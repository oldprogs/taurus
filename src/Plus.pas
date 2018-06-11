unit Plus;

interface

uses windows, classes, xbase;

procedure PrepareVariables;
function  Win2Dos(const WinStr: string): string;
function  Dos2Win(const DosStr: string): string;
function  FileNameDos2Win(const FileName: string; convert: boolean): string;
function  FileNameWin2Dos(const FileName: string; convert: boolean): string;

function  ShortFileName(const LongName: string):string;
procedure UnPrepareVariables;

function GetFileSize(const FileName: string): Int64;
function GetFileTime(const FileName: string): DWORD;
function GetDirSize(const FileName: string): Int64;
function GetDirTime(const FileName: string): Integer;
function GetFileList(const Dir, nam: string): TStringColl;

implementation

uses sysutils;

const
  MBsize = 1024 * 1024;

var
  plusSrcStr, plusDestStr, plusLongFileName, plusShortFileName: PChar;

function GetFileSize;
var
   Handle: THandle;
   FindData: TWin32FindData;
begin
   Handle := FindFirstFile(PChar(FileName), FindData);
   if Handle <> INVALID_HANDLE_VALUE then begin
      Windows.FindClose(Handle);
      if (FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = 0 then begin
         Int64Rec(Result).Lo := FindData.nFileSizeLow;
         Int64Rec(Result).Hi := FindData.nFileSizeHigh;
         Exit;
      end;
   end;
   Result := -1;
end;

function GetFileTime;
var
   SR: TuFindData;
begin
   SR.Info.Time := 0;
   if uFindFirst(FileName, SR) then begin
      Result := SR.Info.Time;
      uFindClose(SR);
   end;
end;

function GetDirSize;
var
  Handle: THandle;
  FindData: TWin32FindData;
begin
  Handle := FindFirstFile(PChar(FileName), FindData);
  if Handle <> INVALID_HANDLE_VALUE then begin
    Windows.FindClose(Handle);
    if (FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) <> 0 then
    begin
      Int64Rec(Result).Lo := FindData.nFileSizeLow;
      Int64Rec(Result).Hi := FindData.nFileSizeHigh;
      Exit;
    end;
  end;
  Result := -1;
end;

function GetDirTime;
var
  Handle: THandle;
  FindData: TWin32FindData;
  LT: TFileTime;
begin
  Handle := FindFirstFile(PChar(FileName), FindData);
  if Handle <> INVALID_HANDLE_VALUE then begin
    Windows.FindClose(Handle);
    if (FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) <> 0 then
    begin
       FileTimeToLocalFileTime(FindData.ftLastWriteTime, LT);
       if FileTimeToDosDateTime(LT, LongRec(Result).Hi, LongRec(Result).Lo) then Exit;
      Exit;
    end;
  end;
  Result := -1;
end;

procedure PrepareVariables;
begin
  plusSrcStr := StrAlloc(MAX_PATH);
  plusDestStr := StrAlloc(MAX_PATH);
  plusLongFileName := StrAlloc(MAX_PATH);
  plusShortFileName := StrAlloc(MAX_PATH);
end;

procedure UnPrepareVariables;
begin
  StrDispose(plusSrcStr);
  StrDispose(plusDestStr);
  StrDispose(plusLongFileName);
  StrDispose(plusShortFileName);
end;

function Win2Dos;
begin
  StrPCopy(plusSrcStr, WinStr);
  CharToOEM(plusSrcStr, plusDestStr);
  Win2Dos := plusDestStr;
end;

function Dos2Win;
begin
  StrPCopy(plusSrcStr, DosStr);
  OEMToChar(plusSrcStr, plusDestStr);
  Dos2Win := plusDestStr;
end;

function FileNameDos2Win;
begin
  if not (convert) then
     result := FileName
  else
     result := Dos2Win(FileName);
end;

function FileNameWin2Dos;
begin
  if not (convert) then
     result := FileName
  else
     result := Win2Dos(FileName);
end;

{based on function LongToShortFileName from RxLibrary}
function ShortFileName;
var
  Temp: TWin32FindData;
  SearchHandle: THandle;
  Name,
  Ext: string;
  ExtPos: integer;
  i: integer;
begin
  Result := LongName;

  SearchHandle := FindFirstFile(PChar(LongName), Temp);
  if SearchHandle <> INVALID_HANDLE_VALUE then begin
     Result := string(Temp.cAlternateFileName);
     if Result = '' then Result := string(Temp.cFileName);
  end;
  Windows.FindClose(SearchHandle);

  if length(Result) > 12 then begin
     Name := ExtractFileName(Result);
     Ext := ExtractFileExt(Result);
     ExtPos := pos(Ext, Name);
     if ExtPos > 9 then ExtPos := 9;
     Name := copy(Name, 1, ExtPos - 1);
     Ext := copy(Ext, 2, 3);
     result := Name + '.' + Ext;
  end;

  for i := 1 to length(result) do
     if (result[i] <= ' ') then result[i] := '_';
end;

function  GetFileList(const dir, nam: string): TStringColl;
var
   Srch: TWin32FindData;
   flag: Integer;
   succ: boolean;
   path: string;
begin
   Result := TStringColl.Create(nam);
   path := dir;
   if (path[Length(path)] <> '\') and
      (path[Length(path)] <> '*') then path := path + '\*.*';
   flag := FindFirstFile(PChar(path), Srch);
   succ := flag <> 0;
   while succ do begin
      if Srch.cFileName[0] <> '.' then begin
         Result.Add(Srch.cFileName);
      end;
      succ := FindNextFile(Flag, Srch);
   end;
   Windows.FindClose(Flag);
end;

begin

end.
