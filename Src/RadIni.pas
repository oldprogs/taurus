unit RadIni;

{$I DEFINE.INC}

interface

uses Windows, Classes, xFido, Recs, xBase, Menus, MGrids;

const
  IniConfig = 'Taurus.ini';
  MaxLine = 20;

type
  TRadArr = array [1..maxline, 1..2] of string[255];
  TRadArrRec = record
    Table: TRadArr;
    Count: byte;
  end;
  TRadBWZWWW = array [0..4] of integer;
  TRadMainForm = array [0..3] of smallint;
  TRadPolls = array [0..7] of word;
  TRadMFRec = record
    Bounds: TRadMainForm;
    Maximized: 0..1;
  end;
  TRadOutMgr = array[0..5] of integer;

  TDualRec = record
     st1,
     st2: PString;
  end;

  TDualColl = class(TColl)
     procedure Add(const st1, st2: string);
     procedure FreeItem(p: pointer); override;
     function MatchAddr(a: TFidoAddress): integer;
  end;

  TRadFidoPollsFlags = record
    Busy : DWORD;
    NoC : DWORD;
    Fail : DWORD;
    Retry : DWORD;
    StandOff : DWORD;
    TimeDial : DWORD;
  end;

  TConfig = class
            _startras: integer;

            StatxPurgeData: boolean;
            DontClearTmr: boolean;
            IgnoreBWZSize: boolean;
            UseNodelistData: boolean;
            PlaySounds: boolean;
            AutoNodelist: boolean;
            accessFName: string;
            agentFName:string;
            StatxFName:string;
            Polls_log:string;
            Cronapps_log:string;
            tariff_log:string;
            PerMinute: boolean;
{$IFDEF WS}
            IPDaemon_log:string;
{$ENDIF}
{$IFDEF RASDIAL}
            ras_log:string;
{$ENDIF}
            ODBCLogging:boolean;
            CloseBWZFile:boolean;
            ForceAddFaxPage:boolean;
            IgnoreEndSession:boolean;
            IncrementArcmail:boolean;
            CPS_MinBytes:DWORD;
            CPS_MinSecs:DWORD;
            FlagsCheckPeriod:byte;
            FlagsDir:string;
            GaugeFore:integer;
            WaitSecRescan:integer;
            GaugeBack:integer;
            LoggerFore:integer;
            LoggerBack:integer;
            BadWazooFore:integer;
            BadWazooBack:integer;
            AlwaysInTray:boolean;
            Stealth:boolean;
            PopupKey: TShortCut;
            Priority: DWORD;
            ShowBalloon:boolean;
            ShowBalloonMin:boolean;
            ShowMenuIcons:boolean;
            UseSpace:boolean;
            DoubleClick:boolean;
            TransmitHold: Boolean;
            DirectAsNormal: Boolean;
            PollAddFlags: string;
            NoHTML: boolean;
            GridInBWZ: boolean;
            AllViaProxy: boolean;
            GridInPV: Boolean;
            TimeShift: integer;
{$IFDEF RASDIAL}
            RASEnabled: Boolean;
            iEntryName:  string;
{$ENDIF}
{$IFDEF USE_TAPI}
            TAPIDebug: boolean;
            TAPIConnect: DWORD;
{$ENDIF}
            HomeDir:  string;
            CfgDir:   string;
            InTemp:   string;
            InSecure: string;
            Log:      string;
            Outbound: string;
            InCommon: string;
            lang: integer;
            helplang: string;
            Synch: TFidoAddress;
            MainAddr: TFidoAddress;
            MainReg: integer;
            SessionOKFlag: boolean;
            SessionAbortedFlag: boolean;
            FreeSpaceLmt: Integer;
            ExtBanner: boolean;
            MaxTimeDiff: Integer;
            OnClose: Integer;
            WinDlgTWait: Integer;
            FixedRetryTimeout: boolean;
            DynamicOutbound: boolean; //restart needed if changed
            DynamicRouting: boolean;
            D5Out: boolean; //restart needed if changed
            RequestCRYPT: boolean;
            ibnRequestLIST: boolean;
            hydRequestLIST: boolean;
            Remote_Enabled: boolean;
            Remote_Password: string;
            Remote_EncPwd: boolean;
            HydraShortLongfilename: boolean;
            HydraUTCDefault: boolean;
            HydraOEM: boolean;
            HydraDebug: boolean;
            FTPDebug: boolean;
            HydraTxWindow: integer;
            HydraRxWindow: integer;
            DontLogTariff: boolean;
            MaxBWZAge: integer;
            MaxBSYAge: integer;
            MaxUDLAge: dword;
            ChatBell: string;
            ChatEnabled: boolean;
            ChatIgnoreFile: string;
            IgnoreCD: boolean;
            TrayLamps: boolean;

            OldMail7Fore: integer;
            OldMail14Fore: integer;
            OldMail21Fore: integer;
            OldMail28Fore: integer;

            OldMail7Back: integer;
            OldMail14Back: integer;
            OldMail21Back: integer;
            OldMail28Back: integer;

            FormsFontName: string;
            FormsFontAttr: string;
            FormsFontSize: integer; // оставь в покое этот сайз ;)

            LoggerFontName: string;
            LoggerFontAttr: string;
            LoggerFontSize: integer;
            //        ^^^^ !

            ExtApp: TRadArrRec;
            RadBWZ: TRadBWZWWW;
            RadOut: TRadOutMgr;
            RadMF: TRadMFRec;
            RadNB: TRadMFRec;
            RadPolls: TRadPolls;
            FPFlags: TRadFidoPollsFlags;

            BindAddr: string;
            ProxyType: TProxyType;
            InBandwidth: integer;
            OutBandwidth: integer;
            EnableProxyAuth: boolean;
            ProxyUserName: string;
            ProxyPassword: string;
            EncryptProxyPassword: boolean;

            DisableWinsockTraps: boolean;
            SimpleBSY: boolean;

            NetmailAddrTo: TStringColl;
            NetmailAddrFrom: TStringColl;
            NetmailPwd: TStringColl;

            SplitA,
            SplitB: integer;

            CS: TRTLCriticalSection;

            logDelete: boolean;
            logWaitEvt: boolean;
            UseAntiHang: boolean;

            StringsList: TStringList;

            constructor Create;
            destructor Destroy; override;
            procedure ReadConfig;
            procedure WriteConfig;
            procedure StoreCfg;

            procedure Enter;
            procedure Leave;

            function ReadString(Sect, Line: string): string; overload;
            function ReadString(Sect, Line, Def: string): string; overload;
            procedure WriteString(Sect, Line, Val: string);
            function ReadBool(Sect, Line: string): boolean;
            function ReadInteger(Sect, Line: string): integer; overload;
            function ReadInteger(Sect, Line: string; Def: integer): integer; overload;
            function ReadSection(Sect, Line: string): TStringList;
            function GetStrings(n: string): TDualColl;
            procedure LoadGrid(g: TAdvGrid);
            procedure SaveGrid(g: TAdvGrid);
      end;

procedure LoadIni;
procedure FreeIni;
procedure IniEnter;
procedure IniLeave;

var
  IniFile: TConfig;
  IniFileCCC: integer = 0;

implementation

uses SysUtils, Forms, IniFiles, wizard, crypt;

const
  main = 'Main';
  colors = 'Colors';
  hydra = 'Hydra';
  binkp = 'Binkp';
  FTP = 'FTP';
  _system = 'System';
  _interface = 'Interface';
  polls = 'Polls';
  tray = 'Tray';
  sizes = 'Sizes';
  tariff = 'Tariff';
  remote = 'Remote';
  paths = 'Paths';
  ip = 'Ip';
  ExtApps = 'ExtApps';
  Netmail = 'Netmail';
  _RasDial = 'RasDial';
  lognames = 'LogNames';
  _tapi = 'TAPI';
  sounds = 'Sounds';
{$IFDEF EXTREME}
  smtp = 'SMTP';
{$ENDIF}  

procedure LoadIni;
begin
  IniFile := TConfig.Create;
  IniFile.ReadConfig;
end;

procedure FreeIni;
begin
  IniFile.Free;
  IniFile := nil;
end;

procedure IniEnter;
begin
  IniFile.Enter;
  Inc(IniFileCCC);
end;

procedure IniLeave;
begin
  Dec(IniFileCCC);
  IniFile.Leave;
  if IniFileCCC < 0 then GlobalFail('%s', ['Unexpected IniLeave!']);
end;

procedure TConfig.Enter;
begin
  EnterCS(CS);
end;

procedure TConfig.Leave;
begin
  LeaveCS(CS);
end;

function TConfig.ReadString(Sect, Line: string): string;
begin
   Result := ReadString(Sect, Line, Line);
end;

function TConfig.ReadString(Sect, Line, Def: string): string;
begin
   with TIniFile.Create(IniFName) do begin
      try
         Result := ReadString(Sect, Line, Def);
      finally
         Free;
      end;
   end;
end;

function TConfig.ReadBool(Sect, Line: string): boolean;
begin
   with TIniFile.Create(IniFName) do begin
      try
         Result := ReadBool(Sect, Line, True);
      finally
         Free;
      end;
   end;
end;

function TConfig.ReadInteger(Sect, Line: string): integer;
begin
   Result := ReadInteger(Sect, Line, 0);
end;

function TConfig.ReadInteger(Sect, Line: string; Def: integer): integer;
begin
   with TIniFile.Create(IniFName) do begin
      try
         Result := ReadInteger(Sect, Line, Def);
      finally
         Free;
      end;
   end;
end;

procedure TConfig.WriteString;
begin
   with TIniFile.Create(IniFName) do begin
      try
         WriteString(Sect, Line, Val);
      finally
         Free;
      end;
   end;
end;

function TConfig.ReadSection;
var
   i: integer;
begin
   with TIniFile.Create(IniFName) do begin
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
end;

function TConfig.GetStrings;
var i: integer;
    s: TStringList;
    t: string;
    m: integer;
begin
   i := StringsList.IndexOf(n);
   if i > -1 then begin
      Result := StringsList.Objects[i] as TDualColl;
      exit;
   end;
   with TIniFile.Create(IniFName) do begin
      try
         s := TStringList.Create;
         ReadSection('Grids', s);
         Result := TDualColl.Create;
         m := StringsList.Add(n);
         StringsList.Objects[m] := Result;
         for i := 1 to s.Count do begin
            t := ReadString('Grids', s[i - 1], '');
            Result.Add(ExtractWord(1, t, ['|']),
                       ExtractWord(2, t, ['|']));
         end;
         s.Free;
      finally
         Free;
      end;
   end;
end;

procedure TConfig.LoadGrid;
var s: TStringList;
    i: integer;
    n: integer;
    r: integer;
    t: string;
    c: string;
begin
   with TIniFile.Create(IniFName) do begin
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
end;

procedure TConfig.SaveGrid;
var i: integer;
    n: integer;
    s: string;
    c: string;
    p: TDualColl;
    l: TStringList;
begin
   with TIniFile.Create(IniFName) do begin
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
end;

constructor TConfig.Create;
begin
  InitializeCriticalSection(CS);
  NetmailAddrTo := TStringColl.Create;
  NetmailAddrFrom := TStringColl.Create;
  NetmailPwd := TStringColl.Create;
  StringsList := TStringList.Create;
end;

destructor TConfig.Destroy;
var d: TDualColl;
    i: integer;
begin
  PurgeCS(CS);
  FreeObject(NetmailAddrTo);
  FreeObject(NetmailAddrFrom);
  FreeObject(NetmailPwd);
  if StringsList <> nil then begin
     for i := 0 to StringsList.Count - 1 do begin
        d := StringsList.Objects[i] as TDualColl;
        FreeObject(d);
     end;
     StringsList.Free;
  end;
  inherited Destroy;
end;

function Hex2Dec(const S: string): Longint;
var
  HexStr: string;
begin
  if Pos('$', S) = 0 then HexStr := '$' + S
  else HexStr := S;
  Result := StrToIntDef(HexStr, 0);
end;

procedure TConfig.ReadConfig;

var
  ini: TIniFile;
  _lang: integer;
  l: TStringList;
  i: integer;
  s, o: string;

function GetExtApp: TRadArrRec;
var
  S: TStringList;
  tmpstr: string;
  I: byte;
begin
  S := TStringList.Create;
  ini.ReadSection(ExtApps, s);
  result.Count := s.Count;
  if result.Count > 0 then
    for I := 1 to result.Count do
    begin
      tmpstr := ini.ReadString(ExtApps, s.Strings[I - 1], 'n/a');
      result.Table[I,1] := ExtractWord(1, tmpstr, ['|']);
      result.Table[I,2] := ExtractWord(2, tmpstr, ['|']);
    end;
  S.Free;
end;

function GetBWZW: TRadBWZWWW;
var
  s: string;
  i: byte;
begin
  s := ini.ReadString(sizes, 'BWZListView', '133,60,60,63,57');
  for i := 0 to 4 do result[i] := StrToIntDef(ExtractWord(i + 1, s, [',']), 70);
end;

function GetOut: TRadOutMgr;
var
  s: string;
  i: byte;
begin
  s := ini.ReadString(sizes, 'OutMgrHdr', '349,142,81,53,70,80');
  for i := 0 to 5 do result[i] := StrToIntDef(ExtractWord(i + 1, s, [',']), 70);
end;

function GetMF: TRadMFRec;
var
  s: string;
begin
  s := Ini.ReadString(sizes, 'MainForm', '223,1,700,621,0');
  result.Bounds[0] := StrToIntDef(ExtractWord(1, s, [',']), 223);
  result.Bounds[1] := StrToIntDef(ExtractWord(2, s, [',']), 005);
  result.Bounds[2] := StrToIntDef(ExtractWord(3, s, [',']), 700);
  result.Bounds[3] := StrToIntDef(ExtractWord(4, s, [',']), 621);
  result.Maximized := StrToIntDef(ExtractWord(5, s, [',']), 000);
  if Result.Bounds[2] = 700 then begin
     Result.Bounds[2] := Screen.Width  - 1 - Result.Bounds[0];
  end;
end;

function GetNB: TRadMFRec;
var
  s: string;
begin
  s := Ini.ReadString(sizes, 'NodeBrws', '391,12,619,470,0');
  result.Bounds[0] := StrToIntDef(ExtractWord(1, s,[',']), 138);
  result.Bounds[1] := StrToIntDef(ExtractWord(2, s,[',']), 194);
  result.Bounds[2] := StrToIntDef(ExtractWord(3, s,[',']), 617);
  result.Bounds[3] := StrToIntDef(ExtractWord(4, s,[',']), 496);
  result.Maximized := StrToIntDef(ExtractWord(5, s,[',']),   0);
end;

function GetPolls: TRadPolls;
var
  s: string;
begin
  s := ini.ReadString(sizes, 'PollsListView', '141,298,77,54,54,53,48,49');
  result[0] := StrToIntDef(ExtractWord(1, s,[',']), 100);
  result[1] := StrToIntDef(ExtractWord(2, s,[',']), 170);
  result[2] := StrToIntDef(ExtractWord(3, s,[',']),  80);
  result[3] := StrToIntDef(ExtractWord(4, s,[',']),  60);
  result[4] := StrToIntDef(ExtractWord(5, s,[',']),  40);
  result[5] := StrToIntDef(ExtractWord(6, s,[',']),  40);
  result[6] := StrToIntDef(ExtractWord(7, s,[',']),  40);
  result[7] := StrToIntDef(ExtractWord(8, s,[',']),  60);
end;

function GetFPF:TRadFidoPollsFlags;
begin
  result.TimeDial := Ini.ReadInteger(polls, 'TimeDial', 120);
  result.Busy := Ini.ReadInteger(polls, 'Busy', 99);
  result.NoC := Ini.ReadInteger(polls, 'NoC', 10);
  result.Fail := Ini.ReadInteger(polls, 'Fail', 10);
  result.Retry := Ini.ReadInteger(polls, 'Retry', 100);
  result.StandOff := Ini.ReadInteger(polls, 'StandOff', 1);
end;

begin
  ini := TIniFile.Create(IniFName);
  with ini do
    try
      InTemp := MakeFullDir('', ReadString(paths, 'TempInbound', ExtractFilePath(ParamStr(0)) + 'INTMP'));
      InSecure := MakeFullDir('', ReadString(paths, 'SecureInbound', ExtractFilePath(ParamStr(0)) + 'INSEC'));
      Log := MakeFullDir('', ReadString(paths, 'Logs', ExtractFilePath(ParamStr(0)) + 'LOG'));
      Outbound := MakeFullDir('', ReadString(paths, 'Outbound', ExtractFilePath(ParamStr(0)) + 'OUT'));
      InCommon := MakeFullDir('', ReadString(paths, 'Inbound', ExtractFilePath(ParamStr(0)) + 'IN'));
      HomeDir := MakeFullDir('', ReadString(paths, 'HomeDir', ExtractFilePath(ParamStr(0))));
      CfgDir := MakeFulldir('', ReadString(paths, 'config', ExtractFilePath(ParamStr(0))));
      FlagsDir := MakeFullDir('', ReadString(paths, 'flags', ExtractFilePath(ParamStr(0)) + 'FLAGS'));

      accessFName := ReadString(LogNames, 'access_log', GetRegStringDef('access_log', 'access_log'));
      agentFName := ReadString(LogNames, 'agent_log', GetRegStringDef('agent_log', 'agent_log'));
      StatxFName := ReadString(LogNames, 'binary_log', GetRegStringDef('binary_log', 'binary_log'));
      Polls_log := ReadString(LogNames, 'polls.log', 'polls.log');
      Tariff_log := ReadString(LogNames, 'tariff.log', 'tariff.log');
      Cronapps_log := ReadString(LogNames, 'cronapps.log', 'cronapps.log');
{$IFDEF WS}
      IPDaemon_log := ReadString(LogNames, 'ipdaemon.log', 'ipdaemon.log');
{$ENDIF}
{$IFDEF RASDIAL}
      ras_log := ReadString(LogNames, 'ras.log', 'ras.log');
{$ENDIF}

      CPS_MinBytes := ReadInteger(main, 'CPS_MinBytes', $100);
      CPS_MinSecs := ReadInteger(main, 'CPS_MinSecs', 10);
      FlagsCheckPeriod := ReadInteger(main, 'FlagsCheckPeriod', 31);
      WaitSecRescan := ReadInteger(main, 'WaitSecsRescan', 2000);
      SessionOKFlag := ReadBool(main, 'SessionOKFlag', false);
      SessionAbortedFlag := ReadBool(main, 'SessionAbortedFlag', false);
      D5Out := ReadBool(main, 'D5Out', false);
      ParseAddress(ReadString(main, 'synch', '0:0/0.0'), Synch);
      ParseAddress(ReadString(main, 'MainAddr', '0:0/0.0'), MainAddr);
      TimeShift := ReadInteger(main, 'SynchTimeShift', 0);
      MainReg := ReadInteger(main, 'MainReg', 0);
      NoHTML := ReadBool(main, 'DisableHTMLHelp', GetRegBooleanDef('DisableHtmlHelp', False));
      OnClose := ReadInteger(main, 'OnClose', 0);
      FreeSpaceLmt := ReadInteger(main, 'FreeSpaceLimit', 0);
      WinDlgTWait := ReadInteger(main, 'WinDlgTWait', 10);
      MaxTimeDiff := ReadInteger(main, 'MaxTimeDiff', 45);
      FixedRetryTimeout := ReadBool(main, 'FixedRetryTimeout', false);
      DontClearTmr := ReadBool(main, 'DontClearTmr', false); // undocumented feature!
      DynamicOutbound := ReadBool(main, 'DynamicOutbound', false);
      DynamicRouting := ReadBool(main, 'DynamicRouting', false);
      MaxBWZAge := ReadInteger(main, 'MaxBWZAge', 3 * day);
      MaxBSYAge := ReadInteger(main, 'MaxBSYAge', 3 * day);
      MaxUDLAge := ReadInteger(main, 'MaxUDLAge', 0);
      if MaxUDLAge = 0 then MaxUDLAge := INVALID_FILE_SIZE;
      ChatBell := ReadString(main, 'ChatBell', '');
      if ChatBell = '0' then ChatBell := '';
      ChatEnabled := ReadBool(main, 'ChatEnabled', False);
      ChatIgnoreFile := ReadString(main, 'ChatIgnoreFile', '');
      IgnoreCD := ReadBool(main, 'IgnoreCD', False);
      TrayLamps := ReadBool(main, 'TrayLamps', False);
      UseSpace := ReadBool(main, 'UseSpace', true);
      UseNodelistData := ReadBool(main, 'UseNodelistData', false);
      PlaySounds := ReadBool(main, 'PlaySounds', false);

      BindAddr := ReadString(IP, 'BindAddr', 'ANY');

      GaugeFore := Hex2Dec(ReadString(colors, 'GaugeFore', '000000'));
      GaugeBack := Hex2Dec(ReadString(colors, 'GaugeBack', 'A0DFE0'));
      LoggerFore := Hex2Dec(ReadString(colors, 'LoggerFore', '000000'));
      LoggerBack := Hex2Dec(ReadString(colors, 'LoggerBack', 'BBCACC'));
      BadWazooFore := Hex2Dec(ReadString(colors, 'BadWazooFore', '000000'));
      BadWazooBack := Hex2Dec(ReadString(colors, 'BadWazooBack', 'FFFFFF'));
      OldMail7Fore := Hex2Dec(ReadString(colors, 'OldMail7Fore',  '80000005'));
      OldMail14Fore := Hex2Dec(ReadString(colors, 'OldMail14Fore', '80000005'));
      OldMail21Fore := Hex2Dec(ReadString(colors, 'OldMail21Fore', '80000005'));
      OldMail28Fore := Hex2Dec(ReadString(colors, 'OldMail28Fore', '80000005'));
      OldMail7Back := Hex2Dec(ReadString(colors, 'OldMail7Back',  '0000FF'));
      OldMail14Back := Hex2Dec(ReadString(colors, 'OldMail14Back', '0000FF'));
      OldMail21Back := Hex2Dec(ReadString(colors, 'OldMail21Back', '0000FF'));
      OldMail28Back := Hex2Dec(ReadString(colors, 'OldMail28Back', '0000FF'));

      AlwaysInTray := ReadBool(tray, 'AlwaysInTray', true);
      Stealth := ReadBool(tray, 'StealthMode', false);
      PopupKey := TextToShortCut(ReadString(tray, 'PopupKey', 'Ctrl+Alt+R'));
      DoubleClick := ReadBool(tray, 'DoubleClick', false);

      Priority := ReadInteger(_system, 'StartPriority', NORMAL_PRIORITY_CLASS);
      StatxPurgeData := ReadBool(_system, 'StatxPurgeData', true);
      IncrementArcmail := ReadBool(_system, 'IncrementArcmail', GetRegBooleanDef('IncrementArcmail', False));
      IgnoreEndSession := ReadBool(_system, 'IgnoreEndSession', GetRegBooleanDef('IgnoreEndSession', False));
      ODBCLogging := ReadBool(_system, 'ODBCLogging', GetRegBooleanDef('ODBC Logging', False));
      ForceAddFaxPage := ReadBool(_system, 'ForceFaxPage', GetRegBooleanDef('ForceFaxPage', False));
      CloseBWZFile := ReadBool(_system, 'CloseBWZFile', GetRegBooleanDef('CloseBWZFile', False));
      DisableWinsockTraps := ReadBool(_system, 'DisableWinsockTraps', GetRegBooleanDef('DisableWinsockTraps', False));
      SimpleBSY := ReadBool(_system, 'SimpleBSY', GetRegBooleanDef('SimpleBSY', False));
      IgnoreBWZSize := ReadBool(_system, 'IgnoreBWZSize', False);
      AutoNodelist := ReadBool(_system, 'AutoNodelist', True);
     {$IFDEF EXTREME}
      UseAntiHang := ReadBool(_system, 'UseAntiHang', True);
     {$ELSE}
      UseAntiHang := ReadBool(_system, 'UseAntiHang', false);
     {$ENDIF} 

      TransmitHold := ReadBool(polls, 'TransmitHold', true);
      DirectAsNormal := ReadBool(polls, 'DirectAsNormal', true);
      PollAddFlags := ReadString(polls, 'Flags', '1011');
      if length(PollAddFlags)<4 then PollAddFlags := PadCh(PollAddFlags, '0', 4 - length(PollAddFlags));

      ShowBalloon := ReadBool(_Interface, 'ShowBalloon', true);
      ShowBalloonMin := ReadBool(_Interface, 'ShowBalloonMin', true);
      ShowMenuIcons := ReadBool(_Interface, 'ShowMenuIcons', true);
      GridInBWZ := ReadBool(_interface, 'GridLinesInBWZ', false);
      GridInPV := ReadBool(_interface, 'GridLinesInPV', false);
      _lang := ReadInteger(_interface, 'language', 0);
      helplang := ReadString(_interface, 'helplang', 'en');
      FormsFontName := ReadString(_interface, 'FormsFontName', 'Arial');
      FormsFontSize := ReadInteger(_interface, 'FormsFontSize', 9);
      FormsFontAttr := ReadString(_interface, 'FormsFontAttr', '0000');

      LoggerFontName := ReadString(_interface, 'LoggerFontName', 'FixedSys');
      LoggerFontSize := ReadInteger(_interface, 'LoggerFontSize', 9);
      LoggerFontAttr := ReadString(_interface, 'LoggerFontAttr', '0000');

      if length(LoggerFontAttr) < 4 then LoggerFontAttr := PadCh(LoggerFontAttr, '0', 4 - length(LoggerFontAttr));

{$IFDEF RASDIAL}
      _StartRas := -1;
      if RASEnabled <> ReadBool(_RasDial, 'RASEnabled', True) then begin
         RASEnabled := not RASEnabled;
      end;
      iEntryName := ReadString(_RasDial, 'EntryName', 'Connection');
{$ENDIF}
      RequestCRYPT := ReadBool(binkp, 'RequestCRYPT', false);
      ibnRequestLIST := ReadBool(binkp, 'RequestLIST', false);

      Remote_Enabled := ReadBool(remote, 'enabled', false);
      Remote_EncPwd := ReadBool(remote, 'EncPwd', False);
      Remote_Password := ReadString(remote, 'pwd', '');
      if Remote_EncPwd then Remote_Password := DecodeStr(Remote_Password);

      DontLogTariff := not ReadBool(tariff, 'LogTariff', false);
      PerMinute := ReadBool(tariff, 'PerMinute', true);

      HydraShortLongfilename := ReadBool(hydra, 'Short_and_Long_filename', true);
      HydraOEM := ReadBool(hydra, 'OEM_CHARSET', true);
      HydraDebug := ReadBool(hydra, '_Debug', false);
      HydraTxWindow := ReadInteger(hydra, 'TxWindow', 0);
      HydraRxWindow := ReadInteger(hydra, 'RxWindow', 0);
      hydRequestLIST := ReadBool(hydra, 'RequestLIST', false);
      HydraUTCDefault := ReadBool(hydra, 'UTCDefault', false);

      FTPDebug := ReadBool(FTP, 'FTPDebug', false);

{$IFDEF USE_TAPI}
      TAPIDebug := ReadBool(_tapi, 'TAPIDebug', False);
      TAPIConnect := DWORD(ReadInteger(_tapi, 'TAPIConnect', 57600));
{$ENDIF}

      ExtApp := GetExtApp;

      RadBWZ := GetBWZW;
      RadOut := GetOut;
      RadMF := GetMF;
      RadNB := GetNB;
      RadPolls := GetPolls;
      FPFlags := GetFPF;

      ProxyType := TProxyType(ReadInteger(IP, 'ProxyType', 0));
      AllViaProxy := ReadBool(IP, 'AllViaProxy', false);
      InBandwidth := ReadInteger(IP, 'InIpBandwidth', 0);
      OutBandwidth := ReadInteger(IP, 'OutIpBandwidth', 0);
      EnableProxyAuth := ReadBool(IP,'EnableProxyAuth',False);
      ProxyUserName := ReadString(IP, 'ProxyUserName', '');
      ProxyPassword := ReadString(IP, 'ProxyPassword', '');
      EncryptProxyPassword := ReadBool(IP, 'EncryptProxyPassword', False);
      if EncryptProxyPassword then ProxyPassword := DecodeStr(ProxyPassword);

      l := TStringList.Create;
      if NetmailAddrTo.Count <> 0 then
      begin
        NetmailAddrTo.FreeAll;
        NetmailAddrFrom.FreeAll;
        NetmailPwd.FreeAll;
      end;

      ReadSection(Netmail, l);
      for i := 0 to l.Count - 1 do
      begin
        s := l[i];
        NetmailAddrTo.Add(s);
        s := Trim(ReadString(Netmail, s, ''));
        o := s;
        delete(o, pos('(', o) , length(o) - pos('(', o) + 1);
        o := Trim(o);
        NetmailAddrFrom.Add(o);
        if pos('(', s) <> 0 then
        begin
          delete(s, 1, pos('(', s));
          delete(s, pos(')', s), 1);
        end else s := '';
        NetmailPwd.Add(s);
      end;
      l.Free;

      SplitA := StrToInt(ExtractWord(1, ReadString(sizes, 'Splitters', '375,320'), [',']));
      SplitB := StrToInt(ExtractWord(2, ReadString(sizes, 'Splitters', '375,320'), [',']));

      logDelete := ReadBool(main, 'LogDelete', False);
      logWaitEvt := ReadBool(main, 'LogWaitEvt', False);

    finally
      free
    end;

    PostMsg(WM_TrayIcon);

    if Application.MainForm <> nil then PostMessage(Application.MainForm.Handle, WM_GRIDUPD,Ord(GridInBWZ), 0);//0 - BWZ; 1 - PV
    if Application.MainForm <> nil then PostMessage(Application.MainForm.Handle, WM_GRIDUPD,Ord(GridInPV), 1);//0 - BWZ; 1 - PV
    if Application.MainForm <> nil then PostMessage(Application.MainForm.Handle, WM_USESPACE,Ord(UseSpace), 0);
    if Application.MainForm <> nil then PostMessage(Application.MainForm.Handle, WM_SETCOLORS, 0, 0);
    if uppercase(HelpLang) = 'en' then begin
       Application.HelpFile := GetHelpFile(HomeDir, LangNames[lnEnglish]);
       HelpLanguageId := HelpLanguageEnglish;
       SetRegHelpLng(LangNames[lnEnglish]);
    end else
    if uppercase(HelpLang) = 'ru' then begin
       Application.HelpFile := GetHelpFile(HomeDir, LangNames[lnRussian]);
       HelpLanguageId := HelpLanguageRussian;
       SetRegHelpLng(LangNames[lnRussian]);
    end;

    if IsHtmlHelp <> not NoHTML then IsHtmlHelp := not NoHTML;
    Application.HelpFile := GetHelpFile(HomeDir, HelpLang);

    if _lang <> lang then begin
       lang := _lang;
       if Application.MainForm <> nil then PostMessage(Application.MainForm.Handle, WM_SetLang, lang, 1);
    end;
end;

procedure TConfig.WriteConfig;
var
  i: integer;
  s: string;
begin
  try
    if not DirectoryExists(ExtractFilePath(IniFName)) then CreateDir(ExtractFilePath(IniFName));
  except
    {showmessage('can''t create homedir!')}
    exit;
  end;
  with TIniFile.Create(IniFName) do begin
    try
      WriteInteger(main, 'CPS_MinBytes', CPS_MinBytes);
      WriteInteger(main, 'CPS_MinSecs', CPS_MinSecs);
      WriteInteger(main, 'FlagsCheckPeriod', FlagsCheckPeriod);
      WriteInteger(main, 'WaitSecsRescan', WaitSecRescan);
      WriteInteger(main, 'OnClose', OnClose);
      WriteBool(main, 'FixedRetryTimeout', FixedRetryTimeout);
      WriteBool(main, 'SessionAbortedFlag', SessionAbortedFlag);
      WriteString(main, 'synch', Addr2Str(Synch));
      WriteString(main, 'MainAddr', Addr2Str(MainAddr));
      WriteInteger(main, 'SynchTimeShift', TimeShift);
      WriteInteger(main, 'MainReg', MainReg);
      WriteBool(main, 'DisableHTMLHelp', NoHTML);
      WriteBool(main, 'UseSpace', UseSpace);
      WriteInteger(main, 'FreeSpaceLimit', FreeSpaceLmt);
//      WriteBool(main, 'ExtBanner', ExtBanner);
      WriteInteger(main, 'WinDlgTWait', WinDlgTWait);
      WriteInteger(main, 'MaxTimeDiff', MaxTimeDiff);
      WriteBool(main, 'FixedRetryTimeout', FixedRetryTimeout);
      WriteBool(main, 'DynamicOutbound', DynamicOutbound);
      WriteBool(main, 'D5Out', D5Out);
      WriteBool(main, 'DynamicRouting', DynamicRouting);
      WriteBool(main, 'SessionOKFlag', SessionOKFlag);
      WriteInteger(main, 'MaxBWZAge', MaxBWZAge);
      WriteInteger(main, 'MaxBSYAge', MaxBSYAge);
      if MaxUDLAge = INVALID_FILE_SIZE then MaxUDLAge := 0;
      WriteInteger(main, 'MaxUDLAge', MaxUDLAge);
      if MaxUDLAge = 0 then MaxUDLAge := INVALID_FILE_SIZE; //bug fixup!
      WriteString(main, 'ChatBell', ChatBell);
      WriteBool(main, 'ChatEnabled', ChatEnabled);
      WriteString(main, 'ChatIgnoreFile', ChatIgnoreFile);
      WriteBool(main, 'UseNodelistData', UseNodelistData);
      WriteBool(main, 'PlaySounds', PlaySounds);
      DeleteKey(main, 'WaitCDDrop');
      WriteBool(main, 'IgnoreCD', IgnoreCD);
      WriteBool(main, 'TrayLamps', TrayLamps);

      WriteString(colors, 'GaugeFore', IntToHex(GaugeFore, 6));
      WriteString(colors, 'GaugeBack', IntToHex(GaugeBack, 6));
      WriteString(colors, 'LoggerFore', IntToHex(LoggerFore, 6));
      WriteString(colors, 'LoggerBack', IntToHex(LoggerBack, 6));
      WriteString(colors, 'BadWazooFore', IntToHex(BadWazooFore, 6));
      WriteString(colors, 'BadWazooBack', IntToHex(BadWazooBack, 6));

      WriteBool(tray, 'DoubleClick', DoubleClick);
      WriteBool(tray, 'AlwaysInTray', AlwaysInTray);
      WriteBool(tray, 'StealthMode', Stealth);
      WriteString(tray, 'PopupKey', ShortCutToText(PopupKey));

      WriteInteger(_system, 'StartPriority', Priority);
      WriteBool(_system, 'StatxPurgeData', StatxPurgeData);
      WriteBool(_system, 'IncrementArcmail', IncrementArcmail);
      WriteBool(_system, 'IgnoreEndSession', IgnoreEndSession);
      WriteBool(_system, 'ODBCLogging', ODBCLogging);
      WriteBool(_system, 'ForceFaxPage', ForceAddFaxPage);
      WriteBool(_system, 'CloseBWZFile', CloseBWZFile);
      WriteBool(_system, 'DisableWinsockTraps', DisableWinsockTraps);
      WriteBool(_system, 'SimpleBSY', SimpleBSY);
      WriteBool(_system, 'IgnoreBWZSize', IgnoreBWZSize);
      WriteBool(_system, 'AutoNodelist', AutoNodelist);
     {$IFDEF EXTREME}
      WriteBool(_system, 'UseAntiHang', true);
     {$ELSE}
      WriteBool(_system, 'UseAntiHang', false);
     {$ENDIF} 

      WriteBool(polls, 'TransmitHold', TransmitHold);
      WriteBool(polls, 'DirectAsNormal', DirectAsNormal);
      WriteString(polls, 'Flags', PollAddFlags);

      WriteBool(_Interface, 'ShowBalloon', ShowBalloon);
      WriteBool(_Interface, 'ShowBalloonMin', ShowBalloonMin);
      WriteBool(_Interface, 'ShowMenuIcons', ShowMenuIcons);
      WriteBool(_interface, 'GridLinesInBWZ', GridInBWZ);
      WriteBool(_interface, 'GridLinesInPV', GridInPV);
      WriteInteger(_interface, 'language', lang);
      WriteString(_interface, 'helplang', helplang);
      WriteString(_interface, 'FormsFontName', FormsFontName);
      WriteInteger(_interface, 'FormsFontSize', FormsFontSize);
      WriteString(_interface, 'FormsFontAttr', FormsFontAttr);
      WriteString(_interface, 'LoggerFontName', LoggerFontName);
      WriteInteger(_interface, 'LoggerFontSize', LoggerFontSize);
      WriteString(_interface, 'LoggerFontAttr', LoggerFontAttr);

      WriteString(paths, 'flags', FlagsDir);
      WriteString(paths, 'TempInbound', InTemp);
      WriteString(paths, 'SecureInbound', InSecure);
      WriteString(paths, 'Logs', Log);
      WriteString(paths, 'Outbound', Outbound);
      WriteString(paths, 'Inbound', InCommon);
      WriteString(paths, 'HomeDir', HomeDir);
      WriteString(paths, 'config', CfgDir);

      WriteString(LogNames, 'access_log', accessFName);
      WriteString(LogNames, 'agent_log', agentFName);
      WriteString(LogNames, 'binary_log', StatxFName);
      WriteString(LogNames, 'polls.log', Polls_log);
      WriteString(LogNames, 'cronapps.log', Cronapps_log);
      WriteString(LogNames, 'tariff.log', tariff_log);
{$IFDEF WS}
      WriteString(LogNames, 'ipdaemon.log', IPDaemon_log);
{$ENDIF}
{$IFDEF RASDIAL}
      WriteString(LogNames, 'ras.log', ras_log);
{$ENDIF}

{$IFDEF RASDIAL}
      WriteBool(_RasDial, 'RASEnabled', RASEnabled);
      WriteString(_RasDial, 'EntryName', iEntryName);
{$ENDIF}

      WriteBool(tariff, 'LogTariff', not DontLogTariff);
      WriteBool(tariff, 'PerMinute', PerMinute);

      WriteBool(binkp, 'RequestCRYPT', RequestCRYPT);
      WriteBool(binkp, 'RequestLIST', ibnRequestLIST);

      WriteBool(hydra, 'UTCDefault', HydraUTCDefault);
      WriteBool(hydra, 'Short_and_Long_filename', HydraShortLongfilename);
      WriteBool(hydra, 'OEM_CHARSET', HydraOEM);
      WriteBool(hydra, '_Debug', HydraDebug);
      WriteInteger(hydra, 'TxWindow', HydraTxWindow);
      WriteInteger(hydra, 'RxWindow', HydraRxWindow);
      WriteBool(hydra, 'RequestLIST', hydRequestLIST);

      WriteBool(FTP, 'FTPDebug', FTPDebug);

{$IFDEF USE_TAPI}
      WriteBool(_tapi, 'TAPIDebug', TAPIDebug);
      WriteInteger(_tapi, 'TAPIConnect', TAPIConnect);
{$ENDIF}

      WriteBool(remote, 'enabled', Remote_Enabled);
      WriteBool(remote, 'EncPwd', Remote_EncPwd);
      if Remote_EncPwd then WriteString (remote, 'pwd', EncodeStr(Remote_Password))
      else WriteString (remote, 'pwd', Remote_Password);

      WriteString(colors, 'OldMail7Fore',  IntToHex(OldMail7Fore, 6));
      WriteString(colors, 'OldMail14Fore', IntToHex(OldMail14Fore, 6));
      WriteString(colors, 'OldMail21Fore', IntToHex(OldMail21Fore, 6));
      WriteString(colors, 'OldMail28Fore', IntToHex(OldMail28Fore, 6));
      WriteString(colors, 'OldMail7Back',  IntToHex(OldMail7Back, 6));
      WriteString(colors, 'OldMail14Back', IntToHex(OldMail14Back, 6));
      WriteString(colors, 'OldMail21Back', IntToHex(OldMail21Back, 6));
      WriteString(colors, 'OldMail28Back', IntToHex(OldMail28Back, 6));

{setfpf begin}
      WriteInteger(polls, 'TimeDial', FPFlags.TimeDial);
      WriteInteger(polls, 'NoC', FPFlags.NoC);
      WriteInteger(polls, 'Busy', FPFlags.Busy);
      WriteInteger(polls, 'Fail', FPFlags.Fail);
      WriteInteger(polls, 'Retry', FPFlags.Retry);
      WriteInteger(polls, 'StandOff', FPFlags.StandOff);
{end}

{sizes}
      WriteString(sizes, 'PollsListView', IntToStr(RadPolls[0]) + ',' +
                                          IntToStr(RadPolls[1]) + ',' +
                                          IntToStr(RadPolls[2]) + ',' +
                                          IntToStr(RadPolls[3]) + ',' +
                                          IntToStr(RadPolls[4]) + ',' +
                                          IntToStr(RadPolls[5]) + ',' +
                                          IntToStr(RadPolls[6]) + ',' +
                                          IntToStr(RadPolls[7]));


      WriteString(sizes, 'MainForm',      IntToStr(RadMF.Bounds[0]) + ',' +
                                          IntToStr(RadMF.Bounds[1]) + ',' +
                                          IntToStr(RadMF.Bounds[2]) + ',' +
                                          IntToStr(RadMF.Bounds[3]) + ',' +
                                          IntToStr(RadMF.Maximized));

      WriteString(sizes, 'NodeBrws',      IntToStr(RadNB.Bounds[0]) + ',' +
                                          IntToStr(RadNB.Bounds[1]) + ',' +
                                          IntToStr(RadNB.Bounds[2]) + ',' +
                                          IntToStr(RadNB.Bounds[3]) + ',' +
                                          IntToStr(RadNB.Maximized));

      WriteString(sizes, 'BWZListView',   IntToStr(RadBWZ[0]) + ',' +
                                          IntToStr(RadBWZ[1]) + ',' +
                                          IntToStr(RadBWZ[2]) + ',' +
                                          IntToStr(RadBWZ[3]) + ',' +
                                          IntToStr(RadBWZ[4]));

      WriteString(sizes, 'OutMgrHdr',     IntToStr(RadOut[0]) + ',' +
                                          IntToStr(RadOut[1]) + ',' +
                                          IntToStr(RadOut[2]) + ',' +
                                          IntToStr(RadOut[3]) + ',' +
                                          IntToStr(RadOut[4]) + ',' +
                                          IntToStr(RadOut[5]));

      WriteString(sizes, 'Splitters', IntToStr(SplitA) + ',' +
                                      IntToStr(SplitB));
{end}

      EraseSection(ExtApps);
      EraseSection(Netmail);

{Netmail}
      if NetmailAddrTo.Count > 0 then
        for i := 0 to NetmailAddrTo.Count - 1 do
        begin
          if (NetmailAddrFrom[i] = '*') and (NetmailAddrTo[i] = '*') then
            s := '*'
          else
            s := Trim(NetmailAddrFrom[i]) + ' (' + NetmailPwd[i] + ')';
          if i = NetmailAddrTo.Count - 1 then s := s + #13#10;
          WriteString(netmail, NetmailAddrTo[i] , s)
        end;
{end}

{setextapp}
      if ExtApp.Count > 0 then
        for i := 1 to ExtApp.Count do
          writestring(ExtApps, format('App%.2d', [i]), ExtApp.Table[i, 1] + '|' +
                                                       ExtApp.Table[i, 2]);
{end}

{IP}
      WriteInteger(IP, 'ProxyType', Integer(ProxyType));
      WriteString (IP, 'BindAddr', BindAddr);
      WriteInteger(IP, 'ProxyType', Integer(ProxyType));
      WriteInteger(Ip, 'InIpBandwidth', InBandwidth);
      WriteInteger(IP, 'OutIpBandwidth', OutBandwidth);
      WriteBool   (IP, 'EnableProxyAuth',EnableProxyAuth);
      WriteString (IP, 'ProxyUserName', ProxyUserName);
      WriteBool   (IP, 'EncryptProxyPassword', EncryptProxyPassword);
      if EncryptProxyPassword then
        WriteString (IP, 'ProxyPassword', EncodeStr(ProxyPassword))
      else
        WriteString (IP, 'ProxyPassword', ProxyPassword);
      WriteBool   (IP, 'AllViaProxy',AllViaProxy);
{end}
    finally
      Free;
    end;

//    (Application.MainForm As TMailerForm).TrayIcon.SeparateIcon :=  AlwaysInTray;

  end;
end;

procedure TConfig.StoreCFG;
begin
  WriteConfig;
end;

procedure TDualColl.Add;
var 
  p : ^TDualRec;
begin
   New(p);
   p.st1 := NewStr(st1);
   p.st2 := NewStr(st2);
   inherited Add(p);
end;

procedure TDualColl.FreeItem;
var 
  r : ^TDualRec absolute p;
begin
   DisposeStr(r.st1);
   DisposeStr(r.st2);
   Dispose(r);
end;

function TDualColl.MatchAddr;
var i: integer;
    s: string;
begin
   Result := -1;
   for i := 0 to Count - 1 do begin
      s := TDualRec(Items[i]^).st1^;
      if MatchMaskAddressListSingle(a, s) then begin
         Result := i;
         Break;
      end;
   end;
end;

end.
