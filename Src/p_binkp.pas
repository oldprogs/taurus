unit p_BinkP;

interface

uses xMisc, xBase, xDES, Windows, SysUtils, InfoZip;

function CreateBinkPProtocol(CP: Pointer; const prec: TProtocolRecord): Pointer;

type
  TBinkPState = (
    bdNone,
    bdInit,
    bdStartWaitFirstMsg,
    bdWaitFirstMsg,
    bdStartWaitPwd,
    bdWaitPwd,
    bdGetInKey,
    bdStartWaitOK,
    bdWaitOK,
    bdWaitDoneOK,
    bdSendPwd,
    bdSendOKPwd,
    bdSendBadPwd,
    bdAllAkasBusy,

    bdStartTransfer,
    bdTransfer,
    bdUnrec,
    bdGotErr,
    bdFinishFail,
    bdStartDrain,
    bdDrain,
    bdFinishOK,
    bd_Done,
    bdDone
  );

  TBinkPPktRx = (
    bdprxNone,
    bdprxHdrHi,
    bdprxHdrLo,
    bdprxData
  );

  TBinkPtx = (
    bdtxInit,
    bdtxGetNextFile,
    bdtxStartFile,
    bdtxGotM_GET,
    bdtxReadNextBlock,
    bdtxReadBlock,
    bdtxTransmit,
    bdtxWait_M_GOT,
    bdtxSendEOB,
    bdtxSendSecondEOB,
    bdtxInitX,
    bdtxDone
  );

  TBinkPrx = (
    bdrxInit,
    bdrxStartWaitFile,
    bdrxWaitFile,
    bdrxStartFile,
    bdrxStartReceData,
    bdrxStartWaitFileSync,
    bdrxWaitFileSync,
    bdrxGotFileSync,
    bdrx_ReceData,
    bdrxReceData,
    bdrxGot_M_EOB,
    bdrxWaitEOB,
    bdrx_Done,
    bdrxDone
  );

const
  MaxSndBlkSz            = $1000;
var
  StartSndBlkSz: integer =  $200;
  DuplexBlkSz  : integer =  $400;
  SubBlkSz     : integer =  $400;

type
  TBinkPArray = array[0..2 * bdK32 - 1] of Char;
  TBinkPOutA  = array[0..MaxSndBlkSz - 1] of Char;

  TGetCharFunc = function(var C: Byte): Boolean of object;
  TWriteProc = procedure(const Buf; i: DWORD) of object;
  TPutCharProc = procedure(C: Byte) of object;
  TCharReadyFunc = function: Boolean of object;

  TBinkP = class(TBiDirProtocol)
    function GetStateStr: string;                               override;
    constructor Create(ACP: TPort; const prec: TProtocolRecord);
    procedure ReportTraf(txMail, txFiles: DWORD);               override;
    destructor Destroy;                                         override;
    function TimeoutValue: DWORD;                               override;
    procedure Cancel;                                           override;
    function NextStep: boolean;                                 override;
    procedure Start({RX}AAcceptFile: TAcceptFile;
                        AFinishRece: TFinishRece;
                    {TX}AGetNextFile: TGetNextFile;
                        AFinishSend: TFinishSend;
                    {CH}AChangeOrder: TChangeOrder
                     ); override;
    function CanChat: boolean; override;
    procedure StartBatch; override;
  private
    CRAM: Boolean;
    secondeob: Boolean;
    secondtime: Boolean;
    count: integer;
    ChallengePtr: PByteArray;
    ChallengeSize: Integer;
    SendDummies, AddrGot, PwdGot,
    OptGot, SupEncDesCBC: boolean;
    DesOutPos, DesOuts, DesInCollectPos, DesInGivePos: DWORD;
    DesInBuf, DesOutBuf: TDesBlock;
    ivIn, ivOut, DesKey: TDesBlock;
    DesKeySchedule: TdesKeySchedule;
    GetCharFunc: TGetCharFunc;
    WriteProc: TWriteProc;
    CharReadyFunc: TCharReadyFunc;
    PutCharProc: TPutCharProc;
    Timeout: EventTimer;
    OutMsgsColl,
    M_SKIP_Coll,
    M_GOT_Coll,
    M_GET_Coll: TStringColl;
    ReceSyncStr, ReceFileStr: string;
    InMsg: string;
    aOut: TBinkPOutA;
    aIn: TBinkPArray;
    aTmpS: TBinkPArray;
    aTmpR: TBinkPArray;
    InHdrHi,
    InHdrLo: Byte;
    InCur, InRep: DWORD;
    OnceAgain,
    InData: Boolean;
    InPZIP: boolean;
    SdPZIP: boolean;
    OldState, OldOldState, OldOldOldState,
    State: TBinkPState;
    tx: TBinkPtx;
    rx: TBinkPrx;
    PktRx: TBinkPPktRx;
    CurPkt: DWORD;
    TxBlkSize, TxBlkPos,
    TxBlkRead: DWORD;
    OutMsgsLocked: Boolean;
    keysin,
    keysout: tkeys;
    LogFName: string;
    ChatEnabled: boolean;
    CrypEnabled: boolean;
    RemoteCanCrypt: boolean;
    RemoteCanTRS: boolean;
    function MakePwdStr(const AStr: string): string;
    procedure FreeChallenge;
    function RxPktKnown: Boolean;
    procedure LogPortErrors;
    procedure SetDesOut;
    procedure SetDesIn;
    function GetRxPktName: string;
    procedure SendMsg(Id: Byte; const Msg: string);
    procedure SendId(Id: Byte);
    procedure SendDataHdr(Sz: DWORD);
    function CanSend: boolean;
    procedure DoChat;
    procedure DoTx;
    procedure DoRx;
    procedure DoStep;
    function RxPkt: DWORD;
    procedure FlushPkt;
    procedure FlushOutMsgs;
    procedure LogNul;
    procedure CheckOpt;
    procedure ChkPwd;
    procedure GetAdr;
    procedure SetTimeout;
    function GetCharPlain(var C: Byte): Boolean;
    function GetCharDES(var C: Byte): Boolean;
    function GetCharCRY(var C: Byte): Boolean;
    procedure WritePlain(const Buf; i: DWORD);
    procedure WriteDES(const Buf; i: DWORD);
    procedure WriteCRY(const Buf; i: DWORD);
    procedure PutCharPlain(c: Byte);
    procedure PutCharDES(c: Byte);
    procedure PutCharCRY(c: Byte);
    function CharReadyPlain: Boolean;
    function CharReadyDES: Boolean;
    function CharReadyCRY: Boolean;
    procedure GetOctetDES;
    procedure SendDummy;
    function KeySum: Word;
    procedure SetChallengeStr(const AStr: string);
    procedure InitCrypt;
  public
    freqprocessed: boolean;
  end;

implementation

  uses xFido, Wizard, RadIni, Forms;

const
  M_Names : array[0..10] of string = (
     'M_NUL', 'M_ADR', 'M_PWD', 'M_FILE', 'M_OK', 'M_EOB',
     'M_GOT', 'M_ERR', 'M_BSY', 'M_GET', 'M_SKIP'
  );

  BinkPStateMsg : array[TBinkPState] of string = (
     'None',
     'Init',
     'StartWaitFirstMsg',
     'WaitFirstMsg',
     'StartWaitPwd',
     'WaitPwd',
     'GetInKey',
     'StartWaitOK',
     'WaitOK',
     'WaitDoneOK',
     'SendPwd',
     'SendOKPwd',
     'SendBadPwd',
     'AllAKAsBusy',

     'StartTransfer',
     'Transfer',
     'Unrec',
     'GotErr',
     'FinishFail',
     'StartDrain',
     'Drain',
     'FinishOK',
     'PreDone',
     'Done'
  );

  BinkPPktRxMsg : array[TBinkPPktRx] of string = (
     'None',
     'HdrHi',
     'HdrLo',
     'Data'
  );

  BinkPtxMsg : array[TBinkPtx] of string = (
     'Init',
     'GetNextFile',
     'StartFile',
     'GotM_GET',
     'ReadNextBlock',
     'ReadBlock',
     'Transmit',
     'Wait_M_GOT',
     'SendEOB',
     'SendSecondEOB',
     'bdtxInitX',
     'Done'
  );

  BinkPrxMsg : array[TBinkPrx] of string = (
     'Init',
     'StartWaitFile',
     'WaitFile',
     'StartFile',
     'StartReceData',
     'StartWaitFileSync',
     'WaitFileSync',
     'GotFileSync',
     '_ReceData',
     'ReceData',
     'Got_M_EOB',
     'WaitEOB',
     '_Done',
     'Done'
  );

  pktData    = $FFFFFFFF;
  pktNone    = $FFFFFFFE;

  pktDCD     = $FFFFFFFD;
  pktAbort   = $FFFFFFFC;
  pktTimeout = $FFFFFFFB;

  MinErr     = pktTimeout;
  MaxErr     = pktDCD;

function FileStrEx(B: TBatch; NeedOfs: Boolean; InvalidTime: boolean; const InvalidTImeStr: string): string;
begin
  if not invalidtime then
    with B.D do
    if NeedOfs then Result := Format('%s %d %d %d', [StrQuote(FName), FSize, FTime, FOfs]) else
      Result := Format('%s %d %d', [StrQuote(FName), FSize, FTime])
  else
    with B.D do
    if NeedOfs then Result := Format('%s %d %s %d', [StrQuote(FName), FSize, InvalidTimeStr, FOfs]) else
      Result := Format('%s %d %s', [StrQuote(FName), FSize, InvalidTimeStr]);
end;

function FileStr(B: TBatch; NeedOfs: Boolean): string;
begin
  result := filestrex(b, needofs, false, '');
end;

procedure TBinkP.SetTimeout;
begin
  NewTimerSecs(Timeout, BinkPTimeout);
end;

destructor TBinkP.Destroy;
begin
  if Chat <> nil then begin
     PostMessage(MainWinHandle, WM_CLOSECHAT, Integer(Chat), Integer(Chat));
  end;
  Application.ProcessMessages;
  FreeObject(M_SKIP_Coll);
  FreeObject(M_GOT_Coll);
  FreeObject(M_GET_Coll);
  FreeObject(OutMsgsColl);
  FreeChallenge;
  inherited Destroy;
end;

procedure TBinkP.SendDummy;
var
  s: string;
  i: DWORD;
begin
  if not SendDummies then Exit;
  i := xRandom(4) + 5;
  s := '| ';
  while i > 0 do begin s := s + Char(xRandom(126 - 32) + 33); Dec(i) end;
  SendMsg(M_NUL, s);
end;

procedure TBinkP.LogPortErrors;
var
  Coll: TStringColl;
  i, j: Integer;
begin
  Coll := CP.GetErrorStrColl;
  j := CollMax(Coll);
  if j < 0 then Exit;
  for i := 0 to j do
  begin
    CustomInfo := Coll[i];
    FLogFile(Self, lfBinkPNiaE);
  end;
  Coll.FreeAll;
end;

function TBinkP.RxPkt: DWORD;
var
  C: Byte;

  procedure Acc;
  var
    I: Integer;
    CC: Byte;
  begin
    InMsg := '';
    if InRep > 1 then
    begin
      for i := 1 to InRep - 1 do
      begin
        CC := Byte(aIn[I]);
        if CC = 0 then Exit;
        InMsg := InMsg + Char(CC);
      end;
    end;
  end;

  procedure GotSomth;
  begin
    InCur := 0;
    PktRx := bdprxHdrHi;
    if InData then Result := pktData else
    begin
      Acc;
      Result := DWORD(aIn[0]);
    end;
  end;

begin
  Result := CurPkt;
  if Result <> pktNone then Exit;
  if not CharReadyFunc then begin
    if CancelRequested then Result := pktAbort else
    if TimerExpired(Timeout) then Result := pktTimeout else
    if CP.DCD <> CP.Carrier then begin
      CP.Carrier := not CP.Carrier;
      Result := pktDCD;
    end;
  end else
  begin
    OnceAgain := True;
    SetTimeout;
    while GetCharFunc(C) do begin
      case PktRx of
        bdprxHdrHi:
          begin
            InHdrHi := C;
            PktRx := bdprxHdrLo;
          end;
        bdprxHdrLo:
          begin
            InCur := 0;
            InPZIP := False;
            InHdrLo := C;
            InData := InHdrHi < $80;
            if RemoteCanPZIP then begin
               InPZIP := InHdrHi and $40 > 0;
               if InPZIP then begin
                  InHdrHi := InHdrHi and $3F;
               end;
            end;
            InRep := ((Word(InHdrHi) shl 8) + Word(InHdrLo)) and (bdK32 - 1);
            R.D.BlkLen := InRep;
            if InRep >= bdK32 then
            begin
              State := bdUnrec;
              Break;
            end;
            PktRx := bdprxData;
            if InCur = InRep then
            begin
              GotSomth;
              Break;
            end;
          end;
        bdprxData:
          begin
            if (InCur = bdK32) or (InCur = InRep) then
            begin
              GlobalFail('bdprxData InCur=%d InRep=%d', [InCur, InRep]); // Debug-only
            end;
            aIn[InCur] := Chr(C);
            Inc(InCur);
            if InCur = InRep then
            begin
              GotSomth;
              Break;
            end;
          end;
      end;
    end;
  end;
  CurPkt := Result;
  LogPortErrors;
end;

procedure TBinkP.FlushPkt;
begin
  CurPkt := pktNone;
end;

procedure TBinkP.FlushOutMsgs;
var
  i,
  j: Integer;
  s: string;
begin
  if OutMsgsLocked then Exit;
  for i := 0 to CollMax(OutMsgsColl) do begin
     s := OutMsgsColl[i];
     for j := 1 to Length(s) do PutCharProc(Byte(s[j]));
  end;
  CP.Flsh;
  OutMsgsColl.FreeAll;
end;

constructor TBinkP.Create(ACP: TPort; const prec: TProtocolRecord);
begin
  inherited Create(ACP);
  FreqProcessed := false;
  M_GOT_Coll := TStringColl.Create;
  M_GET_Coll := TStringColl.Create;
  M_SKIP_Coll := TStringColl.Create;
  OutMsgsColl := TStringColl.Create;
  GetCharFunc := GetCharPlain;
  WriteProc := WritePlain;
  PutCharProc := PutCharPlain;
  CharReadyFunc := CharReadyPlain;
  secondeob := false;
  secondtime := false;
  count := 1;
  FiAddr    := prec.Addr;
  FiSysop   := prec.Sysop;
  FiStation := prec.Station;
  LogFName  := prec.LogFName;
  ChatEnabled := prec.ChatEnabled;
  CrypEnabled := prec.CrypEnabled;
end;

function TBinkP.TimeoutValue: DWORD;
begin
  Result := MultiTimeout([Timeout]);
  if DesKey <> 0 then Result := MinD(Result, 1000); // sleep no more than a second if ecrypted
end;

procedure TBinkP.Cancel;
begin
  FreeObject(CP);
end;

procedure TBinkP.SetChallengeStr(const AStr: string);
var
  sl: Integer;
  d: DWORD;
begin
  sl := Length(AStr);
  if (sl = 0) or Odd(sl) then begin
     State := bdFinishFail;
     SendMsg(M_ERR, Format('Invalid length of challenge string (%d chars)', [sl]));
     Exit;
  end;
  ChallengeSize := sl div 2;
  GetMem(ChallengePtr, ChallengeSize);
  for sl := 0 to ChallengeSize - 1 do begin
     d := VlH(Copy(AStr, sl * 2 + 1, 2));
     if (d = INVALID_VALUE) or (d > $FF) then begin
        State := bdFinishFail;
        SendMsg(M_ERR, Format('Invalid challenge string (%s)', [AStr]));
        Exit;
     end;
     ChallengePtr^[sl] := Byte(d);
  end;
end;

procedure TBinkP.CheckOpt;
var
  s,
  z,
  k: string;
begin
  s := InMsg;
  GetWrd(s, z, ' ');
  CustomInfo := InMsg;
  FLogFile(Self, lfBinkPNul);
  if UpperCase(z) <> 'OPT' then Exit;
  OptGot := True;
  while s <> '' do begin
     GetWrd(s, z, ' ');
     GetWrd(z, k, '-');
     k := UpperCase(k);
     if k = 'CRAM' then begin
        GetWrd(z, k, '-');
        if Pos('MD5', k) > 0 then begin
           RemoteCanCram := True;
           GetWrd(z, k, '-');
           if not CramDisabled then SetChallengeStr(k);
        end;
     end else begin
        if k = 'ENC' then begin
           GetWrd(z, k, '-');
           if k = 'DES' then begin
              GetWrd(z, k, '-');
              if k = 'CBC' then SupEncDesCBC := True;
           end;
        end else
        if k = 'CHT' then begin
           RemoteCanChat := True;
           FLogFile(self, lfChat);
        end else
        if k = 'LST' then begin
           RemoteCanList := True;
           ListBuf.Add('LIST');
        end else
        if k = 'PLZ' then begin
           RemoteCanPZIP := ZLIBLoaded;
           if ZLIBLoaded then FLogFile(self, lfPZIP);
        end else
        if k = 'MBT' then begin
           RemoteCanDYNA := True;
           RemoteCan2eob := True;
           FLogFile(Self, lfDYNA);
           SendMsg(M_NUL, 'OPT MBT');
        end else
        if k = 'BRK' then begin
           if not RemoteCanBrek then FLogFile(Self, lfBrek);
           RemoteCanBrek := True;
           SendMsg(M_NUL, 'OPT BRK');
        end else
        if k = 'CRYPT' then begin
           RemoteCanCryp := IniFile.RequestCRYPT or CrypEnabled;
           RemoteCanCrypt := True;
        end else
        if k = 'TRS' then begin
           RemoteCanTRS := True;
        end;
     end;
  end;
end;

procedure TBinkP.LogNul;
var
   i: integer;
   s: string;
begin
  if UpperCase(copy(InMsg, 1, 3)) = 'CHT' then begin
     s := copy(InMsg, 5, Length(InMsg) - 4);
     if ChatOpened and (UpperCase(s) = 'BYE') then begin
        ChatOpened := False;
        Chat.RemoteVisible := False;
        Chat.Visible := False;
     end else begin
        CustomInfo := InMsg;
        StartChat(LogFName, false, ChatBell);
        Chat.AddMsg(s);
     end;
  end else
  if UpperCase(copy(InMsg, 1, 3)) = 'TRS' then begin
     if UpperCase(copy(InMsg, 1, 7)) = 'TRS ASK' then begin
        CustomInfo := ExtractWord(3, InMsg, [' ']);
        FLogFile(Self, lfTRSASK);
     end else
     if ExtractWord(3, InMsg, [' ']) = 'NAK' then begin
        for i := 0 to CollMax(TRSList) do begin
           s := TRSList[i];
           if ExtractWord(1, s, [' ']) = ExtractWord(2, InMsg, [' ']) then begin
              s := ExtractWord(1, s, [' ']) + ' NAK';
              TRSList[i] := s;
           end;
        end;
     end else
     if ExtractWord(3, InMsg, [' ']) = 'ACK' then begin
        for i := 0 to CollMax(TRSList) do begin
           s := TRSList[i];
           if ExtractWord(1, s, [' ']) = ExtractWord(2, InMsg, [' ']) then begin
              s := ExtractWord(1, s, [' ']) + ' ACK';
              TRSList[i] := s;
           end;
        end;
     end;
  end else
  if UpperCase(copy(InMsg, 1, 4)) = 'LIST' then begin
     RemoteUseList := True;
     SendFList;
  end else
  if UpperCase(copy(InMsg, 1, 3)) = 'LST' then begin
     ProcessLST(InMsg);
  end else begin
     if UpperCase(copy(InMsg, 1, 3)) = 'SYS' then begin
        fiStation := InMsg;
        delete(FiStation, 1, 4);
     end else
     if UpperCase(copy(InMsg, 1, 3)) = 'ZYZ' then begin
        fiSysop := InMsg;
        delete(FiSysop, 1, 4);
     end else
     if UpperCase(copy(InMsg, 1, 3)) = 'VER' then begin
        if pos('/1.1', InMsg) > 0 then begin
           RemoteCanDYNA := True;
           RemoteCan2eob := True;
           RemoteCanBrek := True;
        end;
     end;
     CheckOpt;
     CustomInfo := InMsg;
  end;
  FlushPkt;
end;

procedure TBinkP.GetAdr;
begin
  CustomInfo := InMsg;
  ParseAddress(ExtractWord(1, InMsg, [' ']), FiAddr);
  FLogFile(Self, lfBinkPAddr);
  if CustomInfo <> '' then begin
     State := bdFinishFail;
     if Length(CustomInfo) = 1 then
     case CustomInfo[1] of
     #1: SendMsg(M_ERR, 'Invalid addrs: ' + InMsg);
     #3: State := bdSendBadPwd;
     #4: State := bdAllAkasBusy;
     end;
  end;
  FlushPkt;
end;

procedure TBinkP.ChkPwd;
begin
   CustomInfo := UniqStr + ' ' + InMsg;
   Finalize(UniqStr);
   FLogFile(Self, lfBinkPPwd);
   FlushPkt;
   if CustomInfo = cBadPwd then State := bdSendBadPwd else
   if CustomInfo = #4 then State := bdAllAkasBusy else
   if CustomInfo = 'CRYPT' then begin
      if RemoteCanCrypt then begin
         if not RemoteCanCryp then begin
            RemoteCanCryp := True;
            SendMsg(M_NUL, 'OPT CRYPT');
            FlushPkt;
         end;
      end;
   end;
end;

procedure TBinkP.ReportTraf(txMail, txFiles: DWORD);
begin
  if txMail + txFiles > 0 then begin
     SendMsg(M_NUL, Format('TRF %d %d', [txMail, txFiles]));
     SendDummy;
  end;
end;

function TBinkP.GetRxPktName: string;
begin
  case CurPkt of
    0..10: Result := M_Names[CurPkt];
    else Result := Hex8(CurPkt)
  end;
end;

function TBinkP.KeySum: Word;
var
  k: TDesBlockI;
begin
  k[0] := $61C74D21;
  k[1] := $D06AB18C;
  xdes_ecb_encrypt_block(@k, SizeOf(k), DesKey, True);
  Result := xdes_md5_crc16(@k, 8);
end;

procedure TBinkP.DoStep;

procedure DoTransfer;
var
  ctx: TBinkPtx;
  crx: TBinkPrx;
  cnt: integer;
begin
  cnt := 0;
  repeat
    DoChat;
    ctx := tx;
    DoTx;
    if State <> bdTransfer then break;
//    if tx = bdtxReadBlock then break;
    if tx = bdtxReadNextBlock then break;
    inc(cnt);
    if cnt = 50 then break;
  until (ctx = tx);
  cnt := 0;
  repeat
    DoChat;
    crx := rx;
    DoRx;
    if State <> bdTransfer then break;
    inc(cnt);
    if cnt = 50 then break;
  until (crx = rx);
  if (tx = bdtxDone) and (rx = bdrxDone) then begin
    State := bdStartDrain;
    OutFlow := True;
  end;
end;

function CanZIP: string;
begin
   if ZLIBLoaded then Result := ' PLZ'
                 else Result := '';
end;

function CanCht: string;
begin
   if ChatEnabled then Result := ' CHT'
                  else Result := '';
end;

function CanLst: string;
begin
   if IniFile.ibnRequestList then Result := ' LST'
                             else Result := '';
end;

function AskCRYPT: string;
begin
   Result := '';
   if (IniFile.RequestCRYPT or CrypEnabled) and not CramDisabled then Result := ' CRYPT';
end;

function CanTRS: string;
begin
   if IniFile.RequestTRS then Result := ' TRS'
                         else Result := '';
end;

procedure SendAddr;
begin
  FLogFile(Self, lfBinkPgAddr);
  SendMsg(M_ADR, CustomInfo);
  SendDummy;
end;

procedure ParseOK_M_ERR;
var
  s,
  z: string;
begin
  State := bdGotErr;
  if DesKey = 0 then Exit;
  s := InMsg;
  GetWrd(s, z, ' ');
  if z <> 'ENC' then Exit;
  GetWrd(s, z, ' ');
  if z <> 'OK' then Exit;
  SetDesIn;
  State := bdStartWaitOK;
end;

procedure ParsePwd_M_ERR;
var
  s, z: string;
  i, j: DWORD;
begin
  State := bdGotErr;
  if not AddrGot then Exit;
  s := InMsg;
  GetWrd(s, z, ' ');
  if z <> 'ENC' then Exit;
  GetWrd(s, z, ' ');
  if z <> 'DES/CBC' then Exit;
  GetWrd(s, z, ' ');
  i := Vl(z);
  if i = INVALID_VALUE then Exit;
  if (i > $FFFF) then Exit;
  j := KeySum;
  if i <> j then begin
     CustomInfo := Format('%d %d', [i, j]);
     FLogFile(Self, lfBinkPBadKey);
     Exit;
  end;
  State := bdStartWaitPwd;
  SendMsg(M_ERR, 'ENC OK');
  CP.Flsh;
  SetDesIn;
  SetDesOut;
  xdes_set_key(DesKey, DesKeySchedule);
  SendDummy;
  SendAddr;
  SendDummy;
end;

function GetCramStr: string;
begin
  if CramDisabled then Result := '' else Result := ' CRAM-MD5-' + GetUniqStr;
end;

begin
  case State of
    bdInit:
      begin
        if not Originator then begin
           SendMsg(M_NUL, 'OPT' + GetCramStr);
        end;
        CustomInfo := CanZIP + CanCHT + CanLST + AskCRYPT + CanTRS;
        if CustomInfo <> '' then begin
           SendMsg(M_NUL, 'OPT' + CustomInfo);
        end;
{        SendMsg(M_NUL, 'OPT ENC-DES-CBC ' + GetCramStr);}
        SendMsg(M_NUL, 'SYS '  + Station.Station);
        SendMsg(M_NUL, 'ZYZ '  + Station.Sysop);
        SendMsg(M_NUL, 'LOC '  + Station.Location);
        SendMsg(M_NUL, 'PHN '  + Station.Phone);
        SendMsg(M_NUL, 'NDL '  + Station.Flags);
        SendMsg(M_NUL, 'TIME ' + RFCDateStr);
        SendMsg(M_NUL, 'VER '  + ProductName + '/' + ProductVersion + '/' + ProductPlatform + ' binkp/1.1');
        if Birthday <> '' then begin
           SendMsg(M_NUL, 'BTH ' + BirthDay);
        end;
        if Originator then begin
           SendAddr;
           State := bdStartWaitFirstMsg;
        end else begin
           State := bdStartWaitPwd;
        end;
      end;
    bdStartWaitFirstMsg:
      State := bdWaitFirstMsg;
    bdWaitFirstMsg:
      case RxPkt of
        pktNone : ;
        MinErr..MaxErr : ;
        Integer(M_ADR) : if AddrGot then State := bdUnrec else begin AddrGot := True; State := bdStartWaitFirstMsg; GetAdr end;
        Integer(M_ERR) : begin ParseOK_M_ERR; FlushPkt end;
        Integer(M_NUL) : begin State := bdStartWaitFirstMsg; LogNul; if State = bdStartWaitFirstMsg then State := bdSendPwd end;
        else if RxPktKnown then State := bdUnrec else begin FlushPkt; State := bdStartWaitFirstMsg end;
      end;
    bdStartWaitPwd:
      State := bdWaitPwd;
    bdWaitPwd:
      case RxPkt of
        pktNone : ;
        MinErr..MaxErr : ;
        Integer(M_ADR) : if AddrGot then State := bdUnrec else begin AddrGot := True; State := bdGetInKey; GetAdr end;
        Integer(M_PWD) :
          if PwdGot then
            State := bdUnrec
          else
            begin
              PwdGot := True;
              State := bdSendOkPwd;
              ChkPwd
            end;
        Integer(M_ERR) : begin ParsePwd_M_ERR; FlushPkt end;
        Integer(M_NUL) : begin LogNul; State := bdStartWaitPwd end;
        else if RxPktKnown then State := bdUnrec else begin FlushPkt; State := bdStartWaitPwd end;
      end;
    bdGetInKey:
      begin
        State := bdStartWaitPwd;
        FLogFile(Self, lfBinkPgInKey);
        Move(CustomInfo[1], DesKey, 8);
        if DesKey = 0 then SendAddr else begin
           if PwdGot then State := bdUnrec;
        end;
      end;
    bdSendPwd:
      begin
        FLogFile(Self, lfBinkPgOutKey);
        Move(CustomInfo[1], DesKey, 8);
        if DesKey <> 0 then begin
           SendMsg(M_ERR, Format('ENC DES/CBC %d (This link is setup as encrypted)', [KeySum]));
           CP.Flsh;
           SetDesOut;
           xdes_set_key(DesKey, DesKeySchedule);
           SendDummy;
        end;
        FLogFile(Self, lfBinkPgPwd);
        if CustomInfo[1] <> ' ' then SendMsg(M_NUL, 'FREQ');
        DelFC(CustomInfo);
        SendMsg(M_PWD, MakePwdStr(CustomInfo));
        fiPassword := CustomInfo;
        if CRAM then FLogFile(Self, lfBinkPCRAM);
        SendDummy;
        State := bdWaitOK;
      end;
    bdStartWaitOK :
      State := bdWaitOK;
    bdWaitOK :
      case RxPkt of
      pktNone : ;
      MinErr..MaxErr : ;
      Integer(M_ADR) : if AddrGot then State := bdUnrec else begin AddrGot := True; if Originator then begin State := bdStartWaitOK; GetAdr end else State := bdUnrec end;
      Integer(M_OK)  :
         begin
            State := bdWaitDoneOK;
            if InMsg <> 'non-secure' then begin
               if InMsg = '' then begin
                  CustomInfo := 'Blank M_OK message';
                  FLogFile(Self, lfDebug);
               end;
               InitCrypt;
            end else begin
               CustomInfo := 'Remote submitted insecure session';
               FLogFile(Self, lfLog);
               if RemoteCanCryp then begin
                  RemoteCanCryp := False;
                  CustomInfo := 'CRYPT option disabled by remote for insecure link';
                  FLogFile(Self, lfLog);
               end;
            end;
         end;
      Integer(M_ERR) : begin ParseOK_M_ERR; FlushPkt  end;
      Integer(M_NUL) : begin LogNul; State := bdStartWaitOK end;
      else if RxPktKnown then State := bdUnrec else begin FlushPkt; State := bdStartWaitOK end;
      end;
    bdWaitDoneOK :
      begin
        FlushPkt;
        State := bdStartTransfer;
      end;
    bdSendOKPwd :
      begin
        CustomInfo := 'non-secure';
        if (FiPassword <> '') and (FiPassword <> '-') then CustomInfo := 'secure';
        SendMsg(M_OK, CustomInfo);
        SendDummy;
        State := bdStartTransfer;
        if CustomInfo = 'secure' then begin
           InitCrypt;
        end;
        sleep(500);
      end;
    bdAllAkasBusy:
      begin
        SendMsg(M_ERR, 'All AKAs are busy');
        State := bdFinishFail;
      end;
    bdSendBadPwd :
      begin
        SendMsg(M_ERR, 'Bad password');
        State := bdFinishFail;
      end;
    bdGotErr :
      begin
        CustomInfo := InMsg;
        FLogFile(Self, lfBinkPErr);
        State := bdFinishFail;
      end;
    bdUnrec :
      begin
        if InData then CustomInfo := 'Data Block' else begin
           CustomInfo := M_Names[CurPkt];
           if InMsg <> '' then CustomInfo := Format('%s "%s" st=%s tx=%s rx=%s blk=%s', [CustomInfo, InMsg, BinkPStateMsg[OldOldState], BinkPtxMsg[tx], BinkPrxMsg[rx], BinkPPktRxMsg[PktRx]]);
        end;
        SendMsg(M_ERR, 'Unrecognized packet ' + CustomInfo);
        FLogFile(Self, lfBinkPUnrec);
        State := bdFinishFail;
      end;
    bdStartDrain: State := bdDrain;
    bdDrain:
      if (CP.OutUsed = 0) then State := bdFinishOK else
      case RxPkt of
        pktNone: {Sleep(100)};
        MinErr..MaxErr : ;
      else
        begin
          FlushPkt;
          State := bdStartDrain;
        end;
      end;
    bdFinishOK :
      begin
        State := bd_Done;
      end;
    bdFinishFail :
      begin
        if ProtocolError = ecOK then ProtocolError := ecTooManyErrors;
        State := bd_Done;
      end;
    bdStartTransfer :
      begin
        tx := bdtxInit;
        rx := bdrxInit;
        State := bdTransfer;
      end;
    bdTransfer:
      DoTransfer;
    bd_Done:
      begin
        Sleep(100);
        State := bdDone;
      end;
    bdDone: ;
   end;
end;

function TBinkP.CanSend: Boolean;
begin
   if T.D.BlkLen = 0 then T.D.BlkLen := 1024;
   Result := (CP.OutUsed < T.D.BlkLen * 2);
end;

procedure TBinkP.DoChat;
var
   i: integer;
   s: string;
begin
   if (ChatBuf <> '') and RemoteCanChat and CanSend then begin
      SendMsg(M_NUL, 'CHT ' + ChatBuf);
      SendDummy;
      ChatBuf := '';
   end;
   if Chat <> nil then begin
      if ChatBuf = '' then begin
         ChatBuf := Chat.ChatBuf;
      end;
      if not Chat.Visible and ChatOpened then begin
         ChatBuf := 'BYE';
         ChatOpened := False;
      end;
   end;
   while ListBuf.Count > 0 do begin
      SendMsg(M_NUL, ListBuf[0]);
      CustomInfo := ListBuf[0];
      FLogFile(Self, lfLog);
      ListBuf.AtFree(0);
   end;
   if IniFile.RequestTRS and RemoteCanTRS then begin
      for i := CollMax(TRSList) downto 0 do begin
         s := TRSList[i];
         if WordCount(s, [' ']) = 1 then begin
           CustomInfo := 'Requesting transit to: ' + s;
            FLogFile(Self, lfLog);
            SendMsg(M_NUL, 'TRS ASK ' + s);
            s := s + ' ASK';
            TRSList[i] := s;
         end else
         if ExtractWord(2, s, [' ']) = 'ACK' then begin
            CustomInfo := 'Transit request for: ' + ExtractWord(1, s, [' ']) + ' succeeded';
            FLogFile(Self, lfLog);
            TRSList.AtFree(i);
         end else
         if ExtractWord(2, s, [' ']) = 'NAK' then begin
            CustomInfo := 'Transit request for: ' + ExtractWord(1, s, [' ']) + ' failed';
            FLogFile(Self, lfLog);
            TRSList.AtFree(i);
         end;
      end;
   end else begin
      TRSList.FreeAll;
   end;
end;

procedure TBinkP.DoTx;

function GotM_GET: Boolean;
 var
  s1,
  s2,
  z1,
  z2: string;
  jd: DWORD;
begin
  if M_GET_Coll.Count = 0 then Result := False else begin
    Result := True;
    s1 := M_GET_COll[0];
    s2 := FileStr(T, False);
    z1 := ''; z2 := '';
    for jd := 0 to 3 do begin
      if UpperCase(z1) <> UpperCase(z2) then begin
        SendMsg(M_ERR, Format('File names mismatch: %s / %s', [z1, z2]));
        State := bdFinishFail;
        Exit;
      end;
      GetWrd(s1, z1, ' ');
      GetWrd(s2, z2, ' ');
    end;
    jd := Vl(z1);
    if (jd = INVALID_VALUE) or (jd >= DWORD(MaxInt)) then begin
       SendMsg(M_ERR, Format('Invalid file position value: %s', [z1]));
       State := bdFinishFail;
       Exit
    end;

    T.D.FPos := jd;
    T.D.FOfs := jd;
    FLogFile(Self, lfSendSync);

    if T.Stream.Seek(T.D.FPos, FILE_BEGIN) = INVALID_FILE_SIZE then begin
       FFinishSend(Self, aaSysError);
       State := bdFinishFail;
       Exit
    end;
    M_GET_COll.AtFree(0);
    tx := bdTxGotM_GET;
    if pos('NZ', UpperCase(s1)) > 0 then begin
       RemoteCanPZIP := False;
       FLogFile(Self, lfNZIP);
    end;
  end;
end;

procedure Got__(Coll: TStringColl; Action: TTransferFileAction);
begin
   if UpperCase(Coll[0]) <> UpperCase(FileStr(T, False)) then
      State := bdFinishFail else begin
      Coll.AtFree(0);
      FFinishSend(Self, Action);
      tx := bdtxGetNextFile;
   end;
end;

var
  i: DWORD;
  l: longint;
  e: integer;
begin
  case tx of
    bdtxDone : ;
    bdtxInitX :
      begin
        if count > 2 then begin
          tx := bdtxInit;
        end;
        inc(count);
      end;
    bdtxInit : tx := bdtxGetNextFile;
    bdtxGetNextFile :
      begin
        if secondtime then secondeob := true;
        secondtime := true;
        OutFlow := True;
        T.ClearFileInfo;
        FGetNextFile(Self);
        if T.D.FName = '' then begin
           tx := bdtxSendEOB;
           if RemoteUseList then begin
              SendMsg(M_NUL, 'LST CLR');
           end;
        end else begin
           tx := bdtxStartFile;
        end;
      end;
    bdtxStartFile:
      begin
        SendMsg(M_FILE, FileStr(T, True));
        SendDummy;
        CP.Flsh;
        T.D.BlkLen := StartSndBlkSz;
        ActuallySent := 0;
        VisuallySent := 0;
        tx := bdtxReadBlock;
        StartSndBlkSz :=  $200;
        DuplexBlkSz   :=  $400;
        SubBlkSz      :=  $400;
      end;
    bdTxGotM_GET:
      begin
        if T.D.FOfs = T.D.FSize then
        begin
          FFinishSend(Self, aaRefuse);
          tx := bdtxGetNextFile;
        end else
        begin
          SendMsg(M_FILE, FileStr(T, True));
          SendDummy;
          if rx = bdrxDone then i := MaxSndBlkSz else i := DuplexBlkSz;
          if i = 0 then i := $400;
          T.D.BlkLen := i;
          tx := bdtxReadBlock;
          ActuallySent := 0;
          VisuallySent := 0;
        end;
      end;
    bdTxReadNextBlock:
      begin
        if rx = bdrxDone then i := MaxSndBlkSz else i := DuplexBlkSz;
        T.D.BlkLen := MinD(i, T.D.BlkLen * 2);
        tx := bdtxReadBlock;
      end;
    bdtxReadBlock:
      if not GotM_GET then
      if M_GOT_Coll.Count > 0 then Got__(M_GOT_Coll, aaRefuse) else
      if M_SKIP_Coll.Count > 0 then Got__(M_SKIP_Coll, aaAcceptLater) else
      begin
        i := MinD(T.D.BlkLen, T.D.FSize - T.D.FPos);
        SetLastError(0);
        if (T.Stream.Read(aOut, i) <> i) or (GetLastError <> 0) then begin
          FFinishSend(Self, aaSysError);
          State := bdFinishFail;
        end else begin
          TxBlkSize := i;
          TxBlkRead := i;
          TxBlkPos  := 0;
          SdPZIP := False;
          tx := bdtxTransmit;
          if RemoteCanPZIP then begin
             l := SizeOf(aTmpS);
             VisuallySent := VisuallySent + dword(i);
             e := Compress(@aTmpS, l, @aOut, i);
             if e < 0 then begin
               CustomInfo := 'Compress error: ' + IntToStr(e);
               FLogFile(Self, lfDebug);
               State := bdFinishFail;
               exit;
             end;
             if (dword(l) < i) then begin
                TxBlkSize := l;
                SdPZIP := RemoteCanPZIP;
                move(aTmpS, aOut, l);
                ActuallySent := ActuallySent + dword(l);
             end else begin
                ActuallySent := ActuallySent + dword(i);
             end;
             if (VisuallySent > 0) and (ActuallySent > 0) then begin
                StartSndBlkSz :=  $200 * (VisuallySent div ActuallySent);
                DuplexBlkSz   :=  $400 * (VisuallySent div ActuallySent);
                SubBlkSz      :=  $400 * (VisuallySent div ActuallySent);
                if DuplexBlkSz < $400 then begin
                   StartSndBlkSz :=  $200;
                   DuplexBlkSz   :=  $400;
                   SubBlkSz      :=  $400;
                end;
             end;
          end;
        end;
      end;
    bdtxTransmit:
      if CanSend and not GotM_GET then begin
        if TxBlkPos = 0 then begin
          OutMsgsLocked := True;
          SendDataHdr(TxBlkSize);
        end;
        i := MinD(TxBlkSize - TxBlkPos, SubBlkSz);
        SetTimeout;
        WriteProc(aOut[TxBlkPos], i);
        if TxBlkPos + i = TxBlkSize then begin
           Inc(T.D.FPos, TxBlkRead);
        end;
        if T.D.FPos = T.D.FSize then begin
          SendDataHdr(0);
          OutMsgsLocked := False;
          SendDummy;
          FlushOutMsgs;
          OutFlow := False;
          tx := bdtxWait_M_GOT;
        end else begin
          Inc(TxBlkPos, i);
          if TxBlkPos = TxBlkSize then begin
            tx := bdTxReadNextBlock;
            OutMsgsLocked := False;
            FlushOutMsgs;
          end;
        end;
      end;
    bdtxWait_M_GOT :
      if not GotM_GET then
      if M_GOT_Coll.Count > 0 then Got__(M_GOT_Coll, aaOK) else
      if M_SKIP_Coll.Count > 0 then Got__(M_SKIP_Coll, aaAcceptLater);
    bdtxSendEOB :
      begin
        if freqprocessed or Originator then begin
          if secondeob then begin
            OutFlow := False;
            FLogFile(Self, lfBatchSendEnd);
            SendId(M_EOB);
            SendDummy;
            tx := bdtxDone;
            if RemoteCan2eob then tx := bdtxSendSecondEOB;
          end else
            tx := bdtxInitX;
        end;
      end;
    bdtxSendSecondEOB:
      begin
         if RemoteCanTRS and (CollMax(TRSList) > -1) then begin
            FlushPkt;
            if CP.Carrier <> CP.DCD then begin
               TRSList.FreeAll;
            end;
         end else
         if rx in [bdrxGot_M_EOB, bdrxWaitEOB, bdrxDone] then begin
            SendId(M_EOB);
            SendDummy;
            tx := bdtxDone;
         end;
      end;
    else
      GlobalFail('%s', ['bdtx']);
  end;
end;

procedure TBinkP.DoRx;
var
  invalidtime: boolean;
  invalidtimestr: string;
  l: longint;

function ParseFileData(AStr: String): Boolean;
var
  s: string;

procedure DoGet;
begin
  GetWrd(AStr, s, ' ')
end;

var
  i: DWORD;
begin
  Result := False;
  invalidtime := false;
  ActuallyRece  := 0;
  VisuallyRece  := 0;
  DoGet;
  if not StrDeQuote(s) then Exit;
  R.D.FName := s;
  DoGet;
  i := Vl(s); if i = INVALID_VALUE then Exit;
  R.D.FSize := i;
  DoGet;
  i := Vl(s);
  if i = INVALID_VALUE then begin
     invalidtime := true;
     invalidtimestr := s;
     i := uGetSystemTime;
  end;
  R.D.FTime := i;
  DoGet;
  if (s = '') then Exit;
  i := Vl(s); if i = INVALID_VALUE then Exit;
  R.D.FOfs := i;
  Result := True;
end;

procedure Add_M_GOT;
begin
  M_GOT_Coll.Add(InMsg);
  FlushPkt;
end;

procedure Add_M_GET;
begin
  M_GET_Coll.Add(InMsg);
  FlushPkt;
end;

procedure Add_M_SKIP;
begin
  M_SKIP_Coll.Add(InMsg);
  FlushPkt;
end;

function Skip: Boolean;

procedure Snd(C: Byte);
begin
  SendMsg(C, FileStr(R, False));
  SendDummy;
end;

begin
  Result := FileRefuse or FileSkip;
  if not Result then Exit;
  if FileSkip then begin
    Snd(M_SKIP);
    FFinishRece(Self, aaAcceptLater);
  end else
  if FileRefuse then begin
    Snd(M_GOT);
    FFinishRece(Self, aaRefuse);
  end;
  rx := bdrxWaitFile;
end;

var
   e: integer;

begin
  case rx of
    bdrxInit :
      rx := bdrxStartWaitFile;
    bdrxStartWaitFile:
      rx := bdrxWaitFile;
    bdrxWaitFile :
      case RxPkt of
        pktNone : ;
        pktData : begin FlushPkt; rx := bdrxStartWaitFile end;
        MinErr..MaxErr : ;
        Integer(M_ERR) : State := bdGotErr;
        Integer(M_GOT) : begin Add_M_GOT; rx := bdrxStartWaitFile end;
        Integer(M_GET) : begin Add_M_GET; rx := bdrxStartWaitFile end;
        Integer(M_SKIP): begin Add_M_SKIP; rx := bdrxStartWaitFile end;
        Integer(M_NUL) : begin LogNul; rx := bdrxStartWaitFile end;
        Integer(M_EOB) : rx := bdrxGot_M_EOB;
        Integer(M_FILE): begin R.ClearFileInfo; rx := bdrxStartFile end;
        else if RxPktKnown then State := bdUnrec else begin FlushPkt; rx := bdrxStartWaitFile end;
      end;
    bdrxStartFile:
      if not ParseFileData(InMsg) then begin
         if Extractword(4, InMsg, [' ']) = '-1' then begin
            ReceSyncStr := FileStr(R, True);
            SendMsg(M_GET, ReceSyncStr);
            SendDummy;
            FlushPkt;
            rx := bdrxWaitFile;
            exit;
         end;
         State := bdUnrec;
      end
      else begin
        ReceFileStr := FileStrEx(R, False, InvalidTime, InvalidTimeStr);
        case FAcceptFile(Self) of
          aaOK : rx := bdrxStartReceData;
          aaRefuse :
            begin
              SendMsg(M_GOT, ReceFileStr);
              SendDummy;
              rx := bdrxWaitFile;
            end;
          aaAcceptLater :
            begin
              SendMsg(M_SKIP, ReceFileStr);
              SendDummy;
              rx := bdrxWaitFile;
            end;
          aaAbort :
          State := bdFinishFail;
        end;
        FlushPkt;
      end;
    bdrxStartReceData:
      if R.D.FOfs = 0 then rx := bdrxReceData else begin
        ReceSyncStr := FileStr(R, True);
        SendMsg(M_GET, ReceSyncStr);
        SendDummy;
        rx := bdrxStartWaitFileSync;
      end;
    bdrxStartWaitFileSync:
      rx := bdrxWaitFileSync;
    bdrxWaitFileSync:
      case RxPkt of
        pktNone : ;
        pktData : begin FlushPkt; rx := bdrxStartWaitFileSync; end;
        MinErr..MaxErr  : ;
        Integer(M_ERR)  : State := bdGotErr;
        Integer(M_GOT)  : begin Add_M_GOT; rx := bdrxStartWaitFileSync; end;
        Integer(M_GET)  : begin Add_M_GET; rx := bdrxStartWaitFileSync; end;
        Integer(M_SKIP) : begin Add_M_SKIP; rx := bdrxStartWaitFileSync; end;
        Integer(M_NUL)  : begin LogNul; rx := bdrxStartWaitFileSync; end;
        Integer(M_FILE) : rx := bdrxGotFileSync;
      else
        if RxPktKnown then State := bdUnrec else begin FlushPkt; rx := bdrxStartWaitFileSync; end;
      end;
    bdrxGotFileSync:
      begin
        if UpperCase(InMsg) = UpperCase(ReceSyncStr) then rx := bdrxReceData
          else State := bdUnrec;
        FlushPkt;
      end;
    bdrx_ReceData:
      begin
        rx := bdrxReceData;
      end;
    bdrxReceData:
      if not Skip then
      case RxPkt of
        pktNone : ;
        pktData :
          begin
            rx := bdrx_ReceData;
            SetLastError(0);
            if InPZIP then begin
               l := SizeOf(aTmpR);
               ActuallyRece := ActuallyRece + InRep;
               e := uncompress(@aTmpR, l, @aIn, InRep);
               if (e < 0) or (l = SizeOf(aTmpR)) then begin
                  l := e;
                  R.D.fOfs := R.D.fPos;
                  ReceSyncStr := FileStr(R, True);
                  SendMsg(M_GET, ReceSyncStr + ' NZ');
                  SendDummy;
                  rx := bdrxWaitFileSync;
                  exit;
               end;
               VisuallyRece := VisuallyRece + dword(l);
               InRep := l;
               move(aTmpR, aIn, l);
            end else
            if RemoteCanPZIP then begin
               ActuallyRece := ActuallyRece + InRep;
               VisuallyRece := VisuallyRece + InRep;
            end;
            if (R.Stream.Write(aIn, InRep) <> InRep) or (GetLastError <> 0) then begin
              FFinishRece(Self, aaSysError);
              State := bdFinishFail;
            end else begin
              Inc(R.D.FPos, InRep);
              if R.D.FPos > R.D.FSize then begin
                // Received data after eof
                State := bdFinishFail;
              end else
              if R.D.FPos = R.D.FSize then begin
                FFinishRece(Self, aaOK);
                SendMsg(M_GOT, ReceFileStr);
                SendDummy;
                rx := bdrxWaitFile;
//                tx := bdtxInit;
              end;
            end;
            FlushPkt;
          end;
        MinErr..MaxErr : ;
        Integer(M_ERR) : State := bdGotErr;
        Integer(M_GOT) : begin Add_M_GOT; rx := bdrx_ReceData end;
        Integer(M_GET) : begin Add_M_GET; rx := bdrx_ReceData end;
        Integer(M_SKIP): begin Add_M_SKIP; rx := bdrx_ReceData end;
        Integer(M_NUL) : begin LogNul; rx := bdrx_ReceData end;
        Integer(M_FILE): begin FFinishRece(Self, aaOK); R.ClearFileInfo; rx := bdrxStartFile; end;
        else if RxPktKnown then State := bdUnrec else begin FlushPkt; rx := bdrx_ReceData end;
      end;
    bdrxGot_M_EOB:
      begin
        FLogFile(Self, lfBatchReceEnd);
        FlushPkt;
        rx := bdrxDone;
        if RemoteCan2eob then rx := bdrxWaitEOB;
      end;
    bdrxWaitEOB:
      case RxPkt of
        pktDCD,
        integer(M_EOB) : begin rx := bdrxDone; end;
        Integer(M_GOT) : begin Add_M_GOT; end;
        Integer(M_SKIP): begin Add_M_SKIP; end;
        Integer(M_GET) : begin Add_M_GET; end;
        Integer(M_FILE): begin R.ClearFileInfo; rx := bdrxStartFile; end;
        Integer(M_NUL) : begin LogNul; end;
      else
        if RxPktKnown then State := bdUnrec;
      end;
    bdrx_Done:
      rx := bdrxDone;
    bdrxDone :
      case RxPkt of
        pktNone : ;
        MinErr..MaxErr : ;
        Integer(M_ERR) : State := bdGotErr;
        Integer(M_GOT) : begin Add_M_GOT; rx := bdrx_Done end;
        Integer(M_GET) : begin Add_M_GET; rx := bdrx_Done end;
        Integer(M_SKIP): begin Add_M_SKIP; rx := bdrx_Done end;
        Integer(M_NUL) : begin LogNul; rx := bdrx_Done end;
        Integer(M_EOB) : begin rx := bdrxDone; end;
        Integer(M_FILE): begin R.ClearFileInfo; rx := bdrxStartFile; end;
      else
        if RxPktKnown then State := bdUnrec else begin FlushPkt; rx := bdrx_Done end;
      end;
  end;
end;

function TBinkP.NextStep: boolean;
begin
  repeat
    repeat
      OnceAgain := False;
      OldOldOldState := OldOldState;
      OldOldState := OldState;
      OldState := State;
      DoStep;
    until (OldState = State) and (not OnceAgain);
    FlushOutMsgs;
    Result := (ProtocolError <> ecOK) or (State = bdDone);
    if not Result then
    case RxPkt of
      pktNone: Break;
      pktDCD:
        begin
          if (rx <> bdrxDone) or (tx <> bdtxDone) then ProtocolError := ecAbortNoCarrier;
          Result := True;
        end;
      pktAbort:
        begin
          ProtocolError := ecAbortByLocal;
          Result := True;
        end;
      pktTimeout:
        begin
          ProtocolError := ecTimeout;
          Result := True;
        end;
    end;
    if Result then begin
      if not RxClosed then begin
        FFinishRece(Self, aaAbort);
      end;
      if not TxClosed then begin
        FFinishSend(Self, aaAbort);
      end;
    end;
    Sleep(50);
  until Result;
  if (R <> nil) and (rx <> bdrxWaitFileSync) then R.D.Part := InCur else R.D.Part := 0;
end;

procedure TBinkP.Start({RX}AAcceptFile: TAcceptFile; AFinishRece: TFinishRece;
                       {TX}AGetNextFile: TGetNextFile; AFinishSend: TFinishSend;
                       {CH}AChangeOrder: TChangeOrder);
begin
  inherited Start(AAcceptFile, AFinishRece, AGetNextFile, AFinishSend, AChangeOrder);
  State := bdInit;
  PktRx := bdprxHdrHi;
  CurPkt := pktNone;
  InCur := 0;
  T.D.BlkLen := 0;
  R.D.BlkLen := 0;
  M_GOT_Coll.FreeAll;
  M_GET_Coll.FreeAll;
  M_SKIP_Coll.FreeAll;
  OutMsgsColl.FreeAll;
  OutMsgsLocked := False;
  SetTimeout;
end;

procedure TBinkP.SendId(Id: Byte);
var
  s: string;
begin
  s := #$80#$01 + Char(Id);
  OutMsgsColl.Add(s);
  FlushOutMsgs;
end;

procedure TBinkP.SendMsg(Id: Byte; const Msg: string);
begin
  OutMsgsColl.Add(FormatBinkPMsg(Id, Msg));
  FlushOutMsgs;
end;

procedure TBinkP.SendDataHdr(Sz: DWORD);
var
  b: byte;
begin
  b := Hi(Sz);
  if SdPZIP then begin
     b := b or $40;
  end;
  PutCharProc(b);
  PutCharProc(Lo(Sz));
end;

function TBinkP.GetStateStr: string;
begin
  Result := Format('%s st=%s/%s/%s/%s tx=%s rx=%s blk=%s', [GetRxPktName, BinkPStateMsg[OldOldOldState], BinkPStateMsg[OldOldState], BinkPStateMsg[OldState], BinkPStateMsg[State], BinkPtxMsg[tx], BinkPrxMsg[rx], BinkPPktRxMsg[PktRx]]);
end;

function TBinkP.GetCharPlain(var C: Byte): Boolean;
begin
  Result := CP.GetChar(C);
end;

procedure TBinkP.GetOctetDES;
var
  B: Byte;
  P: PByteArray;
begin
  P := @DesInBuf;
  while (DesInCollectPos < 8) do begin
    if not CP.GetChar(B) then Break;
    P^[DesInCollectPos] := B;
    Inc(DesInCollectPos);
  end;
  if DesInCollectPos = 8 then begin
    xdes_cbc_encrypt(DesInBuf, DesKeySchedule, ivIn, False);
    DesInCollectPos := 9;
    DesInGivePos := 0;
  end;
end;

function TBinkP.GetCharDES(var C: Byte): Boolean;
var
  P: PByteArray;
begin
  Result := False;
  GetOctetDES;
  if DesInCollectPos = 9 then begin
    Result := True;
    P := @DesInBuf;
    C := P^[DesInGivePos];
    Inc(DesInGivePos);
    if DesInGivePos = 8 then DesInCollectPos := 0;
  end;
end;

function TBinkP.GetCharCRY(var C: Byte): Boolean;
begin
  Result := CP.GetChar(C);
  if Result then decrypt_buf(C, 1, keysin);
end;

procedure TBinkP.WritePlain(const Buf; i: DWORD);
var
  p: PByteArray;
  c: DWORD;
begin
  if i = 0 then Exit;
  p := @Buf;
  for c := 0 to i - 1 do CP.PutChar(p^[c]);
end;

procedure TBinkP.WriteCRY(const Buf; i: DWORD);
var
  p: PByteArray;
  c: DWORD;
begin
  if i = 0 then Exit;
  p := @Buf;
  for c := 0 to i - 1 do PutCharCRY(p^[c]);
end;

procedure TBinkP.WriteDES(const Buf; i: DWORD);
var
   c: Integer;
begin
   if i > 0 then begin
      for c := 0 to i - 1 do PutCharDES(PxByteArray(@Buf)^[c]);
   end;
end;

procedure TBinkP.PutCharPlain(c: Byte);
begin
   CP.PutChar(c);
end;

procedure TBinkP.PutCharCRY(c: Byte);
var
   b: byte;
begin
   b := c;
   encrypt_buf(b, 1, keysout);
   CP.PutChar(b);
end;

procedure TBinkP.PutCharDES(c: Byte);
var
  j: Integer;
  P: PByteArray;
begin
  P := @DesOutBuf;
  P^[DesOutPos] := c;
  Inc(DesOutPos);
  if DesOutPos = 8 then begin
    xdes_cbc_encrypt(DesOutBuf, DesKeySchedule, ivOut, True);
    for j := 0 to 7 do CP.PutChar(P^[j]);
    Inc(DesOuts);
    if DesOuts > 32 then begin
      CP.Flsh;
      DesOuts := 0;
    end;
    DesOutPos := 0;
  end;
end;

function TBinkP.CharReadyPlain: Boolean;
begin
   Result := CP.CharReady;
end;

function TBinkP.CharReadyCRY: Boolean;
begin
   Result := CP.CharReady;
end;

function TBinkP.CharReadyDES: Boolean;
begin
   Result := DesInCollectPos = 9;
   if (not Result) and (CP.CharReady) then begin
      GetOctetDES;
      Result := CharReadyDES;
   end;
end;

procedure TBinkP.SetDesOut;
begin
   SendDummies := True;
   WriteProc := WriteDES;
   PutCharProc := PutCharDES;
   DesOutPos := 0;
end;

procedure TBinkP.SetDesIn;
begin
   GetCharFunc := GetCharDES;
   CharReadyFunc := CharReadyDES;
   DesInCollectPos := 0
end;

function TBinkP.RxPktKnown: Boolean;
begin
  case RxPkt of
    M_NUL,
    M_ADR,
    M_PWD,
    M_FILE,
    M_OK,
    M_EOB,
    M_GOT,
    M_ERR,
    M_BSY,
    M_GET,
    M_SKIP:
      Result := True
  else
      Result := False;
  end;
end;

procedure TBinkP.FreeChallenge;
begin
   if ChallengePtr = nil then Exit;
   FreeMem(ChallengePtr, ChallengeSize);
   ChallengePtr := nil;
end;

function TBinkP.MakePwdStr(const AStr: string): string;
begin
   if ChallengePtr = nil then begin Result := AStr; Exit end;
   Result := 'CRAM-MD5-' + KeyedMD5(AStr[1], Length(AStr), ChallengePtr^, ChallengeSize);
   CRAM := True;
   FreeChallenge;
end;

function TBinkP.CanChat;
begin
   Result := RemoteCanChat and ChatEnabled;
end;

procedure TBinkP.StartBatch;
begin
   if RemoteUseList then begin
      SendFList;
   end;
   if remoteCanDYNA and ((tx = bdtxDone) or (tx = bdtxSendSecondEOB)) then tx := bdtxGetNextFile else
   if remoteCanBREK then begin
      if Assigned(FChangeOrder) and FChangeOrder(self) then begin
         tx := bdtxGetNextFile;
      end;
   end;
end;

procedure TBinkP.InitCrypt;
var
   i: integer;
begin
   RemoteCanCryp :=  RemoteCanCryp and (FiPassword <> '-') and (RemoteCanCRAM or Originator);
   if not RemoteCanCryp then exit;
   FLogFile(Self, lfCRYP);
   if Originator then begin
      init_keys(keysout, FiPassword);
      init_keys(keysin, '-');
      for i := 1 to length(FiPassword) do begin
         update_keys(keysin, ord(FiPassword[i]));
      end;
   end else begin
      init_keys(keysin, FiPassword);
      init_keys(keysout, '-');
      for i := 1 to length(FiPassword) do begin
         update_keys(keysout, ord(FiPassword[i]));
      end;
   end;
   CP.Flsh;
   GetCharFunc := GetCharCRY;
   WriteProc := WriteCRY;
   PutCharProc := PutCharCRY;
   CharReadyFunc := CharReadyCRY;
end;

function CreateBinkPProtocol(CP: Pointer; const prec: TProtocolRecord): Pointer;
begin
  Result := TBinkP.Create(CP, Prec);
end;

end.


