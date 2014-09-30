unit ufrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ActnList, iocpTcpServer, ExtCtrls,
  ComCtrls;

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
    procedure actOpenExecute(Sender: TObject);
    procedure actStopExecute(Sender: TObject);
    procedure btnDisconectAllClick(Sender: TObject);
    procedure btnGetWorkerStateClick(Sender: TObject);
  private
    iCounter:Integer;
    FTcpServer: TIocpTcpServer;
    procedure refreshState;
    procedure OnRecvBuffer(pvClientContext:TIocpClientContext; buf:Pointer;
        len:cardinal; errCode:Integer);
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
  FTcpServer := TIocpTcpServer.Create(Self);
  FTcpServer.OnDataReceived := self.OnRecvBuffer;
  FTcpServer.createDataMonitor;
  TFMMonitor.createAsChild(pnlMonitor, FTcpServer);
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
  FTcpServer.OnDataReceived := self.OnRecvBuffer;
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

procedure TfrmMain.btnGetWorkerStateClick(Sender: TObject);
begin
  ShowMessage(FTcpServer.IocpEngine.getStateINfo);
end;

procedure TfrmMain.OnRecvBuffer(pvClientContext:TIocpClientContext;
    buf:Pointer; len:cardinal; errCode:Integer);
var
  j, i:Integer;
begin
  if errCode = 0 then
  begin
    j := InterlockedIncrement(iCounter);
//    if j mod 2000 = 0 then
//    begin
//      pvClientContext.RequestDisconnect;
//      exit;
//    end;

    if j mod 2000 = 0 then
    begin
      for i := 0 to 200 do
      begin
        pvClientContext.PostWSASendRequest(buf, len);
      end;
      exit;
    end;

    pvClientContext.PostWSASendRequest(buf, len);

  end else
  begin
    pvClientContext.RequestDisconnect;
  end;
end;

end.
