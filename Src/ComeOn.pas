unit ComeOn;

interface

{$I DEFINE.INC}

procedure Come_On;
procedure _Come_On(P: Pointer);

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

{$IFDEF GRAB}
  Controls, Menus, StdCtrls, ExtCtrls, ComCtrls, MdmCmd,
  Import, AtomEdit, MlineCfg, FreqCfg, DevCfg, LineBits,
  ModemCfg, SelDir, PathName, NodelCfg, FidoPwd, DialRest,
  Attach, DupCfg, StupCfg, Extrnls, xEvents,
  EvtEdit, TracePl, EncLinks, FidoStat, FileBox, IpCfg,
  FreqEdit, PwdInput, NodeWiz, OvrExpl, PollCfg, SinglPwd,
  Setup, CheckLst,

{$ENDIF}

  OutBound, Windows, OdbcLog, CmdLn, Wizard, CfgFiles, Plus;

var
  inipath: string;

{$IFDEF GRAB}

{$I Grab.PAS}

procedure GrabForms;

procedure Grab(var Reference; FormClass: TFormClass);
begin
  Application.CreateForm(FormClass, Reference);
  GrabForm(TForm(Reference){, Format('..\LNG\ENG_%.2d.LNG', [AN])});
end;

var
   ImportForm          : TImportForm;
   AtomEditorForm      : TAtomEditorForm;
   MailerLineCfgForm   : TMailerLineCfgForm;
   FreqCfgForm         : TFreqCfgForm;
   DeviceConfig        : TDeviceConfig;
   FidoAddressInput    : TFidoAddressInput;
   NodelistCompiler    : TNodelistCompiler;
   LineBitsEditor      : TLineBitsEditor;
   ModemEditor         : TModemEditor;
//   SelectDirDialog     : TSelectDirDialog;
   PathNamesForm       : TPathNamesForm;
   NodeListCfgForm     : TNodeListCfgForm;
   PwdForm             : TPwdForm;
   RestrictCfgForm     : TRestrictCfgForm;
   MailerForm          : TMailerForm;
   AttachStatusForm    : TAttachStatusForm;
   MainConfigForm      : TMainConfigForm;
   StartupConfigForm   : TStartupConfigForm;
//   RegInputForm        : TRegInputForm;
   ExternalsForm       : TExternalsForm;
//   UnregForm           : TUnregForm;
   EventsForm          : TEventsForm;
   EvtEditForm         : TEvtEditForm;
   NodelistBrowser     : TNodelistBrowser;
   DisplayInfoForm     : TDisplayInfoForm;
   EncryptedLinksForm  : TEncryptedLinksForm;
   FidoTemplateEditor  : TFidoTemplateEditor;
   FileBoxesForm       : TFileBoxesForm;
   FReqDlg             : TFReqDlg;
   ModemCmdForm        : TModemCmdForm;
   NewPwdInputForm     : TNewPwdInputForm;
   NodeWizzardForm     : TNodeWizzardForm;
   OvrExplainForm      : TOvrExplainForm;
   PollSetupForm       : TPollSetupForm;
   SinglePasswordForm  : TSinglePasswordForm;
   StartWizzardForm    : TStartWizzardForm;
   IPcfgForm           : TIPcfgForm;

//   Pref                : TPreferences;
   Setup               : TSetupForm;

begin
  Grab(ImportForm          , TImportForm                     );
  Grab(AtomEditorForm      , TAtomEditorForm                 );
  Grab(MailerLineCfgForm   , TMailerLineCfgForm              );
  Grab(FreqCfgForm         , TFreqCfgForm                    );
  Grab(DeviceConfig        , TDeviceConfig                   );
  Grab(FidoAddressInput    , TFidoAddressInput               );
  Grab(NodelistCompiler    , TNodelistCompiler               );
  Grab(LineBitsEditor      , TLineBitsEditor                 );
  Grab(ModemEditor         , TModemEditor                    );
//  Grab(SelectDirDialog     , TSelectDirDialog                );
  Grab(PathNamesForm       , TPathNamesForm                  );
  Grab(NodeListCfgForm     , TNodeListCfgForm                );
  Grab(PwdForm             , TPwdForm                        );
  Grab(RestrictCfgForm     , TRestrictCfgForm                );
  Grab(MailerForm          , TMailerForm                     );
  Grab(AttachStatusForm    , TAttachStatusForm               );
  Grab(MainConfigForm      , TMainConfigForm                 );
  Grab(StartupConfigForm   , TStartupConfigForm              );
//  Grab(RegInputForm        , TRegInputForm                   );
  Grab(ExternalsForm       , TExternalsForm                  );
//  Grab(UnregForm           , TUnregForm                      );
  Grab(EventsForm          , TEventsForm                     );
  Grab(EvtEditForm         , TEvtEditForm                    );
  Grab(NodelistBrowser     , TNodelistBrowser                );
  Grab(DisplayInfoForm     , TDisplayInfoForm                );
  Grab(EncryptedLinksForm  , TEncryptedLinksForm             );
  Grab(FidoTemplateEditor  , TFidoTemplateEditor             );
  Grab(FileBoxesForm       , TFileBoxesForm                  );
  Grab(FReqDlg             , TFReqDlg                        );
  Grab(ModemCmdForm        , TModemCmdForm                   );
  Grab(NewPwdInputForm     , TNewPwdInputForm                );
  Grab(NodeWizzardForm     , TNodeWizzardForm                );
  Grab(OvrExplainForm      , TOvrExplainForm                 );
  Grab(PollSetupForm       , TPollSetupForm                  );
  Grab(SinglePasswordForm  , TSinglePasswordForm             );
  Grab(StartWizzardForm    , TStartWizzardForm               );
  Grab(IpCfgForm           , TIpCfgForm                      );
  Grab(Setup               , TSetupForm                      );
//  Grab(Pref                , TPreferences                    );
  StoreGrabbed;
  ExitProcess(0);
end;

{$ENDIF}

procedure Stop(const a, b: string);
begin
  Windows.MessageBox(0, PChar(A), PChar(B), MB_SETFOREGROUND or MB_TASKMODAL or MB_ICONSTOP or MB_OK);
end;

procedure AnotherArgus;
begin
//  Stop('Another instance is already running', ProductName);
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

function GetEMSICR: string;
var
   s: string;
begin
   s := GetRegStringDef('EMSI_CR', '%0D');
   UnpackRFC1945(s);
   Result := s;
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
{ZLib}
  ZLibHandle := 0;
  ZLibHandle := LoadLibrary(PChar(MakeNormName(HomeDir, 'zlib.dll')));
  if ZLibHandle <> 0 then begin
    @compress_ := GetProcAddress(ZLibHandle, 'compress2');
    @uncompress_ := GetProcAddress(ZLibHandle, 'uncompress');
    ZLibLoaded := True;
  end;

{BZip}
//  BZipHandle := 0;
//  BZipHandle := LoadLibrary(PChar(MakeNormName(HomeDir, 'bzip.dll')));
//  if BZipHandle <> 0 then begin
//    @compress_ := GetProcAddress(BZipHandle, 'compress2');
//    @uncompress_ := GetProcAddress(BZipHandle, 'uncompress');
//    BZipLoaded := True;
//  end;

end;

procedure FreePlugins;
begin
{ZLib}
 if ZLibHandle <> 0 then FreeLibrary(ZLibHandle);

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

  {$IFDEF GRAB}
  GrabForms;
  {$ENDIF}

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

  Application.ProcessMessages;
  FreeAllLines;
  FreeAllPolls(pdnShutDown, True);
  Application.ProcessMessages;

  DeInitTickTimer;

  DoneMailers;
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
  DoneMsgDispatcher;
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

procedure _Come_On(P: Pointer);
begin
  Come_on;
  exitprocess(0);
end;

procedure Come_On;
var st,s: string;
    b:boolean;
    sa: TStringArray;
    i:byte;
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
  b := True;
  if Copy(s, 1, 5) = 'DELAY' then begin
    b := False; 
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
{  if b then} TestAnotherArgus(proc_i);
  DoComeOn;
end;

end.

