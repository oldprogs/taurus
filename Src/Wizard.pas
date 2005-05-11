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
function  Center(const S: String; const Width: Byte): String;
function  CenterCh(const S: String; const Ch: Char; const Width: Byte): String;
function  Pad(const S: String; const Len: Byte): String;
function  PadCh(const S: String; const Ch: Char; const Len: Byte): String;

function  LTrim(const S: String): String;
function  Trim(S: String): String;
procedure TrimEx(var S: String);
function  RTrim(const S: String): String;

function  ExtractWord(const N: Byte; const S: String; const WordDelims: TwCharSet): String;
function  WordCount(const S: String; const WordDelims: TwCharSet): Byte;

function  GetAllAfterChar(const S: String; const Spc: Byte; const Ch: Char): String;
function  GetAllAfterSpace(const S: String; const Spc: Byte): String;

procedure FixTabs(var S: String);
procedure RepackString(var S: String; const Delims: TwCharSet; const Divider: String);

{ pstrings }

function  GetPString(const S: Pointer): String;
procedure GetPStringEx(const S: Pointer; var R: String);

{ numbers: hex }

function  HexB(const B: Byte): String;
function  HexT(const W: Word): String;
function  HexW(const W: Word): String;
function  HexL(const L: Longint): String;
function  HexPtr(const P: Pointer): String;

{ numbers to strings }

function  Long2Str(const L: Longint): String;
function  Long2StrFmt(const L: Longint): String;
function  Real2Str(const R: Real; const Width, Decimals: Byte): String;

function  lz(const Number: Longint): String;

{ strings to chars/numbers }

function  Str2Char(const S: String): Char;
function  Str2Number(const S: String): Boolean;
function  Str2Byte(const S: String; var A: Byte): Boolean;
function  Str2Integer(const S: String; var A: Integer): Boolean;
function  Str2Word(const S: String; var A: Word): Boolean;
function  Str2xWord(const S: String; var A: xWord): Boolean;
function  Str2Longint(const S: String; var A: Longint): Boolean;
function  Size2KB(const Size: Longint): String;

{ files }

function  AddBackSlash(S: String): String;
function  RemoveBackSlash(S: String): String;
function  ExistDir(const S: String): Boolean;
function  ExistFile(const S: String): Boolean;
function  FExpand(const S: String): String;

function  HasExtension(const Name: String; var DotPos: Word): Boolean;
function  ForceExtension(const Name, Ext: String): String;
function  JustExtension(const Name: String): String;
function  JustFilename(const PathName: String): String;
function  JustFilenameOnly(const PathName: String): String;
function  JustPathname(const PathName: String): String;

function  TextSeek(var F: Text; const Target: Longint): Boolean;
function  TextFileSize(var F: Text) : Longint;
function  TextPos(var F: Text): Longint;

function  FileLocked(const FName: String): Boolean;
function  EraseFile(const FName: String): Boolean;
function  RenameFile(const AFName, BFName: String): Boolean;

{ time & date }

function  Clock: Longint;
procedure Wait(const ms: Longint);
function  DayOfWeek(const Year, Month, Day: Longint): Word;

{ wildcards }

function  CheckWildcard(const Src, Mask: String): Boolean;
function  IsWildcard(const Mask: String): Boolean;

{ misc }

function  GetBinkDateTime: String;

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
procedure GetDate(var Year, Month, Day, Dow: Word);
procedure GetTime(var Hour, Min, Sec, Sec100: Word);
procedure wFindFirst(const Path: String; const Attrs: Integer; var SR: SearchRec);
procedure wFindNext(var SR: SearchRec);
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

function Center(const S: String; const Width: Byte): String;
 begin
  Center := CenterCh(S, ' ', Width);
 end;

function CenterCh(const S: String; const Ch: Char; const Width: Byte): String;
 {$IFDEF DOS}
 var
  Result: String;
 {$ENDIF}
 begin
  if Length(S) >= Width then
   Result := S
  else
   if Length(S) < 255 then
    begin
     SetLength(Result, Width);
     FillChar(Result[1], Width, Ch);
     Move(S[1], Result[Succ((Width - Length(S)) shr 1)], Length(S));
    end;

  {$IFDEF DOS}
  CenterCh := Result;
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

function LTrim(const S: String): String;
 var
  K: Byte;
 begin
  K := 1;

  while (K <= Length(S)) and (S[K] = ' ') do
   Inc(K);

  LTrim := Copy(S, K, 255);
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

function RTrim(const S: String): String;
var
   L: Byte;
begin
   L := Length(S);
   while (L <> 0) and (S[L] = ' ') do Dec(L);
   RTrim := Copy(S, 1, L);
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

function GetAllAfterChar(const S: String; const Spc: Byte; const Ch: Char): String;
 var
  K, L: Byte;
  {$IFDEF DOS}
  Result: String;
  {$ENDIF}
 begin
  Result := '';
  L := 0;

  for K := 1 to Length(S) do
   if S[K] = Ch then
    begin
     Inc(L);

     if L >= Spc then
      begin
       Result := Copy(S, K + 1, Length(S));
       Break;
      end;
    end;

  {$IFDEF DOS}
  GetAllAfterChar := Result;
  {$ENDIF}
 end;

function GetAllAfterSpace(const S: String; const Spc: Byte): String;
 begin
  GetAllAfterSpace := GetAllAfterChar(S, Spc, ' ');
 end;

procedure FixTabs(var S: String);
 var
  O: String;
  K, L, M: Byte;
 begin
  if Pos(#9, S) = 0 then
   Exit;

  O := S;
  S := '';
  M := 0;

  for K := 1 to Length(O) do
   case O[K] of
    #9:
     begin
      L := 8 - (M and 7);
      Inc(M, L);
      while L <> 0 do
       begin
        S := Concat(S, ' ');
        Dec(L);
       end;
     end;
   else
    S := Concat(S, O[K]);

    Inc(M);
   end;
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

{ pstrings }

function GetPString(const S: Pointer): String;
 {$IFDEF CODE32}
 begin
  GetPStringEx(S, Result);
 end;
 {$ELSE}
 type
  PString = ^String;
 begin
  if S = nil then
   GetPString := ''
  else
   GetPString := PString(S)^;
 end;
 {$ENDIF}

procedure GetPStringEx(const S: Pointer; var R: String);
 type
  PString = ^String;
 begin
  if S = nil then
   R := ''
  else
   R := PString(S)^;
 end;

{ numbers: hex }

function HexB(const B: Byte): String;
 begin
  HexB := Digits[B shr 4] + Digits[B and $F];
 end;

function HexT(const W: Word): String;
 begin
  HexT := Digits[Hi(W) and $F] +
          Digits[Lo(W) shr 4] +
          Digits[Lo(W) and $F];
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

function HexPtr(const P: Pointer): String;
 begin
  with Long(P) do
   HexPtr := HexW(LowWord) + ':' + HexW(HighWord);
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

function Real2Str(const R: Real; const Width, Decimals: Byte): String;
 {$IFDEF DOS}
 var
  Result: String;
 {$ENDIF}
 begin
  Str(R: Width: Decimals, Result);

  {$IFDEF DOS}
  Real2Str := Result;
  {$ENDIF}
 end;

function lz(const Number: Longint): String;
 {$IFDEF DOS}
 var
  Result: String;
 {$ENDIF}
 begin
  Str(Number, Result);

  if Length(Result) = 1 then
   Result := Concat('0', Result);

  {$IFDEF DOS}
  lz := Result;
  {$ENDIF}
 end;

{ strings to chars/numbers }

function Str2Char(const S: String): Char;
 begin
  if Length(S) = 0 then
   Str2Char := #0
  else
   Str2Char := S[1];
 end;

function Str2Number(const S: String): Boolean;
 var
  X: Longint;
  C: xInteger;
 begin
  Val(S, X, C);
  Str2Number:=C = 0;
 end;

function Str2Byte(const S: String; var A: Byte): Boolean;
 begin
  if S = '' then
   begin
    A := 0;
    Str2Byte := True;
   end
  else
   begin
    Val(S, A, ValL);
    Str2Byte := ValL = 0;
   end;
 end;

function Str2Integer(const S: String; var A: Integer): Boolean;
 begin
  if S = '' then
   begin
    A := 0;
    Str2Integer := True;
   end
  else
   begin
    Val(S, A, ValL);
    Str2Integer := ValL = 0;
   end;
 end;

function Str2Word(const S: String; var A: Word): Boolean;
 begin
  if S = '' then
   begin
    A := 0;
    Str2Word := True;
   end
  else
   begin
    Val(S, A, ValL);
    Str2Word := ValL = 0;
   end;
 end;

function Str2xWord(const S: String; var A: XWord): Boolean;
 begin
  if S = '' then
   begin
    A := 0;
    Str2xWord := True;
   end
  else
   begin
    Val(S, A, ValL);
    Str2xWord := ValL = 0;
   end;
 end;

function Str2Longint(const S: String; var A: Longint): Boolean;
 begin
  if S = '' then
   begin
    A := 0;
    Str2Longint := True;
   end
  else
   begin
    Val(S, A, ValL);
    Str2Longint := ValL = 0;
   end;
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

function RemoveBackSlash(S: String): String;
 begin
  if (Copy(S, Length(S) - 2, 2) <> ':\') and (S[Length(S)] = '\') then
   SetLength(S, Length(S) - 1);

  RemoveBackSlash := S;
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
 {$IFDEF DELPHI}
 begin
  Result := FileExists(S);
 end;
 {$ELSE}
 var
  F: File;
  A: xWord;
 begin
  Assign(F, S);

  GetFAttr(F, A);

  ExistFile := DosError = 0;
 end;
 {$ENDIF}

function FExpand(const S: String): String;
 begin
  {$IFDEF DELPHI}
  Result := ExpandFileName(S);
  {$ELSE}
  FExpand := Dos.FExpand(S);
  {$ENDIF}
 end;


function HasExtension(const Name: String; var DotPos: Word): Boolean;
 var
  I: Word;
 begin
  DotPos := 0;

  for I:=Length(Name) downto 1 do
   if (Name[I] = '.') and (DotPos = 0) then
    DotPos := I;

  HasExtension := (DotPos > 0) and (Pos('\', Copy(Name, Succ(DotPos), 64)) = 0);
 end;

function ForceExtension(const Name, Ext: String): String;
 var
  DotPos: Word;
 begin
  if HasExtension(Name, DotPos) then
   ForceExtension := Copy(Name, 1, DotPos) + Ext
  else
   ForceExtension := Name + '.' + Ext;
 end;

function JustExtension(const Name: String): String;
 var
  DotPos: Word;
 begin
  if HasExtension(Name, DotPos) then
   JustExtension := Copy(Name, Succ(DotPos), 3)
  else
   JustExtension := '';
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


{$IFDEF VIRTUALPASCAL}
function TextSeek(var F: Text; const Target: LongInt): Boolean;
 var
  P: LongInt;
  T: TextRec absolute F;
 begin
  TextSeek := True;

  SysFileSeek(T.Handle, 0, 1, P);

  Dec(P, T.BufEnd);

  P := Target - P;

  if (P >= 0) and (P < T.BufEnd) then
   T.BufPos := P
  else
   begin
    SysFileSeek(T.Handle, Target, 0, P);

    T.BufEnd := 0;
    T.BufPos := 0;
   end;
 end;

function TextFileSize(var F: Text): LongInt;
 var
  T: TextRec absolute F;
  P: Longint;
 begin
  SysFileSeek(T.Handle, 0, 1, P);
  SysFileSeek(T.Handle, 0, 2, Result);
  SysFileSeek(T.Handle, P, 0, P);
 end;

function TextPos(var F: Text): LongInt;
 var
  T: TextRec absolute F;
 begin
  SysFileSeek(T.Handle, 0, 1, Result);

  if T.Mode = fmOutput then
   Inc(Result, T.BufPos)
  else
   if T.BufEnd <> 0 then
    Dec(Result, T.BufEnd - T.BufPos);
 end;
{$ENDIF}

{$IFDEF DELPHI}
function TextSeek(var F: Text; const Target: LongInt): Boolean;
 var
  T: TextRec absolute F;
  P: Longint;
 begin
  TextSeek := True;

  P := FileSeek(T.Handle, 0, 1);

  Dec(P, T.BufEnd);

  P := Target - P;

  if (P >= 0) and (P < T.BufEnd) then
   T.BufPos := P
  else
   begin
    FileSeek(T.Handle, Target, 0);

    T.BufEnd := 0;
    T.BufPos := 0;
   end;
 end;

function TextFileSize(var F: Text): LongInt;
 var
  T: TextRec absolute F;
  P: Longint;
 begin
  P := FileSeek(T.Handle, 0, 1);

  Result:=FileSeek(T.Handle, 0, 2);

  FileSeek(T.Handle, P, 0);
 end;

function TextPos(var F: Text): LongInt;
 var
  T: TextRec absolute F;
 begin
  Result := FileSeek(T.Handle, 0, 1);

  if T.Mode = fmOutput then
   Inc(Result, T.BufPos)
  else
   if T.BufEnd <> 0 then
    Dec(Result, T.BufEnd - T.BufPos);
 end;
{$ENDIF}

{$IFDEF DOS}
{ The following part of code has been cut from
  Turbo Professional 5.21 (c) by TurboPower Software, 1987, 1992. }

function TextSeek(var F: Text; const Target: LongInt): Boolean;
 var
  T: Long absolute Target;
  Pos: LongInt;
  Regs: Registers;
 begin
  TextSeek := False;

  with Regs, TText(F) do
   begin
    if Mode <> FMInput then
     Exit;

    AX := $4201;
    BX := Handle;
    CX := 0;
    DX := 0;
    MsDos(Regs);

    if Odd(Flags) then
     Exit;

    Long(Pos).HighWord := DX;
    Long(Pos).LowWord := AX;

    Dec(Pos, BufEnd);

    Pos := Target - Pos;

    if (Pos >= 0) and (Pos < BufEnd) then
     BufPos := Pos
    else
     begin
      AX := $4200;
      BX := Handle;
      CX := T.HighWord;
      DX := T.LowWord;

      MsDos(Regs);

      if Odd(Flags) then
       Exit;

      BufEnd := 0;
      BufPos := 0;
     end;
   end;

  TextSeek := True;
 end;

function TextFileSize(var F: Text) : LongInt;
 var
  OldHi, OldLow: Integer;
  Regs: Registers;
 begin
  with Regs, TText(F) do
   begin
    if Mode = FMClosed then
     begin
      TextFileSize := -1;
      Exit;
     end;

    AX := $4201;
    BX := Handle;
    CX := 0;
    DX := 0;
    MsDos(Regs);

    if Odd(Flags) then
     begin
      TextFileSize := -1;

      Exit;
     end;

    OldHi := DX;
    OldLow := AX;
    AX := $4202;
    BX := Handle;
    CX := 0;
    DX := 0;
    MsDos(Regs);

    if Odd(Flags) then
     begin
      TextFileSize := -1;

      Exit;
     end;

    TextFileSize := Longint(DX) shl 16 + AX;

    AX := $4200;
    BX := Handle;
    CX := OldHi;
    DX := OldLow;
    MsDos(Regs);

    if Odd(Flags) then
     TextFileSize := -1;
   end;
 end;

function TextPos(var F: Text): LongInt;
 var
  Position: LongInt;
  Regs: Registers;
 begin
  with Regs, TText(F) do
   begin
    if Mode = FMClosed then
     begin
      TextPos := -1;

      Exit;
     end;

    AX := $4201;
    BX := Handle;
    CX := 0;
    DX := 0;
    MsDos(Regs);

    if Odd(Flags) then
     begin
      TextPos := -1;

      Exit;
     end;

    Long(Position).HighWord := DX;
    Long(Position).LowWord := AX;

    if Mode = FMOutput then
     Inc(Position, BufPos)
    else
     if BufEnd <> 0 then
      Dec(Position, BufEnd - BufPos);

    TextPos := Position;
   end;
 end;
{$ENDIF}


function FileLocked(const FName: String): Boolean;
 var
  AFileMode: Integer;
  F: File;
 begin
  if not ExistFile(FName) then
   begin
    FileLocked := False;

    Exit;
   end;

  AFileMode := FileMode;

  FileMode := $12;

  if IOResult <> 0 then;

  Assign(F, FName);
  Reset(F);

  if IOResult = 0 then
   begin
    FileLocked := False;

    Close(F);
   end
  else
   FileLocked := True;

  if IOResult <> 0 then;

  FileMode := AFileMode;
 end;

function EraseFile(const FName: String): Boolean;
 var
  F: Text;
 begin
  if IOResult <> 0 then;

  Assign(F, FName);
  Erase(F);

  EraseFile := IOResult = 0;
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

{ time & date }

function Clock: Longint;
 {$IFDEF VIRTUALPASCAL}
 begin
  Clock := SysSysMsCount;
 end;
 {$ENDIF}
 {$IFDEF DELPHI}
 begin
  Clock := GetTickCount;
 end;
 {$ENDIF}
 {$IFDEF DOS}
 assembler;
  asm
             push    ds              { save caller's data segment }
             mov     ds, seg0040     {  access ticker counter }
             mov     bx, 6ch         { offset of ticker counter in segm.}
             mov     dx, 43h         { timer chip control port }
             mov     al, 4           { freeze timer 0 }
             pushf                   { save caller's int flag setting }
             cli                     { make reading counter an atomic operation}
             mov     di, ds:[bx]     { read bios ticker counter }
             mov     cx, ds:[bx+2]
             sti                     { enable update of ticker counter }
             out     dx, al          { latch timer 0 }
             cli                     { make reading counter an atomic operation}
             mov     si, ds:[bx]     { read bios ticker counter }
             mov     bx, ds:[bx+2]
             in      al, 40h         { read latched timer 0 lo-byte }
             mov     ah, al          { save lo-byte }
             in      al, 40h         { read latched timer 0 hi-byte }
             popf                    { restore caller's int flag }
             xchg    al, ah          { correct order of hi and lo }
             cmp     di, si          { ticker counter updated ? }
             je      @no_update      { no }
             or      ax, ax          { update before timer freeze ? }
             jns     @no_update      { no }
             mov     di, si          { use second }
             mov     cx, bx          {  ticker counter }
@no_update:  not     ax              { counter counts down }
             mov     bx, 36edh       { load multiplier }
             mul     bx              { w1 * m }
             mov     si, dx          { save w1 * m (hi) }
             mov     ax, bx          { get m }
             mul     di              { w2 * m }
             xchg    bx, ax          { ax = m, bx = w2 * m (lo) }
             mov     di, dx          { di = w2 * m (hi) }
             add     bx, si          { accumulate }
             adc     di, 0           {  result }
             xor     si, si          { load zero }
             mul     cx              { w3 * m }
             add     ax, di          { accumulate }
             adc     dx, si          {  result in dx:ax:bx }
             mov     dh, dl          { move result }
             mov     dl, ah          {  from dl:ax:bx }
             mov     ah, al          {   to }
             mov     al, bh          {    dx:ax:bh }
             mov     di, dx          { save result }
             mov     cx, ax          {  in di:cx }
             mov     ax, 25110       { calculate correction }
             mul     dx              {  factor }
             sub     cx, dx          { subtract correction }
             sbb     di, si          {  factor }
             xchg    ax, cx          { result back }
             mov     dx, di          {  to dx:ax }
             pop     ds              { restore caller's data segment }
  end;
 {$ENDIF}

procedure Wait(const ms: Longint);
 {$IFDEF VIRTUALPASCAL}
 begin
  SysCtrlSleep(ms);
 end;
 {$ENDIF}
 {$IFDEF DELPHI}
 begin
  Sleep(ms);
 end;
 {$ENDIF}
 {$IFDEF DOS}
 var
  Anchor1, Anchor2, Current: Longint;
 begin
  Anchor2 := Clock;
  Anchor1 := Anchor2 + ms;

  repeat
   Current:=Clock;
  until (Current > Anchor1) or (Current < Anchor2);
 end;
 {$ENDIF}

function DayOfWeek(const Year, Month, Day: Longint): Word;
 var
  Temp1, Temp2: Longint;
 begin
  Temp1 := Month + 10;
  Temp2 := Year + (Month - 14) div 12;
  DayOfWeek := ((13 *  (Temp1 - Temp1 div 13 * 12) - 1) div 5 +
                Day + 77 + 5 * (Temp2 - Temp2 div 100 * 100) div 4 +
                Temp2 div 400 - Temp2 div 100 * 2) mod 7;
 end;

{ wildcards }

{
  CheckWildcard (WildEqu)
  (c) by Vladimir S. Lokhov <vsl@tula.net> <2:5022/18.14>, 1994-2000.
}

type
 TCheckWildcardStack = packed record
  Src, Mask: Byte;
 end;

function CheckWildcard(const Src, Mask: String): Boolean;
 var
  Stack: array[1..128] of TCheckWildcardStack;
  StackPointer,
  SrcPosition, MaskPosition,
  SrcLength, MaskLength: Byte;
 begin
  CheckWildcard := False;

  if (Mask = '') and (Src <> '') then
   Exit;

  MaskLength := Length(Mask);
  SrcLength := Length(Src);

  if Mask[MaskLength] <> '*' then
   while (MaskLength > 1) and (SrcLength > 1) do
    begin
     if (Mask[MaskLength] = '*') or (Mask[MaskLength] = '?') then
      Break;

     if Mask[MaskLength] <> Src[SrcLength] then
      Exit;

     Dec(MaskLength);
     Dec(SrcLength);
    end;

  if Mask[MaskLength] = '*' then
   while (Mask[MaskLength - 1] = '*') and (MaskLength > 1) do
    Dec(MaskLength);

  StackPointer := 0;

  SrcPosition := 1;
  MaskPosition := 1;

  while (SrcPosition <= SrcLength) and (MaskPosition <= MaskLength) do
   begin
    case Mask[MaskPosition] of
     '?':
      begin
       Inc(SrcPosition);
       Inc(MaskPosition);
      end;
     '*':
      begin
       if (MaskPosition = 1) or (Mask[MaskPosition - 1] <> '*') then
        Inc(StackPointer);

       Stack[StackPointer].Mask:=MaskPosition;

       Inc(MaskPosition);

       if MaskPosition <= MaskLength then
        if (Mask[MaskPosition] <> '?') and (Mask[MaskPosition] <> '*') then
         while (SrcPosition <= Length(Src)) and (Src[SrcPosition] <> Mask[MaskPosition]) do
          Inc(SrcPosition);

       Stack[StackPointer].Src := SrcPosition + 1;
      end;
    else
     if Src[SrcPosition] = Mask[MaskPosition] then
      begin
       Inc(SrcPosition);
       Inc(MaskPosition);
      end
     else
      begin
       if StackPointer = 0 then
        Exit;

       SrcPosition := Stack[StackPointer].Src;
       MaskPosition := Stack[StackPointer].Mask;

       Dec(StackPointer)
      end;
    end;

    while not ((SrcPosition <= SrcLength) xor (MaskPosition > MaskLength)) do
     begin
      if (MaskPosition >= MaskLength) and (Mask[MaskLength] = '*') then
       Break;

      if StackPointer = 0 then
       Exit;

      SrcPosition := Stack[StackPointer].Src;
      MaskPosition := Stack[StackPointer].Mask;

      Dec(StackPointer)
     end;
   end;

  CheckWildcard := True;
 end;

function IsWildcard(const Mask: String): Boolean;
 begin
  IsWildcard := (Pos('*', Mask) > 0) or (Pos('?', Mask) > 0);
 end;

{ misc }

function GetBinkDateTime: String;
 var
  Year, Month, Day, Dow, Hour, Min, Sec, Sec100: xWord;
 begin
  GetDate(Year, Month, Day, Dow);
  GetTime(Hour, Min, Sec, Sec100);

  GetBinkDateTime := LeftPadCh(Long2Str(Day), '0', 2) + ' ' +
                     Months[Month] + ' ' +
                     LeftPadCh(Long2Str(Hour), '0', 2) + ':' +
                     LeftPadCh(Long2Str(Min), '0', 2) + ':' +
                     LeftPadCh(Long2Str(Sec), '0', 2);
 end;

{ multiplatform stuff }

{$IFNDEF DELPHI}
function GetAttr(const FName: String): Longint;
 var
  F: File;
  K: XWord;
 begin
  Assign(F, FName);

  GetFAttr(F, K);

  GetAttr := K;
 end;

function GetFileDate(const FName: String): Longint;
 var
  SR: SearchRec;
 begin
  wFindFirst(FName, AnyFile, SR);

  if DosError <> 0 then
   GetFileDate := -1
  else
   GetFileDate := SR.Time;

  wFindClose(SR);
 end;

function GetFileSize(const S: String): Longint;
 var
  SR: SearchRec;
 begin
  wFindFirst(S, AnyFile, SR);

  if DosError <> 0 then
   GetFileSize := -1
  else
   GetFileSize := SR.Size;

  wFindClose(SR);
 end;

function GetStamp(const FName: String): Longint;
 var
  F: File;
  K: Longint;
 begin
  if IOResult <> 0 then;

  Assign(F, FName);
  Reset(F);

  if IOResult <> 0 then
   begin
    GetStamp := -1;
    Exit;
   end;

  GetFTime(F, K);

  Close(F);

  GetStamp := K;

  if IOResult <> 0 then;
 end;

procedure SetAttr(const FName: String; K: Longint);
 var
  F: File;
 begin
  Assign(F, FName);

  SetFAttr(F, K);

  if IOResult <> 0 then;
 end;

procedure SetStamp(const FName: String; K: Longint);
 var
  F: File;
 begin
  if IOResult <> 0 then;

  Assign(F, FName);
  Reset(F);

  if IOResult <> 0 then
   Exit;

  SetFTime(F, K);

  Close(F);

  if IOResult <> 0 then;
 end;

function StackOverflow: boolean;
 begin
  StackOverflow := SPtr < $1000;
 end;
{$ENDIF}

{$IFDEF DELPHI}
procedure GetDate(var Year, Month, Day, Dow: Word);
 begin
  DecodeDate(Date, Year, Month, Day);
  Dow := DayOfWeek(Year, Month, Day);
 end;

procedure GetTime(var Hour, Min, Sec, Sec100: Word);
 begin
  DecodeTime(Time, Hour, Min, Sec, Sec100);
  Sec100 := Sec100 div 10;
 end;

procedure wFindFirst(const Path: String; const Attrs: Integer; var SR: SearchRec);
 begin
  DosError := SysUtils.FindFirst(Path, Attrs, SR);
 end;

procedure wFindNext(var SR: SearchRec);
 begin
  DosError := SysUtils.FindNext(SR);
 end;

procedure wFindClose(var SR: SearchRec);
 begin
  SysUtils.FindClose(SR);
 end;
{$ENDIF}


{$IFDEF DOS}
procedure wFindClose(var SR: SearchRec);
 begin
 end;

procedure SetLength(var S: String; const NewLength: Byte);
 begin
  Byte(S[0]) := NewLength;
 end;
{$ENDIF}

end.
