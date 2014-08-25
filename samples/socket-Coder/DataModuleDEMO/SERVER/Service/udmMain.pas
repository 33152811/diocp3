(*
  ÿ���ͻ���һ��ʵ��, ���߳�������
  
*)
unit udmMain;


interface

uses
  SysUtils, Classes, DB, ADODB, Provider, IniFiles;

type
  TdmMain = class(TDataModule)
    conMain: TADOConnection;
    dspMain: TDataSetProvider;
    qryMain: TADOQuery;
    procedure DataModuleCreate(Sender: TObject);
  public
    /// <summary>
    /// �ͻ��˵���
    //     ִ����ں���
    //  ��vData�������޸Ľ��᷵�ص��ͻ���
    /// </summary>
    function Execute(pvCmdIndex: Integer; var vData: OleVariant): Boolean;
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
  lvFile := ChangeFileExt(ParamStr(0), '.db.ini');
  lvINI := TIniFile.Create(lvFile);
  try
    lvStr := lvINI.ReadString('main', 'connectionString', '');
    if lvStr <> '' then
    begin
      conMain.ConnectionString := lvStr;
    end else
    begin
      lvINI.WriteString('main', 'connectionString', dmMain.conMain.ConnectionString);
    end;                                       
  finally
    lvINI.Free;
  end;
end;

function TdmMain.Execute(pvCmdIndex: Integer; var vData: OleVariant): Boolean;
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
        qryMain.SQL.Add(vData);
        qryMain.Open;

        vData := dspMain.Data;
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
