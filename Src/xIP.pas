unit xIP;

{$I DEFINE.INC}

interface uses
  Windows, Forms,

{$IFDEF WS}
  Classes, wsock, xMisc,
{$ENDIF}
  xBase;
{$IFDEF WS}

var
  TCPIP_InR, TCPIP_OutR: DWORD;
  TCPIP_InGr, TCPIP_OutGr: array[0..TCPIP_GrDataSz] of Integer;
  TCPIP_GrStep: DWORD;
  TCPIP_GrCS: TRTLCriticalSection;
  ProxyEnabled: Boolean;
  ProxyAddr: string;
  ProxyPort: DWORD;
  SocksAlloc: Integer;

type
  TDaemonParams = record
    ifcico: TvIntArr;
    Telnet: TvIntArr;
     BinkP: TvIntArr;
   {$IFDEF EXTREME}
       FTP: TvIntArr;
      HTTP: TvIntArr;
      SMTP: TvIntArr;
      POP3: TvIntArr;
      GATE: TvIntArr;
      NNTP: TvIntArr;
   {$ENDIF}
    InConns, OutConns: DWORD;
  end;

  TTelnetLast = (ttNone, ttIAC, ttWILL, ttWONT, ttDO, ttDONT, ttUnk);

  TTelnetFilter = class
    CP: TPort;
    TL: TTelnetLast;
    OutIAC: Boolean;
    procedure answer(Tag, Opt: Byte);
    procedure Init;
    function InFilter(B: Byte; var I: Byte): Boolean;
    function OutFilter(B: Byte; var O: Byte): Boolean;
  end;

  TSockPort = class(TDevicePort)
    OrigHandle: THandle;
    SockW: TRTLCriticalSection;
    IpPort: DWORD;
    aType: DWORD;
    Typ: TProtCore;
    Filter: TTelnetFilter;
    Incoming: Boolean;
    constructor Create(AHandle: DWORD; AFilter: TTelnetFilter; AIPPort: DWORD; ATyp: TProtCore);
    procedure CloseHW_A;                                override;
    procedure CloseHW_B;                                override;
    function ReadNow: Integer;                          override;
    procedure SleepDown;                                override;
    procedure WakeUp;                                   override;
    procedure SaveParams;                               override;
    procedure RestoreParams;                            override;
    procedure HWPurge(Typ: TTxRxSet);                   override;
    procedure DropDCD;
    procedure Err;
  end;

  TNewIpInLine = class
    Port: Pointer;
    Prot: TProtCore;
    aTyp: DWORD;
    IpPort: DWORD;
  end;

  TWSAConnectResult = class
    p: Pointer;
    Res: Integer;
    Terminated,
    Error: Boolean;
    Port: Pointer;
    IpPort: DWORD;
    Prot: TProtCore;
    aTyp: DWORD;
    ResolvedAddr: DWORD;
    Addr: string;
  end;

function OpenPort(AHandle: TSocket; Typ: TProtCore; IpPort: DWORD): TSockPort;
function Addr2Inet(i: DWORD): string;
function RunDaemon(Params: TDaemonParams): Boolean;
procedure ShutdownDaemon;
procedure EndSockMgr;
procedure EndIpThreads;
procedure _WSAConnect(const Addr: string; p: Pointer; AProt: TProtCore; APort: DWORD; aType: DWORD);
function WSAErrMsg(Msg: Integer): string;
procedure PurgeConnThrs;
procedure HostResolveComplete(Idx, lParam: Integer);

function ConnectToRemoteHost(var FSocket: TSocket; const AAddr:string; APort:DWORD): integer;
function DisconnectFromRemoteHost(FSocket: TSocket): integer;
function SendToRemoteHost(FSocket: TSocket; const Buf; BufLen: integer; WriteOL: POverlapped): integer;
function ReadFromRemoteHost(FSocket: TSocket; var Buf; var BufLen: integer; ReadOL: POverlapped): integer;

var
  OutConnsAvail: DWORD;
  IPMon: T_Thread;

  oBlk: THandle;
  RemoteSocket: TSocket;
{$ENDIF}

function Inet2Addr(const s: string): DWORD;
function Inet2Port(s: string; var Port: DWORD): DWORD;
function Sym2Port(s: string; var Port: DWORD): string;
function Sym2Addr(const s: string): string;
function ValidInetAddr(const s: string): Boolean;
function ValidSymAddr(const s: string): Boolean;
{$IFDEF WS}
function CoolResolve(const Addr: string; oBlk: DWORD; var Error: Integer): DWORD;
{$ENDIF}

const
  INADDR_NONE      = $FFFFFFFF;

implementation

uses
{$IFDEF WS}
//wsock,
  MlrThr, MlrDefs,
{$ENDIF}
  SysUtils, RadIni, Recs, Crypt, xFido, Wizard;

function InetAddr(const s: string): DWORD;
{$IFNDEF WS}
var
  a,
  b: string;
  i,
  e: Integer;
  r: array[0..3] of Int64;
{$ENDIF}
begin
 {$IFDEF WS}
   try
     Result := DWORD(inet_addr(PChar(s)));
   except
     Result := DWORD(INADDR_NONE);
   end;
 {$ELSE}
   Result := INADDR_NONE;
   i := 0;
   a := s;
   while a <> '' do
   begin
     if i = 4 then Exit;
     GetWrd(a, b, '.');
     for e := 1 to Length(b) do
       case b[e] of
         '0'..'9' : ;
         else Exit;
       end;
     Val(b, r[i], e);
     if e <> 0 then Exit;
     Inc(i);
   end;
   for e := 0 to i - 2 do begin
     if (r[e] < 0) or (r[e] > $FF) then Exit;
   end;
   case i - 1 of
     0 : begin
           if r[0] > MaxInt then Result := (r[0] - MaxInt) + MaxInt else
             Result := (r[0]);
         end;
     1 : begin
           if (r[1] < 0) or (r[1] > $FFFFFF) then Exit;
           Result := ((r[0]) shl 24) or (r[1]);
         end;
     2 : begin
           if (r[2] < 0) or (r[2] > $FFFF) then Exit;
           Result := ((r[0]) shl 24) or ((r[1]) shl 16) or ((r[2]));
         end;
     3 : begin
           if (r[3] < 0) or (r[3] > $FF) then Exit;
           Result := ((r[0]) shl 24) or ((r[1]) shl 16) or ((r[2]) shl 8) or (r[3]);
         end;
     else GlobalFail('%s', ['InetAddr']);
   end;
 {$ENDIF}
end;

function Inet2Addr;
var
  Port: DWORD;
begin
  Result := Inet2Port(s, Port);
end;

function Sym2Addr;
var
  Port: DWORD;
begin
  Result := Sym2Port(s, Port);
end;

function Sym2Port(s: string; var Port: DWORD): string;
var
  z: string;
  i,
  e: DWORD;
  c: Char;
begin
  Result := '';
  i := INADDR_NONE;
  if Pos('_', s) > 0 then C := '_' else C := ':';
  GetWrd(s, z, C);
  if s <> '' then
  begin
    Val(s, i, e);
    if e <> 0 then Exit;
  end;
  if not BothKVC(z) then Exit;
  if i <> INADDR_NONE then Port := i;
  DelFC(z);
  DelLC(z);
  Result := z;
end;

function Inet2Port(s: string; var Port: DWORD): DWORD;
var
  z: string;
  i: DWORD;
  C: Char;
begin
  Result := INADDR_NONE;
  i := INADDR_NONE;
  if Pos('_', s) > 0 then C := '_' else C := ':';
  GetWrd(s, z, C);
  if s <> '' then begin
    i := Vl(s);
    if i = INVALID_VALUE then Exit;
  end;
  Replace('*', '.', z);
  Result := InetAddr(z);
  if Result = INADDR_NONE then Exit;
  if i <> INADDR_NONE then Port := i;
end;

function ValidInetAddr(const s: string): Boolean;
begin
  try
    Result := Inet2Addr(s) <> INADDR_NONE;
  except
    Result := False;
  end;
end;

function ValidSymAddr(const s: string): Boolean;
begin
  Result := Sym2Addr(s) <> '';
end;

{$IFDEF WS}

function _send(var AHandle: TSocket; const Buf; var Size: Integer; var Error: Boolean; OL: POverlapped): Integer; forward;
function _recv(var AHandle: TSocket; var Buf; var Size: Integer; var Error: Boolean; OL: POverlapped): Integer; forward;

const
  DaemonMemSize = TCPIP_Round;

type
  TIPMonThread = class(T_Thread)
    Again: Boolean;
    MemIn,
    MemOut: array[0..DaemonMemSize - 1] of Integer;
    TCPIP_In,
    TCPIP_Out: DWORD;
    constructor Create;
    destructor Destroy; override;
    procedure InvokeExec; override;
    class function ThreadName: string; override;
  end;

  TResolveThread = class(T_Thread)
    Again: Boolean;
    CS: TRTLCriticalSection;
    oAsyncAvail, oStartResolve: THandle;
    InReq, OutReq, Resp, Async: TColl;
    procedure InvokeExec; override;
    constructor Create;
    destructor Destroy; override;
    function StartAsyncRequest(const HostName: string): Boolean;
    function ProcessRequests: Boolean;
    function AsyncIdxFound(Idx: Integer): Boolean;
    procedure HostResolveComplete(Idx, lParam: Integer);
    class function ThreadName: string; override;
  end;

  TResolveRequest = class
    HostName: string;
    oEvt: THandle;
  end;

  TResolveResponse = class
    HostName: string;
    Addr: DWORD;
    Error: Integer;
  end;

  TResolveAsyncStruc = class
    HostName: string;
    HostBuf: array[0..MAXGETHOSTSTRUCT] of Char;
    MsgIdx: Integer;
    Handle: TSocket;
  end;

class function TResolveThread.ThreadName: string;
begin
  Result := 'Host Resolver';
end;

procedure TResolveThread.HostResolveComplete(Idx, lParam: Integer);
var
  a: packed record buflen, err: word end absolute lParam;
  i,
  j: Integer;
  r: TResolveAsyncStruc;
  req: TResolveRequest;
  rsp: TResolveResponse;
  phe: PHostEnt;
begin
  for i := 0 to Async.Count - 1 do
  begin
    r := Async[i];
    if r.MsgIdx = Idx then
    begin
      for j := Resp.Count - 1 downto 0 do
      begin
        rsp := Resp[j];
        if rsp.HostName = r.HostName then Resp.AtFree(j);
      end;

      phe := @r.HostBuf;

      Rsp := TResolveResponse.Create;
      Rsp.HostName := StrAsg(r.HostName);
      Rsp.Error := a.err;
      if a.err = 0 then begin
        if phe^.h_addr_list <> nil then begin
          Rsp.Addr := PDwordArray(phe^.h_addr_list^)^[0];
        end else begin
          Rsp.Error := -199;
        end;
      end;
      Resp.Insert(Rsp);
      for j := OutReq.Count - 1 downto 0 do begin
        req := OutReq[j];
        if r.HostName = req.HostName then begin
          SetEvt(req.oEvt);
          OutReq.AtFree(j);
        end;
      end;
      if Async.Count = WM__NUMRESOLVE then SetEvt(oAsyncAvail);
      Async.AtFree(i);
      Break;
    end;
  end;
end;

function TResolveThread.AsyncIdxFound(Idx: Integer): Boolean;
var
  i: Integer;
  a: TResolveAsyncStruc;
begin
  Result := False;
  for i := 0 to Async.Count - 1 do begin
    a := Async[i];
    if a.MsgIdx = Idx then begin
      Result := True;
      Break;
    end;
  end;
end;

function TResolveThread.StartAsyncRequest(const HostName: string): Boolean;
var
  i,
  j: Integer;
  r: TResolveAsyncStruc;
  found: Boolean;
begin
  Result := True;
  found := False;
  for i := 0 to Async.Count - 1 do
  begin
    r := Async[i];
    if r.HostName = HostName then begin
      Found := True;
      Break;
    end;
  end;
  if (not Found) then begin
    if (Async.Count = WM__NUMRESOLVE) then
      Result := False
    else begin
      j := -1;
      for i := 0 to WM__NUMRESOLVE - 1 do begin
        if not AsyncIdxFound(i) then begin j := i; Break end;
      end;
      if j = -1 then GlobalFail('%s', ['TResolveThread.StartAsyncRequest AsyncIdx Not Found']);
      r := TResolveAsyncStruc.Create;
      r.HostName := StrAsg(HostName);
      r.MsgIdx := j;
      r.Handle := WSAAsyncGetHostByName(MainWinHandle, WM_RESOLVE + r.MsgIdx, PChar(r.HostName), r.HostBuf, MAXGETHOSTSTRUCT);
      Async.Insert(r);
      if Async.Count = WM__NUMRESOLVE then ResetEvt(oAsyncAvail);
    end;
  end;
end;

function TResolveThread.ProcessRequests: Boolean;
var
  rreq: TResolveRequest;
  rres: TResolveResponse;
  AsyncStarted: Boolean;
  i,
  k,
  j: Integer;
begin
  Result := False;
  for k := InReq.Count - 1 downto 0 do begin
    rreq := InReq[k];
    j := -1;
    for i := 0 to Resp.Count - 1 do begin
      rres := Resp[i];
      if rres.HostName = rreq.HostName then begin
        j := i;
        Break;
      end;
    end;
    AsyncStarted := StartAsyncRequest(StrAsg(rreq.HostName));
    if (j = -1) then begin
      if not AsyncStarted then Exit;
      OutReq.Insert(rreq);
      InReq.AtDelete(k);
    end else begin
      SetEvt(rreq.oEvt);
      InReq.AtFree(k);
    end;
  end;
  Result := True;
end;

procedure TResolveThread.InvokeExec;
var
  DoWait: Boolean;
begin
  if not Again then begin
    Again := True;
    WaitEvtInfinite(oStartResolve);
  end;
  EnterCS(CS);
  DoWait := not ProcessRequests;
  LeaveCS(CS);
  if DoWait then WaitEvtInfinite(oAsyncAvail) else Again := False;
end;

//    HostName: string;
//    oEvt: Integer;

constructor TResolveThread.Create;
begin
  inherited Create;
  InitializeCriticalSection(CS);
  oStartResolve := CreateEvtA;
  oAsyncAvail := CreateEvt(True);
  InReq := TColl.Create;
  OutReq := TColl.Create;
  Resp := TColl.Create;
  Async := TColl.Create;
  Priority := tpLowest;
end;

var
  SkipCleanup,
  WSAStarted: Boolean;

destructor TResolveThread.Destroy;
var
  i: Integer;
  a: TResolveAsyncStruc;
begin
  for i := 0 to Async.Count - 1 do begin
     a := Async[i];
     WSACancelAsyncRequest(a.Handle);
     SkipCleanup := True;
  end;
  FreeObject(InReq);
  FreeObject(OutReq);
  FreeObject(Resp);
  FreeObject(Async);
  PurgeCS(CS);
  ZeroHandle(oStartResolve);
  ZeroHandle(oAsyncAvail);
  inherited Destroy;
end;

const

WSA_ErrMsgMax = 65;
WSA_ErrMsg: array[0..WSA_ErrMsgMax] of record s: string; n: Integer end = (

  // Custom error codes
  (s: 'No address (A) records available'; n:-199),

  // SOCKS4 error codes

  (s: 'SOCKS request rejected or failed'; n:-91),
  (s: 'SOCKS request rejected becasue SOCKS server cannot connect to identd on the client'; n:-92),
  (s: 'SOCKS request rejected because the client program and identd report different user-ids'; n:-93),

  // Windows Sockets definitions of regular Microsoft C error constants

  (s: 'WSAEINTR';  n: (WSABASEERR +  4)),
  (s: 'WSAEBADF';  n: (WSABASEERR +  9)),
  (s: 'WSAEACCES'; n: (WSABASEERR + 13)),
  (s: 'WSAEFAULT'; n: (WSABASEERR + 14)),
  (s: 'WSAEINVAL'; n: (WSABASEERR + 22)),
  (s: 'WSAEMFILE'; n: (WSABASEERR + 24)),

  // Windows Sockets definitions of regular Berkeley error constants

  (s: 'WSAEWOULDBLOCK';     n: (WSABASEERR + 35)),
  (s: 'WSAEINPROGRESS';     n: (WSABASEERR + 36)),
  (s: 'WSAEALREADY';        n: (WSABASEERR + 37)),
  (s: 'WSAENOTSOCK';        n: (WSABASEERR + 38)),
  (s: 'WSAEDESTADDRREQ';    n: (WSABASEERR + 39)),
  (s: 'WSAEMSGSIZE';        n: (WSABASEERR + 40)),
  (s: 'WSAEPROTOTYPE';      n: (WSABASEERR + 41)),
  (s: 'WSAENOPROTOOPT';     n: (WSABASEERR + 42)),
  (s: 'WSAEPROTONOSUPPORT'; n: (WSABASEERR + 43)),
  (s: 'WSAESOCKTNOSUPPORT'; n: (WSABASEERR + 44)),
  (s: 'WSAEOPNOTSUPP';      n: (WSABASEERR + 45)),
  (s: 'WSAEPFNOSUPPORT';    n: (WSABASEERR + 46)),
  (s: 'WSAEAFNOSUPPORT';    n: (WSABASEERR + 47)),
  (s: 'WSAEADDRINUSE';      n: (WSABASEERR + 48)),
  (s: 'WSAEADDRNOTAVAIL';   n: (WSABASEERR + 49)),
  (s: 'WSAENETDOWN';        n: (WSABASEERR + 50)),
  (s: 'WSAENETUNREACH';     n: (WSABASEERR + 51)),
  (s: 'WSAENETRESET';       n: (WSABASEERR + 52)),
  (s: 'WSAECONNABORTED';    n: (WSABASEERR + 53)),
  (s: 'WSAECONNRESET';      n: (WSABASEERR + 54)),
  (s: 'WSAENOBUFS';         n: (WSABASEERR + 55)),
  (s: 'WSAEISCONN';         n: (WSABASEERR + 56)),
  (s: 'WSAENOTCONN';        n: (WSABASEERR + 57)),
  (s: 'WSAESHUTDOWN';       n: (WSABASEERR + 58)),
  (s: 'WSAETOOMANYREFS';    n: (WSABASEERR + 59)),
  (s: 'WSAETIMEDOUT';       n: (WSABASEERR + 60)),
  (s: 'WSAECONNREFUSED';    n: (WSABASEERR + 61)),
  (s: 'WSAELOOP';           n: (WSABASEERR + 62)),
  (s: 'WSAENAMETOOLONG';    n: (WSABASEERR + 63)),
  (s: 'WSAEHOSTDOWN';       n: (WSABASEERR + 64)),
  (s: 'WSAEHOSTUNREACH';    n: (WSABASEERR + 65)),
  (s: 'WSAENOTEMPTY';       n: (WSABASEERR + 66)),
  (s: 'WSAEPROCLIM';        n: (WSABASEERR + 67)),
  (s: 'WSAEUSERS';          n: (WSABASEERR + 68)),
  (s: 'WSAEDQUOT';          n: (WSABASEERR + 69)),
  (s: 'WSAESTALE';          n: (WSABASEERR + 70)),
  (s: 'WSAEREMOTE';         n: (WSABASEERR + 71)),

  // Extended Windows Sockets error constant definitions

  (s:'WSASYSNOTREADY';n:          (WSABASEERR+91)),
  (s:'WSAVERNOTSUPPORTED';n:      (WSABASEERR+92)),
  (s:'WSANOTINITIALISED';n:       (WSABASEERR+93)),
  (s:'WSAEDISCON';n:              (WSABASEERR+101)),
  (s:'WSAENOMORE';n:              (WSABASEERR+102)),
  (s:'WSAECANCELLED';n:           (WSABASEERR+103)),
  (s:'WSAEINVALIDPROCTABLE';n:    (WSABASEERR+104)),
  (s:'WSAEINVALIDPROVIDER';n:     (WSABASEERR+105)),
  (s:'WSAEPROVIDERFAILEDINIT';n:  (WSABASEERR+106)),
  (s:'WSASYSCALLFAILURE';n:       (WSABASEERR+107)),
  (s:'WSASERVICE_NOT_FOUND';n:    (WSABASEERR+108)),
  (s:'WSATYPE_NOT_FOUND';n:       (WSABASEERR+109)),
  (s:'WSA_E_NO_MORE';n:           (WSABASEERR+110)),
  (s:'WSA_E_CANCELLED';n:         (WSABASEERR+111)),
  (s:'WSAEREFUSED';n:             (WSABASEERR+112)),

  // Authoritative Answer: Host not found
  (s:'WSAHOST_NOT_FOUND';n:       (WSABASEERR+1001)),

  // Non-Authoritative: Host not found, or SERVERFAIL
  (s:'WSATRY_AGAIN';n:            (WSABASEERR+1002)),

  // Non-recoverable errors, FORMERR, REFUSED, NOTIMP
  (s:'WSANO_RECOVERY';n:          (WSABASEERR+1003)),

  // Valid name, no data record of requested type
  (s:'WSANO_DATA';n:              (WSABASEERR+1004))
);

function WSAErrMsg(Msg: Integer): string;
var
  i: Integer;
begin
  for i := 0 to WSA_ErrMsgMax do begin
    if Msg = WSA_ErrMsg[i].n then begin
      Result := WSA_ErrMsg[i].s;
      Exit;
    end;
  end;
  Result := FormatErrorMsg('', Msg);
end;


const
  TN_WILL = 251;
  TN_WONT = 252;
  TN_DO   = 253;
  TN_DONT = 254;
  TN_IAC  = 255;

  TN_TRANSMIT_BINARY = 0;
  TN_ECHO            = 1;
  TN_SUPPRESS_GA     = 3;

type

   TSockInThread = class(TInThread)
     GotChar: Boolean;
     function SubRead(var Buf; Size: Integer): Integer;
     function Read(var Buf; Size: DWORD): DWORD; override;
     class function ThreadName: string; override;
   end;

   TSockOutThread = class(TOutThread)
     AuxO: TDevicePortOutBlk;
     AuxSz: DWORD;
     More: Boolean;
     function SubWrite(const Buf; Size: Integer): Integer;
     function Write(const Buf; Size: DWORD): DWORD; override;
     class function ThreadName: string; override;
   end;

  TSockListen = class(T_Thread)
    Again: Boolean;
    Typ: TProtCore;
    IpPort: DWORD;
    SocketHandle: TSocket;
    oAccept: THandle;
    procedure TheEnd;
    procedure InvokeExec; override;
    destructor Destroy; override;
    function RecreateHandle: Boolean;
    class function ThreadName: string; override;
  end;

  TInSockMgr = class(T_Thread)
    SocksAvail: DWORD;
    oNewSocks: DWORD;
    NewSocks: TColl;
    ListeningSocks: TColl;
    procedure InvokeExec; override;
    constructor Create;
    destructor  Destroy; override;
    class function ThreadName: string; override;
  end;

var
//  RemotePort: TSockPort;
  Thr: TSockPort;

function __setblock(const h: TSocket; p: u_long): Integer;
var
   b: u_long;
begin
   b := p;
   Result := ioctlsocket(h, FIONBIO, b);
end;

function __unblock(h: TSocket): Integer;
begin
   Result := WSAEventSelect(h, 0, 0);
   if Result = SOCKET_ERROR then Exit;
   Result := __setblock(h, 0);
end;

procedure __close(var h: TSocket);
var
  ls: TSocket;
   e: Integer;
begin
   ls := INVALID_SOCKET;
   XChg(h, ls);
   if (ls = INVALID_SOCKET) or (ls = 0) then Exit;
   if closesocket(ls) <> 0 then begin
      if not IniFile.DisableWinsockTraps then begin
         e := WSAGetLastError;
         GlobalFail('closesocket error %d (%s)', [e, WSAErrMsg(e)]);
      end;
   end;
   Dec(SocksAlloc);
end;

function __socket: TSocket;
begin
   if WinSock2 then begin
      Result := WSASocket(PF_INET, SOCK_STREAM, IPPROTO_IP, nil, 0, WSA_FLAG_OVERLAPPED);
   end else begin
      Result := socket(PF_INET, SOCK_STREAM, 0);
   end;
   if Result <> INVALID_SOCKET then Inc(SocksAlloc);
end;

function __reuse(h: DWORD): Integer;
var
   bt: DWORD;
begin
   bt := 1;
   Result := setsockopt(h, SOL_SOCKET, SO_REUSEADDR, @bt, SizeOf(bt));
   if Result = SOCKET_ERROR then Exit;
end;

function __bind(AHandle, APort: DWORD; var Adr: TSockAddr): Integer;
begin
   Adr.sin_family      := AF_INET;
   Adr.sin_port        := htons(APort);
  // visual. allow bind IPDaemon to specified interface
   if (UpperCase(IniFile.BindAddr) = 'ANY') then
     Adr.sin_addr.s_addr := INADDR_ANY
   else
     Adr.sin_addr.s_addr := Inet2Addr(IniFile.BindAddr);
   Result := bind(AHandle, Adr, SizeOf(Adr));
end;

var
  SockMgr: TInSockMgr;

procedure TTelnetFilter.answer(Tag, Opt: Byte);
var
  a: array[0..2] of Byte;
begin
  EnterCS(TSockPort(CP).SockW);
  a[0] := TN_IAC;
  a[1] := Tag;
  a[2] := Opt;
  TSockOutThread(TSockPort(CP).WriteThr).SubWrite(a, 3);
  LeaveCS(TSockPort(CP).SockW);
end;

procedure TTelnetFilter.Init;
begin
  EnterCS(TSockPort(CP).SockW);
  answer(TN_DO, TN_SUPPRESS_GA);
  answer(TN_WILL, TN_SUPPRESS_GA);
  answer(TN_DO, TN_TRANSMIT_BINARY);
  answer(TN_WILL, TN_TRANSMIT_BINARY);
  answer(TN_DO, TN_ECHO);
  answer(TN_WILL, TN_ECHO);
  LeaveCS(TSockPort(CP).SockW);
end;

function TTelnetFilter.InFilter(B: Byte; var I: Byte): Boolean;
begin
  Result := False;
  case TL of
    ttNone:
      if B = TN_IAC then TL := ttIAC else begin I := B; Result := True end;
    ttIAC:
      case B of
        TN_IAC  : begin TL := ttNone; I := B; Result := True; end;
        TN_WILL : TL := ttWILL;
        TN_WONT : TL := ttWONT;
        TN_DO   : TL := ttDO;
        TN_DONT : TL := ttDONT;
        else TL := ttUnk;
      end;
    ttWILL,ttWONT,ttDO,ttDONT,ttUnk:
      begin
        case TL of
          ttWILL : if (B <> TN_TRANSMIT_BINARY) and (B <> TN_SUPPRESS_GA) and (B <> TN_ECHO) then answer(TN_DONT, B);
          ttWONT : ;
          ttDO   : if (B <> TN_TRANSMIT_BINARY) and (B <> TN_SUPPRESS_GA) and (B <> TN_ECHO) then answer(TN_WONT, B);
          ttDONT : ;
          ttUnk  : ;
          else GlobalFail('%s', ['TTelnetFilter unknown TL']);
        end;
        TL := ttNone;
      end;
    else GlobalFail('%s', ['TTelnetFilter unknown TL']);
  end;
end;

function TTelnetFilter.OutFilter(B: Byte; var O: Byte): Boolean;
begin
   if OutIAC then begin
      O := TN_IAC;
      OutIAC := False;
      Result := False;
   end else begin
      O := B;
      if B = TN_IAC then OutIAC := True;
      Result := OutIAC;
   end;
end;

function TSockPort.ReadNow: Integer;
begin
  Result := PortInBufSize;
end;

constructor TSockPort.Create;
var
  e: Integer;
begin
  inherited Create(TSockInThread, TSockOutThread);
  InitializeCriticalSection(SockW);
  FHandle := AHandle;
  if Win32Platform <> VER_PLATFORM_WIN32_NT then begin
     // workaround for socket handle inheritance bug of Win9x
     OrigHandle := FHandle;
     if not DuplicateHandle(GetCurrentProcess, OrigHandle, GetCurrentProcess, @FHandle, 0, True, DUPLICATE_SAME_ACCESS) then begin
        e := GetLastError;
        GlobalFail('Duplicate Socket Handle Failed, Error %d (%s)', [e, WSAErrMsg(e)]);
     end;
     Inc(SocksAlloc);
  end;
  FDCD := True;
  FCarrier := True;
  if AFilter <> nil then begin
     Filter := AFilter;
     Filter.CP := Self;
  end;
  IPPort := AIPPort;
  Typ := ATyp;
  WakeThreads;
end;

procedure __shutdown(FHandle: DWORD);
var
  e: Integer;
begin
   if shutdown(FHandle, 2) = SOCKET_ERROR then begin
      if not IniFile.DisableWinsockTraps then begin
         e := WSAGetLastError;
         GlobalFail('shutdown failed, error %d. Try using WinSockVersion registry variable', [e, WSAErrMsg(e)]);
      end;
   end;
end;

procedure TSockPort.CloseHW_A;
begin
   if not WinSock2 then begin
    __shutdown(FHandle);
    __close(FHandle);
      if Win32Platform <> VER_PLATFORM_WIN32_NT then begin
       __close(OrigHandle);
      end;
   end;
end;

procedure TSockPort.CloseHW_B;
begin
   if WinSock2 then begin
      __close(TSocket(FHandle));
      if Win32Platform <> VER_PLATFORM_WIN32_NT then begin
         __close(OrigHandle);
      end;
   end;
   if Incoming then begin
      if SockMgr <> nil then begin
         Inc(SockMgr.SocksAvail);
      end;
   end else begin
      Inc(OutConnsAvail);
   end;
   PurgeCS(SockW);
   FreeObject(Filter);
end;

procedure TSockPort.Err;
var
   ee: TComError;
begin
   ee := TComError.Create;
   ee.Err := WSAGetLastError;
   InsComErr(ee);
end;

procedure TSockPort.DropDCD;
begin
   EnterCS(StatCS);
   FDCD := False;
   UpdateLineStatus;
   LeaveCS(StatCS);
end;

function _recv(var AHandle: TSocket; var Buf; var Size: Integer; var Error: Boolean; OL: POverlapped): Integer;
var
  B: TWSABuf;
  Flags: DWORD;
  i: Integer;
  Actually: DWORD;
begin
  if WinSock2 then begin
    Result := 0;
    B.Buf := @Buf;
    B.Len := Size;
    Flags := 0;
    Actually := 0;
    case WSARecv(AHandle, @B, 1, Actually, Flags, OL, nil) of
      0 : Result := Actually;
      SOCKET_ERROR:
        begin
          i := WSAGetLastError;
          case i of
            WSA_IO_PENDING:
              begin
                Flags := 0;
                Actually := 0;
                if WSAGetOverlappedResult(AHandle, OL^, Actually, True, Flags) then begin
                  Result := Actually;
                end else begin
                  Error := True;
                end
              end;
            else Error := True;
          end;
        end;
      else Error := True;
    end;
    if Error then Result := 0;
  end else begin
    Result := recv(AHandle, Buf, Size, 0);
    if Result = SOCKET_ERROR then begin Result := 0; Error := True end;
  end;
end;

function TSockInThread.SubRead(var Buf; Size: Integer): Integer;
var
  Error: Boolean;
  SockHandle: TSocket;
  IpSessionCount: integer;
begin
  if Terminated then Result := 0 else
  begin
    Error := False;
    SockHandle := TSocket(CP.Handle);
    Result := _recv(SockHandle, Buf, Size, Error, @CP.ReadOL);
    if Error then begin
      TSockPort(CP).Err;
      Result := 0
    end;
    if Terminated then Result := 0 else
    if (Result = 0) and (not CP.TempDown) then begin
      TSockPort(CP).DropDCD;
      Terminated := True
    end;
    Inc(TIPMonThread(IPMon).TCPIP_In, Result);

    // visual. Incoming traffic shaper.

    IpSessionCount := (Cfg.IpData.OutC - OutConnsAvail) + (Cfg.IpData.InC - SockMgr.SocksAvail);
    if (CP.MaxBPSIn > 0) then
      if (TIPMonThread(IPMon).TCPIP_In >= CP.MaxBPSIn) then
        sleep(trunc(1000 * IpSessionCount / (CP.MaxBPSIn / TIPMonThread(IPMon).TCPIP_In)))
      else

{    if (result > 0) and (Cfg.IpData.InBandwidth > 0) then
      if (TCPIP_InR > Cfg.IpData.InBandwidth) then
        sleep(trunc(1000/(Cfg.IpData.InBandwidth/TIPMonThread(IPMon).TCPIP_In)));}

  end;
end;

function TSockInThread.Read(var Buf; Size: DWORD): DWORD;

var
  AuxSz: DWORD;

procedure ParseAux(var Arr: TxByteArray; var Rslt: DWORD);

var
  ofs: DWORD;

procedure DoIt;

function DoFilter(B: Byte; var I: Byte): Boolean;
begin
  Result := TSockPort(CP).Filter.InFilter(B, I);
end;

begin
  repeat
    GotChar := DoFilter(Arr[Ofs], Arr[Rslt]);
    if GotChar then Inc(Rslt);
    Inc(Ofs);
    if (Rslt = Size) or (Ofs = AuxSz) then Exit;
  until False;
end;

begin
  Rslt := 0;
  Ofs := 0;
  if AuxSz = 0 then Exit;
  DoIt;
end;

begin
  Result := 0;
  AuxSz := SubRead(Buf, Size);
  if Terminated then Exit;
  if TSockPort(CP).Filter = nil then Result := AuxSz else ParseAux(TxByteArray(Buf), Result);
end;

class function TSockInThread.ThreadName;
begin
   Result := 'Interface in  (IP)';
end;

function _send(var AHandle: TSocket; const Buf; var Size: Integer; var Error: Boolean; OL: POverlapped): Integer;
var
  B: TWSABuf;
  Flags,
  Actually: DWORD;
  i: Integer;
begin
  if WinSock2 then begin
    Result := 0;
    B.Buf := @Buf;
    B.Len := Size;
    Actually := 0;
    i := WSASend(AHandle, @B, 1, Actually, 0, OL, nil);
    case i of
      0 : Result := Actually;
      SOCKET_ERROR:
        begin
          i := WSAGetLastError;
          case i of
            WSA_IO_PENDING:
              begin
                Actually := 0;
                if WSAGetOverlappedResult(AHandle, OL^, Actually, True, Flags) then begin
                  Result := Actually;
                end else begin
                  Error := True;
                end;
              end;
            else Error := True;
          end;
        end;
      else Error := True;
    end;
    if Error then Result := 0;
  end else begin
    Result := send(AHandle, (@Buf)^, Size, 0);
    if Result = SOCKET_ERROR then begin Error := True; Result := 0 end;
  end;
end;

function TSockOutThread.SubWrite(const Buf; Size: Integer): Integer;
var
  Error: Boolean;
  SockHandle: TSocket;
  IpSessionCount: integer;
begin
  if Terminated then Result := 0 else begin
    Error := False;
    SockHandle := TSocket(CP.Handle);
    Result := _send(SockHandle, Buf, Size, Error, @CP.WriteOL);
    if Error then begin
      TSockPort(CP).Err;
      Result := 0
    end;
    if Terminated then Result := 0 else
    if (Result = 0) and (not CP.TempDown) then begin
       TSockPort(CP).DropDCD;
       Terminated := True;
    end;
    Inc(TIPMonThread(IPMon).TCPIP_Out, Result);

    // visual. Outgoing traffic shaper.
    IpSessionCount := (Cfg.IpData.OutC - OutConnsAvail) + (Cfg.IpData.InC - SockMgr.SocksAvail);
    if (result > 0) and (CP.MaxBPSOut > 0) and (IpSessionCount > 0) then
      if (TIPMonThread(IPMon).TCPIP_Out >= CP.MaxBPSOut) then
        sleep(trunc(1000 * IpSessionCount / (CP.MaxBPSOut / TIPMonThread(IPMon).TCPIP_Out)));

{    if (result > 0) and (Cfg.IpData.OutBandwidth > 0) then
      if (TCPIP_OutR > Cfg.IpData.OutBandwidth) then
        sleep(trunc(1000/(Cfg.IpData.OutBandwidth/TCPIP_OutR)));}
  end;
end;

function TSockOutThread.Write(const Buf; Size: DWORD): DWORD;

procedure ParseAux(const Arr: TxByteArray; var Rslt: DWORD);

function DoFilter(B: Byte; var I: Byte): Boolean;
begin
  Result := TSockPort(CP).Filter.OutFilter(B, I);
end;

begin
   repeat
      while More do begin
         More := DoFilter(0, AuxO[AuxSz]);
         Inc(AuxSz); if AuxSz = Size then Exit;
      end;
      while not More do begin
         More := DoFilter(Arr[Rslt], AuxO[AuxSz]);
         Inc(Rslt); Inc(AuxSz);
         if (Rslt = Size) or (AuxSz = PortWriteBlockSize) then Exit;
      end;
   until Terminated;
end;

procedure Flsh;
var
   i: Integer;
begin
   if AuxSz > 0 then repeat
      i := SubWrite(AuxO, AuxSz);
      Dec(AuxSz, i);
      if AuxSz > 0 then begin
         Move(AuxO[i], AuxO[0], AuxSz);
         if Result = 0 then Break;
      end else Break;
   until Terminated;
end;

begin
   EnterCS(TSockPort(CP).SockW);
   if TSockPort(CP).Filter = nil then Result := SubWrite(Buf, Size) else begin
      Result := 0;
      Flsh;
      if AuxSz = 0 then begin
         ParseAux(TxByteArray(Buf), Result);
         Flsh;
      end;
   end;
   LeaveCS(TSockPort(CP).SockW);
end;

class function TSockOutThread.ThreadName;
begin
   Result := 'Interface out (IP)';
end;

function OpenPort(AHandle: TSocket; Typ: TProtCore; IpPort: DWORD): TSockPort;
var
   F: TTelnetFilter;
begin
   if Typ = ptTelnet then F := TTelnetFilter.Create else F := nil;
   Result := TSockPort.Create(AHandle, F, IpPort, Typ);
   if F <> nil then F.Init;
end;

procedure TSockListen.TheEnd;
begin
   Terminated := True;
   if WinSock2 then begin
      SetEvt(oAccept);
   end else begin
    __close(SocketHandle);
   end;
end;

class function TSockListen.ThreadName: string;
begin
   Result := 'Socket Listener';
end;

function TSockListen.RecreateHandle: Boolean;
var
   LocalAdr: TSockAddr;
begin
   Result := False;
   SocketHandle := __socket;
   if SocketHandle = INVALID_SOCKET then Exit;
   if __reuse(SocketHandle) = SOCKET_ERROR then Exit;
   if __bind(SocketHandle, IpPort, LocalAdr) = SOCKET_ERROR then Exit;
   if WinSock2 then begin
      if __setblock(SocketHandle, 1) = SOCKET_ERROR then Exit;
   end;
   Result := True;
end;

destructor TSockListen.Destroy;
begin
   __close(SocketHandle);
   if WinSock2 then begin
      ZeroHandle(oAccept);
   end;
   inherited Destroy;
end;

procedure TSockListen.InvokeExec;

var
  RemoteAddr: TSockAddr;
  RemoteAddrLen: Integer;
  NewHandle: TSocket;
  dd: Integer;
  Thr: TSockPort;
  ne: TWSANetworkEvents;

procedure SendStr(const s: string);
begin
  if __setblock(NewHandle, 1) = SOCKET_ERROR then Exit;
  send(NewHandle, (@s[1])^, Length(s), 0);
  if __setblock(NewHandle, 0) = SOCKET_ERROR then Exit;
end;

begin // procedure TSockListen.InvokeExec;
  if Terminated then Exit;
  if not Again then begin
    Again := True;
    listen(SocketHandle, 5);
  end;
  RemoteAddrLen := SizeOf(RemoteAddr);
  if WinSock2 then begin
    WSAEventSelect(SocketHandle, oAccept, FD_ACCEPT);
    WaitEvtInfinite(oAccept);
    if Terminated then Exit;
    Clear(ne, SizeOf(ne));
    dd := WSAEnumNetworkEvents(SocketHandle, oAccept, @ne);
    if dd = SOCKET_ERROR then begin
      Terminated := True;
      Exit
    end;
    if ne.iErrorCode[FD_ACCEPT_BIT] <> 0 then begin
       Terminated := True;
       Exit;
    end;
    NewHandle := WSAAccept(SocketHandle, RemoteAddr, RemoteAddrLen, nil, 0);
  end else begin
    NewHandle := accept(SocketHandle, @RemoteAddr, @RemoteAddrLen);
  end;

  if NewHandle = INVALID_SOCKET then
     Terminated := True else Inc(SocksAlloc);
  if Terminated then begin
    __close(NewHandle);
    Exit;
  end;
  if WinSock2 then begin
    __unblock(NewHandle);
  end;
  SockMgr.NewSocks.Enter;
  if SockMgr.SocksAvail = 0 then begin
    case Typ of
      ptifcico, ptTelnet, ptFTP, ptHTTP, ptPOP3, ptSMTP, ptGATE, ptNNTP: SendStr('BUSY' + ccCR);
      ptBinkP: SendStr(FormatBinkPMsg(M_BSY, 'Too many servers are running'));
      else GlobalFail('%s', ['TSockListen.ThreadExec unknown "Typ"']);
    end;
    Sleep(500); // wait to drain out
    __close(NewHandle);
    SockMgr.NewSocks.Leave;
    Exit;
  end else begin
    Dec(SockMgr.SocksAvail);
    Thr := OpenPort(NewHandle, Typ, IpPort);
    Thr.CallerId := Addr2Inet(RemoteAddr.sin_addr.s_addr);
    dd := IniFile.ReadInteger('Black_List', Thr.CallerID);
    if DWORD(dd) > Cfg.IPData.BList then begin
       Thr.Msg := 'Carrier dropped (address is blacklisted), BL = ' + IntToStr(dd);
       Thr.DropDCD;
    end;
    Thr.Incoming := True;
    SockMgr.NewSocks.Insert(Thr);
    SockMgr.NewSocks.Leave;
    SetEvt(SockMgr.oNewSocks);
  end;
end;

class function TInSockMgr.ThreadName: string;
begin
   Result := 'Socket Acceptor';
end;

procedure TInSockMgr.InvokeExec;
var
   P: TSockPort;
   NL: TNewIpInLine;
begin
   WaitEvtInfinite(oNewSocks);
   if Terminated then Exit;
   NewSocks.Enter;
   while NewSocks.Count > 0 do begin
      P := NewSocks[0];
      NewSocks.AtDelete(0);
      NL := TNewIpInLine.Create;
      NL.Port := P;
      NL.Prot := P.Typ;
      NL.IpPort := P.IpPort;
      NL.aTyp := P.aType;
     _PostMessage(MainWinHandle, WM_NEWSOCKPORT, 0, Integer(NL));
   end;
   NewSocks.Leave;
end;

constructor TInSockMgr.Create;
begin
   inherited Create;
   Priority := tpLower;
   oNewSocks := CreateEvtA;
   NewSocks := TColl.Create;
   ListeningSocks := TColl.Create;
end;

destructor  TInSockMgr.Destroy;
begin
   ZeroHandle(oNewSocks);
   FreeObject(ListeningSocks);
   FreeObject(NewSocks);
   inherited Destroy;
end;

procedure CreateListeningSocket(APort: Integer; ATyp: TProtCore);
var
  Thr: TSockListen;
begin
  Thr := TSockListen.Create;
  if WinSock2 then
  begin
    Thr.oAccept := CreateEvt(False);
  end;
  Thr.Typ := ATyp;
  Thr.IpPort := APort;
  Thr.Priority := tpLower;
  if Thr.RecreateHandle then
  begin
    Thr.Suspended := False;
    SockMgr.ListeningSocks.Insert(Thr);
  end else
  begin
    Thr.Terminated := True;
    __close(Thr.SocketHandle);
    Thr.Suspended := False;
    Thr.WaitFor;
    FreeObject(Thr);
  end;
end;

var
  ConnThrs: TColl;
  ResolveThr: TResolveThread;

procedure HostResolveComplete(Idx, lParam: Integer);
begin
  if (ResolveThr = nil) or (ResolveThr.Terminated) then Exit;
  EnterCS(ResolveThr.CS);
  ResolveThr.HostResolveComplete(Idx, lParam);
  LeaveCS(ResolveThr.CS);
end;

function RunDaemon;

procedure DoIt(var A: TvIntArr; Typ: TProtCore);
var
  i: Integer;
begin
  for i := 0 to A.Cnt - 1 do CreateListeningSocket(A.Arr^[I], Typ);
end;

var
  d: TWSAData;
  i: Integer;

begin
  Result := False;
  if not WSAStarted then
  begin
    if Win32Platform = VER_PLATFORM_WIN32_NT then
    begin
      i := WSAStartup(2, d);
    end else
    begin
      i := WSAStartup($101, d);
    end;
    if i <> 0 then
    begin
      DisplayError(Format('Can''t initialize sockets API, error #%d', [i]), 0);
      Exit;
    end;
    WSAStarted := True;
  end;
  ConnThrs := TColl.Create;
  ResolveThr := TResolveThread.Create;
  SockMgr := TInSockMgr.Create;
  SockMgr.SocksAvail := Params.InConns;
  OutConnsAvail := Params.OutConns;
  DoIt(Params.ifcico, ptifcico);
  DoIt(Params.Telnet, ptTelnet);
  DoIt(Params.BinkP, ptBinkP);
  {$IFDEF EXTREME}
  DoIt(Params.FTP,  ptFTP );
  DoIt(Params.HTTP, ptHTTP);
  DoIt(Params.SMTP, ptSMTP);
  DoIt(Params.POP3, ptPOP3);
  DoIt(Params.GATE, ptGATE);
  DoIt(Params.NNTP, ptNNTP);
  {$ENDIF}
  ResolveThr.Suspended := False;
  SockMgr.Suspended := False;
  IPMon := TIpMonThread.Create;
  IPMon.Suspended := False;
  Result := True;
end;

type
  TWSAConnectThread = class(T_Thread)
    ReadOL, WriteOL : TOverLapped;
    SocketConnected: Boolean;
    Addr: string;
    cr: TWSAConnectResult;
    Port: DWORD;
    Prot: TProtCore;
    aTyp: DWORD;
    oBlk: THandle;
    FSocket: TSocket;
    FProxyFlag: boolean;
    function ProxyFlag(p: Pointer): boolean;
    procedure InvokeExec; override;
    constructor Create(const AAddr: string; p: Pointer; AProt: TProtCore; APort: Integer; AType: DWORD);
    destructor Destroy; override;
    class function ThreadName: string; override;
  public
    procedure TheEnd;
  end;

procedure EndSockMgr;
begin
  SockMgr.Terminated := True;
  ResolveThr.Terminated := True;
  SetEvt(SockMgr.oNewSocks);
  SetEvt(ResolveThr.oAsyncAvail);
  SetEvt(ResolveThr.oStartResolve);
  SockMgr.WaitFor;
  ResolveThr.WaitFor;
end;

procedure EndIpThreads;
var
  i: Integer;
  s: TSockListen;
  c: TWSAConnectThread;
begin
  for i := 0 to SockMgr.ListeningSocks.Count - 1 do begin s := SockMgr.ListeningSocks[i]; s.TheEnd end;
  for i := 0 to ConnThrs.Count - 1 do begin c := ConnThrs[i]; c.TheEnd end;
  for i := 0 to SockMgr.ListeningSocks.Count - 1 do begin s := SockMgr.ListeningSocks[i]; s.WaitFor end;
  for i := 0 to ConnThrs.Count - 1 do begin c := ConnThrs[i]; c.WaitFor end;
end;

procedure ShutdownDaemon;
var
  e: Integer;
begin
  if not WSAStarted then exit;
  ConnThrs.FreeAll;
  FreeObject(ConnThrs);
  SockMgr.ListeningSocks.FreeAll;
  FreeObject(SockMgr);
  FreeObject(ResolveThr);
  if SocksAlloc <> 0 then
  begin
    if not IniFile.DisableWinsockTraps then GlobalFail('SocksAlloc = %d after ShutdownDaemon', [SocksAlloc]);
  end;
  if not SkipCleanup then
  begin
    e := WSACleanup;
    if e <> 0 then  GlobalFail('WSACleanUp Error %d (%s)', [e, WSAErrMsg(e)]);
    WSAStarted := False;
  end;
end;

procedure PurgeConnThrs;
var
  i: Integer;
  t: TWSAConnectThread;
begin
  ConnThrs.Enter;
  for i := ConnThrs.Count - 1 downto 0 do
  begin
    t := ConnThrs[i];
    if not t.Terminated then Continue;
    t.WaitFor;
    ConnThrs.AtFree(i);
  end;
  ConnThrs.Leave;
end;

function Addr2Inet(i: DWORD): string;
begin
  Result := Format('%d.%d.%d.%d', [
        (i shr  0) and $FF,
        (i shr  8) and $FF,
        (i shr 16) and $FF,
        (i shr 24) and $FF
        ]);
end;

class function TWSAConnectThread.ThreadName: string;
begin
  Result := 'Socket Connector';
end;

procedure TWSAConnectThread.TheEnd;
begin
  if WaitForSingleObject(FThreadHandle, 0) = WAIT_OBJECT_0 then begin
     Terminated := True;
     Exit;
  end;
  Suspend;
  Terminated := True;
  SetEvt(oBlk);
  if WinSock2 then
  begin
    if ProxyEnabled and FProxyFlag then
    begin
      SetEvt(ReadOL.hEvent);
      SetEvt(WriteOL.hEvent);
    end;
  end else
  begin
    if ProxyEnabled and FProxyFlag then
    begin
      if (FSocket <> 0) and (FSocket <> INVALID_SOCKET) and SocketConnected then
      begin
        SocketConnected := False;
        __shutdown(FSocket);
      end;
    end;
  end;
  Resume;
end;

function CoolResolve(const Addr: string; oBlk: DWORD; var Error: Integer): DWORD;
var
  i: Integer;
  ia: DWORD;
  aa: string;
  req: TResolveRequest;
  rsp: TResolveResponse;
begin
  ia := Inet2Addr(Addr);
  if ia = INADDR_NONE then
  begin
    aa := Sym2Addr(Addr);
    if aa <> '' then begin
       req := TResolveRequest.Create;
       req.HostName := StrAsg(aa);
       req.oEvt := oBlk;
       EnterCS(ResolveThr.CS);
       ResolveThr.InReq.Insert(req);
       SetEvt(ResolveThr.oStartResolve);
       LeaveCS(ResolveThr.CS);
       WaitEvtInfinite(oBlk);
       ResetEvt(oBlk);
       EnterCS(ResolveThr.CS);
       for i := 0 to ResolveThr.Resp.Count - 1 do begin
         rsp := ResolveThr.Resp[i];
         if rsp.HostName = aa then begin
           if rsp.Error = 0 then ia := rsp.Addr else begin
             ia := INADDR_NONE;
             Error := rsp.Error;
           end;
         end;
       end;
       LeaveCS(ResolveThr.CS);
    end;
  end;
  Result := ia;
end;

function Socks4Request(AHandle, AAddr, APort: DWORD; ReadOL, WriteOL: POverlapped; Method: byte; FBindAddr: string): Integer;
var
  Buf: array[0..255] of char;
  BufLen: integer;
  Error: Boolean;
  i: Integer;
  r: TSocksRequest;
  p: PxByteArray;
  SocksReplySize : Integer;

begin
  Error := False;
  result := 0;

  if Method <> SOCKS_ACCEPT then
  begin

    Clear(r, cszr);
    r.VN := SOCKS_VERSION_4;
    r.CD := Method;
    r.DstPort := htons(APort);
    if AAddr = INADDR_NONE then r.DstIP := $1
                           else r.DstIP := AAddr;
    p := @r;
    BufLen := cszr;

    i:=_send(AHandle, p^, BufLen, Error, WriteOL);
    if Error then begin Result := WSAGetLastError; Exit end;
    if i <= 0 then begin Result := -91; Exit end; //SOCKS request rejected or failed;
    BufLen:=0;

    FillChar(Buf, SizeOf(Buf), 0);
    if Length(IniFile.ProxyUserName) <= 0 then IniFile.ProxyUserName := 'TAURUS';
    Move(IniFile.ProxyUserName[1], Buf[BufLen], Length(IniFile.ProxyUserName));
    Inc(BufLen, Length(IniFile.ProxyUserName));
    Buf[BufLen] := #0;
    Inc(BufLen);

    if AAddr = INADDR_NONE then // SOCKS4A
    begin
      FBindAddr := Sym2Addr(FBindAddr);
      DbgStr('SOCKS4A: Connect to %s', [FBindAddr]);
      if Length(FBindAddr) > 0 then
      begin
        Move(FBindAddr[1], Buf[BufLen], Length(FBindAddr));
        Inc(BufLen, Length(FBindAddr));
        Buf[BufLen]:= #0;
        Inc(BufLen);
      end;
    end;

    i := _send(AHandle, Buf[0], BufLen, Error, WriteOL);
    if Error then begin Result := WSAGetLastError; Exit end;
    if i <= 0 then begin Result := -91; Exit end; //SOCKS request rejected or failed;

    Clear(r, cszr);
    SocksReplySize := cszr;
    BufLen := _recv(AHandle, p^[0], SocksReplySize, Error, ReadOL);
    if Error then begin Result := WSAGetLastError; Exit end;
    if (BufLen < 2) or (r.VN <> 0) then begin Result := -1; Exit; end;
    if r.CD <> 90 then begin
      Result := -r.CD;
      exit;
    end;
    Result := 0;
  end;

end;

function Socks5Login(AHandle: DWORD; ReadOL, WriteOL: POverlapped): integer;
var
  Buf: array[0..255] of char;
  UserLen,
  PassLen: byte;
  BufLen: integer;
  Error: boolean;
begin
  Error := False;
  Buf[0]:= SOCKS_LOGIN_VERSION;
  UserLen:= Length(IniFile.ProxyUserName);
  Buf[1]:= char(UserLen);
  Move(IniFile.ProxyUserName[1], Buf[2], UserLen);
  Inc(UserLen, 2);
  PassLen:= Length(IniFile.ProxyPassword);
  Buf[UserLen]:= char(PassLen);
  Move(IniFile.ProxyPassword[1], Buf[UserLen + 1], PassLen);
  Inc(PassLen);
  BufLen := UserLen + PassLen;

  BufLen := _send(AHandle, Buf[0], BufLen, Error, WriteOL);
  if Error then begin
    Result := WSAGetLastError;
    DbgStr(WSAErrMsg(Result), []);
    Exit
  end;

  BufLen := 2;
  Error := False;
  UserLen := _recv(AHandle, Buf[0], BufLen, Error, ReadOL);

  if (UserLen < 2) or (Buf[0] <> SOCKS_LOGIN_VERSION) then begin
    Result := -1;
    Exit
  end;

  if Buf[1] <> #00 then begin
    Result := -1;
    Exit
  end;

  Result := 0;
end;

function Socks5Request(AHandle, AAddr, APort: DWORD; ReadOL, WriteOL: POverlapped; Method: byte; FBindAddr: string): Integer;
var
  Buf: array[0..255] of char;
  BufLen: integer;
  Error: Boolean;
  DstPort: WORD;
//  DstAddr: DWORD;
//  p: pointer;
begin
  result := 0;
  Error := False;
  if Method <> SOCKS_ACCEPT then begin
    // supported 2 authentication methods
    Buf[0] := chr(SOCKS_VERSION_5);
    Buf[1] := #2;
    Buf[2] := chr(SOCKS_NOAUTH);
    Buf[3] := chr(SOCKS_USERPASS);

    BufLen := 4;
    _send(AHandle, Buf[0], BufLen, Error, WriteOL);
    if Error then begin
      Result := WSAGetLastError;
      DbgStr(WSAErrMsg(Result),[]);
      Exit
    end;

    BufLen := 2;
    BufLen := _recv(AHandle, Buf[0], BufLen, Error, ReadOL);

    if Buf[0] <> chr(SOCKS_VERSION_5) then begin Result := -1; exit; end;
    if Buf[1] = chr(SOCKS_USERPASS) then Socks5Login(AHandle, ReadOL, WriteOL) else
    if Buf[1] <> chr(SOCKS_NOAUTH) then begin Result := -1; exit; end;

    Buf[0] := chr(SOCKS_VERSION_5);
    Buf[1] := chr(Method);
    Buf[2] := #0;

    if AAddr = INADDR_NONE then begin
      Buf[3] := SOCKS_TYPENAME;
      FBindAddr := Sym2Addr(FBindAddr);
      BufLen := Length(FBindAddr);
      Buf[4] := char(BufLen);
      Move(FBindAddr[1], Buf[5], BufLen);
      Inc(BufLen, 5);
    end else begin
      Buf[3] := SOCKS_TYPEIP4;
      BufLen := 4;
      Move(AAddr, Buf[BufLen], BufLen);
      Inc(BufLen, 4);
    end;

    DstPort := htons(APort);
    Move(DstPort, Buf[BufLen], 2);
    Inc(BufLen, 2);

    BufLen:=_send(AHandle, Buf[0], BufLen, Error, WriteOL);
    if Error then begin
      Result := WSAGetLastError;
      DbgStr(WSAErrMsg(Result), []);
      Exit
    end;

    BufLen := 4;
    BufLen := _recv(AHandle, Buf[0], BufLen, Error, ReadOL);

    if Buf[0] <> chr(SOCKS_VERSION_5) then begin Result := -1; exit; end;
    if Buf[1] <> #0 then begin Result := -1; exit; end;

    case Buf[3] of
      SOCKS_TYPEIP4 : begin
                        BufLen := 6;
                        BufLen := _recv(AHandle, Buf[0], BufLen, Error, ReadOL);
                        FBindAddr := Format('%d.%d.%d.%d',
                                         [byte(Buf[0]), byte(Buf[1]),
                                          byte(Buf[2]), byte(Buf[3])]);
//                        APort:= MakeWord(byte(Buf[5]),byte(Buf[4]));
                      end;
      SOCKS_TYPENAME: begin
                        BufLen := 1;
                        BufLen := _recv(AHandle, Buf[0], BufLen, Error, ReadOL);

                        BufLen := byte(Buf[0]);
                        BufLen := _recv(AHandle, Buf[0], BufLen, Error, ReadOL);
                        SetString(FBindAddr, PChar(@Buf[0]), BufLen);

                        BufLen := 2;
                        BufLen := _recv(AHandle, Buf[0], BufLen, Error, ReadOL);
//                        APort:= MakeWord(byte(Buf[1]),byte(Buf[0]));
                      end;
    end; { case }

    Result := 0;
  end;
end;

function Connect2HttpProxy(AHandle, AAddr, APort: DWORD; ReadOL, WriteOL: POverlapped; const FBindAddr: string): Integer;
var
  j,
  i: Integer;
  HttpCmd,
  ProxyAnswer,
  AuthInfo: string;
  Error: Boolean;
  C: array [0..255] of byte;

begin
  Result := 0;
  Error := False;

  if AAddr = INADDR_NONE then HttpCmd := Format(HttpProxyCommand[IniFile.ProxyType],[Sym2Addr(FBindAddr),APort])
  else HttpCmd := Format(HttpProxyCommand[IniFile.ProxyType], [Addr2Inet(AAddr),APort]);
  j := Length(HttpCmd);
  DbgStr('send: %s, length = %d',[EscapeChars(HttpCmd), j]);
  i := _send(AHandle, HttpCmd[1], j, Error, WriteOL);
  DbgStr('result: bytes sent = %d, error = %d', [i, Integer(Error)]);
  if Error then begin Result := WSAGetLastError; Exit end;
  if i <> j then begin Result := -1; Exit end; //HTTP request rejected or failed;

  if IniFile.EnableProxyAuth then begin
    AuthInfo := EncodeB64(Format('%s:%s', [IniFile.ProxyUserName, IniFile.ProxyPassword]));
    HttpCmd := Format('Proxy-Authorization: Basic %s'#13#10, [AuthInfo]);
    j := Length(HttpCmd);
    DbgStr('send: %s, length = %d',[EscapeChars(HttpCmd), j]);
    i := _send(AHandle, HttpCmd[1], j, Error, WriteOL);
    DbgStr('result: bytes sent = %d, error = %d', [i, Integer(Error)]);
    if Error then begin Result := WSAGetLastError; Exit end;
    if i <> j then begin Result := -1; Exit end; //HTTP request rejected or failed;
  end;

  HttpCmd := #13#10;
  j := Length(HttpCmd);
  DbgStr('send: %s, length = %d',[EscapeChars(HttpCmd), j]);
  i := _send(AHandle, HttpCmd[1], j, Error, WriteOL);
  DbgStr('result: bytes sent = %d, error = %d', [i, Integer(Error)]);
  if Error then begin Result := WSAGetLastError; Exit end;
  if i <> j then begin Result := -1; Exit end; //HTTP request rejected or failed;

  j := 256;
  DbgStr('wait for proxy answer ...',[]);
  i := _recv(AHandle, C, j, Error, ReadOL);
  DbgStr('result: bytes recv = %d, error = %d',[i, Integer(Error)]);
  if Error then begin Result := WSAGetLastError; Exit end;
  if i = 0 then begin Result := -1; Exit end; //connection has been gracefully closed
  ProxyAnswer := PChar(@C[0]);
  ProxyAnswer := copy(ProxyAnswer, 1, i - 1);
  DbgStr('answer: %s', [EscapeChars(ProxyAnswer)]);
  if Pos(' 200 ', ProxyAnswer) = 0 then Result := -1;
end;

function ConnectProxy(AHandle, AAddr, APort: DWORD; ReadOL, WriteOL: POverlapped; const FBindAddr: string): Integer;
begin
  case IniFile.ProxyType of
    ptSocks4:
      result := Socks4Request(AHandle, AAddr, APort, ReadOL, WriteOL, SOCKS_CONNECT, FBindAddr);
    ptSocks5:
      result := Socks5Request(AHandle, AAddr, APort, ReadOL, WriteOL, SOCKS_CONNECT, FBindAddr);
    ptHttpPut,
    ptHttpConnect:
      result := Connect2HttpProxy(AHandle, AAddr, APort, ReadOL, WriteOL, FBindAddr);
    else
      result := 0; //???
  end;
  if Result <> 0 then DbgStr(WSAErrMsg(Result), []);
end;

procedure TWSAConnectThread.InvokeExec;

var
 ia: DWORD;
 dd: Integer;

function DoIt: Integer;
var
  Adr: TSockAddr;
  ne: TWSANetworkEvents;
  FAddr, FPort: DWORD;
  _Adr: string;
  ss: TStringList;
  i: integer;
  s: string;
begin
  Result := WSANO_DATA;
  _Adr := Addr;
  if Prot = ptSMTP then begin
     ss := IniFile.ReadSection('Grids', 'gPOP3');
     if ss <> nil then begin
        for i := 0 to ss.Count - 1 do begin
           s := IniFile.ReadString('Grids', ss[i]);
           if MatchMaskAddressListSingle(TFidoPoll(cr.p).Node.Addr, ExtractWord(5, s, ['|'])) then begin
              _Adr := ExtractWord(1, ExtractWord(1, s, ['|']), [':']);
              break;
           end;
        end;
        ss.Free;
     end;
  end;
  ia := CoolResolve(_Adr, oBlk, Result);
  if ia = INADDR_NONE then
    if ProxyEnabled and FProxyFlag {and (IniFile.ProxyType = ptSocks4) }then //visual
    else Exit;

  cr.ResolvedAddr := ia;
  if Terminated then Exit;
  FSocket := __socket;
  if FSocket = INVALID_SOCKET then begin Result := WSAGetLastError; Exit end;
  if Terminated then Exit;

  if WinSock2 then
  begin
    __setblock(FSocket, 1);
  end;

  Adr.sin_family := AF_INET;

  if ProxyEnabled and FProxyFlag then
  begin
    FPort := ProxyPort;
    FAddr := CoolResolve(ProxyAddr, oBlk, Result);
    if FAddr = INADDR_NONE then Exit;
  end else
  begin
    FPort := Port;
    FAddr := ia;
  end;

  Adr.sin_port        := htons(FPort);
  Adr.sin_addr.s_addr := FAddr;

  if WinSock2 then
  begin
    dd := WSAEventSelect(FSocket, oBlk, FD_CONNECT);
    if dd = SOCKET_ERROR then
    begin
      Result := WSAGetLastError; Exit
    end;
    dd := WSAConnect(FSocket, Adr, SizeOf(Adr), nil, nil, nil, nil);
    if (dd = SOCKET_ERROR) then
    begin
      Result := WSAGetLastError;
      if Result <> WSAEWOULDBLOCK then Exit;
      WaitEvtInfinite(oBlk);
      if Terminated then Exit;
      Clear(ne, SizeOf(ne));
      dd := WSAEnumNetworkEvents(FSocket, oBlk, @ne);
      if dd = SOCKET_ERROR then
      begin
        Result := WSAGetLastError; Exit
      end;
      Result := ne.iErrorCode[FD_CONNECT_BIT]; {!!!}
      if Result <> 0 then Exit;
    end;
  end else
  begin
    dd := connect(FSocket, Adr, SizeOf(Adr));
    if dd = SOCKET_ERROR then
    begin
      Result := WSAGetLastError; Exit
    end;
  end;

  if Terminated then Exit;

  SocketConnected := True;

  if ProxyEnabled and FProxyFlag then // visual
  begin
    Result := ConnectProxy(FSocket, ia, Port, @ReadOL, @WriteOL, Addr);
    if Result <> 0 then Exit;
  end;

  if Terminated then Exit;

  if WinSock2 then
  begin
    __unblock(FSocket);
  end;

  Result := 0;
  cr.Prot := Prot;
  cr.Error := False;
end;

begin  // procedure TWSAConnectThread.InvokeExec;
  FSocket := INVALID_SOCKET;
  cr.Res := DoIt;
  cr.Addr := Addr;
  cr.Prot := Prot;
  cr.Terminated := Terminated;
  if (not cr.Terminated) and (not cr.Error) then cr.Port := OpenPort(FSocket, Prot, cr.IpPort);
  if (cr.Port = nil) then begin
    __close(FSocket);
    Inc(OutConnsAvail);
  end;
  if cr.Port <> nil then begin
    if ia = INADDR_NONE then TDevicePort(cr.Port).CallerId := ProxyAddr
    else TDevicePort(cr.Port).CallerId := Addr2Inet(ia);
  end;
  _PostMessage(MainWinHandle, WM_CONNECTRES, 0, Integer(cr));
  Terminated := True;
end;

// PROXY flag is present ?
function TWSAConnectThread.ProxyFlag;
var
  f: TStringColl;
begin
  Result := False;
  if p = nil then exit;
  f := TStringColl.Create;
  f.FillEnum(TFidoPoll(p).IPFlags, ',', True);
  if IniFile.AllViaProxy then result := not f.Found('NOPROXY')
  else result := f.Found('PROXY');
  FreeObject(f);
end;

constructor TWSAConnectThread.Create;
begin
  inherited Create;
  FProxyFlag := ProxyFlag(p);
  if WinSock2 then
  begin
    if ProxyEnabled and FProxyFlag then begin
      ReadOL.hEvent := CreateEvt(False);
      WriteOL.hEvent := CreateEvt(False);
    end;
  end;
  cr := TWSAConnectResult.Create;
  cr.IpPort := APort;
  cr.aTyp := AType;
  cr.p := p;
  cr.ResolvedAddr := INADDR_NONE;
  cr.Error := True;
  Port := APort;
  Prot := AProt;
  aTyp := AType;
  Priority := tpLowest;
  Addr := AAddr;
  oBlk := CreateEvt(False);
end;

destructor TWSAConnectThread.Destroy;
begin
  if WinSock2 then begin
    if ProxyEnabled and FProxyFlag then begin
      ZeroHandle(ReadOL.hEvent);
      ZeroHandle(WriteOL.hEvent);
    end;
  end;
  ZeroHandle(oBlk);
  inherited Destroy;
end;

procedure _WSAConnect;
var
  thr: TWSAConnectThread;
begin
  thr := TWSAConnectThread.Create(Addr, p, AProt, APort, aType);
  ConnThrs.Enter;
  ConnThrs.Insert(thr);
  ConnThrs.Leave;
  Dec(OutConnsAvail);
  thr.Suspended := False;
end;

class function TIPMonThread.ThreadName: string;
begin
  Result := 'TCP/IP Monitor';
end;

constructor TIPMonThread.Create;
begin
  inherited Create;
  Priority := tpHighest;
  InitializeCriticalSection(TCPIP_GrCS);
end;

destructor TIPMonThread.Destroy;
begin
  PurgeCS(TCPIP_GrCS);
  inherited Destroy;
end;

procedure TIPMonThread.InvokeExec;
var
   _in,
  _out,
   i: Integer;
begin
   if not Again then begin
      Again := True;
      for i := 0 to TCPIP_GrDataSz - 1 do begin
         TCPIP_OutGr[i] := -1;
         TCPIP_InGr[i] := -1;
      end;
   end;
   Move(MemOut[0], MemOut[1], (DaemonMemSize - 1) * SizeOf(Integer));
   MemOut[0] := 0; XChg(TCPIP_Out, MemOut[0]);
   Move(MemIn[0], MemIn[1], (DaemonMemSize - 1) * SizeOf(Integer));
   MemIn[0] := 0; XChg(TCPIP_In, MemIn[0]);
   Inc(TCPIP_GrStep);
   EnterCS(TCPIP_GrCS);
   _in := 0; for i := 0 to DaemonMemSize - 1 do Inc(_in, MemIn[i]);
   _out := 0; for i := 0 to DaemonMemSize - 1 do Inc(_out, MemOut[i]);
   Move(TCPIP_OutGr[1], TCPIP_OutGr[0], (TCPIP_GrDataSz - 1) * SizeOf(Integer));
   TCPIP_OutGr[TCPIP_GrDataSz - 1] := _out;
   TCPIP_OutR := _out;
   Move(TCPIP_InGr[1], TCPIP_InGr[0], (TCPIP_GrDataSz - 1) * SizeOf(Integer));
   TCPIP_InGr[TCPIP_GrDataSz - 1] := _in;
   TCPIP_InR := _in;
   LeaveCS(TCPIP_GrCS);
   Sleep(1000);
end;

procedure TSockPort.SleepDown;
begin
  ResetEvt(oTempDown);
  TempDown := True;
  SetEvt(ReadOL.hEvent);
  SetEvt(StatOL.hEvent);
end;

procedure TSockPort.WakeUp;
begin
  TempDown := False;
  SetEvt(oTempDown);
end;

procedure TSockPort.SaveParams;
begin
end;

procedure TSockPort.RestoreParams;
begin
end;

procedure TSockPort.HWPurge(Typ: TTxRxSet);
begin
end;

function ConnectToRemoteHost;
var
  FAddr,
  FPort: DWORD;
  Adr: TSockAddr;
  Thr: TSockPort;
  dd: Integer;

begin

  Result := 0;

  FSocket := __socket;
  if FSocket = INVALID_SOCKET then begin Result := WSAGetLastError; Exit end;

  oBlk := CreateEvt(False);

  FAddr := CoolResolve(AAddr, oBlk, Result);
  if FAddr = INADDR_NONE then exit;
  FPort := APort;

  if WinSock2 then
  begin
    __unblock(FSocket);
  end;

  Adr.sin_family      := AF_INET;
  Adr.sin_port        := htons(FPort);
  Adr.sin_addr.s_addr := FAddr;

  Dec(SockMgr.SocksAvail);
  Thr := TSockPort.Create(FSocket, nil, FPort, ptUndefined);
  Thr.Incoming := False;
  SockMgr.NewSocks.Insert(Thr);
  SockMgr.NewSocks.Leave;
  SetEvt(SockMgr.oNewSocks);

  if WinSock2 then
  begin
    __unblock(FSocket);
  end;

  dd := connect(FSocket, Adr, SizeOf(Adr));
  if dd = SOCKET_ERROR then
  begin
    Result := WSAGetLastError; Exit
  end;

  Thr.Write('hello admin_', 12);

end;

function DisconnectFromRemoteHost;
begin
   __shutdown(FSocket);
   __close(FSocket);
   ZeroHandle(oBlk);
   Result := 0;
end;

function SendToRemoteHost;
var
   Error: Boolean;
  _Buf: array [0..20] of char;
  _BufLen: integer;

begin
   Result := 0;
   Error := False;

  _Buf := 'Hello admin'#13#10#0;
  _BufLen := Length(_Buf);

   Thr.Write(_Buf, _BufLen);

   if Error then begin Result := WSAGetLastError; Exit end;
end;

function ReadFromRemoteHost;
var
   Error: Boolean;
begin
   Result := 0;
   Error := False;
   if Error then begin Result := WSAGetLastError; Exit end;
end;

{$ENDIF}

end.
