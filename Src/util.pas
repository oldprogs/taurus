unit Util;

interface

type
   MoveEn = (up, down, right, left);  { type for the AnsiMove function }
   MediaType = (mtWAV, mtRaMZ, mtUnknown);

function GetBuildDate(const fn: string;var date: TDateTime): boolean;
function AnsiMove(Move: MoveEn; Number: integer): string;
function ProcessBS(var s: string): boolean;
function GetMediaType(const fn: string): MediaType;

const
   AnsiInit = #27'[';               { the same old ANSI init string }
   AnsiSave = AnsiInit + 's';       { constant for saving the character }
   AnsiRestore = AnsiInit + 'u';    { constant for restoring the char ^ }
   AnsiCls = AnsiInit + '2J';       { constant for clearing screen }
   AnsiEraseLine = AnsiInit + 'K';  { constant for erasing lines }


implementation

uses
   classes,
   sysutils;

function GetBuildDate;
type

   DWord = LongWord;

   TExeHeader = record
      F1  : array [0..23] of char;
      Flag  : Byte;
      F2  : array [0..34] of char;
      AdrPE  : LongInt;  //OffSet to PE Header
   end;

   TPEHeader = record
      Sign  : array [0..5] of char;
      NObj  : Word;
      F3  : array [0..11] of char;
      NTHead  : Word;
      F4  : array [0..226] of Char
   end;

   Trsrc = record
      ObjName  : array [0..7] of char;
      F5  : array [0..11] of char;
      PhysOffs  : DWord;
      F6  : array [0..11] of char;
   End;

   TFirst = record
      F7  : array [0..3] of char;
      CompD  : DWord;
   end;

var

   fname: tfilestream;
   n    : Integer;
   EH   : TExeHeader;
   PEH  : TPEHeader;
   RSRC : Trsrc;
   First: TFirst;

begin

   FName:=TFileStream.Create(Fn, fmOpenRead or fmShareDenyNone);
   fname.seek(0,soFrombeginning);
   fname.read(EH,64);
   fname.seek(EH.AdrPE,soFrombeginning);
   fname.read(PEH,248);
   fname.seek(EH.AdrPE+248,soFrombeginning);

   For n:=1 to PEH.Nobj do begin
      fname.read(RSRC,40);
      if RSRC.ObjName='.rsrc' then begin
         fname.seek(RSRC.PhysOffs,soFrombeginning);
         fname.read(First,8);
         Break;
      end;
   end;
   If RSRC.ObjName<>'.rsrc' then
      result:=false
   else begin
      result:=true;//FormatDateTime('dd-mm-yyyy',FileDateToDateTime(First.CompD));
      date:=FileDateToDateTime(First.CompD);
   end;
   fname.free;
end;

function AnsiMove(Move: MoveEn; Number: integer): string;
var
   Stri: string;
   Final: string;
begin
   Final := AnsiInit;
   Str(Number, Stri);
   if Number > 1 then
      Final := Final + Stri;
   if Move = up then
      Final := Final + 'A'
   else if Move = down then
      Final := Final + 'B'
   else if Move = right then
      Final := Final + 'C'
   else if Move = left then
      Final := Final + 'D';
   AnsiMove := Final;
end;

function ProcessBS(var s: string): boolean;
var
   i: integer;
begin
   i := pos(#8, s);
   while i > 1 do begin
      delete(s, i - 1, 2);
      i := pos(#8, s);
   end;{while}
   result := true;
end;

function GetMediaType(const fn: string): MediaType;
var
   FileID: TextFile;
   Buf: string;
begin
   result := mtUnknown;

  {$I-}
   AssignFile(FileID, fn);
   Reset(FileID);
   if IOResult <> 0 then exit;
  {$I+}

   Buf := '';
   if not EOF(FileID) then Readln(FileID, Buf);
   if Buf = 'RAMZ' then result := mtRaMZ else
   if Copy(Buf,1,4) = 'RIFF' then result := mtWAV;

   CloseFile(FileID);
end;

end.
