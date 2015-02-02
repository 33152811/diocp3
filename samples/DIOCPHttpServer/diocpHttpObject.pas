(*
 *	 Unit owner: D10.Mofen, delphi iocp framework author
 *         homePage: http://www.Diocp.org
 *	       blog: http://www.cnblogs.com/dksoft
 *
 *    HttpЭ�鴦��Ԫ
 *    ���д󲿷�˼·������delphi iocp framework�е�iocp.HttpServer
 *
*)
unit DiocpHttpObject;

interface

uses
  Classes, StrUtils, SysUtils, uBuffer,
  iocpTcpServer;

type
  TDiocpHttpState = (hsCompleted, hsRequest{��������}, hsRecvingPost{��������});
  TDiocpHttpResponse = class;
  TDiocpHttpClientContext = class;

  TDiocpHttpRequest = class(TObject)
  private
    FDiocpContext:TDiocpHttpClientContext;

    /// ͷ��Ϣ
    FHttpVersion: Word;  // 10, 11
    FRequestVersionStr:string;

    FRequestMethod: string;
    FRequestUrl: String;
    FRequestParams: String;

    FContextType  : string;
    FContextLength: Int64;
    FKeepAlive    : Boolean;
    FRequestAccept: String;
    FRequestReferer:String;
    FRequestAcceptLanguage:string;
    FRequestAcceptEncoding:string;
    FRequestUserAgent:string;
    FRequestAuth:string;
    FRequestCookies:string;
    FRequestHostName:string;
    FRequestHostPort:string;
    FXForwardedFor:string;



    FRawHttpData: TMemoryStream;

    FRawPostData : TMemoryStream;
    FPostDataLen :Integer;

    FRequestHeader: TStringList;

    FResponse: TDiocpHttpResponse;


    /// <summary>
    ///   �Ƿ���Ч��Http ���󷽷�
    /// </summary>
    /// <returns>
    ///   0: ���ݲ��㹻���н���
    ///   1: ��Ч������ͷ
    ///   2: ��Ч����������ͷ
    /// </returns>
    function DecodeHttpRequestMethod: Integer;

    /// <summary>
    ///   ����Http���������Ϣ
    /// </summary>
    /// <returns>
    ///   1: ��Ч��Http��������
    /// </returns>
    function DecodeHttpRequestParams: Integer;

    /// <summary>
    ///   ���յ���Buffer,д������
    /// </summary>
    procedure WriteRawBuffer(const Buffer: Pointer; len: Integer);
  protected
    function MakeHeader(const Status, ContType, Header: string; pvContextLength:
        Integer): string;
  public
    constructor Create;
    destructor Destroy; override;

    /// <summary>
    ///   ����
    /// </summary>
    procedure Clear;

    property RequestHeader: TStringList read FRequestHeader;
    property RequestUrl: String read FRequestUrl;
    /// <summary>
    ///  Http��Ӧ���󣬻�д����
    /// </summary>
    property Response: TDiocpHttpResponse read FResponse;

    /// <summary>
    ///   Ӧ����ϣ����ͻ�ͻ���
    /// </summary>
    procedure ResponseEnd;


    procedure CloseContext;

  end;

  TDiocpHttpResponse = class(TObject)
  private
    FResponseHeader:string;
    FContentType: String;
    FData: TMemoryStream;
  public
    procedure Clear;
    constructor Create;
    destructor Destroy; override;
    procedure WriteBuf(pvBuf:Pointer; len:Cardinal);
    procedure WriteString(pvString:string);

    property ContentType: String read FContentType write FContentType;
  end;

  /// <summary>
  ///   Http �ͻ�������
  /// </summary>
  TDiocpHttpClientContext = class(TIocpClientContext)
  private
    FHttpState: TDiocpHttpState;
    FRequest: TDiocpHttpRequest;
  public
    constructor Create; override;
    destructor Destroy; override;
  protected
    /// <summary>
    ///   �黹������أ�����������
    /// </summary>
    procedure DoCleanUp; override;

    /// <summary>
    ///   ���յ��ͻ��˵�HttpЭ������, ���н����TDiocpHttpRequest����ӦHttp����
    /// </summary>
    procedure OnRecvBuffer(buf: Pointer; len: Cardinal; ErrCode: WORD); override;
  end;


  {$IFDEF UNICODE}
  /// <summary>
  ///  ��Ӧ����
  /// </summary>
  TOnDiocpHttpRequest = reference to procedure (pvRequest:TDiocpHttpRequest);
  {$ELSE}
  /// <summary>
  ///  ��Ӧ����
  /// </summary>
  TOnDiocpHttpRequest = procedure(pvRequest:TDiocpHttpRequest) of object;
  {$ENDIF}


  /// <summary>
  ///   Http ��������
  /// </summary>
  TDiocpHttpServer = class(TIocpTcpServer)
  private
    FOnDiocpHttpRequest: TOnDiocpHttpRequest;

    /// <summary>
    ///   ��ӦHttp���� ִ����Ӧ�¼�
    /// </summary>
    procedure DoRequest(pvRequest:TDiocpHttpRequest);
  public
    constructor Create(AOwner: TComponent); override;

    /// <summary>
    ///   ��ӦHttp�����¼�
    /// </summary>
    property OnDiocpHttpRequest: TOnDiocpHttpRequest read FOnDiocpHttpRequest write
        FOnDiocpHttpRequest;
  end;

implementation

//delphi ����ٱ��� URLDecode URLEncode

function URLDecode(const S: string): string;
var
  Idx: Integer;   // loops thru chars in string
  Hex: string;    // string of hex characters
  Code: Integer; // hex character code (-1 on error)

begin
  // Intialise result and string index
  Result := '';
  Idx := 1;
  // Loop thru string decoding each character
  while Idx <= Length(S) do
  begin
    case S[Idx] of
      '%':
      begin
        // % should be followed by two hex digits - exception otherwise
        if Idx <= Length(S) - 2 then
        begin
          // there are sufficient digits - try to decode hex digits
          Hex := S[Idx+1] + S[Idx+2];
          Code := SysUtils.StrToIntDef('$' + Hex, -1);
          Inc(Idx, 2);
        end
        else
          // insufficient digits - error
          Code := -1;
        // check for error and raise exception if found
        if Code = -1 then
          raise SysUtils.EConvertError.Create(
            'Invalid hex digit in URL'
          );
        // decoded OK - add character to result
        Result := Result + Chr(Code);
      end;
      '+':
        // + is decoded as a space
        Result := Result + ' '
      else
        // All other characters pass thru unchanged
        Result := Result + S[Idx];
    end;
    Inc(Idx);
  end;

  // ����utf8����
  Result := Utf8Decode(Result);
end;


function URLEncode(S: string; const InQueryString: Boolean): string;
var
  Idx: Integer; // loops thru characters in string
begin
  S := UTF8Encode(S);
  Result := '';
  for Idx := 1 to Length(S) do
  begin
    case S[Idx] of
      'A'..'Z', 'a'..'z', '0'..'9', '-', '_', '.':
        Result := Result + S[Idx];
      ' ':
        if InQueryString then
          Result := Result + '+'
        else
          Result := Result + '%20';
      else
        Result := Result + '%' + SysUtils.IntToHex(Ord(S[Idx]), 2);
    end;
  end;
end;

function FixHeader(const Header: string): string;
begin
  Result := Header;
  if (RightStr(Header, 4) <> #13#10#13#10) then
  begin
    if (RightStr(Header, 2) = #13#10) then
      Result := Result + #13#10
    else
      Result := Result + #13#10#13#10;
  end;
end;

procedure TDiocpHttpRequest.Clear;
begin
  FRawHttpData.Clear;
  FRawPostData.Clear;
  FContextLength := 0;
  FPostDataLen := 0;
  FResponse.FData.Clear;
  FResponse.FResponseHeader := '';
end;

procedure TDiocpHttpRequest.CloseContext;
begin
  FDiocpContext.PostWSACloseRequest();
end;

constructor TDiocpHttpRequest.Create;
begin
  inherited Create;
  FRawHttpData := TMemoryStream.Create();
  FRawPostData := TMemoryStream.Create();
  FRequestHeader := TStringList.Create();
  FResponse := TDiocpHttpResponse.Create();
end;

destructor TDiocpHttpRequest.Destroy;
begin
  FreeAndNil(FResponse);
  FRawPostData.Free;
  FRawHttpData.Free;
  FRequestHeader.Free;
  inherited Destroy;
end;

function TDiocpHttpRequest.DecodeHttpRequestMethod: Integer;
var
  lvBuf:Pointer;
begin
  Result := 0;
  if FRawHttpData.Size <= 7 then Exit;

  lvBuf := FRawHttpData.Memory;

  if FRequestMethod <> '' then
  begin
    Result := 1;  // �Ѿ�����
    Exit;
  end;

  //���󷽷������з���ȫΪ��д���ж��֣����������Ľ������£�
  //GET     �����ȡRequest-URI����ʶ����Դ
  //POST    ��Request-URI����ʶ����Դ�󸽼��µ�����
  //HEAD    �����ȡ��Request-URI����ʶ����Դ����Ӧ��Ϣ��ͷ
  //PUT     ����������洢һ����Դ������Request-URI��Ϊ���ʶ
  //DELETE  ���������ɾ��Request-URI����ʶ����Դ
  //TRACE   ��������������յ���������Ϣ����Ҫ���ڲ��Ի����
  //CONNECT ��������ʹ��
  //OPTIONS �����ѯ�����������ܣ����߲�ѯ����Դ��ص�ѡ�������
  //Ӧ�þ�����
  //GET��������������ĵ�ַ����������ַ�ķ�ʽ������ҳʱ�����������GET�������������ȡ��Դ��eg:GET /form.html HTTP/1.1 (CRLF)
  //
  //POST����Ҫ��������������ܸ��������������ݣ��������ύ����

  Result := 1;
  // HTTP 1.1 ֧��8������
  if (StrLIComp(lvBuf, 'GET', 3) = 0) then
  begin
    FRequestMethod := 'GET';
  end else if (StrLIComp(lvBuf, 'POST', 4) = 0) then
  begin
    FRequestMethod := 'POST';
  end else if (StrLIComp(lvBuf, 'PUT', 3) = 0) then
  begin
    FRequestMethod := 'PUT';
  end else if (StrLIComp(lvBuf, 'HEAD', 3) = 0) then
  begin
    FRequestMethod := 'HEAD';
  end else if (StrLIComp(lvBuf, 'OPTIONS', 7) = 0) then
  begin
    FRequestMethod := 'OPTIONS';
  end else if (StrLIComp(lvBuf, 'DELETE', 6) = 0) then
  begin
    FRequestMethod := 'DELETE';
  end else if (StrLIComp(lvBuf, 'TRACE', 5) = 0) then
  begin
    FRequestMethod := 'TRACE';
  end else if (StrLIComp(lvBuf, 'CONNECT', 7) = 0) then
  begin
    FRequestMethod := 'CONNECT';
  end else
  begin
    Result := 2;
  end;
end;

function TDiocpHttpRequest.DecodeHttpRequestParams: Integer;
var
  lvRawString: AnsiString;
  lvRequestCmdLine, lvMethod, lvTempStr, lvRawTemp:String;
  i, j:Integer;

begin
  Result := 1;
  SetLength(lvRawString, FRawHttpdata.Size);
  FRawHttpdata.Position := 0;
  FRawHttpData.Read(lvRawString[1], FRawHttpdata.Size);
  FRequestHeader.Text := lvRawString;

  // GET /test?v=abc HTTP/1.1
  lvRequestCmdLine := FRequestHeader[0];
  FRequestHeader.Delete(0);

  I := 1;
  while (I <= Length(lvRequestCmdLine)) and (lvRequestCmdLine[I] <> ' ') do
    Inc(I);
  // ���󷽷�(GET, POST, PUT, HEAD...)
  lvMethod := UpperCase(Copy(lvRequestCmdLine, 1, I - 1));
  Inc(I);
  while (I <= Length(lvRequestCmdLine)) and (lvRequestCmdLine[I] = ' ') do
    Inc(I);
  J := I;
  while (I <= Length(lvRequestCmdLine)) and (lvRequestCmdLine[I] <> ' ') do
    Inc(I);

  // ���������·��
  lvTempStr := Copy(lvRequestCmdLine, J, I - J);
  // ��������
  J := Pos('?', lvTempStr);

  if (J <= 0) then
  begin
    FRequestUrl := lvTempStr;
    lvRawTemp := '';

    FRequestUrl := URLDecode(FRequestUrl);
    FRequestParams := '';
  end else
  begin
    FRequestUrl := Copy(lvTempStr, 1, J - 1);
    lvRawTemp := Copy(lvTempStr, J + 1, MaxInt);

    FRequestUrl := URLDecode(FRequestUrl);
    FRequestParams := URLDecode(lvRawTemp);
  end;


  Inc(I);
  while (I <= Length(lvRequestCmdLine)) and (lvRequestCmdLine[I] = ' ') do
    Inc(I);
  J := I;
  while (I <= Length(lvRequestCmdLine)) and (lvRequestCmdLine[I] <> ' ') do
    Inc(I);

  // �����HTTP�汾
  FRequestVersionStr := Trim(UpperCase(Copy(lvRequestCmdLine, J, I - J)));

  if (FRequestVersionStr = '') then
    FRequestVersionStr := 'HTTP/1.0';
  if (lvTempStr = 'HTTP/1.0') then
  begin
    FHttpVersion := 10;
    FKeepAlive := false;  // Ĭ��Ϊfalse
  end else
  begin
    FHttpVersion := 11;    
    FKeepAlive := true;    // Ĭ��Ϊtrue
  end;                     

  FContextLength := 0;


  //eg��POST /reg.jsp HTTP/ (CRLF)
  //Accept:image/gif,image/x-xbit,... (CRLF)
  //...
  //HOST:www.guet.edu.cn (CRLF)
  //Content-Length:22 (CRLF)
  //Connection:Keep-Alive (CRLF)
  //Cache-Control:no-cache (CRLF)
  //(CRLF)         //��CRLF��ʾ��Ϣ��ͷ�Ѿ��������ڴ�֮ǰΪ��Ϣ��ͷ
  //user=jeffrey&pwd=1234  //��������Ϊ�ύ������
  //
  //HEAD������GET����������һ���ģ�����HEAD����Ļ�Ӧ������˵������HTTPͷ���а�������Ϣ��ͨ��GET�������õ�����Ϣ����ͬ�ġ�����������������ش���������Դ���ݣ��Ϳ��Եõ�Request-URI����ʶ����Դ����Ϣ���÷��������ڲ��Գ����ӵ���Ч�ԣ��Ƿ���Է��ʣ��Լ�����Ƿ���¡�
  //2������ͷ����
  //3����������(��)

  for i := 0 to FRequestHeader.Count -1 do
  begin
    lvRequestCmdLine := FRequestHeader[i];
    if (lvRequestCmdLine = '') then Continue;

    // �ո�֮��ĵ�һ���ַ�λ��
    j := Pos(' ', lvRequestCmdLine) + 1;

    if StrLIComp(@lvRequestCmdLine[1], 'Content-Type:', 13) = 0 then
      FContextType := Copy(lvRequestCmdLine, j, Length(lvRequestCmdLine))
    else if StrLIComp(@lvRequestCmdLine[1], 'Content-Length:', 15) = 0 then
    begin
      FContextLength := StrToInt64Def(Copy(lvRequestCmdLine, j, MaxInt), -1);
    end
    else if StrLIComp(@lvRequestCmdLine[1], 'Accept:', 7) = 0 then
      FRequestAccept:= Copy(lvRequestCmdLine, j, MaxInt)
    else if StrLIComp(@lvRequestCmdLine[1], 'Referer:', 8) = 0 then
      FRequestReferer := Copy(lvRequestCmdLine, j, MaxInt)
    else if StrLIComp(@lvRequestCmdLine[1], 'Accept-Language:', 16) = 0 then
      FRequestAcceptLanguage := Copy(lvRequestCmdLine, j, MaxInt)
    else if StrLIComp(@lvRequestCmdLine[1], 'Accept-Encoding:', 16) = 0 then
      FRequestAcceptEncoding := Copy(lvRequestCmdLine, j, MaxInt)
    else if StrLIComp(@lvRequestCmdLine[1], 'User-Agent:', 11) = 0 then
      FRequestUserAgent := Copy(lvRequestCmdLine, j, MaxInt)
    else if StrLIComp(@lvRequestCmdLine[1], 'Authorization:', 14) = 0 then
      FRequestAuth := Copy(lvRequestCmdLine, j, MaxInt)
    else if StrLIComp(@lvRequestCmdLine[1], 'Cookie:', 7) = 0 then
      FRequestCookies := Copy(lvRequestCmdLine, j, MaxInt)
    else if StrLIComp(@lvRequestCmdLine[1], 'Host:', 5) = 0 then
    begin
      lvTempStr := Copy(lvRequestCmdLine, j, MaxInt);
      J := Pos(':', lvTempStr);
      if J > 0 then
      begin
        FRequestHostName := Copy(lvTempStr, 1, J - 1);
        FRequestHostPort := Copy(lvTempStr, J + 1, 100);
      end else
      begin
        FRequestHostName := lvTempStr;
        FRequestHostPort := IntToStr((FDiocpContext).Owner.Port);
      end;
    end
    else if StrLIComp(@lvRequestCmdLine[1], 'Connection:', 11) = 0 then
    begin
      lvTempStr := Copy(lvRequestCmdLine, j, MaxInt);
      // HTTP/1.0 Ĭ��KeepAlive=False��ֻ����ʾָ����Connection: keep-alive����ΪKeepAlive=True
      // HTTP/1.1 Ĭ��KeepAlive=True��ֻ����ʾָ����Connection: close����ΪKeepAlive=False
      if FHttpVersion = 10 then
        FKeepAlive := SameText(lvTempStr, 'keep-alive')
      else if SameText(lvTempStr, 'close') then
        FKeepAlive := False;
    end
    else if StrLIComp(@lvRequestCmdLine[1], 'X-Forwarded-For:', 16) = 0 then
      FXForwardedFor := Copy(lvRequestCmdLine, j, MaxInt);
  end;
end;

function TDiocpHttpRequest.MakeHeader(const Status, ContType, Header: string;
    pvContextLength: Integer): string;
begin
  Result := '';

  if (Status = '') then
    Result := Result + FRequestVersionStr + ' 200 OK' + #13#10
  else
    Result := Result + FRequestVersionStr + ' ' + Status + #13#10;

  if (ContType = '') then
    Result := Result + 'Content-Type: text/html' + #13#10
  else
    Result := Result + 'Content-Type: ' + ContType + #13#10;


  if (pvContextLength > 0) then
    Result := Result + 'Content-Length: ' + IntToStr(pvContextLength) + #13#10;
//    Result := Result + 'Cache-Control: no-cache'#13#10;

  if FKeepAlive then
    Result := Result + 'Connection: keep-alive'#13#10
  else
    Result := Result + 'Connection: close'#13#10;

  Result := Result + 'Server: DIOCP3/1.0'#13#10;

  if (Header <> '') then
    Result := Result + FixHeader(Header)
  else
    Result := Result + #13#10;
end;

procedure TDiocpHttpRequest.ResponseEnd;
var
  lvFixedHeader: AnsiString;
  Len: Integer;
begin
  lvFixedHeader := MakeHeader('', FResponse.FContentType, FResponse.FResponseHeader, FResponse.FData.Size);

  // FResponseSize����׼ȷָ�����͵����ݰ���С
  // �����ڷ�����֮��(Owner.TriggerClientSentData)�Ͽ��ͻ�������
  if lvFixedHeader <> '' then
  begin
    Len := Length(lvFixedHeader);
    FDiocpContext.PostWSASendRequest(PAnsiChar(lvFixedHeader), Len);
  end;
  
  FDiocpContext.PostWSASendRequest(FResponse.FData.Memory, FResponse.FData.Size);
  
  if not FKeepAlive then
  begin
    FDiocpContext.PostWSACloseRequest;
  end;
end;

procedure TDiocpHttpRequest.WriteRawBuffer(const Buffer: Pointer; len: Integer);
begin
  FRawHttpData.WriteBuffer(Buffer^, len);
end;

procedure TDiocpHttpResponse.Clear;
begin
  FContentType := '';
  FData.Clear;
  FResponseHeader := '';
end;

constructor TDiocpHttpResponse.Create;
begin
  inherited Create;
  FData := TMemoryStream.Create();
end;

destructor TDiocpHttpResponse.Destroy;
begin
  FreeAndNil(FData);
  inherited Destroy;
end;

procedure TDiocpHttpResponse.WriteBuf(pvBuf: Pointer; len: Cardinal);
begin
  FData.Write(pvBuf^, len);
end;

procedure TDiocpHttpResponse.WriteString(pvString:string);
begin
  FData.WriteBuffer(PChar(pvString)^, Length(pvString) * SizeOf(Char));
end;

constructor TDiocpHttpClientContext.Create;
begin
  inherited Create;
  FRequest := TDiocpHttpRequest.Create();
  FRequest.FDiocpContext := Self;
end;

destructor TDiocpHttpClientContext.Destroy;
begin
  FreeAndNil(FRequest);
  inherited Destroy;
end;

procedure TDiocpHttpClientContext.DoCleanUp;
begin
  inherited;
  FHttpState := hsCompleted;
end;

procedure TDiocpHttpClientContext.OnRecvBuffer(buf: Pointer; len: Cardinal;
    ErrCode: WORD);
var
  lvTmpBuf: PAnsiChar;
  CR, LF: Integer;
  lvRemain:Cardinal;
begin
  inherited;
  lvTmpBuf := buf;
  CR := 0;
  LF := 0;
  lvRemain := len;
  while (lvRemain > 0) do
  begin
    if FHttpState = hsCompleted then
    begin  // ��ɺ����ã����´�����һ����
      FRequest.Clear;
      FHttpState := hsRequest;
    end;

    if (FHttpState = hsRequest) then
    begin
      case lvTmpBuf^ of
        #13: Inc(CR);
        #10: Inc(LF);
      else
        CR := 0;
        LF := 0;
      end;

      // д����������
      FRequest.WriteRawBuffer(lvTmpBuf, 1);

      if FRequest.DecodeHttpRequestMethod = 2 then
      begin    // ��Ч��Http����
        self.RequestDisconnect('��Ч��Http����', Self);
        Exit;
      end;

      // ���������ѽ������(#13#10#13#10��HTTP��������ı�־)
      if (CR = 2) and (LF = 2) then
      begin
        if FRequest.DecodeHttpRequestParams = 0 then
        begin
          Self.RequestDisconnect('��Ч��HttpЭ������', Self);
          Exit;
        end;

        if SameText(FRequest.FRequestMethod, 'POST') or
          SameText(FRequest.FRequestMethod, 'PUT') then
        begin
          // ��Ч��Post����ֱ�ӶϿ�
          if (FRequest.FContextLength <= 0) then
          begin
            Self.RequestDisconnect('��Ч��POST/PUT��������', Self);
            Exit;
          end;
          // �ı�Http״̬, �����������״̬
          FHttpState := hsRecvingPost;
        end else
        begin
          FHttpState := hsCompleted;
          // �����¼�
          TDiocpHttpServer(FOwner).DoRequest(FRequest);
          Break;
        end;
      end;
    end else if (FHttpState = hsRecvingPost) then
    begin
      Inc(FRequest.FPostDataLen);
      FRequest.FRawPostData.Write(buf^, 1);
      if FRequest.FPostDataLen >= FRequest.FContextLength then
      begin
        FHttpState := hsCompleted;
        // �����¼�
        TDiocpHttpServer(FOwner).DoRequest(FRequest);
      end;
    end;
    Dec(lvRemain);
    Inc(lvTmpBuf);
  end; 
end;


{ TDiocpHttpServer }

constructor TDiocpHttpServer.Create(AOwner: TComponent);
begin
  inherited;
  KeepAlive := false;
  registerContextClass(TDiocpHttpClientContext);
end;

procedure TDiocpHttpServer.DoRequest(pvRequest: TDiocpHttpRequest);
begin
   if Assigned(FOnDiocpHttpRequest) then
   begin
     FOnDiocpHttpRequest(pvRequest);
   end;
end;

end.
