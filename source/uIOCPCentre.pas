unit uIOCPCentre;

interface

// call dataReceived procedure with qworker
{.$DEFINE QDAC_QWorker}

uses
  iocpTcpServer, uBuffer, SysUtils, Classes,
  uIocpCoder
  {$IFDEF QDAC_QWorker}
    , qworker
  {$ELSE}
    , iocpTask
  {$ENDIF}
  ;

type
  TIocpCoderSendRequest = class(iocpTcpServer.TIocpSendRequest)
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


  TIOCPCoderClientContext = class(iocpTcpServer.TIOCPClientContext)
  private
    FrecvBuffers: TBufferLink;
    FStateINfo: String;
    function GetStateINfo: String;
   {$IFDEF QDAC_QWorker}
    procedure OnExecuteJob(pvJob:PQJob);
   {$ELSE}
    procedure OnExecuteJob(pvTaskRequest: TIocpTaskRequest);
   {$ENDIF}
  protected
    procedure add2Buffer(buf:PAnsiChar; len:Cardinal);
    procedure clearRecvedBuffer;
    function decodeObject: TObject;
    procedure OnRecvBuffer(buf: Pointer; len: Cardinal; ErrCode: WORD); override;
    procedure recvBuffer(buf:PAnsiChar; len:Cardinal); virtual;
  protected
  public
    constructor Create;override;
    destructor Destroy; override;

    /// <summary>
    ///   on received a object
    /// </summary>
    /// <param name="pvDataObject"> (TObject) </param>
    procedure dataReceived(const pvDataObject:TObject); virtual;

    /// <summary>
    ///   send a object to peer socket
    /// </summary>
    /// <param name="pvDataObject"> (TObject) </param>
    procedure writeObject(const pvDataObject:TObject);

    /// <summary>
    ///   received buffer
    /// </summary>
    property Buffers: TBufferLink read FrecvBuffers;

    /// <summary>
    ///
    /// </summary>
    property StateINfo: String read GetStateINfo write FStateINfo;
  end;



  TOnDataObjectReceived = procedure(pvClientContext:TIOCPCoderClientContext;pvObject:TObject) of object;


  TIOCPConsole = class(TIocpTcpServer)
  private
    FInnerEncoder: TIOCPEncoder;
    FInnerDecoder: TIOCPDecoder;

    FEncoder: TIOCPEncoder;
    FDecoder: TIOCPDecoder;
    FOnDataObjectReceived: TOnDataObjectReceived;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    /// <summary>
    ///   ע��������ͽ�������
    /// </summary>
    procedure registerCoderClass(pvDecoderClass:TIOCPDecoderClass;
        pvEncoderClass:TIOCPEncoderClass);

    /// <summary>
    ///   register Decoder instance
    /// </summary>
    /// <param name="pvDecoder"> (TIOCPDecoder) </param>
    procedure registerDecoder(pvDecoder:TIOCPDecoder);

    /// <summary>
    ///   register Encoder instance
    /// </summary>
    /// <param name="pvEncoder"> (TIOCPEncoder) </param>
    procedure registerEncoder(pvEncoder:TIOCPEncoder);

  published

    /// <summary>
    ///   on clientContext received a object
    /// </summary>
    property OnDataObjectReceived: TOnDataObjectReceived read FOnDataObjectReceived
        write FOnDataObjectReceived;


  end;



implementation

uses
  uIOCPFileLogger;

constructor TIOCPCoderClientContext.Create;
begin
  inherited Create;
  FrecvBuffers := TBufferLink.Create();
end;

destructor TIOCPCoderClientContext.Destroy;
begin
  FrecvBuffers.Free;
  inherited Destroy;
end;

procedure TIOCPCoderClientContext.add2Buffer(buf: PAnsiChar; len: Cardinal);
begin
  //add to context receivedBuffer
  FrecvBuffers.AddBuffer(buf, len);
end;

procedure TIOCPCoderClientContext.clearRecvedBuffer;
begin
  if FrecvBuffers.validCount = 0 then
  begin
    FrecvBuffers.clearBuffer;
  end else
  begin
    FrecvBuffers.clearHaveReadBuffer;
  end;
end;

procedure TIOCPCoderClientContext.dataReceived(const pvDataObject:TObject);
begin

end;

function TIOCPCoderClientContext.decodeObject: TObject;
begin
  Result := TIocpConsole(Owner).FDecoder.Decode(FrecvBuffers);
end;

function TIOCPCoderClientContext.GetStateINfo: String;
begin
  Result := FStateINfo;
end;



procedure TIOCPCoderClientContext.OnRecvBuffer(buf: Pointer; len: Cardinal;
  ErrCode: WORD);
begin
  recvBuffer(buf, len);
end;

{$IFDEF QDAC_QWorker}
procedure TIOCPCoderClientContext.OnExecuteJob(pvJob: PQJob);
var
  lvObj:TObject;
begin
  lvObj := TObject(pvJob.Data);
  try
    dataReceived(lvObj);
  finally
    lvObj.Free;
  end;
end;
{$ELSE}

procedure TIOCPCoderClientContext.OnExecuteJob(pvTaskRequest: TIocpTaskRequest);
var
  lvObj:TObject;
begin
  lvObj := TObject(pvTaskRequest.TaskData);
  try
    dataReceived(lvObj);
  finally
    lvObj.Free;
  end;
end;
{$ENDIF}

procedure TIOCPCoderClientContext.recvBuffer(buf:PAnsiChar; len:Cardinal);
var
  lvObject:TObject;
begin
  add2Buffer(buf, len);

  self.StateINfo := '���յ�����,׼�����н���';

  ////����һ���յ������ʱ����ֻ������һ���߼��Ĵ���(dataReceived);
  ///  2013��9��26�� 08:57:20
  ///    ��лȺ��JOE�ҵ�bug��
  while True do
  begin
    //����ע��Ľ�����<���н���>
    lvObject := decodeObject;
    if Integer(lvObject) = -1 then
    begin
      /// ����İ���ʽ, �ر�����
      DoDisconnect;
      exit;
    end else if lvObject <> nil then
    begin
      try
        self.StateINfo := '����ɹ�,׼������dataReceived�����߼�����';


        if Assigned(TIOCPConsole(Owner).FOnDataObjectReceived) then
          TIOCPConsole(Owner).FOnDataObjectReceived(Self, lvObject);


       {$IFDEF QDAC_QWorker}
         Workers.Post(OnExecuteJob, lvObject);
       {$ELSE}
         iocpTaskManager.PostATask(OnExecuteJob, lvObject);
       {$ENDIF}
      except
        on E:Exception do
        begin
          TIOCPFileLogger.logErrMessage('�ػ����߼��쳣!' + e.Message);
        end;
      end;
    end else
    begin
      //������û�п���ʹ�õ��������ݰ�,����ѭ��
      Break;
    end;
  end;

  //������<���û�п��õ��ڴ��>����
  clearRecvedBuffer;
end;



procedure TIOCPCoderClientContext.writeObject(const pvDataObject:TObject);
var
  lvOutBuffer:TBufferLink;
  lvRequest:TIocpCoderSendRequest;
begin
  if not Active then Exit;
  
  lvOutBuffer := TBufferLink.Create;
  try
    TIocpConsole(Owner).FEncoder.Encode(pvDataObject, lvOutBuffer);
  except
    lvOutBuffer.Free;
    raise;
  end;

  lvRequest := TIocpCoderSendRequest(getSendRequest);
  lvRequest.setBufferLink(lvOutBuffer);


  postSendRequest(lvRequest);

  self.StateINfo := 'TIOCPCoderClientContext.writeObject,Ͷ�ݵ����ͻ���';

end;

constructor TIOCPConsole.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FClientContextClass := TIOCPCoderClientContext;
  FIocpSendRequestClass := TIocpCoderSendRequest;
end;

destructor TIOCPConsole.Destroy;
begin
  if FInnerDecoder <> nil then FInnerDecoder.Free;
  if FInnerEncoder <> nil then FInnerEncoder.Free;
  inherited Destroy;
end;

procedure TIOCPConsole.registerCoderClass(pvDecoderClass: TIOCPDecoderClass;
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

{ TIOCPConsole }

procedure TIOCPConsole.registerDecoder(pvDecoder: TIOCPDecoder);
begin
  FDecoder := pvDecoder;
end;

procedure TIOCPConsole.registerEncoder(pvEncoder: TIOCPEncoder);
begin
  FEncoder := pvEncoder;
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

end.
