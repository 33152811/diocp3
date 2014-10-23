(*
 *	 Unit owner: d10.�����
 *	       blog: http://www.cnblogs.com/dksoft
 *     homePage: www.diocp.org
 *
 *
 *)


unit iocpCoderClientSocket;


interface

uses
  iocpClientSocket, iocpBaseSocket, uIocpCoder, uBuffer, SysUtils, Classes;

type
  TOnDataObjectReceived = procedure(pvObject:TObject) of object;


  TIocpCoderSendRequest = class(TIocpSendRequest)
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


  TIocpCoderRemoteContext = class(TIocpRemoteContext)
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
    procedure OnRecvBuffer(buf: Pointer; len: Cardinal; errCode: WORD); override;

    //procedure OnRecvBuffer(buf: Pointer; len: Cardinal; ErrCode: WORD); virtual;
  public
    constructor Create; override;
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
    property OnDataObjectReceived: TOnDataObjectReceived read FOnDataObjectReceived write FOnDataObjectReceived;
  end;


  TIocpCoderClient = class(TIocpClientSocket)
  public
    constructor Create(AOwner: TComponent); override;
  end;





implementation

uses
  uIOCPFileLogger;


constructor TIocpCoderRemoteContext.Create;
begin
  inherited Create;
  FRecvBufferLink := TBufferLink.Create();
end;

destructor TIocpCoderRemoteContext.Destroy;
begin
  FreeAndNil(FRecvBufferLink);
  if FInnerDecoder <> nil then FInnerDecoder.Free;
  if FInnerEncoder <> nil then FInnerEncoder.Free;
  inherited Destroy;
end;

procedure TIocpCoderRemoteContext.OnRecvBuffer(buf: Pointer; len: Cardinal;
    errCode: WORD);
var
  lvObject:TObject;
begin
  //inherited OnRecvBuffer(buf, len, errCode);
  FRecvBufferLink.AddBuffer(buf, len);

  while True do
  begin
    //����ע��Ľ�����<���н���>
    lvObject := FDecoder.Decode(FRecvBufferLink, Self);
    if Integer(lvObject) = -1 then
    begin
      self.Close;
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

procedure TIocpCoderRemoteContext.registerCoderClass(pvDecoderClass: TIOCPDecoderClass;
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

{ TIocpCoderRemoteContext }

procedure TIocpCoderRemoteContext.registerDecoder(pvDecoder: TIOCPDecoder);
begin
  FDecoder := pvDecoder;
end;

procedure TIocpCoderRemoteContext.registerEncoder(pvEncoder: TIOCPEncoder);
begin
  FEncoder := pvEncoder;
end;


procedure TIocpCoderRemoteContext.writeObject(pvObject: TObject);
var
  lvOutBuffer:TBufferLink;
  lvRequest:TIocpCoderSendRequest;
begin
  if not self.Active then Exit;
  
  lvOutBuffer := TBufferLink.Create;
  try
    FEncoder.Encode(pvObject, lvOutBuffer);
  except
    lvOutBuffer.Free;
    raise;
  end;

  lvRequest := TIocpCoderSendRequest(getSendRequest);
  lvRequest.setBufferLink(lvOutBuffer);
  postSendRequest(lvRequest);
end;

constructor TIocpCoderSendRequest.Create;
begin
  inherited Create;
  FBlockSize := 0;
  FBufferLink := nil;
end;

destructor TIocpCoderSendRequest.Destroy;
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

procedure TIocpCoderSendRequest.DoCleanUp;
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

{ TIocpCoderSendRequest }

function TIocpCoderSendRequest.checkSendNextBlock: Boolean;
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

function TIocpCoderSendRequest.isCompleted: Boolean;
begin
  Result := FBufferLink.validCount = 0;

  if Result  then
  begin  // release Buffer
    FBufferLink.clearBuffer;
  end;
end;

procedure TIocpCoderSendRequest.onSendRequestSucc;
begin
  ;
end;

procedure TIocpCoderSendRequest.setBufferLink(pvBufferLink: TBufferLink);
begin
  FBufferLink := pvBufferLink;
end;

{ TIocpCoderClient }

constructor TIocpCoderClient.Create(AOwner: TComponent);
begin
  inherited;
  registerContextClass(TIocpCoderRemoteContext);
  FIocpSendRequestClass := TIocpCoderSendRequest; 
end;

end.
