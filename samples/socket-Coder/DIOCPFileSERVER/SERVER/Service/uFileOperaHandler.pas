unit uFileOperaHandler;
                              
interface

uses
  SimpleMsgPack, SysUtils, Windows, Classes, Math, uCRCTools,
  superobject, uZipTools;

type
  TFileOperaHandler = class(TObject)
  private
    class function getBasePath():String;
    class procedure forceDirectoryOfFile(pvFile:String);
    class function extractServerFileName(pvDataObject: TSimpleMsgPack):String;
    class procedure pathWithoutBackslash(var vPath: String);
  private
    class function BigFileSize(const AFileName: string): Int64;

    class procedure writeFileINfo(pvINfo: TSimpleMsgPack; const AFileName: string);

    /// <summary>TFileOperaHandler.FileRename
    /// </summary>
    /// <returns> Boolean
    /// </returns>
    /// <param name="pvSrcFile"> �����ļ��� </param>
    /// <param name="pvNewFileName"> ����·���ļ��� </param>
    class function FileRename(pvSrcFile:String; pvNewFileName:string): Boolean;

    class procedure downFileData(pvDataObject:TSimpleMsgPack);

    class procedure uploadFileData(pvDataObject:TSimpleMsgPack);

    /// <summary>
    ///   ����һ���ļ�
    ///  {
    ///      "catalog":"doc",
    ///      "fileName":"dev\a.doc",    //Դ�ļ�
    ///      "newFile":"dev\b.doc"      //���ļ�
    ///  }
    /// </summary>
    class procedure executeCopyAFile(pvDataObject:TSimpleMsgPack);

    //��ȡ�ļ���Ϣ
    class procedure readFileINfo(pvDataObject:TSimpleMsgPack);

    //ɾ���ļ�
    class procedure FileDelete(pvDataObject:TSimpleMsgPack);
  public
    class procedure Execute(pvDataObject: TSimpleMsgPack);
  end;

implementation

{ TFTPWrapper_ProgressBar }

class function TFileOperaHandler.BigFileSize(const AFileName: string): Int64;
var
  sr: TSearchRec;
begin
  try
    if SysUtils.FindFirst(AFileName, faAnyFile, sr) = 0 then
      result := Int64(sr.FindData.nFileSizeHigh) shl Int64(32) + Int64(sr.FindData.nFileSizeLow)
    else
      result := -1;
  finally
    SysUtils.FindClose(sr);
  end;
end;

class procedure TFileOperaHandler.Execute(pvDataObject: TSimpleMsgPack);
var
  lvCMDIndex:Integer;
begin
  lvCMDIndex := pvDataObject.ForcePathObject('cmd.index').AsInteger;
  case lvCMDIndex of
    1:       // �����ļ�
      begin
        downFileData(pvDataObject);
      end;
    2:       //�ϴ��ļ�
      begin
        uploadFileData(pvDataObject);

        // ɾ���ļ�����
        pvDataObject.DeleteObject('data');
      end;
    3:      //��ȡ�ļ���Ϣ
      begin
        readFileINfo(pvDataObject);
      end;
    4:       //ɾ��
      begin
        FileDelete(pvDataObject);
      end;
    5:       // copyһ���ļ�
      begin
        executeCopyAFile(pvDataObject);
      end;
  end;  
end;

class function TFileOperaHandler.extractServerFileName(pvDataObject: TSimpleMsgPack): String;
var
  lvPath, lvTempStr:String;
begin
  Result := pvDataObject.S['fileName'];
  if pvDataObject.S['catalog'] <> '' then
  begin
    lvTempStr := pvDataObject.S['catalog'];
    pathWithoutBackslash(lvPath);
    Result := lvTempStr + '\' + Result;
  end;
  lvPath := getBasePath;
  pathWithoutBackslash(lvPath);
  Result := lvPath + '\' + Result;
end;

class procedure TFileOperaHandler.FileDelete(pvDataObject: TSimpleMsgPack);
var
  lvFileName, lvRealFileName:String;
  lvCrc, lvSize:Cardinal;
begin
  lvFileName:= extractServerFileName(pvDataObject);
  if not FileExists(lvFileName) then
    raise Exception.CreateFmt('(%s)�ļ�������!', [pvDataObject.S['fileName']]);
  SysUtils.DeleteFile(lvFileName);

  if FileExists(lvFileName) then
  begin
    raise Exception.Create('�ļ�ɾ��ʧ��!');
  end;
end;

class function TFileOperaHandler.FileRename(pvSrcFile:String;
    pvNewFileName:string): Boolean;
var
  lvNewFile:String;
begin
  lvNewFile := ExtractFilePath(pvSrcFile) + ExtractFileName(pvNewFileName);
  Result := MoveFile(pchar(pvSrcFile), pchar(lvNewFile));
end;

class procedure TFileOperaHandler.forceDirectoryOfFile(pvFile: String);
var
  lvPath:String;
  lvLen:Integer;
begin
  lvPath := ExtractFilePath(pvFile);
  pathWithoutBackslash(lvPath);
  
  ForceDirectories(lvPath);
end;

class function TFileOperaHandler.getBasePath: String;
begin
  Result := ExtractFilePath(ParamStr(0)) + 'files\';
end;

class procedure TFileOperaHandler.pathWithoutBackslash(var vPath: String);
var
  lvLen:Integer;
begin
  while True do
  begin
    lvLen := Length(vPath);
    if lvLen = 0 then Break;
    if vPath[lvLen] in ['/', '\'] then Delete(vPath, lvLen, 1) else
    begin
      Break;
    end;
  end;
end;

class procedure TFileOperaHandler.readFileINfo(pvDataObject: TSimpleMsgPack);
const
  SEC_SIZE = 1024 * 4;
var
  lvFileStream:TFileStream;
  lvFileName, lvRealFileName:String;
  lvCrc, lvSize:Cardinal;
  lvINfo:TSimpleMsgPack;
begin
  lvFileName := extractServerFileName(pvDataObject);

  pvDataObject.DeleteObject('info');

  if not FileExists(lvFileName) then
  begin
    pvDataObject.I['info.exists'] := -1;  //������

    exit;
  end else
  begin
    lvINfo := pvDataObject.ForcePathObject('info');
    writeFileINfo(lvINfo, lvFileName);             
  end;
end;

class procedure TFileOperaHandler.executeCopyAFile(pvDataObject:TSimpleMsgPack);
var
  lvFileName, lvNewFile:String;
  lvPath, lvTempStr:String;
begin
  lvFileName := pvDataObject.S['fileName'];
  lvNewFile := pvDataObject.S['newFile'];
  if pvDataObject.S['catalog'] <> '' then
  begin
    lvTempStr := pvDataObject.S['catalog'];
    pathWithoutBackslash(lvPath);
    lvFileName := lvTempStr + '\' + lvFileName;
    lvNewFile := lvTempStr + '\' + lvNewFile;
  end;
  lvPath := getBasePath;
  pathWithoutBackslash(lvPath);
  lvFileName := lvPath + '\' + lvFileName;
  lvNewFile := lvPath + '\' + lvNewFile;

  if not FileExists(lvFileName) then raise Exception.CreateFmt('(%s)�ļ�������!', [pvDataObject.S['fileName']]);


  if not Windows.CopyFile(PAnsiChar(AnsiString(lvFileName)),
     PAnsiChar(AnsiString(lvNewFile)), False)  then
  begin
    RaiseLastOSError;
  end;               
end;

class procedure TFileOperaHandler.downFileData(pvDataObject:TSimpleMsgPack);
const
  SEC_SIZE = 1024 * 4;  //4K
var
  lvFileStream:TFileStream;
  lvFileName, lvRealFileName:String;
  lvSize:Cardinal;
begin
  lvFileName:= extractServerFileName(pvDataObject);

  if not FileExists(lvFileName) then raise Exception.CreateFmt('(%s)�ļ�������!', [pvDataObject.S['fileName']]);


  lvFileStream := TFileStream.Create(lvFileName, fmOpenRead or fmShareDenyWrite);
  try
    lvFileStream.Position := pvDataObject.I['start'];
    pvDataObject.Clear();
    pvDataObject.I['fileSize'] := lvFileStream.Size;
    lvSize := Min(SEC_SIZE, lvFileStream.Size-lvFileStream.Position);
    
    // �ļ�����
    pvDataObject.ForcePathObject('data').LoadBinaryFromStream(lvFileStream, lvSize);
    
    pvDataObject.I['blockSize'] := lvSize;
  finally
    lvFileStream.Free;
  end;
end;

class procedure TFileOperaHandler.uploadFileData(pvDataObject:TSimpleMsgPack);
var
  lvFileStream:TFileStream;
  lvFileName, lvRealFileName:String;
  lvCrc:Cardinal;
begin
  lvFileName:= extractServerFileName(pvDataObject);

  // ��һ�δ���
  if pvDataObject.I['start'] = 0 then
  begin
    // ɾ��ԭ���ļ�
    if FileExists(lvFileName) then SysUtils.DeleteFile(lvFileName);
  end;

  lvRealFileName := lvFileName;

  forceDirectoryOfFile(lvRealFileName);

  lvFileName := lvFileName + '.temp';



  if pvDataObject.I['start'] = 0 then
  begin    // ��һ���� ɾ����ʱ�ļ�
    if FileExists(lvFileName) then SysUtils.DeleteFile(lvFileName);
  end;

  if FileExists(lvFileName) then
  begin
    lvFileStream := TFileStream.Create(lvFileName, fmOpenReadWrite);
  end else
  begin
    lvFileStream :=  TFileStream.Create(lvFileName, fmCreate);
  end;
  try
    lvFileStream.Position := pvDataObject.I['start'];
    
    pvDataObject.ForcePathObject('data').SaveBinaryToStream(lvFileStream);

  finally
    lvFileStream.Free;
  end;

  if pvDataObject.B['eof'] then
  begin
    FileRename(lvFileName, lvRealFileName);
  end;
end;

class procedure TFileOperaHandler.writeFileINfo(pvINfo: TSimpleMsgPack; const
    AFileName: string);
var
  lvFileStream:TFileStream;
begin
  if FileExists(AFileName) then
  begin
    lvFileStream := TFileStream.Create(AFileName, fmOpenRead);
    try
      pvINfo.I['size'] := lvFileStream.Size;

      pvINfo.I['checksum'] := TZipTools.verifyStream(lvFileStream, 0);
      
    finally
      lvFileStream.Free;
    end;
  end;
end;

end.
