unit ComeOn;

interface

{$I DEFINE.INC}

procedure Come_On;

implementation

uses
  Wsock, //Dialogs,
  Watcher,
  LngTools,
  MlrForm, MlrThr,
  Forms, SysUtils,
  Messages,
  classes, AltRecs, Netmail, NdlUtil, MClasses, RasThrd,
  xTAPI, xBase, xMisc, Recs, RadIni,
  OutBound, Windows, OdbcLog, CmdLn, Wizard, CfgFiles, Plus;

var
  inipath: string;

procedure AnotherArgus;
begin
  Halt;
end;

procedure TestAnotherArgus(const sss: string);
var
  H: THandle;
begin
  SetLastError(0);
  if sss = '' then inipath := MakeFullDir(JustPathname(paramstr(0)), JustFileNameOnly(ParamStr(0)) + '.ini')
  else inipath := sss;
  IniName := inipath;
  with TIniFile.Create(inipath) do begin
     sMutexName := ReadString('system', 'MutexName', 'ARGUS_SEMAPHORE');
     sActivateEventName := ReadString('system', 'ActivateEventName', 'ARGUS_EVENT_ACTIVATE');
     free;
  end;
  hMutex := CreateMutex(nil, False, PCHAR(sMutexName));
  if (hMutex = 0) then AnotherArgus;
  if (GetLastError = ERROR_ALREADY_EXISTS) then begin
     ZeroHandle(hMutex);
     H := OpenEvent(EVENT_MODIFY_STATE, False, PCHAR(sActivateEventName));
     if H = INVALID_HANDLE_VALUE then AnotherArgus else begin
        SetEvent(H);
        ZeroHandle(H);
        Halt;
     end;
  end;
end;

function proc_i: string;
var st,
    st2: string;
    sa: TStringArray;
     i: integer;
begin
  st := GetParamStr;
  if paramcount <> 0 then begin
    st := StrPas(StrPos(StrUpper(PChar(GetParamStr)), '-I'));
  end;

  scanandchange(st);
  sa := GetSwitches(st);
  st2 := '';
  for i := 1 to CountSwitches(st) do begin
    if copy(sa[i], 1, 3) = '-I:' then begin
      ExtractSubParam(sa[i], st2);
      break;
    end;
  end;
  result := st2;
end;

procedure LoadPlugins(const HomeDir: string);
begin
  ZLibLoaded := False;
  ZLibHandle := 0;
  ZLibHandle := LoadLibrary(PChar(MakeNormName(HomeDir, 'zlib.dll')));
  if ZLibHandle <> 0 then begin
    @zlibvers_ := GetProcAddress(ZLibHandle, 'zlibVersion');
    @compress_ := GetProcAddress(ZLibHandle, 'compress2');
    @uncompress_ := GetProcAddress(ZLibHandle, 'uncompress');
    @inflateini_ := GetProcAddress(ZLibHandle, 'inflateInit_');
    @deflateini_ := GetProcAddress(ZLibHandle, 'deflateInit_');
    @inflate_ := GetProcAddress(ZLibHandle, 'inflate');
    @deflate_ := GetProcAddress(ZLibHandle, 'deflate');
    @inflateend_ := GetProcAddress(ZLibHandle, 'inflateEnd');
    @deflateend_ := GetProcAddress(ZLibHandle, 'deflateEnd');
    ZLibLoaded := True;
  end;

  BZipLoaded := False;
  BZipHandle := 0;
  BZipHandle := LoadLibrary(PChar(MakeNormName(HomeDir, 'bzip.dll')));
  if BZipHandle <> 0 then begin
    @bzinflateini_ := GetProcAddress(BZipHandle, '_BZ2_bzDecompressInit');
    @bzdeflateini_ := GetProcAddress(BZipHandle, '_BZ2_bzCompressInit');
    @bzinflate_ := GetProcAddress(BZipHandle, '_BZ2_bzDecompress');
    @bzdeflate_ := GetProcAddress(BZipHandle, '_BZ2_bzCompress');
    @bzinflateend_ := GetProcAddress(BZipHandle, '_BZ2_bzDecompressEnd');
    @bzdeflateend_ := GetProcAddress(BZipHandle, '_BZ2_bzCompressEnd');
    BZipLoaded := True;
  end;

end;

procedure FreePlugins;
begin
  if ZLibHandle <> 0 then FreeLibrary(ZLibHandle);
  if BZipHandle <> 0 then FreeLibrary(BZipHandle);
end;

procedure DoComeOn;
var
  st2: string;
  s: string;
  v: TStringList;
  h: THandle;
begin
//  fShowExceptionCallback := ShowExceptionCallback;

  StartTime := GetTickCount;

  with TIniFile.Create(inipath) do begin
     s := ReadString('system', 'EMSI_CR', GetRegStringDef('EMSI_CR', '%0D'));
     UnpackRFC1945(s);
     sEMSI_CR := s;
     WinSockVersion := ReadInteger('system', 'WinSockVersion', GetRegIntegerDef('WinSockVersion', 0));
     ThrTimesLog := (Win32Platform = VER_PLATFORM_WIN32_NT) and ReadBool('system','LogThreadTimes', GetRegBooleanDef('LogThreadTimes', False));
     Free;
  end;

  st2 := proc_i;
  IniFName := inipath;
  LoadINI;

  LoadPlugins(IniFile.HomeDir);

  IsHTMLHelp := not IniFile.NoHTML;

  xBaseInit;

  PrepareVariables;

  if inifile.ODBCLogging then OdbcLogInitialize;

  InitMsgDispatcher;

  if inifile.RASEnabled then begin
     RasThrd.StartRas;
  end else begin
     RasThread := nil
  end;

  StartWatcher;
  SetLanguage(GetRegInterfaceLng);

  Application.Initialize;

  Application.ShowHint := True;

  RegisterConfig;
  AltRegisterConfig;

  LoadConfig;
  AltLoadConfig;

  StartupOptions := Cfg.StartupData.Options;

  TrapLogFName := MakeNormName(dLog, 'traps.log');
  EMSILogFName := MakeNormName(dLog, 'Remsi.log');
  WaitLogFName := MakeNormName(dLog, 'WaitE.log');
  EntrLogFName := MakeNormName(dLog, 'Enter.log');
  NetmailLog   := MakeNormName(dLog, 'Netml.log');
  CopyFile(PChar(EntrLogFName), PChar(MakeNormName(dLog, 'Enter.bak')), False);
  VersLogFName := MakeNormName(dLog, 'Tau_Ver');
  h := _CreateFileDir(VersLogFName, [cWrite, cCanPending]);
  ZeroHandle(h);
  v := TStringList.Create;
  v.Add(GetOSVer);
  v.Add('Taurus v.' + ProductVersion);
  v.SaveToFile(VersLogFName);
  v.Free;

{.$IFDEF THRLOG}
  ThreadsLogFName := MakeNormName(dLog, 'threads.txt');
{.$ENDIF}

  LoadIntegers;
  AltLoadIntegers;

  InitTickTimer;

  InitFidoOut;
  InitNdlUtil;

  if NodelistMissed then begin
     VCompileNodelist(True);
  end;

  InitMailers;

  LoadHistory;

  OpenBWZlog;

  InitHelp;

  PurgeActiveFlags;

  OpenMailerForm(PanelOwnerPolls, False);

  OdbcLogCheckInit(MakeNormName(dLog, 'odbcerr.log'));

  if StartupOptions and stoRunIpDaemon <> 0 then _RunDaemon;

  InitTAPI;

  OpenAutoStartLines;

  PostMsg(WM_UPDATEMENUS);

  Sleep(100);

  Application.ProcessMessages;

  TMailerForm(Application.MainForm).SuperShow;

  Application.Run;

  StopWatcher;
  Application.MainForm.Free;

  FinishTAPI;

  if StoreConfigAfter then StoreConfig(0);
  if AltStoreConfigAfter then AltStoreConfig(0);

  RasThrd.FinishRas;

  FreePlugins;

//  Application.ProcessMessages;
  FreeAllLines;
  FreeAllPolls(pdnShutDown, True);
//  Application.ProcessMessages;

  DeInitTickTimer;

  DoneMailers;

  DoneMsgDispatcher;

  DoneFidoOut;
  FreeNetmailHolder;
  FreeNodeController;
  DoneNdlUtil;
  CloseBWZlog;
  StoreHistory;

  StoreIntegers;
  UnPrepareVariables;
  AltStoreIntegers;

  FreeCfgContainer;
  AltFreeCfgContainer;
  FreeRegExprList;
  OdbcLogDone;
  xBaseDone;
  DoneMClasses;
  LanguageDone;

  FreeIni;
  ZeroHandle(hMutex);

  ApplicationDone := True;
end;

procedure DoGetStartupInfo;
var
   S: TStartupInfo;
begin
   Clear(S, SizeOf(S));
   S.cb := SizeOf(S);
   GetStartupInfo(S);
   if S.dwFlags and STARTF_USESHOWWINDOW <> 0 then
     FStartMinimized := (S.wShowWindow = SW_MINIMIZE) or
                        (S.wShowWindow = SW_SHOWMINIMIZED) or
                        (S.wShowWindow = SW_SHOWMINNOACTIVE);
end;

procedure Come_On;
var
  st,
   s: string;
  sa: TStringArray;
   i: byte;
begin
   DoGetStartupInfo;
   Application.Title := 'Taurus [init]';
   CurrentProcessHandle := GetCurrentProcess;
   CurrentThreadHandle := GetCurrentThread;

   st := GetParamStr;
   if paramcount <> 0 then begin
      st := StrPas(StrPos(StrUpper(PChar(GetParamStr)), 'DELAY'));
   end;

   s := UpperCase(st);
   s := ExtractWord(1, s, [' ']);
   if Copy(s, 1, 5) = 'DELAY' then begin
      delete(s, 1, 5);
      Sleep(strtointdef(s, 9000));
   end;
   st := GetParamStr;
   scanandchange(st);
   if paramcount <> 0 then begin
      st := StrPas(StrPos(StrUpper(PChar(GetParamStr)), '-I'));
   end;

   st := GetParamStr;
   scanandchange(st);
   sa := GetSwitches(st);
   for i := 1 to CountSwitches(st) do begin
      st := StrPas(StrPos(StrUpper(PChar(GetParamStr)), '-I'));
   end;
   TestAnotherArgus(proc_i);
   DoComeOn;
end;

end.

