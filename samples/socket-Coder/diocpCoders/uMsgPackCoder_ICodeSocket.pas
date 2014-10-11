(*
   unit Owner: d10.ymofen

   first release:
      2014-10-11 12:40:33

   examples:
      TMsgPackCoder.SendObject(TRawTcpClientCoderImpl.Create(FRawTcpClient), lvStream);
      TMsgPackCoder.RecvObject(TRawTcpClientCoderImpl.Create(FRawTcpClient), lvStream);
*)
unit uMsgPackCoder_ICodeSocket;

interface

uses
  uICoderSocket, Classes, SysUtils, uZipTools, qmsgPack, uBufferRW;

type
  {$if CompilerVersion < 18}
    TBytes = array of Byte;
  {$IFEND}

  TMsgPackCoder = class(TObject)
  private
    /// <summary>
    ///   ��ͷBuffer������buffer�л�ԭTQMsgPack
    /// </summary>
    class procedure decodeFromBuffer(pvObject:TQMsgPack; pvHeadBuffer,
        pvBuffer:TBytes);

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
  PACK_FLAG = $0818;  
  MAX_HEAD_LEN = 1024;

  MAX_OBJECT_SIZE = 1024 * 1024 * 10;  //�������С 10M , ����10M �����Ϊ����İ���

const
  BUF_BLOCK_SIZE = 1024 * 8;




resourcestring
  strRecvException_ErrorFlag = '����İ�ͷ����,�Ͽ��������������';
  strRecvException_ErrorData = '���������,�Ͽ��������������';
  strRecvException_VerifyErr = '��������ݰ���У��ʧ��!';
  strSendException_TooBig = '���ݰ�̫��,����ҵ���ֲ���,������ݰ�[%d]!';
  strSendException_NotEqual = '����Buffer����ָ������%d,ʵ�ʷ���:%d';





class procedure TMsgPackCoder.decodeFromBuffer(pvObject: TQMsgPack;
    pvHeadBuffer, pvBuffer: TBytes);
var
  lvBufferReader:IBufferReader;
  lvZiped:Byte;
  lvNameSpaceID:Integer;
  lvBuffers:TBytes;
begin
  lvZiped:= 0;
  if Length(pvHeadBuffer) > 0 then
  begin
    lvBufferReader := TBufferReader.create(@pvHeadBuffer[0], length(pvHeadBuffer));
    lvBufferReader.read(lvZiped, SizeOf(lvZiped));
    lvBufferReader.read(lvNameSpaceID, SizeOf(lvNameSpaceID));
  end;

  //ѹ����
  if lvZiped = 1 then
  begin
    lvBuffers := TBytes(TZipTools.unCompressBuf(pvBuffer[0], Length(pvBuffer)));
    pvObject.Parse(lvBuffers);
  end else
  begin
    //ֱ�ӽ���
    pvObject.Parse(pvBuffer);
  end;
end;

{ TMsgPackCoder }

class function TMsgPackCoder.RecvObject(pvSocket: ICoderSocket;
  pvObject: TObject): Boolean;
var
  lvBytes, lvHeadBytes:SysUtils.TBytes;
  lvReadL:Integer;
  lvPACK_FLAG:Word;
  lvDataLen: Integer;
  lvHeadlen: Integer;
begin
  pvSocket.recvBuf(@lvPACK_FLAG, 2);
  if lvPACK_FLAG <> PACK_FLAG then
  begin
    //����İ�����
    raise Exception.Create('����İ�ͷ����,�Ͽ��������������');
  end;

  //headlen
  pvSocket.recvBuf(@lvReadL, SizeOf(lvReadL));
  lvHeadlen := TByteTools.swap32(lvReadL);

  if lvHeadlen > 0 then
  begin
    //�ļ�ͷ���ܹ���
    if lvHeadlen > MAX_HEAD_LEN  then
    begin
      //����İ�����
      raise Exception.Create('����İ�ͷ����,�Ͽ��������������');
    end;


    //head
    setLength(lvHeadBytes, lvHeadlen);
    pvSocket.recvBuf(@lvHeadBytes[0], lvHeadlen);
  end else if lvHeadlen < 0 then
  begin
    //����İ�����
    raise Exception.Create('����İ�ͷ����,�Ͽ��������������');
  end;

  //buf_len
  pvSocket.recvBuf(@lvReadL, SizeOf(lvReadL));
  lvDataLen := TByteTools.swap32(lvReadL);

  ///������ݹ���
  if (lvDataLen > MAX_OBJECT_SIZE)  then
  begin
    //����İ�����
    raise Exception.Create('���������,�Ͽ��������������');
  end;


  //��ȡ���ݳ���
  if lvDataLen > 0 then
  begin
    setLength(lvBytes, lvDataLen);
    pvSocket.recvBuf(@lvBytes[0], lvDataLen);
  end;

  decodeFromBuffer(TQMsgPack(pvObject), lvHeadBytes, lvBytes);
  Result := true;                            
end;

class function TMsgPackCoder.SendObject(pvSocket: ICoderSocket; pvObject:
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

class function TMsgPackCoder.SendStream(pvSocket: ICoderSocket; pvStream:
    TStream): Integer;
var
  lvBufBytes:array[0..BUF_BLOCK_SIZE-1] of byte;
  l, j, r, lvTotal:Integer;
  P:PByte;
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
      P := PByte(@lvBufBytes[0]);
      j := l;
      while j > 0 do
      begin
        r := pvSocket.sendBuf(P, j);
        if r = -1 then
        begin
          RaiseLastOSError;
        end;
        Inc(P, r);
        Dec(j, r);
      end;
      lvTotal := lvTotal + l;
    end else Break;
  until (l = 0);
  Result := lvTotal;
end;

end.
