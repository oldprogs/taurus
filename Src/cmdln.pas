         (***************************************************)
         (*                                                 *)
         (*      Command line utils by Denis Voituk         *)
         (*                  Version 1.0                    *)
         (*           (C) 2000 by Denis Voituk              *)
         (*             FIDOnet 2:5012/28.25                *)
         (*                                                 *)
         (*                               Date: 09/05/2000  *)
         (*                            NewDate: 25/05/2001  *)
         (***************************************************)

{ Format of command line:                                             }
{   simple_param "simple param" /1stparam -Switch1 -Switch2 /2ndparam }
{   /3param:"Some string"                                             }
{   -switch:"some string" -switch:short_string /4param:short_string   }

{ Subparams:                                                          }
{   /4param:short_string                                              }
{   /3param:"Some string"                                             }

unit Cmdln;

interface


const
  SP_HAS = 0;
  SP_NO = 1;
  SP_ERROR = 2;

Type
  TStringArray = array [1..10] of string[255];
  TCharSet = Set Of Char;

  function HasSubParam(const cl: string): byte;
  function ExtractSubParam(const cl: string; var s: string): byte;
  function ScanAndChange(var str: string): boolean;
  function CountSwitches(const cl: string): byte;
  function CountParams(const cl: string): byte;
  function CountSimpleParams(const cl: string): byte;
  function GetSwitches(const cl: string): TStringArray;
  function GetParams(const cl: string): TStringArray;
  function GetSimpleParams(const cl: string): TStringArray;
//  function ExtractWord(N: Byte; const S: string; WordDelims: CharSet): string;
//  function WordCount(const S: string; WordDelims: CharSet): Byte;
  function GetParamStr: string;

implementation

uses wizard;

function HasChar(const s: string; c: char; var pos : word):boolean;
var I: word;
begin
  for I := 1 to Length(s) do
    if s[I] = c then
    begin
      pos := I;
      haschar := true;
      exit;
    end;
  haschar := false;
end;

function GetParamStr: string;
var
  I: word;
  pos : word;
  s, s2: string;
//  b: boolean;
begin
  s := '';
  if paramcount <> 0 then
    for I := 1 to paramcount do
    begin
      s2 :=Paramstr(I);
      if haschar(s2, ' ', pos) then
        if haschar(s2, ':', pos) then
        begin
          insert('"', s2, pos + 1);
          insert('"', s2, length(s2) + 1)
        end
        else s2 := '"' + s2 + '"';
      S := S + s2 + ' ';
    end;
  GetParamstr := s;
end;

function HasSubParam;
var
  I,c: byte;
begin
  c := 0;
  for I := 1 to length(cl) do
  begin
    if cl[I] = ':' then inc(c);
  end;
  case c of
    0: HasSubParam := SP_NO;
    1: HasSubParam := SP_HAS
  else HasSubParam := SP_ERROR;
  end;
end;

function ExtractSubParam;
var
  c,x: byte;
  I: byte;
//  tmpstr: string;
begin
  c := 0;
  x := 0;
  for I := 1 to length(cl) do
  begin
    if cl[I] = ':' then
    begin
      inc(c);
      x := i;
      break;
    end;
  end;
  case c of
    0:
    Begin
      ExtractSubParam := SP_NO;
      s := '';
      exit;
    end;
    1: ExtractSubParam := SP_HAS
    else ExtractSubParam := SP_ERROR;
  end;

  s := copy(cl, x, length(cl) - x + 1);
  delete(s,1,1);
{  for I:=1 to length(s) do
  begin}
  I:=0;
  repeat
    inc(I);
    if s[I] = #$05 then s[I] := ' ';
    if s[I] = '"' then
    begin
      delete(s, I, 1);
      dec(I);
      if I = length(s) then exit;
    end;
  until I = length(s);
//  end;
end;

{by sergey korowkin}
(*function WordCount(const S: string; WordDelims: CharSet): Byte;
var
  Count: Byte;
  I: Word;
  SLen: Byte absolute S;
begin
  Count := 0;
  I := 1;
  while I <= SLen do
  begin
    while (I <= SLen) and (S[I] in WordDelims) do Inc(I);
    if I <= SLen then Inc(Count);
    while (I <= SLen) and not(S[I] in WordDelims) do Inc(I);
  end;
  WordCount := Count;
end;*)

function ScanAndChange(var str: string): boolean;
var
  I: word;
  opened: boolean;
begin
  opened := false;
  for I := 1 to Length(str) do
  begin
    case str[I] of
      ' ': if opened then str[I] := #$05;
      '"': opened := not opened;
    end;
  end;
  ScanAndChange := not opened;
end;

function ScanAndRestore(var str: string): boolean;
var
  I: word;
  tmpstr: string;
begin
  if HasSubParam(str) = SP_NO then
  begin
    if str[1] <> '"' then
    begin
      ScanAndRestore := true;
      exit;
    end;
    scanandrestore := not ((str[1] <> '"') and (str[length(str)] = '"')) or ((str[1] = '"') and (str[length(str)] <> '"'));

    tmpstr := str;
    tmpstr := copy(str, 2, length(str) - 2);
    for I := 1 to length(tmpstr) do if tmpstr[I] = #$05 then tmpstr[I] := ' ';
    str := tmpstr;
  end
  else
  begin
    ScanAndRestore := false;
    tmpstr := str;
    for I := 1 to length(tmpstr) do if tmpstr[I] = #$05 then tmpstr[I] := ' ';
    str := tmpstr;
  end;
end;

{by sergey korowkin}
(*function ExtractWord(N: Byte; const S: string; WordDelims: CharSet): string;
var
  I: Word;                 {!!.12}
  Count, Len: Byte;
  SLen: Byte absolute S;
begin
  Count := 0;
  I := 1;
  Len := 0;
  ExtractWord[0] := #0;

  while (I <= SLen) and (Count <> N) do begin
    {skip over delimiters}
    while (I <= SLen) and (S[I] in WordDelims) do
      Inc(I);

    {if we're not beyond end of S, we're at the start of a word}
    if I <= SLen then
      Inc(Count);

    {find the end of the current word}
    while (I <= SLen) and not(S[I] in WordDelims) do begin
      {if this is the N'th word, add the I'th Character to Tmp}
      if Count = N then begin
        Inc(Len);
        ExtractWord[0] := Char(Len);
        ExtractWord[Len] := S[I];
      end;

      Inc(I);
    end;
  end;
end;
*)

function AbstractCount(cl: string; prefix: TCharSet; invert: boolean): byte;
var
  c,I,n: byte;
  s: string;
  v:-128..127;
begin
  c := 0;
  v := 0;
  ScanAndChange(cl);
  n := WordCount(cl, [' ']);
  case invert of
    true:
      begin
        c :=  n;
        v := -1;
      end;
    false:
      begin
        c := 0;
        v := 1;
      end;
  end;
  for I := 1 to n do
  begin
    s := ExtractWord(I, cl, [' ']);
    if s[1] in prefix then inc(c, v);
  end;
  AbstractCount := c;
end;

function CountSwitches;
begin
  CountSwitches := AbstractCount(cl, ['-'], false)
end;

function CountParams;
begin
  CountParams := AbstractCount(cl, ['/'], false)
end;

function CountSimpleParams;
begin
  CountSimpleParams := AbstractCount(cl, ['-', '/'], true)
end;

function AbstractGet(cl: string; prefix: TCharSet; invert: boolean): TStringArray;
var
  c,I,n: byte;
  s: string;
begin
  ScanAndChange(cl);
  n := WordCount(cl, [' ']);
  c := 0;
  for I := 1 to n do
  begin
    s :=ExtractWord(I, cl, [' ']);
    if (s[1] in prefix) and not invert then
    begin
      inc(c);
      scanandrestore(s);
      AbstractGet[c] := s;
    end
    else if not (s[1] in prefix) and invert then
    begin
      inc(c);
      scanandrestore(s);
      AbstractGet[c] := s;
    end;
  end;
end;

function GetSwitches;
begin
  GetSwitches := abstractget(cl, ['-'], false);
end;

function GetParams;
begin
  GetParams:=abstractget(cl, ['/'], false);
end;

function GetSimpleParams;
begin
  GetSimpleParams := abstractget(cl, ['/', '-'], true);
end;


end.
