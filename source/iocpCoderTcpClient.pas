unit iocpCoderTcpClient;

interface

uses
  iocpTcpClient, uIocpCoder, uBuffer, SysUtils, Classes;

type

  TOnDataObjectReceived = procedure(pvObject:TObject) of object;


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


//
//
//procedure TIOCPClientContext.writeObject(const pvDataObject:TObject);
//var
//  lvOutBuffer:TBufferLink;
//  lvRequest:TIocpSendRequest;
//begin
//  lvOutBuffer := TBufferLink.Create;
//  try
//    TiocpCoderTcpClient(Owner).FEncoder.Encode(pvDataObject, lvOutBuffer);
//  except
//    lvOutBuffer.Free;
//    raise;
//  end;
//
//  lvRequest := TIocpSendRequest(getSendRequest);
//  lvRequest.setBufferLink(lvOutBuffer);
//
//
//  postSendRequest(lvRequest);
//
//  self.StateINfo := 'TIOCPClientContext.writeObject,Ͷ�ݵ����ͻ���';
//
//end;

constructor TiocpCoderTcpClient.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FRecvBufferLink := TBufferLink.Create();
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
  inherited;
  FRecvBufferLink.AddBuffer(buf, len);

  while True do
  begin
    //����ע��Ľ�����<���н���>
    lvObject := FDecoder.Decode(FRecvBufferLink);
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
  lvBufLink:TBufferLink;
begin
  lvBufLink := TBufferLink.Create;
  try
    FEncoder.Encode(pvObject, lvBufLink);

    //lvBufLink.readBuffer()

  finally
    lvBufLink.Free;
  end;

end;

end.
