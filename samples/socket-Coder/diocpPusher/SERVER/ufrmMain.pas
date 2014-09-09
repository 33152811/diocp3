unit ufrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ActnList, uIOCPCentre, ExtCtrls,
  ComObj, ComCtrls;

type
  TfrmMain = class(TForm)
    edtPort: TEdit;
    btnOpen: TButton;
    actlstMain: TActionList;
    actOpen: TAction;
    actStop: TAction;
    actPushMsg: TAction;
    edtMsg: TEdit;
    btnPushMsg: TButton;
    pgcMain: TPageControl;
    tsPuller: TTabSheet;
    tsMoniter: TTabSheet;
    pnlMonitor: TPanel;
    ListView1: TListView;
    pnlPullerOperator: TPanel;
    procedure actOpenExecute(Sender: TObject);
    procedure actPushMsgExecute(Sender: TObject);
    procedure actStopExecute(Sender: TObject);
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
    FTcpServer: TIOCPConsole;
    procedure refreshState;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  frmMain: TfrmMain;

implementation

uses
  uFMMonitor, uDIOCPStreamCoder, uRunTimeINfoTools, iocpTask;

{$R *.dfm}

constructor TfrmMain.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTcpServer := TIOCPConsole.Create(Self);
  FTcpServer.createDataMonitor;
  // register decoder and encoder class
  FTcpServer.registerCoderClass(TIOCPStreamDecoder, TIOCPStreamEncoder);
  TFMMonitor.createAsChild(pnlMonitor, FTcpServer);
end;

destructor TfrmMain.Destroy;
begin
  iocpTaskManager.Enable := false;
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

procedure TfrmMain.actPushMsgExecute(Sender: TObject);
var
  lvList:TList;
  i: Integer;
  lvStream:TMemoryStream;
  s:AnsiString;
begin
  lvList := TList.Create;
  try
    lvStream := TMemoryStream.Create;
    try
      s := edtMsg.Text;
      lvStream.Write(s[1], Length(s));

      // get all client context to List
      FTcpServer.getOnlineContextList(lvList);


      for i := 0 to lvList.Count-1 do
      begin
        //send stream object directly
        TIOCPCoderClientContext(lvList[i]).writeObject(lvStream);
      end;
    finally
      lvStream.Free;
    end;
  finally
    lvList.Free;
  end;

end;

procedure TfrmMain.actStopExecute(Sender: TObject);
begin
  FTcpServer.safeStop;
  refreshState;
end;

procedure TfrmMain.btn1Click(Sender: TObject);
begin
  ShowMessage(TRunTimeINfoTools.transByteSize(10000000000000));
end;

end.
