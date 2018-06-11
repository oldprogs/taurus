unit RadSav;

{$I DEFINE.INC}

interface

uses Windows, Classes, xFido, Recs, xBase, Menus, MGrids, CfgFiles;

const
  IniConfig = 'Taurus.ini';
  MaxLine = 20;

type

  TDualRec = record
     nam,
     st1,
     st2: PString;
  end;

  TDualColl = class(TColl)
     procedure Add(const nam, st1, st2: string);
     procedure FreeItem(p: pointer); override;
     function MatchAddr(const n: string; a: TFidoAddress): integer;
  end;

  TRadSav = class
     CS: TRTLCriticalSection;
     StringsList: TStringList;
     FileName: string;
     constructor Create(const fn: string); virtual;
     destructor Destroy; override;
     procedure Enter;
     procedure Leave;
     function ReadString(Sect, Line: string): string; overload;
     function ReadString(Sect, Line, Def: string): string; overload;
     procedure WriteString(Sect, Line, Val: string);
     function ReadBool(Sect, Line: string): boolean; overload;
     function ReadBool(Sect, Line: string; Def: boolean): boolean; overload;
     procedure WriteBool(Sect, Line: string; Val: boolean);
     function ReadInteger(Sect, Line: string): integer; overload;
     function ReadInteger(Sect, Line: string; Def: integer): integer; overload;
     procedure WriteInteger(Sect, Line: string; Val: integer);
     function ReadSection(Sect, Line: string): TStringList;
     function GetStrings(n: string): TDualColl;
     procedure LoadGrid(g: TAdvGrid); overload;
     procedure LoadGrid(s: string; g: TAdvGrid); overload;
     procedure SaveGrid(g: TAdvGrid); overload;
     procedure SaveGrid(s: string; g: TAdvGrid); overload;
   end;

var
  SavFile: TRadSav;

implementation

uses SysUtils, Forms, Wizard, Crypt;

procedure TRadSav.Enter;
begin
   EnterCS(CS);
end;

procedure TRadSav.Leave;
begin
   LeaveCS(CS);
end;

function TRadSav.ReadString(Sect, Line: string): string;
begin
   Result := ReadString(Sect, Line, Line);
end;

function TRadSav.ReadString(Sect, Line, Def: string): string;
begin
   Enter;
   try
      with TIniFile.Create(FileName) do begin
         Result := ReadString(Sect, Line, Def);
         Free;
      end;
   finally
      Leave;
   end;
end;

function TRadSav.ReadBool(Sect, Line: string; Def: boolean): boolean;
begin
   Enter;
   try
      with TIniFile.Create(FileName) do begin
         Result := ReadBool(Sect, Line, Def);
         Free;
      end;
   finally
      Leave;
   end;
end;

function TRadSav.ReadBool(Sect, Line: string): boolean;
begin
   Result := ReadBool(Sect, Line, True);
end;

procedure TRadSav.WriteBool;
begin
   Enter;
   try
      with TMemIniFile.Create(FileName) do begin
         WriteBool(Sect, Line, Val);
         UpdateFile;
         Free;
      end;
   finally
      Leave;
   end;
end;

function TRadSav.ReadInteger(Sect, Line: string): integer;
begin
   Result := ReadInteger(Sect, Line, 0);
end;

procedure TRadSav.WriteInteger;
begin
   Enter;
   try
      with TMemIniFile.Create(FileName) do begin
         WriteInteger(sect, Line, Val);
         UpdateFile;
         Free;
      end;
   finally
      Leave;
   end;
end;

function TRadSav.ReadInteger(Sect, Line: string; Def: integer): integer;
begin
   Enter;
   try
      with TIniFile.Create(FileName) do begin
         Result := ReadInteger(Sect, Line, Def);
         Free;
      end;
   finally
      Leave;
   end;
end;

procedure TRadSav.WriteString;
begin
   Enter;
   try
      with TMemIniFile.Create(FileName) do begin
         WriteString(Sect, Line, Val);
         UpdateFile;
         Free;
      end;
   finally
      Leave;
   end;
end;

function TRadSav.ReadSection;
var
   i: integer;
begin
   Enter;
   try
      with TIniFile.Create(FileName) do begin
         try
            Result := TStringList.Create;
            ReadSection('Grids', Result);
         finally
            Free;
         end;
      end;
      for i := Result.Count - 1 downto 0 do begin
         if Pos(UpperCase(Line), UpperCase(Result[i])) = 0 then begin
            Result.Delete(i);
         end;
      end;
      if Result.Count = 0 then begin
         Result.Free;
         Result := nil;
      end;
   finally
      Leave;
   end;
end;

function TRadSav.GetStrings;
var
   i: integer;
   s: TStringList;
   t: string;
   m: integer;
begin
   i := StringsList.IndexOf(n);
   if i > -1 then begin
      Result := StringsList.Objects[i] as TDualColl;
      exit;
   end;
   Enter;
   try
      with TIniFile.Create(FileName) do begin
         try
            s := TStringList.Create;
            ReadSection('Grids', s);
            Result := TDualColl.Create;
            m := StringsList.Add(n);
            StringsList.Objects[m] := Result;
            for i := 1 to s.Count do begin
               if pos(n, s[i - 1]) > 0 then begin
                  t := ReadString('Grids', s[i - 1], '');
                  Result.Add(s[i - 1],
                             ExtractWord(1, t, ['|']),
                             ExtractWord(2, t, ['|']));
               end;
            end;   
            s.Free;
         finally
            Free;
         end;
      end;
   finally
      Leave;
   end;      
end;

procedure TRadSav.LoadGrid(g: TAdvGrid);
var
   s: TStringList;
   i: integer;
   n: integer;
   r: integer;
   t: string;
   c: string;
begin
   Enter;
   try
      with TIniFile.Create(FileName) do begin
         try
            s := TStringList.Create;
            ReadSection('Grids', s);
            r := 1;
            for i := 1 to s.Count do begin
               if pos(g.Name, s[i - 1]) > 0 then begin
                  g.AddLine;
                  t := ReadString('Grids', s[i - 1], '');
                  for n := 1 to WordCount(t, ['|']) do begin
                     c := ExtractWord(n, t, ['|']);
                     if c = '-' then c := '';
                     g.Cells[g.FixedCols - 1 + n, r] := c;
                  end;
                  inc(r);
               end;
            end;
            g.DelLine;
            s.Free;
         finally
            Free;
         end;
      end;
   finally
      Leave;
   end;
end;

procedure TRadSav.LoadGrid(s: string; g: TAdvGrid);
var
   l: TStringList;
   i: integer;
begin
   Enter;
   try
      with TMemIniFile.Create(FileName) do begin
         try
            l := TStringList.Create;
            ReadSection(s, l);
            for i := 0 to l.Count - 1 do begin
               if g.RowCount <= i + 1 then begin
                  g.RowCount := i + 2;
               end;
               g.Cells[1, i + 1] := l[i];
               g.Cells[2, i + 1] := ReadString(s, l[i], '');
            end;
            l.Free;
         finally
            Free;
         end;
      end;
   finally
      Leave;
   end;
end;

procedure TRadSav.SaveGrid(g: TAdvGrid);
var
   i: integer;
   n: integer;
   s: string;
   c: string;
   p: TDualColl;
   l: TStringList;
begin
   Enter;
   try
      with TMemIniFile.Create(FileName) do begin
         try
            l := TStringList.Create;
            ReadSection('Grids', l);
            for i := l.Count - 1 downto 0 do begin
               if pos(g.Name, l[i]) > 0 then begin
                  DeleteKey('Grids', l[i]);
               end;
            end;
            l.Free;
         finally
            UpdateFile;
            Free;
         end;
      end;
      for i := 1 to g.RowCount - 1 do begin
         s := '';
         for n := g.FixedCols to g.ColCount - 1 do begin
            c := g.Cells[n, i];
            if c = '' then c := '-';
            s := s + c + '|';
         end;
         WriteString('Grids', g.Name + IntToStr(i), s);
      end;
      i := StringsList.IndexOf(g.Name);
      if i > - 1 then begin
         p := StringsList.Objects[i] as TDualColl;
         FreeObject(p);
         StringsList.Delete(i);
      end;
   finally
      Leave;
   end;
end;

procedure TRadSav.SaveGrid(s: string; g: TAdvGrid);
var
  l: TStringList;
  i: integer;
begin
  Enter;
  try
    with TMemIniFile.Create(FileName) do
    begin
      try
        l := TStringList.Create;
        ReadSection(s, l);
        for i := 0 to l.Count - 1 do
          DeleteKey(s, l[i]);
        l.Free;
        for i := 0 to g.RowCount - 2 do
          WriteString(s, g.Cells[1, i + 1], g.Cells[2, i + 1]);
      finally
        UpdateFile;
        Free;
      end;
    end;
  finally
    Leave;
  end;
end;

constructor TRadSav.Create;
begin
  inherited Create;
  FileName := fn;
  InitializeCriticalSection(CS);
  StringsList := TStringList.Create;
end;

destructor TRadSav.Destroy;
var
  d: TDualColl;
  i: integer;
begin
   PurgeCS(CS);
   if StringsList <> nil then begin
      for i := 0 to StringsList.Count - 1 do begin
         d := StringsList.Objects[i] as TDualColl;
         FreeObject(d);
      end;
      StringsList.Free;
   end;
   inherited Destroy;
end;

procedure TDualColl.Add;
var
   p : ^TDualRec;
begin
   New(p);
   p.nam := NewStr(nam);
   p.st1 := NewStr(st1);
   p.st2 := NewStr(st2);
   inherited Add(p);
end;

procedure TDualColl.FreeItem;
var
   r : ^TDualRec absolute p;
begin
   DisposeStr(r.nam);
   DisposeStr(r.st1);
   DisposeStr(r.st2);
   Dispose(r);
end;

function TDualColl.MatchAddr;
var
   i: integer;
   s: string;
   r:^TDualRec;
begin
   Result := -1;
   for i := 0 to Count - 1 do begin
      r := Items[i];
      s := r.st1^;
      if (Pos(UpperCase(n), UpperCase(r.nam^)) = 1) and MatchMaskAddressListSingle(a, s) then begin
         Result := i;
         Break;
      end;
   end;
end;

end.
