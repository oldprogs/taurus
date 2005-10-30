unit xTAPI;

interface

uses
  Windows, xBase, xMisc, Tapi, Classes;

{$I DEFINE.INC}

type

  THandleArray = array[0..9] of THandle;
  TExecsArray = array[0..19] of record
     h: THandle;
     r: DWORD;
  end;

  TTapiPort = class(TSerialPort)
    hCommFile            : THandle;
    Version              : DWORD;
    Line                 : HLINE;
    Call                 : HCALL;
    MediaModes           : DWORD;
    ActivModes           : DWORD;
    bConnected           : boolean;
    PassThrough          : boolean;
    CallHandOff          : boolean;
    Device               : DWORD;
    DevNam               : string;
    fAnswer              : boolean;
    fHandOf              : boolean;
    Messages             : TStringColl;
    TAPILog              : TStringColl;
    Privileges           : DWORD;
    fNeedDrop            : boolean;
    RealOwner            : boolean;
    ModemString          : string;
    WakeEvent            : THandle;
    CriticalSection      : TRTLCriticalSection;
    LinesArray           : THandleArray;
    CallsArray           : THandleArray;
    OldLines             : integer;
    OldCalls             : integer;
    MakingCall           : boolean;
    function  SaveHandle(var a: THandleArray; h: THandle): boolean;
    function  NextHandle(var a: THandleArray): THandle;
    procedure FreeHandle(var a: THandleArray; h: THandle);
    constructor Create(APort: DWORD; AName: string; Pass, Hand: boolean);
    destructor Destroy; override;
    function  Execute(cn: string; rc: long): boolean;
    procedure StorLine(const s: string; const l: boolean);
    function  OpenLine: boolean;
    procedure CloseLine;
    procedure CheckCalls;
    procedure OnConnectionInt;
  protected
    procedure SetAnswer(b: Boolean);
    function  GetNeedDrop: boolean;
    function  GetOnline: integer;
    procedure SetCallID(c: HCALL);
    procedure SetPriority(const yes: boolean = True);
    procedure Enter;
    procedure Leave;
  public
    procedure CheckOpens;
    function  MakeCall: boolean;
    procedure DropHand;
    procedure DropCall;
    procedure HandOff;
    procedure ResetLine;
  published
    property CallID: HCALL read Call write SetCallID;
    property Answer: boolean read fAnswer write SetAnswer;
    property NeedDrop: boolean read GetNeedDrop write fNeedDrop;
    property Online: integer read GetOnline;
  end;

function VerifyUsableLine (id: DWORD): LONG;
function GetLineName(dn: DWORD): string; overload;
function GetLineName(dc: LPLINEDEVCAPS): string; overload;
function GetLineID(n: string): integer;
function FillTAPILines(sl: TStrings): DWORD;

procedure InitTAPI;
procedure FinishTAPI;

implementation

uses
  MlrThr, MlrDefs, SysUtils, RadIni, Recs, Dialogs, Forms, Wizard;

type
   TTapiPortArray = record
      Self: TTapiPort;
   end;

const
   HiVer = $00020000;  // Highest API version wanted   (2.0)
   LoVer = $00010004;  // Lowest  API version accepted (1.4)

var
   TapiInitialized: boolean = False;
   TapiAppHandler : HLINEAPP;
   TapiDevsNumber : integer = 0;
   ThisTapiPort   : TTapiPort;
   TapiPortArray  : array[0..100] of TTapiPortArray;
   ExecsArray     : TExecsArray;
   CallBackEntered: boolean;

procedure SaveTapiPort(Inst: DWORD; Port: TTapiPort);
begin
   TapiPortArray[Inst].Self := Port;
end;

function FindTapiPort(Inst: DWORD): TTapiPort;
begin
   Result := TapiPortArray[Inst].Self;
end;

procedure FreeTapiPort(Inst: DWORD);
begin
   TapiPortArray[Inst].Self := nil;
end;

procedure LineCallbackProc (hDevice,
                            dwMessage,
                            dwInstance,
                            dwParam1,
                            dwParam2,
                            dwParam3 : DWORD); stdcall; far;
var
   ci: TLineCallInfo;
   ii: integer;
begin

  ThisTapiPort := FindTapiPort(dwInstance);
  if (ThisTapiPort = nil) then exit;

  try

  if (dwMessage <> 12) then begin
     ThisTapiPort.StorLine(
        IntToStr(hDevice) + ' ' +
        IntToStr(dwMessage) + ' ' +
        IntToStr(dwParam1) + ' ' +
        IntToStr(dwParam2) + ' ' +
        IntToStr(dwParam3), False);
  end;

  case dwMessage of

  LINE_CLOSE:
     Begin
        thisTAPIPort.Enter;
        thisTAPIPort.Answer := False;
        thisTAPIPort.fHandOf := False;
        thisTAPIPort.Line := 0;
        thisTAPIPort.Call := 0;
        FillChar(ThisTapiPort.LinesArray, SizeOf(THandleArray), #0);
        FillChar(ThisTapiPort.CallsArray, SizeOf(THandleArray), #0);
        thisTAPIPort.StorLine('Line is forcibly closed', True);
        thisTAPIPort.Leave;
     End;

  LINE_CREATE:
     begin
//        FillChar(ThisTapiPort.LinesArray, SizeOf(THandleArray), #0);
        FillChar(ThisTapiPort.CallsArray, SizeOf(THandleArray), #0);
        LineShutDown(TapiAppHandler);
        TapiInitialized := lineInitialize(@TapiAppHandler, GetModuleHandle (nil),
                                           LineCallbackProc,
                                          'Taurus'#0,
                                          @TapiDevsNumber) = 0;
     end;

  LINE_CALLINFO:
     Begin
        case dwParam1 of
        LINECALLINFOSTATE_NUMOWNERDECR:
           begin
              thisTAPIPort.CheckCalls;
           end;
        end;
     End;

  LINE_MONITORMEDIA:
     begin
     end;

  LINE_REPLY:
     Begin
        While CallbackEntered do begin
           Sleep(100);
           Application.ProcessMessages
        end;
        CallBackEntered := True;
        ii := 0;
        while ii < 20 do begin
           if ExecsArray[ii].h = 0 then begin
              ExecsArray[ii].h := dwParam1;
              ExecsArray[ii].r := dwParam2;
              break;
           end;
           inc(ii);
        end;
        CallBackEntered := False;
     End;

  LINE_CALLSTATE:
     Begin
        if (hDevice <> 0) then ThisTapiPort.CallID := hDevice;
        if (dwParam3 <> 0) then begin
           thisTAPIPort.fAnswer := True;
           if dwParam3 = LINECALLPRIVILEGE_OWNER then begin
              thisTAPIPort.RealOwner := true;
           end;              
           if ((thisTAPIPort.Privileges = LINECALLPRIVILEGE_MONITOR) or
               (dwParam1 = LINECALLSTATE_CONNECTED)) and
               (dwParam3 = LINECALLPRIVILEGE_OWNER) then begin
              thisTAPIPort.fAnswer := True;
              if thisTAPIPort.Execute(
                            'lineSetCallParams',
                            lineSetCallParams(
                            hCall(hDevice),
                            LINEBEARERMODE_PASSTHROUGH,
                            0,
                            0,
                            nil)) then begin
                 thisTAPIPort.ModemString := #13#10'CONNECT ' + IntToStr(IniFile.TapiConnect) +'/TAPI'#13#10;
              end;
           end;
           thisTAPIPort.Privileges := dwParam3;
        end;
        case dwParam1 of
        LINECALLSTATE_CONNECTED:
           Begin
              if (not thisTAPIPort.bConnected) and
                 (thisTAPIPort.Privileges <> LINECALLPRIVILEGE_MONITOR) Then
              Begin
                 if dwParam3 = LINECALLPRIVILEGE_OWNER then begin
                    thisTAPIPort.RealOwner := true;
                 end;
                 thisTAPIPort.OnConnectionInt;
              End;
           End;
        LINECALLSTATE_OFFERING:
           Begin
              FillChar(ci, sizeof(ci), #0);
              ci.dwTotalSize := sizeof(ci);
              linegetcallinfo(hDevice, @ci);
              if (not thisTAPIPort.bConnected) then
              Begin
                 thisTAPIPort.Answer := True;
                 if (thisTAPIPort.Privileges = LINECALLPRIVILEGE_MONITOR) and
                    not thisTAPIPort.CallHandOff then exit;
                 thisTAPIPort.RealOwner := dwParam3 = LINECALLPRIVILEGE_OWNER;
                 if thisTAPIPort.RealOwner then begin
                    thisTAPIPort.ModemString := #13#10'TAPI OFFERING (OWNER)'#13#10;
                 end else begin
                    thisTAPIPort.ModemString := #13#10'TAPI OFFERING (MONITOR)'#13#10;
                 end;
                 thisTAPIPort.NeedDrop := True;
                 if dwParam3 = LINECALLPRIVILEGE_MONITOR then begin
                    thisTAPIPort.StorLine('Owning call', True);
                    thisTAPIPort.Privileges := LINECALLPRIVILEGE_OWNER;
                    if thisTAPIPort.Execute(
                          'lineSetCallPrivilege',
                          lineSetCallPrivilege(
                          hCall(hDevice),
                          LINECALLPRIVILEGE_OWNER)) then begin
                       thisTAPIPort.Answer := False;
                       thisTAPIPort.fHandOf := False;
                       thisTAPIPort.DropCall;
                       thisTAPIPort.Answer := True;
                       thisTAPIPort.MakeCall;
                    end;
                 end else begin
                    thisTAPIPort.StorLine('Prepareing call', False);
                    thisTAPIPort.Execute(
                       'lineSetCallParams',
                       lineSetCallParams(
                       hCall(hDevice),
                       LINEBEARERMODE_PASSTHROUGH,
                       0,
                       0,
                       nil));
                 end;
              End;
           End;

        LINECALLSTATE_DIALING:
           Begin
              thisTAPIPort.Answer := True;
           End;

        LINECALLSTATE_IDLE:
           Begin
              thisTAPIPort.Answer := False;
              thisTAPIPort.fHandOf := False;
              if thisTAPIPort.Line <> 0 then begin
                 if thisTAPIPort.Privileges <> LINECALLPRIVILEGE_OWNER then begin
                    if thisTAPIPort.Call = hDevice then begin
                       thisTAPIPort.DropCall;
                    end else begin
                       lineDeallocateCall(hDevice);
                    end;
                 end;
              end;
           End;
        end;
     End;
  end;

  finally
     if thisTAPIPort.WakeEvent <> 0 then SetEvt(thisTAPIPort.WakeEvent);
  end;

end;

function TTapiPort.SaveHandle;
var
   i: integer;
begin
   Result := False;
   if h = 0 then exit;
   for i := 0 to 9 do begin
      if a[i] = h then exit;
      if a[i] = 0 then begin
         a[i] := h;
         Result := True;
         exit;
      end;
   end;
end;

function TTapiPort.NextHandle;
var
   i: integer;
begin
   Result := 0;
   for i := 0 to 9 do begin
      if a[i] <> 0 then begin
         Result := a[i];
         a[i] := 0;
         exit;
      end;
   end;
end;

procedure TTapiPort.FreeHandle;
var
   i: integer;
begin
   for i := 0 to 9 do begin
      if a[i] = h then begin
         a[i] := 0;
      end;
   end;
end;

type
   MmRec = record
      v: DWORD;
      n: string;
   end;

const
   Mmd : array[1..14] of MmRec = (
     (v: $0002; n: 'MEDIAMODE_UNKNOWN'),
     (v: $0004; n: 'MEDIAMODE_INTERACTIVEVOICE'),
     (v: $0008; n: 'MEDIAMODE_AUTOMATEDVOICE'),
     (v: $0010; n: 'MEDIAMODE_DATAMODEM'),
     (v: $0020; n: 'MEDIAMODE_G3FAX'),
     (v: $0040; n: 'MEDIAMODE_TDD'),
     (v: $0080; n: 'MEDIAMODE_G4FAX'),
     (v: $0100; n: 'MEDIAMODE_DIGITALDATA'),
     (v: $0200; n: 'MEDIAMODE_TELETEX'),
     (v: $0400; n: 'MEDIAMODE_VIDEOTEX'),
     (v: $0800; n: 'MEDIAMODE_TELEX'),
     (v: $1000; n: 'MEDIAMODE_MIXED'),
     (v: $2000; n: 'MEDIAMODE_ADSI'),
     (v: $4000; n: 'MEDIAMODE_VOICEVIEW')
     );

constructor TTapiPort.Create;
var
   i: integer;
   s: string;
 Ext: TLINEEXTENSIONID;
begin
   hCommFile := INVALID_HANDLE_VALUE;
   Version := 0;
   Device := APort;
   DevNam := AName;
   Messages := TStringColl.Create('TAPI.Messages');
   TAPILog := TStringColl.Create('TAPI.TAPILog');
   CallHandOff := Hand;
   if Pass then begin
      CallHandOff := False;
   end;
   InitializeCriticalSection(CriticalSection);
   SaveTapiPort(APort, Self);
   if GetLineName(APort) = AName then begin
      Execute(
         'lineNegotiateAPIVersion',
         lineNegotiateAPIVersion(TapiAppHandler, Device, LoVer, HiVer, @Version, @Ext));
      if Version = 0 then begin
         DisplayError('TAPI version installed is too high or too low  '#13#10 +
                      'We need versions ' + inttostr(LoVer shr 16) +
                      '.' + inttostr(LoVer and $FFFF) +
                      ' - ' + inttostr(HiVer shr 16) +
                      '.' + inttostr(HiVer and $FFFF) +
                      ' to work properly  '#13#10, 0);
      end else begin
         StorLine('Version:  ' + inttostr(Version shr 16) +
                           '.' + inttostr(Version and $FFFF), True);
      end;
   end;

   MediaModes := VerifyUsableLine(APort);
   StorLine('Mediamd: ' + HexW(MediaModes), True);
   for i := 1 to 14 do begin
      if Mmd[i].v and MediaModes > 0 then begin
         StorLine('   ' + Mmd[i].n, True);
      end;
   end;

   SetPriority;

   if (Version = 0) or (Integer(MediaModes) < 0) or
      not OpenLine or (Pass and (not MakeCall)) then begin
      s := '';
      for i := 0 to Messages.Count - 1 do begin
         s := s + Messages[i] + #13#10;
      end;
      DisplayError(s, 0);
      Destroy;
      asm
         pop edi
         pop esi
         pop ebx
         mov esp, ebp
         pop ebp
         ret 012
      end;
   end;

   PassThrough := Pass;

   inherited Create (hCommFile);
end;

destructor TTapiPort.Destroy;
begin
   PassThrough := False;
   fAnswer := False;
   fHandOf := False;
   DropCall;
   CloseLine;
   FreeTapiPort(Device);
   FreeObject(Messages);
   FreeObject(TAPILog);
   PurgeCS(CriticalSection);
   inherited;
end;

function TTapiPort.Execute;
var
   i: integer;
   n: integer;
begin
   Result := False;
   if rc = 0 then begin
      Result := True;
   end else
   if rc > 0 then begin
      n := 0;
      repeat
         for i := 0 to 19 do begin
            if ExecsArray[i].h = THandle(RC) then begin
               if ExecsArray[i].r = 0 then begin
                  Result := True;
               end else begin
                  StorLine(cn + ' failed: ' + TapiCheck(ExecsArray[i].r), True);
               end;
               ExecsArray[i].h := 0;
               ExecsArray[i].r := 0;
               exit;
            end;
         end;
         Sleep(100);
         Application.ProcessMessages;
         inc(n);
         if n = 50 then begin
            StorLine(cn + ' failed (timeout)', True);
            exit;
         end;
      until False;
   end else begin
      StorLine('Request failed (' + cn + '): ' + TapiCheck(RC), False);
   end;
   if DWORD(RC) = LINEERR_INVALLINEHANDLE then begin
      Line := 0;
   end;
end;

procedure TTapiPort.StorLine;
begin
   if Messages = nil then exit;
   Messages.Enter;
   Messages.Add(s);
   if Messages.Count > 20 then Messages.AtFree(0);
   Messages.Leave;
   if l then begin
      TAPILog.Enter;
      TAPILog.Add(s);
      TAPILog.Leave;
   end;
end;

function TTapiPort.OpenLine;
var
   l: integer;
 Ext: TLINEEXTENSIONID;
begin
   Enter;
   Result := False;
   if Line = 0 then begin
      l := Device;
      Device := GetLineID(DevNam);
      if integer(Device) = -1 then begin
         Leave;
         exit;
      end;
      if Device <> DWORD(l) then begin
         SaveTapiPort(Device, Self);
         FreeTapiPort(l);
      end;   
      Execute(
         'lineNegotiateAPIVersion',
         lineNegotiateAPIVersion(TapiAppHandler, Device, LoVer, HiVer, @Version, @Ext));
      if Version = 0 then begin
         Leave;
         exit;
      end;
      MediaModes := VerifyUsableLine(Device);
      if integer(MediaModes) = -1 then begin
         Leave;
         exit;
      end;
      ActivModes := LINEMEDIAMODE_DATAMODEM;
      if CallHandOff and ((MediaModes and LINEMEDIAMODE_UNKNOWN) > 0) then begin
         ActivModes := MediaModes;
      end;
      if execute(
         'lineOpen',
         lineOpen(TapiAppHandler, Device, @Line, Version, 0, Device,
         LINECALLPRIVILEGE_MONITOR or LINECALLPRIVILEGE_OWNER, ActivModes, nil)) then begin
         SaveHandle(LinesArray, Line);
         l := Online;
         if l > -1 then begin
            StorLine('Line opened: ' + IntToStr(Line) + ' (' + inttostr(l) + ' opens)', True);
            SetPriority;
            Result := True;
            OldLines := l;
            CheckCalls;
         end else begin
            Line := 0;
         end;
      end else begin
         OldCalls := 0;
      end;
   end else begin
      CheckCalls;
   end;
   Leave;
end;

procedure TTAPIPort.CheckCalls;
type
   t = array[0..0] of THandle;
var
   c: PLineCallList;
   a:^t;
begin
   if RealOwner then exit;
   GetMem(c, 1024);
   FillChar(c^, 1024, #0);
   c.dwTotalSize := 1024;
   Execute(
      'lineGetNewCalls',
      lineGetNewCalls(Line, 0, LINECALLSELECT_LINE, @c^));
   if c.dwCallsNumEntries > 0 then begin
      if Call = 0 then begin
         fAnswer := True;
         NeedDrop := False;
         OldCalls := c.dwCallsNumEntries;
         StorLine('Calls detected: ' + IntToStr(OldCalls), True);
         a := Pointer(DWORD(c) + c.dwCallsOffset);
         CallID := a[0];
      end;
   end else begin
      fAnswer := False;
      NeedDrop := True;
      OldCalls := 0;
      DropCall;
   end;
   FreeMem(c, 1024);
end;

procedure TTAPIPort.CloseLine;
var
   l: THandle;
begin
   Enter;
   repeat
      l := NextHandle(LinesArray);
      if (l <> 0) and Execute('lineClose', lineClose(l)) then begin
         StorLine('Line closed: ' + IntToStr(l), True);
         if l = Line then Line := 0;
      end;
   until (l = 0);
   FillChar(CallsArray, SizeOf(CallsArray), 0);
   Leave;
end;

procedure TTAPIPort.SetAnswer;
begin
   fAnswer := b;
end;

function TTAPIPort.GetNeedDrop;
begin
   Result := fNeedDrop and (fHandle <> INVALID_HANDLE_VALUE);
end;

function  TTAPIPort.GetOnline;
var
   ds: TLineDevStatus;
begin
   Result := -1;
   ds.dwTotalSize := SizeOf(ds);
   if LineGetLineDevStatus(Line, @ds) = 0 then begin
      Result := ds.dwNumOpens;
   end;
end;

procedure TTAPIPort.SetCallID;
begin
   if c <> Call then begin
      Call := c;
      if SaveHandle(CallsArray, c) then begin
         StorLine(IntToStr(c) + ' call handle', False);
      end;
   end;
//   if c <> 0 then begin
//      fAnswer := False;
//   end;
end;

procedure TTAPIPort.CheckOpens;
var
   o: integer;
begin
   if Call <> 0 then exit;
   o := OnLine;
   if (o <> -1) and (OldLines <> o) then begin
      StorLine('Opens number changed (' + IntToStr(OldLines) + ' -> ' + IntToStr(o) + ')', True);
   end;
   if OldLines < o then begin
      DropCall;
      CloseLine;
      OpenLine;
   end else begin
     if o > -1 then OldLines := o;
   end;
end;

function  TTAPIPort.MakeCall;
var
  cp: TLINECALLPARAMS;
   i: integer;
   c: HCALL;
begin
   Result := False;
   if MakingCall then exit;
   MakingCall := True;
   OpenLine;
   MakingCall := False;
   if Line = 0 then begin
      exit;
   end;
   if Call <> 0 then begin
      Result := True;
      exit;
   end;

   NeedDrop := True;
   Privileges := 0;
   FillChar(cp, SizeOf(cp), 0);

   if oHandle = 0 then oHandle := CreateEvt(False);

   with cp do
   begin
      dwTotalSize  := SizeOf(cp);
      dwBearerMode := LINEBEARERMODE_PASSTHROUGH;
      dwMediaMode  := LINEMEDIAMODE_DATAMODEM;
    end;

    if Execute('lineMakeCall', lineMakeCall(Line, @c, nil, 0, @cp)) then begin
       i := 0;
       while hCommFile = INVALID_HANDLE_VALUE do begin
          Sleep(100);
          Application.ProcessMessages;
          inc(i);
          if i > 40 then begin
             exit;
          end;
       end;
       RealOwner := True;
       Privileges := LINECALLPRIVILEGE_OWNER;
       Result := True;
    end else begin
       NeedDrop := False;
       ResetLine;
    end;

end;

procedure TTAPIPort.ResetLine;
var
   i: integer;
 Ext: TLINEEXTENSIONID;
begin
   DropCall;
   CloseLine;
   if GetLineName(Device) = DevNam then begin
      Execute(
         'lineNegotiateAPIVersion',
         lineNegotiateAPIVersion(TapiAppHandler, Device, LoVer, HiVer, @Version, @Ext));
      if Version = 0 then begin
         DisplayError('TAPI version installed is too high or too low  '#13#10 +
                      'We need versions ' + inttostr(LoVer shr 16) +
                      '.' + inttostr(LoVer and $FFFF) +
                      ' - ' + inttostr(HiVer shr 16) +
                      '.' + inttostr(HiVer and $FFFF) +
                      ' to work properly  '#13#10, 0);
      end else begin
         StorLine('Version:  ' + inttostr(Version shr 16) +
                           '.' + inttostr(Version and $FFFF), True);
      end;
   end;
   MediaModes := VerifyUsableLine(Device);
   StorLine('Mediamd: ' + HexW(MediaModes), True);
   for i := 1 to 14 do begin
      if Mmd[i].v and MediaModes > 0 then begin
         StorLine('   ' + Mmd[i].n, True);
      end;
   end;
   SetPriority;
end;

procedure TTAPIPort.DropHand;
begin
   if hCommFile <> INVALID_HANDLE_VALUE then begin
      StorLine(IntToStr(hCommFile) + ' comm handle closed', False);
//      SleepDown;
      CloseHandle(hCommFile);
      ComHandle := INVALID_HANDLE_VALUE;
      hCommFile := INVALID_HANDLE_VALUE;
//      WakeUp;
   end;
end;

procedure TTAPIPort.SetPriority;
var
   a: string;
   i: integer;
begin
   a := ExtractFileName(ParamStr(0));
   for i := 1 to 15 do begin
      if (1 shl i) and MediaModes > 0 then begin
         Execute('lineSetAppPriority', lineSetAppPriority(PChar(a), 1 shl i, nil, 0, nil, 0));
         if yes then begin
            if (1 shl i) and ActivModes > 0 then begin
               Execute('lineSetAppPriority', lineSetAppPriority(PChar(a), 1 shl i, nil, 0, nil, 1));
            end;
         end;   
      end;
   end;
end;

procedure TTAPIPort.Enter;
begin
   EnterCS(CriticalSection);
end;

procedure TTAPIPort.Leave;
begin
   LeaveCS(CriticalSection);
end;

procedure TTAPIPort.DropCall;
var
   h: THandle;
begin
   SetPriority;
   if PassThrough and (FHandle <> INVALID_HANDLE_VALUE) then exit;
   if  Answer then exit;
   if fHandOf then exit;
   Enter;
   DropHand;
   if Call <> 0 then begin
      if Privileges = LINECALLPRIVILEGE_OWNER then begin
         if Execute('lineDrop', lineDrop(Call, nil, 0)) then begin
            StorLine(IntToStr(Call) + ' call dropped', False);
         end;
      end;
      bConnected := False;
      Call := 0;
      Privileges := 0;
      NeedDrop := False;
      RealOwner := False;
   end;
   repeat
      h := NextHandle(CallsArray);
      if h <> 0 then begin
         if Execute('lineDeallocateCall', lineDeallocateCall(h)) then begin
            StorLine(IntToStr(h) + ' call handle closed', False);
         end;
      end;
   until (h = 0);
   if Line = 0 then OpenLine;
   if PassThrough then MakeCall;
   Leave;
end;

procedure TTAPIPort.HandOff;
var
   rc: long;
begin
   Privileges := LINECALLPRIVILEGE_OWNER;
   fAnswer := False;
   fHandOf := False;
   DropHand;
   if Execute(
      'lineSetCallParams',
      lineSetCallParams(Call, LINEBEARERMODE_VOICE, 0, 0, nil)) then begin
      SetPriority(False);
      rc := lineHandOff(Call, nil, LINEMEDIAMODE_DATAMODEM);
      case rc of
       0:
         begin
            if Execute(
                  'lineSetCallPrivilege',
                  lineSetCallPrivilege(Call, LINECALLPRIVILEGE_MONITOR)) then begin
               Privileges := LINECALLPRIVILEGE_MONITOR;
               fAnswer := True;
               fHandOf := True;
               RealOwner := False;
               StorLine('Line was hand off', True);
               exit;
            end;
         end;
      long(LINEERR_TARGETSELF):
         begin
            StorLine('LINEERR_TARGETSELF', True);
         end;
      long(LINEERR_TARGETNOTFOUND):
         begin
            StorLine('LINEERR_TARGETNOTFOUND', True);
         end
         else begin
            StorLine('Error while handing off line', True);
         end;
      end;
   end;
   DropCall;
end;

procedure TTAPIPort.OnConnectionInt;
Var
   lp: LPVARSTRING;
   dw: DWORD;
Begin
   if Call = 0 then exit;
   if OldCalls > 0 then exit;
   bConnected := TRUE;
   dw := sizeof(VARSTRING) + 1024;
   GetMem(LPVOID(lp), dw);
   FillChar(lp^, SizeOf(lp^), #0);
   lp.dwTotalSize := dw;
   if Execute(
         'lineGetID',
         lineGetID(Line, 0, Call, LINECALLSELECT_CALL, lp, 'comm/datamodem')) then begin
      strmove (@hCommFile, PChar (DWORD(lp) + lp.dwStringOffset), sizeof (LONG));
      if (hCommFile <> INVALID_HANDLE_VALUE) then begin
         ComHandle := hCommFile;
         StorLine(IntToStr(hCommFile) + ' comm handle', False);
      end else begin
         bConnected := False;
      end;
   End;
   FreeMem(lp, dw);
End;

function I_lineNegotiateLegacyAPIVersion (dwDeviceID: DWORD): DWORD;
Var
   ei: TLINEEXTENSIONID;
   av: DWORD;
   rc: DWORD;
Begin
   av := 0;
   rc := lineNegotiateAPIVersion(TAPIAppHandler, dwDeviceID,
                                 LoVer, HiVer, @av, @ei);
   if (rc = LINEERR_INCOMPATIBLEAPIVERSION) Then Begin
      Result := 0;
      exit;
   End;
   Result := av;
End;

function I_lineNegotiateAPIVersion (dwDeviceID: DWORD): DWORD;
Var
   ei: TLINEEXTENSIONID;
   av: DWORD;
   rc: DWORD;
Begin
   av := 0;
   rc := lineNegotiateAPIVersion (TapiAppHandler, dwDeviceID,
                                  LoVer, LoVer, @av, @ei);
   if (rc = LINEERR_INCOMPATIBLEAPIVERSION) Then Begin
      Result := 0;
      exit;
   End;
   Result := av;
End;

function GetLineName (dn: DWORD): string;
var
   av: DWORD;
   dc: LPLINEDEVCAPS;
begin
   GetMem(dc, sizeof(TLINEDEVCAPS) + 1024);
   FillChar(dc^, SizeOf(dc^), #0);
   dc.dwTotalSize := sizeof(dc^) + 1024;
   av := I_lineNegotiateLegacyAPIVersion (dn);
   if (av <> 0) Then begin
      lineGetDevCaps (TAPIAppHandler, dn, av, 0, dc);
      Result := GetLineName(dc);
   end else begin
      Result := 'Cannot find device';
   end;
   FreeMem(dc, sizeof(TLINEDEVCAPS) + 1024);
end;

function GetLineName (dc: LPLINEDEVCAPS): string;
Var
   ln: PChar;
Begin
   GetMem  (ln,  dc.dwLineNameSize + 1);
   FillChar(ln^, dc.dwLineNameSize + 1, #0);
   Result := '';
   if (dc <> nil) Then Begin
      if ((dc.dwLineNameSize <> 0) and
          (dc.dwLineNameOffset <> 0) and
          (dc.dwStringFormat = STRINGFORMAT_ASCII)) then Begin
         // This is the name of the device.
         strmove (ln, PChar (DWORD(dc) + dc.dwLineNameOffset),
                  dc.dwLineNameSize);
         if (ln[0] <> Chr (0)) Then Begin
            // Reverse indented to make this fit
            // Make sure the device name is null terminated.
            if (ln[dc.dwLineNameSize - 1] <> Chr (0)) Then Begin
               // If the device name is not null terminated, null
               // terminate it.  Yes, this looses the end character.
               // Its a bug in the service provider.
               ln[dc.dwLineNameSize - 1] := Chr (0);
            End;
         End else begin
            StrPCopy (ln, 'Line name is empty');
         end
      End else begin
         StrPCopy(ln, 'Unnamed line');
      end;
      Result := StrPas(ln);
   End else begin
      Result := 'Line is unavailable';
   end;
   freemem(ln, dc.dwLineNameSize + 1);
End;

function VerifyUsableLine (id: DWORD): LONG;
Var
    hLine_: HLINE;
    hCall_: HCALL;
    dc: LPLINEDEVCAPS;
    rs: LPLINEADDRESSSTATUS;
    vs: LPVARSTRING;
    av: DWORD;
    rc: LONG;

    procedure DeleteBuffers;
    begin
      if (hCall_ <> 0) then
         lineDrop (hCall_, nil, 0);
      if (hLine_ <> 0) then
         lineClose (hLine_);
      if (rs <> nil) then
         Freemem (rs);
      if (dc <> nil) Then
          Freemem (dc);
      if (vs <> nil) then
          Freemem(vs);
    end;

Begin
    hLine_ := 0;
    dc := nil;
    rs := nil;
    vs := nil;

    // The line device must support an API Version that TapiComm does.
    av := I_lineNegotiateAPIVersion(id);
    if (av = 0) Then
       begin
       Result := -1;
       DeleteBuffers;
       exit;
       End;

    GetMem(LPVOID(dc), sizeof(TLINEDEVCAPS) + 1024);
    FillChar(dc^, SizeOf(dc^), #0);
    dc.dwTotalSize := sizeof(TLINEDEVCAPS) + 1024;

    lineGetDevCaps(TapiAppHandler, id, av, 0, dc);

    Result := dc.dwMediaModes;

    // Must support LINEBEARERMODE_VOICE
    if ((dc.dwBearerModes and LINEBEARERMODE_VOICE) = 0) then
       Begin
       Result := -1;
       DeleteBuffers;
       exit;
       End;

    // Must support LINEMEDIAMODE_DATAMODEM
    if ((dc.dwMediaModes and LINEMEDIAMODE_DATAMODEM) = 0) then
       Begin
       Result := -1;
       DeleteBuffers;
       exit;
       End;

    // Must be able to make calls
    if ((dc.dwLineFeatures and LINEFEATURE_MAKECALL) = 0) Then
       Begin
       Result := -1;
       DeleteBuffers;
       exit;
       End;

    // It is necessary to open the line so we can check if
    // there are any call appearances available.  Other TAPI
    // applications could be using all call appearances.
    // Opening the line also checks for other possible problems.

    rc := lineOpen(TapiAppHandler, id, @hLine_,
                   av, 0, 0,
                   LINECALLPRIVILEGE_NONE, LINEMEDIAMODE_DATAMODEM,
                   LPLINECALLPARAMS(0));

    if (rc = integer(LINEERR_ALLOCATED)) Then Begin
       Result := -1;
       DeleteBuffers;
       exit;
    End;

    GetMem(LPVOID(rs), sizeof(TLINEADDRESSSTATUS) + 1024);
    FillChar(rs^, sizeOf(rs^), #0);
    rs.dwTotalSize := sizeof(TLINEADDRESSSTATUS) + 1024;

    // Get LineAddressStatus to make sure the line isn't already in use.
    lineGetAddressStatus(hLine_, 0, rs);

    // Are there any available call appearances (ie: is it in use)?
//    if ( (as.dwAddressFeatures and
//               LINEADDRFEATURE_MAKECALL) = 0) Then
//       Begin
//          Result := -1;
//          DeleteBuffers;
//          exit
//       End;

    // Make sure the "comm/datamodem" device class is supported
    // Note that we don't want any of the 'extra' information
    // normally returned in the VARSTRING structure.  All we care
    // about is if lineGetID succeeds.

    {GetMem(LPVOID(vs), sizeof(VARSTRING) + 1024);
    ZeroMem (PChar(vs));
    vs.dwTotalSize:=sizeof(VARSTRING) + 1024;

    // Fill the VARSTRING structure
    TapiCheck (lineGetID (hLine_, 0, hCall_, LINECALLSELECT_LINE,
              vs, 'comm/datamodem'));
     }
  deletebuffers;
End;

function GetLineID(n: string): integer;
var
   l: TStringList;
   i: integer;
begin
   Result := -1;
   l := TStringList.Create;
   FillTAPILines(l);
   for i := 0 to l.Count - 1 do begin
      if l[i] = n then begin
         Result := Integer(l.Objects[i]);
      end;
   end;
   l.Free;
end;

function FillTAPILines(sl: TStrings): DWORD;
Var
  id: DWORD;
  av: DWORD;
  dc: LPLINEDEVCAPS;
  ln: string;
   i: integer;
Begin
   Result := MAXDWORD;
   sl.Clear;
   GetMem(LPVOID(dc), sizeof(TLINEDEVCAPS) + 1024);
   FillChar(dc^, SizeOf(dc^), #0);
   dc.dwTotalSize := sizeof(TLINEDEVCAPS) + 1024;
   for id := 0 to TapiDevsNumber - 1 do begin
      av := I_lineNegotiateLegacyAPIVersion (id);
      if (av <> 0) Then Begin
         if lineGetDevCaps (TAPIAppHandler, id, av, 0, dc) = 0 then begin
            ln := GetLineName (dc);
         end else begin
            ln := 'Wrong device ID';
         end;
      End else begin
      // Couldn't NegotiateAPIVersion.  Line is unavail.
         ln := 'Line is unavailable';
      end;
      // If this line is usable and we don't have a default initial
      // line yet, make this the initial line.
      if (VerifyUsableLine(id) > -1) Then begin
          Result := id;
          // Put the device name into the control
          i := sl.Add (ln);
          sl.Objects[i] := pointer(id);
      end;
      ln := '';
   End; {for dwDeviceID := 0 to dwNumDevs - 1 do}
   FreeMem (dc, sizeof(TLINEDEVCAPS) + 1024);
End;

procedure InitTAPI;
begin
   FillChar(TapiPortArray, SizeOf(TapiPortArray), #0);
   FillChar(ExecsArray, SizeOf(ExecsArray), #0);
   CallBackEntered := False;
   TapiInitialized := lineInitialize(
                     @TapiAppHandler,
                      GetModuleHandle (nil),
                      LineCallbackProc,
                     'Taurus'#0,
                     @TapiDevsNumber,
                      ) = 0;
end;

procedure FinishTAPI;
begin
   if TapiInitialized then lineShutdown(TapiAppHandler);
end;

end.

