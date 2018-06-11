program Taurus;

//{$IMAGEBASE $400000}

{$R 'folders.res' 'folders.rc'}
{.$R 'VerInfo.RES' 'VerInfo.rc'}
{$R 'main.res' 'main.rc'}
{$R 'xOutline.res' 'xOutline.rc'}
{$I DEFINE.INC}

uses
{$IFDEF FullDebugMode}
  FastMM4,
  JCLHookExcept,
  JCLDebug,
{$ENDIF}
{$IFDEF DEBUGVER}
  MemCheck in 'MemCheck.pas',
{$ENDIF}
  RasThrd in 'RasThrd.pas',
  Setup in 'Setup.pas' {SetupForm},
  ComeOn in 'ComeOn.pas',
  DevCfg in 'DevCfg.PAS' {DeviceConfig},
  FidoStat in 'FidoStat.PAS' {FidoTemplateEditor},
  NdlUtil in 'NdlUtil.pas' {NodelistCompiler},
  FreqEdit in 'Freqedit.pas' {FReqDlg},
  LineBits in 'LineBits.PAS' {LineBitsEditor},
  MClasses in 'MClasses.pas',
  ModemCfg in 'ModemCfg.PAS' {ModemEditor},
  Outbound in 'Outbound.pas',
  p_Hydra in 'p_Hydra.pas',
  xBase in 'xBase.pas',
  xMisc in 'xMisc.pas',
  Mgrids in 'Mgrids.pas',
  MlineCfg in 'MlineCfg.PAS' {MailerLineCfgForm},
  FreqCfg in 'FreqCfg.PAS' {FreqCfgForm},
  NodeLCfg in 'NodeLCfg.PAS' {NodeListCfgForm},
  Recs in 'Recs.pas',
  DialRest in 'DialRest.PAS' {RestrictCfgForm},
  MlrForm in 'MlrForm.pas' {MailerForm},
  xFido in 'xFido.pas',
  p_Zmodem in 'P_zmodem.pas',
  Attach in 'Attach.PAS' {AttachStatusForm},
  xIP in 'xIP.pas',
  DUPCfg in 'DUPCfg.PAS' {MainConfigForm},
  StupCfg in 'StupCfg.PAS' {StartupConfigForm},
  TracePl in 'TracePl.PAS' {DisplayInfoForm},
  Extrnls in 'Extrnls.PAS' {ExternalsForm},
  LngTools in 'LngTools.pas',
  NodeBrws in 'NodeBrws.pas' {NodelistBrowser},
  Import in 'Import.PAS' {ImportForm},
  xEvents in 'xEvents.PAS' {EventsForm},
  EvtEdit in 'EvtEdit.PAS' {EvtEditForm},
  AtomEdit in 'AtomEdit.PAS' {AtomEditorForm},
  xNiagara in 'xNiagara.pas',
  p_BinkP in 'p_BinkP.pas',
  xDES in 'xDES.pas',
  EncLinks in 'EncLinks.PAS' {EncryptedLinksForm},
  PwdInput in 'PwdInput.PAS' {NewPwdInputForm},
  SinglPwd in 'SinglPwd.PAS' {SinglePasswordForm},
  MlrThr in 'MlrThr.pas',
  OvrExpl in 'OvrExpl.pas' {OvrExplainForm},
  FidoPwd in 'FidoPwd.pas' {PwdForm},
  AdrIBox in 'AdrIBox.PAS' {FidoAddressInput},
  Grids in 'Grids.pas',
  FTS1 in 'FTS1.pas',
  PollCfg in 'PollCfg.pas' {PollSetupForm},
  MdmCmd in 'MdmCmd.PAS' {ModemCmdForm},
  FileBox in 'FileBox.PAS' {FileBoxesForm},
  NodeWiz in 'NodeWiz.pas' {NodeWizzardForm},
  StartWiz in 'StartWiz.PAS' {StartWizzardForm},
  RRegExp in 'RRegExp.pas',
  OdbcSql in 'OdbcSql.pas',
  OdbcLog in 'OdbcLog.pas',
  igHHInt in 'igHHInt.pas',
  WSock in 'WSock.pas',
  NTdyn in 'NTdyn.pas',
  RadIni in 'RadIni.pas',
  Watcher in 'Watcher.pas',
  PathName in 'PathName.PAS' {PathNamesForm},
  Wizard in 'Wizard.pas',
  Util in 'Util.pas',
  IpCfg in 'IpCfg.pas' {IPCfgForm},
  Cmdln in 'Cmdln.pas',
  Tapi in 'Tapi.pas',
  xTAPI in 'xTAPI.pas',
  Netmail in 'Netmail.pas',
  LogView in 'LogView.pas' {LogViewer},
  UNetCfg in 'UNetCfg.pas' {NetCfg};

{$R *.RES}

begin
{$IFDEF DEBUGVER}
  MemChk;
{$ENDIF}
{$IFDEF FullDebugMode}
  Include(JclStackTrackingOptions, stExceptFrame);
  Include(JclStackTrackingOptions, stRawMode);
  JclStartExceptionTracking;
  JclAddExceptNotifier(AnyExceptionNotify);
{$ENDIF}
  Come_On;
end.