unit Un_LzUDP;

interface

uses
  Windows, Classes, SysUtils, WinSock, WinSock2;

const
  DEFAULT_SENDBUF_SIZE = 8192;
  DEFAULT_RECVBUF_SIZE = 8192;

type
  {�����������֤����}
  TAuthenType = (atNone, atUserPass);

  TLzUDPRecvThread = class;
  TLzUDPSocket = class;

  TProxyInfo = record
    Enabled: Boolean; //�Ƿ�ʹ�ô���
    Address: string; //�����������ַ
    Port: Integer; //����������˿ں�
    Username: string; //�����������֤�û���
    Password: string; //����
  end;

  TUDPException = class(Exception);

  TPeerInfo = record
    PeerIP: longword;
    PeerPort: integer;
  end;

  { utInit: ��ʼ���������û����� utSend:�������� utRecv: �������� utClose:�ر�Socket}
  TUDPErrorType = (utInit, utSend, utRecv, utClose);
  TUDPErrorEvent = procedure(Sender: TObject; ErrorType: TUDPErrorType;
    var ErrorCode: Integer) of object;

  { �������¼� }
  TUDPReadEvent = procedure(UDPSocket: TLzUDPSocket; const PeerInfo: TPeerInfo)
    of object;

  //��Ҫ��UDP��
  TLzUDPSocket = class(TObject)
  private
    FSocket: TSocket;
    FPort: integer;
    //�������¼�
    FOnSocketError: TUDPErrorEvent;
    //�������¼�
    FOnDataRead: TUDPReadEvent;
    //���ͺͽ��ܻ����С
    FSendBufSize: Integer;
    FRecvBufSize: Integer;
    //��¼���ܵ����ݵ�Զ�̻�������Ϣ
    FPeerInfo: TPeerInfo;
    //���������ʱ�����һЩ�ͻ�������,�õ����ݵ���ʱ��
    FTimeOut: Longword;
    FOnTimeOut: TThreadMethod;
    //�ж��Ƿ�����׽���
    FActive: Boolean;
    FBroadcast: Boolean;
    FProxyInfo: TProxyInfo;
    //ʹ�ô���ʱ�������ӵ�Tcp Socket
    FTcpSocket: TSocket;
    //����������ϵ�Udpӳ���ַ��Ϣ
    FUdpProxyAddr: TSockAddrIn;
    //�õ������û����С�ĺ���
    function GetSendBufSize: Integer;
    function GetRecvBufSize: Integer;
    procedure SetSendBufSize(Value: Integer);
    procedure SetRecvBufSize(Value: Integer);
    procedure SetActive(Value: Boolean);
    procedure SetTimeOut(Value: Longword);
    function InitSocket: Boolean;
    procedure FreeSocket;
    procedure DoActive(Active: boolean);
    procedure DataReceive;
    //���Ӵ��������
    function ConnectToProxy: Boolean;
    //Tcp����
    function Handclasp(Socket: TSocket; AuthenType: TAuthenType): Boolean;
    //����Udpӳ��ͨ��
    function MapUdpChannel(Socket: TSocket): Boolean;
    //ͨ��Proxy��������
    function SendByProxy(Socket: TSocket; var buf; len: Integer; RemoteIP:
      longword;
      RemotePort: Integer): Integer;
    //��Proxy��������
    function RecvByProxy(Socket: TSocket; var buf; len: Integer; RemoteIP:
      longword;
      RemotePort: Integer): Integer;
  protected
    FUdpRecvThread: TLzUDPRecvThread;
  public
    constructor Create;
    destructor Destroy; override;

    //���ͻ���������
    function SendBuf(var Buf; Size: Integer; IP: longword; Port: Integer):
      Boolean;
    //�����ı�
    function SendText(Text: string; IP: longword; Port: integer): Boolean;
    //�������͹㲥��Ϣ�ĺ���
    function BroadcastBuf(var Buf; Size: Integer; Port: Integer): Boolean;
    function BroadcastText(Text: string; Port: Integer): Boolean;
    //���պ���
    function RecvBuf(var Buf; Size: Integer; IP: longword; Port: Integer):
      Integer;
    //���ܵ�Զ�����ݵ�Client��Ϣ
    property PeerInfo: TPeerInfo read FPeerInfo;
    //���ͺͽ��ջ�������С
    property SendBufSize: Integer read GetSendBufSize write SetSendBufSize;
    property RecvBufSize: Integer read GetRecvBufSize write SetRecvBufSize;
    //�����˿�
    property Port: Integer read FPort write FPort;
    //�ȴ����ݳ�ʱ�� Ĭ����$FFFFFFFF;
    property TimeOut: DWORD read FTimeOut write SetTimeOut;
    //���׽���
    property Active: Boolean read FActive write SetActive;
    //�Ƿ���Թ㲥
    property EnableBroadcast: Boolean read FBroadcast write FBroadcast;
    //��������
    property ProxyInfo: TProxyInfo read FProxyInfo write FProxyInfo;
    //�����ݵ�����¼�
    property OnDataRead: TUdpReadEvent read FOnDataRead write FOnDataRead;
    //�׽��ַ��������¼�
    property OnSocketError: TUdpErrorEvent read FOnSocketError write
      FOnSocketError;
    //�������ݷ�����ʱ
    property OnTimeOut: TThreadMethod read FOnTimeOut write FOnTimeOut;
  end;

  TLzUDPRecvThread = class(TThread)
  private
    FSocket: TLzUDPSocket;
    FEvent: WSAEvent;
    //���ܵ����ݵ��¼�
    FOnDataRecv: TThreadMethod;
    procedure InitEvent;
    procedure FreeEvent;
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: Boolean; AUdpSocket: TLzUDPSocket);
    destructor Destroy; override;
    property OnDataRecv: TThreadMethod read FOnDataRecv write FOnDataRecv;
    procedure Stop;
  end;

implementation

{ TLzUDPSocket }

function TLzUDPSocket.BroadcastBuf(var Buf; Size, Port: Integer): Boolean;
var
  ret, ErrorCode: Integer;
  saRemote: TSockAddrIn;
begin
  Result := False;
  saRemote.sin_family := AF_INET;
  saRemote.sin_port := htons(Port);
  saRemote.sin_addr.S_addr := htonl(INADDR_BROADCAST);

  if FProxyInfo.Enabled then
    ret := SendByProxy(FSocket, Buf, Size, saRemote.sin_addr.S_addr,
      ntohs(saRemote.sin_port))
  else
    ret := sendto(FSocket, Buf, Size, 0, saRemote, SizeOf(saRemote));
    
  if ret = SOCKET_ERROR then
  begin
    ErrorCode := GetLastError;
    if ErrorCode <> WSAEWOULDBLOCK then
    begin
      if Assigned(FOnSocketError) then
        FOnSocketError(Self, utSend, ErrorCode);
      if ErrorCode <> 0 then
        raise TUDPException.CreateFmt('�㲥����ʱ������������%d',
          [ErrorCode]);
    end;
  end
  else
    Result := True;
end;

function TLzUDPSocket.BroadcastText(Text: string; Port: Integer): Boolean;
begin
  Result := BroadcastBuf(Text[1], Length(Text), Port);
end;

constructor TLzUDPSocket.Create;
var
  WSAData: TWSAData;
begin
  FActive := False;
  FPort := 0;
  FillChar(FPeerInfo, SizeOf(TPeerInfo), 0);
  FSendBufSize := DEFAULT_SENDBUF_SIZE;
  FRecvBufSize := DEFAULT_RECVBUF_SIZE;
  FSocket := INVALID_SOCKET;
  FUdpRecvThread := nil;
  FTimeOut := $FFFFFFFF;
  FBroadcast := False;
  FTcpSocket := INVALID_SOCKET;
  if WSAStartup(MakeWord(2, 2), WSAData) <> 0 then
    raise TUDPException.Create('��������ҪWinSock2���û����ϵ�Socket�汾̫��!');
end;

destructor TLzUDPSocket.Destroy;
begin
  if FActive then
    DoActive(False);

  if FTcpSocket <> INVALID_SOCKET then
    closesocket(FTcpSocket);

  if WSACleanup <> 0 then
    MessageBox(0, 'Socket����ʧ��!', '����', MB_OK + MB_ICONERROR);

  inherited Destroy;
end;

procedure TLzUDPSocket.DoActive(Active: boolean);
var
  ErrorCode: Integer;
begin
  if Active = True then
  begin
    if InitSocket then
    begin
      FActive := True;
      try
        SetSendBufSize(FSendBufSize);
        SetRecvBufSize(FRecvBufSize);
        FUdpRecvThread := TLzUDPRecvThread.Create(True, Self);
        FUdpRecvThread.FOnDataRecv := DataReceive;
        FUdpRecvThread.Resume;
      except
        DoActive(False);
        raise TUDPException.Create('���������̷߳�������!');
      end;
    end
    else
    begin
      ErrorCode := GetLastError;
      if Assigned(FOnSocketError) then
        FOnSocketError(Self, utInit, ErrorCode);
      if ErrorCode <> 0 then
        raise TUDPException.CreateFmt('��ʼ���׽��ַ������󣬴�������%d',
          [ErrorCode]);
    end;
  end
  else // �ر��׽���
  begin
    if Assigned(FUDPRecvThread) then
    begin
      FUdpRecvThread.Stop;
      FreeAndNil(FUDPRecvThread);
    end;
    FreeSocket;
    FActive := False;
  end;
end;

procedure TLzUDPSocket.FreeSocket;
begin
  if FSocket <> INVALID_SOCKET then
  begin
    closesocket(FSocket);
    FSocket := INVALID_SOCKET;
  end;
  if FTcpSocket <> INVALID_SOCKET then
  begin
    closesocket(FTcpSocket);
    FTcpSocket := INVALID_SOCKET;
  end;
end;

function TLzUDPSocket.GetRecvBufSize: Integer;
begin
  Result := FRecvBufSize;
end;

function TLzUDPSocket.GetSendBufSize: Integer;
begin
  Result := FSendBufSize;
end;

function TLzUDPSocket.InitSocket: Boolean;
var
  saLocal: TSockAddrIn;
  bReLinten: Boolean;
  i: Integer;
begin
  result := false;
  FSocket := WSASocket(AF_INET, SOCK_DGRAM, 0, nil, 0, WSA_FLAG_OVERLAPPED);
  if FSocket = INVALID_SOCKET then
    Exit;

  //������TIME_WAIT״̬�¿����ٴ�����ͬ�Ķ˿��ϼ���
  {
  if FPort = 0 then
  begin
    Result:= True;
    Exit;
  end;
  }

  bReLinten := True;
  if setsockopt(FSocket, SOL_SOCKET, SO_REUSEADDR, @bReLinten, SizeOf(bReLinten))
    <> 0 then
    Exit;

  if setsockopt(FSocket, SOL_SOCKET, SO_BROADCAST, @FBroadcast, SizeOf(Integer))
    <> 0 then
    Exit;

  saLocal.sin_family := AF_INET;
  saLocal.sin_port := htons(FPort);
  saLocal.sin_addr.S_addr := INADDR_ANY;

  if bind(FSocket, @saLocal, SizeOf(saLocal)) = SOCKET_ERROR then
  begin
    FreeSocket;
    Exit;
  end;

  i := SizeOf(saLocal);
  GetSockName(FSocket, saLocal, i);
  FPort := ntohs(saLocal.sin_port);

  //�д���ʱ���Ƚ���Udpӳ��ͨ��
  if FProxyInfo.Enabled then
  begin
    if not ConnectToProxy then
      Exit;
  end;

  Result := True;
end;

procedure TLzUDPSocket.DataReceive;
begin
  if Assigned(FOnDataRead) then
    FOnDataRead(Self, FPeerInfo);
end;

function TLzUDPSocket.RecvBuf(var Buf; Size: Integer; IP: longword; Port:
  Integer): integer;
var
  saRemote: TSockAddrIn;
  ret, fromlen: Integer;
  ErrorCode: Integer;
begin
  Result := 0;
  saRemote.sin_family := AF_INET;
  saRemote.sin_addr.S_addr := IP;
  saRemote.sin_port := htons(Port);
  fromlen := SizeOf(saRemote);

  if FProxyInfo.Enabled then
    ret := RecvByProxy(FSocket, Buf, Size, IP, Port)
  else
    ret := recvfrom(FSocket, Buf, Size, 0, saRemote, fromlen);

  with FPeerInfo do
  begin
    PeerIP := saRemote.sin_addr.S_addr;
    PeerPort := ntohs(saRemote.sin_port);
  end;

  if ret = SOCKET_ERROR then
  begin
    ErrorCode := GetLastError;
    if (ErrorCode <> WSAEWOULDBLOCK)
      and (ErrorCode <> WSAECONNRESET) then //������connection reset by peer����
    begin
      if Assigned(FOnSocketError) then
        FOnSocketError(Self, utRecv, ErrorCode);
      if ErrorCode <> 0 then
        raise TUDPException.CreateFmt('�������ݳ�����������%d', [ErrorCode]);
    end;
  end
  else
    Result := ret;
end;

function TLzUDPSocket.SendBuf(var Buf; Size: Integer; IP: longword; Port:
  Integer): Boolean;
var
  ret, ErrorCode: Integer;
  saRemote: TSockAddrIn;
begin
  Result := False;

  saRemote.sin_family := AF_INET;
  saRemote.sin_port := htons(Port);
  saRemote.sin_addr.S_addr := IP;

  if saRemote.sin_addr.S_addr = INADDR_NONE then
    raise TUDPException.Create('��Ч��Զ��������ַ!');

  if FProxyInfo.Enabled then
    ret := SendByProxy(FSocket, Buf, Size, IP, Port)
  else
    ret := sendto(FSocket, Buf, Size, 0, saRemote, SizeOf(saRemote));

  if ret = SOCKET_ERROR then
  begin
    ErrorCode := GetLastError;
    if ErrorCode <> WSAEWOULDBLOCK then
    begin
      if Assigned(FOnSocketError) then
        FOnSocketError(Self, utSend, ErrorCode);
      if ErrorCode <> 0 then
        raise TUDPException.CreateFmt('��������ʱ������������%d',
          [ErrorCode]);
    end;
  end
  else
    Result := True;
end;

function TLzUDPSocket.SendText(Text:string; IP: longword; Port: integer): Boolean;
begin
  Result := SendBuf(Pointer(Text)^, Length(Text), IP, Port);
end;

procedure TLzUDPSocket.SetActive(Value: Boolean);
begin
  if FActive <> Value then
    DoActive(Value);
end;

procedure TLzUDPSocket.SetRecvBufSize(Value: Integer);
var
  ErrorCode: Integer;
begin
  if FRecvBufSize <> Value then
  begin
    ErrorCode := setsockopt(FSocket, SOL_SOCKET, SO_RCVBUF, @Value,
      sizeof(Value));
    if ErrorCode = SOCKET_ERROR then
      raise TUDPException.CreateFmt('���ý��ջ�����������������%d',
        [GetLastError]);
    FRecvBufSize := Value;
  end;
end;

procedure TLzUDPSocket.SetSendBufSize(Value: Integer);
var
  ErrorCode: Integer;
begin
  if FSendBufSize <> Value then
  begin
    ErrorCode := setsockopt(FSocket, SOL_SOCKET, SO_SNDBUF, @Value,
      sizeof(Value));
    if ErrorCode = SOCKET_ERROR then
      raise TUDPException.CreateFmt('���÷��ͻ��������󡣴�������%d',
        [GetLastError]);
    FSendBufSize := Value;
  end;
end;

procedure TLzUDPSocket.SetTimeOut(Value: Longword);
begin
  if FTimeOut <> Value then
    FTimeOut := Value;
end;

function TLzUDPSocket.ConnectToProxy: Boolean;
var
  saProxy: TSockAddrIn;
  ret: Integer;
  bRet: Boolean;
begin
  //������Proxy��Tcp����
  if FTcpSocket = INVALID_SOCKET then
    FTcpSocket := socket(AF_INET, SOCK_STREAM, 0);

  saProxy.sin_family := AF_INET;
  saProxy.sin_port := htons(FProxyInfo.Port);
  saProxy.sin_addr.S_addr := inet_addr(PChar(FProxyInfo.Address));
  ret := connect(FTcpSocket, @saProxy, SizeOf(saProxy));
  if ret = SOCKET_ERROR then
    raise Exception.CreateFmt('�޷����ӵ��������������������%d',
      [WSAGetLastError]);

  {����������Ƿ���Ҫ�����֤}
  if Trim(FProxyInfo.Username) <> '' then
    bRet := Handclasp(FTcpSocket, atUserPass)
  else
    bRet := Handclasp(FTcpSocket, atNone);

  if not bRet then
  begin
    closesocket(FTcpSocket);
    raise Exception.CreateFmt('��������������֤ʧ��!��������%d',
      [WSAGetLastError]);
  end;

  //����UDPӳ��ͨ��
  if not MapUdpChannel(FTcpSocket) then
  begin
    closesocket(FTcpSocket);
    raise Exception.CreateFmt('�����������֧��UDP!��������%d',
      [WSAGetLastError]);
  end;

  Result := True;
end;

function TLzUDPSocket.Handclasp(Socket: TSocket; AuthenType: TAuthenType):
  Boolean;
var
  Buf: array[0..255] of Byte;
  I, Ret: Integer;
  Username, Password: string;
begin
  Result := False;
  case AuthenType of
    // ������֤
    atNone:
      begin
        Buf[0] := $05;
        Buf[1] := $01;
        Buf[2] := $00;
        Ret := send(Socket, Buf, 3, 0);
        if Ret = -1 then Exit;
        FillChar(Buf, 256, #0);
        Ret := recv(Socket, Buf, 256, 0);
        if Ret < 2 then Exit;
        if Buf[1] <> $00 then Exit;
        Result := True;
      end;
    // �û���������֤
    atUserPass:
      begin
        Buf[0] := $05; // Socks�汾��
        Buf[1] := $02; // ������֤����
        Buf[2] := $00; // ����У��
        Buf[3] := $02; // ���û�������У��
        Ret := send(Socket, Buf, 4, 0);
        if Ret = -1 then Exit;
        FillChar(Buf, 256, #0);
        Ret := recv(Socket, Buf, 256, 0);
        if Ret < 2 then Exit;
        if Buf[1] <> $02 then Exit;
        Username := FProxyInfo.Username;
        Password := FProxyInfo.Password;
        FillChar(Buf, 256, #0);
        Buf[0] := $01;
        Buf[1] := Length(Username);
        for I := 0 to Buf[1] - 1 do
          Buf[2 + I] := Ord(Username[I + 1]);
        Buf[2 + Length(Username)] := Length(Password);
        for I := 0 to Buf[2 + Length(Username)] - 1 do
          Buf[3 + Length(Username) + I] := Ord(Password[I + 1]);
        Ret := send(Socket, Buf, Length(Username) + Length(Password) + 3, 0);
        if Ret = -1 then Exit;
        Ret := recv(Socket, Buf, 256, 0);
        if Ret = -1 then Exit;
        if Buf[1] <> $00 then Exit;
        Result := True;
      end;
  end;
end;

function TLzUDPSocket.MapUdpChannel(Socket: TSocket): Boolean;
var
  saLocal: TSockAddrIn;
  NameLen: Integer;
  ProxyAddr: TInAddr;
  ProxyPort: Word;
  Buf: array[0..255] of Byte;
begin
  Result := False;
  NameLen := SizeOf(saLocal);
  getsockname(FSocket, saLocal, NameLen);
  Buf[0] := $05; //Э��汾Socks5
  Buf[1] := $03; //Socks����:UDP
  Buf[2] := $00; //����
  Buf[3] := $01; //��ַ����IPv4
  CopyMemory(@Buf[4], @saLocal.sin_addr, 4);
  CopyMemory(@Buf[8], @saLocal.sin_port, 2);
  send(Socket, Buf, 10, 0);
  FillChar(Buf, 256, #0);
  recv(Socket, Buf, 256, 0);
  if (Buf[0] <> $05) and (Buf[1] <> $00) then
    Exit;
  CopyMemory(@ProxyAddr, @Buf[4], 4); //��ȡProxy��ӳ���ַ
  CopyMemory(@ProxyPort, @Buf[8], 2); //��ȡProxy��ӳ��˿ں�

  FUdpProxyAddr.sin_family := AF_INET;
  FUdpProxyAddr.sin_port := ProxyPort;
  FUdpProxyAddr.sin_addr := ProxyAddr;

  Result := True;
end;

function TLzUDPSocket.SendByProxy(Socket: TSocket; var buf; len: Integer;
  RemoteIP: longword; RemotePort: Integer): Integer;
var
  TempBuf: array[0..1023] of Byte;
  saRemote: TSockAddrIn;
begin
  saRemote.sin_family := AF_INET;
  saRemote.sin_port := htons(RemotePort);
  saRemote.sin_addr.S_addr := RemoteIP;
  // ���ϱ�ͷ
  FillChar(TempBuf, 1023, $0);
  TempBuf[0] := $00; //����
  TempBuf[1] := $00; //����
  TempBuf[2] := $00; //�Ƿ�ֶ�����(�˴�����)
  TempBuf[3] := $01; //IPv4
  CopyMemory(@TempBuf[4], @saRemote.sin_addr, 4); //�����������ַ
  CopyMemory(@TempBuf[8], @saRemote.sin_port, 2); //����������˿�
  CopyMemory(@TempBuf[10], @buf, len); //ʵ������
  Result := sendto(Socket, TempBuf, len + 10, 0, FUdpProxyAddr,
    SizeOf(FUdpProxyAddr));
  if Result = SOCKET_ERROR then
    raise Exception.CreateFmt('�������ݴ���!�������%d', [WSAGetLastError]);
end;

function TLzUDPSocket.RecvByProxy(Socket: TSocket; var buf; len: Integer;
  RemoteIP: longword; RemotePort: Integer): Integer;
var
  TempBuf: array[0..1023] of Byte;
  saRemote: TSockAddrIn;
  fromlen: Integer;
begin
  FillChar(TempBuf, 1024, #0);
  saRemote.sin_family := AF_INET;
  saRemote.sin_port := htons(RemotePort);
  saRemote.sin_addr.S_addr := RemoteIP;
  fromlen := SizeOf(saRemote);
  Result := recvfrom(Socket, TempBuf, len, 0, saRemote, fromlen);
  if Result = SOCKET_ERROR then
    raise Exception.CreateFmt('�������ݴ���!�������%d', [WSAGetLastError]);
  Assert(TempBuf[0] = $00); //����
  Assert(TempBuf[1] = $00); //����
  Assert(TempBuf[2] = $00); //�Ƿ�ֶ�����
  Assert(TempBuf[3] = $01); //IPv4
  CopyMemory(@saRemote.sin_addr, @TempBuf[4], 4); //�����������ַ
  CopyMemory(@saRemote.sin_port, @TempBuf[8], 2); //����������˿�
  CopyMemory(@buf, @TempBuf[10], len); //ʵ������
end;

{ TLzUDPRecvThread }

constructor TLzUDPRecvThread.Create(CreateSuspended: Boolean; AUdpSocket:
  TLzUDPSocket);
begin
  inherited Create(CreateSuspended);
  FSocket := AUDPSocket;
  FEvent := WSA_INVALID_EVENT;
  InitEvent;
end;

destructor TLzUDPRecvThread.Destroy;
begin
  if not Terminated then
    Stop;
  FreeEvent;
  inherited Destroy;
end;

procedure TLzUDPRecvThread.Execute;
var
  ErrorCode: Integer;
begin
  while not Terminated do
  begin
    ErrorCode := WSAWaitForMultipleEvents(
      1, //�¼�����
      @FEvent, //�¼�������
      False, //��һ���¼�����ʱ�ͷ���
      FSocket.FTimeOut, // ��ʱʱ��
      False //��������ʱ����ִ��I/O����
      );

    if Terminated then
      Break;

    if ErrorCode = WAIT_IO_COMPLETION then
    begin
      Break;
    end
    else
    begin
      WSAResetEvent(FEvent);
      if ErrorCode = WSA_WAIT_TIMEOUT then
      begin
        if Assigned(FSocket.FOnTimeOut) then
          FSocket.FOnTimeOut;
//          Synchronize(FSocket.FOnTimeOut);
      end
      else
        if Assigned(FOnDataRecv) then
          FOnDataRecv;
//          Synchronize(FOnDataRecv);
    end;
  end;
end;

procedure TLzUDPRecvThread.FreeEvent;
begin
  if FEvent <> WSA_INVALID_EVENT then
    WSACloseEvent(FEvent);
end;

procedure TLzUDPRecvThread.InitEvent;
var
  ErrorCode: Integer;
begin
  FEvent := WSACreateEvent;
  if FEvent = WSA_INVALID_EVENT then
    raise TUDPException.CreateFmt('�����׽����¼����������������%d',
      [WSAGetLastError]);

  ErrorCode := WSAEventSelect(FSocket.FSocket, FEvent, FD_READ);
  if ErrorCode = SOCKET_ERROR then
    raise TUDPException.CreateFmt('�����׽����¼����������������%d',
      [WSAGetLastError]);
end;

procedure TLzUDPRecvThread.Stop;
begin
  Terminate;
  SetEvent(FEvent);
  WaitFor;
end;

end.

