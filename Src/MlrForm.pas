unit MlrForm;

{$I DEFINE.INC}

interface

uses
   Classes, Menus, Forms, MClasses, ComCtrls, ExtCtrls, mGrids,
   Controls, StdCtrls, Windows, xFido, MlrThr, Outbound,
   Graphics, xMisc, Messages, xBase, SysUtils, Buttons,
   Dialogs, ImgList, RemoteUnit, xOutline, Netmail, JvComponent,
   JvAnalogClock, JvxClock;

type

   Twcb = (
      wcb_lSndSize,
      wcb_llSndSize,
      wcb_lSndCPS,
      wcb_llSndCPS,
      wcb_lRcvSize,
      wcb_llRcvSize,
      wcb_lRcvCPS,
      wcb_llRcvCPS,
      wcb_SndTot,
      wcb_RcvTot,
      wcbSndBar,
      wcbRcvBar,
      wcbLampsPanel,
      wcbTimeoutBox,

      wcb_mlClose,
      wcb_mlAbortOperation,
      wcb_mlResetTimeout,
      wcb_mlIncTimeout,

      wcb_mpReset,
      wcb_bResetPoll,
      wcb_ppResetPoll,

      wcb_mpTrace,
      wcb_bTracePoll,
      wcb_ppTracePoll,

      // visual {
      wcb_lFileSndTime,
      wcb_llFileSndTime,
      wcb_lTotalSndTime,
      wcb_llTotalSndTime,
      wcb_lFileRcvTime,
      wcb_llFileRcvTime,
      wcb_lTotalRcvTime,
      wcb_llTotalRcvTime,
      wcb_lSessionTime,
      wcb_llSessionTime,
      wcb_lSessionCost,
      wcb_llSessionCost,
      // vusual }

      wcb_mpPause,
      wcb_ppPause,
      wcb_bPause,

      wcb_mpDelete,
      wcb_bDeletePoll,
      wcb_ppDeletePoll,

      wcb_mpDeleteAll,
      wcb_bDeleteAllPolls,
      wcb_ppDeleteAllPolls,

      wcb_mlSkip,
      wcb_bSkip,
      wcb_mlRefuse,
      wcb_mlChat,
      wcb_bRefuse,

      wcb_mlAnswer,
      wcb_bAnswer,
      wcb_bKillBWZ,
      wcb_bChat,

      wcb_TopPage0,
      wcb_TopPage1,
      wcb_TopPage2,
      wcb_TopPage3,
      wcb_TopPage4,
      wcb_TopPage5,

      wcb_BtmPage0,
      wcb_BtmPage1,
      wcb_BtmPage2,
      wcb_BtmPage3,
      wcb_BtmPage4,
      wcb_BtmPage5,

      wcb_Rescan,

      wcb_MasterKeyCreate,
      wcb_MasterKeyChange,
      wcb_MasterKeyRemove,

      wcb_OutSmartMenu,

      wcb_mlSendMdmCmds //,

      );

   Twci = (
      wciSndTotCur,
      wciSndTotMax,
      wciSndFilCur,
      wciSndFilMax,
      wciRcvTotCur,
      wciRcvTotMax,
      wciRcvFilCur,
      wciRcvFilMax
      );

   Twcs = (
      wcsStatus,
      wcsTimeout,

      wcsGrd1,
      wcsGrd2,
      wcsGrd3,
      wcsGrd4,
      wcsGrd5,
      wcsGrd6,
      wcsGrd7,
      wcsGrd8,

      wcsSndFile,
      wcsSndCPS,
      wcsSndSize,

      wcsRcvFile,
      wcsRcvCPS,
      wcsRcvSize,

      wcsErr,
      wcsProtName,

      wcsPurgeFile,
      wcsPurgeNode,

      // visual {
      wcslFileSndTime,
      wcslTotalSndTime,
      wcslFileRcvTime,
      wcslTotalRcvTime,
      wcslSessionTime,
      wcslSessionCost
      // visual }

      );

  TOutMgrOpCode = (omoUnk, omoReaddr, omoKill, omo_Immed, omo_Crash, omo_Direct, omo_Normal, omo_Hold, omoUnlink, omoPurge);

  TOutMgrGroupInfo = record
    AreBroken,
    CanUnLink: Boolean;
    OutAttTypesFound: TOutAttTypeSet;
    StatusesFound: TOutStatusSet;
  end;

  TMailerForm = class(TForm) //standard text aling
    SessionHist: TTransPan;
    MHistO: TNavyGraph;
    MHistI: TNavyGraph;
    MainTabControl: TTabControl;
    MainPanel: TTransPan;
    MainMenu: TMainMenu;
    mSystem: TMenuItem;
    mLine: TMenuItem;
    mHelp: TMenuItem;
    mlAbortOperation: TMenuItem;
    mlResetTimeout: TMenuItem;
    mlIncTimeout: TMenuItem;
    mwClose: TMenuItem;
    N2: TMenuItem;
    mwCreateMirror: TMenuItem;
    mwRemoteMirror: TMenuItem;
    mfExit: TMenuItem;
    mConfig: TMenuItem;
    mTool: TMenuItem;
    mtBrowseNodelist: TMenuItem;
    mtCompileNodelist: TMenuItem;
    mPoll: TMenuItem;
    mpCreate: TMenuItem;
    mpDelete: TMenuItem;
    mpReset: TMenuItem;
    mpDeleteAll: TMenuItem;
    N1: TMenuItem;
    mlClose: TMenuItem;
    N6: TMenuItem;
    mcPasswords: TMenuItem;
    msOpenDialup: TMenuItem;
    mfRunIPDaemon: TMenuItem;
    N8: TMenuItem;
    mhAbout: TMenuItem;
    LogBox: TLogger;
    mcDialup: TMenuItem;
    mcDaemon: TMenuItem;
    mcPathnames: TMenuItem;
    mcStartup: TMenuItem;
    mcNodelist: TMenuItem;
    mhContents: TMenuItem;
    N9: TMenuItem;
    mpTrace: TMenuItem;
    PollPopupMenu: TPopupMenu;
    ppCreatePoll: TMenuItem;
    N11: TMenuItem;
    ppTracePoll: TMenuItem;
    ppResetPoll: TMenuItem;
    ppDeletePoll: TMenuItem;
    ppDeleteAllPolls: TMenuItem;
    maExternals: TMenuItem;
    maFileRequests: TMenuItem;
    N7: TMenuItem;
    mtEditFileRequest: TMenuItem;
    maEvents: TMenuItem;
    N12: TMenuItem;
    mlSkip: TMenuItem;
    mlRefuse: TMenuItem;
    mlAnswer: TMenuItem;
    TopNotebookPanel: TTransPan;
    PollsListPanel: TTransPan;
    PollsListView: TAdvListView;
    DaemonPanel: TTransPan;
    MainDaemonPanel: TTransPan;
    Panel7: TTransPan;
    Panel9: TTransPan;
    DaemonPI: TTransPan;
    Panel16: TTransPan;
    gInput: TNavyGauge;
    Panel12: TTransPan;
    DaemonPIH: TTransPan;
    Panel18: TTransPan;
    gInputGraph: TNavyGraph;
    Panel6: TTransPan;
    Panel8: TTransPan;
    DaemonPO: TTransPan;
    Panel111: TTransPan;
    gOutput: TNavyGauge;
    Panel10: TTransPan;
    DaemonPOH: TTransPan;
    Panel17: TTransPan;
    gOutputGraph: TNavyGraph;
    Panel19: TTransPan;
    Panel20: TTransPan;
    Panel21: TTransPan;
    MailerAPanel: TTransPan;
    TermsPanel: TTransPan;
    TermTx: TMicroTerm;
    TermRx: TMicroTerm;
    DialupInfoPanel: TTransPan;
    StatusCarrier: TTransPan;
    StatusBox: TGroupBox;
    MailerBPanel: TTransPan;
    Panel2: TTransPan;
    SndBox: TGroupBox;
    lSndFile: TLabel;
    llSndCPS: TLabel;
    lSndCPS: TLabel;
    llSndSize: TLabel;
    lSndSize: TLabel;
    SndTot: TxGauge;
    SndBar: TProgressBar;
    RcvBox: TGroupBox;
    lRcvFile: TLabel;
    llRcvCPS: TLabel;
    lRcvCPS: TLabel;
    llRcvSize: TLabel;
    lRcvSize: TLabel;
    RcvTot: TxGauge;
    RcvBar: TProgressBar;
    Panel3: TTransPan;
    SessionNfoPnl: TTransPan;
    gTabCnt: TTabControl;
    gTitles: TAdvGrid;
    gNfo: TAdvGrid;
    gLst: TAdvGrid;
    BottomPanel: TTransPan;
    MailerBtnPanel: TTransPan;
    bAbort: TSpeedButton;
    bRefuse: TSpeedButton;
    bSkip: TSpeedButton;
    bAnswer: TSpeedButton;
    bPause: TSpeedButton;
    LampsPanelCarrier: TTransPan;
    LampsPanel: TTransPan;
    mlRXD: TModemLamp;
    lRXD: TLabel;
    mlTXD: TModemLamp;
    lTXD: TLabel;
    mlCTS: TModemLamp;
    lCTS: TLabel;
    lDSR: TLabel;
    mlDSR: TModemLamp;
    mlDCD: TModemLamp;
    lDCD: TLabel;
    PollBtnPanel: TTransPan;
    DaemonBtnPanel: TTransPan;
    OutMgrPopup: TPopupMenu;
    OutMgrPanel: TTransPan;
    SystemPanel: TTransPan;
    OutMgrHeader: THeaderControl;
    OutMgrBevel: TBevel;
    OutMgrOutline: TxOutlin;
    OutMgrBtnPanel: TTransPan;
    SystemBtnPanel: TTransPan;
    bReread: TSpeedButton;
    bDeleteAllPolls: TSpeedButton;
    bTracePoll: TSpeedButton;
    bResetPoll: TSpeedButton;
    bDeletePoll: TSpeedButton;
    bNewPoll: TSpeedButton;
    TrayPopupMenu: TPopupMenu;
    tpRestore: TMenuItem;
    tpExit: TMenuItem;
    N5: TMenuItem;
    tpCreatePoll: TMenuItem;
    tpBrowseNodelist: TMenuItem;
    maEncryptedLinks: TMenuItem;
    tpCancel: TMenuItem;
    N3: TMenuItem;
    N10: TMenuItem;
    tpEditFileRequest: TMenuItem;
    mcMasterPassword: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    mcMasterPwdCreate: TMenuItem;
    mcMasterPwdChange: TMenuItem;
    mcMasterPwdRemove: TMenuItem;
    N17: TMenuItem;
    ompCur: TMenuItem;
    ompName: TMenuItem;
    ompExt: TMenuItem;
    ompStat: TMenuItem;
    ompAll: TMenuItem;
    opmImmed: TMenuItem;
    opmCrash: TMenuItem;
    opmDirect: TMenuItem;
    opmNormal: TMenuItem;
    opmHold: TMenuItem;
    N19: TMenuItem;
    opmPurge: TMenuItem;
    opmReaddress: TMenuItem;
    opmFinalize: TMenuItem;
    ompEntire: TMenuItem;
    N21: TMenuItem;
    N18: TMenuItem;
    N20: TMenuItem;
    N22: TMenuItem;
    ompAttach: TMenuItem;
    ompPoll: TMenuItem;
    ompBrowseNL: TMenuItem;
    opmUnlink: TMenuItem;
    ompEditFreq: TMenuItem;
    mtAttachFiles: TMenuItem;
    mtOutSmartMenu: TMenuItem;
    mtBrowseNodelistAt: TMenuItem;
    mcPolls: TMenuItem;
    ompOpen: TMenuItem;
    ompCreateFlag: TMenuItem;
    ompCfImmed: TMenuItem;
    ompCfCrash: TMenuItem;
    ompCfDirect: TMenuItem;
    ompCfNormal: TMenuItem;
    ompCfHold: TMenuItem;
    mtCreateFlag: TMenuItem;
    mlSendMdmCmds: TMenuItem;
    mtCompileNodelistInv: TMenuItem;
    N13: TMenuItem;
    mcFileBoxes: TMenuItem;
    N14: TMenuItem;
    ompRescan: TMenuItem;
    N23: TMenuItem;
    maNodes: TMenuItem;
    N24: TMenuItem;
    ompHelp: TMenuItem;
    N25: TMenuItem;
    tpCreateNormalPoll: TMenuItem;
    mpNormalPoll: TMenuItem;
    ppNormalPoll: TMenuItem;
    mpPause: TMenuItem;
    ppPause: TMenuItem;
    SessionBox: TGroupBox;
    ompCfPause: TMenuItem;
    mfRestart: TMenuItem;
    N4: TMenuItem;
    tExternal: TMenuItem;
    eaNone: TMenuItem;
    Panel4: TTransPan;
    GroupBox2: TGroupBox;
    Panel11: TTransPan;
    bwListView: TListView;
    pBWZ: TPopupMenu;
    mnuDelBWZ: TMenuItem;
    mnuNow: TMenuItem;
    mnuNow2: TMenuItem;
    bKillBWZ: TSpeedButton;
    bChat: TSpeedButton;
    mnuTossBwz: TMenuItem;
    mnuWebSite: TMenuItem;
    tpMinimize: TMenuItem;
    N26: TMenuItem;
    N27: TMenuItem;
    mnuLines: TMenuItem;
    mnu_tray_TCP: TMenuItem;
    llFileSndTime: TLabel;
    lFileSndTime: TLabel;
    llTotalSndTime: TLabel;
    lTotalSndTime: TLabel;
    llFileRcvTime: TLabel;
    lFileRcvTime: TLabel;
    llTotalRcvTime: TLabel;
    lTotalRcvTime: TLabel;
    llSessionTime: TLabel;
    lSessionTime: TLabel;
    llSessionCost: TLabel;
    lSessionCost: TLabel;
    mnuTerminal: TMenuItem;
    llAvaibleAtInbound: TLabel;
    lAvaibleAtInbound: TLabel;
    lOutboundSize: TLabel;
    llOutboundSize: TLabel;
    mnuPrefEx: TMenuItem;
    CancelButton: TButton;
    ConnectButton: TButton;
    lStatus2: TLabel;
    lTimeCon: TLabel;
    mlChat: TMenuItem;
    ilMainMenu: TImageList;
    ChatPan: TTransPan;
    Panel13: TTransPan;
    eType: TEdit;
    Panel15: TTransPan;
    ChatMemo1: TMemo;
    ChatMemo2: TMemo;
    RasLabelPan: TTransPan;
    RasBtnPan: TTransPan;
    ChatCaptionPan: TTransPan;
    sbCloseChat: TSpeedButton;
    imgHeader: TImage;
    lChatCaption: TLabel;
    lStatus: TLabel;
    TimeoutBox: TTransPan;
    lTimeout: TLabel;
    bStart: TSpeedButton;
    bAdd: TSpeedButton;
    SplitterAPanel: TSplitter;
    SplitterBPanel: TSplitter;
    ilTray: TImageList;
    lInfo1: TLabel;
    lInfo2: TLabel;
    lTime1: TLabel;
    lTime0: TLabel;
    N28: TMenuItem;
    mtViewLogs: TMenuItem;
    LName: TMenuItem;
    StatusLine: TTransPan;
    GroupLine: TGroupBox;
    TransPan1: TTransPan;
    TransPan2: TTransPan;
    Clock: TJvAnalogClock;
    TransPan3: TTransPan;
    GroupBox1: TGroupBox;
    stListView: TListView;
    evListView: TListView;
    mnuClock: TMenuItem;
    N29: TMenuItem;
    lClock: TTransPan;
    JvxClock: TJvxClock;
    Clock2: TJvxClock;
    pobLeft: TTransPan;
    pobCenter: TTransPan;
    Label1: TLabel;
    procedure MainTabControlChange(Sender: TObject);
    procedure bAbortClick(Sender: TObject);
    procedure bStartClick(Sender: TObject);
    procedure bAddClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mcPathnamesClick(Sender: TObject);
    procedure mwCreateMirrorClick(Sender: TObject);
    procedure mwRemoteMirrorClick(Sender: TObject);
    procedure mcDialupClick(Sender: TObject);
    procedure NodesPasswords1Click(Sender: TObject);
    procedure mlCloseClick(Sender: TObject);
    procedure bNewPollClick(Sender: TObject);
    procedure PollsListViewChange(Sender: TObject; Item: TListItem; Change: TItemChange);
    procedure PollsListViewClick(Sender: TObject);
    procedure bDeletePollClick(Sender: TObject);
    procedure mfExitClick(Sender: TObject);
    procedure mtBrowseNodelistClick(Sender: TObject);
    procedure mwCloseClick(Sender: TObject);
    procedure mhAboutClick(Sender: TObject);
    procedure bResetPollClick(Sender: TObject);
    procedure bDeleteAllPollsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mfRunIPDaemonClick(Sender: TObject);
    procedure mcStartupClick(Sender: TObject);
    procedure mtCompileNodelistClick(Sender: TObject);
    procedure mcNodelistClick(Sender: TObject);
    procedure mcDaemonClick(Sender: TObject);
    procedure mhContentsClick(Sender: TObject);
    procedure mhWebSiteClick(Sender: TObject);
    procedure mhHelpClick(Sender: TObject);
    procedure bTracePollClick(Sender: TObject);
    procedure mcExternalsClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SetIntLang(i1: integer; i2: integer);
    procedure SetColors;
    procedure mclEnglishUKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure maEventsClick(Sender: TObject);
    procedure bSkipClick(Sender: TObject);
    procedure bRefuseClick(Sender: TObject);
    procedure bChatClick(Sender: TObject);
    procedure maFileRequestsClick(Sender: TObject);
    procedure mtEditFileRequestClick(Sender: TObject);
    procedure bAnswerClick(Sender: TObject);
    procedure OutMgrOutlineDrawItem(Control: TWinControl; Index: Integer; R: TRect; State: TOwnerDrawState);
    procedure FormResize(Sender: TObject);
    procedure OutMgrOutlineMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure OutMgrOutlineDblClick(Sender: TObject);
    procedure OutMgrHeaderSectionClick(HeaderControl: THeaderControl; Section: THeaderSection);
    procedure OutMgrHeaderSectionResize(HeaderControl: THeaderControl; Section: THeaderSection);
    procedure TrayIconClick(Sender: TObject);
    procedure TrayIconMinimize(Sender: TObject);
    procedure maEncryptedLinksClick(Sender: TObject);
    procedure tpRestoreClick(Sender: TObject);
    procedure tpCreatePollClick(Sender: TObject);
    procedure tpBrowseNodelistClick(Sender: TObject);
    procedure tpEditFileRequestClick(Sender: TObject);
    procedure msAdministrativeModeClick(Sender: TObject);
    procedure mcMasterPwdCreateClick(Sender: TObject);
    procedure mcMasterPwdChangeClick(Sender: TObject);
    procedure mcMasterPwdRemoveClick(Sender: TObject);
    procedure bRereadClick(Sender: TObject);
    procedure opmReaddressClick(Sender: TObject);
    procedure opmFinalizeClick(Sender: TObject);
    procedure opmImmedClick(Sender: TObject);
    procedure opmCrashClick(Sender: TObject);
    procedure opmDirectClick(Sender: TObject);
    procedure opmNormalClick(Sender: TObject);
    procedure opmHoldClick(Sender: TObject);
    procedure opmPurgeClick(Sender: TObject);
    procedure OutMgrPopupPopup(Sender: TObject);
    procedure ompAttachClick(Sender: TObject);
    procedure ompPollClick(Sender: TObject);
    procedure ompBrowseNLClick(Sender: TObject);
    procedure opmUnlinkClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure OutMgrOutlineApiDropFiles(Sender: TObject);
    procedure ompEditFreqClick(Sender: TObject);
    procedure mtAttachFilesClick(Sender: TObject);
    procedure mtOutSmartMenuClick(Sender: TObject);
    procedure mtBrowseNodelistAtClick(Sender: TObject);
    procedure ompOpenClick(Sender: TObject);
    procedure OutMgrOutlineKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ompCfImmedClick(Sender: TObject);
    procedure ompCfCrashClick(Sender: TObject);
    procedure ompCfDirectClick(Sender: TObject);
    procedure ompCfNormalClick(Sender: TObject);
    procedure ompCfHoldClick(Sender: TObject);
    procedure PollPopupMenuPopup(Sender: TObject);
    procedure PollsListViewKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure PollsListViewDblClick(Sender: TObject);
    procedure mtCreateFlagClick(Sender: TObject);
    procedure mcPollsClick(Sender: TObject);
    procedure mlSendMdmCmdsClick(Sender: TObject);
    procedure mcFileBoxesClick(Sender: TObject);
    procedure maNodesClick(Sender: TObject);
    procedure ompHelpClick(Sender: TObject);
    function FormHelp(Command: Word; Data: Integer; var CallHelp: Boolean): Boolean;
    procedure tpCreateNormalPollClick(Sender: TObject);
    procedure mpPauseClick(Sender: TObject);
    procedure ompCfPauseClick(Sender: TObject);
    procedure TrayPopupMenuPopup(Sender: TObject);
    procedure mfRestartClick(Sender: TObject);
    procedure bwListBoxClick(Sender: TObject);
    procedure bbDeleteClick(Sender: TObject);
    procedure pBWZPopup(Sender: TObject);
    procedure mnuTossBwzClick(Sender: TObject);
    procedure mnuArgusCloneClick(Sender: TObject);
    procedure mnuRadiusOnWebClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure mnuTerminalClick(Sender: TObject);
    procedure ConnectButtonClick(Sender: TObject);
    procedure mnuPrefExClick(Sender: TObject);
    procedure ChatPanResize(Sender: TObject);
    procedure eTypeKeyPress(Sender: TObject; var Key: Char);
    procedure sbCloseChatClick(Sender: TObject);
    procedure ChatMemo2KeyPress(Sender: TObject; var Key: Char);
    procedure gTabCntChange(Sender: TObject);
    procedure SplitterAPanelMoved(Sender: TObject);
    procedure SplitterBPanelMoved(Sender: TObject);
    procedure PollsListViewApiDropFiles(Sender: TObject);
    procedure LNameClick(Sender: TObject);
    procedure ChatCaptionPanConstrainedResize(Sender: TObject;
      var MinWidth, MinHeight, MaxWidth, MaxHeight: Integer);
    procedure gLstRowDelete(Sender: TObject; xRow: Integer);
    procedure gLstRowMoved(Sender: TObject; FromIndex, ToIndex: Integer);
    procedure mnuClockClick(Sender: TObject);
    procedure evListViewClick(Sender: TObject);
    procedure evListViewCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure New1Click(Sender: TObject);
  private
    OutBSize: int64;
    aOutbound: TAnimate;
    uTaskbarRestart: DWORD;
    _Closed: Boolean;
    OutMgrSelectedItemInstead: Integer;
    OutMgrSelectedItemAddr: TFidoAddress;
    OutMgrSelectedItemName: string;
    OutMgrNodeSort: Integer;
    OutMgrdLast: TPoint;
    OutMgrBM: TBitmap;
    OutMgrBmps: array[0..2] of TBitmap;
    StartSize: TPoint;
    ListUpd: Integer;
    Activated, Shown: Boolean;
    ActiveLine: TMailerThread;
    wcs: array[Twcs] of string;
    wci: array[Twci] of Integer;
    wcb: set of Twcb;
    TopPagePanels: array[wcb_TopPage0..wcb_TopPage5] of TTransPan;
    BtmPagePanels: array[wcb_BtmPage0..wcb_BtmPage5] of TTransPan;
    OutMgrExpanded: TFidoAddrColl;
    OutMgrNodes: TOutNodeColl;
    FirstOutMgrNode,
    LastOutMgrNode: TOutItem;
    IC: TIcon;
    TNum: integer;
    TNam: string;
    TAct: pointer;
    TTim: DWORD;
    LUpd: boolean;
    procedure CreateAllMenu;
    procedure DestroyAllMenu;
    procedure UpdateBWZListBox;
    procedure FillBWListBox;
    procedure MyMenuClick(Sender: TObject);
    procedure ExceptionEvent(Sender: TObject; E: Exception);
    procedure UpdatePollOptions;
    procedure UpdateViewOutMgr;
    procedure OutMgrRefillExpanded;
    procedure LoadOutMgrBmp(i: Integer; const AName: string; AColor: TColor);
    procedure UpdateBoundsOutMgrBM;
    procedure UpdateOutboundManager;
    procedure SetTopPageIndex(Idx: Integer);
    procedure SetBtmPageIndex(Idx: Integer);
    procedure LineOpenClick(Sender: TObject);
    procedure PrepareGtitles;
    procedure SetLabel(L: TObject; c: TWcs; const s: string);
    procedure SetVisible(L: TControl; c: TWcb; V: Boolean);
    procedure SetEnabledO(L: TObject; c: TWcb; V: Boolean);
    procedure UpdateRas(const D: string; const DS: string);
    procedure UpdateDial(const D: TDisplayData; const DS: TDisplayStringData);
    procedure UpdateProt(const D: TDisplayData; const DS: TDisplayStringData; T, R: TBatch; AOutUsed: DWORD; var Btns: Boolean);
    procedure SetBar(B: TProgressBar; C, M: Integer; CI, MI: Twci);
    procedure SetGauge(G: TxGauge; C, M: Integer; CI, MI: Twci);
    procedure InsertPollAddress(const A: TFidoAddress);
    function PollAnyway(an: TAdvNode): Boolean;
    procedure WMGetMinMaxInfo(var AMsg: TWmGetMinMaxInfo); message WM_GETMINMAXINFO;
    procedure WMStartMdmCmd(var M: TMessage); message WM_STARTMDMCMD;
    procedure WMStartTerm(var M: TMessage); message WM_STARTTERM;
    procedure WMTrayRC(var M: TMessage); message WM_TRAYRC;
    procedure WMAppMinimize(var M: TMessage); message WM_APPMINIMIZE;
    procedure WMSetColors(var M: TMessage); message WM_SETCOLORS;
    procedure WMSetLang(var M: TMessage); message WM_SETLANG;
    procedure WMGridUpd(var M: TMessage); message WM_GRIDUPD;
    procedure WMUseSpace(var M: TMessage); message WM_USESPACE;
    procedure WMReReadCFG(var M: TMessage); message WM_CFGREREAD;
    procedure WMReReadOutb(var M: TMessage); message WM_REREADOUTB;
    procedure WMOutboundAlert(var M: TMessage); message WM_OUTBOUNDALERT;
    procedure WMRebuildExt(var M: TMessage); message WM_EXTREBUILD;
    procedure WMCheckFileFlags(var M: TMessage); message WM_CHECKFILEFLAGS;
    procedure WMNCCalcSize(var M: TWMNCCalcSize); message WM_NCCALCSIZE;
    procedure UpdateView(fromcc: boolean);
    procedure UpdateTabs;
    procedure UpdateLog;
    procedure UpdateLamps;
    procedure UpdateLast(const S: string; u: boolean);
    procedure InvalidateLabels;
    procedure RestoreFromTray;
    procedure NewPoll;
    procedure EditFileRequest;
    procedure EditFileRequestEx(const AA: TFidoAddress);
    procedure RereadOutbound(full: boolean);
    function OutMgrSelectedItem: TOutItem;
    procedure InvokeOutMgrSmartMenu;
    procedure UpdateOutboundCommands;
    function GetOutFileColl(FileMask: PString; NodeAdrr: PFidoAddress; OutStatus: POutStatus; var AInfo: TOutMgrGroupInfo): TOutFileColl;
    procedure FillOutMgrSubMenu(AMenu: TMenuItem; C: TOutFileColl; const AInfo: TOutMgrGroupInfo);
    function GetOutCollByTag(ATag: Integer; Item: TOutItem; var Caption: string; var AInfo: TOutMgrGroupInfo): TOutFileColl;
    procedure PerformOutboundOperations(FileLists: TColl; DestAddr: PFidoAddress; OpCode: TOutMgrOpCode);
    procedure OutOp(Sender: TObject; OpCode: TOutMgrOpCode);
    procedure OutOpTag(OpCode: TOutMgrOpCode; t: Integer);
    procedure AttachFiles(SC: TStringColl; const A: TFidoAddress);
    procedure AttachFilesQuery(const A: TFidoAddress);
    procedure BrowseNodelistAt(const Addr: TFidoAddress);
    procedure CreateOutFileFlag(const AA: TFidoAddress; Status: TOutStatus);
    procedure ompCreateFileFlag(os: TOutStatus);
  protected {3}
    function Hook(var Message: TMessage): Boolean;
  public {4}
    DU_InGrM, DU_OutGrM: array[0..TCPIP_GrDataSz] of Integer;
    TrayIcon: TTrayIcon;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function IsShortCut(var Message: TWMKey): Boolean; override;
    procedure SuperShow;
    procedure InsertEvt(Evt: Pointer);
    procedure WndProc(var M: TMessage); override;
    procedure SetHKSpace(x: boolean);
  end;

procedure InitMsgDispatcher;
procedure DoneMsgDispatcher;
procedure OpenMailerForm(AThread: TMailerThread; DoShow: Boolean);
function  OpenRemoteForm(P: Pointer): TRemoteForm;
procedure UpdateLampsAll;
procedure UpdateTerm(Struc: Integer);
procedure ClearTerms(AThr: Integer);
procedure OpenAutoStartLines;
function  OpenMailer(LineId: DWORD; Handle: DWORD): TMailerThread;
procedure FreeAllLines;
procedure FreeAllPolls(Action: TPollDone; All: Boolean);
procedure SwitchDaemon(Handle: DWORD);
procedure PurgeActiveFlags;
procedure VCompileNodelist(AAuto: boolean);

type
   T_OpenTerm = function(Handle: THandle): Boolean; stdcall;

   T_OpenUniTerm = function(PortHandle: THandle): Boolean; stdcall;


var
   LocalExit: Boolean;
   ModuleHandle: THandle;
   F_OpenTerm: T_OpenTerm = nil;
   F_OpenUniTerm: T_OpenUniTerm = nil;

implementation

uses
   igHHint, RasUnit, RasThrd, MdmCmd, Recs, NdlUtil, FileBox, NodeWiz,
   ActnList, xIP, LngTools, PathName, AltRecs, DupCfg, FidoPwd, NodeBrws,
   StupCfg, NodeLCfg, Wizard, Plus, Util, RadIni, tarif, IPCfg, ShellAPI,
   TracePl, Extrnls, PollCfg, xEvents, FreqCfg, SinglPwd, EncLinks,
   AdrIBox, FreqEdit, Attach, xDES, PwdInput, Setup, LogView, RadSav,
   EvtEdit, xTAPI;

{$R *.DFM}

const
   ioFolders = 0;
   ioLines = 1;

   olfLastItem = 1;
   olfLastLevel = 2;

procedure UpdateMenus;
var
   l: TLineRec;
   m,
  tm,
   n,
  tn,
   f: TMenuItem;
   c,
   i,
   j: Integer;
  mf: TMailerForm;
  MT: TStringColl;
begin
   c := 32817;
   if MailerForms = nil then Exit;
   if MailerThreads = nil then Exit;
   MT := TStringColl.Create;
   MailerThreads.Enter;
   for j := 0 to MailerThreads.Count - 1 do begin
      MT.Ins(TMailerThread(MailerThreads[j]).Name);
   end;
   MailerThreads.Leave;
   MailerForms.Enter;
   for j := 0 to MailerForms.Count - 1 do begin
      mf := MailerForms[j];
      m := mf.msOpenDialup;
      tm := mf.mnuLines;
      with m do begin
         while Count > 0 do begin
            f := Items[0];
            Remove(f);
            FreeObject(f);
         end;
      end;
      with tm do begin
         while Count > 0 do begin
            f := Items[0];
            Remove(f);
            FreeObject(f);
         end;
      end;
      for i := 0 to Cfg.Lines.Count - 1 do begin
         l := Cfg.Lines[i];
         n := TMenuItem.Create(m);
         if i < 9 then begin
            n.ShortCut := c + i;
         end;
         tn := TMenuItem.Create(m);
         n.Caption := l.Name;
         tn.Caption := l.Name;
         n.OnClick := mf.LineOpenClick;
         tn.OnClick := mf.LineOpenClick;
         if MT.Found(l.Name) then begin
            n.Checked := True;
            tn.Checked := True;
         end else begin
            n.Tag := l.id;
            tn.Tag := l.id;
         end;
         m.Add(n);
         tm.Add(tn);
      end;
      m.Enabled := True;
      m := mf.mtViewLogs;
      m.Clear;
      FreeObject(MT);
      MT := GetFileList(dLog, '*.*');
      if MT <> nil then begin
         while MT.Count > 0 do begin
            if (pos(MT[0], IniFile.StatxFName) = 0) and
               (MT[0] <> 'Tau_Ver' ) then
            begin
               n := TMenuItem.Create(m);
               n.Caption := MT[0];
               n.OnClick := mf.LNameClick;
               m.Add(n);
            end;
            MT.AtFree(0);
         end;
      end;
   end;
   MailerForms.Leave;
   FreeObject(MT);
end;

procedure OpenAutoStartLines;
var
   i: Integer;
   Lines: TLineColl;
   LR: TLineRec;
begin
   CfgEnter;
   Lines := Pointer(Cfg.Lines.Copy);
   CfgLeave;
   for i := 0 to Lines.Count - 1 do begin
      LR := Lines[i];
      if IsAutoStartLine(LR.Id) then begin
         OpenMailer(LR.Id, 0);
      end;
   end;
   FreeObject(Lines);
end;

procedure TabChangeAll;
var
   i: Integer;
begin
   if MailerForms <> nil then
      for i := 0 to MailerForms.Count - 1 do
         TMailerForm(MailerForms.At(i)).MainTabControlChange(nil);
end;

procedure UpdateTabsAll;
var
   i: Integer;
begin
   if MailerForms <> nil then
      for i := 0 to MailerForms.Count - 1 do
         TMailerForm(MailerForms.At(i)).UpdateTabs;
end;

procedure UpdateViewAll;
var
   i: Integer;
begin
   try

      if (MailerThreads <> nil) then begin
         if (MailerThreads.Count = 0) then ShowIt('Idle', True)
         else if (MailerThreads.Count > 1) then {ShowIt('', False);}
      end;

      MailerForms.Enter;
      for i := 0 to CollMax(MailerForms) do begin
         TMailerForm(MailerForms.At(i)).UpdateView(false);
      end;
      MailerForms.Leave;

   except on E: Exception do ProcessTrap(E.Message, 'UpdateViewAll');
   end;

end;

procedure UpdateLast(const P: longint; u: boolean);
var
   S: pstring absolute P;
   i: integer;
begin
   if s = nil then exit;
   if MailerForms <> nil then begin
      for i := 0 to MailerForms.Count - 1 do begin
         TMailerForm(MailerForms.At(i)).UpdateLast(S^, u);
      end;
   end;
end;

procedure ExportRoute(const P: longint);
var
   S: pstring absolute P;
   g: TStringList;
   i: integer;
   n: integer;
   m: integer;
   t: string;
   r: TPasswordRec;
   a: TFidoAddress;
begin
   g := TStringList.Create;
   n := 0;
   for i := 0 to IniFile.NetmailAddrTo.Count - 1 do begin
      m := Length(IniFile.NetmailAddrTo[i]);
      if m > n then n := m;
   end;
   g.Add('Routing:');
   g.Add('');
   for i := 0 to IniFile.NetmailAddrTo.Count - 1 do begin
      g.Add(Pad(IniFile.NetmailAddrTo[i], n + 2) + '<=  ' + ExtractWord(1, IniFile.NetmailAddrFrom[i], [' ']));
      t := IniFile.NetmailAddrFrom[i];
      for m := 2 to WordCount(t, [' ']) do begin
         g.Add(Pad('', n + 2) + '<=  ' + ExtractWord(m, t, [' ']));
      end;
   end;
   g.Add('');
   g.Add('Links:');
   g.Add('');
   for i := 0 to Cfg.Passwords.Count - 1 do begin
      r := Cfg.Passwords[i];
      for m := 0 to r.AddrList.Count - 1 do begin
         a := r.AddrList[m];
         if MatchMaskAddress(a, '*:*/*.0@*') then begin
            g.Add(Pad(Addr2Str(a), n + 1) + ' <=  ' + Addr2Str(a));
         end;
      end;
   end;
   g.SaveToFile(S^);
   g.Free;
end;

{$I utility.inc}

type
   TMsgDispatcher = class
      RASDaemonS: boolean;
      RASConnect: boolean;
      RASMailLin: dword;
      RASWaitPtr: integer;
      constructor Create;
      destructor Destroy; override;
      procedure WndProc(var Msg: TMessage);
      procedure AppMessage(var Msg: TMsg; var Handled: Boolean);
   end;

function TMailerForm.IsShortCut(var Message: TWMKey): Boolean;

  function DispatchShortCut: Boolean;
  var
     I: Integer;
  begin
     if FActionLists <> nil then
     for I := 0 to FActionLists.Count - 1 do
     if TCustomActionList(FActionLists[I]).IsShortCut(Message) then begin
        Result := True;
        Exit;
     end;
     Result := False;
  end;

begin
   Result := False;
   if Message.Result = 0 then exit;
   if Assigned(OnShortCut) then OnShortCut(Message, Result);
   if eType.Focused or ChatMemo1.Focused or ChatMemo2.Focused then begin
        // 539885569 - CTRL+ALT+C
        // 3407873   - '.'
        // 65537     - esc
      case Message.KeyData of
      65537: exit;     // ESC
      539885569: exit; // CTRL+ALT+C
      3735553: exit;   // ' '
      3407873: exit;   // '.'
      1835009: exit;   // ENTER
      else;
      end;
   end;
   Result := Result or (Menu <> nil) and (Menu.WindowHandle <> 0) and Menu.IsShortCut(Message) or DispatchShortCut;
end;

procedure TMailerForm.MyMenuClick(Sender: TObject);
begin
   WinExec(PChar(string(IniFile.ExtApp.Table[TMenuItem(Sender).MenuIndex + 1, 1])), sw_shownormal);
end;

procedure TMailerForm.UpdateBWZListBox;
var
   age,
   i: Integer;
   r: TBWZRec;
   newitem: TListItem;
   date: TDateTime;
   st: string;
begin
   BWZColl.Enter;
   BWZColl.Update;
   bwListView.Items.BeginUpdate;
   bwListView.Items.Clear;
   for i := 0 to BWZColl.Count - 1 do begin
      r := BWZColl[i];
      if FileExists(r.GetBWZFName) then begin
         newitem := bwListView.Items.Add;
         newitem.Caption := r.FName;
         newitem.SubItems.Add(Int2StrK(r.TmpSize));
         newitem.SubItems.Add(Int2StrK(r.FSize));
         newitem.SubItems.Add(Addr2Str(r.Addr));
         age := FileAge(r.GetBWZFName);
         date := SysUtils.Date;
         if age > -1 then begin
            date := FileDateToDateTime(age);
         end;
         st := formatdatetime('dd-mmm-yyyy hh:nn:ss', date);
         newitem.SubItems.Add(st);
      end;
   end;
   bwListView.Items.EndUpdate;
   BWZColl.Age := FileAge(BWZColl.FName);
   BWZColl.Update;
   BWZColl.Leave;
end;

procedure TMailerForm.FillBWListBox;
begin
   if FileAge(BWZColl.FName) <> BWZColl.Age then PostMSG(WM_UPDBWZ);
end;

procedure TMailerForm.CreateAllMenu;
var
   i: integer;

   function CreateMenuItem(const menucaption: string; menuenabled: boolean; shortcutidx: integer): TMenuItem;
   begin
      result := TMenuItem.Create(self);
      result.Caption := menucaption;
      result.OnClick := MyMenuClick;
      result.Enabled := menuenabled;
      if (shortcutidx > 0) and (shortcutidx < 10) then result.ShortCut := 16432 + shortcutidx;
   end;

begin
   if IniFile.ExtApp.Count = 0 then begin
      tExternal.Insert(0, CreateMenuItem('-none-', false, 0));
      exit;
   end;
   for i := 1 to IniFile.ExtApp.Count do begin
      tExternal.Insert(i - 1, CreateMenuItem(IniFile.ExtApp.Table[i, 2], true, i));
   end;
end;

procedure TMailerForm.DestroyAllMenu;
begin
   tExternal.Clear
end;

var
   MsgDispatcher: TMsgDispatcher;

constructor TMsgDispatcher.Create;
const
   CTimerTick = 1000;
begin
   inherited Create;
   MainWinHandle := AllocateHWnd(WndProc);
   SetTimer(MainWinHandle, 1, CTimerTick, nil);
end;

{.$IFDEF THRLOG}
procedure TMsgDispatcher.AppMessage(var Msg: TMsg; var Handled: Boolean);
begin
   IncLong(AppThrInvoked);
end;
{.$ENDIF}

destructor TMsgDispatcher.Destroy;
begin
   DeallocateHWnd(MainWinHandle);
   inherited Destroy;
end;

procedure GetTermBounds(var cw, ch: Integer);
begin
   if Application.MainForm = nil then begin
      cw := 0;
      ch := 0
   end else
   with TMailerForm(Application.MainForm).TermTx do begin
      cw := ClientWidth;
      ch := ClientHeight
   end;
end;

procedure NewIPLine(APort: Pointer; AIpPort: Integer; AProt: TProtCore; AType: DWORD);
var
  ILD: TNewIpLineData;
   cw,
   ch: Integer;
begin
   ILD := TNewIpLineData.Create;
   ILD.Poll := nil;
   ILD.IpPort := AIpPort;
   ILD.Prot := AProt;
   ILD.ATyp := AType;
   GetTermBounds(cw, ch);
   OpenMailerThread(APort, 0, ILD, cw, ch);
   PostMsg(WM_UPDATETABS);
end;

procedure NewInIPLine(l: Integer);
var
   NI: TNewIpInLine absolute l;
begin
   NewIpLine(NI.Port, NI.IpPort, NI.Prot, NI.aTyp);
   NI.Free;
end;

procedure OutConnRes(A: Integer);
var
   cr: TWSAConnectResult absolute A;
   s,
   z: string;
   ILD: TNewIpLineData;
   cw,
   ch: Integer;
   p: TFidoPoll;
   ss: TStringList;
   i: integer;
begin
   if FidoPolls.IndexOf(cr.p) > - 1 then begin
   if cr.Error then begin
      z := TFidoPoll(cr.p).IPAddr;
      if cr.Prot = ptSMTP then begin
         ss := IniFile.ReadSection('Grids', 'gPOP3');
         if ss <> nil then begin
            for i := 0 to ss.Count - 1 do begin
               s := IniFile.ReadString('Grids', ss[i]);
               if MatchMaskAddressListSingle(TFidoPoll(cr.p).Node.Addr, ExtractWord(5, s, ['|'])) then begin
                  z := ExtractWord(1, s, ['|']);
                  break;
               end;
            end;
            ss.Free;
         end;
      end;
      if (cr.ResolvedAddr = INADDR_NONE) then begin
         s := 'Unresolved'
      end else begin
         s := Addr2Inet(cr.ResolvedAddr);
      end;
      s := Format('%s (%s) #%d', [z, s, cr.IpPort]);
      z := Addr2Str(TFidoPoll(cr.p).Node.Addr);
      if cr.Terminated then begin
         s := Format('%s  Terminated  %s', [z, s]);
      end else begin
         s := Format('%s  WS%.5d (%s)  %s', [z, cr.Res, WSAErrMsg(cr.Res), s]);
      end;
      IPPolls.Logger.Log(ltInfo, s);
      TFidoPoll(cr.p).IncNoConnectTries;
      p := cr.p;
      RollPoll(p);
      cr.p := p;
   end else begin
      if (DaemonStarted) and (cr.Port <> nil) then begin
         ILD := TNewIpLineData.Create;
         ILD.Poll := cr.p;
         ILD.IpPort := cr.IpPort;
         ILD.Prot := cr.Prot;
         ILD.Addr := cr.Addr;
         ILD.ATyp := cr.ATyp;
         GetTermBounds(cw, ch);
         OpenMailerThread(cr.Port, 0, ILD, cw, ch);
         PostMsg(WM_UPDATETABS);
      end;
   end;
   end;
   FreeObject(cr);
end;

var
   FlFlgTimer: EventTimer;
var
   ThrLogTimer: EventTimer;

procedure UpdThrLog;
begin
   if TimerInstalled(ThrLogTimer) and not TimerExpired(ThrLogTimer) then Exit;
   NewTimerSecs(ThrLogTimer, 5);
   UpdateThreadsLog;
end;

procedure CheckFileFlags(const filename: string);
var
   reload: Boolean;

   function _FileExists(const s: string): boolean;
   begin
   {$IFDEF ReadDirectoryChanges}
     if (Win32Platform = VER_PLATFORM_WIN32_NT) and (filename <> '') then
     begin
       result := lowercase(filename) = lowercase(s);
     end else
   {$ENDIF}
     begin
       result := FileExists(s);
     end;
   end;

   procedure CheckDaemon;
   var
      open, close: Boolean;
      FOpen, FClose: string;
   begin
      FOpen := MakeFullDir(IniFile.FlagsDir, 'open.ip');
      FClose := MakeFullDir(IniFile.FlagsDir, 'close.ip');

      open := _FileExists(FOpen);
      close := _FileExists(FClose);

      if open then begin
         if not DaemonStarted then SwitchDaemon(INVALID_HANDLE_VALUE);
      end else
      if close then begin
         if DaemonStarted then SwitchDaemon(INVALID_HANDLE_VALUE);
      end;

      if open then DeleteFile(FOpen);
      if close then DeleteFile(FClose);

   end;

   procedure CheckLineFlags;
   var
      t: TMailerThread;
      i,
      j: Integer;
      Lines: TLineColl;
      LR: TLineRec;
      open,
      close: Boolean;
      FOpen,
      FClose: string;
   begin
      CfgEnter;
      Lines := Pointer(Cfg.Lines.Copy);
      for i := 0 to Lines.Count - 1 do begin
         LR := Lines[i];
         FOpen := MakeFullDir(IniFile.FlagsDir, 'open.' + LR.Name);
         FClose := MakeFullDir(IniFile.FlagsDir, 'close.' + LR.Name);

         open := _FileExists(FOpen);
         close := _FileExists(FClose);

         if close then begin
            DeleteFile(FClose);
            MailerThreads.Enter;
            for j := 0 to CollMax(MailerThreads) do begin
               t := MailerThreads[j];
               if Integer(t.LineId) = LR.Id then begin
                  t.InsertEvt(TMlrEvtFlagTerminate.Create);
                  reload := True;
                  Application.Title := LR.Name + ' closed';
                  If (Application.MainForm as TMailerForm).TrayIcon <> nil then begin
                  (Application.MainForm as TMailerForm).TrayIcon.Hint := LR.Name + ' closed';
                  end;
                  Sleep(2000);
               end;
            end;
            MailerThreads.Leave;
         end else
         if open then begin
            t := OpenMailer(LR.Id, INVALID_HANDLE_VALUE);
            if t <> nil then reload := True;
            DeleteFile(FOpen);
         end;
      end;
      FreeObject(Lines);
      CfgLeave;
   end;

   procedure CheckSingleFlags;
   var
      s,
      e: string;
      g: TStringList;
      I: integer;
      c: Char;

      function ispflag(s: string): boolean;
      begin
         s := uppercase(s);
         result := (s = '%EXITNOW%') or (copy(s, 1, 8) = '%RESTART') or
                   (s = '%STARTRAS%') or (s = '%STOPRAS%');
      end;

      procedure ExecuteFlag(s: string; const FlagName: string);
      begin
         s := uppercase(s);
         if s = '%EXITNOW%' then begin
            FidoPolls.Log.LogSelf(Format('Detected %s - exit is defined for this flag', [FlagName]));
            PostCloseMessage;
         end else
         if copy(s, 1, 8) = '%RESTART' then begin
            FidoPolls.Log.LogSelf(Format('Detected %s - restart is defined for this flag', [FlagName]));
            delete(s, 1, 8);
            if pos('%', s) = 0 then begin
               FidoPolls.Log.LogSelf(Format('Format of %s is invalid (not closed by "%")', [FlagName]));
               exit;
            end;
            if (length(s) > 1) or (strtointdef(copy(s, 1, pos('%', s) - 1), 0) < 5000) then s := '5000%';
            StoreConfig(0);
            ShellExecute(0, nil, PChar(ParamStr(0)),
               PChar('delay' + copy(s, 1, pos('%', s) - 1)), PChar(ExtractFilePath(ParamStr(0))), sw_shownormal);
            PostCloseMessage;
         end;
      end;

   begin
      case xBase.DirExists(IniFile.FlagsDir) of
        -1: FidoPolls.Log.LogSelf(Format('Please remove file ' + IniFile.FlagsDir + ' from the %s directory', [HomeDir]));
         0: CreateDir(IniFile.FlagsDir);
         1: ;
      end;

      s := MakeFullDir(IniFile.FlagsDir, 'EXIT.NOW');
      if _FileExists(s) then begin
         DeleteFile(s);
         FidoPolls.Log.LogSelf(Format('Detected %s - exiting', [s]));
         PostCloseMessage;
      end;

      s := MakeFullDir(IniFile.FlagsDir, 'NODELIST.OK');
      if _FileExists(s) then begin
         DeleteFile(s);
         FidoPolls.Log.LogSelf(Format('Detected %s - forced nodelist compilation', [s]));
         PostMsg(WM_COMPILENL);
      end;

      s := MakeFullDir(IniFile.FlagsDir, 'PASSWORD.OK');
      if _FileExists(s) then begin
         DeleteFile(s);
         FidoPolls.Log.LogSelf(Format('Detected %s - forced password list import', [s]));
         PostMsg(WM_IMPORTPWDL);
      end;

      s := MakeFullDir(IniFile.FlagsDir, 'DUPOVR.OK');
      if _FileExists(s) then begin
         DeleteFile(s);
         FidoPolls.Log.LogSelf(Format('Detected %s - forced dial-up nodes list import', [s]));
         PostMsg(WM_IMPORTDUPOVRL);
      end;

      s := MakeFullDir(IniFile.FlagsDir, 'IPOVR.OK');
      if _FileExists(s) then begin
         DeleteFile(s);
         FidoPolls.Log.LogSelf(Format('Detected %s - forced TCP/IP nodes list import', [s]));
         PostMsg(WM_IMPORTIPOVRL);
      end;

      s := MakeFullDir(IniFile.FlagsDir, 'RESCAN.NOW');
      if _FileExists(s) then begin
         DeleteFile(s);
         FidoPolls.Log.LogSelf(Format('Detected %s - forced rescan', [s]));
         ScanCounter := 99999;
      end;

      s := MakeFullDir(IniFile.FlagsDir, 'ROUTE.EXP');
      if _FileExists(s) then begin
         g := TStringList.Create;
         g.LoadFromFile(s);
         DeleteFile(s);
         if g.Count > 0 then begin
            e := g[0];
            SendMessage(MainWinHandle, WM_ROUTEEXPORT, Integer(@e), 0);
            FidoPolls.Log.LogSelf(Format('Detected %s - forced routing table export to: %s', [s, e]));
         end else begin
            FidoPolls.Log.LogSelf(Format('Detected empty %s - nothing to do', [s]));
         end;
         g.Free;
      end;

      for I := 0 to altcfg.FlagsCollA.Count - 1 do begin
         c := (altcfg.FlagsCollA.Strings[I])[1];
         s := altcfg.FlagsCollA.Strings[I];
         if c in ['?', '*', '&'] then delete(s, 1, 1);
         if not (xBase.direxists(ExtractDir(s)) = 1) then begin
            s := MakeFullDir(IniFile.FlagsDir, s);
         end;
         e := altcfg.FlagsCollB.Strings[I];
         while copy(e, 1, 1) = '#' do Delete(e, 1, 1);
         while copy(e, 1, 1) = '*' do Delete(e, 1, 1);
         while copy(e, 1, 1) = '<' do Delete(e, 1, 1);
         while copy(e, 1, 1) = '>' do Delete(e, 1, 1);
         while copy(e, 1, 1) = '+' do Delete(e, 1, 1);
         while copy(e, 1, 1) = '?' do Delete(e, 1, 1);
         if not ispflag(altcfg.FlagsCollB.Strings[I]) then begin
            {
             flagname.flg - выполнить команду, если существует (создан) флаг и
                            удалить его;
            *flagname.flg - выполнить команду, если отсутствует (удален) флаг;
            ?flagname.flg - выполнить команду, если существует (создан) флаг;
            &flagname.flg - выполнить команду, если отсутствует (удален) флаг и
                            создать его
            }
            case c of
               '?':
                  begin
                     if _FileExists(s) then begin
                        FidoPolls.Log.LogSelf(Format('Detected %s - forced executing %s', [s, e]));
                        WinExec(PChar(e), SW_SHOWMINNOACTIVE)
                     end;
                  end;
               '*':
                  begin
                     if not _FileExists(s) then begin
                        FidoPolls.Log.LogSelf(Format('Do not detected %s - forced executing %s', [s, e]));
                        WinExec(PChar(e), SW_SHOWMINNOACTIVE)
                     end;
                  end;
               '&':
                  begin
                     if not _FileExists(s) then begin
                        CloseHandle(FileCreate(s));
                        FidoPolls.Log.LogSelf(Format('Do not detected %s - forced executing %s', [s, e]));
                        WinExec(PChar(e), SW_SHOWMINNOACTIVE)
                     end;
                  end
            else begin
                  if _FileExists(s) then begin
                     FidoPolls.Log.LogSelf(Format('Detected %s - forced executing %s', [s, altcfg.FlagsCollB.Strings[I]]));
                     WinExec(PChar(e), SW_SHOWMINNOACTIVE);
                     DeleteFile(s);
                  end;
               end;
            end;
         end else begin
            case c of
               '?':
                  begin
                     if _FileExists(s) then
                        ExecuteFlag(altcfg.FlagsCollB.Strings[I], s);
                  end;
               '*':
                  begin
                     if not _FileExists(s) then
                        ExecuteFlag(altcfg.FlagsCollB.Strings[I], s);
                  end;
               '&':
                  begin
                     if not _FileExists(s) then begin
                        ShellExecute(Application.Handle, nil, PChar(format('/? > %s', [s])),
                           nil, PChar(ExtractFilePath(e)), sw_hide);
                        ExecuteFlag(altcfg.FlagsCollB.Strings[I], s);
                     end;
                  end
            else
                  begin
                  if _FileExists(s) then begin
                     DeleteFile(s);
                     ExecuteFlag(altcfg.FlagsCollB.Strings[I], s);
                  end;
               end;
            end;
         end;
      end;
   end;

begin
   reload := False;
   FileFlags.Enter;
   CheckSingleFlags;
   CheckLineFlags;
   CheckDaemon;
   FileFlags.Leave;
   if reload then begin
      PostMsg(WM_UPDATETABS);
      PostMsg(WM_TABCHANGE);
      PostMsg(WM_UPDATEMENUS);
   end;
end;

procedure ChkFlFlg(forced: boolean; const filename: string);
begin
   if not forced then begin
      if TimerInstalled(FlFlgTimer) and not TimerExpired(FlFlgTimer) then Exit;
   end;
   NewTimerSecs(FlFlgTimer, 5{inifile.FlagsCheckPeriod});
   CheckFileFlags(filename);
end;

procedure PurgeActiveFlags;
var
   Lines: TLineColl;
   LR: TLineRec;
   i: Integer;
   s: string;
begin
   CfgEnter;
   Lines := Pointer(Cfg.Lines.Copy);
   CfgLeave;
   for i := 0 to Lines.Count - 1 do begin
      LR := Lines[i];
      s := MakeFullDir(IniFile.FlagsDir, 'active.' + LR.Name);
      if FileExists(s) then DeleteFile(s);
   end;
   FreeObject(Lines);
   s := MakeFullDir(IniFile.FlagsDir, 'active.ip');
   if FileExists(s) then DeleteFile(s);
   s := MakeFullDir(IniFile.FlagsDir, 'current.ip');
   if FileExists(s) then DeleteFile(s);
end;

procedure SetupOK;
begin
   PurgeAdvNodeCache;
   InvalidatePollAddrs;
   _RecalcPolls(False);
   PostMsg(WM_UPDATEMENUS);
end;

const
   PBT_APMQUERYSUSPEND  = $0000;
   PBT_APMQUERYSTANDBY  = $0001;
   PBT_APMSUSPEND       = $0004;
   PBT_APMSTANDBY       = $0005;
   PBT_APMRESUMESUSPEND = $0007;
   PBT_APMRESUMESTANDBY = $0008;
   BROADCAST_QUERY_DENY = $424D5144;

procedure TMsgDispatcher.WndProc(var Msg: TMessage);
var
   DummyMsg: TMsg;
       Save: TShortCut;
       Line: DWORD;
       MlrT: TMailerThread;
          i: integer;
          l: TLineRec;
          s: string;
          b: boolean;
         cd: TCopyDataStruct;
   LinesCnt: integer;
begin
   LiveCounter := 0;
   if (Msg.Msg in [WM_QUERYENDSESSION, WM_ENDSESSION]) and (IniFile.IgnoreEndSession) then begin
      MSG.Result := 1;
      exit;
   end;
   if Msg.Msg = WM_POWERBROADCAST then begin
      case Msg.WParam of
      PBT_APMQUERYSUSPEND:
         begin
            MailerThreads.Enter;
            for i := CollMax(MailerThreads) downto 0 do begin
               MlrT := MailerThreads[i];
               if MlrT.DialupLine then begin
                  MlrT.Enter;
                  if (MlrT.SD <> nil) and (MlrT.SD.Prot <> nil) then begin
                     MlrT.SD.Prot.ProtocolError := ecAbortByLocal;
                  end;
                  MlrT.Leave;
               end;
            end;
            MailerThreads.Leave;
            repeat
               b := True;
               MailerThreads.Enter;
               for i := CollMax(MailerThreads) downto 0 do begin
                  MlrT := MailerThreads[i];
                  if MlrT.DialupLine then begin
                     b := b and (MlrT.State = msIdle);
                  end;
               end;
               MailerThreads.Leave;
               Sleep(500);
            until b;
            Msg.Result := 1;
         end;
      PBT_APMRESUMESUSPEND:
         begin
            if EventsThr <> nil then begin
               SetEvt(EventsThr.oEvt);
            end;
            Msg.Result := 1;
         end;
      end;
   end;
   if RASConnect and (RASThread <> nil) then RASThread.CheckConnection;
   if Cfg = nil then Exit;
   try
      if ExitNow then PostCloseMessage;
      if Msg.Msg = APIMessage then begin
         if Msg.WParam = 0 then begin
            APIHandle  := Msg.LParam;
            PostMessage(APIHandle, APIMessage, 0, MainWinHandle);
            Msg.Result := 1;
            exit;
         end else
         if Msg.WParam = 5 then begin
            Msg.Result := 0;
            if Application.MainForm <> nil then begin
               Msg.Result := 1;
               TMailerForm(Application.MainForm).RereadOutbound(false);
            end;
         end else
         if Msg.WParam = 6 then begin
            Msg.Result := 0;
            if RASThread <> nil then begin
               Msg.Result := 1;
               RASThread.Disconnect;
            end;
         end else
         if Msg.WParam = 7 then begin
            TMailerForm(Application.MainForm).mtAttachFilesClick(nil);
            Msg.Result := Application.MainForm.Handle;
         end else
         if Msg.WParam = 8 then begin
            Msg.Result := (GetTickCount - StartTime) div 1000;
            exit;
         end else
         if Msg.WParamLo = 9 then begin
            if Msg.LParam <> 0 then APIHandle := MSG.LParam;
            cd.dwData := Msg.WParamHi;
            s := '';
            case Msg.WParamHi of
          0: s := IniFile.HomeDir;
          1: s := IniFile.CfgDir;
          2: s := IniFile.FlagsDir;
          3: s := IniFile.Outbound;
          4: s := Inifile.InCommon;
          5: s := IniFile.InSecure;
          6: s := IniFile.InTemp;
          7: s := ExtractFilePath(IniFile.Log);
          8: s := ProductName + '/' + ProductVersion;
          9:
             begin
                MailerThreads.Enter;
                for i := 0 to MailerThreads.Count - 1 do begin
                   s := s + TMailerThread(MailerThreads[i]).Name + #13#10;
                end;
                MailerThreads.Leave;
             end;
            else
               s := 'Unknown request number: ' + IntToStr(cd.dwData);
            end;
            s := s + #0;
            cd.cbData := Length(s);
            cd.lpData := @s[1];
            if SendMessage(APIHandle, WM_COPYDATA, MainWinHandle, integer(@cd)) <> 0 then Msg.Result := 1 else Msg.Result := 0;
            exit;
         end;
         Line := Msg.WParam shr 16;
         if Line >= DWORD(Cfg.Lines.Count) then begin
            Msg.Result := 0;
            exit;
         end;
         l := Cfg.Lines[Line];
         MlrT := nil;
         MailerThreads.Enter;
         for i := 0 to CollMax(MailerThreads) do begin
            MlrT := MailerThreads[i];
            if DWORD(l.Id) = MlrT.LineId then begin
               break;
            end else begin
               MlrT := nil;
            end;
         end;
         if MlrT <> nil then begin
            case Msg.WParam and $FFFF of
            1:
               begin
                  if MlrT.State in [__FirstMisc..__LastMisc] then begin
                     MlrT.SD.AnswerRequest := True;
                     MlrT.State := msWaitNextRing;
                     SetEvt(MlrT.oEvt);
                     Msg.Result := 1;
                  end else begin
                     Msg.Result := 0;
                  end;
               end;
            2:
               begin
                  Msg.Result := 1;
                  SetEvt(MlrT.oEvt);
                  MlrT.State := msHangUp;
               end;
            4:
               begin
                  Msg.Result := 1;
                  MlrT.InsertEvt(TMlrEvtOperatorTerminate.Create);
               end;
            end;
         end else
         if Msg.WParam and $FFFF = 3 then begin
            MlrT := OpenMailer(l.Id, MainWinHandle);
            if MlrT <> nil then begin
               MailerForms.Enter;
               if MailerForms.Count > 0 then begin
                  TMailerForm(MailerForms[0]).ActiveLine := MlrT;
                  SendMsg(WM_UPDATETABS);
                  SendMsg(WM_TABCHANGE);
                  Msg.Result := 1;
               end else begin
                  Msg.Result := 0;
               end;
               MailerForms.Leave;
            end else begin
               Msg.Result := 0;
            end;
         end;
         MailerThreads.Leave;
         exit;
      end;

      case Msg.Msg of
         WM_UPDOUTMGR,
         WM_UPDATEMENUS,
         WM_UPDATEVIEW,
         WM_UPDATETABS,
         WM_TABCHANGE,
         WM_UPDATELAMPS,
         WM_UPDBWZ:
            repeat
               if not PeekMessage(DummyMsg, MainWinHandle, Msg.Msg, Msg.Msg, PM_REMOVE) then
               begin
                  Break;
               end;
            until False;
      end;

      case Msg.Msg of
         WM_NULL: ;
         WM_COMPILENL:
            if not ExitNow then VCompileNodelist(True);
         WM_IMPORTPWDL:
            if not ExitNow then ImportPwdList;
         WM_IMPORTDUPOVRL:
            if not ExitNow then ImportDupOvrList;
         WM_SWITCHDAEMON: SwitchDaemon(INVALID_HANDLE_VALUE);
         WM_IMPORTIPOVRL:
            if not ExitNow then ImportIpOvrList;
         WM_TIMECHANGE, WM_TIMER:
            if Application.MainForm <> nil then
            begin
               PostMsg(WM_UPDATEVIEW);
               {.$IFDEF THRLOG}
               if ThrTimesLog then UpdThrLog;
               {.$ENDIF}
               ChkFlFlg(false, '');
            end;
         WM_UPDATEMENUS: UpdateMenus;
         WM_UPDATEVIEW: UpdateViewAll;
         WM_UPDATETABS: UpdateTabsAll;
         WM_TABCHANGE: TabChangeAll;
         WM_UPDATELAMPS: UpdateLampsAll;
         WM_UPDATETERM: UpdateTerm(Msg.lParam);
         WM_TRAYICON: if (Application.MainForm as TMailerForm).TrayIcon <> nil then
                         (Application.MainForm as TMailerForm).TrayIcon.SeparateIcon := IniFile.AlwaysInTray;
         WM_ADDPOLLSLOG: AddSpcLogStr(Msg.lParam, PanelOwnerPolls);
         WM_CLEARTERMS: ClearTerms(Msg.lParam);
         WM_CLOSELINE: __CloseLine(Msg.lParam);
         WM_UPDOUTMGR: UpdateOutboundManagers;
         WM_UPDBWZ: UpdateBWListBox;
         WM_RESTORE_EVT:
            begin
               Application.Restore;
               Application.BringToFront
            end;
         WM_SETUPOK:
            if not ExitNow then SetupOK;
         WM_OPENREMOTE:
            begin
              msg.Result := Integer(OpenRemoteForm(Pointer(msg.WParam)));
              exit;
            end;
         WM_CLICKMENU:
            begin
               Save := TMenuItem(msg.LParam).ShortCut;
               TMenuItem(msg.LParam).ShortCut := 7007;
               TMenuItem(msg.LParam).Click;
               TMenuItem(msg.LParam).ShortCut := Save;
            end;
         WM_CLOSECHAT:
            begin
              FreeObject(TChat(msg.WParam));
              sleep(100);
              UpdateViewAll;
            end;
         WM_CONNECT:
            begin
               if ApplicationDowned and Inifile.TrayLamps then begin
                  TMailerForm(Application.MainForm).ActiveLine := Pointer(Msg.LParam);
               end;
            end;
         WM_LASTIN:
            begin
               UpdateLast(Msg.WParam, True);
            end;
         WM_LASTOUT:
            begin
               UpdateLast(Msg.WParam, False);
            end;
         WM_HOTKEY:
            begin
               if Msg.WParam = 700 then begin
                  if ApplicationDowned then begin
                     Application.ShowMainForm := True;
                     Application.MainForm.WindowState := wsNormal;
                     Application.MainForm.Visible := True;
                     Application.Restore;
                     Application.BringToFront;
                     SendMsg(WM_UPDATETABS);
                     SendMsg(WM_TABCHANGE);
                  end else begin
                     Application.Minimize;
                  end;
               end;
            end;
         WM_CHECKNETMAIL:
            begin
               ScanCounter := 1;
            end;
         WM_ROUTEEXPORT:
            begin
               ExportRoute(Msg.WParam);
            end;
         WM_RESOLVE..WM_RESOLVE + WM__NUMRESOLVE - 1: HostResolveComplete(Msg.Msg - WM_RESOLVE, Msg.lParam);
         WM_ADDDAEMONLOG: AddSpcLogStr(Msg.lParam, PanelOwnerDaemon);
         WM_NEWSOCKPORT: NewInIPLine(Msg.lParam);
         WM_CONNECTRES: OutConnRes(Msg.lParam);
         WM_GETWINDLGT:
            begin
               msg.Result := IniFile.WinDlgTWait;
               exit;
            end;
         WM_RASDIALEVENT:
            begin
               UpdateViewAll;
               case msg.WParam of
               RASCS_CONNECTED:
                  begin
                     FidoPollsLog('RAS connected to: ' + RASThread.EntryName);
                     InvalidatePollAddrs;
                     if not DaemonStarted then
                     begin
                        SwitchDaemon(INVALID_HANDLE_VALUE);
                     end;
                     _RecalcPolls(True);
                     PlaySnd('RASConnect', RASSoundsON);
                  end;
               RASCS_DISCONNECTED:
                  begin
                     PlaySnd('RASFinish', RASSoundsON);
                     if RASConnect then begin
                        RASConnect := False;
                        if not RASProcess then begin
                           RASInvoked := True;
                        end else begin
                           RASInvoked := False;
                        end;
                        if not RASDaemonS and DaemonStarted then begin
                           SwitchDaemon(INVALID_HANDLE_VALUE);
                        end;
                        if RASMailLin <> 0 then begin
                           for LinesCnt := 0 to MailerThreads.Count - 1 do begin
                              if TMailerThread(MailerThreads[LinesCnt]).LineId = RASMailLin then exit;
                           end;
                           repeat
                              RASWaitPtr := Integer(OpenMailer(RASMailLin, 0));
                              Application.ProcessMessages;
                              Sleep(100);
                           until RASWaitPtr <> 0;
                           if MailerForms <> nil then begin
                              PostMsg(WM_UPDATETABS);
                              PostMsg(WM_TABCHANGE);
                              PostMsg(WM_UPDATEMENUS);
                           end;
                        end;
                     end;
                  end;
               end;
               if msg.LParam <> 0 then
               begin
                  case msg.LParam of
                  619,
                  628,
                  633: ;
                  else
                     if (RASThread <> nil) and (RASInvoked or DaemonStarted) then RASThread.Connect(True);
                  end;
               end;
            end;
         WM_RASEVENT:
            begin
               RASConnect := True;
               RASWaitPtr := Msg.WParam;
               RASMailLin := Msg.LParam;
            end;
         WM_RASDISCONNECT:
            begin
               if RASThread <> nil then RASThread.Disconnect;
            end;
         WM_LINEDESTROYED:
            begin
               if RASConnect then
               begin
                  RASProcess := True;
                  if RASWaitPtr = Msg.WParam then
                  begin
                     RASWaitPtr := 0;
                     if Daemonstarted then
                     begin
                        RASDaemonS := True;
                     end
                     else
                     begin
                        RASDaemonS := False;
                     end;
                     if RASThread <> nil then RASThread.Connect(False);
                  end;
               end;
            end;
      else
         begin
            Msg.Result := DefWindowProc(MainWinHandle, Msg.Msg, Msg.wParam, Msg.lParam);
            Exit;
         end;
      end;
      Msg.Result := 0;
   except on E: Exception do ProcessTrap(E.Message + '(Message: ' + IntToStr(Msg.Msg) + ')', 'MainVCL');
      {.$142C}
   end;
end;

constructor TMailerForm.Create(AOwner: TComponent);
const
   CTimerTick = 1000;
begin
   inherited Create(AOwner);
   Application.HookMainWindow(Hook);
   SetTimer(Handle, 1, CTimerTick, nil);
end;

destructor TMailerForm.Destroy;
begin
   FreeHotKey;
   Application.UnhookMainWindow(Hook);
   inherited Destroy;
end;

function TMailerForm.Hook(var Message: TMessage): Boolean;
begin
   Result := ((Message.Msg = WM_ENDSESSION)
          and (Message.LParam = integer(ENDSESSION_LOGOFF)));
end;

procedure TMailerForm.OutMgrRefillExpanded;
var
   sitem,
   i: Integer;
   ONode: TOutlineNode;
   n: TOutItem;
   pa: PFidoAddress;
begin
   FreeObject(OutMgrExpanded);

   OutMgrSelectedItemAddr.Zone := -1;

   sitem := OutMgrOutline.SelectedItem;
   for i := 1 to OutMgrOutLine.ItemCount do
   begin
      ONode := OutMgrOutline[i];
      n := ONode.Data;
      if (OutMgrSelectedItemInstead = -1) and (i = sitem) then
      begin
         OutMgrSelectedItemAddr := n.Address;
         OutMgrSelectedItemName := n.Name;
      end;
      if not ONode.Expanded then Continue;
      New(pa);
      pa^ := n.Address;
      if OutMgrExpanded = nil then OutMgrExpanded := TFidoAddrColl.Create;
      OutMgrExpanded.Insert(pa);
   end;
end;

procedure TMailerForm.UpdateOutboundManager;
var
   i: Integer;
   n: TOutNode;
   E: Boolean;
   dsk: byte;

   procedure floutb;
   var
      n: TOutNode;
      OutMgrNodes: TOutNodeColl;
      filec: TOutFileColl;
      _i,
      _j: integer;
      os: int64;
   begin
      EnterCS(OutMgrThread.NodesCS);
      OutMgrThread.ForcedUpdate := true;
      FidoOut.ForcedRescan := True;
      OutMgrThread.FullRescan := true;
      os := 0;
      OutMgrNodes := nil;
      if OutMgrThread.Nodes <> nil then OutMgrNodes := OutMgrThread.Nodes.Copy;
      LeaveCS(OutMgrThread.NodesCS);
      if OutMgrNodes = nil then exit;
      for _i := 0 to CollMax(OutMgrNodes) do begin
         n := OutMgrNodes[_i];
         if n.Files <> nil then n.Files.PurgeDuplicates;
         n.PrepareNfo;
         filec := n.Files;
         if filec <> nil then
         if filec.Count > 0 then
         for _j := 0 to filec.Count - 1 do begin
            os := os + plus.GetFileSize(TOutFile(filec.At(_j)).Name)
         end;
      end;
      //    lOutboundSize.Caption := FloatToStr(Round(os / {1048576}1024)) + ' Kb';
      lOutboundSize.Caption := FloatToStr(Round(FidoOut.OutboundSize / {1048576} 1024)) + ' Kb';
      FreeObject(OutMgrNodes);
   end;

begin
   OutMgrRefillExpanded;
   FreeObject(OutMgrNodes);
   EnterCS(OutMgrThread.NodesCS);
   if OutMgrThread.Nodes <> nil then OutMgrNodes := OutMgrThread.Nodes.Copy;
   LeaveCS(OutMgrThread.NodesCS);
   E := False;
   for i := 0 to CollMax(OutMgrNodes) do begin
      n := OutMgrNodes[i];
      if n.Files <> nil then n.Files.PurgeDuplicates;
      n.PrepareNfo;
      E := E or (osError in n.FStatus);
   end;
   UpdateViewOutMgr;
   SetEnabledO(bReread, wcb_Rescan, True);
   if (Win32Platform = VER_PLATFORM_WIN32_NT) then begin
      aOutbound.Visible := False;
      aOutbound.Active := False;
   end;
   try
      if IniFile.InSecure[2] <> ':' then dsk := 0
                                    else dsk := ord(Upcase(IniFile.InSecure[1])) - $40;
      lAvaibleAtInbound.Caption := FloatToStr(Round(DiskFree(dsk) / 1048576 - IniFile.FreeSpaceLmt)) + ' Mb';
   except on E: Exception do ProcessTrap(E.Message, 'procedure TMailerForm.UpdateOutboundManager: Disk space check');
   end;
   floutb;
end;

procedure TMailerForm.SetTopPageIndex(Idx: Integer);
var
   i: Twcb;
   j: Integer;
begin
   FillBWListBox;
   j := 0;
   for i := wcb_TopPage0 to wcb_TopPage5 do begin
      SetVisible(TopPagePanels[i], i, j = Idx);
      Inc(j);
   end;
end;

procedure TMailerForm.SetBtmPageIndex(Idx: Integer);
var
   i: Twcb;
   j: Integer;
begin
   j := 0;
   for i := wcb_BtmPage0 to wcb_BtmPage5 do begin
      SetVisible(BtmPagePanels[i], i, j = Idx);
      Inc(j);
   end;
end;

procedure TMailerForm.SuperShow;
var
   p: Pointer;
begin
   if MailerThreads.Count > 0 then
      p := MailerThreads[0]
   else
      p := PanelOwnerPolls;
   ActiveLine := p;
   UpdateTabs;
   MainTabControlChange(nil);
   if IniFile.Stealth then begin
      WindowState := wsMinimized;
      Application.ShowMainForm := False;
   end else Show;
   SetHotKey;
end;

procedure TMailerForm.InsertEvt(Evt: Pointer);
var
   a: TMailerThread;
   i: Integer;
begin
   a := ActiveLine;
   for i := 0 to MailerThreads.Count - 1 do begin
      if a = MailerThreads[i] then a.InsertEvt(Evt);
   end;   
end;

procedure TMailerForm.InvalidateLabels;
begin
   lSndSize.Left := llSndSize.Left + llSndSize.Width + 6;
   lRcvSize.Left := llRcvSize.Left + llRcvSize.Width + 6;

   lFileSndTime.Left := llFileSndTime.Left + llFileSndTime.Width + 6;
//   llTotalSndTime.Left := lFileSndTime.Left + lFileSndTime.Width + 6;
   lTotalSndTime.Left := llTotalSndTime.Left + llTotalSndTime.Width + 6;

   lFileRcvTime.Left := llFileRcvTime.Left + llFileRcvTime.Width + 6;
//   llTotalRcvTime.Left := lFileRcvTime.Left + lFileRcvTime.Width + 6;
   lTotalRcvTime.Left := llTotalRcvTime.Left + llTotalRcvTime.Width + 6;

   lSessionTime.Left := llSessionTime.Left + llSessionTime.Width + 6;
//   llSessionCost.Left := lSessionTime.Left + lSessionTime.Width + 6;
   lSessionCost.Left := llSessionCost.Left + llSessionCost.Width + 6;
end;

procedure BackupConfig(Handle: DWORD);
var
   D: TSaveDialog;
   B: Boolean;
   Dst,
   Src: string;
begin
   D := TSaveDialog.Create(Application);
   D.Title := LngStr(rsMMBackUpCfgC);
   D.Filter := LngStr(rsMMBackUpCfgF);
   D.Options := [ofHideReadOnly, ofNoReadOnlyReturn, ofOverwritePrompt];
   B := D.Execute;
   Dst := D.FileName;
   FreeObject(D);
   if not B then Exit;
   Src := ConfigFName;
   if not Windows.CopyFile(PChar(Src), PChar(Dst), False) then DisplayError(FormatErrorMsg(Format('%s -> %s', [Src, Dst]), GetLastError), Handle);
end;

procedure OpenMailerForm;
var
   MailerForm: TMailerForm;
begin
   Application.CreateForm(TMailerForm, MailerForm);
   MailerForm.ActiveLine := AThread;
   MailerForm.UpdateTabs;
   MailerForm.MainTabControlChange(nil);
   MailerForms.Insert(MailerForm);
   if DoShow then begin
      MailerForm.MainTabControlChange(nil);
      MailerForm.Show;
   end;
   if Cfg.UpgStrings <> nil then begin
      if WinDlgCap(FormatLng(rsMMNewCfgItems, [ProductNameFull, ProductVersion, Cfg.UpgStrings.LongString]), MB_YESNO or MB_ICONQUESTION, MailerForm.Handle, LngStr(rsMMCfgUpd)) = idYes then BackupConfig(MailerForm.Handle);
      FreeObject(Cfg.UpgStrings);
      StoreConfig(MailerForm.Handle);
   end;
   SetWindowText(MainWinHandle, PChar('Radius_API_Receiver'));
   SetPriorityClass(GetCurrentProcess, IniFile.Priority);
end;

function OpenRemoteForm;
var
   RemoteForm: TRemoteForm;
begin
   Application.CreateForm(TRemoteForm, RemoteForm);
   Result := RemoteForm;
   RemoteForm.prot := P;
   RemoteForm.Show;
end;

procedure InitMsgDispatcher;
begin
   MsgDispatcher := TMsgDispatcher.Create;
   {.$IFDEF THRLOG}
   Application.OnMessage := MsgDispatcher.AppMessage;
   {.$ENDIF}
end;

////////////////////////////////////////////////////////////////////////
//                                                                    //
//                             Mailer Form                            //
//                                                                    //
////////////////////////////////////////////////////////////////////////

procedure TMailerForm.UpdateTabs;
var
   i,
  ti,
  ic,
   c: Integer;
   m: TMailerThread;

   procedure DoAdd(const s: string);
   begin
      if c < ic then
         MainTabControl.Tabs[c] := s
      else
         MainTabControl.Tabs.Add(s);
      Inc(c);
   end;

begin
   ti := -1;
   c := 0;
   ic := MainTabControl.Tabs.Count;
   for i := 0 to CollMax(MailerThreads) do begin
      m := MailerThreads.At(i);
      if not m.DialupLine then Continue;
      if ActiveLine = m then ti := c;
      DoAdd(m.Name);
   end;
   if ti = -1 then ti := c;
   if ActiveLine = PanelOwnerPolls then ti := c;
   DoAdd(LngStr(rsMMTabPolls));
   if ActiveLine = PanelOwnerOutMgr then ti := c;
   DoAdd(LngStr(rsMMTabOutbound));
   if ActiveLine = PanelOwnerSystem then ti := c;
   DoAdd(LngStr(rsMMTabSystem));
   if DaemonStarted then begin
      if ActiveLine = PanelOwnerDaemon then ti := c;
      DoAdd(LngStr(rsMMTabDaemon));
      for i := 0 to MailerThreads.Count - 1 do begin
         m := MailerThreads.At(i);
         if m.DialupLine then Continue;
         if ActiveLine = m then ti := c;
         DoAdd(m.Name);
      end;
   end;
   while ic > c do begin
      Dec(ic);
      MainTabControl.Tabs.Delete(ic)
   end;
   MainTabControl.TabIndex := ti;
end;

procedure TMailerForm.SetBar(B: TProgressBar; C, M: Integer; CI, MI: Twci);
begin
   if wci[MI] <> M then begin
      wci[MI] := M;
      B.Max := M;
   end;
   if wci[CI] <> C then begin
      wci[CI] := C;
      B.Position := C;
   end;
end;

procedure TMailerForm.SetGauge(G: TxGauge; C, M: Integer; CI, MI: Twci);
begin
   if wci[MI] <> M then begin
      wci[MI] := M;
      G.MaxValue := M;
   end;
   if wci[CI] <> C then begin
      wci[CI] := C;
      G.Progress := C;
   end;
end;

procedure TMailerForm.SetLabel(L: TObject; c: TWcs; const s: string);
var
   Lbl: TLabel absolute L;
   Mnu: TMenuItem absolute L;
begin
   if wcs[c] = s then Exit;
   wcs[c] := s;
   if L is TLabel then begin
      Lbl.Caption := s;
      if Lbl.ShowHint then Lbl.Hint := s;
   end else
   if L is TMenuItem then
      Mnu.Caption := s
   else
      GlobalFail('TMailerForm.SetLabel(%s,...,"%s")', [L.ClassName, s]);
end;

procedure TMailerForm.SetEnabledO(L: TObject; c: TWcb; V: Boolean);
begin
   if V = (c in wcb) then Exit;
   if V then
      Include(wcb, c)
   else
      Exclude(wcb, c);
   if L is TControl then
      with L as TControl do
         Enabled := V
   else
   if L is TMenuItem then
      with L as TMenuItem do
         Enabled := V
   else
      GlobalFail('TMailerForm.SetEnabled for %s', [L.ClassName]);
end;

procedure TMailerForm.SetVisible(L: TControl; c: TWcb; V: Boolean);
begin
   if V = (c in wcb) then Exit;
   if V then
      Include(wcb, c)
   else
      Exclude(wcb, c);
   L.Visible := V;
end;

procedure TMailerForm.UpdateProt;
const
   bsMsg: array[TBatchState] of Integer = (rsMMbsInit, rsMMbsDummy, rsMMbsEnd, rsMMbsIdle, rsMMbsWait);

var
   a,
   b: Integer;
 ela: DWORD;
  bs: TBatchState;

   procedure SetSndSize(B: Boolean);
   begin
      SetVisible(lSndSize, wcb_lSndSize, B);
      SetVisible(llSndSize, wcb_llSndSize, B);
      SetVisible(SndBar, wcbSndBar, B);
   end;

   procedure SetRcvSize(B: Boolean);
   begin
      SetVisible(lRcvSize, wcb_lRcvSize, B);
      SetVisible(llRcvSize, wcb_llRcvSize, B);
      SetVisible(RcvBar, wcbRcvBar, B);
      Btns := B;
   end;

   procedure SetSndCPS(B: Boolean);
   begin
      SetVisible(lSndCPS, wcb_lSndCPS, B);
      SetVisible(llSndCPS, wcb_llSndCPS, B);
   end;

   procedure SetRcvCPS(B: Boolean);
   begin
      SetVisible(lRcvCPS, wcb_lRcvCPS, B);
      SetVisible(llRcvCPS, wcb_llRcvCPS, B);
   end;

   procedure DoFill(const List: TStringColl); overload;
   var
      i: Integer;
      s: string;
      n: string;
      c: Twcs;
   begin
      List.Enter;
      gLst.Top    := gNfo.Top;
      gLst.Left   := gTitles.Left;
      gLst.Width  := gNfo.Left + gNfo.Width;
      gLst.Height := gNfo.Height;
      case gTabCnt.Tabs.Count of
      0: begin
           gTabCnt.Tabs.Add('Info');
           gTabCnt.Tabs.Add('Files');
         end;
      1:
         begin
           gTabCnt.Tabs.Add('Files');
         end;
      end;
      if List.Count > 0 then begin
         gLst.RowCount := List.Count + 1;
      end else begin
         gLst.Cells[1, 1] := '';
         gLst.Cells[2, 1] := '';
      end;
      for i := 0 to CollMax(List) do begin
         c := TWcs(i + 1 + Integer(wcsGrd1));
         s := List[i];
         if c <= wcslSessionCost then begin
            if wcs[c] = s then Continue;
            wcs[c] := s;
         end;
         n := ExtractWord(1, s, [' ']);
         StrDeQuote(n);
         gLst[1, i + 1] := n;
         gLst[2, i + 1] := ExtractWord(2, s, [' ']);
      end;
      List.Leave;
   end;

   procedure DoFill(const Strs: array of string); overload;
   var
      i: Integer;
      w: integer;
      t: integer;
      s: string;
      c: Twcs;
   begin
      w := gNfo.Width;
      for i := 0 to 7 do begin
         t := gNfo.Canvas.TextWidth(gNfo.Cells[0, i]) + 10;
         if t > w then begin
            w := t;
         end;
      end;
      if gNfo.ColWidths[0] <> w then begin
         gNfo.ColWidths[0] := w;
      end;
      for i := Low(Strs) to High(Strs) do begin
         c := TWcs(i + Integer(wcsGrd1));
         s := Strs[i];
         if wcs[c] = s then Continue;
         wcs[c] := s;
         gNfo[0, i] := s;
      end;
   end;

   procedure SetSndTot(const B: Boolean);
   begin
      SetVisible(SndTot, wcb_SndTot, B);
   end;

   // visual {

   procedure SetSndTime(B: Boolean);
   begin
      SetVisible(lFileSndTime, wcb_lFileSndTime, B);
      SetVisible(llFileSndTime, wcb_llFileSndTime, B);
   end;

   procedure SetSndTotalTime(B: Boolean);
   begin
      SetVisible(lTotalSndTime, wcb_lTotalSndTime, B);
      SetVisible(llTotalSndTime, wcb_llTotalSndTime, B);
   end;

   procedure SetRcvTime(B: Boolean);
   begin
      SetVisible(lFileRcvTime, wcb_lFileRcvTime, B);
      SetVisible(llFileRcvTime, wcb_llFileRcvTime, B);
   end;

   procedure SetRcvTotalTime(B: Boolean);
   begin
      SetVisible(lTotalRcvTime, wcb_lTotalRcvTime, B);
      SetVisible(llTotalRcvTime, wcb_llTotalRcvTime, B);
   end;

   procedure SetSessionTime(B: Boolean);
   begin
      SetVisible(lSessionTime, wcb_lSessionTime, B);
      SetVisible(llSessionTime, wcb_llSessionTime, B);
   end;

   procedure SetSessionCost(B: Boolean);
   begin
      SetVisible(lSessionCost, wcb_lSessionCost, B);
      SetVisible(llSessionCost, wcb_llSessionCost, B);
   end;

   procedure CalcSessionCost;
   var
      OperTimeItem: OperTimeRec;
      ZoneTimeDiff: DWORD;

   begin
      if (IniFile.DontLogTariff) or (not (ActiveLine is TMailerThread)) then exit;

      with OperTimeItem do begin
         if ActiveLine.DialupLine then
            ConnType := ctDial
         else
            ConnType := ctIP;

         if not ActiveLine.DialupLine then
         if ActiveLine.SD <> nil then begin
            if ActiveLine.SD.ActivePoll = nil then begin
               Direction := dirIn;
               PhoneNumber := ActiveLine.PublicDS.ConnectString;
               PhoneNumber := copy(PhoneNumber, 6, pos('#', PhoneNumber) - 7);
            end else begin
               Direction := dirOUT;
               PhoneNumber := ActiveLine.PublicDS.ConnectString;
               PhoneNumber := copy(PhoneNumber, 4, pos('#', PhoneNumber) - 5);
            end
         end else
         if not (ActiveLine is TMailerThread) then exit;
         if ActiveLine.SD = nil then exit;
         if ActiveLine.SD.ActivePoll = nil then begin
            Direction := dirIn;
            PhoneNumber := ActiveLine.PublicDS.rmtPhone;
         end else begin
            Direction := dirOUT;
            PhoneNumber := ActiveLine.SD.ActivePoll.DialupPhone
         end;

         ZoneTimeDiff := uGetLocalTime - uGetSystemTime;
         Period.StartTime := uDelphiTime(ActiveLine.SD.ConnectStart + ZoneTimeDiff);
         Period.StopTime := uDelphiTime(uGetSystemTime + ZoneTimeDiff);

         if T <> nil then
            Sent := (D.txBytes + T.D.FPos) / 1048576
         else
            Sent := 0;

         if R <> nil then
            Received := (D.rxBytes + R.D.FPos - R.D.FOfs + R.D.Part) / 1048576
         else
            Received := 0;
      end;

      Cost := CalcCost(TarifPlan, OperTimeItem);
      SetLabel(lSessionCost, wcslSessionCost, Format('%5.2f', [Cost]));
      SetSessionCost(True)
   end;

   procedure SetRcvTot(const B: Boolean);
   begin
      SetVisible(RcvTot, wcb_RcvTot, B);
   end;

   procedure SetSndBar(C, M: Integer);
   begin
      SetBar(SndBar, C, M, wciSndFilCur, wciSndFilMax);
   end;

   procedure SetRcvBar(C, M: Integer);
   begin
      SetBar(RcvBar, C, M, wciRcvFilCur, wciRcvFilMax);
   end;

   procedure SetSndGauge(C, M: Integer);
   begin
      SetGauge(SndTot, C, M, wciSndTotCur, wciSndTotMax);
   end;

   procedure SetRcvGauge(C, M: Integer);
   begin
      SetGauge(RcvTot, C, M, wciRcvTotCur, wciRcvTotMax);
   end;

var
   s: string;
   fpos,
   rxAdd,
   txAdd: DWORD;
   i: Integer;
   Seconds: extended; // visual
   RxCPS,
   TxCPS: integer; // visual

begin

   if (ActiveLine = PanelOwnerPolls) or
      (ActiveLine = PanelOwnerOutMgr) or
      (ActiveLine = PanelOwnerDaemon) or
      (ActiveLine = PanelOwnerSystem) or
      (MailerThreads.IndexOf(ActiveLine) = -1) then Exit;

   if ApplicationDowned then exit;
   if ActiveLine.SD = nil then exit;

   if (ActiveLine.SD.Prot <> nil) and
      (CollCount(ActiveLine.SD.Prot.RemFiles) > 1) then begin
      if gLst.Tag = 0 then begin
         gLst.ColWidths[1] := gLst.Width - 4 - gLst.ColWidths[0] - gLst.ColWidths[2] - GetsystemMetrics(SM_CXVSCROLL);
      end;

      DoFill(ActiveLine.SD.prot.RemFiles);

      if gTabCnt.Tag <> 7 then begin
         gTabCnt.Tag := 7;
         gNfo.DefaultRowHeight := (gNfo.Height - GetSystemMetrics(SM_CYHSCROLL) - 9) div 8;
         gTitles.DefaultRowHeight := gNfo.DefaultRowHeight;
      end;
      gLst.RenumberRows;
   end else begin
      if gTabCnt.TabIndex = 1 then begin
         gTabCnt.TabIndex := 0;
         gTabCntChange(gTabCnt);
      end;
      if gTabCnt.Tabs.Count > 0 then begin
         gTabCnt.Tabs.Clear;
      end;
      if gTabCnt.Tag <> 9 then begin
         gTabCnt.Tag := 9;
         gNfo.DefaultRowHeight := (gNfo.Height - GetSystemMetrics(SM_CYHSCROLL) - 9) div 8;
         gTitles.DefaultRowHeight := gNfo.DefaultRowHeight;
         gNfo.IgnoreAdjust := True;
         gTitles.IgnoreAdjust := True;
      end;
   end;

   with DS do
      DoFill([ConnectString, rmtStationName, rmtAddressList, rmtSysopName, rmtLocation, rmtPhone, rmtFlags, rmtSoft, ActiveLine.SD.rmtTime]); //visual

   lSessionTime.Caption := FormatDateTime('hh:mm:ss', EncodeTime(((activeline.timeonline div 1000) div 60) div 60, ((activeline.timeonline div 1000) div 60) mod 60, (activeline.timeonline div 1000) mod 60, activeline.timeonline mod 1000));
   SetSessionTime(True);

   txAdd := 0;
   rxAdd := 0;
   RxCPS := 0; // visual
   TxCPS := 0; // visual

   if T = nil then begin
      SetSndSize(False);
      SetSndCPS(False);
      SetSndTime(False); // visual
      bs := bsIdle;
   end else begin
      if T.D.Start = 0 then begin
         SetSndSize(False);
         SetSndBar(0, 0);
         SetSndCPS(False);
         SetSndTime(False); // visual
         case T.D.State of
            bsInit, bsEnd: bs := T.D.State;
         else
            bs := bsWait;
         end;
      end else begin
         fpos := T.D.FPos;
         if AOutUsed < fpos then Dec(fpos, AOutUsed);
         ela := uGetSystemTime - T.D.Start;
         bs := bsActive;
         a := T.D.FSize;
         b := fpos;
         LowerPrec(a, b, 7);

         SetSndBar(b, a);

         txAdd := fpos;

         if fpos < T.D.FOfs then
            a := 0
         else
            a := fpos - T.D.FOfs;
         SetLabel(lSndSize, wcsSndSize, Format('%s / %s', [Int2Str(MinD(fpos, T.D.FSize)), Int2Str(T.D.FSize)]));
         SetSndSize(True);
         if (ela < IniFile.CPS_MinSecs) or (dword(a) < IniFile.CPS_MinBytes) then begin
            SetSndCPS(False);
            SetSndTime(False);
         end else begin
            if ela > 0 then begin
               i := DWORD(a) div ela;
            end else begin
               i := 0;
            end;
            SetLabel(lSndCPS, wcsSndCPS, Int2Str(i));
            SetSndCPS(True);
            TxCPS := i;
            if TxCPS > 0 then begin
               a := T.D.FSize;
               b := fpos;
               Seconds := (DWORD(a) - MinD(DWORD(a), DWORD(b))) div DWORD(TxCPS);
               SetLabel(lFileSndTime, wcslFileSndTime, FormatDateTime('hh:mm:ss', Seconds / 86400));
               SetSndTime(True);
            end;
         end;
      end;
   end;
   if bs = bsActive then
      s := T.D.FName
   else
      s := LngStr(bsMsg[bs]);

   SetLabel(lSndFile, wcsSndFile, s);

   if R = nil then begin
      SetRcvSize(False);
      SetRcvCPS(False);
      bs := bsIdle;
   end else begin
      if R.D.Start = 0 then begin
         SetRcvSize(False);
         SetRcvBar(0, 0);

         SetRcvCPS(False);
         case R.D.State of
            bsInit, bsEnd: bs := R.D.State;
         else
            bs := bsWait;
         end;
      end else begin
         ela := uGetSystemTime - R.D.Start;
         bs := bsActive;

         a := R.D.FSize;
         b := R.D.FPos + R.D.Part;
         LowerPrec(a, b, 7);

         SetRcvBar(b, a);

         rxAdd := R.D.FPos + R.D.Part;

         a := R.D.FPos + R.D.Part - R.D.FOfs;

         SetLabel(lRcvSize, wcsRcvSize, Format('%s / %s', [Int2Str(MinD(R.D.FPos + R.D.Part, R.D.FSize)), Int2Str(R.D.FSize)]));
         SetRcvSize(True);
         if (ela < IniFile.CPS_MinSecs) or (dword(a) < IniFile.CPS_MinBytes) then begin
            SetRcvCPS(False);
            SetRcvTime(false);
         end else
         if R.D.Start = 0 then begin
            SetRcvSize(False);
            SetRcvBar(0, 0);
            SetRcvCPS(False);
            SetRcvTime(False); // visual
            case R.D.State of
               bsInit, bsEnd: bs := R.D.State;
            else
               bs := bsWait;
            end; {case}
         end else begin
            ela := uGetSystemTime - R.D.Start;
            bs := bsActive;
            a := R.D.FSize;
            b := R.D.FPos + R.D.Part;
            LowerPrec(a, b, 7);
            SetRcvBar(b, a);
            rxAdd := R.D.FPos + R.D.Part;
            a := R.D.FPos + R.D.Part - R.D.FOfs;
            SetLabel(lRcvSize, wcsRcvSize, Format('%s / %s', [Int2Str(MinD(R.D.FPos + R.D.Part, R.D.FSize)), Int2Str(R.D.FSize)]));
            SetRcvSize(True);
            if (ela < IniFile.CPS_MinSecs) or (DWORD(a) < IniFile.CPS_MinBytes) then begin
               SetRcvCPS(False);
               SetRcvTime(False); // visual
            end else begin
               if ela > 0 then begin
                  i := DWORD(a) div ela;
               end else begin
                  i := 0;
               end;
               SetLabel(lRcvCPS, wcsRcvCPS, Int2Str(i));
               SetRcvCPS(True);
               RxCPS := i;
               if RxCPS > 0 then begin
                  a := R.D.FSize;
                  b := R.D.FPos + R.D.Part;
                  Seconds := (DWORD(a) - MinD(b, DWORD(a))) div DWORD(RxCPS);
                  SetLabel(lFileRcvTime, wcslFileRcvTime, FormatDateTime('hh:mm:ss', Seconds / 86400));
                  SetRcvTime(True);
               end;
            end;
         end;
      end;
   end;

   if bs = bsActive then
      s := R.D.FName
   else
      s := LngStr(bsMsg[bs]);

   SetLabel(lRcvFile, wcsRcvFile, s);

   a := D.TxTot;
   b := D.txBytes + txAdd;
   if (a = b) then SetSndTime(False);
   if (a = 0) or (a < b) then begin
      SetSndTotalTime(False); // visual
      SetSndTot(False)
   end else begin
      SetSndTot(True);
      SetSndGauge(b, a);
      if (TxCPS > 0) then begin
         SetSndTotalTime(True);
         Seconds := (DWORD(a) - MinD(DWORD(a), b)) div DWORD(TxCPS);
         SetLabel(lTotalSndTime, wcslTotalSndTime, FormatDateTime('hh:mm:ss', Seconds / 86400));
      end;
   end;
   a := D.rmtForUs;
   b := D.rxBytes + rxAdd;
   if (a = b) then SetRcvTime(False);
   if (a = 0) or (a < b) then begin
      SetRcvTotalTime(False); // visual
      SetRcvTot(False);
   end else begin
      SetRcvTot(True);
      SetRcvGauge(b, a);
      if (RxCPS > 0) then begin
         SetRcvTotalTime(True);
         Seconds := (DWORD(a) - MinD(DWORD(a), b)) div DWORD(RxCPS);
         SetLabel(lTotalRcvTime, wcslTotalRcvTime, FormatDateTime('hh:mm:ss', Seconds / 86400));
      end;
   end;
   CalcSessionCost;
   SetTopPageIndex(1);
end;

procedure TMailerForm.UpdateRas(const D: string; const DS: string);
begin
   lTimeCon.Caption := d;
   lStatus2.Caption := ds;
end;

procedure TMailerForm.UpdateDial(const D: TDisplayData; const DS: TDisplayStringData);
var
   e: DWORD;
   s: string;
begin
   e := RemainingTimeSecs(D.TmrPublic);
   if e = High(e) then
      SetVisible(TimeoutBox, wcbTimeoutBox, False)
   else begin
      SetLabel(lTimeout, wcsTimeout, IntToStr(e));
      SetVisible(TimeoutBox, wcbTimeoutBox, True)
   end;
   if DS.StatusParam = '' then
      s := LngStr(D.StatusMsg)
   else
   if pos(';', DS.StatusParam) = 0 then
      s := FormatLng(D.StatusMsg, [DS.StatusParam])
   else
      s := FormatLng(D.StatusMsg, [wizard.ExtractWord(1, DS.StatusParam, [';']), wizard.ExtractWord(2, DS.StatusParam, [';'])]);
   SetLabel(lStatus, wcsStatus, s);
   SetTopPageIndex(0);
end;

procedure TMailerForm.UpdateLog;
var
   I: Integer;
   S,
   Z: string;
  TL: Boolean;
begin
   EnterCS(ActiveLine.LogCS);
   S := StrAsg(ActiveLine.NewLogStr);
   ActiveLine.NewLogStr := '';
   TL := ActiveLine.TruncateLog;
   ActiveLine.TruncateLog := False;
   LeaveCS(ActiveLine.LogCS);
   if TL then ActiveLine.LogStrings.FreeAll;
   if S = '' then Exit;
   while S <> '' do begin
      i := Pos(#13#10, S);
      Z := Copy(S, 1, i - 1);
      Delete(S, 1, i + 1);
      ActiveLine.LogStrings.Add(Z);
   end;
   while ActiveLine.LogStrings.Count > MaxLogStrings do begin
      ActiveLine.LogStrings.AtFree(0);
   end;
   InvalidateLogBox(ActiveLine);
end;

var
   xy: array[0..5] of record x, y, n: integer; b: boolean end =
      ((x: 0; y: 0; n: 0; b: False), (x: 5; y: 0; n: 1; b: False), (x: 10; y: 0; n: 1; b: False),
       (x: 0; y: 7; n: 1; b: False), (x: 5; y: 7; n: 0; b: False), (x: 10; y: 7; n: 0; b: False));

procedure TMailerForm.UpdateLamps;
var
   j: Integer;
  OK: Boolean;
  bm: TBitMap;
  im: TBitMap;
  TR: TRect;
  II: TIconInfo;
begin
   if (ActiveLine = PanelOwnerPolls) or
      (ActiveLine = PanelOwnerOutMgr) or
      (ActiveLine = PanelOwnerDaemon) or
      (ActiveLine = PanelOwnerSystem) or
      (MailerThreads.IndexOf(ActiveLine) = -1) then
   begin
      if (Application.MainForm <> nil) and ((Application.MainForm as TMailerForm).TrayIcon <> nil) then begin
         (Application.MainForm as TMailerForm).TrayIcon.Icon := Application.Icon;
      end;
      if Inifile.TrayLamps and ApplicationDowned then begin
         OK := True;
         for j := 0 to CollMax(MailerThreads) do begin
            OK := False;
            ActiveLine := MailerThreads[j];
            break;
         end;
         if OK then exit;
      end else begin
         Exit;
      end;
   end;
   EnterCS(ActiveLine.CP_CS);
   OK := ActiveLine.CP <> nil;
   if OK then
      j := ActiveLine.CP.LineStatus
   else
      j := 0;
   LeaveCS(ActiveLine.CP_CS);
   if not OK then Exit;
   mlDCD.Lit := j and MS_RLSD_ON <> 0;
   mlDSR.Lit := j and MS_DSR_ON  <> 0;
   mlCTS.Lit := j and MS_CTS_ON  <> 0;
   mlTXD.Lit := j and MS_TXD_ON  <> 0;
   mlRXD.Lit := j and MS_RXD_ON  <> 0;
   if Inifile = nil then exit;
   if ilTray = nil then exit;
   if Inifile.TrayLamps and (ApplicationDowned or Inifile.AlwaysInTray) and (TTim + 50 < GetTickCount) then begin
      xy[0].b := j and MS_RLSD_ON <> 0;
      xy[1].b := j and MS_TXD_ON  <> 0;
      xy[2].b := j and MS_RXD_ON  <> 0;
      xy[3].b := j and MS_RING_ON <> 0;
      xy[4].b := j and MS_DSR_ON  <> 0;
      xy[5].b := j and MS_CTS_ON  <> 0;

      bm := TBitMap.Create;
      bm.Width  := 16;
      bm.Height := 16;
      bm.PixelFormat := pf4bit;

      im := TBitMap.Create;
      im.Width  := 16;
      im.Height := 16;
      im.PixelFormat := pf1bit;
      im.Canvas.Brush.Color := clBlack;
      TR := im.Canvas.ClipRect;
      Dec(TR.Bottom);
      im.Canvas.FillRect(TR);

      for j := 0 to 5 do begin
         ilTray.Draw(bm.Canvas, xy[j].x, xy[j].y, integer(xy[j].b) * xy[j].n + 2 * (1 - integer(xy[j].b)), true);
      end;

      II.fIcon := True;
      II.xHotspot := 8;
      II.yHotspot := 8;
      II.hbmMask  := im.Handle;
      II.hbmColor := bm.Handle;
      j := IC.Handle;
      if IC.HandleAllocated then IC.ReleaseHandle;
      IC.Handle := CreateIconIndirect(II);
      bm.Free;
      im.Free;
      if (Application.MainForm <> nil) and ((Application.MainForm as TMailerForm).TrayIcon <> nil) then begin
         (Application.MainForm as TMailerForm).TrayIcon.Icon := ic;
      end;
      if j <> 0 then begin
         DestroyIcon(j);
      end;
      LUpd := False;
   end else begin
      if (TTim + 50 > GetTickCount) then LUpd := True;
   end;
   TTim := GetTickCount;
end;

procedure TMailerForm.UpdateLast;
var
   t: string;
begin
   t := lInfo1.Caption;
   if u then begin
      t := Trim(ExtractWord(2, t, [#13]));
      t := 'Last  in: ' + S + #13 + t + ' ';
   end else begin
      t := Trim(ExtractWord(1, t, [#13]));
      t := t + #13#10 + 'Last out: ' + S + ' ';
   end;
   lInfo1.Caption := t;
   lInfo2.Caption := t;
   lInfo2.Left := lInfo1.Left;
end;

function SortPollsByDate(Item1, Item2: Pointer): Integer;
var
   P1: TFidoPoll absolute Item1;
   P2: TFidoPoll absolute Item2;
begin
   if P1.Birth = P2.Birth then
      Result := 0
   else
   if P1.Birth < P2.Birth then
      Result :=  1
   else
      Result := -1;
end;

var
   OutMgrNodeCC: Integer;

function DoOutMgrNodeSort(Item1, Item2: Pointer): Integer;
var
   C: Integer;
   N1: TOutItem absolute Item1;
   N2: TOutItem absolute Item2;
   N1F: TOutFile absolute Item1;
   N2F: TOutFile absolute Item2;
   Node1: TFidoNode;
   s2: string;
   Node2: TFidoNode;
   s1: string;

   procedure Cmp0;
   begin
      if N1 is TOutNode then
         C := CompareAddrs(N1.Address, N2.Address)
      else
         C := CompareText(N1.Name, N2.Name);
   end;

begin
   case Abs(OutMgrNodeCC) - 1 of
   0: Cmp0;
   1:
      begin
         Node1 := GetListedNode(N1.Address);
         Node2 := GetListedNode(N2.Address);
         if Node1 = nil then
            s1 := '-Unknown sysop-'
         else
            s1 := Node1.Sysop;
         if Node2 = nil then
            s2 := '-Unknown sysop-'
         else
            s2 := Node2.Sysop;
         C := CompareText(s1, s2);
         if c = 0 then Cmp0;
      end;
   2:
      begin
         if N1.Nfo.Size = N2.Nfo.Size then
            Cmp0
         else
         if N1.Nfo.Size < N2.Nfo.Size then
            C := 1
         else
            C := -1;
      end;
   3:
      if N1 is TOutFile then begin
         C := Integer(N1F.Status) - Integer(N2F.Status);
         if C = 0 then Cmp0;
      end else begin
         if N1.Nfo.Attr = N2.Nfo.Attr then
            Cmp0
         else
         if N1.Nfo.Attr < N2.Nfo.Attr then
            C := 1
         else
            C := -1;
      end;
   4:
      if N1 is TOutFile then begin
         C := Integer(N1F.KillAction) - Integer(N2F.KillAction);
         if C = 0 then Cmp0;
      end else
         Cmp0;
   5:
      begin
         if N1.Nfo.Time = N2.Nfo.Time then
            Cmp0
         else
         if N1.Nfo.Time < N2.Nfo.Time then
            C := 1
         else
            C := -1;
      end;
   else
      GlobalFail('DoOutMgrNodeSort ... %d', [Abs(OutMgrNodeCC) - 1]);
   end;
   if OutMgrNodeCC < 0 then C := -C;
   Result := C;
end;

procedure TMailerForm.UpdateViewOutMgr;
var
   i,
   j,
   k,
   cc,
   ccc,
   sitem,
   sp: Integer;
   n: TOutNode;
   f: TOutFile;
   nn: TOutlineNode;
begin
   cc := CollMax(OutMgrNodes);
   OutMgrNodeCC := OutMgrNodeSort;
   if cc >= 0 then OutMgrNodes.Sort(DoOutMgrNodeSort);
   for I := 0 to cc do begin
      n := OutMgrNodes[I];
      if n.Files <> nil then n.Files.Sort(DoOutMgrNodeSort);
   end;
   sp := GetScrollPos(OutMgrOutline.Handle, SB_VERT);
   OutMgrOutline.BeginUpdate;
   OutMgrOutline.Clear;
   for i := 0 to cc do begin
      n := OutMgrNodes[i];
      j := OutMgrOutline.AddObject(0, Addr2Str(n.Address), n);
      if i = 0 then
         FirstOutMgrNode := n
      else
         if i = cc then LastOutMgrNode := n;
      ccc := CollMax(n.Files);
      for k := 0 to ccc do begin
         f := n.Files[k];
         with f.Nfo do begin
            Attr := 0;
            if i = cc then Attr := Attr or olfLastLevel;
            if k = ccc then Attr := Attr or olfLastItem;
         end;
         OutMgrOutline.AddChildObject(j, f.Name, f);
      end;
   end;
   if OutMgrSelectedItemInstead = -1 then
      sitem := -1
   else begin
      sitem := MinI(OutMgrSelectedItemInstead, OutMgrOutline.ItemCount);
      OutMgrSelectedItemInstead := -1;
   end;
   for i := 1 to OutMgrOutline.ItemCount do begin
      nn := OutMgrOutline[i];
      n := nn.Data;
      if (sitem = -1) and
         (CompareAddrs(OutMgrSelectedItemAddr, n.Address) = 0) and
         (n.Name = OutMgrSelectedItemName) then
      begin
         sitem := i;
         if OutMgrExpanded = nil then Continue;
      end;
      if not nn.HasItems then Continue;
      if (OutMgrExpanded <> nil) and (OutMgrExpanded.Search(@n.Address, cc)) then nn.Expanded := True;
   end;
   if sitem > 0 then OutMgrOutline.SelectedItem := sitem;
   SendMessage(OutMgrOutline.Handle, WM_VSCROLL, SB_THUMBPOSITION or sp shl 16, 0);
   OutMgrOutline.EndUpdate;
end;

procedure TMailerForm.UpdateView(fromcc: boolean);

   procedure UpdateMlr;
   var
      D: TDisplayData;
     DS: TDisplayStringData;
      T,
      R: TBatch;
      CPOutUsed: Integer;
      B: Boolean;
      i: word;
      j,
      k: Integer;
      c: TColl;
      u: TSystemTime;
      s: TSystemTime;
      l: TSystemTime;
      y: TSystemTime;
      a: TDateTime;
     ol: TOlEventContainer;
      e: TListItem;
     zi: TTimeZoneInformation;
     st: string;

   type
      TDSet = 0..60;
      TWSet = set of TDSet;

   function NextMatch(const w: word; s: TWSet): word;
   var
      r: word;
   begin
      Result := 0;
      r := w;
      while not (r in s) and (r < 60) do Inc(r);
      if r in s then begin
         Result := r;
         exit;
      end;
      if Result = 0 then begin
         Result := NextMatch(0, s);
      end;
   end;

   function PrevMatch(const w: word; s: TWSet): word;
   var
      r: word;
   begin
      Result := 0;
      r := w;
      while not (r in s) and (r > 0) do Dec(r);
      if r in s then begin
         Result := r;
         exit;
      end;
      if Result = 0 then begin
         Result := PrevMatch(60, s);
      end;
   end;

   begin
      Move(DU_OutGrM, MHistO.Data, SizeOf(MHistO.Data));
      Move(DU_InGrM, MHistI.Data, SizeOf(MHistI.Data));
      MHistO.Invalidate;
      MHistI.Invalidate;
      UpdateLog;
      EnterCS(ActiveLine.DisplayDataCS);
      D := ActiveLine.PublicD;
      DS := ActiveLine.PublicDS;
      if ActiveLine.PubBatchT <> nil then
         T := ActiveLine.PubBatchT.Copy
      else
         T := nil;
      if ActiveLine.PubBatchR <> nil then
         R := ActiveLine.PubBatchR.Copy
      else
         R := nil;
      LeaveCS(ActiveLine.DisplayDataCS);
      if not D.Initialized then Exit;
      CPOutUsed := D.CPOutUsed;
      SetVisible(LampsPanel, wcbLampsPanel, not (D.ExtApp or D.NoCP));
      B := False;
      if (T = nil) and (R = nil) then begin
         UpdateDial(D, DS);
         activeline.timeonline := 0;
         activeline.fsttic := 0;
      end else begin
         if activeline.fsttic = 0 then begin
            activeline.fsttic := GetTickCount;
            activeline.timeonline := 0;
         end else
            activeline.timeonline := GetTickCount - activeline.fsttic;
         UpdateProt(D, DS, T, R, CPOutUsed, B);
      end;
      FreeObject(T);
      FreeObject(R);
      if D.SkipIs then B := False;
      SetEnabledO(mlSkip, wcb_mlSkip, B);
      SetEnabledO(mlRefuse, wcb_mlRefuse, B);
      ActiveLine.Enter;
      if (ActiveLine.SD <> nil) and (ActiveLine.SD.Prot <> nil) then begin
         if (ActiveLine.SD.Prot.Chat <> nil) then begin
           try
             if ChatMemo1.Text <> ActiveLine.SD.Prot.Chat.Memo1Text.Text then begin
                ChatMemo1.Text := ActiveLine.SD.Prot.Chat.Memo1Text.Text;
                ChatMemo1.Perform(em_linescroll, 0, ChatMemo1.Lines.Count);
             end;
             if ChatMemo2.Text <> ActiveLine.SD.Prot.Chat.Memo2Text.Text then begin
                ChatMemo2.Text := ActiveLine.SD.Prot.Chat.Memo2Text.Text;
                ChatMemo2.Perform(em_linescroll, 0, ChatMemo2.Lines.Count);
             end;
             ChatPan.Visible := (ActiveLine.SD.Prot.Chat <> nil) and (ActiveLine.SD.Prot.Chat.Visible);
             if ChatPan.Visible then begin
                lChatCaption.Caption := ActiveLine.SD.Prot.Chat.Caption;
                if not eType.Focused and
                   (ChatMemo1.SelLength = 0) and
                   (ChatMemo2.SelLength = 0) then
                begin
                   eType.SetFocus;
                end;
             end;
           except
             ChatPan.Visible := false;
           end;
         end else ChatPan.Visible := false;
         SetEnabledO(mlChat, wcb_mlChat, ActiveLine.SD.Prot.CanChat and not ActiveLine.SD.Prot.ChatOpened);
         SetEnabledO(bChat, wcb_bChat, ActiveLine.SD.Prot.CanChat and not ActiveLine.SD.Prot.ChatOpened);
      end else begin
         SetEnabledO(mlChat, wcb_mlChat, False);
         SetEnabledO(bChat, wcb_bChat, False);
         ChatPan.Visible := false;
      end;
      ActiveLine.Leave;
      SetEnabledO(bSkip, wcb_bSkip, B);
      SetEnabledO(bRefuse, wcb_bRefuse, B);
      SetEnabledO(mlAnswer, wcb_mlAnswer, D.CanAnswer);
      SetEnabledO(bAnswer, wcb_bAnswer, D.CanAnswer);
      for k := 0 to evListView.Items.Count - 1 do begin
         evListView.Items[k].DropTarget := True;
      end;
      UpdateGlobalEvtUpdateFlag;
      c := ActiveLine.EP.GetEventList;
      b := False;
      for k := 0 to CollMax(c) do begin
         ol := c[k];
         if ol.CronRec.IsUTC then GetSystemTime(S) else GetLocalTime(S);
         u := s;
         for j := 0 to ol.CronRec.Count - 1 do begin
            if not ol.Active then begin
               if not (S.wMonth - 1 in ol.CronRec.p^[j].Months) then continue;
               if not (S.wDay - 1 in ol.CronRec.p^[j].Days) then continue;
               if not (S.wDayOfWeek in ol.CronRec.p^[j].Dows) then continue;
               i := NextMatch(S.wMinute, ol.CronRec.p^[j].Minutes);
               if i < S.wMinute then begin
                  inc(S.wHour);
                  if S.wHour > 23 then begin
                     S.wHour := 0;
                  end;
               end;
               S.wMinute := i;
               S.wHour := NextMatch(S.wHour, ol.CronRec.p^[j].Hours);
            end else begin
               S.wHour := PrevMatch(S.wHour, ol.CronRec.p^[j].Hours);
               S.wMinute := PrevMatch(S.wMinute, ol.CronRec.p^[j].Minutes);
            end;
            S.wSecond := 0;
            e := evListView.FindCaption(0, ol.EName, False, True, True);
            if e = nil then begin
               b := True;
               e := evListView.Items.Add;
               e.Caption := ol.EName;
               e.SubItems.Add('');
               e.SubItems.Add('');
            end;
            if ol.CronRec.IsUTC then begin
               GetTimeZoneInformation(zi);
               SystemTimeToTzSpecificLocalTime(@zi, S, L);
               y := l;
               A := SystemTimeToDateTime(L);
            end else begin
               y := s;
               A := SystemTimeToDateTime(S);
            end;
            st := FormatDateTime('hh:mm', A);
            if e.SubItems[0] <> st then begin
               b := True;
               e.SubItems[0] := st;
            end;
            uNix2WinTime(uWin2NixTime(S) + ol.Len * 60, S);
            if ol.CronRec.IsUTC then begin
               GetTimeZoneInformation(zi);
               SystemTimeToTzSpecificLocalTime(@zi, S, L);
               A := SystemTimeToDateTime(L);
               s := l;
            end else begin
               A := SystemTimeToDateTime(S);
            end;
            st := FormatDateTime('hh:mm', A);
            if e.SubItems[1] <> st then begin
               b := True;
               e.SubItems[1] := st;
            end;
            if ol.Active then begin
               if e.ImageIndex <> 05 then begin
                  e.ImageIndex := 05;
               end;
            end else begin
               if e.ImageIndex <> -1 then begin
                  e.ImageIndex := -1;
               end;
            end;
            e.DropTarget := False;
         end;
      end;
      if c <> nil then begin
         c.DeleteAll;
      end;
      FreeObject(c);
      for k := evListView.Items.Count - 1 downto 0 do begin
         if evListView.Items[k].DropTarget then begin
            evListView.Items.Delete(k);
         end;
      end;
      if b then begin
         evListView.AlphaSort;
      end;
   end;

   procedure UpdateRasDial;
   begin
      if RASThread <> nil then begin
         RasThread.CheckConnection;
         UpDateRas(uFormatDateTime('hh:mm:ss', RasThread.Lasts div 1000), RasThread.ResultString);
      end;
   end;

   function ShowTime: string;
   var
      I,
      N: integer;
   begin
      Result := '';
      N := (GetTickCount - StartTime) div 1000;
      I := N div (60 * 60 * 24);
      N := N mod (60 * 60 * 24);
      if I > 0 then begin
         Result := IntToStr(I) + ' day(s) ';
      end;
      Result := Result + uFormatDateTime('hh:mm:ss', N);
   end;

   procedure UpdatePolls;
   const
      PT: array[TPollType] of Integer = (-1, rsMMptAuto, rsMMptNetm, rsMMptCron, rsMMptTest, rsMMptManual, rsMMptImm, rsMMptBack, rsMMptRCC, rsMMptNmIm);
   var
      C: TColl;
      S: TStringColl;
      I,
      N: Integer;
      P: TFidoPoll;
      Z: string;
      PC: TPollColl;
   begin
      C := TColl.Create;
      PC := TPollColl.Create;
      EnterFidoPolls;
      for I := 0 to FidoPolls.Count - 1 do begin
         PC.Insert(FidoPolls[I]);
      end;
      PC.Sort(SortPollsByDate);
      for I := 0 to PC.Count - 1 do begin
         P := PC[I];
         S := TStringColl.Create;
         S.Add(Addr2Str(P.Node.Addr));
         S.Add(NodeDataStr(P.Node, False)); // Phones & Flags
         case Integer(P.Owner) of
         Integer(nil):
            Z := LngStr(rsMMptNone);
         Integer(PollOwnerExtApp):
            Z := LngStr(rsMMptExtApp);
         Integer(PollOwnerDaemon):
            Z := LngStr(rsMMptDaemon);
         else
            Z := P.Owner.Name;
         end;
         S.Add(Z); // Owner
         if FidoOut.Paused(P.Node.Addr) then begin
            N := radBNPause;
         end else
         if (P.Owner = nil) or (P.Owner = PollOwnerExtApp) then
            N := rsMMpsIdle
         else
         if P.Owner = PollOwnerDaemon then
            N := rsMMpsConnect
         else
         case
            P.Owner.State of
         msDialing: N := rsMMpsDialing;
         msRinging: N := rsMMpsRinging;
         __FirstCN..__LastCN: N := rsMMpsConnect;
         __FirstHSh..__LastHSh: N := rsMMpsHSh;
         __FirstEMSI..__LastEMSI: N := rsMMpsEMSI;
         __FirstWZ..__LastWZ: N := rsMMpsWZ;
         __FirstExtApp..__LastExtApp: N := rsMMpsExtrnl;
         else
            N := rsMMpsUnk;
         end;

         S.Add(LngStr(N)); // State
         S.Add(P.STryBusy);
         S.Add(P.STryNoC);
         S.Add(P.STryFail);
         S.Add(LngStr(PT[P.Typ])); // Type
         C.Insert(S);
      end;
      LeaveFidoPolls;
      PC.DeleteAll;
      FreeObject(PC);
      Inc(ListUpd);
      UpdateDetailsBox(PollsListView, C);
      Dec(ListUpd);
      FreeObject(C);
   end;

   procedure SetLineCommands(B: Boolean);
   var
      Z: Boolean;
      A: TFidoAddress;
      S: string;
   begin
      SetEnabledO(mlClose, wcb_mlClose, B);
      SetEnabledO(mlAbortOperation, wcb_mlAbortOperation, B);
      if (not B) or (not ActiveLine.DialupLine) then begin
         SetEnabledO(mlSendMdmCmds, wcb_mlSendMdmCmds, False);
         mnuTerminal.Enabled := false;
      end else begin
         SetEnabledO(mlSendMdmCmds, wcb_mlSendMdmCmds, B and (AllowedMdmCmdState(ActiveLine.State) { and (ActiveLine.CP <> nil)}));
         mnuTerminal.Enabled := B and AllowedMdmCmdState(ActiveLine.State) and ((@F_OpenTerm <> nil) or (@F_OpenUniTerm <> nil));
      end;
      if B then begin
         if (ActiveLine = PanelOwnerPolls) or
            (ActiveLine = PanelOwnerOutMgr) or
            (ActiveLine = PanelOwnerSystem) or
            (ActiveLine = PanelOwnerDaemon) then GlobalFail('%s', ['SetLineCommands']);
         Z := TimerInstalled(ActiveLine.D.TmrPublic)
      end else begin
         Z := False;
      end;
      SetEnabledO(mlResetTimeout, wcb_mlResetTimeout, Z);
      SetEnabledO(mlIncTimeout, wcb_mlIncTimeout, Z);
      if B then
         Z := False
      else
         Z := PollsListView.ItemFocused <> nil;

      SetEnabledO(mpTrace, wcb_mpTrace, Z);
      SetEnabledO(bTracePoll, wcb_bTracePoll, Z);
      SetEnabledO(ppTracePoll, wcb_ppTracePoll, Z);

      if Z then begin
         ParseAddress(PollsListView.ItemFocused.Caption, A);
         if FidoOut.Paused(A) then begin
            s := LngStr(rsUnPause);
         end else begin
            s := LngStr(rsPause);
         end;
         if mpPause.Caption <> s then begin
            mpPause.Caption := s;
         end;
      end;

      SetEnabledO(mpPause, wcb_mpPause, Z);

      SetEnabledO(bPause, wcb_bPause, Z);
      SetEnabledO(ppPause, wcb_ppPause, Z);

      SetEnabledO(mpReset, wcb_mpReset, Z);
      SetEnabledO(bResetPoll, wcb_bResetPoll, Z);
      SetEnabledO(ppResetPoll, wcb_ppResetPoll, Z);

      SetEnabledO(mpDelete, wcb_mpDelete, Z);
      SetEnabledO(bDeletePoll, wcb_bDeletePoll, Z);
      SetEnabledO(ppDeletePoll, wcb_ppDeletePoll, Z);

      Z := FidoPolls.Count > 0;
      SetEnabledO(mpDeleteAll, wcb_mpDeleteAll, Z);
      SetEnabledO(bDeleteAllPolls, wcb_bDeleteAllPolls, Z);
      SetEnabledO(ppDeleteAllPolls, wcb_ppDeleteAllPolls, Z);
   end;

   procedure UpdateDaemon;
   begin
      if exitnow then exit;
      if gOutputGraph = nil then exit;
      if gInputGraph = nil then exit;
      if TCPIP_GrCS.DebugInfo = nil then exit;
      EnterCS(TCPIP_GrCS);
      Move(TCPIP_OutGr, gOutputGraph.Data, SizeOf(gOutputGraph.Data));
      Move(TCPIP_InGr, gInputGraph.Data, SizeOf(gInputGraph.Data));
      gOutputGraph.GridStep := TCPIP_GrStep;
      gInputGraph.GridStep := TCPIP_GrStep;
      gOutput.Value := TCPIP_OutR;
      gInput.Value := TCPIP_InR;
      LeaveCS(TCPIP_GrCS);
      gOutput.Invalidate;
      gInput.Invalidate;
      gOutputGraph.Invalidate;
      gInputGraph.Invalidate;
      if inifile.RASEnabled then begin
         if not (RasLabelPan.Visible and RasBtnPan.Visible) then begin
           RasLabelPan.Visible := true;
           RasBtnPan.Visible := true;
         end;
         UpDateRasDial;
      end else begin
         RasLabelPan.Visible := False;
         RasBtnPan.Visible := False;
      end;
   end;

   procedure UpdateSystem;
   var
      B: boolean;
      i: integer;
      o: integer;
      m: TMailerThread;
      a: TListItem;
      r: string;
      t: string;
   begin
      if bwListView.Selected = nil then
         B := false
      else
         b := true;
      SetEnabledO(bKillBWZ, wcb_bKillBWZ, B);
      t := '';
      if stListView.ItemFocused <> nil then begin
         t := stListView.ItemFocused.Caption;
      end;
      MailerThreads.Enter;
      for i := 0 to stListView.Items.Count - 1 do begin
         stListView.Items[i].DropTarget := True;
      end;
      for i := 0 to CollMax(MailerThreads) do begin
         m := MailerThreads[i];
         a := stListView.FindCaption(0, m.Name, False, True, False);
         if a = nil then begin
            a := stListView.Items.Add;
            a.Caption := m.Name;
            a.SubItems.Add('');
            a.SubItems.Add('');
         end;
         a.DropTarget := False;
         if a.SubItems[0] <> m.StatusMsg then begin
            a.SubItems[0] := m.StatusMsg;
         end;
         if TimerInstalled(m.D.TmrPublic) then begin
            r := IntToStr(RemainingTimeSecs(m.D.TmrPublic));
         end else begin
            if m.FstTic <> 0 then begin
               o := GetTickCount - m.fsttic;
               r := FormatDateTime('hh:mm:ss', EncodeTime(((o div 1000) div 60) div 60, ((o div 1000) div 60) mod 60, (o div 1000) mod 60, o mod 1000));
            end else begin
               r := '';
            end;
         end;
         if a.SubItems[1] <> r then begin
            a.SubItems[1] := r;
         end;
      end;
      MailerThreads.Leave;
      for i := stListView.Items.Count - 1 downto 0 do begin
         if stListView.Items[i].DropTarget then begin
            stListView.Items.Delete(i);
         end;
      end;
      if t <> '' then begin
         stListView.ItemFocused := stListView.FindCaption(0, t, False, True, False);
         if stListView.ItemFocused <> nil then begin
            stListView.ItemFocused.Selected := True;
         end;
      end;
   end;

   procedure SetMasterKeyCommands(B: Boolean);
   begin
      SetEnabledO(mcMasterPwdCreate, wcb_MasterKeyCreate, B);
      B := not B;
      SetEnabledO(mcMasterPwdChange, wcb_MasterKeyChange, B);
      SetEnabledO(mcMasterPwdRemove, wcb_MasterKeyRemove, B);
   end;

var
   ClearMlr,
   B,
   OutMgrTab: Boolean;
   dsk: byte;
begin
   if ApplicationDowned then begin
      mnu_tray_TCP.Checked := DaemonStarted;
   end;
   if (Trunc(Now * 100000) mod 50) = 0 then begin
      try
         if IniFile.InSecure[2] <> ':' then
            dsk := 0
         else
            dsk := ord(Upcase(IniFile.InSecure[1])) - $40;
         GroupBox2.Caption := ' badwazoo / free at inbound: ' + FloatToStr(Round(DiskFree(dsk) / 1048576)) + ' Mb';
      except on E: Exception do ProcessTrap(E.Message, 'Disk space check');
      end;
   end;
   try
      UpdateMHist(ActiveLine);
      Inc(MHistO.GridStep);
      Inc(MHistI.GridStep);
      if (MHistO.GridStep mod 12) = 0 then begin
         MHistO.GridStep := 0;
         MHistI.GridStep := 0;
      end;
   except on E: Exception do ProcessTrap(E.Message, 'Disk space check #2');
   end;
   {---}
   ClearMlr := True;
   B := False;
   OutMgrTab := False;
   case Integer(ActiveLine) of
   Integer(PanelOwnerDaemon): UpdateDaemon;
   Integer(PanelOwnerOutMgr): begin OutMgrTab := True; end; // OutMgr needs no updating
   Integer(PanelOwnerSystem): UpdateSystem;
   Integer(PanelOwnerPolls):
      if not fromcc then UpdatePolls;
   else
      begin
         if MailerThreads.IndexOf(ActiveLine) = -1 then begin
            exit;
//          GlobalFail('%s', ['TMailerForm.UpdateView, MailerThreads.IndexOf(ActiveLine) = -1']);
         end;
         UpdateMlr;
         B := True;
         ClearMlr := False;
      end;
   end;
   SetEnabledO(mtOutSmartMenu, wcb_OutSmartMenu, OutMgrTab);
   SetLineCommands(B);
   if ClearMlr then begin
      SetEnabledO(mlSkip, wcb_mlSkip, False);
      SetEnabledO(mlRefuse, wcb_mlRefuse, False);
      SetEnabledO(mlChat, wcb_mlChat, False);
      SetEnabledO(bSkip, wcb_bSkip, False);
      SetEnabledO(bRefuse, wcb_bRefuse, False);
      SetEnabledO(mlAnswer, wcb_mlAnswer, False);
      SetEnabledO(bAnswer, wcb_bAnswer, False);
   end;
   SetMasterKeyCommands(Cfg.MasterKey = 0);
   mfRunIPDaemon.Checked := DaemonStarted;
   mnu_tray_TCP.Checked := DaemonStarted;
   if LUpd then UpdateLamps;
   lTime0.Caption := LngStr(rsUptimeStr);
   lTime1.Caption := ShowTime;
   FormResize(nil);
end;

procedure TMailerForm.MainTabControlChange(Sender: TObject);

   procedure GetActiveLine;
   var
      i: Integer;
      j,
     ch: Integer;
      m: TMailerThread;
   begin
      ActiveLine := nil;
      i := MainTabControl.TabIndex;
      ch := 0;
      for j := 0 to CollMax(MailerThreads) do begin
         m := MailerThreads[j];
         if not m.DialupLine then Continue;
         if ch = i then begin
            ActiveLine := m;
            Exit
         end;
         Inc(ch);
      end;
      if ch = i then begin
         ActiveLine := PanelOwnerPolls;
         Exit
      end;
      Inc(ch);
      if ch = i then begin
         ActiveLine := PanelOwnerOutMgr;
         Exit
      end;
      Inc(ch);
      if ch = i then begin
         ActiveLine := PanelOwnerSystem;
         Exit;
      end;
      Inc(ch);
      if ch = i then begin
         ActiveLine := PanelOwnerDaemon;
         Exit
      end;
      Inc(ch);
      for j := 0 to CollMax(MailerThreads) do begin
         m := MailerThreads[j];
         if m.DialupLine then Continue;
         if ch = i then begin
            ActiveLine := m;
            Exit
         end;
         Inc(ch);
      end;
      if ActiveLine = nil then ActiveLine := PanelOwnerPolls;
   end;

var
   s,
   z: string;
   DoClearTerms: Boolean;

begin
   DoClearTerms := True;
   GetActiveLine;
   case Integer(ActiveLine) of
   Integer(PanelOwnerOutMgr):
      begin
         SetTopPageIndex(4);
         SetBtmPageIndex(3);
         s := LngStr(rsMMwcOutMgr);
         LogBox.Lines := nil;
         ChatPan.Visible := false;
         LogBox.Visible := false;
      end;
   Integer(PanelOwnerPolls):
      begin
         SetTopPageIndex(2);
         SetBtmPageIndex(1);
         LogBox.Lines := FidoPolls.Log.Strings;
         LogBox.Visible := true;
         ChatPan.Visible := false;
         s := LngStr(rsMMwcPollMgr);
      end;
   Integer(PanelOwnerSystem):
      begin
         SetTopPageIndex(5);
         SetBtmPageIndex(5);
         LogBox.Lines := nil;
         ChatPan.Visible := false;
         LogBox.Visible := false;
         s := LngStr(rsMMwcSystem);
      end;
   Integer(PanelOwnerDaemon):
      begin
         SetTopPageIndex(3);
         SetBtmPageIndex(2);
         if LogBox.Lines <> IPPolls.LogContainer.Strings then
            LogBox.Lines := IPPolls.LogContainer.Strings;
         LogBox.Visible := true;
         ChatPan.Visible := false;
         s := LngStr(rsMMwcDaemon);
      end;
   else
      begin
         SetBtmPageIndex(0);
         if LogBox.Lines <> ActiveLine.LogStrings then
            LogBox.Lines := ActiveLine.LogStrings;
         UpdateLamps;
         TermTx.Data := ActiveLine.TermTxData;
         TermRx.Data := ActiveLine.TermRxData;
         TermTx.Invalidate;
         TermRx.Invalidate;
         DoClearTerms := False;
         s := ActiveLine.Name;
         if ActiveLine.PublicD.isZMH then begin
            s := s + ' (ZMH)';
         end;
         LogBox.Visible := true;
         if (ActiveLine.SD <> nil) and (ActiveLine.SD.Prot <> nil) and (ActiveLine.SD.Prot.Chat <> nil) then begin
           ChatPan.Visible := (ActiveLine.SD.Prot.Chat <> nil) and (ActiveLine.SD.Prot.Chat.Visible);
           if ChatPan.Visible then lChatCaption.Caption := ActiveLine.SD.Prot.Chat.Caption;
         end else ChatPan.Visible := false;
      end;
   end;
   if Application.MainForm = Self then begin
      z := LngStr(rsMMwcMain)
   end else begin
      z := FormatLng(rsMMwcMirror, [MailerForms.IndexOf(Self)]);
   end;
   Caption := FormatLng(rsMMwcArgus, [z, s]);
   if DoClearTerms then begin
      TermTx.Data := nil;
      TermRx.Data := nil;
   end;
   UpdateView(true);
   UpdateLamps;
end;

procedure TMailerForm.bAbortClick(Sender: TObject);
begin
   InsertEvt(TMlrEvtChStatus.Create(msCancel));
end;

procedure TMailerForm.bStartClick(Sender: TObject);
begin
   InsertEvt(TMlrEvtClearTmrPublic.Create);
end;

procedure TMailerForm.bAddClick(Sender: TObject);
begin
   InsertEvt(TMlrEvtIncTmrPublic.Create);
end;

procedure FreeAllLines;
var
   i: Integer;
begin
   MailerThreads.Enter;
   for i := 0 to MailerThreads.Count - 1 do begin
      TMailerThread(MailerThreads[i]).Terminated := True;
      TMailerThread(MailerThreads[i]).InsertEvt(TMlrEvtShutdownTerminate.Create);
   end;
   MailerThreads.Leave;
   Application.ProcessMessages;
   MailerThreads.Enter;
   for i := 0 to MailerThreads.Count - 1 do begin
      TMailerThread(MailerThreads[i]).WaitFor;
   end;
   MailerThreads.Leave;
   i := 0;
   while (MailerThreads.Count > 0) and (i < 40) do begin
      Application.ProcessMessages;
      Sleep(500);
      Inc(i);
   end;
   if DaemonStarted then _ShutdownDaemon;
end;

procedure FreeAllForms;
var
   i: Integer;
   f: TForm;
begin
   for i := MailerForms.Count - 1 downto 0 do begin
      f := MailerForms[i];
      f.Free;
   end;
   PurgeZombies;
end;

procedure FreeAllPolls(Action: TPollDone; All: Boolean);
var
   i: Integer;
   p: TFidoPoll;
begin
   EnterFidoPolls;
   for i := FidoPolls.Count - 1 downto 0 do begin
      p := FidoPolls[i];
      if All or (p.Owner = PollOwnerExtApp) or (p.Owner = nil) then begin
         if (p.Owner is TMailerThread) then begin
            if (p.Owner.SD <> nil) and (p.Owner.SD.ActivePoll <> nil) then begin
               p.Owner.InsertEvt(TMlrEvtChStatus.Create(msCancel));
               p.Owner.SD.ActivePoll := nil;
            end;
         end;
         p.Done := Action;
         FidoPolls.AtFree(i);
      end;
   end;
   LeaveFidoPolls;
end;

procedure TMailerForm.FormDestroy(Sender: TObject);
begin
   FreeObject(TrayIcon);
   FreeObject(IC);
   FreeObject(OutMgrExpanded);
   FreeObject(OutMgrBM);
   FreeObject(OutMgrBmps[0]);
   FreeObject(OutMgrBmps[1]);
   FreeObject(OutMgrBmps[2]);
   FreeObject(OutMgrNodes);
   FreeObject(BWListView);
   FreeObject(STListView);
   FreeObject(EVListView);
   MailerForms.Enter;
   MailerForms.Delete(Self);
   MailerForms.Leave;
   if Application.MainForm <> Self then
      PostMsg(WM_TABCHANGE)
   else
      FreeAllForms;
   Term := true;
end;

var
   HelpDone,
   HelpInitialized: Boolean;

procedure TMailerForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
   x: array[0..4] of integer;
   o: TRadOutMgr;
   x4: TRadPolls;
   x2: ^TRadBWZWWW;
   x3: TRadMFRec;
   wp: MClasses._TWindowPlacement;
   i: smallint;
   s: string;
begin
   Action := caFree;
   if _Closed then Exit;
   _Closed := True;
   Inc(ListUpd);
   if Application.MainForm = Self then begin
   if not WMCLOSE then
      case IniFile.OnClose of
         1:
            begin
               if MessageBox(handle, PChar(lngstr(rsCloseQuestion)), 'Mailer', mb_YESNO or MB_ICONQUESTION) = idNo then
               begin
                  Action := caNone;
                  _Closed := false;
                  exit;
               end;
            end;
         2:
            begin
               Application.Minimize;
               Action := caNone;
               _Closed := false;
               exit;
            end;
      else
         ;
      end; {case}
      Application.Minimize;
      if DaemonStarted then _ShutdownDaemon;
      if HelpInitialized then begin
         HelpInitialized := False;
         HelpDone := True;
         HtmlHelp(0, '', HH_UNINITIALIZE, 0);
      end;
      SetEvt(oShutdown);
      if not KillTimer(MainWinHandle, 1) then GlobalFail('KillTimer Error %d', [GetLastError]);
      if not KillTimer(Handle, 1) then GlobalFail('KillTimer Error %d', [GetLastError]);
      x[0] := BWListView.Columns[0].Width;
      x[1] := BWListView.Columns[1].Width;
      x[2] := BWListView.Columns[2].Width;
      x[3] := BWListView.Columns[3].Width;
      x[4] := BWListView.Columns[4].Width;
      x2 := @x;
      with inifile do
         RadBWZ := x2^;
      SavFile.WriteInteger('Sizes', 'stListView', stListView.Columns[0].Width);
      for I := 0 to 5 do
         o[i] := OutMgrHeader.Sections[i].Width;
      with inifile do
         RadOut := o;
      for I := 0 to 7 do
         x4[i] := PollsListView.Columns[i].Width;
      inifile.RadPolls := x4;

      wp.length := sizeof(wp);

      if not GetWindowPlacement(handle, @wp) then GlobalFail('WindowPlacement error %d', [GetLastError]);
      if WindowState = wsMaximized then begin
         x3.Maximized := 1;
         if wp.rcNormalPosition.Left > -(wp.rcNormalPosition.Right - wp.rcNormalPosition.Left) then //DV: 07.08.01
            x3.Bounds[0] := wp.rcNormalPosition.Left
         else
            x3.Bounds[0] := -4;
         if wp.rcNormalPosition.Top < Screen.Height {+ height} then //DV: 07.08.01
            x3.Bounds[1] := wp.rcNormalPosition.Top
         else
            x3.Bounds[1] := -4;
         x3.Bounds[2] := wp.rcNormalPosition.Right - wp.rcNormalPosition.Left;
         x3.Bounds[3] := wp.rcNormalPosition.Bottom - wp.rcNormalPosition.Top;
         IniFile.RadMF := x3;
      end else begin
         x3.Maximized := 0;
         if wp.rcNormalPosition.Left > -(wp.rcNormalPosition.Right - wp.rcNormalPosition.Left) then //DV: 07.08.01
            x3.Bounds[0] := wp.rcNormalPosition.Left //DV: 07.08.01
         else
            x3.Bounds[0] := -4; //DV: 07.08.01
         if wp.rcNormalPosition.Top + height > 0 then //DV: 11.02.02 - bugfix
            x3.Bounds[1] := wp.rcNormalPosition.Top //DV: 07.08.01
         else
            x3.Bounds[1] := -4; //DV: 07.08.01
         x3.Bounds[2] := Width;
         x3.Bounds[3] := Height;
         IniFile.RadMF := x3;
      end;
      Inifile.SplitA := Panel2.Width;
      Inifile.SplitB := TermsPanel.Width;
      s := ExtractWord(1, lInfo1.Caption, [#13, #10]);
      SavFile.WriteString('Store', 'LastIn', s);
      s := ExtractWord(2, lInfo1.Caption, [#13, #10]);
      SavFile.WriteString('Store', 'LastOut', s);
      IniFile.StoreCFG;
      FreeLibrary(ModuleHandle);
      ExitNow := true;
   end;
end;

procedure TMailerForm.mcPathnamesClick(Sender: TObject);
begin
   SetupPathNames;
end;

procedure TMailerForm.mwCreateMirrorClick(Sender: TObject);
begin
   OpenMailerForm(ActiveLine, True);
   PostMsg(WM_UPDOUTMGR);
   PostMsg(WM_UPDATEMENUS);
   PostMsg(WM_UPDBWZ);
end;

procedure TMailerForm.mwRemoteMirrorClick(Sender: TObject);
var
   A: TFidoAddrColl;
  an: TAdvNode;
begin
   A := InputFidoAddress(LngStr(rsMMpollNodes), True, nil);
   if A = nil then Exit;
   an := FindNode(A[0]);
   if an = nil then exit;
   InsertPoll(an, [osImmed], ptpRCC);
  _RecalcPolls(True);
{   OpenRemoteForm(A[0]);}
   FreeObject(A);
end;

procedure TMailerForm.mcDialupClick(Sender: TObject);
begin
   DialupSetup(0);
end;

procedure TMailerForm.NodesPasswords1Click(Sender: TObject);
begin
   SetupPasswords;
end;

function OpenMailer(LineId: DWORD; Handle: DWORD): TMailerThread;
var
   r: TPortRec;

   procedure DoOpen;
   var
      cw,
      ch,
      i,
      j: Integer;
      m: TMailerThread;
      p: TPort;
   begin
      m := nil;
      j := -1;
      for i := 0 to CollMax(MailerThreads) do begin
         m := MailerThreads[i];
         if m.LineId = LineId then begin
            j := i;
            if Handle <> INVALID_HANDLE_VALUE then DisplayErrorLng(rsMMAlrAct, Handle);
            Break
         end;
      end;
      if j = -1 then begin
         r := GetPortRec(LineId);
         p := OpenSerialPort(r);
         if p = nil then begin
            if R.d.Port >= MaxComPorts then begin
               if Handle <> INVALID_HANDLE_VALUE then DisplayErrorFmtLng(rsMMCantOpenTDev, [R.Name], Handle);
            end else begin
               if Handle <> INVALID_HANDLE_VALUE then DisplayErrorFmtLng(rsMMCantOpenPort, [ComName(R.d.Port)], Handle);
            end;
            Exit;
         end;
         GetTermBounds(cw, ch);
         m := OpenMailerThread(p, LineId, nil, cw, ch);
      end;
      Result := m;
   end;

begin
   TMailerForm(Application.MainForm).msOpenDialup.Enabled := False;
   Result := nil;
   r := nil;
   DoOpen;
   FreeObject(r);
end;

procedure TMailerForm.LineOpenClick(Sender: TObject);
var
  mt: TMailerThread;
 idx,
   j: Integer;
 _MT: TStringList;
   s: string;
begin
   if not TMenuItem(Sender).Checked then begin
      mt := OpenMailer(TMenuItem(Sender).Tag, Handle);
      if mt <> nil then ActiveLine := mt;
   end else begin
      _MT := TStringList.Create;
      _MT.Sorted := false;
      for j := 0 to CollMax(MailerThreads) do begin
         _MT.Add(TMailerThread(MailerThreads[j]).Name);
      end;
      s := TMenuItem(Sender).Caption;
      if pos('&', s) > 0 then Delete(s, pos('&', TMenuItem(Sender).Caption), 1);
      idx := _MT.IndexOf(s);
      if (idx > -1) then begin
         mt := TMailerThread(MailerThreads[idx]);
         mt.InsertEvt(TMlrEvtOperatorTerminate.Create);
      end;
      _MT.Free;
   end;
   PostMsg(WM_UPDATETABS);
   PostMsg(WM_TABCHANGE);
   PostMsg(WM_UPDATEMENUS);
end;

procedure TMailerForm.mlCloseClick(Sender: TObject);
begin
   InsertEvt(TMlrEvtOperatorTerminate.Create);
end;

function TMailerForm.PollAnyway(an: TAdvNode): Boolean;
begin
   case an.PrefixFlag of
   {nfPvt, }
   nfHold,
   nfDown:
      begin
         Result := YesNoConfirm(Format('Node %s (%s from %s) has %s status in the nodelist. Create poll anyway?', [Addr2Str(an.Addr), an.Sysop, an.Location, cNodePrefixFlag[an.PrefixFlag]]), Handle)
      end;
   else
      Result := True;
   end;

end;

procedure TMailerForm.InsertPollAddress(const A: TFidoAddress);
var
   an: TAdvNode;
begin
   an := FindNode(A);
   if an = nil then begin
      DisplayErrorFmtLng(rsMMUnlistedNode, [Addr2Str(A)], Handle);
   end else begin
      if PollAnyway(an) then InsertPoll(an, [], ptpManual);
   end;
end;

procedure TMailerForm.bNewPollClick(Sender: TObject);
begin
   NewPoll;
end;

procedure TMailerForm.PollsListViewChange(Sender: TObject; Item: TListItem; Change: TItemChange);
begin
   Inc(ListUpd);
   if ListUpd = 1 then MainTabControlChange(nil);
   Dec(ListUpd);
end;

procedure TMailerForm.PollsListViewClick(Sender: TObject);
begin
   Inc(ListUpd);
   if ListUpd = 1 then MainTabControlChange(nil);
   Dec(ListUpd);
   UpdateView(false);
end;

procedure TMailerForm.mfExitClick(Sender: TObject);
begin
   WMCLOSE := true;
   _PostMessage(Application.MainForm.Handle, WM_CLOSE, 0, 0);
end;

procedure TMailerForm.mtBrowseNodelistClick(Sender: TObject);
begin
   BrowseNodes;
end;

procedure TMailerForm.mwCloseClick(Sender: TObject);
begin
   WMCLOSE := true;
   Close;
end;

procedure TMailerForm.mhAboutClick(Sender: TObject);
var
   mbp: tagMsgBoxParamsA;

   function MakeLangID(PrimaryLangID, SubLangID: Word): Word;
   begin
      Result := (SubLangID shl 10) or PrimaryLangID;
   end;

begin
   //  ShowAbout;
   mbp.hwndOwner := Application.Handle;
   mbp.cbSize := sizeof(mbp);
   mbp.lpszText := PChar(
      ProductNameFull + #10 +
      'Version: ' + ProductVersion + #10#10 +
      '© 2003-2004 by Taurus. All rights reserved'#10 +
      'FidoNet: 2:461/700, 701, 702, e-mail: taurus@rinet.ru'#10#10 +
      '© 2003-2004 by RadSoft. All rights reserved'#10#10 +
      '© 2000-2003 by Denis Voituk. All rights reserved'#10 +
      'FidoNet: 2:5012/37, 2:5012/38, 2:550/5012, e-mail: deniska666@mail.ru          '#10#10 +
      '© 2001 OlegON software. All rights reserved'#10 +
      'FidoNet: 2:5020/1970, e-mail: support@olegon.com'#10#10 +
      '© 2001-2002 by Sergey Shumakov. All rights reserved'#10 +
      'FidoNet: 2:5005/47'#10#10 +
      '© 1996-2001 RITLABS S.R.L. All rights reserved'#10#10 +
      'Hydra transfer protocol'#10 +
      '© 1991-1993 Joaquim H. Homrighausen. All rights reserved'#10 +
      '© 1991-1993 Lentz Software Development. All rights reserved'#10#10 +
      'Contains cryptographic software written by Eric Young');

   mbp.lpszCaption := '';
   mbp.hInstance := hInstance;
   mbp.lpszIcon := MAKEINTRESOURCE(700);
   mbp.dwStyle := MB_USERICON or MB_OK;
   mbp.dwContextHelpId := 0;
   mbp.dwLanguageId := MAKELANGID(LANG_RUSSIAN, 0);
   MessageBoxIndirect(mbp);
end;

procedure TMailerForm.bDeletePollClick(Sender: TObject);
var
   p: TFidoPoll;
   li: TListItem;
   i: Integer;
   CantDelete: Boolean;
   s: string;
   a: TFidoAddress;
begin
   CantDelete := False;
   li := PollsListView.ItemFocused;
   if li <> nil then begin
      s := li.Caption;
      if not ParseAddress(s, a) then GlobalFail('TMailerForm.bDeletePollClick, failed to parse "%s"', [s]);
      EnterFidoPolls;
      for i := 0 to FidoPolls.Count - 1 do begin
         p := FidoPolls[i];
         if CompareAddrs(a, p.Node.Addr) = 0 then begin
            if True or (p.Owner = PollOwnerExtApp) or (p.Owner = nil) then begin
               p.Done := pdnDeleted;
               FidoPolls.AtFree(i);
            end else begin
               CantDelete := True;
               s := FormatLng(rsMMCDBP, [PollOwnerName(p)]);
            end;
            Break;
         end;
      end;
      LeaveFidoPolls;
   end;
   PostMsg(WM_UPDATEVIEW);
   if CantDelete then DisplayError(s, Handle);
end;

procedure TMailerForm.bResetPollClick(Sender: TObject);
var
   p: TFidoPoll;
  li: TListItem;
   i: Integer;
   s: string;
   a: TFidoAddress;
begin
   li := PollsListView.ItemFocused;
   if li <> nil then begin
      s := li.Caption;
      if not ParseAddress(s, a) then GlobalFail('TMailerForm.bResetPollClick, failed to parse "%s"', [s]);
      EnterFidoPolls;
      for i := 0 to FidoPolls.Count - 1 do begin
         p := FidoPolls[i];
         if CompareAddrs(a, p.Node.Addr) = 0 then begin
            p.Reset;
            Break;
         end;
      end;
      LeaveFidoPolls;
   end;
   PostMsg(WM_UPDATEVIEW);
end;

procedure TMailerForm.bDeleteAllPollsClick(Sender: TObject);
begin
   FreeAllPolls(pdnDeleteAll, True);
   PostMsg(WM_UPDATEVIEW);
end;

procedure TMailerForm.PrepareGtitles;
var
  gw,
   i: Integer;
   Extent: TSize;
   s: string;
begin
   GridFillRowLng(gTitles, rsMMTitlesGrid);
   gTitles.Canvas.Font := gTitles.Font;
   gw := 0;
   for i := 0 to gTitles.RowCount - 1 do begin
      s := gTitles[0, i] + 'M';
      GetTextExtentPoint32(gTitles.Canvas.Handle, @s[1], Length(s), Extent);
      gw := MaxI(gw, Extent.cX);
   end;
   gTitles.Width := gw;
   gTitles.DefaultColWidth := gw - 1;
end;

procedure TMailerForm.LoadOutMgrBmp(i: Integer; const AName: string; AColor: TColor);
var
   B,
   C: TBitmap;
   R: TRect;
begin
   FreeObject(OutMgrBmps[i]);
   B := TBitmap.Create;
   B.LoadFromResourceName(hInstance, AName);
   R := Rect(0, 0, B.Width, B.Height);
   C := TBitmap.Create;
   C.Width := R.Right;
   C.Height := R.Bottom;
   C.Canvas.Brush.Color := OutMgrOutline.Color;
   C.Canvas.BrushCopy(R, B, R, AColor);
   OutMgrBmps[i] := C;
   FreeObject(B);
end;

procedure TMailerForm.ExceptionEvent(Sender: TObject; E: Exception);
var
   s,
  em: string;
begin
   if Sender = nil then
      s := 'Application'
   else begin
      s := 'App/' + Sender.ClassName;
      if Sender is TComponent then s := s + '/' + TComponent(Sender).Name;
   end;
   if TObject(E) is Exception then
      em := E.Message
   else
      em := 'UnkExpt';
   ProcessTrap(em, s);
end;

procedure TMailerForm.FormCreate(Sender: TObject);
var
  ModuleLoaded: boolean;

   function DoLoadLibrary: boolean;
   var
      ModuleName: string;
   begin
      ModuleName := MakeNormName(HomeDir, 'wTerminal.dll');
      ModuleHandle := LoadLibrary(PChar(ModuleName));
      result := ModuleHandle <> 0;
   end;

   function __Load(A: PChar): Pointer;
   begin
      Result := GetProcAddress(ModuleHandle, A);
   end;

   procedure InitOutMgrPopup;
   var
      i,
      j: Integer;
      m,
      k,
      n: TMenuItem;
   begin
      gTitles.MenuDisabled := true;
      gNfo.MenuDisabled := true;
      for i := 0 to OutMgrPopup.Items.Count - 1 do begin
         m := OutMgrPopup.Items[i];
         if m.Tag > 1 then begin
            for j := 0 to ompCur.Count - 1 do begin
               k := ompCur.Items[j];
               n := TMenuItem.Create(m);
               n.Caption := k.Caption;
               n.OnClick := k.OnClick;
               m.Add(n);
            end;
         end;
      end;
   end;

begin
   lInfo1.Caption :=
   Trim(SavFile.ReadString('Store', 'LastIn',
                      'Last  in: -:---/---@--------, --/--/-- --:--:--')) + #32#13#10 +
   Trim(SavFile.ReadString('Store', 'LastOut',
                      'Last out: -:---/---@--------, --/--/-- --:--:--')) + #32;
   lInfo2.Caption := lInfo1.Caption;
   lInfo2.Left := lInfo1.Left;
   if (Win32Platform = VER_PLATFORM_WIN32_NT) then begin
      aOutbound := nil;
      try
         aOutbound := TAnimate.Create(Self);
         aOutbound.Align := alRight;
         aOutbound.Width := 78;
         aOutbound.Center := True;
         OutMgrBtnPanel.InsertControl(aOutbound);
      except
         FreeObject(aOutbound);
      end;
   end;

   ic := TIcon.Create;
   ic.Width  := 32;
   ic.Height := 32;

   FillBWListBox;

   OutMgrSelectedItemInstead := -1;
   OutMgrNodeSort := 1;
   OutMgrBM := TBitmap.Create;
   UpdateBoundsOutMgrBM;

   LoadOutMgrBmp(ioFolders, 'FOLDERS', clAqua);
   LoadOutMgrBmp(ioLines, 'LINES', clWhite);

   TopPagePanels[wcb_TopPage0] := MailerAPanel;
   TopPagePanels[wcb_TopPage1] := MailerBPanel;
   TopPagePanels[wcb_TopPage2] := PollsListPanel;
   TopPagePanels[wcb_TopPage3] := DaemonPanel;
   TopPagePanels[wcb_TopPage4] := OutMgrPanel;
   TopPagePanels[wcb_TopPage5] := SystemPanel;

   BtmPagePanels[wcb_BtmPage0] := MailerBtnPanel;
   BtmPagePanels[wcb_BtmPage1] := PollBtnPanel;
   BtmPagePanels[wcb_BtmPage2] := DaemonBtnPanel;
   BtmPagePanels[wcb_BtmPage3] := OutMgrBtnPanel;
   BtmPagePanels[wcb_BtmPage4] := PollBtnPanel;
   BtmPagePanels[wcb_BtmPage5] := SystemBtnPanel;

   FillForm(Self, rsMailerForm);
   GridFillRowLng(Self.gTitles, rsMMTitlesGrid);
   GridFillColLng(Self.gLst, rsMMLstGrid);
   StartSize.X := Width;
   StartSize.Y := Height;

   mfRunIPDaemon.Enabled := True;
   mnu_tray_TCP.Enabled := True;

   mwRemoteMirror.Visible := False;

{$IFDEF REMOTEMIRROR}
   mwRemoteMirror.Enabled := True;
   mwRemoteMirror.Visible := True;
{$ENDIF}

   if not (Application.MainForm = nil) then begin
      //  ???
   end else begin
      ClearTimer(flflgtimer);
      ModuleLoaded := DoLoadLibrary;
      if ModuleLoaded then begin
        F_OpenUniTerm := __Load('CreateTermWindow');
        if @F_OpenUniTerm = nil then begin
          F_OpenTerm := __Load('OpenTerminal'); // for backward compability
        end
      end;
      Application.OnException := ExceptionEvent;
      Application.OnHelp := FormHelp;

      if ((IniFile.RadMF.Bounds[0] <> 32767) and
          (IniFile.RadMF.Bounds[1] <> 32767) and
          (IniFile.RadMF.Bounds[2] <> 32767) and
          (IniFile.RadMF.Bounds[3] <> 32767)) and
          (IniFile.RadMF.Bounds[0] < screen.Width) and (IniFile.RadMF.Bounds[1] + IniFile.RadMF.Bounds[3] > 0) then
         SetBounds(IniFile.RadMF.Bounds[0], IniFile.RadMF.Bounds[1], IniFile.RadMF.Bounds[2], IniFile.RadMF.Bounds[3]);
      if IniFile.RadMF.Maximized = 1 then WindowState := wsMaximized;
   end;

   SetHKSpace(IniFile.UseSpace);

   destroyallmenu;
   createallmenu;

   if HelpLanguageId = 0 then begin
      mhContents.Enabled := False;
   end;
   InitOutMgrPopup;

   with IniFile do begin
      ChatPan.Font.Assign(LogBox.Font);
      ChatPan.Color := LogBox.Color;
      eType.Font.Color := clBlack;

      PollsListView.GridLines := GridInPV;
      BWListView.GridLines := GridInBWZ;
      STListView.GridLines := GridInBWZ;
      EVListView.GridLines := GridInBWZ;
      BWListView.Columns[0].Width := RadBWZ[0];
      BWListView.Columns[1].Width := RadBWZ[1];
      BWListView.Columns[2].Width := RadBWZ[2];
      BWListView.Columns[3].Width := RadBWZ[3];
      BWListView.Columns[4].Width := RadBWZ[4];

      STListView.Columns[0].Width := SavFile.ReadInteger('Sizes', 'stListView', 250);

      PollsListView.Columns[0].Width := RadPolls[0];
      PollsListView.Columns[1].Width := RadPolls[1];
      PollsListView.Columns[2].Width := RadPolls[2];
      PollsListView.Columns[3].Width := RadPolls[3];
      PollsListView.Columns[4].Width := RadPolls[4];
      PollsListView.Columns[5].Width := RadPolls[5];
      PollsListView.Columns[6].Width := RadPolls[6];
      PollsListView.Columns[7].Width := RadPolls[7];

      OutMgrHeader.Sections[0].Width := RadOut[0];
      OutMgrHeader.Sections[1].Width := RadOut[1];
      OutMgrHeader.Sections[2].Width := RadOut[2];
      OutMgrHeader.Sections[3].Width := RadOut[3];
      OutMgrHeader.Sections[4].Width := RadOut[4];
      OutMgrHeader.Sections[5].Width := RadOut[5];

      Panel2.Width := SplitA;
      TermsPanel.Width := SplitB;
      SetColors;
      SplitterAPanelMoved(nil);
      SplitterBPanelMoved(nil);
   end;

   gNfo.ColWidths[0] := gNfo.Width;
   lStatus.Font.Style := [fsBold];
   lStatus2.Font.Style := [fsBold];
   lTimeOut.Font.Style := [fsBold];
   lTimeOut.Top := bAdd.Top + (bAdd.Height - lTimeOut.Height) div 2;
   OutMgrOutLine.ItemHeight := Abs(Font.Height) + 4;
   mnuClockClick(nil);
end;

procedure TMailerForm.WMStartMdmCmd(var M: TMessage);
var
   ModemCmdForm: TModemCmdForm;
   r: TModalResult;
   P: TPoint;
   InitOnExit: boolean;
begin
  InitOnExit := true;
  repeat
      ModemCmdForm := TModemCmdForm.Create(Self);
      ModemCmdForm.cbInit.Checked := InitOnExit;
      P.X := StatusBox.Left;
      P.Y := StatusBox.Top + StatusBox.Height;
      P := StatusBox.ClientToScreen(P);
      ModemCmdForm.Left := P.X - 32;
      ModemCmdForm.Top := P.Y + 8;
      ModemCmdForm.P := Self;
      r := ModemCmdForm.ShowModal;
      InitOnExit := ModemCmdForm.cbInit.Checked;
      FreeObject(ModemCmdForm);
  until r <> mrOK;
  if r = 2 then begin
     InsertEvt(TMlrEvtChStatus.Create(msInit));
  end else begin
     InsertEvt(TMlrEvtChStatus.Create(msIdleA_Expired));
  end;
end;

procedure TMailerForm.WMStartTerm(var M: TMessage);
var
   h: THandle;
begin
   if (ActiveLine is TMailerThread) and (ActiveLine.DialupLine) then begin
      if @F_OpenUniTerm <> nil then begin
         if ActiveLine.TapiDevice then begin
            (ActiveLine.CP as TTAPIPort).MakeCall;
         end;
         h := ActiveLine.CP.Handle;
         (ActiveLine.CP as TSerialPort).SleepDown;
         F_OpenUniTerm(h);
         (ActiveLine.CP as TSerialPort).WakeUp;
      end;
   end;
   InsertEvt(TMlrEvtChStatus.Create(msInit));
end;

procedure TMailerForm.WMGetMinMaxInfo(var AMsg: TWMGetMinMaxInfo);
var
   MM: TMinMaxInfo;
begin
   MM := AMsg.MinMaxInfo^;
   MM.ptMinTrackSize := StartSize;
   AMsg.MinMaxInfo^ := MM;
end;

procedure TMailerForm.WMTrayRC;
begin
   SetForegroundWindow(Handle);
   TrayIcon.DoRightClick(TObject(M.lParam));
end;

procedure TMailerForm.WMAppMinimize;
begin
   Application.Minimize;
end;

procedure TMailerForm.WMSetColors;
begin
   Self.SetColors;
end;

procedure TMailerForm.WMUseSpace;
begin
   Self.SetHKSpace(bool(m.WParam));
end;

procedure TMailerForm.WMSetLang(var M: TMessage);
begin
   SetIntLang(M.WParam, M.LParam);
end;

procedure TMailerForm.WMGRIDUPD(var M: TMessage);
begin
   case M.LParam of
   0:
      begin
         BWListView.GridLines := IniFile.GridInBWZ;
         STListView.GridLines := IniFile.GridInBWZ;
         EVListView.GridLines := IniFile.GridInBWZ;
      end;
   1:
      begin
         PollsListView.GridLines := IniFile.GridInPV;
      end;   
   else {error}
      ;
   end; {of case}
end;

procedure TMailerForm.WMCHECKFILEFLAGS(var M: TMessage);
begin
  if Win32Platform = VER_PLATFORM_WIN32_NT then begin
    if M.WParam = 0 then exit;
    ChkFlFlg(true, TStringHolder(M.WParam).S);
    FreeObject(TStringHolder(M.WParam));
  end else begin
    ChkFlFlg(true, '');
  end;
end;

procedure TMailerForm.WMNCCalcSize;
begin
   inherited;
end;

procedure TMailerForm.WMRebuildExt(var M: TMessage);
begin
   DestroyAllMenu;
   CreateAllMenu;
end;

procedure TMailerForm.WMReReadCFG(var M: TMessage);
begin
   IniFile.ReadConfig;
end;

procedure TMailerForm.WMReReadOutb(var M: TMessage);
begin
   ReReadOutbound(M.LParam = 1);
end;

procedure TMailerForm.WMOutboundAlert(var M: TMessage);
var
   i: integer;
   t: TMailerThread;
begin
   if M.WParam = 1 then begin
      if OutMgrThread <> nil then begin
         OutMgrThread.HandUpdate := True;
         SetEvt(OutMgrThread.oEvt);
      end;
   end else
   if M.WParam = 2 then begin
      if MailerThreads = nil then exit;
      if MailerThreads.Count = 0 then exit;
      if IniFile = nil then exit;
      if not IniFile.DynamicOutbound then exit;
      MailerThreads.Enter;
      for i := 0 to CollMax(MailerThreads) do begin
         t := MailerThreads[i];
         if t.Terminated then continue;
         if t.SD = nil then continue;
         if not t.SD.WeHaveReported then continue;
         if t.SD.OutFiles = nil then continue;
         if not t.D.Initialized then continue;
         if CollCount(t.SD.rmtAddrs) = 0 then continue;
         if t.SD.Prot = nil then continue;
         t.NeedRescan := True;
      end;
      MailerThreads.Leave;
   end;
end;

function CurrentOnline: integer;
var
   i,
   n: integer;
   m: TMailerThread;
begin
   n := 0;
   for i := 0 to CollMax(MailerThreads) do begin
      m := MailerThreads[i];
      if not m.DialupLine then begin
         inc(n);
      end;
   end;
   Result := n;
end;

procedure SwitchDaemon(Handle: DWORD);
begin
   if DaemonStarted then begin
      if (Handle = INVALID_HANDLE_VALUE) or
         (CurrentOnline = 0) or
         (OkCancelConfirmLng(rsMMcloseDaemon, Handle)) then
      begin
         IPPolls.Terminated := True;
         _ShutdownDaemon
      end else
         Exit;
   end else begin
      _RunDaemon;
   end;
   PostMsg(WM_UPDATETABS);
   PostMsg(WM_TABCHANGE);
   PostMsg(WM_UPDATEMENUS);
end;

procedure TMailerForm.mfRunIPDaemonClick(Sender: TObject);
begin
   mfRunIPDaemon.Enabled := false;
   SwitchDaemon(Handle);
   mfRunIPDaemon.Enabled := true;
end;

procedure DoneMsgDispatcher;
begin
   FreeObject(MsgDispatcher);
end;

procedure TMailerForm.mcStartupClick(Sender: TObject);
begin
   StartupConfiguration;
end;

procedure TMailerForm.mtCompileNodelistClick(Sender: TObject);
begin
   if YesNoConfirmLng(rsMMokCompileNdl, Handle) then VCompileNodelist(False);
end;

procedure TMailerForm.mcNodelistClick(Sender: TObject);
begin
   SetupNodelist;
end;

procedure TMailerForm.mcDaemonClick(Sender: TObject);
begin
   SetupIP(0);
end;

procedure TMailerForm.mhContentsClick(Sender: TObject);
begin
   _PostMessage(Application.Handle, CM_INVOKEHELP, HELP_CONTENTS, 0);
end;

procedure TMailerForm.mhWebSiteClick(Sender: TObject);
begin
   ShellExecute(Handle, { handle to parent window }
      nil, { pointer to string that specifies operation to perform }
      'http://www.ritlabs.com/argus/',
      nil, { pointer to string that specifies executable-file parameters }
      nil, { pointer to string that specifies default directory }
      SW_SHOWNORMAL);
end;

procedure TMailerForm.mhHelpClick(Sender: TObject);
begin
   _PostMessage(Application.Handle, CM_INVOKEHELP, HELP_HELPONHELP, 0);
end;

procedure TMailerForm.bTracePollClick(Sender: TObject);
var
   SC,
   LC: TStringColl;
   p: TFidoPoll;
   li: TListItem;
   i: Integer;
   TQ: TFSC62Quant;
   m: TMailerThread;
   AV: Boolean;

   procedure AddHdr;
   var
      s: string;
   begin
      case p.Node.PrefixFlag of
         nfPvt, nfHold, nfDown: s := Format(' (%s)', [cNodePrefixFlag[p.Node.PrefixFlag]]);
      end;

      if P.Node.Location = '' then
         SC.Add(FormatLng(rsMMStationHdrA, [Addr2Str(p.Node.Addr)]) + s)
      else begin
         SC.Add(FormatLng(rsMMStationHdrB, [p.Node.Station, Addr2Str(p.Node.Addr)]) + s);
         SC.Add(FormatLng(rsMMSysopHdr, [p.Node.Sysop, p.Node.Location]));
      end;
      SC.Add('');
   end;

   procedure ChkPS(a, b: Pointer);
   begin
      if AV then begin
         case GetPollState(a, P, False, b, LC, TQ) of
            plsAVL: FidoOut.Unlock(p.Node.Addr, osBusyEx);
            plsFRB: ;
         else
            AV := False;
         end;
      end;
   end;

const
   PtpTyp: array[TPollType] of Integer = (0, rsMMptpiOutb, rsMMptpiNetm, rsMMptpiCron, rsMMptpiTest, rsMMptpiManual, rsMMptpiImm, rsMMptpiBack, rsMMptpiRCC, rsMMptpiNmIm);

var
   s: string;
   a: TFidoAddress;
   ii: Integer;
begin
   li := PollsListView.ItemFocused;
   if li <> nil then begin
      s := li.Caption;
      if not ParseAddress(s, a) then GlobalFail('TMailerForm.bTracePollClick, failed to parse "%s"', [s]);
      EnterFidoPolls;
      for i := 0 to FidoPolls.Count - 1 do begin
         p := FidoPolls[i];
         if CompareAddrs(a, p.Node.Addr) = 0 then begin
            AV := True;
            SC := TStringColl.Create;
            LC := TStringColl.Create;
            TQ := CurFSC62Quant;
            AddHdr;

            if DaemonStarted then begin
               ChkPS(IPPolls.OwnPolls, PollOwnerDaemon);
               if AV then begin
                  LC.Ins0('--- TCP/IP Daemon');
                  LC.Ins0('');
               end;
               SC.Concat(LC);
            end;

            for ii := 0 to CollMax(MailerThreads) do begin
               m := MailerThreads[ii];
               if not m.DialupLine then Continue;
               ChkPS(m.OwnPolls, m);
               if AV then begin
                  LC.Ins0((Format('--- %s', [m.Name])));
                  LC.Ins0('');
               end;
               SC.Concat(LC);
            end;

            FreeObject(LC);
            if AV then begin
               SC.Ins0('');
               SC.Ins0(LngStr(PtpTyp[p.typ]));
            end;

            LeaveFidoPolls;
            DisplayInfoFormEx(FormatLng(rsMMPollNfoC, [Addr2Str(a)]), SC);
            FreeObject(SC);
            Exit;
         end;
      end;
      LeaveFidoPolls;
   end;
end;

procedure TMailerForm.mcExternalsClick(Sender: TObject);
begin
   if ConfigureExternals then begin
      CronThr.Recalc := True;
      destroyallmenu;
      createallmenu;
   end;
end;

procedure TMailerForm.FormKeyDown(Sender: TObject; var Key: Word;
   Shift: TShiftState);
var
   c, i: Integer;
begin
   case Key of
   VK_TAB:
      if ssCtrl in Shift then begin
         i := MainTabControl.TabIndex;
         c := MainTabControl.Tabs.Count;
         if ssShift in Shift then begin
            Dec(i);
            if i < 0 then i := c - 1;
         end else begin
            Inc(i);
            if i = c then i := 0;
         end;
         MainTabControl.TabIndex := i;
         MainTabControlChange(nil);
      end;
   end;
end;

procedure TMailerForm.SetIntLang(i1: integer; i2: integer);
var
   i: Integer;
   f: TMailerForm;
begin
   if MailerForms = nil then Exit;
   i := i1;
   if not SetRegInterfaceLng(i) then begin
      DisplayErrorLng(rsCantUpdateReg, Handle);
      Exit;
   end;
   SetLanguage(i);
   for i := 0 to MailerForms.Count - 1 do begin
      f := MailerForms.At(i);
      FillForm(f, rsMailerForm);
      f.gTitles.RefillLng;
      f.gLst.RefillLng;
      f.gNfo.RefillLng;
      GridFillRowLng(f.gTitles, rsMMTitlesGrid);
      GridFillColLng(f.gLst, rsMMLstGrid);
      f.UpdateView(false);
   end;
   UpdateTabsAll;
   TabChangeAll;
end;

procedure TMailerForm.mclEnglishUKClick(Sender: TObject);
begin
   SetIntLang(TComponent(Sender).Tag, 0);
end;

procedure TMailerForm.FormShow(Sender: TObject);
begin
   if Shown then Exit;
   Shown := True;
   InvalidateLabels;
   PrepareGtitles;
end;

procedure TMailerForm.maEventsClick(Sender: TObject);
begin
   SetupEvents;
end;

procedure TMailerForm.bSkipClick(Sender: TObject);
begin
   if IniFile.PollAddFlags[2] = '1' then begin
      if MessageBox(handle, 'Do you really want to skip that file?', 'Mailer', mb_OKCANCEL or MB_ICONQUESTION) = idok then
         InsertEvt(TMlrEvtSkip.Create)
   end else begin
      InsertEvt(TMlrEvtSkip.Create);
   end;
end;

procedure TMailerForm.bRefuseClick(Sender: TObject);
begin
   if IniFile.PollAddFlags[1] = '1' then begin
      if MessageBox(handle, 'Do you really want to reject that file?', 'Mailer', mb_OKCANCEL or MB_ICONQUESTION) = idok then
         InsertEvt(TMlrEvtRefuse.Create)
   end else begin
      InsertEvt(TMlrEvtRefuse.Create)
   end;
end;

procedure TMailerForm.bChatClick(Sender: TObject);
begin
   if (ActiveLine <> nil) and
      (ActiveLine.SD <> nil) and
      (ActiveLine.SD.Prot <> nil) then
   begin
      ActiveLine.SD.Prot.StartChat(ActiveLine.LogFName, true, '');
   end;
end;

procedure TMailerForm.bAnswerClick(Sender: TObject);
begin
   InsertEvt(TMlrEvtAnswer.Create);
end;

procedure TMailerForm.maFileRequestsClick(Sender: TObject);
begin
   SetupFileRequests;
end;

procedure TMailerForm.mtEditFileRequestClick(Sender: TObject);
begin
   EditFileRequest;
end;

///////////////////////////////////////////////////////////////////////
//                                                                   //
//                      OUTBOUND MANAGER                             //
//                                                                   //
///////////////////////////////////////////////////////////////////////

procedure TMailerForm.OutMgrOutlineDrawItem(Control: TWinControl; Index: Integer; R: TRect; State: TOwnerDrawState);
var
   I: Integer;
   F: TOutItem;
   N: TOutlineNode;
   zzz,
   S,
   s2: string;
   R1,
   RR: TRect;
   SysTime,
   Age: DWORD;
   node: TFidoNode;
   cl: TColor;

   procedure ClrRct(R: TRect);
   begin
      with OutMgrBM.Canvas do begin
         cl := Brush.Color;
         Brush.Color := clWindow;
         FillRect(Rect(R.Left, R.Top, R.Left + 16, R.Bottom));
         Brush.Color := cl;
      end;
   end;

   procedure DrawStr(AFlags: DWORD; const AStr: string);
   begin
      if R.Left < R.Right then DrawText(OutMgrBM.Canvas.Handle, PChar(AStr), Length(AStr), R, DT_END_ELLIPSIS or DT_NOCLIP or DT_NOPREFIX or AFlags);
   end;

begin
   if NodelistCompilation then exit;
   N := OutMgrOutline.GetVisibleNode(Index);
   F := N.Data;
   if OutMgrBM.Height < R.Bottom - R.Top then OutMgrBM.Height := R.Bottom - R.Top;
   if OutMgrBM.Width < R.Right - R.Left then OutMgrBM.Width := R.Right - R.Left;
   RR := R;
   R := Rect(0, 0, RR.Right - RR.Left, RR.Bottom - R.Top);
   with OutMgrBM.Canvas do begin
      SysTime := uGetSystemTime;
      if SysTime >= Time then
         Age := SysTime - F.Nfo.Time
      else
         Age := 0;
      if Age >= 28 * day then begin
         Font.Color := IniFile.OldMail28Fore;
         Brush.Color := IniFile.OldMail28Back;
      end
      else
      if Age >= 21 * day then begin
         Font.Color := IniFile.OldMail21Fore;
         Brush.Color := IniFile.OldMail21Back;
      end else
      if Age >= 14 * day then begin
         Font.Color := IniFile.OldMail14Fore;
         Brush.Color := IniFile.OldMail14Back;
      end else
      if Age >= 7 * day then begin
         Font.Color := IniFile.OldMail7Fore;
         Brush.Color := IniFile.OldMail7Back;
      end else begin
         Brush.Color := clWindow;
         Font.Color := clWindowText;
      end;
      FillRect(Rect(R.Left, R.Top, R.Left + (Integer(N.Level) + 1) * 16, R.Bottom));
      ClrRct(R);
      if N.Level = 1 then begin
         if f = FirstOutMgrNode then
            I := 2
         else
         if f = LastOutMgrNode then
            I := 1
         else
            I := 0;
         if N.HasItems then begin
            Inc(I, 3);
            if N.Expanded then Inc(I, 3);
         end;
      end else begin
         if (f.Nfo.Attr and olfLastItem = 0) then
            I := 0
         else
            I := 1;
         if (f.Nfo.Attr and olfLastLevel = 0) then BitBlt(Handle, R.Left, R.Top, 16, 16, OutMgrBmps[ioLines].Canvas.Handle, 144, 0, SRCCOPY);
         Inc(R.Left, 16);
      end;

      ClrRct(R);
      BitBlt(Handle, R.Left, R.Top, 16, 16, OutMgrBmps[ioLines].Canvas.Handle, I * 16, 0, SRCCOPY);

      if F is TOutNode then begin
         if (index = 0) then OutBSize := 0;
         //        addsize:=true;
         Font.Style := [fsBold];
         I := 0;
         if N.Expanded then Inc(I);
         if (osBusy in F.StatusSet) or
            (osBusyEx in F.StatusSet) then
         begin
            Inc(I, 7);
            Node := GetListedNode(F.Address);
            if Node = nil then
               s2 := '-Unknown sysop-'
            else
               s2 := Node.Sysop;
            //          Node.Free;
            if osBusy in F.StatusSet then s := FormatLng(rsMMOutNBusy, [Addr2Str(F.Address)]);
            if osBusyEx in F.StatusSet then s := FormatLng(rsMMOutNCusy, [Addr2Str(F.Address)]);
            //          s := Format('%s [%s]',[s,s2]);
            s := Format('%s', [s]);
         end else begin
            Node := GetListedNode(F.Address);
            if Node = nil then
               s2 := '-Unknown sysop-'
            else
               s2 := Node.Sysop;
            //          Node.Free;
            //          s := Format('%s [%s]',[Addr2Str(F.Address),s2]);
            s := Format('%s', [Addr2Str(F.Address)]);
         end;
      end else begin
         Font.Style := [];
         if (TOutFile(F).Error <> 0) or (F.Status = osError) then begin
            s := FormatLng(rsMMOutNBrkLnk, [f.Name]);
            I := 9;
         end else
            case F.Status of
               osImmedMail, osCrashMail, osDirectMail, osNormalMail, osHoldMail:
                  begin
                     I := 2;
                  end;
               osImmed, osCrash, osDirect, osNormal, osHold:
                  begin
                     zzz := ExtractFileExt(f.Name);
                     if f.Name = '' then
                     begin
                        s := FormatLng(rsMMOutNFlag, [f.StatusString]);
                        I := 10;
                     end
                     else
                     if IsArcMailExt(zzz) then
                     begin
                        I := 4;
                        s := ExtractFileName(f.Name);
                     end
                     else
                     if (UpperCase(zzz) = '.PKT') or (UpperCase(zzz) = '.P2K') then
                     begin
                        I := 2;
                     end
                     else
                     begin
                        I := 3;
                        s := f.Name;
                     end;
                  end;
               osHReq:
                  begin
                     s := f.Name;
                     I := 6;
                  end;
               osRequest:
                  begin
                     I := 5;
                     s := FormatLng(rsMMOutNFreq, [ExtractFileName(f.Name)]);
                  end;
               osCallback:
                  begin
                     I := 7;
                     s := FormatLng(rsMMOutCBack, [ExtractFileName(f.Name)]);
                  end;
            end;
      end;
      if I = 2 then begin
         s := FormatLng(rsMMOutNMailPkt, [ExtractFileName(f.Name)]);
      end;
      Inc(R.Left, 16);
      ClrRct(R);
      BitBlt(Handle, R.Left, R.Top, 16, 16, OutMgrBmps[ioFolders].Canvas.Handle, I * 16, 0, SRCCOPY);
      Inc(R.Left, 16);

      if ([odSelected, odFocused, odChecked] * State <> [])
         {or F.Selected}then
      begin
         Brush.Color := clHighlight;
         Font.Color := clHighlightText;
      end;
      R1 := R;
      FillRect(R1);
      Inc(R.Left, 4);
      R.Right := OutMgrHeader.Sections[0].Width - 4;
      DrawStr(0, S);
      Inc(R.Left, OutMgrHeader.Sections[0].Width - R.Left);
      R.Right := R.Left + OutMgrHeader.Sections[1].Width - 4;
      DrawStr(0, s2);
      Inc(R.Left, OutMgrHeader.Sections[1].Width);
      if F.Nfo.Size > 0 then begin
         R.Right := R.Left + OutMgrHeader.Sections[2].Width - 4;
         DrawStr(DT_RIGHT, Format('%.0n', [F.Nfo.Size + 0.0]));
      end;
      Inc(R.Left, OutMgrHeader.Sections[2].Width);
      R.Right := R.Left + OutMgrHeader.Sections[3].Width - 4;
      DrawStr(0, F.StatusString);
      Inc(R.Left, OutMgrHeader.Sections[3].Width);
      R.Right := R.Left + OutMgrHeader.Sections[4].Width - 4;
      DrawStr(0, F.ActionString);
      Inc(R.Left, OutMgrHeader.Sections[4].Width);
      R.Right := R.Left + OutMgrHeader.Sections[5].Width - 4;
      DrawStr(0, F.AgeString);
      if odFocused in State then DrawFocusRect(R1);
   end;
   R := Rect(0, 0, RR.Right - RR.Left, RR.Bottom - RR.Top);
   OutMgrOutline.Canvas.CopyRect(RR, OutMgrBM.Canvas, R);
end;

procedure TMailerForm.UpdateBoundsOutMgrBM;
begin
   if OutMgrBM = nil then Exit;
   OutMgrBM.Width := OutMgrOutline.Width;
   OutMgrBM.Height := OutMgrOutline.ItemHeight;
   OutMgrBM.Canvas.Font := OutMgrOutline.Font;
end;

procedure TMailerForm.FormResize(Sender: TObject);
begin
   if (Application.MainForm = nil) or (MainPanel.Parent = nil) then exit;
   UpdateBoundsOutMgrBM;
   OutMgrPanel.Width := MainPanel.ClientWidth;
   OutMgrPanel.Height := BottomPanel.Top - OutMgrPanel.Top;
   SystemPanel.Width := MainPanel.ClientWidth;
   SystemPanel.Height := BottomPanel.Top - SystemPanel.Top;
   lTimeCon.Left := RasBtnPan.Left - lTimeCon.Width - 20;
   lTime0.Top  := 2;
   lTime1.Top  := 2;
   lTime0.Left := MainTabControl.ClientWidth - lTime0.Width - ltime1.Width - 10;
   lTime1.Left := MainTabControl.ClientWidth - ltime1.Width - 10;
end;

procedure TMailerForm.OutMgrOutlineMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
   I: Integer;
   N: TOutlineNode;
begin
   I := OutMgrOutline.GetItem(X, Y);
   OutMgrdLast := Point(X, Y);
   if I > 0 then begin
      OutMgrOutline.SelectedItem := I;
      N := OutMgrOutline[OutMgrOutline.SelectedItem];
      if (X < Integer(N.Level) * 16) then N.Expanded := not N.Expanded;
   end;
end;

procedure TMailerForm.OutMgrOutlineDblClick(Sender: TObject);
var
   P: TPoint;
begin
   GetCursorPos(P);
   Windows.ScreenToClient(OutMgrOutline.Handle, P);
   OutMgrOutlineMouseDown(Sender, mbLeft, [], P.X, P.Y);
   ompOpenClick(nil);
end;

procedure TMailerForm.OutMgrHeaderSectionClick(HeaderControl: THeaderControl; Section: THeaderSection);
var
   i: Integer;
begin
   i := Section.Index + 1;
   if OutMgrNodeSort = i then
      OutMgrNodeSort := -i
   else
      OutMgrNodeSort := i;
   OutMgrRefillExpanded;
   UpdateViewOutMgr;
end;

procedure TMailerForm.OutMgrHeaderSectionResize(HeaderControl: THeaderControl; Section: THeaderSection);
begin
   OutMgrRefillExpanded;
   UpdateViewOutMgr;
end;

procedure TMailerForm.RereadOutbound(full: boolean);
var
   c: integer;
begin
   c := 0;
   while OutMgrThread.HandUpdate do begin
      Application.ProcessMessages;
      Sleep(100);
      inc(c);
      if c = 50 then begin
         exit;
      end;
   end;
   OutMgrThread.ForcedUpdate := True;
   FidoOut.ForcedRescan := True;
   OutMgrThread.FullRescan := full;
   OutMgrThread.HandUpdate := True;
   SetEvt(OutMgrThread.oEvt);
   SetEnabledO(bReread, wcb_Rescan, False);
   if (Win32Platform = VER_PLATFORM_WIN32_NT) then begin
      if aOutbound.CommonAVI <> aviFindFolder then aOutbound.CommonAVI := aviFindFolder;
      aOutbound.Visible := True;
      aOutbound.Active := True;
   end;
end;

procedure TMailerForm.TrayIconClick(Sender: TObject);
begin
  if TrayIcon.Minimized then begin
    RestoreFromTray;
    if Inifile.TrayLamps then begin 
       if MailerForms <> nil then begin
          MailerForms.Enter;
          if MainTabControl.Tabs.Count > TNum then begin
             if MainTabControl.Tabs[TNum] = TNam then begin
                MainTabControl.TabIndex := TNum;
                ActiveLine := TAct;
             end else begin
                MainTabControl.TabIndex := 0;
             end;
          end else begin
             MainTabControl.TabIndex := 0;
          end;
          MailerForms.Leave;
          PostMsg(WM_UPDATETABS);
          PostMsg(WM_TABCHANGE);
       end;
    end
  end else begin
    Application.Minimize;
  end;
end;

procedure TMailerForm.TrayIconMinimize(Sender: TObject);
begin
   if IniFile.Stealth then ShowWindow(Application.Handle, SW_Hide);
   UpdateLampsAll;
end;

function ReloginFailed: Boolean;
begin
   Result := not AskSinglePassword(nil, Cfg.MasterKeyChk);
   if Result then PostCloseMessage;
end;

procedure TMailerForm.maEncryptedLinksClick(Sender: TObject);
begin
   if (Cfg.MasterKey <> 0) and (ReloginFailed) then Exit;
   SetupEncryptedLinks;
end;

procedure TMailerForm.tpRestoreClick(Sender: TObject);
begin
   RestoreFromTray;
end;

procedure TMailerForm.RestoreFromTray;
begin
   Application.Restore;
   Application.RestoreTopmosts;
   SetForegroundWindow(Application.MainForm.Handle);
   TMailerForm(Application.MainForm).RereadOutbound(false);
end;

procedure TMailerForm.NewPoll;
var
   A: TFidoAddrColl;
   I: Integer;
begin
   A := InputFidoAddress(LngStr(rsMMpollNodes), True, nil);
   if A = nil then Exit;
   for I := 0 to A.Count - 1 do begin
      InsertPollAddress(A[I]);
   end;
   _RecalcPolls(True);
   PostMsg(WM_UPDATEVIEW);
   FreeObject(A);
end;

procedure TMailerForm.tpCreatePollClick(Sender: TObject);
var
   doit : boolean;
begin
   doit := TrayIcon.Minimized;
   if doit then RestoreFromTray;
   NewPoll;
   if doit then Application.Minimize;
end;

procedure TMailerForm.tpBrowseNodelistClick(Sender: TObject);
var
   doit : boolean;
begin
   doit := TrayIcon.Minimized;
   if doit then RestoreFromTray;
   BrowseNodes;
   if doit then Application.Minimize;
end;

procedure TMailerForm.CreateOutFileFlag(const AA: TFidoAddress; Status: TOutStatus);
var
   S: string;
   I: DWORD;
begin
   S := GetOutFileName(AA, Status);
   I := _CreateFileDir(S, [cWrite, cEnsureNew]);
   if I <> INVALID_HANDLE_VALUE then ZeroHandle(I) else begin
      if GetErrorNum <> ERROR_FILE_EXISTS then begin
         DisplayWarning(FormatErrorMsg(S, GetErrorNum), Handle);
      end;
   end;
end;

procedure TMailerForm.EditFileRequestEx(const AA: TFidoAddress);
var
   S: string;
   B: Boolean;
   DoPoll: Boolean;
   Status: TOutStatus;
begin
   B := EditRequests(AA);
   S := GetErrorMsg;
   if S <> '' then DisplayError(S, Handle);
   if not B then Exit;
   if not GetAttachStatusEx(Status, DoPoll, nil) then Exit;
   CreateOutFileFlag(AA, Status);
   if DoPoll then InsertPollAddress(AA);
   _RecalcPolls(True);
   RereadOutbound(false);
end;

procedure TMailerForm.EditFileRequest;
var
   AA: TFidoAddress;
begin
   FillChar(AA, SizeOf(AA), #0);
   if not InputSingleAddress(LngStr(rsMMeditFReq), AA, nil) then Exit;
   EditFileRequestEx(AA);
end;

procedure TMailerForm.tpEditFileRequestClick(Sender: TObject);
var
   doit : boolean;
begin
   doit := TrayIcon.Minimized;
   if doit then RestoreFromTray;
   EditFileRequest;
   if doit then Application.Minimize;
end;

procedure TMailerForm.msAdministrativeModeClick(Sender: TObject);
begin
   MailerForms.FreeAll;
end;

function InputMasterPassword(Handle: DWORD): Boolean;
var
   Key: TDesBlock;
begin
   Result := False;
   if not InputNewPwd(Key, LngStr(rsMMMPEntrNew), False, IDH_MASTPWD) then Exit;
   Cfg.MasterKeyChk := xdes_md5_crc16(@Key, 8);
   Cfg.MasterKey := Key;
   Result := StoreConfig(Handle);
   if not Result then PostCloseMessage;
end;

procedure TMailerForm.mcMasterPwdCreateClick(Sender: TObject);
begin
   if WinDlgCapHlp(LngStr(rsMMMPCreate), MB_YESNO or MB_HELP or MB_ICONWARNING, Handle, LngStr(rsMMMPStUpCap), IDH_MASTPWD) <> mrYes then Exit;
   if InputMasterPassword(Handle) then DisplayInfoLng(rsMMMPStUpOK, Handle);
end;

procedure TMailerForm.mcMasterPwdChangeClick(Sender: TObject);
begin
   if WinDlgCap(LngStr(rsMMMPCfmChange), MB_YESNO or MB_ICONWARNING, Handle, LngStr(rsMMMPChgCap)) <> mrYes then Exit;
   if ReloginFailed then Exit;
   if InputMasterPassword(Handle) then DisplayInfoLng(rsMMMPChgOK, Handle);
end;

procedure TMailerForm.mcMasterPwdRemoveClick(Sender: TObject);
begin
   if WinDlgCap(LngStr(rsMMMPCfmRemove), MB_YESNO or MB_ICONWARNING, Handle, LngStr(rsMMMPRemoveCap)) <> mrYes then Exit;
   if ReloginFailed then Exit;
   Cfg.MasterKey := 0;
   Cfg.MasterKeyChk := 0;
   if StoreConfig(Handle) then DisplayInfoLng(rsMMMPRemovedOK, Handle);
end;

function TMailerForm.OutMgrSelectedItem: TOutItem;
var
   ONode: TOutlineNode;
   sitem: Integer;
begin
   Result := nil;
   sitem := OutMgrOutline.SelectedItem;
   if sitem < 1 then Exit;
   ONode := OutMgrOutline[sitem];
   if ONode = nil then GlobalFail('%s', ['TMailerForm.OutMgrSelectedItem ONode = nil']);
   Result := ONode.Data;
end;

type
   TOutFileList = class(TStringColl)
      DestAddr,
      Addr: TFidoAddress;
      Stat: TOutStatus;
      Lock,
      Unlock: Boolean;
   end;

function OutFileColl2OutFileLists(AC: TOutFileColl): TColl;
var
   i: Integer;
   F: TOutFile;
   PrevAddr: TFidoAddress;
   PrevStat: TOutStatus;
   PrevColl,
   CurColl: TOutFileList;
   NewAddr: Boolean;
begin
   PrevColl := nil;
   CurColl := nil;
   Result := nil;
   PrevAddr.Zone := -1;
   PrevStat := osNone;
   for i := 0 to CollMax(AC) do begin
      F := AC[i];
      NewAddr := CompareAddrs(F.Address, PrevAddr) <> 0;
      if NewAddr or (F.FStatus <> PrevStat) then begin
         CurColl := TOutFileList.Create;
         CurColl.IgnoreCase := True;
         CurColl.Addr := F.Address;
         PrevAddr := F.Address;
         CurColl.Stat := F.FStatus;
         PrevStat := F.Status;
         if Result = nil then Result := TColl.Create;
         Result.Insert(CurColl);
         if NewAddr then begin
            CurColl.Lock := True;
            if PrevColl <> nil then PrevColl.Unlock := True;
            PrevColl := CurColl;
         end;
      end;
      if CurColl = nil then
         GlobalFail('%s', ['OutFileColl2OutFileLists CurColl = nil'])
      else
         CurColl.Ins(F.Name);
   end;
   if PrevColl <> nil then PrevColl.Unlock := True;
end;

function OutboundOpChStat(C: TOutFileList; S: TOutStatus): string;
begin
   if FidoOut.MoveFiles(C, @C.Addr, @C.Addr, @C.Stat, @S, False, False, False) then
      Result := ''
   else
      Result := GetErrorMsg;
end;

function OutboundOpReaddress(C: TOutFileList): string;
begin
   if FidoOut.MoveFiles(C, @C.Addr, @C.DestAddr, @C.Stat, @C.Stat, False, False, False) then
      Result := ''
   else
      Result := GetErrorMsg;
end;

function OutboundOpKill(C: TOutFileList): string;
begin
   if FidoOut.MoveFiles(C, @C.Addr, nil, @C.Stat, nil, True, False, False) then
      Result := ''
   else
      Result := GetErrorMsg;
end;

function OutboundOp_Immed(C: TOutFileList): string;
begin
   Result := OutboundOpChStat(C, osImmed);
end;

function OutboundOp_Crash(C: TOutFileList): string;
begin
   Result := OutboundOpChStat(C, osCrash);
end;

function OutboundOp_Direct(C: TOutFileList): string;
begin
   Result := OutboundOpChStat(C, osDirect);
end;

function OutboundOp_Normal(C: TOutFileList): string;
begin
   Result := OutboundOpChStat(C, osNormal);
end;

function OutboundOp_Hold(C: TOutFileList): string;
begin
   Result := OutboundOpChStat(C, osHold);
end;

function OutboundOpUnlink(C: TOutFileList): string;
begin
   if FidoOut.MoveFiles(C, @C.Addr, nil, @C.Stat, nil, False, False, True) then
      Result := ''
   else
      Result := GetErrorMsg;
end;

function OutboundOpPurge(C: TOutFileList): string;
begin
   if FidoOut.MoveFiles(C, @C.Addr, nil, @C.Stat, nil, True, True, False) then
      Result := ''
   else
      Result := GetErrorMsg;
end;

function PerformOutboundOp(C: TOutFileList; OpCode: TOutMgrOpCode; var s: string): Boolean;
type
   TOutboundOpFunc = function(C: TOutFileList): string;
const
   OutboundOpFuncs: array[TOutMgrOpCode] of TOutboundOpFunc =
   (nil,
    OutboundOpReaddress,
    OutboundOpKill,
    OutboundOp_Immed,
    OutboundOp_Crash,
    OutboundOp_Direct,
    OutboundOp_Normal,
    OutboundOp_Hold,
    OutboundOpUnlink,
    OutboundOpPurge
    );
var
   ErrStr: string;
begin
   ErrStr := OutboundOpFuncs[OpCode](C);
   Result := ErrStr = '';
   if not Result then s := ErrStr;
end;

procedure TMailerForm.PerformOutboundOperations(FileLists: TColl; DestAddr: PFidoAddress; OpCode: TOutMgrOpCode);
var
   i: Integer;
   C: TOutFileList;
   OK,
   Ignore: Boolean;
   s: string;
begin
   Ignore := False;
   for i := 0 to CollMax(FileLists) do begin
      C := FileLists[i];
      if (C.Lock) and ((DestAddr = nil) or (CompareAddrs(DestAddr^, C.Addr) <> 0)) then begin
         Ignore := False;
         repeat
            if FidoOut.Lock(C.Addr, osBusy, False) then Break;
            case WinDlg(FormatLng(rsMMOutIsBusy, [Addr2Str(C.Addr)]), MB_ICONWARNING or MB_ABORTRETRYIGNORE, Handle) of
            idAbort: Exit;
            idIgnore:
               begin
                  Ignore := True;
                  Break
               end;
            end; // assume idRetry elsewhere
         until False;
      end;
      if Ignore then Continue; // looking for a next node
      if DestAddr <> nil then C.DestAddr := DestAddr^;
      OK := PerformOutboundOp(C, OpCode, s);
      if ((not OK) or (C.Unlock)) and ((DestAddr = nil) or (CompareAddrs(DestAddr^, C.Addr) <> 0)) then FidoOut.Unlock(C.Addr, osBusy);
      if (not OK) then begin
         Ignore := True;
         if WinDlg(s, MB_ICONWARNING or MB_OKCANCEL, Handle) = idCancel then Exit;
      end;
   end;
end;

procedure TMailerForm.UpdateOutboundCommands;
var
   Found,
   f: Boolean;
   h,
   oo: string;
   o: TOutItem;
   m: TMenuItem;
   i: Integer;
   c: TOutFileColl;
   oe: Boolean;
   Info: TOutMgrGroupInfo;
   j: Integer;
begin
   f := True;
   o := OutMgrSelectedItem;
   Found := o <> nil;
   ompAttach.Enabled := Found;
   ompPoll.Enabled := Found;
   ompBrowseNL.Enabled := Found;
   ompEditFreq.Enabled := Found;
   ompCreateFlag.Enabled := Found;
   if Found then begin
     h := Addr2Str(o.Address);
     if FidoOut.Paused(o.Address) then ompCfPause.Caption := 'Unpause'
                                  else ompCfPause.Caption := 'Pause'
   end else begin
      h := LngStr(rsMMOutCurNode);
   end;
   ompAttach.Caption := FormatLng(rsMMOutAttTo, [h]);
   ompPoll.Caption := FormatLng(rsMMOutPoll, [h]);
   ompBrowseNL.Caption := FormatLng(rsMMOutBrwsAt, [h]);
   ompEditFreq.Caption := FormatLng(rsMMOutEdFrq, [h]);
   ompCreateFlag.Caption := FormatLng(rsMMOutCrtFlg, [h]);

   for i := 0 to OutMgrPopup.Items.Count - 1 do begin
      m := OutMgrPopup.Items[i];
      if m.Tag < 1 then Continue;
      for j := 0 to ompCur.Count - 1 do begin
         m.Items[j].Caption := ompCur.Items[j].Caption;
      end;
      c := GetOutCollByTag(m.Tag, o, h, Info);
      if (c <> nil) and (m.Tag <> 1) then h := FormatLng(rsMMOutDoNItems, [h, c.Count]);
      m.Caption := h;
      if f then begin
         f := False;
         oe := (c <> nil) and xIsReg(ExtractFileExt(h));
         if oe then
            oo := h
         else
            oo := LngStr(rsMMOutCurFile);
         ompOpen.Caption := FormatLng(rsMMOutOpemItem, [oo]);
         ompOpen.Enabled := oe;
      end;
      FillOutMgrSubMenu(m, c, Info);
      CollDeleteAll(c);
      FreeObject(c);
   end;
end;

function TMailerForm.GetOutFileColl(FileMask: PString; NodeAdrr: PFidoAddress; OutStatus: POutStatus; var AInfo: TOutMgrGroupInfo): TOutFileColl;
var
   R: TOutFileColl;
   i,
   j: Integer;
   N: TOutNode;
   F: TOutFile;
begin
   AInfo.StatusesFound := [];
   AInfo.OutAttTypesFound := [];
   AInfo.AreBroken := False;
   AInfo.CanUnlink := False;
   R := nil;
   for i := 0 to CollMax(OutMgrNodes) do begin
      N := OutMgrNodes[i];
      if (OutStatus <> nil) and (not (OutStatus^ in N.FStatus)) then Continue;
      if (NodeAdrr <> nil) and (CompareAddrs(N.Address, NodeAdrr^) <> 0) then Continue;
      for j := 0 to CollMax(N.Files) do begin
         F := N.Files[j];
         if (OutStatus <> nil) and (OutStatus^ <> F.FStatus) then Continue;
         {>Вот тут bug<}
         if (FileMask <> nil) and (not MatchMask(F.Name, FileMask^)) then Continue;
         AInfo.AreBroken := AInfo.AreBroken or (F.Error <> 0);
         Include(AInfo.OutAttTypesFound, F.OutAttType);
         case F.FStatus of
         osImmed, osImmedMail: Include(AInfo.StatusesFound, osImmed);
         osCrash, osCrashMail: Include(AInfo.StatusesFound, osCrash);
         osDirect, osDirectMail: Include(AInfo.StatusesFound, osDirect);
         osNormal, osNormalMail: Include(AInfo.StatusesFound, osNormal);
         osHold, osHoldMail: Include(AInfo.StatusesFound, osHold);
         osHReq: Include(AInfo.StatusesFound, osHReq);
         end;
         if not AInfo.CanUnlink then
         case F.FStatus of
         osImmed,
         osCrash,
         osDirect,
         osNormal,
         osHold,
         osHReq: AInfo.CanUnLink := True;
         end;
         if R = nil then R := TOutFileColl.Create;
         R.Add(F);
      end;
   end;
   Result := R;
end;

function GetCollCurrentFile(AForm: TMailerForm; Item: TOutItem; var Caption: string; var AInfo: TOutMgrGroupInfo): TOutFileColl;
var
   F: TOutFile absolute Item;
begin
   Result := nil;
   if (Item = nil) or (Item is TOutNode) then begin
      Caption := LngStr(rsMMOutCurOfCur);
   end else
   if not (Item is TOutFile) then
      GlobalFail('%s', ['GetCollCurrentFile'])
   else begin
      if F.Name = '' then begin
         Caption := FormatLng(rsMMOutNFlag, [F.StatusString]);
         F.Name := Caption
      end else
         Caption := ExtractFileName(F.Name);
      Result := AForm.GetOutFileColl(@F.Name, @F.Address, @F.FStatus, AInfo);
   end;
end;

function GetCollByName(AForm: TMailerForm; Item: TOutItem; var Caption: string; var AInfo: TOutMgrGroupInfo): TOutFileColl;
var
   F: TOutFile absolute Item;
   Path,
   Name,
   Ext,
   s: string;
begin
   if (Item = nil) or (not (Item is TOutFile)) or (F.Name = '') then begin
      Caption := LngStr(rsMMOutSameFNm);
      Result := nil;
   end else begin
      FSplit(F.Name, Path, Name, Ext);
      s := Name + '.*';
      Caption := FormatLng(rsMMOutNofN, [s, Addr2Str(F.Address)]);
      s := Path + s;
      Result := AForm.GetOutFileColl(@s, @F.Address, nil, AInfo);
   end
end;

function GetCollByExt(AForm: TMailerForm; Item: TOutItem; var Caption: string; var AInfo: TOutMgrGroupInfo): TOutFileColl;
var
   F: TOutFile absolute Item;
   Path,
   Name,
   Ext,
   s: string;
begin
   Caption := '';
   Result := nil;
   if (Item <> nil) and (Item is TOutFile) and (F.Name <> '') then
      case F.FStatus of
      osImmed, osCrash, osDirect, osNormal, osHold:
         begin
            FSplit(F.Name, Path, Name, Ext);
            if IsArcMailExt(Ext) then
               s := '*' + Copy(Ext, 1, 3) + '?'
            else
               s := '*' + Ext;
            Caption := FormatLng(rsMMOutNofN, [s, Addr2Str(F.Address)]);
            s := Path + s;
            Result := AForm.GetOutFileColl(@s, @F.Address, nil, AInfo);
         end
      end;
   if Caption = '' then Caption := LngStr(rsMMOutSameFXt);
end;

function GetCollByStatus(AForm: TMailerForm; Item: TOutItem; var Caption: string; var AInfo: TOutMgrGroupInfo): TOutFileColl;
var
   F: TOutFile absolute Item;
begin
   Caption := '';
   Result := nil;
   if (Item <> nil) and (Item is TOutFile) then
   case F.FStatus of
   osImmed,
   osCrash,
   osDirect,
   osNormal,
   osHold:
      begin
         Caption := FormatLng(rsMMOutNFofN, [F.StatusString, Addr2Str(F.Address)]);
         Result := AForm.GetOutFileColl(nil, @F.Address, @F.FStatus, AInfo);
      end;
   end;
   if Caption = '' then Caption := LngStr(rsMMOutSameSt);
end;

function GetCollByNode(AForm: TMailerForm; Item: TOutItem; var Caption: string; var AInfo: TOutMgrGroupInfo): TOutFileColl;
begin
   if Item = nil then begin
      Caption := LngStr(rsMMOutEntrNode);
      Result := nil;
   end else begin
      Caption := FormatLng(rsMMOutNAofN, [Addr2Str(Item.Address)]);
      Result := AForm.GetOutFileColl(nil, @Item.Address, nil, AInfo);
   end
end;

function GetCollEntireOutbound(AForm: TMailerForm; Item: TOutItem; var Caption: string; var AInfo: TOutMgrGroupInfo): TOutFileColl;
begin
   Caption := LngStr(rsMMOutEntire);
   Result := AForm.GetOutFileColl(nil, nil, nil, AInfo);
end;

function TMailerForm.GetOutCollByTag(ATag: Integer; Item: TOutItem; var Caption: string; var AInfo: TOutMgrGroupInfo): TOutFileColl;
type
   TGetOutCollFunc = function(AForm: TMailerForm; Item: TOutItem; var Caption: string; var AInfo: TOutMgrGroupInfo): TOutFileColl;

const
   GetCollFuncs: array[0..6] of TGetOutCollFunc =
   (nil,
    GetCollCurrentFile,
    GetCollByName,
    GetCollByExt,
    GetCollByStatus,
    GetCollByNode,
    GetCollEntireOutbound
    );
begin
   AInfo.AreBroken := False;
   AInfo.CanUnlink := False;
   AInfo.StatusesFound := [];
   Result := GetCollFuncs[ATag](Self, Item, Caption, AInfo);
end;

procedure TMailerForm.FillOutMgrSubMenu(AMenu: TMenuItem; C: TOutFileColl; const AInfo: TOutMgrGroupInfo);
const
   idxReaddr = 0;
   idxFinalize = 1;
   idxImmed = 3;
   idxCrash = 4;
   idxDirect = 5;
   idxNormal = 6;
   idxHold = 7;
   idxUnlink = 9;
   idxPurge = 10;

var
   B: Boolean;
   I: Integer;

   procedure SetEnabledO(AE: Boolean);
   begin
      AMenu.Items[i].Enabled := AE;
   end;

   procedure SetEnabledA(S: TOutStatus);
   begin
      SetEnabledO(B and ([S] <> AInfo.StatusesFound) and (AInfo.StatusesFound <> []));
   end;

begin
   B := (C <> nil) and (oatBSO in AInfo.OutAttTypesFound);
   for i := 0 to AMenu.Count - 1 do begin
      case i of
      idxReaddr: SetEnabledO(B);
      idxFinalize: SetEnabledO(True);
      idxImmed: SetEnabledA(osImmed);
      idxCrash: SetEnabledA(osCrash);
      idxDirect: SetEnabledA(osDirect);
      idxNormal: SetEnabledA(osNormal);
      idxHold: SetEnabledA(osHold);
      idxUnlink: SetEnabledO(B and AInfo.CanUnLink);
      idxPurge: SetEnabledO(B and AInfo.AreBroken);
      end;
   end;
end;

procedure TMailerForm.bRereadClick(Sender: TObject);
begin
   RereadOutbound(true);
end;

procedure TMailerForm.opmReaddressClick(Sender: TObject);
begin
   OutOp(Sender, omoReaddr);
end;

procedure TMailerForm.opmFinalizeClick(Sender: TObject);
begin
   OutOp(Sender, omoKill);
end;

procedure TMailerForm.opmImmedClick(Sender: TObject);
begin
   OutOp(Sender, omo_Immed);
end;

procedure TMailerForm.opmCrashClick(Sender: TObject);
begin
   OutOp(Sender, omo_Crash);
end;

procedure TMailerForm.opmDirectClick(Sender: TObject);
begin
   OutOp(Sender, omo_Direct);
end;

procedure TMailerForm.opmNormalClick(Sender: TObject);
begin
   OutOp(Sender, omo_Normal);
end;

procedure TMailerForm.opmHoldClick(Sender: TObject);
begin
   OutOp(Sender, omo_Hold);
end;

procedure TMailerForm.opmPurgeClick(Sender: TObject);
begin
   OutOp(Sender, omoPurge);
end;

procedure TMailerForm.OutMgrPopupPopup(Sender: TObject);
begin
   UpdateOutboundCommands;
end;

procedure TMailerForm.OutOp(Sender: TObject; OpCode: TOutMgrOpCode);
begin
   if TMenuItem(Sender).Parent.Tag = 6 then begin
      if not (MessageBox(application.handle, 'This operation will be applied to the entire outbound. Do you want to continue?', 'Mailer', mb_OKCANCEL or MB_ICONQUESTION) = idok) then exit;
   end else begin
      case opcode of
      omoKill:
         if not (MessageBox(application.handle, 'This operation will delete one or more files. Do you want to continue?', 'Mailer', mb_OKCANCEL or MB_ICONQUESTION) = idok) then exit;
      omoUnlink:
         if not (MessageBox(application.handle, 'This operation will unlink one or more files. Do you want to continue?', 'Mailer', mb_OKCANCEL or MB_ICONQUESTION) = idok) then
            exit
      else
            ;
      end; {case}
   end;
   OutOpTag(OpCode, TMenuItem(Sender).Parent.Tag);
end;

procedure KillBoxes(c: TOutFileColl);
var i: integer;
    o: TOutFile;
begin
   for i := 0 to CollCount(c) - 1 do begin
      o := c[i];
      if o.OutAttType = oatFileBox then begin
         DelFile('KillBoxes', o.Name);
      end;
   end;
end;

procedure TMailerForm.OutOpTag(OpCode: TOutMgrOpCode; t: Integer);
var
   a: TFidoAddress;
   h: string;
   o: TOutItem;
   c: TOutFileColl;
   f: TColl;
   p: PFidoAddress;
   i: Integer;
   Info: TOutMgrGroupInfo;
begin
   o := OutMgrSelectedItem;
   if o = nil then Exit;
   OutMgrSelectedItemInstead := OutMgrOutline.SelectedItem;
   c := GetOutCollByTag(t, o, h, Info);
   if (opCode = omoKill) and (oatFileBox in Info.OutAttTypesFound) then KillBoxes(c);
   i := CollCount(c);
   f := OutFileColl2OutFileLists(c);
   CollDeleteAll(c);
   FreeObject(c);
   if OpCode <> omoReaddr then
      p := nil
   else begin
      FillChar(a, SizeOf(a), #0);
      if not InputSingleAddress(FormatLng(rsMMOutOpRAdr, [i]), a, nil) then Exit;
      p := @a;
      repeat
         if FidoOut.Lock(p^, osBusy, False) then Break;
         if WinDlg(FormatLng(rsMMOutIsBusy, [Addr2Str(p^)]), MB_ICONWARNING or MB_RETRYCANCEL, Handle) = idCancel then begin
            FreeObject(f);
            Exit;
         end;
      until False;
   end;
   if (t <> 6) or (YesNoConfirm(FormatLng(rsMMOutOpCmfEnt, [i]), Handle)) then PerformOutboundOperations(f, p, OpCode);
   if p <> nil then FidoOut.Unlock(p^, osBusy);
   FreeObject(f);
   RereadOutbound(false);
end;

procedure TMailerForm.AttachFiles(SC: TStringColl; const A: TFidoAddress);
var
   DoPoll: Boolean;
   Status: TOutStatus;
   K: TKillAction;
   s: string;
begin
   if not GetAttachStatusEx(Status, DoPoll, @K) then Exit;
   repeat
      if FidoOut.Lock(A, osBusy, False) then Break;
      if WinDlg(FormatLng(rsMMOutIsBusy, [Addr2Str(A)]), MB_ICONWARNING or MB_RETRYCANCEL, Handle) = idCancel then Exit;
   until False;
   if FidoOut.AttachFiles(A, SC, Status, K) then
      s := ''
   else
      s := GetErrorMsg;
   FidoOut.Unlock(A, osBusy);
   OutMgrSelectedItemInstead := OutMgrOutline.SelectedItem;
   if s <> '' then DisplayError(s, Handle);
   if DoPoll then InsertPollAddress(A);
   _RecalcPolls(True);
   RereadOutbound(false);
end;

procedure TMailerForm.AttachFilesQuery(const A: TFidoAddress);
var
   D: TOpenDialog;
   SC: TStringColl;
   i: Integer;
begin
   D := TOpenDialog.Create(Application);
   D.Title := LngStr(rsMMAttachCap);
   D.Filter := GetCompleteFilter;
   D.FilterIndex := CompleteFilterIndex;
   D.Options := [ofAllowMultiSelect, ofFileMustExist, ofPathMustExist, ofHideReadOnly];
   SC := nil;
   if (D.Execute) and (D.Files.Count > 0) then begin
      SC := TStringColl.Create;
      for i := 0 to D.Files.Count - 1 do begin
         SC.Add(D.Files[i]);
      end;
   end;
   FreeObject(D);
   if SC = nil then Exit;
   AttachFiles(SC, A);
   FreeObject(SC);
end;

procedure TMailerForm.ompAttachClick(Sender: TObject);
var
   A: TFidoAddress;
   o: TOutItem;
begin
   o := OutMgrSelectedItem;
   if o = nil then Exit;
   A := o.Address;
   AttachFilesQuery(A);
end;

procedure TMailerForm.ompPollClick(Sender: TObject);
var
   o: TOutItem;
   a: TFidoAddress;
begin
   o := OutMgrSelectedItem;
   if o = nil then Exit;
   a := o.Address;
   InsertPollAddress(a);
   _RecalcPolls(True);
end;

procedure TMailerForm.BrowseNodelistAt(const Addr: TFidoAddress);
begin
   if not BrowseAtNode(Addr) then DisplayError(FormatLng(rsMMNodeUndNdl, [Addr2Str(Addr)]), Handle);
end;

procedure TMailerForm.ompBrowseNLClick(Sender: TObject);
var
   o: TOutItem;
   a: TFidoAddress;
begin
   o := OutMgrSelectedItem;
   if o = nil then Exit;
   a := o.Address;
   BrowseNodelistAt(a);
end;

procedure TMailerForm.opmUnlinkClick(Sender: TObject);
begin
   OutOp(Sender, omoUnlink);
end;

procedure TMailerForm.FormActivate(Sender: TObject);
begin
   if Activated then Exit;
   DragAcceptFiles(OutMgrOutline.Handle, True);
   DragAcceptFiles(PollsListView.Handle, True);
   Activated := True;
   if Application.MainForm = Self then begin
      SendMsg(WM_IMPORTDUPOVRL);
      SendMsg(WM_IMPORTIPOVRL);
      TrayIcon := TTrayIcon.Create(Self);
      TrayIcon.Hint := 'Taurus';
      TrayIcon.Icon := Application.Icon;
      TrayIcon.PopupMenu := TrayPopupMenu;
      TrayIcon.SeparateIcon := IniFile.AlwaysInTray;
      //    TrayIcon.OnDblClick := TrayIconDblClick;
      TrayIcon.OnClick := TrayIconClick;
      TrayIcon.OnMinimize := TrayIconMinimize;
      TrayIcon.Active := not IniFile.Stealth;
      if FStartMinimized and not IniFile.Stealth then PostMessage(Handle, WM_APPMINIMIZE, 0, 0);
      PostMsg(WM_IMPORTPWDL);
      WMCLOSE := false;
      uTaskbarRestart := RegisterWindowMessage('TaskbarCreated');
   end
end;

procedure TMailerForm.OutMgrOutlineApiDropFiles(Sender: TObject);
var
   A,
  OA: TFidoAddress;
   o: TOutItem;
   p: PFidoAddress;
   i: Integer;
begin
   SetForegroundWindow(Handle);
   if OutMgrOutline.DroppedFiles = nil then Exit;
   i := OutMgrOutline.GetItem(OutMgrOutline.DropPoint.X, OutMgrOutline.DropPoint.Y);
   if i <> -1 then OutMgrOutline.SelectedItem := i;
   o := OutMgrSelectedItem;
   if o = nil then
      p := nil
   else begin
      OA := o.Address;
      p := @OA
   end;
   FillChar(A, SizeOf(A), #0);
   if not InputSingleAddress(FormatLng(rsMMAttachIA, [OutMgrOutline.DroppedFiles.Count]), A, p) then Exit;
   AttachFiles(OutMgrOutline.DroppedFiles, A);
   FreeObject(OutMgrOutline.DroppedFiles);
end;

procedure TMailerForm.PollsListViewApiDropFiles(Sender: TObject);
var
   A,
  OA: TFidoAddress;
   o: TListItem;
   p: PFidoAddress;
begin
   SetForegroundWindow(Handle);
   if PollsListView.DroppedFiles = nil then Exit;
   o := PollsListView.GetItemAt(PollsListView.DropPoint.X, PollsListView.DropPoint.Y);
   if o <> nil  then begin
      ParseAddress(o.Caption, OA);
      p := @OA;
      FillChar(A, SizeOf(A), #0);
      if not InputSingleAddress(FormatLng(rsMMAttachIA, [PollsListView.DroppedFiles.Count]), A, p) then Exit;
      AttachFiles(PollsListView.DroppedFiles, A);
   end;
   FreeObject(PollsListView.DroppedFiles);
end;

procedure TMailerForm.ompEditFreqClick(Sender: TObject);
var
   o: TOutItem;
   a: TFidoAddress;
begin
   o := OutMgrSelectedItem;
   if o = nil then Exit;
   a := o.Address;
   EditFileRequestEx(a);
end;

procedure TMailerForm.mtAttachFilesClick(Sender: TObject);
var
   AA: TFidoAddress;
begin
   FillChar(AA, SizeOf(AA), #0);
   if not InputSingleAddress(LngStr(rsMMAttachTA), AA, nil) then Exit;
   AttachFilesQuery(AA);
end;

procedure TMailerForm.InvokeOutMgrSmartMenu;
begin
   OutMgrOutline.PopupMenu.Popup(Screen.Width div 4, Screen.Height div 4);
end;

procedure TMailerForm.mtOutSmartMenuClick(Sender: TObject);
begin
   InvokeOutMgrSmartMenu;
end;

procedure TMailerForm.mtBrowseNodelistAtClick(Sender: TObject);
var
   AA: TFidoAddress;
begin
   FillChar(AA, SizeOf(AA), #0);
   if not InputSingleAddress(LngStr(rsMMBrsNdlAt), AA, nil) then Exit;
   AA.Domain := FindFTNDOM(AA);
   BrowseNodelistAt(AA);
end;

procedure TMailerForm.ompOpenClick(Sender: TObject);
var
   o: TOutItem;
   s: string;
begin
   o := OutMgrSelectedItem;
   if (o = nil) or (not (o is TOutFile)) then Exit;
   if o.Status = osRequest then begin
      EditFileRequestEx(o.Address);
      Exit;
   end;
   s := o.Name;
   if not xIsReg(ExtractFileExt(s)) then Exit;
   ShellExecute(Handle, { handle to parent window }
      nil, { pointer to string that specifies operation to perform }
      PChar(s),
      nil, { pointer to string that specifies executable-file parameters }
      nil, { pointer to string that specifies default directory }
      SW_SHOWNORMAL);

end;

procedure TMailerForm.OutMgrOutlineKeyDown(Sender: TObject; var Key: Word;
   Shift: TShiftState);
begin
   case Key of
   VK_RETURN: ompOpenClick(nil);
   VK_DELETE: OutOpTag(omoKill, 1); // 1 means current file
   end;
end;

procedure TMailerForm.ompCreateFileFlag(os: TOutStatus);
var
   o: TOutItem;
   Addr: TFidoAddress;
begin
   o := OutMgrSelectedItem;
   if o = nil then Exit;
   Addr := o.Address;
   CreateOutFileFlag(Addr, os);
   _RecalcPolls(True);
   RereadOutbound(false);
end;

procedure TMailerForm.ompCfImmedClick(Sender: TObject);
begin
   ompCreateFileFlag(osImmed);
end;

procedure TMailerForm.ompCfCrashClick(Sender: TObject);
begin
   ompCreateFileFlag(osCrash);
end;

procedure TMailerForm.ompCfDirectClick(Sender: TObject);
begin
   ompCreateFileFlag(osDirect);
end;

procedure TMailerForm.ompCfNormalClick(Sender: TObject);
begin
   ompCreateFileFlag(osNormal);
end;

procedure TMailerForm.ompCfHoldClick(Sender: TObject);
begin
   ompCreateFileFlag(osHold);
end;

procedure TMailerForm.PollPopupMenuPopup(Sender: TObject);
begin
   UpdateView(false);
end;

procedure TMailerForm.PollsListViewKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   case Key of
   VK_RETURN: bTracePollClick(nil);
   VK_DELETE: bDeletePollClick(nil);
   end;
end;

procedure TMailerForm.PollsListViewDblClick(Sender: TObject);
begin
   bTracePoll.Click;
end;

procedure TMailerForm.mtCreateFlagClick(Sender: TObject);
var
   Status: TOutStatus;
   DoPoll: Boolean;
   L: TFidoAddrColl;
   i: Integer;
   A: TFidoAddress;
begin
   L := InputFidoAddress(LngStr(rsMMCrtFF), True, nil);
   if L = nil then Exit;
   if not GetAttachStatusEx(Status, DoPoll, nil) then begin
      FreeObject(L);
      Exit;
   end;
   for i := 0 to CollMax(L) do begin
      A := L[i];
      CreateOutFileFlag(A, Status);
      if DoPoll then InsertPollAddress(A);
   end;
   _RecalcPolls(True);
   RereadOutbound(false);
   FreeObject(L);
end;

procedure TMailerForm.WndProc(var M: TMessage);
begin
   WindCounter := 0;
   if csDesigning in ComponentState then begin
      inherited WndProc(M);
      Exit;
   end;
   try
      if (Application.MainForm <> nil) and (TrayIcon <> nil) then begin
         if (Application.MainForm = Self) and (M.Msg = uTaskbarRestart) then begin
            TrayIcon.fNoTrayIcon := True;
            TrayIcon.AddIconToTray;
            Exit;
         end else
         if (Application.MainForm = Self) and (M.Msg = WM_SYSCOMMAND) and (M.WParam = SC_MINIMIZE) then begin
            TrayIcon.Active := not IniFile.Stealth;
            TNum := MainTabControl.TabIndex;
            TNam := MainTabControl.Tabs[MainTabControl.TabIndex];
            TAct := ActiveLine;
         end;
      end; // else exit;
      inherited WndProc(M);
   except on E: Exception do //ProcessTrap(E.Message+'(Message: '+IntToStr(M.Msg)+')', 'TMailerForm.WndProc');
   end;
end;

procedure TMailerForm.UpdatePollOptions;
var
   r: TPollOptionsData;
begin
   CfgEnter;
   r := Cfg.PollOptions.Copy;
   CfgLeave;
   EnterFidoPolls;
   Xchg(Integer(FidoPolls.Options), Integer(r));
   LeaveFidoPolls;
   FreeObject(r);
end;

procedure TMailerForm.mcPollsClick(Sender: TObject);
begin
   if ConfigurePolls then begin
      CronThr.Recalc := True;
      UpdatePollOptions;
   end;
end;

procedure TMailerForm.mlSendMdmCmdsClick(Sender: TObject);
begin
   InsertEvt(TMlrEvtEnterMdmCmds.Create(Handle));
end;

procedure TMailerForm.mcFileBoxesClick(Sender: TObject);
begin
   SetupFileBoxes;
end;

procedure TMailerForm.maNodesClick(Sender: TObject);
begin
   InvokeNodeWizzard;
end;

procedure TMailerForm.ompHelpClick(Sender: TObject);
begin
   Application.HelpContext(OutMgrPopup.HelpContext);
end;

procedure DoHelp(Handle: THandle; Command, Data: DWORD);
var
   R: Integer;
begin
   if IsHtmlHelp and (not HtmlHelpLibError) then begin
      R := 0;
      if not HelpInitialized then begin
         HelpInitialized := True;
         R := HtmlHelp(Handle, '', HH_INITIALIZE, 0);
      end;
      if R = 0 then
      case Command of
      HELP_CONTENTS:
         begin
            R := HtmlHelp(Handle, Application.HelpFile, HH_DISPLAY_TOC, 0);
         end;
      HELP_CONTEXT:
         begin
            R := HtmlHelp(Handle, Application.HelpFile, HH_HELP_CONTEXT, Data)
         end;
      end;
      if (R = -1) and (HtmlHelpLibError) then begin
         InitHelp;
         DoHelp(Handle, Command, Data);
      end;
   end else begin
      WinHelp(Handle, PChar(Application.HelpFile), Command, Data);
   end;
end;

function TMailerForm.FormHelp(Command: Word; Data: Integer; var CallHelp: Boolean): Boolean;
begin
   if not HelpDone then begin
     if Screen.ActiveForm is TMailerForm then begin
       case Integer(ActiveLine) of
       Integer(PanelOwnerDaemon): Data := IDH_INTRODAEMON;
       Integer(PanelOwnerPolls): Data := IDH_POLLMGRDESCR;
       Integer(PanelOwnerOutMgr): Data := IDH_OUTBOUND;
       Integer(PanelOwnerSystem): Data := IDH_SYSTEM;
       else
         Data := IDH_MLRD;
       end; {of case}
     end;
     DoHelp(0, Command, Data);
   end;
   CallHelp := False;
   Result := True;
end;

procedure TMailerForm.tpCreateNormalPollClick(Sender: TObject);
var
   L: TFidoAddrColl;
   i: Integer;
   A: TFidoAddress;
   doit : boolean;
begin
   doit := TrayIcon.Minimized;
   if doit then RestoreFromTray;
   L := InputFidoAddress(LngStr(rsMMCrtFF), True, nil);
   if L <> nil then begin
     for i := 0 to CollMax(L) do begin
        A := L[i];
        CreateOutFileFlag(A, oscrash);
     end;
     _RecalcPolls(True);
     RereadOutbound(false);
     FreeObject(L);
   end;
   if doit then Application.Minimize;
end;

procedure TMailerForm.mpPauseClick(Sender: TObject);
var
   p: TFidoPoll;
  li: TListItem;
   i: Integer;
   s: string;
   a: TFidoAddress;
begin
   li := PollsListView.ItemFocused;
   if li <> nil then begin
      s := li.Caption;
      if not ParseAddress(s, a) then GlobalFail('TMailerForm.mpPauseClick, failed to parse "%s"', [s]);
      EnterFidoPolls;
      for i := 0 to FidoPolls.Count - 1 do begin
         p := FidoPolls[i];
         if CompareAddrs(a, p.Node.Addr) = 0 then begin
            if not FidoOut.Paused(P.Node.Addr) then begin
               FidoOut.Pause(P.Node.Addr);
               s := Format('Poll to %s is paused', [Addr2Str(p.Node.Addr)]);
            end else begin
               FidoOut.Unpause(P.Node.Addr);
               s := Format('Poll to %s is unpaused', [Addr2Str(p.Node.Addr)]);
            end;
            FidoPolls.Log.LogSelf(s);
            _RecalcPolls(True);
            Break;
         end;
      end;
      LeaveFidoPolls;
   end;
   PostMsg(WM_UPDATEVIEW);
end;

procedure TMailerForm.ompCfPauseClick(Sender: TObject);
var
   o: TOutItem;
   Addr: TFidoAddress;
begin
   o := OutMgrSelectedItem;
   if o = nil then Exit;
   Addr := o.Address;
   if not FidoOut.Paused(Addr) then
      FidoOut.Pause(Addr)
   else
      FidoOut.Unpause(Addr);
end;

procedure TMailerForm.TrayPopupMenuPopup(Sender: TObject);
begin
   tpRestore.Enabled := TrayIcon.Minimized;
   tpMinimize.Enabled := not TrayIcon.Minimized;
end;

procedure TMailerForm.mfRestartClick(Sender: TObject);
begin
   StoreConfig(0);
   ShellExecute(0, nil, PChar(ParamStr(0)),
      PChar('delay9000'), PChar(ExtractFilePath(ParamStr(0))), sw_shownormal);
   PostCloseMessage;
end;

procedure TMailerForm.bwListBoxClick(Sender: TObject);
var
   i: integer;
begin
   BWZColl.Enter;
   BWZColl.Update;
   if bwListView.ItemFocused <> nil then begin
      i := bwListView.ItemFocused.Index;
      if (i >= 0) and (i < BWZColl.Count) then BWZColl[i] else UpdateBWZListBox;
   end;
   BWZColl.Update;
   BWZColl.Leave;
end;

procedure TMailerForm.bbDeleteClick(Sender: TObject);
var
   r: TBWZRec;
begin
   if bwListView.ItemFocused = nil then exit;
   BWZColl.Enter;
   BWZColl.Update;
   if BWZColl.Count - 1 < bwListView.ItemFocused.Index then exit;

   try
      if bwListView.ItemFocused <> nil then
         r := BWZColl[bwListView.ItemFocused.Index]
      else begin
         BWZColl.Update;
         BWZColl.Leave;
         UpdateBWZListBox;
         exit;
      end;
   except
      BWZColl.Update;
      BWZColl.Leave;
      UpdateBWZListBox;
      exit;
   end;

   BWZColl.Update;
   BWZColl.Leave;

   if FileExists(r.GetBWZFName) then DeleteFile(r.GetBWZFName);
   FreeBWZ(r);
   BWZColl.Update;
   FillBWListBox;
end;

procedure TMailerForm.SetHKSpace(x: boolean);
begin
   if x then
      mlResetTimeOut.ShortCut := ShortCut(Word(' '), [])
   else
      mlResetTimeOut.ShortCut := 16418;
end;

procedure SetFontSize(c: TComponent; s: integer);
var
   i: integer;
   w: TComponent;
begin
   for i := 0 to c.ComponentCount - 1 do begin
      w := c.Components[i];
      if w is TLabel then begin
         if (w as TLabel).Font.Name <> 'Small Fonts' then begin
            (w as TLabel).Font.Size := s;
         end; 
      end else begin
         SetFontSize(w, s);
      end;
   end;
end;

procedure TMailerForm.SetColors;
begin
   if MailerForms = nil then Exit;
   SetFontSize(Self, Font.Size);
   SndTot.BackColor := IniFile.GaugeBack;
   RcvTot.BackColor := IniFile.GaugeBack;
   SndTot.ForeColor := IniFile.GaugeFore;
   RcvTot.ForeColor := IniFile.GaugeFore;
   bwListView.Color := IniFile.BadWazooBack;
   bwListView.Font.Color := IniFile.BadWazooFore;
   stListView.Color := IniFile.BadWazooBack;
   stListView.Font.Color := IniFile.BadWazooFore;
   evListView.Color := IniFile.BadWazooBack;
   evListView.Font.Color := IniFile.BadWazooFore;
   LogBox.Color := IniFile.LoggerBack;
   LogBox.Brush.Color := IniFile.LoggerBack;
   LogBox.Font.Color := IniFile.LoggerFore;
   LogBox.Font.Name := IniFile.LoggerFontName;
   LogBox.Font.Size := IniFile.LoggerFontSize;
   LogBox.Font.Style := [];
   if IniFile.LoggerFontAttr[1] = '1' then LogBox.Font.Style := LogBox.Font.Style + [fsBold];
   if IniFile.LoggerFontAttr[2] = '1' then LogBox.Font.Style := LogBox.Font.Style + [fsItalic];
   if IniFile.LoggerFontAttr[3] = '1' then LogBox.Font.Style := LogBox.Font.Style + [fsUnderline];
   if IniFile.LoggerFontAttr[4] = '1' then LogBox.Font.Style := LogBox.Font.Style + [fsStrikeOut];
   LogBox.Text := '';
   LogBox.DoPaint(true);
   LInfo1.Font.Assign(LogBox.Font);
   LInfo2.Font.Assign(LogBox.Font);
   PollBtnPanel.Color := LogBox.Color;
   SystemBtnPanel.Color := LogBox.Color;
end;

procedure TMailerForm.pBWZPopup(Sender: TObject);
begin
   if BWListView.ItemFocused <> nil then begin
      mnuDelBWZ.Enabled := true;
      mnuDelBWZ.Caption := LngStr(rsDeleteFromBWZ);
      mnuDelBWZ.Caption := Format(mnuDelBWZ.Caption, [BWListView.Items.Item[BWListView.ItemFocused.Index].Caption]);
   end else
      mnuDelBWZ.Enabled := false;
end;

procedure TMailerForm.mnuTossBwzClick(Sender: TObject);
begin
   ActiveLine.TossBWZ(true);
end;

procedure TMailerForm.mnuArgusCloneClick(Sender: TObject);
begin
   ShellExecute(Handle, { handle to parent window }
      nil, { pointer to string that specifies operation to perform }
      'http://www.umans.ru/argus/',
      nil, { pointer to string that specifies executable-file parameters }
      nil, { pointer to string that specifies default directory }
      SW_SHOWNORMAL);
end;

procedure TMailerForm.mnuRadiusOnWebClick(Sender: TObject);
begin
   ShellExecute(Handle,
      nil,
      'http://taurus.rinet.ru/',
      nil,
      nil,
      SW_SHOWNORMAL);
end;

procedure TMailerForm.CancelButtonClick(Sender: TObject);
begin
   if RASProcess then begin
      RASProcess := False;
      FidoPollsLog('RAS event finished (cancelled by operator)');
   end;
   sendmessage(MainWinHandle, WM_RASDISCONNECT, 0, 0);
end;

procedure TMailerForm.mnuTerminalClick(Sender: TObject);
begin
   InsertEvt(TMlrEvtExecTerminal.Create(Handle));
end;

procedure TMailerForm.ConnectButtonClick(Sender: TObject);
begin
   RASSoundsON := IniFile.PlaySounds;
   if RASThread <> nil then RasThread.Connect(True);
end;

procedure TMailerForm.mnuPrefExClick(Sender: TObject);
begin
   SetPrefEx(TMenuItem(Sender).ShortCut = 7007);
end;

procedure TMailerForm.ChatPanResize(Sender: TObject);
begin
   ChatMemo1.Height := Panel15.Height div 2;
end;

procedure TMailerForm.eTypeKeyPress(Sender: TObject; var Key: Char);
begin
   ActiveLine.SD.Prot.Chat.LastKey := Time();
   if Key = #27 then begin
      ActiveLine.SD.Prot.Chat.Visible := False;
      exit;
      Key := #0;
   end;
   if Key = #13 then begin
     ActiveLine.SD.Prot.Chat.ChatStr :=
     ActiveLine.SD.Prot.Chat.ChatStr + Win2Dos(eType.Text) + #10;
     ActiveLine.SD.Prot.Chat.DispStr := ActiveLine.SD.Prot.Chat.ChatStr;
     Delete(ActiveLine.SD.Prot.Chat.DispStr, length(ActiveLine.SD.Prot.Chat.DispStr), 1);
     eType.Text := '';
     Key := #0;
   end;
end;

procedure TMailerForm.sbCloseChatClick(Sender: TObject);
begin
   ActiveLine.SD.Prot.Chat.Visible := False;
end;

procedure TMailerForm.ChatMemo2KeyPress(Sender: TObject; var Key: Char);
begin
   if Key = #27 then begin
      ActiveLine.SD.Prot.Chat.Visible := False;
      exit;
      Key := #0;
   end;
end;

procedure TMailerForm.gTabCntChange(Sender: TObject);
begin
   case (Sender as TTabControl).TabIndex of
  -1:
      begin
        (Sender as TTabControl).TabIndex := 0;
      end;
   0:
      begin
         gLst.Visible := False;
      end;
   1:
      begin
         gLst.Visible := True;
      end;
   end;
end;

procedure TMailerForm.SplitterAPanelMoved(Sender: TObject);
begin
   TermTx.Width := TermsPanel.Width - TermTx.Left - 5;
   TermRx.Width := TermsPanel.Width - TermRx.Left - 5;
end;

procedure TMailerForm.SplitterBPanelMoved(Sender: TObject);
begin
   SndTot.Left := Panel2.Width - SndTot.Width - 24;
   RcvTot.Left := Panel2.Width - RcvTot.Width - 24;
end;

procedure TMailerForm.LNameClick(Sender: TObject);
var
   v: TLogViewer;
begin
   v := TLogViewer.Create(Application);
   v.LogName := MakeNormName(dLog, StripHotKey((Sender as TMenuItem).Caption));
   v.ShowModal;
   v.Free;
end;

procedure TMailerForm.ChatCaptionPanConstrainedResize(Sender: TObject;
  var MinWidth, MinHeight, MaxWidth, MaxHeight: Integer);
begin
   sbCloseChat.Top  := 2;
   sbCloseChat.Height := ChatCaptionPan.ClientHeight - 2;
   sbCloseChat.Width := GetSystemMetrics(SM_CXVSCROLL);
   sbCloseChat.Left := ChatCaptionPan.ClientWidth - sbCloseChat.Width - 2;
end;

procedure TMailerForm.gLstRowDelete(Sender: TObject; xRow: Integer);
begin
   if xRow > 1 then begin
      ActiveLine.SD.Prot.ListBuf.Add('LST DEL ' + (Sender as TAdvGrid).Cells[1, xRow]);
   end;
end;

procedure TMailerForm.gLstRowMoved(Sender: TObject; FromIndex, ToIndex: Integer);
begin
   ActiveLine.SD.Prot.ListBuf.Add('LST MOV ' + (Sender as TAdvGrid).Cells[1, FromIndex] + ' ' + IntToStr(FromIndex - ToIndex));
end;

procedure TMailerForm.mnuClockClick(Sender: TObject);
begin
   if Sender <> nil then begin
      IniFile.ClockVisible := not IniFile.ClockVisible;
   end;   
   evListView.Visible := not IniFile.ClockVisible;
   Clock.ClockEnabled :=     IniFile.ClockVisible;
   mnuClock.Checked := IniFile.ClockVisible;
end;

procedure TMailerForm.evListViewClick(Sender: TObject);
var
  oe,
  ne: TEventContainer;
  ev: TEventColl;
   i: Integer;
   n: Integer;
begin
   if evListView.ItemFocused = nil then exit;
   Ev := TEventColl.Create;
   Cfg.Events.AppendTo(Ev);
   i := evListView.ItemFocused.Index;
   try
      if i > -1 then begin
         for n := 0 to CollMax(Ev) do begin
            oe := Ev[n];
            if oe.FName = evListView.Items[i].Caption then begin
               ne := Pointer(oe.Copy);
               if not EditEvent(ne) then FreeObject(ne) else begin
                  Ev[n] := ne;
                  FreeObject(oe);
                  CfgEnter;
                  XChg(Integer(Cfg.Events), Integer(Ev));
                  CfgLeave;
                  StoreConfig(Handle);
                  EventsThr.DoRecalc;
               end;
               exit;
            end;
         end;
      end;
   finally
      FreeObject(Ev);
   end;
end;

procedure TMailerForm.evListViewCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
begin
   if Item1.SubItems[0] > Item2.SubItems[0] then Compare := +1 else
   if Item1.SubItems[0] < Item2.SubItems[0] then Compare := -1 else
   if Item1.Caption     > Item2.Caption     then Compare := +1 else
   if Item1.Caption     < Item2.Caption     then Compare := -1 else
                                                 Compare := 00;
end;

procedure TMailerForm.New1Click(Sender: TObject);
var
   e: TEventContainer;
  ev: TEventColl;
begin
   Ev := TEventColl.Create;
   Cfg.Events.AppendTo(Ev);
   e := TEventContainer.Create;
   if not EditEvent(e) then FreeObject(e) else begin
      e.Id := Ev.GetUnusedId;
      Ev.Insert(e);
      CfgEnter;
      XChg(Integer(Cfg.Events),Integer(Ev));
      CfgLeave;
      StoreConfig(Handle);
      EventsThr.DoRecalc;
   end;
   FreeObject(Ev);
end;

end.
