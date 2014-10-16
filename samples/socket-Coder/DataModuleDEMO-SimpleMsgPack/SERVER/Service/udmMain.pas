(*
  ÿ���ͻ���һ��ʵ��, ���߳�������
  
*)
unit udmMain;


interface

uses
  SysUtils, Classes, DB, ADODB, Provider, IniFiles, DBClient;

type
  TdmMain = class(TDataModule)
    conMain: TADOConnection;
    dspMain: TDataSetProvider;
    qryMain: TADOQuery;
    cdsMain: TClientDataSet;
    procedure DataModuleCreate(Sender: TObject);
  public
    /// <summary>
    /// �ͻ��˵���
    //     ִ����ں���
    //  ��vData�������޸Ľ��᷵�ص��ͻ���
    /// </summary>
    function Execute(pvCmdIndex: Integer; var vData: OleVariant; var vMsg: string):
        Boolean;
  end;

var
  dmMain: TdmMain;

implementation

{$R *.dfm}

procedure TdmMain.DataModuleCreate(Sender: TObject);
var
  lvINI:TIniFile;
  lvStr:String;
  lvFile:String;
begin
  qryMain.DisableControls;
  lvFile := ChangeFileExt(ParamStr(0), '.db.ini');
  lvINI := TIniFile.Create(lvFile);
  try
    lvStr := lvINI.ReadString('main', 'connectionString', '');
    if lvStr <> '' then
    begin
      conMain.ConnectionString := lvStr;
    end else
    begin
      lvINI.WriteString('main', 'connectionString', conMain.ConnectionString);
    end;                                       
  finally
    lvINI.Free;
  end;
end;

function TdmMain.Execute(pvCmdIndex: Integer; var vData: OleVariant; var vMsg:
    string): Boolean;
begin
  case pvCmdIndex of
    0:
      begin
        // ���ط����ʱ����ͻ���
        vData := Now();
        Result := true;
      end;
    1:  // ��ѯ����
      begin
        // vData ��Ϊ�Ǵ����SQL���
        //   ִ�к�, vDataΪ��ѯ�����ݣ��������ڶ�ClientData.Data�ĸ�ֵ

        qryMain.Close;
        qryMain.SQL.Clear;
        qryMain.SQL.Add(vData);
        qryMain.Open;

        dspMain.DataSet := qryMain;
        vData := dspMain.Data;

        try
          cdsMain.Data := vData;
        except
          on E:Exception do
          begin
            raise Exception.Create('����˳��Ը�ֵ��cdsMain.Dataʱ�������쳣:' + e.Message);
          end;
        end;

        qryMain.Close;
        Result := true;
      end;
    2:
      begin
        // vData Ϊִ�е����
        conMain.BeginTrans;
        try
          qryMain.Close;
          qryMain.SQL.Clear;
          qryMain.SQL.Add(vData);
          qryMain.ExecSQL;
          conMain.CommitTrans;

          VarClear(vData);
          
          Result := true;


        except
          conMain.RollbackTrans;
          raise;
        end;
      end;
  end;
end;

end.
