(*

*)
unit udmMain;


interface

uses
  SysUtils, Classes, DB, ADODB;

type
  TdmMain = class(TDataModule)
    conMain: TADOConnection;
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

function TdmMain.Execute(pvCmdIndex: Integer; var vData: OleVariant): Boolean;
begin
  
end;

end.
