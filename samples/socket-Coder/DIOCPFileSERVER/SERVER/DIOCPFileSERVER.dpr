program DIOCPFileSERVER;

uses
  FastMM4,
  FastMM4Messages,
  Forms,
  ufrmMain in 'ufrmMain.pas' {frmMain},
  uFMMonitor in '..\..\..\Common\Frames\uFMMonitor.pas' {FMMonitor: TFrame},
  uRunTimeINfoTools in '..\..\..\Common\Frames\uRunTimeINfoTools.pas',
  uMyClientContext in 'Service\uMyClientContext.pas',
  uZipTools in '..\..\diocpCoders\uZipTools.pas',
  SimpleMsgPack in '..\Common\SimpleMsgPack.pas',
  uFileOperaHandler in 'Service\uFileOperaHandler.pas',
  uCRCTools in '..\..\diocpCoders\uCRCTools.pas',
  uDIOCPDxStreamCoder in '..\..\diocpCoders\uDIOCPDxStreamCoder.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
