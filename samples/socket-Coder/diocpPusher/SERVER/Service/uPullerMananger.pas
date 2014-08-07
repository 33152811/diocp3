unit uPullerMananger;

interface

uses
  uMapObject, uIOCPCentre, Classes, SyncObjs;


type
  /// <summary>
  ///   ����ʹ�����Ϣ��������
  /// </summary>
  TMessagePullMananger = class(TObject)
  private
    FCS: TCriticalSection;
    FPuller: TMapObject;
    procedure lock;
    procedure unLock;
  public
    constructor Create;
    destructor Destroy; override;
    procedure registerPuller(pvPullID: string; pvObject: TIOCPCoderClientContext);
    procedure removePuller(pvPullID:string);
    function writeObject(pvPullID:string; pvData:TObject): Boolean;

    function findObject(pvPullID:String): TIOCPCoderClientContext;

    procedure dispatchObject(pvData:TObject);

    /// <summary>
    ///  ��ȡ�����б�
    /// </summary>
    procedure getPullerIDList(vString:TStrings);
    
    /// <summary>
    ///  ��ȡ�����б�
    /// </summary>
    function getPullerIDS(pvSplitStr:string = sLineBreak): String;
  end;

var
  pullerMananger:TMessagePullMananger;

implementation

constructor TMessagePullMananger.Create;
begin
  inherited Create;
  FPuller := TMapObject.Create();
  FCS := TCriticalSection.Create();
end;

destructor TMessagePullMananger.Destroy;
begin
  FCS.Free;
  FPuller.clear;
  FPuller.Free;
  inherited Destroy;
end;

procedure TMessagePullMananger.dispatchObject(pvData: TObject);
var
  i:Integer;
begin
  lock;
  try
    for i := FPuller.Count - 1 downto 0 do
    begin
      TIOCPCoderClientContext(FPuller[i]).writeObject(pvData);
    end;
  finally
    unLock;
  end;
end;

function TMessagePullMananger.findObject(pvPullID:String):
    TIOCPCoderClientContext;
begin
  Result :=TIOCPCoderClientContext(FPuller.find(pvPullID));
end;

procedure TMessagePullMananger.getPullerIDList(vString:TStrings);
var
  i:Integer;
begin
  lock;
  try
    for i := FPuller.Count - 1 downto 0 do
    begin
      vString.Add(FPuller.Keys[i]);        
    end;
  finally
    unLock;
  end;
end;

function TMessagePullMananger.getPullerIDS(pvSplitStr:string = sLineBreak):
    String;
var
  lvStrs:TStrings;
begin
  lvStrs := TStringList.Create;
  try
    lvStrs.LineBreak := pvSplitStr;
    getPullerIDList(lvStrs);
    Result := lvStrs.Text;
  finally
    lvStrs.Free;
  end;
end;

procedure TMessagePullMananger.lock;
begin
  FCS.Enter;
end;

procedure TMessagePullMananger.registerPuller(pvPullID: string; pvObject:
    TIOCPCoderClientContext);
begin
  lock;
  try
    FPuller.put(pvPullID, pvObject);
  finally
    unLock;
  end;
end;

procedure TMessagePullMananger.removePuller(pvPullID: string);
begin
  lock;
  try
    FPuller.remove(pvPullID);
  finally
    unLock;
  end;
end;

procedure TMessagePullMananger.unLock;
begin
  FCS.Leave;
end;

function TMessagePullMananger.writeObject(pvPullID:string; pvData:TObject):
    Boolean;
var
  lvClient:TIOCPCoderClientContext;
begin
  Result := false;
  lvClient := TIOCPCoderClientContext(FPuller.find(pvPullID));
  if lvClient <> nil then
  begin
    if lvClient.Active then
    begin
      lvClient.writeObject(pvData);
      Result := true;
    end;
  end;
end;

initialization
  pullerMananger := TMessagePullMananger.Create;

finalization
  pullerMananger.Free;

end.
