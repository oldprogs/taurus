unit xFido;

{$I DEFINE.INC}

interface

uses
  xBase, CommCtrl, Windows, MGrids, Classes;

type
  TNodeType = (fntUnk, fntZone, fntRegion, fntNet, fntHub, fntNode, fntPoint);
  TPktFileType = (pftNone, pftFTS1, pftFSC39, pftFSC45, pftP2K, pftUnknown, pftOpenErr, pftReadErr);

  POutStatus = ^TOutStatus;
  TOutStatus = (osError, osBusy,
                osImmedMail, osCrashMail, osDirectMail, osNormalMail, osHoldMail,
                osImmed, osCrash, osDirect, osNormal, osHold, osHReq, osRequest,
                osCallback, osNone, osPause, osBusyEx);

  PKillAction = ^TKillAction;
  TKillAction = (kaBsoNothingAfter, kaBsoKillAfter, kaBsoTruncateAfter, kaFbKillAfter, kaFbMoveAfter,
                 kaAmaNothingAfter, kaAmaKillAfter, kaAmaTruncateAfter);

  TOutAttType = (oatUnk, oatBSO, oatFileBox, oatAMA, oatMSG);
  TOutAttTypeSet = set of TOutAttType;

  TInboundPutKind = (ipkUnk, ipkQueue, ipkOverwrite);

{-- P2K }

const
  P2K_FAttribute_IsKillSent      = $01; // 1 *
  P2K_FAttribute_IsFileAttached  = $02; // 2
  P2K_FAttribute_IsFileRequest   = $04; // 3
  P2K_FAttribute_IsTruncFile     = $08; // 4 *
  P2K_FAttribute_IsKillFile      = $10; // 5 *
  P2K_SENDMASK_F                 = $19;

  P2K_RAttribute_IsCrash         = $01;
  P2K_RAttribute_IsHold          = $02;
  P2K_RAttribute_IsDirect        = $04;
  P2K_RAttribute_IsExclusive     = $08;
  P2K_RAttribute_IsImmediate     = $10;
  P2K_SENDMASK_R                 = $00;

  P2K_GAttribute_IsLocal         = $01; // 1 *
  P2K_GAttribute_IsSent          = $02; // 2 *
  P2K_GAttribute_IsPrivate       = $04; // 3
  P2K_GAttribute_IsOrphan        = $08; // 4 *
  P2K_SENDMASK_G                 = $0B;

type
  TP2K_NetworkAddress = packed record
    Zone,
    Net,
    Node,
    Point: Word;
  end;

  TType2000HeaderV5 = packed record
    MainHeaderLen,
    SubHeaderLen: Word;
    OrigAddr: TP2K_NetworkAddress;
    OrigDomain: string[30];
    DestAddr: TP2K_NetworkAddress;
    DestDomain: string[30];
    Password: string[8];
    ProductName: string[30];
    PktVersionMajor,
    PktVersionMinor: Word;
  end;

  TPakd2000MsgHeadrV5 = packed record
    OrigAddr,
    DestAddr,
    WrittenAddr: TP2K_NetworkAddress;
    Year: Word;
    Month,
    Day,
    Hour,
    Min,
    Sec,
    Sec100,
    FAttribute,
    RAttribute,
    GAttribute: Byte;
    SeenBys,
    Paths: Word;
    TextBytes: Integer;
  end;

{-- FTS1}

  TFTS1PktHdr = packed record       // FTS-0001 Packet
    OrigNode,                       // originating node
    DestNode,                       // destination node
    Year,                           // 0..99  when packet was created
    Month,                          // 0..11  when packet was created
    Day,                            // 1..31  when packet was created
    Hour,                           // 0..23  when packet was created
    Minute,                         // 0..59  when packet was created
    Second,                         // 0..59  when packet was created
    Rate,                           // destination's baud rate
    Version,                        // packet version, must be 2
    OrigNet,                        // originating network number
    DestNet: Word;                  // destination network number
    Product,                        // product type
    Serial: Byte;                   // serial number (some systems)
    Password: array[0..7] of Char;  // session/pickup password
    OrigZone,                       // originating zone
    DestZone: Word;                 // Destination zone
    B_fill2: array[0..15] of Char;
    B_fill3: Integer;
  end;

  TFSC45PktHdr = packed record      // FSC-0045 (2.2) packet
    OrigNode,                       // originating node
    DestNode,                       // destination node
    OrigPoint,                      // originating point
    DestPoint: Word;                // destination point
    B_fill1: array[0..7] of Byte;   // Unused, must be zero
    SubVersion,                     // packet subversion, must be 2
    Version,                        // packet version, must be 2
    OrigNet,                        // originating network number
    DestNet: Word;                  // destination network number
    Product,                        // product type
    Serial: Byte;                   // serial number (some systems)
    Password: array[0..7] of Char;  // session/pickup password
    OrigZone,                       // originating zone
    DestZone: Word;                 // Destination zone
    OrigDomain,                     // originating domain
    DestDomain: array[0..7] of Char;// destination domain
    B_fill3: Integer;
  end;

  TFSC39PktHdr = packed record      // FSC-0039 packet type
    OrigNode,                       // originating node
    DestNode,                       // destination node
    Year,                           // 0..99  when packet was created
    Month,                          // 0..11  when packet was created
    Day,                            // 1..31  when packet was created
    Hour,                           // 0..23  when packet was created
    Minute,                         // 0..59  when packet was created
    Second,                         // 0..59  when packet was created
    Rate,                           // destination's baud rate
    Version,                        // packet version, must be 2
    OrigNet,                        // originating network number
    DestNet: Word;                  // destination network number
    ProductLow,                     // FTSC product type (low byte)
    ProdRevLow: Byte;               // product rev (low byte)
    Password: array[0..7] of Char;  // session/pickup password
    OrigZoneIgnore,                 // Zone info from other software
    DestZoneIgnore: Word;           // Zone info from other software
    Reserved: Word;                 // Spare Change, undefined
    CapValid: Word;                 // CapWord with bytes swapped.
    ProductHi,                      // FTSC product type (high byte)
    ProdRevHi: Byte;                // product rev (hi byte)
    CapWord,                        // Capability word
    OrigZone,                       // originating zone
    DestZone,                       // Destination zone
    OrigPoint,                      // originating point
    DestPoint: Word;                // destination point
    ProdData: Integer;              // Product-specific data
  end;

  PTeLinkBlk = ^TTeLinkBlk;
  TTeLinkBlk = packed record
    FileLen: DWORD;
    FileTime,
    FileDate: Word;
    FileName: array[0..15] of Byte;
    NullByte: Byte;
    ProgramName: array[0..15] of Byte;
    CRCMode: Byte;
    Fill: array[0..85] of Byte;
  end;

  TXmodemBlk = packed record
    Header,
    BlockNumA,
    BlockNumB: Byte;
    Data: array[0..127] of Byte;
    CrcHi,
    CrcLo: Byte;
  end;

  TFTS1BlkType = (
    btUndefined,
    btEmpty,
    btNone,
    btErr,
    btTeLink,
    btData,
    btEOT,
    btTSync
  );


  TEMSISeq = (es_INQ, es_REQ, es_CLI, es_HBT, es_DAT, es_ACK, es_NAK,
              es_IRQ, es_IIR, es_ICI, es_ISI, es_ISM, es_CHT, es_TCH,
              es_TZP, es_PZT, es_None, es_DatError, es_NOC);

  TTransportType = (ttUnknown, ttInvalid, ttDialup, ttIP);

  TEMSIAddonType = (
    eaIDENT,
    eaMOH,
    eaTRX,
    eaTRAF,
    eaBTH,
    eaCustom
  );

  TEMSILinkCode = (
        el8N1,     // Communication parameter
//    Calling system options
        elPUA,     // Pickup mail for all presented addresses.
        elPUP,     // Pickup mail for primary address only.
        elNPU,     // No mail pickup desired.
//    Answering system options:
        elHAT,     // Hold ALL traffic.
        elHXT,     // Hold compressed mail traffic.
        elHRQ,     // Hold file requests (not processed at this time).
        elNone
  );
  TEMSILinkCodes = set of TEMSILinkCode;

  TEMSICapability = (
        ecBND,     // BinkP
        ecHYD,     // Hydra.
        ecJAN,     // Janus.
        ecKER,     // Kermit.
        ecDZA,     // DirectZAP (Zmodem variant).
        ecZAP,     // ZedZap (Zmodem variant).
        ecZMO,     // Zmodem w/1,024 byte data packets.
        ecYMO,     // YModem
        ecNCP,     // No compatible protocols (failure).

        ecNRQ,     // No file requests accepted by this system.
        ecARC,     // ARCmail 0.60-capable, as defined by the FTSC.
        ecXMA,     // Supports other forms of compressed mail.
        ecHFR,     // Support hold file requests
        ecFNC,     // MS-DOS filename conversion.
        ecNone
  );
  TEMSICapabilities = set of TEMSICapability;

  TEMSIColl = class(TStringColl)
    property FingerPrint     : string index 0 read GetString;
    property AddressList     : string index 1 read GetString;
    property Password        : string index 2 read GetString;
    property LinkCodes       : string index 3 read GetString;
    property Compatibility   : string index 4 read GetString;
    property MlrProductCode  : string index 5 read GetString;
    property MlrName         : string index 6 read GetString;
    property MlrVersion      : string index 7 read GetString;
    property MlrSerialNo     : string index 8 read GetString;
  end;

  PFidoAddress = ^TFidoAddress;
  TFidoAddress = packed record
  case Integer of
    0: (Zone, Net, Node, Point: word; Domain: string[8]; Region: word; Hubb: word);
    1: (arr: array[1..4] of word; str: array [0..8] of char);
    2: (rec: array[1..4] of word; fil: word; ofs: integer; reg: word; hub: word);
  end;

  TFidoAddrColl = class(TSortedColl)
    function GetString: string;
    function Compare(Key1, Key2: Pointer): Integer; override;
    procedure FreeItem(Item: Pointer); override;
    function KeyOf(Item: Pointer): Pointer; override;
    procedure PutItem(Stream: TxStream; Item: Pointer); override;
    function GetItem(Stream: TxStream): Pointer; override;
    function GetAddress(Index: Integer): TFidoAddress;
    property Addresses[Index: Integer]: TFidoAddress read GetAddress; default;
    function Crc32Item(Item: Pointer; Crc32: DWORD): DWORD; override;
    procedure Add(const A: TFidoAddress);
    procedure Ins(const A: TFidoAddress);
  end;

  TNodePrefixFlag = (nfUndef, nfNormal, nfPoint, nfHub, nfNet, nfZone, nfPvt, nfHold, nfDown, nfOver, nfUnrec, nfRegion);

const
  cNodePrefixFlag: array[TNodePrefixFlag] of string = ('?', 'Node', 'Point', 'Hub', 'Host', 'Zone', 'Pvt', 'Hold', 'Down', '??', '???', 'Region');

var
  AddrColl: TFidoAddrColl = nil;

type
  TAdvNodeData = class(TAdvCpOnlyObject)
    Flags,
    NdlFl,
    Phone,
    IPAddr: string;
    function Copy: Pointer; override;
  end;

  TAdvNodeExtData = class(TAdvCpOnlyObject)
    Opts, Cmd: string;
    function Copy: Pointer; override;
  end;

  TAdvNode = class(TAdvCpOnlyObject)
    PrefixFlag: TNodePrefixFlag;
    Speed: Integer;
    Station,
    Sysop,
    Location: String;
    Addr: TFidoAddress;
    DialupData, IPData: TColl;
    Ext: TAdvNodeExtData;
    function Copy: Pointer; override;
    destructor Destroy; override;
  end;

  TFidoNodeColl = class(TSortedColl)
    function Compare(Key1, Key2: Pointer): Integer; override;
    function KeyOf(Item: Pointer): Pointer; override;
    procedure AtInsert(Index: Integer; Item: Pointer); override;
    procedure FreeAll; override;
    procedure Concat(AColl: TColl); override;
    procedure Update(Item: Pointer);
  end;

  TFidoNode = class
    cs: TRtlCriticalSection;
  public
    PrefixFlag: TNodePrefixFlag;
    TreeItem: HTreeItem;
    HasPoints: Boolean;
    Addr: TFidoAddress;
    Hub, Region,
    Speed: word;
    Station,
    Sysop,
    Phone,
    Flags,
    Location: String;
    Coll: TFidoNodeColl;
    function Copy: TFidoNode;
    constructor Create;
    destructor  Destroy; override;
  end;

  TFidoNLColl = class(TFidoAddrColl)
    Nodelist: TStringList;
    Domain: string;
    constructor Create;
    destructor  Destroy; override;
    function Compare(Key1, Key2: Pointer): Integer; override;
    procedure Add(const A: TFidoAddress; const n: string);
    procedure Ins(const A: TFidoAddress; const n: string);
    procedure SaveToFile(const n: string);
    function SearchNode(const Addr: TFidoAddress): TFidoNode;
    function GetFirstNode: TFidoAddress;
    function GetNextNode(var Addr: TFidoAddress): boolean;
  end;

  Ta4s = array[1..5] of string;
  TFSC62Quant = 0..47;

  TFSC62Time = set of TFSC62Quant;

  TOvrData = class
    PhoneDirect: string;
    Flags: string;
    PhoneNodelist: TFidoAddress;
  end;

  T_Minute = 0..59;
  T_Hour   = 0..23;
  T_Day    = 0..30;
  T_Month  = 0..11;
  T_Dow    = 0..06;

  TMinuteSet = set of T_Minute;
  THourSet   = set of T_Hour;
  TDaySet    = set of T_Day;
  TMonthSet  = set of T_Month;
  TDowsSet   = set of T_Dow;

  TCronRec = packed record
    Minutes : TMinuteSet;
    Hours   : THourSet;
    Days    : TDaySet;
    Months  : TMonthSet;
    Dows    : TDowsSet;
  end;

  TCronRecArr = packed array[0..(MaxInt div SizeOf(TCronRec)) - 1] of TCronRec;
  PCronRecArr = ^TCronRecArr;

  TCronRecord = class
    Id: string;
    p: PCronRecArr;
    Count: Integer;
    IsPermanent: Boolean;
    IsUTC: Boolean;
    procedure SetMatch(const t: TSystemTime);
    constructor Create(s: string);
    destructor Destroy; override;
  private
    fMatch: TSystemTime;
    fDelay: boolean;
  published
    property Match: TSystemTime read fMatch write SetMatch;
    property Delay: boolean read fDelay write fDelay;
  end;

  TCronStor = record
     Id: string[50];
     Tm: TSystemTime;
  end;

  TOvrItemTyp = (oiAddress, oiAddressMask, oiFlag, oiInvFlag, oiPhoneNum, oiIPNum, oiIPSym, oiUnknown);

  EMSIOpt = set of (crc32, varlen, error);

const
  MaxModemCmdIdx = 6;

  EMSI_Seq : array[TEMSISeq] of
  record
    S: string[3];
    O: EMSIOpt;
  end = (
  (S: 'INQ'; O: []),
  (S: 'REQ'; O: []),
  (S: 'CLI'; O: []),
  (S: 'HBT'; O: []),
  (S: 'DAT'; O: [varlen]),
  (S: 'ACK'; O: []),
  (S: 'NAK'; O: []),
  (S: 'IRQ'; O: []),
  (S: 'IIR'; O: []),
  (S: 'ICI'; O: [crc32, varlen]),
  (S: 'ISI'; O: [crc32, varlen]),
  (S: 'ISM'; O: [crc32, varlen]),
  (S: 'CHT'; O: []),
  (S: 'TCH'; O: []),
  (S: 'tzp'; O: [error]),
  (S: 'pzt'; O: [error]),
  (S: ''; O: [error]),
  (S: ''; O: [error]),
  (S: 'NOC'; O: [error])

 );

  SEMSICapabilities  : array[TEMSICapability] of string =
    ('BND', 'HYD', 'JAN', 'KER', 'DZA', 'ZAP', 'ZMO', 'YMO', 'NCP',
     'NRQ', 'ARC', 'XMA', 'HFR', 'FNC', '');
  SEMSILinkCodes : array[TEMSILinkCode] of string = ('8N1', 'PUA', 'PUP', 'NPU', 'HAT', 'HXT', 'HRQ', '');
  SEMSIAddons : array[TEMSIAddonType] of string = ('IDENT', 'MOH#', 'TRX#', 'TRAF', 'BTH', '');

const
  kwTCP                   = $17844453;
  kwVMP                   = $8A83BDB3;
  kwTEL                   = $55DFBF9A;
  kwTELNET                = $4C81E181;
  kwIFC                   = $FAB3C1EB;
  kwBINKP                 = $D83DB481;
  kwBINKD                 = $C2E760FC;
  kwBND                   = $A05B31A1;
  kwBNP                   = $BA81E5DC;
  kwIBN                   = $E06E7852;
  kwITN                   = $FCF6CD85;
  kwIVM                   = $57C9FEBD;
  kwIP                    = $49EA573B;
  kwU                     = $BC3C793A;
  kwIEM                   = $3626BF2F;
  kwITX                   = $082278D4;
  kwIUC                   = $9B5C8079;
  kwIMI                   = $F992F13E;
  kwISE                   = $246582CA;
  kwPOP                   = $BC38A383;

function IdentEMSISeq(var AStr: string; icrc: DWORD): TEMSISeq;
function CompareAddrs(const a, b: TFidoAddress; NLColl: boolean = False): Integer;
function FidoAddress(Zone, Net, Node, Point: Integer; const Domain: string): TFidoAddress;
function BuildEMSICapabilities(Cap: TEMSICapabilities): string;
function BuildEMSILinkCodes(Cap: TEMSILinkCodes): string;
function ParseEMSILinkCodes(var S: string): TEMSILinkCodes;
function IdentEMSILinkCode(const S: string): TEMSILinkCode;
function ParseEMSICapabilities(var S: string): TEMSICapabilities;
function IdentEMSICapability(const S: string): TEMSICapability;
function IdentEMSIAddon(const S: string): TEMSIAddonType;
function CreateAddrColl(const A: string): TFidoAddrColl;
function CreateAddrCollInvAddrs(const A: string; InvAddrs: TStringColl): TFidoAddrColl;
function CreateAddrCollMsg(const A: string; var Msg: string): TFidoAddrColl;
function CreateAddrCollEx(const A: string; ASkip: Boolean): TFidoAddrColl;
function ParseEMSILine(S: String; L: TStringColl; AC: Char): Boolean;
function ExtractEMSI(var InB: string): string;
function Hex2EMSI(var S: string): Boolean;
function GetSpeed(const S: String): DWORD;
function ParseAddress(const Address: String; var Addr: TFidoAddress): Boolean;
function A4s2Addr(const a: Ta4s; var Addr: TFidoAddress): Boolean;
function ParseAddressMsg(const Address: String; var Addr: TFidoAddress; var Msg: string): Boolean;
function ValidAddress(const Address: String): Boolean;
function Addr2Str(const Addr: TFidoAddress): string;
function Addr2StrEx(const Addr: TFidoAddress): string;
{V6.0 begin}
function SplitAddress(const Address: string; var Strs: Ta4s; AllowMask: Boolean): Boolean;
function SplitAddressEx(const Address: string; var Strs: Ta4s; AllowMask, AllowREmask: Boolean): Boolean;
{V6.0 end}
function PureAddressMasks(const a: Ta4s): Boolean;
function MatchMaskAddress(const Addr: TFidoAddress; const AMask: string): Boolean;
function ValidMaskAddress(const AMask: string): Boolean;
function MatchMaskAddressListMultiple(Addrs: TFidoAddrColl; const AMaskList: string): Boolean;
function MatchMaskAddressListSingle(const Addr: TFidoAddress; const AMaskList: string): Boolean;
function ValidMaskAddressList(const AMaskList: string; AHandle: DWORD): Boolean;
procedure _PutAddress(Stream: TxStream; const Addr: TFidoAddress);
procedure _GetAddress(Stream: TxStream; var Addr: TFidoAddress);
function CurFSC62Quant: TFSC62Quant;
function NodeFSC62LocalEx(const Flags: string; FReq: Boolean): TFSC62Time;
function NodeFSC62Local(const Flags: string): TFSC62Time;
function GetTime(C: Char; var Q: TFSC62Quant): Boolean;
function _NodeFSC62TimeEx(Flags: string; const Addr: TFidoAddress; FReq, ALocal: Boolean; IP: boolean = False): TFSC62Time;
function NodeFSC62TimeEx(const Flags: string; const Addr: TFidoAddress; ALocal: Boolean; IP: boolean = False): TFSC62Time;
procedure AdjustFSC62Quant(var t: TFSC62Quant; Bias: Integer);
function FSC62TimeToStr(t: TFSC62Time): string;
function IsTxyEx(const S: string; var Local: Boolean; FReq: boolean): Boolean;
function IsTxy(const S: string; var Local: Boolean): Boolean;
function IdentOvrItem(const Item: string; AddrMask: Boolean; ChkFlags: Boolean): TOvrItemTyp;
function ValidOverride(const AStr: string; Dialup: Boolean; var Item: string): string;
function ParseOverride(const AAStr: string; var Msg, Item: string; Dialup: Boolean): TColl;
function WipePhoneNumber(const Phone: string): string;
function GetTransportType(const Phone, Flags: string): TTransportType;
function TransportFlagsMatch(const s, z: string; Dialup: Boolean): Boolean;
function TransportMatch(const Num: string; Dialup: Boolean): Boolean;
function AreFlagsTCP(s: string): Boolean;
function ParseCronRec(n, s: string; Permanent, UTC: Boolean; var ErrStr: string): TCronRecord;
function ValidCronRecDlg(const s: string; Handle: DWORD; Permanent: Boolean): Boolean;
function ValidCronRecStr(const s: string): string;
function ValidCronRec(const s: string): Boolean;
function ValidCronColl(c: TStringColl; var ErrLn: Integer; var Msg: string): Boolean;
function ParseCronColl(n: string; c: TStringColl): TColl;
function ValidateAddrs(const s: string; Handle: DWORD): Boolean;
function ValidateAddrsMask(const g: TAdvGrid; r, c: integer; h: DWORD): Boolean;
function ValidModemCmd(Idx: Integer; const Cmd, Name: string; Handle: DWORD): Boolean;
function GetNodeType(N: TFidoNode): TNodeType;
function IsArcMailExt(const AExt: string): Boolean;
function IsNetMailExt(const AExt: string): Boolean;
function IsNotMailExt(const AExt: string): Boolean;
procedure PurgeTimeFlags(SC: TStringColl);
procedure PurgeTimeFlagsEx(SC: TStringColl;FReq: Boolean);
procedure PurgeIpFlags(SC: TStringColl);
function HumanTime2UTxyL(const ATime: string; NeedU: Boolean): string;
function HumanTime2UTxyLEx(ATime: string; FReq, NeedU: Boolean): string;
function OvrColl2Str(C: TColl): string;
function NewFidoAddr(const A: TFidoAddress): PFidoAddress;
function NextPollOptionMatches(var s: string; AValue: DWORD): Boolean;
function NextPollOptionValid(var s: string; Handle: DWORD): Boolean;
function PollSleepMSecsValid(var s: string; Handle: DWORD): Boolean;
function PollSleepMSecs(var s: string): DWORD;
function PollTimeoutExitCodeValid(var s: string; AHandle: DWORD): Boolean;
function PollTimeoutExitCode(var s: string): DWORD;
function GetPktFileType(const FName: string): TPktFileType;
function GetOutAttTypeByKillAction(KA: TKillAction): TOutAttType;
function OutStatus2Char(s: TOutStatus): Char;
function OutStatus2StrTmail(s: TOutStatus): string;
function Char2OutStatus(c: Char): TOutStatus;
function ValidPhnPrefix(const s: string): Boolean;
function FindFTNDOM(const a: TFidoAddress): string; overload;
function FindFTNDOM(const a: string): string; overload;
function CalcTime(const T: TSystemTime): DWORD;
function DUFlags(const s: string): string;
function IPFlags(const s: string): string;

implementation

uses SysUtils, xIP, LngTools, RRegExp, RadIni, Forms, Wizard, Recs,
     AltRecs, NdlUtil, Outbound, UWrd;

type
  TCronRecUnp = record
    Minutes : array[0..59] of byte;
    Hours   : array[0..23] of byte;
    Days    : array[0..30] of byte;
    Months  : array[0..11] of byte;
    Dows    : array[0..06] of Byte;
    NumMinutes, NumHours, NumDays, NumMonths, NumDows: Byte;
  end;

function Char2OutStatus(c: Char): TOutStatus;
var
   o: TOutStatus;
begin
   case UpCase(C) of
   'I': o := osImmed;
   'C': o := osCrash;
   'D': o := osDirect;
   'H': o := osHold;
   'N': o := osNormal;
   '*': o := osNone;
   else o := osError;
   end;
   Result := o;
end;

function OutStatus2Char(s: TOutStatus): Char;
var
   c: Char;
begin
   case s of
   osImmed:  c := 'I';
   osCrash:  c := 'C';
   osDirect: c := 'D';
   osHold:   c := 'H';
   osNone:   c := '*';
   else      c := 'N';
   end;
   Result := c;
end;

function OutStatus2StrTmail(s: TOutStatus): string;
var
   c: Char;
begin
   c := OutStatus2Char(s);
   if c = 'N' then Result := '' else Result := c;
end;

function GetOutAttTypeByKillAction(KA: TKillAction): TOutAttType;
begin
   case KA of
   kaBsoNothingAfter,
   kaBsoKillAfter,
   kaBsoTruncateAfter:
      Result := oatBSO;
   kaFbKillAfter,
   kaFbMoveAfter:
      Result := oatFileBox;
   kaAmaNothingAfter,
   kaAmaKillAfter,
   kaAmaTruncateAfter:
      Result := oatAMA;
   else
      Result := oatUnk;
   end;
end;

function ValidateAddrs(const s: string; Handle: DWORD): Boolean;
var
   a: TFidoAddrColl;
   Msg: string;
begin
   a := CreateAddrCollMsg(s, Msg);
   Result := a <> nil;
   if Result then FreeObject(a) else DisplayError(Msg, Handle);
end;

function ValidateAddrsMask;
var
   i: integer;
begin
   Result := True;
   for i := r to g.RowCount do begin
      if not ValidMaskAddressList(g.Cells[c, i], h) then begin
         Result := False;
         exit;
      end;
   end;
end;

function IdentEMSISeq(var AStr: string; iCRC: DWORD): TEMSISeq;
var
  L, I, J, K, C, DataLen, crc: DWORD;
  Seq: TEMSISeq;
  S3: string[3];
begin
  Result := es_None;
  I := Pos('**EMSI_', UpperCase(AStr));
  C := Pos('NO CARRIER', AStr);
  J := Pos(EMSI_TZP, AStr);
  K := Pos(EMSI_PZT, AStr);
  if I = 0 then I := High(DWORD);
  if C = 0 then C := High(DWORD);
  if C < I then begin
     Result := es_NOC;
     Delete(AStr, C, 11);
     exit;
  end;
  if J = 0 then J := High(DWORD);
  if K = 0 then K := High(DWORD);
  if (I > J) or (I > K) then begin
    if (J < K) and (J <> High(DWORD)) then begin
      Result := es_TZP;
      L := Length(EMSI_TZP);
      Delete(AStr, 1, J + L - 1);
    end else
    if (K <> High(DWORD)) then begin
      Result := es_PZT;
      L := Length(EMSI_PZT);
      Delete(AStr, 1, K + L - 1);
    end;
    Exit;
  end;
  if I = High(DWORD) then Exit;
  if I > 0 then Delete(AStr, 1, I - 1);
  S3 := UpperCase(Copy(AStr, 8, 3));
  for Seq := Low(Seq) to High(Seq) do with EMSI_Seq[Seq] do begin
    if error in O then Continue;
    if S3 <> S then Continue;
    if Length(AStr) < 14 then Exit;
    if varlen in O then begin
      DataLen := VlH(Copy(AStr, 11, 4));
      if DataLen = INVALID_VALUE then begin
        Delete(AStr, 1, 14);
        Exit;
      end;
      L := Length(AStr);
      if L < 14 + DataLen + 4 then Exit else begin
        crc := VlH(Copy(AStr, 15 + DataLen, 4));
        if (crc = INVALID_VALUE) or (crc <> Crc16UsdBlock(AStr[3], 12 + DataLen)) then begin
          Delete(AStr, 1, 14 + DataLen + 4);
          if Seq = es_DAT then Result := es_DATError;
        end else begin
          if crc = iCRC then begin
             Delete(AStr, 1, 14 + DataLen + 4);
             Result := es_None;
          end else begin
             Delete(AStr, 1, 10);  // leave Len & Data
             Result := Seq;
          end;
        end;
      end;
    end else begin
      crc := VlH(Copy(AStr, 11, 4));
      if (crc <> INVALID_VALUE) and (crc = Crc16UsdBlock(AStr[3], 8)) then Result := Seq;
      Delete(AStr, 1, 14);
    end;
    Exit;
  end;
  // Unknown sequence (**EMSI_????)
  if Length(AStr) >= 14 then Delete(AStr, 1, 14);
end;

function Addr2StrEx(const Addr: TFidoAddress): string;
var a: TFidoAddress;
begin
  if (Addr.Zone = $FFFF) and (Addr.Domain <> 'POP3') then begin
     Result := Inifile.ReadString('Grids', 'gSMTP' + IntToStr(Addr.Point), 'Error');
     Result := ExtractWord(1, Result, ['|']) + '@POP3';
     exit;
  end;
  a := Addr;
  FindFTNDOM(a);
  with a do
    Result := Format('%d:%d/%d.%d', [Zone, Net, Node, Point]);
  if inifile.D5Out and (a.Domain <> '') then Result := Result + '@' + a.Domain;
end;

function Addr2Str(const Addr: TFidoAddress): string;
var
  a: TFidoAddress;
begin
  if (Addr.Zone = $FFFF) {and (Addr.Domain <> 'POP3')} then begin
     Result := Inifile.ReadString('Grids', 'gSMTP' + IntToStr(Addr.Point), 'Error');
     Result := ExtractWord(1, Result, ['|']) + '@POP3';
     exit;
  end;
  a := Addr;
  a.Domain := FindFTNDOM(a);
  with a do
  if Point = 0 then
    Result := Format('%d:%d/%d', [Zone, Net, Node]) else
    Result := Format('%d:%d/%d.%d', [Zone, Net, Node, Point]);
  if inifile.D5Out and (a.Domain <> '') then Result := Result + '@' + a.Domain;
end;

function GetSpeed(const S: String): DWORD;
var
  L, I, J: DWORD;
begin
  I := 1;
  L := Length(S);
  while (I <= L) and ((S[I] < '0') or (S[I] > '9')) do Inc(I);
  J := 0;
  while (I + J <= L) and (S[I + J] >= '0') and (S[I + J] <= '9') do Inc(J);
  if J > 0 then
  begin
    Result := Vl(Copy(S, I, J));
    if Result = INVALID_VALUE then Result := 300
  end else
  begin
    Result := 300;
  end;
end;

function BuildEMSICapabilities(Cap: TEMSICapabilities): string;
var
  C: TEMSICapability;
begin
  Result := '';
  for C := Low(TEMSICapability) to High(TEMSICapability) do
  begin
    if (C in CAP) then
    begin
      if Result <> '' then AddStr(Result, ',');
      Result := Result + SEMSICapabilities[C];
    end;
  end;
end;

function IdentEMSICapability(const S: string): TEMSICapability;
var
  C: TEMSICapability;
  US: string;
begin
  Result := ecNone;
  US := UpperCase(S);
  for C := Low(TEMSICapability) to High(TEMSICapability) do
  begin
    if US = SEMSICapabilities[C] then begin Result := C; Exit end;
  end;
end;

function ParseEMSICapabilities(var S: string): TEMSICapabilities;
var
  UnkFlags,
  w: string;
  C: TEMSICapability;
begin
  Result := [];
  UnkFlags := '';
  repeat
    GetWrd(s, w, ',');
    if (w = '') and (s = '') then Break;
    C := IdentEMSICapability(w);
    if C = ecNone then
    begin
      if UnkFlags <> '' then AddStr(UnkFlags, ',');
      UnkFlags := UnkFlags + w;
    end else Include(Result, C);
  until False;
  S := UnkFlags;
end;

function BuildEMSILinkCodes(Cap: TEMSILinkCodes): string;
var
  C: TEMSILinkCode;
begin
  Result := '';
  for C := Low(TEMSILinkCode) to High(TEMSILinkCode) do
  begin
    if (C in CAP) then
    begin
      if Result <> '' then AddStr(Result, ',');
      Result := Result + SEMSILinkCodes[C];
    end;
  end;
end;

function IdentEMSILinkCode(const S: string): TEMSILinkCode;
var
  C: TEMSILinkCode;
  US: string;
begin
  Result := elNone;
  US := UpperCase(S);
  for C := Low(TEMSILinkCode) to High(TEMSILinkCode) do
  begin
    if US = SEMSILinkCodes[C] then begin Result := C; Exit end;
  end;
end;

function ParseEMSILinkCodes(var S: string): TEMSILinkCodes;
var
  UnkFlags,w: string;
  C: TEMSILinkCode;
begin
  Result := [];
  UnkFlags := '';
  repeat
    GetWrd(s, w, ',');
    if (w = '') and (s = '') then Break;
    C := IdentEMSILinkCode(w);
    if C = elNone then
    begin
      if UnkFlags <> '' then AddStr(UnkFlags, ',');
      UnkFlags := UnkFlags + w;
    end else Include(Result, C);
  until False;
  S := UnkFlags;
end;

function NewFidoAddr(const A: TFidoAddress): PFidoAddress;
begin
  New(Result);
  Result^ := A;
end;

procedure TFidoAddrColl.Add(const A: TFidoAddress);
begin
  AtInsert(Count, NewFidoAddr(A));
end;

procedure TFidoAddrColl.Ins(const A: TFidoAddress);
begin
  Insert(NewFidoAddr(A));
end;

function TFidoAddrColl.Compare(Key1, Key2: Pointer): Integer;
begin
  Result := CompareAddrs(PFidoAddress(Key1)^, PFidoAddress(Key2)^);
end;

procedure TFidoAddrColl.FreeItem(Item: Pointer);
begin
  Dispose(PFidoAddress(Item));
end;

function TFidoAddrColl.KeyOf(Item: Pointer): Pointer;
begin
  Result := Item;
end;

procedure _PutAddress;
begin
  Stream.WriteInteger(Addr.Zone);
  Stream.WriteInteger(Addr.Net);
  Stream.WriteInteger(Addr.Node);
  Stream.WriteInteger(Addr.Point);
  (Stream as TxMemoryStreamEx).Addition.WriteStr(Addr.Domain);
end;

procedure _GetAddress;
begin
  Addr.Zone := Stream.ReadInteger;
  Addr.Net := Stream.ReadInteger;
  Addr.Node := Stream.ReadInteger;
  Addr.Point := Stream.ReadInteger;
  Addr.Domain := (Stream as TxMemoryStreamEx).Addition.ReadStr;
  if (Addr.Domain = '') then Addr.Domain := FindFTNDOM(Addr);
  if (Addr.Domain = '') and (Addr.Zone in [1..6]) then Addr.Domain := 'fidonet';
end;

procedure TFidoAddrColl.PutItem;
begin
  _PutAddress(Stream, PFidoAddress(Item)^);
end;

function TFidoAddrColl.GetItem;
begin
  Result := New(PFidoAddress);
  _GetAddress(Stream, PFidoAddress(Result)^);
end;

function TFidoAddrColl.GetAddress(Index: Integer): TFidoAddress;
begin
  Result := PFidoAddress(At(Index))^;
end;

function TFidoAddrColl.Crc32Item(Item: Pointer; Crc32: DWORD): DWORD;
var
  i: Integer;
begin
  Result := Crc32;
  for i := 0 to SizeOf(TFidoAddress) - 1 do Result := UpdateCrc32(PxByteArray(Item)^[I], Result);
end;

function ParseAddressMsgEx(const Address: String; var Addr: TFidoAddress; PMsg: PString): Boolean;
begin
  Result := ParseAddress(Address, Addr);
  if (not Result) and (PMsg <> nil) then PMsg^ := FormatLng(rsXfNoValid, [Address]);
end;

function CreateAddrCollMsgEx(const AA: string; PMsg: PString; InvAddrs: TStringColl; ASkip: Boolean): TFidoAddrColl;
var
  A,
  w: string;
  t: string;
  C: TFidoAddrColl;
  Addr: TFidoAddress;
  P: PFidoAddress;
  s: TStringList;
  i: integer;
begin
  Result := nil;
  C := TFidoAddrColl.Create;
  A := AA;
  repeat
    GetWrd(A, w, ' ');
    if w = '' then Break;
    if not ParseAddress(w, Addr) then begin
       s := IniFile.ReadSection('Grids', 'gSMTP');
       if s <> nil then begin
          for i := 0 to s.Count - 1 do begin
             t := IniFile.ReadString('Grids', s[i]);
             if pos(UpperCase(ExtractWord(1, w, ['@'])) + '|', UpperCase(t)) > 0 then begin
                Addr.Zone   := $FFFF;
                Addr.Net    := $FFFF;
                Addr.Node   := $FFFF;
                Addr.Point  := i + 1;
                Addr.Domain := 'POP3';
                w := Addr2Str(Addr);
             end;
          end;
          s.Free;
       end;
    end;
    if not ParseAddressMsgEx(w, Addr, PMsg) then begin
      if ASkip then begin
        if InvAddrs <> nil then InvAddrs.Add(w);
        Continue;
      end else begin
        FreeObject(C);
        Exit;
      end;
    end;
    P := New(PFidoAddress);
    P^ := Addr;
    C.AtInsert(C.Count, P);
  until False;
  if C.Count > 0 then
    Result := C
  else begin
    FreeObject(C);
    if PMsg <> nil then PMsg^ := LngStr(rsXfBlankFTN);
  end;
end;

function CreateAddrCollEx(const A: string; ASkip: Boolean): TFidoAddrColl;
begin
  Result := CreateAddrCollMsgEx(A, nil, nil, ASkip);
end;

function CreateAddrCollMsg(const A: string; var Msg: string): TFidoAddrColl;
begin
  Result := CreateAddrCollMsgEx(A, @Msg, nil, False);
end;

function CreateAddrCollInvAddrs(const A: string; InvAddrs: TStringColl): TFidoAddrColl;
begin
  Result := CreateAddrCollMsgEx(A, nil, InvAddrs, True);
end;

function CreateAddrColl(const A: string): TFidoAddrColl;
var
  Msg: string;
begin
  Result := CreateAddrCollMsg(A, Msg);
end;

function TFidoAddrColl.GetString: string;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to Count - 1 do begin
    if Result <> '' then AddStr(Result, ' ');
    Result := Result + Addr2Str(Addresses[i]);
  end;
end;

function ParseEMSILine(S: String; L: TStringColl; AC: Char): Boolean;
var
  C: Char;
  Z: string;
begin
  Result := False;
  L.FreeAll;
  while S <> '' do begin
    Z := '';
    DelFC(S);
    repeat
      if S = '' then Exit;
      C := S[1];
      DelFC(S);
      if C <> AC then begin
        AddStr(Z, C);
      end else begin
        if (S <> '') and (S[1] = AC) then begin
          DelFC(S);
          AddStr(Z, C);
        end else begin
          L.Add(Z);
          Break;
        end;
      end;
    until False;
  end;
  Result := True;
end;

function ExtractEMSI(var InB: string): string;
var
  J: DWORD;
begin
  Result := '';
  J := VlH(Copy(InB, 1, 4));
  if J = INVALID_VALUE then Exit;
  Result := Copy(InB, 5, J);
  Delete(InB, 1, J + 8);
end;

function Hex2EMSI(var S: string): Boolean;
var
  Z: string;
  I,
 ZL,
 SL: Integer;
  C: Char;
begin
  Result := False;
  SL := Length(S);
  SetLength(Z, SL);
  I := 1; ZL := 0;
  C := '?';
  while I <= SL do begin
    case S[I] of
      #0..#31, #128..#255: Exit;
      '\':
        if I = SL then Exit else
        case S[I+1] of
          '\' :
            begin
              Inc(I, 2);
              C := '\';
            end;
          '0'..'9', 'a'..'f', 'A'..'F':
            if I+1 = SL then Exit else
            case S[I+2] of
              '0'..'9', 'a'..'f', 'A'..'F':
                begin
                  C := Char((Pos(UpCase(S[I + 1]), rrHiHexChar) - 1) shl 4 +
                            (Pos(UpCase(S[I + 2]), rrHiHexChar) - 1));
                  if C < ' ' then C := '?';
                  Inc(I, 3);
                end;
              else Exit;
            end;
          else Exit;
        end;
      else
        begin
          C := S[I];
          Inc(I);
        end;
    end;
    Inc(ZL);
    Z[ZL] := C;
  end;
  S := Copy(Z, 1, ZL);
  Result := True;
end;

function IdentEMSIAddon(const S: string): TEMSIAddonType;
var
   C: TEMSIAddonType;
  US: string;
begin
   Result := eaCustom;
   US := UpperCase(S);
   for C := Low(TEMSIAddonType) to High(TEMSIAddonType) do begin
      if US = SEMSIAddons[C] then begin Result := C; Exit end;
   end;
end;

function ValidMaskAddress(const AMask: string): Boolean;
var
   a: Ta4s;
  RE: TPCRE;
   s: string;
begin
   Result := SplitAddress(AMask, a, True);
   if Result then Exit;
   RE := nil;//to avoid unintialized warning
   if (Pos('~', AMask) <= 0) then begin Result := False; Exit end;
   try
      s := StrQuotePartEx(AMask, '~', 'G', 'H');
      RE := GetRegExpr('^[\*0-9A-H]+\:[\*0-9A-H]+\/[\*0-9A-H]+(\.[\*0-9A-H]+)?$');
      Result := (RE.ErrPtr = 0) and (RE.Match(s) > 0) and (RE[0] <> '');
   finally
      RE.Unlock;
   end;
end;

function MatchMaskAddress(const Addr: TFidoAddress; const AMask: string): Boolean;
var
   a: Ta4s;
   b: TFidoAddress;
 HiC: Char;
   i,
   j,
   m: Integer;
   s,
   z,
   k,
   n: string;
   c: Char;
  RE: TPCRE;
  ok: Boolean;
  fc: TFidoAddrColl;
begin
   HiC := #0;
   fc := nil;
   Result := (AMask = '*:*/*.*')   or (AMask = '*:*/*') or
             (AMask = '*:*/*.*@*') or (AMask = '*:*/*@*');
   if Result then Exit;
   k := StrQuotePartEx(AMask, '~', #3, #4);
   if (Pos(#3, k) <= 0) then begin
      Replace(#4, '~', k);
      if not SplitAddress(k, a, True) then Exit;
      try
         for i := 1 to 4 do begin
            s := IntToStr(Addr.arr[i]);
            z := a[i];
            if z[Length(z)] = '*' then begin
               DelLC(z);
               SetLength(s, Length(z));
            end else
            if (i = 2) and (a[3] = '#') then begin
               b.Zone   := StrToInt(a[1]);
               b.Net    := StrToInt(a[2]);
               b.Node   := 0;
               b.Point  := 0;
               b.Domain := a[5];
               fc := GetScope(b);
               if fc = nil then exit;
               b := Addr;
               b.Point := 0;
               try
                  if fc.Search(@b, j) then begin
                     break;
                  end;
               finally
                  FreeObject(fc);
               end;
            end else
            if (i = 3) and (a[4] = '#') then begin
               b.Zone   := StrToInt(a[1]);
               b.Net    := StrToInt(a[2]);
               b.Node   := StrToInt(a[3]);
               b.Point  := word(-1);
               b.Domain := a[5];
               fc := GetScope(b);
               if fc = nil then exit;
               b := Addr;
               b.Point := 0;
               try
                  if fc.Search(@b, j) then begin
                     break;
                  end;
               finally
                  FreeObject(fc);
               end;
            end;
            if s <> z then Exit;
         end;
         if inifile.D5Out then begin
            if a[5] <> '*' then begin
               if a[5] <> Addr.Domain then Exit;
            end;
         end;
      finally
         if fc <> nil then begin
            FreeObject(fc);
         end;
      end;
   end else begin
      j := 0;
      if not SplitAddressEx(k, a, True, True) then Exit;
      for i := 1 to 4 do begin
         k := a[i];
         n := '';
         for m := 1 to Length(k) do begin
            c := k[m];
            case j of
            0:
               case c of
               #3: j := 3;
               #4: Exit;
               '*': n := n + '\d*';
               '?': n := n + '\d';
               '0'..'9': n := n + c;
               else Exit;
               end;
            2:
               begin
                  n := n + Char(VlH(HiC + c));
                  j := 3;
               end;
            3:
               begin
                  if c = #3 then j := 0 else begin HiC := c; j := 2 end;
               end;
            end;
         end;
         RE := GetRegExpr('^' + n + '$');
         ok := (RE.ErrPtr = 0) and (RE.Match(IntToStr(Addr.arr[i])) > 0) and (RE[0] <> '');
         RE.Unlock;
         if not ok then Exit;
      end;
   end;
   Result := True;
end;

function MatchMaskAddressListMultiple(Addrs: TFidoAddrColl; const AMaskList: string): Boolean;
var
   s,
   z: string;
   a: TFidoAddress;
   IsSimpleAddress: Boolean;
   i: Integer;
   Addr: TFidoAddress;
begin
   Result := False;
   s := AMaskList;
   while s <> '' do begin
      GetWrd(s, z, ' ');
      IsSimpleAddress := ParseAddress(z, a);
      for i := 0 to Addrs.Count - 1 do begin
         Addr := Addrs[i];
         if IsSimpleAddress then Result := CompareAddrs(Addr, a) = 0 else
                                 Result := MatchMaskAddress(Addr, z);
         if Result then Break;
      end;
      if Result then Break;
   end;
end;

function MatchMaskAddressListSingle(const Addr: TFidoAddress; const AMaskList: string): Boolean;
var
   c: TFidoAddrColl;
begin
   c := TFidoAddrColl.Create;
   c.Ins(Addr);
   Result := MatchMaskAddressListMultiple(c, AMaskList);
   c.Free;
end;

function ValidMaskAddressList(const AMaskList: string; AHandle: DWORD): Boolean;
var
   a: Ta4s;
   s,
   z: string;
begin
   Result := True;
   s := AMaskList;
   while s <> '' do begin
      GetWrd(s, z, ' ');
      if SplitAddress(z, a, True) then Continue;
      if AHandle <> INVALID_HANDLE_VALUE then DisplayError(FormatLng(rsXfNoValidAOM, [z]), AHandle);
      Result := False;
      Break;
   end;
end;

function SplitAddressEx;
var
  i,
  b,
  j,
  k: Integer;
  c: char;
  PrevMask: Boolean;
const
  wstr: string = ':/.'#0;
begin
  Result := False;
  PrevMask := False;
  for i := 1 to 5 do Strs[i] := '';
  b := 1;
  j := Pos('@', Address);
  if j = 0 then begin
     j := Pos('#', Address);
     if (j <> 0) and (Pos('/#', Address) = 0) and (Pos('.#', Address) = 0) then begin
        b := j + 1;
        Strs[5] := LowerCase(ExtractWord(1, ExtractWord(1, Address, ['#']), ['.']));
     end;
     j := Length(Address);
  end else begin
     Strs[5] := LowerCase(ExtractWord(1, ExtractWord(2, Address, ['@']), ['.']));
     Dec(j);
  end;
  k := 1;
  for i := b to j do begin
    c := Address[i];
    case c of
      '0'..'9':
        if PrevMask then Exit else AddStr(Strs[k], c);
      'A'..'F', #3, #4: if not AllowREmask then Exit else
        begin
          if PrevMask then Exit else AddStr(Strs[k], c);
        end;
      '*':
        if (PrevMask) or (not AllowMask) then Exit else
        begin
          AddStr(Strs[k], '*');
          PrevMask := True;
        end;
      '#':
        if AllowMask and (k = 4) then begin
          AddStr(Strs[k], '#');
          PrevMask := True;
        end else
        if AllowMask and (k = 3) then begin
          AddStr(Strs[k], '#');
          PrevMask := True;
        end else Exit;
      else
        if c <> wstr[k] then Exit else
        begin
          PrevMask := False;
          if Strs[k] = '' then Exit;
          Inc(k);
        end;
     end;
  end;
  case k of
    1 : begin
          if AllowMask and (Address = '*') then begin
             Strs[2] := '*';
             Strs[3] := '*';
             Strs[4] := '*';
             Strs[5] := '*';
             Result := True;
          end;
        end;
    2 : begin
          if AllowMask and (Strs[2] = '*') then begin
             Strs[3] := '*';
             Strs[4] := '*';
             Strs[5] := '*';
             Result := True;
          end;
        end;
    3 : begin
          Result := Strs[3] <> '';
          if Result then
          begin
            if (AllowMask and (Pos('*', Address) > 0)) or
               (AllowMask and (Strs[3] = '#')) or
               (AllowREMask and (Pos(#3, Address) > 0))
            then begin
               Strs[4] := '*';
               if Strs[5] = '' then begin
                  Strs[5] := '*';
               end;
            end else begin
               Strs[4] := '0';
               if Strs[5] = '' then begin
                  Strs[5] := FindFTNDOM(Address);
               end;
            end;
          end;
        end;
    4 : begin
          Result := Strs[4] <> '';
            if (AllowMask and (Pos('*', Address) > 0)) or
               (AllowMask and (Strs[4] = '#')) or
               (AllowREMask and (Pos(#3, Address) > 0))
            then begin
               if Strs[5] = '' then begin
                  Strs[5] := FindFTNDOM(Address);
               end;
            end else begin
               if Strs[5] = '' then begin
                  Strs[5] := FindFTNDOM(Address);
               end;
            end;
        end;
    else Result := False;
  end;
end;

function SplitAddress;
begin
   Result := SplitAddressEx(Address, strs, AllowMask, False);
end;

function PureAddressMasks(const a: Ta4s): Boolean;
var
   i: Integer;
   s: string;
begin
   Result := True;
   for i := 1 to 5 do begin
      s := a[i];
      if (Pos('*', s) > 0) and (s <> '*') then begin
         Result := False;
         Break;
      end;
   end;
end;

function ValidAddress(const Address: String): Boolean;
var
   A: TFidoAddress;
begin
   Result := ParseAddress(Address, A);
end;

function ParseAddressMsg(const Address: String; var Addr: TFidoAddress; var Msg: string): Boolean;
begin
   Result := ParseAddressMsgEx(Address, Addr, @Msg);
end;

function FindFTNDOM(const a: TFidoAddress): string;
begin
   if not IniFile.D5Out then begin
      Result := '';
      exit;
   end;
   Result := a.Domain;
   if a.Zone = word(-1) then exit;
   if a.Domain <> '' then exit;
   if inifile = nil then exit;
   if not inifile.D5Out then exit;
   if (Result = '') then Result := inifile.MainAddr.Domain;
   if (Result = '') and IniFile.d5Out and (a.Zone in [1..6]) then Result := 'fidonet';
end;

function FindFTNDOM(const a: string): string;
var
   f: TFidoAddress;
begin
   fillchar(f, sizeof(f), #0);
   f.Zone := strtointdef(ExtractWord(1, a, [':']), -1);
   Result := FindFTNDOM(f);
end;

function A4s2Addr(const a: Ta4s; var Addr: TFidoAddress): Boolean;
var
   e,
   i: DWORD;
begin
   Result := False;
   for i := 1 to 4 do begin
      e := Vl(a[i]);
      if (e = INVALID_VALUE) or (e > $FFFF) then Exit;
      Addr.arr[i] := e;
   end;
   if inifile.D5Out then begin
      if a[5] <> '' then begin
         Addr.Domain := LowerCase(a[5]);
         if a[5] = '*' then exit;
      end else begin
         Addr.Domain := FindFTNDOM(Addr);
      end;
   end;
   Result := True;
end;

function ParseAddress;
var
   a: Ta4s;
   s: TStringList;
   i: integer;
   t: string;
   sfin: string;
begin
   Result := False;
   if IniFile = nil then exit;
   FillChar(Addr, SizeOf(Addr), #0);
   sfin := '';
   if pos(':', Address) = 0 then sfin := IntToStr(IniFile.MainAddr.Zone) + ':';
   if pos('/', Address) = 0 then sfin := sfin + IntToStr(IniFile.MainAddr.Net) + '/';
   sfin := sfin + Address;
   if not SplitAddress(sfin, a, False) then begin
      if not Result then begin
         s := IniFile.ReadSection('Grids', 'gSMTP');
         if s <> nil then begin
            for i := 0 to s.Count - 1 do begin
               t := IniFile.ReadString('Grids', s[i]);
               if (pos(UpperCase(ExtractWord(1, Address, ['@'])) + '|', UpperCase(t)) > 0) and (Address <> '') then begin
                  Addr.Zone   := $FFFF;
                  Addr.Net    := $FFFF;
                  Addr.Node   := $FFFF;
                  Addr.Point  := i + 1;
                  Addr.Domain := 'POP3';
                  Result := True;
                  break;
               end;
            end;
            s.Free;
         end;
      end;
      Exit;
   end;
   Result := A4s2Addr(a, Addr);
end;

function FidoAddress;
begin
   Result.Zone := Zone;
   Result.Net := Net;
   Result.Node := Node;
   Result.Point := Point;
   if IniFile.d5out then begin
      Result.Domain := Domain;
   end else begin
      Result.Domain := '';
      exit;
   end;
   if Domain = '' then begin
      Result.Domain := FindFTNDOM(Result);
      if (Result.Domain = '') and (Zone in [1..6]) then Result.Domain := 'fidonet';
   end;
end;

function CompareAddrs(const a, b: TFidoAddress; NLColl: boolean = False): Integer;
begin
   if not NLColl and IniFile.D5Out then begin
      if a.Domain < b.Domain then Result := -1 else
      if a.Domain > b.Domain then Result :=  1 else Result := 0;
      if Result <> 0 then exit;
   end;
   Result := a.Zone  - b.Zone;
   if Result <> 0 then begin
      if a.Zone = word(-1) then Result := -1 else
      if b.Zone = word(-1) then Result :=  1;
      exit;
   end;
   Result := a.Net   - b.Net;
   if Result <> 0 then exit;
   Result := a.Node  - b.Node;
   if Result <> 0 then exit;
   result := a.Point - b.Point;
   if Result <> 0 then exit;
end;

constructor TFidoNode.Create;
begin
   inherited;
   InitializeCriticalSection(CS);
end;

function TFidoNode.Copy: TFidoNode;
begin
   Result := nil;
   if self = nil then exit;
   try
      EnterCS(CS);
      Result := TFidoNode.Create;
      Result.Addr     := Addr;
      Result.Region   := Region;
      Result.Hub      := Hub;
      Result.Speed    := Speed;
      Result.Station  := StrAsg(Station);
      Result.Sysop    := StrAsg(Sysop);
      Result.Phone    := StrAsg(Phone);
      Result.Flags    := StrAsg(Flags);
      Result.Location := StrAsg(Location);
      Result.PrefixFlag := PrefixFlag;
      Result.HasPoints := HasPoints;
      Result.TreeItem := TreeItem;
      LeaveCS(CS);
   except
      on E: Exception do begin
         ProcessTrap(E.Message, 'TFidoNode.Copy');
      end;
   end;
end;

destructor  TFidoNode.Destroy;
begin
   if Coll <> nil then begin
      Coll.Enter;
      Coll.Delete(Self);
      Coll.Leave;
      Coll := nil;
   end;
   PurgeCS(CS);
   inherited Destroy;
end;

procedure TFidoNodeColl.AtInsert(Index: Integer; Item: Pointer);
begin
  inherited;
  TFidoNode(Item).Coll := Self;
end;

function TFidoNodeColl.Compare(Key1, Key2: Pointer): Integer;
begin
   Result := CompareAddrs(TFidoAddress(Key1^), TFidoAddress(Key2^));
end;

procedure TFidoNodeColl.Concat(AColl: TColl);
begin
   inherited;
end;

procedure TFidoNodeColl.FreeAll;
var
   i: integer;
begin
   Enter;
   for i := 0 to FCount - 1 do begin
      TFidoNode(At(I)).Coll := nil;
      FreeItem(At(I));
   end;
   FCount := 0;
   Leave;
end;

function TFidoNodeColl.KeyOf(Item: Pointer): Pointer;
begin
   Result := @TFidoNode(Item).Addr;
end;

procedure TFidoNodeColl.Update(Item: Pointer);
var
   i: integer;
begin
   if Search(@TFidoNode(Item).Addr, i) then begin
      TFidoNode(Items[i]).TreeItem := TFidoNode(Item).TreeItem;
   end else begin
      Insert(Item);
   end;
end;

destructor TAdvNode.Destroy;
begin
   FreeObject(Ext);
   FreeObject(DialupData);
   FreeObject(IPData);
   inherited Destroy;
end;

function TAdvNode.Copy: Pointer;
var
   r: TAdvNode;
begin
   r := TAdvNode.Create;
   r.Speed := Speed;
   r.Station := StrAsg(Station);
   r.Sysop := StrAsg(Sysop);
   r.Location := StrAsg(Location);
   r.PrefixFlag := PrefixFlag;
   r.Addr := Addr;
   if DialupData <> nil then r.DialupData := DialupData.Copy;
   if IPData <> nil then r.IPData := IPData.Copy;
   if Ext <> nil then r.Ext := Ext.Copy;
   Result := r;
end;

function TAdvNodeExtData.Copy: Pointer;
var
   r: TAdvNodeExtData;
begin
   r := TAdvNodeExtData.Create;
   r.Opts := StrAsg(Opts);
   r.Cmd := StrAsg(Cmd);
   Result := r;
end;

function CurFSC62Quant: TFSC62Quant;
begin
   Result := TFSC62Quant((uGetSystemTime mod SecsPerDay) div (60 * 30));
end;

function IsTxyEx(const S: string; var Local: Boolean; FReq: boolean): Boolean;
var
   len: byte;
begin
   Result := False;
   if freq and (length(s) < 4) then begin
      result := false;
      exit;
   end;
   if FReq then begin
      if UpCase(s[4]) <> 'F' then exit;
      len := 4;
   end else len := 3;
   if Length(S) = len then Local := False else
   if Length(S) = len + 1 then begin
      Local := True;
      if UpCase(S[len + 1]) <> 'L' then Exit
   end else Exit;
   if UpCase(S[1]) <> 'T' then Exit;
   Result := (S[2] in ['A'..'X', 'a'..'x']) and (S[3] in ['A'..'X', 'a'..'x']);
end;

function IsTxy(const S: string; var Local: Boolean): Boolean;
begin
   result := IsTxyEX(s,local,false);
end;

procedure AdjustFSC62Quant(var t: TFSC62Quant; Bias: Integer);
var
   i: Integer;
begin
   i := Integer(t) + Bias div (60*30);
   if i < 0 then i := 48 + i else
   if i > 47 then i := i - 48;
   t := TFSC62Quant(i);
end;

procedure FillFSC62Time(var t: TFSC62Time; t1, t2: TFSC62Quant);
var
   i: TFSC62Quant;
begin
   if t1 <= t2 then begin
      Include(t, t1);
      if (t1 < High(TFSC62Quant)) and (t2 > Low(TFSC62Quant)) then for i := Succ(t1) to Pred(t2) do Include(t, i);
   end else begin
      for i := t1 to High(TFSC62Quant) do Include(t, i);
      if t2 > Low(TFSC62Quant) then for i := Low(TFSC62Quant) to Pred(t2) do Include(t, i);
   end;
end;

function NodeFSC62LocalEx(const Flags: string; FReq: boolean): TFSC62Time;
begin
   Result := _NodeFSC62TimeEx(Flags, FidoAddress(-1, -1, -1, -1, ''), FReq, True);
end;

function NodeFSC62Local(const Flags: string): TFSC62Time;
begin
   Result := NodeFSC62LocalEx(Flags, False);
end;

function GetTime(C: Char; var Q: TFSC62Quant): Boolean;
var
   i: Integer;
begin
   Result := False;
   case C of
   'a'..'x', 'A'..'X' :;
   else Exit;
   end;
   i := Ord(C) - Ord('A');
   if i < 24 then Inc(i, i) else begin
      Dec(i, Ord('a') - Ord('A'));
      Inc(i, i + 1);
   end;
   Q := TFSC62Quant(I);
   Result := True;
end;

function GetShiftedZMH(var z: string; var zone: integer): boolean; {by Alexey Asemov 2:550/555}
var
   zi: integer; {*}
begin {*}
   Result := False; {*}
   if Length(z)<3 then exit; {*}
   if (z[1] <> '!') and (z[1] <> '#') then exit; {*}
   if (z[2] < '0') or (z[2] > '9') then exit; {*}
   if (z[3] < '0') or (z[3] > '9') then exit; {*}
   Result := True; {*}
   zi := StrToInt(z[2] + z[3]); {*}
   z := Copy(z, 4, Length(z) - 3); {*}
   case zi of {*}
   1: zone := 5; {*}
   2: zone := 2; {*}
   8: zone := 4; {*}
   9: zone := 1; {*}
   18: zone := 3; {*}
   20: zone := 6; {*}
   else Result := False; {*}
   end; {*}
end; {*}

function _NodeFSC62TimeEx(Flags: string; const Addr: TFidoAddress; FReq, ALocal: Boolean; IP: boolean = False): TFSC62Time;
var
   z: string;
   t1,
   t2: TFSC62Quant;

const
   zmh: array[1..6] of TFSC62Quant = (
    09 * 2 + 0, // Zone 1 mail hour (09:00 - 10:00 UTC)
    02 * 2 + 1, // Zone 2 mail hour (02:30 - 03:30 UTC)
    18 * 2 + 0, // Zone 3 mail hour (18:00 - 19:00 UTC)
    08 * 2 + 0, // Zone 4 mail hour (08:00 - 09:00 UTC)
    01 * 2 + 0, // Zone 5 mail hour (01:00 - 02:00 UTC)
    20 * 2 + 0  // Zone 6 mail hour (20:00 - 21:00 UTC)
   );
var
   Local,
   u: Boolean;
   ZMHZone: Integer; {*}
begin
//   u := False;
   u := True;
   Result := [];
   while Flags <> '' do begin
      GetWrd(Flags, z, ',');
      if z = '' then continue;
      u := u or (UpperCase(z) = 'U');
      if not FReq then begin
         if ((z[1] = '#') or (z[1] = '!')) then begin {*}
            { parse extended ZMH shift flags! } {*}
            while GetShiftedZMH(z, ZMHZone) do begin {*}
               t1 := zmh[ZMHZone]; {*}
               t2 := Succ(t1) + 1; {*} //buster ??
               if ALocal then begin {*}
                  GetBias; {*}
                  AdjustFSC62Quant(t1, -TimeZoneBias); {*}
                  AdjustFSC62Quant(t2, -TimeZoneBias); {*}
               end; {*}
               FillFSC62Time(Result, t1, t2); {*}
            end; {*}
         end; {*}
         if (UpperCase(z) = 'CM') then begin
            Result := [Low(TFSC62Quant)..High(TFSC62Quant)];
            Exit;
         end;
         if IP and (UpperCase(z) = 'ICM') then begin
            Result := [Low(TFSC62Quant)..High(TFSC62Quant)];
            Exit;
         end;
      end;
      if u and IsTxyEx(z, Local, FReq) then begin
         if (GetTime(z[2], t1)) and
            (GetTime(z[3], t2)) then
         begin
            if Local <> ALocal then
            if Local then begin
               GetBias;
               AdjustFSC62Quant(t1, TimeZoneBias);
               AdjustFSC62Quant(t2, TimeZoneBias);
            end else
            if ALocal then begin
               GetBias;
               AdjustFSC62Quant(t1, -TimeZoneBias);
               AdjustFSC62Quant(t2, -TimeZoneBias);
            end;
            Result := [];
            FillFSC62Time(Result, t1, t2);
         end;
      end;
   end;
   if {(not ALocal) and} (Addr.Point = 0) and (Result = []) then
   case Addr.Zone of
   1..6 :
      begin
         t1 := zmh[Addr.Zone];
         t2 := Succ(t1);
         if ALocal then begin
            GetBias;
            AdjustFSC62Quant(t1, -TimeZoneBias);
            AdjustFSC62Quant(t2, -TimeZoneBias);
         end;
         Include(Result, t1);
         Include(Result, t2)
      end;
   end;
   if (Result = []) and (FReq) then Result := [Low(TFSC62Quant)..High(TFSC62Quant)];
end;

function NodeFSC62TimeEx;
var
   n: TAdvNode;
begin
   if not IP then begin
      n := FindNode(Addr);
      if n <> nil then begin
         try
            if (n.Speed = 300)  and (n.DialupData = nil) then begin
               Result := [];
               exit;
            end else
            if n.DialupData <> nil then begin
            end;
         finally
            FreeObject(n);
         end;
      end;
   end;
   result := _NodeFSC62TimeEx(Flags, Addr, false, ALocal, IP);
end;

function _IdentOvrItem(const Item: string; AddrMask: Boolean; ChkFlags, InverseFlags: Boolean): TOvrItemTyp;
var
   CS: xBase.TCharSet;
   US,
   TS: string; {*}
begin
   Result := oiUnknown;
   if Item = '' then Exit;
   US := UpperCase(Item);
   FillCharSet(US, CS);
   if ValidSymAddr(Item) then Result := oiIPSym else
   if ValidInetAddr(Item) then Result := oiIPNum else
   if ((':' in CS) or
       ('/' in CS) or
       ('.' in CS)) and (US[1] < 'A') then
   begin
      if AddrMask then begin
         if ValidMaskAddress(Item) then begin
            if ValidAddress(Item) then Result := oiAddress
                                  else Result := oiAddressMask;
         end;
      end else begin
         if ValidAddress(Item) then Result := oiAddress;
      end;
   end else
   if ('-' in CS) and not ('@' in CS) then begin
      if ([',', '+', '-', 'W', '0'..'9'] * CS = CS) and
         (Pos('--', Item) = 0) and
         (Pos('+', CopyLeft(Item, 2)) = 0) and
         (['0'..'9'] * CS <> [])
      then Result := oiPhoneNum;
   end else
   if ChkFlags then begin
      TS := Copy(US, 1, 3); {*}
      if (TS = '!01') or (TS = '!02') or (TS = '!08') or (TS = '!09') or (TS = '!18')  or (TS = '!20') or
         (TS = '#01') or (TS = '#02') or (TS = '#08') or (TS = '#09') or (TS = '#18')  or (TS = '#20') then {*}
      begin {*}
         if InverseFlags then Result := oiInvFlag else Result := oiFlag; {*}
         exit;
      end; {*}
      case US[1] of
      '!':
         if not InverseFlags then Result := _IdentOvrItem(CopyLeft(Item, 2), AddrMask, ChkFlags, True);
      'A'..'Z':
         if ['.', ':', '@', '-', '0'..'9', 'A'..'Z', '_'] * CS = CS then begin
            if InverseFlags then Result := oiInvFlag else Result := oiFlag;
         end;
      end;
   end;
end;

function IdentOvrItem(const Item: string; AddrMask: Boolean; ChkFlags: Boolean): TOvrItemTyp;
begin
  Result := _IdentOvrItem(Item, AddrMask, ChkFlags, False);
end;

function ValidOverride(const AStr: string; Dialup: Boolean; var Item: string): string;
var
  L: TColl;
begin
  L := ParseOverride(AStr, Result, Item, Dialup);
  FreeObject(L);
end;

function ConflictsFSC0072(s: string): string;
var
  Local,
  u: Boolean;
  z,
 us: string;
begin
  Result := '';
  u := False;
  while s <> '' do
  begin
    GetWrd(s, z, ',');
    us := UpperCase(z);
    u := u or (us = 'U');
    if IsTxy(z, Local) then
    begin
      if not u then
      begin
        if (us <> 'TCP') and (us <> 'TEL') then
          Result := FormatLng(rsXfFSC72U, [z]);
      end;
    end;
  end;
end;

function ParseOverride(const AAStr: string; var Msg, Item: string; Dialup: Boolean): TColl;
var
  L: TColl;
  AStr: string;

function Parse: Boolean;
var
  w: string;

function ParseOvr: Boolean;
type
  TOvrTyp = (otNone, otPhoneDirect, otPhoneNodelist);
var
  s, z: string;
  nTyp: TOvrTyp;
  nPhoneDirect: string;
  nFlags: string;
  nPhoneNodelist: TFidoAddress;
  o: TOvrData;
  ioi: TOvrItemTyp;
const
  FlagOnly : array[Boolean] of integer = (rsXfFO0, rsXfFO1);
  _APD: array[Boolean] of integer = (rsXfAPD0, rsXfAPD1);
  _APN: array[Boolean] of integer = (rsXfAPN0, rsXfAPN1);
begin
  Result := False;
  if Application.MainForm = nil then exit;
  Msg := '';
  nTyp := otNone;
  nPhoneDirect := '';
  nFlags := '';
  FillChar(nPhoneNodelist, SizeOf(nPhoneNodelist), 0);
  while w <> '' do
  begin
    if dialup and (w[1] = '"') then begin
       GetWrd(w, z, '"');
       GetWrd(w, z, '"');
       delete(w, 1, 1);
    end else begin
       GetWrd(w, z, ',');
    end;
    ioi := IdentOvrItem(z, False, True);
    s := '';
    case ioi of
      oiPhoneNum : if not Dialup then s := LngStr(rsXfPNNA);
      oiIPSym    : if Dialup then s := LngStr(rsXfIPSNA);
      oiIPNum    : if Dialup then
                   begin
                     if not DigitsOnly(z) then s := LngStr(rsXfIPNNA) else
                       s := FormatLng(rsXfIPNEG, ['%s', DivideDash(z)]);
                   end;
    end;
    if s <> '' then
    begin
      Msg := Format(s, [z]);
      Exit;
    end;
    case ioi of
  {-} oiAddress:
        case nTyp of
          otNone:
            begin
              if not ParseAddressMsg(z, nPhoneNodelist, Msg) then Exit;
              nTyp := otPhoneNodelist;
            end;
          otPhoneDirect:
            begin
              Msg := FormatLng(_APD[Dialup], [z, nPhoneDirect]);
              Exit;
            end;
          otPhoneNodelist:
            begin
              Msg := FormatLng(_APN[Dialup], [z, Addr2Str(nPhoneNodelist)]);
              Exit;
            end;
        end;
  {-} oiPhoneNum, oiIPSym, oiIPNum:
        case nTyp of
          otNone:
            begin
              nPhoneDirect := z;
              nTyp := otPhoneDirect;
            end;
          otPhoneDirect:
            begin
              case ioi of
                oiPhoneNum : s := LngStr(rsXfAPpdPn);
                oiIPSym    : s := LngStr(rsXfAPpdIs);
                oiIPNum    : s := LngStr(rsXfAPpdIn);
                else GlobalFail('ParseOverride("%s",...) unknown ioi on otPhoneDirect', [AAStr]);
              end;
              Msg := Format(s, [z, nPhoneDirect]);
              Exit;
            end;
          otPhoneNodelist:
            begin
              case ioi of
                oiPhoneNum : s := LngStr(rsXfAPpnPn);
                oiIPSym    : s := LngStr(rsXfAPpnIs);
                oiIPNum    : s := LngStr(rsXfAPpnIn);
                else GlobalFail('ParseOverride("%s",...) unknown ioi on otPhoneNodelist', [AAStr]);
              end;
              Msg := Format(s, [z, Addr2Str(nPhoneNodelist)]);
              Exit;
            end;
        end;
      oiFlag, oiInvFlag:
        if nTyp = otNone then
        begin
          Msg := FormatLng(FlagOnly[Dialup], [z]);
          Exit;
        end else
        begin
          if nFlags <> '' then AddStr(nFlags, ',');
          nFlags := nFlags + z;
        end;
      oiUnknown:
        begin
          Msg := FormatLng(rsXfUnrecItem, [z]);
          Exit;
        end;
    end;
  end;
  if nTyp = otNone then Exit;
  Msg := ConflictsFSC0072(nFlags);
  if Msg <> '' then Exit;
  Result := True;
  o := TOvrData.Create;
  o.PhoneDirect := StrAsg(nPhoneDirect);
  o.Flags := StrAsg(nFlags);
  o.PhoneNodelist := nPhoneNodelist;
  L.Insert(o);
end;

function ChkTransport: Boolean;
var
  i: Integer;
  o: TOvrData;

const
  TCPFlags = 'BND, BNP, IBN, IFC, IP, ITN, IVM, TCP, TEL, VMP, POP, ITX, IUC, IMI, ISE, IEM';
  CMsg: array[Boolean] of Integer = (rsXfCmsg0, rsXfCmsg1);

begin
  Result := True;
  for i := 0 to L.Count - 1 do
  begin
    o := L[i];
    if o.PhoneDirect = '' then Continue;
    if not TransportFlagsMatch(o.PhoneDirect, o.Flags, Dialup) then
    begin
      Item := o.PhoneDirect;
      if o.Flags <> '' then Item := Item + ',' + o.Flags;
      Msg := FormatLng(CMsg[Dialup], [TCPFlags]);
      Result := False;
      Exit;
    end;
  end;
end;

begin
   AStr := AAStr;
   Result := False;
   while AStr <> '' do
   begin
      GetWrd(AStr, w, ' ');
      Item := w;
      if not ParseOvr then Exit;
   end;
   Result := ChkTransport;
end;

begin
   L := TColl.Create;
   if not Parse then FreeObject(L);
   Result := L;
end;

function IsIpFlag(ACRC: DWORD): Boolean;
begin
  case ACRC of
    kwTCP    ,
    kwVMP    ,
    kwTEL    ,
    kwTELNET ,
    kwIFC    ,
    kwBINKP  ,
    kwBINKD  ,
    kwBND    ,
    kwBNP    ,
    kwIBN    ,
    kwITN    ,
    kwIVM    ,
    kwPOP    ,
    kwITX    ,
    kwIUC    ,
    kwIMI    ,
    kwISE    ,
    kwIEM    ,
    kwIP     : Result := True;
    else Result := False;
  end;
end;

procedure PurgeIpFlags;
var
  Again: Boolean;
  Idx, i: Integer;
  c: DWORD;
begin
  Again := True;
  Idx := 0;
  while Again do
  begin
    Again := False;
    for i := Idx to CollMax(SC) do
    begin
      Idx := i;
      c := CRC32Str(UpperCase(SC[i]), CRC32_INIT);
      if c = kwU then Break;
      if IsIpFlag(c) then
      begin
        SC.AtFree(i);
        Again := True;
        Break;
      end;
    end;
  end;
end;

function AreFlagsTCP(s: string): Boolean;
var
   f: TStringColl;
   i: Integer;
begin
   Result := False;
//  s := UpperCase(s); //All standard flags must be UpperCased
                       //in other case they are not standard IP-Flags
   i := Pos('U,', s);
   if i > 0 then s := Copy(s, 1, i);
   f := TStringColl.Create;
   f.FillEnum(s, [','], True);
   for i := 0 to f.Count - 1 do begin
     if IsIpFlag(CRC32Str(Extractword(1, f[i], [':']), CRC32_INIT)) then begin Result := True; Break end;
   end;
//  Result := f.Found('TCP') or f.Found('VMP') or f.Found('TEL') or f.Found('TELNET') or f.Found('IFC') or f.Found('BINKP') or f.Found('BINKD') or f.Found('BND');
   FreeObject(f);
end;

function GetTransportType;
var
   o: TOvrItemTyp;
begin
   o := IdentOvrItem(Phone, False, False);
   Result := ttInvalid;
   if AreFlagsTCP(Flags) then begin
      if (o = oiIPNum) or (o = oiIPSym) then Result := ttIP;
      Exit;
   end;
   if o = oiPhoneNum then Result := ttDialup;
end;

function WipePhoneNumber(const Phone: string): string;
begin
   Result := WipeChars(Phone, '+-');
end;

function TransportMatch(const Num: string; Dialup: Boolean): Boolean;
var
   oi: TOvrItemTyp;
begin
   oi := IdentOvrItem(Num, False, False);
   Result := not (((Dialup = True) and (oi <> oiPhoneNum)) or ((Dialup = False) and (oi <> oiIPSym) and (oi <> oiIPNum)))
end;

function TransportFlagsMatch(const s, z: string; Dialup: Boolean): Boolean;
var
   tt: TTransportType;
begin
   tt := GetTransportType(s, z);
   Result := not (((Dialup = True) and (tt <> ttDialup)) or ((Dialup = False) and (tt <> ttIP)));
end;

function VlMsg(const s: string; var Rslt: DWORD; var Msg: string): Boolean;
var
   a: DWORD;
begin
   Result := False;
   a := Vl(s);
   if a = INVALID_VALUE then begin
      Msg := FormatLng(rsXfCrnINV, [s]);
      Exit;
   end;
   Result := True;
   Rslt := a;
end;

function VlMsgR(const s: string; Mn, Mx: DWORD; var Rslt: DWORD; var Msg: string): Boolean;
begin
   Result := VlMsg(s, Rslt, Msg);
   if not Result then Exit;
   if (Rslt >= Mn) and (Rslt <= Mx) then Exit;
   Msg := FormatLng(rsXfCrnINR, [Rslt, Mn, Mx]);
   Result := False;
end;

function ValidCronRecDlg;
var
   r: TCronRecord;
   ErrorStr: string;
begin
   r := ParseCronRec('', s, Permanent, False, ErrorStr);
   Result := r <> nil;
   if Result then FreeObject(r) else begin
      DisplayError(ErrorStr, Handle);
   end;
end;

function ValidCronRecStr(const s: string): string;
var
   r: TCronRecord;
   ErrorStr: string;
begin
   r := ParseCronRec('', s, False, False, ErrorStr);
   if r = nil then Result := ErrorStr else begin Result := ''; FreeObject(r) end;
end;

function ValidCronRec(const s: string): Boolean;
begin
   Result := ValidCronRecStr(s) = '';
end;

function ParseCronRecUnp(s: string; var r: TCronRecUnp): string;
var
   ErrMsg: string;

procedure _Get(a: PxByteArray; var Cnt: Byte; MinValue, MaxValue, OfsValue: DWORD);

function Vl(const s: string; var b: Byte): Boolean;
var
   i: DWORD;
begin
   Result := VlMsgR(s, MinValue, MaxValue, i, ErrMsg);
   if not Result then Exit;
   b := i;
end;

var
   cc: Integer;
   skp, step: Byte;

procedure Add(b: Byte);
var
   i: Integer;
begin
   Dec(b, OfsValue);
   for i := 0 to cc - 1 do begin
      if a^[i] = b then Exit;
   end;
   a^[cc] := b;
   Inc(cc);
end;

procedure AddSkp(b: Byte);
begin
   if skp = 0 then Add(b);
   Inc(skp);
   if skp >= step then skp := 0;
end;

procedure VE;
begin
   ErrMsg := LngStr(rsXfCrnVE);
end;

var
   z, k, l, st: string;
   b, mn, mx: Byte;
begin
   step := 0;
   GetWrd(s, z, ' ');
   if z = '' then begin
      if MaxValue = 59 then begin
         VE; Exit;
      end else begin
         z := '*';
      end;
   end;
   cc := 0;
   repeat
      if z <> '*' then begin
         if Pos ('/', z) > 0 then begin
            st := z;
            GetWrd(st, z, '/');
            if not Vl(st, step) then Exit;
            if z = '*' then begin
               b := MinValue;
               repeat
                  Add(b);
                  Inc(b, step);
               until b > MaxValue;
               Break;
            end;
         end;
         while z <> '' do begin
            GetWrd(z, k, ',');
            if Pos('-', k) = 0 then begin
               if not Vl(k, b) then Exit;
               if step = 0 then Add(b) else begin
                  repeat
                     Add(b);
                     Inc(b, step);
                  until b > MaxValue;
               end;
            end else begin
               GetWrd(k, l, '-');
               if not Vl(l, mn) then Exit;
               if not Vl(k, mx) then Exit;
               skp := 0;
               if mx >= mn then for b := mn to mx do AddSkp(b) else begin
                  for b := mn to MaxValue do AddSkp(b);
                  skp := 0;
                  for b := MinValue to mx do AddSkp(b);
               end;
            end;
         end;
      end;
   until True;
   Cnt := cc;
end;

function Get(a: PxByteArray; var Cnt: Byte; MinValue, MaxValue, OfsValue: Byte): Boolean;

procedure QuickSort(L, R: Byte);
var
   T, P: Byte;
   I, J: Integer;
begin
   repeat
      I := L;
      J := R;
      P := a^[(L + R) shr 1];
      repeat
         while a^[I] < P do Inc(I);
         while a^[J] > P do Dec(J);
         if I <= J then begin
            T := a^[I];
            a^[I] := a^[J];
            a^[J] := T;
            Inc(I);
            Dec(J);
         end;
      until I > J;
      if L < J then QuickSort(L, J);
      L := I;
   until I >= R;
end;

begin
   Cnt := $FF;
  _Get(a, Cnt, MinValue, MaxValue, OfsValue);
   Result := Cnt <> $FF;
   if Result and (Cnt>1) then QuickSort(0, Cnt-1);
end;

function NoMore: Boolean;
begin
   Result := Trim(s) = '';
   if not Result then ErrMsg := FormatLng(rsXfCrnUS, [s]);
end;

begin
   ErrMsg := 'Cron Format Error!!!';
   with r do
   if Get(@Minutes, NumMinutes, 0, High(Minutes), 0) and
      Get(@Hours, NumHours, 0, High(Hours), 0) and
      Get(@Days, NumDays, 1, High(Days)+1, 1) and
      Get(@Months, NumMonths, 1, High(Months)+1, 1) and
      Get(@Dows, NumDows, 1, High(Dows)+1, 1) and
      NoMore then Result := '' else
   begin
      if Trim(ErrMsg) = '' then GlobalFail('ParseCronRec("%s",...) ErrMsg=<empty>', [s]);
      Result := ErrMsg;
   end;
end;

function ParseCronRec(n, s: string; Permanent, UTC: Boolean; var ErrStr: string): TCronRecord;
var
  pk: TCronRecUnp;
   r: TCronRec;
   i: Integer;
   z: string;
begin
   Clear(r, SizeOf(r));
   Result := TCronRecord.Create(n);
   Result.IsUTC := UTC;
   if Permanent then begin
      Result.IsPermanent := True;
      ErrStr := '';
      Exit;
   end;
   repeat
      GetWrd(s, z, ';');
      ErrStr := ParseCronRecUnp(z, pk);
      if ErrStr <> '' then begin FreeObject(Result); Exit; end;
      if pk.NumMinutes = 0 then r.Minutes := [0..High(T_Minute)] else for i := 0 to pk.NumMinutes - 1 do Include(r.Minutes, pk.Minutes[i]);
      if pk.NumHours = 0 then r.Hours := [0..High(T_Hour)] else for i := 0 to pk.NumHours - 1 do Include(r.Hours, pk.Hours[i]);
      if pk.NumDays = 0 then r.Days := [0..High(T_Day)] else for i := 0 to pk.NumDays - 1 do Include(r.Days, pk.Days[i]);
      if pk.NumMonths = 0 then r.Months := [0..High(T_Month)] else for i := 0 to pk.NumMonths - 1 do Include(r.Months, pk.Months[i]);
      if pk.NumDows = 0 then r.Dows := [0..High(T_Dow)] else for i := 0 to pk.NumDows - 1 do Include(r.Dows, pk.Dows[i]);
      Inc(Result.Count);
      ReallocMem(Result.p, Result.Count * SizeOf(TCronRec));
      Result.p^[Result.Count - 1] := r;
      s := Trim(s);
      if s = '' then Break;
      Clear(r, SizeOf(r));
   until False;
end;

function _ParseCronColl(n: string; c: TStringColl; var ErrLn: Integer; var Msg: string): TColl;
var
   i: Integer;
   s, ec: string;
   r: TCronRecord;
begin
   Result := nil;
   for i := 0 to c.Count - 1 do begin
      s := c[i];
      r := ParseCronRec(n + s, s, False, False, ec);
      if r <> nil then begin
         if Result = nil then Result := TColl.Create;
         Result.Insert(r);
      end else begin
         ErrLn := i + 1;
         Msg := ec;
         FreeObject(Result);
         Break;
      end;
   end;
end;

function ValidCronColl(c: TStringColl; var ErrLn: Integer; var Msg: string): Boolean;
var
   cc: TColl;
begin
   cc := _ParseCronColl('', c, ErrLn, Msg);
   Result := cc <> nil;
   FreeObject(cc);
end;

function ParseCronColl(n: string; c: TStringColl): TColl;
var
   i: Integer;
   s: string;
begin
   Result := _ParseCronColl(n, c, i, s);
end;

function InvalidateModemCmdStr(const AName, AStr: string; FinalChar: Char; ValidOnLetters: Boolean): string;
var
   fc, s: string;
   CharSet: xBase.TCharSet;
   c: Char;
   err: Boolean;
begin
   Result := '';
   s := _DelSpaces(UpperCase(AStr));
   if FinalChar = #0 then fc := 'non-CR' else fc := FinalChar;
   if ValidOnLetters then begin
      FillCharSet(s, CharSet);
      if CharSet * ['A'..'Z'] = [] then Exit; ///
   end;
   if s = '' then Result := FormatLng(rsXfTplEmpty, [AName, fc]) else begin
      c := s[Length(s)];
      if FinalChar = #0 then err := (c = '!') or (c = '|') else err := c <> FinalChar;
      if err then Result := FormatLng(rsXfTplChar, [AName, AStr, c, AName, fc]);
   end;
end;

function ValidModemCmd(Idx: Integer; const Cmd, Name: string; Handle: DWORD): Boolean;
const
   FinalChars: array[0..MaxModemCmdIdx] of Char = ('|', '!', #0, '!', #1, #1, '|');
   VOLs: array[0..MaxModemCmdIdx] of Boolean = (True, True, False, False, False, False, True);
var
   c: Char;
   s: string;
begin
   Result := True;
   c := FinalChars[Idx];
   if c = #1 then Exit;
   s := InvalidateModemCmdStr(Name, Cmd, c, VOLs[Idx]);
   if s = '' then Exit;
   Result := YesNoWarning(s, Handle);
end;

function GetNodeType(N: TFidoNode): TNodeType;
begin
   if N.Addr.Point <> 0 then Result := fntPoint else
   if N.Addr.Node <> 0 then begin
      if N.Hub = N.Addr.Node then Result := fntHub else Result := fntNode;
   end else
   if ((N.Addr.Net = N.Addr.Zone) and ((N.Addr.Domain = 'fidonet') or not IniFile.D5Out) and (N.Region = 0)) or (N.Addr.Net = 0) then Result := fntZone else
   if N.PrefixFlag = nfRegion then Result := fntRegion else Result := fntNet;
end;

function IsArcMailExt(const AExt: string): Boolean;
var
   s: string;
begin
   s := UpperCase(Copy(AExt, 2, Length(AExt) - 2));
   Result :=
   (s = 'SU') or
   (s = 'MO') or
   (s = 'TU') or
   (s = 'WE') or
   (s = 'TH') or
   (s = 'FR') or
   (s = 'SA') or
   (s = 'TM');
end;

function IsNetMailExt(const AExt: string): Boolean;
var
   s: string;
begin
   s := UpperCase(Copy(AExt, Length(Aext) - 2, 3));
   Result :=
   (s = 'IUT') or
   (s = 'CUT') or
   (s = 'DUT') or
   (s = 'OUT') or
   (s = 'HUT') or
   (s = 'IU~') or
   (s = 'CU~') or
   (s = 'DU~') or
   (s = 'OU~') or
   (s = 'HU~');
end;

function IsNotMailExt(const AExt: string): Boolean;
begin
   Result := not (IsNetMailExt(AExt) or IsArcMailExt(AExt));
end;

procedure PurgeTimeFlags(SC: TStringColl);
begin
   PurgeTimeFlagsEx(SC, false);
end;

procedure PurgeTimeFlagsEx(SC: TStringColl; FReq: Boolean);
var
   i, Idx: Integer;
   uu, ok, Local: Boolean;
   s: string;
begin
   Idx := 0;
   uu := False;
   repeat
      ok := True;
      for i := Idx to CollMax(SC) do begin
         Idx := i;
         s := UpperCase(SC[i]);
         if not uu then begin
            if s = 'U' then begin
               uu := True;
               Continue;
            end;
            if s = 'CM' then begin
               ok := False; SC.AtFree(i); Break
            end;
            Continue;
         end;
         if IsTxyEx(s, Local, FReq) then begin
            ok := False; SC.AtFree(i); Break
         end;
      end;
   until ok;
   i := CollMax(SC);
   if (i >= 0) and (UpperCase(SC[i]) = 'U') then SC.AtFree(i);
end;

function FSC62QuantToStr(t: TFSC62Quant): string;
begin
   Result := Format('%.2d:%.2d', [Integer(t) div 2, (Integer(t) mod 2) * 30]);
end;

function FSC62QuantToChar(t: TFSC62Quant): Char;
begin
   Result := Char(Ord('A') + Integer(t) div 2 + (Ord('a') - Ord('A')) * (Integer(t) mod 2));
end;

function FSC62TimeToStr(t: TFSC62Time): string;
var
   Heads, Tails: array[0..23] of TFSC62Quant;
   FirstPair, NumPairs: Integer;
   i: TFSC62Quant;
   ScanHead: Boolean;
   s: string;
begin
   if t = [Low(TFSC62Quant)..High(TFSC62Quant)] then begin
      Result := 'CM';
      Exit;
   end;
   FirstPair := 0;
   NumPairs := 0;
   ScanHead := True;
   for i := Low(TFSC62Quant) to High(TFSC62Quant) do begin
      if ScanHead then begin
         if (i in t) then begin
            Heads[NumPairs] := i;
            ScanHead := False;
         end;
      end else begin // Scan Tail
         if not (i in t) then begin
            Tails[NumPairs] := i;
            Inc(NumPairs);
            ScanHead := True;
         end;
      end;
   end;
   if not ScanHead then begin
      Tails[NumPairs] := Low(TFSC62Quant);
      Inc(NumPairs);
   end;
   if (NumPairs > 1) and (Tails[NumPairs - 1] = Heads[0]) then begin
      Tails[NumPairs - 1] := Tails[0];
      FirstPair := 1;
   end;
   s := '';
   if NumPairs > 0 then
   for i := FirstPair to Pred(NumPairs) do begin
      if s <> '' then s := s + ',';
      s := s + FSC62QuantToStr(Heads[i]) + '-' + FSC62QuantToStr(Tails[i]);
   end;
   if s = '' then s := 'n/a';
   Result := s;
end;

function H2xCvtOK(var s: string): Boolean;
var
   s1, s2: string;
   a1, a2: DWORD;
   c: Char;
begin
   Result := False;
   GetWrd(s, s1, ':');
   GetWrd(s, s2, ':');
   if s <> '' then Exit;
   a1 := Vl(s1); if a1 = INVALID_VALUE then Exit;
   if a1 = 24 then a1 := 0;
   a2 := Vl(s2); if a2 = INVALID_VALUE then Exit;
   if (a1 > 23) then Exit;
   if (a2 > 59) then Exit;
   c := Char(Ord('a') + a1);
   if a2 < 30 then c := UpCase(c);
   s := c;
   Result := True;
end;

function HumanTime2TxyToken(ATime: string): string;
var
   s1, s2: string;
begin
   Result := '';
   GetWrd(ATime, s1, '-');
   GetWrd(ATime, s2, '-');
   if ATime <> '' then Exit;
   if H2xCvtOK(s1) and H2xCvtOK(s2) then Result := Format('T%s%sL', [s1, s2]);
end;

function HumanTime2UTxyL(const ATime: string; NeedU: Boolean): string;
begin
   result := HumanTime2UTxyLEx(ATime, false, NeedU);
end;

function HumanTime2UTxyLEx(ATime: string; FReq, NeedU: Boolean): string;
var
   s: string;
   c: TStringColl;
begin
   if (UpperCase(ATime) = 'CM') then begin
{    if FReq then Result:=''
    else }
      Result := 'CM';
      Exit;
   end;
   c := TStringColl.Create;
   while ATime <> '' do begin
      GetWrd(ATime, s, ',');
      s := HumanTime2TxyToken(s);
      if s <> '' then begin
         if FReq then Insert('F', s, 4);
         c.Add(s);
      end;
   end;
   if c.Count > 0 then begin
      if NeedU then Result := 'U,' else Result := '';
      Result := Result + c.LongStringD(',')
   end else Result := '';
   FreeObject(c);
end;


function OvrColl2Str(C: TColl): string;
var
   s, z: string;
   O: TOvrData;
   i: Integer;
begin
   z := '';
   for i := 0 to CollMax(C) do begin
      O := C[i];
      s := O.PhoneDirect;
      if s = '' then s := Addr2Str(O.PhoneNodelist);
      if O.Flags <> '' then s := s + ',' + O.Flags;
      if z <> '' then z := z + ' ';
      z := z + s;
   end;
   Result := z;
end;


function TAdvNodeData.Copy: Pointer;
var
   r: TAdvNodeData;
begin
   r := TAdvNodeData.Create;
   r.Flags := StrAsg(Flags);
   r.NdlFl := StrAsg(NdlFl);
   r.Phone := StrAsg(Phone);
   r.IPAddr := StrAsg(IPAddr);
   Result := r;
end;

function NextPollOptionMatchesMsg(var s, ErrMsg: string; AValue: DWORD): Boolean;

var
   z, k, l: string;
   b, mn, mx: DWORD;

procedure InvRange;
begin
   ErrMsg := FormatLng(rsRecsInvCRro, [mn, mx]);
end;

begin
   Result := False;
   GetWrd(s, z, ' ');
   if (z = '') or (z = '.') then Exit;
   while z <> '' do begin
      GetWrd(z, k, ',');
      if Pos('-', k) = 0 then begin
         if not VlMsg(k, b, ErrMsg) then Exit;
         if AValue = b then begin Result := True; Exit; end;
      end else begin
         GetWrd(k, l, '-');
         if not VlMsg(l, mn, ErrMsg) then Exit;
         if not VlMsg(k, mx, ErrMsg) then Exit;
         if mn > mx then begin InvRange; Exit end;
         if (AValue >= mn) and (AValue <= mx) then begin Result := True; Exit; end;
      end;
   end;
end;

function NextPollOptionMatches(var s: string; AValue: DWORD): Boolean;
var
   Msg: string;
begin
   Result := NextPollOptionMatchesMsg(s, Msg, AValue);
end;

function NextPollOptionValid(var s: string; Handle: DWORD): Boolean;
var
   Msg: string;
   i: DWORD;
begin
   i := INVALID_VALUE;
   NextPollOptionMatchesMsg(s, Msg, i);
   Result := Msg = '';
   if not Result then DisplayError(Msg, Handle);
end;

function NextPollSleepMSecsMsg(var s, ErrMsg: string): DWORD;
var
   z: string;
begin
   GetWrd(s, z, ' ');
   if z = '' then begin
      Result := INFINITE;
      Exit;
   end;
   if VlMsg(z, Result, ErrMsg) then Result := Result * 1000 * 60;
end;

function PollSleepMSecs(var s: string): DWORD;
var
   z, Msg: string;
begin
   z := s;
   Result := NextPollSleepMSecsMsg(z, Msg);
   if Msg <> '' then GlobalFail('PollSleepMSecs("%s")', [s]);
end;

function PollSleepMSecsValid(var s: string; Handle: DWORD): Boolean;
var
   Msg: string;
begin
   NextPollSleepMSecsMsg(s, Msg);
   Result := Msg = '';
   if not Result then DisplayError(Msg, Handle);
end;

function PollTimeoutExitCodeMsg(var s, Msg: string): DWORD;
var
   z: string;
begin
   GetWrd(s, z, ' ');
   if z = '' then begin
      Result := 1;
      Exit;
   end;
   VlMsg(z, Result, Msg);
end;

function PollTimeoutExitCodeValid(var s: string; AHandle: DWORD): Boolean;
var
   Msg: string;
begin
   PollTimeoutExitCodeMsg(s, Msg);
   Result := Msg = '';
   if not Result then DisplayError(Msg, AHandle);
end;

function PollTimeoutExitCode(var s: string): DWORD;
var
   z, Msg: string;
begin
   z := s;
   Result := PollTimeoutExitCodeMsg(z, Msg);
   if Msg <> '' then GlobalFail('PollTimeoutExitCode("%s")', [s]);
end;

function GetPktFileType(const FName: string): TPktFileType;
var
   pktP2K: TType2000HeaderV5;
   pkt0001: TFTS1PktHdr absolute pktP2K;
   pkt0039: TFSC39PktHdr absolute pkt0001;
   pkt0045: TFSC45PktHdr absolute pkt0001;
   h, Actually: DWORD;
begin
   Result := pftUnknown;
   h := _CreateFile(FName, [cRead, cSequentialScan, cShareAllowWrite]);
   if h = INVALID_HANDLE_VALUE then begin
      Result := pftOpenErr;
      Exit;
   end;
   ReadFile(h, pktP2K, SizeOf(pktP2K), Actually, nil);
   ZeroHandle(h);
   if Actually < 60 then begin
      Result := pftReadErr;
      Exit;
   end;
   if Actually = SizeOf(pktP2K) then begin
    // Try to determine P2K
      if (pktP2K.MainHeaderLen = 126) and
         (pktP2K.SubHeaderLen = 43) and
         (pktP2K.PktVersionMajor = 2000) then
      begin
      // This is a P2K packet
         Result := pftP2K;
         Exit;
      end;
   end;

   if pkt0001.rate = 2 then begin
    // This is a FSC-0045 (type 2.2) packet!
      Result := pftFSC45;
      Exit;
   end else begin
      if Swap(pkt0039.CapValid) = pkt0039.CapWord then begin
      // This is a FSC-0039 packet!
         Result := pftFSC39;
         Exit;
      end else begin
      // FTS-0001 or bullshitted packet.
         if (pkt0001.month  < 13) and
            (pkt0001.day    < 32) and
            (pkt0001.hour   < 25) and
            (pkt0001.minute < 61) and
            (pkt0001.second < 61) then
         begin
            Result := pftFTS1;
            Exit;
         end;
      end;
   end;
end;

constructor TCronRecord.Create;
var
   f: file;
   e: TCronStor;
begin
   inherited Create;
   Id := s;
   if s <> '' then begin
      if not ExistFile(EventsFName) then exit;
      try
         AssignFile(f, EventsFName);
         Reset(f, 1);
         while not eof(f) do begin
            blockread(f, e, SizeOf(e));
            if e.Id = s then begin
               fMatch := e.Tm;
               exit;
            end;
         end;
      finally
         CloseFile(f);
      end;
   end;
end;

function CalcTime(const T: TSystemTime): DWORD;
begin
   Result := T.wMinute + T.wHour * 60 + T.wDay * 60 * 24 + T.wMonth * 60 * 24 * 31 + (T.wYear - 2005) * 60 * 24 * 31 * 365;
end;

procedure TCronRecord.SetMatch;
var
   e: TCronStor;
   s: TDosStream;
begin
   if Calctime(t) <> CalcTime(fMatch) then begin
      fMatch := t;
      if Id = '' then exit;
      Cfg.Enter;
      try
         if ExistFile(EventsFName) then s := CreateDosStream(EventsFName, [cRead, cWrite, cShare])
                                   else s := CreateDosStream(EventsFName, [cRead, cWrite, cEnsureNew]);
         if s = nil then exit;
         while s.Position < s.Size do begin
            s.Read(e, SizeOf(e));
            if e.Id = Id then begin
               s.Seek(-SizeOf(e), soFromCurrent);
               break;
            end;
         end;
         e.Id := Id;
         e.Tm := t;
         s.Write(e, SizeOf(e));
         s.Free;
      finally
         Cfg.Leave;
      end;
   end;
end;

destructor TCronRecord.Destroy;
var
   t: TSystemTime;
begin
   t := fMatch;
   FillChar(fMatch, SizeOf(fMatch), 0);
   Match := t;
   if p <> nil then ReallocMem(p, 0);
   inherited Destroy;
end;

function ValidPhnPrefix(const s: string): Boolean;
var
   i: Integer;
begin
   Result := (s = '') or (s = '-');
   if Result then Exit;
   Result := True;
   for i := 1 to Length(s) do
   case s[i] of
   '0'..'9': ;
   else begin Result := False; Break end;
   end;
   if Result then Exit;
   Result := IdentOvrItem(s, False, False) = oiPhoneNum;
end;

procedure TFidoNLColl.Add(const A: TFidoAddress; const n: string);
begin
   Ins(A, n);
end;

procedure TFidoNLColl.Ins(const A: TFidoAddress; const n: string);
var
   i: integer;
   t: TFidoAddress;
begin
   i := IndexOf(@a);
   if i > -1 then begin
      t := Addresses[i];
      AtDelete(i);
      t.ofs := a.ofs;
   end else begin
      t := a;
   end;
   t.fil := Nodelist.IndexOf(n);
   if t.fil = word(-1) then begin
      t.fil := Nodelist.Add(n);
   end;
   inherited Ins(t);
end;

function TFidoNLColl.Compare(Key1, Key2: Pointer): Integer;
begin
   Result := CompareAddrs(PFidoAddress(Key1)^, PFidoAddress(Key2)^, True);
end;

constructor TFidoNLColl.Create;
begin
   inherited;
   Nodelist := TStringList.Create;
end;

destructor TFidoNLColl.Destroy;
begin
   Nodelist.Free;
   inherited;
end;

procedure TFidoNLColl.SaveToFile(const n: string);
var
   i: integer;
   f: TDOSStream;
   a: TFidoAddress;
   b: byte;
   w: word;
   d: dword;
   s: string;
begin
   if Count = 0 then exit;
   f := CreateDOSStream(n, [cWrite]);
   f.Seek(0, FILE_END);
   w := Nodelist.Count;
   f.Write(w, 2);
   for i := 0 to w - 1 do begin
      s := Nodelist[i];
      b := Length(s);
      f.Write(b, 1);
      f.Write(s[1], b);
   end;
   b := Length(Domain);
   f.Write(b, 1);
   f.Write(Domain[1], b);
   d := Count;
   f.Write(d, 4);
   try
      for i := 0 to Count - 1 do begin
         a := PFidoAddress(Items[i])^;
         f.Write(a, 18);
      end;
   finally
      f.Free;
   end;
end;

function TFidoNLColl.SearchNode(const Addr: TFidoAddress): TFidoNode;
var
   a: TFidoAddress;
   s: TTextReader;
   n: string;
   i: integer;
   j: integer;
begin
   Result := nil;
   i := IndexOf(@Addr);
   if i = -1 then exit;
   a := Addresses[i];
   s := CreateTextReader(Nodelist[a.Fil]);
   if s <> nil then begin
      try
         s.Position := a.Ofs;
         n := s.GetStr;
         Result := TFidoNode.Create;
         Result.Addr := a;
         Result.Addr.Domain := Domain;
         Result.Region := a.reg;
         Result.Hub := a.hub;
         Result.Speed := StrToIntDef(wordn(n, ',', 7, True), 0);
         Result.Station := StringReplace(wordn(n, ',', 3, True), '_', ' ', [rfReplaceAll]);
         Result.Sysop := StringReplace(wordn(n, ',', 5, True), '_', ' ', [rfReplaceAll]);
         Result.Phone := wordn(n, ',', 6, True);
         Result.Location := wordn(n, ',', 4, True);
         Result.HasPoints := (i < Count - 1) and (Addresses[i + 1].Node = a.Node);
         j := 0;
         for i := 1 to Length(n) do begin
            if n[i] = ',' then inc(j);
            if j = 7 then break;
         end;
         Result.Flags := system.copy(n, i + 1, Length(n) - i);
         n := wordn(n, ',', 1, True);
         if n = 'Zone' then Result.PrefixFlag := nfZone else
         if n = 'Region' then Result.PrefixFlag := nfRegion else
         if n = 'Host' then Result.PrefixFlag := nfNet else
         if n = 'Hub' then Result.PrefixFlag := nfHub else
         if n = '' then Result.PrefixFlag := nfNormal else
         if n = 'Point' then Result.PrefixFlag := nfPoint else
         if n = 'Pvt' then Result.PrefixFlag := nfPvt else
         if n = 'Hold' then Result.PrefixFlag := nfHold else
         if n = 'Down' then Result.PrefixFlag := nfDown else
         Result.PrefixFlag := nfUnrec;
      finally
         s.Free;
      end;
   end else begin
     PostMsg(WM_COMPILENL);
   end;
end;

function TFidoNLColl.GetNextNode(var Addr: TFidoAddress): boolean;
var
   a: TFidoAddress;
   i: integer;
begin
   Result := False;
   if Addr.domain <> Domain then begin
      Addr := GetFirstNode;
      Addr.Domain := Domain;
      Result := True;
      exit;
   end;
   i := IndexOf(@Addr);
   if i > -1 then begin
      inc(i);
      if i < Count then begin
         a := Addresses[i];
         Addr.Domain := Domain;
         Addr.Zone := a.Zone;
         Addr.Net := a.Net;
         Addr.Node := a.Node;
         Addr.Point := a.Point;
         Addr.Region := a.reg;
         Addr.Hubb := a.hub;
         Result := True;
      end;
   end;
end;

function TFidoNLColl.GetFirstNode: TFidoAddress;
begin
   Result.Domain := '';
   Result.Zone := 0;
   Result.Net := 0;
   Result.Node := 0;
   Result.Point := 0;
   if Count > 0 then begin
      Result.Domain := Domain;
      Result.Zone := Addresses[0].Zone;
      Result.Net := Addresses[0].Net;
      Result.Node := Addresses[0].Node;
      Result.Point := Addresses[0].Point;
      Result.Region := Addresses[0].reg;
      Result.Hubb := Addresses[0].hub;
   end;
end;

const Flags = ',ICM,INA,IP,TCP,IBN,BND,BINKP,IFC,ITN,IVM,IFT,ITX,IMI,IEM,ISE,IUC,GUUCP,DOM,DO4,DO3,DO2,DO1,DO0';

function DUFlags(const s: string): string;
var t,
    f: string;
begin
   t := s;
   Result := '';
   while t <> '' do begin
      GetWrd(t, f, ',');
      if pos(',' + ExtractWord(1, f, [':']), Flags) = 0 then begin
         Result := Result + ',' + f;
      end;
   end;
   Delete(Result, 1, 1);
end;

function IPFlags(const s: string): string;
var t,
    f: string;
begin
   t := s;
   Result := '';
   while t <> '' do begin
      GetWrd(t, f, ',');
      if pos(',' + ExtractWord(1, f, [':']), Flags) > 0 then begin
         Result := Result + ',' + f;
      end;
   end;
   Delete(Result, 1, 1);
end;

initialization

finalization

end.


