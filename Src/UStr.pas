unit UStr;

interface

function  space   (           n:integer):string ;
function  replicate(ch:char;  n:integer):string ;
function  trim    (str:string;c:boolean=false):string ;
function  alike   (a,b:string;var d, p: integer): boolean;
function  center  (str:string;n:integer):string ;
function  UpSt    (  s:string          ):string;
function  LoSt    (  s:string          ):string;
function  lpad    (  s:string;n:integer;c:char):string;
function  rpad    (  s:string;n:integer;c:char):string;
function  addbackslash(p : string) : string;
function  match   (sm : string; var st: string) : boolean;
function  lines   (p, l, s : longint) : string;
function  LoCase  (c : char) : char;
function  JustPathName(PathName : string) : string;
function  JustFileName(PathName : string) : string;
function  JustName    (PathName : string) : string;
function  CRC16       (s        : string) : system.word;

implementation

function  space;
var   i : integer;
tempstr : string;
     begin
        tempstr:='';
        for i:=1 to n do tempstr:=tempstr+' ';
        space:=tempstr;
     end;

function  replicate;
var   i : integer;
tempstr : string;
     begin
        tempstr:='';
        for i:=1 to n do tempstr:=tempstr+ch;
        replicate:=tempstr;
     end;

function  trim;
var i,j : integer;
      s : string;
      n : integer;
begin
   trim := '';
   s := str;
   if length(str) > 1 then begin
      i := length(str);
      j := 1;
      while (j <= i) and (str[j] = ' ') do inc(j);
      if j > i then begin
         result := '';
         exit;
      end;
      while              (str[i] = ' ') do dec(i);
      s := copy(str, j, i - j + 1);
   end;
   if c and (length(s) > 3) then begin
      repeat
         i := pos('  ', s);
         if i > 0 then begin
{            s := copy(s, 1, i - 1) + copy(s, i + 1, length(s) - i);}
            j := i + 2;
            n := length(s);
            while (j <= n) and (s[j] = ' ') do inc(j);
            s := copy(s, 1, i) + copy(s, j, n - i + 1);
         end;
      until i = 0;
   end;
   if c then result := LoSt(s)
        else result := s;
end;

function  alike;
var
   o: integer;
   x,
   y: integer;

   function seeka(c: char; a: string; b, e: integer): integer;
         asm
            push  ebx
            push  ecx
            push  edx
            push  edi
            push  esi
            mov   esi, e    // ecx
            cmp   esi, b    // if b > e
            jge   @@good
            mov   eax, b
            jmp   @@out1
     @@good:
            sub   esi, b
            xchg  ecx, esi  // e-> esi
            mov   edi, a
            add   edi, esi  // b
            repnz scasb
            jz    @@yes1
            mov   eax, e
            inc   eax
            jmp   @@out1
     @@yes1:
            mov   eax, e
            sub   eax, ecx
     @@out1:
            pop   esi
            pop   edi
            pop   edx
            pop   ecx
            pop   ebx
         end;

   function count1(a, b: string): integer;
   var e,
       f,
       p,
       n: integer;
       s: integer;
       t: integer;
       o: integer;
       l,
       r: string;
   begin
   e := length(a);
   f := length(b);
   if (e = 0) or (f = 0) then begin
      result := 0;
      exit;
   end;
   p := 1;
   n := 1;
   l := '';
   r := '';
   o := 0;
   while (p <= e) and (n <= f) do begin
      if a[p] = b[n] then begin
         inc(p);
         inc(n);
         inc(o);
      end else begin
         s := seeka(b[n], a, p, e);
         t := seeka(a[p], b, n, f);
         if (s > e) and (t > f) then begin
            inc(p);
            inc(n);
         end else begin
            if s > e then s := e + f;
            if t > f then t := f + e;
            if s - p < t - n then begin
               l := l + copy(a, p, s - p);
               p := s;
//               if (r <> '') then begin
//                  o := o + count1(l, r);
//                  l := '';
//                  r := '';
//               end;
            end else
            if t - n < s - p then begin
               r := r + copy(b, n, t - n);
               n := t;
//               if (l <> '') then begin
//                  o := o + count1(l, r);
//                  l := '';
//                  r := '';
//               end;
            end else
            if s - p = t - n then begin
               l := l + copy(a, p, s - p);
               r := r + copy(b, n, t - n);
               p := s;
               n := t;
//               if (l <> '') and (r <> '') then begin
//                  o := o + count1(l, r);
//                  l := '';
//                  r := '';
//               end;
            end;
         end;
      end;
   end;
   result := o + count1(l, r);
   end;

   function count(const a, b: string): integer;
   var e,
       f,
       p,
       n: integer;
       o: integer;
       l,
       r: string;
   begin
   e := length(a);
   f := length(b);
   if (e = 0) or (f = 0) then begin
      result := 0;
      exit;
   end;
   p := 1;
   n := 1;
   l := '';
   r := '';
   o := 0;
   while (p <= e) and (n <= f) do begin
      if a[p] = b[n] then begin
         inc(p);
         inc(n);
         inc(o);
      end else
      if a[e] = b[f] then begin
         dec(e);
         dec(f);
         inc(o);
      end else begin
         if (p < e) and (n < f) then begin
            o := o + count1(copy(a, p, e - p + 1), copy(b, n, f - n + 1));
         end;
         break;
      end;
   end;
   result := o;
   end;


begin
   result := false;
   x := length(a);
   y := length(b);
   if x + y = 0 then begin
      result := true;
      d      := 100;
      exit;
   end;
   if (x = 0) or (y = 0) then begin
      d := 0;
      exit;
   end;
   o := count(a, b);
   d := (100 * o div x + 100 * o div y) div 2;
   if d = 100 then begin
      result := true;
   end;
end;

function  center;
var tempstr : string;
          j : integer;
     begin
        j := n - length(trim(str));
        if j > 0 then tempstr := space(j - j div 2) + trim(str) + space(j div 2)
                 else tempstr := trim(str);
        center := tempstr;
     end;

function UpSt;
var t : string;
    i : integer;
begin
   t := s;
   for i := 1 to length(s) do t[i] := UpCase(s[i]);
   UpSt := t;
end;

function LoSt;
var t : string;
    i : integer;
    n : integer;
begin
   t := s;
   n := length(s);
   for i := 1 to n do t[i] := LoCase(s[i]);
   LoSt := t;
end;

function lpad;
begin
   lpad := replicate(c, n - length(s)) + s;
end;

function rpad;
begin
   rpad := s + replicate(c, n - length(s));
end;

    function addbackslash;
    begin
       if length(p) > 0 then
       if p[length(p)] = '\' then addbackslash := p
                             else addbackslash := p + '\'
                        else addbackslash := p;
    end;

function match(sm : string; var st: string) : boolean;
var p : integer;
  _sm,
  _st : string;
begin
   match := false;
   if (length(sm) > 0) and (length(st) > 0) then begin
      _sm := UpSt(sm);
      _st := UpSt(st);
      while pos(_sm, _st) > 0 do begin
         match := true;
         p     := pos(_sm, _st);
        _st    := copy(_st, 1, p - 1) + copy(_st, p + length(_sm), 250);
         st    := copy( st, 1, p - 1) + copy( st, p + length( sm), 250);
      end;
   end;
end;

function lines;
var o : string;
    i : longint;
    n : longint;
begin
    if l > 0 then begin
       i := p * s div l;
       n := p * s * 2 div l;
       o := replicate('Û', i);
       if n > i * 2 then o := o + 'Ý';
       lines := o + space(s - length(o));
    end else lines := '';
end;

function LoCase;
var t : char;
begin
   if (c >= 'A') and (c <= 'Z') then t := chr(ord(c) + 32)
                                else t := c;
   LoCase := t;
end;

  function JustPathname(PathName : string) : string;
    {-Return just the drive:directory portion of a pathname}
  var
    I : Word;
  begin
    I := Succ(Word(Length(PathName)));
    repeat
      Dec(I);
    until (PathName[I] in ['\',':',#0]) or (I = 1);

    if I = 1 then
      {Had no drive or directory name}
      JustPathname := ''
    else if I = 1 then
      {Either the root directory of default drive or invalid pathname}
      JustPathname := PathName[1]
    else if (PathName[I] = '\') then begin
      if PathName[Pred(I)] = ':' then
        {Root directory of a drive, leave trailing backslash}
        JustPathname := Copy(PathName, 1, I)
      else
        {Subdirectory, remove the trailing backslash}
        JustPathname := Copy(PathName, 1, Pred(I));
    end else
      {Either the default directory of a drive or invalid pathname}
      JustPathname := Copy(PathName, 1, I);
  end;

  function JustFilename(PathName : string) : string;
    {-Return just the filename of a pathname}
  var
    I : Word;
  begin
    I := Succ(Word(Length(PathName)));
    repeat
      Dec(I);
    until (I = 0) or (PathName[I] in ['\', ':', #0]);
    JustFilename := Copy(PathName, Succ(I), 64);
  end;

  function JustName(PathName : string) : string;
    {-Return just the name (no extension, no path) of a pathname}
  var
    DotPos : Byte;
  begin
    PathName := JustFileName(PathName);
    for DotPos := Length(PathName) downto 1 do begin
       if PathName[DotPos] = '.' then break;
    end;
    if DotPos > 0 then begin
       PathName := Copy(PathName, 1, DotPos - 1);
    end;
    JustName := PathName;
  end;


function CRC16(s : string) : system.word;  { By Kevin Cooney }
var
  crc : longint;
  t,r : byte;
begin
  crc := 0;
  for t := 1 to length(s) do
  begin
    crc := (crc xor (ord(s[t]) shl 8));
    for r := 1 to 8 do
      if (crc and $8000)>0 then
        crc := ((crc shl 1) xor $1021)
          else
            crc := (crc shl 1);
  end;
  CRC16 := (crc and $FFFF);
end;

end.
