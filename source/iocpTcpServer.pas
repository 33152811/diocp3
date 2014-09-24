(*
 *	 Unit owner: D10.Mofen
 *	       blog: http://www.cnblogs.com/dksoft
 *
 *	 v3.0.1(2014-7-16 21:36:30)
 *     + first release
 *
 *   thanks qsl's suggestion
 *)
 
unit iocpTcpServer;

interface

{$DEFINE LOGGER_ON}
{$DEFINE DEBUG_MSG_ON}

{$DEFINE CHANGE_STATE_USE_LOCKER}

uses
  Classes, iocpSocketUtils, iocpEngine, iocpProtocol,
  winsock, iocpWinsock2,

  iocpRawSocket, SyncObjs, Windows, SysUtils,
  {$IFDEF LOGGER_ON}
    safeLogger,
  {$ENDIF}

  BaseQueue, iocpLocker;


type
  TIocpTcpServer = class;
  TIocpAcceptorMgr = class;
  TIocpClientContext = class;
  TIocpRecvRequest = class;
  TIocpSendRequest = class;

  TIocpClientContextClass = class of TIocpClientContext;

  TOnClientContextError = procedure(pvClientContext: TIocpClientContext; errCode:
      Integer) of object;

  TOnDataReceived = procedure(pvClientContext:TIocpClientContext;
      buf:Pointer; len:cardinal; errCode:Integer) of object;

  
  TClientContextNotifyEvent = procedure(pvClientContext: TIocpClientContext) of
      object;

  /// <summary>
  ///   on post request is completed
  /// </summary>
  TOnDataRequestCompleted = procedure(pvClientContext:TIocpClientContext;
      pvRequest:TIocpRequest) of object;

  /// <summary>
  ///   client object
  /// </summary>
  TIocpClientContext = class(TObject)
  private
    FDebugStrings:TStrings;
    
    FSocketState: TSocketState;

    /// <summary>
    ///   ReferenceCounter counter
    /// </summary>
    FReferenceCounter:Integer;

    /// <summary>
    ///    request discnnect flag, ReferenceCounter is zero then do disconnect
    /// </summary>
    FRequestDisconnect:Boolean;

    FContextLocker: TIocpLocker;

    FDebugINfo: string;
    procedure SetDebugINfo(const Value: string);

    function incReferenceCounter(pvDebugInfo: string; pvObj: TObject): Boolean;

    /// <summary>
    ///    dec RequestCounter then check counter and Request flag for Disonnect
    /// </summary>
    function decReferenceCounter(pvDebugInfo: string; pvObj: TObject): Integer;

    /// <summary>
    ///   dec RequestCounter and requestDisconnect then check counter flag for Disonnect
    /// </summary>
    procedure decReferenceCounterAndRequestDisconnect(pvDebugInfo: string; pvObj:
        TObject);

    procedure lock();
    procedure unLock();
  private
    FAlive:Boolean;
  {$IFDEF CHANGE_STATE_USE_LOCKER}
  {$ELSE}
    FLockActive:Boolean;
  {$ENDIF}



    // link
    FPre:TIocpClientContext;
    FNext:TIocpClientContext;

    /// <summary>
    ///  sending flag
    /// </summary>
    FSending: Boolean;

    FActive: Boolean;

    FOwner: TIocpTcpServer;



    FcurrSendRequest:TIocpSendRequest;
    FData: Pointer;

    /// sendRequest link
    FSendRequestLink: TIocpRequestSingleLink;

    FRawSocket: TRawSocket;

    FRemoteAddr: String;
    FRemotePort: Integer;

    /// <summary>
    ///   called by recvRequest response
    /// </summary>
    procedure DoReceiveData;

    /// <summary>
    ///   called by sendRequest response
    /// </summary>
    procedure DoSendRequestCompleted(pvRequest: TIocpSendRequest);

    /// <summary>
    ///   post next sendRequest
    /// </summary>
    procedure checkNextSendRequest();

    /// <example>
    ///  sendRequest to pool
    /// </example>
    procedure checkReleaseRes;


    procedure SetOwner(const Value: TIocpTcpServer);

  protected
    /// <summary>
    ///   recvRequest
    /// </summary>
    FRecvRequest:TIocpRecvRequest;

    /// <summary>
    ///   request recv data
    /// </summary>
    procedure PostWSARecvRequest();virtual;

    /// <summary>
    ///   post reqeust to sending queue,
    ///    fail, push back to pool
    /// </summary>
    function postSendRequest(pvSendRequest:TIocpSendRequest):Boolean;


    /// <summary>
    ///
    /// </summary>
    function getSendRequest():TIocpSendRequest;

    procedure InnerCloseContext;
  protected
    /// <summary>
    ///   lock context avoid disconnect,
    ///     lock succ return false else return false( context request disconnect)
    /// </summary>
    function LockContext(pvDebugInfo: string; pvObj: TObject): Boolean;

    procedure unLockContext(pvDebugInfo: string; pvObj: TObject);

    procedure DoConnected;

    procedure DoCleanUp;virtual;

    procedure OnRecvBuffer(buf: Pointer; len: Cardinal; ErrCode: WORD); virtual;

    procedure OnDisconnected; virtual;

    procedure OnConnected;virtual;

    procedure SetSocketState(pvState:TSocketState); virtual;
  public
    procedure postNextSendRequest;


    constructor Create; virtual;
    destructor Destroy; override;

    procedure DoDisconnect;

    procedure RequestDisconnect;

    /// <summary>
    ///  post send request to iocp queue, if post successful return true.
    ///    if request is completed, will call DoSendRequestCompleted procedure
    /// </summary>
    function PostWSASendRequest(buf: Pointer; len: Cardinal; pvCopyBuf: Boolean =
        true): Boolean;

    property Active: Boolean read FActive;

    property Data: Pointer read FData write FData;

    property DebugINfo: string read FDebugINfo write SetDebugINfo;

    property Owner: TIocpTcpServer read FOwner write SetOwner;

    property RawSocket: TRawSocket read FRawSocket;

    property RemoteAddr: String read FRemoteAddr;

    property RemotePort: Integer read FRemotePort;
    property SocketState: TSocketState read FSocketState;

  end;

  /// <summary>
  ///   WSARecv io request
  /// </summary>
  TIocpRecvRequest = class(TIocpRequest)
  private
    FDebugInfo:String;
    FInnerBuffer: iocpWinsock2.TWsaBuf;
    FRecvBuffer: iocpWinsock2.TWsaBuf;
    FRecvdFlag: Cardinal;
    FOwner: TIocpTcpServer;
    FClientContext:TIocpClientContext;
  protected
    /// <summary>
    ///   iocp reply request, run in iocp thread
    /// </summary>
    procedure HandleResponse; override;
  public
    /// <summary>
    ///   post recv request to iocp queue
    /// </summary>
    function PostRequest: Boolean; overload;

    /// <summary>
    ///
    /// </summary>
    function PostRequest(pvBuffer:PAnsiChar; len:Cardinal): Boolean; overload;

  public
    constructor Create;
    destructor Destroy; override;
  end;


  TIocpSendRequestClass = class of TIocpSendRequest;
  /// <summary>
  ///   WSASend io request
  /// </summary>
  TIocpSendRequest = class(TIocpRequest)
  private
    // for singlelinked
    FNext:TIocpSendRequest;

    FIsBusying:Boolean;

    FAlive: Boolean;

    FBytesSize:Cardinal;

    FCopyBuf:TWsaBuf;

    // send buf record
    FWSABuf:TWsaBuf;


    FBuf:Pointer;
    FPosition:Cardinal;
    FLen:Cardinal;

    FOwner: TIocpTcpServer;

    FClientContext:TIocpClientContext;


    FOnDataRequestCompleted: TOnDataRequestCompleted;
    /// <summary>
    ///   checkStart to post
    /// </summary>
    function checkStart: Boolean;
  protected
    /// <summary>
    ///   is all buf send completed?
    /// </summary>
    function isCompleted:Boolean;virtual;

    /// <summary>
    ///  on request successful
    /// </summary>
    procedure onSendRequestSucc; virtual;

    /// <summary>
    ///   post send a block
    /// </summary>
    function checkSendNextBlock: Boolean; virtual;
  protected
    /// <summary>
    ///   iocp reply request, run in iocp thread
    /// </summary>
    procedure HandleResponse; override;


    procedure DoCleanUp;virtual;

    /// <summary>
    ///   post send buffer to iocp queue
    /// </summary>
    function InnerPostRequest(buf: Pointer; len: Cardinal): Boolean;


  public
    constructor Create; virtual;

    destructor Destroy; override;

    /// <summary>
    ///   set buf inneed to send
    /// </summary>
    procedure setBuffer(buf: Pointer; len: Cardinal; pvCopyBuf: Boolean = true);

    property ClientContext: TIocpClientContext read FClientContext;

    property Owner: TIocpTcpServer read FOwner;

    /// <summary>
    ///   on entire buf send completed
    /// </summary>
    property OnDataRequestCompleted: TOnDataRequestCompleted read
        FOnDataRequestCompleted write FOnDataRequestCompleted;
  end;


  /// <summary>
  ///   acceptEx request
  /// </summary>
  TIocpAcceptExRequest = class(TIocpRequest)
  private
    /// <summary>
    ///   acceptEx lpOutBuffer[in]
    ///     A pointer to a buffer that receives the first block of data sent on a new connection,
    ///       the local address of the server, and the remote address of the client.
    ///       The receive data is written to the first part of the buffer starting at offset zero,
    ///       while the addresses are written to the latter part of the buffer.
    ///       This parameter must be specified.
    /// </summary>
    FAcceptBuffer: array [0.. (SizeOf(TSockAddrIn) + 16) * 2 - 1] of byte;

    FOwner: TIocpTcpServer;
    FAcceptorMgr:TIocpAcceptorMgr;

    FClientContext:TIocpClientContext;
    /// <summary>
    ///   get socket peer info on acceptEx reponse
    /// </summary>
    procedure getPeerINfo;
  protected
    function PostRequest: Boolean;

  protected
    procedure HandleResponse; override;
    
  public
    constructor Create(AOwner: TIocpTcpServer);
  end;

  /// <summary>
  ///   manager acceptEx request
  /// </summary>
  TIocpAcceptorMgr = class(TObject)
  private
    FOwner: TIocpTcpServer;
    FList:TList;
    FListenSocket: TRawSocket;
    FLocker: TIocpLocker;
    FMaxRequest:Integer;
    FMinRequest:Integer;

  protected
  public
    constructor Create(AOwner: TIocpTcpServer; AListenSocket: TRawSocket);

    destructor Destroy; override;

    procedure releaseRequestObject(pvRequest:TIocpAcceptExRequest);

    procedure removeRequestObject(pvRequest:TIocpAcceptExRequest);

    procedure checkPostRequest;

    property ListenSocket: TRawSocket read FListenSocket;


  end;

  /// <summary>
  ///   iocp data monitor
  /// </summary>
  TIocpDataMonitor = class(TObject)
  private
    FSentSize:Int64;
    FRecvSize:Int64;
    FPostWSASendSize: Int64;

    FPushSendQueueCounter: Integer;
    FResponseSendObjectCounter:Integer;

    FPostWSASendCounter:Integer;
    FResponseWSASendCounter:Integer;

    FPostWSARecvCounter:Integer;
    FResponseWSARecvCounter:Integer;

    FPostWSAAcceptExCounter:Integer;
    FResponseWSAAcceptExCounter:Integer;

    FLocker: TCriticalSection;
    FPostSendObjectCounter: Integer;

    procedure incSentSize(pvSize:Cardinal);
    procedure incPostWSASendSize(pvSize:Cardinal);
    procedure incRecvdSize(pvSize:Cardinal);

    procedure incPostWSASendCounter();
    procedure incResponseWSASendCounter;

    procedure incPostWSARecvCounter();
    procedure incResponseWSARecvCounter;

    procedure incPushSendQueueCounter;
    procedure incPostSendObjectCounter();
    procedure incResponseSendObjectCounter();
  public
    constructor Create;
    destructor Destroy; override;

    procedure clear;

    property PushSendQueueCounter: Integer read FPushSendQueueCounter;
    property PostSendObjectCounter: Integer read FPostSendObjectCounter;
    property ResponseSendObjectCounter: Integer read FResponseSendObjectCounter;

    property PostWSAAcceptExCounter: Integer read FPostWSAAcceptExCounter;
    property PostWSARecvCounter: Integer read FPostWSARecvCounter;
    property PostWSASendCounter: Integer read FPostWSASendCounter;


    property PostWSASendSize: Int64 read FPostWSASendSize;
    property RecvSize: Int64 read FRecvSize;

    property ResponseWSAAcceptExCounter: Integer read FResponseWSAAcceptExCounter;
    property ResponseWSARecvCounter: Integer read FResponseWSARecvCounter;
    property ResponseWSASendCounter: Integer read FResponseWSASendCounter;
    property SentSize: Int64 read FSentSize;
  end;

  TContextDoublyLinked = class(TObject)
  private
    FLocker: TIocpLocker;
    FHead:TIocpClientContext;
    FTail:TIocpClientContext;
    FCount:Integer;
  public
    constructor Create;
    destructor Destroy; override;

    procedure add(pvContext:TIocpClientContext);
    function remove(pvContext:TIocpClientContext): Boolean;

    function Pop:TIocpClientContext;

    procedure write2List(pvList:TList);

    property Count: Integer read FCount;

  end;


  TIocpTcpServer = class(TComponent)
  private
  {$IFDEF LOGGER_ON}
    FSafeLogger:TSafeLogger;
  {$ENDIF}

    FMaxSendingQueueSize:Integer;

    FIsDestroying :Boolean;
    FWSARecvBufferSize: cardinal;
    procedure SetWSARecvBufferSize(const Value: cardinal);

    function isDestroying:Boolean;
  {$IFDEF LOGGER_ON}
    function logCanWrite:Boolean;
  {$ENDIF}
  protected
    FClientContextClass:TIocpClientContextClass;

    FIocpSendRequestClass:TIocpSendRequestClass;

    procedure setName(const NewName: TComponentName); override;
  private
    // clientContext pool
    FContextPool: TBaseQueue;


    // sendRequest pool
    FSendRequestPool: TBaseQueue;



    /// data record
    FDataMoniter: TIocpDataMonitor;

    FActive: Boolean;


    // online clientcontext list
    FOnlineContextList: TContextDoublyLinked;

    // acceptEx request mananger
    FIocpAcceptorMgr:TIocpAcceptorMgr;

    FIocpEngine: TIocpEngine;

    FKeepAlive: Boolean;

    // server listen socket, accept client connection
    FListenSocket: TRawSocket;
    FOnClientContextConnected: TClientContextNotifyEvent;
    FOnClientContextDisconnected: TClientContextNotifyEvent;


    FOnDataReceived: TOnDataReceived;


    FOnClientContextError: TOnClientContextError;

    FPort: Integer;

    FWSASendBufferSize: cardinal;

    procedure DoClientContextError(pvClientContext: TIocpClientContext;
        pvErrorCode: Integer);
    function GetWorkerCount: Integer;

    procedure SetWorkerCount(const Value: Integer);

    procedure SetActive(pvActive:Boolean);



    /// <summary>
    ///   occur on create instance
    /// </summary>
    procedure onCreateClientContext(const context: TIocpClientContext);virtual;

    /// <summary>
    ///   pop ClientContext object
    /// </summary>
    function getClientContext():TIocpClientContext;

    /// <summary>
    ///   giveback to pool
    /// </summary>
    function releaseClientContext(pvObject:TIocpClientContext): Boolean;



    procedure doReceiveData(pvIocpClientContext:TIocpClientContext; pvRequest:TIocpRecvRequest);
  protected
    /// <summary>
    ///   pop sendRequest object
    /// </summary>
    function getSendRequest():TIocpSendRequest;

    /// <summary>
    ///   push back to pool
    /// </summary>
    function releaseSendRequest(pvObject:TIocpSendRequest): Boolean;

  private
    procedure DoAcceptExResponse(pvRequest: TIocpAcceptExRequest);

    function GetClientCount: Integer;
    procedure SetWSASendBufferSize(const Value: cardinal);

  public
    constructor Create(AOwner: TComponent); override;

    procedure setMaxSendingQueueSize(pvSize:Integer);

    destructor Destroy; override;

    procedure registerContextClass(pvContextClass: TIocpClientContextClass);

    procedure registerSendRequestClass(pvClass: TIocpSendRequestClass);

    /// <summary>
    ///   create DataMonitor object
    /// </summary>
    procedure createDataMonitor;


    /// <summary>
    ///   check clientContext object is valid.
    /// </summary>
    function checkClientContextValid(const pvClientContext: TIocpClientContext):  Boolean;

    /// <summary>
    ///
    /// </summary>
    procedure DisconnectAll;

    /// <summary>
    ///   get online client list
    /// </summary>
    procedure getOnlineContextList(pvList:TList);

    /// <summary>
    ///   stop and wait all workers down
    /// </summary>
    procedure safeStop();

    property Active: Boolean read FActive write SetActive;

    procedure open();

    procedure close;

    /// <summary>
    ///   client connections counter
    /// </summary>
    property ClientCount: Integer read GetClientCount;
    property DataMoniter: TIocpDataMonitor read FDataMoniter;
    property IocpEngine: TIocpEngine read FIocpEngine;

    /// <summary>
    ///   set socket Keep alive option when acceptex
    /// </summary>
    property KeepAlive: Boolean read FKeepAlive write FKeepAlive;
  published

    /// <summary>
    ///   on disconnected
    /// </summary>
    property OnClientContextDisconnected: TClientContextNotifyEvent read
        FOnClientContextDisconnected write FOnClientContextDisconnected;

    /// <summary>
    ///   on connected
    /// </summary>
    property OnClientContextConnected: TClientContextNotifyEvent read FOnClientContextConnected write FOnClientContextConnected;

    /// <summary>
    ///   listen port
    /// </summary>
    property Port: Integer read FPort write FPort;

    /// <summary>
    ///   default cpu count * 2 -1
    /// </summary>
    property WorkerCount: Integer read GetWorkerCount write SetWorkerCount;


    /// <summary>
    ///   post wsaRecv request block size
    /// </summary>
    property WSARecvBufferSize: cardinal read FWSARecvBufferSize write
        SetWSARecvBufferSize;

    /// <summary>
    ///   max size for post WSASend
    /// </summary>
    property WSASendBufferSize: cardinal read FWSASendBufferSize write
        SetWSASendBufferSize;







    /// <summary>
    ///  on work error
    ///    occur in post request methods or iocp worker thread
    /// </summary>
    property OnClientContextError: TOnClientContextError read FOnClientContextError
        write FOnClientContextError;



    /// <summary>
    ///  on clientcontext received data
    ///    called by iocp worker thread
    /// </summary>
    property OnDataReceived: TOnDataReceived read FOnDataReceived write
        FOnDataReceived;
  end;



implementation

{$IFDEF DEBUG_MSG_ON}
procedure logDebugMessage(pvMsg: string; const args: array of const);
begin
  sfLogger.logMessage(pvMsg, args);
end;
{$ENDIF}



/// compare target, cmp_val same set target = new_val
/// return old value
function lock_cmp_exchange(cmp_val, new_val: Boolean; var target: Boolean): Boolean; overload;
asm
{$ifdef win32}
  lock cmpxchg [ecx], dl
{$else}
.noframe
  mov rax, rcx
  lock cmpxchg [r8], dl
{$endif}
end;


procedure TIocpClientContext.InnerCloseContext;
begin
  Assert(FOwner <> nil);
  Assert(FReferenceCounter = 0);
  Assert(FActive);
{$IFDEF CHANGE_STATE_USE_LOCKER}

  try
    FActive := false;
    FRawSocket.close;
    checkReleaseRes;
    FOwner.FOnlineContextList.remove(self);

    try
      if Assigned(FOwner.FOnClientContextDisconnected) then
      begin
        FOwner.FOnClientContextDisconnected(Self);
      end;
      OnDisconnected;
    except
    end;
  finally
    FOwner.releaseClientContext(Self);
  end;

{$ELSE}
  if lock_cmp_exchange(True, False, FLockActive) then
  begin
    try
      FActive := false;
      FRawSocket.close;
      checkReleaseRes;
      FOwner.FOnlineContextList.remove(self);

      try
        if Assigned(FOwner.FOnClientContextDisconnected) then
        begin
          FOwner.FOnClientContextDisconnected(Self);
        end;
        OnDisconnected;
      except
      end;
    finally
      FOwner.releaseClientContext(Self);
    end;
  end;
{$ENDIF}
end;

procedure TIocpClientContext.lock;
begin
  FContextLocker.lock();
end;

function TIocpClientContext.LockContext(pvDebugInfo: string; pvObj: TObject):
    Boolean;
begin
  Result := incReferenceCounter(pvDebugInfo, pvObj);
end;

procedure TIocpClientContext.unLockContext(pvDebugInfo: string; pvObj: TObject);
begin
  decReferenceCounter(pvDebugInfo, pvObj);
end;


procedure TIocpClientContext.checkNextSendRequest;
var
  lvRequest:TIocpSendRequest;
begin
  Assert(FOwner <> nil);
  lvRequest := TIocpSendRequest(FSendRequestLink.Pop);
  if lvRequest = nil then
  begin
    FSending := false;
  end;

  if lvRequest <> nil then
  begin
    FcurrSendRequest := lvRequest;
    if lvRequest.checkStart then
    begin
      if (FOwner.FDataMoniter <> nil) then
      begin
        FOwner.FDataMoniter.incPostSendObjectCounter;
      end;
    end else
    begin
    {$IFDEF DEBUG_MSG_ON}
      if FOwner.logCanWrite then
        FOwner.FSafeLogger.logMessage('TIocpClientContext.checkNextSendRequest.checkStart return false',  []);
    {$ENDIF}

      /// kick out the clientContext
      RequestDisconnect;
    end;
  end;
end;

procedure TIocpClientContext.checkReleaseRes;
var
  lvRequest:TIocpSendRequest;
begin
  while true do
  begin
    lvRequest :=TIocpSendRequest(FSendRequestLink.Pop);
    if lvRequest <> nil then
    begin
      FOwner.releaseSendRequest(lvRequest);
    end else
    begin
      Break;
    end;
  end;
end;

constructor TIocpClientContext.Create;
begin
  inherited Create;
  FDebugStrings := TStringList.Create;
  FReferenceCounter := 0;
  FContextLocker := TIocpLocker.Create('contextLocker');
  FAlive := False;
  FRawSocket := TRawSocket.Create();
  FActive := false;
  FSendRequestLink := TIocpRequestSingleLink.Create(10);
  FRecvRequest := TIocpRecvRequest.Create;
  FRecvRequest.FClientContext := self;
end;

function TIocpClientContext.incReferenceCounter(pvDebugInfo: string; pvObj:
    TObject): Boolean;
begin
  FContextLocker.lock('incReferenceCounter');
  if (not Active) or FRequestDisconnect then
  begin
    Result := false;
  end else
  begin
    Inc(FReferenceCounter);
    FDebugStrings.Add(Format('+(%d):%d,%s', [FReferenceCounter, IntPtr(pvObj), pvDebugInfo]));

    if FDebugStrings.Count > 20 then
      FDebugStrings.Delete(0);

    Result := true;
  end;
  FContextLocker.unLock;
end;


function TIocpClientContext.decReferenceCounter(pvDebugInfo: string; pvObj:
    TObject): Integer;
var
  lvCloseContext:Boolean;
begin
  lvCloseContext := false;
  FContextLocker.lock('decReferenceCounter');
  Dec(FReferenceCounter);
  FDebugStrings.Add(Format('-(%d):%d,%s', [FReferenceCounter, IntPtr(pvObj), pvDebugInfo]));

  if FDebugStrings.Count > 20 then
    FDebugStrings.Delete(0);


  if FReferenceCounter < 0 then
    Assert(FReferenceCounter >=0 );
  if FReferenceCounter = 0 then
    if FRequestDisconnect then lvCloseContext := true;
    
  FContextLocker.unLock; 
  
  if lvCloseContext then InnerCloseContext; 
end;

procedure TIocpClientContext.decReferenceCounterAndRequestDisconnect(
    pvDebugInfo: string; pvObj: TObject);
var
  lvCloseContext:Boolean;
begin
  lvCloseContext := false;

  FContextLocker.lock('decReferenceCounter');
  FRequestDisconnect := true;
  Dec(FReferenceCounter);
  FDebugStrings.Add(Format('-(%d):%d,%s', [FReferenceCounter, IntPtr(pvObj), pvDebugInfo]));

  if FDebugStrings.Count > 20 then
    FDebugStrings.Delete(0);
  if FReferenceCounter < 0 then
    Assert(FReferenceCounter >=0 );
  if FReferenceCounter = 0 then
    lvCloseContext := true;
    
  FContextLocker.unLock; 
  
  if lvCloseContext then InnerCloseContext; 
end;

procedure TIocpClientContext.RequestDisconnect;
var
  lvCloseContext:Boolean;
begin
  lvCloseContext := false;
  FContextLocker.lock('RequestDisconnect');
  
  FRequestDisconnect := True;

  //
  if FReferenceCounter = 0 then
  begin
    lvCloseContext := true;
  end;
  
  FContextLocker.unLock; 
  
  if lvCloseContext then InnerCloseContext else FRawSocket.close; 
end;

destructor TIocpClientContext.Destroy;
begin
  if FReferenceCounter <> 0 then
  begin
    Assert(FReferenceCounter = 0);
  end;

  FRawSocket.close;
  FRawSocket.Free;

  FRecvRequest.Free;

  Assert(FSendRequestLink.Count = 0);

  FSendRequestLink.Free;
  FContextLocker.Free;
  FDebugStrings.Free;
  inherited Destroy;
end;

procedure TIocpClientContext.DoCleanUp;
begin
  FOwner := nil;
  Assert(FReferenceCounter = 0);
  FRequestDisconnect := false;

  FDebugStrings.Add(Format('-(%d):%d,%s', [FReferenceCounter, IntPtr(Self), '-----DoCleanUp-----']));

  Assert(not FActive);
//  if FActive then
//  begin
//    FRawSocket.close;
//    FActive := false;
//    checkReleaseRes;
//  end;
end;

procedure TIocpClientContext.DoConnected;
begin
{$IFDEF CHANGE_STATE_USE_LOCKER}
  FContextLocker.lock('DoConnected');
  try
    if not FActive then
    begin
      FActive := true;
      Assert(FOwner <> nil);
      FOwner.FOnlineContextList.add(Self);
      if Assigned(FOwner.FOnClientContextConnected) then
      begin
        FOwner.FOnClientContextConnected(Self);
      end;

      try
        OnConnected();
      except
      end;

      PostWSARecvRequest;
    end;
  finally
    FContextLocker.unLock;
  end;
{$ELSE}
  if lock_cmp_exchange(False, True, FLockActive) = False then
  begin
    try
      if FOwner = nil then
        Assert(FOwner <> nil);

      FOwner.FOnlineContextList.add(Self);
      if Assigned(FOwner.FOnClientContextConnected) then
      begin
        FOwner.FOnClientContextConnected(Self);
      end;

      try
        OnConnected();
      except
      end;
    finally
      FActive := true;
    end;
    PostWSARecvRequest;
  end;
{$ENDIF}
end;

procedure TIocpClientContext.DoDisconnect;
begin
  RequestDisconnect;
end;

procedure TIocpClientContext.DoReceiveData;
begin
  OnRecvBuffer(FRecvRequest.FRecvBuffer.buf,
    FRecvRequest.FBytesTransferred,
    FRecvRequest.FErrorCode);
  if FOwner <> nil then
    FOwner.doReceiveData(Self, FRecvRequest);
end;

procedure TIocpClientContext.DoSendRequestCompleted(pvRequest:
    TIocpSendRequest);
begin
  ;
end;

function TIocpClientContext.getSendRequest: TIocpSendRequest;
begin
  Result := FOwner.getSendRequest;
  Assert(Result <> nil);
  Result.FClientContext := self;
end;






procedure TIocpClientContext.OnConnected;
begin
  
end;

procedure TIocpClientContext.OnDisconnected;
begin

end;

procedure TIocpClientContext.OnRecvBuffer(buf: Pointer; len: Cardinal; ErrCode:
    WORD);
begin
  
end;

procedure TIocpClientContext.postNextSendRequest;
begin
  self.lock;
  try
    checkNextSendRequest;
  finally
    self.unLock;
  end;
end;

function TIocpClientContext.postSendRequest(
  pvSendRequest: TIocpSendRequest): Boolean;
begin  
  Result := False;
    
  if incReferenceCounter('TIocpClientContext.postSendRequest', pvSendRequest) then
  try
    FContextLocker.lock();   
    try    
      Result := FSendRequestLink.Push(pvSendRequest);
      if Result then
      begin      
        if (FOwner<> nil) and (FOwner.FDataMoniter <> nil) then
        begin
          FOwner.FDataMoniter.incPushSendQueueCounter;
        end;
        Result := true;

        if not FSending then
        begin
          FSending := true;
          checkNextSendRequest;
        end;
      end;
    finally
      FContextLocker.unLock;
    end;
    
    if not Result then
    begin
    {$IFDEF DEBUG_MSG_ON}
      if FOwner.logCanWrite then
        FOwner.FSafeLogger.logMessage('Push sendRequest to Sending Queue fail, queue size:%d',
         [FSendRequestLink.Count]);
    {$ENDIF}

      FOwner.releaseSendRequest(pvSendRequest);
      self.RequestDisconnect;
    end;
  finally
    decReferenceCounter('TIocpClientContext.postSendRequest', pvSendRequest);
  end;
end;

procedure TIocpClientContext.PostWSARecvRequest;
begin
  FRecvRequest.PostRequest;
end;



function TIocpClientContext.PostWSASendRequest(buf: Pointer; len: Cardinal;
    pvCopyBuf: Boolean = true): Boolean;
var
  lvRequest:TIocpSendRequest;
begin
  if self.Active then
  begin
    lvRequest := getSendRequest;
    lvRequest.setBuffer(buf, len, pvCopyBuf);
    Result := postSendRequest(lvRequest);
  end else
  begin
    Result := false;
  end;
end;



procedure TIocpClientContext.SetDebugINfo(const Value: string);
begin
  FDebugINfo := Value;
end;

procedure TIocpClientContext.SetOwner(const Value: TIocpTcpServer);
begin
  FOwner := Value;
  FRecvRequest.FOwner := FOwner;
end;

procedure TIocpClientContext.SetSocketState(pvState:TSocketState);
begin
  FSocketState := pvState;
//  if Assigned(FOnSocketStateChanged) then
//  begin
//    FOnSocketStateChanged(Self);
//  end;
end;

procedure TIocpClientContext.unLock;
begin
  FContextLocker.unLock;
end;


function TIocpTcpServer.checkClientContextValid(const pvClientContext: TIocpClientContext): Boolean;
begin
  Result := (pvClientContext.FOwner = Self);
  //Result := FOnlineContextList.IndexOf(pvClientContext) <> -1;
end;

procedure TIocpTcpServer.close;
begin
  SetActive(False);
end;

constructor TIocpTcpServer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LOGGER_ON}
  FSafeLogger:=TSafeLogger.Create();
  FSafeLogger.setAppender(TLogFileAppender.Create(True));
{$ENDIF}

  FKeepAlive := true;
  FContextPool := TBaseQueue.Create;
  FSendRequestPool := TBaseQueue.Create;
    
  FIocpEngine := TIocpEngine.Create();

  FOnlineContextList := TContextDoublyLinked.Create();

  FListenSocket := TRawSocket.Create;

  FIocpAcceptorMgr := TIocpAcceptorMgr.Create(Self, FListenSocket);

  // post wsaRecv block size
  FWSARecvBufferSize := 1024 * 4;

  FWSASendBufferSize := 1024 * 8;
end;

destructor TIocpTcpServer.Destroy;
begin
{$IFDEF LOGGER_ON}
  FSafeLogger.Enable := false;
{$ENDIF}

  FIsDestroying := true;

  safeStop;

  if FDataMoniter <> nil then FDataMoniter.Free;

  FContextPool.FreeDataObject;

  FSendRequestPool.FreeDataObject;

  FListenSocket.Free;
  FIocpAcceptorMgr.Free;
  FIocpEngine.Free;

  FOnlineContextList.Free;

  FContextPool.Free;
  FSendRequestPool.Free;

{$IFDEF LOGGER_ON}
  FSafeLogger.Free;
{$ENDIF}
  inherited Destroy;
end;

procedure TIocpTcpServer.DisconnectAll;
var
  lvClientContext, lvNextContext:TIocpClientContext;
begin
  FOnlineContextList.FLocker.lock('DisconnectAll');
  try
    lvNextContext := FOnlineContextList.FHead;

    // request all context discounnt
    while lvNextContext <> nil do
    begin    
      lvClientContext := lvNextContext;
      lvNextContext := lvNextContext.FNext; 
      lvClientContext.RequestDisconnect;    
    end;
  finally
    FOnlineContextList.FLocker.unLock;
  end;
end;

{$IFDEF LOGGER_ON}
function TIocpTcpServer.logCanWrite: Boolean;
begin
  Result := (not isDestroying) and FSafeLogger.Enable;
end;
{$ENDIF}

procedure TIocpTcpServer.DoAcceptExResponse(pvRequest: TIocpAcceptExRequest);
var
  lvRet, lvErrCode:Integer;
  lvContinue:Boolean;
begin
  if pvRequest.FErrorCode = 0 then
  begin
    lvContinue := true;
    if FKeepAlive then
    begin
      if not pvRequest.FClientContext.FRawSocket.setKeepAliveOption() then
      begin       // set option fail
        lvErrCode := GetLastError;
        DoClientContextError(pvRequest.FClientContext, lvErrCode);

        pvRequest.FClientContext.FRawSocket.close;

        // relase client context object
        releaseClientContext(pvRequest.FClientContext);
        pvRequest.FClientContext := nil;
        
        lvContinue := false;
      end;
    end;


    if lvContinue then
    begin

      lvRet := FIocpEngine.IocpCore.bind2IOCPHandle(pvRequest.FClientContext.FRawSocket.SocketHandle, 0);
      if lvRet = 0 then
      begin     // binding error
        lvErrCode := GetLastError;
        DoClientContextError(pvRequest.FClientContext, lvErrCode);

        pvRequest.FClientContext.FRawSocket.close;

        // relase client context object
        releaseClientContext(pvRequest.FClientContext);
        pvRequest.FClientContext := nil;
      end else
      begin
        pvRequest.FClientContext.DoConnected;
      end;
    end;
  end else
  begin
    // relase client context object
    releaseClientContext(pvRequest.FClientContext);
    pvRequest.FClientContext := nil;
  end;

  // remove from list
  FIocpAcceptorMgr.removeRequestObject(pvRequest);

  if FActive then FIocpAcceptorMgr.checkPostRequest;
end;

procedure TIocpTcpServer.DoClientContextError(pvClientContext:
    TIocpClientContext; pvErrorCode: Integer);
begin
{$IFDEF DEBUG_MSG_ON}
  if logCanWrite then
    FSafeLogger.logMessage('TIocpTcpServer.DoClientContextError Error:%d',  [pvErrorCode], 'ContextError', lgvError);
{$ENDIF}

  if Assigned(FOnClientContextError) then
    FOnClientContextError(pvClientContext, pvErrorCode);
end;

procedure TIocpTcpServer.doReceiveData(pvIocpClientContext: TIocpClientContext;
  pvRequest: TIocpRecvRequest);
begin
  if Assigned(FOnDataReceived) then
    FOnDataReceived(pvIocpClientContext,
      pvRequest.FRecvBuffer.buf, pvRequest.FBytesTransferred,
      pvRequest.FErrorCode);
end;

function TIocpTcpServer.getClientContext: TIocpClientContext;
begin
  Result := TIocpClientContext(FContextPool.Pop);
  if Result = nil then
  begin
    if FClientContextClass <> nil then
    begin
      Result := FClientContextClass.Create;
      onCreateClientContext(Result);
    end else
    begin
      Result := TIocpClientContext.Create;
      onCreateClientContext(Result);
    end;
    Result.FSendRequestLink.setMaxSize(FMaxSendingQueueSize);
  end;
  Result.FAlive := True;
  Result.DoCleanUp;
  Result.Owner := Self;
end;

function TIocpTcpServer.GetWorkerCount: Integer;
begin
  Result := FIocpEngine.WorkerCount;
end;

function TIocpTcpServer.isDestroying: Boolean;
begin
  Result := FIsDestroying or (csDestroying in self.ComponentState)
end;

procedure TIocpTcpServer.onCreateClientContext(
  const context: TIocpClientContext);
begin

end;

procedure TIocpTcpServer.open;
begin
  SetActive(true);
end;

procedure TIocpTcpServer.registerContextClass(pvContextClass: TIocpClientContextClass);
begin
  FClientContextClass := pvContextClass;
end;

procedure TIocpTcpServer.registerSendRequestClass(
  pvClass: TIocpSendRequestClass);
begin
  FIocpSendRequestClass := pvClass;
end;

function TIocpTcpServer.releaseClientContext(pvObject:TIocpClientContext):
    Boolean;
begin
  if lock_cmp_exchange(True, False, pvObject.FAlive) = true then
  begin
    pvObject.DoCleanUp;
    FContextPool.Push(pvObject);
    Result := true;
  end else
  begin
    Result := false;
  end;
end;

function TIocpTcpServer.releaseSendRequest(pvObject:TIocpSendRequest): Boolean;
begin
  if lock_cmp_exchange(True, False, pvObject.FAlive) = True then
  begin
    FSendRequestPool.Push(pvObject);
    Result := true;
  end else
  begin
    Result := false;
  end;
end;

procedure TIocpTcpServer.safeStop;
begin
  if FActive then
  begin
    FActive := false;

    // close listen socket
    FListenSocket.close;

    DisconnectAll;

    // engine stop
    FIocpEngine.safeStop;

    //Assert(self.) 
  end; 
end;

procedure TIocpTcpServer.SetActive(pvActive:Boolean);
begin
  if pvActive <> FActive then
  begin
    if pvActive then
    begin
      if FDataMoniter <> nil then FDataMoniter.clear;
      
      // engine start
      FIocpEngine.checkStart;
      
      // create listen socket
      FListenSocket.createTcpOverlappedSocket;

      // bind to listen port
      if not FListenSocket.bind('', FPort) then
      begin
        RaiseLastOSError;
      end;

      // listen
      if not FListenSocket.listen() then
      begin
        RaiseLastOSError;
      end;

      FIocpEngine.IocpCore.bind2IOCPHandle(FListenSocket.SocketHandle, 0);


      FIocpAcceptorMgr.FMinRequest := 10;
      FIocpAcceptorMgr.FMaxRequest := 100;

      // post AcceptEx request
      FIocpAcceptorMgr.checkPostRequest;

      FActive := True;
    end else
    begin
      safeStop;
    end; 
  end;
end;

procedure TIocpTcpServer.setMaxSendingQueueSize(pvSize: Integer);
begin
  if pvSize <= 0 then
  begin
    FMaxSendingQueueSize := 10;
  end else
  begin
    FMaxSendingQueueSize := pvSize;
  end;
end;

procedure TIocpTcpServer.setName(const NewName: TComponentName);
begin
  inherited;
{$IFDEF LOGGER_ON}
  if FSafeLogger.Appender is TLogFileAppender then
  begin
    if NewName <> '' then
    begin
      TLogFileAppender(FSafeLogger.Appender).FilePreFix := NewName + '_';
    end;
  end;
{$ENDIF}
end;

procedure TIocpTcpServer.SetWorkerCount(const Value: Integer);
begin
  FIocpEngine.setWorkerCount(Value);
end;

procedure TIocpTcpServer.createDataMonitor;
begin
  if FDataMoniter = nil then
  begin
    FDataMoniter := TIocpDataMonitor.Create;
  end;
end;

function TIocpTcpServer.GetClientCount: Integer;
begin
  Result := FOnlineContextList.Count;
end;

procedure TIocpTcpServer.getOnlineContextList(pvList:TList);
begin
  FOnlineContextList.write2List(pvList);
end;

function TIocpTcpServer.getSendRequest: TIocpSendRequest;
begin
  if Self = nil then
  begin
    Result := nil;
    Exit;
  end;
  Result := TIocpSendRequest(FSendRequestPool.Pop);
  if Result = nil then
  begin
    if FIocpSendRequestClass <> nil then
    begin
      Result := FIocpSendRequestClass.Create;
    end else
    begin
      Result := TIocpSendRequest.Create;
    end;
  end;
  Result.FAlive := true;
  Result.DoCleanup;
  Result.FOwner := Self;
end;

procedure TIocpTcpServer.SetWSARecvBufferSize(const Value: cardinal);
begin
  FWSARecvBufferSize := Value;
  if FWSARecvBufferSize = 0 then
  begin
    FWSARecvBufferSize := 1024 * 4;
  end;
end;

procedure TIocpTcpServer.SetWSASendBufferSize(const Value: cardinal);
begin
  FWSASendBufferSize := Value;
  if FWSASendBufferSize <=0 then
    FWSASendBufferSize := 1024 * 8;
end;

procedure TIocpAcceptorMgr.checkPostRequest;
var
  lvRequest:TIocpAcceptExRequest;
begin
  Assert(FOwner <> nil);
  FLocker.lock;
  try
    if FList.Count > FMinRequest then Exit;

    // post request
    while FList.Count < FMaxRequest do
    begin
      lvRequest := TIocpAcceptExRequest.Create(FOwner);
      lvRequest.FClientContext := FOwner.getClientContext;
      lvRequest.FAcceptorMgr := self;
      if lvRequest.PostRequest then
      begin
        FList.Add(lvRequest);
        if (FOwner.FDataMoniter <> nil) then
        begin
          InterlockedIncrement(FOwner.FDataMoniter.FPostWSAAcceptExCounter);
        end;
      end else
      begin     // post fail
        lvRequest.FClientContext.SetSocketState(ssDisconnected);
        FOwner.releaseClientContext(lvRequest.FClientContext);
        releaseRequestObject(lvRequest);
      end;
    end;
  finally
    FLocker.unLock;
  end;
end;

constructor TIocpAcceptorMgr.Create(AOwner: TIocpTcpServer; AListenSocket:
    TRawSocket);
begin
  inherited Create;
  FLocker := TIocpLocker.Create();
  FLocker.Name := 'acceptorLocker';
  FMaxRequest := 200;
  FMinRequest := 10;  
  FList := TList.Create;
  FOwner := AOwner;
  FListenSocket := AListenSocket;
end;

destructor TIocpAcceptorMgr.Destroy;
begin
  FList.Free;
  FLocker.Free;
  inherited Destroy;
end;

procedure TIocpAcceptorMgr.releaseRequestObject(
  pvRequest: TIocpAcceptExRequest);
begin
  pvRequest.Free; 
end;

procedure TIocpAcceptorMgr.removeRequestObject(pvRequest: TIocpAcceptExRequest);
begin
  FLocker.lock;
  try
    FList.Remove(pvRequest);
  finally
    FLocker.unLock;
  end;
end;

constructor TIocpAcceptExRequest.Create(AOwner: TIocpTcpServer);
begin
  inherited Create;
  FOwner := AOwner;
end;

procedure TIocpAcceptExRequest.getPeerINfo;
var
  localAddr: PSockAddr;
  remoteAddr: PSockAddr;
  localAddrSize : Integer;
  remoteAddrSize : Integer;
begin
  localAddrSize := SizeOf(TSockAddr) + 16;
  remoteAddrSize := SizeOf(TSockAddr) + 16;
  IocpGetAcceptExSockaddrs(@FAcceptBuffer[0],
                        0,
                        SizeOf(localAddr^) + 16,
                        SizeOf(remoteAddr^) + 16,
                        localAddr,
                        localAddrSize,
                        remoteAddr,
                        remoteAddrSize);

  FClientContext.FRemoteAddr := string(inet_ntoa(TSockAddrIn(remoteAddr^).sin_addr));
  FClientContext.FRemotePort := ntohs(TSockAddrIn(remoteAddr^).sin_port);
end;

procedure TIocpAcceptExRequest.HandleResponse;
begin
  Assert(FOwner <> nil);
  ///
  if (FOwner.FDataMoniter <> nil) then
  begin
    InterlockedIncrement(FOwner.FDataMoniter.FResponseWSAAcceptExCounter);
  end;

  try
    if FErrorCode = 0 then
    begin
      // msdn
      // The socket sAcceptSocket does not inherit the properties of the socket
      //  associated with sListenSocket parameter until SO_UPDATE_ACCEPT_CONTEXT
      //  is set on the socket.
      FOwner.FListenSocket.UpdateAcceptContext(FClientContext.FRawSocket.SocketHandle);

      getPeerINfo();
    end;
    FOwner.DoAcceptExResponse(Self);
  finally
    FAcceptorMgr.releaseRequestObject(Self);
  end;

end;

function TIocpAcceptExRequest.PostRequest: Boolean;
var
  dwBytes: Cardinal;
  lvRet:BOOL;
  lvErrCode:Integer;
  lp:POverlapped;
begin
  FClientContext.FRawSocket.createTcpOverlappedSocket;
  dwBytes := 0;
  lp := @FOverlapped;

  FClientContext.SetSocketState(ssAccepting);

  lvRet := IocpAcceptEx(FOwner.FListenSocket.SocketHandle
                , FClientContext.FRawSocket.SocketHandle
                , @FAcceptBuffer[0]
                , 0
                , SizeOf(TSockAddrIn) + 16
                , SizeOf(TSockAddrIn) + 16
                , dwBytes
                , lp);
  if not lvRet then
  begin
    lvErrCode := WSAGetLastError;
    Result := lvErrCode = WSA_IO_PENDING;
    if not Result then
    begin
      FOwner.DoClientContextError(FClientContext, lvErrCode);
    end;
  end else
  begin
    Result := True;
  end;
end;

constructor TIocpRecvRequest.Create;
begin
  inherited Create;
end;

destructor TIocpRecvRequest.Destroy;
begin
  if FInnerBuffer.len > 0 then
  begin
    FreeMem(FInnerBuffer.buf, FInnerBuffer.len);
  end;
  inherited Destroy;
end;

procedure TIocpRecvRequest.HandleResponse;
begin
  InterlockedDecrement(FOverlapped.refCount);
  if FOverlapped.refCount <> 0 then
    Assert(FOverlapped.refCount <>0);

  Assert(FOwner <> nil);
  try
    if (FOwner.FDataMoniter <> nil) then
    begin
      FOwner.FDataMoniter.incResponseWSARecvCounter;
      FOwner.FDataMoniter.incRecvdSize(FBytesTransferred);
    end;

    if not FOwner.Active then
    begin
      {$IFDEF DEBUG_MSG_ON}
       if FOwner.logCanWrite then
        FOwner.FSafeLogger.logMessage('IocpRecvRequest response server enginee is off');
      {$ENDIF}
    end else if FErrorCode <> 0 then
    begin
      {$IFDEF DEBUG_MSG_ON}
       if FOwner.logCanWrite then
        FOwner.FSafeLogger.logMessage('IocpRecvRequest response ErrorCode:%d',  [FErrorCode]);
      {$ENDIF}
      FOwner.DoClientContextError(FClientContext, FErrorCode);
      FClientContext.RequestDisconnect;
    end else if (FBytesTransferred = 0) then
    begin      // no data recvd, socket is break
      {$IFDEF DEBUG_MSG_ON}
        if FOwner.logCanWrite then
          FOwner.FSafeLogger.logMessage('IocpRecvRequest response FBytesTransferred is zero',  []);
      {$ENDIF}
      FClientContext.RequestDisconnect;
    end else
    begin
      FClientContext.DoReceiveData;
    end;
  finally
    FClientContext.decReferenceCounter(
      Format('debugInfo:%s, refcount:%d, TIocpRecvRequest.WSARecvRequest.HandleResponse',
        [FDebugInfo,FOverlapped.refCount]), Self);

    if not FClientContext.FRequestDisconnect then
    begin
      FClientContext.PostWSARecvRequest;
    end;
  end;
end;

function TIocpRecvRequest.PostRequest(pvBuffer: PAnsiChar;
  len: Cardinal): Boolean;
var
  lvRet:Integer;
  lpNumberOfBytesRecvd: Cardinal;
begin
  Result := False;
  lpNumberOfBytesRecvd := 0;
  FRecvdFlag := 0;

  FRecvBuffer.buf := pvBuffer;
  FRecvBuffer.len := len;

  if FClientContext.incReferenceCounter('TIocpRecvRequest.WSARecvRequest.Post', Self) then
  begin
    InterlockedIncrement(FOverlapped.refCount);
    FDebugInfo := IntToStr(intPtr(FClientContext));
    lvRet := iocpWinsock2.WSARecv(FClientContext.FRawSocket.SocketHandle,
       @FRecvBuffer,
       1,
       lpNumberOfBytesRecvd,
       FRecvdFlag,
       LPWSAOVERLAPPED(@FOverlapped),   // d7 need to cast
       nil
       );
    if lvRet = SOCKET_ERROR then
    begin
      lvRet := WSAGetLastError;
      Result := lvRet = WSA_IO_PENDING;
      if not Result then
      begin
        {$IFDEF DEBUG_MSG_ON}
         if FOwner.logCanWrite then
          FOwner.FSafeLogger.logMessage('TIocpRecvRequest.PostRequest Error:%d',  [lvRet]);
        {$ENDIF}

        InterlockedDecrement(FOverlapped.refCount);

        // trigger error event
        FOwner.DoClientContextError(FClientContext, lvRet);

        // decReferenceCounter
        FClientContext.decReferenceCounterAndRequestDisconnect(
        'TIocpRecvRequest.WSARecvRequest.Error', Self);

      end else
      begin
        if (FOwner <> nil) and (FOwner.FDataMoniter <> nil) then
        begin
          FOwner.FDataMoniter.incPostWSARecvCounter;
        end;
      end;
    end else
    begin
      Result := True;
    
      if (FOwner <> nil) and (FOwner.FDataMoniter <> nil) then
      begin
        FOwner.FDataMoniter.incPostWSARecvCounter;
      end;
    end;   
  end;
end;

function TIocpRecvRequest.PostRequest: Boolean;
begin
  if FInnerBuffer.len <> FOwner.FWSARecvBufferSize then
  begin
    if FInnerBuffer.len > 0 then FreeMem(FInnerBuffer.buf);
    FInnerBuffer.len := FOwner.FWSARecvBufferSize;
    GetMem(FInnerBuffer.buf, FInnerBuffer.len);
  end;
  Result := PostRequest(FInnerBuffer.buf, FInnerBuffer.len);
end;

function TIocpSendRequest.checkSendNextBlock: Boolean;
var
  l:Cardinal;
begin
  if FPosition < FLen then
  begin
    l := FLen - FPosition;
    if l > FOwner.FWSASendBufferSize then l := FOwner.FWSASendBufferSize;

    Result := InnerPostRequest(Pointer(IntPtr(FBuf) + IntPtr(FPosition)), l)

  end else
  begin
    Result := false;
  end;
end;

constructor TIocpSendRequest.Create;
begin
  inherited Create;
end;

destructor TIocpSendRequest.Destroy;
begin
  if FCopyBuf.len <> 0 then
  begin
    FreeMem(FCopyBuf.buf);
  end;
  inherited Destroy;
end;

procedure TIocpSendRequest.DoCleanUp;
begin
  FBytesSize := 0;
  FNext := nil;
  FOwner := nil;
  FClientContext := nil;
  FBuf := nil;
  FLen := 0;
  FPosition := 0;
end;

procedure TIocpSendRequest.HandleResponse;
begin
  FIsBusying := false;

  Assert(FOwner<> nil);
  try
    if (FOwner.FDataMoniter <> nil) then
    begin                                                       
      FOwner.FDataMoniter.incSentSize(FBytesTransferred);
      FOwner.FDataMoniter.incResponseWSASendCounter;

    end;

    if FErrorCode <> 0 then
    begin
      {$IFDEF DEBUG_MSG_ON}
       if FOwner.logCanWrite then
        FOwner.FSafeLogger.logMessage('TIocpSendRequest.HandleResponse FErrorCode:%d',  [FErrorCode]);
      {$ENDIF}
      FOwner.DoClientContextError(FClientContext, FErrorCode);
      FClientContext.RequestDisconnect; 
      // release request
      FOwner.releaseSendRequest(Self);
    end else
    begin
      onSendRequestSucc;
      if isCompleted then    // is all buf send completed?
      begin
        if FOwner.FDataMoniter <> nil then
        begin
          FOwner.FDataMoniter.incResponseSendObjectCounter;
        end;

        if Assigned(FOnDataRequestCompleted) then
        begin
          FOnDataRequestCompleted(FClientContext, Self);
        end;

        FClientContext.DoSendRequestCompleted(Self);

        FClientContext.postNextSendRequest;

      end else
      begin
        if not checkSendNextBlock then
        begin
          {$IFDEF DEBUG_MSG_ON}
           if FOwner.logCanWrite then
             FOwner.FSafeLogger.logMessage('TIocpSendRequest.checkSendNextBlock return false',  []);
          {$ENDIF}

          /// kick out the clientContext
          FClientContext.RequestDisconnect;
        end;
      end;
    end;
  finally
    FClientContext.decReferenceCounter('TIocpSendRequest.WSASendRequest.Response', Self);
    
    // release request
    FOwner.releaseSendRequest(Self); 
  end;
end;

function TIocpSendRequest.InnerPostRequest(buf: Pointer; len: Cardinal):
    Boolean;
var
  lvRet: Integer;
  dwFlag: Cardinal;
  lpNumberOfBytesSent:Cardinal;
begin
  FIsBusying := True;
  FBytesSize := len;
  FWSABuf.buf := buf;
  FWSABuf.len := len;
  dwFlag := 0;
  lpNumberOfBytesSent := 0;

  if FClientContext.incReferenceCounter('TIocpSendRequest.WSASendRequest', Self) then
  begin
    lvRet := WSASend(FClientContext.FRawSocket.SocketHandle,
                      @FWSABuf,
                      1,
                      lpNumberOfBytesSent,
                      dwFlag,
                      LPWSAOVERLAPPED(@FOverlapped),   // d7 need to cast
                      nil
    );
    if lvRet = SOCKET_ERROR then
    begin
      lvRet := WSAGetLastError;
      Result := lvRet = WSA_IO_PENDING;
      if not Result then
      begin
        try
           FIsBusying := False;
        {$IFDEF DEBUG_MSG_ON}
           if FOwner.logCanWrite then
             FOwner.FSafeLogger.logMessage('TIocpSendRequest.WSASendRequest Error:%d',  [lvRet]);
        {$ENDIF}

           FOwner.DoClientContextError(FClientContext, lvRet);
        except  
          on e:Exception do
          begin    
            {$IFDEF DEBUG_MSG_ON}
               if FOwner.logCanWrite then
                 FOwner.FSafeLogger.logMessage('TIocpSendRequest.InnerPostRequest Exception:' + E.Message, '', lgvError);
            {$ENDIF}
          end;
        end;
        /// request kick out
        FClientContext.decReferenceCounterAndRequestDisconnect('TIocpSendRequest.InnerPostRequest.fail', Self);

        FOwner.releaseSendRequest(Self);
      end else
      begin
        if (FOwner <> nil) and (FOwner.FDataMoniter <> nil) then
        begin
          FOwner.FDataMoniter.incPostWSASendSize(len);
          FOwner.FDataMoniter.incPostWSASendCounter;
        end;
      end;
    end else
    begin
      Result := True;
      if (FOwner <> nil) and (FOwner.FDataMoniter <> nil) then
      begin
        FOwner.FDataMoniter.incPostWSASendSize(len);
        FOwner.FDataMoniter.incPostWSASendCounter;
      end;
    end;
  end;
end;

function TIocpSendRequest.isCompleted: Boolean;
begin
  Result := FPosition >= FLen;
end;

procedure TIocpSendRequest.onSendRequestSucc;
begin
  FPosition := FPosition + self.FBytesTransferred;
end;

procedure TIocpSendRequest.setBuffer(buf: Pointer; len: Cardinal; pvCopyBuf:
    Boolean = true);
begin
  if pvCopyBuf then
  begin
    if FCopyBuf.len > 0 then FreeMem(FCopyBuf.buf);

    FCopyBuf.len := len;
    GetMem(FCopyBuf.buf, FCopyBuf.len);
    Move(buf^, FCopyBuf.buf^, FCopyBuf.len);
    FBuf := FCopyBuf.buf;
    FLen := FCopyBuf.len;
  end else
  begin
    FBuf := buf;
    FLen := len;
  end;
  FPosition := 0;
end;

function TIocpSendRequest.checkStart: Boolean;
begin
  Result := checkSendNextBlock;
end;

procedure TIocpDataMonitor.clear;
begin
  FLocker.Enter;
  try
    FSentSize:=0;
    FRecvSize:=0;
    FPostWSASendSize:=0;

    FPostWSASendCounter:=0;
    FResponseWSASendCounter:=0;

    FPostWSARecvCounter:=0;
    FResponseWSARecvCounter:=0;

    FPushSendQueueCounter := 0;
    FResponseSendObjectCounter := 0;
    
    //FPostWSAAcceptExCounter:=0;
    //FResponseWSAAcceptExCounter:=0;
  finally
    FLocker.Leave;
  end;
end;

constructor TIocpDataMonitor.Create;
begin
  inherited Create;
  FLocker := TCriticalSection.Create();
end;

destructor TIocpDataMonitor.Destroy;
begin
  FLocker.Free;
  inherited Destroy;
end;

procedure TIocpDataMonitor.incPushSendQueueCounter;
begin
  InterlockedIncrement(FPushSendQueueCounter);
end;

procedure TIocpDataMonitor.incPostSendObjectCounter;
begin
  InterlockedIncrement(FPostSendObjectCounter);
end;

procedure TIocpDataMonitor.incPostWSARecvCounter;
begin
  InterlockedIncrement(FPostWSARecvCounter);
end;

procedure TIocpDataMonitor.incPostWSASendCounter;
begin
  InterlockedIncrement(FPostWSASendCounter);
end;

procedure TIocpDataMonitor.incPostWSASendSize(pvSize: Cardinal);
begin
  FLocker.Enter;
  try
    FPostWSASendSize := FPostWSASendSize + pvSize;
  finally
    FLocker.Leave;
  end;
end;

procedure TIocpDataMonitor.incRecvdSize(pvSize: Cardinal);
begin
  FLocker.Enter;
  try
    FRecvSize := FRecvSize + pvSize;
  finally
    FLocker.Leave;
  end;
end;

procedure TIocpDataMonitor.incResponseSendObjectCounter;
begin
  InterlockedIncrement(FResponseSendObjectCounter);
end;

procedure TIocpDataMonitor.incResponseWSARecvCounter;
begin
  InterlockedIncrement(FResponseWSARecvCounter);
end;

procedure TIocpDataMonitor.incResponseWSASendCounter;
begin
  InterlockedIncrement(FResponseWSASendCounter);
end;

procedure TIocpDataMonitor.incSentSize(pvSize:Cardinal);
begin
  FLocker.Enter;
  try
    FSentSize := FSentSize + pvSize;
  finally
    FLocker.Leave;
  end;
end;

procedure TContextDoublyLinked.add(pvContext: TIocpClientContext);
begin
  FLocker.lock;
  try
    if FHead = nil then
    begin
      FHead := pvContext;
    end else
    begin
      if FTail = nil then
      begin
        FCount := FCount;
      end;
      FTail.FNext := pvContext;
      pvContext.FPre := FTail;
    end;

    FTail := pvContext;
    FTail.FNext := nil;

    if FTail = nil then
    begin
      FCount := FCount;
    end;

    inc(FCount);
  finally
    FLocker.unLock;
  end;
end;

constructor TContextDoublyLinked.Create;
begin
  inherited Create;
  FCount := 0;
  FLocker := TIocpLocker.Create();
  FLocker.Name := 'onlineContext';
  FHead := nil;
  FTail := nil;
end;

destructor TContextDoublyLinked.Destroy;
begin
  FreeAndNil(FLocker);
  inherited Destroy;
end;

function TContextDoublyLinked.Pop: TIocpClientContext;
begin
  FLocker.lock;
  try
    Result := FHead;
    if FHead <> nil then
    begin
      FHead := FHead.FNext;
      if FHead = nil then FTail := nil;
      Dec(FCount);
      Result.FPre := nil;
      Result.FNext := nil;  
    end;  
  finally
    FLocker.unLock;
  end;
end;

function TContextDoublyLinked.remove(pvContext:TIocpClientContext): Boolean;
begin
  Result := false;
  FLocker.lock;
  try
    if pvContext.FPre <> nil then
    begin
      pvContext.FPre.FNext := pvContext.FNext;
      if pvContext.FNext <> nil then
        pvContext.FNext.FPre := pvContext.FPre;
    end else if pvContext.FNext <> nil then
    begin    // pre is nil, pvContext is FHead
      pvContext.FNext.FPre := nil;
      FHead := pvContext.FNext;
    end else
    begin   // pre and next is nil
      if pvContext = FHead then
      begin
        FHead := nil;
      end else
      begin
        exit;
      end;
    end;
    Dec(FCount);

    if FCount < 0 then
    begin
      Assert(FCount > 0);
    end;

    //  set pvConext.FPre is FTail
    if FTail = pvContext then
      FTail := pvContext.FPre;

    if FTail = nil then
    begin
      FCount := FCount;
      FTail := nil;
    end;

    if FHead = nil then
    begin
      FCount := FCount;
      FHead := nil;
    end;

    pvContext.FPre := nil;
    pvContext.FNext := nil;
    Result := true;
  finally
    FLocker.unLock;
  end;
end;

procedure TContextDoublyLinked.write2List(pvList: TList);
var
  lvItem:TIocpClientContext;
begin
  FLocker.lock;
  try
    lvItem := FHead;
    while lvItem <> nil do
    begin
      pvList.Add(lvItem);
      lvItem := lvItem.FNext;
    end;
  finally
    FLocker.unLock;
  end;
end;

end.
