unit xBase;

{$I DEFINE.INC}

interface

uses
{$IFDEF FullDebugMode}
  FastMM4,
{$ENDIF}
  Controls,
  Windows,
  SysUtils,
  StdCtrls,
  Classes,
  Graphics,
  ComCtrls,
  Messages,
  Extctrls,
  Menus;

var
  nnName: string;
  CProductDate: string;
  CProductVersion: string;
  CProductVersionForAbout: string;
  CProductNameVer: string;
  ProductDateLen: integer;
  ProductDate: string;
  ProductNameVerLen: integer;
  ProductNameVer: string;
  ProductVersionLen: integer;
  ProductVersion: string;

  APIMessage: DWORD;
  APIHandle: THandle;
  GlobalBlock: pointer;

  Term: boolean;
  StartTime: DWORD;
  ExitNow: Boolean;

type
  TProtCore = (ptUndefined, ptDialup, ptifcico, ptTelnet, ptBinkP, ptFTP,
    ptHTTP, ptSMTP, ptPOP3, ptGATE, ptNNTP);
  TSessionCore = (scUndefined, scFTS1, scEmsiWz, scBinkP, scFTP, scHTTP, scSMTP,
    scPOP3, scGATE, scNNTP);

  TLangName = (lnEnglish, lnRussian);

const
  ClearRegexprCache = true;

  CProductPlatform = 'Win32';
  CProductVersionA = '5.101';
  CProductMinorVersion = 101;
  CProductMajorVersion = 005;
  CProductName = 'Taurus';
  //  CProductName     = 'Aries';
  CReleaseSpec: string = 'Winter';

  //  CProductNameFull = 'Aries by Bob Bakh (based on Taurus (based on Radius (based on Argus)))';
  CProductNameFull = 'Taurus (based on Radius (based on Argus))';

  bdK32 = $8000;

  MaxComPorts = 32;

  INVALID_VALUE = INVALID_HANDLE_VALUE;
  INVALID_FILE_ATTRIBUTES = INVALID_FILE_SIZE;

  LangNames: array[TLangName] of ShortString = ('en', 'ru');

  M_NUL = 0;
  M_ADR = 1;
  M_PWD = 2;
  M_FILE = 3;
  M_OK = 4;
  M_EOB = 5;
  M_GOT = 6;
  M_ERR = 7;
  M_BSY = 8;
  M_GET = 9;
  M_SKIP = 10;

  IDH_GUIGRID = 1380;
  IDH_IMPORTPWD = 2140;
  IDH_IMPORTNODES = 2210;
  IDH_BINKPENC = 2040;
  IDH_MASTPWD = 2050;
  IDH_SMARTMENU = 2070;

  IDH_INTRODAEMON = 1820;
  IDH_POLLMGRDESCR = 1690;
  IDH_OUTBOUND = 1160;
  IDH_SYSTEM = 1260;
  IDH_MLRD = 1500;

  EMSI_INQ = '**EMSI_INQC816';
  EMSI_REQ = '**EMSI_REQA77E';
  EMSI_ACK = '**EMSI_ACKA490';
  EMSI_NAK = '**EMSI_NAKEEC3';
  EMSI_TCH = '**EMSI_TCH3C60';
  EMSI_CHT = '**EMSI_CHTF5D4';
  EMSI_ISI = '**EMSI_ISI2E00';
  EMSI_ICI = '**EMSI_ICI2D73';
  EMSI_IIR = '**EMSI_IIR61E2';
  EMSI_IRQ = '**EMSI_IRQ8E08';

  EMSI_TZP = '-TZP16B2-';
  EMSI_PZT = '-PZT8AF6-';

  TCPIP_GrDataSz = 2000;
  TCPIP_Round = 8;

  cBadPwd = 'BAD_PASSWORD';
  cNoPwd = 'NO_PASSWORD';

  rrLoHexChar: array[0..$F] of char = '0123456789abcdef';
  rrHiHexChar: array[0..$F] of char = '0123456789ABCDEF';
  rrHi32Char: array[0..$1F] of char = '0123456789ABCDEFGHIJKLMNOPQRSTUV';

  { CRC-16 CCITT proper }
  CRC16PROP_POLY = $8408; // Generator polynomial number
  CRC16PROP_INIT = $FFFF; // Initial CRC value for calculation
  CRC16PROP_TEST = $F0B8; // Result to test for at receiver

  { CRC-16 CCITT upside-down }
  CRC16USD_POLY = $1021; // Generator polynomial number
  CRC16USD_INIT = $0; // Initial CRC value for calculation
  CRC16USD_TEST = $0; // Result to test for at receiver

  { CRC-32 CCITT }
  CRC32_POLY = $EDB88320; // Generator polynomial number
  CRC32_INIT = $FFFFFFFF; // Initial CRC value for calculation
  CRC32_TEST = $DEBB20E3; // Result to test for at receiver

  UnixDaysBase = 719163; {Days between 1/1/1 and 1/1/1970}
  DelphiDayBase = 693594; {Days between 1/1/1 and 12/31/1899}
  {Days between 1/1/1 and 12/30/1899}

{ Maximum TColl size }

  MaxCollSize = (MaxInt div 2) div SizeOf(Pointer);

  TextReaderBufSize = $2000;

  { TColl error codes }

  coIndexError = -1; { Index out of range }
  coOverflow = -2; { Overflow }
  coMissing = -3;
  coMissingStr = -4;

  WM__ARGUSBASE = WM_USER + 8;
  WM__NUMRESOLVE = 32;

  WM_RESOLVE = WM__ARGUSBASE + $1000;
  WM__ARGUS = WM_RESOLVE + WM__NUMRESOLVE;
  WM_REFILLOUT = WM__ARGUS + 0;
  WM_SAYRESCAN = WM__ARGUS + 1;
  WM_UPDATETABS = WM__ARGUS + 2;
  WM_CHANGETV = WM__ARGUS + 3;
  WM_UPDATEVIEW = WM__ARGUS + 4;
  WM_UPDATELAMPS = WM__ARGUS + 6;
  WM_UPDATETERM = WM__ARGUS + 7;
  WM_ADDPOLLSLOG = WM__ARGUS + 8;
  WM_CLEARTERMS = WM__ARGUS + 9;
  WM_TABCHANGE = WM__ARGUS + 10;
  WM_CLOSELINE = WM__ARGUS + 11;
  WM_UPDATEMENUS = WM__ARGUS + 12;
  WM_COMPILENL = WM__ARGUS + 14;
  WM_UPDOUTMGR = WM__ARGUS + 15;
  WM_TrayCallBack_Message = WM__ARGUS + 17;
  WM_SETOK = WM__ARGUS + 18;
  WM_TRAYRC = WM__ARGUS + 19;
  WM_APPMINIMIZE = WM__ARGUS + 20;
  WM_IMPORTPWDL = WM__ARGUS + 21;
  WM_RESTORE_EVT = WM__ARGUS + 22;
  WM_STARTMDMCMD = WM__ARGUS + 23;
  WM_IMPORTDUPOVRL = WM__ARGUS + 24;
  WM_IMPORTIPOVRL = WM__ARGUS + 25;
  WM_SETUPOK = WM__ARGUS + 26;

  WM_RESCANOUTBOUND = WM__ARGUS + 30; // visual
  WM_CHECKFILEFLAGS = WM__ARGUS + 31; // visual
  WM_GETWINDLGT = WM__ARGUS + 32;
  //  WM_SETTRAYICONPARAMS =  WM__ARGUS + 33; // visual
  WM_SWITCHDAEMON = WM__ARGUS + 34; // visual

  WM_SETCOLORS = WM__ARGUS + 40;
  WM_SETLANG = WM__ARGUS + 41;
  WM_CFGREREAD = WM__ARGUS + 42;
  WM_UPDBWZ = WM__ARGUS + 43;
  WM_USESPACE = WM__ARGUS + 44;
  WM_EXTREBUILD = WM__ARGUS + 45;
  WM_STARTTERM = WM__ARGUS + 46;
  WM_REREADOUTB = WM_RESCANOUTBOUND;
  WM_SETRASDIALSTATE = WM__ARGUS + 47;
  WM_RASLOADENTRYLIST = WM__ARGUS + 48;
  //  WM_STARTCHAT     = WM__ARGUS + 49; //FREE!
  WM_CLOSECHAT = WM__ARGUS + 50;
  WM_RASEVENT = WM__ARGUS + 51;
  WM_LINEDESTROYED = WM__ARGUS + 52;
  WM_OUTBOUNDALERT = WM__ARGUS + 53;
  WM_SCANOUTBOUND = WM__ARGUS + 54;
  WM_SETSTATUS = WM__ARGUS + 55;
  WM_GRIDUPD = WM__ARGUS + 56;
  WM_TRAYICON = WM__ARGUS + 57;
  WM_OPENREMOTE = WM__ARGUS + 58;
  WM_CLICKMENU = WM__ARGUS + 59;
  WM_RASDISCONNECT = WM__ARGUS + 60;
  WM_CONNECT = WM__ARGUS + 61;
  WM_LASTIN = WM__ARGUS + 62;
  WM_LASTOUT = WM__ARGUS + 63;
  WM_CHECKNETMAIL = WM__ARGUS + 64;
  WM_ROUTEEXPORT = WM__ARGUS + 65;
  WM_OUTEXPORT = WM__ARGUS + 66;

  WM_NEWSOCKPORT = WM__ARGUS + 100;
  WM_ADDDAEMONLOG = WM__ARGUS + 101;
  WM_CONNECTRES = WM__ARGUS + 102;

type
  TObjProc = procedure of object;
  TForEachProc = procedure(P: Pointer) of object;

  PFileInfo = ^TFileInfo;
  TFileInfo = record
    Attr,
      Time: DWORD;
    Size: Int64;
  end;

  TuFindData = record
    Handle: DWORD;
    Info: TFileInfo;
    FName: string;
  end;

  TSetOperation = (soUnknown, soSet, soUnion, soDiff, soIntersect);

  PScrollRec = ^TScrollRec;
  TScrollRec = record
    rMin, rMax, rPage, rPos,
      lMin, lMax, lPage, lPos: Integer;
  end;

  TScrollData = record
    h, v: TScrollRec;
  end;

  TTextReaderBuf = array[0..TextReaderBufSize - 1] of Char;

  TCreateFileMode = (

    cRead, // Specifies read access to the file
    cWrite, // Specifies write access to the file

    cFlag,

    cEnsureNew, // Creates a NEW file. The function fails
    // if the specified file already exists.

    cTruncate, // Once opened, the file is truncated so that
    // its size is zero bytes.

    cExisting, //  For communications resources, console diveces

    cShareAllowWrite,
    cShareDenyRead,
    cShare,

    cOverlapped, // This flag enables more than one operation to be
    // performed simultaneously with the handle
    // (e.g. a simultaneous read and write operation).

    cRandomAccess, // Indicates that the file is accessed randomly.
    // Windows uses this flag to optimize file caching.

    cSequentialScan, // Indicates that the file is to be accessed
    // sequentially from beginning to end.

    cDeleteOnClose, // Indicates that the operating system is to delete
    // the file immediately after all of its handles
    // have been closed.

    cWriteThrough, // Instructs the operating system to write through
    // any intermediate cache and go directly to the
    // file. The operating system can still cache
    // write operations, but cannot lazily flush them.

    cCanPending // Indiacate than the file can be used later.

    );

  TCreateFileModeSet = set of TCreateFileMode;

  { Character set type }

  PCharSet = ^TCharSet;
  TCharSet = set of Char;

  { General arrays }

  PCharArray = ^TCharArray;
  TCharArray = array[0..High(Integer) - 1] of Char;

  PxByteArray = ^TxByteArray;
  TxByteArray = array[0..High(Integer) - 1] of Byte;

  PxWordArray = ^TxWordArray;
  TxWordArray = array[0..High(Integer) div 2 - 1] of Word;

  PIntArray = ^TIntArray;
  TIntArray = array[0..(MaxLongInt div 4) - 1] of Integer;

  PDWORDArray = ^TDWORDArray;
  TDWORDArray = array[0..(MaxLongInt div 4) - 1] of DWORD;

  PvIntArr = ^TvIntArr;
  TvIntArr = record
    Arr: PIntArray;
    Cnt: Integer;
  end;

  PBoolean = ^Boolean;

  { TColl types }

  PItemList = ^TItemList;
  TItemList = array[0..MaxCollSize - 1] of Pointer;

  TCollError = class(Exception)
    constructor Create(ACode, ACnt, AInfo: Integer; const AClassName: string);
  end;

  TAdvObject = class;

  TxStream = class
  private
    function GetPosition: DWORD;
    procedure SetPosition(Pos: DWORD);
    function GetSize: DWORD;
  public
    GotStarter, GotTerminator, FreeLastLoaded: Boolean;
    Tag: integer;
    function Read(var Buffer; Count: DWORD): DWORD; virtual; abstract;
    function Write(const Buffer; Count: DWORD): DWORD; virtual; abstract;
    function Seek(Offset: Integer; Origin: Word): DWORD; virtual; abstract;
    function CopyFrom(Source: TxStream; Count: DWORD): DWORD;
    function WriteA(const Buffer; Count, A: DWORD): DWORD;
    function WriteA4(const Buffer; Count: DWORD): DWORD;
    property Position: DWORD read GetPosition write SetPosition;
    property Size: DWORD read GetSize;
    function ReadStr: string;
    procedure WriteStr(const S: string);
    function WriteLn(S: string): Boolean;
    procedure WriteDWORD(I: DWORD);
    function ReadDWORD: DWORD;
    procedure WriteInteger(I: Integer);
    function ReadInteger: Integer;
    procedure WriteBool(B: Boolean);
    function ReadBool: Boolean;
    procedure WriteByte(B: Byte);
    function ReadByte: Byte;
    procedure Put(AObject: TAdvObject);
    function Get: Pointer;
  end;

  TxCustomMemoryStream = class(TxStream)
  private
    FMemory: Pointer;
    FSize, FPosition: DWORD;
  protected
    procedure SetPointer(Ptr: Pointer; Size: Integer);
    function GetMemory: Pointer;
  public
    function Read(var Buffer; Count: DWORD): DWORD; override;
    function Seek(Offset: Integer; Origin: Word): DWORD; override;
    function SaveToStream(Stream: TxStream): Boolean;
    function SaveToFile(const FileName: string): Boolean; virtual;
    property Memory: Pointer read GetMemory;
  end;

  { TxMemoryStream }

  TxMemoryStream = class(TxCustomMemoryStream)
  private
    FCapacity: DWORD;
    procedure SetCapacity(NewCapacity: DWORD);
  protected
    function Realloc(var NewCapacity: DWORD): Pointer; virtual;
  public
    destructor Destroy; override;
    procedure Clear;
    procedure LoadFromStream(Stream: TxStream);
    procedure LoadFromFile(const FileName: string); virtual;
    procedure SetSize(NewSize: DWORD);
    function Write(const Buffer; Count: DWORD): DWORD; override;
    property Capacity: DWORD read FCapacity write SetCapacity;
  end;

  TxMemoryStreamEx = class(TxMemoryStream)
    Addition: TxMemoryStream;
    oVersion: byte;
    nVersion: byte;
  public
    constructor Create;
    destructor Destroy; override;
    procedure LoadFromFile(const FileName: string); override;
    function SaveToFile(const FileName: string): boolean; override;
  end;

  TDosStream = class(TxStream)
  public
    OwnHandle: Boolean;
    Handle: DWORD;
    fMode: TCreateFileModeSet;

    constructor Create(AHandle: DWORD);

    destructor Destroy; override;
    function Truncate: Boolean;

    function Seek(Offset: Integer; Origin: Word): DWORD; override;

    { overrides }
    function Read(var Buffer; Count: DWORD): DWORD; override;
    function Write(const Buffer; Count: DWORD): DWORD; override;

  end;

  PAdvObject = ^TAdvObject;
  TAdvObject = class
    constructor Load(Stream: TxStream); virtual; abstract;
    procedure Store(Stream: TxStream); virtual; abstract;
  end;

  TAdvCpObject = class(TAdvObject)
    function Copy: Pointer; virtual; abstract;
  end;

  TAdvCpOnlyObject = class(TAdvCpObject)
    constructor Load(Stream: TxStream); override;
    procedure Store(Stream: TxStream); override;
  end;

  TThreadTimes = record
    CreationTime,
      ExitTime,
      KernelTime,
      UserTime: TFileTime;
  end;

  TThreadNfo = class(TAdvCpOnlyObject)
    Name: string;
    Invoked,
      KernelTime,
      UserTime: TFileTime;
    function Copy: Pointer; override;
  end;

  T_Thread = class
  protected
    FCSRecursion: Integer;
    FThreadInvoked: TFileTime;
    FPThreadNfo: TThreadNfo;
    FThreadHandle: THandle;
    FThreadErrMsg: string;
    FThreadErrNum: longint;
    FThreadID: THandle;
    FSuspended: Boolean;
    FFinished: Boolean;
    FThreadReturnValue: Integer;
    //    FreeOnTerminate: Boolean;
    class function ThreadName: string; virtual; abstract;
    procedure FExecute;
    procedure RegisterSelf;
    procedure __AddTimes;
    procedure GetTimesEx(var T: TThreadTimes);
    procedure __FExecute;
    procedure InvokeDone; virtual;
    procedure InvokeExec; virtual; abstract;
    function GetThrErrorMsg: string; virtual;
    procedure SetPriority(Value: TThreadPriority);
    procedure SetSuspended(Value: Boolean);
  public
    Terminated: Boolean;
    procedure Resume;
    procedure Suspend;
    function WaitFor(const TimeOut: DWORD = INFINITE): DWORD;
    function WaitEvtAEx(nCount: Integer; lpHandles: PWOHandleArray; Timeout:
      DWORD; AWaitAll: Boolean; eName: string = ''): DWORD;
    function WaitEvtA(nCount: Integer; lpHandles: PWOHandleArray; Timeout:
      DWORD; eName: string = ''): DWORD;
    function WaitEvts(const id: array of THandle; Timeout: DWORD; eName: string =
      ''): DWORD;
    function WaitEvt(H: THandle; Timeout: DWORD; eName: string = ''): DWORD;
    function WaitEvtInfinite(H: THandle; eName: string = ''): DWORD;
    constructor Create;
    destructor Destroy; override;
    property Priority: TThreadPriority write SetPriority;
    property Suspended: Boolean read FSuspended write SetSuspended;
    property ThreadID: THandle read FThreadID;
  end;

  TAdvClass = class of TAdvObject;

  TioRec = class
    Typ: TAdvClass;
    Id: Integer;
  end;

  TCollClass = class of TColl;
  TStringColl = class;

{$IFDEF FullDebugMode}
  TEnterList = class(TStringList)
  private
    CS: TRTLCriticalSection;
  public
    constructor Create;
    destructor Destroy; override;
    procedure SaveToFile(const N: string); reintroduce;
    procedure Enter;
    procedure Leave;
  end;
{$ENDIF}

  TColl = class(TAdvCpObject)
  protected
    CS: TRTLCriticalSection;
    FCount: Integer;
    FCapacity: DWORD;
    FDelta: DWORD;
    Shared: Integer;
    FName: string;
{$IFDEF FullDebugMode}
    Debug: TEnterList;
{$ENDIF}
  public
    FList: PItemList;
    function Name: string;
    procedure CopyItemsTo(Coll: TColl);
    function Copy: Pointer; override;
    function CopyItem(AItem: Pointer): Pointer; virtual;
    procedure DoInit(ALimit, ADelta: Integer);
    constructor Create; overload;
    constructor Create(const n: string); overload;
    constructor Load(Stream: TxStream); override;
    procedure Store(Stream: TxStream); override;
    procedure PutItem(Stream: TxStream; Item: Pointer); virtual;
    function GetItem(Stream: TxStream): Pointer; virtual;
    destructor Destroy; override;
    function At(Index: Integer): Pointer;
    procedure AtDelete(Index: Integer);
    procedure AtFree(Index: Integer);
    procedure AtInsert(Index: Integer; Item: Pointer); virtual;
    procedure AtPut(Index: Integer; Item: Pointer);
    procedure Delete(Item: Pointer);
    procedure DeleteAll;
    procedure Error(Code, Cnt, Info: Integer);
    procedure FFree(Item: Pointer);
    procedure FreeAll; virtual;
    procedure FreeItem(Item: Pointer); virtual;
    function IndexOf(Item: Pointer): Integer; virtual;
    procedure Insert(Item: Pointer); virtual;
    procedure Add(Item: Pointer);
    procedure Pack;
    procedure SetCapacity(NewCapacity: DWORD);
    procedure MoveTo(CurIndex, NewIndex: Integer);
    property Items[Idx: Integer]: Pointer read At write AtPut; default;
    property Count: Integer read FCount;
    property First: Pointer index 0 read At write AtPut;
    function Crc32Item(Item: Pointer; Crc32: DWORD): DWORD; virtual;
    function Crc32(Init: DWORD): DWORD; virtual;
    procedure ForEach(Proc: TForEachProc); virtual;
    procedure Sort(Compare: TListSortCompare);
    procedure Concat(AColl: TColl); virtual;
    procedure Enter;
    procedure Leave;
  end;

  TSortedColl = class(TColl)
  public
    Duplicates: Boolean;
    function Compare(Key1, Key2: Pointer): Integer; virtual; abstract;
    function KeyOf(Item: Pointer): Pointer; virtual; abstract;
    function IndexOf(Item: Pointer): Integer; override;
    procedure Insert(Item: Pointer); override;
    function Search(Key: Pointer; var Index: Integer): Boolean; virtual;
  end;

  TioRecColl = class(TSortedColl)
    function KeyOf(Item: Pointer): Pointer; override;
    function Compare(Key1, Key2: Pointer): Integer; override;
  end;

  TTextReader = class;

  { TStringColl object }

  TStringColl = class(TSortedColl)
  protected
    fObjects: TColl;
    procedure AlignObjects;
    procedure SetString(Index: Integer; const Value: string);
    function GetString(Index: Integer): string;
    procedure SetObject(Index: Integer; const Value: pointer);
    function GetObject(Index: Integer): pointer;
  public
    KeepOnLoad, IgnoreCase: Boolean;
    Prev: TStringColl;
    Mark: string;
    constructor Create; overload;
    constructor Create(const n: string); overload;
    destructor Destroy; override;
    procedure PutItem(Stream: TxStream; Item: Pointer); override;
    function GetItem(Stream: TxStream): Pointer; override;
    function KeyOf(Item: Pointer): Pointer; override;
    procedure FreeItem(Item: Pointer); override;
    function Compare(Key1, Key2: Pointer): Integer; override;
    function CopyItem(AItem: Pointer): Pointer; override;
    function LoadFromTextReader(T: TTextReader): Boolean;
    function LoadFromFile(const FName: string): Boolean;
    function LoadFromStream(Stream: TxStream): Boolean;
    function LoadFromString(const s: string): Boolean;
    function Copy: Pointer; override;
    procedure Ins(const S: string);
    procedure InsD(const S: string);
    procedure Ins0(const S: string);
    procedure Add(const S: string);
    procedure AtIns(Index: Integer; const Item: string);
    property Strings[Index: Integer]: string read GetString write SetString;
    default;
    property Objects[Index: Integer]: pointer read GetObject write SetObject;
    function SaveToStream(Stream: TxStream): Boolean;
    function SaveToFile(const FileName: string): Boolean;
    function IdxOf(const Item: string): Integer;
    function IdxOfUC(const Str: string): Integer;
    procedure AppendTo(AColl: TStringColl);
    procedure Concat(AColl: TStringColl); reintroduce;
    procedure Fill(const AStrs: array of string);
    function Crc32Item(Item: Pointer; Crc32: DWORD): DWORD; override;
    function Found(const Str: string): Boolean;
    function Matched(const Str: string): Integer;
    function FoundUC(const Str: string): Boolean;
    procedure FillEnum(Str: string; Delim: TCharSet; Sorted: Boolean);
    function LongString: string;
    function LongStringD(c: char): string;
    function LongStringS(const s: string): string;
  end;

  TDblString = class
    Key, Value: string;
  end;

  TDblStringColl = class(TSortedColl)
    IgnoreCase: Boolean;
    function Compare(Key1, Key2: Pointer): Integer; override;
    function KeyOf(Item: Pointer): Pointer; override;
  end;

  TStationDataColl = class(TStringColl)
    property Station: string index 0 read GetString;
    property Address: string index 1 read GetString;
    property Sysop: string index 2 read GetString;
    property Location: string index 3 read GetString;
    property Phone: string index 4 read GetString;
    property Flags: string index 5 read GetString;
  end;

  TTextReader = class
    Eof: Boolean;
    OwesStream: Boolean;
    function GetStr: string;
    destructor Destroy; override;
  private
    FileSz: DWORD;
    FilePos: DWORD;
    Stream: TxStream;
    BufSz: DWORD;
    BufPos: DWORD;
    Buf: TTextReaderBuf;
    Skip1: Boolean;
    SavPos: DWORD;
  protected
    function GetPosition: int64;
    procedure SetPosition(ofs: int64);
  public
    property Position: int64 read GetPosition write SetPosition;
  end;

  { Standard event timer record structure used by all timing routines }
  EventTimer = record
    StartTicks: DWORD; { Tick count when timer was initialized }
    ExpireTicks: DWORD; { Tick count when timer will expire }
  end;

  PEventTimer = ^EventTimer;

  TDiskSpaceInfo = packed record
    SPC, // sectors per cluster
      BPS, // bytes per sector
      NFC, // number of free clusters
      TNC: DWORD; // total number of clusters
  end;

  TExecShowMode = (swHide, swMinimize, swShow);

  TStringHolder = class
    S: string;
  end;

procedure DbgStr(const FormatStr: string; const Args: array of const);
function EscapeChars(const S: string): string;

{ --- DosStream Routines }
function CreateDosStream(const FName: string; Mode: TCreateFileModeSet):
  TDosStream;
function CreateDosStreamDir(const FName: string; Mode: TCreateFileModeSet):
  TDosStream;
function OpenRead(const FName: string): TDosStream;
function OpenWrite(const FName: string): TDosStream;
function SeekEof(Handle: DWORD): DWORD;
function xRandom32: DWORD;
function xRandom(a: DWORD): DWORD;

{ --- Time Routines }

function uCvtGetFileTime(L, H: DWORD): DWORD;
procedure uCvtSetFileTime(T: DWORD; var L, H: DWORD);
procedure uNix2WinTime(I: DWORD; var T: TSystemTime);
function uWin2NixTime(const T: TSystemTime): DWORD;

function uDosDateTimeToFileTime(wFatDate, wFatTime: Word; var uTime: DWORD):
  Boolean;

function uGetLocalTime: DWORD;
function uGetSystemTime: DWORD;
function uSetFileTimeByHandle(Handle: DWORD; uTime: DWORD): Boolean;
function uSetFileTime(const FName: string; uTime: DWORD): Boolean;
function uDelphiTime(uTime: DWORD): TDateTime;
function uFormatDateTime(const Format: string; uTime: DWORD): string;
function uFormat(uTime: DWORD): string;

function uFindFirst(const FName: string; var FindData: TuFindData): Boolean;
function uFindFirstEx(const FName: string; var FindData: TuFindData; fSearchOp:
  TFindexSearchOps): Boolean;
function uFindNext(var FindData: TuFindData): Boolean;
function uFindClose(var FindData: TuFindData): Boolean;

function GetHelpFile(const HomePath: string; const Lng: string): string;

function MultiTimeout(const Timers: array of EventTimer): DWORD;

procedure InitTickTimer;
procedure DeInitTickTimer;
procedure InitEventWaiter;

procedure NewTimer(var ET: EventTimer; Tics: DWORD);
procedure NewTimerSecs(var ET: EventTimer; Secs: DWORD);
function GetHalfAvg(a: DWORD): DWORD;
procedure NewTimerAvg(var ET: EventTimer; Secs: DWORD);
procedure NewTimerMSecs(var ET: EventTimer; MSecs: DWORD);
procedure ClearTimer(var ET: EventTimer);
function TimerInstalled(const ET: EventTimer): Boolean;
function TimerExpired(const ET: EventTimer): Boolean;
function ElapsedTime(const ET: EventTimer): DWORD;
function RemainingTimeMsecs(const ET: EventTimer): DWORD;
function RemainingTimeSecs(const ET: EventTimer): DWORD;

{ --- string Routines }
function StrBegsU(const Substr, S: string): Boolean;
function StrBegsF(const Substr: string; SubstrLen: Integer; const S: string;
  SLen: Integer): Boolean;
function PackRFC1945(const s: string; Chars: TCharSet): string;
function UnpackRFC1945(var s: string): Boolean;
function StrQuote(const s: string): string;
function StrDeQuote(var s: string): Boolean;
function DivideDash(const S: string): string;
function _MatchMask(const AName: string; const AMask: string; SupportPercent:
  Boolean): Boolean;
function MatchMask(const AName, AMask: string): Boolean;
function IsWild(const S: string): Boolean;
function TrimZeros(const S: string): string;
function OctalStr2Long(S: string): Integer;
function OctalStr(L: Integer): string;
function BothKVC(const S: string): Boolean;

function AddLeftSpaces(const S: string; NumSpaces: Integer): string;
function AddRightSpaces(const S: string; NumSpaces: Integer): string;
function Hex2(a: Byte): string;
function Hex3(a: Word): string;
function Hex4(a: Word): string;
function Hex8(a: Integer): string;
function H32_2(a: Word): string;
function H32_3(a: Word): string;
function Int2Hex(a: Integer): string;
function MakeNormName(const Path, Name: string): string;
function ExtractDir(const S: string): string;
function MakeFullDir(const D, S: string): string;
procedure AddStr(var S: string; C: char);
procedure FSplit(const FName: string; var Path, Name, Ext: string);
function Replace(const Pattern, ReplaceString: string; var S: string): Boolean;
function ReplaceCI(const Pattern, ReplaceString: string; var S: string):
  Boolean;
function DelLeft(const S: string): string;
function DelRight(const S: string): string;
function CopyLeft(const S: string; I: Integer): string;
function _DelSpaces(const s: string): string;
function StrRight(const S: string; Num: Integer): string;
function StrEnds(const Substr, S: string): Boolean;
procedure GetWrd(var s, w: string; c: char);
procedure DelFC(var s: string);
procedure DelLC(var s: string);
function Int2Str(L: Integer): string;
function Int2StrK(L: Integer): string;
function WipeChars(const AStr, AWipeChars: string): string;
procedure FillCharSet(const AStr: string; var CharSet: TCharSet);
function DigitsOnly(const AStr: string): Boolean;

{ --- Basic Routines }

function MaxI(A, B: Integer): Integer;
function MinI(A, B: Integer): Integer;
function MaxD(A, B: DWORD): DWORD;
function MinD(A, B: DWORD): DWORD;
procedure XChg(var Critical, Normal);
procedure AddLong(var A: TFileTime; const B: TFileTime);
procedure IncLong(var A: TFileTime);
procedure SubLong(var A: TFileTime; const B: TFileTime);
function NulSearch(const Buffer): Integer;
function ShortBuf2Str(const Buffer; AMaxLen: Integer): string;
function ShortBuf2StrEx(const Buffer; AMaxLen: Integer; AC: Char): string;
procedure LowerPrec(var A, B: Integer; Bits: Byte);
procedure Clear(var Buf; Count: Integer);
function MemEqu(const A, B; Sz: Integer): Boolean;

{ --- CRC Routines }

function UpdateCrc32(CurByte: Byte; CurCrc: DWORD): DWORD;
function UpdateCrc16Usd(CurByte: Byte; CurCrc: Word): Word;
function UpdateCrc16Prop(CurByte: Byte; CurCrc: Word): Word;
function Crc16Post(Crc: word): word;
function Crc32Post(Crc: DWORD): DWORD;
function Crc16UsdBlock(const Buf; Len: DWORD): word;
function Crc16PropBlock(const Buf; Len: DWORD): word;
function Crc32Block(const Buf; Len: Integer; Crc32: DWORD): DWORD;
function Crc32Str(const S: string; Crc32: DWORD): DWORD;
function Crc32Int(I: DWORD; Crc32: DWORD): DWORD;

{ --- Win32 Events Extentions }

function CreateEvt(Initial: Boolean): THandle;
function CreateEvtA: THandle;
function WaitEvtA(nCount: Integer; lpHandles: PWOHandleArray; Timeout: DWORD):
  DWORD;
function WaitEvts(const id: array of THandle; Timeout: DWORD): DWORD;
function WaitEvtsAll(const id: array of THandle; Timeout: DWORD): DWORD;
function WaitEvt(H: THandle; Timeout: DWORD): DWORD;
function WaitEvtInfinite(H: THandle): DWORD;

function UpdateDetailsBox(AB: TListView; AC: TColl): Boolean;

{ --- Win32 API Hooks }

function GetEnvVariable(const Name: string): string;
function GetFileNfo(const FName: string; var Info: TFileInfo; NeedAttr:
  Boolean): Boolean;
function GetFileNfoByHandle(Handle: DWORD; var Info: TFileInfo): Boolean;
function ZeroHandle(var Handle: THandle): Boolean;
procedure _PostMessage(a: DWORD; b, c, d: Integer);
procedure PostMsgP(Msg: Integer; LParam: Pointer);
procedure PostMsg(Msg: Integer);
procedure SendMsg(Msg: Integer);

function _CreateFileSecurity(const FName: string; Mode: TCreateFileModeSet;
  lpSecurityAttributes: PSecurityAttributes): DWORD;
function _CreateFile(const FName: string; Mode: TCreateFileModeSet): DWORD;
function _CreateFileDir(const FName: string; Mode: TCreateFileModeSet): DWORD;
function _GetFileSize(const FName: string): DWORD;

function CreateTextReaderByStream(Stream: TxStream): TTextReader;
function CreateTextReader(const FName: string): TTextReader;

function GetAPIDroppedFiles(H: THandle): TStringColl;
function WindowsDirectory: string;

function ExecProcess(const Args: string; var PI: TProcessInformation; Env, Dir:
  Pointer; InheritHandles: Boolean; CreationFlags: DWORD; ShowMode:
  TExecShowMode): Boolean;
function DoCreateProcess(const s: string; var PI: TProcessInformation; ShowMode:
  TExecShowMode): Boolean;

{ --- Rectangle Routines }

function _InflateRect(const R: TRect; X, Y: Integer): TRect;
function _EmptyRect(const R: TRect): Boolean;
function _OffsetRect(const R: TRect; X, Y: Integer): TRect;

{ --- Dialog Routines }

function WinDlg(const S: string; Flags: DWORD; AHandle: DWORD): DWORD;
procedure WinDlgT(const S: string);
function WinDlgCap(const S: string; Flags: DWORD; AHandle: DWORD; const Caption:
  string): DWORD;
function WinDlgCapHlp(const S: string; Flags: DWORD; AHandle: DWORD; const
  Caption: string; AHelpCtx: DWORD): DWORD;
function YesNoConfirm(const Msg: string; AHandle: DWORD): Boolean;
function YesNoWarning(const Msg: string; AHandle: DWORD): Boolean;
function OkCancelConfirm(const Msg: string; AHandle: DWORD): Boolean;
procedure DisplayError(const Msg: string; AHandle: DWORD);

procedure DisplayInformation(const Msg: string; AHandle: DWORD);
procedure DisplayWarning(const Msg: string; AHandle: DWORD);
procedure DisplayCustomInfo(const Msg: string; AHandle: DWORD);

function CreateDirInheritance(S: string): Boolean;
function DeleteEmptyDirInheritance(S: string; const StopOn: string): Integer;
function DirExists(S: string): Integer;

procedure FreeObject(var O);
procedure xBaseInit;
procedure xBaseDone;

procedure RegisterIoRec(Typ: TAdvClass; Id: Integer);
function GlobalFail(const AMessage: string; const AParams: array of const):
  Integer;

function FormatErrorMsg(const FName: string; e: Integer): string;
procedure SetErrorMsg(const FName: string);
function GetErrorMsg: string;
function GetErrorNum: longint;
procedure ClearErrorMsg;

procedure FreeVIntArr(var A: TvIntArr);
procedure AddVIntArr(var A: TvIntArr; i: Integer);

function ControlString(C: TControl): string;

procedure CollDeleteAll(C: TColl);
function CollMax(C: TColl): Integer;
function CollCount(C: TColl): Integer;

function CreateTCollEL(const n: string): TColl;
procedure MoveColl(Src, Dst: TColl; Idx: Integer);
function CreateTempFile(const APath, APfx: string; var FName: string): Integer;
function TempFileName(const APath, APfx: string): string;
function SysErrorMsg(ErrorCode: Integer): string;
procedure SetHotKey;
procedure FreeHotKey;
function StripTmp(const n: string): string;
{$IFDEF FullDebugMode}
function DebugInfo(const i: integer): string;
{$ENDIF}

const
  HelpLanguageRussian = LANG_RUSSIAN;
  HelpLanguageEnglish = LANG_ENGLISH or (SUBLANG_ENGLISH_UK shl 10);
  HelpLanguageGerman = LANG_GERMAN or (SUBLANG_GERMAN_AUSTRIAN shl 10);
  HelpLanguageSpanish = LANG_SPANISH or (SUBLANG_SPANISH shl 10);
  HelpLanguageDutch = LANG_DUTCH or (SUBLANG_DUTCH_BELGIAN shl 10);
  HelpLanguageDanish = LANG_DANISH;

  stoRunIpDaemon = $01;
  stoFastLog = $02;
  stoSkipLogWZ = $04;

  ProductNameLen = Length(CProductName);
  ProductName: string[ProductNameLen] = CProductName;
  ProductNameFullLen = Length(CProductNameFull);
  ProductNameFull: string[ProductNameFullLen] = CProductNameFull;
  ProductPlatformLen = Length(CProductPlatform);
  ProductPlatform: string[ProductPlatformLen] = CProductPlatform;

var
  DaemonStarted: Boolean;
  OnlineStarted: boolean;
  StartupOptions: Byte;
  hMutex: DWORD;
  oRecalcEvents: DWORD;
  RecalcEvents,
    ApplicationDowned,
    ApplicationDone,
    IsService,
    EnglishHelp, RussianHelp, DutchHelp, GermanHelp, DanishHelp, SpanishHelp:
  Boolean;
  HelpLanguageId,
    CurrentProcessHandle,
    CurrentThreadHandle,
    CompleteFilterIndex,
    MainWinHandle: DWORD;
  HotKeySet: boolean;
  oShutdown: DWORD;
  TrapLogFName: string;
  EMSILogFName: string;
  WaitLogFName: string;
  EntrLogFName: string;
  VersLogFName: string;
{$IFDEF FullDebugMode}
  EnterList: TEnterList;
{$ENDIF}
  TrapLogCS: TRTLCriticalSection;
  LiveCounter: DWORD;
  WindCounter: DWORD;
  ScanCounter: DWORD;
  ScanActive: boolean;

  //  TimeZoneBias: Integer;

{$DEFINE SOFTTICKER}
{$IFDEF SOFTTICKER}
  TickCounter: DWORD;
{$ELSE}
function TickCounter: DWORD;
{$ENDIF}

const
  // These Windows-defined constants are required for use with TOSVersionInfoEx
  // NT Product types
  VER_NT_WORKSTATION                        = 1;
  VER_NT_DOMAIN_CONTROLLER                  = 2;
  VER_NT_SERVER                             = 3;

type
  TOSVersionInfoEx = packed record
    dwOSVersionInfoSize: DWORD;
    dwMajorVersion: DWORD;
    dwMinorVersion: DWORD;
    dwBuildNumber: DWORD;
    dwPlatformId: DWORD;
    szCSDVersion: array[0..127] of AnsiChar; { Maintenance string for PSS usage }
    wServicePackMajor: WORD;
    wServicePackMinor: WORD;
    wSuiteMask: WORD;
    wProductType: BYTE;
    wReserved: BYTE;
  end;

function GetOSVer: string;
function GetMemoryStream: TxMemoryStreamEx;

function _LogOK(const Name: string; var Handle: DWORD): Boolean;
procedure _LogWriteStr(const AStr: string; var FHandle: DWORD);
{$IFDEF FullDebugMode}
procedure AnyExceptionNotify(ExceptObj: TObject; ExceptAddr: Pointer;
  OSException: Boolean);
{$ENDIF}
procedure ProcessTrap(const CMsg, CThreadName: string);

function NumBits(I: DWORD): DWORD;
function Vl(const s: string): DWORD;
function VlH(const s: string): DWORD;
function Vlx(const s: string): DWORD;
function FormatBinkPMsg(Id: Byte; const Msg: string): string;

var
  Thr_Coll: TColl;
  ioRecColl: TioRecColl;
  FStartMinimized: Boolean;
  TimeZoneBias: Integer;

function GetCompleteFilter: string;
function xIsReg(Ext: string): Boolean;

procedure UpdateThreadsLog;

var
  ThreadsLogFName: string;
  AppThrInvoked: TFileTime;
  TrapCatched: boolean;

procedure SetEvt(oEvt: THandle);
procedure ResetEvt(oEvt: THandle);

function _GetComputerName: string;
procedure BlockRBO(var Buf; Count: Integer);
function WheelScrollLines: Integer;
procedure GetWheelCommands(ADelta: Integer; var ScrollCode, Count: Integer);
procedure GetBias;
function StrAsg(const Src: string): string;
procedure EnterCS(var CS: TRTLCriticalSection);
procedure LeaveCS(var CS: TRTLCriticalSection);
procedure PurgeCS(var CS: TRTLCriticalSection);
function MonthE(m: Integer): string;
function MonthE2(m: Integer): string;
function DOWE(d: Integer): string;
function DOWE2(d: Integer): string;
procedure ShowExceptionCallback(Buffer, Title: PChar);
function RFCDateStr: string; overload;
function RFCDateUTC: string;
function RFCDateStr(const D: TSystemTime): string; overload;
function RFCDateStr(const D: DWORD): string; overload;
function StrQuotePartEx(const s: string; OldC, NewC, NewC1: Char): string;
procedure FreeRegExprList;
function GetRegExpr(const APattern: string): Pointer;
function FileTimeToMsecs(F: TFileTime): DWORD;

var
  ThrTimesLog: Boolean;
  TNodelistDataFixUp: boolean;
  IsHtmlHelp: Boolean;
  IniFName: string;
  sMutexName: string;
  sActivateEventName: string;

implementation

uses
  Forms,
  ShellAPI,
  RRegExp,
  igHHInt,
  NTdyn,
  Util,
  xMisc,
  RadIni,
  wizard,
  Registry,
  DateUtils,
  JVCLVer,
  JclBase
{$IFDEF FullDebugMode}
  ,
  JCLDebug
{$ENDIF}
  ;

const
  charset = ['!', '"', '#', '$', '%', '&', '''', '(', ')',
    '*', '+', ',', '-', '.', '/', ':', ';', '<',
    '=', '>', '?', '@', '[', ']', '^', '_', '`',
    '{', '|', '}', '~', 'A'..'Z', 'a'..'z', '0'..'9'];

  ////////////////////////////////////////////////////////////////////////
  //                                                                    //
  //                          Time Routines                             //
  //                                                                    //
  ////////////////////////////////////////////////////////////////////////

type
  TTickThread = class(T_Thread)
    procedure InvokeExec; override;
    class function ThreadName: string; override;
  end;

class function TTickThread.ThreadName: string;
begin
  Result := 'Main Timer';
end;

procedure TTickThread.InvokeExec;
begin
  if terminated then
    exit;
  Inc(TickCounter);
  Inc(LiveCounter);
  Inc(WindCounter);
  if ScanCounter > 0 then
  begin
    Inc(ScanCounter);
  end;
  if (LiveCounter > 20 * 60 * 2) or (WindCounter > 20 * 60 * 2) then
  begin
{$IFDEF FullDebugMode}
    if (EntrLogFName <> '') then
    begin
      EnterList.SaveToFile(EntrLogFName);
    end;
{$ENDIF}
    GlobalFail('Taurus hanged up: %d %d', [LiveCounter, WindCounter]);
  end;
  if ScanCounter > 20 * 5 then
  begin
    if Application.MainForm <> nil then
    begin
      PostMessage(Application.MainForm.Handle, WM_OUTBOUNDALERT, 1, 0);
    end;
    ScanCounter := 0;
  end;
  Sleep(50);
end;

var
  TickThr: TTickThread;

procedure DeInitTickTimer;
begin
  TickThr.Terminated := true;
end;

procedure InitTickTimer;
begin
  Inc(TickCounter);
  TickThr := TTickThread.Create;
  TickThr.Priority := tpTimeCritical;
  TickThr.Suspended := False;
end;

(*
function GetOSVer: string;
var
  OS: TOSVersionInfo;
begin
  Result := '';
  OS.dwOSVersionInfoSize := SizeOf(OS);
  if GetVersionEx(OS) then
  begin
    case OS.dwPlatformId of
      VER_PLATFORM_WIN32s: Result := 'Windows 3.1';
      VER_PLATFORM_WIN32_WINDOWS:
        begin
          Result := 'Windows 9X';
          OS.dwBuildNumber := OS.dwBuildNumber and $FFFF;
        end;
      VER_PLATFORM_WIN32_NT: Result := 'Windows NT';
    end;
    Result := Result + ' ' + IntToStr(OS.dwMajorVersion) + '.' +
      IntToStr(OS.dwMinorVersion) + ' (build: ' +
      IntToStr(OS.dwBuildNumber);
    if OS.szCSDVersion[0] <> #0 then
    begin
      Result := Result + ', ' + OS.szCSDVersion;
    end;
    Result := Result + ')';
  end;
end;
*)

function GetOSVer: string;
var
  VerInfo: TOsversionInfoEx;
  PVerInfo: POSVersionInfo;            // pointer to OS version info structure
  OSVersionEx: Boolean;
//  OSVersionEx: Bool;
  PlatformId,
  PlatformType,
  VersionNumber,
  CurrentBuildNumber,
  TResult: string;
begin
  FillChar(VerInfo, SizeOf(VerInfo), 0);
  VerInfo.dwOSVersionInfoSize := SizeOf(VerInfo);
  PVerInfo := @VerInfo;
  OSVersionEx := GetVersionEx(PVerInfo^);
  // Detect platform
  with TRegistry.Create do begin
    RootKey := HKEY_LOCAL_MACHINE;
    case VerInfo.dwPlatformId of
      VER_PLATFORM_WIN32s:
        begin
          // Registry (Huh? What registry?)
          PlatformId := 'Windows 3.1';
        end;
      VER_PLATFORM_WIN32_WINDOWS:
        begin
          // Registry
          OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion', False);
          PlatformId    := ReadString('ProductName');
          VersionNumber := ReadString('VersionNumber');
          CurrentBuildNumber := ReadString('CurrentBuildNumber');
        end;
      VER_PLATFORM_WIN32_NT:
        begin
          // Registry
          OpenKey('\SOFTWARE\Microsoft\Windows NT\CurrentVersion', False);
          PlatformId    := ReadString('ProductName');
          VersionNumber := ReadString('CurrentVersion');
          CurrentBuildNumber := ReadString('CurrentBuildNumber');
          if (VerInfo.dwMajorVersion = 5) and OSVersionEx then begin
            if VerInfo.wProductType = VER_NT_WORKSTATION then PlatformType := 'Professional';
            if VerInfo.wProductType = VER_NT_SERVER then PlatformType := 'Server';
          end;
        end;
    end;
    Free;
  end;
  if Trim(PlatformType) <> '' 
    then  PlatformId :=  PlatformId + ' ' + PlatformType;
  TResult := PlatformId + ' [version ' + VersionNumber;
  TResult := StringReplace(TResult, 'Microsoft ', '', [rfReplaceAll, rfIgnoreCase]);
  if Trim(CurrentBuildNumber) = '' 
    then TResult := TResult + ']'
    else TResult := TResult + '.' + CurrentBuildNumber + ']';
  if Trim(VerInfo.szCSDVersion) <> '' then TResult := TResult + ' ' + Trim(VerInfo.szCSDVersion);
  
  Result := TResult;
end;

type
  TEventWaiter = class(T_Thread)
    hActivate: THandle;
    constructor Create;
    destructor Destroy; override;
    procedure InvokeExec; override;
    class function ThreadName: string; override;
  end;

var
  EventWaiterThr: TEventWaiter;

constructor TEventWaiter.Create;
begin
  inherited Create;
  hActivate := CreateEvent(nil, False, False, PCHAR(sActivateEventName));
  Priority := tpHighest;
end;

destructor TEventWaiter.Destroy;
begin
  ZeroHandle(hActivate);
  inherited Destroy;
end;

procedure TEventWaiter.InvokeExec;
begin
  if hActivate = INVALID_HANDLE_VALUE then
  begin
    Terminated := True;
    Exit
  end;
  if WaitEvt(hActivate, INFINITE) = WAIT_OBJECT_0 then
  begin
    if not Terminated then
      PostMsg(WM_RESTORE_EVT);
  end;
end;

class function TEventWaiter.ThreadName: string;
begin
  Result := 'Event Waiter';
end;

procedure InitEventWaiter;
begin
  EventWaiterThr := TEventWaiter.Create;
  EventWaiterThr.Suspended := False;
end;

const
  cMaxDateHi = 32111902; // 2038, 1, 2, 19, 3, 8, 10, 235
  cTimeHi = 27111902;
  cTimeLo = -717324288;
  cSecScale = 10000000;
  cMsecScale = 10000;

function uCvtGetFileTime(L, H: DWORD): DWORD; assembler;
asm
  mov ecx, cSecScale
  sub eax, cTimeLo
  sbb edx, cTimeHi
  jns @@ns
@@err:
  mov eax, 0
  jmp @@ok
@@ns:
  cmp edx, cMaxDateHi - cTimeHi
  ja  @@err
  div ecx
  test eax, eax
  js  @@err
@@ok:
end;

function uCvtMsecs(L, H: DWORD): DWORD; assembler;
asm
   cmp  edx, cMsecScale / 2
   jb   @@ok
   mov  eax, 0
   jmp  @@end
@@ok:
   mov  ecx, cMsecScale
   div  ecx
@@end:
end;

function FileTimeToMsecs(F: TFileTime): DWORD;
begin
  Result := uCvtMsecs(F.dwLowDateTime, F.dwHighDateTime);
end;

procedure uCvtSetFileTime(T: DWORD; var L, H: DWORD); assembler;
asm
  push edx
  push ebx
  mov  ebx, cSecScale
  mul  ebx
  pop  ebx
  add  eax, cTimeLo
  adc  edx, cTimeHi
  mov  [ecx], edx
  pop  edx
  mov  [edx], eax
end;

procedure uNix2WinTime(I: DWORD; var T: TSystemTime);
var
  F: TFileTime;
begin
  uCvtSetFileTime(I, F.dwLowDateTime, F.dwHighDateTime);
  FileTimeToSystemTime(F, T);
end;

function uWin2NixTime(const T: TSystemTime): DWORD;
var
  F: TFileTime;
begin
  SystemTimeToFileTime(T, F);
  Result := uCvtGetFileTime(F.dwLowDateTime, F.dwHighDateTime);
end;

function uDosDateTimeToFileTime;
var
  T: TFileTime;
begin
  Result := DosDateTimeToFileTime(wFatDate, wFatTime, T);
  if Result then
    uTime := uCvtGetFileTime(T.dwLowDateTime, T.dwHighDateTime)
  else
    uTime := uGetSystemTime;
end;

function uGetLocalTime: DWORD;
var
  ST, T: TFileTime;
begin
  GetSystemTimeAsFileTime(ST);
  FileTimeToLocalFileTime(ST, T);
  Result := uCvtGetFileTime(T.dwLowDateTime, T.dwHighDateTime);
end;

function uGetSystemTime: DWORD;
var
  T: TFileTime;
begin
  GetSystemTimeAsFileTime(T);
  Result := uCvtGetFileTime(T.dwLowDateTime, T.dwHighDateTime);
end;

function uSetFileTimeByHandle(Handle: DWORD; uTime: DWORD): Boolean;
var
  F: TFileTime;
begin
  uCvtSetFileTime(uTime, F.dwLowDateTime, F.dwHighDateTime);
  Result := SetFileTime(Handle, nil, nil, @F);
end;

function uSetFileTime(const FName: string; uTime: DWORD): Boolean;
var
  Handle: DWORD;
begin
  Result := False;
  Handle := _CreateFile(FName, [cWrite, cExisting]);
  if Handle = INVALID_HANDLE_VALUE then
    Exit;
  Result := uSetFileTimeByHandle(Handle, uTime);
  ZeroHandle(Handle);
end;

procedure CvtFD(const wf: TWin32FindData; var FindData: TuFindData);
begin
  FindData.Info.Attr := wf.dwFileAttributes;
  FindData.Info.Time := uCvtGetFileTime(wf.ftLastWriteTime.dwLowDateTime,
    wf.ftLastWriteTime.dwHighDateTime);
  Int64Rec(FindData.Info.Size).Lo := wf.nFileSizeLow;
  Int64Rec(FindData.Info.Size).Hi := wf.nFileSizeHigh;
  FindData.FName := wf.cFileName;
end;

function uFindFirstEx(const FName: string; var FindData: TuFindData; fSearchOp:
  TFindexSearchOps): Boolean;
var
  wf: TWin32FindData;
begin
  if (Win32Platform = VER_PLATFORM_WIN32_NT) then
  begin
    FindData.Handle := NTDyn_FindFirstFileEx(PChar(FName), FindExInfoStandard,
      @wf, fSearchOp, nil, 0);
  end
  else
  begin
    FindData.Handle := FindFirstFile(PChar(FName), wf);
  end;
  Result := FindData.Handle <> INVALID_HANDLE_VALUE;
  if Result then
    CvtFD(wf, FindData);
end;

function uFindFirst(const FName: string; var FindData: TuFindData): Boolean;
begin
  Result := uFindFirstEx(FName, FindData, FindExSearchNameMatch);
end;

function uFindNext(var FindData: TuFindData): Boolean;
var
  wf: TWin32FindData;
begin
  Result := FindNextFile(FindData.Handle, wf);
  if Result then
    CvtFD(wf, FindData);
end;

function uFindClose(var FindData: TuFindData): Boolean;
begin
  Result := Windows.FindClose(FindData.Handle);
end;

function uFormatDateTime(const Format: string; uTime: DWORD): string;
begin
  //  SetNormalMonths;
  Result := FormatDateTime(Format, uDelphiTime(uTime));
end;

function uFormat(uTime: DWORD): string;
begin
  Result := uFormatDateTime('dd', uTime) + '-' +
    MonthE(MonthOf(uDelphiTime(uTime))) + '-' +
    uFormatDateTime('yyyy hh:nn:ss', uTime);
end;

function uDelphiTime;
begin
  {Convert to Delphi style date, add in unix base}
  Result := uTime / SecsPerDay;
  Result := Result + UnixDaysBase - DelphiDayBase;
end;

function MultiTimeout;
var
  I: Integer;
begin
  Result := High(Result);
  for I := 0 to High(Timers) do
    Result := MinD(Result, RemainingTimeMsecs(Timers[I]));
end;

procedure NewTimer;
{-Returns a set EventTimer that will expire in Tics}
var
  a: DWORD;
begin
  a := TickCounter;
  ET.StartTicks := a;
  ET.ExpireTicks := a + Tics;
end;

procedure NewTimerSecs;
begin
  NewTimer(ET, Secs * 20);
end;

function GetHalfAvg(a: DWORD): DWORD;
begin
  Result := a + xRandom(a) - (a div 2);
end;

procedure NewTimerAvg;
begin
  NewTimer(ET, GetHalfAvg(Secs * 20));
end;

procedure NewTimerMSecs;
var
  t: Integer;
begin
  t := Msecs div 50;
  if Msecs mod 50 <> 0 then
    Inc(t);
  NewTimer(et, t);
end;

function TimerExpired;
{-Returns True if ET has expired}
begin
  if TimerInstalled(ET) then
    Result := TickCounter > ET.ExpireTicks
  else
    Result := Boolean(GlobalFail('%s',
      ['Attempt do invoke TimerExpired() on uninstalled timer']));
end;

function ElapsedTime;
{-Returns elapsed time, in tics, for this timer}
begin
  if TimerInstalled(ET) then
    Result := TickCounter - ET.StartTicks
  else
    Result := High(Result);
end;

function RemainingTimeMSecs;
{-Returns remaining time, in msecs, for this timer}
var
  tc: DWORD;
begin
  if TimerInstalled(ET) then
  begin
    tc := TickCounter;
    if tc > ET.ExpireTicks then
    begin
      Result := 0
    end
    else
    begin
      Result := (ET.ExpireTicks - tc) * 50;
    end;
  end
  else
  begin
    Result := High(Result);
  end;
end;

function RemainingTimeSecs;
{-Returns remaining time, in secs, for this timer}
var
  tc: DWORD;
begin
  if TimerInstalled(ET) then
  begin
    tc := TickCounter;
    if tc > ET.ExpireTicks then
    begin
      Result := 0
    end
    else
    begin
      Result := (ET.ExpireTicks - tc) div 20;
    end;
  end
  else
  begin
    Result := High(Result);
  end;
end;

procedure ClearTimer;
begin
  ET.StartTicks := 0;
  ET.ExpireTicks := 0;
end;

function TimerInstalled;
begin
  Result := (ET.StartTicks <> 0) and (ET.ExpireTicks <> 0);
end;

////////////////////////////////////////////////////////////////////////
//                                                                    //
//                         string Routines                            //
//                                                                    //
////////////////////////////////////////////////////////////////////////

function IsWild(const S: string): Boolean;
var
  z: string;
begin
  Result := (Pos('*', S) > 0) or (Pos('?', S) > 0);
  if Result then
    Exit;
  z := StrQuotePartEx(s, '~', #3, #4);
  Result := z <> s;
end;

function TrimZeros(const S: string): string;
var
  I, J: Integer;
begin
  I := Length(S);
  while (I > 0) and (S[I] <= ' ') do
    Dec(I);
  J := 1;
  while (J < I) and ((S[J] <= ' ') or (S[J] = '0')) do
    Inc(J);
  Result := Copy(S, J, (I - J) + 1);
end;

function OctalStr2Long(S: string): Integer;
{-Convert S from an octal string to a longint}
const
  HiMag = 11;
  Magnitude: array[1..HiMag] of Integer =
  (1, 8, 64, 512, 4096, 32768, 262144, 2097152, 16777216, 134217728,
    1073741824);
var
  Len: Byte;
  I: Integer;
  J: Integer;
  Part: Integer;
  Res: Integer;
begin
  {Assume failure}
  OctalStr2Long := 0;

  {Remove leading blanks and zeros}
  S := TrimZeros(S);
  Len := Length(S);

  {Return 0 for invalid strings}
  if Len > HiMag then
    Exit;

  {Convert it}
  Res := 0;
  J := 1;
  for I := Len downto 1 do
  begin
    if (S[I] < '0') or (S[I] > '7') then
      Exit;
    Part := Byte(S[I]) - $30;
    Res := Res + Part * Magnitude[J];
    Inc(J);
  end;
  OctalStr2Long := Res
end;

function OctalStr(L: Integer): string;
{-Convert L to octal base string}
const
  Digits: array[0..7] of Char = '01234567';
var
  I: Integer;
begin
  SetLength(Result, 12);
  for I := 0 to 11 do
  begin
    Result[12 - I] := Digits[L and 7];
    L := L shr 3;
  end;
end;

function BothKVC(const S: string): Boolean;
begin
  Result := (Copy(S, 1, 1) = '"') and (Copy(S, Length(S), 1) = '"');
end;

function AddLeftSpaces;
begin
  Result := Format('%' + IntToStr(NumSpaces) + 's', [S]);
end;

function AddRightSpaces;
var
  i: Integer;
begin
  if NumSpaces < 0 then
    GlobalFail('AddRightSpaces(%s,%d', [s, NumSpaces]);
  if NumSpaces = 0 then
    Result := ''
  else
  begin
    SetLength(Result, NumSpaces);
    FillChar(Result[1], NumSpaces, ' ');
    i := MinI(NumSpaces, Length(S));
    if i > 0 then
      Move(S[1], Result[1], i);
  end;
end;

function Hex2;
begin
  SetLength(Result, 2);
  Result[1] := rrHiHexChar[a shr $4];
  Result[2] := rrHiHexChar[a and $F];
end;

function Hex3;
var
  I: Integer;
begin
  SetLength(Result, 3);
  for I := 0 to 2 do
  begin
    Result[3 - I] := rrHiHexChar[A and $F];
    A := A shr 4;
  end;
end;

function Hex4;
var
  I: Integer;
begin
  SetLength(Result, 4);
  for I := 0 to 3 do
  begin
    Result[4 - I] := rrHiHexChar[A and $F];
    A := A shr 4;
  end;
end;

function H32_2(a: Word): string;
begin
  SetLength(Result, 2);
  Result[1] := rrHi32Char[(a shr 5) and $1F];
  Result[2] := rrHi32Char[a and $1F];
end;

function H32_3(a: Word): string;
var
  I: Integer;
begin
  SetLength(Result, 3);
  for I := 0 to 2 do
  begin
    Result[3 - I] := rrHi32Char[A and $1F];
    A := A shr 5;
  end;
end;

function Hex8;
var
  I: Integer;
begin
  SetLength(Result, 8);
  for I := 0 to 7 do
  begin
    Result[8 - I] := rrHiHexChar[A and $F];
    A := A shr 4;
  end;
end;

function Int2Hex(a: Integer): string;
begin
  Result := Format('%x', [a]);
end;

function MakeFullDir(const D, S: string): string;
begin
  if (Pos(':', S) > 0) or (Copy(S, 1, 2) = '\\') or (Copy(S, 1, 1) = '.') then
  begin
    Result := S;
  end
  else
  begin
    if Copy(S, 1, 1) = '\' then
    begin
      Result := MakeNormName(Copy(D, 1, Pos(':', D)), Copy(S, 2, Length(S) -
        1));
    end
    else
    begin
      Result := MakeNormName(D, S);
    end;
  end;
  if Result = '' then
    exit;
  if Result[length(Result)] = '\' then
    Delete(Result, length(Result), 1);
end;

function ExtractDir;
var
  i: Integer;
begin
  Result := S;
  i := Length(S);
  if (i > 3) and (S[i] = '\') then
    DelLC(Result);
end;

function MakeNormName;
begin
  Result := Path;
  if Path = '' then
    exit;
  if Name = '' then
  begin
    Result := '';
    exit;
  end;
  if (Result <> '') and (Result[Length(Result)] <> '\') then
    AddStr(Result, '\');
  if (Name = JustFileName(Name)) or (Pos('%', Name) > 0) then
  begin
    Result := Result + Name;
  end
  else
  begin
    if pos(':', Name) > 0 then
    begin
      Result := Name;
    end
    else if pos('..', Name) > 0 then
    begin
      Result := Name;
    end
    else
    begin
      Result := Result + Name;
    end;
  end;
end;

procedure AddStr;
begin
  S := S + C;
end;

procedure FSplit(const FName: string; var Path, Name, Ext: string);
type
  TStep = (sExt, sName, sPath);
var
  Step: TStep;
  I: Integer;
  C: Char;
begin
  I := Length(FName);
  if Pos('.', FName) = 0 then
    Step := sName
  else
    Step := sExt;
  Path := ''; Name := '';
  Ext := '';
  while I > 0 do
  begin
    C := FName[I];
    Dec(I);
    case Step of
      sExt:
        case C of
          '.':
            begin
              Ext := C + Ext;
              Inc(Step);
            end;
          '\', ':':
            begin
              Name := Ext;
              Ext := '';
              Path := C;
              Step := sPath;
            end;
        else
          Ext := C + Ext;
        end;
      sName: if (C = '\') or (C = ':') then
        begin
          Path := C;
          Inc(Step)
        end
        else
          Name := C + Name;
      sPath: Path := C + Path;
    end;
  end;
end;

function ReplaceEx(const Pattern, ReplaceString: string; var S: string; CI:
  Boolean): Boolean;
var
  I,
    J,
    LP,
    LR: Integer;
begin
  Result := False;
  J := 1;
  LP := Length(Pattern);
  LR := Length(ReplaceString);
  repeat
    if CI then
    begin
      I := Pos(Pattern, UpperCase(CopyLeft(S, J)));
    end
    else
    begin
      I := Pos(Pattern, CopyLeft(S, J));
    end;
    if I > 0 then
    begin
      Delete(S, J + I - 1, LP);
      Insert(ReplaceString, S, J + I - 1);
      Result := True;
    end;
    Inc(J, I + LR - 1);
  until I = 0;
end;

function Replace(const Pattern, ReplaceString: string; var S: string): Boolean;
begin
  Result := ReplaceEx(Pattern, ReplaceString, S, False);
end;

function ReplaceCI(const Pattern, ReplaceString: string; var S: string):
  Boolean;
begin
  Result := ReplaceEx(Pattern, ReplaceString, S, True);
end;

function DelLeft(const S: string): string;
var
  I,
    L: Integer;
begin
  I := 1;
  L := Length(S);
  while I <= L do
  begin
    case S[I] of
      #9, ' ': ;
    else
      Break
    end;
    Inc(I);
  end;
  Result := Copy(S, I, L + 1 - I);
end;

function DelRight(const S: string): string;
var
  I: Integer;
begin
  I := Length(S);
  while I > 0 do
  begin
    case S[I] of
      #9, ' ': ;
    else
      Break
    end;
    Dec(I);
  end;
  Result := Copy(S, 1, I);
end;

function _DelSpaces(const s: string): string;
begin
  Result := DelLeft(DelRight(s));
end;

procedure DelFC(var s: string);
begin
  Delete(s, 1, 1);
end;

procedure DelLC(var s: string);
var
  l: Integer;
begin
  l := Length(s);
  case l of
    0: ;
    1: s := '';
  else
    SetLength(s, l - 1);
  end;
end;

function Int2Str(L: Integer): string;
var
  I: Integer;
begin
  Str(L, Result);
  I := Length(Result) - 2;
  while I > 1 do
  begin
    { Thousand Separator }
    Insert(',', Result, I);
    Dec(I, 3);
  end;
end;

function Int2StrK(L: Integer): string;
begin
  case L of
    0..999:
      begin
        Result := Int2Str(L) + 'b';
      end;
    1000..999999:
      begin
        Str(L / 1000: 0: 1, Result);
        Result := Result + 'K';
      end;
    1000000..999999999:
      begin
        Str(L / 1000000: 0: 1, Result);
        Result := Result + 'M';
      end;
  end;
end;

function WipeChars;
var
  i,
    j: Integer;
begin
  Result := '';
  j := Length(AStr);
  for i := 1 to j do
    if Pos(AStr[I], AWipeChars) = 0 then
      AddStr(Result, AStr[I]);
end;

procedure FillCharSet(const AStr: string; var CharSet: TCharSet);
var
  i: Integer;
begin
  CharSet := [];
  for i := 1 to Length(AStr) do
    Include(CharSet, AStr[i]);
end;

function DigitsOnly(const AStr: string): Boolean;
var
  i: Integer;
begin
  Result := False;
  if AStr = '' then
    Exit;
  for i := 1 to Length(AStr) do
    case AStr[i] of
      '0'..'9': ;
    else
      Exit;
    end;
  Result := True;
end;

procedure GetWrd(var s, w: string; c: char);
var
  i, j: Integer;
begin
  w := '';
  if s = '' then
    Exit;
  if (c = ' ') and (Pos(' ', s) > 0) then
    s := _DelSpaces(s);
  j := 0;
  for i := 1 to Length(s) do
  begin
    if s[i] = c then
      Break;
    Inc(j);
  end;
  w := Copy(s, 1, j);
  Delete(s, 1, j + 1);
end;

function StrRight(const S: string; Num: Integer): string;
begin
  Result := Copy(S, Length(S) - Num + 1, Num);
end;

function StrEnds(const Substr, S: string): Boolean;
begin
  Result := StrRight(S, Length(Substr)) = Substr;
end;

function CopyLeft(const S: string; I: Integer): string;
begin
  Result := Copy(S, I, Length(S) - I + 1);
end;

////////////////////////////////////////////////////////////////////////
//                                                                    //
//                          Basic Routines                            //
//                                                                    //
////////////////////////////////////////////////////////////////////////

procedure Clear(var Buf; Count: Integer);
begin
  FillChar(Buf, Count, 0);
end;

function MemEqu(const A, B; Sz: Integer): Boolean;
asm
    push  ebx
    xchg  eax, ebx
    jmp   @1

@0: inc   edx
@1: mov   al, [ebx]
    inc   ebx
    cmp   al, [edx]
    jne   @@Wrong
    dec   ecx
    jnz   @0

    mov   eax, 1
    jmp   @@End
@@Wrong:
    mov   eax, 0
@@End:
    pop   ebx
end;

function MaxI(A, B: Integer): Integer; assembler;
asm
  cmp  eax, edx
  jg   @@g
  xchg eax, edx
@@g:
end;

function MinI(A, B: Integer): Integer; assembler;
asm
  cmp  eax, edx
  jl   @@l
  xchg eax, edx
@@l:
end;

function MaxD(A, B: DWORD): DWORD; assembler;
asm
  cmp  eax, edx
  ja   @@a
  xchg eax, edx
@@a:
end;

function MinD(A, B: DWORD): DWORD; assembler;
asm
  cmp  eax, edx
  jb   @@b
  xchg eax, edx
@@b:
end;

procedure XChg(var Critical, Normal); assembler;
asm
  mov  ecx, [edx]
  lock xchg[eax], ecx
  mov  [edx], ecx
end;

function NulSearch; assembler;
asm
  CLD
  PUSH    EDI
  MOV     EDI, Buffer
  XOR     AL,  AL
  MOV     ECX, -1
  REPNE   SCASB
  XCHG    EAX,ECX
  NOT     EAX
  DEC     EAX
  POP     EDI
end;

function ShortBuf2StrEx;
var
  ss: ShortString;
  sl: Byte absolute ss;
  c: Char;
  i: Integer;
  Arr: TCharArray absolute Buffer;
begin
  sl := 0;
  for i := 1 to AMaxLen do
  begin
    c := Arr[sl];
    if c = AC then
      Break;
    sl := i;
    ss[i] := c;
  end;
  Result := ss;
end;

function ShortBuf2Str;
begin
  Result := ShortBuf2StrEx(Buffer, AMaxLen, #0);
end;

procedure LowerPrec(var A, B: Integer; Bits: Byte);
var
  C: ShortInt;
begin
  C := MaxD(NumBits(A), NumBits(B));
  Dec(C, Bits);
  if C <= 0 then
    Exit;
  A := A shr C;
  B := B shr C;
end;

////////////////////////////////////////////////////////////////////////
//                                                                    //
//                           CRC Routines                             //
//                                                                    //
////////////////////////////////////////////////////////////////////////

type
  TXlatTable = array[byte] of Byte;
  TCrc16Table = array[byte] of Word;
  TCrc32Table = array[byte] of DWORD;

var
  RBOTable: TXlatTable;
  Crc16UsdTable, Crc16PropTable: TCrc16Table;
  Crc32Table: TCrc32Table;

procedure InitRBOTable;
var
  i, j: Integer;
begin
  for i := $00 to $FF do
  begin
    j := (((i and $01) shl 7) or
      ((i and $02) shl 5) or
      ((i and $04) shl 3) or
      ((i and $08) shl 1) or
      ((i and $10) shr 1) or
      ((i and $20) shr 3) or
      ((i and $40) shr 5) or
      ((i and $80) shr 7));
    RBOTable[i] := j;
  end;
end;

procedure InitCRC16PropTable;
var
  i: Integer;
  Crc16: DWORD;
  ar: array[0..1] of DWORD;
begin
  ar[0] := 0;
  ar[1] := CRC16PROP_POLY;
  for i := Low(Crc16PropTable) to High(Crc16PropTable) do
  begin
    Crc16 := i; // do 8 times
    Crc16 := (Crc16 shr 1) xor ar[Crc16 and 1];
    Crc16 := (Crc16 shr 1) xor ar[Crc16 and 1];
    Crc16 := (Crc16 shr 1) xor ar[Crc16 and 1];
    Crc16 := (Crc16 shr 1) xor ar[Crc16 and 1];
    Crc16 := (Crc16 shr 1) xor ar[Crc16 and 1];
    Crc16 := (Crc16 shr 1) xor ar[Crc16 and 1];
    Crc16 := (Crc16 shr 1) xor ar[Crc16 and 1];
    Crc16 := (Crc16 shr 1) xor ar[Crc16 and 1];
    Crc16PropTable[i] := Crc16;
  end;
end;

procedure InitCRC16UsdTable;
var
  i, n: Integer;
  Crc16: Integer;
  ar: array[0..1] of Integer;
begin
  ar[0] := 0;
  ar[1] := CRC16USD_POLY;
  for i := Low(Crc16UsdTable) to High(Crc16UsdTable) do
  begin
    Crc16 := (i shl 8) and $FFFF;
    for N := 1 to 8 do
      Crc16 := ((Crc16 shl 1) xor ar[Crc16 shr 15]) and $FFFF;
    Crc16UsdTable[i] := Crc16;
  end;
end;

procedure InitCRC32Table;
var
  i, Crc32: DWORD;
  ar: array[0..1] of DWORD;
begin
  ar[0] := 0;
  ar[1] := CRC32_POLY;
  for i := Low(Crc32Table) to High(Crc32Table) do
  begin
    Crc32 := i; // 8 times
    Crc32 := (Crc32 shr 1) xor ar[Crc32 and 1];
    Crc32 := (Crc32 shr 1) xor ar[Crc32 and 1];
    Crc32 := (Crc32 shr 1) xor ar[Crc32 and 1];
    Crc32 := (Crc32 shr 1) xor ar[Crc32 and 1];
    Crc32 := (Crc32 shr 1) xor ar[Crc32 and 1];
    Crc32 := (Crc32 shr 1) xor ar[Crc32 and 1];
    Crc32 := (Crc32 shr 1) xor ar[Crc32 and 1];
    Crc32 := (Crc32 shr 1) xor ar[Crc32 and 1];
    Crc32Table[i] := Crc32;
  end;
end;

function Crc16Post(Crc: word): word;
begin
  Crc16Post := (not Crc); // CRC Postconditioning before xmit
end;

function Crc32Post(Crc: DWORD): DWORD;
begin
  Crc32Post := (not Crc); // CRC Postconditioning before xmit
end;

function Crc16PropBlock(const Buf; Len: DWORD): word;
var
  i: Integer;
  A: TxByteArray absolute Buf;
begin
  Result := CRC16PROP_INIT;
  for i := 0 to Len - 1 do
  begin
    Result := UpdateCrc16Prop(A[i], Result);
  end;
end;

function Crc16UsdBlock(const Buf; Len: DWORD): word;
var
  i: Integer;
  A: TxByteArray absolute Buf;
begin
  Result := CRC16USD_INIT;
  for i := 0 to Len - 1 do
  begin
    Result := UpdateCrc16Usd(A[i], Result);
  end;
  Result := UpdateCrc16Usd(0, Result);
  Result := UpdateCrc16Usd(0, Result);
end;

function Crc32Int(I: DWORD; Crc32: DWORD): DWORD;
begin
  Result := CRC32Block(I, SizeOf(I), Crc32);
end;

function Crc32Block;
var
  i: Integer;
  A: TxByteArray absolute Buf;
begin
  Result := Crc32;
  for i := 0 to Len - 1 do
  begin
    Result := UpdateCrc32(A[i], Result);
  end;
end;

// CRC-16 proper, used for both CCITT and the one used by ARC

function UpdateCrc16Prop(CurByte: Byte; CurCrc: Word): Word;
{-Returns an updated CRC16}
begin
  Result := Crc16PropTable[Byte(CurCrc) xor CurByte] xor (CurCrc shr 8);
end;

// CRC-16 upside-down, transmitted high-byte first

function UpdateCrc16Usd(CurByte: Byte; CurCrc: Word): Word;
{-Returns an updated CRC16}
begin
  Result := Crc16UsdTable[CurCrc shr 8] xor ((CurCrc and $FF) shl 8) xor
    CurByte;
end;

function UpdateCrc32(CurByte: Byte; CurCrc: DWORD): DWORD;
{-Returns an updated crc32}
begin
  UpdateCrc32 := Crc32Table[byte(CurCrc xor CurByte)] xor (CurCrc shr 8);
  ;
end;

////////////////////////////////////////////////////////////////////////
//                                                                    //
//                      Win32 Events Extentions                       //
//                                                                    //
////////////////////////////////////////////////////////////////////////

function CreateEvtA;
begin
  Result := CreateEvent(nil, False, False, nil);
  if Result = 0 then
    GlobalFail('CreateEvtA Error %d', [GetLastError]);
end;

function CreateEvt;
begin
  Result := CreateEvent(nil, // address of security attributes
    True, // flag for manual-reset event
    Initial, // flag for initial state
    nil); // address of event-object name
  if Result = 0 then
    GlobalFail('CreateEvt Error %d', [GetLastError]);
end;

function WaitEvtAEx(nCount: Integer; lpHandles: PWOHandleArray; Timeout: DWORD;
  AWaitAll: Boolean): DWORD;
begin
  try
    if (Timeout = High(Timeout)) or (Integer(Timeout) = High(Integer)) then
      Timeout := INFINITE;
    if nCount = 1 then
      Result := WaitForSingleObject(lpHandles^[0], Timeout)
    else
      Result := WaitForMultipleObjects(nCount, lpHandles, AWaitAll, Timeout);
    if Result = WAIT_FAILED then
      GlobalFail('WaitEvtA(count=%d) - WaitFailed', [nCount]);
  except
    Result := WAIT_FAILED;
  end;
end;

function WaitEvtA(nCount: Integer; lpHandles: PWOHandleArray; Timeout: DWORD):
  DWORD;
begin
  Result := WaitEvtAEx(nCount, lpHandles, Timeout, False);
end;

function WaitEvts;
begin
  Result := WaitEvtA(High(id) + 1, @id, Timeout);
end;

function WaitEvtsAll;
begin
  Result := WaitEvtAEx(High(id) + 1, @id, Timeout, True);
end;

function WaitEvt(H: THandle; Timeout: DWORD): DWORD;
begin
  Result := WaitEvts([H], Timeout);
end;

function WaitEvtInfinite(H: THandle): DWORD;
begin
  Result := WaitEvt(H, INFINITE);
end;

function T_Thread.WaitEvtAEx(nCount: Integer; lpHandles: PWOHandleArray;
  Timeout: DWORD; AWaitAll: Boolean; eName: string = ''): DWORD;
{$IFDEF FullDebugMode}
var
  st: string;
  en: string;
  ii: integer;
{$ENDIF}
begin
{$IFDEF FullDebugMode}
  if (IniFile <> nil) and IniFile.logWaitEvt then
  begin
    if TimeOut = INFINITE then
      St := 'INFINITE'
    else
      St := IntToStr(TimeOut);
    if eName <> '' then
      St := St + ', ' + eName;
    En := Pad(ThreadName, 19) + ': ' + IntToStr(lpHandles^[0]) + ', ' + St;
    EnterList.Enter;
    EnterList.Add(En);
    if (EntrLogFName <> '') and IniFile.SaveWaits then
    begin
      EnterList.SaveToFile(EntrLogFName);
    end;
    EnterList.Leave;
  end;
{$ENDIF}

  try
    if (Timeout = High(Timeout)) or (Integer(Timeout) = High(Integer)) then
      Timeout := INFINITE;
    if nCount = 1 then
      Result := WaitForSingleObject(lpHandles^[0], Timeout)
    else
      Result := WaitForMultipleObjects(nCount, lpHandles, AWaitAll, Timeout);
    if Result = WAIT_FAILED then
      GlobalFail('WaitEvtA(count=%d) - WaitFailed', [nCount]);
  except
    Result := WAIT_FAILED;
  end;

{$IFDEF FullDebugMode}
  if (IniFile <> nil) and IniFile.logWaitEvt then
  begin
    EnterList.Enter;
    ii := EnterList.IndexOf(En);
    if ii > -1 then
    begin
      EnterList.Delete(ii);
      if (EntrLogFName <> '') and IniFile.SaveWaits then
      begin
        EnterList.SaveToFile(EntrLogFName);
      end;
    end;
    EnterList.Leave;
  end;
{$ENDIF}
end;

function T_Thread.WaitEvtA(nCount: Integer; lpHandles: PWOHandleArray; Timeout:
  DWORD; eName: string = ''): DWORD;
begin
  Result := WaitEvtAEx(nCount, lpHandles, Timeout, False);
end;

function T_Thread.WaitEvts;
begin
  Result := WaitEvtA(High(id) + 1, @id, Timeout);
end;

function T_Thread.WaitEvt(H: THandle; Timeout: DWORD; eName: string = ''):
  DWORD;
begin
  Result := WaitEvts([H], Timeout);
end;

function T_Thread.WaitEvtInfinite(H: THandle; eName: string = ''): DWORD;
begin
  Result := WaitEvt(H, INFINITE, eName);
end;

////////////////////////////////////////////////////////////////////////
//                                                                    //
//                      Win32 API Hooks                               //
//                                                                    //
////////////////////////////////////////////////////////////////////////

function GetFileNfo;
var
  D: TWin32FileAttributeData;
  Handle: DWORD;
begin
  if Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
    Result := NTdyn_GetFileAttributesEx(PChar(FName), GetFileExInfoStandard,
      @D);
    if not Result then
      Exit;
    Info.Attr := D.dwFileAttributes;
    Int64Rec(Info.Size).Lo := D.nFileSizeLow;
    Int64Rec(Info.Size).Hi := D.nFileSizeHigh;
    Info.Time := uCvtGetFileTime(D.ftLastWriteTime.dwLowDateTime,
      D.ftLastWriteTime.dwHighDateTime);
    Result := True;
  end
  else
  begin
    Result := False;
    Handle := _CreateFile(FName, [cRead, cShareAllowWrite]);
    if Handle = INVALID_HANDLE_VALUE then
      Exit;
    Result := GetFileNfoByHandle(Handle, Info);
    ZeroHandle(Handle);
    if NeedAttr and Result and (Info.Attr = INVALID_HANDLE_VALUE) then
      Result := GetFileAttributes(PChar(FName)) <> INVALID_HANDLE_VALUE;
  end;
end;

function GetFileNfoByHandle;
var
  i: TByHandleFileInformation;
begin
  Result := False;
  if Handle = INVALID_HANDLE_VALUE then
    Exit;
  FillChar(i, SizeOf(i), $FF);
  i.dwFileAttributes := INVALID_FILE_ATTRIBUTES;
  i.nFileSizeLow := GetFileSize(Handle, nil);
  Result := (i.nFileSizeLow <> INVALID_FILE_SIZE) and GetFileTime(Handle, nil,
    nil, @i.ftLastWriteTime);
  if not Result then
    Exit;
  Info.Size := i.nFileSizeLow;
  Info.Attr := i.dwFileAttributes;
  Info.Time := uCvtGetFileTime(i.ftLastWriteTime.dwLowDateTime,
    i.ftLastWriteTime.dwHighDateTime);
  Result := True;
end;

function ZeroHandle(var Handle: THandle): Boolean;
begin
  if (Handle = INVALID_HANDLE_VALUE) or
    (Handle = 0) then
    Result := False
  else
  begin
    Result := CloseHandle(Handle);
    if not Result then
      GlobalFail('CloseHandle(%d) Error %d', [Handle, GetLastError]);
    Handle := 0;
  end;
end;

procedure _PostMessage(a: DWORD; b, c, d: Integer);
begin
  {if not} PostMessage(a, b, c, d)
    {then GlobalFail('PostMessage(%d,%d,%d,%d) Error %d (MainWinHandle=%d)', [a, b, c, d, GetLastError, MainWinHandle]);}
  {�� ������������, ������ postmessage ����� ���������� 0}
end;

procedure PostMsgP;
begin
  _PostMessage(MainWinHandle, Msg, 0, Integer(LParam));
end;

procedure PostMsg;
begin
  _PostMessage(MainWinHandle, Msg, 0, 0);
end;

procedure SendMsg;
begin
  SendMessage(MainWinHandle, Msg, 0, 0);
end;

function _CreateFile;
begin
  Result := _CreateFileSecurity(FName, Mode, nil);
end;

function _CreateFileSecurity;
var
  Access,
    Share,
    Disp,
    Flags,
    trc: DWORD;
const
  NumDispModes = 5;
  DispArr: array[1..NumDispModes] of
  record
    w: Boolean; {Write}
    n: Boolean; {EnsureNew}
    t: Boolean; {Truncate}
    d: DWORD; {Disp}
  end =
  ((w: False; n: False; t: False; d: OPEN_EXISTING),
    (w: True; n: False; t: False; d: OPEN_ALWAYS),
    (w: True; n: True; t: False; d: CREATE_NEW),
    (w: True; n: False; t: True; d: CREATE_ALWAYS),
    (w: True; n: True; t: True; d: TRUNCATE_EXISTING));
begin

  // Prepare Disp & Flags

  Flags := FILE_ATTRIBUTE_NORMAL;
  Access := 0;
  Share := 0;
  Disp := 0;
  trc := 0;

  if cFlag in Mode then
  begin
    Disp := CREATE_NEW;
    Flags := Flags or FILE_FLAG_DELETE_ON_CLOSE
  end
  else
  begin
    if Mode * [cTruncate, cEnsureNew] <> [] then
      Mode := Mode + [cWrite];
    if cExisting in Mode then
      Disp := OPEN_EXISTING
    else
    begin
      if cWrite in Mode then
        Flags := FILE_ATTRIBUTE_ARCHIVE;
      repeat
        Inc(Disp);
        if Disp > NumDispModes then
          GlobalFail('_CreateFile: Invalid mode opening %s', [FName]);
        with DispArr[Disp] do
          if (w = (cWrite in Mode)) and
            (n = (cEnsureNew in Mode)) and
            (t = (cTruncate in Mode)) then
          begin
            Disp := d;
            Break
          end;
      until False;
    end;

    if cOverlapped in Mode then
      Flags := Flags or FILE_FLAG_OVERLAPPED;
    if cRandomAccess in Mode then
      Flags := Flags or FILE_FLAG_RANDOM_ACCESS;
    if cSequentialScan in Mode then
      Flags := Flags or FILE_FLAG_SEQUENTIAL_SCAN;
    if cDeleteOnClose in Mode then
      Flags := Flags or FILE_FLAG_DELETE_ON_CLOSE;
    if cWriteThrough in Mode then
      Flags := Flags or FILE_FLAG_WRITE_THROUGH;

    // Prepare 'Access' and 'Share'

    if cShareAllowWrite in Mode then
      Share := FILE_SHARE_WRITE;
    if cShare in Mode then
      Share := FILE_SHARE_READ or FILE_SHARE_WRITE;
    if cRead in Mode then
    begin
      Access := Access or GENERIC_READ;
      Share := Share or FILE_SHARE_READ
    end;
    if cWrite in Mode then
    begin
      Access := Access or GENERIC_WRITE;
      Share := Share or FILE_SHARE_READ
    end;
    if cShareDenyRead in Mode then
      Share := Share and not FILE_SHARE_READ;
  end;

  Result := CreateFile(PChar(FName), Access, Share, lpSecurityAttributes, Disp,
    Flags, 0);
  if Result = INVALID_HANDLE_VALUE then
  begin
    if not (cCanPending in Mode) then
      while (GetLastError = ERROR_SHARING_VIOLATION) do
      begin
        inc(trc);
        sleep(100);
        Result := CreateFile(PChar(FName), Access, Share, lpSecurityAttributes,
          Disp, Flags, 0);
        if trc > 20 then
          break;
      end;
  end;
end;

function _GetFileSize;
var
  H: DWORD;
begin
  Result := INVALID_FILE_SIZE;
  H := _CreateFile(FName, [cRead]);
  if H = INVALID_HANDLE_VALUE then
    Exit;
  Result := GetFileSize(H, nil);
  ZeroHandle(H);
end;

function GetAPIDroppedFiles;
var
  I,
    J: Integer;
  N: Int64;
  S: string;
  SL: Integer;
begin
  Result := nil;
  N := DragQueryFile(H, $FFFFFFFF, nil, 0);
  if (N <> 0) and (N <> INVALID_HANDLE_VALUE) then
  begin
    J := N;
    SL := -1;
    for I := 0 to J - 1 do
    begin
      N := DragQueryFile(H, I, nil, 0);
      if N >= SL then
      begin
        SL := N + 1;
        SetLength(S, SL)
      end;
      DragQueryFile(H, I, PChar(S), N + 1);
      if Result = nil then
        Result := TStringColl.Create;
      Result.Add(System.Copy(S, 1, N));
    end;
  end;
end;

function WindowsDirectory: string;
begin
  SetLength(Result, MAX_PATH);
  GetWindowsDirectory(PChar(Result), MAX_PATH);
  SetLength(Result, NulSearch(Result[1]));
end;

procedure _SetErrorMsg(const S: string; N: longint); forward;

const
  CExecEmpty = 'SYS00000 Exec string is empty';

function ExecProcess;
const
  swh: array[TExecShowMode] of DWORD = (SW_HIDE, SW_SHOWMINNOACTIVE, SW_SHOWNA);
var
  SI: TStartupInfo;
  s, z: string;
begin
  if Args = '' then
  begin
    Result := False;
    _SetErrorMsg(CExecEmpty, 0);
    Exit;
  end;
  Clear(SI, SizeOf(TStartupInfo));
  SI.CB := SizeOf(SI);
  if CreationFlags and DETACHED_PROCESS = 0 then
  begin
    SI.dwFlags := STARTF_USESHOWWINDOW;
    SI.wShowWindow := swh[ShowMode];
  end;
  Result := CreateProcess(
    nil, // pointer to name of executable module
    PChar(Args), // pointer to command line string
    nil, // pointer to process security attributes
    nil, // pointer to thread security attributes
    InheritHandles, // handle inheritance flag
    CreationFlags, // creation flags
    env, // pointer to new environment block
    Dir, // pointer to current directory name
    SI, // pointer to STARTUPINFO
    PI // pointer to PROCESS_INFORMATION
    );
  if not Result then
  begin
    s := Args;
    GetWrd(s, z, ' ');
    SetErrorMsg(z);
  end;
end;

////////////////////////////////////////////////////////////////////////
//                                                                    //
//                             Objects                                //
//                                                                    //
////////////////////////////////////////////////////////////////////////

var
  MainThreadMsg: string;
  MainThreadNum: Integer;

procedure _SetErrorMsg(const S: string; N: longint);
var
  i: Integer;
  e: DWORD;
  t: T_Thread;
begin
  e := GetCurrentThreadId;
  if e = MainThreadID then
  begin
    MainThreadNum := N;
    if N <> 0 then
    begin
      MainThreadMsg := S;
    end
    else
    begin
      MainThreadMsg := '';
    end;
  end
  else
  begin
    Thr_Coll.Enter;
    for i := 0 to Thr_Coll.Count - 1 do
    begin
      t := Thr_Coll[i];
      if t.ThreadID = e then
      begin
        t.FThreadErrNum := n;
        if n <> 0 then
        begin
          t.FThreadErrMsg := s;
        end
        else
        begin
          t.FThreadErrMsg := '';
        end;
        Break;
      end;
    end;
    Thr_Coll.Leave;
  end;
end;

procedure ClearErrorMsg;
begin
  _SetErrorMsg('', 0);
end;

function SysErrorMsg(ErrorCode: Integer): string;
var
  Len: Integer;
  Buffer: array[0..255] of Char;
begin
  Len := FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM or
    FORMAT_MESSAGE_ARGUMENT_ARRAY, nil, ErrorCode, 0, Buffer,
    SizeOf(Buffer), nil);
  while (Len > 0) and (Buffer[Len - 1] in [#0..#32, '.']) do
    Dec(Len);
  SetString(Result, Buffer, Len);
end;

function FormatErrorMsg(const FName: string; e: Integer): string;
begin
  if FName = '' then
    Result := Format('SYS%.5d (%s)', [e, SysErrorMsg(e)])
  else
    Result := Format('SYS%.5d ''%s'' (%s)', [e, Copy(FName, 1, MAX_PATH),
      SysErrorMsg(e)]);
  Replace(#13#10, ' ', Result);
end;

procedure SetErrorMsg(const FName: string);
var
  e: longint;
begin
  e := GetLastError;
  _SetErrorMsg(FormatErrorMsg(FName, e), e);
end;

function GetErrorMsg: string;
var
  i: Integer;
  e: DWORD;
  t: T_Thread;
begin
  Result := '';
  e := GetCurrentThreadId;
  if e = MainThreadId then
    Result := MainThreadMsg
  else
  begin
    Thr_Coll.Enter;
    for i := 0 to Thr_Coll.Count - 1 do
    begin
      t := Thr_Coll[i];
      if t.ThreadID = e then
      begin
        Result := t.FThreadErrMsg;
        t.FThreadErrMsg := '';
        t.FThreadErrNum := 0;
        Break;
      end;
    end;
    Thr_Coll.Leave;
  end;
end;

function GetErrorNum: longint;
var
  i: Integer;
  e: DWORD;
  t: T_Thread;
begin
  Result := 0;
  e := GetCurrentThreadId;
  if e = MainThreadId then
    Result := MainThreadNum
  else
  begin
    Thr_Coll.Enter;
    for i := 0 to Thr_Coll.Count - 1 do
    begin
      t := Thr_Coll[i];
      if t.ThreadID = e then
      begin
        Result := t.FThreadErrNum;
        Break;
      end;
    end;
    Thr_Coll.Leave;
  end;
end;

function ThreadProc(Thread: T_Thread): Integer;
begin
  Thread.FExecute;
  Result := Thread.FThreadReturnValue;
  Thread.FFinished := True;
  EndThread(Result);
end;

procedure T_Thread.InvokeDone;
begin
end;

constructor T_Thread.Create;
begin
  inherited Create;
  if ThrTimesLog then
    RegisterSelf;
  FSuspended := True;
  FThreadHandle := BeginThread(nil, 0, @ThreadProc, Pointer(Self),
    CREATE_SUSPENDED, FThreadID);
  if FThreadHandle = 0 then
    GlobalFail('T_Thread.Create BeginThread Error %d', [GetLastError]);
  Thr_Coll.Enter;
  Thr_Coll.Insert(Self);
  Thr_Coll.Leave;
end;

destructor T_Thread.Destroy;
begin
  //  if not FFinished then GlobalFail('Attemt to destroy thread %s which is not finished', [ClassName]);
  FFinished := True;
  Thr_Coll.Enter;
  Thr_Coll.Delete(Self);
  Thr_Coll.Leave;
  if ThrTimesLog then
    __AddTimes;
  ZeroHandle(FThreadHandle);
  inherited Destroy;
end;

function T_Thread.GetThrErrorMsg: string;
begin
  Result := '???';
end;

const
  Priorities: array[TThreadPriority] of Integer =
  (THREAD_PRIORITY_IDLE, THREAD_PRIORITY_LOWEST, THREAD_PRIORITY_BELOW_NORMAL,
    THREAD_PRIORITY_NORMAL, THREAD_PRIORITY_ABOVE_NORMAL,
    THREAD_PRIORITY_HIGHEST, THREAD_PRIORITY_TIME_CRITICAL);

procedure T_Thread.SetPriority(Value: TThreadPriority);
begin
  SetThreadPriority(FThreadHandle, Priorities[Value]);
end;

{$IFDEF FullDebugMode}

function DebugInfo(const i: integer): string;
var
  n: integer;
begin
  Result := '';
  for n := i downto 0 do
  begin
    Result := Result + ModuleByLevel(n + 1) + '.' + ProcByLevel(n + 1) + '(' +
      IntToStr(LineByLevel(n + 1)) + '), ';
  end;
end;
{$ENDIF}

function T_Thread.WaitFor(const TimeOut: DWORD = INFINITE): DWORD;
{$IFDEF FullDebugMode}
var
  en: string;
  ii: integer;
{$ENDIF}
begin
{$IFDEF FullDebugMode}
  if (IniFile <> nil) and IniFile.logWaitEvt then
  begin
    En := Pad(ThreadName, 19) + ': WaitFor, ' + DebugInfo(3);
    EnterList.Enter;
    EnterList.Add(En);
    if (EntrLogFName <> '') and IniFile.SaveWaits then
    begin
      EnterList.SaveToFile(EntrLogFName);
    end;
    EnterList.Leave;
  end;
{$ENDIF}
  WaitForSingleObject(FThreadHandle, INFINITE);
  GetExitCodeThread(FThreadHandle, Result);
{$IFDEF FullDebugMode}
  if (IniFile <> nil) and IniFile.logWaitEvt then
  begin
    EnterList.Enter;
    ii := EnterList.IndexOf(En);
    if ii > -1 then
    begin
      EnterList.Delete(ii);
      if (EntrLogFName <> '') and IniFile.SaveWaits then
      begin
        EnterList.SaveToFile(EntrLogFName);
      end;
    end;
    EnterList.Leave;
  end;
{$ENDIF}
end;

procedure T_Thread.SetSuspended(Value: Boolean);
begin
  if Value <> FSuspended then
    if Value then
      Suspend
    else
      Resume;
end;

procedure T_Thread.Suspend;
begin
  FSuspended := True;
  SuspendThread(FThreadHandle);
end;

procedure T_Thread.Resume;
begin
  if ResumeThread(FThreadHandle) = 1 then
    FSuspended := False;
end;

{$IFDEF FullDebugMode}

procedure AnyExceptionNotify(ExceptObj: TObject; ExceptAddr: Pointer;
  OSException: Boolean);
var
  sl: TStringList;
  si: integer;
  th: DWORD;
  nm: string;
begin
  TrapCatched := True;
  th := 0;
  EnterCS(TrapLogCS);
  if ExceptObj <> nil then
  begin
    nm := ExceptObj.ClassName;
  end
  else
  begin
    nm := 'nil';
  end;
  if _LogOK(TrapLogFName, th) then
  begin
    _LogWriteStr('* ' + uFormat(uGetLocalTime) + ' v' + ProductVersion, th);
  end;
  if _LogOK(TrapLogFName, th) then
  begin
    _LogWriteStr('! ' + uFormat(uGetLocalTime) + ' obj: ' + nm + ' adr: ' + HexL(Integer(ExceptAddr)), th);
  end;
  sl := TSTringList.Create;
  sl.Add('');
  JclLastExceptStackListToStrings(sl, True, True, True);
  sl.Add('');
  for si := 0 to sl.Count - 1 do
  begin
    if _LogOK(TrapLogFName, th) then
    begin
      _LogWriteStr('! ' + uFormat(uGetLocalTime) + ' ' + sl.Strings[si], th);
    end;
  end;
  sl.Free;
  LeaveCS(TrapLogCS);
end;
{$ENDIF}

procedure ProcessTrap(const CMsg, CThreadName: string);
var
  TrapLogFHandle: DWORD;
  PI: TProcessInformation;
begin
  PlaySnd('Trap', Inifile.PlaySounds);
  Sleep(3000);
{$IFDEF FullDebugMode}
  if not TrapCatched then
  begin
    AnyExceptionNotify(nil, nil, False);
  end;
{$ENDIF}
  TrapLogFHandle := 0;
  EnterCS(TrapLogCS);
  if _LogOK(TrapLogFName, TrapLogFHandle) then
  begin
    _LogWriteStr('! ' + uFormat(uGetLocalTime) + ' v' + ProductVersion + ' [' +
      CThreadName + '] ' + CMsg, TrapLogFHandle);
  end;
  DoCreateProcess(ParamStr(0) + ' DELAY', PI, swMinimize);
  ZeroHandle(hMutex);
  ResumeThread(PI.hThread);
  ExitProcess(1);
end;

procedure ShowExceptionCallback(Buffer, Title: PChar);
var
  s: string;
begin
  s := Title + ' ' + Buffer;
  Replace(#13, ' ', s);
  Replace(#10, ' ', s);
  ProcessTrap(s, 'Unhandled');
end;

procedure AddLong(var A: TFileTime; const B: TFileTime); assembler;
asm
   mov  ecx, [edx + 0]
   add  [eax], ecx
   mov  ecx, [edx + 4]
   adc  [eax + 4], ecx
end;

procedure IncLong(var A: TFileTime); assembler;
asm
   add  DWORD ptr [eax][0], 1
   adc  DWORD ptr [eax][4], 0
end;

procedure SubLong(var A: TFileTime; const B: TFileTime); assembler;
asm
   mov  ecx, [edx + 0]
   sub  [eax], ecx
   mov  ecx, [edx + 4]
   sbb  [eax + 4], ecx
end;

var
  ThreadsLogFHandle: DWORD;

type
  TThrNfoColl = class(TSortedColl)
    function KeyOf(Item: Pointer): Pointer; override;
    function Compare(Key1, Key2: Pointer): Integer; override;
  end;

function TThrNfoColl.KeyOf(Item: Pointer): Pointer;
begin
  Result := @TThreadNfo(Item).Name;
end;

function TThrNfoColl.Compare(Key1, Key2: Pointer): Integer;
begin
  Result := CompareStr(PString(Key1)^, PString(Key2)^);
end;

var
  ThreadNfoColl: TThrNfoColl;

procedure UpdateThreadsLog;
var
  TT: TThreadTimes;
  i,
    j: Integer;
  actually: DWORD;
  c: TThrNfoColl;
  t: T_Thread;
  s {, z}: string;
  n: TThreadNfo;

  procedure DoAdd(const KernelTime, UserTime, Invoked: TFileTime; const AName:
    string);
  begin
    s := s + Format('%s%s%s %s'#13#10, [
      AddLeftSpaces(IntToStr(FileTimeToMsecs(KernelTime)), 13),
        AddLeftSpaces(IntToStr(FileTimeToMsecs(UserTime)), 13),
        AddLeftSpaces(IntToStr(Invoked.dwLowDateTime), 11),
        AName]);
  end;

begin
  if ThreadsLogFHandle = 0 then
  begin
    if not _LogOK(ThreadsLogFName, ThreadsLogFHandle) then
      GlobalFail('Failed to create %s', [ThreadsLogFName]);
  end;

  c := TThrNfoColl.Create;
  Thr_Coll.Enter;
  ThreadNfoColl.Enter;
  ThreadNfoColl.CopyItemsTo(c);
  ThreadNfoColl.Leave;
  for i := 0 to Thr_Coll.Count - 1 do
  begin
    t := Thr_Coll[i];
    s := t.ThreadName;
    if not c.Search(@s, j) then
      GlobalFail('UpdateThreadsLog Item "%s" Not Found', [s]);
    n := c[j];
    t.GetTimesEx(TT);
    AddLong(n.KernelTime, TT.KernelTime);
    AddLong(n.UserTime, TT.UserTime);
    AddLong(n.Invoked, t.FThreadInvoked);
  end;
  Thr_Coll.Leave;
  s := '    Kernel(ms)     User(ms)   Invoked'#13#10;

  if not GetThreadTimes(CurrentThreadHandle, TT.CreationTime, TT.ExitTime,
    TT.KernelTime, TT.UserTime) then
  begin
    GlobalFail('GetThreadTimes("CurrentThreadHandle",...) Error %d',
      [GetLastError]);
  end;
  DoAdd(TT.KernelTime, TT.UserTime, AppThrInvoked, 'Application');

  for i := 0 to c.Count - 1 do
  begin
    n := c[i];
    nnName := n.Name;
    DoAdd(n.KernelTime, n.UserTime, n.Invoked, n.Name);
  end;
  FreeObject(c);
  SetFilePointer(ThreadsLogFHandle, 0, nil, FILE_BEGIN);
  WriteFile(ThreadsLogFHandle, s[1], Length(s), Actually, nil);
  SetEndOfFile(ThreadsLogFHandle);
end;

function TThreadNfo.Copy: Pointer;
var
  r: TThreadNfo;
begin
  r := TThreadNfo.Create;
  r.Name := StrAsg(Name);
  r.Invoked := Invoked;
  r.KernelTime := KernelTime;
  r.UserTime := UserTime;
  Result := r;
end;

procedure T_Thread.RegisterSelf;
var
  Nfo: TThreadNfo;
  i: Integer;
  s: string;
begin
  s := StrAsg(ThreadName);
  ThreadNfoColl.Enter;
  if ThreadNfoColl.Search(@s, i) then
    Nfo := ThreadNfoColl[i]
  else
  begin
    Nfo := TThreadNfo.Create;
    Nfo.Name := s;
    ThreadNfoColl.AtInsert(i, Nfo);
  end;
  FPThreadNfo := Nfo;
  ThreadNfoColl.Leave;
end;

procedure T_Thread.GetTimesEx(var T: TThreadTimes);
begin
  if not GetThreadTimes(FThreadHandle, T.CreationTime, T.ExitTime, T.KernelTime,
    T.UserTime) then
  begin
    GlobalFail('T_Thread.__FExecute GetThreadTimes("%s",...) Error %d',
      [ClassName, GetLastError]);
  end;
end;

procedure T_Thread.__AddTimes;
var
  T: TThreadTimes;
begin
  GetTimesEx(T);
  SubLong(T.ExitTime, T.CreationTime);
  Thr_Coll.Enter;
  AddLong(FPThreadNfo.KernelTime, T.KernelTime);
  AddLong(FPThreadNfo.UserTime, T.UserTime);
  AddLong(FPThreadNfo.Invoked, FThreadInvoked);
  Thr_Coll.Leave;
end;

procedure T_Thread.__FExecute;
begin
  repeat
    IncLong(FThreadInvoked);
    InvokeExec;
  until Terminated;
  InvokeDone;
end;

procedure T_Thread.FExecute;
begin
  try
    __FExecute;
  except
    on E: Exception do
      ProcessTrap(GetThrErrorMsg + ' "' + E.Message + '"', ClassName);
  end;
end;

function CreateDosStream(const FName: string; Mode: TCreateFileModeSet):
  TDosStream;
var
  h: DWORD;
begin
  ClearErrorMsg;
  Result := nil;
  h := _CreateFile(FName, Mode);
  if h = INVALID_HANDLE_VALUE then
  begin
    SetErrorMsg(FName);
    Exit
  end;
  Result := TDosStream.Create(h);
  Result.fMode := Mode;
  Result.OwnHandle := True;
end;

function CreateDosStreamDir(const FName: string; Mode: TCreateFileModeSet):
  TDosStream;
begin
  Result := CreateDosStream(FName, Mode);
  if (Result = nil) then
  begin
    if GetLastError <> ERROR_PATH_NOT_FOUND then
      Exit
    else
    begin
      if not CreateDirInheritance(ExtractFilePath(FName)) then
        Exit;
      Result := CreateDosStream(FName, Mode);
    end;
  end;
end;

function _CreateFileDir(const FName: string; Mode: TCreateFileModeSet): DWORD;
begin
  Result := _CreateFile(FName, Mode);
  if (Result = INVALID_HANDLE_VALUE) then
  begin
    if GetLastError <> ERROR_PATH_NOT_FOUND then
    begin
      if pos('.BSY', UpperCase(FName)) = 0 then
      begin
        SetErrorMsg(FName);
      end;
      Exit;
    end
    else
    begin
      if not CreateDirInheritance(ExtractFilePath(FName)) then
        Exit;
      Result := _CreateFile(FName, Mode);
      if Result = INVALID_HANDLE_VALUE then
      begin
        SetErrorMsg(FName);
        Exit;
      end;
    end;
  end;
end;

function GetIoId(ATyp: TClass): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to ioRecColl.Count - 1 do
  begin
    if ATyp = TioRec(ioRecColl[i]).Typ then
    begin
      Result := TioRec(ioRecColl[i]).Id;
      Exit;
    end;
  end;
end;

const
  StreamKey = $33;

constructor TDosStream.Create;
begin
  inherited Create;
  Handle := AHandle;
end;

function GetMemoryStream: TxMemoryStreamEx;
begin
  Result := TxMemoryStreamEx.Create;
end;

destructor TDosStream.Destroy;
begin
  if OwnHandle then
    ZeroHandle(Handle);
  inherited Destroy;
end;

function OpenRead(const FName: string): TDosStream;
begin
  Result := CreateDosStream(FName, [cRead, cShare]);
end;

function SeekEof;
begin
  Result := SetFilePointer(Handle, 0, nil, File_End);
end;

function OpenWrite(const FName: string): TDosStream;
begin
  Result := CreateDosStream(FName, [cTruncate]);
end;

function TDosStream.Seek(Offset: Longint; Origin: Word): DWORD;
begin
  Result := SetFilePointer(Handle, Offset, nil, Origin);
end;

function TDosStream.Truncate;
begin
  Result := SetEndOfFile(Handle);
end;

function TDosStream.Read(var Buffer; Count: DWORD): DWORD;
begin
  if not ReadFile(Handle, Buffer, Count, DWORD(Result), nil) then
    Result := 0;
  Tag := Result;
end;

function TDosStream.Write;
begin
  if not WriteFile(Handle, Buffer, Count, DWORD(Result), nil) then
    Result := 0;
end;

constructor TCollError.Create(ACode, ACnt, AInfo: Integer; const AClassName:
  string);
begin
  inherited
    Create(Format('Coll Error. Code = %d, Cnt = %d Info = %d, Class = %s', [ACode,
    ACnt, AInfo, AClassName]));
end;

procedure QuickSort(SortList: PItemList; L, R: Integer; SCompare:
  TListSortCompare);
var
  I, J: Integer;
  P, T: Pointer;
begin
  repeat
    I := L;
    J := R;
    P := SortList^[(L + R) shr 1];
    repeat
      while SCompare(SortList^[I], P) < 0 do
        Inc(I);
      while SCompare(SortList^[J], P) > 0 do
        Dec(J);
      if I <= J then
      begin
        T := SortList^[I];
        SortList^[I] := SortList^[J];
        SortList^[J] := T;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then
      QuickSort(SortList, L, J, SCompare);
    L := I;
  until I >= R;
end;

{ ---- TColl ---- }

procedure TColl.Sort(Compare: TListSortCompare);
begin
  if (FList <> nil) and (Count > 0) then
    QuickSort(FList, 0, Count - 1, Compare);
end;

function TColl.Copy;
begin
  Result := TColl.Create;
  CopyItemsTo(TColl(Result));
end;

procedure TColl.CopyItemsTo;
var
  i: Integer;
begin
  Coll.FreeAll;
  for i := 0 to Count - 1 do
    Coll.AtInsert(Coll.Count, CopyItem(At(i)));
end;

function TColl.Name;
begin
  Result := FName;
end;

function TColl.CopyItem(AItem: Pointer): Pointer;
begin
  Result := TAdvCpObject(AItem).Copy;
end;

procedure TColl.Concat(AColl: TColl);
var
  i: Integer;
begin
  AColl.Enter;
  try
    Enter;
    try
      for i := 0 to AColl.Count - 1 do
        Insert(AColl[i]);
    finally
      Leave;
    end;
    AColl.DeleteAll;
  finally
    AColl.Leave;
  end;
end;

var
  CollCS: TRTLCriticalSection;

procedure TColl.Enter;
var
  j: integer;
begin
  if CollCS.DebugInfo = nil then
    exit;
  Windows.EnterCriticalSection(CollCS);
  j := 1;
  Xchg(Shared, j);
  if j = 0 then
    InitializeCriticalSection(CS);
  Windows.LeaveCriticalSection(CollCS);
  EnterCS(CS);
end;

procedure TColl.Leave;
begin
  if CS.DebugInfo = nil then
    exit;
  LeaveCS(CS);
end;

procedure EnterCS(var CS: TRTLCriticalSection);
{$IFDEF FullDebugMode}
var
  s: string;
  e: string;
  i: integer;
{$ENDIF}
begin
  if CS.DebugInfo = nil then
  begin
    exit;
  end;
{$IFDEF FullDebugMode}
  if (IniFile <> nil) and IniFile.logWaitEvt then
  begin
    EnterList.Enter;
    s := 'EnterCS, ' + IntToStr(Integer(CS.DebugInfo)) + ', ' + DebugInfo(3);
    EnterList.Add(Pad('Enter_(pre)', 19) + ': ' + s);
    if (EntrLogFName <> '') and IniFile.SaveWaits then
    begin
      EnterList.SaveToFile(EntrLogFName);
    end;
    EnterList.Leave;
  end;
{$ENDIF}
  Windows.EnterCriticalSection(CS);
{$IFDEF FullDebugMode}
  if (IniFile <> nil) and IniFile.logWaitEvt then
  begin
    EnterList.Enter;
    e := Pad('Enter', 19) + ': ' + s;
    for i := EnterList.Count - 1 downto 0 do
    begin
      if pos(Pad('Enter_(pre)', 19) + ': EnterCS, ' +
        IntToStr(Integer(CS.DebugInfo)), EnterList[i]) > 0 then
      begin
        EnterList[i] := e;
        break;
      end;
    end;
    if (EntrLogFName <> '') and IniFile.SaveWaits then
    begin
      EnterList.SaveToFile(EntrLogFName);
    end;
    EnterList.Leave;
  end;
{$ENDIF}
end;

procedure LeaveCS(var CS: TRTLCriticalSection);
{$IFDEF FullDebugMode}
var
  i: integer;
{$ENDIF}
begin
  if CS.DebugInfo = nil then
    exit;
  Windows.LeaveCriticalSection(CS);
{$IFDEF FullDebugMode}
  if (IniFile <> nil) and IniFile.logWaitEvt then
  begin
    EnterList.Enter;
    for i := 0 to EnterList.Count - 1 do
    begin
      if pos(Pad('Enter', 19) + ': EnterCS, ' + IntToStr(Integer(CS.DebugInfo)),
        EnterList[i]) > 0 then
      begin
        EnterList.Delete(i);
        break;
      end;
    end;
    if (EntrLogFName <> '') and IniFile.SaveWaits then
    begin
      EnterList.SaveToFile(EntrLogFName);
    end;
    EnterList.Leave;
  end;
{$ENDIF}
end;

procedure PurgeCS;
begin
  if CS.DebugInfo = nil then
    exit;
  if CS.LockCount > -1 then
  begin
    while CS.LockCount > -1 do
      LeaveCS(CS);
  end;
  DeleteCriticalSection(CS);
end;

procedure TColl.ForEach(Proc: TForEachProc);
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    Proc(FList^[I]);
end;

function TColl.Crc32;
var
  i: Integer;
begin
  Result := Init;
  for i := 0 to Count - 1 do
  begin
    Result := Crc32Item(FList^[i], Result);
  end;
end;

function TColl.Crc32Item(Item: Pointer; Crc32: DWORD): DWORD;
begin
  Result := Crc32;
end;

procedure TColl.PutItem;
begin
  Stream.Put(Item);
end;

function TColl.GetItem;
begin
  Result := Pointer(Stream.Get);
end;

constructor TColl.Load;
var
  lDelta,
    lCount: DWORD;
  i: Integer;
  P: Pointer;
begin
{$IFDEF FullDebugMode}
  if Debug = nil then
    Debug := TEnterList.Create;
{$ENDIF}
  lDelta := Stream.ReadDWORD;
  DoInit(lDelta * 2, lDelta);
  lCount := Stream.ReadDWORD;
  if lCount = 0 then
    Exit;
  for i := 0 to lCount - 1 do
  begin
    P := GetItem(Stream);
    if P <> nil then
      AtInsert(Count, P);
  end;
end;

procedure TColl.Store;
var
  i: Integer;
begin
  Stream.WriteDWORD(FDelta);
  Stream.WriteDWORD(Count);
  for i := 0 to Count - 1 do
  begin
    PutItem(Stream, At(i));
  end;
end;

constructor TColl.Create;
begin
  inherited Create;
  fName := ClassName;
{$IFDEF FullDebugMode}
  Debug := TEnterList.Create;
{$ENDIF}
  DoInit(32, 64);
end;

constructor TColl.Create(const n: string);
begin
  inherited Create;
  fName := n;
{$IFDEF FullDebugMode}
  Debug := TEnterList.Create;
{$ENDIF}
  DoInit(32, 64);
end;

procedure TColl.DoInit(ALimit, ADelta: Integer);
begin
  FList := nil;
  FCount := 0;
  FCapacity := 0;
  FDelta := ADelta;
  SetCapacity(ALimit);
end;

destructor TColl.Destroy;
begin
  FreeAll;
  SetCapacity(0);
{$IFDEF FullDebugMode}
  FreeObject(Debug);
{$ENDIF}
  if Shared = 1 then
    PurgeCS(CS);
  inherited Destroy;
end;

function TColl.At(Index: Integer): Pointer;
var
  err: boolean;
begin
  err := false;
  try
    if (Index < 0) or (Index >= FCount) then
      err := true;
    Result := FList^[Index];
  except
    Result := nil
  end;
  if err then
    Error(coIndexError, FCount, Index);
end;

procedure TColl.AtDelete(Index: Integer);
begin
  if (Index < 0) or (Index >= FCount) then
    Error(coIndexError, FCount, Index);
  Dec(FCount);
  if Index < FCount then
    System.Move(FList^[Index + 1], FList^[Index], (FCount - Index) *
      SizeOf(Pointer));
end;

procedure TColl.AtFree(Index: Integer);
var
  Item: Pointer;
begin
  Item := At(Index);
  FreeItem(Item);
  AtDelete(Index);
end;

procedure TColl.AtInsert(Index: Integer; Item: Pointer);
begin
  if (Index < 0) or (Index > FCount) then
    Error(coIndexError, FCount, Index);
  if FCount = Integer(FCapacity) then
    SetCapacity(FCapacity + FDelta);
  if Index < FCount then
    System.Move(FList^[Index], FList^[Index + 1], (FCount - Index) *
      SizeOf(Pointer));
  FList^[Index] := Item;
  Inc(FCount);
end;

procedure TColl.AtPut(Index: Integer; Item: Pointer);
begin
  if (Index < 0) or (Index >= FCount) then
    Error(coIndexError, FCount, Index);
  FList^[Index] := Item;
end;

procedure TColl.Delete(Item: Pointer);
var
  i: integer;
begin
  Enter;
  i := IndexOf(Item);
  if i > -1 then
  begin
    AtDelete(i);
  end;
  Leave;
end;

procedure TColl.DeleteAll;
begin
  FCount := 0;
end;

procedure TColl.Error(Code, Cnt, Info: Integer);
begin
  asm nop
  end;
  raise TCollError.Create(Code, Cnt, Info, ClassName);
end;

procedure TColl.FFree(Item: Pointer);
begin
  Delete(Item);
  FreeItem(Item);
end;

procedure TColl.FreeAll;
var
  I: Integer;
begin
  Enter;
  for I := 0 to FCount - 1 do
  begin
    FreeItem(At(I));
  end;
  Leave;
  FCount := 0;
end;

procedure TColl.FreeItem(Item: Pointer);
begin
  TObject(Item).Free;
end;

function TColl.IndexOf(Item: Pointer): Integer;
begin
  Result := 0;
  while (Result < FCount) and (FList^[Result] <> Item) do
    Inc(Result);
  if Result = FCount then
    Result := -1;
end;

procedure TColl.Insert(Item: Pointer);
begin
  AtInsert(FCount, Item);
end;

procedure TColl.Add(Item: Pointer);
begin
  AtInsert(FCount, Item);
end;

procedure TColl.Pack;
var
  I: Integer;
begin
  for I := FCount - 1 downto 0 do
    if Items[I] = nil then
      AtDelete(I);
end;

procedure TColl.SetCapacity;
begin
  if NewCapacity = 0 then
  begin
    FreeMem(FList, FCapacity);
    FList := nil;
    Exit;
  end;
  if (Integer(NewCapacity) < FCount) or (NewCapacity > MaxCollSize) then
    Error(coOverflow, FCount, NewCapacity);
  if NewCapacity <> FCapacity then
  begin
    ReallocMem(FList, NewCapacity * SizeOf(Pointer));
    FCapacity := NewCapacity;
  end;
end;

procedure TColl.MoveTo(CurIndex, NewIndex: Integer);
var
  Item: Pointer;
begin
  if CurIndex <> NewIndex then
  begin
    if (NewIndex < 0) or (NewIndex >= FCount) then
      Error(coIndexError, FCount, NewIndex);
    Item := FList^[CurIndex];
    AtDelete(CurIndex);
    AtInsert(NewIndex, Item);
  end;
end;

{ TSortedColl }

function TSortedColl.IndexOf(Item: Pointer): Integer;
var
  I: Integer;
begin
  IndexOf := -1;
  if Search(KeyOf(Item), I) then
  begin
    if Duplicates then
      while (I < Count) and {(Item <> FList^[I])}(Compare(Item, FList^[I]) <> 0) do
        Inc(I);
    if I < Count then
      IndexOf := I;
  end;
end;

procedure TSortedColl.Insert(Item: Pointer);
var
  I: Integer;
begin
  if not Search(KeyOf(Item), I) or Duplicates then
    AtInsert(I, Item)
  else
    FreeItem(Item);
end;

function TSortedColl.Search(Key: Pointer; var Index: Integer): Boolean;
var
  L,
    H,
    I,
    C: Integer;
begin
  Search := False;
  L := 0;
  H := Count - 1;
  while L <= H do
  begin
    I := (L + H) shr 1;
    C := Compare(KeyOf(FList^[I]), Key);
    if C < 0 then
      L := I + 1
    else
    begin
      H := I - 1;
      if C = 0 then
      begin
        Search := True;
        if not Duplicates then
          L := I;
      end;
    end;
  end;
  Index := L;
end;

{ TioRecColl }

function TioRecColl.KeyOf(Item: Pointer): Pointer;
begin
  KeyOf := @TioRec(Item).Id;
end;

function TioRecColl.Compare(Key1, Key2: Pointer): Integer;
begin
  Result := Integer(Key1^) - Integer(Key2^);
end;

{ TStringColl }

constructor TStringColl.Create;
begin
  inherited;
  fObjects := TColl.Create;
end;

constructor TStringColl.Create(const n: string);
begin
  inherited;
  fObjects := TColl.Create;
end;

destructor TStringColl.Destroy;
begin
  FreeObject(fObjects);
  inherited;
end;

function TStringColl.LongString: string;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to Count - 1 do
    Result := Result + Strings[i] + #13#10;
end;

function TStringColl.LongStringD(c: char): string;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to Count - 2 do
    Result := Result + Strings[i] + c;
  for i := MaxI(0, Count - 1) to Count - 1 do
    Result := Result + Strings[i];
end;

function TStringColl.LongStringS(const s: string): string;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to Count - 2 do
    Result := Result + Strings[i] + s;
  for i := MaxI(0, Count - 1) to Count - 1 do
    Result := Result + Strings[i];
end;

procedure TStringColl.FillEnum(Str: string; Delim: TCharSet; Sorted: Boolean);
var
  Z: string;
  i: integer;
  d: Char;
begin
  while Str <> '' do
  begin
    d := ' ';
    for i := 1 to Length(Str) do
    begin
      if Str[i] in Delim then
      begin
        d := Str[i];
        break;
      end;
    end;
    GetWrd(Str, Z, d);
    if Sorted then
      InsD(Z)
    else
      Add(Z);
  end;
end;

function TStringColl.Found(const Str: string): Boolean;
var
  i: Integer;
begin
  Result := Search(@Str, I);
end;

function TStringColl.Matched(const Str: string): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Count - 1 do
  begin
    if pos(UpperCase(Str), UpperCase(Self[i])) = 1 then
    begin
      Result := i;
      exit;
    end;
  end;
end;

function TStringColl.IdxOfUC(const Str: string): Integer;
var
  us: string;
  i: Integer;
begin
  us := UpperCase(Str);
  Result := -1;
  for i := 0 to Count - 1 do
    if us = UpperCase(Strings[i]) then
    begin
      Result := i;
      Exit
    end;
end;

function TStringColl.FoundUC(const Str: string): Boolean;
begin
  Result := IdxOfUC(Str) <> -1;
end;

function TStringColl.LoadFromFile(const FName: string): Boolean;
var
  T: TTextReader;
begin
  Result := False;
  T := CreateTextReader(FName);
  if T = nil then
    Exit;
  Result := LoadFromTextReader(T);
  FreeObject(T);
end;

function TStringColl.LoadFromStream(Stream: TxStream): Boolean;
var
  T: TTextReader;
begin
  Result := False;
  T := CreateTextReaderByStream(Stream);
  if T = nil then
    Exit;
  Result := LoadFromTextReader(T);
  FreeObject(T);
end;

function TStringColl.LoadFromString(const s: string): Boolean;
var
  M: TxMemoryStream;
begin
  M := TxMemoryStream.Create;
  M.FSize := Length(s);
  M.FMemory := @s[1];
  Result := LoadFromStream(M);
  M.FMemory := nil;
  M.FSize := 0;
  FreeObject(M);
end;

function TStringColl.LoadFromTextReader;
begin
  if not KeepOnLoad then
    FreeAll;
  while not T.EOF do
    Add(T.GetStr);
  Result := True;
end;

function TStringColl.Copy;
begin
  Result := TStringColl.Create;
  CopyItemsTo(TColl(Result));
end;

function TStringColl.CopyItem(AItem: Pointer): Pointer;
begin
  Result := NewStr(StrAsg(PString(AItem)^));
end;

function TStringColl.Crc32Item(Item: Pointer; Crc32: DWORD): DWORD;
begin
  Result := Crc32Str(PString(Item)^, Crc32);
end;

procedure TStringColl.PutItem;
begin
  Stream.WriteStr(Pstring(Item)^);
end;

function TStringColl.GetItem;
begin
  Result := NewStr(Stream.ReadStr);
end;

function TStringColl.KeyOf(Item: Pointer): Pointer;
begin
  KeyOf := Item;
end;

procedure TStringColl.Concat(AColl: TStringColl);
var
  i: Integer;
begin
  for i := 0 to AColl.Count - 1 do
    AtInsert(Count, AColl.At(I));
  AColl.DeleteAll;
end;

procedure TStringColl.AppendTo(AColl: TStringColl);
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    AColl.Add(StrAsg(Strings[i]));
end;

procedure TStringColl.Fill(const AStrs: array of string);
var
  i: Integer;
begin
  FreeAll;
  for i := Low(AStrs) to High(AStrs) do
    Add(AStrs[i]);
end;

function TStringColl.IdxOf(const Item: string): Integer;
begin
  Result := IndexOf(@Item);
end;

function TStringColl.SaveToStream;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to FCount - 1 do
  begin
    if not Stream.WriteLn(Strings[i]) then
      Exit;
  end;
  Result := True;
end;

function TStringColl.SaveToFile(const FileName: string): Boolean;
var
  T: TDosStream;
begin
  Result := False;
  T := OpenWrite(FileName);
  if T = nil then
    Exit;
  T.Truncate;
  Result := SaveToStream(T);
  FreeObject(T);
end;

procedure TStringColl.AlignObjects;
begin
  while fObjects.Count < Count do
    fObjects.Add(nil);
end;

procedure TStringColl.SetString(Index: Integer; const Value: string);
begin
  FreeItem(At(Index));
  AtPut(Index, NewStr(StrAsg(Value)));
end;

function TStringColl.GetString(Index: Integer): string;
begin
  Result := PString(At(Index))^;
end;

procedure TStringColl.SetObject(Index: Integer; const Value: pointer);
begin
  AlignObjects;
  fObjects[Index] := Value;
end;

function TStringColl.GetObject(Index: Integer): pointer;
begin
  AlignObjects;
  Result := fObjects[Index];
end;

function TStringColl.Compare(Key1, Key2: Pointer): Integer;
begin
  if IgnoreCase then
    Result := CompareText(PString(Key1)^, PString(Key2)^)
  else
    Result := CompareStr(PString(Key1)^, PString(Key2)^);
end;

procedure TStringColl.FreeItem(Item: Pointer);
begin
  DisposeStr(Item);
end;

procedure TStringColl.AtIns(Index: Integer; const Item: string);
begin
  AtInsert(Index, NewStr(StrAsg(Item)));
end;

procedure TStringColl.Add(const S: string);
begin
  AtInsert(Count, NewStr(StrAsg(S)));
end;

procedure TStringColl.Ins0(const S: string);
begin
  AtInsert(0, NewStr(StrAsg(S)));
end;

procedure TStringColl.Ins(const S: string);
begin
  Insert(NewStr(StrAsg(S)));
end;

procedure TStringColl.InsD(const S: string);
var
  I: Integer;
begin
  if Duplicates then
    Ins(S)
  else
  begin
    if not Search(@S, I) then
      AtInsert(I, NewStr(StrAsg(s)));
  end;
end;

{ --- TextReader }

function CreateTextReader(const FName: string): TTextReader;
begin
  Result := CreateTextReaderByStream(OpenRead(FName));
  if Result <> nil then
    Result.OwesStream := True;
end;

function CreateTextReaderByStream(Stream: TxStream): TTextReader;
var
  FileSz: Integer;
begin
  Result := nil;
  if Stream = nil then
    Exit;
  FileSz := Stream.Size;
  if FileSz = -1 then
    Exit;
  Result := TTextReader.Create;
  Result.FileSz := FileSz;
  Result.Stream := Stream;
  if FileSz = 0 then
    Result.Eof := True
  else
  begin
    Result.BufSz := MinD(FileSz, TextReaderBufSize);
    if Stream.Read(Result.Buf, Result.BufSz) <> Result.BufSz then
      FreeObject(Result);
  end;
end;

function TTextReader.GetStr: string;
var
  CurLen,
    BufBeg: DWORD;
  Was: Boolean;

  procedure DoAddStr(var s: string; DoDec: Boolean);
  var
    Grow: DWORD;
  begin
    Grow := (BufPos - BufBeg) - Byte(Was);
    if DoDec then
      Dec(Grow);
    if Grow > 0 then
    begin
      SetLength(s, CurLen + Grow);
      Move(Buf[BufBeg], s[CurLen + 1], Grow);
      Inc(CurLen, Grow);
    end;
  end;

var
  PrevC,
    C: Char;

begin
  Result := '';
  if Eof then
    Exit;
  PrevC := #0;
  CurLen := 0;
  BufBeg := BufPos;
  Was := False;
  SavPos := FilePos;
  repeat
    if BufPos = BufSz then
    begin
      DoAddStr(Result, False);
      BufSz := Stream.Read(Buf, TextReaderBufSize);
      if BufSz <= 0 then
      begin
        Eof := True;
        Break;
      end;
      BufPos := 0;
      BufBeg := 0;
      if Was then
      begin
        Skip1 := True;
        Break
      end;
    end;
    C := Buf[BufPos];
    Inc(BufPos);
    Inc(FilePos);
    case C of
      #10, #13:
        begin
          if Skip1 then
          begin
            BufBeg := BufPos;
            Skip1 := False;
            Continue;
          end;
          if Was then
          begin
            DoAddStr(Result, True);
            Dec(BufPos, Integer(PrevC = C));
            Dec(FilePos, Integer(PrevC = C));
            Break;
          end
          else
            Was := True;
          PrevC := C;
        end;
    else
      begin
        if Was then
        begin
          DoAddStr(Result, True);
          Dec(BufPos);
          Dec(FilePos);
          Break;
        end;
        Skip1 := False
      end;
    end;
  until False;
  if FilePos >= FileSz then
    Eof := True;
end;

destructor TTextReader.Destroy;
begin
  if OwesStream then
    FreeObject(Stream);
  inherited Destroy;
end;

procedure FreeObject(var O);
var
  OO: TObject absolute O;
  XX: TObject;
begin
  if TObject(O) <> nil then
  begin
    if TObject(O) is TColl then
    begin
      (TObject(O) as TColl).Enter;
      (TObject(O) as TColl).Leave;
    end;
  end;
  XX := nil;
  XChg(Integer(OO), Integer(XX));
  TObject(XX).Free;
end;

////////////////////////////////////////////////////////////////////////
//                                                                    //
//                       Rectangle Routines                           //
//                                                                    //
////////////////////////////////////////////////////////////////////////

function _InflateRect;
begin
  Result.Left := R.Left + X;
  Result.Right := R.Right - X;
  Result.Top := R.Top + Y;
  Result.Bottom := R.Bottom - Y;
end;

function _EmptyRect(const R: TRect): Boolean;
begin
  Result := (R.Left = 0) and (R.Right = 0) and (R.Top = 0) and (R.Bottom = 0);
end;

function _OffsetRect(const R: TRect; X, Y: Integer): TRect;
begin
  Result.Left := R.Left + X;
  Result.Right := R.Right + X;
  Result.Top := R.Top + Y;
  Result.Bottom := R.Bottom + Y;
end;

////////////////////////////////////////////////////////////////////////
//                                                                    //
//                              Dialogs                               //
//                                                                    //
////////////////////////////////////////////////////////////////////////

procedure MsgBoxCallback(HelpInfo: PHELPINFO); stdcall;
begin
  _PostMessage(Application.Handle, CM_INVOKEHELP, HELP_CONTEXT,
    HelpInfo.dwContextId);
end;

var
  MsgFrm: TForm;
  MsgPan: TPanel;
  CaptionPan: TPanel;
  MsgLabel: TLabel;
  Timer: TTimer;
  Text: string;
  prevwndproc: pointer;
  c: integer;
  idt: integer;

procedure WinDlgT;
var
  n2: TNotifyEvent;
  n3: TKeyPressEvent;

  procedure msgpanonClick(Sender: TObject);
  begin
    killtimer(0, idt);
    MsgFrm.Close;
    MsgFrm.ModalResult := mrOK;
  end;

  procedure timerontimer(Sender: TObject);
  begin
    dec(c);
    if c <= 0 then
    begin
      if (timer <> nil) then
        Timer.Enabled := false;
      if (MsgFrm <> nil) then
      begin
        MsgFrm.Release;
        MsgFrm.ModalResult := mrOK;
      end;
      exit;
    end;
    try
      if (MsgFrm <> nil) and (MsgLabel <> nil) then
        MsgLabel.Caption := Format('%s [%d]', [text, c]);
    except
      if (timer <> nil) then
        Timer.Enabled := false;
    end;
  end;

  procedure msgpanonKeyPress(Sender: TObject; var Key: Char);
  begin
    msgpanonclick(sender);
  end;

begin
  MsgFrm := TForm.Create(Application);
  text := s;
  MsgFrm.Width := Length(S) * 6;
  MsgFrm.Height := 100;
  MsgFrm.Position := poScreenCenter;
  MsgFrm.BorderStyle := bsNone;
  n3 := nil;
  @n3 := @msgpanonKeyPress;
  MsgFrm.OnKeyPress := n3;
  c := SendMessage(MainWinHandle, WM_GETWINDLGT, 0, 0);

  n2 := nil;

  CaptionPan := TPanel.Create(MsgFrm);
  //  CaptionPan.AutoSize := true;
  CaptionPan.BevelInner := bvRaised;
  CaptionPan.BevelOuter := bvLowered;
  @n2 := @msgpanonClick;
  CaptionPan.OnClick := n2;
  CaptionPan.Parent := MsgFrm;
  CaptionPan.Width := MsgFrm.Width - 1;
  CaptionPan.Height := 20;
  CaptionPan.Align := alTop;
  CaptionPan.Caption := 'Message';
  CaptionPan.ParentBackground := false;
  CaptionPan.Color := clNavy;
  CaptionPan.Font.Color := clWhite;

  n2 := nil;

  MsgPan := TPanel.Create(MsgFrm);
  MsgPan.AutoSize := true;
  MsgPan.BevelInner := bvRaised;
  MsgPan.BevelOuter := bvLowered;
  @n2 := @msgpanonClick;
  MsgPan.OnClick := n2;
  MsgPan.Parent := MsgFrm;
  MsgPan.Width := MsgFrm.Width - 1;
  MsgPan.Height := MsgFrm.Height - 1;
  MsgPan.Align := alClient;

  Timer := TTimer.Create(MsgFrm);
  @n2 := @timerontimer;
  Timer.OnTimer := n2;
  Timer.Interval := 1000;

  MsgLabel := TLabel.Create(MsgPan);
  @n2 := @msgpanonClick;
  MsgLabel.OnClick := n2;
  MsgLabel.AutoSize := true;
  MsgLabel.Caption := Format('%s [%d]', [text, c]);
  MsgFrm.Width := MsgLabel.Width + 20;
  MsgFrm.Height := MsgLabel.Height + 50 + 20;

  MsgLabel.Parent := MsgPan;
  MsgLabel.Left := MsgFrm.Width div 2 - MsgLabel.Width div 2;
  //  MsgLabel.Top := MsgPan.Height div 2 - MsgLabel.Height div 2 - 20;
  MsgLabel.Top := MsgFrm.Height div 2 - MsgLabel.Height div 2 - 10;
  MsgLabel.Alignment := taCenter;

  //  idt:=SetTimer(0, GetTickCount, 1000, @TimerProc);
  MsgFrm.ShowModal;
  if (MsgLabel <> nil) then
    MsgLabel.Free;
  if (timer <> nil) then
    Timer.Free;
  if (MsgPan <> nil) then
    MsgPan.Free;
  if (CaptionPan <> nil) then
    CaptionPan.Free;
  if (MsgFrm <> nil) then
    MsgFrm.Release;
end;

function WinDlgCapHlp;
var
  p: TMSGBOXPARAMS;
begin
  Clear(p, SizeOf(p));
  p.cbSize := SizeOf(p);
  p.hwndOwner := AHandle;
  p.hInstance := hInstance;
  p.lpszText := PChar(S);
  p.lpszCaption := PChar(Caption);
  p.dwStyle := MB_SETFOREGROUND or MB_TASKMODAL or Flags;
  if (Application = nil) or (AHelpCtx = 0) then
    p.dwStyle := p.dwStyle or MB_TOPMOST
  else
  begin
    p.dwContextHelpId := AHelpCtx;
    p.lpfnMsgBoxCallback := @MsgBoxCallback;
  end;
  p.dwLanguageId := HelpLanguageId;
  Result := Integer(Windows.MessageBoxIndirect(p));
end;

function WinDlgCap;
begin
  Result := WinDlgCapHlp(S, Flags, AHandle, Caption, 0);
end;

function WinDlg;
var
  Caption: string;
begin
  if (AHandle = 0) {and (Application <> nil)} then
    AHandle := GetActiveWindow {Application.Handle};
  if AHandle = 0 then
    Caption := ''
  else
  begin
    SetLength(Caption, 81);
    GetWindowText(AHandle, PChar(Caption), 80);
  end;
  Result := WinDlgCap(S, Flags, AHandle, Caption);
end;

procedure DisplayError;
begin
  WinDlgT(Msg);
end;

procedure DisplayInformation;
begin
  WinDlgT(Msg);
end;

procedure DisplayCustomInfo;
begin
  WinDlgT(Msg);
end;

procedure DisplayWarning;
begin
  WinDlgT(Msg);
end;

function YesNoWarning(const Msg: string; AHandle: DWORD): Boolean;
begin
  Result := WinDlg(Msg, MB_YESNO or MB_ICONWARNING, AHandle) = idYes;
end;

function YesNoConfirm;
begin
  YesNoConfirm := WinDlg(Msg, MB_YESNO or MB_ICONQUESTION, AHandle) = idYes;
end;

function OkCancelConfirm(const Msg: string; AHandle: DWORD): Boolean;
begin
  Result := WinDlg(Msg, MB_OKCANCEL or MB_ICONQUESTION, AHandle) = idOK;
end;

function DeleteEmptyDirInheritance(S: string; const StopOn: string): Integer;
var
  us: string;
begin
  us := UpperCase(StopOn);
  Result := 0;
  while (UpperCase(S) <> us) and RemoveDirectory(PChar(S)) do
  begin
    Inc(Result);
    S := ExtractFileDir(S);
  end;
end;

function CreateDirInheritance;
var
  L: DWORD;
  z: string;
begin
  ClearErrorMsg;
  Result := True;
  if S = '' then
    Exit;
  S := ExpandFileName(S);
  L := Length(S);
  if L <= 3 then
    Exit;
  if S[L] = '\' then
    SetLength(S, L - 1);
  L := GetFileAttributes(PChar(S));
  if L <> INVALID_HANDLE_VALUE then
    Result := (L and FILE_ATTRIBUTE_DIRECTORY <> 0)
  else
  begin
    case GetLastError of
      ERROR_PATH_NOT_FOUND,
        ERROR_FILE_NOT_FOUND:
        begin
          z := ExtractFilePath(S);
          if z = S then
            Result := False
          else
          begin
            Result := CreateDirInheritance(z);
            if Result then
            begin
              Result := CreateDirectory(PChar(S), nil) = TRUE;
              if not Result then
                SetErrorMsg(S);
            end;
          end;
        end
    else
      begin
        SetErrorMsg(S);
        Result := False;
      end;
    end;
  end;
  S := '';
end;

function DirExists(S: string): Integer;
var
  L: DWORD;
begin
  S := ExpandFileName(S);
  if StrEnds(':\', S) then
  begin
    if GetDriveType(PChar(S)) in [0..1] then
      Result := -1
    else
      Result := 1;
    Exit;
  end;
  if StrEnds('\', S) then
    DelLC(S);
  L := GetFileAttributes(PChar(S));
  if L = INVALID_HANDLE_VALUE then
  begin
    case GetLastError of
      ERROR_FILE_NOT_FOUND,
        ERROR_PATH_NOT_FOUND: Result := 0
    else
      Result := -1;
    end;
  end
  else
  begin
    if L and FILE_ATTRIBUTE_DIRECTORY = 0 then
      Result := -1
    else
      Result := 1;
  end;
end;

const
  CMonths = 'JanFebMarAprMayJunJulAugSepOctNovDec';
  Months: string[Length(CMonths)] = CMonths;

  CMonths2 = 'JnFbMrApMyJnJlAgSpOcNvDc';
  Months2: string[Length(CMonths2)] = CMonths2;

  CDOWs = 'SunMonTueWedThuFriSat';
  DOWS: string[Length(CDOWs)] = CDOWs;

  CDOWs2 = 'SuMoTuWeThFrSa';
  DOWs2: string[Length(CDOWs2)] = CDOWs2;

function MonthE(m: Integer): string;
begin
  Result := Copy(Months, 1 + (m - 1) * 3, 3);
end;

function MonthE2(m: Integer): string;
begin
  Result := Copy(Months2, 1 + (m - 1) * 2, 2);
end;

function DOWE(d: Integer): string;
begin
  Result := Copy(DOWs, 1 + d * 3, 3);
end;

function DOWE2(d: Integer): string;
begin
  Result := Copy(DOWs2, 1 + d * 2, 2);
end;

procedure GetBias;
var
  T, L: TFileTime;
  a, b: DWORD;
begin
  GetSystemTimeAsFileTime(T);
  FileTimeToLocalFileTime(T, L);
  a := uCvtGetFileTime(T.dwLowDateTime, T.dwHighDateTime);
  b := uCvtGetFileTime(L.dwLowDateTime, L.dwHighDateTime);
  TimeZoneBias := Integer(a) - Integer(b);
end;

procedure xBaseInit;
begin

  if (Win32Platform = VER_PLATFORM_WIN32_NT) then
    LoadNTDyn;

  if Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
    NTdyn_SetProcessShutdownParameters($3FF, 0);
  end;

  oShutdown := CreateEvt(False);
  oRecalcEvents := CreateEvtA;

  InitializeCriticalSection(TrapLogCS);

  GetBias;

  {--- Init CRCs }
  InitCRC16PropTable;
  InitCRC16UsdTable;
  InitCRC32Table;

  InitRBOTable;

  Thr_Coll := TColl.Create('Thr_Coll');
  if ThrTimesLog then
    ThreadNfoColl := TThrNfoColl.Create('ThreadNfoColl');
  ioRecColl := TioRecColl.Create('ioRecColl');

  Randomize;

  InitEventWaiter;

end;

function ReadRegString(Key: HKey; const AStrName: string): string;
var
  l, t, e: Integer;
  z: ShortString;
begin
  z[0] := #250;
  l := 250;
  t := REG_SZ;
  e := RegQueryValueEx(
    Key, // handle of key to query
    PChar(AStrName), // value to query
    nil, // reserved
    @t, // value type
    @z[1], // data buffer
    @l // buffer size
    );
  if e <> ERROR_SUCCESS then
    Result := ''
  else
  begin
    Result := Copy(z, 1, NulSearch(z[1]));
  end;
end;

var
  FCompleteFilter: string;
  xRegExtensions: TStringColl;

function _GetCompleteFilter: string;
const
  ClassBufSize = 1000;
var
  Buf: array[0..ClassBufSize] of Char;
  ds: TDblString;
  sc,
    ks: TDblStringColl;
  SubKey,
    Key: HKEY;
  BufSize: DWORD; // size of string buffer
  s,
    z: string;
  i,
    ec,
    cSubKeys, // number of subkeys
    cchMaxSubkey, // longest subkey name length
    cchMaxClass, // longest class string length
    cValues, // number of value entries
    cchMaxValueName, // longest value name length
    cbMaxValueData, // longest value data length
    cbSecurityDescriptor: Integer; // security descriptor length
  ftLastWriteTime: TFileTime; // last write time
begin
  xRegExtensions := TStringColl.Create;
  Result := '';
  if RegOpenKeyEx(HKEY_CLASSES_ROOT, nil, 0, KEY_QUERY_VALUE or
    KEY_ENUMERATE_SUB_KEYS, Key) <> ERROR_SUCCESS then
    Exit;
  BufSize := ClassBufSize;
  ec := RegQueryInfoKey(
    Key, // handle of key to query
    @Buf,
    @BufSize,
    nil,
    @cSubKeys,
    @cchMaxSubkey,
    @cchMaxClass,
    @cValues,
    @cchMaxValueName,
    @cbMaxValueData,
    @cbSecurityDescriptor,
    @ftLastWriteTime);
  if ec <> ERROR_SUCCESS then
  begin
    RegCloseKey(Key);
    Exit;
  end;
  sc := TDblStringColl.Create;
  sc.Duplicates := True;
  ks := TDblStringColl.Create;
  for i := 0 to cSubKeys - 1 do
  begin
    BufSize := ClassBufSize;
    ec := RegEnumKeyEx(
      Key,
      i,
      Buf,
      BufSize,
      nil,
      nil, // address of buffer for class string
      nil, // address for size of class buffer
      @ftLastWriteTime);
    if ec <> ERROR_SUCCESS then
      Continue;
    SetString(s, Buf, BufSize);
    if RegOpenKeyEx(
      HKEY_CLASSES_ROOT, // handle of an open key
      PChar(s), // subkey name
      0, // Reserved
      KEY_QUERY_VALUE,
      SubKey
      ) <> ERROR_SUCCESS then
      Continue;
    z := ReadRegString(SubKey, '');
    RegCloseKey(SubKey);
    if z = '' then
      Continue;
    ds := TDblString.Create;
    if (s <> '') and (s[1] = '.') then
    begin
      ds.Key := z;
      ds.Value := s;
      sc.Add(ds);
      DelFC(s);
      xRegExtensions.Ins(UpperCase(s));
    end
    else
    begin
      ds.Key := s;
      ds.Value := z;
      ks.Insert(ds);
    end;
  end;
  RegCloseKey(Key);
  for i := 0 to sc.Count - 1 do
  begin
    ds := sc[i];
    s := ds.Value;
    z := ds.Key;
    if (s = '') or (s[1] <> '.') then
      Continue;
    if not ks.Search(@z, ec) then
      Continue;
    ds := ks[ec];
    z := ds.Value;
    s := Format('%s (*%s)|*%s', [z, s, s]);
    if Result <> '' then
      s := '|' + s;
    Result := Result + s;
    Inc(CompleteFilterIndex);
  end;
  FreeObject(sc);
  FreeObject(ks);
end;

procedure UpdateCompleteFilter;
begin
  FCompleteFilter := _GetCompleteFilter;
  if FCompleteFilter <> '' then
    FCompleteFilter := FCompleteFilter + '|';
  FCompleteFilter := FCompleteFilter + 'All Files (*.*)|*.*';
  Inc(CompleteFilterIndex);
end;

function GetCompleteFilter: string;
begin
  if FCompleteFilter = '' then
    UpdateCompleteFilter;
  Result := FCompleteFilter;
end;

function xIsReg(Ext: string): Boolean;
var
  J: Integer;
begin
  Result := False;
  if (Ext = '') or (Ext[1] <> '.') then
    Exit;
  DelFC(Ext);
  Ext := UpperCase(Ext);
  if FCompleteFilter = '' then
    UpdateCompleteFilter;
  Result := xRegExtensions.Search(@Ext, J);
end;

procedure xBaseDone;
begin
  TickThr.Terminated := True;
  EventWaiterThr.Terminated := True;
  SetEvent(EventWaiterThr.hActivate);
  Finalize(FCompleteFilter);
  FreeObject(xRegExtensions);
  TickThr.WaitFor;
  FreeObject(TickThr);
  EventWaiterThr.WaitFor;
  FreeObject(EventWaiterThr);
  if Thr_Coll.Count <> 0 then
    GlobalFail('xBaseDone while ThreadCount=%d', [Thr_Coll.Count]);
  FreeObject(Thr_Coll);
  FreeObject(ThreadNfoColl);
  FreeObject(ioRecColl);
  PurgeCS(TrapLogCS);
  ZeroHandle(oShutdown);
  ZeroHandle(oRecalcEvents);
  ZeroHandle(ThreadsLogFHandle);
end;

procedure RegisterIoRec(Typ: TAdvClass; Id: Integer);
var
  ioRec: TioRec;
begin
  ioRec := TioRec.Create;
  ioRec.Typ := Typ;
  ioRec.Id := Id;
  ioRecColl.Insert(ioRec);
end;

type
  EGlobalFailure = class(EAccessViolation)
  end;

procedure DoFail(const AMessage: string; const AParams: array of const);
begin
  raise EGlobalFailure.Create('GF ' + Format(AMessage, AParams));
end;

function GlobalFail;
begin
  Result := 0;
  DoFail(AMessage, AParams);
end;

function StrQuotePartEx(const s: string; OldC, NewC, NewC1: Char): string;
var
  i: Integer;
  StopC,
    c: Char;
  q: Integer;
begin
  StopC := #0;
  if Pos(OldC, s) <= 0 then
  begin
    Result := s;
    Exit
  end;
  Result := '';
  q := 0;
  for i := 1 to Length(s) do
  begin
    c := s[i];
    case q of
      0:
        begin
          if c = OldC then
            q := 1
          else
            Result := Result + c;
        end;
      1:
        begin
          if c = OldC then
          begin
            Result := Result + NewC1;
            q := 0;
          end
          else
          begin
            StopC := c;
            Result := Result + NewC;
            q := 2;
          end;
        end;
    else
      begin
        if c = StopC then
        begin
          Result := Result + NewC;
          q := 0;
        end
        else
        begin
          Result := Result + Hex2(Byte(c));
        end;
      end;
    end;
  end;
end;

function _MatchMask(const AName: string; const AMask: string; SupportPercent:
  Boolean): Boolean;
var
  s,
    z: string;
  HiC,
    c: Char;
  i,
    j: Integer;
  re: RRegExp.TPcre;
begin
  HiC := #0;
  s := StrQuotePartEx(AMask, '~', #3, #4);
{$IFDEF ALLOW_LOCAL_MASKS}
  if (Pos(#3, s) = 0) then
  begin
    Replace(#4, '~', s);
    Result := _MatchMaskLocal(AName, s, SupportPercent);
    Exit;
  end;
{$ENDIF}
  j := 0;
  z := '';
  for i := 1 to Length(s) do
  begin
    c := s[i];
    case j of
      0:
        case c of
          #3: j := 1;
          #4: z := z + '~';
          '*': z := z + '.*';
          '?': z := z + '.';
          '%': if SupportPercent then
              z := z + '\d'
            else
              z := z + c;
          'a'..'z', 'A'..'Z', '0'..'9': z := z + c;
        else
          z := z + '\x' + Hex2(Byte(c));
        end;
      1:
        begin
          HiC := c;
          j := 2;
        end;
      2:
        begin
          z := z + Char(VlH(HiC + c));
          j := 3;
        end;
      3:
        begin
          if c = #3 then
            j := 0
          else
          begin
            HiC := c;
            j := 2;
          end;
        end;
    end;
  end;

  RE := GetRegExpr('(?i)^' + z + '$');
  RE.PattOptions := [poCaseLess];
  Result := (RE.ErrPtr = 0) and (RE.Match(AName) > 0) and (RE[0] <> '');
  RE.Unlock;
end;

function MatchMask(const AName, AMask: string): Boolean;
begin
  Result := _MatchMask(AName, AMask, False);
end;

function UpdateDetailsBox(AB: TListView; AC: TColl): Boolean;
var
  I,
    C: Integer;
  S: TStringColl;
  V: TListItem;
  UI: Boolean;

begin
  Result := False;
  C := AB.Items.Count;
  UI := True;
  if C < AC.Count then
    for I := C to AC.Count - 1 do
      AB.Items.Add
  else if C > AC.Count then
    for I := C - 1 downto AC.Count do
      AB.Items.Delete(I)
  else
    UI := False;
  for I := 0 to AC.Count - 1 do
  begin
    S := AC[I];
    V := AB.Items[I];
    if UI then
      V.SubItems.Clear;
    if V.SubItems.Count = 0 then
    begin
      Result := True;
      for C := 1 to S.Count - 1 do
        V.SubItems.Add(S[C])
    end
    else
    begin
      for C := 1 to S.Count - 1 do
        if V.SubItems[C - 1] <> S[C] then
        begin
          Result := True;
          V.SubItems[C - 1] := S[C];
        end;
    end;
    if (V.Caption <> S[0]) then
      V.Caption := S[0];
  end;
  if Result then
  begin
    AB.Items.BeginUpdate;
    AB.Items.EndUpdate
  end;
end;

procedure AddVIntArr(var A: TvIntArr; i: Integer);
begin
  Inc(A.Cnt);
  ReallocMem(A.Arr, A.Cnt * SizeOf(Integer));
  A.Arr^[A.Cnt - 1] := i;
end;

procedure FreeVIntArr(var A: TvIntArr);
begin
  if A.Arr <> nil then
    ReallocMem(A.Arr, 0);
end;

function CreateTCollEL(const n: string): TColl;
begin
  Result := TColl.Create(n);
end;

function GetEnvVariable(const Name: string): string;
const
  BufSize = 128;
var
  Buf: array[0..BufSize] of Char;
  I: DWORD;
begin
  I := GetEnvironmentVariable(PChar(Name), Buf, BufSize);
  case I of
    1..BufSize:
      begin
        SetLength(Result, I);
        Move(Buf, Result[1], I);
      end;
    BufSize + 1..High(I):
      begin
        SetLength(Result, I + 1);
        GetEnvironmentVariable(PChar(Name), @Result[1], I);
        SetLength(Result, I);
      end;
  else
    begin
      Result := '';
    end;
  end;
end;

function ControlString(C: TControl): string;
var
  i: Integer;
begin
  i := C.GetTextLen;
  if i = 0 then
    Result := ''
  else
  begin
    SetLength(Result, i + 2);
    C.GetTextBuf(@Result[1], i + 1);
    SetLength(Result, i);
  end;
end;

function GetHelpFile(const HomePath: string; const Lng: string): string;
const
  ext: array[boolean] of string = ('hlp', 'chm');
begin
  Result := MakeNormName(HomePath, Format('Taurus%s.%s', [Lng, ext[IsHtmlHelp and
    not HtmlHelpLibError]]));
end;

function DivideDash(const S: string): string;
begin
  Result := S;
  Insert('-', Result, (Length(S) div 2) + 1);
end;

procedure CollDeleteAll;
begin
  if C <> nil then
    C.DeleteAll;
end;

function CollCount;
begin
  if C = nil then
    Result := 0
  else
    Result := C.Count;
end;

function CollMax;
begin
  Result := CollCount(C) - 1;
end;

procedure MoveColl(Src, Dst: TColl; Idx: Integer);
begin
  if Idx = -1 then
    Exit;
  Dst.Insert(Src[Idx]);
  Src.AtDelete(Idx);
end;

function Crc32Str(const S: string; Crc32: DWORD): DWORD;
var
  i,
    j: Integer;
begin
  Result := Crc32;
  j := Length(s);
  Result := UpdateCrc32(j, Result);
  for i := 1 to j do
    Result := UpdateCrc32(Byte(s[i]), Result);
end;

function TempFileName(const APath, APfx: string): string;
var
  s: string;
begin
  SetLength(s, 1000);
  GetTempFileName(PChar(APath), PChar(APfx), 0, @s[1]);
  Result := Copy(s, 1, NulSearch(s[1]));
end;

function CreateTempFile(const APath, APfx: string; var FName: string): Integer;
begin
  FName := TempFileName(APath, APfx);
  Result := _CreateFile(FName, [cWrite, cExisting]);
end;

function DoCreateProcess;
begin
  Result := ExecProcess(s, PI, nil, nil, False, CREATE_SUSPENDED, ShowMode);
end;

constructor TAdvCpOnlyObject.Load(Stream: TxStream);
begin
  GlobalFail('Attemp to load %s which is TAdvCpOnlyObject', [ClassName]);
end;

procedure TAdvCpOnlyObject.Store(Stream: TxStream);
begin
  GlobalFail('Attemp to store %s which is TAdvCpOnlyObject', [ClassName]);
end;

procedure _LogWriteStr(const AStr: string; var FHandle: DWORD);
var
  S: string;
  J: DWORD;
begin
  S := AStr + #13#10;
  WriteFile(FHandle, S[1], Length(S), J, nil);
  if StartupOptions and stoFastLog = 0 then
    ZeroHandle(FHandle);
end;

function _LogOK(const Name: string; var Handle: DWORD): Boolean;
begin
  if (Handle = 0) or (Handle = INVALID_HANDLE_VALUE) then
  begin
    Handle := _CreateFileDir(Name, [cWrite, cCanPending]);
    if Handle <> INVALID_HANDLE_VALUE then
      if SeekEof(Handle) = INVALID_FILE_SIZE then
      begin
        ZeroHandle(Handle);
        Handle := INVALID_HANDLE_VALUE
      end;
  end
  else
  begin
    if StartupOptions and stoFastLog = 0 then
    begin
      if Handle <> INVALID_HANDLE_VALUE then
        GlobalFail('Log %s is already opened, Handle = %d', [Name, Handle]);
    end;
  end;
  Result := (Handle <> INVALID_HANDLE_VALUE) and (Handle <> 0);
end;

function TxStream.WriteA(const Buffer; Count, A: DWORD): DWORD;
const
  MaxA = 4;
var
  MMod,
    PPos: DWORD;
  Fill: array[0..MaxA] of Byte;
  R: DWORD;
begin
  if A > MaxA then
    GlobalFail('TxStream.WriteA  A(%d) > MaxA(%d)', [A, MaxA]);
  PPos := Position;
  MMod := PPos mod A;
  R := 0;
  if MMod > 0 then
  begin
    Clear(Fill, MMod);
    Inc(R, Write(Fill, MMod));
  end;
  Inc(R, Write(Buffer, Count));
  Result := R;
end;

function TxStream.WriteA4(const Buffer; Count: DWORD): DWORD;
begin
  Result := WriteA(Buffer, Count, 4);
end;

function TxStream.GetPosition: DWORD;
begin
  Result := Seek(0, 1);
end;

procedure TxStream.SetPosition(Pos: DWORD);
begin
  Seek(Pos, 0);
end;

function TxStream.GetSize: DWORD;
var
  Pos: DWORD;
begin
  Pos := Seek(0, 1);
  Result := Seek(0, 2);
  Seek(Pos, 0);
end;

function TxStream.CopyFrom(Source: TxStream; Count: DWORD): DWORD;
const
  MaxBufSize = $F000;
var
  BufSize, N: DWORD;
  Buffer: PChar;
begin
  if Count = 0 then
  begin
    Source.Position := 0;
    Count := Source.Size;
  end;
  Result := Count;
  if Count > MaxBufSize then
    BufSize := MaxBufSize
  else
    BufSize := Count;
  GetMem(Buffer, BufSize);
  try
    while Count <> 0 do
    begin
      if Count > BufSize then
        N := BufSize
      else
        N := Count;
      Source.Read(Buffer^, N);
      Write(Buffer^, N);
      Dec(Count, N);
    end;
  finally
    FreeMem(Buffer, BufSize);
  end;
end;

function TxCustomMemoryStream.GetMemory: Pointer;
begin
  Result := FMemory;
  if Result = nil then
    GlobalFail('%s', ['TxCustomMemoryStream.GetMemory=nil']);
end;

procedure TxCustomMemoryStream.SetPointer(Ptr: Pointer; Size: Integer);
begin
  FMemory := Ptr;
  FSize := Size;
end;

function TxCustomMemoryStream.Read(var Buffer; Count: DWORD): DWORD;
begin
  Result := FSize - FPosition;
  if Result > 0 then
  begin
    if Result > Count then
      Result := Count;
    Move(Pointer(DWORD(FMemory) + FPosition)^, Buffer, Result);
    Inc(FPosition, Result);
    Exit;
  end;
  Result := 0;
end;

function TxCustomMemoryStream.Seek(Offset: Integer; Origin: Word): DWORD;
begin
  case Origin of
    0: FPosition := Offset;
    1: Inc(FPosition, Offset);
    2: FPosition := DWORD(Integer(FSize) + Offset);
  end;
  Result := FPosition;
end;

function TxCustomMemoryStream.SaveToStream(Stream: TxStream): Boolean;
begin
  if FSize = 0 then
    Result := True
  else
    Result := Stream.Write(FMemory^, FSize) = FSize;
end;

function TxCustomMemoryStream.SaveToFile(const FileName: string): Boolean;

  function DoSave: Boolean;
  var
    Stream: TDosStream;
  begin
    Result := False;
    Stream := OpenWrite(FileName);
    if Stream = nil then
      Exit;
    Stream.Truncate;
    Result := SaveToStream(Stream);
    FreeObject(Stream);
  end;

begin
  ClearErrorMsg;
  Result := DoSave;
  if not Result then
    SetErrorMsg(FileName);
end;

{ TxMemoryStream }

const
  MemoryDelta = $2000; { Must be a power of 2 }

destructor TxMemoryStream.Destroy;
begin
  Clear;
  inherited Destroy;
end;

procedure TxMemoryStream.Clear;
begin
  SetCapacity(0);
  FSize := 0;
  FPosition := 0;
end;

procedure TxMemoryStream.LoadFromStream(Stream: TxStream);
var
  Count: Integer;
begin
  Stream.Position := 0;
  Count := Stream.Size;
  SetSize(Count);
  if Count <> 0 then
    Stream.Read(FMemory^, Count);
end;

procedure TxMemoryStream.LoadFromFile(const FileName: string);
var
  Stream: TxStream;
begin
  Stream := OpenRead(FileName);
  if Stream = nil then
    Exit;
  LoadFromStream(Stream);
  Stream.Free;
end;

procedure TxMemoryStream.SetCapacity(NewCapacity: DWORD);
begin
  SetPointer(Realloc(NewCapacity), FSize);
  FCapacity := NewCapacity;
end;

procedure TxMemoryStream.SetSize(NewSize: DWORD);
begin
  Clear;
  SetCapacity(NewSize);
  FSize := NewSize;
end;

function TxMemoryStream.Realloc(var NewCapacity: DWORD): Pointer;
begin
  if NewCapacity > 0 then
    NewCapacity := (NewCapacity + (MemoryDelta - 1)) and not (MemoryDelta - 1);
  Result := FMemory;
  if NewCapacity <> FCapacity then
  begin
    if NewCapacity = 0 then
    begin
      GlobalFreePtr(FMemory);
      Result := nil;
    end
    else
    begin
{$WARNINGS off}
      if Capacity = 0 then
        Result := GlobalAllocPtr(HeapAllocFlags, NewCapacity)
      else
        Result := GlobalReallocPtr(FMemory, NewCapacity, HeapAllocFlags);
{$WARNINGS on}
    end;
  end;
end;

function TxMemoryStream.Write(const Buffer; Count: DWORD): DWORD;
var
  Pos: DWORD;
begin
  Pos := FPosition + Count;
  if Pos > 0 then
  begin
    if Pos > FSize then
    begin
      if Pos > FCapacity then
        SetCapacity(Pos);
      FSize := Pos;
    end;
    System.Move(Buffer, Pointer(DWORD(FMemory) + FPosition)^, Count);
    FPosition := Pos;
    Result := Count;
    Exit;
  end;
  Result := 0;
end;

constructor TxMemoryStreamEx.Create;
begin
  inherited;
  Addition := TxMemoryStream.Create;
  nVersion := 1;
end;

destructor TxMemoryStreamEx.Destroy;
begin
  FreeObject(Addition);
  inherited;
end;

procedure TxMemoryStreamEx.LoadFromFile;
var
  b: byte;
begin
  inherited;
  Addition.LoadFromFile(ChangeFileExt(FileName, '.add'));
  Addition.Seek(-3, soFromEnd);
  b := Addition.ReadByte;
  if b = $FF then
  begin
    oVersion := Addition.ReadInteger;
  end;
  Addition.SetPosition(0);
end;

function TxMemoryStreamEx.SaveToFile;
var
  b: byte;
begin
  result := false;
  if inherited SaveTofile(FileName) then
  begin
    b := $FF;
    Addition.WriteByte(b);
    Addition.WriteByte(nVersion);
    b := 0;
    Addition.WriteByte(b);
    Result := Addition.SaveToFile(ChangeFileExt(FileName, '.add'));
  end;
end;

procedure TxStream.WriteDWORD(I: DWORD);
var
  j,
    nb: Integer;
  b: Byte;
begin
  nb := NumBits(I);
  for j := (nb - 1) div 7 downto 1 do
  begin
    b := ((i shr (j * 7)) and $7F) or $80;
    Write(b, 1);
  end;
  b := I and $7F;
  Write(b, 1);
end;

function TxStream.ReadDWORD: DWORD;
var
  b: Byte;
begin
  Result := 0; // 5 times
  Read(b, 1);
  Result := (Result shl 7) or (b and $7F);
  if b < $80 then
    Exit;
  Read(b, 1);
  Result := (Result shl 7) or (b and $7F);
  if b < $80 then
    Exit;
  Read(b, 1);
  Result := (Result shl 7) or (b and $7F);
  if b < $80 then
    Exit;
  Read(b, 1);
  Result := (Result shl 7) or (b and $7F);
  if b < $80 then
    Exit;
  Read(b, 1);
  Result := (Result shl 7) or (b and $7F);
  if b < $80 then
    Exit;
end;

procedure TxStream.WriteInteger(I: Integer);
begin
  WriteDWORD(DWORD(i));
end;

function TxStream.ReadInteger: Integer;
begin
  Result := Integer(ReadDWORD);
end;

procedure TxStream.WriteByte(B: Byte);
begin
  Write(B, 1);
end;

function TxStream.ReadByte: Byte;
begin
  Read(Result, 1);
end;

procedure TxStream.WriteBool(B: Boolean);
begin
  Write(B, 1);
end;

function TxStream.ReadBool: Boolean;
begin
  Read(Result, 1);
end;

function TxStream.ReadStr;
var
  I: DWORD;
begin
  I := ReadDWORD;
  SetLength(Result, I);
  if I > 0 then
    Read(Result[1], I);
end;

procedure TxStream.WriteStr;
var
  I: DWORD;
begin
  I := Length(s);
  WriteDWORD(I);
  if I > 0 then
    Write(s[1], I);
end;

function TxStream.WriteLn;
var
  i: DWORD;
begin
  s := s + #13#10;
  i := Length(s);
  Result := Write(s[1], i) = i;
end;

procedure TxStream.Put(AObject: TAdvObject);
var
  L: Integer;
  P,
    NewP: DWORD;
begin
  L := GetIoId(AObject.ClassType);
  if L = -1 then
    GlobalFail('Writing unregistered class %s', [AOBject.ClassName]);
  WriteDWORD(L);
  WriteDWORD(L xor StreamKey);
  P := Position;
  Write(L, 4);
  AObject.Store(Self);
  NewP := Position;
  L := NewP - (P + 4);
  Position := P;
  Write(L, 4);
  Position := NewP;
end;

function TxStream.Get: Pointer;
var
  id,
    dlen,
    curpos: DWORD;
  i: Integer;
  o: TAdvClass;
  b: Boolean;
begin
  Result := nil;
  id := ReadDWORD;
  if ReadDWORD <> id xor StreamKey then
    Exit;
  Read(dlen, 4);
  curpos := Position;
  b := ioRecColl.Search(@id, i);
  if b then
  begin
    o := TIoRec(ioRecColl[i]).Typ;
    Result := o.Load(Self);
    if Position <> curpos + dlen then
      GlobalFail('Error loading %s', [o.ClassName]);
  end
  else
  begin
    Position := curpos + dlen;
  end;
  if FreeLastLoaded then
  begin
    FreeLastLoaded := False;
    FreeObject(Result);
  end;
end;

function NumBits(I: DWORD): DWORD; assembler;
asm
   bsr eax, eax
   jz  @z
   inc eax
@z:
end;

var
  xRandSeed: DWORD;

function xRandom32: DWORD; assembler;
asm
   mov     eax, xRandSeed
   mov     edx, 08088405h
   mul     edx
   inc     eax
   mov     xRandSeed, eax
end;

function xRandom(a: DWORD): DWORD; assembler;
asm
   mov     ecx, eax
   call    xRandom32
   mul     ecx
   mov     eax, edx
end;

function StrBegsU(const Substr, S: string): Boolean;
begin
  Result := UpperCase(Copy(S, 1, Length(SubStr))) = Substr;
end;

function StrBegsF(const Substr: string; SubstrLen: Integer; const S: string;
  SLen: Integer): Boolean;
begin
  Result := (SLen >= SubstrLen) and MemEqu(Substr[1], S[1], SubstrLen);
end;

function UnpackStrEx(var s: string; QuoteChar: string): Boolean;
var
  r: string;
  c: char;
  i,
    h,
    l,
    sl: Integer;
begin
  Result := False;
  i := 0;
  if Length(QuoteChar) > 1 then
  begin
    Replace(QuoteChar, '%', s);
    QuoteChar := '%';
  end;
  sl := Length(s);
  while i < sl do
  begin
    Inc(i);
    c := s[i];
    if c = QuoteChar then
    begin
      if i > sl - 2 then
        Exit;
      if (length(QuoteChar) = 2) and (UpCase(s[i + 1]) = UpCase(QuoteChar[2])) then
        inc(i);
      l := Pos(UpCase(s[i + 2]), rrHiHexChar) - 1;
      h := Pos(UpCase(s[i + 1]), rrHiHexChar) - 1;
      if (h = -1) or (l = -1) then
        Exit;
      r := r + Chr(h shl 4 or l);
      Inc(i, 2);
      Continue;
    end;
    r := r + c;
  end;
  s := r;
  Result := True;
end;

function UnpackRFC1945(var s: string): Boolean;
begin
  Result := UnpackStrEx(s, '%');
end;

function StrDeQuote(var s: string): Boolean;
begin
  Result := UnpackStrEx(s, '\x');
end;

function PackStrEx(const s: string; Chars: TCharSet; const QuoteChar: string):
  string;
var
  r: string;
  c: Char;
  i: Integer;
begin
  r := '';
  for i := 1 to Length(s) do
  begin
    c := s[i];
    if (c < ' ') or (c in Chars) or (c = QuoteChar[1]) then
      R := R + QuoteChar + Hex2(Byte(c))
    else
      R := R + c;
  end;
  Result := r;
end;

function PackRFC1945(const s: string; Chars: TCharSet): string;
begin
  Result := PackStrEx(s, Chars, '%');
end;

function StrQuote(const s: string): string;
begin
  Result := PackStrEx(s, [#0..#255] - charset, '\x');
end;

function TDblStringColl.Compare(Key1, Key2: Pointer): Integer;
begin
  if IgnoreCase then
    Result := CompareText(PString(Key1)^, PString(Key2)^)
  else
    Result := CompareStr(PString(Key1)^, PString(Key2)^);
end;

function TDblStringColl.KeyOf(Item: Pointer): Pointer;
begin
  Result := @TDblString(Item).Key;
end;

function FormatBinkPMsg(Id: Byte; const Msg: string): string;
var
  Len: Word;
begin
  Len := (Length(Msg) + 2) or bdK32;
  Result := Char(Hi(Len)) + Char(Lo(Len)) + Char(Id) + Msg + #0;
end;

function Vl10z2(const s: string): DWORD;
var
  a,
    b,
    i: DWORD;
  c: Char;
const
  ti: array[1..10] of DWORD = (
    1000000000,
    100000000,
    10000000,
    1000000,
    100000,
    10000,
    1000,
    100,
    10,
    1);
begin
  Result := INVALID_VALUE;
  a := 0;
  for i := 10 downto 1 do
  begin
    C := s[i];
    if (C < '0') or (C > '9') then
      Exit; // wrong digit
    b := DWORD((DWORD(Ord(C)) - DWORD(Ord('0')))) * ti[i];
    if High(Result) - a < b then
      Exit; // overflow
    Inc(a, b);
  end;
  Result := a;
end;

function Vl(const s: string): DWORD;
var
  a,
    i,
    l: DWORD;
  c: Char;
begin
  Result := INVALID_VALUE;
  l := Length(s);
  case l of
    0: Exit;
    1: case s[1] of
        '0'..'9':
          begin
            Result := Ord(s[1]) - Ord('0');
            Exit
          end;
      else
        Exit;
      end;
    2..9: ;
    10: case s[1] of
        '0'..'1': ;
        '2':
          begin
            Result := Vl10z2(s);
            Exit
          end;
      else
        Exit;
      end;
  end;
  a := 0;
  for i := 1 to l do
  begin
    C := s[i];
    if (C < '0') or (C > '9') then
      Exit;
    a := a * 10 + Ord(C) - Ord('0');
  end;
  Result := a;
end;

function VlH(const s: string): DWORD;
var
  a,
    i,
    L,
    start: DWORD;
  c: Char;
begin
  Result := INVALID_VALUE;
  L := Length(s);
  start := 0;
  if (L = 0) then
    Exit;
  while (start < L - 1) and (s[start + 1] = '0') do
    Inc(start);
  if (L - start > 8) then
    Exit;
  a := 0;
  for i := 1 + start to L do
  begin
    C := s[i];
    a := a shl 4;
    case C of
      '0'..'9': Inc(a, Ord(C) - Ord('0'));
      'A'..'F': Inc(a, Ord(C) - Ord('A') + 10);
      'a'..'f': Inc(a, Ord(C) - Ord('a') + 10);
    else
      Exit;
    end;
  end;
  Result := a;
end;

function VlX(const s: string): DWORD;
var
  a,
    i,
    l: DWORD;
  c: Char;
begin
  Result := INVALID_VALUE;
  l := Length(s);
  if (l = 0) or (l > 8) then
    Exit;
  a := 0;
  for i := 1 to l do
  begin
    C := s[i];
    a := a shl 5;
    case C of
      '0'..'9': Inc(a, Ord(C) - Ord('0'));
      'A'..'V': Inc(a, Ord(C) - Ord('A') + 10);
      'a'..'v': Inc(a, Ord(C) - Ord('a') + 10);
    else
      Exit;
    end;
  end;
  Result := a;
end;

procedure SetEvt(oEvt: THandle);
begin
  if not SetEvent(oEvt) then
    GlobalFail('SetEvent(%d) Error %d', [oEvt, GetLastError]);
end;

procedure ResetEvt(oEvt: THandle);
begin
  if not ResetEvent(oEvt) then
    GlobalFail('ResetEvent(%d) Error %d', [oEvt, GetLastError]);
end;

function _GetComputerName: string;
var
  b: array[0..MAX_COMPUTERNAME_LENGTH + 1] of Char;
  s: string;
  i: DWORD;
begin
  Result := '';
  i := MAX_COMPUTERNAME_LENGTH;
  if not GetComputerName(@b, i) then
    Exit;
  SetString(s, b, i);
  Result := s;
end;

procedure BlockRBO(var Buf; Count: Integer);
var
  p: PxByteArray;
  i: Integer;
begin
  p := @Buf;
  for i := 0 to Count - 1 do
    p^[i] := RBOTable[p^[i]];
end;

var
  FWheelScrollLines: DWORD;
  FWheelScrollLinesGot: Boolean;

function WheelScrollLines: Integer;
begin
  if not FWheelScrollLinesGot then
  begin
    FWheelScrollLinesGot := True;
    if not SystemParametersInfo(SPI_GETWHEELSCROLLLINES, 0, @FWheelScrollLines,
      0) then
      FWheelScrollLines := WHEEL_PAGESCROLL;
  end;
  Result := FWheelScrollLines;
end;

procedure GetWheelCommands(ADelta: Integer; var ScrollCode, Count: Integer);
const
  CCode: array[Boolean] of array[Boolean] of Integer = ((SB_LINEDOWN,
    SB_LINEUP), (SB_PAGEDOWN, SB_PAGEUP));
var
  dir,
    page: Boolean;
  lines: DWORD;
begin
  dir := ADelta > 0;
  if not dir then
    ADelta := -ADelta;
  lines := WheelScrollLines;
  page := lines = WHEEL_PAGESCROLL;
  if page then
    lines := 1;
  ScrollCode := CCode[page, dir];
  Count := (ADelta * Integer(lines)) div WHEEL_DELTA;
end;

function StrAsg(const Src: string): string;
begin
  if Src = '' then
    Result := ''
  else
  begin
    SetLength(Result, Length(Src));
    Move(Src[1], Result[1], Length(Src));
  end;
end;

function ItoS(I: DWORD): string;
begin
  Str(I, Result);
end;

function ItoSz(I: DWORD; Width: Integer): string;
begin
  Result := ItoS(I);
  while Length(Result) < Width do
    Result := '0' + Result;
  Result := Copy(Result, 1, Width);
end;

function RFCDateStr(const D: TSystemTime): string;
var
  s: string;
begin
  GetBias;
  s := Format('%4.4d', [-TimeZoneBias div 36]);
  if Length(s) = 4 then
    s := '+' + s;
  Result :=
    DowE(D.wDayOfWeek) + ', ' +
    ItoSz(D.wDay, 2) + ' ' +
    MonthE(D.wMonth) + ' ' +
    ItoS(D.wYear) + ' ' +
    ItoSz(D.wHour, 2) + ':' +
    ItoSz(D.wMinute, 2) + ':' +
    ItoSz(D.wSecond, 2) + ' ' + s; //according to RFC 2822
end;

function RFCDateStr: string;
var
  D: TSystemTime;
begin
  GetSystemTime(D);
  Result := RFCDateStr(D);
end;

function RFCDateUTC: string;
var
  D: TSystemTime;
begin
  GetSystemTime(D);
  Result := RFCDateStr(D);
end;

function RFCDateStr(const D: DWORD): string;
var
  S: TSystemTime;
  T: TDateTime;
begin
  T := FileDateToDateTime(D);
  DateTimeToSystemTime(T, S);
  Result := RFCDateStr(S);
end;

type
  TRegExpColl = class(TSortedColl)
    function KeyOf(Item: Pointer): Pointer; override;
    function Compare(Key1, Key2: Pointer): Integer; override;
  end;

var
  RegExpList: TRegExpColl;

function TRegExpColl.KeyOf(Item: Pointer): Pointer;
begin
  KeyOf := @(TPCRE(Item).FPatt);
end;

function TRegExpColl.Compare(Key1, Key2: Pointer): Integer;
begin
  Result := CompareStr(PString(Key1)^, PString(Key2)^);
end;

procedure FreeRegExprList;
var
  r: TPCRE;
begin
  if RegExpList = nil then
    exit;
  RegExpList.Enter;
  while RegExpList.Count > 0 do
  begin
    r := RegExpList[0];
    r.Lock;
    r.Unlock;
    RegExpList.AtFree(0);
  end;
  RegExpList.Leave;
  FreeObject(RegExpList);
end;

function GetRegExpr(const APattern: string {; AOptions: TPattOptions}): Pointer;
var
  i: Integer;
  s: string;
  r: TPCRE;
  b: boolean;
begin
  result := nil;
  EnterCS(CollCS);
  if RegExpList = nil then
    RegExpList := TRegExpColl.Create('RegExpList');
  LeaveCS(CollCS);
  RegExpList.Enter;
  s := APattern;
  b := RegExpList.Search(@s, i);
  if b then
  begin
    r := RegExpList[i];
    Result := r;
  end;
  if (result = nil) or (not b) then
  begin
    Result := TPCRE.Create;
    TPCRE(Result).Initializing := False;
    TPCRE(Result).Pattern := APattern;
    RegExpList.AtInsert(i, Result);
  end;

  RegExpList.Leave;
  if result = nil then
    exit;
  TPCRE(Result).Lock;
end;

procedure DbgStr;
begin
  OutputDebugString(PChar(Format(FormatStr, Args)));
end;

function EscapeChars;
var
  i: integer;
begin
  result := '';
  for i := 1 to length(S) do
  begin
    if (S[i] < ' ') or (S[i] > 'z') then
      result := result + Format('\%.2x', [ord(S[i])])
    else
      result := result + S[i];
  end;
end;

{$IFDEF FullDebugMode}

constructor TEnterList.Create;
begin
  inherited;
  InitializeCriticalSection(CS);
end;

destructor TEnterList.Destroy;
begin
  while CS.LockCount > -1 do
    Leave;
  DeleteCriticalSection(CS);
end;

procedure TEnterList.Enter;
begin
  EnterCriticalSection(CS);
end;

procedure TEnterList.Leave;
begin
  LeaveCriticalSection(CS);
end;

procedure TEnterList.SaveToFile(const N: string);
var
  Stream: TStream;
begin
  if ExistFile(N) then
  begin
    Stream := TFileStream.Create(N, fmOpenWrite or fmShareDenyWrite);
  end
  else
  begin
    Stream := TFileStream.Create(N, fmCreate or fmShareDenyWrite);
  end;
  try
    SaveToStream(Stream);
    Stream.Size := Stream.Position;
  finally
    Stream.Free;
  end;
end;
{$ENDIF}

procedure SetHotKey;
var
  k: word;
  m: word;
  s: TShiftState;
begin
  ShortCutToKey(IniFile.PopupKey, k, s);
  m := 0;
  if ssAlt in s then
    m := m or MOD_ALT;
  if ssCtrl in s then
    m := m or MOD_CONTROL;
  if ssShift in s then
    m := m or MOD_SHIFT;
  HotKeySet := RegisterHotKey(MainWinHandle, 700, m, k);
end;

procedure FreeHotKey;
begin
  if HotKeySet then
    UnregisterHotKey(MainWinHandle, 700);
end;

var
  date: TDateTime;

function TTextReader.GetPosition: int64;
begin
  Result := SavPos;
end;

procedure TTextReader.SetPosition(ofs: int64);
begin
  Stream.Position := ofs;
  FilePos := ofs;
  BufPos := 0;
  Bufsz := 0;
end;

function StripTmp(const n: string): string;
begin
  Result := n;
  if pos('.TMP', UpperCase(n)) = Length(n) - 3 then
  begin
    Result := copy(n, 1, Length(n) - 4);
  end;
end;

{Version routines}

function GetJustFileVersion: string;
var
  j, w: Cardinal;
  s: shortstring;
  buf: pointer;
  buf2: pointer;
  q: DWORD;
  vsinfo: ^VS_FIXEDFILEINFO;
  mVer,
  lVer,
  rVer,
  bVer: DWORD;
//  flag: DWORD;
begin
  s := ParamStr(0) + #0;
  j := GetFileVersionInfoSize(@s[1], w);
  if j = 0 then
    Exit;
  buf := Ptr(GlobalAlloc(GMEM_FIXED, j));
  GetFileVersionInfo(@s[1], 0, j, buf);
  VerQueryValue(buf, '\', buf2, q);
  vsinfo := buf2;
  mVer := vsInfo^.dwProductVersionMS div $FFFF;
  lVer := vsInfo^.dwProductVersionMS mod $10000;
  rVer := vsInfo^.dwProductVersionLS div $FFFF;
  bVer := vsInfo^.dwProductVersionLS mod $10000;
//  flag := vsInfo^.dwFileFlags;
  s := IntToStr(mVer) + '.' +
    IntToStr(lVer) + '.' +
    IntToStr(rVer) + '.' +
    IntToStr(bVer);
//  if (flag and VS_FF_DEBUG) > 0        then s := s + '/Debug';
//  if (flag and VS_FF_PRERELEASE) > 0   then s := s + '/PreRelease';
//  if (flag and VS_FF_PRIVATEBUILD) > 0 then s := s + '/Private';
//  if (flag and VS_FF_SPECIALBUILD) > 0 then s := s + '/Special';
  Result := s;
  GlobalFree(Cardinal(buf));
end;

function GetFullFileVersion: string;
var
  j, w: Cardinal;
  s: shortstring;
  buf: pointer;
  buf2: pointer;
  q: DWORD;
  vsinfo: ^VS_FIXEDFILEINFO;
  mVer,
  lVer,
  rVer,
  bVer,
  flag: DWORD;
begin
  s := ParamStr(0) + #0;
  j := GetFileVersionInfoSize(@s[1], w);
  if j = 0 then
    Exit;
  buf := Ptr(GlobalAlloc(GMEM_FIXED, j));
  GetFileVersionInfo(@s[1], 0, j, buf);
  VerQueryValue(buf, '\', buf2, q);
  vsinfo := buf2;
  mVer := vsInfo^.dwProductVersionMS div $FFFF;
  lVer := vsInfo^.dwProductVersionMS mod $10000;
  rVer := vsInfo^.dwProductVersionLS div $FFFF;
  bVer := vsInfo^.dwProductVersionLS mod $10000;
  flag := vsInfo^.dwFileFlags;
  s := IntToStr(mVer) + '.' +
    IntToStr(lVer) + '.' +
    IntToStr(rVer) + '.' +
    IntToStr(bVer);
  if (flag and VS_FF_DEBUG) > 0 then
    s := s + '/Debug';
  if (flag and VS_FF_PRERELEASE) > 0 then
    s := s + '/PreRelease';
  if (flag and VS_FF_PRIVATEBUILD) > 0 then
    s := s + '/Private';
  if (flag and VS_FF_SPECIALBUILD) > 0 then
    s := s + '/Special';
  Result := s;
  GlobalFree(Cardinal(buf));
end;

var
  i: Integer;

initialization
  TrapCatched := False;

  for i := 1 to 12 do
    ShortMonthNames[i] := Copy(MonthS, (i - 1) * 3 + 1, 3);

  if GetBuildDate(ParamStr(0), Date) then
  begin
    case MonthOf(date) of
      12,
      1..2: CReleaseSpec := 'Winter';
      3..5: CReleaseSpec := 'Spring';
      6..8: CReleaseSpec := 'Summer';
      9..11: CReleaseSpec := 'Autumn';
    end;

    CProductDate := FormatDateTime('mmm d, yyyy; hh:nn', Date);
    CProductVersionForAbout := GetJustFileVersion + ' (' + CReleaseSpec + ')';
//    CProductVersion := Format('%s/%s/%s', [CProductVersionA,
//      FormatDateTime('dd.mm.yyyy, hh:nn', date), CReleaseSpec]);
    CProductVersionForAbout := CProductVersionForAbout + Format(#10'Compiled: %s', [FormatDateTime('dd-mmm-yyyy, hh:nn:ss', Date)]);

    CProductVersionForAbout := CProductVersionForAbout + #10'JVCL: ' + IntToStr(JVCLVersionMajor) + '.' + IntToStr(JVCLVersionMinor) + '.' + IntToStr(JVCLVersionRelease) + '.' + IntToStr(JVCLVersionBuild);    // build number, days since march 1, 2006
{$IFDEF FullDebugMode}
    CProductVersionForAbout := CProductVersionForAbout + #9#9'FastMM: ' + FastMMVersion;
{$ENDIF}
    CProductVersionForAbout := CProductVersionForAbout + #10'JCL: ' + IntToStr(JclVersionMajor) + '.' + IntToStr(JclVersionMinor) + '.' + IntToStr(JclVersionRelease) + '.' + IntToStr(JclVersionBuild); // build number, days since march 1, 2000
{$IFDEF FullDebugMode}
    CProductVersionForAbout := CProductVersionForAbout + #9#9'DEBUG: enabled';
{$ENDIF}

(*
{$IFDEF FullDebugMode}
    CProductVersionForAbout := CProductVersionForAbout + #10'FastMM: ' + FastMMVersion;
{$ENDIF}
{$IFDEF FullDebugMode}
    CProductVersionForAbout := CProductVersionForAbout + #10'DEBUG: enabled';
{$ENDIF}
*)

    CProductVersion := GetJustFileVersion + '/' + CReleaseSpec;
//    CProductVersion := Format('%s/%s/%s', [CProductVersionA,
//      FormatDateTime('dd.mm.yyyy, hh:nn', date), CReleaseSpec]);
{$IFDEF FullDebugMode}
    CProductVersion := CProductVersion + '/FastMM ' + FastMMVersion;
{$ENDIF}
{$IFDEF FullDebugMode}
    CProductVersion := CProductVersion + '/DEBUG';
{$ENDIF}
  end
  else
  begin
    CProductDate := '-unknown-';
    CProductVersion := Format('%s', [CProductVersionA]);
  end;
  ProductVersionLen := Length(CProductVersion);
  ProductVersion := CProductVersion;
  ProductDateLen := Length(CProductDate);
  ProductDate := CProductDate;
  ProductNameVerLen := Length(CProductNameVer);
  ProductNameVer := CProductNameVer;
  ThreadNfoColl := nil;

  InitializeCriticalSection(CollCS);

  APIMessage := RegisterWindowMessage('Radius_API');
{$IFDEF FullDebugMode}
  EnterList := TEnterList.Create;
{$ENDIF}
  LiveCounter := 0;
  WindCounter := 0;
  ScanCounter := 0;

  HotKeySet := False;

  Application.UpdateFormatSettings := False;

finalization
  PurgeCS(CollCS);
{$IFDEF FullDebugMode}
  EnterList.Free;
{$ENDIF}

end.
