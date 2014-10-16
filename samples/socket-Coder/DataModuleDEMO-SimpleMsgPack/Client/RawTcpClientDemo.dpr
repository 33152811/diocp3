program RawTcpClientDemo;

uses
  ExceptionLog,
  Forms,
  ufrmMain in 'ufrmMain.pas' {frmMain},
  uICoderSocket in '..\..\diocpCoders\uICoderSocket.pas',
  uStreamCoderSocket in '..\..\diocpCoders\uStreamCoderSocket.pas',
  uRawTcpClientCoderImpl in '..\..\diocpCoders\uRawTcpClientCoderImpl.pas',
  uIRemoteServer in 'interface\uIRemoteServer.pas',
  uRemoteServerDIOCPImpl in 'service\uRemoteServerDIOCPImpl.pas',
  uZipTools in '..\..\diocpCoders\uZipTools.pas',
  SimpleMsgPack in '..\Common\SimpleMsgPack.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
