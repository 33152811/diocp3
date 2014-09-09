﻿(*
   unit Owner: D10.Mofen, qdac.swish
      welcome to report bug: 185511468(qq), 185511468@qq.com
   Web site   : https://github.com/ymofen/msgpack-delphi

  * Delphi 2007 (tested)
  * XE5, XE7 (tested)

   + first release
     2014-08-15 13:05:13

   + add array support
     2014-08-19 12:18:47

   + add andriod support
     2014-09-08 00:45:27


   samples:
     lvMsgPack:=TSimpleMsgPack.Create;
     lvMsgPack.S['root.child01'] := 'abc';

     //save to stream
     lvMsgPack.EncodeToStream(pvStream);


Copyright (c) 2014, ymofen, swish
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

     

*)
unit SimpleMsgPack;

interface

uses
  classes, SysUtils
  {$IFDEF UNICODE}, Generics.Collections{$ELSE}, Contnrs{$ENDIF}
  {$IFDEF MSWINDOWS}, Windows{$ENDIF}
  ,Variants;

type
  {$IF RTLVersion<25}
    IntPtr=Integer;
  {$IFEND IntPtr}

  {$if CompilerVersion < 18} //before delphi 2007
    TBytes = array of Byte;
  {$ifend}

  TMsgPackType = (mptUnknown, mptNull, mptMap, mptArray, mptString, mptInteger,
  mptBoolean, mptFloat, mptSingle, mptDateTime, mptBinary);

  // reserved
  IMsgPack = interface
    ['{37D3E479-7A46-435A-914D-08FBDA75B50E}'] 
  end;

  // copy from qmsgPack
  TMsgPackValue= packed record
    ValueType:Byte;
    case Integer of
      0:(U8Val:Byte);
      1:(I8Val:Shortint);
      2:(U16Val:Word);
      3:(I16Val:Smallint);
      4:(U32Val:Cardinal);
      5:(I32Val:Integer);
      6:(U64Val:UInt64);
      7:(I64Val:Int64);
      8:(F32Val:Single);
      9:(F64Val:Double);
      10:(BArray:array[0..16] of Byte);
  end;

  TMsgPackSetting = class(TObject)
  private
    FCaseSensitive: Boolean;
  public
    property CaseSensitive: Boolean read FCaseSensitive write FCaseSensitive;
  end;



  TSimpleMsgPack = class(TObject)
  private

    FParent:TSimpleMsgPack;

    FLowerName:String;

    FName:String;

    FValue:TBytes;

    FDataType:TMsgPackType;

  {$IFDEF UNICODE}
    FChildren: TObjectList<TSimpleMsgPack>;
  {$ELSE}
    FChildren: TObjectList;
  {$ENDIF}

    procedure InnerAddToChildren(obj:TSimpleMsgPack);
    function InnerAdd: TSimpleMsgPack;
    function GetCount: Integer;
    procedure InnerEncodeToStream(pvStream:TStream);
    procedure InnerParseFromStream(pvStream: TStream);

    procedure setName(pvName:string);
  private
    function getAsString: String;
    procedure setAsString(pvValue:string);

    function getAsInteger: Int64;
    procedure setAsInteger(pvValue:Int64);
    function GetAsBoolean: Boolean;
    procedure SetAsBoolean(const Value: Boolean);

    procedure SetAsFloat(const Value: Double);
    function GetAsFloat: Double;

    procedure SetAsDateTime(const Value: TDateTime);
    function GetAsDateTime: TDateTime;

    function GetAsVariant: Variant;
    procedure SetAsVariant(const Value: Variant);

    procedure SetAsSingle(const Value: Single);
    function GetAsSingle: Single;

    procedure checkObjectDataType(ANewType: TMsgPackType = mptMap);

    function findObj(pvName:string): TSimpleMsgPack;
    function indexOf(pvName:string): Integer;
    function indexOfCaseSensitive(pvName:string): Integer;
    function indexOfIgnoreSensitive(pvLowerCaseName: string): Integer;


  private
  


    function GetO(pvPath: String): TSimpleMsgPack;
    procedure SetO(pvPath: String; const Value: TSimpleMsgPack);

    function GetS(pvPath: String): string;
    procedure SetS(pvPath: String; const Value: string);

    function GetI(pvPath: String): Int64;
    procedure SetI(pvPath: String; const Value: Int64);

    function GetB(pvPath: String): Boolean;
    procedure SetB(pvPath: String; const Value: Boolean);
    
    function GetD(pvPath: String): Double;
    procedure SetD(pvPath: String; const Value: Double);

    function GetItems(AIndex: Integer): TSimpleMsgPack;

  public
    constructor Create;
    destructor Destroy; override;
    property Count: Integer read GetCount;

    procedure LoadBinaryFromStream(pvStream: TStream; pvLen: cardinal = 0);
    procedure SaveBinaryToStream(pvStream:TStream);

    procedure LoadBinaryFromFile(pvFileName:String);
    procedure SaveBinaryToFile(pvFileName:String);

    procedure EncodeToStream(pvStream:TStream);
    procedure DecodeFromStream(pvStream:TStream);

    function EncodeToBytes: TBytes;
    procedure DecodeFromBytes(pvBytes:TBytes); 

    function Add(pvNameKey, pvValue: string): TSimpleMsgPack; overload;
    function Add(pvNameKey: string; pvValue: Int64): TSimpleMsgPack; overload;
    function Add(pvNameKey: string; pvValue: TBytes): TSimpleMsgPack; overload;
    function Add(pvNameKey: String): TSimpleMsgPack; overload;
    function Add():TSimpleMsgPack; overload;

    function ForcePathObject(pvPath:string): TSimpleMsgPack;

    property AsInteger:Int64 read getAsInteger write setAsInteger;
    property AsString:string read getAsString write setAsString;
    property AsBoolean: Boolean read GetAsBoolean write SetAsBoolean;
    property AsFloat: Double read GetAsFloat write SetAsFloat;
    property AsSingle: Single read GetAsSingle write SetAsSingle;
    property AsDateTime: TDateTime read GetAsDateTime write SetAsDateTime;
    property AsVariant: Variant read GetAsVariant write SetAsVariant;

    property O[pvPath: String]: TSimpleMsgPack read GetO write SetO;
    property S[pvPath: String]: string read GetS write SetS;
    property I[pvPath: String]: Int64 read GetI write SetI;
    property B[pvPath: String]: Boolean read GetB write SetB;
    property D[pvPath: String]: Double read GetD write SetD;

    property Items[AIndex: Integer]: TSimpleMsgPack read GetItems; default;
  end;

implementation

resourcestring
  SVariantConvertNotSupport = 'type to convert not support!。';


function swap16(const v): Word;
begin
  // FF, EE : EE->1, FF->2
  PByte(@result)^ := PByte(IntPtr(@v) + 1)^;
  PByte(IntPtr(@result) + 1)^ := PByte(@v)^;
end;

function swap32(const v): Cardinal;
begin
  // FF, EE, DD, CC : CC->1, DD->2, EE->3, FF->4
  PByte(@result)^ := PByte(IntPtr(@v) + 3)^;
  PByte(IntPtr(@result) + 1)^ := PByte(IntPtr(@v) + 2)^;
  PByte(IntPtr(@result) + 2)^ := PByte(IntPtr(@v) + 1)^;
  PByte(IntPtr(@result) + 3)^ := PByte(@v)^;
end;

function swap64(const v): Int64;
begin
  // FF, EE, DD, CC, BB, AA, 99, 88 : 88->1 ,99->2 ....
  PByte(@result)^ := PByte(IntPtr(@v) + 7)^;
  PByte(IntPtr(@result) + 1)^ := PByte(IntPtr(@v) + 6)^;
  PByte(IntPtr(@result) + 2)^ := PByte(IntPtr(@v) + 5)^;
  PByte(IntPtr(@result) + 3)^ := PByte(IntPtr(@v) + 4)^;
  PByte(IntPtr(@result) + 4)^ := PByte(IntPtr(@v) + 3)^;
  PByte(IntPtr(@result) + 5)^ := PByte(IntPtr(@v) + 2)^;
  PByte(IntPtr(@result) + 6)^ := PByte(IntPtr(@v) + 1)^;
  PByte(IntPtr(@result) + 7)^ := PByte(@v)^;
end;

// v and outVal is can't the same value
procedure swap64Ex(const v; out outVal);
begin
  // FF, EE, DD, CC, BB, AA, 99, 88 : 88->1 ,99->2 ....
  PByte(@outVal)^ := PByte(IntPtr(@v) + 7)^;
  PByte(IntPtr(@outVal) + 1)^ := PByte(IntPtr(@v) + 6)^;
  PByte(IntPtr(@outVal) + 2)^ := PByte(IntPtr(@v) + 5)^;
  PByte(IntPtr(@outVal) + 3)^ := PByte(IntPtr(@v) + 4)^;
  PByte(IntPtr(@outVal) + 4)^ := PByte(IntPtr(@v) + 3)^;
  PByte(IntPtr(@outVal) + 5)^ := PByte(IntPtr(@v) + 2)^;
  PByte(IntPtr(@outVal) + 6)^ := PByte(IntPtr(@v) + 1)^;
  PByte(IntPtr(@outVal) + 7)^ := PByte(@v)^;
end;

// v and outVal is can't the same value
procedure swap32Ex(const v; out outVal);
begin
  // FF, EE, DD, CC : CC->1, DD->2, EE->3, FF->4
  PByte(@outVal)^ := PByte(IntPtr(@v) + 3)^;
  PByte(IntPtr(@outVal) + 1)^ := PByte(IntPtr(@v) + 2)^;
  PByte(IntPtr(@outVal) + 2)^ := PByte(IntPtr(@v) + 1)^;
  PByte(IntPtr(@outVal) + 3)^ := PByte(@v)^;
end;

// v and outVal is can't the same value
procedure swap16Ex(const v; out outVal);
begin
  // FF, EE : EE->1, FF->2
  PByte(@outVal)^ := PByte(IntPtr(@v) + 1)^;
  PByte(IntPtr(@outVal) + 1)^ := PByte(@v)^;
end;

// overload swap
function swap(v:Single):Single; overload;
begin
  swap16Ex(v, Result);
end;

// overload swap
function swap(v:word):Word; overload;
begin
  swap16Ex(v, Result);
end;

// overload swap
function swap(v:Cardinal):Cardinal; overload;
begin
  swap32Ex(v, Result);
end;

function swap(v:Double):Double; overload;
begin
  swap64Ex(v, Result);
end;


// copy from qstring
function BinToHex(p: Pointer; l: Integer; ALowerCase: Boolean): string;
const
  B2HConvert: array [0 .. 15] of Char = ('0', '1', '2', '3', '4', '5', '6',
    '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F');
  B2HConvertL: array [0 .. 15] of Char = ('0', '1', '2', '3', '4', '5', '6',
    '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f');
var
  pd: PChar;
  pb: PByte;
begin
  if SizeOf(Char) = 2 then
  begin
    SetLength(Result, l shl 1);
  end else
  begin
    SetLength(Result, l);
  end;
  pd := PChar(Result);
  pb := p;
  if ALowerCase then
  begin
    while l > 0 do
    begin
      pd^ := B2HConvertL[pb^ shr 4];
      Inc(pd);
      pd^ := B2HConvertL[pb^ and $0F];
      Inc(pd);
      Inc(pb);
      Dec(l);
    end;
  end
  else
  begin
    while l > 0 do
    begin
      pd^ := B2HConvert[pb^ shr 4];
      Inc(pd);
      pd^ := B2HConvert[pb^ and $0F];
      Inc(pd);
      Inc(pb);
      Dec(l);
    end;
  end;
end;



function getFirst(var strPtr: PChar; splitChars: TSysCharSet): string;
var
  oPtr:PChar;
  l:Cardinal;
begin
  oPtr := strPtr;
  Result := '';
  while True do
  begin
    if (strPtr^ in splitChars) then
    begin
      l := strPtr - oPtr;
      if l > 0 then
      begin
      {$IFDEF UNICODE}
        SetLength(Result, l);
        Move(oPtr^, PChar(Result)^, l shl 1);
      {$ELSE}
        SetLength(Result, l);
        Move(oPtr^, PChar(Result)^, l);
      {$ENDIF}
        break;
      end;
    end else if (strPtr^ = #0) then
    begin
      l := strPtr - oPtr;
      if l > 0 then
      begin
      {$IFDEF UNICODE}
        SetLength(Result, l);
        Move(oPtr^, PChar(Result)^, l shl 1);
      {$ELSE}
        SetLength(Result, l);
        Move(oPtr^, PChar(Result)^, l);
      {$ENDIF}
      end;
      break;
    end;
    Inc(strPtr);
  end;
end;


function Utf8DecodeEx(pvValue:{$IFDEF UNICODE}TBytes{$ELSE}AnsiString{$ENDIF}; len:Cardinal):string;
{$IFDEF UNICODE}
var             
  lvBytes:TBytes;
{$ENDIF}
begin
{$IFDEF UNICODE}
  lvBytes := TEncoding.Convert(TEncoding.UTF8, TEncoding.Unicode, pvValue);
  SetLength(Result, Length(lvBytes) shr 1);
  Move(lvBytes[0], PChar(Result)^, Length(lvBytes));
{$ELSE}
  result:= UTF8Decode(pvValue);
{$ENDIF}
end;

function Utf8EncodeEx(pvValue:string):{$IFDEF UNICODE}TBytes{$ELSE}AnsiString{$ENDIF};
{$IFDEF UNICODE}
var
  lvBytes:TBytes;
  len:Cardinal;
{$ENDIF}
begin
{$IFDEF UNICODE}
  len := length(pvValue) shl 1;
  SetLength(lvBytes, len);
  Move(PChar(pvValue)^, lvBytes[0], len);
  Result := TEncoding.Convert(TEncoding.Unicode, TEncoding.UTF8, lvBytes);
{$ELSE}
  result:= UTF8Encode(pvValue);
{$ENDIF}
end;


// copy from qmsgPack
procedure writeString(pvValue: string; pvStream: TStream);
var

  lvRawData:{$IFDEF UNICODE}TBytes{$ELSE}AnsiString{$ENDIF};
  l:Integer;
  lvValue:TMsgPackValue;
begin
  lvRawData := Utf8EncodeEx(pvValue);
  l:=Length(lvRawData);

  //
  //fixstr stores a byte array whose length is upto 31 bytes:
  //+--------+========+
  //|101XXXXX|  data  |
  //+--------+========+
  //
  //str 8 stores a byte array whose length is upto (2^8)-1 bytes:
  //+--------+--------+========+
  //|  0xd9  |YYYYYYYY|  data  |
  //+--------+--------+========+
  //
  //str 16 stores a byte array whose length is upto (2^16)-1 bytes:
  //+--------+--------+--------+========+
  //|  0xda  |ZZZZZZZZ|ZZZZZZZZ|  data  |
  //+--------+--------+--------+========+
  //
  //str 32 stores a byte array whose length is upto (2^32)-1 bytes:
  //+--------+--------+--------+--------+--------+========+
  //|  0xdb  |AAAAAAAA|AAAAAAAA|AAAAAAAA|AAAAAAAA|  data  |
  //+--------+--------+--------+--------+--------+========+
  //
  //where
  //* XXXXX is a 5-bit unsigned integer which represents N
  //* YYYYYYYY is a 8-bit unsigned integer which represents N
  //* ZZZZZZZZ_ZZZZZZZZ is a 16-bit big-endian unsigned integer which represents N
  //* AAAAAAAA_AAAAAAAA_AAAAAAAA_AAAAAAAA is a 32-bit big-endian unsigned integer which represents N
  //* N is the length of data

  if L<=31 then
  begin
    lvValue.ValueType:=$A0+Byte(L);
    pvStream.WriteBuffer(lvValue.ValueType,1);
  end
  else if L<=255 then
  begin
    lvValue.ValueType:=$d9;
    lvValue.U8Val:=Byte(L);
    pvStream.WriteBuffer(lvValue,2);
  end
  else if L<=65535 then
  begin
    lvValue.ValueType:=$da;
    lvValue.U16Val:=((L shr 8) and $FF) or ((L shl 8) and $FF00);
    pvStream.Write(lvValue,3);
  end else
  begin
    lvValue.ValueType:=$db;
    lvValue.BArray[0]:=(L shr 24) and $FF;
    lvValue.BArray[1]:=(L shr 16) and $FF;
    lvValue.BArray[2]:=(L shr 8) and $FF;
    lvValue.BArray[3]:=L and $FF;
    pvStream.WriteBuffer(lvValue,5);
  end;

  pvStream.Write(PByte(lvRawData)^, l);
end;

procedure WriteBinary(p: PByte; l: Integer; pvStream: TStream);
var
  lvValue:TMsgPackValue;
begin
  if l <= 255 then
  begin
    lvValue.ValueType := $C4;
    lvValue.U8Val := Byte(l);
    pvStream.WriteBuffer(lvValue, 2);
  end
  else if l <= 65535 then
  begin
    lvValue.ValueType := $C5;
    lvValue.BArray[0] := (l shr 8) and $FF;
    lvValue.BArray[1] := l and $FF;
    pvStream.WriteBuffer(lvValue, 3);
  end
  else
  begin
    lvValue.ValueType := $C6;
    lvValue.BArray[0] := (l shr 24) and $FF;
    lvValue.BArray[1] := (l shr 16) and $FF;
    lvValue.BArray[2] := (l shr 8) and $FF;
    lvValue.BArray[3] := l and $FF;
    pvStream.WriteBuffer(lvValue, 5);
  end;
  pvStream.WriteBuffer(p^, l);
end;

// copy from qmsgPack
procedure WriteInt(const iVal: Int64; AStream: TStream);
var
  lvValue:TMsgPackValue;
begin
  if iVal>=0 then
    begin
    if iVal<=127 then
      begin
      lvValue.U8Val:=Byte(iVal);
      AStream.WriteBuffer(lvValue.U8Val,1);
      end
    else if iVal<=255 then//UInt8
      begin
      lvValue.ValueType:=$cc;
      lvValue.U8Val:=Byte(iVal);
      AStream.WriteBuffer(lvValue,2);
      end
    else if iVal<=65535 then
      begin
      lvValue.ValueType:=$cd;
      lvValue.BArray[0]:=(iVal shr 8);
      lvValue.BArray[1]:=(iVal and $FF);
      AStream.WriteBuffer(lvValue,3);
      end
    else if iVal<=Cardinal($FFFFFFFF) then
      begin
      lvValue.ValueType:=$ce;
      lvValue.BArray[0]:=(iVal shr 24) and $FF;
      lvValue.BArray[1]:=(iVal shr 16) and $FF;
      lvValue.BArray[2]:=(iVal shr 8) and $FF;
      lvValue.BArray[3]:=iVal and $FF;
      AStream.WriteBuffer(lvValue,5);
      end
    else
      begin
      lvValue.ValueType:=$cf;
      lvValue.BArray[0]:=(iVal shr 56) and $FF;
      lvValue.BArray[1]:=(iVal shr 48) and $FF;
      lvValue.BArray[2]:=(iVal shr 40) and $FF;
      lvValue.BArray[3]:=(iVal shr 32) and $FF;
      lvValue.BArray[4]:=(iVal shr 24) and $FF;
      lvValue.BArray[5]:=(iVal shr 16) and $FF;
      lvValue.BArray[6]:=(iVal shr 8) and $FF;
      lvValue.BArray[7]:=iVal and $FF;
      AStream.WriteBuffer(lvValue,9);
      end;
    end
  else//<0
    begin
    if iVal<=-2147483648 then//64λ
      begin
      lvValue.ValueType:=$d3;
      lvValue.BArray[0]:=(iVal shr 56) and $FF;
      lvValue.BArray[1]:=(iVal shr 48) and $FF;
      lvValue.BArray[2]:=(iVal shr 40) and $FF;
      lvValue.BArray[3]:=(iVal shr 32) and $FF;
      lvValue.BArray[4]:=(iVal shr 24) and $FF;
      lvValue.BArray[5]:=(iVal shr 16) and $FF;
      lvValue.BArray[6]:=(iVal shr 8) and $FF;
      lvValue.BArray[7]:=iVal and $FF;
      AStream.WriteBuffer(lvValue,9);
      end
    else if iVal<=-32768 then
      begin
      lvValue.ValueType:=$d2;
      lvValue.BArray[0]:=(iVal shr 24) and $FF;
      lvValue.BArray[1]:=(iVal shr 16) and $FF;
      lvValue.BArray[2]:=(iVal shr 8) and $FF;
      lvValue.BArray[3]:=iVal and $FF;
      AStream.WriteBuffer(lvValue,5);
      end
    else if iVal<=-128 then
      begin
      lvValue.ValueType:=$d1;
      lvValue.BArray[0]:=(iVal shr 8);
      lvValue.BArray[1]:=(iVal and $FF);
      AStream.WriteBuffer(lvValue,3);
      end
    else if iVal<-32 then
      begin
      lvValue.ValueType:=$d0;
      lvValue.I8Val:=iVal;
      AStream.WriteBuffer(lvValue,2);
      end
    else
      begin
      lvValue.I8Val:=iVal;
      AStream.Write(lvValue.I8Val,1);
      end;
    end;//End <0
end;

procedure WriteFloat(pvVal: Double; AStream: TStream);
var
  lvValue:TMsgPackValue;
begin
  lvValue.F64Val := swap(pvVal);
  lvValue.ValueType := $CB;
  AStream.WriteBuffer(lvValue, 9);
end;

procedure WriteSingle(pvVal: Single; AStream: TStream);
var
  lvValue:TMsgPackValue;
begin
  lvValue.F64Val := swap(pvVal);
  lvValue.ValueType := $CB;
  AStream.WriteBuffer(lvValue, 5);
end;

procedure WriteNull(pvStream:TStream);
var
  lvByte:Byte;
begin
  lvByte := $C0;
  pvStream.Write(lvByte, 1);
end;

procedure WriteBoolean(pvValue:Boolean; pvStream:TStream);
var
  lvByte:Byte;
begin
  if pvValue then lvByte := $C3 else lvByte := $C2;
  pvStream.Write(lvByte, 1);
end;


/// <summary>
///  copy from qmsgpack
/// </summary>
procedure writeArray(obj:TSimpleMsgPack; pvStream:TStream);
var
  c, i:Integer;
  lvValue:TMsgPackValue;
  lvNode:TSimpleMsgPack;
begin
  C:=obj.Count;

  if C <= 15 then
  begin
    lvValue.ValueType := $90 + C;
    pvStream.WriteBuffer(lvValue.ValueType, 1);
  end
  else if C <= 65535 then
  begin
    lvValue.ValueType := $DC;
    lvValue.BArray[0] := (C shr 8) and $FF;
    lvValue.BArray[1] := C and $FF;
    pvStream.WriteBuffer(lvValue, 3);
  end
  else
  begin
    lvValue.ValueType := $DD;
    lvValue.BArray[0] := (C shr 24) and $FF;
    lvValue.BArray[1] := (C shr 16) and $FF;
    lvValue.BArray[2] := (C shr 8) and $FF;
    lvValue.BArray[3] := C and $FF;
    pvStream.WriteBuffer(lvValue, 5);
  end;

  for I := 0 to C-1 do
  begin
    lvNode:=TSimpleMsgPack(obj.FChildren[I]);
    lvNode.InnerEncodeToStream(pvStream);
  end;
end;

procedure writeMap(obj:TSimpleMsgPack; pvStream:TStream);
var
  c, i:Integer;
  lvValue:TMsgPackValue;
  lvNode:TSimpleMsgPack;
begin
  C:=obj.Count;
  if C<=15 then
  begin
    lvValue.ValueType:=$80+C;
    pvStream.WriteBuffer(lvValue.ValueType,1);
  end
  else if C<=65535 then
  begin
    lvValue.ValueType:=$de;
    lvValue.BArray[0]:=(C shr 8) and $FF;
    lvValue.BArray[1]:=C and $FF;
    pvStream.WriteBuffer(lvValue,3);
  end
  else
  begin
    lvValue.ValueType:=$df;
    lvValue.BArray[0]:=(C shr 24) and $FF;
    lvValue.BArray[1]:=(C shr 16) and $FF;
    lvValue.BArray[2]:=(C shr 8) and $FF;
    lvValue.BArray[3]:=C and $FF;
    pvStream.WriteBuffer(lvValue,5);
  end;
  for I := 0 to C-1 do
  begin
    lvNode:=TSimpleMsgPack(obj.FChildren[I]);
    writeString(lvNode.FName, pvStream);
    lvNode.InnerEncodeToStream(pvStream);
  end;
end;

function EncodeDateTime(pvVal: TDateTime): string;
var
  AValue: TDateTime;
begin
  AValue := pvVal;
  if AValue - Trunc(AValue) = 0 then // Date
    Result := FormatDateTime('yyyy-MM-dd', AValue)
  else
  begin
    if Trunc(AValue) = 0 then
      Result := FormatDateTime('hh:nn:ss.zzz', AValue)
    else
      Result := FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', AValue);
  end;
end;


constructor TSimpleMsgPack.Create;
begin
  inherited Create;
  {$IFDEF UNICODE}
    FChildren := TObjectList<TSimpleMsgPack>.Create(true);
  {$ELSE}
    FChildren := TObjectList.Create(true);
  {$ENDIF}

end;

procedure TSimpleMsgPack.DecodeFromBytes(pvBytes: TBytes);
var
  lvStream:TStream;
begin
  lvStream := TMemoryStream.Create;
  try
    lvStream.Write(pvBytes[0], Length(pvBytes));
    lvStream.Position := 0;
    DecodeFromStream(lvStream);
  finally
    lvStream.Free;
  end;

end;

procedure TSimpleMsgPack.DecodeFromStream(pvStream: TStream);
begin
  InnerParseFromStream(pvStream);
end;

destructor TSimpleMsgPack.Destroy;
begin
  FChildren.Clear;
  FChildren.Free;
  FChildren := nil;
  inherited Destroy;
end;

function TSimpleMsgPack.Add(pvNameKey, pvValue: string): TSimpleMsgPack;
begin
  Result := InnerAdd;
  Result.setName(pvNameKey);
  Result.AsString := pvValue;
end;

function TSimpleMsgPack.Add(pvNameKey: string; pvValue: Int64): TSimpleMsgPack;
begin
  Result := InnerAdd;
  Result.setName(pvNameKey);
  Result.AsInteger := pvValue;
end;


function TSimpleMsgPack.Add: TSimpleMsgPack;
begin
  Result := InnerAdd;
end;

function TSimpleMsgPack.Add(pvNameKey: string; pvValue: TBytes): TSimpleMsgPack;
begin
  Result := InnerAdd;
  Result.setName(pvNameKey);
  Result.FDataType := mptBinary;
  Result.FValue := pvValue;
end;

function TSimpleMsgPack.Add(pvNameKey:String): TSimpleMsgPack;
begin
  Result := InnerAdd;
  Result.setName(pvNameKey);
end;

procedure TSimpleMsgPack.checkObjectDataType(ANewType: TMsgPackType = mptMap);
begin
  if not (FDataType in [mptMap]) then
  begin
    FDataType := ANewType;
  end;
end;

function TSimpleMsgPack.EncodeToBytes: TBytes;
var
  lvStream:TStream;
begin
  lvStream := TMemoryStream.Create;
  try
    EncodeToStream(lvStream);
    lvStream.Position := 0;
    SetLength(Result, lvStream.size);
    lvStream.Read(Result[0], lvStream.Size);
  finally
    lvStream.Free;
  end;
end;

procedure TSimpleMsgPack.EncodeToStream(pvStream: TStream);
begin
  InnerEncodeToStream(pvStream);
end;

function TSimpleMsgPack.findObj(pvName:string): TSimpleMsgPack;
var
  i:Integer;
begin
  i := indexOfCaseSensitive(pvName);
  if i <> -1 then
  begin
    Result := TSimpleMsgPack(FChildren[i]);
  end else
  begin
    Result := nil;
  end;
end;

function TSimpleMsgPack.ForcePathObject(pvPath:string): TSimpleMsgPack;
var
  lvName:string;
  s:string;
  sPtr:PChar;
  lvTempObj, lvParent:TSimpleMsgPack;
  j:Integer;
begin
  s := pvPath;

  lvParent := Self;
  sPtr := PChar(s);
  while sPtr^ <> #0 do
  begin
    lvName := getFirst(sPtr, ['.', '/','\']);
    if lvName = '' then
    begin
      Break;
    end else
    begin
      if sPtr^ = #0 then
      begin           // end
        j := lvParent.indexOf(lvName);
        if j <> -1 then
        begin
          Result := TSimpleMsgPack(lvParent.FChildren[j]);
        end else
        begin
          Result := lvParent.Add(lvName);
        end;
      end else
      begin
        // find childrean
        lvTempObj := lvParent.findObj(lvName);
        if lvTempObj = nil then
        begin
          lvParent := lvParent.Add(lvName);
        end else
        begin
          lvParent := lvTempObj;
        end;
      end;
    end;
    if sPtr^ = #0 then Break;
    Inc(sPtr);
  end;
end;

function TSimpleMsgPack.GetAsBoolean: Boolean;
begin
  if FDataType = mptBoolean then
    Result := PBoolean(FValue)^
  else if FDataType = mptString then
    Result := StrToBoolDef(AsString, False)
  else if FDataType = mptInteger then
    Result := (AsInteger <> 0)
  else if FDataType in [mptNull, mptUnknown] then
    Result := False
  else
    Result := False;

end;

function TSimpleMsgPack.GetAsDateTime: TDateTime;
begin
  if FDataType in [mptDateTime, mptFloat] then
    Result := PDouble(FValue)^
  else if FDataType = mptSingle then
    Result := PSingle(FValue)^
  else if FDataType = mptString then
  begin
    Result := StrToDateTimeDef(GetAsString, 0);
  end
  else if FDataType in [mptInteger] then
    Result := AsInteger
  else
    Result := 0;
end;

function TSimpleMsgPack.GetAsFloat: Double;
begin
  if FDataType in [mptFloat, mptDateTime] then
    Result := PDouble(FValue)^
  else if FDataType = mptSingle then
    Result := PSingle(FValue)^
  else if FDataType = mptBoolean then
    Result := Integer(AsBoolean)
  else if FDataType = mptString then
    Result := StrToFloatDef(AsString, 0)
  else if FDataType = mptInteger then
    Result := AsInteger
  else
    Result := 0;
end;

function TSimpleMsgPack.getAsInteger: Int64;
begin
  case FDataType of
    mptInteger: Result:=PInt64(FValue)^;
  else
    Result := 0;
  end;
end;

function TSimpleMsgPack.GetAsSingle: Single;
begin
  if FDataType in [mptFloat, mptDateTime] then
    Result := PDouble(FValue)^
  else if FDataType = mptSingle then
    Result := PSingle(FValue)^
  else if FDataType = mptBoolean then
    Result := Integer(AsBoolean)
  else if FDataType = mptString then
    Result := StrToFloatDef(AsString, 0)
  else if FDataType = mptInteger then
    Result := AsInteger
  else
    Result := 0;
end;

function TSimpleMsgPack.getAsString: String;
var
  l:Cardinal;
begin
  Result := '';
  if FDataType = mptString then
  begin
    l := Length(FValue);
    if l = 0 then
    begin
      Result := '';
    end else if SizeOf(Char) = 2 then
    begin
      SetLength(Result, l shr 1);
      Move(FValue[0],PChar(Result)^, l);
    end else
    begin
      SetLength(Result, l);
      Move(FValue[0],PChar(Result)^, l);
    end;
  end else
  begin
    case FDataType of
      mptUnknown, mptNull:
        Result := '';
      mptInteger:
        Result := IntToStr(AsInteger);
      mptBoolean:
        Result := BoolToStr(AsBoolean, True);
      mptFloat:
        Result := FloatToStrF(AsFloat, ffGeneral, 15, 0);
      mptSingle:
        Result := FloatToStrF(AsSingle, ffGeneral, 7, 0);
      mptBinary:
        Result := BinToHex(@FValue[0], Length(FValue), False);
      mptDateTime:
        Result := EncodeDateTime(AsDateTime);
//      mptArray:
//        Result := EncodeArray;
//      mptMap:
//        Result := EncodeMap;
//      mptExtended:
//        Result := EncodeExtended;
    else
       Result := '';
    end;
  end;
  //showMessage(Result);
end;

/// <summary>
///   copy from qdac3
/// </summary>
function TSimpleMsgPack.GetAsVariant: Variant;
var
  I: Integer;
  procedure BytesAsVariant;
  var
    L: Integer;
    p:PByte;
  begin
    L := Length(FValue);
    Result := VarArrayCreate([0, L - 1], varByte);
    p:=VarArrayLock(Result);
    Move(FValue[0],p^,L);
    VarArrayUnlock(Result);
  end;

begin
  case FDataType of
    mptString:
      Result := AsString;
    mptInteger:
      Result := AsInteger;
    mptFloat:
      Result := AsFloat;
    mptSingle:
      Result := AsSingle;
    mptDateTime:
      Result := AsDateTime;
    mptBoolean:
      Result := AsBoolean;
    mptArray, mptMap:
      begin
        Result := VarArrayCreate([0, Count - 1], varVariant);
        for I := 0 to Count - 1 do
          Result[I] := TSimpleMsgPack(FChildren[I]).AsVariant;
      end;
    mptBinary:
      BytesAsVariant;
  else
    raise Exception.Create(SVariantConvertNotSupport);
  end;
end;

function TSimpleMsgPack.GetB(pvPath: String): Boolean;
var
  lvObj:TSimpleMsgPack;
begin
  lvObj := GetO(pvPath);
  if lvObj = nil then
  begin
    Result := False;
  end else
  begin
    Result := lvObj.AsBoolean;
  end;
end;

function TSimpleMsgPack.GetCount: Integer;
begin
  Result := FChildren.Count;
end;

function TSimpleMsgPack.GetD(pvPath: String): Double;
var
  lvObj:TSimpleMsgPack;
begin
  lvObj := GetO(pvPath);
  if lvObj = nil then
  begin
    Result := 0;
  end else
  begin
    Result := lvObj.AsFloat;
  end;
end;

function TSimpleMsgPack.GetI(pvPath: String): Int64;
var
  lvObj:TSimpleMsgPack;
begin
  lvObj := GetO(pvPath);
  if lvObj = nil then
  begin
    Result := 0;
  end else
  begin
    Result := lvObj.AsInteger;
  end;
end;

function TSimpleMsgPack.GetItems(AIndex: Integer): TSimpleMsgPack;
begin
  Result := TSimpleMsgPack(FChildren[AIndex]);
end;

function TSimpleMsgPack.GetO(pvPath: String): TSimpleMsgPack;
var
  lvName:String;
  s:String;
  sPtr:PChar;
  lvTempObj:TSimpleMsgPack;
begin
  s := pvPath;

  Result := nil;
  lvTempObj := Self; 
  sPtr := PChar(s);
  while sPtr^ <> #0 do
  begin
    lvName := getFirst(sPtr, ['.', '/','\']);
    if lvName = '' then
    begin
      Break;
    end else
    begin
      // find childrean
      lvTempObj := lvTempObj.findObj(lvName);

      if lvTempObj = nil then
      begin
        Break;
      end else
      begin
        Result := lvTempObj;
      end;                  
    end;
    if sPtr^ = #0 then Break;
    Inc(sPtr);
  end;
end;

function TSimpleMsgPack.GetS(pvPath: String): string;
var
  lvObj:TSimpleMsgPack;
begin
  lvObj := GetO(pvPath);
  if lvObj = nil then
  begin
    Result := '';
  end else
  begin
    Result := lvObj.AsString;
  end;
end;

function TSimpleMsgPack.indexOf(pvName:string): Integer;
begin
  Result := indexOfIgnoreSensitive(LowerCase(pvName));
end;

function TSimpleMsgPack.indexOfCaseSensitive(pvName:string): Integer;
var
  i, l: Integer;
  lvObj:TSimpleMsgPack;
begin
  Result := -1;
  l := Length(pvName);
  if l = 0 then exit;
  for i := 0 to FChildren.Count-1 do
  begin
    lvObj := TSimpleMsgPack(FChildren[i]);
    if Length(lvObj.FName) = l then
    begin
      if lvObj.FName = pvName then
      begin
        Result := i;
        break;
      end;
    end;
  end;
end;

function TSimpleMsgPack.indexOfIgnoreSensitive(pvLowerCaseName: string):
    Integer;
var
  i, l: Integer;
  lvObj:TSimpleMsgPack;
begin
  Result := -1;
  l := Length(pvLowerCaseName);
  if l = 0 then exit;
  for i := 0 to FChildren.Count-1 do
  begin
    lvObj := TSimpleMsgPack(FChildren[i]);
    if Length(lvObj.FLowerName) = l then
    begin
      if lvObj.FLowerName = pvLowerCaseName then
      begin
        Result := i;
        break;
      end;
    end;
  end;
end;

function TSimpleMsgPack.InnerAdd: TSimpleMsgPack;
begin
  Result := TSimpleMsgPack.Create;
  Result.FDataType := mptUnknown;
  InnerAddToChildren(Result);
end;

procedure TSimpleMsgPack.InnerAddToChildren(obj: TSimpleMsgPack);
begin
  checkObjectDataType(mptMap);
  obj.FParent := self;
  FChildren.Add(obj);
end;

procedure TSimpleMsgPack.InnerEncodeToStream(pvStream:TStream);
begin
  case FDataType of
    mptUnknown, mptNull: WriteNull(pvStream);
    mptMap: writeMap(Self, pvStream);
    mptArray: writeArray(Self, pvStream);
    mptString: writeString(Self.getAsString, pvStream);
    mptInteger: WriteInt(self.getAsInteger, pvStream);
    mptBoolean: WriteBoolean(self.GetAsBoolean, pvStream);
    mptFloat: WriteFloat(GetAsFloat, pvStream);
    mptSingle: WriteSingle(GetAsSingle, pvStream);
    mptBinary: WriteBinary(PByte(@FValue[0]), Length(FValue), pvStream);
  end;
end;

procedure TSimpleMsgPack.InnerParseFromStream(pvStream: TStream);
var
  lvByte:Byte;
  lvBData: array[0..15] of Byte;
  lvAnsiStr:{$IFDEF UNICODE}TBytes{$ELSE}AnsiString{$ENDIF};
  lvBytes:TBytes;
  l, i:Cardinal;
  i64:Int64;
  lvObj:TSimpleMsgPack;
begin
  pvStream.Read(lvByte, 1);
  if lvByte <=$7F then   //positive fixint	0xxxxxxx	0x00 - 0x7f
  begin
    setAsInteger(lvByte);
  end else if lvByte <= $8f then //fixmap	1000xxxx	0x80 - 0x8f
  begin
    FDataType := mptMap;
    SetLength(FValue, 0);
    FChildren.Clear;
    l := lvByte - $80;

    for I := 0 to l - 1 do
    begin
      lvObj := InnerAdd;

      // map key
      lvObj.InnerParseFromStream(pvStream);
      lvObj.setName(lvObj.getAsString);

        // value
      lvObj.InnerParseFromStream(pvStream);
    end;
  end else if lvByte <= $9f then //fixarray	1001xxxx	0x90 - 0x9f
  begin
    FDataType := mptArray;
    SetLength(FValue, 0);
    FChildren.Clear;

    l := lvByte - $90;

    for I := 0 to l - 1 do
    begin
      lvObj := InnerAdd;
      // value
      lvObj.InnerParseFromStream(pvStream);
    end;
  end else if lvByte <= $bf then //fixstr	101xxxxx	0xa0 - 0xbf
  begin
    l := lvByte - $A0;   // str len
    if l > 0 then
    begin

      SetLength(lvAnsiStr, l);
      pvStream.Read(PByte(lvAnsiStr)^, l);
      setAsString(UTF8DecodeEx(lvAnsiStr, l));

//      SetLength(lvBytes, l + 1);
//      lvBytes[l] := 0;
//      pvStream.Read(lvBytes[0], l);
//      setAsString(UTF8Decode(PAnsiChar(@lvBytes[0])));
    end else
    begin
      setAsString('');
    end;
  end else
  begin
    case lvByte of
      $C0: // null
      begin
        FDataType := mptNull;
        SetLength(FValue, 0);
      end;
      $C2: // False
      begin
        SetAsBoolean(False);
      end;
      $C3: // True
      begin
        SetAsBoolean(True);
      end;
      $C4: // 短二进制，最长255字节
      begin
        FDataType := mptBinary;

        l := 0; // fill zero
        pvStream.Read(l, 1);

        SetLength(FValue, l);
        pvStream.Read(FValue[0], l);
      end;
      $C5: // 二进制，16位，最长65535B
      begin
        FDataType := mptBinary;

        l := 0; // fill zero
        pvStream.Read(l, 2);
        l := swap16(l);

        SetLength(FValue, l);
        pvStream.Read(FValue[0], l);
      end;
      $C6: // 二进制，32位，最长2^32-1
        begin
          FDataType := mptBinary;

          l := 0; // fill zero
          pvStream.Read(l, 4);
          l := swap32(l);

          SetLength(FValue, l);
          pvStream.Read(FValue[0], l);
        end;
      $ca: // float 32
        begin
          pvStream.Read(lvBData[0], 4);
          AsSingle := swap(PSingle(@lvBData[0])^);
        end;
      $cb: // Float 64
        begin
          pvStream.Read(lvBData[0], 8);
          AsSingle := swap(PDouble(@lvBData[0])^);
        end;
      $dc: // array 16
        begin
          //      +--------+--------+--------+~~~~~~~~~~~~~~~~~+
          //      |  0xdc  |YYYYYYYY|YYYYYYYY|    N objects    |
          //      +--------+--------+--------+~~~~~~~~~~~~~~~~~+
          FDataType := mptArray;
          SetLength(FValue, 0);
          FChildren.Clear;


          l := 0; // fill zero
          pvStream.Read(l, 2);

          l := swap16(l);

          for I := 0 to l - 1 do
          begin
            lvObj := InnerAdd;
            // value
            lvObj.InnerParseFromStream(pvStream);
          end;
        end;
      $dd: // Array 32
        begin
        //  +--------+--------+--------+--------+--------+~~~~~~~~~~~~~~~~~+
        //  |  0xdd  |ZZZZZZZZ|ZZZZZZZZ|ZZZZZZZZ|ZZZZZZZZ|    N objects    |
        //  +--------+--------+--------+--------+--------+~~~~~~~~~~~~~~~~~+
          FDataType := mptArray;
          SetLength(FValue, 0);
          FChildren.Clear;


          l := 0; // fill zero
          pvStream.Read(l, 4);

          l := swap32(l);

          for I := 0 to l - 1 do
          begin
            lvObj := InnerAdd;
            // value
            lvObj.InnerParseFromStream(pvStream);
          end;
        end;
      $d9:   //str 8 , 255
        begin
          //  str 8 stores a byte array whose length is upto (2^8)-1 bytes:
          //  +--------+--------+========+
          //  |  0xd9  |YYYYYYYY|  data  |
          //  +--------+--------+========+
          l := 0;
          pvStream.Read(l, 1);

          SetLength(lvAnsiStr, l);
          pvStream.Read(PByte(lvAnsiStr)^, l);
          setAsString(UTF8DecodeEx(lvAnsiStr, l));

  //        SetLength(lvBytes, l + 1);
  //        lvBytes[l] := 0;
  //        pvStream.Read(lvBytes[0], l);
  //        setAsString(UTF8Decode(PAnsiChar(@lvBytes[0])));
        end;
      $DE: // Object map 16
        begin
          //    +--------+--------+--------+~~~~~~~~~~~~~~~~~+
          //    |  0xde  |YYYYYYYY|YYYYYYYY|   N*2 objects   |
          //    +--------+--------+--------+~~~~~~~~~~~~~~~~~+
          FDataType := mptMap;
          SetLength(FValue, 0);
          FChildren.Clear;


          l := 0; // fill zero
          pvStream.Read(l, 2);
          l := swap16(l);

          for I := 0 to l - 1 do
          begin
            lvObj := InnerAdd;
            // map key
            lvObj.InnerParseFromStream(pvStream);
            lvObj.setName(lvObj.getAsString);

            // value
            lvObj.InnerParseFromStream(pvStream);
          end;
        end;
      $DF: //Object map 32
        begin
          //    +--------+--------+--------+--------+--------+~~~~~~~~~~~~~~~~~+
          //    |  0xdf  |ZZZZZZZZ|ZZZZZZZZ|ZZZZZZZZ|ZZZZZZZZ|   N*2 objects   |
          //    +--------+--------+--------+--------+--------+~~~~~~~~~~~~~~~~~+
          FDataType := mptMap;
          SetLength(FValue, 0);
          FChildren.Clear;


          l := 0; // fill zero
          pvStream.Read(l, 4);

          l := swap32(l);

          for I := 0 to l - 1 do
          begin
            lvObj := InnerAdd;
            
            // map key
            lvObj.InnerParseFromStream(pvStream);
            lvObj.setName(lvObj.getAsString);

            // value
            lvObj.InnerParseFromStream(pvStream);
          end;
        end;
      $da:    // str 16
        begin
          //      str 16 stores a byte array whose length is upto (2^16)-1 bytes:
          //      +--------+--------+--------+========+
          //      |  0xda  |ZZZZZZZZ|ZZZZZZZZ|  data  |
          //      +--------+--------+--------+========+

          l := 0; // fill zero
          pvStream.Read(l, 2);
          l := swap16(l);

          SetLength(lvAnsiStr, l);
          pvStream.Read(PByte(lvAnsiStr)^, l);
          setAsString(UTF8DecodeEx(lvAnsiStr, l));

  //        SetLength(lvBytes, l + 1);
  //        lvBytes[l] := 0;
  //        pvStream.Read(lvBytes[0], l);
  //        setAsString(UTF8Decode(PAnsiChar(@lvBytes[0])));
        end;
      $db:    // str 16
        begin
          //  str 32 stores a byte array whose length is upto (2^32)-1 bytes:
          //  +--------+--------+--------+--------+--------+========+
          //  |  0xdb  |AAAAAAAA|AAAAAAAA|AAAAAAAA|AAAAAAAA|  data  |
          //  +--------+--------+--------+--------+--------+========+

          l := 0; // fill zero
          pvStream.Read(l, 4);
          l := swap32(l);

          SetLength(lvAnsiStr, l);
          pvStream.Read(PByte(lvAnsiStr)^, l);
          setAsString(UTF8DecodeEx(lvAnsiStr, l));


  //        SetLength(lvBytes, l + 1);
  //        lvBytes[l] := 0;
  //        pvStream.Read(lvBytes[0], l);
  //        setAsString(UTF8Decode(PAnsiChar(@lvBytes[0])));
        end;
      $cc, $d0:   //uint 8, int 8
      begin
        //      uint 8 stores a 8-bit unsigned integer
        //      +--------+--------+
        //      |  0xcc  |ZZZZZZZZ|
        //      +--------+--------+
        //      int 8 stores a 8-bit signed integer
        //      +--------+--------+
        //      |  0xd0  |ZZZZZZZZ|
        //      +--------+--------+

        l := 0;
        pvStream.Read(l, 1);
        setAsInteger(l);
      end;
      $cd, $d1:
      begin
        //    uint 16 stores a 16-bit big-endian unsigned integer
        //    +--------+--------+--------+
        //    |  0xcd  |ZZZZZZZZ|ZZZZZZZZ|
        //    +--------+--------+--------+
        //
        //    int 16 stores a 16-bit big-endian signed integer
        //    +--------+--------+--------+
        //    |  0xd1  |ZZZZZZZZ|ZZZZZZZZ|
        //    +--------+--------+--------+

        l := 0;
        pvStream.Read(l, 2);
        l := swap16(l);
        setAsInteger(l);
      end;
    end;
  end;
end;

procedure TSimpleMsgPack.LoadBinaryFromFile(pvFileName:String);
var
  lvFileStream:TFileStream;
begin
  if FileExists(pvFileName) then
  begin
    lvFileStream := TFileStream.Create(pvFileName, fmOpenRead);
    try
      LoadBinaryFromStream(lvFileStream);
    finally
      lvFileStream.Free;
    end;
  end;                                   
end;

procedure TSimpleMsgPack.LoadBinaryFromStream(pvStream: TStream; pvLen:
    cardinal = 0);
begin
  FDataType := mptBinary;
  if pvLen = 0 then
  begin
    pvStream.Position := 0;
    SetLength(FValue, pvStream.Size);
    pvStream.Read(FValue[0], pvStream.Size);
  end else
  begin
    SetLength(FValue, pvLen);
    pvStream.ReadBuffer(FValue[0], pvLen);
  end;
end;

procedure TSimpleMsgPack.SaveBinaryToFile(pvFileName: String);
var
  lvFileStream:TFileStream;
begin
  if FileExists(pvFileName) then
  begin
    if not DeleteFile(PChar(pvFileName)) then
      RaiseLastOSError;
  end;
  lvFileStream := TFileStream.Create(pvFileName, fmCreate);
  try
    lvFileStream.WriteBuffer(FValue[0], Length(FValue));
  finally
    lvFileStream.Free;
  end;
end;

procedure TSimpleMsgPack.SaveBinaryToStream(pvStream: TStream);
begin
  pvStream.WriteBuffer(FValue[0], Length(FValue));
end;

procedure TSimpleMsgPack.SetAsBoolean(const Value: Boolean);
begin
  FDataType := mptBoolean;
  SetLength(FValue, 1);
  PBoolean(@FValue[0])^ := Value;
end;

procedure TSimpleMsgPack.SetAsDateTime(const Value: TDateTime);
begin
  FDataType := mptDateTime;
  SetLength(FValue, SizeOf(TDateTime));
  PDouble(@FValue[0])^ := Value;
end;

procedure TSimpleMsgPack.SetAsFloat(const Value: Double);
begin
  FDataType := mptFloat;
  SetLength(FValue, SizeOf(Double));
  PDouble(@FValue[0])^ := Value;
end;

procedure TSimpleMsgPack.setAsInteger(pvValue: Int64);
begin
  FDataType := mptInteger;
  SetLength(FValue, SizeOf(Int64));
  PInt64(@FValue[0])^ := pvValue;
end;

procedure TSimpleMsgPack.SetAsSingle(const Value: Single);
begin

end;

procedure TSimpleMsgPack.setAsString(pvValue: string);
begin
  FDataType := mptString;
  if SizeOf(Char) = 2 then
  begin
    SetLength(FValue, length(pvValue) shl 1);
    Move(PChar(pvValue)^, FValue[0], Length(FValue));
  end else
  begin
    SetLength(FValue, length(pvValue));
    Move(PChar(pvValue)^, FValue[0], Length(FValue));
  end;
end;

/// <summary>
///   copy from qdac3
/// </summary>
procedure TSimpleMsgPack.SetAsVariant(const Value: Variant);
var
  I: Integer;
  AType: TVarType;
  procedure VarAsBytes;
  var
    L: Integer;
    p: PByte;
  begin
    FDataType := mptBinary;
    L := VarArrayHighBound(Value, 1) + 1;
    SetLength(FValue, L);
    p := VarArrayLock(Value);
    Move(p^, FValue[0], L);
    VarArrayUnlock(Value);
  end;
begin
  if VarIsArray(Value) then
  begin
    AType := VarType(Value);
    if (AType and varTypeMask) = varByte then
      VarAsBytes
    else
    begin
      checkObjectDataType(mptArray);
      FChildren.Clear;
      for I := VarArrayLowBound(Value, VarArrayDimCount(Value))
        to VarArrayHighBound(Value, VarArrayDimCount(Value)) do
        Add.AsVariant := Value[I];
    end;
  end
  else
  begin
    case VarType(Value) of
      varSmallInt, varInteger, varByte, varShortInt, varWord,
        varLongWord, varInt64:
        AsInteger := Value;
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
        AsInteger := Value;
      {$IFEND}
    else
      raise Exception.Create(SVariantConvertNotSupport);
    end;
  end;
end;

procedure TSimpleMsgPack.SetB(pvPath: String; const Value: Boolean);
var
  lvObj:TSimpleMsgPack;
begin
  lvObj := ForcePathObject(pvPath);
  lvObj.AsBoolean := Value;
end;

procedure TSimpleMsgPack.SetD(pvPath: String; const Value: Double);
var
  lvObj:TSimpleMsgPack;
begin
  lvObj := ForcePathObject(pvPath);
  lvObj.AsFloat := Value;
end;

procedure TSimpleMsgPack.SetI(pvPath: String; const Value: Int64);
var
  lvObj:TSimpleMsgPack;
begin
  lvObj := ForcePathObject(pvPath);
  lvObj.AsInteger := Value;
end;

procedure TSimpleMsgPack.setName(pvName: string);
begin
  FName := pvName;
  FLowerName := LowerCase(FName);
end;

procedure TSimpleMsgPack.SetO(pvPath: String; const Value: TSimpleMsgPack);
var
  lvName:String;
  s:String;
  sPtr:PChar;
  lvTempObj, lvParent:TSimpleMsgPack;
  j:Integer;
begin
  s := pvPath;

  lvParent := Self;
  sPtr := PChar(s);
  while sPtr^ <> #0 do
  begin
    lvName := getFirst(sPtr, ['.', '/','\']);
    if lvName = '' then
    begin
      Break;
    end else
    begin
      if sPtr^ = #0 then
      begin           // end
        j := lvParent.indexOf(lvName);
        if j <> -1 then
        begin
          lvTempObj := TSimpleMsgPack(lvParent.FChildren[j]);
          lvParent.FChildren[j] := Value;
          lvTempObj.Free;  // free old
        end else
        begin
          Value.setName(lvName);
          lvParent.InnerAddToChildren(Value);
        end;
      end else
      begin
        // find childrean
        lvTempObj := lvParent.findObj(lvName);
        if lvTempObj = nil then
        begin
          lvParent := lvParent.Add(lvName);
        end else
        begin
          lvParent := lvTempObj;
        end;
      end;
    end;
    if sPtr^ = #0 then Break;
    Inc(sPtr);
  end;
end;

procedure TSimpleMsgPack.SetS(pvPath: String; const Value: string);
var
  lvObj:TSimpleMsgPack;
begin
  lvObj := ForcePathObject(pvPath);
  lvObj.AsString := Value;
end;



end.
