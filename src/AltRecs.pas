unit AltRecs;

{$I DEFINE.INC}

interface

uses Dialogs, Windows, Messages, xBase, xFido, StdCtrls, Classes, Recs;

const

  AltCfgFName         = 'altcfg.bin';
  AltIntegersFName    = 'altcfg.int';

var
  icvCallSec : Integer;
  icvSRFLags : Integer;
  icvColorStored,icvShowInTray : Boolean;
  icvTFSFlags : integer;
  _icvSRFLags: array [0..7] of byte absolute icvSRFlags;
  icvGetFromFile : Word;
  _icvGetFromFile: array [0..3] of byte absolute icvGetFromFile;
  icvUseSpace: Boolean;
  icvbwListBoxColor,
  icvLogBoxColor,
  icvSndTotBackColor,
  icvRcvTotBackColor,
  icvbwListBoxForeColor,
  icvSndTotForeColor,
  icvRcvTotForeColor,
  icvLogBoxForeColor: integer;
type
  TAltElement = class(TElement)
    procedure SetDefault; override;
    function Name: string; override;
    function Copy: Pointer; override;
  end;

  TFlagsCollA      = class(TStringColl)
    constructor Load(Stream: TxStream); override;
  end;

  TFlagsCollB      = class(TStringColl)
    constructor Load(Stream: TxStream); override;
  end;

  TExtAppCollA      = class(TStringColl)
    constructor Load(Stream: TxStream); override;
  end;

  TExtAppCollB      = class(TStringColl)
    constructor Load(Stream: TxStream); override;
  end;

  TIpDomCollC = class(TStringColl)
    constructor Load(Stream: TxStream); override;
  end;

  TNodelistDataDomain = class(TStringColl)
    constructor Load(Stream: TxStream); override;
  end;

  TAltStationRec = class(TAltElement)
    BannerFile: string;
    procedure Store(Stream: TxStream); override;
    constructor Load(Stream: TxStream); override;
  end;

  TAltPWDFile = class(TAltElement)
    FlagsPath: string;
    procedure Store(Stream: TxStream); override;
    constructor Load(Stream: TxStream); override;
  end;

  TRadIni = class
    FlagsCollA: TFlagsCollA;
    FlagsCollB: TFlagsCollB;
    ExtAppCollA: TExtAppCollA;
    ExtAppCollB: TExtAppCollB;
    IpDomC: TIpDomCollC;
    NodelistDataDomain: TNodelistDataDomain;
    AltStationRec: TAltStationRec;
    AltPWDFile: TAltPWDFile;
    CS: TRTLCriticalSection;
    class procedure SetObj(ap: Pointer; ao: TAdvObject);
    constructor Create;
    destructor Destroy; override;
    function DoLoad(Stream: TxStream): Boolean;
    procedure DoStore(Stream: TxStream);
    procedure PutObjects(s: TxStream);
    procedure ReFill;
    procedure Enter;
    procedure Leave;
  end;

var
  AltCfg: TRadIni;

procedure AltRegisterConfig;
procedure AltLoadConfig;
function AltStoreConfig(Handle: DWORD): Boolean;
procedure AltLoadIntegers;
procedure AltStoreIntegers;
procedure AltFreeCfgContainer;

function AltConfigFName: string;

procedure AltCfgEnter;
procedure AltCfgLeave;


Var
  AltStoreConfigAfter: Boolean;


implementation uses SysUtils, LngTools, Forms;


type
  TAltStarter = class(TAdvObject)
    constructor Load(Stream: TxStream); override;
    procedure Store(Stream: TxStream); override;
    destructor Destroy; override;
  end;

  TAltTerminator = class(TAdvObject)
    constructor Load(Stream: TxStream); override;
    procedure Store(Stream: TxStream); override;
    destructor Destroy; override;
  end;

procedure TAltElement.SetDefault; begin GlobalFail('%s', ['TAltElement.SetDefault']); end;
function TAltElement.Name: string; begin GlobalFail('%s', ['TAltElement.Name']); result := '' end;
function TAltElement.Copy: Pointer; begin GlobalFail('%s', ['TElementOnly.Copy']); Result := nil end;

procedure TAltStationRec.Store(Stream: TxStream);
begin
  inherited Store(Stream);
  Stream.WriteStr(BannerFile);
end;

procedure TAltPWDFile.Store(Stream: TxStream);
begin
  inherited Store(Stream);
  Stream.WriteStr(FlagsPath)
end;

class procedure TRadIni.SetObj(ap: Pointer; ao: TAdvObject);
var
  p: PAdvObject;
begin
  p := PAdvObject(ap);
//  if p^ <> nil then GlobalFail('TRadIni.SetObj - %s is already set', [p.ClassName]);
  p^ := ao;
end;

procedure TRadIni.Enter;
begin
  EnterCS(CS);
end;

procedure TRadIni.Leave;
begin
  LeaveCS(CS);
end;

function TRadIni.DoLoad(Stream: TxStream): Boolean;
begin
  Result := False;
  repeat
    Stream.Get;
    if not Stream.GotStarter then Break;
    if Stream.GotTerminator then begin Result := True; Break end;
    if (Stream.Position >= Stream.Size) then Break;
  until False;
end;

procedure PutStarter(Stream: TxStream);
var
  o: TAdvObject;
begin
  o := TAltStarter.Create; Stream.Put(o); FreeObject(o);
end;

procedure PutTerminator(Stream: TxStream);
var
  o: TAdvObject;
begin
  o := TAltTerminator.Create; Stream.Put(o); FreeObject(o);
end;

procedure TRadIni.PutObjects(s: TxStream);
{var i: integer;
    j: integer;
    p: TPasswordRec;}
begin
  PutStarter(s);
  s.Put(FlagsCollA);
  s.Put(FlagsCollB);
  s.Put(AltStationRec);
  s.Put(ExtAppCollA);
  s.Put(ExtAppCollB);
  s.Put(AltPWDFile);
  s.Put(IpDomC);
  s.Put(NodelistDataDomain);
  PutTerminator(s);
end;

procedure TRadIni.DoStore(Stream: TxStream);
begin
  PutObjects(Stream);
end;

procedure TRadIni.Refill;

procedure CreateFlagsCollA;
begin
  FlagsCollA := TFlagsCollA.Create('FlagsCollA');
end;

procedure CreateFlagsCollB;
begin
  FlagsCollB := TFlagsCollB.Create('FlagsCollB');
end;

procedure CreateExtAppCollA;
begin
  ExtAppCollA := TExtAppCollA.Create('ExtAppCollA');
end;

procedure CreateExtAppCollB;
begin
  ExtAppCollB := TExtAppCollB.Create('ExtAppCollB');
end;

procedure CreateIpDomCollC;
begin
  IpDomC := TIpDomCollC.Create('IpDomC');
  IpDomC.Add('fidonet');
end;

procedure CreateNodelistDataDomain;
begin
  NodelistDataDomain := TNodelistDataDomain.Create('NodelistDataDomain');
//  Cfg.NodeList.Domain := NodelistDataDomain;
end;

procedure CreateAltStationRec;
begin
  AltStationRec := TAltStationRec.Create;
end;

procedure CreateAltPWDFile;
begin
  AltPWDFile := TAltPWDFile.Create;
end;

begin
  if FlagsCollA = nil then CreateFlagsCollA;
  if FlagsCollB = nil then CreateFlagsCollB;
  if ExtAppCollA = nil then CreateExtAppCollA;
  if ExtAppCollB = nil then CreateExtAppCollB;
  if AltStationRec = nil then CreateAltStationRec;
  if AltPWDFile = nil then CreateAltPWDFile;
  if IpDomC = nil then CreateIpDomCollC;
  if NodelistDataDomain = nil then CreateNodelistDataDomain;
end;

constructor TRadIni.Create;
begin
  inherited Create;
  InitializeCriticalSection(CS);
end;

destructor TRadIni.Destroy;
begin
  PurgeCS(CS);
  FreeObject(FlagsCollA);
  FreeObject(FlagsCollB);
  FreeObject(ExtAppCollA);
  FreeObject(ExtAppCollB);
  FreeObject(AltStationRec);
  FreeObject(AltPWDFile);
  FreeObject(IpDomC);
  FreeObject(NodelistDataDomain);
  inherited Destroy;
end;

procedure AltFreeCfgContainer;
begin
  FreeObject(AltCfg);
end;

const
  ridAltStarter       =   310;
  ridAltTerminator    =   320;

  ridExtAppCollA      =   500;
  ridExtAppCollB      =   510;

  ridFlagsCollA       =  1000;
  ridFlagsCollB       =  1010;
  ridAltStationRec    =  1020;
  ridAltPWDFile       =  1030;
  ridIpDomCollC       =  3291;
  rid5DOutbound       =  3391;
  ridNodelistDataDom  =  3700;

var
  FConfigDir: ShortString;

function ConfigDir: string;
begin
  Result := FConfigDir;
end;

procedure AltRegisterConfig;
var
  S: string;
begin
  S := GetRegConfigDir;
  if S = '' then begin S := GetRegHomeDir; SetRegConfigDir(S); end;
  if S = '' then
  begin
    S := MakeNormName(ExtractFilePath(WindowsDirectory), 'ARGUS');
    if not FileExists(MakeNormName(S, 'altcfg.bin')) then
    begin
      AltStoreConfigAfter := True;
      S := ExtractFileDir(ParamStr(0));
    end;
    if not SetRegConfigDir(S) then
    begin
      DisplayErrorLng(rsCantUpdateReg,0);
      Application.Terminate;
      Exit;
    end;
  end;
  FConfigDir := ExtractDir(S);
  if DirExists(ConfigDir)=0 then
  begin
    if not CreateDirInheritance(ConfigDir) then
    begin
      DisplayErrorFmtLng(rsRecsCAHD, [ConfigDir], 0);
      Halt
    end;
  end;

  RegisterIoRec(TAltStarter, ridAltStarter);
  RegisterIoRec(TAltTerminator, ridAltTerminator);
  RegisterIoRec(TFlagsCollA, ridFlagsCollA);
  RegisterIoRec(TFlagsCollB, ridFlagsCollB);
  RegisterIoRec(TExtAppCollA, ridExtAppCollA);
  RegisterIoRec(TExtAppCollB, ridExtAppCollB);
  RegisterIoRec(TIpDomCollC, ridIpDomCollC);
  RegisterIoRec(TNodelistDataDomain, ridNodelistDataDom);
  RegisterIoRec(TAltStationRec, ridAltStationRec);
  RegisterIoRec(TAltPWDFile, ridAltPWDFile);
  AltCfg := TRadIni.Create;

end;

procedure AltLoadConfig;
var
  s: TxMemoryStream;
  d: TDosStream;
  p: Pointer;
  sz: Integer;
begin
  d := OpenRead(AltConfigFName);
  if d = nil then
  begin
//    if not AcceptLicence then Halt;
//    StartupWizzard;
  end else
  begin
    s := GetMemoryStream;
    sz := d.Size;
    GetMem(p, sz);
    d.Read(p^, sz);
    s.Write(p^,sz);
    s.Position := 0;
    FreeMem(p, sz);
    FreeObject(d);
    if not AltCfg.DoLoad(s) then GlobalFail('%s', ['Failed to load altconfig']);
    FreeObject(s);
  end;
  AltCfg.Refill;

//  UpdateGlobalEvtUpdateFlag;
end;

function AltStoreConfig(Handle: DWORD): Boolean;
var
  s: TxMemoryStream;
begin
  AltStoreConfigAfter := False;
  repeat
    s := GetMemoryStream;
    AltCfg.DoStore(s);
    Result := s.SaveToFile(AltConfigFName);
    FreeObject(s);
    if Result then Break else
    begin
      if WinDlgCap(GetErrorMsg, MB_RETRYCANCEL or MB_ICONERROR, Handle, LngStr(rsRecsCntWrtCfg)) = idCancel then Break;
    end;
  until False;
end;

const
  iccSOF       = 1;
  iccEOF       = 2;
  iccCallSec   = 10;
  iccSRFlags   = 20;
  iccGetFromFile = 30;
  iccShowInTray = 40;
  iccTFSFlags = 50;
  iccUseSpace = 60;
  iccbwListBoxColor = 70;
  iccLogBoxColor = 71;
  iccSndTotBackColor = 72;
  iccRcvTotBackColor = 73;
  iccbwListBoxForeColor = 74;
  iccSndTotForeColor = 75;
  iccRcvTotForeColor = 76;
  iccLogBoxForeColor = 77;
  iccColorStored = 78;

procedure AltLoadIntegers;
var
  s: TxStream;
  i: Integer;
begin
  s := OpenRead(MakeNormName(ConfigDir, AltIntegersFName));
  if s = nil then Exit;
  if s.ReadDword <> iccSOF then Exit;
  while s.Position < s.Size do
  begin
    i := s.ReadInteger;
    case s.ReadDword of
      iccEOF :
        Break;
      iccCallSec:
        icvCallSec := i;
      iccSRFlags:
        icvSRFlags := i;
      iccGetFromFile :
        icvGetFromFile := i;
      iccShowInTray:
        icvShowInTray := (i=1);
      iccColorStored:
        icvColorStored := (i=1);
      iccTFSFlags:
        icvTFSFlags := i;
      iccUseSpace:
        icvUseSpace := (i=1);
      iccbwListBoxColor:
        icvbwListBoxColor := i;
      iccLogBoxColor:
        icvLogBoxColor := i;
      iccSndTotBackColor:
        icvSndTotBackColor := i;
      iccRcvTotBackColor:
        icvRcvTotBackColor := i;
      iccbwListBoxForeColor:
        icvbwListBoxForeColor := i;
      iccSndTotForeColor:
        icvSndTotForeColor := i;
      iccRcvTotForeColor:
        icvRcvTotForeColor := i;
      iccLogBoxForeColor:
        icvLogBoxForeColor := i;
    end;
  end;
  FreeObject(s);
end;

procedure AltStoreIntegers;
var
  s: TDosStream;

  procedure WD(a: Integer; b: DWORD);
  begin
    S.WriteInteger(a); S.WriteDword(b);
  end;

begin
  s := OpenWrite(MakeNormName(ConfigDir, AltIntegersFName));
  if s = nil then Exit;
  SetEndOfFile(s.Handle);
  s.WriteDWORD(iccSOF);
  WD(icvGetFromFile, iccGetFromFile);
  WD(icvSRFlags, iccSRFlags);
  WD(icvTFSFlags,iccTFSFlags);
  WD(icvCallSec, iccCallSec);

  WD(icvbwListBoxColor,iccbwListBoxColor);
  WD(icvLogBoxColor,iccLogBoxColor);
  WD(icvSndTotBackColor,iccSndTotBackColor);
  WD(icvRcvTotBackColor,iccRcvTotBackColor);
  WD(icvbwListBoxForeColor,iccbwListBoxForeColor);
  WD(icvSndTotForeColor,iccSndTotForeColor);
  WD(icvRcvTotForeColor,iccRcvTotForeColor);
  WD(icvLogBoxForeColor,iccLogBoxForeColor);
  WD(ord(icvColorStored),iccColorStored);
  WD(ord(icvShowInTray), iccShowInTray);
  WD(ord(icvUseSpace), iccUseSpace);
  WD(iccEOF, iccEOF);
  FreeObject(s);
end;

{ TTerminator }

constructor TAltTerminator.Load(Stream: TxStream);
begin
  Stream.GotTerminator := True;
  Stream.FreeLastLoaded := True;
end;

procedure TAltTerminator.Store(Stream: TxStream); begin end;
destructor TAltTerminator.Destroy; begin inherited Destroy end;

{ TAltStarter }

constructor TAltStarter.Load(Stream: TxStream);
begin
  Stream.GotStarter := True;
  Stream.FreeLastLoaded := True;
end;

procedure TAltStarter.Store(Stream: TxStream); begin end;
destructor TAltStarter.Destroy; begin inherited Destroy end;

function AltConfigFName: string;
begin
  Result := MakeNormName(ConfigDir, AltCfgFName);
end;

var
  AltCfgCCC: Integer;

procedure AltCfgEnter;
begin
  AltCfg.Enter;
  Inc(AltCfgCCC);
end;

procedure AltCfgLeave;
begin
  Dec(AltCfgCCC);
  AltCfg.Leave;
  if ALtCfgCCC < 0 then
  GlobalFail('%s', ['Unexpected AltCfgLeave!']);
end;

constructor TFlagsCollA.Load(Stream: TxStream);
begin
  inherited Load(Stream);
  AltCfg.SetObj(@AltCfg.FlagsCollA, Self);
end;

constructor TFlagsCollB.Load(Stream: TxStream);
begin
  inherited Load(Stream);
  AltCfg.SetObj(@AltCfg.FlagsCollB, Self);
end;

constructor TExtAppCollA.Load(Stream: TxStream);
begin
  inherited Load(Stream);
  AltCfg.SetObj(@AltCfg.ExtAppCollA, Self);
end;

constructor TExtAppCollB.Load(Stream: TxStream);
begin
  inherited Load(Stream);
  AltCfg.SetObj(@AltCfg.ExtAppCollB, Self);
end;

constructor TAltStationRec.Load(Stream: TxStream);
begin
  inherited Load(Stream);
  BannerFile := Stream.ReadStr;
  AltCfg.SetObj(@AltCfg.AltStationRec, Self);
end;

constructor TAltPWDFile.Load(Stream: TxStream);
begin
  inherited Load(Stream);
  FlagsPath := Stream.ReadStr;
  AltCfg.SetObj(@AltCfg.AltPWDFile, Self);
end;

constructor TIpDomCollC.Load(Stream: TxStream);
begin
  inherited Load(Stream);
  AltCfg.SetObj(@AltCfg.IpDomC, Self);
  while AltCfg.IpDomC.Count < Cfg.IpDomA.Count do AltCfg.IpDomC.Add('');
end;

constructor TNodelistDataDomain.Load(Stream: TxStream);
begin
  inherited Load(Stream);
  AltCfg.SetObj(@AltCfg.NodelistDataDomain, Self);
end;

initialization
  icvCallSec := High(icvCallSec);

finalization

end.

