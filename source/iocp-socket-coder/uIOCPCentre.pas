unit uIOCPCentre;

interface

uses
  iocpTcpServer, uBuffer, SysUtils, Classes;

type
  TIOCPDecoder = class(TObject)
  public
    /// <summary>
    ///   �����յ�������,����н��յ�����,���ø÷���,���н���
    /// </summary>
    /// <returns>
    ///   ���ؽ���õĶ���
    /// </returns>
    /// <param name="inBuf"> ���յ��������� </param>
    function Decode(const inBuf: TBufferLink): TObject; virtual; abstract;
  end;

  TIOCPDecoderClass = class of TIOCPDecoder;

  TIOCPEncoder = class(TObject)
  public
    /// <summary>
    ///   ����Ҫ���͵Ķ���
    /// </summary>
    /// <param name="pvDataObject"> Ҫ���б���Ķ��� </param>
    /// <param name="ouBuf"> ����õ����� </param>
    procedure Encode(pvDataObject:TObject; const ouBuf: TBufferLink); virtual;
        abstract;
  end;

  TIOCPEncoderClass = class of TIOCPEncoder;

  TIocpSendRequest = class(iocpTcpServer.TIocpSendRequest)
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
    procedure setBufferLink(pvBufferLink:TBufferLink);
  end;




  TIOCPClientContext = class(iocpTcpServer.TiocpClientContext)
  private
    FrecvBuffers: TBufferLink;
    FStateINfo: String;
    function GetStateINfo: String;

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
    ///   ���ݴ���
    /// </summary>
    /// <param name="pvDataObject"> (TObject) </param>
    procedure dataReceived(const pvDataObject:TObject); virtual;
    /// <summary>
    ///   �����ݷ��ظ��ͻ���
    /// </summary>
    /// <param name="pvDataObject"> (TObject) </param>
    procedure writeObject(const pvDataObject:TObject);

    /// <summary>
    ///   ���ܵ�Buffer
    /// </summary>
    property Buffers: TBufferLink read FrecvBuffers;
    //״̬��Ϣ
    property StateINfo: String read GetStateINfo write FStateINfo;
  end;



  TOnDataObjectReceived = procedure(pvClientContext:TIocpClientContext;pvObject:TObject) of object;


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
    ///   ע�������
    /// </summary>
    /// <param name="pvDecoder"> (TIOCPDecoder) </param>
    procedure registerDecoder(pvDecoder:TIOCPDecoder);

    /// <summary>
    ///   ע�������
    /// </summary>
    /// <param name="pvEncoder"> (TIOCPEncoder) </param>
    procedure registerEncoder(pvEncoder:TIOCPEncoder);

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

constructor TIOCPClientContext.Create;
begin
  inherited Create;
  FrecvBuffers := TBufferLink.Create();
end;

destructor TIOCPClientContext.Destroy;
begin
  FrecvBuffers.Free;
  inherited Destroy;
end;

procedure TIOCPClientContext.add2Buffer(buf: PAnsiChar; len: Cardinal);
begin
  //���뵽�׽��ֶ�Ӧ�Ļ���
  FrecvBuffers.AddBuffer(buf, len);
end;

procedure TIOCPClientContext.clearRecvedBuffer;
begin
  if FrecvBuffers.validCount = 0 then
  begin
    FrecvBuffers.clearBuffer;
  end else
  begin
    FrecvBuffers.clearHaveReadBuffer;
  end;
end;

procedure TIOCPClientContext.dataReceived(const pvDataObject:TObject);
begin

end;

function TIOCPClientContext.decodeObject: TObject;
begin
  Result := TIocpConsole(Owner).FDecoder.Decode(FrecvBuffers);
end;

function TIOCPClientContext.GetStateINfo: String;
begin
  Result := FStateINfo;
end;

procedure TIOCPClientContext.OnRecvBuffer(buf: Pointer; len: Cardinal;
  ErrCode: WORD);
begin
  recvBuffer(buf, len);
end;

procedure TIOCPClientContext.recvBuffer(buf:PAnsiChar; len:Cardinal);
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
        try
          self.StateINfo := '����ɹ�,׼������dataReceived�����߼�����';


          if Assigned(TIOCPConsole(Owner).FOnDataObjectReceived) then
            TIOCPConsole(Owner).FOnDataObjectReceived(Self, lvObject);


          //����ɹ�������ҵ���߼��Ĵ�����
          dataReceived(lvObject);

          self.StateINfo := 'dataReceived�߼��������!';
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
  clearRecvedBuffer;
end;

procedure TIOCPClientContext.writeObject(const pvDataObject:TObject);
var
  lvOutBuffer:TBufferLink;
  lvRequest:TIocpSendRequest;
begin
  lvOutBuffer := TBufferLink.Create;
  try
    TIocpConsole(Owner).FEncoder.Encode(pvDataObject, lvOutBuffer);
  except
    lvOutBuffer.Free;
    raise;
  end;

  lvRequest := TIocpSendRequest(getSendRequest);
  lvRequest.setBufferLink(lvOutBuffer);


  postSendRequest(lvRequest);

  self.StateINfo := 'TIOCPClientContext.writeObject,Ͷ�ݵ����ͻ���';

end;

constructor TIOCPConsole.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FClientContextClass := TIOCPClientContext;
  FIocpSendRequestClass := TIocpSendRequest;
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

constructor TIocpSendRequest.Create;
begin
  inherited Create;
  FBlockSize := 0;

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
