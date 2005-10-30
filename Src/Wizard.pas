{
 Common stuff for any good programmer. ;-)

 version 2.50, 21/01/2000
  full DELPHI compatibility
  (don't forget to set DELPHI in conditional defines)
  global changes

 (q) by sergey korowkin aka sk // [rAN], 1999-2001.

 contact: 2:6033/27@fidonet, sk@fido.irk.ru, http://sk.elk.ru
}

{$IFDEF VIRTUALPASCAL}
{&Delphi+,CDecl-,Use32-}
{$ENDIF}
{$I-}

unit Wizard;
{$DEFINE DELPHI}
{$IFDEF DPMI}           {$DEFINE DOS}     {$ENDIF}
{$IFDEF MSDOS}          {$DEFINE DOS}     {$ENDIF}
{$IFDEF VIRTUALPASCAL}  {$DEFINE CODE32}  {$ENDIF}
{$IFDEF DELPHI}         {$DEFINE CODE32}
                        {.$DEFINE WIN32} //Unnecessary
                        {$DEFINE HUGEISON}{$ENDIF}

interface
uses
     {$IFDEF VIRTUALPASCAL}
     vpSysLow,
     Dos;
     {$ENDIF}

     {$IFDEF DELPHI}
     Windows,
     SysUtils;
     {$ENDIF}

     {$IFDEF DOS}
     Dos;
     {$ENDIF}

type
 TwCharSet = set of Char;

 {$IFDEF VIRTUALPASCAL}
 xWord = Longint;
 xInteger = Longint;
 {$ELSE}
 xWord = Word;
 xInteger = Integer;
 {$ENDIF}

{$IFDEF DELPHI}
type
 TextRec = TTextRec;

 SearchRec = TSearchRec;

var
 globDigitChar: char = ',';

var
 DosError: Longint;

{$HINTS OFF}
{$WARNINGS OFF}
const
 ReadOnly          = faReadOnly;
 Hidden            = faHidden;
 SysFile           = faSysFile;
 VolumeID          = faVolumeID;
 Directory         = faDirectory;
 Archive           = faArchive;
 AnyFile           = faAnyFile;

{$ENDIF}

var
 Replaced: Boolean; { True if Replace/ReplaceEx did anything }

const
 Months: Array[1..12] Of String[3] =
  ('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');

 PMonths: Array[1..12] Of PChar =
  ('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');
  
 Days: array[Boolean, 1..12] of Longint =
  ((31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31),
   (31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31));

const
 OSid = {$IFDEF DPMI}  '/DPMI' {$ENDIF}
        {$IFDEF WIN32} '/W32'  {$ENDIF}
        {$IFDEF OS2}   '/OS2'  {$ENDIF}
        {$IFDEF MSDOS} '/DOS'  {$ENDIF};

{ strings }

function  LeftPad(const S: String; const Len: Byte): String;
function  LeftPadCh(const S: String; const Ch: Char; const Len: Byte): String;
function  Pad(const S: String; const Len: Byte): String;
function  PadCh(const S: String; const Ch: Char; const Len: Byte): String;

function  Trim(S: String): String;
procedure TrimEx(var S: String);

function  ExtractWord(const N: Byte; const S: String; const WordDelims: TwCharSet): String;
function  WordCount(const S: String; const WordDelims: TwCharSet): Byte;

procedure RepackString(var S: String; const Delims: TwCharSet; const Divider: String);

{ numbers: hex }

function  HexW(const W: Word): String;
function  HexL(const L: Longint): String;

{ numbers to strings }

function  Long2Str(const L: Longint): String;
function  Long2StrFmt(const L: Longint): String;

{ strings to chars/numbers }

function  Size2KB(const Size: Longint): String;

{ files }

function  AddBackSlash(S: String): String;
function  ExistDir(const S: String): Boolean;
function  ExistFile(const S: String): Boolean;

function  JustFilename(const PathName: String): String;
function  JustFilenameOnly(const PathName: String): String;
function  JustPathname(const PathName: String): String;

function  RenameFile(const AFName, BFName: String): Boolean;

{ multiplatform stuff }

{$IFNDEF DELPHI}
function  GetAttr(const FName: String): Longint;
function  GetFileDate(const FName: String): Longint;
function  GetFileSize(const S: String): Longint;
function  GetStamp(const FName: String): Longint;
procedure SetAttr(const FName: String; K: Longint);
procedure SetStamp(const FName: String; K: Longint);
function  StackOverflow: Boolean;
{$ENDIF}

{$IFDEF DELPHI}
procedure wFindFirst(const Path: String; const Attrs: Integer; var SR: SearchRec);
procedure wFindClose(var SR: SearchRec);
{$ENDIF}

{$IFDEF DOS}
procedure wFindClose(var SR: SearchRec);
procedure SetLength(var S: String; const NewLength: Byte);
{$ENDIF}

implementation

const
 DosDelimSet    : set of Char           = ['\', ':', #0];
 Digits         : array[0..$F] of Char  = '0123456789ABCDEF';

var
 ValL: xInteger;

type
 Long = record
  LowWord, HighWord: System.Word;
 end;

 DateTimeRec = record
  FTime, FDate: System.Word;
 end;

{$IFNDEF CODE32}
 PTextBuffer = ^TTextBuffer;
 TTextBuffer = array[0..65520] of Byte;
 TText = record
  Handle: Word;
  Mode: Word;
  BufSize: Word;
  Priv: Word;
  BufPos: Word;
  BufEnd: Word;
  BufPtr: PTextBuffer;
  OpenProc: Pointer;
  InOutProc: Pointer;
  FlushProc: Pointer;
  CloseProc: Pointer;
  UserData: array[1..16] of Byte;
  Name: array[0..79] of Char;
  Buffer: array[0..127] of Char;
 end;

const
 FMClosed      = $D7B0;
 FMInput       = $D7B1;
 FMOutput      = $D7B2;
 FMInOut       = $D7B3;
{$ENDIF}


function LeftPad(const S: String; const Len: Byte): String;
 begin
  LeftPad := LeftPadCh(S, ' ', Len);
 end;

function LeftPadCh(const S: String; const Ch: Char; const Len: Byte): String;
 {$IFDEF DOS}
 var
  Result: String;
 {$ENDIF}
 begin
  if Length(S) >= Len then
   Result := S
  else
   if Length(S) < 255 then
    begin
     SetLength(Result, Len);
     Move(S[1], Result[Succ(Word(Len)) - Length(S)], Length(S));
     FillChar(Result[1], Len - Length(S), Ch);
    end;

  {$IFDEF DOS}
  LeftPadCh := Result;
  {$ENDIF}
 end;

function Pad(const S: String; const Len: Byte): String;
 begin
   Pad := PadCh(S, ' ', Len);
 end;

function PadCh(const S: String; const Ch: Char; const Len: Byte): String;
 {$IFDEF DOS}
 var
  Result: String;
 {$ENDIF}
 begin
  if Length(S) >= Len then
   Result := S
  else
   begin
    SetLength(Result, Len);
    Move(S[1], Result[1], Length(S));
    if Length(S) < 255 then
     FillChar(Result[Succ(Length(S))], Len - Length(S), Ch);
   end;

  {$IFDEF DOS}
  PadCh := Result;
  {$ENDIF}
 end;

function Trim(S: String): String;
 begin
  TrimEx(S);
  Trim := S;
 end;

procedure TrimEx(var S: String);
 var
  K, L: Byte;
 begin
  K := 1;

  while (K <= Length(S)) and (S[K] = ' ') do
   Inc(K);

  L := Length(S);

  while (L <> 0) and (S[L] = ' ') do
   Dec(L);

  Inc(L);
  Dec(L, K);

  S := Copy(S, K, L);
 end;

function ExtractWord(const N: Byte; const S: String; const WordDelims: TwCharSet): String;
var
   I: Word;
   Count,
   Len: Word;
  {$IFDEF DOS}
   Result: String;
  {$ENDIF}
begin
   Count := 0;
   I := 1;
   Len := 0;
   Result := '';

   while (I <= Length(S)) and (Count <> N) do begin
      while (I <= Length(S)) and (S[I] in WordDelims) do Inc(I);
      if I <= Length(S) then Inc(Count);
      while (I <= Length(S)) and not (S[I] in WordDelims) do begin
         if Count = N then begin
            Inc(Len);
            SetLength(Result, Len);
            Result[Len] := S[I];
         end;
         Inc(I);
      end;
   end;

  {$IFDEF DOS}
   ExtractWord := Result;
  {$ENDIF}
 end;

function WordCount(const S: String; const WordDelims: TwCharSet): Byte;
 var
  Count, I: Word;
 begin
  Count := 0;
  I := 1;

  while I <= Length(S) do
   begin
    while (I <= Length(S)) and (S[I] in WordDelims) do
     Inc(I);

    if I <= Length(S) then
     Inc(Count);

    while (I <= Length(S)) and not (S[I] in WordDelims) do
     Inc(I);
   end;

  WordCount := Count;
 end;

procedure RepackString(var S: String; const Delims: TwCharSet; const Divider: String);
 var
  R: String;
  K: Integer;
 begin
  R := ExtractWord(1, S, Delims);

  for K := 2 to WordCount(S, Delims) do
   R := Concat(R, Divider, ExtractWord(K, S, Delims));

  S := R;
 end;

function HexW(const W: Word): String;
 begin
  HexW := Digits[Hi(W) shr 4] +
          Digits[Hi(W) and $F] +
          Digits[Lo(W) shr 4] +
          Digits[Lo(W) and $F];
 end;

function HexL(const L: Longint): String;
 begin
  with Long(L) do
   HexL := HexW(HighWord) + HexW(LowWord);
 end;

{ numbers to strings }

function MakeFmt(const R: String): String;
 var
  K, L: Byte;
  Minus: Boolean;
  {$IFDEF DOS}
  Result: String;
  {$ENDIF}
 begin
  Result := '';

  L := 0;

  for K := Length(R) downto 1 do
   begin
    Result := R[K] + Result;

    Inc(L);

    if L = 3 then
     begin
      Result := globDigitChar + Result;
      L := 0;
     end;
   end;

  Minus := Copy(Result, 1, 1) = '-';

  if Minus then
   Delete(Result, 1, 1);

  while Copy(Result, 1, 1) = ',' do
   Delete(Result, 1, 1);

  if Minus then
   Result := '-' + Result;

  {$IFDEF DOS}
  MakeFmt := Result;
  {$ENDIF}
 end;

function Long2Str(const L: Longint): String;
 {$IFDEF DOS}
 var
  Result: String;
 {$ENDIF}
 begin
  Str(L, Result);

  {$IFDEF DOS}
  Long2Str := Result;
  {$ENDIF}
 end;

function Long2StrFmt(const L: Longint): String;
 begin
  Long2StrFmt := MakeFmt(Long2Str(L));
 end;

function Size2KB(const Size: Longint): String;
 {$IFDEF DOS}
var
   Result: String;
 {$ENDIF}
begin
   Str((Size / 1024):1:1, Result);

   if Copy(Result, Length(Result) - 1, 2) = '.0' then SetLength(Result, Length(Result) - 2);

   Result := Concat(Result, 'kb');

 {$IFDEF DOS}
   Size2KB := Result;
 {$ENDIF}
end;

{ files }

function AddBackSlash(S: String): String;
 begin
  if Length(S) <> 0 then
   if S[Length(S)] <> '\' then
    S := S + '\';

  AddBackSlash := S;
 end;

function ExistDir(const S: String): Boolean;
 var
  SR: SearchRec;
 begin
  wFindFirst(AddBackSlash(S) + '*.*', AnyFile, SR);

  ExistDir := DosError = 0;

  wFindClose(SR);
 end;

function ExistFile(const S: String): Boolean;
begin
   Result := FileExists(S);
end;

function JustFilename(const PathName: String): String;
 var
  I: Word;
 begin
  JustFileName := '';
  if PathName = '' then exit;

  I := Succ(Word(Length(PathName)));

  repeat
   Dec(I);
  until (PathName[I] in DosDelimSet) or (I = 0);

  JustFilename := Copy(PathName, Succ(I), 64);
 end;

function JustFilenameOnly(const PathName: String): String;
 var
  I: Integer;
  S: String;
 begin

  S := JustFilename(PathName);
  I := Length(S);

  while (I <> 0) and (S[I] <> '.') do
   Dec(I);

  if I <= 1 then
   JustFileNameOnly := ''
  else
   JustFilenameOnly := Copy(S, 1, I - 1);;
 end;

function JustPathname(const PathName: String): String;
 var
  I: Word;
 begin
  JustPathName := '';
  if PathName = '' then exit;

  I := Succ(Word(Length(PathName)));

  repeat
   Dec(I);
  until (PathName[I] in DosDelimSet) or (I = 0);

  if I = 0 then
   JustPathname := ''
  else
   if I = 1 then
    JustPathname := PathName[1]
   else
    if PathName[I] = '\' then
     if PathName[Pred(I)] = ':' then
      JustPathname := Copy(PathName, 1, I)
     else
      JustPathname := Copy(PathName, 1, Pred(I))
    else
     JustPathname := Copy(PathName, 1, I);
 end;

function RenameFile(const AFName, BFName: String): Boolean;
 var
  F: Text;
 begin
  if IOResult <> 0 then;

  Assign(F, AFName);
  Rename(F, BFName);

  RenameFile := IOResult = 0;
 end;

{ misc }

{$IFDEF DELPHI}
procedure wFindFirst(const Path: String; const Attrs: Integer; var SR: SearchRec);
 begin
  DosError := SysUtils.FindFirst(Path, Attrs, SR);
 end;

procedure wFindClose(var SR: SearchRec);
 begin
  SysUtils.FindClose(SR);
 end;
{$ENDIF}

end.
