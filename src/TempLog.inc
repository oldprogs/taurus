// ============= Tempoparily Logfile writer ============= //

const
  MonthS: array [1..12] of String[3] = ('Jan', 'Feb', 'Mar', 
                                        'Apr', 'May', 'Jun', 
                                        'Jul', 'Aug', 'Sep', 
                                        'Oct', 'Nov', 'Dec');

function LogDate: string;
var
  Year, Month, Day: Word;
begin
  DecodeDate(Now, Year, Month, Day);
  LogDate := FormatDateTime('dd-"' + MonthS[Month] + '"-yyyy hh:nn:ss.zzz', Now);
end;

function ReplaceStr(Sour, What, _To: String): String;
var
  I: Integer;
begin
  Result := Sour;
  I := Pos(AnsiUpperCase(What), AnsiUpperCase(Result));
  while I <> 0 do begin
    Delete(Result, I, Length(What));
    Insert(_To, Result, I);
    I := Pos(AnsiUpperCase(What), AnsiUpperCase(Result));
  end;
end;

function HasExtension(Name: string; var DotPos: Word): Boolean;
var
  I: Word;
begin
  DotPos := 0;
  for I := Length(Name) downto 1 do
    if (Name[I] = '.') and (DotPos = 0) then
      DotPos := I;
  HasExtension := (DotPos > 0) and (Pos('\', Copy(Name, Succ(DotPos), 64)) = 0);
end;

function ForceExtension(Name, Ext: string): string;
var
  DotPos: Word;
begin
  if HasExtension(Name, DotPos) then
    ForceExtension := Copy(Name, 1, DotPos) + Ext
  else
    ForceExtension := Name + '.' + Ext;
end;

function LogFName: String;
begin
  Result := IncludeTrailingPathDelimiter(ExtractFileDir(ParamStr(0))) + ForceExtension(ExtractFileName(ParamStr(0)), 'test.log');
end;

function AddStringToLog(Sign, Action: String): String;
var
  LogFile: TextFile;

  procedure OpenLogFile;
  begin
    AssignFile(LogFile, LogFName);
    try
      Append(LogFile);
    except
      Rewrite(LogFile);
    end;
  end;

begin
//  EnterCriticalSection(CS);
  OpenLogFile;
  if Sign = ''
    then Result := ''
    else begin
      Action := ReplaceStr(Action, #13#10, '!@#$@!#$$#@#$@$%^%#@##$');
      Action := ReplaceStr(Action, #10#13, '!@#$@!#$$#@#$@$%^%#@##$');
      Action := ReplaceStr(Action, #13,    '!@#$@!#$$#@#$@$%^%#@##$');
      Action := ReplaceStr(Action, #10,    '!@#$@!#$$#@#$@$%^%#@##$');
      Action := ReplaceStr(Action, '!@#$@!#$$#@#$@$%^%#@##$', #13#10 + StringOfChar(' ', Length(LogDate) + 3));
      Result := Format('%s %s %s', [Sign, LogDate, Action]);
    end;
  Writeln(LogFile, Result);
  CloseFile(LogFile);
//  LeaveCriticalSection(CS);
//  Result := Copy(Result, 1, WindMax.x - 1);
end;

// ============= Tempoparily Logfile writer ============= //
