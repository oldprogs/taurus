unit xMisc;

{$I DEFINE.INC}

interface

uses Windows, Classes, xBase, xFido, RadIni, MClasses, Outbound, xDes;

const
  {Convenient character constants (and aliases)}
  cNul = 0;
  cSoh = 1;
  cStx = 2;
  cEtx = 3;
  cEot = 4;
  cEnq = 5;        ccEnq = Char(cEnq);
  cAck = 6;        ccAck = Char(cAck);
  cBel = 7;
  cBS  = 8;
  cTab = 9;
  cLF  = 10;       ccLF = #10;
  cVT  = 11;
  cFF  = 12;
  cCR  = 13;       ccCR = #13;
  cSO  = 14;
  cSI  = 15;
  cDle = 16;
  cDC1 = 17;       cXon  = 17;
  cDC2 = 18;
  cDC3 = 19;       cXoff = 19;
  cDC4 = 20;
  cNak = 21;
  cSyn = 22;
  cEtb = 23;
  cCan = 24;
  cEM  = 25;
  cSub = 26;
  cEsc = 27;
  cFS  = 28;
  cGS  = 29;
  cRS  = 30;
  cUS  = 31;

  cYooHooHdr = $1f; ccYooHooHdr = Char(cYooHooHdr);
  cYooHoo = $f1; ccYooHoo = Char(cYooHoo);
  cTSync  = $ae; ccTSync = Char(cTSync);

//  CPS_MinBytes = $100;
//  CPS_MinSecs = 1; // 10 seconds

  ZAutoStr = ^X'B00';

  DefHandshakeRetry = 10;   {Number of times to retry handshake}

  ModemTraceMask = EV_CTS or EV_DSR or EV_RING {$IFNDEF RLSD} or EV_RLSD {$ENDIF};

  { Additional modem status bits }
   MS_TXD_ON = DWORD($0100);
   MS_RXD_ON = DWORD($0200);

   FadeTicks = 5;

  CE_MsgNum = 11;
  CE_Msg : array[0..CE_MsgNum - 1] of record i: Integer; s: string end = (
    (i: CE_BREAK;    s: 'CE_BREAK'),    // The hardware detected a break condition.
    (i: CE_DNS;      s: 'CE_DNS'),      // Windows 95 only: A parallel device is not selected.
    (i: CE_FRAME;    s: 'CE_FRAME'),    // The hardware detected a framing error.
    (i: CE_IOE;      s: 'CE_IOE'),      // An I/O error occurred during communications with the device.
    (i: CE_MODE;     s: 'CE_MODE'),     // The requested mode is not supported, or the hFile parameter is invalid. If this value is specified, it is the only valid error.
    (i: CE_OOP;      s: 'CE_OOP'),      // Windows 95 only: A parallel device signaled that it is out of paper.
    (i: CE_OVERRUN;  s: 'CE_OVERRUN'),  // A character-buffer overrun has occurred. The next character is lost.
    (i: CE_PTO;      s: 'CE_PTO'),      // Windows 95 only: A time-out occurred on a parallel device.
    (i: CE_RXOVER;   s: 'CE_RXOVER'),   // An input buffer overflow has occurred. There is either no room in the input buffer, or a character was received after the end-of-file (EOF) character.
    (i: CE_RXPARITY; s: 'CE_RXPARITY'), // The hardware detected a parity error.
    (i: CE_TXFULL;   s: 'CE_TXFULL')    // The application tried to transmit a character, but the output buffer
  );

type

  TComError = class
    Err: DWORD;
    cs: TComStat;
  end;

  TProtocolError = (
    ecOK,
    ecTimeout,               {Fatal time out}
    ecAbortNoCarrier,        {Aborting due to carrier loss}
    ecAbortByRemote,         {Transfer aborted by remote console}
    ecAbortByLocal,          {Transfer aborted by local console}
    ecIncompatibleLink,      {Incompatible protocol options on this link}
    ecTooManyErrors          {Too many errors during protocol}
  );

const
  SProtocolError : array[TProtocolError] of string = (
   'OkiDoki',
   'Fatal time out',
   'Aborting due to carrier loss',
   'Transfer aborted by remote',
   'Transfer aborted',
   'Incompatible protocol options on this link',
   'Disconnect reason is fatal error'
  );

type
  TTransferStreamType = (
    xstUndefined,
    xstUnknown,
    xstOut,
    xstInDiskFileNew,
    xstInDiskFileAppend,
    xstInMemREQ,
    xstInMemPKT,
    xstInMemCLB
  );

  TTransferFileAction = (aaOK , aaRefuse, aaAcceptLater, aaAcceptLater_r, aaSysError, aaAbort);

  TDialState = (dsUnknown, dsIdle, dsDialing, dsRinging, dsAnswering, dsConnected);

  TSignalType = (stRead, stWrite);
  TSignalTypeSet = set of TSignalType;

  {For specifying log file calls}
  TLogFileStatus = (
    lfUndefined,

  { file i/o }
    lfBadPkt,            // Bad packet received
    lfBadEOF,            // Bad EOF received
    lfBadCRC,            // Bad CRC received

    lfSendSync,          // Transmit resuming file (...transmitting from ofs)
    lfSendSeek,          // ...resending from offset

  { batch }
    lfBatchSendEnd,
    lfBatchReceEnd,

  { session }
    lfBatchesDone,

{$IFDEF BINKP}
  { BinkP }
    lfBinkPBadKey,
    lfBinkPgInKey,
    lfBinkPgOutKey,
    lfBinkPgAddr,
    lfBinkPgPwd,
    lfBinkPNul,
    lfBinkPErr,
    lfBinkPUnrec,
    lfBinkPPwd,
    lfBinkPAddr,
    lfNodePassw,
    lfBinkPNiaE,
    lfBinkPCRAM,
{$ENDIF}

  { hydra }
    lfHydraNfo,
    lfHydraMsg,

  { debug }
    lfDebug,
    lfLog,

    lfTimeout,
    lfNAK,
    lfBadHdr,

    lf1Prog,
    lf1Addr,
    lf1PCode,
    lf1Pwd,
    lfChat,
    lfGZIP,
    lfPZIP,
    lfDYNA,
    lfNZIP,
    lfCRYP,
    lfBREK,

    lfDelete

  );

  TProtocolStatus = (
    psOK                 ,  {Protocol is ok}
    psProtocolHandshake  ,  {Protocol handshaking in progress}
    psInvalidDate        ,  {Bad date/time stamp received and ignored}
    psFileRejected       ,  {Incoming file was rejected}
    psFileRenamed        ,  {Incoming file was renamed}
    psSkipFile           ,  {Incoming file was skipped}
    psFileDoesntExist    ,  {Incoming file doesn't exist locally, skipped}
    psCantWriteFile      ,  {Incoming file skipped due to Zmodem options}
    psTimeout            ,  {Timed out waiting for something}
    psBlockCheckError    ,  {Bad checksum or CRC}
    psLongPacket         ,  {Block too long}
    psDuplicateBlock     ,  {Duplicate block received and ignored}    {!!.02}
    psProtocolError      ,  {Error in protocol}
    psAbortByRemote      ,  {Cancel requested}
    psAbortByLocal       ,  {Cancel requested}
    psEndFile            ,  {At end of file}
    psResumeBad          ,  {B+ host refused resume request}
    psSequenceError      ,  {Block was out of sequence}
    psAbortNoCarrier     ,  {Aborting on carrier loss}
    {Specific to certain protocols}
    psGotCrcE            ,  {Got CrcE packet (Zmodem)}
    psGotCrcG            ,  {Got CrcG packet (Zmodem)}
    psGotCrcW            ,  {Got CrcW packet (Zmodem)}
    psGotCrcQ            ,  {Got CrcQ packet (Zmodem)}
    psTryResume          ,  {B+ is trying to resume a download}
    psHostResume         ,  {B+ host is resuming}
    psWaitAck            ,  {Waiting for B+ ack (internal)}

    {Internal}
    psNoHeader           , {Protocol is waiting for header (internal)}
    psGotHeader          , {Protocol has header (internal)}
    psGotData            , {Protocol has data packet (internal)}
    psNoData               {Protocol doesn't have data packet yet (internal)}
  );

  {Constants for supported protocol types}
type
  TProtocolType = (
                   piAscii,
                   piBinkP,
      {$IFDEF EXTREME}
                   piFTP,
                   piHTTP,
                   piPOP3,
                   piSMTP,
                   piGATE,
                   piNNTP,
                   piRCC,
      {$ENDIF}
                   piBPlus,
                   piFTS1,
                   piHydra,
                   piJanus,
                   piKermit,
                   piNiagara,
                   piXmodem,
                   piXmodemCRC,
                   piXmodem1K,
                   piXmodem1KG,
                   piYmodem,
                   piYmodemG,
                   piZmodem,
                   piZmodem8K,
                   piZmodem8KD,
                   piError
                   );

  {Block check codes}
  TBlockCheckType = (bcNone,             {No block checking}
                     bcChecksum1,        {Basic checksum}
                     bcChecksum2,        {Two byte checksum}
                     bcCrc16,            {16 bit Crc}
                     bcCrc32,            {32 bit Crc}
                     bcCrcK);            {Kermit style Crc}

const
  PortMinBufRead      =  $200;
  PortInBufSize       = $1000;
  PortOutBufSize      = $8000;
  PortWriteBlockSize  = $0400;
  PortChrBufSize      = $0800;

  CheckTypeStrs : array[TBlockCheckType] of string = (
    'None', 'Checksum', 'Checksum2', 'Crc16', 'Crc32', 'CrcKermit'
  );

  ProtocolNames : array[TProtocolType] of string = (
    'Ascii',
    'BinkP',
    {$IFDEF EXTREME}
    'FTP',
    'HTTP',
    'POP3',
    'SMTP',
    'GATE',
    'NNTP',
    'RCC',
    {$ENDIF}
    'B+',
    'FTS-0001',
    'Hydra',
    'Janus',
    'Kermit',
    'Niagara',
    'Xmodem',
    'XmodemCRC',
    'Xmodem1K',
    'Xmodem1KG',
    'Ymodem',
    'YmodemG',
    'ZedZip (Zmodem/1K)',
    'ZedZap (Zmodem/8K)',
    'DirZap (Zmodem/8K/Direct)',
    '*** error ***'
  );

type

  {For storing received and transmitted blocks}
  PDataBlock = ^TDataBlock;
  TDataBlock = array[1..MaxInt] of Byte;

  {Describes working buffer for expanding a standard buffer with escapes}
  PWorkBlock = ^TWorkBlock;
  TWorkBlock = array[1..MaxInt] of Byte;

  {Describes data area of headers}
  TPosFlags = array[0..3] of Byte;

  TDevicePortInBuf  = array[0..PortInBufSize - 1] of Byte;
  TDevicePortOutBuf = array[0..PortOutBufSize - 1] of Byte;
  TDevicePortOutBlk = array[0..PortWriteBlockSize - 1] of Byte;
  TDevicePortChrBuf = array[0..PortChrBufSize - 1] of Byte;

  TTxRx = (TX, RX);
  TTxRxSet = set of TTxRx;

  TPort = class;
  TDevicePort = class;
  TSerialPort = class;

  TBaseProtocol = class;

  TLogFileProc = procedure(P: TBaseProtocol; AStatus: TLogFileStatus) of object;

  TAcceptFile = function (P: TBaseProtocol): TTransferFileAction of object;
  TGetNextFile = procedure (P: TBaseProtocol) of object;
  TFinishRece = procedure (P: TBaseProtocol; Action: TTransferFileAction) of object;
  TFinishSend = procedure (P: TBaseProtocol; Action: TTransferFileAction) of object;
  TChangeOrder = function (P: TBaseProtocol): boolean of object;

  TBatchState = (bsInit, bsActive, bsEnd, bsIdle, bsWait);

  TBatchData = record
    FPos,                         // current position in files
    Start,                        // time we started this file
    FSize,                        // file length
    FOfs,                         // offset in file we begun
    FTime,                        // unix file time
    BlkLen,                       // length of last block
    Part           : DWORD;
    ErrPos         : Integer;
    State          : TBatchState;
    StreamType     : TTransferStreamType;
    FName          : ShortString;
  end;

  TBatch = class
    d: TBatchData;
    r: TOutFile;
    Stream: TxStream;                // file stream
    procedure Clear;
    procedure ClearFileInfo;
    function Copy: TBatch;
    function CPS(AOutUsed: DWORD): Integer;
  end;

  TProtocolRecord = record
    ChatEnabled: boolean;
    HydraOEM: boolean;
    HydraShortNames: boolean;
    Addr: TFidoAddress;
    tzshift: integer;
    Sysop: string;
    Station: string;
    LogFName: string;
  end;

  TChat = class
    ChatStr: string;
    DispStr: string;
    LastKey: TDateTime;
    Caption: string;
    Log: TLogContainer;
    ChatBell: string;
  private
    BaseProtocol: TBaseProtocol;
    Collector: AnsiString;
    LogLastLine: boolean;
    LogCount: integer;
    fRemoteVisible: boolean;
    fWeAreVisible: boolean;
    function GetChatStr: string;
    function GetTimeout: integer;
//    procedure SetRemoteVisible(v: boolean);
    procedure SetVisible(v: boolean);
  public
    Memo1Text: TStringList;
    Memo2Text: TStringList;
    constructor Create(ALocal: boolean; const LogFName: string; BaseP: TBaseProtocol; const ChatBell: string);
    destructor Destroy; override;
    procedure AddMsg(const t: string);
    property ChatBuf: string read GetChatStr;
    property TimeOut: integer read GetTimeout;
    property RemoteVisible: boolean read fRemoteVisible write fRemoteVisible;
    property Visible: boolean read fWeAreVisible write SetVisible;
  end;

  TBaseProtocol = class
  protected
     CP                  : TPort;
     CS                  : TRTLCriticalSection;
     FAcceptFile         : TAcceptFile;
     FGetNextFile        : TGetNextFile;
     FFinishRece         : TFinishRece;
     FFinishSend         : TFinishSend;
     FChangeOrder        : TChangeOrder;

    _Compress            : function(dest: pointer; var res: longint; src: pointer; len: longint; lev: integer): integer; stdcall;
    _Uncompress          : function(dest: pointer; var res: longint; src: pointer; len: longint              ): integer; stdcall;

     procedure CalcTimeout(var VTimeout: DWORD; AMax, AMin: DWORD);
     procedure CalcBlockSize(var VMax, VCur: DWORD; AMax, AMin: DWORD);
     procedure DbgLog(const s: string);
     procedure DbgLogFmt(const Fmt: string; const Args: array of const);
     constructor Create(ACP : TPort);
     procedure Finish; virtual;
     procedure Cancel; virtual; abstract;
     procedure IncTotalErrors;
  private
     procedure DoStart;
  public
     CramDisabled,
     Debug,
     OutFlow             : Boolean;
     TotalErrors         : DWORD;
     ProtocolError       : TProtocolError;         {Holds last error}
     Station             : TStationDataColl;
     OutFiles            : TStringColl;
     OutPaths            : TStringColl;
     RemFiles            : TStringColl;
     RemImage            : TStringColl;
     RecFiles            : TStringColl;
     Speed,
     BatchNo,
     BinkPTimeout        : DWORD;
     FileRefuse,
     FileSkip,
     Originator          : Boolean;                // Are we the orig side?
     CustomInfo          : string;
     T, R                : TBatch;
     ID                  : TProtocolType;
     CancelRequested     : Boolean;
     FLogFile            : TLogFileProc;
     ChatBuf             : string;
     ListBuf             : TStringColl;
     Chat                : TChat;
     ChatOpened          : boolean;
     ChatBell            : string;
     FiAddr              : TFidoAddress;
     FiSysop             : string;
     FiStation           : string;
     FiPassword          : string;
     BirthDay            : string;
     RemoteCanChat,
     RemoteCanPZIP,
     RemoteCanDyna,
     RemoteCan2eob,
     RemoteCanCram,
     RemoteCanCryp,
     RemoteCanBrek,
     RemoteCanList       : Boolean;
     RemoteUseList       : Boolean;
     FillOutList         : Boolean;
     DummyNextFile       : Boolean;
     SendFTPFile         : Boolean;
     ActuallySent,
     ActuallyRece,
     VisuallySent,
     VisuallyRece        : DWORD;
     OutSize             : DWORD;
     ipAddr              : string;
     UniqStr             : string;
     aType               : DWORD;
     function TimeoutValue: DWORD; virtual; abstract;
     procedure Start({RX}AAcceptFile: TAcceptFile;
                         AFinishRece: TFinishRece;
                     {TX}AGetNextFile: TGetNextFile;
                         AFinishSend: TFinishSend;
                     {CH}AChangeOrder: TChangeOrder
                     ); virtual; abstract;
     function TxClosed: Boolean;
     function RxClosed: Boolean;
     function GetStateStr: string; virtual; abstract;
     procedure ReportTraf(txMail, txFiles: DWORD); virtual; abstract;
     function Name: string;
     destructor Destroy; override;
     function IsBiDir: Boolean; virtual; abstract;
     function GetUniqStr: string;
     function NextStep: Boolean; virtual; abstract;
     procedure StartChat(const LogFName: string; local: boolean; const ChatBell: string); virtual;
     function CanChat: Boolean; virtual;
     function Compress(dest: pointer; var res: longint; src: pointer; len: longint): integer;
     function Uncompress(dest: pointer; var res: longint; src: pointer; len: longint): integer;
  end;

  TBiDirProtocol = class(TBaseProtocol)
  public
     function IsBiDir: Boolean;                                 override;
     procedure Start({RX}AAcceptFile: TAcceptFile;
                         AFinishRece: TFinishRece;
                     {TX}AGetNextFile: TGetNextFile;
                         AFinishSend: TFinishSend;
                     {CH}AChangeOrder: TChangeOrder);           override;
     procedure ProcessLST(const l: string);
     procedure SendFList;
     procedure StartBatch; virtual;
  end;

  {$IFDEF EXTREME}

   TCoding = (
   cUNK,
   cB64,
   cMIM,
   cUUE
   );

  TInetProtocol = class(TBiDirProtocol)
     LList: TStringColl;
     tBuff: string;
     bBuff: string;
     Timer: EventTimer;
     fUser,
     fPass: string;
     fFlId: string;
     fCode: TCoding;
     fSize: DWORD;
     fLine: string;
     fStam: string;
     fName: string;
     fBuff: string;
     aFrom: TFidoAddress;
     aDest: TFidoAddress;
     aPass: string;
     nFrom: string;
     nDest: string;
     nSubj: string;
     rmCRC: DWORD;
     dwCRC: DWORD;
     dwMD5: string;
     dwCTX: TMD5ctx;
     dwB16: TMD5Byte16;
     fMime: boolean;
     nBoun: string;
     fCram: string;
     iAddr: string;
     constructor Create(ACP : TPort);
     destructor Destroy; override;
     function Decode_UUDec(const inp: string): string;
     function Encode_UUEnc(const inp; Size: integer): string;
     function CanSend: boolean;
     procedure PutString(const s: string = '');
     procedure CheckInput;
     function PreFile(const z, s: string): boolean;
     procedure RecFile(const z, a: string);
     function RecStep: boolean;
     procedure SendFile; 
     procedure AbortRece(const s: string = ''); virtual; abstract;
     procedure FinisRece(const s: string = ''); virtual; abstract;
     procedure FinisSend(const s: string = ''); virtual; abstract;
     function ExtractParam(const k, s, d: string): string;
     procedure SendHeader(const f: string);
     procedure SendSEATHd(const CRC: DWORD; MD5: string);
     procedure HandleFile(const f: TxStream; var CRC: DWORD; var Auth: string);
  end;
  {$ENDIF}

  TOneWayProtocol = class(TBaseProtocol)
  protected
     TimeoutTimer        : EventTimer;
     BlockErrors         : DWORD;
     DataBlock           : PDataBlock;      {Working data block}
     CheckType           : TBlockCheckType; {Code for block check type}
     BlockCheck          : DWORD;         {Block check value}
     ProtocolStatus      : TProtocolStatus; {Holds last status}
     LastBlock           : Boolean;         {True at eof}

     procedure PrepareReceive(AAcceptFile: TAcceptFile;
                              AFinishRece: TFinishRece); virtual; abstract;
     procedure PrepareTransmit(NextFunc: TGetNextFile;
                         AFinishSend: TFinishSend); virtual; abstract;

     function  Timeout: Boolean;
     procedure IncBlockErrors;

     constructor Create(ACP : TPort);

     function  Receive: Boolean; virtual; abstract;
     function  Transmit : Boolean; virtual; abstract;

     procedure SignalFinish;
   public
     function IsBiDir: Boolean;                                 override;
     function TimeoutValue: DWORD; override;
     function NextStep: Boolean; override;
     procedure Start({RX}AAcceptFile: TAcceptFile;
                         AFinishRece: TFinishRece;
                     {TX}AGetNextFile: TGetNextFile;
                         AFinishSend: TFinishSend;
                     {CH}AChangeOrder: TChangeOrder);           override;

   end;

   TFadeThread = class(T_Thread)
     oFade: DWORD;
     constructor Create;
     procedure InvokeExec; override;
     destructor Destroy; override;
     class function ThreadName: string; override;
   end;

   TInThreadClass = class of TInThread;
   TInThread = class(T_Thread)
     Actually: DWORD;
     ReadState: Boolean;
     CP: TDevicePort;
     ReadBuf: TDevicePortInBuf;     { Used by ReadFile }
     procedure InvokeExec; override;
     function Read(var Buf; Size: DWORD): DWORD; virtual; abstract;
     class function ThreadName: string; override;
   end;

   TSerialInThread = class(TInThread)
     function Read(var Buf; Size: DWORD): DWORD; override;
     class function ThreadName: string; override;
   end;

   TOutThreadClass = class of TOutThread;
   TOutThread = class(T_Thread)
     OutFlow: Boolean;
     CP: TDevicePort;
     WriteBuf: TDevicePortOutBlk;
     Purge: Boolean;
     procedure InvokeExec; override;
     function Write(const Buf; Size: DWORD): DWORD; virtual; abstract;
     class function ThreadName: string; override;
   end;

   TSerialOutThread = class(TOutThread)
     function Write(const Buf; Size: DWORD): DWORD; override;
     class function ThreadName: string; override;
   end;

   TPort = class
   protected
     procedure SetCarrier(B: Boolean);               virtual; abstract;
     function  GetCarrier: Boolean;                  virtual; abstract;
     procedure SetCallerId(const S:string);          virtual; abstract;
     procedure SetPortNumber(V: Integer);            virtual; abstract;
     procedure SetPortIndex(V: Integer);             virtual; abstract;
     procedure SetDTE(V: Integer);                   virtual; abstract;
     function  GetCallerId: string;                  virtual; abstract;
     function  GetPortNumber: Integer;               virtual; abstract;
     function  GetPortIndex: Integer;                virtual; abstract;
     function  GetDTE: Integer;                      virtual; abstract;
  public
   // mapped routines
     procedure SetDeltaDCDNotify(h: DWORD);          virtual; abstract;
     procedure SetCommErrorNotify(h: DWORD);         virtual; abstract;
     function  ComErrorColl: TColl;                  virtual; abstract;
     procedure EnterCommErrorCS;                     virtual; abstract;
     procedure LeaveCommErrorCS;                     virtual; abstract;
     function  LineStatus: DWORD;                    virtual; abstract;
     function  Handle: DWORD;                        virtual; abstract;
     function  oDataAvail: DWORD;                    virtual; abstract;
     function  oOutDrained: DWORD;                   virtual; abstract;
     function  OutUsed: DWORD;                       virtual; abstract;
     function  Write(const Buf; Size: DWORD): DWORD; virtual; abstract;
     function  CharReady: Boolean;                   virtual; abstract;
     procedure Flsh;                                 virtual; abstract;
     procedure PutChar(C: Byte);                     virtual; abstract;
     function  GetChar(var C: Byte): Boolean;        virtual; abstract;
     function  DCD: Boolean;                         virtual; abstract;
     function  GetErrorStrColl: TStringColl;         virtual; abstract;
     procedure SendString(const S: string);
     property Carrier: Boolean read GetCarrier write SetCarrier;
     property CallerId: string read GetCallerId write SetCallerId;
     property PortNumber: Integer read GetPortNumber write SetPortNumber;
     property PortIndex: Integer read GetPortIndex write SetPortIndex;
     property DTE: Integer read GetDTE write SetDTE;
   end;

   TMapPort = class(TPort)
   protected
     DevicePort: TDevicePort;
     procedure SetCarrier(B: Boolean);                 override;
     function  GetCarrier: Boolean;                    override;
     procedure SetCallerId(const S:string);            override;
     procedure SetPortNumber(V: Integer);              override;
     procedure SetPortIndex(V: Integer);               override;
     procedure SetDTE(V: Integer);                     override;
     function GetCallerId: string;                     override;
     function GetPortNumber: Integer;                  override;
     function GetPortIndex: Integer;                   override;
     function GetDTE: Integer;                         override;
   public
     procedure SetDeltaDCDNotify(h: DWORD);            override;
     procedure SetCommErrorNotify(h: DWORD);           override;
     function  ComErrorColl: TColl;                    override;
     procedure EnterCommErrorCS;                       override;
     procedure LeaveCommErrorCS;                       override;
     function  LineStatus: DWORD;                      override;
     function  Handle: DWORD;                          override;
     function  oOutDrained: DWORD;                     override;
     function  oDataAvail: DWORD;                      override;
     constructor Create(ADevicePort: TDevicePort);
     function ExtractPort: TDevicePort;
     destructor Destroy; override;
     function  DCD: Boolean;                           override;
   end;

   TDevicePort = class(TPort)
   protected
   // constant options
     FCallerId,
     HoldStr: string;
     FPortNumber,
     FPortIndex,
     FDTE,                      { Baudrate port have been locked }
     SzWrite,
     SzWriteNow,
     PtrReadA, SzReadA,
     SzReadB,
     HoldPos,
     HoldLen,
     FLineStatus,
     SzOutChars,

     oFreeReadB,      { Signaled on free ReadB }
     oNewOutData,     { To wake up writing thread }
     oReadDowned,
     oStatusDowned,
     oTempDown,
     oHandle: DWORD;

     LastRead, LastWrite: EventTimer;

     SignalTimeouts: array[TSignalType] of EventTimer;

     ReadA,                 { API-free, used by GetChar }
     ReadB: TDevicePortInBuf;     { Shared by ReadFile and GetChar }

     WriteBuf: TDevicePortOutBuf;

     OutChars: TDevicePortChrBuf;

     ReadThr: TInThread;
     WriteThr: TOutThread;

     ReadCS, WriteCS: TRTLCriticalSection;

     FCarrier,
     HoldKept,
     bNewData,
     PurgeRX,
     FRI,
     FCTS,
     FDSR,
     FDTR,
     FRTS,
     FTXD,
     FRXD,
     FDCD: Boolean;

     StatCS  : TRTLCriticalSection;
     StatOL  : TOverLapped;

     procedure Reload;
     procedure CloseHW_A;                              virtual; abstract;
     procedure CloseHW_B;                              virtual; abstract;
     procedure HWPurge(Typ: TTxRxSet);                 virtual; abstract;
     procedure SaveParams;                             virtual; abstract;
     procedure RestoreParams;                          virtual; abstract;
     procedure SetCarrier(B: Boolean);                 override;
     function  GetCarrier: Boolean;                    override;
     procedure SetCallerId(const S:string);            override;
     procedure SetPortNumber(V: Integer);              override;
     procedure SetPortIndex(V: Integer);               override;
     procedure SetDTE(V: Integer);                     override;
     function GetCallerId: string;                     override;
     function GetPortNumber: Integer;                  override;
     function GetPortIndex: Integer;                   override;
     function GetDTE: Integer;                         override;
   public
     ComErrorCS: TRTLCriticalSection;
     FComErrorColl: TColl;
     FHandle,
     FoDeltaDCDNotify,
     FoComErrorNotify,
     FoDataAvail,                                      { Signaled on Input Data available }
     FoOutDrained: DWORD;                              { Signaled on Output Buffer drained }
     TempDown: Boolean;
     ReadOL, WriteOL : TOverLapped;
     MaxBPSOut,
     MaxBPSIn : DWORD;
     function  oOutDrained: DWORD;                     override;
     function  oDataAvail: DWORD;                      override;
     procedure EnterCommErrorCS;                       override;
     procedure LeaveCommErrorCS;                       override;
     function  ComErrorColl: TColl;                    override;
     procedure SetDeltaDCDNotify(h: DWORD);            override;
     procedure SetCommErrorNotify(h: DWORD);           override;
     procedure SetHoldStr(const S: string);
     procedure InsComErr(ee: TComError);
     procedure EnterWriteCS;
     procedure LeaveWriteCS;
     function ReadNow: Integer;                        virtual; abstract;
     procedure WakeThreads;
     function LineStatus: DWORD;                       override;
     procedure UpdateLineStatus;

     function  GetChar(var C: Byte): Boolean;          override;
     function  CharReady: Boolean;                     override;
     function  _GetChar: Byte;

     function  Write(const Buf; Size: DWORD): DWORD;   override;
     procedure PutChar(C: Byte);                       override;
     procedure Flsh;                                   override;
     function  GetErrorStrColl: TStringColl;           override;

     procedure Purge(Typ: TTxRxSet);

     constructor Create(InClass: TInThreadClass; OutClass: TOutThreadClass);
     destructor Destroy; override;
     function  Handle: DWORD;                          override;

     function OutUsed: DWORD;                          override;
     function DCD: Boolean;                            override;
     procedure SleepDown;                              virtual; abstract;
     procedure WakeUp;                                 virtual; abstract;
   end;


   TSerialStatusThr = class;

   TSerialPort = class(TDevicePort)
   public
     OrgTimeouts,
     DefTimeouts: TCommTimeouts;
     StatThr : TSerialStatusThr;

     procedure SetExitTimeouts;
     procedure SetMask(Arg: Integer);
     procedure SetBPS(I: Integer);
     function ReadNow: Integer; override;
     procedure SleepDown; override;
     procedure WakeUp; override;

     function ChkAbort: Integer;
     function RealDCD: Boolean;
     procedure CloseHW_A; override;
     procedure CloseHW_B; override;
     procedure HWPurge(Typ: TTxRxSet); override;
     procedure ReadStatus;
     procedure SetDTR(Value: Boolean);
     procedure SetRTS(Value: Boolean);
     property DTR: Boolean write SetDTR;
     property RTS: Boolean write SetRTS;

     constructor Create(AHandle: DWORD);
     destructor Destroy; override;
     procedure SaveParams; override;
     procedure RestoreParams; override;
     procedure SetLine(AOptions: Integer);
     procedure SetTimeouts(T: TCommTimeouts);
     procedure SetHandle(Handle: THandle);
     procedure WaitClean;
   published
     property  ComHandle: THandle read FHandle write SetHandle;
   end;

   TSerialStatusThr = class(T_Thread)
   private
     EvtMask: DWORD;
     Again: Boolean;
     CP: TSerialPort;
   public
     procedure InvokeExec; override;
     class function ThreadName: string; override;
   end;

   TCommThread = class(T_Thread)
     CP: TPort;
     class function ThreadName: string; override;
   end;

   TLampsProc = procedure(AComThr: TCommThread);

   TLampsThread = class(T_Thread)
     oStatusChange: DWORD;   { Signaled on Modem Status change }
     class function ThreadName: string; override;
     constructor Create;
     procedure InvokeExec; override;
     destructor Destroy; override;
   end;

  TDevicePortColl = class(TColl)
    LampsThr: TLampsThread;
    FadeThr: TFadeThread;
    constructor Create;
    destructor Destroy; override;
  end;

function SetCommParams(AHandle, ASpeed: DWORD;
                       ADataBits, AParityType, AStopBits: Byte;
                       ACTS_RTS,  AxOn_xOff: Boolean): Boolean;

procedure EnumSerialPorts(items: TStrings);

var
  PortsColl  : TDevicePortColl;
  ZLibHandle : THandle;
  ZLibLoaded : Boolean;
  BZipHandle : THandle;
  BZipLoaded : Boolean;
  Compress_  : function(dest: pointer; var res: longint; src: pointer; len: longint; lev: integer): integer; stdcall;
  Uncompress_: function(dest: pointer; var res: longint; src: pointer; len: longint              ): integer; stdcall;

const
  Z_OK = 0;
  Z_STREAM_END = 1;
  Z_NEED_DICT = 2;
  Z_ERRNO = (-1);
  Z_STREAM_ERROR = (-2);
  Z_DATA_ERROR = (-3);
  Z_MEM_ERROR = (-4);
  Z_BUF_ERROR = (-5);
  Z_VERSION_ERROR = (-6);

function IsOldMailer(const softstr: string): boolean;
procedure PlaySnd(const s: string; Play: boolean);
function ChatBellThreadFunc(p: pointer):integer;

var
  MidStarted: boolean = False;

implementation

uses
   SysUtils, NTdyn, wizard, plus, util, BleepInt,
   MMsystem, NdlUtil, Crypt;

function IsOldMailer(const softstr: string): boolean;
begin
  result := false;

  {Argus}
  if (pos('Argus', softstr) > 0) then
  begin
    result := true;
    exit;
  end;

  {old Radius}
  if copy(softstr, 1, 12) = 'Radius/4.010' then
  begin
    result := ExtractWord(3, softstr, ['/'])[9] = ',';
    exit;
  end;

  {very old Radius}
  if (pos('Radius/4.00', softstr) > 0) then
  begin
    result := true;
    exit;
  end;

end;

procedure PlaySnd;
var e: integer;
    p: string;
begin
   if IniFile.Stealth then exit;
   if MidStarted then mciSendString('close snd', nil, 0, 0);
   if not Inifile.PlaySounds and not Play then exit;
   if not IniFile.ReadBool('Sounds', 'c_' + s) then exit;
   p := Inifile.ReadString('Sounds', s);
   if p = s then begin
      p := MakeFullDir(inifile.HomeDir, 'Snd\');
      p := MakeFullDir(p, s);
   end else begin
      p := ExtractWord(1, p, ['.']);
   end;
   if ExistFile(p + '.wav') then sndPlaySound(PChar(p + '.wav'), SND_ASYNC) else
   if ExistFile(p + '.mid') then begin
      e := mciSendString(PAnsiChar('open sequencer!' + p + '.mid alias snd'), nil, 0, 0);
      if e = 0 then begin
         mciSendString('play snd from 0', nil, 0, 0);
         MidStarted := True;
      end;
   end;
end;

procedure PlayRaMZ(const fn: string);
var
  FileID: TextFile;
  Buf: string;
  Freq, MSecs, linecount: integer;
begin
  {$I-}
  AssignFile(FileID, fn);
  Reset(FileID);
  if IOResult <> 0 then exit;
  {$I+}

  Buf := '';
  LineCount := 0;
  while not EOF(FileID) do
  begin
    inc(linecount);
    Readln(FileID, Buf);
    case linecount of
      1:;//TAG
      2:;//название
      else begin
        if WordCount(Buf,[' ']) <> 2 then break;
        Freq := StrToIntDef(ExtractWord(1, Buf, [' ']), 0);
        MSecs := StrToIntDef(ExtractWord(2, Buf, [' ']), 0);
        BleepInt.DoBleep(Freq, MSecs);
      end;
    end;{of case}
  end;
  BleepInt.ShutUp;
  CloseFile(FileID);
end;

function ChatBellThreadFunc(p:pointer):integer;
begin
  result := 0;
  if string(pchar(p)) = '1' then
  begin
    BleepInt.Bleep(bInterrupt);
    BleepInt.Bleep(bInterrupt);
    BleepInt.Bleep(bInterrupt);
    BleepInt.Bleep(bInterrupt);
    exit;
  end;
  case GetMediaType(string(pchar(p))) of
    mtWAV: sndPlaySound(pchar(p), SND_ASYNC);
    mtRaMZ: PlayRaMZ(string(pchar(p)));
    else;
  end; {of case}
End;

{ --- In Thread }

class function TInThread.ThreadName: string;
begin
  Result := 'Interface Input (Base)';
end;

procedure TInThread.InvokeExec;
type
  TToDo = (_ReadAgain, _WaitB);

function ToDo: TToDo;

var
  SetDataAvail: Boolean;

procedure MakeChoice;
begin

  ToDo := _ReadAgain;

  if CP.PurgeRX then begin
     ResetEvt(CP.FoDataAvail);
     CP.PurgeRX := False;
  end else
  if Actually <> 0 then begin
     if Actually > PortInBufSize - CP.SzReadB then begin
        if not (CP is TSerialPort) then begin
           CP.FCTS := False;
        end;
        ToDo := _WaitB;
     end else begin
        if not (CP is TSerialPort) then begin
           CP.FCTS := True;
        end;
        if CP.SzReadB = 0 then begin
           ResetEvt(CP.oFreeReadB);
           if CP.SzReadA = 0 then SetDataAvail := True;
        end;
        Move(ReadBuf, CP.ReadB[CP.SzReadB], Actually);
        Inc(CP.SzReadB, Actually);
     end;
  end;
end;

begin
  SetDataAvail := False;
  EnterCS(CP.ReadCS);
  MakeChoice;
  if SetDataAvail then SetEvt(CP.FoDataAvail);
  LeaveCS(CP.ReadCS);
end;

begin
  if CP.FHandle = INVALID_HANDLE_VALUE then begin
     CP.FRI  := False;
     CP.FCTS := False;
     CP.FDSR := True;
     CP.FDTR := True;
     CP.FRTS := False;
     CP.FRXD := False;
     CP.FTXD := False;
     WaitEvtInfinite(CP.oHandle);
     ResetEvt(CP.oHandle);
  end;
  if Terminated then exit;
  if not ReadState then begin
    if CP is TSerialPort then begin
      if not TimerExpired(CP.LastRead) then Sleep(10);
      NewTimer(CP.LastRead, 1);
    end;

    if not CP.TempDown then Actually := Read(ReadBuf, CP.ReadNow);

    if Terminated then Exit;

    if CP.TempDown then begin
      if Win32Platform = VER_PLATFORM_WIN32_NT then begin
        if NTdyn_SignalObjectAndWait(CP.oReadDowned, CP.oTempDown, INFINITE, False) <> WAIT_OBJECT_0 then GlobalFail('%s', ['SignalObjectAndWait oReadDowned']);
      end else begin
        SetEvt(CP.oReadDowned);
        WaitEvtInfinite(CP.oTempDown);
      end;
      SetEvt(CP.oReadDowned);
      CP.RestoreParams;
      Exit;
    end;

    EnterCS(CP.StatCS);
    CP.FRxD := True;
    CP.UpdateLineStatus;
    NewTimer(CP.SignalTimeouts[stRead], FadeTicks);
    SetEvt(PortsColl.FadeThr.oFade);
    LeaveCS(CP.StatCS);

    if Terminated then Exit;

    ReadState := True;
  end;

  if ReadState then begin
    case ToDo of
      _ReadAgain: ReadState := False;
      _WaitB: WaitEvtInfinite(CP.oFreeReadB);
    end;
  end;
end;

{ --- Out Thread }

class function TOutThread.ThreadName: string;
begin
  Result := 'Interface out (Base)';
end;

procedure TOutThread.InvokeExec;

procedure PrepareFlow;
var
  SetOutDrained: Boolean;
begin
  CP.EnterWriteCS;
  CP.SzWriteNow := 0;
  CP.LeaveWriteCS;
  if CP.FHandle = INVALID_HANDLE_VALUE then begin
     WaitEvtInfinite(CP.oHandle);
     ResetEvt(CP.oHandle);
  end;
  if Terminated then exit;
  WaitEvtInfinite(CP.oNewOutData);
  if Terminated then Exit;
  if CP.FHandle = INVALID_HANDLE_VALUE then begin
     WaitEvtInfinite(CP.oHandle);
     ResetEvt(CP.oHandle);
  end;
  if Terminated then exit;
  SetOutDrained := False;
  CP.EnterWriteCS;
  if not Terminated then begin
    CP.SzWriteNow := MinD(CP.SzWrite, PortWriteBlockSize);
    Move(CP.WriteBuf, WriteBuf, CP.SzWriteNow);
    Dec(CP.SzWrite, CP.SzWriteNow);
    if CP.SzWrite = 0 then begin
      CP.bNewData := False;
      SetOutDrained := True;
      ResetEvt(CP.oNewOutData);
    end else begin
      Move(CP.WriteBuf[CP.SzWriteNow], CP.WriteBuf, CP.SzWrite);
    end;
  end;
  if SetOutDrained then SetEvt(CP.FoOutDrained);
  CP.LeaveWriteCS;

  if Terminated then Exit;
  if CP.SzWriteNow > 0 then OutFlow := True;
end;

procedure DoOutFlow;
var
  SzWriteActual: DWORD;
begin
  if CP.FHandle = INVALID_HANDLE_VALUE then begin
     WaitEvtInfinite(CP.oHandle);
     ResetEvt(CP.oHandle);
  end;
  if Terminated then exit;
  EnterCS(CP.StatCS);
  CP.FTxD := True;
  CP.UpdateLineStatus;
  NewTimer(CP.SignalTimeouts[stWrite], FadeTicks);
  SetEvt(PortsColl.FadeThr.oFade);
  LeaveCS(CP.StatCS);

  if CP is TSerialPort then begin
    if not TimerExpired(CP.LastWrite) then Sleep(10);
    NewTimer(CP.LastWrite, 1);
  end;

  SzWriteActual := Write(WriteBuf, CP.SzWriteNow);

  if not (CP is TSerialPort) then begin
     CP.FDSR := SzWriteActual = CP.SzWriteNow;
  end;

  if Terminated then Exit;

  CP.EnterWriteCS;
  if CP.SzWriteNow = 0 then SzWriteActual := 0;
  if (CP.SzWriteNow = SzWriteActual) then begin
    CP.LeaveWriteCS;
    OutFlow := False;
    Exit;
  end;
  if SzWriteActual > 0 then begin
    Dec(CP.SzWriteNow, SzWriteActual);
    Move(WriteBuf[SzWriteActual], WriteBuf, CP.SzWriteNow)
  end;
  CP.LeaveWriteCS;
end;

begin
  if CP.FHandle = INVALID_HANDLE_VALUE then begin
     WaitEvtInfinite(CP.oHandle);
     ResetEvt(CP.oHandle);
  end;
  if Terminated then exit;
  if not OutFlow then PrepareFlow;
  if OutFlow then DoOutFlow;
end;

{ --- Fade Thread }

class function TFadeThread.ThreadName: string;
begin
  Result := 'Lamps Fader';
end;

constructor TFadeThread.Create;
begin
  inherited Create;
  Priority := tpLower;
  oFade := CreateEvtA;
end;

procedure TFadeThread.InvokeExec;
var
  t: TSignalType;
 CP: TDevicePort;

procedure CndChk(var b: Boolean);
var
  e: PEventTimer;
begin
  e := @CP.SignalTimeouts[t];
  if TimerInstalled(e^) and TimerExpired(e^) then
  begin
    b := False;
    ClearTimer(e^);
  end;
end;

var
  i: Integer;
  e: EventTimer;
  ToSleep: DWORD;
begin
  ToSleep := High(ToSleep);
  PortsColl.Enter;
  if PortsColl.Count > 0 then begin
    for i := 0 to PortsColl.Count - 1 do begin
      CP := PortsColl[i];
      EnterCS(CP.StatCS);
      for t := Low(TSignalType) to High(TSignalType) do begin
        e := CP.SignalTimeouts[t];
        if TimerInstalled(e) then ToSleep := MinD(ToSleep, RemainingTimeMSecs(e));
        if ToSleep = 0 then Break;
      end;
      LeaveCS(CP.StatCS);
    end;
  end;
  PortsColl.Leave;

  if ToSleep = High(ToSleep) then ToSleep := INFINITE;
  WaitEvt(oFade, MaxD(50, ToSleep));

  if Terminated then Exit;

  PortsColl.Enter;
  for i := 0 to PortsColl.Count - 1 do begin
    CP := PortsColl[i];
    EnterCS(CP.StatCS);
    t := Low(TSignalType);
    CndChk(CP.FRxD);
    t := Succ(t);
    CndChk(CP.FTxD);
    CP.UpdateLineStatus;
    LeaveCS(CP.StatCS);
  end;
  PortsColl.Leave;
end;

destructor TFadeThread.Destroy;
begin
  ZeroHandle(oFade);
  inherited Destroy;
end;

{ --- Ports collection }

constructor TDevicePortColl.Create;
begin
  inherited Create('TDevicePortColl');
  LampsThr := TLampsThread.Create;
  FadeThr := TFadeThread.Create;

  LampsThr.Suspended := False;
  FadeThr.Suspended := False;
end;

destructor TDevicePortColl.Destroy;
begin
  LampsThr.Suspended := True;
  FadeThr.Suspended := True;
  LampsThr.Terminated := True;
  FadeThr.Terminated := True;
  SetEvt(LampsThr.oStatusChange);
  SetEvt(FadeThr.oFade);
  LampsThr.Suspended := False;
  FadeThr.Suspended := False;
  LampsThr.WaitFor; FreeObject(LampsThr);
  FadeThr.WaitFor; FreeObject(FadeThr);
  inherited Destroy;
end;

{ --- Map port }

procedure TMapPort.SetCallerId(const S:string);
begin
  DevicePort.CallerId := S;
end;

procedure TMapPort.SetPortNumber(V: Integer);
begin
  DevicePort.PortNumber := V;
end;

procedure TMapPort.SetPortIndex(V: Integer);
begin
  DevicePort.PortIndex := V;
end;

procedure TMapPort.SetDTE(V: Integer);
begin
  DevicePort.DTE := V;
end;

function TMapPort.GetCallerId: string;
begin
  Result := DevicePort.CallerId;
end;

function TMapPort.GetPortNumber: Integer;
begin
  Result := DevicePort.PortNumber;
end;

function TMapPort.GetPortIndex: Integer;
begin
  Result := DevicePort.PortIndex;
end;

function TMapPort.GetDTE: Integer;
begin
  Result := DevicePort.DTE;
end;

function TMapPort.oOutDrained: DWORD;
begin
  Result := DevicePort.FoOutDrained;
end;

function TMapPort.oDataAvail: DWORD;
begin
  Result := DevicePort.FoDataAvail;
end;

constructor TMapPort.Create(ADevicePort: TDevicePort);
begin
  inherited Create;
  DevicePort := ADevicePort;
end;

function TMapPort.ExtractPort: TDevicePort;
begin
  Result := DevicePort;
  DevicePort := nil;
end;

destructor TMapPort.Destroy;
begin
  FreeObject(DevicePort);
  inherited Destroy;
end;

procedure TMapPort.SetCarrier(B: Boolean);
begin
  DevicePort.FCarrier := B;
end;

function  TMapPort.GetCarrier: Boolean;
begin
  Result := DevicePort.FCarrier;
end;

function  TMapPort.DCD: Boolean;
begin
  Result := DevicePort.DCD;
end;

function  TMapPort.Handle: DWORD;
begin
  Result := DevicePort.FHandle;
end;

procedure TMapPort.SetDeltaDCDNotify(h: DWORD);
begin
  DevicePort.SetDeltaDCDNotify(h);
end;

procedure TMapPort.SetCommErrorNotify(h: DWORD);
begin
  DevicePort.SetCommErrorNotify(h);
end;

function  TMapPort.ComErrorColl: TColl;
begin
  Result := DevicePort.ComErrorColl;
end;

procedure TMapPort.EnterCommErrorCS;
begin
  DevicePort.EnterCommErrorCS;
end;

procedure TMapPort.LeaveCommErrorCS;
begin
  DevicePort.LeaveCommErrorCS;
end;

function  TMapPort.LineStatus: DWORD;
begin
  Result := DevicePort.LineStatus;
end;

{ --- Abstract Device port }

function TDevicePort.GetErrorStrColl;
begin
  Result := nil;
end;

procedure TDevicePort.SetCallerId(const S: string);
begin
  FCallerId := S;
end;

procedure TDevicePort.SetPortNumber(V: Integer);
begin
  FPortNumber := V;
end;

procedure TDevicePort.SetPortIndex(V: Integer);
begin
  FPortIndex := V;
end;

procedure TDevicePort.SetDTE(V: Integer);
begin
  FDTE := V;
end;

function TDevicePort.GetCallerId: string;
begin
  Result := FCallerId;
end;

function TDevicePort.GetPortNumber: Integer;
begin
  Result := FPortNumber;
end;

function TDevicePort.GetPortIndex: Integer;
begin
  Result := FPortIndex;
end;

function TDevicePort.GetDTE: Integer;
begin
  Result := FDTE;
end;

function TDevicePort.Handle: DWORD;
begin
  Result := FHandle;
end;

procedure TDevicePort.SetCarrier(B: Boolean);
begin
  FCarrier := B;
end;

function  TDevicePort.GetCarrier: Boolean;
begin
  Result := FCarrier;
end;

function  TDevicePort.LineStatus: DWORD;
begin
  Result := FLineStatus;
end;

function  TDevicePort.oOutDrained: DWORD;
begin
  Result := FoOutDrained;
end;

function  TDevicePort.oDataAvail: DWORD;
begin
  Result := FoDataAvail;
end;

procedure TDevicePort.EnterCommErrorCS;
begin
  EnterCS(ComErrorCS);
end;

procedure TDevicePort.LeaveCommErrorCS;
begin
  LeaveCS(ComErrorCS);
end;

function TDevicePort.ComErrorColl: TColl;
begin
  Result := FComErrorColl;
end;

function TDevicePort.OutUsed: DWORD;
begin
  Result := SzOutChars + SzWrite;
end;

function TDevicePort.DCD: Boolean;
begin
  Result := FDCD;
end;

procedure TDevicePort.InsComErr(ee: TComError);
begin
  EnterCS(ComErrorCS);
  FComErrorColl.Insert(ee);
  if FoComErrorNotify <> INVALID_HANDLE_VALUE then SetEvent(FoComErrorNotify);
  LeaveCS(ComErrorCS);
end;

procedure TDevicePort.EnterWriteCS;
begin
  EnterCS(WriteCS);
end;

procedure TDevicePort.LeaveWriteCS;
begin
  LeaveCS(WriteCS);
end;

procedure TDevicePort.UpdateLineStatus;
var
  s: DWORD;
  PulseDeltaDCD: Boolean;
begin
  PulseDeltaDCD := False;
  s := FLineStatus;
  if FRI  then s := s or MS_RING_ON  else s := s and not MS_RING_ON;
  if FCTS then s := s or MS_CTS_ON  else s := s and not MS_CTS_ON;
{$IFNDEF RLSD}  if FDCD then s := s or MS_RLSD_ON else s := s and not MS_RLSD_ON; {$ENDIF}
  if FDSR then s := s or MS_DSR_ON else s := s and not MS_DSR_ON;
  if FTXD then s := s or MS_TXD_ON else s := s and not MS_TXD_ON;
  if FRXD then s := s or MS_RXD_ON else s := s and not MS_RXD_ON;
  if s <> FLineStatus then begin
    {$IFNDEF RLSD}
    if (s and MS_RLSD_ON) <> (FLineStatus and MS_RLSD_ON) then begin
      if FoDeltaDCDNotify <> INVALID_HANDLE_VALUE then PulseDeltaDCD := True;
    end;
    {$ENDIF}
    FLineStatus := s;
    SetEvt(PortsColl.LampsThr.oStatusChange);
    if PulseDeltaDCD then SetEvt(FoDeltaDCDNotify);
  end;
end;

procedure TDevicePort.Purge;
begin
  if TX in Typ then begin
    EnterWriteCS;
    SzWrite := 0;
    SzWriteNow := 0;
    SzOutChars := 0;
    if HoldKept then begin
      HoldPos := 0;
      HoldKept := False;
      HoldStr  := '';
    end;
  end;
  if RX in Typ then begin
    EnterCS(ReadCS);
    PurgeRX := True;
    PtrReadA := 0;
    SzReadA := 0;
    SzReadB := 0;
  end;

  HWPurge(Typ);

  if RX in Typ then LeaveCS(ReadCS);
  if TX in Typ then LeaveWriteCS;

end;

procedure TDevicePort.WakeThreads;
begin
  ReadThr.Suspended := False;
  WriteThr.Suspended := False;
end;

{function TDevicePort.OutEmpty: Boolean;
begin
  Flsh;
  Result := not bNewData;
end;}

procedure TDevicePort.PutChar(C: Byte);
begin
  OutChars[SzOutChars] := C;
  Inc(SzOutChars);
  if SzOutChars = PortChrBufSize then Flsh;
end;

procedure TDevicePort.Flsh;
var
  Sz, Actual: Integer;
  Cn: Integer;
begin
  Cn := 0;
  while SzOutChars > 0 do begin
    Sz := SzOutChars;
    SzOutChars := 0;
    Actual := Write(OutChars, Sz);
    SzOutChars := Sz - Actual;
    if Sz > Actual then begin
      Move(OutChars[Actual], OutChars, SzOutChars);
      WaitEvt(oNewOutData, 100);
    end;
    inc(Cn);
    if Cn = 50 then break;
  end;
end;

function TDevicePort.Write(const Buf; Size: DWORD): DWORD;
var
  SetNewData : Boolean;
begin
  SetNewData := False;
  Flsh;
  EnterWriteCS;
  Result := MaxD(0, MinD(Size, PortOutBufSize - SzWrite));
  if Result <> Size then GlobalFail('Port Output Buffer Overflow (PortOutBufSize=%d, SzWrite=%d)', [PortOutBufSize, SzWrite]);
  if Result <> 0 then begin
    if SzWrite = 0 then begin
      SetNewData := True;
      bNewData := True;
      ResetEvt(FoOutDrained);
    end;
    Move(Buf, WriteBuf[SzWrite], Result);
    Inc(SzWrite, Result);
  end;
  LeaveWriteCS;
  if SetNewData then SetEvt(oNewOutData);
end;

constructor TDevicePort.Create;
begin
  inherited Create;
{--- Critical Sections}
  InitializeCriticalSection(ReadCS);
  InitializeCriticalSection(StatCS);
  InitializeCriticalSection(WriteCS);
  InitializeCriticalSection(ComErrorCS);

{--- Semaphore Events }
  oFreeReadB   := CreateEvt(True);
  FoDataAvail   := CreateEvt(False);
  oNewOutData  := CreateEvt(False);
  FoOutDrained  := CreateEvt(True);
  oTempDown    := CreateEvt(False);
  oReadDowned := CreateEvt(False);
  oStatusDowned := CreateEvt(False);
  if oHandle = 0 then oHandle := CreateEvt(False);

  ReadOL.hEvent := CreateEvt(False);
  StatOL.hEvent := CreateEvt(False);
  WriteOL.hEvent := CreateEvt(False);

{--- In Thread}
  ReadThr := InClass.Create;
  with ReadThr do begin
    CP := Self;
    Priority := tpHigher;
  end;

{--- Out Thread}
  WriteThr := OutClass.Create;
  with WriteThr do begin
    CP := Self;
    Priority := tpHigher;
  end;

  FoDeltaDCDNotify := INVALID_HANDLE_VALUE;
  FoComErrorNotify := INVALID_HANDLE_VALUE;
  FComErrorColl := TColl.Create;

  PortsColl.Enter;
  PortsColl.Insert(Self);
  PortsColl.Leave;

  NewTimer(LastRead, 0);
  NewTimer(LastWrite, 0);

  MaxBPSOut := IniFile.OutBandwidth;
  MaxBPSIn := IniFile.InBandwidth

end;

destructor TDevicePort.Destroy;
begin

  PortsColl.Enter;
  PortsColl.Delete(Self);
  PortsColl.Leave;

  if ReadThr <> nil then begin

     CloseHW_A;

     ReadThr.Terminated := True;
     WriteThr.Terminated := True;

     SetEvt(oDataAvail);
     SetEvt(oFreeReadB);
     SetEvt(oNewOutData);
     SetEvt(oOutDrained);
     SetEvt(oReadDowned);

     SetEvt(ReadOL.hEvent);
     SetEvt(WriteOL.hEvent);

     SetEvt(oHandle);
     ReadThr.WaitFor; FreeObject(ReadThr);
     SetEvt(oHandle);
     WriteThr.WaitFor; FreeObject(WriteThr);

     CloseHW_B;

     FreeObject(FComErrorColl);

     ZeroHandle(oFreeReadB);
     ZeroHandle(FoDataAvail);
     ZeroHandle(oNewOutData);
     ZeroHandle(FoOutDrained);
     ZeroHandle(ReadOL.hEvent);
     ZeroHandle(WriteOL.hEvent);
     ZeroHandle(StatOL.hEvent);
     ZeroHandle(oTempDown);
     ZeroHandle(oReadDowned);
     ZeroHandle(oStatusDowned);
     ZeroHandle(oHandle);

     PurgeCS(ReadCS);
     PurgeCS(StatCS);
     PurgeCS(WriteCS);
     PurgeCS(ComErrorCS);
  end;

  inherited Destroy;
end;

procedure TDevicePort.SetDeltaDCDNotify(h: DWORD);
begin
  FoDeltaDCDNotify := h;
end;

procedure TDevicePort.SetCommErrorNotify(h: DWORD);
begin
  FoComErrorNotify := h;
end;

procedure TDevicePort.SetHoldStr(const S: string);
begin
  if S = '' then Exit;
  HoldStr := HoldStr + S;
  HoldLen := Length(HoldStr);
  HoldKept := True;
end;

function TDevicePort.GetChar(var C: Byte): Boolean;
begin
  if HoldKept then begin
    Result := True;
    Inc(HoldPos);
    if HoldPos > HoldLen then GlobalFail('TDevicePort.GetChar HoldPos(%d) > HoldLen(%d)', [HoldPos, HoldLen]);
    C := Byte(HoldStr[HoldPos]);
    if HoldPos = HoldLen then begin
      HoldKept := False;
      HoldStr := '';
      HoldPos := 0;
    end;
  end else begin
    Reload;
    if SzReadA = 0 then Result := False else begin
      Result := True;
      C := ReadA[PtrReadA]; Inc(PtrReadA);
    end;
  end;
end;

function TDevicePort._GetChar: Byte;
begin
  GetChar(Result);
end;

function TDevicePort.CharReady: Boolean;
begin
  if HoldKept then Result := True else begin
    Reload;
    Result := SzReadA > 0;
  end;
end;

procedure TDevicePort.Reload;
begin
  if (SzReadA = 0) and (SzReadB = 0) then Exit;
  if PtrReadA <> SzReadA then Exit;
  EnterCS(ReadCS);
  PtrReadA := 0; SzReadA := SzReadB;
  if SzReadB = 0 then
  ResetEvt(FoDataAvail)
  else
  begin
    Move(ReadB, ReadA, SzReadB);
    SzReadB := 0;
    SetEvt(oFreeReadB);
  end;
  LeaveCS(ReadCS);
end;

procedure TPort.SendString(const S: string);
var
  i: Integer;
begin
  for i := 1 to Length(S) do PutChar(Byte(S[I]));
end;

procedure TSerialPort.SetBPS(I: Integer);
var
  DCB: TDCB;

procedure GetCS;
var
  j: Integer;
begin
  j := 0;
  while not GetCommState(Handle, DCB) do begin
    Inc(j);
    if j = 10 then GlobalFail('TSerialPort.SetBPS GetCommState Error %d', [GetLastError]);
    ChkAbort;
  end;
end;

procedure SetCS;
var
  j: Integer;
begin
  j := 0;
  while not SetCommState(Handle, DCB) do begin
    Inc(j); if j = 10 then GlobalFail('TSerialPort.SetBPS SetCommState Error %d', [GetLastError]);
    ChkAbort;
  end;
end;

begin
  SleepDown;
  GetCS;
  DCB.Baudrate := I;
  SetCS;
  WakeUp;
end;

{ --- Serial Port }

function SetCommParams;

const
  fBinary            = $1;          // binary mode, no EOF check
  fParity            = $2;          // enable parity checking
  fOutxCtsFlow       = $4;          // CTS output flow control
  fOutxDsrFlow       = $8;          // DSR output flow control
  fDtrControlMask    = $10 + $20;   // DTR flow control type
  fDsrSensitivity    = $40;         // DSR sensitivity
  fTXContinueOnXoff  = $80;         // XOFF continues Tx
  fOutX              = $100;        // XON/XOFF out flow control
  fInX               = $200;        // XON/XOFF in flow control
  fErrorChar         = $400;        // enable error replacement
  fNull              = $800;        // enable null stripping
  fRtsControlMask    = $1000+$2000; // RTS flow control
  fAbortOnError      = $4000;       // abort reads/writes on error

  { DTR Control Flow Values. }
  fDtrDisable        =   0;
  fDtrEnable         = $10;
  fDtrHandShake      = $20;

  { RTS Control Flow Values}
  fRtsDisable        =     0;
  fRtsEnable         = $1000;
  fRtsHandshake      = $2000;
  fRtsToggle         = $3000;

var
  DCB: TDCB;
  f: LongInt;

begin
  Result := False;
  if not GetCommState(AHandle, DCB) then Exit;

  f := fBinary +
       fAbortOnError +
       fParity +
       fDtrEnable ;

  if ACTS_RTS  then Inc(f, fOutxCtsFlow + fRtsHandshake) else Inc(f, fRtsEnable);
  if AxOn_xOff then Inc(f, fOutX + fInX);

  with DCB do begin
    Flags    := f;
    BaudRate := ASpeed;
    ByteSize := ADataBits;
    Parity   := AParityType;
    StopBits := AStopBits;
  end;

  if not SetCommState(AHandle, DCB) then Exit;

  Result := True;
end;

procedure EnumSerialPorts(items: TStrings);
const
  BufSize     = 65535;
var
  Buf_DevList : Array[0..BufSize] of Char;
  DevName     : PChar;
  sDevName    : string;
  i           : integer;
  sPort       : string;
  cb          : array[0..999] of char;
  cc          :^TCommConfig;
  cs          : DWORD;
begin
  //Make sure we clear out any elements which may already be in the array
  items.clear;

  //On NT use the QueryDosDevice API
  if (Win32Platform = VER_PLATFORM_WIN32_NT) then
  begin
    //Use QueryDosDevice to look for all devices of the form COMx. This is a better
    //solution as it means that no ports have to be opened at all.
    if QueryDosDevice(nil, Buf_DevList, BufSize) = 0 then Exit;
    DevName := Buf_DevList;
    while DevName^ <> #00 do
    begin
      if (StrLIComp('COM', DevName, 3) = 0) and (Length(StrPas(DevName)) < 6) then
      begin
        sDevName := StrPas(DevName);
        items.Add(sDevName + ':');
      end;
      DevName := StrEnd(DevName) + 1;
    end;
  end else
  begin
    //Up to 255 COM ports are supported so we iterate through all of them seeing
    for i := 1 to MaxComports - 1 do // We support only 31 ports :)
    begin
      sPort := Format('COM%d', [i]);
      cs := 999;
      cc := @cb;
      if GetDefaultCommConfig(PChar(sPort), cc^, cs) then begin
         items.Add(sPort + ':');
      end;
    end;
  end;
end;

procedure FillDefaultTimeouts(var T: TCommTimeouts);
begin
  T.ReadIntervalTimeout :=         50; // MaxDWord;
  T.ReadTotalTimeoutMultiplier :=   0;
  T.ReadTotalTimeoutConstant :=     MaxDWord;
  T.WriteTotalTimeoutMultiplier :=  0; // MaxDWord;
  T.WriteTotalTimeoutConstant :=    0; // MaxDWord - 1;
end;

procedure FillExitTimeouts(var T: TCommTimeouts);
begin
  T.ReadIntervalTimeout :=          MaxDWord;
  T.ReadTotalTimeoutMultiplier  :=  0;
  T.ReadTotalTimeoutConstant :=     0;
  T.WriteTotalTimeoutMultiplier :=  0; // MaxDWord;
  T.WriteTotalTimeoutConstant :=    0; // MaxDWord - 1;
end;

procedure TSerialPort.SetExitTimeouts;
var
  T: TCommTimeouts;
begin
  FillExitTimeouts(T);
  SetTimeouts(T);
end;

procedure TSerialPort.SaveParams;
begin
  SetTimeouts(OrgTimeouts);
end;

procedure TSerialPort.RestoreParams;
begin
  SetTimeouts(DefTimeouts);
end;

procedure TSerialPort.SetTimeouts(T: TCommTimeouts);
var
  j: Integer;
  e: integer;
begin
  if FHandle = INVALID_HANDLE_VALUE then exit;
  j := 0;
  while (not SetCommTimeouts(FHandle, T)) and (FHandle <> INVALID_HANDLE_VALUE) do begin
    Inc(j);
    if j = 10 then begin
       e := GetLastError;
       if e = ERROR_INVALID_HANDLE then begin
          ComHandle := INVALID_HANDLE_VALUE;
          exit;
       end;
       if (StatThr = nil) or ((StatThr <> nil) and StatThr.Terminated) then exit;
       GlobalFail('TSerialPort.SetTimeouts SetCommTimeouts Error %d', [GetLastError]);
    end;
    ChkAbort;
  end;
end;

procedure TSerialPort.SetHandle;
begin
   if (Handle <> INVALID_HANDLE_VALUE) and (Handle <> FHandle) then begin
      FHandle := Handle;
      FillDefaultTimeouts(DefTimeouts);
      SetTimeouts(DefTimeouts);
      SetEvt(oHandle);
   end else begin
      FHandle := Handle;
   end;
end;

procedure TSerialPort.WaitClean;
var
   e: DWORD;
   o: TOverlapped;
   b: boolean;
begin
   o.hEvent := CreateEvt(False);
   e := 0;
   b := WaitCommEvent(FHandle, e, @o);
   exit;
   if not b then
   begin
      case GetLastError of
      ERROR_IO_PENDING :
         begin
            GetOverLappedResult(Handle, o, e, True);
         end;
      end;
   end;
   ZeroHandle(o.hEvent);
end;

procedure TSerialPort.ReadStatus;
var
  j: Integer;
  CommStatus: DWORD;
begin
  if FHandle <> INVALID_HANDLE_VALUE then begin
     j := 0;
     while (not GetCommModemStatus(FHandle, CommStatus)) and
           (FHandle <> INVALID_HANDLE_VALUE) do
     begin
       Sleep(100);
       Inc(j); if j = 10 then GlobalFail('TSerialPort.ReadStatus GetCommModemStatus Error %d', [GetLastError]);
       ChkAbort;
     end;
  end else begin
     CommStatus := MS_DSR_ON;
  end;
  FCTS := CommStatus and MS_CTS_ON <> 0;
  FDSR := CommStatus and MS_DSR_ON <> 0;
  if Inifile.IgnoreCD then begin
     FDCD := False;
  end else begin
{$IFNDEF RLSD}
     FDCD := CommStatus and MS_RLSD_ON <> 0;
{$ENDIF}
  end;
  FRI := CommStatus and MS_RING_ON <> 0;
end;

function TSerialPort.ReadNow: Integer;
begin
  Result := MaxD(MinD(PortInBufSize, ChkAbort), PortMinBufRead);
end;

procedure TSerialPort.SleepDown;
begin
  ResetEvt(oTempDown);
  TempDown := True;

  SetEvt(ReadOL.hEvent);
  SetEvt(StatOL.hEvent);

  if FHandle = INVALID_HANDLE_VALUE then exit;

  SetMask(EV_TXEMPTY);
  SetExitTimeouts;

  WaitEvtsAll([oReadDowned, oStatusDowned], INFINITE);

  ResetEvt(oReadDowned);
  ResetEvt(oStatusDowned);

  SaveParams;

end;

procedure TSerialPort.WakeUp;
begin
  FCarrier := RealDCD;
  TempDown := False;
  SetEvt(oTempDown);

  if FHandle = INVALID_HANDLE_VALUE then exit;

  WaitEvtsAll([oReadDowned, oStatusDowned], INFINITE);

  ResetEvt(oReadDowned);
  ResetEvt(oStatusDowned);
end;

procedure TSerialPort.CloseHW_A;
begin
  StatThr.Terminated := True;
  SetEvt(StatOl.hEvent);
  SetEvt(oTempDown);
  SetEvt(oHandle);
  SetEvt(oStatusDowned);
  StatThr.WaitFor;
  FreeObject(StatThr);
end;

procedure TSerialPort.CloseHW_B;
begin
  ZeroHandle(FHandle);
end;

procedure TSerialPort.HWPurge;
var
  AV: Integer;
begin
  AV := 0;
  if TX in Typ then Inc(AV, PURGE_TXCLEAR or PURGE_TXABORT);
  if RX in Typ then Inc(AV, PURGE_RXCLEAR or PURGE_RXABORT);
  PurgeComm(FHandle, AV);
end;

destructor TSerialPort.Destroy;
begin
  if StatThr <> nil then begin
     StatThr.Terminated := True;
     ReadThr.Terminated := True;
     WriteThr.Terminated := True;
     SetEvt(StatOL.hEvent);
     SetEvt(ReadOL.hEvent);
     SetEvt(WriteOL.hEvent);
     SetMask(EV_TXEMPTY);
     SetExitTimeouts;
  end;
  inherited Destroy;
end;

constructor TSerialPort.Create;
var
  j: Integer;
begin

  inherited Create(TSerialInThread, TSerialOutThread);

  ComHandle := AHandle;

{--- Status Thread}
  StatThr := TSerialStatusThr.Create;
  with StatThr do begin
     CP := Self;
     Priority := tpLower;
  end;

{--- Timeouts}
  if FHandle <> INVALID_HANDLE_VALUE then begin
     j := 0;
     while not GetCommTimeouts(FHandle, OrgTimeouts) do begin
        Inc(j);
        if (j = 10) or (GetLastError <> ERROR_OPERATION_ABORTED) then GlobalFail('TSerialPort.Create GetCommTimeouts Error', [GetLastError]);
        ChkAbort;
     end;
  end;
  FillDefaultTimeouts(DefTimeouts);
  SetTimeouts(DefTimeouts);

{--- Escape Funcitons}
  SetLine(Windows.CLRDTR); FDTR := False;

  ReadStatus;
  UpdateLineStatus;

  StatThr.Suspended := False;
  WakeThreads;
  FCarrier := RealDCD;
end;

function TSerialPort.RealDCD: Boolean;
begin
  EnterCS(StatCS);
  ReadStatus;
  UpdateLineStatus;
  LeaveCS(StatCS);
  Result := FDCD;
end;

procedure TSerialPort.SetLine(AOptions: Integer);
var
  j: Integer;
  e: Integer;
begin
  if FHandle = INVALID_HANDLE_VALUE then exit;
  j := 0;
  while not EscapeCommFunction(FHandle, AOptions) do begin
    Inc(j);
    e := GetLastError;
    if (j = 10) or (e <> ERROR_OPERATION_ABORTED) then begin
       if e = ERROR_INVALID_HANDLE then begin
          ComHandle := INVALID_HANDLE_VALUE;
          exit;
       end;
       GlobalFail('TSerialPort.SetLine EscapeCommFunction Error: %d', [e]);
    end;
    ChkAbort;
    Sleep(50);
  end;
end;

procedure TSerialPort.SetDTR(Value: Boolean);
const
  Cmd_DTR : array[Boolean] of Integer = (Windows.CLRDTR, Windows.SETDTR);
begin
  EnterCS(StatCS);
  if Value <> FDTR then begin
     SetLine(Cmd_DTR[Value]);
     FDTR := Value;
     UpdateLineStatus;
  end;
  LeaveCS(StatCS);
end;

procedure TSerialPort.SetRTS(Value: Boolean);
const
  Cmd_RTS : array[Boolean] of Integer = (Windows.CLRRTS, Windows.SETRTS);
begin
  GlobalFail('%s', ['SetRTS?']);
  EnterCS(StatCS);
  if Value <> FRTS then begin
     SetLine(Cmd_RTS[Value]);
     FRTS := Value;
     UpdateLineStatus;
  end;
  LeaveCS(StatCS);
end;

function TSerialPort.ChkAbort;
var
   e: DWORD;
  cs: TComStat;
  ee: TComError;
begin
  if FHandle = INVALID_HANDLE_VALUE then begin
     Result := 0;
     exit;
  end;
  ClearCommError(FHandle, e, @cs);
  Result := cs.cbInQue;
  if e <> 0 then begin
     ee := TComError.Create;
     ee.Err := e;
     ee.cs := cs;
     InsComErr(ee);
   end;
end;

procedure TSerialPort.SetMask(Arg: Integer);
var
  j: Integer;
  e: Integer;
begin
  if FHandle = INVALID_HANDLE_VALUE then begin
     exit;
  end;
  j := 0;
  while not SetCommMask(FHandle, Arg) do begin
    Inc(j);
    e := GetLastError;
    if (j = 10) or (e <> ERROR_OPERATION_ABORTED) then begin
       if e = ERROR_INVALID_HANDLE then begin
          ComHandle := INVALID_HANDLE_VALUE;
          exit;
       end;
       if (StatThr = nil) or ((StatThr <> nil) and StatThr.Terminated) then exit;
       GlobalFail('TSerialStatusThr.ThreadExec SetCommMask Error %d', [GetLastError]);
    end;
    ChkAbort;
  end;
end;

class function TSerialStatusThr.ThreadName: string;
begin
  Result := 'Port Status';
end;

procedure TSerialStatusThr.InvokeExec;

procedure DoTempDown;
begin
  CP.SetMask(0);
  SetEvt(CP.oStatusDowned);
  WaitEvtInfinite(CP.oTempDown, 'oTempDown');
  SetEvt(CP.oStatusDowned);
  Again := False;
end;

procedure DoGeneric;
var
  Actually: DWORD;
  b: Boolean;
begin
  EnterCS(CP.StatCS);
  CP.ReadStatus;
  CP.UpdateLineStatus;
  LeaveCS(CP.StatCS);

  ResetEvt(CP.StatOL.hEvent);
  b := WaitCommEvent(CP.FHandle, EvtMask, @CP.StatOL);
  if not b then
  begin
    case GetLastError of
      ERROR_IO_PENDING:
        begin
          b := GetOverLappedResult(CP.FHandle, CP.StatOL, Actually, not (CP.TempDown or Terminated));
          if not b then
          begin
            case GetLastError of
              ERROR_INVALID_HANDLE:;
              ERROR_INVALID_PARAMETER:;
              ERROR_NOACCESS,
              ERROR_IO_INCOMPLETE,
              ERROR_OPERATION_ABORTED: CP.ChkAbort;
              else
              GlobalFail('TSerialStatusThr.ThreadExec GetOverLappedResult Error %d', [GetLastError]);
            end;
          end;
        end;
      ERROR_INVALID_HANDLE,
      ERROR_INVALID_PARAMETER:;
      ERROR_NOACCESS,
      ERROR_OPERATION_ABORTED: CP.ChkAbort;
      else
      GlobalFail('TSerialStatusThr.ThreadExec WaitCommEvent Error %d', [GetLastError]);
    end;
  end;
end;

begin
  if Terminated then exit;
  if CP.FHandle = INVALID_HANDLE_VALUE then begin
     EnterCS(CP.StatCS);
     CP.ReadStatus;
     CP.UpdateLineStatus;
     LeaveCS(CP.StatCS);
     WaitEvtInfinite(CP.oHandle, 'oHandle');
     ResetEvt(CP.oHandle);
  end;
  if Terminated then exit;
  if not Again then
  begin
    Again := True;
  end;
  CP.SetMask(ModemTraceMask);
  if CP.TempDown then DoTempDown else DoGeneric;
end;

function TSerialOutThread.Write(const Buf; Size: DWORD): DWORD;
var
  OL : POverlapped;
  r: Boolean;
begin
  OL := @TSerialPort(CP).WriteOL;
  r := WriteFile(CP.FHandle, Buf, Size, Result, OL);
  if not r then
  begin
    case GetLastError of
      ERROR_IO_PENDING :
        if GetOverLappedResult(CP.FHandle, OL^, Result, True) <> TRUE then
        begin
          case GetLastError of
            ERROR_INVALID_HANDLE,
            ERROR_INVALID_PARAMETER:;
            ERROR_NOACCESS,
            ERROR_OPERATION_ABORTED :TSerialPort(CP).ChkAbort;
          else
            GlobalFail('TSerialOutThread.Write GetOverLappedResult Error %d', [GetLastError]);
          end;
        end;
      ERROR_INVALID_HANDLE,
      ERROR_INVALID_PARAMETER:;
      ERROR_NOACCESS,
      ERROR_OPERATION_ABORTED: TSerialPort(CP).ChkAbort;
      else
      GlobalFail('TSerialOutThread.Write WriteFile Error %d', [GetLastError]);
    end;
  end;
end;

class function TSerialOutThread.ThreadName;
begin
   Result := 'Interface out (COM)';
end;

function TSerialInThread.Read(var Buf; Size: DWORD): DWORD;
var
  OL : POverlapped;
  r: Boolean;
begin
  if CP.FHandle = INVALID_HANDLE_VALUE then begin
     WaitEvtInfinite(CP.oHandle);
     ResetEvt(CP.oHandle);
  end;
  if Terminated then exit;
  OL := @CP.ReadOL;
  r := ReadFile(CP.FHandle, Buf, Size, Result, OL);
  if not r then
  begin
    case GetLastError of
      ERROR_IO_PENDING :
        if GetOverLappedResult(CP.FHandle, OL^, Result, not (CP.TempDown or Terminated)) <> TRUE then
        case GetLastError of
          ERROR_INVALID_HANDLE,
          ERROR_INVALID_PARAMETER:;
          ERROR_NOACCESS,
          ERROR_IO_INCOMPLETE,
          ERROR_OPERATION_ABORTED : TSerialPort(CP).ChkAbort;
          else
          GlobalFail('TSerialInThread.Read GetOverLappedResult Error %d', [GetLastError]);
        end;
      ERROR_INVALID_HANDLE,
      ERROR_INVALID_PARAMETER:;
      ERROR_NOACCESS,
      ERROR_OPERATION_ABORTED: TSerialPort(CP).ChkAbort;
      else
      GlobalFail('TSerialInThread.Read ReadFile Error %d', [GetLastError]);
    end;
  end;
end;

class function TSerialInThread.ThreadName;
begin
   Result := 'Interface in  (COM)';
end;

/////////////////////////////////////////////////////////////////////////
//                                                                     //
//                       FILE TRANSFER PROTOCOLS                       //
//                                                                     //
/////////////////////////////////////////////////////////////////////////

function  TOneWayProtocol.Timeout: Boolean;
begin
  if TimerExpired(TimeoutTimer)
  then
    Result := True
  else
    Result := False;
end;

constructor TChat.Create;
var
  ThreadID: LongWord;
  tf: TThreadFunc;
begin
  Log := TLogContainer.Create;
  LogLastLine := false;
  Log.FTag := ltRasDial;
  Log.FMsg := 0;
  Log.FName := MakeNormName(IniFile.Log, Format('chat_%s.log',['logname']));
  Log.FName := ExtractFilePath(LogFName) + 'chat_' + ExtractFileName(LogFName);
  LogCount := 1;
  self.ChatBell := ChatBell;
  BaseProtocol := BaseP;
  Memo1Text := TStringList.Create;
  Memo2Text := TStringList.Create;
  fRemoteVisible := True;
  if (not ALocal) and (ChatBell <> '') and (ChatBell <> '0') then
  begin
    tf := ChatBellThreadFunc;
    BeginThread(nil, 65536, tf, pchar(chatbell), 0, ThreadId);
  end;
end;

destructor TChat.Destroy;
begin
  if LogLastLine then begin
     Log.Log(FormatLogStr(ltPolls, ExtractWord(WordCount(Memo1Text.Text, [#13, #10]), Memo1Text.Text, [#13, #10]), 'Remote'));
  end;
  FreeObject(Memo1Text);
  FreeObject(Memo2Text);
  FreeObject(Log);
end;

function TChat.GetChatStr;
var
  str1,
  str: string;
  i: integer;
begin
   Result := ChatStr;
   ChatStr := '';
   if DispStr = '' then exit;
   Log.Log(FormatLogStr(ltPolls, Dos2Win(DispStr), 'OurSide'));
   Memo2Text.Text := Memo2Text.Text + ExtractWord(1, Dos2Win(DispStr), [#13, #10]);
   if wordcount(DispStr, [#10, #13]) > 1 then
   begin
     for i := 2 to WordCount(DispStr, [#10, #13]) do begin
       str1 := ExtractWord(i, DispStr, [#10, #13]);
       Memo2Text.Add(str1);
     end;
   end else
   if DispStr[length(DispStr)] = #$a then Memo2Text.Add('');
   str := Memo2Text.Strings[Memo2Text.Count - 1];
   processbs(str);
   Memo2Text.Strings[Memo2Text.Count - 1] := str;
   DispStr := '';
end;

function TChat.GetTimeout;
begin
   result := round((Time() - LastKey) * 100000);
end;

procedure TChat.SetVisible;
begin
   fWeAreVisible := v;
   if not v  and fRemoteVisible then
   begin
//     ChatStr := #10' * SysOp finished chat. * '#10#10;
   end;
end;

procedure TChat.AddMsg;
var
   r: string;
   s: string;
   i: integer;
  wc: integer;
begin
   r := '';
   s := t;
   if t = '' then exit;
   Collector := Collector + t;
   processbs(Collector);

   wc := wordcount(Collector, [#$0A]);

   Memo1Text.Clear;

   for i := 1 to wc do begin
      Memo1Text.Add(Dos2Win(ExtractWord(i, collector, [#10])));
   end;

   if (length(t) > 0) and (Collector[length(Collector)] <> #10) then begin
     loglastline := true;
     dec(wc);
   end else begin
     loglastline := false;
   end;

   for i := LogCount to wc do begin
     Log.Log(FormatLogStr(ltPolls, Dos2Win(ExtractWord(i, Collector, [#$0A])), 'Remote'));
   end;

   LogCount := wc + 1;
end;

function TBaseProtocol.TxClosed: Boolean;
begin
  Result := (T = nil) or (T.Stream = nil);
end;

function TBaseProtocol.RxClosed: Boolean;
begin
  Result := (R = nil) or (R.Stream = nil);
end;

procedure TBaseProtocol.CalcTimeout(var VTimeout: DWORD; AMax, AMin: DWORD);
begin
  VTimeOut := 81920 div MaxD(Speed, 300);
  If (VTimeOut < AMin) then VTimeOut := AMax else
  If (VTimeOut > AMax) then VTimeOut := AMax;
end;

procedure TBaseProtocol.CalcBlockSize(var VMax, VCur: DWORD; AMax, AMin: DWORD);
begin
  VMax := (MaxD(Speed, 300) * 128) div 300;

  if VMax < AMin * 4 then VMax := AMin * 4 else
  if VMax > AMax then VMax := AMax;

  VCur := VMax div 4;
  if VCur < AMin then VCur := AMin;

  VMax := AMax;

  VCur := MinD(VMax, 1 shl (NumBits(VCur) - 1));

end;

procedure TBaseProtocol.DbgLog(const s: string);
begin
  CustomInfo := s;
  FLogFile(Self, lfDebug);
end;

procedure TBaseProtocol.DbgLogFmt(const Fmt: string; const Args: array of const);
begin
  DbgLog(Format(Fmt, Args));
end;

procedure TBaseProtocol.Finish;
begin
  FreeObject(T);
  FreeObject(R);
end;

procedure TBaseProtocol.IncTotalErrors;
begin
  Inc(TotalErrors);
end;

procedure TOneWayProtocol.IncBlockErrors;
begin
  Inc(BlockErrors);
end;

constructor TBaseProtocol.Create;
begin
  inherited Create;
  InitializeCriticalSection(CS);
  CP := ACP;
  if ZLibLoaded then begin
    _compress := compress_;
    _uncompress := uncompress_;
  end;
  ListBuf := TStringColl.Create;
end;

constructor TOneWayProtocol.Create;
begin
  inherited Create(ACP);
end;

destructor TBaseProtocol.Destroy;
begin
  FreeObject(OutFiles);
  FreeObject(OutPaths);
  FreeObject(RemFiles);
  FreeObject(RemImage);
  FreeObject(RecFiles);
  FreeObject(ListBuf);
  if T <> nil then FreeObject(T.Stream);
  if R <> nil then FreeObject(R.Stream);
  Finish;
  PurgeCS(CS);
  inherited Destroy;
end;

function TBaseProtocol.Name: string;
begin
  Name := ProtocolNames[ID];
end;

var
  UniqCounter: Integer;

function TBaseProtocol.GetUniqStr;
var
  r: packed record
    FT: TFileTime;
    TC: DWORD;
    MC: Integer;
    UC: Integer;
    PN: Integer;
    PI: Integer;
    RI: DWORD;
    C1: Integer;
  end;
  D: TMD5Byte16;
  C: TMD5Ctx;
  ci: string;
  cil: Integer;
begin
  GetSystemTimeAsFileTime(r.FT);
  r.MC := AllocMemCount;
  r.TC := GetTickCount;
  r.UC := InterlockedIncrement(UniqCounter);
  r.PN := CP.PortNumber;
  r.PI := CP.PortIndex;
  r.RI := xRandom32;
  MD5Init(C);
  MD5Update(C, r, SizeOf(r));
  ci := CP.CallerId; cil := Length(ci);
  if cil > 0 then MD5Update(C, ci[1], cil);
  MD5Final(D, C);
  UniqStr := DigestToStr(D);
  Result := UniqStr;
end;

procedure TBaseProtocol.StartChat;
var
  str: string;
begin
  str := Format('Chat with %s, sysop of %s (%s)',[FiSysop, FiStation, Addr2Str(FiAddr)]);
  if not ChatOpened then begin
     Chat := TChat.Create(Local, LogFName, Self, ChatBell);
     Chat.ChatStr := #10' * Hello ' + ExtractWord(1, FiSysOp, [' ']) + '!'#10' * Logging is on'#10;
     Chat.Log.LogSelf(str);
  end;
  if not chat.visible then begin
     Chat.Visible := true;
  end;
  Chat.Caption := str;
  ChatOpened := True;
end;

function TBaseProtocol.CanChat;
begin
   Result := False;
end;

function TBaseProtocol.Compress;
begin
   result := 1;
   try
     if ZLibLoaded then begin
        EnterCS(CS);
        result := _compress(dest, res, src, len, 9);
        LeaveCS(CS);
     end;
   except
     result := -1
   end;
end;

function TBaseProtocol.Uncompress;
begin
   result := 1;
   try
     if ZLibLoaded then begin
        EnterCS(CS);
        result := _uncompress(dest, res, src, len);
        LeaveCS(CS);
     end;
   except
     result := -1
   end;
end;

{$IFDEF EXTREME}

constructor TInetProtocol.Create;
begin
   inherited;
   LList := TStringColl.Create;
end;

destructor TInetProtocol.Destroy;
begin
   FreeObject(LList);
   inherited;
end;

function poscn(c: char; const s: string; n: integer): integer;
var
  i: integer;
begin
  if n = 0 then  n := 1;
  if n > 0 then begin
     for i := 1 to length(s) do begin
        if s[i] <> c then begin
           dec(n);
           result := i;
           if n = 0 then begin
              exit;
           end;
        end;
     end;
  end else begin
     for i := length(s) downto 1 do begin
        if s[i] <> c then begin
           inc(n);
           result := i;
           if n = 0 then begin
              exit;
           end;
        end;
     end;
  end;
  poscn := 0;
end;

const
  bin2uue: string = '`!"#$%&''()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_';
//  uue2bin: string = ' !"#$%&''()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_ ';

type
  ta_8u = packed array [0..65530] of byte;

CONST
   offset = 32;

function TInetProtocol.Decode_UUDec;
VAR
   lineIndex,
   byteNum,
   count, i: Integer;
   chars: ARRAY [0..3] OF Byte;
   hunk: ARRAY [0..2] OF Word;
   Line: string;

   FUNCTION nextch: Char;
   BEGIN {nextch}
      Result := #0;
      lineIndex := Succ(lineIndex);
      IF lineIndex > Length(Line) THEN {abort('Line too short.')};
      IF NOT (Line[lineindex] IN [' '..'`']) THEN exit;
      IF Line[lineindex] = '`' THEN nextch := ' '
                               ELSE nextch := Line[lineIndex]
   END; {nextch}

   PROCEDURE DecodeByte;

      PROCEDURE GetNextHunk;
      VAR
         i: Integer;

      BEGIN {GetNextHunk}
         FOR i := 0 TO 3 DO chars[i] := Ord(nextch) - offset;
         hunk[0] := (chars[0] SHL 2) + (chars[1] SHR 4);
         hunk[1] := (chars[1] SHL 4) + (chars[2] SHR 2);
         hunk[2] := (chars[2] SHL 6) + chars[3];
         byteNum := 0;
      END; {GetNextHunk}

   BEGIN {DecodeByte}
      IF byteNum = 3 THEN GetNextHunk;
      Result := Result + Chr(hunk[byteNum]);
      byteNum := Succ(byteNum)
   END; {DecodeByte}

BEGIN {DecodeLine}
   if copy(Inp, 1, 2) = '..' then begin
      Result := Decode_UUDec(copy(Inp, 2, Length(Inp) - 1));
      exit;
   end;
   Result := '';
   Line := Inp;
   lineIndex := 0;
   byteNum := 3;
   count := (Ord(nextch) - offset);
   FOR i := 1 TO count DO DecodeByte
END; {DecodeLine}

function TInetProtocol.Encode_UUEnc(const inp; size: integer): string;
var
  buff: ta_8u absolute inp;
  offset: shortint;
  pos1,pos2: byte;
  i: byte;
  out: string;
begin
  setlength(out, size * 4 div 3 + 4);
  fillchar(out[1], size * 4 div 3 + 2, #0);
  out[1] := char(((size - 1) and $3f) + $21);
  size := ((size + 2) div 3) * 3;
  offset := 2;
  pos1 := 0;
  pos2 := 2;
  out[pos2] := #0;
  while pos1 < size do begin
     if offset > 0 then begin
        out[pos2] := char(ord(out[pos2]) or ((buff[pos1] and ($3f shl offset)) shr offset));
        offset := offset - 6;
        inc(pos2);
        out[pos2] := #0;
     end else
     if offset < 0 then begin
        offset := abs(offset);
        out[pos2] := char(ord(out[pos2]) or ((buff[pos1] and ($3f shr offset)) shl offset));
        offset := 8 - offset;
        inc(pos1);
     end else begin
        out[pos2] := char(ord(out[pos2]) or ((buff[pos1] and $3f)));
        inc(pos2);
        inc(pos1);
        out[pos2] := #0;
        offset := 2;
     end;
  end;
  if offset = 2 then dec(pos2);
  for i := 2 to pos2 do out[i] := bin2uue[ord(out[i]) + 1];
  Result := copy(out, 1, pos2);
end;

function TInetProtocol.CanSend: Boolean;
begin
  Result := (CP.OutUsed < 4096);
end;

procedure TInetProtocol.CheckInput;
var
   C: byte;
   s: string;
begin
   while CP.CharReady and (LList.Count < 101) do begin
      if CP.GetChar(C) then begin
         if (C in [10, 13]) then begin
            bBuff := bBuff + Chr(C);
            if TBuff <> '' then begin
               if TBuff[1] = #9 then begin
                  if LList.Count > 0 then begin
                     s := LList[LList.Count - 1];
                     s := s + ' ' + Copy(TBuff, 2, Length(TBuff) - 1);
                     LList[LList.Count - 1] := s;
                  end else begin
                     LList.Add(copy(TBuff, 1, Length(TBuff) - 1));
                  end;
               end else begin
                  LList.Add(TBuff);
               end;
               TBuff := '';
            end else begin
               if (Length(bBuff) > 2) and (C = 10) then begin
                  LList.Add('');
                  exit;
               end;
            end;
            NewTimerSecs(Timer, BinkPTimeout);
         end else begin
            TBuff := TBuff + Chr(C);
            bBuff := '';
         end;
      end;
   end;
end;

procedure TInetProtocol.PutString;
var
   i: integer;
   a: string;
begin
   if IniFile.FTPDebug then begin
      DbgLog('> ' + s);
   end;
   a := s;
   if (ID = piSMTP) and (Length(s) > 1) and (s[1] = '.') then begin
      a := '.' + s;
   end;
   for i := 1 to length(a) do CP.PutChar(ord(a[i]));
   if self.ID in [piSMTP, piPOP3, piGATE, piNNTP] then begin
      CP.PutChar(13);
   end;
   CP.PutChar(10);
   CP.Flsh;
   while (CP.OutUsed > 0) and CP.DCD do Sleep(100);
end;

function TInetProtocol.ExtractParam;
var
   a,
   b,
   c: string;
begin
   Result := d;
   a := s;
   while a <> '' do begin
      GetWrd(a, b, ';');
      GetWrd(b, c, '=');
      if Trim(UpperCase(k)) = Trim(UpperCase(c)) then begin
         RepackString(b, ['"'], '');
         Result := Trim(b);
         exit;
      end;
   end;
end;

procedure TInetProtocol.SendHeader;
var
   a: TAdvNode;
   s: string;
begin
   PutString('From: ' + Station.Sysop + ' <' + Addr2Str(IniFile.MainAddr) + '>');
   if ipAddr <> '' then begin
      PutString('To: <' + ExtractWord(1, ipAddr, ['"']) + '>');
   end else begin
      a := FindNode(FiAddr);
      s := 'SysOp';
      if a <> nil then begin
         s := a.Sysop;
         FreeObject(a);
      end;
      PutString('To: ' + s + ' <' + Addr2Str(FiAddr) + '>');
   end;
   PutString('Subject: FTN Mail Transport ' + '(' + f + ')');
   PutString('Date: ' + RFCDateUTC);
   PutString('Organization: ' + Station.Station + ' [' + Addr2Str(IniFile.MainAddr) + ']');
   PutString('Reply-to: ' + Station.Sysop + ' <' + Addr2Str(IniFile.MainAddr) + '>');
   PutString('Message-Id: ' + GetUniqStr);
   PutString('X-Mailer: ' + ProductName + '/' + ProductVersion);
   PutString('X-FTN-Sender: ' + Addr2Str(IniFile.MainAddr));
   PutString('X-FTN-Receiver: ' + Addr2Str(FiAddr));
end;

procedure TInetProtocol.SendSEATHd;
begin
   PutString;
   PutString('Ftn-Addr: ' + Addr2Str(FiAddr));
   PutString('Ftn-Orig: ' + Addr2Str(IniFile.MainAddr));
   PutString('Ftn-Auth: ' + MD5);
   PutString;
   PutString('Ftn-File: ' + T.d.FName);
   PutString('Ftn-File-Id: ' + T.d.FName + '@' + HexL(CRC));
   PutString('Ftn-Date: ' + IntToStr(T.d.FTime));
   PutString('Ftn-Size: ' + IntToStr(T.d.FSize));
   PutString('Ftn-Crc32: ' + HexL(CRC));
   PutString('Ftn-Encoding: uuencode');
   PutString('Ftn-Seg: 1-1');
   PutString('Ftn-Seg-Id: 1-1-' + T.d.FName + '@' + HexL(CRC));
   PutString('Ftn-Seg-Crc32: ' + HexL(CRC));
   PutString;
   PutString('begin 644 ' + T.d.FName);
end;

procedure TInetProtocol.HandleFile;
var
   i: integer;
   C: byte;
   x: TMD5ctx;
   d: TMD5Byte16;
begin
   CRC := CRC32_INIT;
   MD5Init(x);
   for i := 0 to f.Size - 1 do begin
      f.Read(C, 1);
      CRC := UpdateCRC32(C, CRC);
      MD5Update(x, c, 1);
   end;
   T.Stream.Position := 0;
   MD5Final(D, X);
   Auth := DigestToStr(d);
   CustomInfo := FiPassword;
   if (CustomInfo = '') and Originator then begin
      FLogFile(Self, lfBinkPgPwd);
      CustomInfo := Trim(CustomInfo);
   end;
   if CustomInfo = '' then CustomInfo := '-';
   Auth := KeyedMD5(CustomInfo[1], Length(CustomInfo), Auth[1], Length(Auth));
end;

function TInetProtocol.PreFile;
var
   a: string;
   b: string;
begin
   Result := True;
   CustomInfo := '';
   if z = 'FTN-FILE:' then begin
      R.d.FName := s;
   end else
   if z = 'FTN-FILE-ID:' then begin
      fFlId := s;
   end else
   if z = 'FTN-CRC32:' then begin
      rmCRC := VlH(s);
   end else
   if z = 'FTN-AUTH:' then begin
      fCram := s;
   end else
   if z = 'FTN-ENCODING:' then begin
      a := UpperCase(s);
      if a = 'BASE64' then fCode := cB64 else
      if a = 'UUENCODE' then fCode := cUUE else fCode := cUnk;
   end else
   if z = 'X-FTN-RECEIVER:' then begin
      fStam := s;
   end else
   if fMime and (z = 'CONTENT-TRANSFER-ENCODING:') then begin
      if UpperCase(s) = 'BASE64' then fCode := cB64 else
      if UpperCase(s) = 'X-UUE' then fCode := cUUE;
   end else
   if z = 'CONTENT-TYPE:' then begin
      if fMime then begin
         rmCRC := VlH(ExtractParam('CRC32', s, '0'));
         R.d.FName := ExtractParam('NAME', s, '');
         fSize := StrToIntDef(ExtractParam('size', s, ''), fSize);
      end else begin
         nBoun := ExtractParam('boundary', s, nBoun);
      end;
   end else
   if z = '--' + UpperCase(nBoun) then begin
      fMime := True;
   end else
   if fMime and (z = 'CONTENT-DISPOSITION:') then begin
      R.d.FName := ExtractParam('filename', s, R.d.FName);
      R.d.FTime := uGetSystemTime;
      fCram := ExtractParam('auth', s, '');
   end else
   if fMime and (z = '') and (R.d.FName <> '') then begin
      case FAcceptFile(Self) of
      aaOK :
         begin
            R.d.FSize := fSize;
            dwCRC := CRC32_INIT;
            MD5Init(dwCTX);
            CustomInfo := 'Rece';
         end;
      aaRefuse :
         begin
            AbortRece('file refused');
         end;
      aaAcceptLater :
         begin
            AbortRece('file will be accepted later');
         end;
      aaAbort :
         begin
            AbortRece('operation aborted');
         end;
      end;
   end else
   if z = 'BEGIN' then begin
      a := s;
      GetWrd(a, b, ' ');
      fCode := cUUE;
      R.d.FTime := uGetSystemTime;
      if R.d.FName = '' then begin
         R.d.FName := a;
      end;
      case FAcceptFile(Self) of
      aaOK :
         begin
            R.d.FSize := fSize;
            dwCRC := CRC32_INIT;
            MD5Init(dwCTX);
            CustomInfo := 'Rece';
         end;
      aaRefuse :
         begin
            AbortRece('file refused');
         end;
      aaAcceptLater :
         begin
            AbortRece('file will be accepted later');
         end;
      aaAbort :
         begin
            AbortRece('operation aborted');
         end;
      end;
   end else Result := False;
end;

procedure TInetProtocol.RecFile;
begin
   R.d.FPos := R.d.FPos + DWORD(Length(a)) + 2;
   if fMime and (fCode = cB64) and ((z = '') or (z[1] = '-') or (z = '.')) then begin
      fMime := False;
      if z = '--' + UpperCase(nBoun) then begin
         fMime := True;
      end;
      FinisRece(z);
   end else
   if z = 'END' then begin
      FinisRece('OK');
   end else begin
      fLine := '';
      case fCode of
   cB64: fLine := DecodeB64(Trim(a));
   cUNK,
   cUUE: fLine := Decode_UUDec(Trim(a));
      end;
      RecStep;
   end;
end;

function TInetProtocol.RecStep;
var
   i: integer;
begin
   Result := True;
   if fLine = '' then exit;
   NewTimerSecs(Timer, BinkPTimeout);
   for i := 1 to Length(fLine) do dwCRC := UpdateCRC32(ord(fLine[i]), dwCRC);
   MD5Update(dwCTX, fLine[1], Length(fLine));
   if (R.Stream.Write(fLine[1], Length(fLine)) <> DWORD(Length(fLine))) or (GetErrorNum <> 0) then begin
      AbortRece(GetErrorMsg);
      FFinishRece(Self, aaSysError);
      Result := False;
      exit;
   end else begin
//      R.d.FPos := R.Stream.Position;
   end;
end;

procedure TInetProtocol.SendFile;
var
   i: integer;
   j: integer;
   s: string;
begin
   while CanSend do begin
      i := MinD(90, T.D.FSize - T.D.FPos);
      SetLength(s, i);
      i := T.Stream.Read(s[1], i);
      j := 1;
      while j <= Length(s) do begin
         if s[j]  = #1 then begin
            s[j] := '@';
         end else
         if s[j]  = #13 then begin
            s[j] := #10;
         end;
         fBuff := fBuff + s[j];
         if s[j] = #10 then begin
            if copy(fBuff, 1, 5) = 'AREA:' then fBuff := '' else
            if fBuff[1] = '@' then fBuff := '' else
            if copy(fBuff, 1, 8) = 'SEEN-BY:' then fBuff := '';
            CP.SendString(fBuff);
            fBuff := '';
         end;
         inc(j);
      end;
//      CP.SendString(fBuff);
      Inc(T.d.FPos, i);
      if T.d.FPos = T.d.FSize then begin
         CP.SendString(fBuff);
         fBuff := '';
         PutString;
         PutString('.');
         SendFTPFile := True;
         CustomInfo := fName;
         FFinishSend(Self, aaOK);
         FinisSend;
         break;
      end;
      if T.d.FPos mod 9000 = 0 then begin
         break;
      end;
   end;
end;

{$ENDIF}

function TOneWayProtocol.TimeoutValue: DWORD;
begin
  TimeoutValue := MultiTimeout([TimeoutTimer]);
end;

procedure TOneWayProtocol.SignalFinish;
begin
  if ProtocolError = ecOk then begin
    case ProtocolStatus of
      psAbortByLocal   : ProtocolError := ecAbortByLocal;
      psAbortByRemote  : ProtocolError := ecAbortByRemote;
      psTimeout        : ProtocolError := ecTimeout;
      psAbortNoCarrier : ProtocolError := ecAbortNoCarrier;
    end;
  end;
end;

function TOneWayProtocol.IsBiDir: Boolean;
begin
  Result := False;
end;

function TBiDirProtocol.IsBiDir: Boolean;
begin
  Result := True;
end;

procedure TBiDirProtocol.Start;
begin
  FAcceptFile := AAcceptFile;
  FFinishRece := AFinishRece;
  FGetNextFile := AGetNextFile;
  FFinishSend := AFinishSend;
  FChangeOrder := AChangeOrder;
  DoStart;
  T := TBatch.Create;
  R := TBatch.Create;
end;

procedure TBiDirProtocol.ProcessLST;
var
   s,
   z,
   t: string;
   i: integer;
begin
   s := l;
   GetWrd(s, z, ' ');
   while trim(s) <> '' do begin
      GetWrd(s, z, ' ');
      if UpperCase(z) = 'CLR' then begin
         FreeObject(RemFiles);
         break;
      end;
      t := z;
      GetWrd(s, z, ' ');
      t := t + ' ' + z;
      if RemFiles = nil then RemFiles := TStringColl.Create;
      if RecFiles = nil then RecFiles := TStringColl.Create;
      RemFiles.Enter;
      RecFiles.Enter;
      i := RemFiles.Matched(ExtractWord(1, t, [' ']));
      if i = -1 then begin
         if (RecFiles.FoundUC(ExtractWord(1, t, [' ']))) then begin
            RecFiles.AtFree(RecFiles.IdxOfUC(ExtractWord(1, t, [' '])));
         end else begin
            if RecFiles.Count = 0 then begin
               RemFiles.Add(t);
            end else begin
               RecFiles.AtFree(0);
            end;
         end;
      end else begin
         RemFiles.AtIns(i, t);
         RemFiles.AtFree(i);
      end;
      RecFiles.Leave;
      RemFiles.Leave;
   end;
end;

procedure TBiDirProtocol.SendFList;
var
   i: integer;
   b: boolean;
begin
   if RemImage = nil then begin
      RemImage := TStringColl.Create;
   end;
   FillOutList := True;
   FGetNextFile(Self);
   b := CollMax(OutFiles) > CollMax(RemImage);
   if not b then begin
      for i := 0 to CollMax(OutFiles) do begin
         if OutFiles[i] <> RemImage[i] then begin
            b := True;
            break;
         end;
      end;
   end;
   if b and (OutFiles.Count <> 1) then begin
      for i := 0 to OutFiles.Count - 1 do begin
         if not RemImage.Found(OutFiles[i]) then begin
            ListBuf.Add('LST ' + OutFiles[i]);
         end;
      end;
   end;
   RemImage.FreeAll;
   OutFiles.AppendTo(RemImage);
end;

procedure TBiDirProtocol.StartBatch;
begin
end;

procedure TBaseProtocol.DoStart;
begin
  ProtocolError := ecOK;
  TotalErrors := 0;
end;

procedure TOneWayProtocol.Start;
begin
  FAcceptFile := nil;
  FGetNextFile := nil;
  if Assigned(AAcceptFile) then begin
    R := TBatch.Create;
    PrepareReceive(AAcceptFile, AFinishRece)
  end else
  if Assigned(AGetNextFile) then begin
    T := TBatch.Create;
    PrepareTransmit(AGetNextFile, AFinishSend);
  end;
  DoStart;
end;

function TOneWayProtocol.NextStep: Boolean;
begin
  if Assigned(FAcceptFile) then Result := Receive else
  if Assigned(FGetNextFile) then Result := Transmit else begin
     Result := False;
     GlobalFail('%s', ['TOneWayProtocol.NextStep both FAcceptFile and FGetNextFile are unassigned']);
  end;
  if Result then Finish;
end;

class function TLampsThread.ThreadName: string;
begin
  Result := 'Lamps Watcher';
end;

constructor TLampsThread.Create;
begin
  inherited Create;
  Priority := tpLower;
  oStatusChange := CreateEvtA;
end;

procedure TLampsThread.InvokeExec;
begin
  WaitEvtInfinite(oStatusChange);
  if Terminated then Exit;
  PostMessage(MainWinHandle, WM_UPDATELAMPS, 0, 0);
end;

destructor TLampsThread.Destroy;
begin
  ZeroHandle(oStatusChange);
  inherited Destroy;
end;

function TBatch.CPS;
var
  i: integer;
  ela,
  a,
  fpos: DWORD;
begin
  i := -1;
  ela := uGetSystemTime - D.Start;
  fpos := D.FPos;
  if AOutUsed < fpos then Dec(fpos, AOutUsed);
  if fpos < D.FOfs then a := 0 else a := fpos - D.FOfs;
  if (ela > IniFile.CPS_MinSecs) and (a > IniFile.CPS_MinBytes) then i := a div ela;
  Result := i;
end;

procedure TBatch.ClearFileInfo;
begin
  D.FPos  := 0;
  D.Start := 0;
  D.FSize := 0;
  D.FOfs  := 0;
  D.Part  := 0;
  D.FTime := 0;
  D.ErrPos:= 0;
  D.StreamType := xstUnknown;
  D.FName := '';
end;

procedure TBatch.Clear;
begin
  FillChar(d, SizeOf(d), 0);
end;

function TBatch.Copy: TBatch;
begin
  Result := TBatch.Create;
  Result.D := D;
end;

class function TCommThread.ThreadName: string;
begin
  Result := 'Abstract Comm';
end;

end.


