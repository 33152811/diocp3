unit qjson;
{$I 'qdac.inc'}

interface

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
  2014.8.15
  =========
  * ������Add�����Զ������������ʱ������ض���ʽ��11,23ʱ�������������(Tuesday����)
  2014.7.31
  =========
  * �����˽�������ʱ������й�����ϵͳ�쳣�޷�������ʾ������(����С�ױ���)
  * �����˽���ʱ����������ѭ�������⣨����С�ױ��棩
  * �����˳����쳣ʱ���쳣����ʾ�ظ�������
  * ������ForcePathʱ'array[].subobjectname'δ��ȷ����·��������(����С�ױ���)
  2014.7.28
  =========
  * ������ToRtti���Դ����������ʱ�����ͣ���JSONΪnullʱ�������������(�ֺ걨��)
  * �޸�ToRecord��������Ϊvar��������const(�ֺ걨��)
  2014.7.16
  =========
  * ������GetPathʱ��δ��ʼ������ַ������Path���Կ��ܳ��������(����С�ױ���)
  2014.7.6
  =========
  + ToRtti����Ծ�̬�������͵�֧��

  2014.7.3
  =========
  * ������Assignʱ�����˵�ǰ������Ƶ�����

  2014.7.1
  =========
  * AsString�޸�jdtNull/jdtUnknownʱ����Ϊ���ؿ��ַ���
  2014.6.28
  =========
  * ������ForcePath('Items[]')Ĭ������˿��ӽ�������(pony,��������)
  + ����JsonRttiEnumAsIntȫ��ѡ�����ö��ֵ�ͼ���ֵ�Ƿ񱣴�����ַ�����Ĭ��ΪTrue(�ֺ뽨��)
  2014.6.27
  =========
  + ����TryParse�������ֺ뽨�飩
  * �޸���Encodeʱ���Լ�������Ҳ�ӵ��˽���ַ����е����⣨�ֺ뱨�棩
  * ������FromRTTIʱ�����ڷ������¼�������û�н��й��˵�����
  * ������ToRtti.ToArrayʱ�����ڶ�̬��������ó���ʱ���ʹ��󣨻ֺ뱨�棩
  2014.6.26
  ==========
  * ������ToRtti.ToRecord�Ӻ���������������ʱ�Ĵ���(��лȺ�ѻֺ������RTTI����Ͳ���)
  * ����HPPEMITĬ�����ӱ���Ԫ(�����ٷ� ����)
  2014.6.23
  ==========
  + FromRecord֧�ֶ�̬�������ͨ����
  2014.6.21
  ==========
  * �Ƴ�ԭ��AddObject/AddRecord/ToObject/ToRecord֧��
  + ���FromRtti/ToRtti/FromRecord/ToRecord/ToRttiValue����֧�֣��滻ԭ����RTTI����
  + ���Invoke������֧��ֱ��ͨ��Json���ö�Ӧ�ĺ���������ο�Demo
  2014.6.17
  =========
  * AsFloat��ֵʱ�����Nan��Infinite��NegInfinite������Чֵ�ļ��
  * AsVariant��ֵʱ�����varNull,varEmpty,varUnknown,varUInt64���͵�֧��
  2014.5.27
  ==========
  + TQHashedJson ֧�֣�����һ�������ѯ�Ż��İ汾��ʹ�ù�ϣ��ӿ�ItemByName�Ĳ�ѯ�ٶȣ�
  �������Ӧ���д�����ʹ��ItemByName��ItemByPath�Ȳ�ѯ��ʹ��������TQJson������Ӧֱ��
  ʹ��TQJson

  2014.5.14
  =========
  + ����CopyIf/DeleteIf/FindIf����
  + ����for..in�﷨֧��
  * ������Encode��ForcePath���ܴ��ڵ�����

  2014.5.6
  ========
  + ����ParseBlock��������֧����ʽ���ͷֶν���
  * �����˽���\uxxxxʱ��ʶ�����
  * �޸�Parse����Ϊ��������ӽ��

  2014.5.4
  ========
  + �����JavaScript��.net������ʱ������/DATE(MillSeconds+TimeZone)/��ʽ��֧��
  * Json����֧�ּ���VCL��TDateTime����֧�֣����ɵ�JSON����Ĭ����JsonDateFormat��
  JsonTimeFormat,JsonDateTimeFormat�����������ƣ����StrictJson����ΪTrue����
  ����/DATE(MillSeconds+TimeZone)/��ʽ
  ��ע��
  ����ʱ�����ͽ�����������ʱ������JSON��ʵ������Ϊ�ַ����������ַ����ٴδ�ʱ
  ����ʧ������Ϣ�������Կ���ֱ����AsDateTime��������д���������ʱ������ʹ��
  JavaScript��.net��ʽ���Ұ�����ʱ����Ϣ����ʱ�佫��ת��Ϊ��������ʱ�䡣

  2014.5.1
  ========
  + ����AddRecord������֧��ֱ�ӱ����¼���ݣ����������͵ĳ�Ա�ᱻ����
  ����(Class)������(Method)���ӿ�(Interface)����������(ClassRef),ָ��(Pointer)������(Procedure)
  �������ܸ���ʵ����Ҫ�����Ƿ����֧��
  + ����ToRecord���������Jsonֱ�ӵ���¼���͵�ת��
  + ����Copy�������ڴ�����ǰ����һ������ʵ����ע��Ŀǰ�汾��¡�ڲ�������Copy�������������ܸĵ�
  * ������Assign������һ������
}
// ���Ի�����ΪDelphi 2007��XE6�������汾�Ŀ����������������޸�
uses classes, sysutils, math, qstring, typinfo, qrbtree
{$IFDEF MSWINDOWS}, windows{$ENDIF}
{$IFDEF UNICODE}, Generics.Collections, Rtti{$ENDIF}
{$IF RTLVersion<22}// 2007-2010
    , PerlRegEx, pcre
{$ELSE}
    , RegularExpressionsCore
{$IFEND}
    ;
{$M+}
{$HPPEMIT '#pragma link "qjson"'}

// ���Ҫʹ����������ʾ��ʽ����TForm1.FormCreate,����������Ķ��壬���򷽷���ΪForm1.FormCreate
{ .$DEFINE TYPENAMEASMETHODPREF }
type
  /// ����Ԫ��QDAC����ɲ��֣���QDAC��Ȩ���ƣ��������QDAC��վ�˽�
  /// <summary>
  /// JSON������Ԫ�����ڿ��ٽ�����ά��JSON�ṹ.ȫ�ֱ���StrictJsonΪFalseʱ��֧��
  /// ע�ͺ����Ʋ�����'"'��
  /// </summary>
  /// TQJsonDataType���ڼ�¼JSON����Ԫ�����ͣ���ȡֵ������
  /// <list>
  /// <item>
  /// <term>jdtUnknown</term><description>δ֪���ͣ�ֻ���¹������δ��ֵʱ���Ż��Ǹ�����</description>
  /// </item>
  /// <item>
  /// <term>jdtNull</term><description>NULL</description>
  /// </item>
  /// <item>
  /// <term>jdtString</term><description>�ַ���</description>
  /// </item>
  /// <item>
  /// <term>jdtInteger</term><description>����(Int64,��������ֵ����ڲ���ʹ��64λ��������)</description>
  /// </item>
  /// <item>
  /// <term>jdtFloat</term><description>˫���ȸ�����(Double)</description>
  /// </item>
  /// <item>
  /// <term>jdtBoolean</term><description>����</description>
  /// </item>
  /// <item>
  /// <term>jdtDateTime</term><description>����ʱ������</description>
  /// </item>
  /// <item>
  /// <term>jdtArray</term><description>����</description>
  /// </item>
  /// <item>
  /// <term>jdtObject</term><description>����</description>
  /// </item>
  /// </list>
  TQJsonDataType = (jdtUnknown, jdtNull, jdtString, jdtInteger, jdtFloat,
    jdtBoolean, jdtDateTime, jdtArray, jdtObject);
  TQJson = class;
{$IFDEF UNICODE}
  /// <summary>
  /// RTTI��Ϣ���˻ص���������XE6��֧��������������XE����ǰ�İ汾�����¼��ص�
  /// </summary>
  /// <param name="ASender">�����¼���TQJson����</param>
  /// <param name="AName">������(AddObject)���ֶ���(AddRecord)</param>
  /// <param name="AType">���Ի��ֶε�������Ϣ</param>
  /// <param name="Accept">�Ƿ��¼�����Ի��ֶ�</param>
  /// <param name="ATag">�û��Զ���ĸ������ݳ�Ա</param>
  TQJsonRttiFilterEventA = reference to procedure(ASender: TQJson;
    AObject: Pointer; AName: QStringW; AType: PTypeInfo; var Accept: Boolean;
    ATag: Pointer);
  /// <summary>
  /// �����˴�����������XE6��֧����������
  /// </summary>
  /// <param name="ASender">�����¼���TQJson����</param>
  /// <param name="AItem">Ҫ���˵Ķ���</param>
  /// <param name="Accept">�Ƿ�Ҫ����ö���</param>
  /// <param name="ATag">�û����ӵ�������</param>
  TQJsonFilterEventA = reference to procedure(ASender, AItem: TQJson;
    var Accept: Boolean; ATag: Pointer);
{$ENDIF UNICODE}
  /// <summary>
  /// RTTI��Ϣ���˻ص���������XE6��֧��������������XE����ǰ�İ汾�����¼��ص�
  /// </summary>
  /// <param name="ASender">�����¼���TQJson����</param>
  /// <param name="AName">������(AddObject)���ֶ���(AddRecord)</param>
  /// <param name="AType">���Ի��ֶε�������Ϣ</param>
  /// <param name="Accept">�Ƿ��¼�����Ի��ֶ�</param>
  /// <param name="ATag">�û��Զ���ĸ������ݳ�Ա</param>
  TQJsonRttiFilterEvent = procedure(ASender: TQJson; AObject: Pointer;
    AName: QStringW; AType: PTypeInfo; var Accept: Boolean; ATag: Pointer)
    of object;
  /// <summary>
  /// �����˴�����������XE6��֧����������
  /// </summary>
  /// <param name="ASender">�����¼���TQJson����</param>
  /// <param name="AItem">Ҫ���˵Ķ���</param>
  /// <param name="Accept">�Ƿ�Ҫ����ö���</param>
  /// <param name="ATag">�û����ӵ�������</param>
  TQJsonFilterEvent = procedure(ASender, AItem: TQJson; var Accept: Boolean;
    ATag: Pointer) of object;
  PQJson = ^TQJson;
{$IFDEF UNICODE}
  TQJsonItemList = TList<TQJson>;
{$ELSE}
  TQJsonItemList = TList;
{$ENDIF}
  /// <summary>
  /// TQJsonTagType�����ڲ�AddObject��AddRecord�������ڲ�����ʹ��
  /// </summary>
  /// <list>
  /// <item>
  /// <term>ttAnonEvent</term><description>�ص���������</description>
  /// <term>ttNameFilter</term><description>���Ի��Ա���ƹ���</descriptio>
  /// </list>
  TQJsonTagType = (ttAnonEvent, ttNameFilter);
  PQJsonInternalTagData = ^TQJsonInternalTagData;

  /// <summary>
  /// TQJsonInternalTagData����AddRecord��AddObject������Ҫ�ڲ�����RTTI��Ϣʱʹ��
  /// </summary>
  TQJsonInternalTagData = record
    /// <summary>Tag���ݵ�����</summary>
    TagType: TQJsonTagType;
{$IFDEF UNICODE}
    /// <summary>����ʹ�õ���������</summary>
    OnEvent: TQJsonRttiFilterEventA;
{$ENDIF UNICODE}
    /// <summary>���ܵ�����(AddObject)���¼�ֶ�(AddRecord)���ƣ��������ͬʱ��IgnoreNames���֣���IgnoreNames�����Ϣ������</summary>
    AcceptNames: QStringW;
    /// <summary>���Ե�����(AddObject)���¼�ֶ�(AddRecord)���ƣ��������ͬʱ��AcceptNameds���AcceptNames����</summary>
    IgnoreNames: QStringW;
    /// <summary>ԭʼ���ݸ�AddObject��AddRecord�ĸ������ݳ�Ա�����������ݸ�OnEvent��Tag���Թ��û�ʹ��</summary>
    Tag: Pointer;
  end;

  TQJsonEnumerator = class;
  /// <summary>�����ⲿ֧�ֶ���صĺ���������һ���µ�QJSON����ע��ӳ��д����Ķ���</summary>
  /// <returns>�����´�����QJSON����</returns>
  TQJsonCreateEvent = function: TQJson;
  /// <summary>�����ⲿ�����󻺴棬�Ա����ö���</summary>
  /// <param name="AJson">Ҫ�ͷŵ�Json����</param>
  TQJsonFreeEvent = procedure(AJson: TQJson);

  EJsonError = class(Exception)

  end;

  /// <summary>
  /// TQJson���ڽ�����ά��JSON��ʽ�Ķ������ͣ�Ҫʹ��ǰ����Ҫ���ڶ��д�����Ӧ��ʵ����
  /// TQJson��TQXML�ھ�������ӿ��ϱ���һ�£�������Json����������Ϣ����XMLû������
  /// ��Ϣ��ʼ����Ϊ���ַ�����������ٲ��ֽӿڻ����в�ͬ.
  /// ������ʵ�ֲ�ͬ��QJSON���е����Ͷ���ͬһ������ʵ�֣�����DataType�Ĳ�ͬ����ʹ��
  /// ��ͬ�ĳ�Ա�����ʡ�������ΪjdtArray������jdtObjectʱ�����������ӽ��.
  /// </summary>
  TQJson = class
  protected
    FName: QStringW;
    FNameHash: Cardinal;
    FDataType: TQJsonDataType;
    FValue: QStringW;
    FParent: TQJson;
    FData: Pointer;
    FItems: TQJsonItemList;
    function GetValue: QStringW;
    procedure SetValue(const Value: QStringW);
    procedure SetDataType(const Value: TQJsonDataType);
    function GetAsBoolean: Boolean;
    function GetAsFloat: Extended;
    function GetAsInt64: Int64;
    function GetAsInteger: Integer;
    function GetAsString: QStringW;
    procedure SetAsBoolean(const Value: Boolean);
    procedure SetAsFloat(const Value: Extended);
    procedure SetAsInt64(const Value: Int64);
    procedure SetAsInteger(const Value: Integer);
    procedure SetAsString(const Value: QStringW);
    function GetAsObject: QStringW;
    procedure SetAsObject(const Value: QStringW);
    function GetAsDateTime: TDateTime;
    procedure SetAsDateTime(const Value: TDateTime);
    function GetCount: Integer;
    function GetItems(AIndex: Integer): TQJson;
    function CharUnescape(var p: PQCharW): QCharW;
    function CharEscape(c: QCharW; pd: PQCharW): Integer;
    procedure ArrayNeeded(ANewType: TQJsonDataType);
    procedure ValidArray;
    procedure ParseObject(var p: PQCharW);
    function ParseJsonPair(ABuilder: TQStringCatHelperW;
      var p: PQCharW): Integer;
    procedure BuildJsonString(ABuilder: TQStringCatHelperW; var p: PQCharW);
    function ParseName(ABuilder: TQStringCatHelperW; var p: PQCharW): Integer;
    procedure ParseValue(ABuilder: TQStringCatHelperW; var p: PQCharW);
    function FormatParseError(ACode: Integer; AMsg: QStringW; ps, p: PQCharW)
      : QStringW;
    procedure RaiseParseException(ACode: Integer; ps, p: PQCharW);
    function TryParseValue(ABuilder: TQStringCatHelperW;
      var p: PQCharW): Integer;
    function BoolToStr(const b: Boolean): QStringW;
    function GetIsNull: Boolean;
    function GetIsNumeric: Boolean;
    function GetIsArray: Boolean;
    function GetIsObject: Boolean;
    function GetIsString: Boolean;
    function GetIsDateTime: Boolean;
    function GetAsArray: QStringW;
    procedure SetAsArray(const Value: QStringW);
    function GetPath: QStringW;
    function GetAsVariant: Variant;
    procedure SetAsVariant(const Value: Variant);
    function GetAsJson: QStringW;
    procedure SetAsJson(const Value: QStringW);
    function GetItemIndex: Integer;
    function ParseJsonTime(p: PQCharW; var ATime: TDateTime): Boolean;
    function CreateJson: TQJson; virtual;
    procedure FreeJson(AJson: TQJson); inline;
    procedure CopyValue(ASource: TQJson); inline;
    procedure Replace(AIndex: Integer; ANewItem: TQJson); virtual;
    procedure InternalRttiFilter(ASender: TQJson; AObject: Pointer;
      APropName: QStringW; APropType: PTypeInfo; var Accept: Boolean;
      ATag: Pointer);
    function InternalEncode(ABuilder: TQStringCatHelperW; ADoFormat: Boolean;
      ADoEscape: Boolean; ANullConvert: Boolean; const AIndent: QStringW)
      : TQStringCatHelperW;
    function ArrayItemTypeName(ATypeName: QStringW): QStringW;
    function ArrayItemType(ArrType: PTypeInfo): PTypeInfo;
  public
    /// <summary>���캯��</summary>
    constructor Create; overload;
    constructor Create(const AName, AValue: QStringW;
      ADataType: TQJsonDataType = jdtUnknown); overload;
    /// <summary>��������</summary>
    destructor Destroy; override;
    { <summary�����һ���ӽ��<��summary>
      <param name="ANode">Ҫ��ӵĽ��</param>
      <returns>������ӵĽ������</returns>
    }
    function Add(ANode: TQJson): Integer; overload;
    /// <summary>���һ��δ������JSON�ӽ��</summary>
    /// <returns>������ӵĽ��ʵ��</returns>
    /// <remarks>
    /// һ������£������������ͣ���Ӧ���δ������ʵ��
    /// </remarks>
    function Add: TQJson; overload;
    function Add(AName, AValue: QStringW;
      ADataType: TQJsonDataType = jdtUnknown): Integer; overload;
    /// <summary>���һ������</summary>
    /// <param name="AName">Ҫ��ӵĶ���Ľ������</param>
    /// <param name="AItems">Ҫ��ӵ���������</param>
    /// <returns>���ش����Ľ��ʵ��</returns>
    function Add(const AName: QStringW; AItems: array of const)
      : TQJson; overload;
    { <summary>���һ���ӽ��</summary>
      <param name="AName">Ҫ��ӵĽ����</param>
      <param name="ADataType">Ҫ��ӵĽ���������ͣ����ʡ�ԣ����Զ�����ֵ�����ݼ��</param>
      <returns>������ӵ��¶���</returns>
      <remarks>
      1.�����ǰ���Ͳ���jdtObject��jdtArray�����Զ�ת��ΪjdtObject����
      2.�ϲ�Ӧ�Լ������������
      </remarks>
    }
    function Add(AName: QStringW; ADataType: TQJsonDataType): TQJson; overload;

    /// <summary>���һ���ӽ��</summary>
    /// <param name="AName">Ҫ��ӵĽ�����������ǰ���Ϊ���飬�������ʱ����Ը�ֵ</param>
    /// <param name="AValue">Ҫ��ӵĽ��ֵ</param>
    /// <returns>������ӵ��¶���</returns>
    function Add(AName: QStringW; AValue: Extended): TQJson; overload;
    /// <summary>���һ���ӽ��</summary>
    /// <param name="AName">Ҫ��ӵĽ�����������ǰ���Ϊ���飬�������ʱ����Ը�ֵ</param>
    /// <param name="AValue">Ҫ��ӵĽ��ֵ</param>
    /// <returns>������ӵ��¶���</returns>
    function Add(AName: QStringW; AValue: Int64): TQJson; overload;
    /// <summary>���һ���ӽ��</summary>
    /// <param name="AName">Ҫ��ӵĽ�����������ǰ���Ϊ���飬�������ʱ����Ը�ֵ</param>
    /// <param name="AValue">Ҫ��ӵĽ��ֵ</param>
    /// <returns>������ӵ��¶���</returns>
    function Add(AName: QStringW; AValue: Boolean): TQJson; overload;
    /// <summary>���һ���ӽ��</summary>
    /// <param name="AName">Ҫ��ӵĽ�����������ǰ���Ϊ���飬�������ʱ����Ը�ֵ</param>
    /// <param name="AValue">Ҫ��ӵ��ӽ��</param>
    /// <returns>������ӵ��¶��������λ��</returns>
    /// <remarks>��ӵĽ���ͷŹ�������㸺���ⲿ��Ӧ���ͷ�</remarks>
    function Add(AName: QStringW; AChild: TQJson): Integer; overload;
    /// <summary>���һ�����������ӽ��</summary>
    /// <param name="AName">Ҫ��ӵĽ�����������ǰ���Ϊ���飬�������ʱ����Ը�ֵ</param>
    /// <returns>������ӵ��¶���</returns>
    function AddArray(AName: QStringW): TQJson; overload;
    /// <summary>���һ���ӽ��</summary>
    /// <param name="AName">Ҫ��ӵĽ�����������ǰ���Ϊ���飬�������ʱ����Ը�ֵ</param>
    /// <param name="AValue">Ҫ��ӵĽ��ֵ</param>
    /// <returns>������ӵ��¶���</returns>
    function AddDateTime(AName: QStringW; AValue: TDateTime): TQJson; overload;
    /// <summary>���һ���ӽ��</summary>
    /// <param name="AName">Ҫ��ӵĽ�����������ǰ���Ϊ���飬�������ʱ����Ը�ֵ</param>
    /// <param name="AValue">Ҫ��ӵĽ��ֵ</param>
    /// <returns>������ӵ��¶���</returns>
    function AddVariant(AName: QStringW; AValue: Variant): TQJson; overload;
    /// <summary>���һ���ӽ��(Null)</summary>
    /// <param name="AName">Ҫ��ӵĽ�����������ǰ���Ϊ���飬�������ʱ����Ը�ֵ</param>
    /// <returns>������ӵ��¶���</returns>
    function Add(AName: QStringW): TQJson; overload; virtual;

    /// <summary>ǿ��һ��·������,���������,�����δ�����Ҫ�Ľ��(jdtObject��jdtArray)</summary>
    /// <param name="APath">Ҫ��ӵĽ��·��</param>
    /// <returns>����·����Ӧ�Ķ���</returns>
    /// <remarks>
    /// ��������·����ȫ�����ڣ���ForcePath�ᰴ���¹���ִ��:
    /// 1�����APath�а���[]������Ϊ��Ӧ��·�����Ϊ���飬ʾ�����£�
    /// (1)��'a.b[].name'��
    /// a -> jdtObject
    /// b -> jdtArray
    /// b[0].name -> jdtNull(b������δָ�����Զ���Ϊ��b[0]
    /// (2)��'a.c[2].name'��
    /// a -> jdtObject
    /// c -> jdtArray
    /// c[2].name -> jdtNull
    /// ����,c[0],c[1]���Զ�����������ֵΪjdtNull��ִ����ɺ�cΪ��������Ԫ�ص�����
    /// (3)��'a[0]'��
    /// a -> jdtArray
    /// a[0] -> jdtNull
    /// 2��·���ָ���./\�ǵȼ۵ģ����ҽ�������в�Ӧ�������������ַ�֮һ,����
    /// a.b.c��a\b\c��a/b/c����ȫ��ͬ��·��
    /// 3�����APathָ���Ķ������Ͳ�ƥ�䣬����׳��쳣����aΪ���󣬵�ʹ��a[0].b����ʱ��
    /// </remarks>
    function ForcePath(APath: QStringW): TQJson;
    /// <summary>����ָ����JSON�ַ���</summary>
    /// <param name="p">Ҫ�������ַ���</param>
    /// <param name="l">�ַ������ȣ�<=0��Ϊ����\0(#0)��β��C���Ա�׼�ַ���</param>
    /// <remarks>���l>=0������p[l]�Ƿ�Ϊ\0�������Ϊ\0����ᴴ������ʵ������������ʵ��</remarks>
    procedure Parse(p: PWideChar; l: Integer = -1); overload;
    /// <summary>����ָ����JSON�ַ���</summary>
    /// <param name="s">Ҫ������JSON�ַ���</param>
    procedure Parse(const s: QStringW); overload;
    function TryParse(p: PWideChar; l: Integer = -1): Boolean; overload;
    /// <summary>����ָ����JSON�ַ���</summary>
    /// <param name="s">Ҫ������JSON�ַ���</param>
    function TryParse(const s: QStringW): Boolean; overload;
    /// <summmary>�����н����׸�JSON���ݿ�</summary>
    /// <param name="AStream">������</param>
    /// <param name="AEncoding">�����ݵı��뷽ʽ</param>
    /// <remarks>ParseBlock�ʺϽ����ֶ�ʽJSON������ӵ�ǰλ�ÿ�ʼ����������ǰ�������Ϊֹ.
    /// ���Ժܺõ����㽥��ʽ�������Ҫ</remarks>
    procedure ParseBlock(AStream: TStream; AEncoding: TTextEncoding);
    /// <summary>��������һ���µ�ʵ��</summary>
    /// <returns>�����µĿ���ʵ��</returns>
    /// <remarks>��Ϊ�ǿ����������¾ɶ���֮������ݱ��û���κι�ϵ����������һ��
    /// ���󣬲��������һ���������Ӱ�졣
    /// </remarks>
    function Copy: TQJson;
{$IFDEF UNICODE}
    /// <summary>��������һ���µ�ʵ��</summary>
    /// <param name="ATag">�û����ӵı�ǩ����</param>
    /// <param name="AFilter">�û������¼������ڿ���Ҫ����������</param>
    /// <returns>�����µĿ���ʵ��</returns>
    /// <remarks>��Ϊ�ǿ����������¾ɶ���֮������ݱ��û���κι�ϵ����������һ��
    /// ���󣬲��������һ���������Ӱ�졣
    /// </remarks>
    function CopyIf(const ATag: Pointer; AFilter: TQJsonFilterEventA)
      : TQJson; overload;
{$ENDIF UNICODE}
    /// <summary>��������һ���µ�ʵ��</summary>
    /// <param name="ATag">�û����ӵı�ǩ����</param>
    /// <param name="AFilter">�û������¼������ڿ���Ҫ����������</param>
    /// <returns>�����µĿ���ʵ��</returns>
    /// <remarks>��Ϊ�ǿ����������¾ɶ���֮������ݱ��û���κι�ϵ����������һ��
    /// ���󣬲��������һ���������Ӱ�졣
    /// </remarks>
    function CopyIf(const ATag: Pointer; AFilter: TQJsonFilterEvent)
      : TQJson; overload;
    /// <summary>��¡����һ���µ�ʵ��</summary>
    /// <returns>�����µĿ���ʵ��</returns>
    /// <remarks>��Ϊʵ����ִ�е��ǿ����������¾ɶ���֮������ݱ��û���κι�ϵ��
    /// ��������һ�����󣬲��������һ���������Ӱ�죬������Ϊ����������֤������
    /// �����Ϊ���ã��Ա��໥Ӱ�졣
    /// </remarks>
    function Clone: TQJson;
    /// <summary>����Ϊ�ַ���</summary>
    /// <param name="ADoFormat">�Ƿ��ʽ���ַ����������ӿɶ���</param>
    /// <param name="ADoEscape">�Ƿ�ת�����ĸ�������ַ�</param>
    /// <param name="AIndent">ADoFormat����ΪTrueʱ���������ݣ�Ĭ��Ϊ�����ո�</param>
    /// <returns>���ر������ַ���</returns>
    /// <remarks>AsJson�ȼ���Encode(True,'  ')</remarks>
    function Encode(ADoFormat: Boolean; ADoEscape: Boolean = False;
      AIndent: QStringW = '  '): QStringW;
    /// <summary>��ȡָ�����ƻ�ȡ����ֵ���ַ�����ʾ</summary>
    /// <param name="AName">�������</param>
    /// <returns>����Ӧ����ֵ</returns>
    function ValueByName(AName, ADefVal: QStringW): QStringW;
    /// <summary>��ȡָ��·������ֵ���ַ�����ʾ</summary>
    /// <param name="AName">�������</param>
    /// <returns>�����������ڣ�����Ĭ��ֵ�����򣬷���ԭʼֵ</returns>
    function ValueByPath(APath, ADefVal: QStringW): QStringW;
    /// <summary>��ȡָ�����Ƶĵ�һ�����</summary>
    /// <param name="AName">�������</param>
    /// <returns>�����ҵ��Ľ�㣬���δ�ҵ������ؿ�(NULL/nil)</returns>
    /// <remarks>ע��QJson���������������ˣ�������������Ľ�㣬ֻ�᷵�ص�һ�����</remarks>
    function ItemByName(AName: QStringW): TQJson; overload;
    /// <summary>��ȡָ�����ƵĽ�㵽�б���</summary>
    /// <param name="AName">�������</param>
    /// <param name="AList">���ڱ�������б����</param>
    /// <param name="ANest">�Ƿ�ݹ�����ӽ��</param>
    /// <returns>�����ҵ��Ľ�����������δ�ҵ�������0</returns>
    function ItemByName(const AName: QStringW; AList: TQJsonItemList;
      ANest: Boolean = False): Integer; overload;
    /// <summary>��ȡ����ָ�����ƹ���Ľ�㵽�б���</summary>
    /// <param name="ARegex">������ʽ</param>
    /// <param name="AList">���ڱ�������б����</param>
    /// <param name="ANest">�Ƿ�ݹ�����ӽ��</param>
    /// <returns>�����ҵ��Ľ�����������δ�ҵ�������0</returns>
    function ItemByRegex(const ARegex: QStringW; AList: TQJsonItemList;
      ANest: Boolean = False): Integer; overload;
    /// <summary>��ȡָ��·����JSON����</summary>
    /// <param name="APath">·������"."��"/"��"\"�ָ�</param>
    /// <returns>�����ҵ����ӽ�㣬���δ�ҵ�����NULL(nil)</returns>
    function ItemByPath(APath: QStringW): TQJson;
    /// <summary>��Դ������JSON��������</summary>
    /// <param name="ANode">Ҫ���Ƶ�Դ���</param>
    /// <remarks>ע�ⲻҪ�����ӽ����Լ�������������ѭ����Ҫ�����ӽ�㣬�ȸ�
    /// ��һ���ӽ�����ʵ�����ٴ���ʵ������
    /// </remarks>
    procedure Assign(ANode: TQJson); virtual;
    /// <summary>ɾ��ָ�������Ľ��</summary>
    /// <param name="AIndex">Ҫɾ���Ľ������</param>
    /// <remarks>
    /// ���ָ�������Ľ�㲻���ڣ����׳�EOutRange�쳣
    /// </remarks>
    procedure Delete(AIndex: Integer); overload; virtual;
    /// <summary>ɾ��ָ�����ƵĽ��</summary>
    /// <param name="AName">Ҫɾ���Ľ������</param>
    /// <remarks>
    /// ���Ҫ��������Ľ�㣬��ֻɾ����һ��
    procedure Delete(AName: QStringW); overload;
{$IFDEF UNICODE}
    /// <summary>
    /// ɾ�������������ӽ��
    /// </summary>
    /// <param name="ATag">�û��Լ����ӵĶ�����</param>
    /// <param name="ANest">�Ƿ�Ƕ�׵��ã����Ϊfalse����ֻ�Ե�ǰ�ӽ�����</param>
    /// <param name="AFilter">���˻ص����������Ϊnil���ȼ���Clear</param>
    procedure DeleteIf(const ATag: Pointer; ANest: Boolean;
      AFilter: TQJsonFilterEventA); overload;
{$ENDIF UNICODE}
    /// <summary>
    /// ɾ�������������ӽ��
    /// </summary>
    /// <param name="ATag">�û��Լ����ӵĶ�����</param>
    /// <param name="ANest">�Ƿ�Ƕ�׵��ã����Ϊfalse����ֻ�Ե�ǰ�ӽ�����</param>
    /// <param name="AFilter">���˻ص����������Ϊnil���ȼ���Clear</param>
    procedure DeleteIf(const ATag: Pointer; ANest: Boolean;
      AFilter: TQJsonFilterEvent); overload;
    /// <summary>����ָ�����ƵĽ�������</summary>
    /// <param name="AName">Ҫ���ҵĽ������</param>
    /// <returns>��������ֵ��δ�ҵ�����-1</returns>
    function IndexOf(const AName: QStringW): Integer; virtual;
{$IFDEF UNICODE}
    /// <summary>���������ҷ��������Ľ��</summary>
    /// <param name="ATag">�û��Զ���ĸ��Ӷ�����</param>
    /// <param name="ANest">�Ƿ�Ƕ�׵��ã����Ϊfalse����ֻ�Ե�ǰ�ӽ�����</param>
    /// <param name="AFilter">���˻ص����������Ϊnil���򷵻�nil</param>
    function FindIf(const ATag: Pointer; ANest: Boolean;
      AFilter: TQJsonFilterEventA): TQJson; overload;
{$ENDIF UNICODE}
    /// <summary>���������ҷ��������Ľ��</summary>
    /// <param name="ATag">�û��Զ���ĸ��Ӷ�����</param>
    /// <param name="ANest">�Ƿ�Ƕ�׵��ã����Ϊfalse����ֻ�Ե�ǰ�ӽ�����</param>
    /// <param name="AFilter">���˻ص����������Ϊnil���򷵻�nil</param>
    function FindIf(const ATag: Pointer; ANest: Boolean;
      AFilter: TQJsonFilterEvent): TQJson; overload;
    /// <summary>������еĽ��</summary>
    procedure Clear; virtual;
    /// <summary>���浱ǰ�������ݵ�����</summary>
    /// <param name="AStream">Ŀ��������</param>
    /// <param name="AEncoding">�����ʽ</param>
    /// <param name="AWriteBom">�Ƿ�д��BOM</param>
    /// <remarks>ע�⵱ǰ�������Ʋ��ᱻд��</remarks>
    procedure SaveToStream(AStream: TStream; AEncoding: TTextEncoding;
      AWriteBOM: Boolean);
    /// <summary>�����ĵ�ǰλ�ÿ�ʼ����JSON����</summary>
    /// <param name="AStream">Դ������</param>
    /// <param name="AEncoding">Դ�ļ����룬���ΪteUnknown�����Զ��ж�</param>
    /// <remarks>���ĵ�ǰλ�õ������ĳ��ȱ������2�ֽڣ�����������</remarks>
    procedure LoadFromStream(AStream: TStream;
      AEncoding: TTextEncoding = teUnknown);
    /// <summary>���浱ǰ�������ݵ��ļ���</summary>
    /// <param name="AFileName">�ļ���</param>
    /// <param name="AEncoding">�����ʽ</param>
    /// <param name="AWriteBOM">�Ƿ�д��UTF-8��BOM</param>
    /// <remarks>ע�⵱ǰ�������Ʋ��ᱻд��</remarks>
    procedure SaveToFile(AFileName: String; AEncoding: TTextEncoding;
      AWriteBOM: Boolean);
    /// <summary>��ָ�����ļ��м��ص�ǰ����</summary>
    /// <param name="AFileName">Ҫ���ص��ļ���</param>
    /// <param name="AEncoding">Դ�ļ����룬���ΪteUnknown�����Զ��ж�</param>
    procedure LoadFromFile(AFileName: String;
      AEncoding: TTextEncoding = teUnknown);
    /// / <summary>����ֵΪNull���ȼ���ֱ������DataTypeΪjdtNull</summary>
    procedure ResetNull;
    /// <summary>����TObject.ToString����</summary>
    function ToString: string; {$IFDEF UNICODE}override; {$ELSE}virtual;
{$ENDIF}
    /// <summary>��ȡfor..in��Ҫ��GetEnumerator֧��</summary>
    function GetEnumerator: TQJsonEnumerator;
    /// <summary>�ж��Լ��Ƿ���ָ��������Ӷ���</summmary>
    /// <param name="AParent">���ܵĸ�����</param>
    /// <returns>���AParent���Լ��ĸ����󣬷���True�����򷵻�false</returns>
    function IsChildOf(AParent: TQJson): Boolean;
    /// <summary>�ж��Լ��Ƿ���ָ������ĸ�����</summmary>
    /// <param name="AChild">���ܵ��Ӷ���</param>
    /// <returns>���AChild���Լ����Ӷ��󣬷���True�����򷵻�false</returns>
    function IsParentOf(AChild: TQJson): Boolean;
{$IFDEF UNICODE}
    /// <summary>ʹ�õ�ǰJson�����������ָ���������Ӧ����</summary>
    /// <param name="AInstance">�����������Ķ���ʵ��</param>
    /// <returns>���غ������õĽ��</returns>
    /// <remarks>��������Ϊ��ǰ������ƣ������Ĳ����������ӽ�������Ҫ����һ��</remarks>
    function Invoke(AInstance: TValue): TValue;
    /// <summary>����ǰ��ֵת��ΪTValue���͵�ֵ</summary>
    /// <returns>���ص�ǰ���ת�����TValueֵ</returns>
    function ToRttiValue: TValue;
    /// <summary>��ָ����RTTIʵ��������JSON����</summary>
    /// <param name="AInstance">���������RTTI����ֵ</param>
    /// <remarks>ע�ⲻ��ȫ��RTTI���Ͷ���֧�֣���ӿ�ɶ��</remarks>
    procedure FromRtti(AInstance: TValue); overload;
    /// <summary>��ָ������Դ��ַ��ָ������������JSON����</summary>
    /// <param name="ASource">�����ṹ���ַ</param>
    /// <param name="AType">�����ṹ��������Ϣ</param>
    procedure FromRtti(ASource: Pointer; AType: PTypeInfo); overload;
    /// <summary>��ָ���ļ�¼ʵ��������JSON����</summary>
    /// <param name="ARecord">��¼ʵ��</param>
    procedure FromRecord<T>(const ARecord: T);
    /// <summary>�ӵ�ǰJSON�л�ԭ��ָ���Ķ���ʵ����</summary>
    /// <param name="AInstance">ʵ����ַ</param>
    /// <remarks>ʵ���ϲ���ֻ֧�ֶ��󣬼�¼����Ŀǰ�޷�ֱ��ת��ΪTValue������û
    /// ���壬������������Ϊ��ֵ������ʵ�ʾ��㸳ֵ��Ҳ���ز��ˣ����������</remarks>
    procedure ToRtti(AInstance: TValue); overload;
    /// <summary>�ӵ�ǰJSON�а�ָ����������Ϣ��ԭ��ָ���ĵ�ַ</summary>
    /// <param name="ADest">Ŀ�ĵ�ַ</param>
    /// <param name="AType">�����ṹ���������Ϣ</param>
    /// <remarks>ADest��Ӧ��Ӧ�Ǽ�¼������������Ͳ���֧��</remarks>
    procedure ToRtti(ADest: Pointer; AType: PTypeInfo); overload;
    /// <summary>�ӵ�ǰ��JSON�л�ԭ��ָ���ļ�¼ʵ����</summary>
    /// <param name="ARecord">Ŀ�ļ�¼ʵ��</param>
    procedure ToRecord<T: record >(var ARecord: T);
{$ENDIF}
    /// <summary>�����</summary>
    property Parent: TQJson read FParent;
    /// <summary>�������</summary>
    /// <seealso>TQJsonDataType</seealso>
    property DataType: TQJsonDataType read FDataType write SetDataType;
    /// <summary>�������</summary>
    property Name: QStringW read FName;
    /// <summary>�ӽ������</<summary>summary>
    property Count: Integer read GetCount;
    /// <summary>�ӽ������</summary>
    property Items[AIndex: Integer]: TQJson read GetItems; default;
    /// <summary>�ӽ���ֵ</summary>
    property Value: QStringW read GetValue write SetValue;
    /// <summary>�ж��Ƿ���NULL����</summary>
    property IsNull: Boolean read GetIsNull;
    /// <summary>�ж��Ƿ�����������</summary>
    property IsNumeric: Boolean read GetIsNumeric;
    /// <summary>�ж��Ƿ�������ʱ������</summary>
    property IsDateTime: Boolean read GetIsDateTime;
    /// <summary>�ж��Ƿ����ַ�������</summary>
    property IsString: Boolean read GetIsString;
    /// <summary>�ж��Ƿ��Ƕ���</summary>
    property IsObject: Boolean read GetIsObject;
    /// <summary>�ж��Ƿ�������</summary>
    property IsArray: Boolean read GetIsArray;
    /// <summary>����ǰ��㵱���������ͷ���</summary>
    property AsBoolean: Boolean read GetAsBoolean write SetAsBoolean;
    /// <summary>����ǰ��㵱����������������</summary>
    property AsInteger: Integer read GetAsInteger write SetAsInteger;
    /// <summary>����ǰ��㵱��64λ��������������</summary>
    property AsInt64: Int64 read GetAsInt64 write SetAsInt64;
    /// <summary>����ǰ��㵱����������������</summary>
    property AsFloat: Extended read GetAsFloat write SetAsFloat;
    /// <summary>����ǰ��㵱������ʱ������������</summary>
    property AsDateTime: TDateTime read GetAsDateTime write SetAsDateTime;
    /// <summary>����ǰ��㵱���ַ������ͷ���</summary>
    property AsString: QStringW read GetAsString write SetAsString;
    /// <summary>����ǰ��㵱��һ�������ַ���������</summary>
    property AsObject: QStringW read GetAsObject write SetAsObject;
    /// <summary>����ǰ��㵱��һ���ַ�������������</summary>
    property AsArray: QStringW read GetAsArray write SetAsArray;
    /// <summary>���Լ�����Variant����������</summary>
    property AsVariant: Variant read GetAsVariant write SetAsVariant;
    /// <summary>���Լ�����Json����������</summary>
    property AsJson: QStringW read GetAsJson write SetAsJson;
    // <summary>����ĸ������ݳ�Ա�����û�������������</summary>
    property Data: Pointer read FData write FData;
    /// <summary>����·����·���м���"\"�ָ�</summary>
    property Path: QStringW read GetPath;
    /// <summary>�ڸ�����е�����˳�򣬴�0��ʼ�������-1��������Լ��Ǹ����</summary>
    property ItemIndex: Integer read GetItemIndex;
    /// <summary>���ƹ�ϣֵ</summary>
    property NameHash: Cardinal read FNameHash;
  end;

  TQJsonEnumerator = class
  private
    FIndex: Integer;
    FList: TQJson;
  public
    constructor Create(AList: TQJson);
    function GetCurrent: TQJson; inline;
    function MoveNext: Boolean;
    property Current: TQJson read GetCurrent;
  end;

  TQHashedJson = class(TQJson)
  protected
    FHashTable: TQHashTable;
    function CreateJson: TQJson; override;
    procedure Replace(AIndex: Integer; ANewItem: TQJson); override;
  public
    constructor Create; overload;
    destructor Destroy; override;
    procedure Assign(ANode: TQJson); override;
    function Add(AName: QStringW): TQJson; override;
    function IndexOf(const AName: QStringW): Integer; override;
    procedure Delete(AIndex: Integer); override;
    procedure Clear; override;
  end;

var
  /// <summary>�Ƿ������ϸ���ģʽ�����ϸ�ģʽ�£�
  /// 1.���ƻ��ַ�������ʹ��˫���Ű�������,���ΪFalse�������ƿ���û�����Ż�ʹ�õ����š�
  /// 2.ע�Ͳ���֧�֣����ΪFalse����֧��//��ע�ͺ�/**/�Ŀ�ע��
  /// </summary>
  StrictJson: Boolean;
  /// <summary>ָ����δ���RTTI�е�ö�ٺͼ�������</summary>
  JsonRttiEnumAsInt: Boolean;
  /// <summary>��������ת��ΪJson����ʱ��ת�����ַ������������������θ�ʽ��</summary>
  JsonDateFormat: QStringW;
  /// <summary>ʱ������ת��ΪJson����ʱ��ת�����ַ������������������θ�ʽ��</summary>
  JsonTimeFormat: QStringW;
  /// <summary>����ʱ������ת��ΪJson����ʱ��ת�����ַ������������������θ�ʽ��</summary>
  JsonDateTimeFormat: QStringW;
  /// <summary>��ItemByName/ItemByPath/ValueByName/ValueByPath�Ⱥ������ж��У��Ƿ��������ƴ�Сд</summary>
  JsonCaseSensitive: Boolean;
  /// ����Ҫ�½�һ��TQJson����ʱ����
  OnQJsonCreate: TQJsonCreateEvent;
  /// ����Ҫ�ͷ�һ��TQJson����ʱ����
  OnQJsonFree: TQJsonFreeEvent;

implementation

uses variants, dateutils;

resourcestring
  SBadJson = '��ǰ���ݲ�����Ч��JSON�ַ�����';
  SNotArrayOrObject = '%s ����һ��JSON��������';
  SVarNotArray = '%s �����Ͳ�����������';
  SBadConvert = '%s ����һ����Ч�� %s ���͵�ֵ��';
  SCharNeeded = '��ǰλ��Ӧ���� "%s" �������� "%s"��';
  SEndCharNeeded = '��ǰλ����ҪJson�����ַ�",]}"��';
  SBadNumeric = '"%s"������Ч����ֵ��';
  SBadJsonTime = '"%s"����һ����Ч������ʱ��ֵ��';
  SBadNameStart = 'Json�������Ӧ��''"''�ַ���ʼ��';
  SBadNameEnd = 'Json��������δ��ȷ������';
  SNameNotFound = '��Ŀ����δ�ҵ���';
  SCommentNotSupport = '�ϸ�ģʽ�²�֧��ע�ͣ�Ҫ��������ע�͵�JSON���ݣ��뽫StrictJson��������ΪFalse��';
  SUnsupportArrayItem = '��ӵĶ�̬�����%d��Ԫ�����Ͳ���֧�֡�';
  SBadStringStart = '�ϸ����JSON�ַ���������"��ʼ��';
  SUnknownToken = '�޷�ʶ���ע�ͷ���ע�ͱ�����//��/**/������';
  SNotSupport = '���� [%s] �ڵ�ǰ���������²���֧�֡�';
  SBadJsonArray = '%s ����һ����Ч��JSON���鶨�塣';
  SBadJsonObject = '%s ����һ����Ч��JSON�����塣';
  SBadJsonEncoding = '��Ч�ı��룬����ֻ����UTF-8��ANSI��Unicode 16 LE��Unicode 16 BE��';
  SJsonParseError = '��%d�е�%d��:%s '#13#10'��:%s';
  SBadJsonName = '%s ����һ����Ч��JSON�������ơ�';
  SObjectChildNeedName = '���� %s �ĵ� %d ���ӽ������δ��ֵ���������ǰ���踳ֵ��';
  SReplaceTypeNeed = '�滻��������Ҫ���� %s �������ࡣ';
  SSupportFloat = 'NaN/+��/-�޲���JSON�淶֧�֡�';
  SParamMissed = '���� %s ͬ���Ľ��δ�ҵ���';
  SMethodMissed = 'ָ���ĺ��� %s �����ڡ�';
  SMissRttiTypeDefine =
    '�޷��ҵ� %s ��RTTI������Ϣ�����Խ���Ӧ�����͵�������(��array[0..1] of Byte��ΪTByteArr=array[0..1]��Ȼ����TByteArr����)��';
  SUnsupportPropertyType = '��֧�ֵ��������͡�';
  SArrayTypeMissed = 'δ֪������Ԫ�����͡�';
  SUnknownError = 'δ֪�Ĵ���';

const
  JsonTypeName: array [TQJsonDataType] of QStringW = ('Unknown', 'Null',
    'String', 'Integer', 'Float', 'Boolean', 'DateTime', 'Array', 'Object');
  EParse_Unknown = -1;
  EParse_BadStringStart = 1;
  EParse_BadJson = 2;
  EParse_CommentNotSupport = 3;
  EParse_UnknownToken = 4;
  EParse_EndCharNeeded = 5;
  EParse_BadNameStart = 6;
  EParse_BadNameEnd = 7;
  EParse_NameNotFound = 8;
  { TQJson }

function TQJson.Add(AName: QStringW; AValue: Int64): TQJson;
begin
Result := Add(AName, jdtInteger);
PInt64(PQCharW(Result.FValue))^ := AValue;
end;

function TQJson.Add(AName: QStringW; AValue: Extended): TQJson;
begin
Result := Add(AName, jdtFloat);
PExtended(PQCharW(Result.FValue))^ := AValue;
end;

function TQJson.Add(AName: QStringW; AValue: Boolean): TQJson;
begin
Result := Add(AName, jdtBoolean);
PBoolean(PQCharW(Result.FValue))^ := AValue;
end;

function TQJson.Add(AName: QStringW): TQJson;
begin
Result := Add;
Result.FName := AName;
end;

function TQJson.Add(AName: QStringW; AChild: TQJson): Integer;
begin
AChild.FName := AName;
Result := Add(AChild);
end;

function TQJson.AddArray(AName: QStringW): TQJson;
begin
Result := Add(AName, jdtArray);
end;

function TQJson.AddDateTime(AName: QStringW; AValue: TDateTime): TQJson;
begin
Result := Add;
Result.FName := AName;
Result.DataType := jdtString;
Result.AsDateTime := AValue;
end;

function TQJson.AddVariant(AName: QStringW; AValue: Variant): TQJson;
begin
Result := Add(AName);
Result.AsVariant := AValue;
end;

function TQJson.Add: TQJson;
begin
Result := CreateJson;
Add(Result);
end;

function TQJson.Add(ANode: TQJson): Integer;
begin
ArrayNeeded(jdtObject);
Result := FItems.Add(ANode);
ANode.FParent := Self;
end;

function TQJson.Add(AName, AValue: QStringW; ADataType: TQJsonDataType)
  : Integer;
var
  ANode: TQJson;
  p: PQCharW;
  ABuilder: TQStringCatHelperW;
  procedure AddAsDateTime;
  var
    ATime: TDateTime;
  begin
  if ParseDateTime(PQCharW(AValue), ATime) then
    ANode.AsDateTime := ATime
  else if ParseJsonTime(PQCharW(AValue), ATime) then
    ANode.AsDateTime := ATime
  else
    raise Exception.Create(SBadJsonTime);
  end;

begin
ANode := CreateJson;
ANode.FName := AName;
Result := Add(ANode);
p := PQCharW(AValue);
if ADataType = jdtUnknown then
  begin
  ABuilder := TQStringCatHelperW.Create;
  try
    if ANode.TryParseValue(ABuilder, p) <> 0 then
      ANode.AsString := AValue
    else if p^ <> #0 then
      ANode.AsString := AValue;
  finally
    FreeObject(ABuilder);
  end;
  end
else
  begin
  case ADataType of
    jdtString:
      ANode.AsString := AValue;
    jdtInteger:
      ANode.AsInteger := StrToInt(AValue);
    jdtFloat:
      ANode.AsFloat := StrToFloat(AValue);
    jdtBoolean:
      ANode.AsBoolean := StrToBool(AValue);
    jdtDateTime:
      AddAsDateTime;
    jdtArray:
      begin
      if p^ <> '[' then
        raise Exception.CreateFmt(SBadJsonArray, [Value]);
      ANode.ParseObject(p);
      end;
    jdtObject:
      begin
      if p^ <> '{' then
        raise Exception.CreateFmt(SBadJsonObject, [Value]);
      ANode.ParseObject(p);
      end;
  end;

  end;
end;

function TQJson.Add(AName: QStringW; ADataType: TQJsonDataType): TQJson;
begin
Result := Add(AName);
Result.DataType := ADataType;
end;

function TQJson.Add(const AName: QStringW; AItems: array of const): TQJson;
var
  I: Integer;
begin
Result := Add(AName);
Result.DataType := jdtArray;
for I := Low(AItems) to High(AItems) do
  begin
  case AItems[I].VType of
    vtInteger:
      Result.Add.AsInteger := AItems[I].VInteger;
    vtBoolean:
      Result.Add.AsBoolean := AItems[I].VBoolean;
{$IFNDEF NEXTGEN}
    vtChar:
      Result.Add.AsString := QStringW(AItems[I].VChar);
{$ENDIF !NEXTGEN}
    vtExtended:
      Result.Add.AsFloat := AItems[I].VExtended^;
{$IFNDEF NEXTGEN}
    vtPChar:
      Result.Add.AsString := QStringW(AItems[I].VPChar);
    vtString:
      Result.Add.AsString := QStringW(AItems[I].VString^);
    vtAnsiString:
      Result.Add.AsString := QStringW(
{$IFDEF UNICODE}
        PAnsiString(AItems[I].VAnsiString)^
{$ELSE}
        AItems[I].VPChar
{$ENDIF UNICODE}
        );
    vtWideString:
      Result.Add.AsString := PWideString(AItems[I].VWideString)^;
{$ENDIF !NEXTGEN}
    vtPointer:
      Result.Add.AsInt64 := IntPtr(AItems[I].VPointer);
    vtWideChar:
      Result.Add.AsString := AItems[I].VWideChar;
    vtPWideChar:
      Result.Add.AsString := AItems[I].VPWideChar;
    vtCurrency:
      Result.Add.AsFloat := AItems[I].VCurrency^;
    vtInt64:
      Result.Add.AsInt64 := AItems[I].VInt64^;
{$IFDEF UNICODE}       // variants
    vtUnicodeString:
      Result.Add.AsString := AItems[I].VPWideChar;
{$ENDIF UNICODE}
    vtVariant:
      Result.Add.AsVariant := AItems[I].VVariant^;
    vtObject:
      begin
      if TObject(AItems[I].VObject) is TQJson then
        Result.Add(TObject(AItems[I].VObject) as TQJson)
      else
        raise Exception.Create(Format(SUnsupportArrayItem, [I]));
      end
  else
    raise Exception.Create(Format(SUnsupportArrayItem, [I]));
  end; // End case
  end; // End for
end;

function TQJson.ArrayItemType(ArrType: PTypeInfo): PTypeInfo;
var
  ATypeData: PTypeData;
begin
Result := nil;
if (ArrType <> nil) and (ArrType.Kind in [tkArray, tkDynArray]) then
  begin
  ATypeData := GetTypeData(ArrType);
  if (ATypeData <> nil) then
    Result := ATypeData.elType2^;
  if Result = nil then
    begin
    if ATypeData.BaseType^ = TypeInfo(Byte) then
      Result := TypeInfo(Byte);
    end;
  end;
end;

function TQJson.ArrayItemTypeName(ATypeName: QStringW): QStringW;
var
  p, ps: PQCharW;
  ACount: Integer;
begin
p := PQCharW(ATypeName);
if StartWithW(p, 'TArray<', true) then
  begin
  Inc(p, 7);
  ps := p;
  ACount := 1;
  while ACount > 0 do
    begin
    if p^ = '>' then
      Dec(ACount)
    else if p^ = '<' then
      Inc(ACount);
    Inc(p);
    end;
  Result := StrDupX(ps, p - ps - 1);
  end
else
  Result := '';
end;

procedure TQJson.ArrayNeeded(ANewType: TQJsonDataType);
begin
if not(DataType in [jdtArray, jdtObject]) then
  begin
  FDataType := ANewType;
  ValidArray;
  end;
end;

procedure TQJson.Assign(ANode: TQJson);
var
  I: Integer;
  AItem, ACopy: TQJson;
begin
if ANode.FDataType in [jdtArray, jdtObject] then
  begin
  DataType := ANode.FDataType;
  Clear;
  for I := 0 to ANode.Count - 1 do
    begin
    AItem := ANode[I];
    if Length(AItem.FName) > 0 then
      begin
      ACopy := Add(AItem.FName);
      ACopy.FNameHash := AItem.FNameHash;
      end
    else
      ACopy := Add;
    ACopy.Assign(AItem);
    end;
  end
else
  CopyValue(ANode);
end;

function TQJson.BoolToStr(const b: Boolean): QStringW;
begin
if b then
  Result := 'true'
else
  Result := 'false';
end;

procedure TQJson.BuildJsonString(ABuilder: TQStringCatHelperW; var p: PQCharW);
var
  AQuoter: QCharW;
  ps: PQCharW;
begin
ABuilder.Position := 0;
if (p^ = '"') or (p^ = '''') then
  begin
  AQuoter := p^;
  Inc(p);
  ps := p;
  while p^ <> #0 do
    begin
    if (p^ = AQuoter) then
      begin
      if ps <> p then
        ABuilder.Cat(ps, p - ps);
      if p[1] = AQuoter then
        begin
        ABuilder.Cat(AQuoter);
        Inc(p, 2);
        ps := p;
        end
      else
        begin
        Inc(p);
        SkipSpaceW(p);
        ps := p;
        Break;
        end;
      end
    else if p^ = '\' then
      begin
      if ps <> p then
        ABuilder.Cat(ps, p - ps);
      ABuilder.Cat(CharUnescape(p));
      ps := p;
      end
    else
      Inc(p);
    end;
  if ps <> p then
    ABuilder.Cat(ps, p - ps);
  end
else
  begin
  while p^ <> #0 do
    begin
    if (p^ = ':') or (p^ = ']') or (p^ = ',') or (p^ = '}') then
      Break
    else
      ABuilder.Cat(p, 1);
    Inc(p);
    end
  end;
end;

function TQJson.CharEscape(c: QCharW; pd: PQCharW): Integer;
begin
case c of
  #7:
    begin
    pd[0] := '\';
    pd[1] := 'b';
    Result := 2;
    end;
  #9:
    begin
    pd[0] := '\';
    pd[1] := 't';
    Result := 2;
    end;
  #10:
    begin
    pd[0] := '\';
    pd[1] := 'n';
    Result := 2;
    end;
  #12:
    begin
    pd[0] := '\';
    pd[1] := 'f';
    Result := 2;
    end;
  #13:
    begin
    pd[0] := '\';
    pd[1] := 'r';
    Result := 2;
    end;
  '\':
    begin
    pd[0] := '\';
    pd[1] := '\';
    Result := 2;
    end;
  '''':
    begin
    pd[0] := '\';
    pd[1] := '''';
    Result := 2;
    end;
  '"':
    begin
    pd[0] := '\';
    pd[1] := '"';
    Result := 2;
    end;
  '/':
    begin
    pd[0] := '\';
    pd[1] := '/';
    Result := 2;
    end
else
  begin
  pd[0] := c;
  Result := 1;
  end;
end;
end;

function TQJson.CharUnescape(var p: PQCharW): QCharW;
  function DecodeOrd: Integer;
  var
    c: Integer;
  begin
  Result := 0;
  c := 0;
  while (p^ <> #0) and (c < 4) do
    begin
    if IsHexChar(p^) then
      Result := (Result shl 4) + HexValue(p^)
    else
      Break;
    Inc(p);
    Inc(c);
    end
  end;

begin
if p^ = #0 then
  begin
  Result := #0;
  Exit;
  end;
if p^ <> '\' then
  begin
  Result := p^;
  Inc(p);
  Exit;
  end;
Inc(p);
case p^ of
  'b':
    begin
    Result := #7;
    Inc(p);
    end;
  't':
    begin
    Result := #9;
    Inc(p);
    end;
  'n':
    begin
    Result := #10;
    Inc(p);
    end;
  'f':
    begin
    Result := #12;
    Inc(p);
    end;
  'r':
    begin
    Result := #13;
    Inc(p);
    end;
  '\':
    begin
    Result := '\';
    Inc(p);
    end;
  '''':
    begin
    Result := '''';
    Inc(p);
    end;
  '"':
    begin
    Result := '"';
    Inc(p);
    end;
  'u':
    begin
    // \uXXXX
    if IsHexChar(p[1]) and IsHexChar(p[2]) and IsHexChar(p[3]) and
      IsHexChar(p[4]) then
      begin
      Result := WideChar((HexValue(p[1]) shl 12) or (HexValue(p[2]) shl 8) or
        (HexValue(p[3]) shl 4) or HexValue(p[4]));
      Inc(p, 5);
      end
    else
      raise Exception.CreateFmt(SCharNeeded, ['0-9A-Fa-f', StrDupW(p, 0, 4)]);
    end;
  '/':
    begin
    Result := '/';
    Inc(p);
    end
else
  begin
  if StrictJson then
    raise Exception.CreateFmt(SCharNeeded, ['btfrn"u''/', StrDupW(p, 0, 4)])
  else
    begin
    Result := p^;
    Inc(p);
    end;
  end;
end;
end;

procedure TQJson.Clear;
var
  I: Integer;
begin
if FDataType in [jdtArray, jdtObject] then
  begin
  for I := 0 to Count - 1 do
    FreeJson(FItems[I]);
  FItems.Clear;
  end;
end;

function TQJson.Clone: TQJson;
begin
Result := Copy;
end;

function TQJson.Copy: TQJson;
begin
Result := CreateJson;
Result.Assign(Self);
end;
{$IFDEF UNICODE}

function TQJson.CopyIf(const ATag: Pointer;
  AFilter: TQJsonFilterEventA): TQJson;
  procedure NestCopy(AParentSource, AParentDest: TQJson);
  var
    I: Integer;
    Accept: Boolean;
    AChildSource, AChildDest: TQJson;
  begin
  for I := 0 to AParentSource.Count - 1 do
    begin
    Accept := true;
    AChildSource := AParentSource[I];
    AFilter(Self, AChildSource, Accept, ATag);
    if Accept then
      begin
      AChildDest := AParentDest.Add(AChildSource.FName, AChildSource.DataType);
      if AChildSource.DataType in [jdtArray, jdtObject] then
        begin
        AChildDest.DataType := AChildSource.DataType;
        NestCopy(AChildSource, AChildDest)
        end
      else
        AChildDest.CopyValue(AChildSource);
      end;
    end;
  end;

begin
if Assigned(AFilter) then
  begin
  Result := CreateJson;
  Result.FName := Name;
  if DataType in [jdtObject, jdtArray] then
    begin
    NestCopy(Self, Result);
    end
  else
    Result.CopyValue(Self);
  end
else
  Result := Copy;
end;
{$ENDIF UNICODE}

function TQJson.CopyIf(const ATag: Pointer; AFilter: TQJsonFilterEvent): TQJson;
  procedure NestCopy(AParentSource, AParentDest: TQJson);
  var
    I: Integer;
    Accept: Boolean;
    AChildSource, AChildDest: TQJson;
  begin
  for I := 0 to AParentSource.Count - 1 do
    begin
    Accept := true;
    AChildSource := AParentSource[I];
    AFilter(Self, AChildSource, Accept, ATag);
    if Accept then
      begin
      AChildDest := AParentDest.Add(AChildSource.FName, AChildSource.DataType);
      if AChildSource.DataType in [jdtArray, jdtObject] then
        NestCopy(AChildSource, AChildDest)
      else
        AChildDest.CopyValue(AChildSource);
      end;
    end;
  end;

begin
if Assigned(AFilter) then
  begin
  Result := CreateJson;
  Result.FName := Name;
  if DataType in [jdtObject, jdtArray] then
    begin
    NestCopy(Self, Result);
    end
  else
    Result.CopyValue(Self);
  end
else
  Result := Copy;
end;

procedure TQJson.CopyValue(ASource: TQJson);
var
  l: Integer;
begin
l := Length(ASource.FValue);
DataType := ASource.DataType;
SetLength(FValue, l);
if l > 0 then
  Move(PQCharW(ASource.FValue)^, PQCharW(FValue)^, l shl 1);
end;

constructor TQJson.Create(const AName, AValue: QStringW;
  ADataType: TQJsonDataType);
begin
inherited Create;
FName := AName;
if ADataType <> jdtUnknown then
  DataType := ADataType;
Value := AValue;
end;

function TQJson.CreateJson: TQJson;
begin
if Assigned(OnQJsonCreate) then
  Result := OnQJsonCreate
else
  Result := TQJson.Create;
end;

constructor TQJson.Create;
begin
inherited;
end;

procedure TQJson.Delete(AName: QStringW);
var
  I: Integer;
begin
I := IndexOf(AName);
if I <> -1 then
  Delete(I);
end;
{$IFDEF UNICODE}

procedure TQJson.DeleteIf(const ATag: Pointer; ANest: Boolean;
  AFilter: TQJsonFilterEventA);
  procedure DeleteChildren(AParent: TQJson);
  var
    I: Integer;
    Accept: Boolean;
    AChild: TQJson;
  begin
  I := 0;
  while I < AParent.Count do
    begin
    Accept := true;
    AChild := AParent.Items[I];
    if ANest then
      DeleteChildren(AChild);
    AFilter(Self, AChild, Accept, ATag);
    if Accept then
      AParent.Delete(I)
    else
      Inc(I);
    end;
  end;

begin
if Assigned(AFilter) then
  DeleteChildren(Self)
else
  Clear;
end;
{$ENDIF UNICODE}

procedure TQJson.DeleteIf(const ATag: Pointer; ANest: Boolean;
  AFilter: TQJsonFilterEvent);
  procedure DeleteChildren(AParent: TQJson);
  var
    I: Integer;
    Accept: Boolean;
    AChild: TQJson;
  begin
  I := 0;
  while I < AParent.Count do
    begin
    Accept := true;
    AChild := AParent.Items[I];
    if ANest then
      DeleteChildren(AChild);
    AFilter(Self, AChild, Accept, ATag);
    if Accept then
      AParent.Delete(I)
    else
      Inc(I);
    end;
  end;

begin
if Assigned(AFilter) then
  DeleteChildren(Self)
else
  Clear;
end;

procedure TQJson.Delete(AIndex: Integer);
begin
if FDataType in [jdtArray, jdtObject] then
  begin
  FreeJson(Items[AIndex]);
  FItems.Delete(AIndex);
  end
else
  raise Exception.Create(Format(SNotArrayOrObject, [FName]));
end;

destructor TQJson.Destroy;
begin
if DataType in [jdtArray, jdtObject] then
  begin
  Clear;
  FreeObject(FItems);
  end;
inherited;
end;

function TQJson.Encode(ADoFormat: Boolean; ADoEscape: Boolean;
  AIndent: QStringW): QStringW;
var
  ABuilder: TQStringCatHelperW;
begin
ABuilder := TQStringCatHelperW.Create;
try
  InternalEncode(ABuilder, ADoFormat, ADoEscape, False, AIndent);
  ABuilder.Back(1); // ɾ�����һ������
  Result := ABuilder.Value;
finally
  FreeObject(ABuilder);
end;
end;
{$IFDEF UNICODE}

function TQJson.FindIf(const ATag: Pointer; ANest: Boolean;
  AFilter: TQJsonFilterEventA): TQJson;
  function DoFind(AParent: TQJson): TQJson;
  var
    I: Integer;
    AChild: TQJson;
    Accept: Boolean;
  begin
  Result := nil;
  for I := 0 to AParent.Count - 1 do
    begin
    AChild := AParent[I];
    Accept := true;
    AFilter(Self, AChild, Accept, ATag);
    if Accept then
      Result := AChild
    else if ANest then
      Result := DoFind(AChild);
    if Result <> nil then
      Break;
    end;
  end;

begin
if Assigned(AFilter) then
  Result := DoFind(Self)
else
  Result := nil;
end;
{$ENDIF UNICODE}

function TQJson.FindIf(const ATag: Pointer; ANest: Boolean;
  AFilter: TQJsonFilterEvent): TQJson;
  function DoFind(AParent: TQJson): TQJson;
  var
    I: Integer;
    AChild: TQJson;
    Accept: Boolean;
  begin
  Result := nil;
  for I := 0 to AParent.Count - 1 do
    begin
    AChild := AParent[I];
    Accept := true;
    AFilter(Self, AChild, Accept, ATag);
    if Accept then
      Result := AChild
    else if ANest then
      Result := DoFind(AChild);
    if Result <> nil then
      Break;
    end;
  end;

begin
if Assigned(AFilter) then
  Result := DoFind(Self)
else
  Result := nil;
end;

function TQJson.ForcePath(APath: QStringW): TQJson;
var
  AName: QStringW;
  p, pn, ws: PQCharW;
  AParent: TQJson;
  l: Integer;
  AIndex: Int64;
const
  PathDelimiters: PWideChar = './\';
begin
p := PQCharW(APath);
AParent := Self;
Result := Self;
while p^ <> #0 do
  begin
  AName := DecodeTokenW(p, PathDelimiters, WideChar(0), true);
  if not(AParent.DataType in [jdtObject, jdtArray]) then
    AParent.DataType := jdtObject;
  Result := AParent.ItemByName(AName);
  if not Assigned(Result) then
    begin
    pn := PQCharW(AName);
    l := Length(AName);
    AIndex := -1;
    if (pn[l - 1] = ']') then
      begin
      repeat
        if pn[l] = '[' then
          begin
          ws := pn + l + 1;
          if ParseInt(ws, AIndex) = 0 then
            AIndex := -1;
          Break;
          end
        else
          Dec(l);
      until l = 0;
      if l > 0 then
        begin
        AName := StrDupX(pn, l);
        Result := AParent.ItemByName(AName);
        if Result = nil then
          Result := AParent.Add(AName, jdtArray)
        else if Result.DataType <> jdtArray then
          raise Exception.CreateFmt(SBadJsonArray, [AName]);
        if AIndex >= 0 then
          begin
          while Result.Count <= AIndex do
            Result.Add;
          Result := Result[AIndex];
          end;
        end
      else
        raise Exception.CreateFmt(SBadJsonName, [AName]);
      end
    else
      begin
      if AParent.IsArray then
        Result := AParent.Add.Add(AName)
      else
        Result := AParent.Add(AName);
      end;
    end;
  AParent := Result;
  end;
end;

function TQJson.FormatParseError(ACode: Integer; AMsg: QStringW; ps, p: PQCharW)
  : QStringW;
var
  ACol, ARow: Integer;
  ALine: QStringW;
begin
if ACode <> 0 then
  begin
  p := StrPosW(ps, p, ACol, ARow);
  ALine := DecodeLineW(p, False);
  if Length(ALine) > 1024 then // һ�������1024���ַ�
    begin
    SetLength(ALine, 1024);
    PQCharW(ALine)[1023] := '.';
    PQCharW(ALine)[1022] := '.';
    PQCharW(ALine)[1021] := '.';
    end;
  Result := Format(SJsonParseError, [ARow, ACol, AMsg, ALine]);
  end
else
  SetLength(Result, 0);
end;

procedure TQJson.FreeJson(AJson: TQJson);
begin
if Assigned(OnQJsonFree) then
  OnQJsonFree(AJson)
else
  FreeObject(AJson);
end;
{$IFDEF UNICODE}

procedure TQJson.FromRecord<T>(const ARecord: T);
begin
FromRtti(@ARecord, TypeInfo(T));
end;

procedure TQJson.FromRtti(ASource: Pointer; AType: PTypeInfo);
var
  AValue: TValue;
  procedure AddCollection(AParent: TQJson; ACollection: TCollection);
  var
    J: Integer;
  begin
  for J := 0 to ACollection.Count - 1 do
    AParent.Add.FromRtti(ACollection.Items[J]);
  end;
// ����XE6��System.rtti��TValue��tkSet���ʹ����Bug
  function SetAsOrd(AValue: TValue): Int64;
  var
    ATemp: Integer;
  begin
  AValue.ExtractRawData(@ATemp);
  case GetTypeData(AValue.TypeInfo).OrdType of
    otSByte:
      Result := PShortint(@ATemp)^;
    otUByte:
      Result := PByte(@ATemp)^;
    otSWord:
      Result := PSmallint(@ATemp)^;
    otUWord:
      Result := PWord(@ATemp)^;
    otSLong:
      Result := PInteger(@ATemp)^;
    otULong:
      Result := PCardinal(@ATemp)^
  else
    Result := 0;
  end;
  end;
  procedure AddRecord;
  var
    AContext: TRttiContext;
    AFields: TArray<TRttiField>;
    ARttiType: TRttiType;
    I, J: Integer;
    AObj: TObject;
  begin
  AContext := TRttiContext.Create;
  ARttiType := AContext.GetType(AType);
  AFields := ARttiType.GetFields;
  for J := Low(AFields) to High(AFields) do
    begin
    if AFields[J].FieldType <> nil then
      begin
      // ����Ǵӽṹ�壬���¼���Ա������Ƕ�����ֻ��¼�乫�������ԣ����⴦��TStrings��TCollection
      case AFields[J].FieldType.TypeKind of
        tkInteger:
          Add(AFields[J].Name).AsInteger := AFields[J].GetValue(ASource)
            .AsInteger;
{$IFNDEF NEXTGEN}tkString, tkLString, tkWString,
{$ENDIF !NEXTGEN}tkUString:
          Add(AFields[J].Name).AsString := AFields[J].GetValue(ASource)
            .AsString;
        tkEnumeration:
          begin
          if GetTypeData(AFields[J].FieldType.Handle)
            .BaseType^ = TypeInfo(Boolean) then
            Add(AFields[J].Name).AsBoolean := AFields[J].GetValue(ASource)
              .AsBoolean
          else if JsonRttiEnumAsInt then
            Add(AFields[J].Name).AsInteger := AFields[J].GetValue(ASource)
              .AsOrdinal
          else
            Add(AFields[J].Name).AsString :=
              AFields[J].GetValue(ASource).ToString;
          end;
        tkSet:
          begin
          if JsonRttiEnumAsInt then
            Add(AFields[J].Name).AsInt64 :=
              SetAsOrd(AFields[J].GetValue(ASource))
          else
            Add(AFields[J].Name).AsString :=
              AFields[J].GetValue(ASource).ToString;
          end;
        tkChar, tkWChar:
          Add(AFields[J].Name).AsString := AFields[J].GetValue(ASource)
            .ToString;
        tkFloat:
          begin
          if (AFields[J].FieldType.Handle = TypeInfo(TDateTime)) or
            (AFields[J].FieldType.Handle = TypeInfo(TTime)) or
            (AFields[J].FieldType.Handle = TypeInfo(TDate)) then
            Add(AFields[J].Name).AsDateTime := AFields[J].GetValue(ASource)
              .AsExtended
          else
            Add(AFields[J].Name).AsFloat := AFields[J].GetValue(ASource)
              .AsExtended;
          end;
        tkInt64:
          Add(AFields[J].Name).AsInt64 := AFields[J].GetValue(ASource).AsInt64;
        tkVariant:
          Add(AFields[J].Name).AsVariant := AFields[J].GetValue(ASource)
            .AsVariant;
        tkArray, tkDynArray:
          begin
          with Add(AFields[J].Name, jdtArray) do
            begin
            AValue := AFields[J].GetValue(ASource);
            for I := 0 to AValue.GetArrayLength - 1 do
              Add.FromRtti(AValue.GetArrayElement(I));
            end;
          end;
        tkClass:
          begin
          AValue := AFields[J].GetValue(ASource);
          AObj := AValue.AsObject;
          if (AObj is TStrings) then
            Add(AFields[J].Name).AsString := TStrings(AObj).Text
          else if AObj is TCollection then
            AddCollection(Add(AFields[J].Name, jdtArray), AObj as TCollection)
          else // �������͵Ķ��󲻱���
            Add(AFields[J].Name).FromRtti(AObj, AFields[J].FieldType.Handle);
          end;
        tkRecord:
          begin
          DataType := jdtObject;
          AValue := AFields[J].GetValue(ASource);
          Add(AFields[J].Name)
            .FromRtti(Pointer(IntPtr(ASource) + AFields[J].Offset),
            AFields[J].FieldType.Handle);
          end;
      end;
      end
    else
      raise Exception.CreateFmt(SMissRttiTypeDefine, [AFields[J].Name]);
    end;
  end;

  procedure AddObject;
  var
    APropList: PPropList;
    ACount: Integer;
    J: Integer;
    AObj, AChildObj: TObject;
    AName: String;
  begin
  AObj := ASource;
  if AObj is TStrings then
    AsString := (AObj as TStrings).Text
  else if AObj is TCollection then
    AddCollection(Self, AObj as TCollection)
  else
    begin
    ACount := GetPropList(AType, APropList);
    for J := 0 to ACount - 1 do
      begin
      if not((APropList[J].PropType^.Kind in [tkMethod, tkInterface, tkClassRef,
        tkPointer, tkProcedure]) or IsDefaultPropertyValue(AObj, APropList[J],
        nil)) then
        begin
{$IF RTLVersion>25}
        AName := APropList[J].NameFld.ToString;
{$ELSE}
        AName := String(APropList[J].Name);
{$IFEND}
        case APropList[J].PropType^.Kind of
          tkClass:
            begin
            AChildObj := Pointer(GetOrdProp(AObj, APropList[J]));
            if AChildObj is TStrings then
              Add(AName).AsString := (AChildObj as TStrings).Text
            else if AChildObj is TCollection then
              AddCollection(Add(AName), AChildObj as TCollection)
            else
              Add(AName).FromRtti(AChildObj);
            end;
          tkRecord, tkArray, tkDynArray: // ��¼�����顢��̬��������ϵͳҲ�����棬Ҳû�ṩ����̫�õĽӿ�
            raise Exception.Create(SUnsupportPropertyType);
          tkInteger:
            Add(AName).AsInt64 := GetOrdProp(AObj, APropList[J]);
          tkChar, tkString, tkWChar, tkLString, tkWString, tkUString:
            Add(AName).AsString := GetStrProp(AObj, APropList[J]);
          tkEnumeration:
            begin
            if GetTypeData(APropList[J]^.PropType^)^.BaseType^ = TypeInfo
              (Boolean) then
              Add(AName).AsBoolean := GetOrdProp(AObj, APropList[J]) <> 0
            else if JsonRttiEnumAsInt then
              Add(AName).AsInteger := GetOrdProp(AObj, APropList[J])
            else
              Add(AName).AsString := GetEnumProp(AObj, APropList[J]);
            end;
          tkSet:
            begin
            if JsonRttiEnumAsInt then
              Add(Name).AsInteger := GetOrdProp(AObj, APropList[J])
            else
              Add(AName).AsString := GetSetProp(AObj, APropList[J], true);
            end;
          tkVariant:
            Add(AName).AsVariant := GetPropValue(AObj, APropList[J]);
          tkInt64:
            Add(AName).AsInt64 := GetInt64Prop(AObj, APropList[J]);
        end;
        end;
      end;
    FreeMem(APropList);
    end;
  end;

  procedure AddArray;
  var
    I, c: Integer;
  begin
  DataType := jdtArray;
  Clear;
  TValue.Make(ASource, AType, AValue);
  c := AValue.GetArrayLength;
  for I := 0 to c - 1 do
    Add.FromRtti(AValue.GetArrayElement(I));
  end;

begin
if ASource = nil then
  Exit;
case AType.Kind of
  tkRecord:
    AddRecord;
  tkClass:
    AddObject;
  tkDynArray:
    AddArray;
end;
end;

procedure TQJson.FromRtti(AInstance: TValue);
var
  I, c: Integer;
begin
case AInstance.Kind of
  tkClass:
    FromRtti(AInstance.AsObject, AInstance.TypeInfo);
  tkRecord:
    FromRtti(AInstance.GetReferenceToRawData, AInstance.TypeInfo);
  tkArray, tkDynArray:
    begin
    DataType := jdtArray;
    Clear;
    c := AInstance.GetArrayLength;
    for I := 0 to c - 1 do
      Add.FromRtti(AInstance.GetArrayElement(I));
    end;
  tkInteger:
    AsInt64 := AInstance.AsInt64;
  tkChar, tkString, tkWChar, tkLString, tkWString, tkUString:
    AsString := AInstance.ToString;
  tkEnumeration:
    begin
    if GetTypeData(AInstance.TypeInfo)^.BaseType^ = TypeInfo(Boolean) then
      AsBoolean := AInstance.AsBoolean
    else if JsonRttiEnumAsInt then
      AsInteger := AInstance.AsOrdinal
    else
      AsString := AInstance.ToString;
    end;
  tkSet:
    AsString := AInstance.ToString;
  tkVariant:
    AsVariant := AInstance.AsVariant;
  tkInt64:
    AsInt64 := AInstance.AsInt64;
end;
end;
{$ENDIF UNICODE}

function TQJson.GetAsArray: QStringW;
begin
if DataType = jdtArray then
  Result := Value
else
  raise Exception.Create(Format(SBadConvert, [AsString, 'Array']));
end;

function TQJson.GetAsBoolean: Boolean;
begin
if DataType = jdtBoolean then
  Result := PBoolean(FValue)^
else if DataType = jdtString then
  begin
  if not TryStrToBool(FValue, Result) then
    raise Exception.Create(Format(SBadConvert, [FValue, 'Boolean']));
  end
else if DataType in [jdtFloat, jdtDateTime] then
  Result := not SameValue(AsFloat, 0)
else if DataType = jdtInteger then
  Result := AsInt64 <> 0
else
  raise Exception.Create(Format(SBadConvert, [JsonTypeName[DataType],
    'Boolean']));
end;

function TQJson.GetAsDateTime: TDateTime;
begin
if DataType in [jdtDateTime, jdtFloat] then
  Result := PExtended(FValue)^
else if DataType = jdtString then
  begin
  if not(ParseDateTime(PWideChar(FValue), Result) or
    ParseJsonTime(PWideChar(FValue), Result) or ParseWebTime(PQCharW(FValue),
    Result)) then
    raise Exception.Create(Format(SBadConvert, ['String', 'DateTime']))
  end
else if DataType = jdtInteger then
  Result := AsInt64
else if DataType in [jdtNull, jdtUnknown] then
  Result := 0
else
  raise Exception.Create(Format(SBadConvert, [JsonTypeName[DataType],
    'DateTime']));
end;

function TQJson.GetAsFloat: Extended;
begin
if DataType in [jdtFloat, jdtDateTime] then
  Result := PExtended(FValue)^
else if DataType = jdtBoolean then
  Result := Integer(AsBoolean)
else if DataType = jdtString then
  begin
  if not TryStrToFloat(FValue, Result) then
    raise Exception.Create(Format(SBadConvert, [FValue, 'Numeric']));
  end
else if DataType = jdtInteger then
  Result := AsInt64
else if DataType = jdtNull then
  Result := 0
else
  raise Exception.Create(Format(SBadConvert, [JsonTypeName[DataType],
    'Numeric']))
end;

function TQJson.GetAsInt64: Int64;
begin
if DataType = jdtInteger then
  Result := PInt64(FValue)^
else if DataType in [jdtFloat, jdtDateTime] then
  Result := Trunc(PExtended(FValue)^)
else if DataType = jdtBoolean then
  Result := Integer(AsBoolean)
else if DataType = jdtString then
  Result := Trunc(AsFloat)
else if DataType = jdtNull then
  Result := 0
else
  raise Exception.Create(Format(SBadConvert, [JsonTypeName[DataType],
    'Numeric']))
end;

function TQJson.GetAsInteger: Integer;
begin
Result := GetAsInt64;
end;

function TQJson.GetAsJson: QStringW;
begin
Result := Encode(true, False, '  ');
end;

function TQJson.GetAsObject: QStringW;
begin
if DataType = jdtObject then
  Result := Value
else
  raise Exception.Create(Format(SBadConvert, [AsString, 'Object']));
end;

function TQJson.GetAsString: QStringW;
begin
if DataType in [jdtNull, jdtUnknown] then
  SetLength(Result, 0)
else
  Result := Value;
end;

function TQJson.GetAsVariant: Variant;
var
  I: Integer;
begin
case DataType of
  jdtString:
    Result := AsString;
  jdtInteger:
    Result := AsInt64;
  jdtFloat:
    Result := AsFloat;
  jdtDateTime:
    Result := AsDateTime;
  jdtBoolean:
    Result := AsBoolean;
  jdtArray, jdtObject:
    begin
    Result := VarArrayCreate([0, Count - 1], varVariant);
    for I := 0 to Count - 1 do
      Result[I] := Items[I].AsVariant;
    end
else
  VarClear(Result);
end;
end;

function TQJson.GetCount: Integer;
begin
if DataType in [jdtObject, jdtArray] then
  Result := FItems.Count
else
  Result := 0;
end;

function TQJson.GetEnumerator: TQJsonEnumerator;
begin
Result := TQJsonEnumerator.Create(Self);
end;

function TQJson.GetIsArray: Boolean;
begin
Result := (DataType = jdtArray);
end;

function TQJson.GetIsDateTime: Boolean;
var
  ATime: TDateTime;
begin
Result := (DataType = jdtDateTime);
if not Result then
  begin
  if DataType = jdtString then
    Result := ParseDateTime(PQCharW(FValue), ATime) or
      ParseJsonTime(PQCharW(FValue), ATime) or
      ParseWebTime(PQCharW(FValue), ATime);
  end;
end;

function TQJson.GetIsNull: Boolean;
begin
Result := (DataType = jdtNull);
end;

function TQJson.GetIsNumeric: Boolean;
begin
Result := (DataType in [jdtInteger, jdtFloat]);
end;

function TQJson.GetIsObject: Boolean;
begin
Result := (DataType = jdtObject);
end;

function TQJson.GetIsString: Boolean;
begin
Result := (DataType = jdtString);
end;

function TQJson.GetItemIndex: Integer;
var
  I: Integer;
begin
Result := -1;
if Assigned(Parent) then
  begin
  for I := 0 to Parent.Count - 1 do
    begin
    if Parent.Items[I] = Self then
      begin
      Result := I;
      Break;
      end;
    end;
  end;
end;

function TQJson.GetItems(AIndex: Integer): TQJson;
begin
Result := FItems[AIndex];
end;

function TQJson.GetPath: QStringW;
var
  AParent, AItem: TQJson;
begin
AParent := FParent;
AItem := Self;
SetLength(Result, 0);
repeat
  if Assigned(AParent) and AParent.IsArray then
    Result := '[' + IntToStr(AItem.ItemIndex) + ']' + Result
  else if AItem.IsArray then
    Result := '\' + AItem.FName + Result
  else
    Result := '\' + AItem.FName + Result;
  if AParent <> nil then
    begin
    AItem := AParent;
    AParent := AItem.Parent;
    end;
until AParent = nil;
if Length(Result) > 0 then
  Result := StrDupX(PQCharW(Result) + 1, Length(Result) - 1);
end;

function TQJson.GetValue: QStringW;
  procedure ValueAsDateTime;
  var
    ADate: Integer;
    AValue: Extended;
  begin
  AValue := PExtended(FValue)^;
  ADate := Trunc(AValue);
  if SameValue(ADate, 0) then // DateΪ0����ʱ��
    begin
    if SameValue(AValue, 0) then
      Result := FormatDateTime(JsonDateFormat, AValue)
    else
      Result := FormatDateTime(JsonTimeFormat, AValue);
    end
  else
    begin
    if SameValue(AValue - ADate, 0) then
      Result := FormatDateTime(JsonDateFormat, AValue)
    else
      Result := FormatDateTime(JsonDateTimeFormat, AValue);
    end;
  end;

begin
case DataType of
  jdtNull, jdtUnknown:
    Result := 'null';
  jdtString:
    Result := FValue;
  jdtInteger:
    Result := IntToStr(PInt64(FValue)^);
  jdtFloat:
    Result := FloatToStr(PExtended(FValue)^);
  jdtDateTime:
    ValueAsDateTime;
  jdtBoolean:
    Result := BoolToStr(PBoolean(FValue)^);
  jdtArray, jdtObject:
    Result := Encode(true);
end;
end;

function TQJson.IndexOf(const AName: QStringW): Integer;
var
  I, l: Integer;
  AItem: TQJson;
  AHash: Cardinal;
begin
Result := -1;
l := Length(AName);
if l > 0 then
  AHash := HashOf(PQCharW(AName), l shl 1)
else
  AHash := 0;
for I := 0 to Count - 1 do
  begin
  AItem := Items[I];
  if Length(AItem.FName) = l then
    begin
    if JsonCaseSensitive then
      begin
      if AItem.FNameHash = 0 then
        AItem.FNameHash := HashOf(PQCharW(AItem.FName), l shl 1);
      if AItem.FNameHash = AHash then
        begin
        if AItem.FName = AName then
          begin
          Result := I;
          Break;
          end;
        end;
      end
    else if StartWithW(PQCharW(AItem.FName), PQCharW(AName), true) then
      begin
      Result := I;
      Break;
      end;
    end;
  end;
end;

function TQJson.InternalEncode(ABuilder: TQStringCatHelperW; ADoFormat: Boolean;
  ADoEscape: Boolean; ANullConvert: Boolean; const AIndent: QStringW)
  : TQStringCatHelperW;
  procedure CatValue(const AValue: QStringW);
  var
    ps: PQCharW;
  const
    CharNum1: PWideChar = '1';
    CharNum0: PWideChar = '0';
    Char7: PWideChar = '\b';
    Char9: PWideChar = '\t';
    Char10: PWideChar = '\n';
    Char12: PWideChar = '\f';
    Char13: PWideChar = '\r';
    CharQuoter: PWideChar = '\"';
    CharBackslash: PWideChar = '\\';
    CharCode: PWideChar = '\u00';
    CharEscape: PWideChar = '\u';
  begin
  ps := PQCharW(AValue);
  while ps^ <> #0 do
    begin
    case ps^ of
      #7:
        ABuilder.Cat(Char7, 2);
      #9:
        ABuilder.Cat(Char9, 2);
      #10:
        ABuilder.Cat(Char10, 2);
      #12:
        ABuilder.Cat(Char12, 2);
      #13:
        ABuilder.Cat(Char13, 2);
      '\':
        ABuilder.Cat(CharBackslash, 2);
      '"':
        ABuilder.Cat(CharQuoter, 2);
    else
      begin
      if ps^ < #$1F then
        begin
        ABuilder.Cat(CharCode, 4);
        if ps^ > #$F then
          ABuilder.Cat(CharNum1, 1)
        else
          ABuilder.Cat(CharNum0, 1);
        ABuilder.Cat(HexChar(Ord(ps^) and $0F));
        end
      else if (ps^ <= #$7E) or (not ADoEscape) then // Ӣ���ַ���
        ABuilder.Cat(ps, 1)
      else
        ABuilder.Cat(CharEscape, 2).Cat(HexChar((PWord(ps)^ shr 12) and $0F))
          .Cat(HexChar((PWord(ps)^ shr 8) and $0F))
          .Cat(HexChar((PWord(ps)^ shr 4) and $0F))
          .Cat(HexChar(PWord(ps)^ and $0F));
      end;
    end;
    Inc(ps);
    end;
  end;

  procedure StrictJsonTime(ATime: TDateTime);
  var
    MS: Int64; // ʱ����Ϣ������
  const
    JsonTimeStart: PWideChar = '"/DATE(';
    JsonTimeEnd: PWideChar = ')/"';
  begin
  MS := Trunc(ATime * 86400000);
  ABuilder.Cat(JsonTimeStart, 7);
  ABuilder.Cat(IntToStr(MS));
  ABuilder.Cat(JsonTimeEnd, 3);
  end;

  procedure DoEncode(ANode: TQJson; ALevel: Integer);
  var
    I: Integer;
    ArrayWraped: Boolean;
    AChild: TQJson;
  const
    CharStringStart: PWideChar = '"';
    CharStringEnd: PWideChar = '",';
    CharNameEnd: PWideChar = '":';
    CharArrayStart: PWideChar = '[';
    CharArrayEnd: PWideChar = '],';
    CharObjectStart: PWideChar = '{';
    CharObjectEnd: PWideChar = '},';
    CharNull: PWideChar = 'null,';
    CharFalse: PWideChar = 'false,';
    CharTrue: PWideChar = 'true,';
    CharComma: PWideChar = ',';
  begin
  if (ANode.Parent <> nil) and (ANode.Parent.DataType <> jdtArray) and
    (Length(ANode.FName) > 0) and (ANode <> Self) then
    begin
    if ADoFormat then
      ABuilder.Replicate(AIndent, ALevel);
    ABuilder.Cat(CharStringStart, 1);
    CatValue(ANode.FName);
    ABuilder.Cat(CharNameEnd, 2);
    end;
  case ANode.DataType of
    jdtArray:
      begin
      ABuilder.Cat(CharArrayStart, 1);
      if ANode.Count > 0 then
        begin
        ArrayWraped := False;
        for I := 0 to ANode.Count - 1 do
          begin
          AChild := ANode.Items[I];
          if AChild.DataType in [jdtArray, jdtObject] then
            begin
            if ADoFormat then
              begin
              ABuilder.Cat(SLineBreak); // ���ڶ�������飬����
              ABuilder.Replicate(AIndent, ALevel + 1);
              ArrayWraped := true;
              end;
            end;
          DoEncode(AChild, ALevel + 1);
          end;
        ABuilder.Back(1);
        if ArrayWraped then
          begin
          ABuilder.Cat(SLineBreak);
          ABuilder.Replicate(AIndent, ALevel);
          end;
        end;
      ABuilder.Cat(CharArrayEnd, 2);
      end;
    jdtObject:
      begin
      if ADoFormat then
        begin
        ABuilder.Cat(CharObjectStart, 1);
        ABuilder.Cat(SLineBreak);
        end
      else
        ABuilder.Cat(CharObjectStart, 1);
      if ANode.Count > 0 then
        begin
        for I := 0 to ANode.Count - 1 do
          begin
          AChild := ANode.Items[I];
          if Length(AChild.Name) = 0 then
            raise Exception.CreateFmt(SObjectChildNeedName, [ANode.Name, I]);
          DoEncode(AChild, ALevel + 1);
          if ADoFormat then
            ABuilder.Cat(SLineBreak);
          end;
        if ADoFormat then
          ABuilder.Back(Length(SLineBreak) + 1)
        else
          ABuilder.Back(1);
        end;
      if ADoFormat then
        begin
        ABuilder.Cat(SLineBreak);
        ABuilder.Replicate(AIndent, ALevel);
        end;
      ABuilder.Cat(CharObjectEnd, 2);
      end;
    jdtNull, jdtUnknown:
      if ANullConvert then
        ABuilder.Cat(CharStringStart).Cat(CharStringEnd)
      else
        ABuilder.Cat(CharNull, 5);
    jdtString:
      begin
      ABuilder.Cat(CharStringStart, 1);
      CatValue(ANode.FValue);
      ABuilder.Cat(CharStringEnd, 2);
      end;
    jdtInteger, jdtFloat, jdtBoolean:
      begin
      ABuilder.Cat(ANode.Value);
      ABuilder.Cat(CharComma, 1);
      end;
    jdtDateTime:
      begin
      ABuilder.Cat(CharStringStart, 1);
      if StrictJson then
        StrictJsonTime(ANode.AsDateTime)
      else
        ABuilder.Cat(ANode.Value);
      ABuilder.Cat(CharStringEnd, 1);
      ABuilder.Cat(CharComma, 1);
      end;
  end;
  end;

begin
Result := ABuilder;
DoEncode(Self, 0);
end;

procedure TQJson.InternalRttiFilter(ASender: TQJson; AObject: Pointer;
  APropName: QStringW; APropType: PTypeInfo; var Accept: Boolean;
  ATag: Pointer);
var
  ATagData: PQJsonInternalTagData;
  procedure DoNameFilter;
  var
    ps: PQCharW;
  begin
  if Length(ATagData.AcceptNames) > 0 then
    begin
    Accept := False;
    ps := StrIStrW(PQCharW(ATagData.AcceptNames), PQCharW(APropName));
    if (ps <> nil) and ((ps = PQCharW(ATagData.AcceptNames)) or (ps[-1] = ',')
      or (ps[-1] = ';')) then
      begin
      ps := ps + Length(APropName);
      Accept := (ps^ = ',') or (ps^ = ';') or (ps^ = #0);
      end;
    end
  else if Length(ATagData.IgnoreNames) > 0 then
    begin
    ps := StrIStrW(PQCharW(ATagData.IgnoreNames), PQCharW(APropName));
    Accept := true;
    if (ps <> nil) and ((ps = PQCharW(ATagData.IgnoreNames)) or (ps[-1] = ',')
      or (ps[-1] = ';')) then
      begin
      ps := ps + Length(APropName);
      Accept := not((ps^ = ',') or (ps^ = ';') or (ps^ = #0));
      end;
    end;
  end;

begin
ATagData := PQJsonInternalTagData(ATag);
if ATagData.TagType = ttNameFilter then
  begin
  DoNameFilter;
  Exit;
  end;
{$IFDEF UNICODE}
if ATagData.TagType = ttAnonEvent then
  begin
  ATagData.OnEvent(ASender, AObject, APropName, APropType, Accept,
    ATagData.Tag);
  end;
{$ENDIF UNICODE}
end;

function TQJson.IsChildOf(AParent: TQJson): Boolean;
begin
if Assigned(AParent) then
  begin
  if AParent = FParent then
    Result := true
  else
    Result := FParent.IsChildOf(AParent);
  end
else
  Result := False;
end;

function TQJson.IsParentOf(AChild: TQJson): Boolean;
begin
if Assigned(AChild) then
  Result := AChild.IsChildOf(Self)
else
  Result := False;
end;

function TQJson.ItemByName(AName: QStringW): TQJson;
var
  AChild: TQJson;
  I: Integer;
  ASelfName: String;
  function ArrayName: String;
  var
    ANamedItem: TQJson;
    AParentIndexes: String;
  begin
  ANamedItem := Self;
  while ANamedItem.Parent <> nil do
    begin
    if ANamedItem.Parent.IsArray then
      begin
      AParentIndexes := AParentIndexes + '[' +
        IntToStr(ANamedItem.ItemIndex) + ']';
      ANamedItem := ANamedItem.Parent;
      end
    else
      Break;
    end;
  Result := ANamedItem.Name + AParentIndexes;
  end;

begin
Result := nil;
if DataType = jdtObject then
  begin
  I := IndexOf(AName);
  if I <> -1 then
    Result := Items[I];
  end
else if DataType = jdtArray then
  begin
  ASelfName := ArrayName;
  for I := 0 to Count - 1 do
    begin
    AChild := Items[I];
    if ASelfName + '[' + IntToStr(I) + ']' = AName then
      begin
      Result := AChild;
      Exit;
      end
    else if AChild.IsArray then
      begin
      Result := AChild.ItemByName(AName);
      if Assigned(Result) then
        Exit;
      end
    else
    end;
  end;
end;

function TQJson.ItemByName(const AName: QStringW; AList: TQJsonItemList;
  ANest: Boolean): Integer;
var
  ANode: TQJson;
  function InternalFind(AParent: TQJson): Integer;
  var
    I: Integer;
  begin
  Result := 0;
  for I := 0 to AParent.Count - 1 do
    begin
    ANode := AParent.Items[I];
    if ANode.Name = AName then
      begin
      AList.Add(ANode);
      Inc(Result);
      end;
    if ANest then
      Inc(Result, InternalFind(ANode));
    end;
  end;

begin
Result := InternalFind(Self);
end;

function TQJson.ItemByPath(APath: QStringW): TQJson;
var
  AParent: TQJson;
  AName: QStringW;
  p, pn, ws: PQCharW;
  l: Integer;
  AIndex: Int64;
const
  PathDelimiters: PWideChar = './\';
begin
AParent := Self;
p := PQCharW(APath);
Result := nil;
while Assigned(AParent) and (p^ <> #0) do
  begin
  AName := DecodeTokenW(p, PathDelimiters, WideChar(0), False);
  if Length(AName) > 0 then
    begin
    // ���ҵ������飿
    l := Length(AName);
    AIndex := -1;
    pn := PQCharW(AName);
    if (pn[l - 1] = ']') then
      begin
      repeat
        if pn[l] = '[' then
          begin
          ws := pn + l + 1;
          ParseInt(ws, AIndex);
          Break;
          end
        else
          Dec(l);
      until l = 0;
      if l > 0 then
        begin
        AName := StrDupX(pn, l);
        Result := AParent.ItemByName(AName);
        if Result <> nil then
          begin
          if Result.DataType <> jdtArray then
            Result := nil
          else if (AIndex >= 0) and (AIndex < Result.Count) then
            Result := Result[AIndex];
          end;
        end;
      end
    else
      Result := AParent.ItemByName(AName);
    if Assigned(Result) then
      AParent := Result
    else
      begin
      Exit;
      end;
    end;
  if CharInW(p, PathDelimiters) then
    Inc(p);
  // ������..��//\\��·��������
  end;
if p^ <> #0 then
  Result := nil;
end;

function TQJson.ItemByRegex(const ARegex: QStringW; AList: TQJsonItemList;
  ANest: Boolean): Integer;
var
  ANode: TQJson;
  APcre: TPerlRegEx;
  function InternalFind(AParent: TQJson): Integer;
  var
    I: Integer;
  begin
  Result := 0;
  for I := 0 to AParent.Count - 1 do
    begin
    ANode := AParent.Items[I];
    APcre.Subject := ANode.Name;
    if APcre.Match then
      begin
      AList.Add(ANode);
      Inc(Result);
      end;
    if ANest then
      Inc(Result, InternalFind(ANode));
    end;
  end;

begin
APcre := TPerlRegEx.Create;
try
  APcre.RegEx := ARegex;
  APcre.Compile;
  Result := InternalFind(Self);
finally
  FreeObject(APcre);
end;
end;

procedure TQJson.LoadFromFile(AFileName: String; AEncoding: TTextEncoding);
var
  AStream: TFileStream;
begin
AStream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
try
  LoadFromStream(AStream, AEncoding);
finally
  FreeObject(AStream);
end;
end;

procedure TQJson.LoadFromStream(AStream: TStream; AEncoding: TTextEncoding);
var
  s: QStringW;
begin
s := LoadTextW(AStream, AEncoding);
if Length(s) > 2 then
  Parse(PQCharW(s), Length(s))
else
  raise Exception.Create(SBadJson);
end;

procedure TQJson.Parse(p: PWideChar; l: Integer);
  procedure ParseCopy;
  var
    s: QStringW;
  begin
  s := StrDupW(p, 0, l);
  p := PQCharW(s);
  ParseObject(p);
  end;

begin
if DataType in [jdtObject, jdtArray] then
  Clear;
if (l > 0) and (p[l] <> #0) then
  ParseCopy
else
  ParseObject(p);
end;

procedure TQJson.Parse(const s: QStringW);
begin
Parse(PQCharW(s), Length(s));
end;

procedure TQJson.ParseBlock(AStream: TStream; AEncoding: TTextEncoding);
var
  AMS: TMemoryStream;
  procedure ParseUCS2;
  var
    c: QCharW;
    ABlockCount: Integer;
  begin
  ABlockCount := 0;
  repeat
    if ABlockCount = 0 then
      begin
      repeat
        AStream.ReadBuffer(c, SizeOf(QCharW));
        AMS.WriteBuffer(c, SizeOf(QCharW));
      until c = '{';
      Inc(ABlockCount);
      end;
    AStream.ReadBuffer(c, SizeOf(QCharW));
    if c = '{' then
      Inc(ABlockCount)
    else if c = '}' then
      Dec(ABlockCount);
    AMS.WriteBuffer(c, SizeOf(QCharW));
  until ABlockCount = 0;
  c := #0;
  AMS.Write(c, SizeOf(QCharW));
  Parse(AMS.Memory, AMS.Size - 1);
  end;

  procedure ParseUCS2BE;
  var
    c: Word;
    ABlockCount: Integer;
    p: PQCharW;
  begin
  ABlockCount := 0;
  repeat
    if ABlockCount = 0 then
      begin
      repeat
        AStream.ReadBuffer(c, SizeOf(Word));
        c := (c shr 8) or ((c shl 8) and $FF00);
        AMS.WriteBuffer(c, SizeOf(Word));
      until c = $7B; // #$7B={
      Inc(ABlockCount);
      end;
    AStream.ReadBuffer(c, SizeOf(Word));
    c := (c shr 8) or ((c shl 8) and $FF00);
    if c = $7B then
      Inc(ABlockCount)
    else if c = $7D then // #$7D=}
      Dec(ABlockCount);
    AMS.WriteBuffer(c, SizeOf(QCharW));
  until ABlockCount = 0;
  c := 0;
  AMS.Write(c, SizeOf(QCharW));
  p := AMS.Memory;
  ParseObject(p);
  end;

  procedure ParseByByte;
  var
    c: Byte;
    ABlockCount: Integer;
  begin
  ABlockCount := 0;
  repeat
    if ABlockCount = 0 then
      begin
      repeat
        AStream.ReadBuffer(c, SizeOf(Byte));
        AMS.WriteBuffer(c, SizeOf(Byte));
      until c = $7B; // #$7B={
      Inc(ABlockCount);
      end;
    AStream.ReadBuffer(c, SizeOf(Byte));
    if c = $7B then
      Inc(ABlockCount)
    else if c = $7D then // #$7D=}
      Dec(ABlockCount);
    AMS.WriteBuffer(c, SizeOf(Byte));
  until ABlockCount = 0;
  end;

  procedure ParseUtf8;
  var
    s: QStringW;
    p: PQCharW;
  begin
  ParseByByte;
  s := qstring.Utf8Decode(AMS.Memory, AMS.Size);
  p := PQCharW(s);
  ParseObject(p);
  end;

  procedure ParseAnsi;
  var
    s: QStringW;
  begin
  ParseByByte;
  s := qstring.AnsiDecode(AMS.Memory, AMS.Size);
  Parse(PQCharW(s));
  end;

begin
AMS := TMemoryStream.Create;
try
  if AEncoding = teAnsi then
    ParseAnsi
  else if AEncoding = teUtf8 then
    ParseUtf8
  else if AEncoding = teUnicode16LE then
    ParseUCS2
  else if AEncoding = teUnicode16BE then
    ParseUCS2BE
  else
    raise Exception.Create(SBadJsonEncoding);
finally
  AMS.Free;
end;
end;

function TQJson.ParseJsonPair(ABuilder: TQStringCatHelperW;
  var p: PQCharW): Integer;
const
  SpaceWithSemicolon: PWideChar = ': '#9#10#13#$3000;
  CommaWithSpace: PWideChar = ', '#9#10#13#$3000;
  JsonEndChars: PWideChar = ',}]';
  JsonComplexEnd: PWideChar = '}]';
var
  AChild: TQJson;
  AObjEnd: QCharW;
begin
// ����ע�ͣ���ֱ������
Result := 0;
while p^ = '/' do
  begin
  if StrictJson then
    begin
    Result := EParse_CommentNotSupport;
    Exit;
    end;
  if p[1] = '/' then
    begin
    SkipUntilW(p, [WideChar(10)]);
    SkipSpaceW(p);
    end
  else if p[1] = '*' then
    begin
    Inc(p, 2);
    while p^ <> #0 do
      begin
      if (p[0] = '*') and (p[1] = '/') then
        begin
        Inc(p, 2);
        SkipSpaceW(p);
        Break;
        end
      else
        Inc(p);
      end;
    end
  else
    begin
    Result := EParse_UnknownToken;
    Exit;
    end;
  end;
// ����ֵ
if (p^ = '{') or (p^ = '[') then // ����
  begin
  try
    if p^ = '{' then
      begin
      DataType := jdtObject;
      AObjEnd := '}';
      end
    else
      begin
      DataType := jdtArray;
      AObjEnd := ']';
      end;
    Inc(p);
    SkipSpaceW(p);
    while (p^ <> #0) and (p^ <> AObjEnd) do
      begin
      AChild := Add;
      Result := AChild.ParseJsonPair(ABuilder, p);
      if Result <> 0 then
        Exit;
      if p^ = ',' then
        begin
        Inc(p);
        SkipSpaceW(p);
        end;
      end;
    if p^ <> AObjEnd then
      begin
      Result := EParse_BadJson;
      Exit;
      end
    else
      begin
      Inc(p);
      SkipSpaceW(p);
      end;
  except
    Clear;
    raise;
  end;
  end
else if Parent <> nil then
  begin
  if (Parent.DataType = jdtObject) and (Length(FName) = 0) then
    begin
    Result := ParseName(ABuilder, p);
    if Result <> 0 then
      Exit;
    end;
  Result := TryParseValue(ABuilder, p);
  if Result = 0 then
    begin
    if not CharInW(p, JsonEndChars) then
      Result := EParse_EndCharNeeded;
    end;
  end
else
  Result := EParse_BadJson;
end;

function TQJson.ParseJsonTime(p: PQCharW; var ATime: TDateTime): Boolean;
var
  MS, TimeZone: Int64;
begin
// Javascript���ڸ�ʽΪ/DATE(��1970.1.1�����ڵĺ�����+ʱ��)/
Result := False;
if not StartWithW(p, '/DATE', False) then
  Exit;
Inc(p, 5);
SkipSpaceW(p);
if p^ <> '(' then
  Exit;
Inc(p);
SkipSpaceW(p);
if ParseInt(p, MS) = 0 then
  Exit;
SkipSpaceW(p);
if (p^ = '+') or (p^ = '-') then
  begin
  if ParseInt(p, TimeZone) = 0 then
    Exit;
  SkipSpaceW(p);
  end
else
  TimeZone := 0;
if p^ = ')' then
  begin
  ATime := (MS div 86400000) + ((MS mod 86400000) / 86400000.0);
  if TimeZone <> 0 then
    ATime := IncHour(ATime, -TimeZone);
  Inc(p);
  SkipSpaceW(p);
  Result := true
  end;
end;

function TQJson.ParseName(ABuilder: TQStringCatHelperW; var p: PQCharW)
  : Integer;
begin
if StrictJson and (p^ <> '"') then
  begin
  Result := EParse_BadNameStart;
  Exit;
  end;
BuildJsonString(ABuilder, p);
if p^ <> ':' then
  begin
  Result := EParse_BadNameEnd;
  Exit;
  end;
if ABuilder.Position = 0 then
  begin
  Result := EParse_NameNotFound;
  Exit;
  end;
FName := ABuilder.Value;
// �����������
Inc(p);
SkipSpaceW(p);
Result := 0;
end;

procedure TQJson.ParseObject(var p: PQCharW);
var
  ABuilder: TQStringCatHelperW;
  ps: PQCharW;
  AErrorCode: Integer;
begin
ABuilder := TQStringCatHelperW.Create;
try
  ps := p;
  try
    SkipSpaceW(p);
    AErrorCode := ParseJsonPair(ABuilder, p);
    if AErrorCode <> 0 then
      RaiseParseException(AErrorCode, ps, p);
  except
    on E: Exception do
      begin
      if E is EJsonError then
        raise
      else
        raise Exception.Create(Self.FormatParseError(EParse_Unknown,
          E.Message, ps, p));
      end;
  end;
finally
  FreeObject(ABuilder);
end;
end;

procedure TQJson.ParseValue(ABuilder: TQStringCatHelperW; var p: PQCharW);
var
  ps: PQCharW;
begin
ps := p;
RaiseParseException(TryParseValue(ABuilder, p), ps, p);
end;

procedure TQJson.RaiseParseException(ACode: Integer; ps, p: PQCharW);
begin
if ACode <> 0 then
  begin
  case ACode of
    EParse_BadStringStart:
      raise EJsonError.Create(FormatParseError(ACode, SBadStringStart, ps, p));
    EParse_BadJson:
      raise EJsonError.Create(FormatParseError(ACode, SBadJson, ps, p));
    EParse_CommentNotSupport:
      raise EJsonError.Create(FormatParseError(ACode,
        SCommentNotSupport, ps, p));
    EParse_UnknownToken:
      raise EJsonError.Create(FormatParseError(ACode,
        SCommentNotSupport, ps, p));
    EParse_EndCharNeeded:
      raise EJsonError.Create(FormatParseError(ACode, SEndCharNeeded, ps, p));
    EParse_BadNameStart:
      raise EJsonError.Create(FormatParseError(ACode, SBadNameStart, ps, p));
    EParse_BadNameEnd:
      raise EJsonError.Create(FormatParseError(ACode, SBadNameEnd, ps, p));
    EParse_NameNotFound:
      raise EJsonError.Create(FormatParseError(ACode, SNameNotFound, ps, p))
  else
    raise EJsonError.Create(FormatParseError(ACode, SUnknownError, ps, p));
  end;
  end;
end;

procedure TQJson.Replace(AIndex: Integer; ANewItem: TQJson);
begin
FreeObject(Items[AIndex]);
FItems[AIndex] := ANewItem;
end;

procedure TQJson.ResetNull;
begin
DataType := jdtNull;
end;

procedure TQJson.SaveToFile(AFileName: String; AEncoding: TTextEncoding;
  AWriteBOM: Boolean);
var
  AStream: TMemoryStream;
begin
AStream := TMemoryStream.Create;
try
  SaveToStream(AStream, AEncoding, AWriteBOM);
  AStream.SaveToFile(AFileName);
finally
  FreeObject(AStream);
end;
end;

procedure TQJson.SaveToStream(AStream: TStream; AEncoding: TTextEncoding;
  AWriteBOM: Boolean);
begin
if AEncoding = teUtf8 then
  SaveTextU(AStream, qstring.Utf8Encode(Value), AWriteBOM)
else if AEncoding = teAnsi then
  SaveTextA(AStream, qstring.AnsiEncode(Value))
else if AEncoding = teUnicode16LE then
  SaveTextW(AStream, Value, AWriteBOM)
else
  SaveTextWBE(AStream, Value, AWriteBOM);
end;

procedure TQJson.SetAsArray(const Value: QStringW);
var
  p: PQCharW;
begin
DataType := jdtArray;
Clear;
p := PQCharW(Value);
ParseObject(p);
end;

procedure TQJson.SetAsBoolean(const Value: Boolean);
begin
DataType := jdtBoolean;
PBoolean(FValue)^ := Value;
end;

procedure TQJson.SetAsDateTime(const Value: TDateTime);
begin
DataType := jdtDateTime;
PExtended(FValue)^ := Value;
end;

procedure TQJson.SetAsFloat(const Value: Extended);
begin
if IsNan(Value) or IsInfinite(Value) then
  raise Exception.Create(SSupportFloat);
DataType := jdtFloat;
PExtended(FValue)^ := Value;
end;

procedure TQJson.SetAsInt64(const Value: Int64);
begin
DataType := jdtInteger;
PInt64(FValue)^ := Value;
end;

procedure TQJson.SetAsInteger(const Value: Integer);
begin
SetAsInt64(Value);
end;

procedure TQJson.SetAsJson(const Value: QStringW);
var
  ABuilder: TQStringCatHelperW;
  p: PQCharW;
begin
ABuilder := TQStringCatHelperW.Create;
try
  try
    if DataType in [jdtArray, jdtObject] then
      Clear;
    p := PQCharW(Value);
    ParseValue(ABuilder, p);
  except
    AsString := Value;
  end;
finally
  FreeObject(ABuilder);
end;
end;

procedure TQJson.SetAsObject(const Value: QStringW);
begin
Parse(PQCharW(Value), Length(Value));
end;

procedure TQJson.SetAsString(const Value: QStringW);
begin
DataType := jdtString;
FValue := Value;
end;

procedure TQJson.SetAsVariant(const Value: Variant);
var
  I: Integer;
begin
if VarIsArray(Value) then
  begin
  ArrayNeeded(jdtArray);
  Clear;
  for I := VarArrayLowBound(Value, VarArrayDimCount(Value))
    to VarArrayHighBound(Value, VarArrayDimCount(Value)) do
    Add.AsVariant := Value[I];
  end
else
  begin
  case VarType(Value) of
    varEmpty, varNull, varUnknown:
      ResetNull;
    varSmallInt, varInteger, varByte, varShortInt, varWord,
      varLongWord, varInt64:
      AsInt64 := Value;
    varSingle, varDouble, varCurrency:
      AsFloat := Value;
    varDate:
      AsDateTime := Value;
    varOleStr, varString{$IFDEF UNICODE}, varUString{$ENDIF}:
      AsString := Value;
    varBoolean:
      AsBoolean := Value;
{$IF RtlVersion>=26}
    varUInt64:
      AsInt64 := Value;
    varRecord:
      FromRtti(PVarRecord(@Value).RecInfo, PVarRecord(@Value).PRecord);
{$IFEND >=XE5}
  end;
  end;
end;

procedure TQJson.SetDataType(const Value: TQJsonDataType);
begin
if FDataType <> Value then
  begin
  if DataType in [jdtArray, jdtObject] then
    begin
    Clear;
    if not(Value in [jdtArray, jdtObject]) then
      begin
      FreeObject(FItems);
      end;
    end;
  case Value of
    jdtNull, jdtUnknown, jdtString:
      SetLength(FValue, 0);
    jdtInteger:
      begin
      SetLength(FValue, SizeOf(Int64) shr 1);
      PInt64(FValue)^ := 0;
      end;
    jdtFloat, jdtDateTime:
      begin
      SetLength(FValue, SizeOf(Extended) shr 1);
      PDouble(FValue)^ := 0;
      end;
    jdtBoolean:
      begin
      SetLength(FValue, 1);
      PBoolean(FValue)^ := False;
      end;
    jdtArray, jdtObject:
      if not(FDataType in [jdtArray, jdtObject]) then
        ArrayNeeded(Value);
  end;
  FDataType := Value;
  end;
end;

procedure TQJson.SetValue(const Value: QStringW);
var
  p: PQCharW;
  procedure ParseNum;
  var
    ANum: Extended;
  begin
  if ParseNumeric(p, ANum) then
    begin
    if SameValue(ANum, Trunc(ANum)) then
      AsInt64 := Trunc(ANum)
    else
      AsFloat := ANum;
    end
  else
    raise Exception.Create(Format(SBadNumeric, [Value]));
  end;
  procedure SetDateTime;
  var
    ATime: TDateTime;
  begin
  if ParseDateTime(PQCharW(Value), ATime) then
    AsDateTime := ATime
  else if ParseJsonTime(PQCharW(Value), ATime) then
    AsDateTime := ATime
  else
    raise Exception.Create(SBadJsonTime);
  end;
  procedure DetectValue;
  var
    ABuilder: TQStringCatHelperW;
    p: PQCharW;
  begin
  ABuilder := TQStringCatHelperW.Create;
  try
    p := PQCharW(Value);
    ParseValue(ABuilder, p);
  except
    AsString := Value;
  end;
  FreeObject(ABuilder);
  end;

begin
if DataType = jdtString then
  FValue := Value
else if DataType = jdtBoolean then
  AsBoolean := StrToBool(Value)
else
  begin
  p := PQCharW(Value);
  if DataType in [jdtInteger, jdtFloat] then
    ParseNum
  else if DataType = jdtDateTime then
    SetDateTime
  else if DataType in [jdtArray, jdtObject] then
    begin
    Clear;
    ParseObject(p);
    end
  else // jdtUnknown
    DetectValue;
  end;
end;

{$IFDEF UNICODE}

function TQJson.Invoke(AInstance: TValue): TValue;
var
  AMethods: TArray<TRttiMethod>;
  AParams: TArray<TRttiParameter>;
  AMethod: TRttiMethod;
  AType: TRttiType;
  AContext: TRttiContext;
  AParamValues: array of TValue;
  I, c: Integer;
  AParamItem: TQJson;
begin
AContext := TRttiContext.Create;
Result := TValue.Empty;
if AInstance.IsObject then
  AType := AContext.GetType(AInstance.AsObject.ClassInfo)
else if AInstance.IsClass then
  AType := AContext.GetType(AInstance.AsClass)
else if AInstance.Kind = tkRecord then
  AType := AContext.GetType(AInstance.TypeInfo)
else
  AType := AContext.GetType(AInstance.TypeInfo);
AMethods := AType.GetMethods(Name);
c := Count;
for AMethod in AMethods do
  begin
  AParams := AMethod.GetParameters;
  if Length(AParams) = c then
    begin
    SetLength(AParamValues, c);
    for I := 0 to c - 1 do
      begin
      AParamItem := ItemByName(AParams[I].Name);
      if AParamItem <> nil then
        AParamValues[I] := AParamItem.ToRttiValue
      else
        raise Exception.CreateFmt(SParamMissed, [AParams[I].Name]);
      end;
    Result := AMethod.Invoke(AInstance, AParamValues);
    Exit;
    end;
  end;
raise Exception.CreateFmt(SMethodMissed, [Name]);
end;

procedure TQJson.ToRecord<T>(var ARecord: T);
begin
ToRtti(@ARecord, TypeInfo(T));
end;

procedure TQJson.ToRtti(AInstance: TValue);
begin
if AInstance.IsEmpty then
  Exit;
if AInstance.Kind = tkRecord then
  ToRtti(AInstance.GetReferenceToRawData, AInstance.TypeInfo)
else if AInstance.Kind = tkClass then
  ToRtti(AInstance.AsObject, AInstance.TypeInfo)
end;

procedure TQJson.ToRtti(ADest: Pointer; AType: PTypeInfo);

  procedure LoadCollection(AJson: TQJson; ACollection: TCollection);
  var
    I: Integer;
  begin
  for I := 0 to AJson.Count - 1 do
    AJson.ToRtti(ACollection.Add);
  end;
  procedure ToRecord;
  var
    AContext: TRttiContext;
    AFields: TArray<TRttiField>;
    ARttiType: TRttiType;
    ABaseAddr: Pointer;
    J: Integer;
    AChild: TQJson;
    AObj: TObject;
  begin
  AContext := TRttiContext.Create;
  ARttiType := AContext.GetType(AType);
  ABaseAddr := ADest;
  AFields := ARttiType.GetFields;
  for J := Low(AFields) to High(AFields) do
    begin
    if AFields[J].FieldType <> nil then
      begin
      AChild := ItemByName(AFields[J].Name);
      if AChild <> nil then
        begin
        case AFields[J].FieldType.TypeKind of
          tkInteger:
            AFields[J].SetValue(ABaseAddr, AChild.AsInteger);
{$IFNDEF NEXTGEN}
          tkString:
            PShortString(IntPtr(ABaseAddr) + AFields[J].Offset)^ :=
              ShortString(AChild.AsString);
{$ENDIF !NEXTGEN}
          tkUString{$IFNDEF NEXTGEN}, tkLString, tkWString{$ENDIF !NEXTGEN}:
            AFields[J].SetValue(ABaseAddr, AChild.AsString);
          tkEnumeration:
            begin
            if GetTypeData(AFields[J].FieldType.Handle)^.BaseType^ = TypeInfo
              (Boolean) then
              AFields[J].SetValue(ABaseAddr, AChild.AsBoolean)
            else
              begin
              case GetTypeData(AFields[J].FieldType.Handle).OrdType of
                otSByte:
                  begin
                  if AChild.DataType = jdtInteger then
                    PShortint(IntPtr(ABaseAddr) + AFields[J].Offset)^ :=
                      AChild.AsInteger
                  else
                    PShortint(IntPtr(ABaseAddr) + AFields[J].Offset)^ :=
                      GetEnumValue(AFields[J].FieldType.Handle,
                      AChild.AsString);
                  end;
                otUByte:
                  begin
                  if AChild.DataType = jdtInteger then
                    PByte(IntPtr(ABaseAddr) + AFields[J].Offset)^ :=
                      AChild.AsInteger
                  else
                    PByte(IntPtr(ABaseAddr) + AFields[J].Offset)^ :=
                      GetEnumValue(AFields[J].FieldType.Handle,
                      AChild.AsString);
                  end;
                otSWord:
                  begin
                  if AChild.DataType = jdtInteger then
                    PSmallint(IntPtr(ABaseAddr) + AFields[J].Offset)^ :=
                      AChild.AsInteger
                  else
                    PSmallint(IntPtr(ABaseAddr) + AFields[J].Offset)^ :=
                      GetEnumValue(AFields[J].FieldType.Handle,
                      AChild.AsString);
                  end;
                otUWord:
                  begin
                  if AChild.DataType = jdtInteger then
                    PWord(IntPtr(ABaseAddr) + AFields[J].Offset)^ :=
                      AChild.AsInteger
                  else
                    PWord(IntPtr(ABaseAddr) + AFields[J].Offset)^ :=
                      GetEnumValue(AFields[J].FieldType.Handle,
                      AChild.AsString);
                  end;
                otSLong:
                  begin
                  if AChild.DataType = jdtInteger then
                    PInteger(IntPtr(ABaseAddr) + AFields[J].Offset)^ :=
                      AChild.AsInteger
                  else
                    PInteger(IntPtr(ABaseAddr) + AFields[J].Offset)^ :=
                      GetEnumValue(AFields[J].FieldType.Handle,
                      AChild.AsString);
                  end;
                otULong:
                  begin
                  if AChild.DataType = jdtInteger then
                    PCardinal(IntPtr(ABaseAddr) + AFields[J].Offset)^ :=
                      AChild.AsInteger
                  else
                    PCardinal(IntPtr(ABaseAddr) + AFields[J].Offset)^ :=
                      GetEnumValue(AFields[J].FieldType.Handle,
                      AChild.AsString);
                  end;
              end;
              end;
            end;
          tkSet:
            begin
            case GetTypeData(AFields[J].FieldType.Handle).OrdType of
              otSByte:
                begin
                if AChild.DataType = jdtInteger then
                  PShortint(IntPtr(ABaseAddr) + AFields[J].Offset)^ :=
                    AChild.AsInteger
                else
                  PShortint(IntPtr(ABaseAddr) + AFields[J].Offset)^ :=
                    StringToSet(AFields[J].FieldType.Handle, AChild.AsString);
                end;
              otUByte:
                begin
                if AChild.DataType = jdtInteger then
                  PByte(IntPtr(ABaseAddr) + AFields[J].Offset)^ :=
                    AChild.AsInteger
                else
                  PByte(IntPtr(ABaseAddr) + AFields[J].Offset)^ :=
                    StringToSet(AFields[J].FieldType.Handle, AChild.AsString);
                end;
              otSWord:
                begin
                if AChild.DataType = jdtInteger then
                  PSmallint(IntPtr(ABaseAddr) + AFields[J].Offset)^ :=
                    AChild.AsInteger
                else
                  PSmallint(IntPtr(ABaseAddr) + AFields[J].Offset)^ :=
                    StringToSet(AFields[J].FieldType.Handle, AChild.AsString);
                end;
              otUWord:
                begin
                if AChild.DataType = jdtInteger then
                  PWord(IntPtr(ABaseAddr) + AFields[J].Offset)^ :=
                    AChild.AsInteger
                else
                  PWord(IntPtr(ABaseAddr) + AFields[J].Offset)^ :=
                    StringToSet(AFields[J].FieldType.Handle, AChild.AsString);
                end;
              otSLong:
                begin
                if AChild.DataType = jdtInteger then
                  PInteger(IntPtr(ABaseAddr) + AFields[J].Offset)^ :=
                    AChild.AsInteger
                else
                  PInteger(IntPtr(ABaseAddr) + AFields[J].Offset)^ :=
                    StringToSet(AFields[J].FieldType.Handle, AChild.AsString);
                end;
              otULong:
                begin
                if AChild.DataType = jdtInteger then
                  PCardinal(IntPtr(ABaseAddr) + AFields[J].Offset)^ :=
                    AChild.AsInteger
                else
                  PCardinal(IntPtr(ABaseAddr) + AFields[J].Offset)^ :=
                    StringToSet(AFields[J].FieldType.Handle, AChild.AsString);
                end;
            end;
            end;
          tkChar, tkWChar:
            AFields[J].SetValue(ABaseAddr, AChild.AsString);
          tkFloat:
            if (AFields[J].FieldType.Handle = TypeInfo(TDateTime)) or
              (AFields[J].FieldType.Handle = TypeInfo(TTime)) or
              (AFields[J].FieldType.Handle = TypeInfo(TDate)) then
              begin
              if AChild.IsDateTime then
                AFields[J].SetValue(ABaseAddr, AChild.AsDateTime)
              else if AChild.DataType in [jdtNull, jdtUnknown] then
                AFields[J].SetValue(ABaseAddr, 0)
              else
                raise Exception.CreateFmt(SBadConvert,
                  [AChild.AsString, JsonTypeName[AChild.DataType]]);
              end
            else
              AFields[J].SetValue(ABaseAddr, AChild.AsFloat);
          tkInt64:
            AFields[J].SetValue(ABaseAddr, AChild.AsInt64);
          tkVariant:
            PVariant(IntPtr(ABaseAddr) + AFields[J].Offset)^ :=
              AChild.AsVariant;
          tkArray, tkDynArray:
            AChild.ToRtti(Pointer(IntPtr(ABaseAddr) + AFields[J].Offset),
              AFields[J].FieldType.Handle);
          tkClass:
            begin
            AObj := AFields[J].GetValue(ABaseAddr).AsObject;
            if AObj is TStrings then
              (AObj as TStrings).Text := AChild.AsString
            else if AObj is TCollection then
              LoadCollection(AChild, AObj as TCollection)
            else
              AChild.ToRtti(AObj);
            end;
          tkRecord:
            AChild.ToRtti(Pointer(IntPtr(ABaseAddr) + AFields[J].Offset),
              AFields[J].FieldType.Handle);
        end;
        end;
      end;
    end;
  end;

  procedure ToObject;
  var
    AProp: PPropInfo;
    ACount: Integer;
    J: Integer;
    AObj, AChildObj: TObject;
    AChild: TQJson;
  begin
  AObj := ADest;
  ACount := Count;
  for J := 0 to ACount - 1 do
    begin
    AChild := Items[J];
    AProp := GetPropInfo(AObj, AChild.Name);
    if AProp <> nil then
      begin
      case AProp.PropType^.Kind of
        tkClass:
          begin
          AChildObj := Pointer(GetOrdProp(AObj, AProp));
          if AChildObj is TStrings then
            (AChildObj as TStrings).Text := AChild.AsString
          else if AChildObj is TCollection then
            LoadCollection(AChild, AChildObj as TCollection)
          else
            AChild.ToRtti(AChildObj);
          end;
        tkRecord, tkArray, tkDynArray: // tkArray,tkDynArray���͵�����û����,tkRecord����
          begin
          AChild.ToRtti(Pointer(GetOrdProp(AObj, AProp)), AProp.PropType^);
          end;
        tkInteger:
          SetOrdProp(AObj, AProp, AChild.AsInteger);
        tkChar, tkString, tkWChar, tkLString, tkWString, tkUString:
          SetStrProp(AObj, AProp, AChild.AsString);
        tkEnumeration:
          begin
          if GetTypeData(AProp.PropType^)^.BaseType^ = TypeInfo(Boolean) then
            SetOrdProp(AObj, AProp, Integer(AChild.AsBoolean))
          else if AChild.DataType = jdtInteger then
            SetOrdProp(AObj, AProp, AChild.AsInteger)
          else
            SetEnumProp(AObj, AProp, AChild.AsString);
          end;
        tkSet:
          begin
          if AChild.DataType = jdtInteger then
            SetOrdProp(AObj, AProp, AChild.AsInteger)
          else
            SetSetProp(AObj, AProp, AChild.AsString);
          end;
        tkVariant:
          SetVariantProp(AObj, AProp, AChild.AsVariant);
        tkInt64:
          SetInt64Prop(AObj, AProp, AChild.AsInt64);
      end;
      end;
    end;
  end;

  procedure SetDynArrayLen(arr: Pointer; AType: PTypeInfo; ALen: NativeInt);
  var
    pmem: Pointer;
  begin
  pmem := PPointer(arr)^;
  DynArraySetLength(pmem, AType, 1, @ALen);
  PPointer(arr)^ := pmem;
  end;

  procedure ToArray;
  var
    AContext: TRttiContext;
    ASubType: TRttiType;
    I, l, AOffset: Integer;
    s: QStringW;
    pd, pi: PByte;
    AChildObj: TObject;
    ASubTypeInfo: PTypeInfo;
    AChild: TQJson;
  begin
  AContext := TRttiContext.Create;
{$IF RTLVersion>25}
  s := ArrayItemTypeName(AType.NameFld.ToString);
{$ELSE}
  s := ArrayItemTypeName(String(AType.Name));
{$IFEND}
  ASubType := AContext.FindType(s);
  ASubTypeInfo := ASubType.Handle;
  if ASubType <> nil then
    begin
    l := Count;
    SetDynArrayLen(ADest, AType, l);
    pd := PPointer(ADest)^;
    for I := 0 to l - 1 do
      begin
      AOffset := I * GetTypeData(AType).elSize;
      pi := Pointer(IntPtr(pd) + AOffset);
      AChild := Items[I];
      case ASubType.TypeKind of
        tkInteger:
          begin
          case GetTypeData(ASubTypeInfo).OrdType of
            otSByte:
              PShortint(pi)^ := AChild.AsInteger;
            otUByte:
              pi^ := Items[I].AsInteger;
            otSWord:
              PSmallint(pi)^ := AChild.AsInteger;
            otUWord:
              PWord(pi)^ := AChild.AsInteger;
            otSLong:
              PInteger(pi)^ := AChild.AsInteger;
            otULong:
              PCardinal(pi)^ := AChild.AsInteger;
          end;
          end;
{$IFNDEF NEXTGEN}
        tkChar:
          pi^ := Ord(PAnsiChar(AnsiString(AChild.AsString))[0]);
{$ENDIF !NEXTGEN}
        tkEnumeration:
          begin
          if GetTypeData(ASubTypeInfo)^.BaseType^ = TypeInfo(Boolean) then
            PBoolean(pi)^ := AChild.AsBoolean
          else
            begin
            case GetTypeData(ASubTypeInfo)^.OrdType of
              otSByte:
                begin
                if AChild.DataType = jdtInteger then
                  PShortint(pi)^ := AChild.AsInteger
                else
                  PShortint(pi)^ := GetEnumValue(ASubTypeInfo, AChild.AsString);
                end;
              otUByte:
                begin
                if AChild.DataType = jdtInteger then
                  pi^ := AChild.AsInteger
                else
                  pi^ := GetEnumValue(ASubTypeInfo, AChild.AsString);
                end;
              otSWord:
                begin
                if AChild.DataType = jdtInteger then
                  PSmallint(pi)^ := AChild.AsInteger
                else
                  PSmallint(pi)^ := GetEnumValue(ASubTypeInfo, AChild.AsString);
                end;
              otUWord:
                begin
                if AChild.DataType = jdtInteger then
                  PWord(pi)^ := AChild.AsInteger
                else
                  PWord(pi)^ := GetEnumValue(ASubTypeInfo, AChild.AsString);
                end;
              otSLong:
                begin
                if AChild.DataType = jdtInteger then
                  PInteger(pi)^ := AChild.AsInteger
                else
                  PInteger(pi)^ := GetEnumValue(ASubTypeInfo, AChild.AsString);
                end;
              otULong:
                begin
                if AChild.DataType = jdtInteger then
                  PCardinal(pi)^ := AChild.AsInteger
                else
                  PCardinal(pi)^ := GetEnumValue(ASubTypeInfo,
                    Items[I].AsString);
                end;
            end;
            end;
          end;
        tkFloat:
          case GetTypeData(ASubTypeInfo)^.FloatType of
            ftSingle:
              PSingle(pi)^ := Items[I].AsFloat;
            ftDouble:
              PDouble(pi)^ := Items[I].AsFloat;
            ftExtended:
              PExtended(pi)^ := Items[I].AsFloat;
            ftComp:
              PComp(pi)^ := Items[I].AsFloat;
            ftCurr:
              PCurrency(pi)^ := Items[I].AsFloat;
          end;
{$IFNDEF NEXTGEN}
        tkString:
          PShortString(pi)^ := ShortString(Items[I].AsString);
{$ENDIF !NEXTGEN}
        tkSet:
          begin
          case GetTypeData(ASubTypeInfo)^.OrdType of
            otSByte:
              begin
              if AChild.DataType = jdtInteger then
                PShortint(pi)^ := AChild.AsInteger
              else
                PShortint(pi)^ := StringToSet(ASubTypeInfo, AChild.AsString);
              end;
            otUByte:
              begin
              if AChild.DataType = jdtInteger then
                pi^ := AChild.AsInteger
              else
                pi^ := StringToSet(ASubTypeInfo, AChild.AsString);
              end;
            otSWord:
              begin
              if AChild.DataType = jdtInteger then
                PSmallint(pi)^ := AChild.AsInteger
              else
                PSmallint(pi)^ := StringToSet(ASubTypeInfo, AChild.AsString);
              end;
            otUWord:
              begin
              if AChild.DataType = jdtInteger then
                PWord(pi)^ := AChild.AsInteger
              else
                PWord(pi)^ := StringToSet(ASubTypeInfo, AChild.AsString);
              end;
            otSLong:
              begin
              if AChild.DataType = jdtInteger then
                PInteger(pi)^ := AChild.AsInteger
              else
                PInteger(pi)^ := StringToSet(ASubTypeInfo, AChild.AsString);
              end;
            otULong:
              begin
              if AChild.DataType = jdtInteger then
                PCardinal(pi)^ := AChild.AsInteger
              else
                PCardinal(pi)^ := StringToSet(ASubTypeInfo, Items[I].AsString);
              end;
          end;
          end;
        tkClass:
          begin
          if PPointer(pi)^ <> nil then
            begin
            AChildObj := PPointer(pi)^;
            if AChildObj is TStrings then
              (AChildObj as TStrings).Text := Items[I].AsString
            else if AChildObj is TCollection then
              LoadCollection(Items[I], AChildObj as TCollection)
            else
              Items[I].ToRtti(AChildObj);
            end;
          end;
        tkWChar:
          PWideChar(pi)^ := PWideChar(Items[I].AsString)[0];
{$IFNDEF NEXTGEN}
        tkLString:
          PAnsiString(pi)^ := AnsiString(Items[I].AsString);
        tkWString:
          PWideString(pi)^ := Items[I].AsString;
{$ENDIF}
        tkVariant:
          PVariant(pi)^ := Items[I].AsVariant;
        tkArray, tkDynArray:
          Items[I].ToRtti(pi, ASubTypeInfo);
        tkRecord:
          Items[I].ToRtti(pi, ASubTypeInfo);
        tkInt64:
          PInt64(pi)^ := Items[I].AsInt64;
        tkUString:
          PUnicodeString(pi)^ := Items[I].AsString;
      end;
      end;
    end
  else
    raise Exception.Create(SArrayTypeMissed);
  end;
  function GetFixedArrayItemType: PTypeInfo;
  var
    pType: PPTypeInfo;
  begin
  pType := GetTypeData(AType)^.ArrayData.ElType;
  if pType = nil then
    Result := nil
  else
    Result := pType^;
  end;
  procedure ToFixedArray;
  var
    I, c, ASize: Integer;
    ASubType: PTypeInfo;
    AChild: TQJson;
    AChildObj: TObject;
    pi: Pointer;
  begin
  c := GetTypeData(AType).ArrayData.ElCount;
  ASubType := GetFixedArrayItemType;
  if ASubType = nil then
    Exit;
  ASize := GetTypeData(ASubType).elSize;
  for I := 0 to c - 1 do
    begin
    pi := Pointer(IntPtr(ADest) + ASize * I);
    AChild := Items[I];
    case ASubType.Kind of
      tkInteger:
        begin
        case GetTypeData(ASubType).OrdType of
          otSByte:
            PShortint(pi)^ := AChild.AsInteger;
          otUByte:
            PByte(pi)^ := AChild.AsInteger;
          otSWord:
            PSmallint(pi)^ := AChild.AsInteger;
          otUWord:
            PWord(pi)^ := AChild.AsInteger;
          otSLong:
            PInteger(pi)^ := AChild.AsInteger;
          otULong:
            PCardinal(pi)^ := AChild.AsInteger;
        end;
        end;
{$IFNDEF NEXTGEN}
      tkChar:
        PByte(pi)^ := Ord(PAnsiChar(AnsiString(AChild.AsString))[0]);
{$ENDIF !NEXTGEN}
      tkEnumeration:
        begin
        if GetTypeData(ASubType)^.BaseType^ = TypeInfo(Boolean) then
          PBoolean(pi)^ := AChild.AsBoolean
        else
          begin
          case GetTypeData(ASubType)^.OrdType of
            otSByte:
              begin
              if AChild.DataType = jdtInteger then
                PShortint(pi)^ := AChild.AsInteger
              else
                PShortint(pi)^ := GetEnumValue(ASubType, AChild.AsString);
              end;
            otUByte:
              begin
              if AChild.DataType = jdtInteger then
                PByte(pi)^ := AChild.AsInteger
              else
                PByte(pi)^ := GetEnumValue(ASubType, AChild.AsString);
              end;
            otSWord:
              begin
              if AChild.DataType = jdtInteger then
                PSmallint(pi)^ := AChild.AsInteger
              else
                PSmallint(pi)^ := GetEnumValue(ASubType, AChild.AsString);
              end;
            otUWord:
              begin
              if AChild.DataType = jdtInteger then
                PWord(pi)^ := AChild.AsInteger
              else
                PWord(pi)^ := GetEnumValue(ASubType, AChild.AsString);
              end;
            otSLong:
              begin
              if AChild.DataType = jdtInteger then
                PInteger(pi)^ := AChild.AsInteger
              else
                PInteger(pi)^ := GetEnumValue(ASubType, AChild.AsString);
              end;
            otULong:
              begin
              if AChild.DataType = jdtInteger then
                PCardinal(pi)^ := AChild.AsInteger
              else
                PCardinal(pi)^ := GetEnumValue(ASubType, Items[I].AsString);
              end;
          end;
          end;
        end;
      tkFloat:
        case GetTypeData(ASubType)^.FloatType of
          ftSingle:
            PSingle(pi)^ := Items[I].AsFloat;
          ftDouble:
            PDouble(pi)^ := Items[I].AsFloat;
          ftExtended:
            PExtended(pi)^ := Items[I].AsFloat;
          ftComp:
            PComp(pi)^ := Items[I].AsFloat;
          ftCurr:
            PCurrency(pi)^ := Items[I].AsFloat;
        end;
{$IFNDEF NEXTGEN}
      tkString:
        PShortString(pi)^ := ShortString(Items[I].AsString);
{$ENDIF !NEXTGEN}
      tkSet:
        begin
        case GetTypeData(ASubType)^.OrdType of
          otSByte:
            begin
            if AChild.DataType = jdtInteger then
              PShortint(pi)^ := AChild.AsInteger
            else
              PShortint(pi)^ := StringToSet(ASubType, AChild.AsString);
            end;
          otUByte:
            begin
            if AChild.DataType = jdtInteger then
              PByte(pi)^ := AChild.AsInteger
            else
              PByte(pi)^ := StringToSet(ASubType, AChild.AsString);
            end;
          otSWord:
            begin
            if AChild.DataType = jdtInteger then
              PSmallint(pi)^ := AChild.AsInteger
            else
              PSmallint(pi)^ := StringToSet(ASubType, AChild.AsString);
            end;
          otUWord:
            begin
            if AChild.DataType = jdtInteger then
              PWord(pi)^ := AChild.AsInteger
            else
              PWord(pi)^ := StringToSet(ASubType, AChild.AsString);
            end;
          otSLong:
            begin
            if AChild.DataType = jdtInteger then
              PInteger(pi)^ := AChild.AsInteger
            else
              PInteger(pi)^ := StringToSet(ASubType, AChild.AsString);
            end;
          otULong:
            begin
            if AChild.DataType = jdtInteger then
              PCardinal(pi)^ := AChild.AsInteger
            else
              PCardinal(pi)^ := StringToSet(ASubType, Items[I].AsString);
            end;
        end;
        end;
      tkClass:
        begin
        if PPointer(pi)^ <> nil then
          begin
          AChildObj := PPointer(pi)^;
          if AChildObj is TStrings then
            (AChildObj as TStrings).Text := Items[I].AsString
          else if AChildObj is TCollection then
            LoadCollection(Items[I], AChildObj as TCollection)
          else
            Items[I].ToRtti(AChildObj);
          end;
        end;
      tkWChar:
        PWideChar(pi)^ := PWideChar(Items[I].AsString)[0];
{$IFNDEF NEXTGEN}
      tkLString:
        PAnsiString(pi)^ := AnsiString(Items[I].AsString);
      tkWString:
        PWideString(pi)^ := Items[I].AsString;
{$ENDIF}
      tkVariant:
        PVariant(pi)^ := Items[I].AsVariant;
      tkArray, tkDynArray:
        Items[I].ToRtti(pi, ASubType);
      tkRecord:
        Items[I].ToRtti(pi, ASubType);
      tkInt64:
        PInt64(pi)^ := Items[I].AsInt64;
      tkUString:
        PUnicodeString(pi)^ := Items[I].AsString;
    end;
    end;
  end;

begin
if ADest <> nil then
  begin
  if AType.Kind = tkRecord then
    ToRecord
  else if AType.Kind = tkClass then
    ToObject
  else if AType.Kind = tkDynArray then
    ToArray
  else if AType.Kind = tkArray then
    ToFixedArray
  else
    raise Exception.Create(SUnsupportPropertyType);
  end;
end;

function TQJson.ToRttiValue: TValue;
  procedure AsDynValueArray;
  var
    AValues: array of TValue;
    I: Integer;
  begin
  SetLength(AValues, Count);
  for I := 0 to Count - 1 do
    AValues[I] := Items[I].ToRttiValue;
  Result := TValue.FromArray(TypeInfo(TValueArray), AValues);
  end;

begin
case DataType of
  jdtString:
    Result := AsString;
  jdtInteger:
    Result := AsInt64;
  jdtFloat:
    Result := AsFloat;
  jdtDateTime:
    Result := AsDateTime;
  jdtBoolean:
    Result := AsBoolean;
  jdtArray, jdtObject: // ����Ͷ���ֻ�ܵ�������������
    AsDynValueArray
else
  Result := TValue.Empty;
end;
end;
{$ENDIF >XE5}

function TQJson.ToString: string;
begin
Result := AsString;
end;

function TQJson.TryParse(p: PWideChar; l: Integer): Boolean;

  procedure DoTry;
  var
    ABuilder: TQStringCatHelperW;
  begin
  ABuilder := TQStringCatHelperW.Create;
  try
    try
      SkipSpaceW(p);
      Result := ParseJsonPair(ABuilder, p) = 0;
    except
      on E: Exception do
        Result := False;
    end;
  finally
    FreeObject(ABuilder);
  end;
  end;

  procedure ParseCopy;
  var
    s: QStringW;
  begin
  s := StrDupW(p, 0, l);
  p := PQCharW(s);
  DoTry;
  end;

begin
if DataType in [jdtObject, jdtArray] then
  Clear;
if (l > 0) and (p[l] <> #0) then
  ParseCopy
else
  DoTry;
end;

function TQJson.TryParse(const s: QStringW): Boolean;
begin
Result := TryParse(PQCharW(s), Length(s));
end;

function TQJson.TryParseValue(ABuilder: TQStringCatHelperW;
  var p: PQCharW): Integer;
var
  ANum: Extended;
const
  JsonEndChars: PWideChar = ',]}';
begin
Result := 0;
if p^ = '"' then
  begin
  BuildJsonString(ABuilder, p);
  AsString := ABuilder.Value;
  end
else if p^ = '''' then
  begin
  if StrictJson then
    Result := EParse_BadStringStart;
  BuildJsonString(ABuilder, p);
  AsString := ABuilder.Value;
  end
else if ParseNumeric(p, ANum) then // ���֣�
  begin
  SkipSpaceW(p);
  if (p^ = #0) or CharInW(p, JsonEndChars) then
    begin
    if SameValue(ANum, Trunc(ANum)) then
      AsInt64 := Trunc(ANum)
    else
      AsFloat := ANum;
    end
  else
    Result := EParse_BadJson;
  end
else if StartWithW(p, 'False', true) then // False
  begin
  Inc(p, 5);
  SkipSpaceW(p);
  AsBoolean := False
  end
else if StartWithW(p, 'True', true) then // True
  begin
  Inc(p, 4);
  SkipSpaceW(p);
  AsBoolean := true;
  end
else if StartWithW(p, 'NULL', true) then // Null
  begin
  Inc(p, 4);
  SkipSpaceW(p);
  ResetNull;
  end
else if (p^ = '[') or (p^ = '{') then
  Result := ParseJsonPair(ABuilder, p)
else
  Result := 2;
end;

procedure TQJson.ValidArray;
begin
if DataType in [jdtArray, jdtObject] then
{$IFDEF UNICODE}
  FItems := TList<TQJson>.Create
{$ELSE}
  FItems := TList.Create
{$ENDIF}
else
  raise Exception.Create(Format(SVarNotArray, [FName]));
end;

function TQJson.ValueByName(AName, ADefVal: QStringW): QStringW;
var
  AChild: TQJson;
begin
AChild := ItemByName(AName);
if Assigned(AChild) then
  Result := AChild.Value
else
  Result := ADefVal;
end;

function TQJson.ValueByPath(APath, ADefVal: QStringW): QStringW;
var
  AItem: TQJson;
begin
AItem := ItemByPath(APath);
if Assigned(AItem) then
  Result := AItem.Value
else
  Result := ADefVal;
end;
{ TQJsonEnumerator }

constructor TQJsonEnumerator.Create(AList: TQJson);
begin
inherited Create;
FList := AList;
FIndex := -1;
end;

function TQJsonEnumerator.GetCurrent: TQJson;
begin
Result := FList[FIndex];
end;

function TQJsonEnumerator.MoveNext: Boolean;
begin
if FIndex < FList.Count - 1 then
  begin
  Inc(FIndex);
  Result := true;
  end
else
  Result := False;
end;

{ TQHashedJson }

function TQHashedJson.Add(AName: QStringW): TQJson;
begin
Result := inherited Add(AName);
Result.FNameHash := HashOf(PQCharW(AName), Length(AName) shl 1);
FHashTable.Add(Pointer(Count - 1), Result.FNameHash);
end;

procedure TQHashedJson.Assign(ANode: TQJson);
begin
inherited;
if (Length(FName) > 0) then
  begin
  if FNameHash = 0 then
    FNameHash := HashOf(PQCharW(FName), Length(FName) shl 1);
  if Assigned(Parent) then
    TQHashedJson(Parent).FHashTable.Add(Pointer(Parent.Count - 1), FNameHash);
  end;
end;

procedure TQHashedJson.Clear;
begin
inherited;
FHashTable.Clear;
end;

constructor TQHashedJson.Create;
begin
inherited;
FHashTable := TQHashTable.Create();
FHashTable.AutoSize := true;
end;

function TQHashedJson.CreateJson: TQJson;
begin
if Assigned(OnQJsonCreate) then
  Result := OnQJsonCreate
else
  Result := TQHashedJson.Create;
end;

procedure TQHashedJson.Delete(AIndex: Integer);
var
  AItem: TQJson;
begin
AItem := Items[AIndex];
FHashTable.Delete(Pointer(AIndex), AItem.NameHash);
inherited;
end;

destructor TQHashedJson.Destroy;
begin
FreeObject(FHashTable);
inherited;
end;

function TQHashedJson.IndexOf(const AName: QStringW): Integer;
var
  AIndex, AHash: Integer;
  AList: PQHashList;
  AItem: TQJson;
begin
AHash := HashOf(PQCharW(AName), Length(AName) shl 1);
AList := FHashTable.FindFirst(AHash);
Result := -1;
while AList <> nil do
  begin
  AIndex := Integer(AList.Data);
  AItem := Items[AIndex];
  if AItem.Name = AName then
    begin
    Result := AIndex;
    Break;
    end
  else
    AList := FHashTable.FindNext(AList);
  end;
end;

procedure TQHashedJson.Replace(AIndex: Integer; ANewItem: TQJson);
var
  AOld: TQJson;
begin
if not(ANewItem is TQHashedJson) then
  raise Exception.CreateFmt(SReplaceTypeNeed, ['TQHashedJson']);
AOld := Items[AIndex];
FHashTable.Delete(Pointer(AIndex), AOld.NameHash);
inherited;
if Length(ANewItem.FName) > 0 then
  FHashTable.Add(Pointer(AIndex), ANewItem.FNameHash);
end;

initialization

StrictJson := False;
JsonRttiEnumAsInt := true;
JsonCaseSensitive := true;
JsonDateFormat := 'yyyy-mm-dd';
JsonDateTimeFormat := 'yyyy-mm-dd''T''hh:nn:ss.zzz';
JsonTimeFormat := 'hh:nn:ss.zzz';
OnQJsonCreate := nil;
OnQJsonFree := nil;

end.
