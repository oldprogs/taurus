unit Setup;

{$I DEFINE.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ComCtrls, Buttons,
  mGrids, MClasses, ExtCtrls, xBase;

type
  TSoundRec = record
    ed: TEdit;
    cb: TCheckBox;
  end;

  TSetupForm = class(TForm)
    tvPages: TTreeView;
    lblPageTitle: TLabel;
    nbPages: TNotebook;
    Bevel3: TBevel;
    lLanguage: TLabel;
    bvFrame: TBevel;
    lTariffOptions: TLabel;
    lRasOptions: TLabel;
    imgHeader: TImage;
    cbTariff: TCheckBox;
    btnHelp: TButton;
    btnApply: TButton;
    btnCancel: TButton;
    btnOK: TButton;
    Bevel9: TBevel;
    Bevel8: TBevel;
    lRCC: TLabel;
    Bevel5: TBevel;
    cbHelpLanguage: TComboBox;
    lHelpLanguage: TLabel;
    cbInterfaceLanguage: TComboBox;
    lInterfaceLanguage: TLabel;
    Bevel7: TBevel;
    lSystemOptions: TLabel;
    lMutexName: TLabel;
    eMutexName: TEdit;
    lActivateEventName: TLabel;
    eActivateEventName: TEdit;
    lEMSICR: TLabel;
    eEMSICR: TEdit;
    Bevel11: TBevel;
    cbSimpleBSY: TCheckBox;
    cbCloseBWZ: TCheckBox;
    cbIncrementArcmail: TCheckBox;
    cbForceFAXPage: TCheckBox;
    cbIgnoreEndSession: TCheckBox;
    lWinSockVersion: TLabel;
    cbWinsockVersion: TComboBox;
    Bevel12: TBevel;
    cbGridBWZ: TCheckBox;
    Bevel13: TBevel;
    lGrid: TLabel;
    cbGridPV: TCheckBox;
    cbGaugeFore: TColorBox;
    lGaugeFore: TLabel;
    Bevel15: TBevel;
    lColors: TLabel;
    lGaugeBack: TLabel;
    cbGaugeBack: TColorBox;
    lLoggerFore: TLabel;
    cbLoggerFore: TColorBox;
    lLoggerBack: TLabel;
    cbLoggerBack: TColorBox;
    lBadWazooFore: TLabel;
    cbBadWazooFore: TColorBox;
    lBadWazooBack: TLabel;
    cbBadWazooBack: TColorBox;
    lMail7Fore: TLabel;
    cbMail7Fore: TColorBox;
    lMail7Back: TLabel;
    cbMail7Back: TColorBox;
    cbMail14Fore: TColorBox;
    cbMail14Back: TColorBox;
    lMail14Back: TLabel;
    lMail14Fore: TLabel;
    cbMail21Fore: TColorBox;
    cbMail21Back: TColorBox;
    lMail21Back: TLabel;
    lMail21Fore: TLabel;
    cbMail28Fore: TColorBox;
    cbMail28Back: TColorBox;
    lMail28Back: TLabel;
    lMail28Fore: TLabel;
    cbAlwaysInTray: TCheckBox;
    Bevel16: TBevel;
    lTrayOptions: TLabel;
    cbEnableRCC: TCheckBox;
    eRCCPwd: TEdit;
    lRCCPwd: TLabel;
    cbEntryList: TComboBox;
    lEntryList: TLabel;
    btnReloadRASEntries: TButton;
    lHome: TLabel;
    Bevel10: TBevel;
    lPathTo: TLabel;
    eHome: TEdit;
    btnHome: TButton;
    btnConfigs: TButton;
    eConfigs: TEdit;
    lConfigs: TLabel;
    btnFileFlags: TButton;
    eFlags: TEdit;
    lFlags: TLabel;
    btnTempInbound: TButton;
    eTempInbound: TEdit;
    lTempInbound: TLabel;
    btnSecureInbound: TButton;
    eSecureInbound: TEdit;
    lSecureInbound: TLabel;
    btnInbound: TButton;
    eInbound: TEdit;
    lInbound: TLabel;
    btnOutbound: TButton;
    eOutbound: TEdit;
    lOutbound: TLabel;
    lLogs: TLabel;
    eLogs: TEdit;
    btnLogs: TButton;
    sbDefGauge: TSpeedButton;
    sbSysGauge: TSpeedButton;
    sbDefLogger: TSpeedButton;
    sbSysLogger: TSpeedButton;
    sbDefBadWazoo: TSpeedButton;
    sbSysBadWazoo: TSpeedButton;
    sbDefMail7: TSpeedButton;
    sbSysMail7: TSpeedButton;
    sbDefMail14: TSpeedButton;
    sbSysMail14: TSpeedButton;
    sbDefMail28: TSpeedButton;
    sbSysMail28: TSpeedButton;
    sbSysMail21: TSpeedButton;
    sbDefMail21: TSpeedButton;
    cbDisableWinsockTraps: TCheckBox;
    cbCryptRCCPwd: TCheckBox;
    MainPan1: TPanel;
    Bevel6: TBevel;
    Bevel2: TBevel;
    Bevel4: TBevel;
    lAddressOptions: TLabel;
    sbMainAKABrowse: TSpeedButton;
    sbSynchClockBrowse: TSpeedButton;
    lSynchClock: TLabel;
    lMainAKA: TLabel;
    lSessionOptions: TLabel;
    lSynchShift: TLabel;
    lCPSMinBytes: TLabel;
    lCPSMinSecs: TLabel;
    lPeriods: TLabel;
    lMsgsAutoClose: TLabel;
    lMaxBWZAge: TLabel;
    lMaxBsyAge: TLabel;
    eMainAKA: TEdit;
    eSynchClock: TEdit;
    seSynchShift: TxSpinEdit;
    seCPSMinBytes: TxSpinEdit;
    seCPSMinSecs: TxSpinEdit;
    seMaxBsyAge: TxSpinEdit;
    seMaxBWZAge: TxSpinEdit;
    seMsgsAutoClose: TxSpinEdit;
    MainPan2: TPanel;
    Bevel1: TBevel;
    lOtherOptions: TLabel;
    lCloseBtnActn: TLabel;
    lMinFreeSpace: TLabel;
    cbSessionOK: TCheckBox;
    cbCreateSessionFail: TCheckBox;
    cbUseSPACE: TCheckBox;
    cbFixedRetryTimeout: TCheckBox;
    cbDynamicOutbound: TCheckBox;
    cbCloseBtnAction: TComboBox;
    seMinFreeSpace: TxSpinEdit;
    sbMainPrev: TSpeedButton;
    sbMainNext: TSpeedButton;
    Bevel17: TBevel;
    lChat: TLabel;
    cbChatEnabled: TCheckBox;
    Bevel18: TBevel;
    lOutboundOptions: TLabel;
    cbD5Out: TCheckBox;
    cbRASEnabled: TCheckBox;
    cbUseHTMLHelp: TCheckBox;
    Bevel19: TBevel;
    lLogger: TLabel;
    Bevel20: TBevel;
    cbODBCLogging: TCheckBox;
    cbLogThreadTimes: TCheckBox;
    bLoggerFont: TButton;
    fdLogger: TFontDialog;
    lLoggerFont: TLabel;
    cbBalloon: TCheckBox;
    cbBalloonMin: TCheckBox;
    Bevel14: TBevel;
    lBalloon: TLabel;
    lWatcherEventName: TLabel;
    eWatcherEventName: TEdit;
    lTxWindow: TLabel;
    lHydra: TLabel;
    Bevel21: TBevel;
    Bevel22: TBevel;
    lBinkP: TLabel;
    seTxWindow: TxSpinEdit;
    lRxWindow: TLabel;
    seRxWindow: TxSpinEdit;
    cbShortName: TCheckBox;
    cbOEMCharset: TCheckBox;
    cbDebug: TCheckBox;
    cbRequestCrypt: TCheckBox;
    lLogFNames: TLabel;
    Bevel23: TBevel;
    eaccess_log: TEdit;
    laccess_log: TLabel;
    eagnt_log: TEdit;
    lagent_log: TLabel;
    ebinary_log: TEdit;
    lbinary_log: TLabel;
    lpolls_log: TLabel;
    epolls_log: TEdit;
    lcronapps_log: TLabel;
    ecronapps_log: TEdit;
    ltariff_log: TLabel;
    etariff_log: TEdit;
    lipdaemon_log: TLabel;
    eipdaemon_log: TEdit;
    lras_log: TLabel;
    eras_log: TEdit;
    lOtherInterface: TLabel;
    Bevel24: TBevel;
    cbShowIcons: TCheckBox;
    cbIgnoreBWZSize: TCheckBox;
    eChatBell: TEdit;
    cbChatBell: TLabel;
    btnChatBell: TButton;
    odChatBell: TOpenDialog;
    cbUseNodelistData: TCheckBox;
    lMaxUDLAge: TLabel;
    seMaxUDLAge: TxSpinEdit;
    cbIBNRequestList: TCheckBox;
    gNetmail: TAdvGrid;
    cbDynamicRouting: TCheckBox;
    cbHydRequestList: TCheckBox;
    cbTariffPerMinute: TCheckBox;
    Bevel25: TBevel;
    Label1: TLabel;
    cbPlaySounds: TCheckBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    edRing: TEdit;
    edDial: TEdit;
    edConnect: TEdit;
    edSession: TEdit;
    edAborted: TEdit;
    edNewLine: TEdit;
    edEndLine: TEdit;
    edRASDial: TEdit;
    edRASConnect: TEdit;
    edRASFinish: TEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Label12: TLabel;
    edIncoming: TEdit;
    Button11: TButton;
    Label13: TLabel;
    edBBS: TEdit;
    Label14: TLabel;
    edTrap: TEdit;
    Button12: TButton;
    Button13: TButton;
    Bevel26: TBevel;
    lOther: TLabel;
    cbIgnoreCD: TCheckBox;
    cbLamps: TCheckBox;
    cbStealth: TCheckBox;
    hkPopup: THotKey;
    lPopup: TLabel;
    cbPriority: TComboBox;
    lPriority: TLabel;
    cbCompileNodelist: TCheckBox;
    cbRing: TCheckBox;
    cbDial: TCheckBox;
    cbConnect: TCheckBox;
    cbSession: TCheckBox;
    cbAborted: TCheckBox;
    cbNewLine: TCheckBox;
    cbEndLine: TCheckBox;
    cbRASDial: TCheckBox;
    cbRASConnect: TCheckBox;
    cbRASFinish: TCheckBox;
    cbIncoming: TCheckBox;
    cbBBS: TCheckBox;
    cbTrap: TCheckBox;
    {$IFDEF EXTREME}
    Bevel27: TBevel;
    lForms: TLabel;
    bFormsFont: TButton;
    fdForms: TFontDialog;
    lFormsFont: TLabel;
    tmCRC: TTimer;
    eNetmail: TEdit;
    bNetmail: TButton;
    lNetmail: TLabel;
    cbScanMSG: TCheckBox;
    {$ENDIF}
    procedure tvPagesChange(Sender: TObject; Node: TTreeNode);
    procedure FormCreate(Sender: TObject);
    procedure btnReloadRASEntriesClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure sbMainAKABrowseClick(Sender: TObject);
    procedure sbSynchClockBrowseClick(Sender: TObject);
    procedure btnHomeClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure sbDefGaugeClick(Sender: TObject);
    procedure sbSysGaugeClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure eHomeChange(Sender: TObject);
    procedure eConfigsChange(Sender: TObject);
    procedure sbMainNextClick(Sender: TObject);
    procedure sbMainPrevClick(Sender: TObject);
    procedure bLoggerFontClick(Sender: TObject);
    procedure btnChatBellClick(Sender: TObject);
    procedure FillNetmailGrid;
    procedure Button1Click(Sender: TObject);
    procedure cbStealthClick(Sender: TObject);
    procedure hkPopupChange(Sender: TObject);
    procedure cbPriorityChange(Sender: TObject);
    procedure bFormsFontClick(Sender: TObject);
    procedure tmCRCTimer(Sender: TObject);
    procedure bNetmailClick(Sender: TObject);
    procedure cbScanMSGClick(Sender: TObject);
  private
    { Private declarations }
    Edits: array[0..12] of TSoundRec;
    wdCRC: DWORD;
    inCRC: boolean;
  public
    procedure SetData(i: integer);
    procedure GetData;
  end ;

  function SetPrefEx(const Remote: boolean): Boolean;

var
  SetupForm: TSetupForm;

implementation

uses LngTools, RadIni, xFido, PathNmEx, IniFiles
     {$IFDEF RASDIAL}, RasThrd, {$ENDIF} AdrIBox, Recs, ShellApi
     {$IFDEF EXTREME}, RCCUnit {$ENDIF}, MlrThr, MlrForm;

var
  FidoAddr1: TFidoAddress;
  FidoAddr2: TFidoAddress;
  i: integer;
  HomeChanged : boolean = false;
  ConfigsChanged : boolean = false;

{$R *.DFM}

function SetPrefEx(const Remote: boolean): Boolean;
begin
  SetupForm := TSetupForm.Create(Application);
{$IFNDEF WS}
  SetupForm.lipdaemon_log.Free;
  SetupForm.eipdaemon_log.Free;
{$ENDIF}
{$IFNDEF RASDIAL}
  SetupForm.lras_log.Free;
  SetupForm.eras_log.Free;
{$ENDIF}
  i := GetRegInterfaceLng;
  SetupForm.SetData(i);
  SetupForm.sbMainPrev.Font.Style := [fsBold];
  SetupForm.sbMainNext.Font.Style := [fsBold];
  SetupForm.sbMainPrev.Font.Color := clBlue;
  SetupForm.sbMainNext.Font.Color := clBlue;
  {$IFDEF EXTREME}
  if Remote then begin
     TreatForm(SetupForm);
  end;
  {$ENDIF}
  SetupForm.cbScanMSGClick(nil);
  Result := SetupForm.ShowModal = mrOK;
  if result and SetupForm.btnApply.Enabled then begin
     SetupForm.GetData;
     IniFile.StoreCFG;
  end;
  FreeObject(SetupForm);
end;

procedure TSetupForm.GetData;
var
   ResLngBase: integer;
   s: string;
  _i: integer;
begin
//Main tab
  IniFile.MainAddr := FidoAddr1;
  IniFile.Synch := FidoAddr2;
  IniFile.SessionOKFlag := cbSessionOK.Checked;
  IniFile.SessionAbortedFlag := cbCreateSessionFail.Checked;
  IniFile.NoHTML := not cbUseHTMLHelp.Checked;
  IniFile.UseSpace := cbUseSPACE.Checked;
  IniFile.FixedRetryTimeout := cbFixedRetryTimeout.Checked;
  Inifile.DynamicOutbound := cbDynamicOutbound.Checked;
  Inifile.DynamicRouting := cbDynamicRouting.Checked;
  IniFile.ScanMSG := cbScanMSG.Checked;
//  IniFile.MainReg := seMainRegion.Value;
  IniFile.TimeShift := seSynchShift.Value;
  IniFile.CPS_MinBytes := seCPSMinBytes.Value;
  IniFile.CPS_MinSecs := seCPSMinSecs.Value;
  IniFile.MaxBSYAge := seMaxBSYAge.Value;
  IniFile.MaxBWZAge := seMaxBWZAge.Value;
  IniFile.MaxUDLAge := seMaxUDLAge.Value;
  IniFile.WinDlgTWait := seMsgsAutoClose.Value;
  IniFile.FreeSpaceLmt := seMinFreeSpace.Value;
  IniFile.OnClose := cbCloseBtnAction.ItemIndex;
  IniFile.ChatEnabled := cbChatEnabled.Checked;
  IniFile.IgnoreCD := cbIgnoreCD.Checked;
  IniFile.TrayLamps := cbLamps.Checked;
  IniFile.ChatBell := eChatBell.Text;
  IniFile.D5Out := cbD5Out.Checked;
  IniFile.UseNodelistData := cbUseNodelistData.Checked;
  IniFile.AutoNodelist := cbCompileNodelist.Checked;
  IniFile.playsounds := cbPlaySounds.Checked;
//Main end

//System tab
  IniFile.IgnoreEndSession := cbIgnoreEndSession.Checked;
  IniFile.IgnoreBWZSize := cbIgnoreBWZSize.Checked;
  IniFile.IncrementArcmail := cbIncrementArcmail.Checked;
  IniFile.DisableWinsockTraps := cbDisableWinsockTraps.Checked;
  IniFile.SimpleBSY := cbSimpleBSY.Checked;
  IniFile.CloseBWZFile := cbCloseBWZ.Checked;
  IniFile.ForceAddFaxPage := cbForceFaxPage.Checked;

  with TIniFile.Create(IniFName) do
  try
    IniFile.Enter;
    WriteString('system', 'EMSI_CR', eEMSICR.Text);
    WriteString('system', 'MutexName', eMutexName.Text);
    WriteString('system', 'ActivateEventName', eActivateEventName.Text);
    WriteString('system', 'WatcherEventName', eWatcherEventName.Text);
    WriteInteger('system', 'WinSockVersion', cbWinSockVersion.ItemIndex);
    WriteBool('system', 'LogThreadTimes', cbLogThreadTimes.Checked);
    for _i := 0 to 12 do begin
       WriteString('Sounds', copy(Edits[_i].ed.Name, 3, 10), Edits[_i].ed.Text);
       WriteBool('Sounds', 'c_' + copy(Edits[_i].ed.Name, 3, 10), Edits[_i].cb.Checked);
    end;
  finally
    free;
    IniFile.Leave;
  end;
//System end

{$IFDEF RASDIAL}
//RAS tab
  IniFile.iEntryName := cbEntryList.Text;
  if (IniFile.RASEnabled <> cbRasEnabled.Checked) then begin
    IniFile.RASEnabled := cbRasEnabled.Checked;
    if IniFile.RASEnabled then begin
      RasThrd.StartRas;
    end else begin
      RasThrd.FinishRas;
    end;
  end;
//RAS end
{$ENDIF}

//Tray tab
  IniFile.AlwaysInTray := cbAlwaysInTray.Checked;
  IniFile.Stealth := cbStealth.Checked;
  IniFile.PopupKey := hkPopup.HotKey;
  if IniFile.Stealth then SetHotKey;
  IniFile.ShowBalloon := cbBalloon.Checked;
  IniFile.ShowBalloonMin := cbBalloonMin.Checked;
//Tray end

//logs tab
  IniFile.ODBCLogging := cbODBCLogging.Checked;
  IniFile.DontLogTariff := not cbTariff.Checked;
  IniFile.accessFName := eaccess_log.Text;
  IniFile.agentFName := eagnt_log.Text;
  IniFile.StatxFName := ebinary_log.Text;
  IniFile.Polls_log := epolls_log.Text;
  IniFile.Cronapps_log := ecronapps_log.Text;
  IniFile.tariff_log := etariff_log.Text;
{$IFDEF WS}
  IniFile.IPDaemon_log := eipdaemon_log.Text;
{$ENDIF}
{$IFDEF RASDIAL}
  IniFile.ras_log := eras_log.Text;
{$ENDIF}
//logs end;

//Remote tab
  IniFile.Remote_Enabled := cbEnableRCC.Checked;
  IniFile.Remote_Password :=  eRCCPwd.Text;
  IniFile.Remote_EncPwd := cbCryptRCCPwd.Checked;
//Remote end

//Interface tab
  IniFile.lang := cbInterfaceLanguage.ItemIndex;
//  IniFile.HelpLang:=LangNames[TLangName(cbHelpLanguage.ItemIndex)];
  case cbHelpLanguage.ItemIndex of
  0: begin
       Application.HelpFile := GetHelpFile(HomeDir, LangNames[lnEnglish]);
       HelpLanguageId := HelpLanguageEnglish;
       SetRegHelpLng(LangNames[lnEnglish]);
     end;
  1: begin
       Application.HelpFile := GetHelpFile(HomeDir, LangNames[lnRussian]);
       HelpLanguageId := HelpLanguageRussian;
       SetRegHelpLng(LangNames[lnRussian]);
     end;
  end;{of case}

  IniFile.GridInBWZ := cbGridBWZ.Checked;
  IniFile.GridInPV := cbGridPV.Checked;
  IniFile.FormsFontSize := fdForms.Font.Size;
  IniFile.FormsFontName := fdForms.Font.Name;
  IniFile.FormsFontAttr[1] := inttostr(integer(fsBold in fdForms.Font.Style))[1];
  IniFile.FormsFontAttr[2] := inttostr(integer(fsItalic in fdForms.Font.Style))[1];
  IniFile.FormsFontAttr[3] := inttostr(integer(fsUnderline in fdForms.Font.Style))[1];
  IniFile.FormsFontAttr[4] := inttostr(integer(fsStrikeOut in fdForms.Font.Style))[1];
  TMailerForm(MailerForms[0]).Font.Assign(fdForms.Font);
  TMailerForm(MailerForms[0]).OutMgrOutLine.ItemHeight := Abs(fdForms.Font.Height) + 4;
  IniFile.LoggerFontSize := fdLogger.Font.Height;
  IniFile.LoggerFontName := fdLogger.Font.Name;
  IniFile.LoggerFontAttr[1] := inttostr(integer(fsBold in fdLogger.Font.Style))[1];
  IniFile.LoggerFontAttr[2] := inttostr(integer(fsItalic in fdLogger.Font.Style))[1];
  IniFile.LoggerFontAttr[3] := inttostr(integer(fsUnderline in fdLogger.Font.Style))[1];
  IniFile.LoggerFontAttr[4] := inttostr(integer(fsStrikeOut in fdLogger.Font.Style))[1];

  IniFile.ShowMenuIcons := cbShowIcons.Checked;

//Interface end

//Colors tab
  IniFile.GaugeFore := cbGaugeFore.Selected;
  IniFile.GaugeBack := cbGaugeBack.Selected;
  IniFile.LoggerFore := cbLoggerFore.Selected;
  IniFile.LoggerBack := cbLoggerBack.Selected;
  IniFile.BadWazooFore := cbBadwazooFore.Selected;
  IniFile.BadWazooBack := cbBadwazooBack.Selected;
  IniFile.OldMail7Fore := cbMail7Fore.Selected;
  IniFile.OldMail7Back := cbMail7Back.Selected;
  IniFile.OldMail14Fore := cbMail14Fore.Selected;
  IniFile.OldMail14Back := cbMail14Back.Selected;
  IniFile.OldMail21Fore := cbMail21Fore.Selected;
  IniFile.OldMail21Back := cbMail21Back.Selected;
  IniFile.OldMail28Fore := cbMail28Fore.Selected;
  IniFile.OldMail28Back := cbMail28Back.Selected;
//Colors end

//Protocols tab
  IniFile.HydraDebug := cbDebug.Checked;
  IniFile.HydraShortLongfilename := cbShortName.Checked;
  IniFile.HydraOEM := cbOEMCharset.Checked;
  IniFile.HydraRxWindow := seRxWindow.Value;
  IniFile.HydraTxWindow := seTxWindow.Value;
  IniFile.RequestCRYPT := cbRequestCrypt.Checked;
  IniFile.ibnRequestLIST := cbIBNRequestList.Checked;
  IniFile.hydRequestLIST := cbHydRequestList.Checked;
//Protocols end

//Netmail tab
  with IniFile do begin
    if NetmailAddrTo.Count <> 0 then begin
      NetmailAddrTo.FreeAll;
      NetmailAddrFrom.FreeAll;
      NetmailPwd.FreeAll;
    end;

    for _i := 0 to gNetmail.RowCount - 2 do begin
      gNetmail.GetData([NetmailAddrTo, NetmailAddrFrom, NetmailPwd]);
    end;
  end;
  IniFile.NetmailDir := eNetmail.Text;
//Netmail end

//Tariff tab
  IniFile.PerMinute := cbTariffPerMinute.Checked;
//Tariff end

//Paths tab
  IniFile.FlagsDir := eFlags.Text;
  IniFile.InTemp := eTempInbound.Text;
  IniFile.Outbound := eOutbound.Text;
  IniFile.InSecure := eSecureInbound.Text;
  IniFile.InCommon := eInbound.Text;
  IniFile.Log := eLogs.Text;
//Paths end

//Finalization
  if i <> inifile.lang then begin
    i := inifile.lang;
    ResLngBase := 0;
    case I of
    MaxInt :;
    idlRussian:
       ResLngBase := LngBaseRussian;
    else
       begin
          ResLngBase := LngBaseEnglish;
       end;
    end;
    if Application.MainForm <> nil then PostMessage(Application.MainForm.Handle, WM_SetLang, inifile.lang, 1);
    _FillForm(self, rsSetupForm, ResLngBase);
    _GridFillColLng(gNetmail, rsNetmailGrid, ResLngBase);
    if (IniFile.OnClose > 2) or (IniFile.OnClose < 0) then cbCloseBtnAction.ItemIndex := 0
    else cbCloseBtnAction.ItemIndex := IniFile.OnClose;
    cbInterfaceLanguage.ItemIndex := i;
  end;

 if HomeChanged then begin
   IniFile.HomeDir := eHome.Text;
   IniFile.CfgDir := eConfigs.Text;
   If not DirectoryExists(IniFile.HomeDir) then CreateDir(IniFile.HomeDir);
   DisplayInfoLng(rsPNHdc, Handle);
   s := '';
   if ParamCount > 0 then begin
     s := ParamStr(1);
     if ParamCount > 1 then begin
       for _i := 2 to ParamCount do s := s + ' ' + ParamStr(_i);
     end;
   end;
   if Pos('delay5000', s) = 0 then s := 'delay5000 ' + s;
   ShellExecute(0, nil, PChar(ParamStr(0)),
      PChar(s), PChar(ExtractFilePath(ParamStr(0))), sw_shownormal);
   PostCloseMessage;
   exit;
 end;

 if ConfigsChanged then begin
   IniFile.CfgDir := eConfigs.Text;
   DisplayInfoLng(rsCDCh, Handle);
   s := '';
   if ParamCount > 0 then begin
     s := ParamStr(1);
     if ParamCount > 1 then begin
       for _i := 2 to ParamCount do s := s + ' ' + ParamStr(_i);
     end;
   end;
   if Pos('delay5000', s) > 0 then s := 'delay5000 ' + s;
   ShellExecute(0, nil, PChar(ParamStr(0)),
      PChar('delay5000 ' + GetCommandLine), PChar(ExtractFilePath(ParamStr(0))), sw_shownormal);
   PostCloseMessage;
   exit;
 end;
end;

procedure TSetupForm.SetData(i:integer);
var
  n: integer;
begin
// Main tab
  eMainAKA.Text := Addr2Str(IniFile.MainAddr);
  FidoAddr1 := IniFile.MainAddr;
  eSynchClock.Text := Addr2Str(IniFile.Synch);
  FidoAddr2 := IniFile.Synch;
//  seMainRegion.Value := IniFile.MainReg;
  seSynchShift.Value := IniFile.TimeShift;
  seCPSMinBytes.Value := IniFile.CPS_MinBytes;
  seCPSMinSecs.Value := IniFile.CPS_MinSecs;
  seMaxBSYAge.Value := IniFile.MaxBSYAge;
  seMaxBWZAge.Value := IniFile.MaxBWZAge;
  seMaxUDLAge.Value := IniFile.MaxUDLAge;
  seMsgsAutoClose.Value := IniFile.WinDlgTWait;
  seMinFreeSpace.Value := IniFile.FreeSpaceLmt;
  cbSessionOK.Checked := IniFile.SessionOKFlag;
  cbCreateSessionFail.Checked := IniFile.SessionAbortedFlag;
  cbUseHTMLHelp.Checked := not IniFile.NoHTML;
  cbUseSpace.Checked := IniFile.UseSpace;
  cbFixedRetryTimeout.Checked := IniFile.FixedRetryTimeout;
  cbDynamicOutbound.Checked := IniFile.DynamicOutbound;
  cbDynamicRouting.Checked := IniFile.DynamicRouting;
  cbScanMSG.Checked := IniFile.ScanMSG;
  cbChatEnabled.Checked := IniFile.ChatEnabled;
  cbIgnoreCD.Checked := IniFile.IgnoreCD;
  cbLamps.Checked := IniFile.TrayLamps;
  eChatBell.Text := IniFile.ChatBell;
  cbD5Out.Checked := IniFile.D5Out;
  if (IniFile.OnClose > 2) or (IniFile.OnClose < 0) then cbCloseBtnAction.ItemIndex := 0
  else cbCloseBtnAction.ItemIndex := IniFile.OnClose;
  cbUseNodelistData.Checked := IniFile.UseNodelistData;
  cbCompileNodelist.Checked := IniFile.AutoNodelist;
  cbPlaySounds.Checked := IniFile.playsounds;
//Main end

//System tab
  cbForceFaxPage.Checked := IniFile.ForceAddFaxPage;
  cbIgnoreEndSession.Checked := IniFile.IgnoreEndSession;
  cbIgnoreBWZSize.Checked := IniFile.IgnoreBWZSize;
  cbIncrementArcmail.Checked := IniFile.IncrementArcmail;
  cbDisableWinsockTraps.Checked := IniFile.DisableWinsockTraps;
  cbSimpleBSY.Checked := IniFile.SimpleBSY;
  cbCloseBWZ.Checked := IniFile.CloseBWZFile;
  with TIniFile.Create(IniFName) do
  try
    IniFile.Enter;
    eEMSICR.Text := ReadString('system', 'EMSI_CR', '%0D');
    eMutexName.Text := ReadString('system', 'MutexName', 'ARGUS_SEMAPHORE');
    eActivateEventName.Text := ReadString('system', 'ActivateEventName', 'ARGUS_EVENT_ACTIVATE');
    eWatcherEventName.Text := ReadString('system', 'WatcherEventName', 'ARGUS_EVENT_DIRECTORY_WATCHER');

//    cbIncrementArcmail.Checked := ReadBool('system','IncrementArcmail', False);
    n := ReadInteger('system', 'WinSockVersion', 0);
    if (n > 2) or (n < 0) then cbWinSockVersion.ItemIndex := 0
    else cbWinSockVersion.ItemIndex := n;
    cbLogThreadTimes.Checked := ReadBool('system', 'LogThreadTimes', False);
    For n := 0 to 12 do begin
       Edits[n].ed.Text := ReadString('Sounds', copy(Edits[n].ed.Name, 3, 10), copy(Edits[n].ed.Name, 3, 10));
       Edits[n].cb.Checked := ReadBool('Sounds', 'c_' + copy(Edits[n].ed.Name, 3, 10), True);
    end;
  finally
    free;
    IniFile.Leave;
  end;
  case IniFile.Priority of
    IDLE_PRIORITY_CLASS: n := 0;
    NORMAL_PRIORITY_CLASS: n := 1;
    HIGH_PRIORITY_CLASS: n := 2;
    REALTIME_PRIORITY_CLASS: n := 3;
  else
    n := 1;
  end;
  cbPriority.ItemIndex := n;
//System end

//Interface tab
  cbInterfaceLanguage.ItemIndex := i;//IniFile.lang;

  if IniFile.HelpLang = LangNames[lnEnglish] then cbHelpLanguage.ItemIndex := Integer(lnEnglish)
  else if IniFile.HelpLang = LangNames[lnRussian] then cbHelpLanguage.ItemIndex := Integer(lnRussian);

  cbGridBWZ.Checked := IniFile.GridInBWZ;
  cbGridPV.Checked := IniFile.GridInPV;

{$IFDEF EXTREME}
  fdForms.Font.Name := IniFile.FormsFontName;
  fdForms.Font.Size := IniFile.FormsFontSize;
  fdForms.Font.Style := [];
  if IniFile.FormsFontAttr[1] = '1' then fdForms.Font.Style := fdForms.Font.Style + [fsBold];
  if IniFile.FormsFontAttr[2] = '1' then fdForms.Font.Style := fdForms.Font.Style + [fsItalic];
  if IniFile.FormsFontAttr[3] = '1' then fdForms.Font.Style := fdForms.Font.Style + [fsUnderline];
  if IniFile.FormsFontAttr[4] = '1' then fdForms.Font.Style := fdForms.Font.Style + [fsStrikeOut];
{$ENDIF}

  fdLogger.Font.Color := IniFile.LoggerFore;
  fdLogger.Font.Name := IniFile.LoggerFontName;
  fdLogger.Font.Height := IniFile.LoggerFontSize;

  fdLogger.Font.Style := [];
  if IniFile.LoggerFontAttr[1] = '1' then fdLogger.Font.Style := fdLogger.Font.Style + [fsBold];
  if IniFile.LoggerFontAttr[2] = '1' then fdLogger.Font.Style := fdLogger.Font.Style + [fsItalic];
  if IniFile.LoggerFontAttr[3] = '1' then fdLogger.Font.Style := fdLogger.Font.Style + [fsUnderline];
  if IniFile.LoggerFontAttr[4] = '1' then fdLogger.Font.Style := fdLogger.Font.Style + [fsStrikeOut];

  {$IFDEF EXTREME}
  lFormsFont.Caption  := Format('%s (%d Pts)', [Font.Name, Font.Size]);
  {$ENDIF}
  lLoggerFont.Caption := Format('%s (%d Pts)', [fdLogger.Font.Name, fdLogger.Font.Size]);
  cbShowIcons.Checked := IniFile.ShowMenuIcons;
//Interface end

//Colors tab
  cbGaugeFore.Selected := IniFile.GaugeFore;
  cbGaugeBack.Selected := IniFile.GaugeBack;
  cbLoggerFore.Selected := IniFile.LoggerFore;
  cbLoggerBack.Selected := IniFile.LoggerBack;
  cbBadwazooFore.Selected := IniFile.BadWazooFore;
  cbBadwazooBack.Selected := IniFile.BadWazooBack;
  cbMail7Fore.Selected := IniFile.OldMail7Fore;
  cbMail7Back.Selected := IniFile.OldMail7Back;
  cbMail14Fore.Selected := IniFile.OldMail14Fore;
  cbMail14Back.Selected := IniFile.OldMail14Back;
  cbMail21Fore.Selected := IniFile.OldMail21Fore;
  cbMail21Back.Selected := IniFile.OldMail21Back;
  cbMail28Fore.Selected := IniFile.OldMail28Fore;
  cbMail28Back.Selected := IniFile.OldMail28Back;
//Colors end

//Tray tab
  FreeHotKey;
  cbAlwaysInTray.Checked := IniFile.AlwaysInTray;
  cbStealth.Checked := IniFile.Stealth;
  hkPopup.HotKey := IniFile.PopupKey;
  hkPopup.Enabled := cbStealth.Checked;
  cbBalloon.Checked := IniFile.ShowBalloon;
  cbBalloonMin.Checked := IniFile.ShowBalloonMin;
//Tray end

//logs tab
  cbODBCLogging.Checked := IniFile.ODBCLogging;
  cbTariff.Checked := not IniFile.DontLogTariff;
  eaccess_log.Text := IniFile.accessFName;
  eagnt_log.Text := IniFile.agentFName;
  ebinary_log.Text := IniFile.StatxFName;
  epolls_log.Text := IniFile.Polls_log;
  ecronapps_log.Text := IniFile.Cronapps_log;
  etariff_log.Text := IniFile.tariff_log;
{$IFDEF WS}
  eipdaemon_log.Text := IniFile.IPDaemon_log;
{$ENDIF}
{$IFDEF RASDIAL}
  eras_log.Text := IniFile.ras_log;
{$ENDIF}
//logs end

//RCC tab
  cbEnableRCC.Checked := IniFile.Remote_Enabled;
  eRCCPwd.Text := IniFile.Remote_Password;
  cbCryptRCCPwd.Checked := IniFile.Remote_EncPwd;
//RCC end

{$IFDEF RASDIAL}
//RAS tab
  cbRASEnabled.Checked := IniFile.RASEnabled;
  if (IniFile.RASEnabled)then begin
     if RasThread = nil then StartRas;
     cbEntryList.Items.AddStrings(RasThread.AllEntries);
     n := cbEntryList.Items.IndexOf(IniFile.iEntryName);
     cbEntryList.ItemIndex := n;
  end;
//RAS end
{$ENDIF}

//Protocols tab
  cbDebug.Checked := IniFile.HydraDebug;
  cbShortName.Checked := IniFile.HydraShortLongfilename;
  cbOEMCharset.Checked := IniFile.HydraOEM;
  seRxWindow.Value := IniFile.HydraRxWindow;
  seTxWindow.Value := IniFile.HydraTxWindow;
  cbRequestCrypt.Checked := IniFile.RequestCRYPT;
  cbIBNRequestList.Checked := IniFile.ibnRequestLIST;
  cbHydRequestList.Checked := IniFile.hydRequestLIST;
//Protocols end

//Tariff tab
  cbTariffPerMinute.Checked := IniFile.PerMinute;
//Tariff end

//Path tab
  eHome.Text := IniFile.HomeDir;
  eConfigs.Text := IniFile.CfgDir;

  HomeChanged := false;
  ConfigsChanged := false;

  eFlags.Text := IniFile.FlagsDir;
  eTempInbound.Text := IniFile.InTemp;
  eSecureInbound.Text := IniFile.InSecure;
  eInbound.Text := IniFile.InCommon;
  eOutbound.Text := IniFile.Outbound;
  eLogs.Text := IniFile.Log;
//Path end

  GridFillColLng(gNetmail, rsNetmailGrid);
  FillNetmailGrid;

  eNetmail.Text := IniFile.NetmailDir;
end;

procedure TSetupForm.tvPagesChange(Sender: TObject; Node: TTreeNode);
begin
  {$IFNDEF RASDIAL}
  if Node.Index = 6 {RAS} then begin
     WinDlgCap(LngStr(rsNoRASMsg), MB_OK or MB_ICONINFORMATION, handle, 'Information');
     tvPages.Select(tvPages.Items.GetFirstNode);
     exit;
  end;
  {$ENDIF}
  if Node.Parent = nil then begin
    case Node.Index of
      0: nbPages.PageIndex := 00;
      1: nbPages.PageIndex := 01;
      2: nbPages.PageIndex := 02;
      3: nbPages.PageIndex := 04;
      4: nbPages.PageIndex := 05;
      5: nbPages.PageIndex := 06;
      6: nbPages.PageIndex := 07;
      7: nbPages.PageIndex := 08;
      8: nbPages.PageIndex := 09;
      9: nbPages.PageIndex := 10;
     10: nbPages.PageIndex := 11;
     11: nbPages.PageIndex := 12;
     12: nbPages.PageIndex := 13;
    else
     GlobalFail('Node.Index = %d', [Node.Index]);
    end;{of case}
  end else begin
    if Node.Parent.Index = 2 then nbPages.PageIndex := 3
    else GlobalFail('Node.Parent.Index = %d', [Node.Parent.Index]);
  end;
  lblPageTitle.Caption := Node.Text;
end;

procedure TSetupForm.FormCreate(Sender: TObject);
begin
  FillForm(self, rsSetupForm);
  tvPages.Items.Item[2].Expand(true);
  Edits[ 0].ed := edRing;
  Edits[ 0].cb := cbRing;
  Edits[ 1].ed := edDial;
  Edits[ 1].cb := cbDial;
  Edits[ 2].ed := edConnect;
  Edits[ 2].cb := cbConnect;
  Edits[ 3].ed := edSession;
  Edits[ 3].cb := cbSession;
  Edits[ 4].ed := edAborted;
  Edits[ 4].cb := cbAborted;
  Edits[ 5].ed := edNewLine;
  Edits[ 5].cb := cbNewLine;
  Edits[ 6].ed := edEndLine;
  Edits[ 6].cb := cbEndLine;
  Edits[ 7].ed := edRASDial;
  Edits[ 7].cb := cbRASDial;
  Edits[ 8].ed := edRASConnect;
  Edits[ 8].cb := cbRASConnect;
  Edits[ 9].ed := edRASFinish;
  Edits[ 9].cb := cbRASFinish;
  Edits[10].ed := edIncoming;
  Edits[10].cb := cbIncoming;
  Edits[11].ed := edBBS;
  Edits[11].cb := cbBBS;
  Edits[12].ed := edTrap;
  Edits[12].cb := cbTrap;
end;

procedure TSetupForm.btnReloadRASEntriesClick(Sender: TObject);
{$IFDEF RASDIAL}
var
  s: string;
begin
  if not IniFile.RASEnabled then exit;
  s := cbEntryList.Text;
  RasThread.LoadEntryList;
  cbEntryList.Items.Clear;
  cbEntryList.Items.AddStrings(RasThread.AllEntries);
  cbEntryList.ItemIndex := cbEntryList.Items.IndexOf(s)
{$ELSE}
begin
{$ENDIF}
end;

  procedure _FlashWindow(winobject: TEdit);
  var i: integer;
  begin//                    $rrggbb
    winobject.Color := clWhite and $FF00FF;
    for i := 0 to $FF do begin
      winobject.Color := winobject.Color + $100;
      sleep(1);
      Application.ProcessMessages;
    end;
    for i := $FF downto 0 do begin
      winobject.Color := winobject.Color - $100;
      sleep(1);
      Application.ProcessMessages;
    end;
    for i := 0 to $FF do begin
      winobject.Color := winobject.Color + $100;
      sleep(1);
      Application.ProcessMessages;
    end;
    winobject.Color := clWindow;
  end;

procedure TSetupForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
   canclose: boolean;
begin
   if (sender <> nil) and (ModalResult <> mrOK) then Exit;
   canClose := ParseAddress(eMainAKA.Text, FidoAddr1);
   if canClose then begin
      canClose := ParseAddress(eSynchClock.Text, FidoAddr2);
      if not canClose then begin
         DisplayErrorLng(rsAdrInNoValidAdr, Handle);
        _FlashWindow(eSynchClock)
      end;
   end else begin
      DisplayErrorLng(rsAdrInNoValidAdr, Handle);
     _FlashWindow(eMainAKA)
   end;
   if not CanClose then begin
      Action := caNone;
      tmCRC.Enabled := False;
      While inCRC do Sleep(100);
   end;
end;

procedure TSetupForm.sbMainAKABrowseClick(Sender: TObject);
begin
  if InputSingleAddress(LngStr(rsMMBrsNdlAt), FidoAddr1, nil) then
     eMainAKA.Text:=Addr2Str(FidoAddr1);
end;

procedure TSetupForm.sbSynchClockBrowseClick(Sender: TObject);
begin
  if InputSingleAddress(LngStr(rsMMBrsNdlAt), FidoAddr2, nil) then
     eSynchClock.Text := Addr2Str(FidoAddr2);
end;

procedure TSetupForm.btnHomeClick(Sender: TObject);
var
   s: string;
  _Sender: TEdit;
begin
  _Sender := nil;// to avoid uninitialized warning;
  case TButton(Sender).Tag of
    0: _Sender := eHome;
    1: _Sender := eConfigs;
    2: _Sender := eFlags;
    3: _Sender := eTempInbound;
    4: _Sender := eSecureInbound;
    5: _Sender := eInbound;
    6: _Sender := eOutbound;
    7: _Sender := eLogs;
    else GlobalFail('TSetupForm.btnHomeClick, TButton(Sender).Tag = %d', [TButton(Sender).Tag]);
  end; {of case}
  s := Browse(Handle, _Sender.Text);
  if s <> '' then _Sender.Text := s;
end;

procedure TSetupForm.btnHelpClick(Sender: TObject);
begin
   Application.HelpContext(HelpContext);
end;

procedure TSetupForm.sbDefGaugeClick(Sender: TObject);
begin
  case (Sender as TComponent).Tag of
    0:
      begin
        cbGaugeFore.Selected := clBlack;
        cbGaugeBack.Selected := clYellow;
      end;
    1:
      begin
        cbLoggerBack.Selected := clBtnFace;
        cbLoggerFore.Selected := clWindowText;
      end;
    2:
      begin
        cbBadWazooBack.Selected := clYellow;
        cbBadWazooFore.Selected := clBlack;
      end;
    3:
      begin
        cbMail7Fore.Selected := clRed;
        cbMail7Back.Selected := clWindow;
      end;
    4:
      begin
        cbMail14Fore.Selected := clRed;
        cbMail14Back.Selected := clWindow;
      end;
    5:
      begin
        cbMail21Fore.Selected := clRed;
        cbMail21Back.Selected := clWindow;
      end;
    6:
      begin
        cbMail28Fore.Selected := clRed;
        cbMail28Back.Selected := clWindow;
      end;
    else GlobalFail('TSetupForm.sbDefGaugeClick, (Sender as TComponent).Tag = %d', [(Sender as TComponent).Tag]);
  end; {of case}
end;

procedure TSetupForm.sbSysGaugeClick(Sender: TObject);
begin
  case (Sender as TComponent).Tag of
    0:
      begin
        cbGaugeFore.Selected := clWindowText;
        cbGaugeBack.Selected := clWindow;
      end;
    1:
      begin
        cbLoggerBack.Selected := clBtnFace;
        cbLoggerFore.Selected := clWindowText;
      end;
    2:
      begin
        cbBadWazooBack.Selected := clWindow;
        cbBadWazooFore.Selected := clWindowText
      end;
    3:
      begin
        cbMail7Fore.Selected := clWindowText;
        cbMail7Back.Selected := clWindow;
      end;
    4:
      begin
        cbMail14Fore.Selected := clWindowText;
        cbMail14Back.Selected := clWindow;
      end;
    5:
      begin
        cbMail21Fore.Selected := clWindowText;
        cbMail21Back.Selected := clWindow;
      end;
    6:
      begin
        cbMail28Fore.Selected := clWindowText;
        cbMail28Back.Selected := clWindow;
      end;
    else
      GlobalFail('TSetupForm.sbSysGaugeClick, TButton(Sender).Tag = %d', [TButton(Sender).Tag]);
  end;{of case}
end;

procedure TSetupForm.btnApplyClick(Sender: TObject);
var
   Action: TCloseAction;
begin
   Action := caFree;
   FormClose(nil, Action);
   if Action = caNone then exit;
   SetupForm.GetData;
   IniFile.StoreCFG;
   wdCRC := 0;
end;

procedure TSetupForm.eHomeChange(Sender: TObject);
begin
  HomeChanged := true;
end;

procedure TSetupForm.eConfigsChange(Sender: TObject);
begin
  ConfigsChanged := true;
end;

procedure TSetupForm.sbMainNextClick(Sender: TObject);
begin
  MainPan1.Visible := false;
  MainPan2.Visible := true;
  sbMainPrev.Enabled := true;
  sbMainNext.Enabled := false;
end;

procedure TSetupForm.sbMainPrevClick(Sender: TObject);
begin
  MainPan1.Visible := true;
  MainPan2.Visible := false;
  sbMainPrev.Enabled := false;
  sbMainNext.Enabled := true;
end;

procedure TSetupForm.bFormsFontClick(Sender: TObject);
begin
   fdForms.Font.Assign(Font);
   if fdForms.Execute then begin
      Font.Assign(fdForms.Font);
      lFormsFont.Caption := Format('%s (%d Pts)',[Font.Name, Font.Size]);
   end;
end;

procedure TSetupForm.bLoggerFontClick(Sender: TObject);
begin
   fdLogger.Font.Color := cbLoggerFore.Selected;
   if fdLogger.Execute then begin
      cbLoggerFore.Selected := fdLogger.Font.Color;
      lLoggerFont.Caption := Format('%s (%d Pts)',[fdLogger.Font.Name, fdLogger.Font.Size]);
   end;
end;

procedure TSetupForm.btnChatBellClick(Sender: TObject);
begin
   if not odChatBell.Execute then exit;
   eChatBell.Text := odChatBell.FileName;
end;

procedure TSetupForm.FillNetmailGrid;
begin
   gNetmail.SetData([IniFile.NetmailAddrTo, IniFile.NetmailAddrFrom, IniFile.NetmailPwd]);
end;

procedure TSetupForm.Button1Click(Sender: TObject);
begin
   odChatBell.FileName := Edits[(Sender as TButton).Tag].ed.Text;
   if odChatBell.Execute then begin
      Edits[(Sender as TButton).Tag].ed.Text := odChatBell.FileName;
      Edits[(Sender as TButton).Tag].cb.Checked := True;
   end;
end;

procedure TSetupForm.cbStealthClick(Sender: TObject);
begin
   hkPopup.Enabled := cbStealth.Checked;
end;

procedure TSetupForm.hkPopupChange(Sender: TObject);
begin
   Update;
end;

procedure TSetupForm.cbPriorityChange(Sender: TObject);
begin
   case cbPriority.ItemIndex of
   0: IniFile.Priority := IDLE_PRIORITY_CLASS;
   1: IniFile.Priority := NORMAL_PRIORITY_CLASS;
   2: IniFile.Priority := HIGH_PRIORITY_CLASS;
   3: IniFile.Priority := REALTIME_PRIORITY_CLASS;
   else
      IniFile.Priority := NORMAL_PRIORITY_CLASS; //GlobalFail ??
   end; {of case}
   SetPriorityClass(GetCurrentProcess, IniFile.Priority);
end;

procedure TSetupForm.tmCRCTimer(Sender: TObject);
var
   CRC: DWORD;

   procedure CalcCRC(o: TComponent);
   var
      i: integer;
      c: TComponent;
      s: string;
      n: integer;
      m: integer;
      g: TAdvGrid;
      f: TFontDialog;
   begin
      for i := 0 to o.ComponentCount - 1 do begin
         c := o.Components[i];
         if c is TLabel then begin
            if ((c as TLabel).Name =  'lFormsFont') or
               ((c as TLabel).Name = 'lLoggerFont') then begin
               s := (c as TLabel).Caption;
               CRC := CRC32Str(s, CRC);
            end;
         end else
         if c is TCheckBox then begin
            CRC := UpdateCRC32(byte((c as TCheckBox).Checked), CRC);
         end else
         if c is TComboBox then begin
            CRC := CRC32Int((c as TComboBox).ItemIndex, CRC);
         end else
         if c is TxSpinEdit then begin
            CRC := CRC32Int((c as TxSpinEdit).Value, CRC);
         end else
         if c is TEdit then begin
            s := (c as TEdit).Text;
            CRC := CRC32Str(s, CRC);
         end else
         if c is TColorBox then begin
            CRC := CRC32Int((c as TColorBox).Selected, CRC);
         end else
         if c is THotKey then begin
            CRC := CRC32Int((c as THotKey).HotKey, CRC);
         end else
         if c is TAdvGrid then begin
            g := c as TAdvGrid;
            for n := 0 to g.RowCount - 1 do begin
               for m := 0 to g.ColCount - 1 do begin
                  s := g.Cells[m, n];
                  CRC := CRC32Str(s, CRC);
               end;
            end;
         end else
         if c is TFontDialog then begin
            f := c as TFontDialog;
            CRC := CRC32Int(f.Font.Charset, CRC);
            CRC := CRC32Int(f.Font.Size, CRC);
            CRC := UpdateCRC32(byte(f.Font.Style), CRC);
         end;
         if c is TComponent then begin
            CalcCRC(c);
         end;
      end;
   end;

begin
   inCRC := True;
   CRC := CRC32_INIT;
   CalcCRC(SetupForm);
   if SetupForm.wdCRC = 0 then begin
      SetupForm.wdCRC := CRC;
   end;
   if SetupForm <> nil then begin
      SetupForm.btnApply.Enabled := CRC <> SetupForm.wdCRC;
   end;
   inCRC := False;
end;

procedure TSetupForm.bNetmailClick(Sender: TObject);
var
   s: string;
begin
   s := Browse(Handle, eNetmail.Text);
   if s <> '' then begin
      eNetmail.Text := s;
   end;
end;

procedure TSetupForm.cbScanMSGClick(Sender: TObject);
begin
   eNetmail.Enabled := cbScanMSG.Checked;
   bNetmail.Enabled := cbScanMSG.Checked;
end;

end.
