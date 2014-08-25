unit uStreamCoderSocket;

interface

uses
  uICoderSocket, Classes, SysUtils, uZipTools;

type
  {$if CompilerVersion < 18}
    TBytes = array of Byte;
  {$IFEND}

  TStreamCoderSocket = class(TObject)
  private
    class function SendStream(pvSocket: ICoderSocket; pvStream: TStream): Integer;
  public
    /// <summary>
    ///   ���ս���
    /// </summary>
    /// <returns> Boolean
    /// </returns>
    /// <param name="pvSocket"> (TClientSocket) </param>
    /// <param name="pvObject"> (TObject) </param>
    class function RecvObject(pvSocket: ICoderSocket; pvObject: TObject): Boolean;

    /// <summary>
    ///   ���뷢��
    /// </summary>
    /// <param name="pvSocket"> (TClientSocket) </param>
    /// <param name="pvDataObject"> (TObject) </param>
    class function SendObject(pvSocket: ICoderSocket; pvObject: TObject): Integer;
  end;


implementation

  //PACK_FLAG  + CRC_VALUE + STREAM_LEN + STREAM_DATA

uses
  uByteTools;

const
  PACK_FLAG = $D10;
  MAX_OBJECT_SIZE = 1024 * 1024 * 10;  //�������С 10M , ����10M �����Ϊ����İ���

const
  BUF_BLOCK_SIZE = 1024 * 8;



resourcestring
  strRecvException_ErrorFlag = '����İ�ͷ����,�Ͽ��������������';
  strRecvException_ErrorData = '���������,�Ͽ��������������';
  strRecvException_VerifyErr = '��������ݰ���У��ʧ��!';
  strSendException_TooBig = '���ݰ�̫��,����ҵ���ֲ���,������ݰ�[%d]!';
  strSendException_NotEqual = '����Buffer����ָ������%d,ʵ�ʷ���:%d';





{ TStreamCoderSocket }

class function TStreamCoderSocket.RecvObject(pvSocket: ICoderSocket;
  pvObject: TObject): Boolean;
var
  lvBytes:TBytes;
  lvReadL, lvTempL:Integer;
  lvPACK_FLAG:Word;
  lvDataLen: Integer;
  lvVerifyValue, lvVerifyDataValue:Cardinal;
  lvPByte:PByte;
begin
  pvSocket.recvBuf(@lvPACK_FLAG, 2);

  if lvPACK_FLAG <> PACK_FLAG then
  begin
    pvSocket.closeSocket;
    //����İ�����
    raise Exception.Create(strRecvException_ErrorFlag);
  end;

  //veri value
  pvSocket.recvBuf(@lvVerifyValue, SizeOf(lvVerifyValue));

  //headlen
  pvSocket.recvBuf(@lvReadL, SizeOf(lvReadL));
  lvDataLen := TByteTools.swap32(lvReadL);

  //�ļ�ͷ���ܹ���
  if lvDataLen > MAX_OBJECT_SIZE  then
  begin
    //����İ�����
    pvSocket.closeSocket;
    //����İ�����
    raise Exception.Create(strRecvException_ErrorData);
  end;

  SetLength(lvBytes,lvDataLen);
  lvPByte := PByte(@lvBytes[0]);
  lvReadL := 0;
  while lvReadL < lvDataLen do
  begin
    lvTempL := pvSocket.recvBuf(lvPByte, lvDataLen - lvReadL);
    Inc(lvPByte, lvTempL);
    lvReadL := lvReadL + lvTempL;
  end;


  lvVerifyDataValue := TZipTools.verifyData(lvBytes[0], lvDataLen);
  if lvVerifyDataValue <> lvVerifyValue then
  begin
    raise Exception.Create(strRecvException_VerifyErr);
  end;


  TStream(pvObject).Write(lvBytes[0], lvDataLen);
  Result := true;                                
end;

class function TStreamCoderSocket.SendObject(pvSocket: ICoderSocket; pvObject:
    TObject): Integer;
var
  lvPACK_FLAG: WORD;
  lvDataLen, lvWriteIntValue: Integer;
  lvBuf: TBytes;
  lvStream:TMemoryStream;
  lvVerifyValue:Cardinal;
begin
  lvPACK_FLAG := PACK_FLAG;

  lvStream := TMemoryStream.Create;
  try
    TStream(pvObject).Position := 0;

    if TStream(pvObject).Size > MAX_OBJECT_SIZE then
    begin
       raise Exception.CreateFmt(strSendException_TooBig, [MAX_OBJECT_SIZE]);
    end;

    //pack_flag
    lvStream.Write(lvPACK_FLAG, 2);

    //
    lvDataLen := TStream(pvObject).Size;

    // stream data
    SetLength(lvBuf, lvDataLen);
    TStream(pvObject).Read(lvBuf[0], lvDataLen);
    //veri value
    lvVerifyValue := TZipTools.verifyData(lvBuf[0], lvDataLen);
    lvStream.Write(lvVerifyValue, SizeOf(lvVerifyValue));


    lvWriteIntValue := TByteTools.swap32(lvDataLen);

    // stream len
    lvStream.Write(lvWriteIntValue, SizeOf(lvWriteIntValue));

    // send pack
    lvStream.write(lvBuf[0], lvDataLen);

    Result := SendStream(pvSocket, lvStream);
  finally
    lvStream.Free;
  end;
end;

class function TStreamCoderSocket.SendStream(pvSocket: ICoderSocket; pvStream:
    TStream): Integer;
var
  lvBufBytes:array[0..BUF_BLOCK_SIZE-1] of byte;
  l, j, lvTotal:Integer;
begin
  Result := 0;
  if pvStream = nil then Exit;
  if pvStream.Size = 0 then Exit;
  lvTotal :=0;
  
  pvStream.Position := 0;
  repeat
    //FillMemory(@lvBufBytes[0], SizeOf(lvBufBytes), 0);
    l := pvStream.Read(lvBufBytes[0], SizeOf(lvBufBytes));
    if (l > 0) then
    begin
      j:=pvSocket.sendBuf(@lvBufBytes[0], l);
      if j <> l then
      begin
        raise Exception.CreateFmt(strSendException_NotEqual, [j, l]);
      end else
      begin
        lvTotal := lvTotal + j;
      end;
    end else Break;
  until (l = 0);
  Result := lvTotal;
end;

end.
