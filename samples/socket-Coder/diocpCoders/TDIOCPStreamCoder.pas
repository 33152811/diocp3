unit TDIOCPStreamCoder;

interface

uses
  uIocpCoder, uBuffer, Classes, SysUtils;

type
  TIOCPStreamDecoder = class(TIOCPDecoder)
  public
    /// <summary>
    ///   �����յ�������,����н��յ�����,���ø÷���,���н���
    /// </summary>
    /// <returns>
    ///   ���ؽ���õĶ���
    /// </returns>
    /// <param name="inBuf"> ���յ��������� </param>
    function Decode(const inBuf: TBufferLink): TObject; override;
  end;


  TIOCPStreamEncoder = class(TIOCPEncoder)
  public
    /// <summary>
    ///   ����Ҫ�����Ķ���
    /// </summary>
    /// <param name="pvDataObject"> Ҫ���б���Ķ��� </param>
    /// <param name="ouBuf"> ����õ����� </param>
    procedure Encode(pvDataObject:TObject; const ouBuf: TBufferLink); override;
  end;

implementation

uses
  uByteTools;

const
  PACK_FLAG = $D10;

  //PACK_FLAG  + STREAM_LEN + STREAM_DATA

  MAX_OBJECT_SIZE = 1024 * 1024 * 10;  //�������С 10M , ����10M �����Ϊ����İ���



function TIOCPStreamDecoder.Decode(const inBuf: TBufferLink): TObject;
begin
  ;
end;

{ TIOCPStreamEncoder }

procedure TIOCPStreamEncoder.Encode(pvDataObject: TObject;
  const ouBuf: TBufferLink);
var
  lvPACK_FLAG: WORD;
  lvDataLen, lvWriteIntValue: Integer;
  lvBuf: TBytes;
begin
  lvPACK_FLAG := PACK_FLAG;

  if TStream(pvDataObject).Size > MAX_OBJECT_SIZE then
  begin
    if lvDataLen > MAX_OBJECT_SIZE then
      raise Exception.CreateFmt('���ݰ�̫��,����ҵ���ֲ���,������ݰ�[%d]!', [MAX_OBJECT_SIZE]);
  end;

  //
  lvDataLen := MAX_OBJECT_SIZE;
  lvWriteIntValue := TByteTools.swap32(lvDataLen);

  //pack_flag
  ouBuf.AddBuffer(@lvPACK_FLAG, 2);

  // stream len
  ouBuf.AddBuffer(@lvWriteIntValue, SizeOf(lvWriteIntValue));

  SetLength(lvBuf, lvDataLen);
  TStream(pvDataObject).Read(lvBuf[0], lvDataLen);

  // stream
  ouBuf.AddBuffer(@lvBuf[0], lvDataLen);  
end;

end.
