(*
 *	 Unit owner: D10.Mofen
 *	       blog: http://www.cnblogs.com/dksoft
 *
 *	 v3.0.1(2014-7-16 21:36:30)
 *     + first release
 *
 *
 *   2014-08-31 17:38:38
 *      ��л(���˵ĳ���  419963966)��diocp3�ľ���
 *)
unit iocpClientSocket;

interface

uses
  iocpBaseSocket, SysUtils, iocpSocketUtils
  {$IFDEF UNICODE}, Generics.Collections{$ELSE}, Contnrs {$ENDIF}
  , Classes;

type
  TIocpRemoteContext = class(TIocpBaseContext)
  private
    FIsConnecting: Boolean;

    FAutoReConnect: Boolean;
    FConnectExRequest: TIocpConnectExRequest;

    FHost: String;
    FPort: Integer;
    procedure PostConnectRequest;
    procedure reCreateSocket;
  protected
    procedure OnConnecteExResponse(pvObject:TObject);

    procedure OnDisconnected; override;

    procedure SetSocketState(pvState:TSocketState); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    /// <summary>
    ///    sync execute connect
    ///      ssDisconnected -> ssConnected/ssDisconnected
    /// </summary>
    procedure Connect;

    /// <summary>
    ///   async execute connect
    ///     ssDisconnected -> ssConnecting -> ssConnected/ssDisconnected
    /// </summary>
    procedure connectASync;

    /// <summary>
    ///   auto connect when disconnected
    /// </summary>
    property AutoReConnect: Boolean read FAutoReConnect write FAutoReConnect;

    property Host: String read FHost write FHost;
    property Port: Integer read FPort write FPort;


  end;

  TIocpClientSocket = class(TIocpBaseSocket)
  private
    function GetCount: Integer;
    function GetItems(pvIndex: Integer): TIocpRemoteContext;
  private
  {$IFDEF UNICODE}
    FList: TObjectList<TIocpRemoteContext>;
  {$ELSE}
    FList: TObjectList;
  {$ENDIF}
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  public
    function Add: TIocpRemoteContext;
    property Count: Integer read GetCount;
    property Items[pvIndex: Integer]: TIocpRemoteContext read GetItems; default;



  end;

implementation

uses
  FileLogger, iocpWinsock2;

resourcestring
  strCannotConnect = '��ǰ״̬�²��ܽ�������...';



constructor TIocpRemoteContext.Create;
begin
  inherited Create;
  FAutoReConnect := False;
  FConnectExRequest := TIocpConnectExRequest.Create(Self);
  FConnectExRequest.OnResponse := OnConnecteExResponse;
  FIsConnecting := false;

end;

destructor TIocpRemoteContext.Destroy;
begin
  FreeAndNil(FConnectExRequest);
  inherited Destroy;
end;

procedure TIocpRemoteContext.Connect;
var
  lvRet:Integer;
begin
  if SocketState <> ssDisconnected then raise Exception.Create(strCannotConnect);

  reCreateSocket;


  if not RawSocket.connect(FHost, FPort) then
    RaiseLastOSError;

  DoConnected;
end;

procedure TIocpRemoteContext.connectASync;
begin
  if SocketState <> ssDisconnected then raise Exception.Create(strCannotConnect);

  ReCreateSocket;

  PostConnectRequest;

end;

procedure TIocpRemoteContext.OnConnecteExResponse(pvObject: TObject);
begin
  FIsConnecting := false;
  if TIocpConnectExRequest(pvObject).ErrorCode = 0 then
  begin
    DoConnected;
  end else
  begin

    DoError(TIocpConnectExRequest(pvObject).ErrorCode);

    if (FAutoReConnect) and (Owner.Active) then
    begin
      PostConnectRequest;
    end else
    begin
      SetSocketState(ssDisconnected);
    end;
  end;
end;

procedure TIocpRemoteContext.OnDisconnected;
begin
  inherited;
end;

procedure TIocpRemoteContext.PostConnectRequest;
begin
  if lock_cmp_exchange(False, True, FIsConnecting) = False then
  begin
    if RawSocket.SocketHandle = INVALID_SOCKET then
    begin
      reCreateSocket;
    end;

    if not FConnectExRequest.PostRequest(FHost, FPort) then
    begin
      FIsConnecting := false;

      Sleep(1000);

      if (FAutoReConnect) and (Owner.Active) then
        PostConnectRequest;
    end;
  end;
end;

procedure TIocpRemoteContext.reCreateSocket;
begin
  RawSocket.createTcpOverlappedSocket;
  if not RawSocket.bind('0.0.0.0', 0) then
  begin
    RaiseLastOSError;
  end;

  Owner.IocpEngine.IocpCore.bind2IOCPHandle(RawSocket.SocketHandle, 0);
end;

procedure TIocpRemoteContext.SetSocketState(pvState: TSocketState);
begin
  inherited;
  if pvState = ssDisconnected then
  begin
    if (FAutoReConnect) and (Owner.Active) then
    begin
      PostConnectRequest;
    end;
  end;
end;

constructor TIocpClientSocket.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF UNICODE}
  FList := TObjectList<TIocpRemoteContext>.Create();
{$ELSE}
  FList := TObjectList.Create();
{$ENDIF}
end;

destructor TIocpClientSocket.Destroy;
begin
  FList.Clear;
  FList.Free;
  inherited Destroy;
end;

function TIocpClientSocket.Add: TIocpRemoteContext;
begin
  Result := TIocpRemoteContext.Create;
  Result.Owner := Self;
  FList.Add(Result);
end;

function TIocpClientSocket.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TIocpClientSocket.GetItems(pvIndex: Integer): TIocpRemoteContext;
begin
{$IFDEF UNICODE}
  Result := FList[pvIndex];
{$ELSE}
  Result := TIocpRemoteContext(FList[pvIndex]);
{$ENDIF}

end;

end.
