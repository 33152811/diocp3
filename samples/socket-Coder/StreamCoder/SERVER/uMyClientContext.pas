unit uMyClientContext;

interface

uses
  uIOCPCentre, iocpLogger, SysUtils, Classes, Windows, Math;


type
  TMyClientContext = class(TIOCPCoderClientContext)
  private
  protected
    procedure OnDisconnected; override;

    procedure OnConnected; override;
  protected
    /// <summary>
    ///   ���ݴ���
    /// </summary>
    /// <param name="pvObject"> (TObject) </param>
    procedure dataReceived(const pvObject: TObject); override;
  end;

implementation

procedure TMyClientContext.dataReceived(const pvObject: TObject);
begin
  // ֱ�ӷ���
  writeObject(pvObject);
end;

procedure TMyClientContext.OnConnected;
begin

end;

procedure TMyClientContext.OnDisconnected;
begin
end;

end.
