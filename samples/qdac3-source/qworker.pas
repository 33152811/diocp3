unit qworker;
{$I 'qdac.inc'}

interface

// ���߳���̫��ʱTQSimpleLock��������������Ŀ��������������ٽ磬������ʱ����ʹ��
{ .$DEFINE QWORKER_SIMPLE_LOCK }
{
  ��Դ������QDAC��Ŀ����Ȩ��swish(QQ:109867294)���С�
  (1)��ʹ����ɼ�����
  ���������ɸ��ơ��ַ����޸ı�Դ�룬�������޸�Ӧ�÷��������ߣ������������ڱ�Ҫʱ��
  �ϲ�������Ŀ���Թ�ʹ�ã��ϲ����Դ��ͬ����ѭQDAC��Ȩ�������ơ�
  ���Ĳ�Ʒ�Ĺ����У�Ӧ�������µİ汾����:
  ����Ʒʹ�õ�JSON����������QDAC��Ŀ�е�QJSON����Ȩ���������С�
  (2)������֧��
  �м������⣬�����Լ���QDAC�ٷ�QQȺ250530692��ͬ̽�֡�
  (3)������
  ����������ʹ�ñ�Դ�������Ҫ֧���κη��á���������ñ�Դ������а�������������
  ������Ŀ����ǿ�ƣ�����ʹ���߲�Ϊ�������ȣ��и���ľ���Ϊ�����ָ��õ���Ʒ��
  ������ʽ��
  ֧������ guansonghuan@sina.com �����������
  �������У�
  �����������
  �˺ţ�4367 4209 4324 0179 731
  �����У��������г����ŷ索����
}

{ �޶���־
  2014.8.19
  =========
  * ������TQJob.Synchronize����inline���������2007���޷���ȷ���������
  2014.8.18
  =========
  * �����˺ϲ��������LongTimeJobͶ���������ƴ��������(־�ı��棩
  * ���������������TQJobGroup.Run������ʱ���ó��������
  + TQJobGroup����MsgWaitFor�������Ա������߳��еȴ������������߳�(�����ٷʲ�����֤)
  + TQJob����Synchronize������ʵ���Ϲ�������TThread.Synchronize����(�����ٷʲ�����֤)

  2014.8.17
  =========
  * �Ľ����ҿ����̻߳��ƣ��Ա��ⲻ��Ҫ��������л����С�׺�Ц���쳾)
  * �ϲ����룬�Լ����ظ�����������л����С�ף�
  * ������Wait�����ӿڣ�AData��AFreeType������ȡ������Ϊ���źŴ���ʱ������ز���
  * TQJobGroup.AfterDone��Ϊ���������ʱ�����жϻ�ʱʱ��Ȼ����
  + TQJobGroup.Add����������AFreeType����
  + TQJobGroup.Run�������볬ʱ���ã�����ָ����ʱ�������δִ����ɣ�����ֹ����ִ��(Bug��û����ע��δ���׸㶨)
  + TQJobGroup.Cancel��������ȡ��δִ�е���ҵִ��

  2014.8.14
  ==========
  * �ο�����С�׵Ľ��飬�޸�Assign������ͬʱTQJobHelper�Ķ�����Ը�Ϊʹ��ͬһ������ʵ��
  * ��������Delphi2007�ϱ��������(����С�ױ��沢�ṩ�޸�)
  2014.8.12
  ==========
  * ������TQJob.Assign�������Ǹ���WorkerProcA��Ա������
  2014.8.8
  ==========
  * �����������߳���Clearʱ����������̵߳���ҵ��Ͷ�ĵ����߳���Ϣ���е���δִ��ʱ
  ���������������(playwo����)

  2014.8.7
  ==========
  * ������TQJobGroup�����ҵʱ�������޸���ҵ���״̬������

  2014.8.2
  ==========
  * ��������Windows��DLL��ʹ��QWorkerʱ�������˳�ʱ���߳��쳣��ֹʱ�������޷���
  ��������(С��ɵ����棬�������֤)
  2014.7.29
  ==========
  + �����������ȫ�ֺ���������ʽ����XE5���ϰ汾�У�����֧������������Ϊ��ҵ����
  [ע��]����������Ӧ���ʾֲ�������ֵ
  2014.7.28
  ==========
  * ������ComNeeded�����������ó�ʼ����ɱ�־λ������(����ұ���)
  2014.7.21
  ==========
  * ������Delphi 2007�޷����������

  2014.7.17
  =========
  * ��������FMXƽ̨�ϱ���ʱ����Hint�Ĵ���
  2014.7.14
  =========
  * ������TQJobGroupû�д���AfterDone�¼�������
  * �޸�������Hint�Ĵ���
  2014.7.12
  =========
  + ���TQJobGroup֧����ҵ����
  2014.7.4
  ========
  * ��������FMX�ļ���������(�ֺ뱨��)
  + ����Clear�����ȫ����ҵ������ʵ��(D10����ҽ���)
  * ֧������ҵ������ͨ������IsTerminated��������ȫ������ʱ���ź���ҵ
  2014.7.3
  =========
  + MakeJobProc��֧��ȫ����ҵ������
  + TQWorkers.Clear�����������������غ�����ʵ������ָ���źŹ�����ȫ����ҵ(�嶾�����顣����)
  * �������ظ���ҵ����ִ��ʱ�޷�����ɾ�������
  2014.6.26
  =========
  * TEvent.WaitFor����������Խ����Delphi2007�ļ�����(D10-����ұ���)
  * ����HPPEMITĬ�����ӱ���Ԫ(�����ٷ� ����)
  2014.6.23
  =========
  * �޸���Windows�����߳�����ҵ�Ĵ�����ʽ���Ը�����COM�ļ����ԣ�D10-����ұ��棩
  2014.6.21
  =========
  * �����˶�COM��֧�֣������Ҫ����ҵ��ʹ��COM���󣬵���Job.Worker.ComNeeded�󼴿�
  �������ʸ���COM����
  2014.6.19
  =========
  * ������DoMainThreadWork�����Ĳ�������˳�����
  * ΪTQWorker������ComNeeded��������֧��COM�ĳ�ʼ����������ҵ��COM��غ�������
  2014.6.17
  =========
  * �źŴ�����ҵʱ�����븽�����ݳ�Ա���������������ӵ�TQJob�ṹ��Data��Ա���Ա�
  �ϲ�Ӧ���ܹ�����Ҫ�ı�ǣ�Ĭ��ֵΪ��
  * ��ҵͶ��ʱ�����˸��ӵĲ�������������ͷŸ��ӵ����ݶ���
}
uses
  classes, types, sysutils, SyncObjs
{$IFDEF UNICODE}, Generics.Collections{$ENDIF}
{$IFDEF NEXTGEN}, fmx.Forms, system.Diagnostics{$ENDIF}
{$IFDEF POSIX}, Posix.Unistd, Posix.Pthread{$ENDIF}
{$IFDEF MSWINDOWS}, Windows, Messages, Forms, activex{$ENDIF}
    , qstring, qrbtree;
{$HPPEMIT '#pragma link "qworker"'}

{ *QWorker��һ����̨�����߹���������ڹ����̵߳ĵ��ȼ����С���QWorker�У���С��
  ������λ����Ϊ��ҵ��Job������ҵ���ԣ�
  1����ָ����ʱ����Զ����ƻ�ִ�У������ڼƻ�����ֻ��ʱ�ӵķֱ��ʿ��Ը���
  2���ڵõ���Ӧ���ź�ʱ���Զ�ִ����Ӧ�ļƻ�����
  �����ơ�
  1.ʱ��������ʹ��0.1msΪ������λ����ˣ�64λ�������ֵΪ9223372036224000000��
  ����864000000��Ϳɵý��ԼΪ10675199116�죬��ˣ�QWorker�е���ҵ�ӳٺͶ�ʱ�ظ�
  ������Ϊ10675199116�졣
  2�����ٹ�������Ϊ1�����������ڵ����Ļ��Ƕ���Ļ����ϣ�����������ơ������
  ���õ����ٹ�������������ڵ���1������������û��ʵ�����ơ�
  3����ʱ����ҵ�������ó�����๤����������һ�룬����Ӱ��������ͨ��ҵ����Ӧ�����
  Ͷ�ĳ�ʱ����ҵʱ��Ӧ���Ͷ�Ľ����ȷ���Ƿ�Ͷ�ĳɹ�
  * }
const
  JOB_RUN_ONCE = $0001; // ��ҵֻ����һ��
  JOB_IN_MAINTHREAD = $0002; // ��ҵֻ�������߳�������
  JOB_MAX_WORKERS = $0004; // �����ܶ�Ŀ������ܵĹ������߳���������ҵ���ݲ�֧��
  JOB_LONGTIME = $0008; // ��ҵ��Ҫ�ܳ���ʱ�������ɣ��Ա���ȳ����������������ҵ��Ӱ��
  JOB_SIGNAL_WAKEUP = $0010; // ��ҵ�����ź���Ҫ����
  JOB_TERMINATED = $0020; // ��ҵ����Ҫ�������У����Խ�����
  JOB_FREE_OBJECT = $0040; // Data��������Object����ҵ��ɻ�����ʱ�ͷ�
  JOB_FREE_RECORD = $0080; // Data��������Record����ҵ��ɻ�����ʱ�ͷ�
  JOB_FREE_INTERFACE = $0100; // Data��������Interface����ҵ���ʱ����_Release
  JOB_DATA_OWNER = $01C0; // ��ҵ��Data��Ա��������
  JOB_GROUPED = $0200; // ��ǰ��ҵ����ҵ���һԱ
  JOB_ANONPROC = $0400; // ��ǰ��ҵ��������������
  WORKER_ISBUSY = $01; // ������æµ
  WORKER_PROCESSLONG = $02; // ��ǰ�����һ����ʱ����ҵ
  WORKER_RESERVED = $04; // ��ǰ��������һ������������
  WORKER_COM_INITED = $08; // �������ѳ�ʼ��Ϊ֧��COM��״̬(����Windows)
  WORKER_LOOKUP = $10; // ���������ڲ�����ҵ
  WORKER_EXECUTING = $20; // ����������ִ����ҵ
  WORKER_EXECUTED = $40; // �������Ѿ������ҵ
  Q1MillSecond = 10; // 1ms
  Q1Second = 10000; // 1s
  Q1Minute = 600000; // 60s/1min
  Q1Hour = 36000000; // 3600s/60min/1hour
  Q1Day = Int64(864000000); // 1day
{$IFNDEF UNICODE}
  wrIOCompletion = TWaitResult(4);
{$ENDIF}

type
  TQJobs = class;
  TQWorker = class;
  TQWorkers = class;
  TQJobGroup = class;
  PQSignal = ^TQSignal;
  PQJob = ^TQJob;
  /// <summary>��ҵ����ص�����</summary>
  /// <param name="AJob">Ҫ�������ҵ��Ϣ</param>
  TQJobProc = procedure(AJob: PQJob) of object;
  TQJobProcG = procedure(AJob: PQJob);
{$IFDEF UNICODE}
  TQJobProcA = reference to procedure(AJob: PQJob);
{$ENDIF}
  /// <summary>��ҵ����ԭ���ڲ�ʹ��</summary>
  /// <remarks>
  /// irNoJob : û����Ҫ�������ҵ����ʱ�����߻����15���ͷŵȴ�״̬�������15����
  /// ������ҵ�����������߻ᱻ���ѣ�����ʱ��ᱻ�ͷ�
  /// irTimeout : �������Ѿ��ȴ���ʱ�����Ա��ͷ�
  TWorkerIdleReason = (irNoJob, irTimeout);
  /// <summary>��ҵ����ʱ��δ���Data��Ա</summary>
  /// <remarks>
  /// jdoFreeByUser : �û����������ͷ�
  /// jdoFreeAsObject : ���ӵ���һ��TObject�̳еĶ�����ҵ���ʱ�����FreeObject�ͷ�
  /// jdoFreeAsRecord : ���ӵ���һ��Record������ҵ���ʱ�����Dispose�ͷ�
  /// jdtFreeAsInterface : ���ӵ���һ���ӿڶ������ʱ�����Ӽ�������ҵ���ʱ����ټ���
  /// </remarks>
  TQJobDataFreeType = (jdfFreeByUser, jdfFreeAsObject, jdfFreeAsRecord,
    jdfFreeAsInterface);

  TQJob = record
  private
    function GetAvgTime: Integer; inline;
    function GetEscapedTime: Int64; inline;
    function GetIsTerminated: Boolean; inline;
    function GetFlags(AIndex: Integer): Boolean; inline;
    procedure SetFlags(AIndex: Integer; AValue: Boolean); inline;
    procedure UpdateNextTime;
    procedure SetIsTerminated(const Value: Boolean);
    procedure AfterRun(AUsedTime: Int64);
  public
    constructor Create(AProc: TQJobProc); overload;
    /// <summary>ֵ��������</summary>
    /// <remarks>Worker/Next/Source���Ḵ�Ʋ��ᱻ�ÿգ�Owner���ᱻ����</remarks>
    procedure Assign(const ASource: PQJob);
    /// <summary>�������ݣ��Ա�Ϊ�Ӷ����е�����׼��</summary>
    procedure Reset; inline;

    /// <summary>�������̶߳����ͬ�������������Ƽ�Ͷ���첽��ҵ�����߳��д���</summary>
    procedure Synchronize(AMethod: TThreadMethod); {$IFDEF UNICODE}inline;{$ENDIF}
    /// <summary>ƽ��ÿ������ʱ�䣬��λΪ0.1ms</summary>
    property AvgTime: Integer read GetAvgTime;
    /// <summmary>����������ʱ�䣬��λΪ0.1ms</summary>
    property EscapedTime: Int64 read GetEscapedTime;
    /// <summary>�Ƿ�ֻ����һ�Σ�Ͷ����ҵʱ�Զ�����</summary>
    property Runonce: Boolean index JOB_RUN_ONCE read GetFlags;
    /// <summary>�Ƿ�Ҫ�������߳�ִ����ҵ��ʵ��Ч����Windows��PostMessage����</summary>
    property InMainThread: Boolean index JOB_IN_MAINTHREAD read GetFlags;
    /// <summary>�Ƿ���һ������ʱ��Ƚϳ�����ҵ����Workers.LongtimeWork����</summary>
    property IsLongtimeJob: Boolean index JOB_LONGTIME read GetFlags;
    /// <summary>�Ƿ���һ���źŴ�������ҵ</summary>
    property IsSignalWakeup: Boolean index JOB_SIGNAL_WAKEUP read GetFlags;
    /// <summary>�Ƿ��Ƿ�����ҵ�ĳ�Ա</summary>
    property IsGrouped: Boolean index JOB_GROUPED read GetFlags;
    /// <summary>�Ƿ�Ҫ�������ǰ��ҵ</summary>
    property IsTerminated: Boolean read GetIsTerminated write SetIsTerminated;
    /// <summary>�ж���ҵ��Dataָ�����һ��������Ҫ����ҵ���ʱ�Զ��ͷ�</summary>
    property IsObjectOwner: Boolean index JOB_FREE_OBJECT read GetFlags
      write SetFlags;
    /// <summary>�ж���ҵ��Dataָ�����һ����¼��Ҫ����ҵ���ʱ�Զ��ͷ�</summary>
    property IsRecordOwner: Boolean index JOB_FREE_RECORD read GetFlags
      write SetFlags;
    /// <summary>�ж���ҵ�Ƿ�ӵ��Data���ݳ�Ա
    property IsDataOwner: Boolean index JOB_DATA_OWNER read GetFlags;
    /// <summary>�ж���ҵ��Dataָ�����һ���ӿ���Ҫ����ҵ���ʱ�Զ��ͷ�</summary>
    property IsInterfaceOwner: Boolean index JOB_FREE_INTERFACE read GetFlags
      write SetFlags;
    /// <summary>�ж���ҵ��������Ƿ���һ����������</summary>
    property IsAnonWorkerProc: Boolean index JOB_ANONPROC read GetFlags
      write SetFlags;
  public
    FirstStartTime: Int64; // ��ҵ��һ�ο�ʼʱ��
    StartTime: Int64; // ������ҵ��ʼʱ��,8B
    PushTime: Int64; // ���ʱ��
    PopTime: Int64; // ����ʱ��
    NextTime: Int64; // ��һ�����е�ʱ��,+8B=16B
    WorkerProc: TQJobProc; // ��ҵ������+8/16B
{$IFDEF UNICODE}
    WorkerProcA: TQJobProcA;
{$ENDIF}
    Owner: TQJobs; // ��ҵ�������Ķ���
    Next: PQJob; // ��һ�����
    Worker: TQWorker; // ��ǰ��ҵ������
    Runs: Integer; // �Ѿ����еĴ���+4B
    MinUsedTime: Integer; // ��С����ʱ��+4B
    TotalUsedTime: Integer; // �����ܼƻ��ѵ�ʱ�䣬TotalUsedTime/Runs���Եó�ƽ��ִ��ʱ��+4B
    MaxUsedTime: Integer; // �������ʱ��+4B
    Flags: Integer; // ��ҵ��־λ+4B
    Data: Pointer; // ������������
    case Integer of
      0:
        (SignalId: Integer; // �źű���
          Source: PQJob; // Դ��ҵ��ַ
          RefCount: PInteger; // Դ����
        );
      1:
        (Interval: Int64; // ����ʱ��������λΪ0.1ms��ʵ�ʾ����ܲ�ͬ����ϵͳ����+8B
          FirstDelay: Int64; // �״������ӳ٣���λΪ0.1ms��Ĭ��Ϊ0
        );
      2: // ������ҵ֧��
        (Group: Pointer;
        );
  end;

  // /// <summary>�����߼�¼�ĸ�������</summary>
  // TQJobHelper = record helper for TQJob
  //
  // end;

  // ��ҵ���ж���Ļ��࣬�ṩ�����Ľӿڷ�װ
  TQJobs = class
  protected
    FOwner: TQWorkers;
    function InternalPush(AJob: PQJob): Boolean; virtual; abstract;
    function InternalPop: PQJob; virtual; abstract;
    function GetCount: Integer; virtual; abstract;
    function GetEmpty: Boolean;
    /// <summary>Ͷ��һ����ҵ</summary>
    /// <param name="AJob">ҪͶ�ĵ���ҵ</param>
    /// <remarks>�ⲿ��Ӧ����ֱ��Ͷ�����񵽶��У�����TQWorkers����Ӧ�����ڲ����á�</remarks>
    function Push(AJob: PQJob): Boolean; virtual;
    /// <summary>����һ����ҵ</summary>
    /// <returns>���ص�ǰ����ִ�еĵ�һ����ҵ</returns>
    function Pop: PQJob; virtual;
    /// <summary>���������ҵ</summary>
    procedure Clear; overload; virtual;
    /// <summary>���ָ������ҵ</summary>
    function Clear(AProc: TQJobProc; AData: Pointer; AMaxTimes: Integer)
      : Integer; overload; virtual; abstract;
    /// <summary>���һ�����������������ҵ</summary>
    function Clear(AObject: Pointer; AMaxTimes: Integer): Integer; overload;
      virtual; abstract;
  public
    constructor Create(AOwner: TQWorkers); overload; virtual;
    destructor Destroy; override;
    /// ���ɿ����棺Count��Emptyֵ����һ���ο����ڶ��̻߳����¿��ܲ�����֤��һ�����ִ��ʱ����һ��
    property Empty: Boolean read GetEmpty; // ��ǰ�����Ƿ�Ϊ��
    property Count: Integer read GetCount; // ��ǰ����Ԫ������
  end;
{$IFDEF QWORKER_SIMPLE_LOCK}

  // һ������λ���ļ���������ʹ��ԭ�Ӻ�����λ
  TQSimpleLock = class
  private
    FFlags: Integer;
  public
    constructor Create;
    procedure Enter; inline;
    procedure Leave; inline;
  end;
{$ELSE}

  TQSimpleLock = TCriticalSection;
{$ENDIF}

  // TQSimpleJobs���ڹ���򵥵��첽���ã�û�д���ʱ��Ҫ�����ҵ
  TQSimpleJobs = class(TQJobs)
  protected
    FFirst, FLast: PQJob;
    FCount: Integer;
    FLocker: TQSimpleLock;
    function InternalPush(AJob: PQJob): Boolean; override;
    function InternalPop: PQJob; override;
    function GetCount: Integer; override;
    procedure Clear; overload; override;
    function Clear(AObject: Pointer; AMaxTimes: Integer): Integer;
      overload; override;
    function Clear(AProc: TQJobProc; AData: Pointer; AMaxTimes: Integer)
      : Integer; overload; override;
  public
    constructor Create(AOwner: TQWorkers); override;
    destructor Destroy; override;
  end;

  // TQRepeatJobs���ڹ���ƻ���������Ҫ��ָ����ʱ��㴥��
  TQRepeatJobs = class(TQJobs)
  protected
    FItems: TQRBTree;
    FLocker: TCriticalSection;
    FFirstFireTime: Int64;
    function InternalPush(AJob: PQJob): Boolean; override;
    function InternalPop: PQJob; override;
    function DoTimeCompare(P1, P2: Pointer): Integer;
    procedure DoJobDelete(ATree: TQRBTree; ANode: TQRBNode);
    function GetCount: Integer; override;
    procedure Clear; override;
    function Clear(AObject: Pointer; AMaxTimes: Integer): Integer;
      overload; override;
    function Clear(AProc: TQJobProc; AData: Pointer; AMaxTimes: Integer)
      : Integer; overload; override;
    procedure AfterJobRun(AJob: PQJob; AUsedTime: Int64);
  public
    constructor Create(AOwner: TQWorkers); override;
    destructor Destroy; override;
  end;

  { �������߳�ʹ�õ���������������ǽ��������������Ϊ���ڹ������������ޣ�����
    �Ĵ���������ֱ����򵥵�ѭ��ֱ����Ч
  }
  TQWorker = class(TThread)
  protected
    FOwner: TQWorkers;
    FEvent: TEvent;
    FTimeout: Integer;
    FNext: TQWorker;
    FFlags: Integer;
    FActiveJob: PQJob;
    // ֮���Բ�ֱ��ʹ��FActiveJob����ط���������Ϊ��֤�ⲿ�����̰߳�ȫ�ķ�����������Ա
    FActiveJobProc: TQJobProc;
    FActiveJobData: Pointer;
    FActiveJobSource: PQJob;
    FActiveJobGroup: TQJobGroup;
    FActiveJobFlags: Integer;
    FTerminatingJob: PQJob;
    procedure Execute; override;
    procedure FireInMainThread;
    procedure DoJob(AJob: PQJob);
    function GetIsIdle: Boolean; inline;
    procedure SetFlags(AIndex: Integer; AValue: Boolean); inline;
    function GetFlags(AIndex: Integer): Boolean; inline;
  public
    constructor Create(AOwner: TQWorkers); overload;
    destructor Destroy; override;
    procedure ComNeeded(AInitFlags: Cardinal = 0);
    /// <summary>�жϵ�ǰ�Ƿ��ڳ�ʱ����ҵ���������</summary>
    property InLongtimeJob: Boolean index WORKER_PROCESSLONG read GetFlags;
    /// <summary>�жϵ�ǰ�Ƿ����</summary>
    property IsIdle: Boolean read GetIsIdle;
    /// <summary>�жϵ�ǰ�Ƿ�æµ</summary>
    property IsBusy: Boolean index WORKER_ISBUSY read GetFlags;
    /// <summary>�жϵ�ǰ�������Ƿ����ڲ������Ĺ�����
    property IsReserved: Boolean index WORKER_RESERVED read GetFlags;
    property IsLookuping: Boolean index WORKER_LOOKUP read GetFlags;
    property IsExecuting: Boolean index WORKER_EXECUTING read GetFlags;
    property IsExecuted: Boolean index WORKER_EXECUTED read GetFlags;
    /// <summary>�ж�COM�Ƿ��Ѿ���ʼ��Ϊ֧��COM
    property ComInitialized: Boolean index WORKER_COM_INITED read GetFlags;
  end;

  /// <summary>�źŵ��ڲ�����</summary>
  TQSignal = record
    Id: Integer;
    /// <summary>�źŵı���</summary>
    Fired: Integer; // <summary>�ź��Ѵ�������</summary>
    Name: QStringW;
    /// <summary>�źŵ�����</summary>
    First: PQJob;
    /// <summary>�׸���ҵ</summary>
  end;

  TWorkerWaitParam = record
    WaitType: Byte;
    Data: Pointer;
    case Integer of
      0:
        (Bound: Pointer); // ���������
      1:
        (WorkerProc: TMethod;);
      2:
        (SourceJob: PQJob);
      3:
        (Group: Pointer);
  end;

  /// <summary>�����߹�����������������ߺ���ҵ</summary>
  TQWorkers = class
  protected
    FWorkers: array of TQWorker;
    FDisableCount: Integer;
    FMinWorkers: Integer;
    FMaxWorkers: Integer;
    FWorkerCount: Integer;
    FBusyCount: Integer;
    FLongTimeWorkers: Integer; // ��¼�³�ʱ����ҵ�еĹ����ߣ���������ʱ�䲻�ͷ���Դ�����ܻ�������������޷���ʱ��Ӧ
    FMaxLongtimeWorkers: Integer; // �������ͬʱִ�еĳ�ʱ������������������MaxWorkers��һ��
    FLocker: TCriticalSection;
    FSimpleJobs: TQSimpleJobs;
    FRepeatJobs: TQRepeatJobs;
    FSignalJobs: TQHashTable;
    FMaxSignalId: Integer;
    FTerminating: Boolean;
{$IFDEF MSWINDOWS}
    FMainWorker: HWND;
    procedure DoMainThreadWork(var AMsg: TMessage);
{$ENDIF}
    function Popup: PQJob;
    procedure SetMaxWorkers(const Value: Integer);
    function GetEnabled: Boolean;
    procedure SetEnabled(const Value: Boolean);
    procedure SetMinWorkers(const Value: Integer);
    procedure WorkerIdle(AWorker: TQWorker; AReason: TWorkerIdleReason); inline;
    procedure WorkerBusy(AWorker: TQWorker); inline;
    procedure WorkerTerminate(AWorker: TObject);
    procedure FreeJob(AJob: PQJob);
    function LookupIdleWorker: Boolean;
    procedure ClearWorkers;
    procedure SignalWorkDone(AJob: PQJob; AUsedTime: Int64);
    procedure DoJobFree(ATable: TQHashTable; AHash: Cardinal; AData: Pointer);
    function Post(AJob: PQJob): Boolean; overload;
    procedure SetMaxLongtimeWorkers(const Value: Integer);
    function SignalIdByName(const AName: QStringW): Integer;
    procedure FireSignalJob(ASignal: PQSignal; AData: Pointer;
      AFreeType: TQJobDataFreeType);
    function ClearSignalJobs(ASource: PQJob): Integer;
    procedure WaitSignalJobsDone(AJob: PQJob);
    procedure WaitRunningDone(const AParam: TWorkerWaitParam);
    procedure FreeJobData(AData: Pointer; AFreeType: TQJobDataFreeType);
  public
    constructor Create(AMinWorkers: Integer = 2); overload;
    destructor Destroy; override;
    /// <summary>Ͷ��һ����̨������ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <returns>�ɹ�Ͷ�ķ���True�����򷵻�False</returns>
    function Post(AProc: TQJobProc; AData: Pointer;
      ARunInMainThread: Boolean = False;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): Boolean; overload;
    /// <summary>Ͷ��һ����̨������ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <returns>�ɹ�Ͷ�ķ���True�����򷵻�False</returns>
    function Post(AProc: TQJobProcG; AData: Pointer;
      ARunInMainThread: Boolean = False;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): Boolean; overload;
{$IFDEF UNICODE}
    /// <summary>Ͷ��һ����̨������ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <returns>�ɹ�Ͷ�ķ���True�����򷵻�False</returns>
    function Post(AProc: TQJobProcA; AData: Pointer;
      ARunInMainThread: Boolean = False;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): Boolean; overload;
{$ENDIF}
    /// <summary>Ͷ��һ����̨��ʱ��ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="AInterval">Ҫ��ʱִ�е���ҵʱ��������λΪ0.1ms����Ҫ���1�룬��ֵΪ10000</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <returns>�ɹ�Ͷ�ķ���True�����򷵻�False</returns>
    function Post(AProc: TQJobProc; AInterval: Int64; AData: Pointer;
      ARunInMainThread: Boolean = False;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): Boolean; overload;
    /// <summary>Ͷ��һ����̨��ʱ��ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="AInterval">Ҫ��ʱִ�е���ҵʱ��������λΪ0.1ms����Ҫ���1�룬��ֵΪ10000</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <returns>�ɹ�Ͷ�ķ���True�����򷵻�False</returns>
    function Post(AProc: TQJobProcG; AInterval: Int64; AData: Pointer;
      ARunInMainThread: Boolean = False;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): Boolean; overload;
{$IFDEF UNICODE}
    /// <summary>Ͷ��һ����̨��ʱ��ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="AInterval">Ҫ��ʱִ�е���ҵʱ��������λΪ0.1ms����Ҫ���1�룬��ֵΪ10000</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <returns>�ɹ�Ͷ�ķ���True�����򷵻�False</returns>
    function Post(AProc: TQJobProcA; AInterval: Int64; AData: Pointer;
      ARunInMainThread: Boolean = False;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): Boolean; overload;
{$ENDIF}
    /// <summary>Ͷ��һ���ӳٿ�ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="AInterval">Ҫ�ӳٵ�ʱ�䣬��λΪ0.1ms����Ҫ���1�룬��ֵΪ10000</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <returns>�ɹ�Ͷ�ķ���True�����򷵻�False</returns>
    function Delay(AProc: TQJobProc; ADelay: Int64; AData: Pointer;
      ARunInMainThread: Boolean = False;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): Boolean; overload;
    /// <summary>Ͷ��һ���ӳٿ�ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="AInterval">Ҫ�ӳٵ�ʱ�䣬��λΪ0.1ms����Ҫ���1�룬��ֵΪ10000</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <returns>�ɹ�Ͷ�ķ���True�����򷵻�False</returns>
    function Delay(AProc: TQJobProcG; ADelay: Int64; AData: Pointer;
      ARunInMainThread: Boolean = False;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): Boolean; overload;
{$IFDEF UNICODE}
    /// <summary>Ͷ��һ���ӳٿ�ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="AInterval">Ҫ�ӳٵ�ʱ�䣬��λΪ0.1ms����Ҫ���1�룬��ֵΪ10000</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <returns>�ɹ�Ͷ�ķ���True�����򷵻�False</returns>
    function Delay(AProc: TQJobProcA; ADelay: Int64; AData: Pointer;
      ARunInMainThread: Boolean = False;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): Boolean; overload;
{$ENDIF}
    /// <summary>Ͷ��һ���ȴ��źŲſ�ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="ASignalId">�ȴ����źű��룬�ñ�����RegisterSignal��������</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <returns>�ɹ�Ͷ�ķ���True�����򷵻�False</returns>
    function Wait(AProc: TQJobProc; ASignalId: Integer;
      ARunInMainThread: Boolean = False): Boolean; overload;
    /// <summary>Ͷ��һ���ȴ��źŲſ�ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="ASignalId">�ȴ����źű��룬�ñ�����RegisterSignal��������</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <returns>�ɹ�Ͷ�ķ���True�����򷵻�False</returns>
    function Wait(AProc: TQJobProcG; ASignalId: Integer;
      ARunInMainThread: Boolean = False): Boolean; overload;
{$IFDEF UNICODE}
    /// <summary>Ͷ��һ���ȴ��źŲſ�ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="ASignalId">�ȴ����źű��룬�ñ�����RegisterSignal��������</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <returns>�ɹ�Ͷ�ķ���True�����򷵻�False</returns>
    function Wait(AProc: TQJobProcA; ASignalId: Integer;
      ARunInMainThread: Boolean = False): Boolean; overload;
{$ENDIF}
    /// <summary>Ͷ��һ����ָ��ʱ��ſ�ʼ���ظ���ҵ</summary>
    /// <param name="AProc">Ҫ��ʱִ�е���ҵ����</param>
    /// <param name="ADelay">��һ��ִ��ǰ���ӳ�ʱ��</param>
    /// <param name="AInterval">������ҵ�ظ���������С�ڵ���0������ҵִֻ��һ�Σ���Delay��Ч��һ��</param>
    /// <param name="ARunInMainThread">�Ƿ�Ҫ����ҵ�����߳���ִ��</param>
    function At(AProc: TQJobProc; const ADelay, AInterval: Int64;
      AData: Pointer; ARunInMainThread: Boolean = False;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): Boolean; overload;
    /// <summary>Ͷ��һ����ָ��ʱ��ſ�ʼ���ظ���ҵ</summary>
    /// <param name="AProc">Ҫ��ʱִ�е���ҵ����</param>
    /// <param name="ADelay">��һ��ִ��ǰ���ӳ�ʱ��</param>
    /// <param name="AInterval">������ҵ�ظ���������С�ڵ���0������ҵִֻ��һ�Σ���Delay��Ч��һ��</param>
    /// <param name="ARunInMainThread">�Ƿ�Ҫ����ҵ�����߳���ִ��</param>
    function At(AProc: TQJobProcG; const ADelay, AInterval: Int64;
      AData: Pointer; ARunInMainThread: Boolean = False;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): Boolean; overload;
{$IFDEF UNICODE}
    /// <summary>Ͷ��һ����ָ��ʱ��ſ�ʼ���ظ���ҵ</summary>
    /// <param name="AProc">Ҫ��ʱִ�е���ҵ����</param>
    /// <param name="ADelay">��һ��ִ��ǰ���ӳ�ʱ��</param>
    /// <param name="AInterval">������ҵ�ظ���������С�ڵ���0������ҵִֻ��һ�Σ���Delay��Ч��һ��</param>
    /// <param name="ARunInMainThread">�Ƿ�Ҫ����ҵ�����߳���ִ��</param>
    function At(AProc: TQJobProcA; const ADelay, AInterval: Int64;
      AData: Pointer; ARunInMainThread: Boolean = False;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): Boolean; overload;
{$ENDIF}
    /// <summary>Ͷ��һ����ָ��ʱ��ſ�ʼ���ظ���ҵ</summary>
    /// <param name="AProc">Ҫ��ʱִ�е���ҵ����</param>
    /// <param name="ATime">ִ��ʱ��</param>
    /// <param name="AInterval">������ҵ�ظ���������С�ڵ���0������ҵִֻ��һ�Σ���Delay��Ч��һ��</param>
    /// <param name="ARunInMainThread">�Ƿ�Ҫ����ҵ�����߳���ִ��</param>
    function At(AProc: TQJobProc; const ATime: TDateTime;
      const AInterval: Int64; AData: Pointer; ARunInMainThread: Boolean = False;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): Boolean; overload;
    /// <summary>Ͷ��һ����ָ��ʱ��ſ�ʼ���ظ���ҵ</summary>
    /// <param name="AProc">Ҫ��ʱִ�е���ҵ����</param>
    /// <param name="ATime">ִ��ʱ��</param>
    /// <param name="AInterval">������ҵ�ظ���������С�ڵ���0������ҵִֻ��һ�Σ���Delay��Ч��һ��</param>
    /// <param name="ARunInMainThread">�Ƿ�Ҫ����ҵ�����߳���ִ��</param>
    function At(AProc: TQJobProcG; const ATime: TDateTime;
      const AInterval: Int64; AData: Pointer; ARunInMainThread: Boolean = False;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): Boolean; overload;
{$IFDEF UNICODE}
    /// <summary>Ͷ��һ����ָ��ʱ��ſ�ʼ���ظ���ҵ</summary>
    /// <param name="AProc">Ҫ��ʱִ�е���ҵ����</param>
    /// <param name="ATime">ִ��ʱ��</param>
    /// <param name="AInterval">������ҵ�ظ���������С�ڵ���0������ҵִֻ��һ�Σ���Delay��Ч��һ��</param>
    /// <param name="ARunInMainThread">�Ƿ�Ҫ����ҵ�����߳���ִ��</param>
    function At(AProc: TQJobProcA; const ATime: TDateTime;
      const AInterval: Int64; AData: Pointer; ARunInMainThread: Boolean = False;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): Boolean; overload;
{$ENDIF}
    /// <summary>Ͷ��һ����̨��ʱ��ִ�е���ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <returns>�ɹ�Ͷ�ķ���True�����򷵻�False</returns>
    /// <remarks>��ʱ����ҵǿ���ں�̨�߳���ִ�У���������Ͷ�ݵ����߳���ִ��</remarks>
    function LongtimeJob(AProc: TQJobProc; AData: Pointer;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): Boolean; overload;
    /// <summary>Ͷ��һ����̨��ʱ��ִ�е���ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <returns>�ɹ�Ͷ�ķ���True�����򷵻�False</returns>
    /// <remarks>��ʱ����ҵǿ���ں�̨�߳���ִ�У���������Ͷ�ݵ����߳���ִ��</remarks>
    function LongtimeJob(AProc: TQJobProcG; AData: Pointer;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): Boolean; overload;
{$IFDEF UNICODE}
    /// <summary>Ͷ��һ����̨��ʱ��ִ�е���ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <returns>�ɹ�Ͷ�ķ���True�����򷵻�False</returns>
    /// <remarks>��ʱ����ҵǿ���ں�̨�߳���ִ�У���������Ͷ�ݵ����߳���ִ��</remarks>
    function LongtimeJob(AProc: TQJobProcA; AData: Pointer;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): Boolean; overload;
{$ENDIF}
    /// <summary>���������ҵ</summary>
    procedure Clear; overload;
    /// <summary>���һ��������ص�������ҵ</summary>
    /// <param name="AObject">Ҫ�ͷŵ���ҵ������̹�������</param>
    /// <param name="AMaxTimes">�����������������<0����ȫ��</param>
    /// <returns>����ʵ���������ҵ����</returns>
    /// <remarks>һ����������ƻ�����ҵ�������Լ��ͷ�ǰӦ���ñ������������������ҵ��
    /// ����δ��ɵ���ҵ���ܻᴥ���쳣��</remarks>
    function Clear(AObject: Pointer; AMaxTimes: Integer = -1): Integer;
      overload;
    /// <summary>�������Ͷ�ĵ�ָ��������ҵ</summary>
    /// <param name="AProc">Ҫ�������ҵִ�й���</param>
    /// <param name="AData">Ҫ�������ҵ��������ָ���ַ�����ֵΪPointer(-1)��
    /// ��������е���ع��̣�����ֻ����������ݵ�ַһ�µĹ���</param>
    /// <param name="AMaxTimes">�����������������<0����ȫ��</param>
    /// <returns>����ʵ���������ҵ����</returns>
    function Clear(AProc: TQJobProc; AData: Pointer; AMaxTimes: Integer = -1)
      : Integer; overload;
    /// <summary>���ָ���źŹ�����������ҵ</summary>
    /// <param name="ASingalId">Ҫ������ź�ID</param>
    /// <returns>����ʵ���������ҵ����</returns>
    function Clear(ASignalName: QStringW): Integer; overload;
    /// <summary>���ָ���źŹ�����������ҵ</summary>
    /// <param name="ASingalId">Ҫ������ź�����</param>
    /// <returns>����ʵ���������ҵ����</returns>
    function Clear(ASignalId: Integer): Integer; overload;
    /// <summary>����һ���ź�</summary>
    /// <param name="AId">�źű��룬��RegisterSignal����</param>
    /// <param name="AData">���Ӹ���ҵ���û�����ָ���ַ</param>
    /// <remarks>����һ���źź�QWorkers�ᴥ��������ע����źŹ���������̵�ִ��</remarks>
    procedure Signal(AId: Integer; AData: Pointer = nil;
      AFreeType: TQJobDataFreeType = jdfFreeByUser); overload;
    /// <summary>�����ƴ���һ���ź�</summary>
    /// <param name="AName">�ź�����</param>
    /// <param name="AData">���Ӹ���ҵ���û�����ָ���ַ</param>
    /// <remarks>����һ���źź�QWorkers�ᴥ��������ע����źŹ���������̵�ִ��</remarks>
    procedure Signal(const AName: QStringW; AData: Pointer = nil;
      AFreeType: TQJobDataFreeType = jdfFreeByUser); overload;
    /// <summary>ע��һ���ź�</summary>
    /// <param name="AName">�ź�����</param>
    /// <remarks>
    /// 1.�ظ�ע��ͬһ���Ƶ��źŽ�����ͬһ������
    /// 2.�ź�һ��ע�ᣬ��ֻ�г����˳�ʱ�Ż��Զ��ͷ�
    /// </remarks>
    function RegisterSignal(const AName: QStringW): Integer; // ע��һ���ź�����

    procedure EnableWorkers;
    procedure DisableWorkers;
    /// <summary>���������������������С��2</summary>
    property MaxWorkers: Integer read FMaxWorkers write SetMaxWorkers;
    /// <summary>��С����������������С��2<summary>
    property MinWorkers: Integer read FMinWorkers write SetMinWorkers;
    /// <summary>�������ĳ�ʱ����ҵ�������������ȼ�������ʼ�ĳ�ʱ����ҵ����</summary>
    property MaxLongtimeWorkers: Integer read FMaxLongtimeWorkers
      write SetMaxLongtimeWorkers;
    /// <summary>�Ƿ�����ʼ��ҵ�����Ϊfalse����Ͷ�ĵ���ҵ�����ᱻִ�У�ֱ���ָ�ΪTrue</summary>
    /// <remarks>EnabledΪFalseʱ�Ѿ����е���ҵ����Ȼ���У���ֻӰ����δִ�е�����</remarks>
    property Enabled: Boolean read GetEnabled write SetEnabled;
    /// <summary>�Ƿ������ͷ�TQWorkers��������</summary>
    property Terminating: Boolean read FTerminating;
  end;
{$IFDEF UNICODE}

  TQJobItemList = TList<PQJob>;
{$ELSE}
  TQJobItemList = TList;
{$ENDIF}

  TQJobGroup = class
  protected
    FEvent: TEvent; // �¼������ڵȴ���ҵ���
    FCount: Integer; // ���ڵ���ҵ����
    FLocker: TQSimpleLock;
    FItems: TQJobItemList; // ��ҵ�б�
    FPrepareCount: Integer; // ׼������
    FByOrder: Boolean; // �Ƿ�˳�򴥷���ҵ��������ȴ���һ����ҵ��ɺ��ִ����һ��
    FAfterDone: TNotifyEvent; // ��ҵ����¼�֪ͨ
    FWaitResult: TWaitResult;
    FTimeout: Int64;
    FTag: Pointer;
    procedure DoJobExecuted(AJob: PQJob);
    procedure DoJobsTimeout(AJob: PQJob);
    procedure DoAfterDone;
  public
    /// AByOrderָ���Ƿ���˳����ҵ����ҵ֮���������ִ��
    constructor Create(AByOrder: Boolean = False); overload;
    destructor Destroy; override;
    procedure Cancel;
    // ׼�������ҵ��ʵ�������ڲ�������
    procedure Prepare;
    // �����ڲ��������������������Ϊ0����ʼʵ��ִ����ҵ
    procedure Run(ATimeout: Cardinal = INFINITE);
    // ���һ����ҵ���̣����׼���ڲ�������Ϊ0����ֱ��ִ�У�����ֻ��ӵ��б�
    function Add(AProc: TQJobProc; AData: Pointer;
      AInMainThread: Boolean = False;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): Boolean;
    // �ȴ���ҵ��ɣ�ATimeoutΪ��ȴ�ʱ��
    function WaitFor(ATimeout: Cardinal = INFINITE): TWaitResult;
    // �ȴ���ҵ��ɣ�ATimeoutΪ��ȴ�ʱ�䣬��ͬ����MsgWaitFor��������Ϣ����
    function MsgWaitFor(ATimeout: Cardinal = INFINITE): TWaitResult;
    // δ��ɵ���ҵ����
    property Count: Integer read FCount;
    /// ȫ����ҵִ�����ʱ�����Ļص��¼�
    property AfterDone: TNotifyEvent read FAfterDone write FAfterDone;
    /// �Ƿ��ǰ�˳��ִ�У�ֻ���ڹ��캯����ָ�����˴�ֻ��
    property ByOrder: Boolean read FByOrder;
    property Tag: Pointer read FTag write FTag;
  end;

  /// <summary>��ȫ�ֵ���ҵ������ת��ΪTQJobProc���ͣ��Ա���������ʹ��</summary>
  /// <param name="AProc">ȫ�ֵ���ҵ������</param>
  /// <returns>�����µ�TQJobProcʵ��</returns>
function MakeJobProc(const AProc: TQJobProcG): TQJobProc; overload;
// ��ȡϵͳ��CPU�ĺ�������
function GetCPUCount: Integer;
// ��ȡ��ǰϵͳ��ʱ�������߿ɾ�ȷ��0.1ms����ʵ���ܲ���ϵͳ����
function GetTimestamp: Int64;
// �����߳����е�CPU
procedure SetThreadCPU(AHandle: THandle; ACpuNo: Integer);
// ԭ������������
function AtomicAnd(var Dest: Integer; const AMask: Integer): Integer;
// ԭ������������
function AtomicOr(var Dest: Integer; const AMask: Integer): Integer;
function JobPoolCount: NativeInt;
function JobPoolPrint: QStringW;

var
  Workers: TQWorkers;

implementation

resourcestring
  SNotSupportNow = '��ǰ��δ֧�ֹ��� %s';
  STooFewWorkers = 'ָ������С����������̫��(������ڵ���1)��';
  STooManyLongtimeWorker = '��������̫�೤ʱ����ҵ�߳�(�����������һ��)��';
  SBadWaitDoneParam = 'δ֪�ĵȴ�����ִ����ҵ��ɷ�ʽ:%d';

type
{$IFDEF MSWINDOWS}
  TGetTickCount64 = function: Int64;
{$ENDIF MSWINDOWS}

  TJobPool = class
  protected
    FFirst: PQJob;
    FCount: Integer;
    FSize: Integer;
    FLocker: TQSimpleLock;
  public
    constructor Create(AMaxSize: Integer); overload;
    destructor Destroy; override;
    procedure Push(AJob: PQJob);
    function Pop: PQJob;
    property Count: Integer read FCount;
    property Size: Integer read FSize write FSize;
  end;

var
  JobPool: TJobPool;
{$IFDEF NEXTGEN}
  _Watch: TStopWatch;
{$ELSE}
  GetTickCount64: TGetTickCount64;
  _PerfFreq: Int64;
{$ENDIF}

procedure JobInitialize(AJob: PQJob; AData: Pointer;
  AFreeType: TQJobDataFreeType; ARunOnce, ARunInMainThread: Boolean); inline;
begin
AJob.Data := AData;
if AData <> nil then
  begin
  case AFreeType of
    jdfFreeAsObject:
      AJob.IsObjectOwner := true;
    jdfFreeAsRecord:
      AJob.IsRecordOwner := true;
    jdfFreeAsInterface:
      begin
      AJob.IsInterfaceOwner := true;
      IUnknown(AData)._AddRef;
      end;
  end;
  end;
AJob.SetFlags(JOB_RUN_ONCE, ARunOnce);
AJob.SetFlags(JOB_IN_MAINTHREAD, ARunInMainThread);
end;

// λ�룬����ԭֵ
function AtomicAnd(var Dest: Integer; const AMask: Integer): Integer; inline;
var
  i: Integer;
begin
repeat
  Result := Dest;
  i := Result and AMask;
until AtomicCmpExchange(Dest, i, Result) = Result;
end;

// λ�򣬷���ԭֵ
function AtomicOr(var Dest: Integer; const AMask: Integer): Integer; inline;
var
  i: Integer;
begin
repeat
  Result := Dest;
  i := Result or AMask;
until AtomicCmpExchange(Dest, i, Result) = Result;
end;
{$IFDEF MSWINDOWS}
// function InterlockedCompareExchange64
{$ENDIF}

procedure SetThreadCPU(AHandle: THandle; ACpuNo: Integer);
begin
{$IFDEF MSWINDOWS}
SetThreadIdealProcessor(AHandle, ACpuNo);
{$ELSE}
// Linux/Andriod/iOS��ʱ����,XE6δ����sched_setaffinity����
{$ENDIF}
end;

// ����ֵ��ʱ�侫��Ϊ100ns����0.1ms
function GetTimestamp: Int64;
begin
{$IFDEF NEXTGEN}
Result := _Watch.Elapsed.Ticks div 1000;
{$ELSE}
if _PerfFreq > 0 then
  begin
  QueryPerformanceCounter(Result);
  Result := Result * 10000 div _PerfFreq;
  end
else if Assigned(GetTickCount64) then
  Result := GetTickCount64 * 10000
else
  Result := GetTickCount * 10000;
{$ENDIF}
end;

function GetCPUCount: Integer;
{$IFDEF MSWINDOWS}
var
  si: SYSTEM_INFO;
{$ENDIF}
begin
{$IFDEF MSWINDOWS}
GetSystemInfo(si);
Result := si.dwNumberOfProcessors;
{$ELSE}// Linux,MacOS,iOS,Andriod{POSIX}
{$IFDEF POSIX}
Result := sysconf(_SC_NPROCESSORS_ONLN);
{$ELSE}// ����ʶ�Ĳ���ϵͳ��CPU��Ĭ��Ϊ1
Result := 1;
{$ENDIF !POSIX}
{$ENDIF !MSWINDOWS}
end;

function MakeJobProc(const AProc: TQJobProcG): TQJobProc;
begin
TMethod(Result).Data := nil;
TMethod(Result).Code := @AProc;
end;

function SameWorkerProc(const P1, P2: TQJobProc): Boolean; inline;
begin
Result := (TMethod(P1).Code = TMethod(P2).Code) and
  (TMethod(P1).Data = TMethod(P2).Data);
end;
{ TQJob }

procedure TQJob.AfterRun(AUsedTime: Int64);
begin
Inc(Runs);
if AUsedTime > 0 then
  begin
  Inc(TotalUsedTime, AUsedTime);
  if MinUsedTime = 0 then
    MinUsedTime := AUsedTime
  else if MinUsedTime > AUsedTime then
    MinUsedTime := AUsedTime;
  if MaxUsedTime = 0 then
    MaxUsedTime := AUsedTime
  else if MaxUsedTime < AUsedTime then
    MaxUsedTime := AUsedTime;
  end;
end;

procedure TQJob.Assign(const ASource: PQJob);
begin
Self := ASource^;
// StartTime := ASource.StartTime;
// PushTime := ASource.PushTime; // ���ʱ��
// PopTime := ASource.PopTime;
// NextTime := ASource.NextTime;
// WorkerProc := ASource.WorkerProc; // ��ҵ������+8/16B
// {$IFDEF UNICODE}
// WorkerProcA := ASource.WorkerProcA;
// {$ENDIF}
// Runs := ASource.Runs;
// MinUsedTime := ASource.MinUsedTime; // ��С����ʱ��+4B
// TotalUsedTime := ASource.TotalUsedTime;
// MaxUsedTime := ASource.MaxUsedTime;
// Flags := ASource.Flags;
// Data := ASource.Data;
// SignalId := ASource.SignalId;
// Runs:=AJob.Runs;
// ����������Ա������
Worker := nil;
Next := nil;
Source := nil;
end;

constructor TQJob.Create(AProc: TQJobProc);
begin
WorkerProc := AProc;
SetFlags(JOB_RUN_ONCE, true);
end;

function TQJob.GetAvgTime: Integer;
begin
if Runs > 0 then
  Result := TotalUsedTime div Runs
else
  Result := 0;
end;

function TQJob.GetIsTerminated: Boolean;
begin
if Assigned(Worker) then
  Result := Workers.Terminating or Worker.Terminated or
    ((Flags and JOB_TERMINATED) <> 0) or (Worker.FTerminatingJob = @Self)
else
  Result := (Flags and JOB_TERMINATED) <> 0;
end;

function TQJob.GetEscapedTime: Int64;
begin
Result := GetTimestamp - StartTime;
end;

function TQJob.GetFlags(AIndex: Integer): Boolean;
begin
Result := (Flags and AIndex) <> 0;
end;

procedure TQJob.Reset;
begin
FillChar(Self, SizeOf(TQJob), 0);
end;

procedure TQJob.SetFlags(AIndex: Integer; AValue: Boolean);
begin
if AValue then
  Flags := (Flags or AIndex)
else
  Flags := (Flags and (not AIndex));
end;

procedure TQJob.SetIsTerminated(const Value: Boolean);
begin
SetFlags(JOB_TERMINATED, Value);
end;

procedure TQJob.Synchronize(AMethod: TThreadMethod);
begin
Worker.Synchronize(AMethod);
end;

procedure TQJob.UpdateNextTime;
begin
if (Runs = 0) and (FirstDelay <> 0) then
  NextTime := PushTime + FirstDelay
else if Interval <> 0 then
  begin
  if NextTime = 0 then
    NextTime := GetTimestamp + Interval
  else
    Inc(NextTime, Interval);
  end
else
  NextTime := GetTimestamp;
end;

{ TQSimpleJobs }

function TQSimpleJobs.Clear(AObject: Pointer; AMaxTimes: Integer): Integer;
var
  AFirst, AJob, APrior, ANext: PQJob;
  ACount: Integer;
begin
// �Ƚ�SimpleJobs���е��첽��ҵ��գ��Է�ֹ������ִ��
FLocker.Enter;
AJob := FFirst;
ACount := FCount;
FFirst := nil;
FLast := nil;
FCount := 0;
FLocker.Leave;

Result := 0;
APrior := nil;
AFirst := nil;
while (AJob <> nil) and (AMaxTimes <> 0) do
  begin
  ANext := AJob.Next;
  if TMethod(AJob.WorkerProc).Data = AObject then
    begin
    if APrior <> nil then
      APrior.Next := ANext;
    AJob.Next := nil;
    FOwner.FreeJob(AJob);
    Dec(AMaxTimes);
    Inc(Result);
    Dec(ACount);
    end
  else
    begin
    if AFirst = nil then
      AFirst := AJob;
    APrior := AJob;
    end;
  AJob := ANext;
  end;
if ACount > 0 then
  begin
  FLocker.Enter;
  AFirst.Next := FFirst;
  FFirst := AFirst;
  Inc(FCount, ACount);
  if FLast = nil then
    FLast := APrior;
  FLocker.Leave;
  end;
end;

function TQSimpleJobs.Clear(AProc: TQJobProc; AData: Pointer;
  AMaxTimes: Integer): Integer;
var
  AFirst, AJob, APrior, ANext: PQJob;
  ACount: Integer;
begin
FLocker.Enter;
AJob := FFirst;
ACount := FCount;
FFirst := nil;
FLast := nil;
FCount := 0;
FLocker.Leave;
Result := 0;
APrior := nil;
AFirst := nil;
while (AJob <> nil) and (AMaxTimes <> 0) do
  begin
  ANext := AJob.Next;
  if SameWorkerProc(AJob.WorkerProc, AProc) and (AJob.Data = AData) then
    begin
    if APrior <> nil then
      APrior.Next := ANext;
    FOwner.FreeJob(AJob);
    Dec(AMaxTimes);
    Inc(Result);
    Dec(ACount);
    end
  else
    begin
    if AFirst = nil then
      AFirst := AJob;
    APrior := AJob;
    end;
  AJob := ANext;
  end;
if ACount > 0 then
  begin
  FLocker.Enter;
  AFirst.Next := FFirst;
  FFirst := AFirst;
  Inc(FCount, ACount);
  if FLast = nil then
    FLast := APrior;
  FLocker.Leave;
  end;
end;

procedure TQSimpleJobs.Clear;
var
  AFirst: PQJob;
begin
FLocker.Enter;
AFirst := FFirst;
FFirst := nil;
FLast := nil;
FCount := 0;
FLocker.Leave;
FOwner.FreeJob(AFirst);
end;

constructor TQSimpleJobs.Create(AOwner: TQWorkers);
begin
inherited Create(AOwner);
FLocker := TQSimpleLock.Create;
end;

destructor TQSimpleJobs.Destroy;
begin
inherited;
FreeObject(FLocker);
end;

function TQSimpleJobs.GetCount: Integer;
begin
Result := FCount;
end;

function TQSimpleJobs.InternalPop: PQJob;
begin
FLocker.Enter;
Result := FFirst;
if Result <> nil then
  begin
  FFirst := Result.Next;
  if FFirst = nil then
    FLast := nil;
  Dec(FCount);
  end;
FLocker.Leave;
end;

function TQSimpleJobs.InternalPush(AJob: PQJob): Boolean;
begin
FLocker.Enter;
if FLast = nil then
  FFirst := AJob
else
  FLast.Next := AJob;
FLast := AJob;
Inc(FCount);
FLocker.Leave;
Result := true;
end;

{ TQJobs }

procedure TQJobs.Clear;
var
  AItem: PQJob;
begin
repeat
  AItem := Pop;
  if AItem <> nil then
    FOwner.FreeJob(AItem)
  else
    Break;
until 1 > 2;
end;

constructor TQJobs.Create(AOwner: TQWorkers);
begin
inherited Create;
FOwner := AOwner;
end;

destructor TQJobs.Destroy;
begin
Clear;
inherited;
end;

function TQJobs.GetEmpty: Boolean;
begin
Result := (Count = 0);
end;

function TQJobs.Pop: PQJob;
begin
Result := InternalPop;
if Result <> nil then
  begin
  Result.PopTime := GetTimestamp;
  Result.Next := nil;
  end;
end;

function TQJobs.Push(AJob: PQJob): Boolean;
begin
AJob.Owner := Self;
AJob.PushTime := GetTimestamp;
Result := InternalPush(AJob);
if not Result then
  begin
  AJob.Next := nil;
  FOwner.FreeJob(AJob);
  end;
end;

{ TQRepeatJobs }

procedure TQRepeatJobs.Clear;
begin
FLocker.Enter;
try
  FItems.Clear;
finally
  FLocker.Leave;
end;
end;

function TQRepeatJobs.Clear(AObject: Pointer; AMaxTimes: Integer): Integer;
var
  ANode, ANext: TQRBNode;
  APriorJob, AJob, ANextJob: PQJob;
  ACanDelete: Boolean;
begin
// ��������ظ��ļƻ���ҵ
Result := 0;
FLocker.Enter;
try
  ANode := FItems.First;
  while (ANode <> nil) and (AMaxTimes <> 0) do
    begin
    ANext := ANode.Next;
    AJob := ANode.Data;
    ACanDelete := true;
    APriorJob := nil;
    while AJob <> nil do
      begin
      ANextJob := AJob.Next;
      if TMethod(AJob.WorkerProc).Data = AObject then
        begin
        if ANode.Data = AJob then
          ANode.Data := AJob.Next;
        if Assigned(APriorJob) then
          APriorJob.Next := AJob.Next;
        AJob.Next := nil;
        FOwner.FreeJob(AJob);
        Dec(AMaxTimes);
        Inc(Result);
        end
      else
        begin
        ACanDelete := False;
        APriorJob := AJob;
        end;
      AJob := ANextJob;
      end;
    if ACanDelete then
      FItems.Delete(ANode);
    ANode := ANext;
    end;
  if FItems.Count > 0 then
    FFirstFireTime := PQJob(FItems.First.Data).NextTime
  else
    FFirstFireTime := 0;
finally
  FLocker.Leave;
end;
end;

procedure TQRepeatJobs.AfterJobRun(AJob: PQJob; AUsedTime: Int64);
var
  ANode: TQRBNode;
  function UpdateSource: Boolean;
  var
    ATemp, APrior: PQJob;
  begin
  Result := False;
  ATemp := ANode.Data;
  APrior := nil;
  while ATemp <> nil do
    begin
    if ATemp = AJob.Source then
      begin
      if AJob.IsTerminated then
        begin
        if APrior <> nil then
          APrior.Next := ATemp.Next
        else
          ANode.Data := ATemp.Next;
        ATemp.Next := nil;
        FOwner.FreeJob(ATemp);
        if ANode.Data = nil then
          FItems.Delete(ANode);
        end
      else
        ATemp.AfterRun(AUsedTime);
      Result := true;
      Break;
      end;
    APrior := ATemp;
    ATemp := ATemp.Next;
    end;
  end;

begin
FLocker.Enter;
try
  ANode := FItems.Find(AJob);
  if ANode <> nil then
    begin
    if UpdateSource then
      Exit;
    end;
  ANode := FItems.First;
  while ANode <> nil do
    begin
    if UpdateSource then
      Break;
    ANode := ANode.Next;
    end;
finally
  FLocker.Leave;
end;
end;

function TQRepeatJobs.Clear(AProc: TQJobProc; AData: Pointer;
  AMaxTimes: Integer): Integer;
var
  AJob, APrior, ANext: PQJob;
  ANode, ANextNode: TQRBNode;
begin
Result := 0;
FLocker.Enter;
try
  ANode := FItems.First;
  while (ANode <> nil) and (AMaxTimes <> 0) do
    begin
    AJob := ANode.Data;
    APrior := nil;
    repeat
      if SameWorkerProc(AJob.WorkerProc, AProc) and
        ((AData = Pointer(-1)) or (AData = AJob.Data)) then
        begin
        ANext := AJob.Next;
        if APrior = nil then
          ANode.Data := ANext
        else
          APrior.Next := AJob.Next;
        FOwner.FreeJob(AJob);
        AJob := ANext;
        Dec(AMaxTimes);
        Inc(Result);
        end
      else
        begin
        APrior := AJob;
        AJob := AJob.Next
        end;
    until AJob = nil;
    if ANode.Data = nil then
      begin
      ANextNode := ANode.Next;
      FItems.Delete(ANode);
      ANode := ANextNode;
      end
    else
      ANode := ANode.Next;
    end;
  if FItems.Count > 0 then
    FFirstFireTime := PQJob(FItems.First.Data).NextTime
  else
    FFirstFireTime := 0;
finally
  FLocker.Leave;
end;
end;

constructor TQRepeatJobs.Create(AOwner: TQWorkers);
begin
inherited;
FItems := TQRBTree.Create(DoTimeCompare);
FItems.OnDelete := DoJobDelete;
FLocker := TCriticalSection.Create;
end;

destructor TQRepeatJobs.Destroy;
begin
inherited;
FreeObject(FItems);
FreeObject(FLocker);
end;

procedure TQRepeatJobs.DoJobDelete(ATree: TQRBTree; ANode: TQRBNode);
begin
FOwner.FreeJob(ANode.Data);
end;

function TQRepeatJobs.DoTimeCompare(P1, P2: Pointer): Integer;
begin
Result := PQJob(P1).NextTime - PQJob(P2).NextTime;
end;

function TQRepeatJobs.GetCount: Integer;
begin
Result := FItems.Count;
end;

function TQRepeatJobs.InternalPop: PQJob;
var
  ANode: TQRBNode;
  ATick: Int64;
  AJob: PQJob;
begin
Result := nil;
if FItems.Count = 0 then
  Exit;
FLocker.Enter;
try
  if FItems.Count > 0 then
    begin
    ATick := GetTimestamp;
    ANode := FItems.First;
    if PQJob(ANode.Data).NextTime <= ATick then
      begin
      AJob := ANode.Data;
      // OutputDebugString(PWideChar('Result.NextTime='+IntToStr(Result.NextTime)+',Current='+IntToStr(ATick)));
      if AJob.Next <> nil then // ���û�и�����Ҫִ�е���ҵ����ɾ����㣬����ָ����һ��
        ANode.Data := AJob.Next
      else
        begin
        ANode.Data := nil;
        FItems.Delete(ANode);
        ANode := FItems.First;
        if ANode <> nil then
          FFirstFireTime := PQJob(ANode.Data).NextTime
        else // û�мƻ���ҵ�ˣ�����Ҫ��
          FFirstFireTime := 0;
        end;
      if AJob.Runonce then
        Result := AJob
      else
        begin
        Inc(AJob.NextTime, AJob.Interval);
        Result := JobPool.Pop;
        Result.Assign(AJob);
        Result.Source := AJob;
        // ���²�����ҵ
        ANode := FItems.Find(AJob);
        if ANode = nil then
          begin
          FItems.Insert(AJob);
          FFirstFireTime := PQJob(FItems.First.Data).NextTime;
          end
        else // ����Ѿ�����ͬһʱ�̵���ҵ�����Լ��ҽӵ�������ҵͷ��
          begin
          AJob.Next := PQJob(ANode.Data);
          ANode.Data := AJob; // �׸���ҵ��Ϊ�Լ�
          end;
        end;
      end;
    end;
finally
  FLocker.Leave;
end;
end;

function TQRepeatJobs.InternalPush(AJob: PQJob): Boolean;
var
  ANode: TQRBNode;
begin
// ������ҵ���´�ִ��ʱ��
AJob.UpdateNextTime;
FLocker.Enter;
try
  ANode := FItems.Find(AJob);
  if ANode = nil then
    begin
    FItems.Insert(AJob);
    FFirstFireTime := PQJob(FItems.First.Data).NextTime;
    end
  else // ����Ѿ�����ͬһʱ�̵���ҵ�����Լ��ҽӵ�������ҵͷ��
    begin
    AJob.Next := PQJob(ANode.Data);
    ANode.Data := AJob; // �׸���ҵ��Ϊ�Լ�
    end;
  Result := true;
finally
  FLocker.Leave;
end;
end;

{ TQWorker }

procedure TQWorker.ComNeeded(AInitFlags: Cardinal);
begin
{$IFDEF MSWINDOWS}
if not ComInitialized then
  begin
  if AInitFlags = 0 then
    CoInitialize(nil)
  else
    CoInitializeEx(nil, AInitFlags);
  FFlags := FFlags or WORKER_COM_INITED;
  end;
{$ENDIF MSWINDOWS}
end;

constructor TQWorker.Create(AOwner: TQWorkers);
begin
inherited Create(true);
FOwner := AOwner;
FTimeout := 1000;
FreeOnTerminate := true;
FFlags := WORKER_ISBUSY; // Ĭ��Ϊæµ
AtomicIncrement(AOwner.FBusyCount);
FEvent := TEvent.Create(nil, False, False, '');
end;

destructor TQWorker.Destroy;
begin
FreeObject(FEvent);
inherited;
end;

procedure TQWorker.DoJob(AJob: PQJob);
begin
{$IFDEF UNICODE}
if AJob.IsAnonWorkerProc then
  AJob.WorkerProcA(AJob)
else
{$ENDIF}
  AJob.WorkerProc(AJob);
end;

procedure TQWorker.Execute;
var
  wr: TWaitResult;
{$IFDEF MSWINDOWS}
  SyncEvent: TEvent;
{$ENDIF}
begin
{$IFDEF MSWINDOWS}
SyncEvent := TEvent.Create(nil, False, False, '');
{$ENDIF}
try
  while not(Terminated or FOwner.FTerminating) do
    begin
    if FOwner.Enabled and (FOwner.FRepeatJobs.FFirstFireTime <> 0) then
      begin
      FTimeout := (FOwner.FRepeatJobs.FFirstFireTime - GetTimestamp) div 10;
      if FTimeout < 0 then // ʱ���Ѿ����ˣ���ô����ִ��
        FTimeout := 0;
      end
    else
      FTimeout := 15000; // 15S�����û����ҵ���룬������Լ��Ǳ������̶߳��󣬷����ͷŹ�����
    if FTimeout <> 0 then
      begin
      wr := FEvent.WaitFor(FTimeout);
      if Terminated or FOwner.FTerminating then
        Break;
      end
    else
      wr := wrSignaled;
    if (wr = wrSignaled) or ((FOwner.FRepeatJobs.FFirstFireTime <> 0) and
      (FOwner.FRepeatJobs.FFirstFireTime + 10 >= GetTimestamp)) then
      begin
      if FOwner.FTerminating then
        Break;
      if IsIdle then
        begin
        SetFlags(WORKER_ISBUSY or WORKER_LOOKUP, true);
        FOwner.WorkerBusy(Self);
        end
      else
        SetFlags(WORKER_LOOKUP, true);
      repeat
        FActiveJob := FOwner.Popup;
        if FActiveJob <> nil then
          begin
          FActiveJob.Worker := Self;
          FActiveJobProc := FActiveJob.WorkerProc;
          // ΪClear(AObject)׼���жϣ��Ա���FActiveJob�̲߳���ȫ
          FActiveJobData := FActiveJob.Data;
          if FActiveJob.IsSignalWakeup then
            FActiveJobSource := FActiveJob.Source
          else
            FActiveJobSource := nil;
          if FActiveJob.IsGrouped then
            FActiveJobGroup := FActiveJob.Group
          else
            FActiveJobGroup := nil;
          FActiveJobFlags := FActiveJob.Flags;
          if FActiveJob.StartTime = 0 then
            begin
            FActiveJob.StartTime := GetTimestamp;
            FActiveJob.FirstStartTime := FActiveJob.StartTime;
            end
          else
            FActiveJob.StartTime := GetTimestamp;
          try
            FFlags := (FFlags or WORKER_EXECUTING) and (not WORKER_LOOKUP);
            if FActiveJob.InMainThread then
{$IFDEF MSWINDOWS}
              begin
              if PostMessage(FOwner.FMainWorker, WM_APP, WPARAM(FActiveJob),
                LPARAM(SyncEvent)) then
                SyncEvent.WaitFor(INFINITE);
              end
{$ELSE}
              Synchronize(Self, FireInMainThread)
{$ENDIF}
            else
              DoJob(FActiveJob);
          except
          end;
          if not FActiveJob.Runonce then
            FOwner.FRepeatJobs.AfterJobRun(FActiveJob,
              GetTimestamp - FActiveJob.StartTime)
          else
            begin
            if FActiveJob.IsSignalWakeup then
              FOwner.SignalWorkDone(FActiveJob,
                GetTimestamp - FActiveJob.StartTime)
            else if FActiveJob.IsLongtimeJob then
              AtomicDecrement(FOwner.FLongTimeWorkers)
            else if FActiveJob.IsGrouped then
              FActiveJobGroup.DoJobExecuted(FActiveJob);
            FActiveJob.Worker := nil;
            end;
          FOwner.FreeJob(FActiveJob);
          FActiveJobProc := nil;
          FActiveJobSource := nil;
          FActiveJobFlags := 0;
          FActiveJobGroup := nil;
          FTerminatingJob := nil;
          FFlags := FFlags and (not WORKER_EXECUTING);
          end
        else
          FFlags := FFlags and (not WORKER_LOOKUP);
      until (FActiveJob = nil) or FOwner.FTerminating or Terminated or
        (not FOwner.Enabled);
      SetFlags(WORKER_ISBUSY, False);
      FOwner.WorkerIdle(Self, irNoJob);
      end
    else if (not IsReserved) and (FTimeout = 15000) then
      begin
      SetFlags(WORKER_ISBUSY, False);
      FOwner.WorkerIdle(Self, irTimeout);
      end;
    end;
finally
  FOwner.WorkerTerminate(Self);
{$IFDEF MSWINDOWS}
  if ComInitialized then
    CoUninitialize;
  FreeObject(SyncEvent);
{$ENDIF}
end;
end;

procedure TQWorker.FireInMainThread;
begin
DoJob(FActiveJob);
end;

function TQWorker.GetFlags(AIndex: Integer): Boolean;
begin
Result := ((FFlags and AIndex) <> 0);
end;

function TQWorker.GetIsIdle: Boolean;
begin
Result := not IsBusy;
end;

procedure TQWorker.SetFlags(AIndex: Integer; AValue: Boolean);
begin
if AValue then
  FFlags := FFlags or AIndex
else
  FFlags := FFlags and (not AIndex);
end;

{ TQWorkers }

function TQWorkers.Post(AJob: PQJob): Boolean;
begin
if (not FTerminating) and (Assigned(AJob.WorkerProc)
{$IFDEF UNICODE} or Assigned(AJob.WorkerProcA){$ENDIF}) then
  begin
  if AJob.Runonce and (AJob.FirstDelay = 0) then
    Result := FSimpleJobs.Push(AJob)
  else
    Result := FRepeatJobs.Push(AJob);
  if Result then
    LookupIdleWorker;
  end
else
  begin
  AJob.Next := nil;
  FreeJob(AJob);
  Result := False;
  end;
end;

function TQWorkers.Post(AProc: TQJobProc; AData: Pointer;
  ARunInMainThread: Boolean; AFreeType: TQJobDataFreeType): Boolean;
var
  AJob: PQJob;
begin
AJob := JobPool.Pop;
JobInitialize(AJob, AData, AFreeType, true, ARunInMainThread);
AJob.WorkerProc := AProc;
Result := Post(AJob);
end;

function TQWorkers.Post(AProc: TQJobProc; AInterval: Int64; AData: Pointer;
  ARunInMainThread: Boolean; AFreeType: TQJobDataFreeType): Boolean;
var
  AJob: PQJob;
begin
AJob := JobPool.Pop;
JobInitialize(AJob, AData, AFreeType, AInterval = 0, ARunInMainThread);
AJob.Interval := AInterval;
AJob.WorkerProc := AProc;
Result := Post(AJob);
end;

function TQWorkers.Post(AProc: TQJobProcG; AData: Pointer;
  ARunInMainThread: Boolean; AFreeType: TQJobDataFreeType): Boolean;
begin
Result := Post(MakeJobProc(AProc), AData, ARunInMainThread, AFreeType);
end;

{$IFDEF UNICODE}

function TQWorkers.Post(AProc: TQJobProcA; AData: Pointer;
  ARunInMainThread: Boolean; AFreeType: TQJobDataFreeType): Boolean;
var
  AJob: PQJob;
begin
AJob := JobPool.Pop;
JobInitialize(AJob, AData, AFreeType, true, ARunInMainThread);
AJob.WorkerProcA := AProc;
AJob.IsAnonWorkerProc := true;
Result := Post(AJob);
end;
{$ENDIF}

function TQWorkers.Clear(AObject: Pointer; AMaxTimes: Integer): Integer;
var
  ACleared: Integer;
  AWaitParam: TWorkerWaitParam;
  function ClearSignalJobs: Integer;
  var
    i: Integer;
    AJob, ANext, APrior: PQJob;
    AList: PQHashList;
    ASignal: PQSignal;
  begin
  Result := 0;
  FLocker.Enter;
  try
    for i := 0 to FSignalJobs.BucketCount - 1 do
      begin
      AList := FSignalJobs.Buckets[i];
      if AList <> nil then
        begin
        ASignal := AList.Data;
        if ASignal.First <> nil then
          begin
          AJob := ASignal.First;
          APrior := nil;
          while (AJob <> nil) and (AMaxTimes <> 0) do
            begin
            ANext := AJob.Next;
            if TMethod(AJob.WorkerProc).Data = AObject then
              begin
              if ASignal.First = AJob then
                ASignal.First := ANext;
              if Assigned(APrior) then
                APrior.Next := ANext;
              AJob.Next := nil;
              FreeJob(AJob);
              Dec(AMaxTimes);
              Inc(Result);
              end
            else
              APrior := AJob;
            AJob := ANext;
            end;
          if AMaxTimes = 0 then
            Break;
          end;
        end;
      end;
  finally
    FLocker.Leave;
  end;
  end;

begin
Result := 0;
if Self <> nil then
  begin
  ACleared := FSimpleJobs.Clear(AObject, AMaxTimes);
  Inc(Result, ACleared);
  Dec(AMaxTimes, ACleared);
  if AMaxTimes <> 0 then
    begin
    ACleared := FRepeatJobs.Clear(AObject, AMaxTimes);
    Inc(Result, ACleared);
    if AMaxTimes <> 0 then
      begin
      ACleared := ClearSignalJobs;
      Inc(Result, ACleared);
      if AMaxTimes <> 0 then
        begin
        AWaitParam.WaitType := 0;
        AWaitParam.Bound := AObject;
        WaitRunningDone(AWaitParam);
        end;
      end;
    end;
  end;
end;

function TQWorkers.At(AProc: TQJobProc; const ADelay, AInterval: Int64;
  AData: Pointer; ARunInMainThread: Boolean;
  AFreeType: TQJobDataFreeType): Boolean;
var
  AJob: PQJob;
begin
AJob := JobPool.Pop;
JobInitialize(AJob, AData, AFreeType, AInterval = 0, ARunInMainThread);
AJob.WorkerProc := AProc;
AJob.Interval := AInterval;
AJob.FirstDelay := ADelay;
Result := Post(AJob);
end;

function TQWorkers.At(AProc: TQJobProc; const ATime: TDateTime;
  const AInterval: Int64; AData: Pointer; ARunInMainThread: Boolean;
  AFreeType: TQJobDataFreeType): Boolean;
var
  AJob: PQJob;
  ADelay: Int64;
  ANow, ATemp: TDateTime;
begin
AJob := JobPool.Pop;
JobInitialize(AJob, AData, AFreeType, AInterval = 0, ARunInMainThread);
AJob.WorkerProc := AProc;
AJob.Interval := AInterval;
// ATime����ֻҪʱ�䲿�֣����ں���
ANow := Now;
ANow := ANow - Trunc(ANow);
ATemp := ATime - Trunc(ATime);
if ANow > ATemp then // �ðɣ�����ĵ��Ѿ����ˣ�������
  ADelay := Trunc(((1 + ANow) - ATemp) * Q1Day) // �ӳٵ�ʱ�䣬��λΪ0.1ms
else
  ADelay := Trunc((ATemp - ANow) * Q1Day);
AJob.FirstDelay := ADelay;
Result := Post(AJob);
end;
{$IFDEF UNICODE}

function TQWorkers.At(AProc: TQJobProcA; const ATime: TDateTime;
  const AInterval: Int64; AData: Pointer; ARunInMainThread: Boolean;
  AFreeType: TQJobDataFreeType): Boolean;
var
  AJob: PQJob;
  ADelay: Int64;
  ANow, ATemp: TDateTime;
begin
AJob := JobPool.Pop;
JobInitialize(AJob, AData, AFreeType, AInterval = 0, ARunInMainThread);
AJob.WorkerProcA := AProc;
AJob.IsAnonWorkerProc := true;
AJob.Interval := AInterval;
// ATime����ֻҪʱ�䲿�֣����ں���
ANow := Now;
ANow := ANow - Trunc(ANow);
ATemp := ATime - Trunc(ATime);
if ANow > ATemp then // �ðɣ�����ĵ��Ѿ����ˣ�������
  ADelay := Trunc(((1 + ANow) - ATemp) * Q1Day) // �ӳٵ�ʱ�䣬��λΪ0.1ms
else
  ADelay := Trunc((ATemp - ANow) * Q1Day);
AJob.FirstDelay := ADelay;
Result := Post(AJob);
end;
{$ENDIF}

function TQWorkers.Clear(AProc: TQJobProc; AData: Pointer;
  AMaxTimes: Integer): Integer;
var
  ACleared: Integer;
  AWaitParam: TWorkerWaitParam;
  function ClearSignalJobs: Integer;
  var
    i: Integer;
    AJob, ANext, APrior: PQJob;
    AList: PQHashList;
    ASignal: PQSignal;
  begin
  Result := 0;
  FLocker.Enter;
  try
    for i := 0 to FSignalJobs.BucketCount - 1 do
      begin
      AList := FSignalJobs.Buckets[i];
      if AList <> nil then
        begin
        ASignal := AList.Data;
        if ASignal.First <> nil then
          begin
          AJob := ASignal.First;
          APrior := nil;
          while (AJob <> nil) and (AMaxTimes <> 0) do
            begin
            ANext := AJob.Next;
            if SameWorkerProc(AJob.WorkerProc, AProc) and
              ((AData = Pointer(-1)) or (AJob.Data = AData)) then
              begin
              if ASignal.First = AJob then
                ASignal.First := ANext;
              if Assigned(APrior) then
                APrior.Next := ANext;
              AJob.Next := nil;
              FreeJob(AJob);
              Inc(Result);
              Dec(AMaxTimes);
              end
            else
              APrior := AJob;
            AJob := ANext;
            end;
          if AMaxTimes = 0 then
            Break;
          end;
        end;
      end;
  finally
    FLocker.Leave;
  end;
  end;

begin
Result := 0;
if Self <> nil then
  begin
  ACleared := FSimpleJobs.Clear(AProc, AData, AMaxTimes);
  Dec(AMaxTimes, ACleared);
  Inc(Result, ACleared);
  if AMaxTimes <> 0 then
    begin
    ACleared := FRepeatJobs.Clear(AProc, AData, AMaxTimes);
    Dec(AMaxTimes, ACleared);
    Inc(Result, ACleared);
    if AMaxTimes <> 0 then
      begin
      ACleared := ClearSignalJobs;
      Inc(Result, ACleared);
      if AMaxTimes <> 0 then
        begin
        AWaitParam.WaitType := 1;
        AWaitParam.Data := AData;
        AWaitParam.WorkerProc := TMethod(AProc);
        WaitRunningDone(AWaitParam);
        end;
      end;
    end;
  end;
end;

procedure TQWorkers.ClearWorkers;
var
  i: Integer;
{$IFDEF MSWINDOWS}
  function WorkerExists: Boolean;
  var
    J: Integer;
    ACode: Cardinal;
  begin
  Result := False;
  FLocker.Enter;
  try
    while FWorkerCount > 0 do
      begin
      if GetExitCodeThread(FWorkers[0].Handle, ACode) then
        begin
        if ACode = STILL_ACTIVE then
          begin
          Result := true;
          Break;
          end;
        end;
      // �������Ѿ������ڣ����ܱ��ⲿ�߳̽���
      FreeObject(FWorkers[0]);
      if FWorkerCount > 0 then
        begin
        for J := 1 to FWorkerCount - 1 do
          FWorkers[J - 1] := FWorkers[J];
        Dec(FWorkerCount);
        FWorkers[FWorkerCount] := nil;
        end;
      end;
  finally
    FLocker.Leave;
  end;
  end;
{$ENDIF}

begin
FTerminating := true;
FLocker.Enter;
try
  FRepeatJobs.FFirstFireTime := 0;
  for i := 0 to FWorkerCount - 1 do
    FWorkers[i].FEvent.SetEvent;
finally
  FLocker.Leave;
end;
while (FWorkerCount > 0) {$IFDEF MSWINDOWS} and WorkerExists {$ENDIF} do
{$IFDEF MSWINDOWS}
  SwitchToThread;
{$ELSE}
  TThread.Yield;
{$ENDIF}
end;

constructor TQWorkers.Create(AMinWorkers: Integer);
var
  ACpuCount: Integer;
  i: Integer;
begin
FSimpleJobs := TQSimpleJobs.Create(Self);
FRepeatJobs := TQRepeatJobs.Create(Self);
FSignalJobs := TQHashTable.Create();
FSignalJobs.OnDelete := DoJobFree;
FSignalJobs.AutoSize := true;
ACpuCount := GetCPUCount;
if AMinWorkers < 1 then
  FMinWorkers := 2
else
  FMinWorkers := AMinWorkers; // ���ٹ�����Ϊ2��
FMaxWorkers := (ACpuCount shl 1) + 1;
if FMaxWorkers <= FMinWorkers then
  FMaxWorkers := (FMinWorkers shl 1) + 1;
FLocker := TCriticalSection.Create;
FTerminating := False;
// ����Ĭ�Ϲ�����
FWorkerCount := FMinWorkers;
SetLength(FWorkers, FMaxWorkers);
for i := 0 to FMinWorkers - 1 do
  begin
  FWorkers[i] := TQWorker.Create(Self);
  FWorkers[i].SetFlags(WORKER_RESERVED, true); // ����������Ҫ���м��
  FWorkers[i].Suspended := False;
  SetThreadCPU(FWorkers[i].Handle, i mod ACpuCount);
  end;
FMaxLongtimeWorkers := (FMaxWorkers shr 1);
{$IFDEF MSWINDOWS}
FMainWorker := AllocateHWnd(DoMainThreadWork);
{$ENDIF}
end;

function TQWorkers.Delay(AProc: TQJobProc; ADelay: Int64; AData: Pointer;
  ARunInMainThread: Boolean; AFreeType: TQJobDataFreeType): Boolean;
var
  AJob: PQJob;
begin
AJob := JobPool.Pop;
JobInitialize(AJob, AData, AFreeType, true, ARunInMainThread);
AJob.WorkerProc := AProc;
AJob.FirstDelay := ADelay;
Result := Post(AJob);
end;
{$IFDEF UNICODE}

function TQWorkers.Delay(AProc: TQJobProcA; ADelay: Int64; AData: Pointer;
  ARunInMainThread: Boolean; AFreeType: TQJobDataFreeType): Boolean;
var
  AJob: PQJob;
begin
AJob := JobPool.Pop;
JobInitialize(AJob, AData, AFreeType, true, ARunInMainThread);
AJob.WorkerProcA := AProc;
AJob.IsAnonWorkerProc := true;
AJob.FirstDelay := ADelay;
Result := Post(AJob);
end;
{$ENDIF}

function TQWorkers.Delay(AProc: TQJobProcG; ADelay: Int64; AData: Pointer;
  ARunInMainThread: Boolean; AFreeType: TQJobDataFreeType): Boolean;
begin
Result := Delay(MakeJobProc(AProc), ADelay, AData, ARunInMainThread, AFreeType);
end;

destructor TQWorkers.Destroy;
begin
ClearWorkers;
FLocker.Enter;
try
  FreeObject(FSimpleJobs);
  FreeObject(FRepeatJobs);
  FreeObject(FSignalJobs);
finally
  FreeObject(FLocker);
end;
{$IFDEF MSWINDOWS}
DeallocateHWnd(FMainWorker);
{$ENDIF}
inherited;
end;

procedure TQWorkers.DisableWorkers;
begin
AtomicIncrement(FDisableCount);
end;

procedure TQWorkers.DoJobFree(ATable: TQHashTable; AHash: Cardinal;
  AData: Pointer);
var
  ASignal: PQSignal;
begin
ASignal := AData;
if ASignal.First <> nil then
  FreeJob(ASignal.First);
Dispose(ASignal);
end;
{$IFDEF MSWINDOWS}

procedure TQWorkers.DoMainThreadWork(var AMsg: TMessage);
var
  AJob: PQJob;
begin
if AMsg.Msg = WM_APP then
  begin
  try
    AJob := PQJob(AMsg.WPARAM);
    AJob.Worker.DoJob(AJob);
  finally
    if AMsg.LPARAM <> 0 then
      TEvent(AMsg.LPARAM).SetEvent;
  end;
  end
else
  AMsg.Result := DefWindowProc(FMainWorker, AMsg.Msg, AMsg.WPARAM, AMsg.LPARAM);
end;

{$ENDIF}

procedure TQWorkers.EnableWorkers;
var
  ANeedCount: Integer;
begin
if AtomicDecrement(FDisableCount) = 0 then
  begin
  if (FSimpleJobs.Count > 0) or (FRepeatJobs.Count > 0) then
    begin
    ANeedCount := FSimpleJobs.Count + FRepeatJobs.Count;
    while ANeedCount > 0 do
      begin
      if not LookupIdleWorker then
        Break;
      Dec(ANeedCount);
      end;
    end;
  end;
end;

procedure TQWorkers.FireSignalJob(ASignal: PQSignal; AData: Pointer;
  AFreeType: TQJobDataFreeType);
var
  AJob, ACopy: PQJob;
  ACount: PInteger;
begin
Inc(ASignal.Fired);
if AData <> nil then
  begin
  New(ACount);
  ACount^ := 1; // ��ʼֵ
  end
else
  ACount := nil;
AJob := ASignal.First;
while AJob <> nil do
  begin
  ACopy := JobPool.Pop;
  ACopy.Assign(AJob);
  JobInitialize(ACopy, AData, AFreeType, true, AJob.InMainThread);
  if ACount <> nil then
    begin
    AtomicIncrement(ACount^);
    ACopy.RefCount := ACount;
    end;
  ACopy.Source := AJob;
  FSimpleJobs.Push(ACopy);
  AJob := AJob.Next;
  end;
if AData <> nil then
  begin
  if AtomicDecrement(ACount^) = 0 then
    begin
    Dispose(ACount);
    FreeJobData(AData, AFreeType);
    end;
  end;
end;

procedure TQWorkers.FreeJob(AJob: PQJob);
var
  ANext: PQJob;
  AFreeData: Boolean;
begin
while AJob <> nil do
  begin
  ANext := AJob.Next;
  if AJob.Data <> nil then
    begin
    if AJob.IsSignalWakeup then
      begin
      AFreeData := AtomicDecrement(AJob.RefCount^) = 0;
      if AFreeData then
        Dispose(AJob.RefCount);
      end
    else
      AFreeData := AJob.IsDataOwner;
    if AFreeData then
      begin
      if AJob.IsObjectOwner then
        FreeJobData(AJob.Data, jdfFreeAsObject)
      else if AJob.IsRecordOwner then
        FreeJobData(AJob.Data, jdfFreeAsRecord)
      else if AJob.IsInterfaceOwner then
        FreeJobData(AJob.Data, jdfFreeAsInterface);
      end;
    end;
  JobPool.Push(AJob);
  AJob := ANext;
  end;
end;

procedure TQWorkers.FreeJobData(AData: Pointer; AFreeType: TQJobDataFreeType);
begin
case AFreeType of
  jdfFreeAsObject:
    try
      FreeObject(TObject(AData));
    except
    end;
  jdfFreeAsRecord:
    try
      Dispose(AData);
    except
    end;
  jdfFreeAsInterface:
    try
      IUnknown(AData)._Release;
    except
    end;
end;
end;

function TQWorkers.GetEnabled: Boolean;
begin
Result := (FDisableCount = 0);
end;

function TQWorkers.LongtimeJob(AProc: TQJobProc; AData: Pointer;
  AFreeType: TQJobDataFreeType): Boolean;
var
  AJob: PQJob;
begin
if AtomicIncrement(FLongTimeWorkers) <= FMaxLongtimeWorkers then
  begin
  Result := true;
  AJob := JobPool.Pop;
  JobInitialize(AJob, AData, AFreeType, true, False);
  AJob.SetFlags(JOB_LONGTIME,True);
  AJob.WorkerProc := AProc;
  Result := Post(AJob);
  if not Result then
    JobPool.Push(AJob);
  end
else
  begin
  AtomicDecrement(FLongTimeWorkers);
  Result := False;
  end;
end;
{$IFDEF UNICODE}

function TQWorkers.LongtimeJob(AProc: TQJobProcA; AData: Pointer;
  AFreeType: TQJobDataFreeType = jdfFreeByUser): Boolean;
var
  AJob: PQJob;
begin
if AtomicIncrement(FLongTimeWorkers) <= FMaxLongtimeWorkers then
  begin
  Result := true;
  AJob := JobPool.Pop;
  JobInitialize(AJob, AData, AFreeType, true, False);
  AJob.SetFlags(JOB_LONGTIME,True);
  AJob.WorkerProcA := AProc;
  AJob.IsAnonWorkerProc := true;
  Result := Post(AJob);
  if not Result then
    JobPool.Push(AJob);
  end
else
  begin
  AtomicDecrement(FLongTimeWorkers);
  Result := False;
  end;
end;
{$ENDIF}

function TQWorkers.LongtimeJob(AProc: TQJobProcG; AData: Pointer;
  AFreeType: TQJobDataFreeType): Boolean;
begin
Result := LongtimeJob(MakeJobProc(AProc), AData, AFreeType);
end;

function TQWorkers.LookupIdleWorker: Boolean;
var
  i: Integer;
  AWorker: TQWorker;
begin
Result := False;
if (FDisableCount <> 0) or (FBusyCount = MaxWorkers) or FTerminating then
  Exit;
FLocker.Enter;
try
  if FBusyCount < FWorkerCount then
    begin
    for i := 0 to FWorkerCount - 1 do
      begin
      AWorker := FWorkers[i];
      if (AWorker <> nil) and (AWorker.IsIdle) then
        begin
        AWorker.Suspended := False;
        AWorker.SetFlags(WORKER_ISBUSY, true);
        AtomicIncrement(FBusyCount);
        AWorker.FEvent.SetEvent;
        Result := true;
        Exit;
        end;
      end;
    end;
  if (not Result) and (FWorkerCount < MaxWorkers) then
    begin
    AWorker := TQWorker.Create(Self);
    SetThreadCPU(AWorker.Handle, FWorkerCount mod GetCPUCount);
    AWorker.Suspended := False;
    AWorker.FEvent.SetEvent;
    FWorkers[FWorkerCount] := AWorker;
    Inc(FWorkerCount);
    Result := true;
    end;
finally
  FLocker.Leave;
end;
end;

function TQWorkers.Popup: PQJob;
begin
Result := FSimpleJobs.Pop;
if Result = nil then
  Result := FRepeatJobs.Pop;
end;

function TQWorkers.RegisterSignal(const AName: QStringW): Integer;
var
  ASignal: PQSignal;
begin
FLocker.Enter;
try
  Result := SignalIdByName(AName);
  if Result < 0 then
    begin
    Inc(FMaxSignalId);
    New(ASignal);
    ASignal.Id := FMaxSignalId;
    ASignal.Fired := 0;
    ASignal.Name := AName;
    ASignal.First := nil;
    FSignalJobs.Add(ASignal, ASignal.Id);
    Result := ASignal.Id;
    // OutputDebugString(PWideChar('Signal '+IntToStr(ASignal.Id)+' Allocate '+IntToHex(NativeInt(ASignal),8)));
    end;
finally
  FLocker.Leave;
end;
end;

procedure TQWorkers.SetEnabled(const Value: Boolean);
begin
if Value then
  EnableWorkers
else
  DisableWorkers;
end;

procedure TQWorkers.SetMaxLongtimeWorkers(const Value: Integer);
begin
if FMaxLongtimeWorkers <> Value then
  begin
  if Value > (MaxWorkers shr 1) then
    raise Exception.Create(STooManyLongtimeWorker);
  FMaxLongtimeWorkers := Value;
  end;
end;

procedure TQWorkers.SetMaxWorkers(const Value: Integer);
var
  ATemp, AMaxLong: Integer;
begin
if (Value >= 2) and (FMaxWorkers <> Value) then
  begin
  AtomicExchange(ATemp, FLongTimeWorkers);
  AtomicExchange(FLongTimeWorkers, 0); // ǿ����0����ֹ������ĳ�ʱ����ҵ
  AMaxLong := Value shr 1;
  FLocker.Enter;
  try
    if FLongTimeWorkers < AMaxLong then // �Ѿ����еĳ�ʱ����ҵ��С��һ��Ĺ�����
      begin
      if ATemp < AMaxLong then
        AMaxLong := ATemp;
      if FMaxWorkers > Value then
        begin
        while Value < FWorkerCount do
          WorkerTerminate(FWorkers[FWorkerCount - 1]);
        FMaxWorkers := Value;
        SetLength(FWorkers, Value);
        end
      else
        begin
        FMaxWorkers := Value;
        SetLength(FWorkers, Value);
        end;
      end;
  finally
    FLocker.Leave;
    AtomicExchange(FLongTimeWorkers, AMaxLong);
  end;
  end;
end;

procedure TQWorkers.SetMinWorkers(const Value: Integer);
begin
if FMinWorkers <> Value then
  begin
  if Value < 1 then
    raise Exception.Create(STooFewWorkers);
  FMinWorkers := Value;
  end;
end;

procedure TQWorkers.Signal(AId: Integer; AData: Pointer;
  AFreeType: TQJobDataFreeType);
var
  AFound: Boolean;
  ASignal: PQSignal;
begin
AFound := False;
FLocker.Enter;
try
  ASignal := FSignalJobs.FindFirstData(AId);
  if ASignal <> nil then
    begin
    AFound := true;
    FireSignalJob(ASignal, AData, AFreeType);
    end
  else
    FreeJobData(AData, AFreeType);
finally
  FLocker.Leave;
end;
if AFound then
  LookupIdleWorker;
end;

procedure TQWorkers.Signal(const AName: QStringW; AData: Pointer;
  AFreeType: TQJobDataFreeType);
var
  i: Integer;
  ASignal: PQSignal;
  AFound: Boolean;
begin
AFound := False;
FLocker.Enter;
try
  for i := 0 to FSignalJobs.BucketCount - 1 do
    begin
    if FSignalJobs.Buckets[i] <> nil then
      begin
      ASignal := FSignalJobs.Buckets[i].Data;
      if (Length(ASignal.Name) = Length(AName)) and (ASignal.Name = AName) then
        begin
        AFound := true;
        FireSignalJob(ASignal, AData, AFreeType);
        Break;
        end;
      end;
    end;
finally
  FLocker.Leave;
end;
if AFound then
  LookupIdleWorker
else
  FreeJobData(AData, AFreeType);
end;

function TQWorkers.SignalIdByName(const AName: QStringW): Integer;
var
  i: Integer;
  ASignal: PQSignal;
begin
Result := -1;
for i := 0 to FSignalJobs.BucketCount - 1 do
  begin
  if FSignalJobs.Buckets[i] <> nil then
    begin
    ASignal := FSignalJobs.Buckets[i].Data;
    if (Length(ASignal.Name) = Length(AName)) and (ASignal.Name = AName) then
      begin
      Result := ASignal.Id;
      Exit;
      end;
    end;
  end;
end;

procedure TQWorkers.SignalWorkDone(AJob: PQJob; AUsedTime: Int64);
var
  ASignal: PQSignal;
  ATemp, APrior: PQJob;
begin
FLocker.Enter;
try
  ASignal := FSignalJobs.FindFirstData(AJob.SignalId);
  ATemp := ASignal.First;
  APrior := nil;
  while ATemp <> nil do
    begin
    if ATemp = AJob.Source then
      begin
      if AJob.IsTerminated then
        begin
        if APrior <> nil then
          APrior.Next := ATemp.Next
        else
          ASignal.First := ATemp.Next;
        ATemp.Next := nil;
        FreeJob(ATemp);
        end
      else
        begin
        // �����ź���ҵ��ͳ����Ϣ
        Inc(ATemp.Runs);
        if AUsedTime > 0 then
          begin
          if ATemp.MinUsedTime = 0 then
            ATemp.MinUsedTime := AUsedTime
          else if AUsedTime < ATemp.MinUsedTime then
            ATemp.MinUsedTime := AUsedTime;
          if ATemp.MaxUsedTime = 0 then
            ATemp.MaxUsedTime := AUsedTime
          else if AUsedTime > ATemp.MaxUsedTime then
            ATemp.MaxUsedTime := AUsedTime;
          Break;
          end;
        end;
      end;
    APrior := ATemp;
    ATemp := ATemp.Next;
    end;
finally
  FLocker.Leave;
end;
end;

procedure TQWorkers.WorkerBusy(AWorker: TQWorker);
begin
AtomicIncrement(FBusyCount);
end;

procedure TQWorkers.WorkerIdle(AWorker: TQWorker; AReason: TWorkerIdleReason);
var
  i, J: Integer;
begin
if AtomicDecrement(FBusyCount) > FMinWorkers then
  begin
  FLocker.Enter;
  try
    if (AWorker <> FWorkers[0]) and (AWorker <> FWorkers[1]) and
      (AReason = irTimeout) then
      begin
      for i := FMinWorkers to FWorkerCount - 1 do
        begin
        if AWorker = FWorkers[i] then
          begin
          AWorker.Terminate;
          for J := i + 1 to FWorkerCount - 1 do
            FWorkers[J - 1] := FWorkers[J];
          FWorkers[FWorkerCount - 1] := nil;
          Dec(FWorkerCount);
          Break;
          end;
        end;
      end;
  finally
    FLocker.Leave;
  end;
  end;
end;

procedure TQWorkers.WorkerTerminate(AWorker: TObject);
var
  i, J: Integer;
begin
AtomicDecrement(FBusyCount);
FLocker.Enter;
for i := 0 to FWorkerCount - 1 do
  begin
  if FWorkers[i] = AWorker then
    begin
    for J := i to FWorkerCount - 2 do
      FWorkers[J] := FWorkers[J + 1];
    FWorkers[FWorkerCount - 1] := nil;
    Dec(FWorkerCount);
    Break;
    end;
  end;
FLocker.Leave;
// PostLog(llHint,'������ %d ������������ %d',[TQWorker(AWorker).ThreadID,FWorkerCount]);
end;

function TQWorkers.Wait(AProc: TQJobProc; ASignalId: Integer;
  ARunInMainThread: Boolean): Boolean;
var
  AJob: PQJob;
  ASignal: PQSignal;
begin
if not FTerminating then
  begin
  AJob := JobPool.Pop;
  JobInitialize(AJob, nil, jdfFreeByUser, False, ARunInMainThread);
  AJob.WorkerProc := AProc;
  AJob.SignalId := ASignalId;
  AJob.SetFlags(JOB_SIGNAL_WAKEUP, true);
  AJob.PushTime := GetTimestamp;
  Result := False;
  FLocker.Enter;
  try
    ASignal := FSignalJobs.FindFirstData(ASignalId);
    if ASignal <> nil then
      begin
      AJob.Next := ASignal.First;
      ASignal.First := AJob;
      Result := true;
      end;
  finally
    FLocker.Leave;
    if not Result then
      JobPool.Push(AJob);
  end;
  end
else
  Result := False;
end;
{$IFDEF UNICODE}

function TQWorkers.Wait(AProc: TQJobProcA; ASignalId: Integer;
  ARunInMainThread: Boolean): Boolean;
var
  AJob: PQJob;
  ASignal: PQSignal;
begin
if not FTerminating then
  begin
  AJob := JobPool.Pop;
  JobInitialize(AJob, nil, jdfFreeByUser, False, ARunInMainThread);
  AJob.WorkerProcA := AProc;
  AJob.IsAnonWorkerProc := true;
  AJob.SignalId := ASignalId;
  AJob.SetFlags(JOB_SIGNAL_WAKEUP, true);
  AJob.PushTime := GetTimestamp;
  Result := False;
  FLocker.Enter;
  try
    ASignal := FSignalJobs.FindFirstData(ASignalId);
    if ASignal <> nil then
      begin
      AJob.Next := ASignal.First;
      ASignal.First := AJob;
      Result := true;
      end;
  finally
    FLocker.Leave;
    if not Result then
      JobPool.Push(AJob);
  end;
  end
else
  Result := False;

end;
{$ENDIF}

function TQWorkers.Wait(AProc: TQJobProcG; ASignalId: Integer;
  ARunInMainThread: Boolean): Boolean;
begin
Result := Wait(MakeJobProc(AProc), ASignalId, ARunInMainThread);
end;

procedure TQWorkers.WaitRunningDone(const AParam: TWorkerWaitParam);
var
  AInMainThread: Boolean;
  function HasJobRunning: Boolean;
  var
    i: Integer;
    AJob: PQJob;
  begin
  Result := False;
  DisableWorkers;
  FLocker.Enter;
  try
    for i := 0 to FWorkerCount - 1 do
      begin
      if FWorkers[i].IsLookuping then // ��δ�������������´β�ѯ
        begin
        Result := true;
        Break;
        end
      else if FWorkers[i].IsExecuting then
        begin
        AJob := FWorkers[i].FActiveJob;
        case AParam.WaitType of
          0: // ByObject
            Result := TMethod(FWorkers[i].FActiveJobProc).Data = AParam.Bound;
          1: // ByData
            Result := (TMethod(FWorkers[i].FActiveJobProc)
              .Code = TMethod(AParam.WorkerProc).Code) and
              (TMethod(FWorkers[i].FActiveJobProc)
              .Data = TMethod(AParam.WorkerProc).Data) and
              ((AParam.Data = Pointer(-1)) or
              (FWorkers[i].FActiveJobData = AParam.Data));
          2: // BySignalSource
            Result := (FWorkers[i].FActiveJobSource = AParam.SourceJob);
          3: // ByGroup
            Result := (FWorkers[i].FActiveJobGroup = AParam.Group);
          $FF: // ����
            Result := true;
        else
          raise Exception.CreateFmt(SBadWaitDoneParam, [AParam.WaitType]);
        end;
        if Result then
          begin
          FWorkers[i].FTerminatingJob := AJob;
          Break;
          end;
        end;
      end;
  finally
    FLocker.Leave;
    EnableWorkers;
  end;
  end;

begin
AInMainThread := GetCurrentThreadId = MainThreadId;
repeat
  if HasJobRunning then
    begin
    if AInMainThread then
      begin
      // ����������߳�������������ҵ���������߳�ִ�У������Ѿ�Ͷ����δִ�У����Ա��������ܹ�ִ��
{$IFDEF NEXTGEN}
      fmx.Forms.Application.ProcessMessages;
{$ELSE}
      Forms.Application.ProcessMessages;
{$ENDIF}
      end;
{$IFDEF MSWINDOWS}
    SwitchToThread;
{$ELSE}
    TThread.Yield;
{$ENDIF}
    end
  else // û�ҵ�
    Break;
until 1 > 2;
end;

procedure TQWorkers.WaitSignalJobsDone(AJob: PQJob);
begin
TEvent(AJob.Data).SetEvent;
end;

function TQWorkers.Clear(ASignalName: QStringW): Integer;
var
  i: Integer;
  ASignal: PQSignal;
  AJob: PQJob;
begin
Result := 0;
FLocker.Enter;
try
  AJob := nil;
  for i := 0 to FSignalJobs.BucketCount - 1 do
    begin
    if FSignalJobs.Buckets[i] <> nil then
      begin
      ASignal := FSignalJobs.Buckets[i].Data;
      if ASignal.Name = ASignalName then
        begin
        AJob := ASignal.First;
        ASignal.First := nil;
        Break;
        end;
      end;
    end;
finally
  FLocker.Leave;
end;
if AJob <> nil then
  ClearSignalJobs(AJob);
end;
{$IFDEF UNICODE}

function TQWorkers.At(AProc: TQJobProcA; const ADelay, AInterval: Int64;
  AData: Pointer; ARunInMainThread: Boolean;
  AFreeType: TQJobDataFreeType): Boolean;
var
  AJob: PQJob;
begin
AJob := JobPool.Pop;
JobInitialize(AJob, AData, AFreeType, AInterval = 0, ARunInMainThread);
AJob.WorkerProcA := AProc;
AJob.IsAnonWorkerProc := true;
AJob.Interval := AInterval;
AJob.FirstDelay := ADelay;
Result := Post(AJob);
end;
{$ENDIF}

function TQWorkers.At(AProc: TQJobProcG; const ADelay, AInterval: Int64;
  AData: Pointer; ARunInMainThread: Boolean;
  AFreeType: TQJobDataFreeType): Boolean;
begin
Result := At(MakeJobProc(AProc), ADelay, AInterval, AData, ARunInMainThread,
  AFreeType);
end;

function TQWorkers.At(AProc: TQJobProcG; const ATime: TDateTime;
  const AInterval: Int64; AData: Pointer; ARunInMainThread: Boolean;
  AFreeType: TQJobDataFreeType): Boolean;
begin
Result := At(MakeJobProc(AProc), ATime, AInterval, AData, ARunInMainThread,
  AFreeType);
end;

function TQWorkers.Clear(ASignalId: Integer): Integer;
var
  i: Integer;
  ASignal: PQSignal;
  AJob: PQJob;
begin
FLocker.Enter;
try
  AJob := nil;
  for i := 0 to FSignalJobs.BucketCount - 1 do
    begin
    if FSignalJobs.Buckets[i] <> nil then
      begin
      ASignal := FSignalJobs.Buckets[i].Data;
      if ASignal.Id = ASignalId then
        begin
        AJob := ASignal.First;
        ASignal.First := nil;
        Break;
        end;
      end;
    end;
finally
  FLocker.Leave;
end;
if AJob <> nil then
  Result := ClearSignalJobs(AJob)
else
  Result := 0;
end;

procedure TQWorkers.Clear;
var
  i: Integer;
  AParam: TWorkerWaitParam;
  ASignal: PQSignal;
begin
DisableWorkers; // ���⹤����ȡ���µ���ҵ
try
  FSimpleJobs.Clear;
  FRepeatJobs.Clear;
  FLocker.Enter;
  try
    for i := 0 to FSignalJobs.BucketCount - 1 do
      begin
      if Assigned(FSignalJobs.Buckets[i]) then
        begin
        ASignal := FSignalJobs.Buckets[i].Data;
        FreeJob(ASignal.First);
        ASignal.First := nil;
        end;
      end;
  finally
    FLocker.Leave;
  end;
  AParam.WaitType := $FF;
  WaitRunningDone(AParam);
finally
  EnableWorkers;
end;
end;

function TQWorkers.ClearSignalJobs(ASource: PQJob): Integer;
var
  AFirst, ALast, APrior, ANext: PQJob;
  ACount: Integer;
  AWaitParam: TWorkerWaitParam;
begin
Result := 0;
AFirst := nil;
APrior := nil;
FSimpleJobs.FLocker.Enter;
try
  ALast := FSimpleJobs.FFirst;
  ACount := FSimpleJobs.Count;
  FSimpleJobs.FFirst := nil;
  FSimpleJobs.FLast := nil;
  FSimpleJobs.FCount := 0;
finally
  FSimpleJobs.FLocker.Leave;
end;
while ALast <> nil do
  begin
  if (ALast.IsSignalWakeup) and (ALast.Source = ASource) then
    begin
    ANext := ALast.Next;
    ALast.Next := nil;
    FreeJob(ALast);
    ALast := ANext;
    if APrior <> nil then
      APrior.Next := ANext;
    Dec(ACount);
    Inc(Result);
    end
  else
    begin
    if AFirst = nil then
      AFirst := ALast;
    APrior := ALast;
    ALast := ALast.Next;
    end;
  end;
if ACount > 0 then
  begin
  FSimpleJobs.FLocker.Enter;
  try
    APrior.Next := FSimpleJobs.FFirst;
    FSimpleJobs.FFirst := AFirst;
    Inc(FSimpleJobs.FCount, ACount);
    if FSimpleJobs.FLast = nil then
      FSimpleJobs.FLast := APrior;
  finally
    FSimpleJobs.FLocker.Leave;
  end;
  end;
AWaitParam.WaitType := 2;
AWaitParam.SourceJob := ASource;
WaitRunningDone(AWaitParam);
FreeJob(ASource);
end;
{$IFDEF UNICODE}

function TQWorkers.Post(AProc: TQJobProcA; AInterval: Int64; AData: Pointer;
  ARunInMainThread: Boolean; AFreeType: TQJobDataFreeType): Boolean;
var
  AJob: PQJob;
begin
AJob := JobPool.Pop;
JobInitialize(AJob, AData, AFreeType, AInterval = 0, ARunInMainThread);
AJob.WorkerProcA := AProc;
AJob.IsAnonWorkerProc := true;
AJob.Interval := AInterval;
Result := Post(AJob);
end;
{$ENDIF}

function TQWorkers.Post(AProc: TQJobProcG; AInterval: Int64; AData: Pointer;
  ARunInMainThread: Boolean; AFreeType: TQJobDataFreeType): Boolean;
begin
Result := Post(MakeJobProc(AProc), AInterval, AData, ARunInMainThread,
  AFreeType);
end;

{ TJobPool }

constructor TJobPool.Create(AMaxSize: Integer);
var
  i: Integer;
begin
inherited Create;
FSize := AMaxSize;
FLocker := TQSimpleLock.Create;
end;

destructor TJobPool.Destroy;
var
  AJob: PQJob;
begin
FLocker.Enter;
while FFirst <> nil do
  begin
  AJob := FFirst.Next;
  Dispose(FFirst);
  FFirst := AJob;
  end;
FreeObject(FLocker);
inherited;
end;

function TJobPool.Pop: PQJob;
begin
FLocker.Enter;
Result := FFirst;
if Result <> nil then
  begin
  FFirst := Result.Next;
  Dec(FCount);
  end;
FLocker.Leave;
if Result = nil then
  GetMem(Result, SizeOf(TQJob));
Result.Reset;
end;

procedure TJobPool.Push(AJob: PQJob);
var
  ADoFree: Boolean;
begin
{$IFDEF UNICODE}
if AJob.IsAnonWorkerProc then
  AJob.WorkerProcA := nil;
{$ENDIF}
FLocker.Enter;
ADoFree := (FCount = FSize);
if not ADoFree then
  begin
  AJob.Next := FFirst;
  FFirst := AJob;
  Inc(FCount);
  end;
FLocker.Leave;
if ADoFree then
  begin
  FreeMem(AJob);
  end;
end;

{ TQSimpleLock }
{$IFDEF QWORKER_SIMPLE_LOCK}

constructor TQSimpleLock.Create;
begin
inherited;
FFlags := 0;
end;

procedure TQSimpleLock.Enter;
begin
while (AtomicOr(FFlags, $01) and $01) <> 0 do
  begin
{$IFDEF MSWINDOWS}
  SwitchToThread;
{$ELSE}
  TThread.Yield;
{$ENDIF}
  end;
end;

procedure TQSimpleLock.Leave;
begin
AtomicAnd(FFlags, Integer($FFFFFFFE));
end;
{$ENDIF QWORKER_SIMPLE_JOB}
{ TQJobGroup }

function TQJobGroup.Add(AProc: TQJobProc; AData: Pointer;
  AInMainThread: Boolean; AFreeType: TQJobDataFreeType): Boolean;
var
  AJob: PQJob;
begin
AJob := JobPool.Pop;
JobInitialize(AJob, AData, AFreeType, true, AInMainThread);
AJob.Group := Self;
AJob.WorkerProc := AProc;
AJob.SetFlags(JOB_GROUPED, true);
FLocker.Enter;
try
  FWaitResult := wrIOCompletion;
  if FPrepareCount > 0 then // ���������Ŀ���ӵ��б��У��ȴ�Run
    begin
    FItems.Add(AJob);
    Result := true;
    end
  else
    begin
    if ByOrder then // ��˳��
      begin
      Result := true;
      FItems.Add(AJob);
      if FItems.Count = 0 then
        Result := Workers.Post(AJob);
      end
    else
      begin
      Result := Workers.Post(AJob);
      if Result then
        FItems.Add(AJob);
      end;
    end;
finally
  FLocker.Leave;
end;
end;

procedure TQJobGroup.Cancel;
var
  i: Integer;
  AJobs: TQSimpleJobs;
  AJob, APrior, ANext: PQJob;
  AWaitParam: TWorkerWaitParam;
begin
FLocker.Enter;
try
  if FByOrder then
    begin
    for i := 0 to FItems.Count - 1 do
      begin
      AJob := FItems[i];
      if AJob.PopTime=0 then
        Workers.FreeJob(AJob);
      end;
    end;
  FItems.Clear;
finally
  FLocker.Leave;
end;
// ��SimpleJobs�����������ȫ����ҵ
AJobs := Workers.FSimpleJobs;
AJobs.FLocker.Enter;
try
  AJob := AJobs.FFirst;
  APrior := nil;
  while AJob <> nil do
    begin
    ANext := AJob.Next;
    if AJob.IsGrouped and (AJob.Group = Self) then
      begin
      if APrior = nil then
        AJobs.FFirst := AJob.Next
      else
        APrior.Next := AJob.Next;
      AJob.Next := nil;
      Workers.FreeJob(AJob);
      if AJob = AJobs.FLast then
        AJobs.FLast := nil;
      end
    else
      APrior := AJob;
    AJob := ANext;
    end;
finally
  AJobs.FLocker.Leave;
end;
AWaitParam.WaitType := 3;
AWaitParam.Group := Self;
Workers.WaitRunningDone(AWaitParam);
end;

constructor TQJobGroup.Create(AByOrder: Boolean);
begin
inherited Create;
FEvent := TEvent.Create(nil, False, False, '');
FLocker := TQSimpleLock.Create;
FByOrder := AByOrder;
FItems := TQJobItemList.Create;
end;

destructor TQJobGroup.Destroy;
var
  i: Integer;
begin
Cancel;
Workers.FSimpleJobs.Clear(Self, -1);
FLocker.Enter;
try
  if FItems.Count > 0 then
    begin
    FWaitResult := wrAbandoned;
    FEvent.SetEvent;
    for i := 0 to FItems.Count - 1 do
      begin
      if PQJob(FItems[i]).PushTime <> 0 then
        JobPool.Push(FItems[i]);
      end;
    FItems.Clear;
    end;
finally
  FLocker.Leave;
end;
FreeObject(FLocker);
FreeObject(FEvent);
FreeObject(FItems);
inherited;
end;

procedure TQJobGroup.DoAfterDone;
begin
if Assigned(FAfterDone) then
  FAfterDone(Self);
end;

procedure TQJobGroup.DoJobExecuted(AJob: PQJob);
var
  i: Integer;
  AIsDone: Boolean;
begin
if FWaitResult = wrIOCompletion then
  begin
  AIsDone := False;
  FLocker.Enter;
  try
    i := FItems.IndexOf(AJob);
    if i <> -1 then
      begin
      FItems.Delete(i);
      if FItems.Count = 0 then
        begin
        FWaitResult := wrSignaled;
        FEvent.SetEvent;
        AIsDone := true;
        end
      else if ByOrder then
        begin
        if not Workers.Post(FItems[0]) then
          begin
          FWaitResult := wrAbandoned;
          FEvent.SetEvent;
          end;
        end;
      end;
  finally
    FLocker.Leave;
  end;
  if AIsDone then
    DoAfterDone;
  end;
end;

procedure TQJobGroup.DoJobsTimeout(AJob: PQJob);
begin
Cancel;
if FWaitResult = wrIOCompletion then
  begin
  FWaitResult := wrTimeout;
  FEvent.SetEvent;
  DoAfterDone;
  end;
end;

function TQJobGroup.MsgWaitFor(ATimeout: Cardinal): TWaitResult;
var
  AEndTime: Int64;
begin
if GetCurrentThreadId <> MainThreadId then
  Result := WaitFor(ATimeout)
else
  begin
  Result := FWaitResult;
  FLocker.Enter;
  try
    if FItems.Count = 0 then
      Result := wrSignaled;
  finally
    FLocker.Leave;
  end;
  if Result = wrIOCompletion then
    begin
    AEndTime := GetTimestamp + ATimeout * 10;
    while GetTimestamp < AEndTime do
      begin
      // ÿ��10������һ���Ƿ�����Ϣ��Ҫ�������������������һ���ȴ�
      if FEvent.WaitFor(10) = wrSignaled then
        begin
        Result := FWaitResult;
        Break;
        end
      else
        begin
        // ����������߳�������������ҵ���������߳�ִ�У������Ѿ�Ͷ����δִ�У����Ա��������ܹ�ִ��
{$IFDEF NEXTGEN}
        fmx.Forms.Application.ProcessMessages;
{$ELSE}
        Forms.Application.ProcessMessages;
{$ENDIF}
        end;
      end;
    if Result = wrIOCompletion then
      begin
      Cancel;
      if Result = wrIOCompletion then
        Result := wrTimeout;
      end;
    DoAfterDone;
    end;
  end;

end;

procedure TQJobGroup.Prepare;
begin
AtomicIncrement(FPrepareCount);
end;

procedure TQJobGroup.Run(ATimeout: Cardinal);
var
  i: Integer;
begin
if AtomicDecrement(FPrepareCount) = 0 then
  begin
  if ATimeout <> INFINITE then
    begin
    FTimeout := GetTimestamp - ATimeout;
    Workers.Delay(DoJobsTimeout, ATimeout * 10, nil);
    end;
  FLocker.Enter;
  try
    if FItems.Count = 0 then
      FWaitResult := wrSignaled
    else
      begin
      FWaitResult := wrIOCompletion;
      if ByOrder then
        begin
        if not Workers.Post(FItems[0]) then
          FWaitResult := wrAbandoned;
        end
      else
        begin
        for i := 0 to FItems.Count - 1 do
          begin
          if not Workers.Post(FItems[i]) then
            begin
            FWaitResult := wrAbandoned;
            Break;
            end;
          end;
        end;
      end;
  finally
    FLocker.Leave;
  end;
  if FWaitResult <> wrIOCompletion then
    DoAfterDone;
  end;
end;

function TQJobGroup.WaitFor(ATimeout: Cardinal): TWaitResult;
begin
Result := FWaitResult;
FLocker.Enter;
try
  if FItems.Count = 0 then
    Result := wrSignaled;
finally
  FLocker.Leave;
end;
if Result = wrIOCompletion then
  begin
  if FEvent.WaitFor(ATimeout) = wrSignaled then
    Result := FWaitResult
  else
    Result := wrTimeout;
  end;
DoAfterDone;
end;

function JobPoolCount: NativeInt;
begin
Result := JobPool.Count;
end;
function JobPoolPrint: QStringW;
var
  AJob:PQJob;
  ABuilder:TQStringCatHelperW;
begin
ABuilder:=TQStringCatHelperW.Create;
JobPool.FLocker.Enter;
try
  AJob:=JobPool.FFirst;
  while AJob<>nil do
    begin
    ABuilder.Cat(IntToHex(NativeInt(AJob),SizeOf(NativeInt))).Cat(SLineBreak);
    AJob:=AJob.Next;
    end;
finally
  JobPool.FLocker.Leave;
  Result:=ABuilder.Value;
  FreeObject(ABuilder);
end;
end;

initialization

{$IFNDEF NEXTGEN}
  GetTickCount64 := GetProcAddress(GetModuleHandle(kernel32), 'GetTickCount64');
if not QueryPerformanceFrequency(_PerfFreq) then
  _PerfFreq := -1;
{$ELSE}
  _Watch := TStopWatch.Create;
_Watch.Start;
{$ENDIF}
JobPool := TJobPool.Create(1024);
Workers := TQWorkers.Create;

finalization

FreeObject(Workers);
FreeObject(JobPool);

end.
