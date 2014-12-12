(*
 *	 Unit owner: d10.�����
 *	       blog: http://www.cnblogs.com/dksoft
 *
 *   ������iocpCoderClient�еĵ�Ԫ�滻
 *	 v0.1
 *     + first release
 *   v0.2
 *     + add writeObject()
 *)
 
unit iocpCoderTcpClient;

interface

uses
  iocpTcpClient, uIocpCoder, uBuffer, SysUtils, Classes;

type

  TOnDataObjectReceived = procedure(pvObject:TObject) of object;

  TIocpSendRequest = class(iocpTcpClient.TIocpSendRequest)
  private
    FBufferLink: TBufferLink;

    FBuf:Pointer;
    FBlockSize: Integer;

  protected
    /// <summary>
    ///   is all buf send completed?
    /// </summary>
    function isCompleted: Boolean; override;

    /// <summary>
    ///  on request successful
    /// </summary>
    procedure onSendRequestSucc; override;

    /// <summary>
    ///   post send a block
    /// </summary>
    function checkSendNextBlock: Boolean; override;


    procedure DoCleanUp;override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure setBufferLink(pvBufferLink:TBufferLink);
  end;


  TiocpCoderTcpClient = class(TIocpTcpClient)
  private
    FRecvBufferLink: TBufferLink;

    FInnerEncoder: TIOCPEncoder;
    FInnerDecoder: TIOCPDecoder;

    FEncoder: TIOCPEncoder;
    FDecoder: TIOCPDecoder;
    FOnDataObjectReceived: TOnDataObjectReceived;
  protected
    /// <summary>
    ///   on recved data, run in iocp worker thread
    /// </summary>
    procedure DoRecvd(buf: Pointer; len: Cardinal; errCode: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    /// <summary>
    ///   ע��������ͽ�������
    /// </summary>
    procedure registerCoderClass(pvDecoderClass:TIOCPDecoderClass;
        pvEncoderClass:TIOCPEncoderClass);
    /// <summary>
    ///   ע�������
    /// </summary>
    /// <param name="pvDecoder"> (TIOCPDecoder) </param>
    procedure registerDecoder(pvDecoder:TIOCPDecoder);

    /// <summary>
    ///   ע�������
    /// </summary>
    /// <param name="pvEncoder"> (TIOCPEncoder) </param>
    procedure registerEncoder(pvEncoder:TIOCPEncoder);


    /// <summary>
    ///   ����һ�����󵽷����
    /// </summary>
    procedure writeObject(pvObject:TObject);

  published

    /// <summary>
    ///   ���յ�һ������
    /// </summary>
    property OnDataObjectReceived: TOnDataObjectReceived read FOnDataObjectReceived
        write FOnDataObjectReceived;


  end;




implementation

uses
  uIOCPFileLogger;


constructor TiocpCoderTcpClient.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FRecvBufferLink := TBufferLink.Create();
  FIocpSendRequestClass := TIocpSendRequest;
end;

destructor TiocpCoderTcpClient.Destroy;
begin
  FreeAndNil(FRecvBufferLink);
  if FInnerDecoder <> nil then FInnerDecoder.Free;
  if FInnerEncoder <> nil then FInnerEncoder.Free;
  inherited Destroy;
end;

procedure TiocpCoderTcpClient.DoRecvd(buf: Pointer; len: Cardinal; errCode:
    Integer);
var
  lvObject:TObject;
begin
  //inherited DoRecvd(buf, len, errCode);
  FRecvBufferLink.AddBuffer(buf, len);

  while True do
  begin
    //����ע��Ľ�����<���н���>
    lvObject := FDecoder.Decode(FRecvBufferLink, Self);
    if Integer(lvObject) = -1 then
    begin
      self.Disconnect;
      exit;
    end else if lvObject <> nil then
    begin
      try
        try
          if Assigned(FOnDataObjectReceived) then
            FOnDataObjectReceived(lvObject);
        except
          on E:Exception do
          begin
            TIOCPFileLogger.logErrMessage('�ػ����߼��쳣!' + e.Message);
          end;
        end;
      finally
        lvObject.Free;
      end;
    end else
    begin
      //������û�п���ʹ�õ��������ݰ�,����ѭ��
      Break;
    end;
  end;

  //������<���û�п��õ��ڴ��>����
  if FRecvBufferLink.validCount = 0 then
  begin
    FRecvBufferLink.clearBuffer;
  end else
  begin
    FRecvBufferLink.clearHaveReadBuffer;
  end;
end;

procedure TiocpCoderTcpClient.registerCoderClass(pvDecoderClass: TIOCPDecoderClass;
    pvEncoderClass: TIOCPEncoderClass);
begin
  if FInnerDecoder <> nil then
  begin
    raise Exception.Create('�Ѿ�ע���˽�������');
  end;

  FInnerDecoder := pvDecoderClass.Create;
  registerDecoder(FInnerDecoder);

  if FInnerEncoder <> nil then
  begin
    raise Exception.Create('�Ѿ�ע���˱�������');
  end;
  FInnerEncoder := pvEncoderClass.Create;
  registerEncoder(FInnerEncoder);
end;

{ TiocpCoderTcpClient }

procedure TiocpCoderTcpClient.registerDecoder(pvDecoder: TIOCPDecoder);
begin
  FDecoder := pvDecoder;
end;

procedure TiocpCoderTcpClient.registerEncoder(pvEncoder: TIOCPEncoder);
begin
  FEncoder := pvEncoder;
end;


procedure TiocpCoderTcpClient.writeObject(pvObject: TObject);
var
  lvOutBuffer:TBufferLink;
  lvRequest:TIocpSendRequest;
begin
  if not self.isActive then Exit;
  
  lvOutBuffer := TBufferLink.Create;
  try
    FEncoder.Encode(pvObject, lvOutBuffer);
  except
    lvOutBuffer.Free;
    raise;
  end;

  lvRequest := TIocpSendRequest(getSendRequest);
  lvRequest.setBufferLink(lvOutBuffer);
  postSendRequest(lvRequest);    
end;

constructor TIocpSendRequest.Create;
begin
  inherited Create;
  FBlockSize := 0;
  FBufferLink := nil;
end;

destructor TIocpSendRequest.Destroy;
begin
  if FBlockSize <> 0 then
  begin
    FreeMem(FBuf);
    FBlockSize := 0;
  end;

  if FBufferLink <> nil then
  begin
    FBufferLink.clearBuffer;
    FBufferLink.Free;
    FBufferLink := nil;
  end;
  inherited Destroy;
end;

procedure TIocpSendRequest.DoCleanUp;
begin
  inherited;

  if FBlockSize <> 0 then
  begin
    FreeMem(FBuf);
    FBlockSize := 0;
  end;

  if FBufferLink <> nil then
  begin
    FBufferLink.clearBuffer;
    FBufferLink.Free;
    FBufferLink := nil;
  end;
end;

{ TIocpSendRequest }

function TIocpSendRequest.checkSendNextBlock: Boolean;
var
  l:Cardinal;
begin
  if FBlockSize = 0 then
  begin
    FBlockSize := Owner.WSASendBufferSize;
    GetMem(FBuf, FBlockSize);
  end;

  l := FBufferLink.readBuffer(FBuf, FBlockSize);
  Result := InnerPostRequest(FBuf, l);
end;

function TIocpSendRequest.isCompleted: Boolean;
begin
  Result := FBufferLink.validCount = 0;

  if Result  then
  begin  // release Buffer
    FBufferLink.clearBuffer;
  end;
end;

procedure TIocpSendRequest.onSendRequestSucc;
begin
  ;
end;

procedure TIocpSendRequest.setBufferLink(pvBufferLink: TBufferLink);
begin
  FBufferLink := pvBufferLink;
end;

end.
