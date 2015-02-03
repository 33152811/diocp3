unit ufrmMain;

interface

{$DEFINE JSON}

{$IFDEF JSON}
  {$DEFINE USE_SuperObject}
{$ENDIF}



uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ActnList, iocpTcpServer, ExtCtrls
  {$IFDEF USE_SuperObject},superobject{$ENDIF}
  , safeLogger, StrUtils,
  ComCtrls, diocpHttpObject
  ;

type
  TfrmMain = class(TForm)
    edtPort: TEdit;
    btnOpen: TButton;
    actlstMain: TActionList;
    actOpen: TAction;
    actStop: TAction;
    btnDisconectAll: TButton;
    pgcMain: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    mmoLog: TMemo;
    pnlMonitor: TPanel;
    btnGetWorkerState: TButton;
    btnFindContext: TButton;
    pnlTop: TPanel;
    procedure actOpenExecute(Sender: TObject);
    procedure actStopExecute(Sender: TObject);
    procedure btnDisconectAllClick(Sender: TObject);
    procedure btnFindContextClick(Sender: TObject);
    procedure btnGetWorkerStateClick(Sender: TObject);
  private
    iCounter:Integer;
    FTcpServer: TDiocpHttpServer;
    procedure refreshState;

    procedure OnHttpSvrRequest(pvRequest:TDiocpHttpRequest);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  uFMMonitor, iocpEngine;

{$R *.dfm}

constructor TfrmMain.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTcpServer := TDiocpHttpServer.Create(Self);
  FTcpServer.Name := 'HttpSVR';
  FTcpServer.SetMaxSendingQueueSize(10000);
  FTcpServer.createDataMonitor;
  FTcpServer.OnDiocpHttpRequest := OnHttpSvrRequest;
  TFMMonitor.createAsChild(pnlMonitor, FTcpServer);
  
  sfLogger.setAppender(TStringsAppender.Create(mmoLog.Lines));
  sfLogger.AppendInMainThread := true;
end;

procedure TfrmMain.OnHttpSvrRequest(pvRequest:TDiocpHttpRequest);
var
  lvJSon:ISuperObject;
  s:String;
begin
  // Context Type
  //pvRequest.Response.ContentType := 'utf-8';

  // ��д����
  pvRequest.Response.WriteString('����ʱ��:' + DateTimeToStr(Now()) + '<br>');
  pvRequest.Response.WriteString('<a href="http://www.diocp.org">DIOCP/MyBean�ٷ�����</a><br>');
  pvRequest.Response.WriteString('<br>');

  pvRequest.Response.WriteString('<div>');

  // ��ȡͷ��Ϣ
  s := pvRequest.RequestHeader.Text;
  s := ReplaceText(s, sLineBreak, '<br>');
  pvRequest.Response.WriteString('ͷ��Ϣ<br>');
  pvRequest.Response.WriteString('����Url:' + pvRequest.RequestUrl + '<br>');


  pvRequest.Response.WriteString(s);
  pvRequest.Response.WriteString('<br>');


  // ����json
  lvJSon := SO();
  lvJSon.S['title'] := 'DIOCP3 Http ������ʾ';
  lvJSon.S['author'] := 'D10.�����';
  lvJSon.S['date'] := DateTimeToStr(Now());
  s := lvJSon.AsJSon(True, False);
  s := ReplaceText(s, sLineBreak, '<br>');
  pvRequest.Response.WriteString(s);
  pvRequest.Response.WriteString('</div>');

  // Ӧ����ϣ����ͻ�ͻ���
  pvRequest.ResponseEnd;

  pvRequest.CloseContext;
end;

destructor TfrmMain.Destroy;
begin
  inherited Destroy;
end;

procedure TfrmMain.refreshState;
begin
  if FTcpServer.Active then
  begin
    btnOpen.Action := actStop;
  end else
  begin
    btnOpen.Action := actOpen;
  end;
end;

procedure TfrmMain.actOpenExecute(Sender: TObject);
begin
  FTcpServer.Port := StrToInt(edtPort.Text);
  FTcpServer.Active := true;
  refreshState;
end;

procedure TfrmMain.actStopExecute(Sender: TObject);
begin
  FTcpServer.safeStop;
  refreshState;
end;

procedure TfrmMain.btnDisconectAllClick(Sender: TObject);
begin
  FTcpServer.DisConnectAll();
end;

procedure TfrmMain.btnFindContextClick(Sender: TObject);
var
  lvList:TList;
  i:Integer;
begin
  lvList := TList.Create;
  try
    FTcpServer.getOnlineContextList(lvList);
    for i:=0 to lvList.Count -1 do
    begin
      FTcpServer.findContext(TIocpClientContext(lvList[i]).SocketHandle);
    end;
  finally
    lvList.Free;
  end;

end;

procedure TfrmMain.btnGetWorkerStateClick(Sender: TObject);
begin
  ShowMessage(FTcpServer.IocpEngine.getWorkerStateInfo(0));
end;



end.
