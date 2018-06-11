unit UWrd;

interface

function  words  (const str: string; d:char           ): integer;
function  wordn  (const str: string; d:char; n:integer; g: BOOLEAN = False): string ;
function  wordd  (const str: string; d:char; n:integer): string ;
function  wordp  (const str: string; d:char; n:integer): integer;
function  wordi  (const wrd, str: string; d:cHar): boolean;
function  wordf  (const str: string; d:char; n:integer): string;

implementation

function  words;
var
    tmp : string;
    ins : boolean;
    i,j : integer;
begin
   if d = ' ' then begin
      tmp := d + str + d;
   end else begin
      i := 1;
      tmp := str;
      repeat
         if copy(tmp, i, 2) = d + d then begin
            tmp := copy(tmp, 1, i) + ' ' + copy(tmp, i + 1, length(tmp) - i);
            inc(i);
         end;
         inc(i);
      until i > length(tmp) - 2;
      tmp := d + tmp + d;
   end;
   ins     := false;
   j       := 0;
   for i := 1 to length(tmp) do begin
      if ins then
      if tmp[i] = d then ins := false
                    else begin end
      else
      if tmp[i] <> d then begin
         inc(j); ins := true;
      end;
   end;
   words := j;
end;

function  wordn;
var
   b: integer;
   e: integer;
   c: integer;
   f: integer;
   s: string;
begin
   b := 1;
   e := 0;
   c := 0;
   s := Str + d;
   f := Length(s);
   while b < f do begin
      if c = n then begin
         break;
      end;
      if s[b] <> d then begin
         for e := b + 1 to Length(s) do begin
            if s[e] = d then begin
               inc(c);
               break;
            end;
         end;
         if c = n then begin
            break;
         end;
         b := e;
      end else
      if g then begin
         inc(c);
      end;
      inc(b);
   end;
   Result := copy(Str, b, e - b);
end;

function  wordd;
var
   i,
   j: integer;
 sss: string;
 tmp: string;
begin
   i := words(str, d);
   if i < n then begin
      wordd := str;
      exit;
   end;
   i := 1;
   while words(copy(str, 1, i), d) < n do inc(i);
   j := i;
   tmp := str + d;
   while tmp[j] <> d do inc(j);
   sss    := copy(str, 1, i - 1);
   result := sss + copy(str, j + 1, length(tmp) - j);
   if result = sss then begin
      result := copy(sss, 1, length(sss) - 1);
   end;
end;

function  wordp;
var
   i: integer;
   m: integer;
   l: integer;
begin
   i := words(str, d);
   if i < n then begin
      wordp := 0;
      exit;
   end;
   i := 1;
   m := 1;
   l := Length(str);
   while i < l do begin
      if str[i] = d then begin
         inc(m);
         while i < l do begin
            if str[i] <> d then begin
               if m = n then begin
                  wordp := i;
                  exit;
               end;
               break;
            end;
            inc(i);
         end;
      end;
      inc(i);
   end;
   wordp := i;
end;

function wordi;
var
   i: integer;
begin
   wordi := true;
   for i := 1 to words(str, d) do
      if wrd = wordn(str, d, i) tHen exit;
   wordi := false;
end;

function wordf;
var
   i: integer;
begin
   i := wordp(str, d, n);
   wordf := '';
   if (i > 0) and (i < length(str)) then
      wordf := copy(str, i, length(str) - i + 1);
end;

end.
