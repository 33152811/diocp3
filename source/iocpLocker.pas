unit iocpLocker;

interface

{$DEFINE USECriticalSection}

uses
  {$IFDEF USECriticalSection}
    SyncObjs,
  {$ELSE}
    Windows,
  {$ENDIF}
  SysUtils, Classes;

type
  {$IFDEF USECriticalSection}
    TIocpLocker = class(TCriticalSection)
  {$ELSE}
    TIocpLocker = class(TObject)
  {$ENDIF}
  private
    FEnterINfo: string;
    FTryEnterInfo: String;
    FName: String;

  {$IFDEF USECriticalSection}
  {$ELSE}
    FSection: TRTLCriticalSection;
  {$ENDIF}

    function GetEnterCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;

    procedure lock(pvDebugInfo: String = '');
    procedure unLock;

    property EnterCount: Integer read GetEnterCount;

    property EnterINfo: string read FEnterINfo;

    property TryEnterInfo: String read FTryEnterInfo;

    function getDebugINfo():String;

    property Name: String read FName write FName;

  end;

implementation

constructor TIocpLocker.Create;
begin
  inherited Create;
  {$IFDEF USECriticalSection}

  {$ELSE}
    InitializeCriticalSection(FSection);
  {$ENDIF}
end;

destructor TIocpLocker.Destroy;
begin
  {$IFDEF USECriticalSection}

  {$ELSE}
    DeleteCriticalSection(FSection);
  {$ENDIF}
  inherited Destroy;
end;

function TIocpLocker.getDebugINfo: String;
begin
  Result := Format('%s: busycount:%d, try:%s, enter:%s', [self.FName, GetEnterCount, FTryEnterInfo, FEnterInfo]);
end;

function TIocpLocker.GetEnterCount: Integer;
begin
  {$IFDEF USECriticalSection}
     Result := FSection.RecursionCount;
  {$ELSE}
     Result := FSection.RecursionCount;
  {$ENDIF}
end;

procedure TIocpLocker.lock(pvDebugInfo: String = '');
begin
  FTryEnterInfo := pvDebugInfo;
  {$IFDEF USECriticalSection}
     Enter;
  {$ELSE}
     EnterCriticalSection(FSection);
  {$ENDIF}
  FEnterINfo := pvDebugInfo;
end;

procedure TIocpLocker.unLock;
begin
  {$IFDEF USECriticalSection}
     Leave;
  {$ELSE}
     LeaveCriticalSection(FSection);
  {$ENDIF}
end;

end.
