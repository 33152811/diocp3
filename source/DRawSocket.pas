(*
   unit owner: d10.�����
   a cross platform unit

   2014-11-11 12:59:08
   + add GetIpAddrByName
   thanks for @����-cyw
*)
unit DRawSocket;

interface

uses
  SysUtils
{$IFDEF POSIX}
    , Posix.Base, Posix.SysSocket, Posix.arpainet, Posix.NetinetIn, Posix.UniStd
    , Posix.NetDB
    , Posix.Fcntl
    , Posix.SysSelect
    , Posix.SysTime
{$ELSE}
    , Windows, winsock
{$ENDIF};

{$if CompilerVersion < 23}
type
     NativeUInt = Cardinal;
     IntPtr = Cardinal;
{$ifend}

const
  SOCKET_ERROR   = -1;
  {$EXTERNALSYM SOCKET_ERROR}

{$IFDEF MSWINDOWS}
  SD_RECEIVE = $00;
  {$EXTERNALSYM SD_RECEIVE}
  SD_SEND    = $01;
  {$EXTERNALSYM SD_SEND}
  SD_BOTH    = $02;
  {$EXTERNALSYM SD_BOTH}
{$ENDIF}

type
  TDSocketState = (ssDisconnected, ssConnected, ssConnecting, ssListening, ssAccepting);

  TDRawSocket = class(TObject)
  private
    FSockaddr: sockaddr_in;
    FSocketHandle:THandle;
  public
    procedure CreateTcpSocket;
    procedure CreateUdpSocket;
    function RecvBuf(var data; const len: Cardinal): Integer;
    function SendBuf(const data; const len: Cardinal): Integer;
    function SendBufTo(const data; const len: Integer): Integer;
    function Connect(const pvAddr: string; pvPort: Integer): Boolean;

    /// <summary>
    ///   can send?
    ///  unit 's
    /// </summary>
    function Writeable(pvTimeOut:Integer): Integer;

    /// <summary>
    ///   check can recv
    ///  unit 's
    /// </summary>
    function Readable(pvTimeOut:Integer): Integer;

    /// <summary>
    ///   set NonBlock mode
    /// </summary>
    function SetNonBlock(pvBlock:Boolean): Integer;

    /// <summary>
    ///  resove host
    /// </summary>
    function GetIpAddrByName(const pvHost: string): string;

    /// <summary>
    ///   set recv time out
    ///    unit is ms
    /// </summary>
    function SetReadTimeOut(const pvTimeOut: Cardinal): Integer;


    /// <summary>
    ///   set send time out
    ///    unit is ms
    /// </summary>
    function SetSendTimeOut(const pvTimeOut: Cardinal): Integer;

    procedure Close;

    function IsValidSocketHandle: Boolean;
  public
    property SocketHandle: THandle read FSocketHandle;
  end;


implementation


{$IFDEF MSWINDOWS}
const
  winsocket = 'wsock32.dll';

var
  __WSAStartupDone:Boolean;

{$EXTERNALSYM send}
function send(s: TSocket; const Buf; len, flags: Integer): Integer; stdcall;
  external winsocket name 'send';
{$EXTERNALSYM sendto}
function sendto(s: TSocket; const Buf; len, flags: Integer; var addrto: TSockAddr;
  tolen: Integer): Integer; stdcall; external    winsocket name 'sendto';

/// <summary>
///  compare target, cmp_val same set target = new_val
///    return old value
/// </summary>
function lock_cmp_exchange(cmp_val, new_val: Boolean; var target: Boolean): Boolean;
asm
  lock cmpxchg [ecx], dl
end;

procedure __CheckWSAStartup;
var
  AData: WSAData;
begin
  if lock_cmp_exchange(False, True, __WSAStartupDone) = False then
  begin
    if WSAStartup(MakeWord(1, 1), AData) <> 0 then
    begin
      __WSAStartupDone := false;
      RaiseLastOSError(WSAGetLastError);
    end;
  end;
end;

{$ENDIF}

{$IFDEF POSIX}
function TranslateTInAddrToString(var AInAddr): string;
type
  TIdSunB = packed record
    s_b1, s_b2, s_b3, s_b4: Byte;
  end;

  TIdSunW = packed record
    s_w1, s_w2: Word;
  end;
  PIdIn4Addr = ^TIdIn4Addr;
  TIdIn4Addr = packed record
    case integer of
        0: (S_un_b: TIdSunB);
        1: (S_un_w: TIdSunW);
        2: (S_addr: LongWord);
  end;
begin
  Result := IntToStr(TIdIn4Addr(AInAddr).S_un_b.s_b1) + '.'   {Do not Localize}
            + IntToStr(TIdIn4Addr(AInAddr).S_un_b.s_b2) + '.' {Do not Localize}
            + IntToStr(TIdIn4Addr(AInAddr).S_un_b.s_b3) + '.' {Do not Localize}
            + IntToStr(TIdIn4Addr(AInAddr).S_un_b.s_b4);
end;


function ResolvingHostName(const pvHost: string): string;
var
  LAddrInfo: pAddrInfo;
  LHints: AddrInfo;
  LRetVal: Integer;
  M: TMarshaller;
begin
  //IMPORTANT!!!
  //
  //The Hints structure must be zeroed out or you might get an AV.
  //I've seen this in Mac OS X
  FillChar(LHints, SizeOf(LHints), 0);
  LHints.ai_family := AF_INET;
  LHints.ai_socktype := SOCK_STREAM;
  LAddrInfo := nil;

  LRetVal := getaddrinfo(M.AsAnsi(pvHost).ToPointer, nil, LHints, LAddrInfo);
  if LRetVal <> 0 then
  begin
    if LRetVal = EAI_SYSTEM then
    begin
      RaiseLastOSError;
    end
    else
    begin
      raise Exception.CreateFmt('Error resolving Address %s: %s (%d)',
        [pvHost, gai_strerror(LRetVal), LRetVal]);
    end;
  end;
  try
    Result := TranslateTInAddrToString(PSockAddr_In( LAddrInfo^.ai_addr)^.sin_addr);
  finally
    freeaddrinfo(LAddrInfo^);
  end;
end;

{$ENDIF}

procedure TDRawSocket.Close;
var
  lvTempSocket: THandle;
begin
  lvTempSocket := FSocketHandle;
  ///INVALID_SOCKET
  if lvTempSocket <> INVALID_HANDLE_VALUE then
  begin
    FSocketHandle := INVALID_HANDLE_VALUE;
    {$IFDEF MSWINDOWS}
      shutdown(lvTempSocket, SD_BOTH);
      closesocket(lvTempSocket);
    {$ELSE}
      __close(lvTempSocket);
    {$ENDIF}
  end;
end;

function TDRawSocket.Connect(const pvAddr: string; pvPort: Integer): Boolean;
{$IFDEF POSIX}
{$ELSE}
{$ENDIF}
begin
  FillChar(FSockaddr, SizeOf(sockaddr_in), 0);
  FSockaddr.sin_family := AF_INET;
  FSockaddr.sin_port := htons(pvPort);
{$IFDEF POSIX}
  FSockaddr.sin_addr.s_addr :=inet_addr(MarshaledAString(UTF8Encode(pvAddr)));
  Result := Posix.SysSocket.Connect(FSocketHandle, sockaddr(FSockaddr), sizeof(sockaddr_in))  = 0;
{$ELSE}
  FSockaddr.sin_addr.s_addr :=inet_addr(PAnsichar(AnsiString(pvAddr)));
  Result := winsock.Connect(FSocketHandle, FSockaddr, sizeof(sockaddr_in))  = 0;
{$ENDIF}
end;

procedure TDRawSocket.CreateTcpSocket;
begin
{$IFDEF MSWINDOWS}
  __CheckWSAStartup;
{$ENDIF}
  FSocketHandle := socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
  if FSocketHandle = INVALID_HANDLE_VALUE then
    RaiseLastOSError;
end;

procedure TDRawSocket.CreateUdpSocket;
begin
{$IFDEF MSWINDOWS}
  __CheckWSAStartup;
{$ENDIF}
  FSocketHandle := socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
end;

function TDRawSocket.Readable(pvTimeOut: Integer): Integer;
{$IFDEF POSIX}
var
  lvFDSet:fd_set;
  lvTime_val: timeval;
{$ELSE}
var
  lvFDSet:TFDSet;
  lvTime_val: TTimeval;
{$ENDIF}
begin
{$IFDEF POSIX}
  // not test
  FD_ZERO(lvFDSet);
  _FD_SET(FSocketHandle, lvFDSet);

  lvTime_val.tv_sec := pvTimeOut;
  lvTime_val.tv_usec := 0;
  Result := select(0, @lvFDSet, nil, nil, @lvTime_val);
{$ELSE}
  FD_ZERO(lvFDSet);
  FD_SET(FSocketHandle, lvFDSet);

  lvTime_val.tv_sec := pvTimeOut;
  lvTime_val.tv_usec := 0;
  Result := select(0, @lvFDSet, nil, nil, @lvTime_val);
{$ENDIF}
end;

function TDRawSocket.RecvBuf(var data; const len: Cardinal): Integer;
begin
  Result := recv(FSocketHandle, data, len, 0);
end;

function TDRawSocket.SendBuf(const data; const len: Cardinal): Integer;
begin
  Result := Send(FSocketHandle, data, len, 0);
end;

function TDRawSocket.SendBufTo(const data; const len: Integer): Integer;
begin
{$IFDEF POSIX}
  Result := sendto(FSocketHandle, data, len, 0, sockaddr(FSockaddr), sizeof(sockaddr_in));
{$ELSE}
  Result := sendto(FSocketHandle, data, len, 0, FSockaddr, sizeof(sockaddr_in));
{$ENDIF}
end;

function TDRawSocket.SetReadTimeOut(const pvTimeOut: Cardinal): Integer;
begin
{$IFDEF POSIX}
  // not test
  Result := setsockopt(FSocketHandle,
   SOL_SOCKET, SO_RCVTIMEO, pvTimeOut, SizeOf(Cardinal));
{$ELSE} 
  Result := setsockopt(FSocketHandle,
   SOL_SOCKET, SO_RCVTIMEO, PAnsiChar(@pvTimeOut), SizeOf(Cardinal));
{$ENDIF}
end;


function TDRawSocket.SetSendTimeOut(const pvTimeOut: Cardinal): Integer;
begin
{$IFDEF POSIX}
  // not test
  Result := setsockopt(FSocketHandle,
   SOL_SOCKET, SO_SNDTIMEO, pvTimeOut, SizeOf(Cardinal));
{$ELSE}
  Result := setsockopt(FSocketHandle,
   SOL_SOCKET, SO_SNDTIMEO, PAnsiChar(@pvTimeOut), SizeOf(Cardinal));
{$ENDIF}
end;

function TDRawSocket.Writeable(pvTimeOut:Integer): Integer;
{$IFDEF POSIX}
var
  lvFDSet:fd_set;
  lvTime_val: timeval;
{$ELSE}
var
  lvFDSet:TFDSet;
  lvTime_val: TTimeval;
{$ENDIF}
begin
{$IFDEF POSIX}
  // not test
  FD_ZERO(lvFDSet);
  _FD_SET(FSocketHandle, lvFDSet);

  lvTime_val.tv_sec := pvTimeOut;
  lvTime_val.tv_usec := 0;
  Result := select(0, nil, @lvFDSet, nil, @lvTime_val);
{$ELSE}
  FD_ZERO(lvFDSet);
  FD_SET(FSocketHandle, lvFDSet);

  lvTime_val.tv_sec := pvTimeOut;
  lvTime_val.tv_usec := 0;
  Result := select(0, nil, @lvFDSet, nil, @lvTime_val);
{$ENDIF}

end;

function TDRawSocket.GetIpAddrByName(const pvHost: string): string;
{$IFDEF POSIX}
{$ELSE}
var
  lvhostInfo: PHostEnt;
{$ENDIF}
begin
{$IFDEF POSIX}
  Result := ResolvingHostName(pvHost);
{$ELSE}
  lvhostInfo := gethostbyname(PAnsiChar(AnsiString(pvHost)));
  if lvhostInfo = nil then
    RaiseLastOSError;

  Result := inet_ntoa(PInAddr(lvhostInfo^.h_addr_list^)^);
{$ENDIF}
end;

function TDRawSocket.IsValidSocketHandle: Boolean;
begin
   Result := FSocketHandle <> INVALID_HANDLE_VALUE;
end;

function TDRawSocket.SetNonBlock(pvBlock:Boolean): Integer;
{$IFDEF POSIX}
{$ELSE}
var
  lvFlag : Integer;
{$ENDIF}
begin
{$IFDEF POSIX}
  // not test
  if pvBlock then
  begin
    Result := fcntl(FSocketHandle, F_SETFL, O_SYNC);
  end else
  begin
    Result := fcntl(FSocketHandle, F_SETFL, O_NONBLOCK);
  end;
{$ELSE}
  if pvBlock then lvFlag := 0 else lvFlag := 1;
  Result := ioctlsocket(SocketHandle, FIONBIO, lvFlag);
{$ENDIF}

end;






initialization
{$IFDEF MSWINDOWS}

{$ENDIF}

end.
