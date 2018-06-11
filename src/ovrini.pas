unit OvrIni;

interface

uses Classes, SysUtils, Windows;

Type
  TOvrNodeIni = record
    phones: string;
    time: string;
    freqtime: string;
    password: string;
    periodical: string;
    externalc: string;
    inbox: string;
    outbox: string;
  end;

  TOvrIni = class
  private
    FIniFile: TIniFile;
  public
    function OvrNodes:TStrings;
    function GetOvrNode(i: string): TOvrNodeIni;
    function CountPhones(i: string): Integer;
    procedure SetNode(i: string; n: TOvrNodeIni);
    procedure DeleteNodeOvr(i: string);
    constructor Create(Path: String);
    destructor Destroy;
  end;

var OvrIniF: TOvrIni;

type
  CharSet = Set Of Char;

  function IsNow(time: string;n: byte): boolean;
  function WordCount(const S: String; WordDelims: CharSet): Byte;
  function ExtractWord(N: Byte; const S: String; WordDelims: CharSet): String;

implementation



const
  phones = 'PHONES';
  time = 'TIME';
  freqtime = 'FREQTIME';
  password = 'PASSWORD';
  periodical = 'PERIODICAL';
  externalc = 'EXTERNALC';
  inbox = 'INBOX';
  outbox = 'OUTBOX';


procedure StUpcaseEx(var S: String);
var
  k: byte;
begin
  for k:=1 to Length(S) do  s[k]:=upcase(s[k]);
end;

function StUpcase(const s: string): string;
var d: string;
begin
  d:=s;
  StUpcaseEx(d);
  result:=d;
end;

function ExtractWord(N: Byte; const S: String; WordDelims: CharSet): String;
var
  I: Word;                 {!!.12}
  Count, Len: Byte;
  SLen: Byte;
begin
  Count := 0;
  I := 1;
  Len := 0;
  SetLength(result,0);
  SLen:=Length(s);

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
        SetLength(result,Len);
        ExtractWord[Len] := S[I];
      end;
      Inc(I);
    end;
  end;
end;

function WordCount(const S: String; WordDelims: CharSet): Byte;
var
  Count: Byte;
  I: Word;
  SLen: Byte;
begin
  Count := 0;
  I := 1;
  SLen:=length(s);
  while I <= SLen do begin
    while (I <= SLen) and (S[I] in WordDelims) do
    Inc(I);
    if I <= SLen then Inc(Count);
    while (I <= SLen) and not(S[I] in WordDelims) do Inc(I);
  end;
  WordCount := Count;
end;

function DayOfWeek(Y, M, D: Word): Word;
var
  Tmp1, Tmp2, yy, mm, dd: Longint;
begin
  yy := y;
  mm := m;
  dd := d;
  Tmp1 := mm + 10;
  Tmp2 := yy + (mm - 14) DIV 12;
  DayOfWeek :=  ((13 *  (Tmp1 - Tmp1 DIV 13 * 12) - 1) DIV 5 +
               dd + 77 + 5 * (Tmp2 - Tmp2 DIV 100 * 100) DIV 4 +
               Tmp2 DIV 400 - Tmp2 DIV 100 * 2) MOD 7;
end;

function IsNow(time: string;n: byte): boolean;
var
  i:integer;
  s: string;
  d1,d2: String;
  st: _SYSTEMTIME;
  n1,n2,n3,h1,h2,m1,m2:integer;
begin
{1.00:00-5.10:00,6.00:00-7.24:00}
{1.00:00-4.10:00,5.00:00-6.24:00,7.00:00-7.12:00}
{12:00-17:00}
   result:=false;
   time := ExtractWord(n,time,[';']);
   if StUpCase(time) = 'CM' then
   begin
     result := true;
     exit;
   end;
   for i:= 1 to wordcount(time,[',']) do
   begin
     s:=ExtractWord(i,time,[',']);
{1.00:00-5.10:00}
     GetSystemTime(ST);
     GetLocalTime(ST);
     if Pos('.',s) <> 0 then
     begin
       d1:=s[1];
       d2:=ExtractWord(2,s,['-'])[1];
       if (not (d1[1] in ['1'..'7'])) or (not (d2[1] in ['1'..'7'])) then exit;
//       ST.wDayOfWeek:=DayOfWeek(ST.wYear,ST.wMonth,ST.wDay);
       case ST.wDayOfWeek of
         1..6: n1:=ST.wDayOfWeek;
         else n1:=7
       end;
       if ((ord(d1[1])-48 < n1) or (ord(d1[1])-48 = n1)) and ((ord(d2[1])-48 > n1) or (ord(d2[1])-48 = n1)) then
       begin
         delete(s,1,2);
         delete(s,pos(d2,s),2);
{00:00-10:00}
         d1:=ExtractWord(1,s,['-']);
         d2:=ExtractWord(2,s,['-']);
         h1:=StrToIntDef(ExtractWord(1,d1,[':']),0);
         m1:=StrToIntDef(ExtractWord(2,d1,[':']),0);
         h2:=StrToIntDef(ExtractWord(1,d2,[':']),24);
         m2:=StrToIntDef(ExtractWord(2,d2,[':']),0);
         n1:=h1*60+m1;
         n2:=h2*60+m2;
         n3:=ST.wHour*60+st.wMinute;
         if (n3 >= n1) and (n3 < n2) then
         begin
           result:=true;
           exit;
         end;
       end;
     end
     else begin
       d1:=ExtractWord(1,s,['-']);
       d2:=ExtractWord(2,s,['-']);
       h1:=StrToIntDef(ExtractWord(1,d1,[':']),0);
       m1:=StrToIntDef(ExtractWord(2,d1,[':']),0);
       h2:=StrToIntDef(ExtractWord(1,d2,[':']),24);
       m2:=StrToIntDef(ExtractWord(2,d2,[':']),0);

       if (h1*60+m1 <= ST.wHour*60+ST.wMinute) and (h2*60+m2 >= ST.wHour*60+ST.wMinute) then
       begin
         result:=true;
         exit;
       end;
     end;
   end;
//  ExtractWord(
end;

constructor TOvrIni.Create(Path: String);
begin
  FIniFile := TIniFile.Create(Path);
end;

destructor TOvrIni.Destroy;
begin
  FIniFile.Free;
end;

function TOvrIni.OvrNodes:TStrings;
begin
  FIniFile.ReadSections(result);
end;

function TOvrIni.CountPhones(i: string): Integer;
begin
  result:=WordCount(FIniFile.ReadString(i,phones,''),[';']);
end;

function TOvrIni.GetOvrNode(i: string): TOvrNodeIni;
begin
  result.phones := FIniFile.ReadString(i,phones,'');
  result.time := FIniFile.ReadString(i,time,'');
  result.freqtime := FIniFile.ReadString(i,freqtime,'');
  result.password := FIniFile.ReadString(i,password,'');
  result.periodical := FIniFile.ReadString(i,periodical,'');
  result.externalc := FIniFile.ReadString(i,externalc,'');
  result.inbox := FIniFile.ReadString(i,inbox,'');
  result.outbox := FIniFile.ReadString(i,outbox,'');
end;

procedure TOvrIni.SetNode(i: string; n: TOvrNodeIni);
begin
  FIniFile.WriteString(i,phones,n.phones);
  FIniFile.WriteString(i,time,n.time);
  FIniFile.WriteString(i,freqtime,n.freqtime);
  FIniFile.WriteString(i,password,n.password);
  FIniFile.WriteString(i,periodical,n.periodical);
  FIniFile.WriteString(i,externalc,n.externalc);
  FIniFile.WriteString(i,inbox,n.inbox);
  FIniFile.WriteString(i,outbox,n.outbox);
end;

procedure TOvrIni.DeleteNodeOvr(i: string);
begin
  FIniFile.EraseSection(i);
end;


end.
