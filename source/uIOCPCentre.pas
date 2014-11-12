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

    procedure DoCleanUp;override;
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

  {$IF RTLVersion>22}
  // thanks: �����ٷ�19183455
  //  vcl for win64
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
  {$IFEND}
  TIOCPConsole = class(TIocpTcpServer)
  private
    FInnerEncoder: TIOCPEncoder;
    FInnerDecoder: TIOCPDecoder;

    FEncoder: TIOCPEncoder;
    FDecoder: TIOCPDecoder;
    FLogicWorkerNeedCoInitialize: Boolean;
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

    property LogicWorkerNeedCoInitialize: Boolean read FLogicWorkerNeedCoInitialize write FLogicWorkerNeedCoInitialize;
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

procedure TIOCPCoderClientContext.DoCleanUp;
begin
  inherited;
  // clear cache buffer
  FrecvBuffers.clearBuffer;
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
  Result := TIocpConsole(Owner).FDecoder.Decode(FrecvBuffers, Self);
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
//  if TIOCPConsole(Owner).FLogicWorkerNeedCoInitialize then
//    pvJob.
    
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
  try
    if TIOCPConsole(Owner).FLogicWorkerNeedCoInitialize then
      pvTaskRequest.iocpWorker.checkCoInitializeEx();

    lvObj := TObject(pvTaskRequest.TaskData);
    try
      dataReceived(lvObj);
    finally
      lvObj.Free;
    end;
  except
   on E:Exception do
    begin
      TIOCPFileLogger.logErrMessage('�ػ����߼��쳣!' + e.Message);
    end;
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
  lvBuf:Pointer;
  len:Cardinal;
begin
  if not Active then Exit;
  if self.LockContext('writeObject', Self) then
  try
    lvOutBuffer := TBufferLink.Create;
    try
      TIocpConsole(Owner).FEncoder.Encode(pvDataObject, lvOutBuffer);
      len := lvOutBuffer.validCount;
      GetMem(lvBuf, len);
      lvOutBuffer.readBuffer(lvBuf, len);
                      
      if PostWSASendRequest(lvBuf, len, dtFreeMem) then
      begin
        Self.StateINfo := 'TIOCPCoderClientContext.writeObject,Post Succ';
      end else
      begin
        // post fail
        FreeMem(lvBuf);
        {$IFDEF DEBUG_ON}
        if FOwner.logCanWrite then
          FOwner.FSafeLogger.logMessage('Push sendRequest to Sending Queue fail, current Queue size:%d',
           [GetSendQueueSize]);
        {$ENDIF}
      end;
    finally
      lvOutBuffer.Free;
    end; 
  finally
    self.unLockContext('writeObject', Self);
  end;    
end;

constructor TIOCPConsole.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FClientContextClass := TIOCPCoderClientContext;
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



end.
