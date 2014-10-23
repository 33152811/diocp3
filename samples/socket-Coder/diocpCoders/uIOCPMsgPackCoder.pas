unit uIOCPMsgPackCoder;

interface

uses
  uIocpCoder, uBuffer, qmsgpack, Classes, 
  uZipTools, SysUtils, uMsgPackObject, uByteTools;

const
  MAX_OBJECT_SIZE = 1024 * 1024 * 10;  //�������С 10M , ����10M �����Ϊ����İ���

type
  TIOCPMsgPackEncoder = class(TIOCPEncoder)
  public
    /// <summary>
    ///   ����Ҫ�����Ķ���
    /// </summary>
    /// <param name="pvDataObject"> Ҫ���б���Ķ��� </param>
    /// <param name="ouBuf"> ����õ����� </param>
    procedure Encode(pvDataObject:TObject; const ouBuf: TBufferLink); override;
  end;


  TIOCPMsgPackDecoder = class(TIOCPDecoder)
  private

  public
    /// <summary>
    ///   �����յ�������,����н��յ�����,���ø÷���,���н���
    /// </summary>
    /// <returns>
    ///   ���ؽ���õĶ���
    /// </returns>
    /// <param name="inBuf"> ���յ��������� </param>
    function Decode(const inBuf: TBufferLink; pvContext: TObject): TObject;
        override;
  end;

implementation

const
  PACK_FLAG = $0818;

  MAX_HEAD_LEN = 1024;

  //PACK_FLAG  + HEAD_LEN + HEAD_DATA + Buffer_LEN + Buffer_DATA

  //HEAD  zip(byte(0,1)), cmd.namespaceid(integer)
  //����> 100K����ѹ��




procedure TIOCPMsgPackEncoder.Encode(pvDataObject:TObject; const ouBuf:
    TBufferLink);
var
  lvMsgPack:TQMsgPack;
  lvBytes :SysUtils.TBytes;
  lvDataLen, lvWriteL: Integer;
  lvHeadlen, lvNameSpaceID: Integer;
  lvZiped:Byte;
  lvPACK_FLAG:Word;
begin
  if pvDataObject = nil then exit;
  lvMsgPack := TQMsgPack(pvDataObject);
  lvBytes := lvMsgPack.Encode;
  lvDataLen :=Length(lvBytes);

  if lvDataLen > 1024 * 100 then  // >100K ����ѹ��
  begin
    lvBytes := SysUtils.TBytes(TZipTools.compressBuf(lvBytes[0], lvDataLen));
    lvDataLen := Length(lvBytes);
    lvZiped := 1;
  end else
  begin
    lvZiped := 0;   //δ����ѹ��
  end;

  if lvDataLen > MAX_OBJECT_SIZE then
    raise Exception.CreateFmt('���ݰ�̫��,����ҵ���ֲ���,������ݰ�[%d]!', [MAX_OBJECT_SIZE]);


  if lvMsgPack.ItemByPath('cmd.namespaceid') <> nil then
  begin
    lvNameSpaceID := lvMsgPack.ForcePath('cmd.namespaceid').AsInteger;
  end else
  begin
    lvNameSpaceID := 0;
  end;

  lvPACK_FLAG := PACK_FLAG;
  //pack_flag
  ouBuf.AddBuffer(@lvPACK_FLAG, 2);
  //Head_len: zip + namespaceid
  lvHeadlen := SizeOf(lvZiped) + SizeOf(lvNameSpaceID);

  lvWriteL := TByteTools.swap32(lvHeadlen);
  //head_len
  ouBuf.AddBuffer(@lvWriteL, SizeOf(lvWriteL));

  //zip
  ouBuf.AddBuffer(@lvZiped, SizeOf(lvZiped));
  //namesapceid
  ouBuf.AddBuffer(@lvNameSpaceID, SizeOf(lvNameSpaceID));

  //data_len
  lvWriteL := TByteTools.swap32(lvDataLen);
  ouBuf.AddBuffer(@lvWriteL, SizeOf(lvWriteL));
  //data
  ouBuf.AddBuffer(@lvBytes[0], lvDataLen);
end;

{ TIOCPMsgPackDecoder }

function TIOCPMsgPackDecoder.Decode(const inBuf: TBufferLink; pvContext:
    TObject): TObject;
var
  lvBytes, lvHeadBytes:SysUtils.TBytes;
  lvValidCount, lvReadL:Integer;
  lvPACK_FLAG:Word;
  lvDataLen: Integer;
  lvHeadlen, lvNameSpaceID: Integer;
  lvZiped:Byte;
  lvMsgPackObject:TMsgPackObject;
begin
  Result := nil;

  //��������е����ݳ��Ȳ�����ͷ���ȣ�
  lvValidCount := inBuf.validCount;   //pack_flag + head_len + buf_len
  if (lvValidCount < SizeOf(Word) + SizeOf(Integer) + SizeOf(Integer)) then
  begin
    Exit;
  end;

  //��¼��ȡλ��
  inBuf.markReaderIndex;
  //setLength(lvBytes, 2);
  inBuf.readBuffer(@lvPACK_FLAG, 2);

  if lvPACK_FLAG <> PACK_FLAG then
  begin
    //����İ�����
    Result := TObject(-1);
    exit;
  end;

  //headlen
  inBuf.readBuffer(@lvReadL, SizeOf(lvReadL));
  lvHeadlen := TByteTools.swap32(lvReadL);

  if lvHeadlen > 0 then
  begin
    //�ļ�ͷ���ܹ���
    if lvHeadlen > MAX_HEAD_LEN  then
    begin
      Result := TObject(-1);
      exit;
    end;

    if inBuf.validCount < lvHeadlen then
    begin
      //����buf�Ķ�ȡλ��
      inBuf.restoreReaderIndex;
      exit;
    end;
    
    //head
    setLength(lvHeadBytes, lvHeadlen);
    inBuf.readBuffer(@lvHeadBytes[0], lvHeadlen);
  end else if lvHeadlen < 0 then
  begin
    //����İ�����
    Result := TObject(-1);
    exit;
  end;

  //buf_len
  inBuf.readBuffer(@lvReadL, SizeOf(lvReadL));
  lvDataLen := TByteTools.swap32(lvReadL);

  ///������ݹ���
  if (lvDataLen > MAX_OBJECT_SIZE)  then
  begin
    //����İ�����
    Result := TObject(-1);
    exit;
  end;
  

  //��������е����ݲ���json�ĳ��Ⱥ�������<˵�����ݻ�û����ȡ���>����ʧ��
  lvValidCount := inBuf.validCount;
  if lvValidCount < (lvDataLen) then
  begin
    //����buf�Ķ�ȡλ��
    inBuf.restoreReaderIndex;
    exit;
  end;

  lvMsgPackObject := TMsgPackObject.create;
  result := lvMsgPackObject;
  lvMsgPackObject.setHeadBytes(lvHeadBytes);

  //��ȡ���ݳ���
  if lvDataLen > 0 then
  begin
    setLength(lvBytes, lvDataLen);
    inBuf.readBuffer(@lvBytes[0], lvDataLen);
    lvMsgPackObject.setBufferBytes(lvBytes);
  end;
end;

end.
