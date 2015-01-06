unit uDIUdpServerEngine;

interface

uses
  Windows,
  Sysutils,
  WinSock2,
  uDIBuffer,
  uDIProtocol,
  uDIMapBuffer,
  uDIPoolBuffer,
  uDISocketEngine,
  uIOCompletionPort;
  {$I IOCP.inc}
  
type

  TDIUdpServerEngine = class(TDISocketEngine)
  private
    m_dLastTime:            DWORD;  // ��¼ʱ��
    m_iInitPostRecvBuffer:  DWORD;  // ���ֽ��յ�Buffer����
  public
    // ����Buffer
    function AllocateBuffer: TDIBuffer; override;
    // ����Buffer
    function ReleaseBuffer(FBuffer: TDIBuffer; m_bAcceptEx: Boolean = FALSE): Boolean; override;
    // �ͷ�����Buffer
    procedure FreeAllBuffers;
    // �ͷ�ϵͳ�ڴ���Դ
    procedure FreeAllPhysicsMemory; override;
  protected
    // �����׽���, ��������
    function ListnerStart: Boolean;
  public
    // ��������Ϣ������
    // Ͷ��Recv I/O ��Ϣ
    function PostWSARecvEvent(FDIClientContext: TDIClientContext; FRecvBuffer: TDIBuffer): Boolean; override;
    // ����Ͷ�ݵ�Recv I/O ��Ϣ
    function OnWSARecv(FDIClientContext: TDIClientContext; FRecvBuffer: TDIBuffer; dwIoSize: DWORD): Boolean;

    // Ͷ��Send I/O ��Ϣ
    function PostWSASendEvent(FDIClientContext: TDIClientContext; FSendBuffer: TDIBuffer): Boolean; override;
    // ����Ͷ�ݵ�Send I/O ��Ϣ
    function OnWSASend(FDIClientContext: TDIClientContext; FSendBuffer: TDIBuffer; dwIoSize: DWORD): Boolean;

 public
    procedure ProcessIOError(FIOEventType: IO_POST_EVENT_TYPE; FDIClientContext: TDIClientContext); override;
    procedure ProcessIOMessage(FIOEventType: IO_POST_EVENT_TYPE; FDIClientContext: TDIClientContext; FBuffer: TDIBuffer; dwIoSize: DWORD); override;

 public
    constructor Create(IOCompletionPort: TIOCompletionPort);
    destructor Destroy; override;
    function StartServer( nPort: Integer;
                          iMaxNumConnections: DWORD;
                          iMaxNumberOfFreeContext: DWORD;
                          iMaxNumberOfFreeBuffer: DWORD;
                          StartEngine: TENGINE_START_TYPE = SERVER_ENGINE_START ): Boolean;  override;
		procedure StopServer; override;
  end;

implementation
  uses uDIResourceStr, uGlobalLogger, uIOCPMonitor;
  

// TDIUdpServerEngine
constructor TDIUdpServerEngine.Create(IOCompletionPort: TIOCompletionPort);
begin
  inherited Create;
  m_IOCompletionPort := IOCompletionPort;
end;

destructor TDIUdpServerEngine.Destroy;
begin
  inherited Destroy;
end;

function TDIUdpServerEngine.ListnerStart: Boolean;
var
  I: Integer;
  FRecvBuffer: TDIBuffer;
begin
  if not FWinSocket.CreateUDPOverlapSocket(m_sListenSocket) then begin

    {$IFDEF _ICOP_DEBUGERR}
        _GlobalLogger.AppendErrorLogMessage('���� Socket�����װ���ʧ��: %d.', [WSAGetLastError()]);
    {$ENDIF}
    Result := FALSE;
    Exit;
  end;

  if not FWinSocket.SetSocketReUseAddr(m_sListenSocket) then begin
  
    {$IFDEF _ICOP_DEBUGERR}
        _GlobalLogger.AppendErrorLogMessage('���ö˿ڸ���setsockopt(SO_EXCLUSIVEADDRUSE) ����ʧ��: %d.', [WSAGetLastError()]);
    {$ENDIF}
    FWinSocket.CloseWinSocket(m_sListenSocket);
    Result := FALSE;
    Exit;
  end;

  // ���׽���
  if not FWinSocket.BindSocket(m_sListenSocket, m_nPort) then begin

    {$IFDEF _ICOP_DEBUGERR}
        _GlobalLogger.AppendErrorLogMessage('���׽��� bind() ����ʧ��: %d.', [WSAGetLastError()]);
    {$ENDIF}
    Result := FALSE;
    Exit;
  end;

  // ���ô�С
  FWinSocket.SetUDPSocketSize(m_sListenSocket, 1024*40);

  // �������׽��ֹ�������ɶ˿ڣ�ע�⣬����Ϊ�����ݵ�CompletionKeyΪ0
  m_IOCompletionPort.AssociateSocketWithCompletionPort(m_sListenSocket, DWORD(0));

  // Ͷ��Recv /IO
  for I:=1 to m_iMaxNumConnections-1 do begin
    FRecvBuffer := AllocateBuffer;

    if FRecvBuffer<>nil then begin
      FRecvBuffer.m_Socket := m_sListenSocket;
      PostWSARecv(FRecvBuffer.m_Socket, FRecvBuffer, PROTOOOL_UDP);
    end;
  end;
  
  // ������������ ���㳬ʱʱ��
  m_bAcceptConnections := TRUE;
  m_dLastTime := GetTickCount;
	Result := TRUE;
end;

function TDIUdpServerEngine.AllocateBuffer: TDIBuffer;
var
  pBuffer: TDIBuffer;
begin
  Result := nil;

  pBuffer := FPoolDIBuffer.AllocateFreeBufferFromPool;
  if (pBuffer <>nil) then begin
    if FMapBuffer.AddDIBuffer(pBuffer) then begin
    
      {$IFDEF _ICOP_DEBUG}
          _GlobalLogger.AppendErrorLogMessage('AllocateBuffer MapID is %d', [pBuffer.m_MapID]);
      {$ENDIF}
      Result := pBuffer;
      Exit;
    end
    else
    begin
      FPoolDIBuffer.ReleaseBufferToPool(pBuffer);
      {$IFDEF _ICOP_DEBUGERR}
          _GlobalLogger.AppendErrorLogMessage(IOCP_ERROR_ALLOCATE_BUFFER, []);
      {$ENDIF}
    end;
  end;
end;

function TDIUdpServerEngine.ReleaseBuffer(FBuffer: TDIBuffer; m_bAcceptEx: Boolean = FALSE): Boolean;  
{$IFDEF _ICOP_DEBUGERR}
var
  sMsg: String;
{$ENDIF}
begin
  Result := FALSE;
  if Assigned(FBuffer) then begin

    {$IFDEF _ICOP_DEBUGERR}
       case FBuffer.GetOperation of
         IO_INITIALIZE:      sMsg := 'IO_INITIALIZE';
         IO_WSA_ACCEPTEX:    sMsg := 'IO_WSA_ACCEPTEX';
         IO_WSA_RECV:        sMsg := 'IO_WSA_RECV';
         IO_WSA_SEND:        sMsg := 'IO_WSA_SEND';
         IO_WSA_CLOSESOCKET: sMsg := 'IO_WSA_CLOSESOCKET';
       end;
    {$ENDIF}

    Result := FMapBuffer.RemoveDIBuffer(FBuffer);
    
    {$IFDEF _ICOP_DEBUG}
      if not Result then
         _GlobalLogger.AppendErrorLogMessage('ReleaseBuffer Error, MapID is %d', [FBuffer.m_MapID]);
    {$ENDIF}

    if Result then
      FPoolDIBuffer.ReleaseBufferToPool(FBuffer);
  end;
end;

procedure TDIUdpServerEngine.FreeAllBuffers;
begin
  // �ͷ��ڴ����Buffer
  {$IFDEF _ICOP_DEBUG}
      _GlobalLogger.AppendLogMessage('FPoolDIBuffer.FreeBuffers�����ͷ��ڴ�, ����: %d.',
                                   [FPoolDIBuffer.GetBufferCount]);
  {$ENDIF}
  FPoolDIBuffer.FreeBuffers;
end;  

procedure TDIUdpServerEngine.FreeAllPhysicsMemory;
begin
  FreeAllBuffers;
end;

procedure TDIUdpServerEngine.ProcessIOError(FIOEventType: IO_POST_EVENT_TYPE; FDIClientContext: TDIClientContext);
begin
end;

procedure TDIUdpServerEngine.ProcessIOMessage(FIOEventType: IO_POST_EVENT_TYPE; FDIClientContext: TDIClientContext; FBuffer: TDIBuffer; dwIoSize: DWORD);
begin
  case FIOEventType of
	  IO_WSA_RECV: OnWSARecv(FDIClientContext, FBuffer, dwIoSize);
	  IO_WSA_SEND: OnWSASend(FDIClientContext, FBuffer, dwIoSize);
  end;
end;

function TDIUdpServerEngine.PostWSARecvEvent(FDIClientContext: TDIClientContext; FRecvBuffer: TDIBuffer): Boolean;
var
  dwIOStatus: IO_RECV_STATUS;
begin
  Result := FALSE;


  if Assigned(FRecvBuffer) and (not m_bEngineShutDown) then begin

    // Ͷ��һ��RECV I/O Buffer
    dwIOStatus := PostWSARecv(FRecvBuffer.m_socket, FRecvBuffer, PROTOOOL_UDP);
    {$IFDEF _ICOP_DEBUGERR}
            case dwIOStatus of
              IO_RECV_WOULDBLOCK:
                _GlobalLogger.AppendErrorLogMessage(IOCP_ERROR_IO_RECV_WOULDBLOCK, [0, 0]);
              IO_RECV_CLOSED:
                _GlobalLogger.AppendErrorLogMessage(IOCP_ERROR_IO_RECV_CLOSED, [0, 0]);
              IO_RECV_RESET:
                _GlobalLogger.AppendErrorLogMessage(IOCP_ERROR_IO_RECV_RESET, [0, 0]);
              IO_RECV_ERROR:
                _GlobalLogger.AppendErrorLogMessage(IOCP_ERROR_IO_RECV_ERROR, [0, 0]);
            end;
    {$ENDIF}

    if ( (dwIOStatus <> IO_RECV_SUCCESS) and
         (dwIOStatus <> IO_RECV_IO_PENDING) and
         (dwIOStatus <> IO_RECV_WOULDBLOCK) ) then begin
      // ����RECV Buffer
      ReleaseBuffer(FRecvBuffer);
    end
    else
    begin
      Result := TRUE;

      // ���ܷ����� ������ɶ˿���Recv I/O����
      {$IFDEF _IOCP_MONITOR}
          _IOCPMonitor.AddIOCPRecv;
      {$ENDIF}
    end;
  end;
end;

function TDIUdpServerEngine.OnWSARecv(FDIClientContext: TDIClientContext; FRecvBuffer: TDIBuffer; dwIoSize: DWORD): Boolean;
var
  FDIBuffer: TDIBuffer;
begin
  if Assigned(FRecvBuffer) then begin
    FRecvBuffer.SetUsed(dwIoSize);
    if Assigned(OnRecvCompletedEvent) then
      OnRecvCompletedEvent(FDIClientContext, FRecvBuffer, dwIoSize);
  end;

  // Ͷ����һ��
  FDIBuffer := AllocateBuffer;
  FDIBuffer.m_Socket := m_sListenSocket;
  if FDIBuffer<>nil then PostWSARecvEvent(FDIClientContext, FDIBuffer);
  Result := TRUE;
end;


function TDIUdpServerEngine.PostWSASendEvent(FDIClientContext: TDIClientContext; FSendBuffer: TDIBuffer): Boolean;
var
  dwIOStatus: IO_SEND_STATUS;
begin
  Result := FALSE;
  
  if Assigned(FSendBuffer) and (not m_bEngineShutDown) then begin

    // Ͷ��һ��SEND I/O Buffer
    dwIOStatus := PostWSASend(FSendBuffer.m_Socket, FSendBuffer, PROTOOOL_UDP);
    {$IFDEF _ICOP_DEBUGERR}
          case dwIOStatus of
            IO_SEND_WOULDBLOCK:
              _GlobalLogger.AppendErrorLogMessage(IOCP_ERROR_IO_SEND_WOULDBLOCK, [0, 0]);
            IO_SEND_RESET:
              _GlobalLogger.AppendErrorLogMessage(IOCP_ERROR_IO_SEND_RESET, [0, 0]);
            IO_SEND_ERROR:
              _GlobalLogger.AppendErrorLogMessage(IOCP_ERROR_IO_SEND_ERROR, [0, 0]);
          end;
    {$ENDIF}

    if ( (dwIOStatus <> IO_SEND_SUCCESS) and
        (dwIOStatus <> IO_SEND_IO_PENDING) and
        (dwIOStatus <> IO_SEND_WOULDBLOCK) ) then begin

      // ����SEND Buffer
      ReleaseBuffer(FSendBuffer);
    end
    else
    begin
      Result := TRUE;

      // ���ܷ����� ������ɶ˿���Send I/O����
      {$IFDEF _IOCP_MONITOR}
          _IOCPMonitor.AddIOCPSend;
      {$ENDIF}
    end;
  end;
end;

function TDIUdpServerEngine.OnWSASend(FDIClientContext: TDIClientContext; FSendBuffer: TDIBuffer; dwIoSize: DWORD): Boolean;
begin
  if Assigned(FSendBuffer) then begin
    FSendBuffer.SetUsed(dwIoSize);
    if Assigned(OnSendCompletedEvent) then
      OnSendCompletedEvent(FDIClientContext, FSendBuffer, dwIoSize);
  end;

  // ����SEND Buffer
  ReleaseBuffer(FSendBuffer);
  Result := TRUE;
end;

function TDIUdpServerEngine.StartServer( nPort: Integer;
                                         iMaxNumConnections: DWORD;
                                         iMaxNumberOfFreeContext: DWORD;
                                         iMaxNumberOfFreeBuffer: DWORD;
                                         StartEngine: TENGINE_START_TYPE ): Boolean;
var
  bRet: LongBool;
  I: Integer;
  FFreeBuffer: TDIBuffer;
begin
  if (m_bEngineStarted) then begin
    Result := False;
    Exit;
  end;

  m_EngineType := StartEngine;
  _GlobalLogger.AppendDisplayMsg(IOCP_ENGINE_START, [m_sEngineName]);

  // �˿ں�
  m_nPort := nPort;
  // ����m_bShutDown, ����״̬
  m_bEngineShutDown := FALSE;
  m_iNumberOfActiveConnections := 0;	                    // ��ǰ�ͻ������Ӹ�������
  m_iMaxNumConnections := iMaxNumConnections;             // �������ͻ������Ӹ���
  m_iMaxNumberOfFreeContext := iMaxNumberOfFreeContext;   // ���������ĳ�����������
  m_iMaxNumberOfFreeBuffer := iMaxNumberOfFreeBuffer;     // ����Buufer������������
  m_iInitPostRecvBuffer := 100;                           // ����Ͷ�ݵ�Recv����

  // ��ʼ��HasMap����
  if Assigned(OnCreateClientContextEvent) then begin
    FMapClientContext.OnCreateClientContextEvent := OnCreateClientContextEvent;
    FMapClientContext.InitHasTableLength(m_iMaxNumConnections);
  end
  else
  begin
    _GlobalLogger.AppendDisplayMsg('OnCreateClientContextEvent is NULL.', []);
    Result := False;
    Exit;
  end;

  // ����Buffer��
  FPoolDIBuffer.SetMaxFreeBuffer(m_iMaxNumberOfFreeBuffer);
  for I:=1 to m_iMaxNumberOfFreeBuffer do begin
    FFreeBuffer := TDIBuffer.Create;
    FPoolDIBuffer.ReleaseBufferToPool(FFreeBuffer);
  end;


  // ����IOCP���ܼ�����
  {$IFDEF _IOCP_MONITOR}
      _IOCPMonitor.StartMonitor;
     _GlobalLogger.AppendLogMessage('%s',['IOCP���ܼ����������ɹ�.']);
  {$ENDIF}

  bRet := FALSE;
  if m_EngineType = SERVER_ENGINE_START then begin
    // ������������
    bRet := ListnerStart();
    if(bRet) then
      _GlobalLogger.AppendDisplayMsg('%s',['�������������׽�������.'])
    else
    begin
      {$IFDEF _ICOP_DEBUG}
          _GlobalLogger.AppendLogMessage('%s',['ϵͳ�쳣���󣬷������������߳�����ʧ��.']);
      {$ENDIF}
      Result := FALSE;
      Exit;
    end;
  end;

  if m_EngineType = SERVER_ENGINE_START then begin
    if (bRet) then begin
      m_bEngineStarted := TRUE;
      _GlobalLogger.AppendDisplayMsg('IOCP��������������ַ: %s, �˿ں�:%d.', [FWinSocket.GetHostIPAddr(), m_nPort]);
      _GlobalLogger.AppendDisplayMsg('%s',['IOCP�������������ɹ�.']);
    end;
  end
  else            
  begin
    m_bEngineStarted := TRUE;
    m_bAcceptConnections := TRUE;
    _GlobalLogger.AppendDisplayMsg('%s',['IOCP�ͻ��������ɹ�.']);
  end;

  Result := TRUE;
end;


procedure TDIUdpServerEngine.StopServer;
begin
  if (m_bEngineStarted) then begin
    // �Ƿ�����ͻ�������
		m_bAcceptConnections := FALSE;
    {$IFDEF _ICOP_DEBUG}
        _GlobalLogger.AppendLogMessage('%s',['��������״̬m_bAcceptConnections := FALSE.']);
    {$ENDIF}

    // �ر���������
    {$IFDEF _ICOP_DEBUG}
        _GlobalLogger.AppendLogMessage('%s',['�ر����пͻ���DisconnectAllClient�ɹ�.']);
    {$ENDIF}

    Sleep(0);

    // ���ùر�
    m_bEngineShutDown := TRUE;

    if m_EngineType = SERVER_ENGINE_START then begin
      // ֹͣ�����߳�
      {$IFDEF _ICOP_DEBUG}
          _GlobalLogger.AppendLogMessage('%s',['WaitForSingleObject m_hListnerEngineThread.']);
      {$ENDIF}
      // SetEvent(m_hShutdownEvent);
      // Sleep(0);

      // WaitForSingleObject(m_hListnerEngineThread.Handle, INFINITE);
      // m_hListnerEngineThread.Free;
      // CloseHandle(m_hShutdownEvent);
      // m_hShutdownEvent := INVALID_HANDLE_VALUE;
      // CloseHandle(m_hListnerEngineThreadEvent);
      // CloseHandle(m_hPostAcceptEvent);
      // m_hPostAcceptEvent := INVALID_HANDLE_VALUE;

      // �ر������׽���
      {$IFDEF _ICOP_DEBUG}
          _GlobalLogger.AppendLogMessage('%s',['�ر������׽���.']);
      {$ENDIF}
      WinSock2.shutdown(m_sListenSocket, SD_BOTH);
      FWinSocket.CloseWinSocket(m_sListenSocket);
      Sleep(0);
    end;

    // �ر�IOCP���ܼ�����
    {$IFDEF _IOCP_MONITOR}
        _IOCPMonitor.StopMonitor;
        _GlobalLogger.AppendLogMessage('%s',['IOCP���ܼ������رճɹ�.']);
    {$ENDIF}

    m_bEngineStarted := FALSE;
  end;

end;

end.
