unit p_SMTP;

interface

uses xMisc, Types, Windows, xBase, SysUtils,
     xFido, Controls, Forms, Classes, xIP;

function CreateSMTPProtocol(CP: Pointer): Pointer;

const
   MaxSndBlkSz            = $4000;

var
   StartSndBlkSz: integer =  $200;
   SubBlkSz     : integer =  $400;

type

   TSMTPState = (
   bdInit,
   bdLogin,
   bdPassw,
   bdUser,
   bdAuth,
   bdPass,
   bdCram,
   bdWork,
   bdData,
   bdRece,
   bdMail,
   bdPrep,
   bdFile,
   bdSend,
   bdSeek,
   bdNetm,
   bdStop,
   bdDone
   );

   TAuth = (
   aUndef,
   aLogin,
   aCram
   );

   TBinkPOutA  = array[0..MaxSndBlkSz - 1] of Char;
   TBinkPArray = array[0..2 * bdK32 - 1] of Char;

   TSMTP = class(TInetProtocol)
      function GetStateStr: string;                               override;
      procedure ReportTraf(txMail, txFiles: DWORD);               override;
      procedure Cancel;                                           override;
      constructor Create(ACP: TPort);
      destructor Destroy; override;
      function TimeoutValue: DWORD;                               override;
      procedure WriteProc(const Buf; i: DWORD);
      function CanSend: boolean;
      function NextStep: boolean;                                 override;
      procedure AbortRece(const s: string = '');                  override;
      procedure FinisRece(const s: string = '');                  override;
      procedure Start({RX}AAcceptFile: TAcceptFile;
                          AFinishRece: TFinishRece;
                      {TX}AGetNextFile: TGetNextFile;
                          AFinishSend: TFinishSend;
                      {CH}AChangeOrder: TChangeOrder
                      ); override;
   private
      State: TSMTPState;
      fFrom: string;
      fDest: string;
      sAuth: TAuth;
      sSize: DWORD;
      fChrs: string;
      procedure DoStep;
   end;

implementation

uses
   Wizard, WSock, Outbound, Plus, Recs, RadIni, xDES,
   DateUtils, Crypt, UStr;

function CreateSMTPProtocol;
begin
   Result := TSMTP.Create(CP);
end;

function TSMTP.GetStateStr: string;
begin
  case State of
  bdInit: result := 'Init';
  bdDone: result := 'Done';
  end;
end;

procedure TSMTP.ReportTraf(txMail, txFiles: DWORD);
begin
  //nothing, just to avoid warning
end;

procedure TSMTP.Cancel;
begin
  // nothing, just to avoid warning
end;

constructor TSMTP.Create;
begin
   inherited Create(ACP);
end;

destructor TSMTP.Destroy;
begin
   inherited Destroy;
end;

function TSMTP.TimeoutValue;
begin
   Result := 1000;
end;

procedure TSMTP.WriteProc(const Buf; i: DWORD);
var
  p: PByteArray;
  c: DWORD;
begin
  if i = 0 then Exit;
  p := @Buf;
  for c := 0 to i - 1 do CP.PutChar(p^[c]);
  CP.Flsh;
end;

function TSMTP.CanSend: Boolean;
begin
  Result := (CP.OutUsed < 60 + 2048);
end;

procedure TSMTP.AbortRece;
begin
   PutString('550 ' + s);
   State := bdData;
   R.d.FName := '';
   R.d.FSize := 0;
end;

procedure TSMTP.FinisRece;
var
   k: string;
begin
   R.d.FSize := R.Stream.Position;
   R.d.FPos  := R.Stream.Position;
   if rmCRC = 0 then dwCRC := 0;
   if fCram = '' then k := '' else begin
      MD5Final(dwB16, dwCTX);
      k := DigestToStr(dwB16);
      k := KeyedMD5(fPass[1], Length(fPass), k[1], Length(k));
   end;
   if (UpperCase(fCram) = UpperCase(k)) and (dwCRC = rmCRC) then begin
      FFinishRece(Self, aaOK);
   end else begin
      if rmCRC <> dwCRC then begin
         CustomInfo := R.d.FName + ', CRC error: '  + IntToStr(rmCRC) + ' / ' + IntToStr(dwCRC);
         FLogFile(Self, lfLog);
      end;
      if UpperCase(fCram) <> UpperCase(k) then begin
         CustomInfo := R.d.FName + ', Auth error: ' + fCram + ' / ' + k;
         FLogFile(Self, lfLog);
      end;
      FFinishRece(Self, aaAbort);
   end;
   State := bdData;
   R.d.FName := '';
   R.d.FSize := 0;
   if s = '.' then begin
      State := bdWork;
      PutString('250 OK DATA');
   end;
end;

{$I ftsc.inc}

procedure TSMTP.DoStep;
var
   S,
   Z,
   A: string;
   i: integer;
 CRC: DWORD;
   h: PktHeaderRec;
   m: PackedMsgHeaderRec;
//   e: PHostEnt;

   function GetWord(const i: integer): string;
   var
      ss: TStringList;
      st: string;
      ii: integer;
   begin
      ss := IniFile.ReadSection('Grids', 'gPOP3');
      if ss <> nil then begin
         for ii := 0 to ss.Count - 1 do begin
            st := IniFile.ReadString('Grids', ss[ii]);
            if MatchMaskAddressListSingle(FiAddr, ExtractWord(5, st, ['|'])) then begin
               Result := ExtractWord(i, st, ['|']);
               break;
            end;
         end;
         ss.Free;
      end;
   end;

begin
   case State of
   bdInit:
      begin
         if Originator then begin
            State := bdLogin;
         end else begin
            fStam := IntToStr(GetCurrentThreadId) + '.' + IntToStr(GetTickCount);
            fStam := '<' + fStam + '@' + ProductName + '>';
            PutString('220 Taurus-SMTP server is ready ' + fStam);
            State := bdUser;
//            i := inet_addr(PAnsiChar(CP.CallerId));
//            e := GetHostByAddr(@i, 4, PF_INET);
//            fName := e.h_name;
         end;
      end;
   end;
   CheckInput;
   while LList.Count > 0 do begin
      NewTimerSecs(Timer, BinkPTimeout);
      s := LList[0];
      LList.AtFree(0);
      if not (State in [bdSeek, bdNetm, bdData]) then begin
         if s = '' then continue;
      end;
      if IniFile.FTPDebug then begin
         DbgLog('< ' + s);
      end;
      a := s;
      GetWrd(s, z, ' ');
      z := UpperCase(z);
      if z = 'QUIT' then begin
         PutString('221 BYE');
         State := bdDone;
      end else
      case State of
      bdLogin:
         begin
            if z = '220' then begin
               PutString('EHLO Taurus');
            end else
            if z = '250' then begin
               if GetWord(2) = '-' then begin
                  State := bdMail;
               end else
               if sAuth = aLogin then begin
                  PutString('AUTH LOGIN');
               end else
               if sAuth = aCram then begin
                  PutString('AUTH CRAM-MD5');
               end else begin
                  State := bdMail;
               end;
            end else
            if copy(z, 1, 4) = '250-' then begin
               GetWrd(a, z, '-');
               GetWrd(a, z, ' ');
               z := UpperCase(z);
               if z = 'AUTH' then begin
                  if Pos('CRAM-MD5', UpperCase(a)) > 0 then begin
                     sAuth := aCram;
                  end else
                  if (Pos('LOGIN', UpperCase(a)) > 0) and (sAuth = aUndef) then begin
                     sAuth := aLogin;
                  end;
               end else
               if z = 'SIZE' then begin
                  sSize := StrToIntDef(a, -1);
               end;
            end else
            if z = '334' then begin
               fLine := DecodeB64(s);
               if UpperCase(fLine) = 'USERNAME:' then begin
                  s := GetWord(2);
                  PutString(EncodeB64(s));
               end else
               if UpperCase(fLine) = 'PASSWORD:' then begin
                  s := GetWord(3);
                  PutString(EncodeB64(s));
               end else
               if sAuth = aCram then begin
                  s := GetWord(2);
                  fStam := s;
                  s := GetWord(3);
                  fStam := fStam + ' ' + KeyedMD5(s[1], Length(s), fLine[1], Length(fLine));
                  PutString(EncodeB64(fStam));
               end;
            end else
            if z = '535' then begin
               CustomInfo := 'Server reported authentication error';
               FLogFile(Self, lfLog);
               PutString('QUIT');
               State := bdDone;
               ProtocolError := ecAbortByRemote;
            end;
            if (z = '235') or (State = bdMail) then begin
               PutString('MAIL FROM: <' + GetWord(4) + '>');
               PutString('RCPT TO: <' + ExtractWord(1, ipAddr, ['"']) + '>');
               PutString('DATA');
               State := bdPrep;
            end;
         end;
      bdPrep:
         begin
            if z = '354' then begin
               State := bdFile;
               nBoun := '';
               SendHeader('');
            end;
         end;
      bdUser:
         begin
            if z = 'HELO' then begin
               PutString('250-' + ProductName);
               PutString('250-AUTH CRAM-MD5 LOGIN');
               PutString('250-SIZE');
               PutString('250 OK');
            end else
            if z = 'EHLO' then begin
               PutString('250-' + ProductName);
               PutString('250-AUTH CRAM-MD5 LOGIN');
               PutString('250-SIZE');
               PutString('250 OK');
            end else
            if z = 'AUTH' then begin
               GetWrd(s, z, ' ');
               if UpperCase(z) = 'LOGIN' then begin
                  State := bdAuth;
                  if s = '' then begin
                     z := 'Username:';
                     PutString('334 ' + EncodeB64(z));
                  end else begin
                     LList.AtIns(0, s);
                  end;
               end else
               if UpperCase(z) = 'CRAM-MD5' then begin
                  PutString('334 ' + EncodeB64(fStam));
                  State := bdCram;
               end else begin
                  PutString('504 Unrecognized authentication type.');
               end;
            end else
            if z = 'RSET' then begin
               PutString('250 OK RSET');
            end else
            if z = 'NOOP' then begin
               PutString('250 OK NOOP');
            end else
            if z = 'QUIT' then begin
               PutString('221 BYE');
               State := bdDone;
            end else begin
               PutString('530 Authentication required.');
            end;
         end;
      bdAuth:
         begin
            fUser := DecodeB64(a);
            CustomInfo := 'Login: ' + fUser;
            FLogFile(Self, lfLog);
            CustomInfo := fUser;
            FLogFile(Self, lfBinkPAddr);
            if CustomInfo = '' then begin
               z := 'Password:';
               PutString('334 ' + EncodeB64(z));
               State := bdPass;
               ParseAddress(s, FiAddr);
            end else begin
               PutString('535 Login error');
               State := bdDone;
            end;
         end;
      bdPass:
         begin
            fPass := DecodeB64(a);
            CustomInfo := 'Passw: ' + fPass;
            FLogFile(Self, lfLog);
            CustomInfo := '- ' + fPass;
            FLogFile(Self, lfBinkPPwd);
            if CustomInfo = '' then begin
               PutString('235 OK');
               State := bdWork;
            end else begin
               PutString('535 Login error');
               State := bdDone;
            end;
         end;
      bdCram:
         begin
            s := DecodeB64(a);
            GetWrd(s, z, ' ');
            fUser := z;
            CustomInfo := 'Login: ' + fUser;
            FLogFile(Self, lfLog);
            CustomInfo := fUser;
            FLogFile(Self, lfBinkPAddr);
            if CustomInfo = '' then begin
               ParseAddress(z, FiAddr);
               FillOutList := True;
               FGetNextFile(Self);
               CustomInfo := fStam + ' CRAM-MD5-' + s;
               FLogFile(Self, lfBinkPPwd);
               if CustomInfo = '' then begin
                  PutString('235 OK');
                  State := bdWork;
               end else begin
                  PutString('535 Login error');
                  State := bdDone;
               end;
            end else begin
               State := bdDone;
            end;
         end;
      bdWork:
         begin
            if z = 'MAIL' then begin
               repeat
                  GetWrd(s, z, ' ');
                  if pos('FROM:', z) > 0 then begin
                     GetWrd(a, z, ':');
                     fFrom := a;
                  end else
                  if pos('SIZE=', z) > 0 then begin
                     GetWrd(a, z, '=');
                     fSize := StrToInt(a);
                     R.d.FSize := fSize;
                  end;
               until s = '';
               PutString('250 OK');
            end else
            if z = 'RCPT' then begin
               GetWrd(s, z, ':');
               if z = 'TO' then begin
                  fDest := s;
                  PutString('250 OK');
               end;
            end else
            if z = 'DATA' then begin
               PutString('354 OK');
               R.ClearFileInfo;
               State := bdData;
               fFrom := ExtractWord(1, ExtractWord(2, ' ' + fFrom, ['<']), ['>']);
               fDest := ExtractWord(1, ExtractWord(2, ' ' + fDest, ['<']), ['>']);
               if ParseAddress(fFrom, aFrom) and ParseAddress(fDest, aDest) then begin
                  nFrom := '';
                  nDest := '';
                  nSubj := '';
                  fillchar(h, sizeof(h), 0);
                  h.OrigNode  := aFrom.Node;
                  h.DestNode  := inifile.MainAddr.Node;
                  h.Year      := CurrentYear;
                  h.Month     := MonthOf(Date);
                  h.Day       := DayOf(Date);
                  h.Hour      := HourOf(Time);
                  h.Minute    := MinuteOf(Time);
                  h.Second    := SecondOf(Time);
                  h.Baud      := 300;
                  h.PktType   := 2;
                  h.OrigNet   := aFrom.Net;
                  h.DestNet   := inifile.MainAddr.Net;
                  h.ProdCode  := $FF;
                  h.SerialNo  := $15;
                  h.OrigZone  := aFrom.Zone;
                  h.DestZone  := inifile.MainAddr.Zone;
                  h.OrigPoint := aFrom.Point;
                  h.DestPoint := inifile.MainAddr.Point;
                  if fPass <> '' then begin
                     move(fPass[1], h.Password, Length(fPass));
                  end;
                  m.MsgType   := 2;
                  m.OrigNode  := aFrom.Node;
                  m.DestNode  := aDest.Node;
                  m.OrigNet   := aFrom.Net;
                  m.DestNet   := aDest.Net;
                  m.Attribute := 0;
                  m.Cost      := 0;
                  z := FormatDateTime('dd mmm yy  hh:nn:ss', Date + Time);
                  move(z[1], m.DateTime, Length(z));
                  R.D.FName   := Format('%.8x.PKT', [GetTickCount xor xRandom32]);
                  R.d.FTime   := uGetSystemTime;
                  R.d.FSize   := fSize;
                  case FAcceptFile(Self) of
                  aaOK :
                     begin
                        R.d.FSize := fSize;
                        R.Stream.Write(h, SizeOf(h));
                        R.Stream.Write(m, SizeOf(m));
                        State := bdSeek;
                        dwCRC := CRC32_INIT;
                     end;
                  aaRefuse :
                     begin
                        PutString('550 file refused');
                        State := bdWork;
                     end;
                  aaAcceptLater :
                     begin
                        PutString('550 file will be accepted later');
                        State := bdWork;
                     end;
                  aaAbort :
                     begin
                        PutString('550 operation aborted');
                        State := bdWork;
                     end;
                  end;
               end;
            end else
            if z = 'RSET' then begin
               PutString('250 OK');
               fFrom := '';
               fDest := '';
               fSize := 0;
            end else
            if z = 'NOOP' then begin
               PutString('250');
            end else
            if z = 'HELP' then begin
               PutString('502');
            end else
            if z = 'QUIT' then begin
               PutString('221 BYE');
               State := bdDone;
            end else begin
               PutString('500 Command is not recognized.');
            end;
         end;
      bdData:
         begin
            while (a <> '') and (a[Length(a)] =';') do begin
               if LList.Count = 0 then begin
                  LList.Add(a);
                  exit;
               end;
               if IniFile.FTPDebug then begin
                  DbgLog('< ' + LList[0]);
               end;
               a := a + LList[0];
               s := s + LList[0];
               LList.AtFree(0);
               fSize := fSize - 2;
            end;
            fSize := fSize - DWORD(Length(a)) - 2;
            if z = 'RSET' then begin
               PutString('250 OK');
               fFrom := '';
               fDest := '';
               fSize := 0;
            end else
            if Prefile(z, s) then begin
               if CustomInfo = 'Rece' then State := bdRece;
            end else
            if z = '.' then begin
               PutString('250 OK');
               State := bdWork;
            end;
         end;
      bdRece:
         begin
            RecFile(z, a);
         end;
      bdSeek:
         begin
            if z = 'FROM:' then begin
               nFrom := ExtractWord(1, ExtractWord(1, s, ['<']), ['"']);
            end else
            if z = 'TO:' then begin
               nDest := ExtractWord(1, ExtractWord(1, s, ['<']), ['"']);;
            end else
            if z = 'SUBJECT:' then begin
               nSubj := s;
               if WordCount(s, ['?']) = 5 then begin
                  nSubj := DecodeB64(ExtractWord(4, s, ['?']));
               end;
            end else
            if pos('CONTENT-', z) = 1 then begin
               fChrs := ExtractParam('charset', s, fChrs);
            end else
            if pos('X-', z) = 1 then begin
            end else
            if z = '' then begin
               z := Trim(nDest) + #0;
               R.Stream.Write(z[1], Length(z));
               z := Trim(nFrom) + #0;
               R.Stream.Write(z[1], Length(z));
               z := Trim(nSubj) + #0;
               R.Stream.Write(z[1], Length(z));
               z := #1'INTL ' +
                    ExtractWord(1, ExtractWord(1, Addr2Str(aDest), ['@']), ['.']) + ' ' +
                    ExtractWord(1, ExtractWord(1, Addr2Str(aFrom), ['@']), ['.']) + #13;
               R.Stream.Write(z[1], Length(z));
               if aDest.Point <> 0 then begin
                  z := #1'TOPT ' + IntToStr(aDest.Point) + #13;
                  R.Stream.Write(z[1], Length(z));
               end;
               if aFrom.Point <> 0 then begin
                  z := #1'FMPT ' + IntToStr(aFrom.Point) + #13;
                  R.Stream.Write(z[1], Length(z));
               end;
               z := #1'MSGID: ' + Addr2Str(aFrom) + ' ' + JustName(R.d.FName) + #13;
               R.Stream.Write(z[1], Length(z));
               if fChrs = '' then fChrs := 'IBMPC';
               z := #1'CHRS: ' + fChrs + ' 2'#13;
               R.Stream.Write(z[1], Length(z));
               z := a + #13;
               R.Stream.Write(z[1], Length(z));
               State := bdNetm;
            end;
         end;
      bdNetm:
         begin
            R.d.FPos := R.d.FPos + DWORD(Length(a)) + 2;
            if z = '.' then begin
               z := #1'Via ' + ExtractWord(1, Station[1], [' ']) +  ' R-GATE/Taurus ' + RFCDateUTC + #13;
               R.Stream.Write(z[1], Length(z));
               z := #0#0#0;
               R.Stream.Write(z[1], 3);
               R.d.FSize := R.Stream.Position;
               R.d.FPos  := R.Stream.Position;
               FFinishRece(Self, aaOK);
               PutString('250 OK');
               State := bdData;
            end else begin
               for i := 1 to Length(a) do
               if a[i] = #0 then begin
                  a[i] := '^';
                  CustomInfo := 'Error in input stream (#0): ' + IntToStr(i) + ', ' + a;
                  FLogFile(Self, lfLog);
               end;
               fLine := a + #13;
               RecStep;
            end;
         end;
      end;
   end;
   Case State of
   bdFile:
      begin
         FGetNextFile(Self);
         if T.d.FName = '' then begin
            case aType of
            kwIMI:
               begin
                  PutString('--' + nBoun + '--');
               end;
            end;
            PutString;
            PutString('.');
            PutString;
            PutString('QUIT');
            State := bdDone;
         end else begin
            HandleFile(T.Stream, CRC, fStam);
            case aType of
            kwIUC,
            kwISE:
               begin
                  SendSEATHd(CRC, fStam);
                  fCode := cUUE;
                  State := bdSend;
               end;
            kwIMI:
               begin
                  if nBoun = '' then begin
                     nBoun := GetUniqStr;
                     PutString('MIME-Version: 1.0');
                     PutString('Content-Type: multipart/mixed; boundary="' + nBoun + '"');
                     PutString('Content-Transfer-Encoding: 8bit');
                     PutString;
                     PutString('--' + nBoun);
                     PutString('Content-Type: text/plain; charset=LATIN');
                     PutString('Content-Transfer-Encoding: 8bit');
                     PutString;
                     PutString('This is mime encoded FTN attach');
                     PutString;
                  end;
                  PutString('--' + nBoun);
                  PutString('Content-Type: application/octet-stream; name="' + T.d.FName + '";');
                  PutString('        size=' + IntToStr(T.d.FSize) + '; crc32=' + HexL(CRC));
                  PutString('Content-Transfer-Encoding: base64');
                  PutString('Content-Disposition: attachment; filename="' + T.d.FName + '";');
                  PutString('        Auth=' + fStam);
                  PutString;
                  fCode := cB64;
                  State := bdSend;
               end;
            end;
         end;
      end;
   bdSend:
      begin
         while CanSend do begin
            NewTimerSecs(Timer, BinkPTimeout);
            i := MinD(45, T.D.FSize - T.D.FPos);
            SetLength(s, i);
            i := T.Stream.Read(s[1], i);
            SetLength(s, i);
            case aType of
            kwISE,
            kwIUC:
               begin
                  PutString(Encode_UUEnc(s[1], Length(s)));
               end;
            kwIMI:
               begin
                  PutString(EncodeB64(s));
               end;
            end;
            Inc(T.d.FPos, i);
            if T.d.FPos = T.Stream.Size then begin
               case aType of
               kwISE,
               kwIUC:
                  begin
                     PutString('end');
                  end;
               kwIMI:
                  begin
                  end;
               end;
               PutString;
               State := bdFile;
               FFinishSend(Self, aaOK);
               break;
            end;
            if T.d.FPos mod 9000 = 0 then begin
               break;
            end;
         end;
      end;
   end;
   if TimerExpired(Timer) or (not CP.DCD) then begin
      if TimerExpired(Timer) then begin
         FLogFile(Self, lfTimeOut);
         ProtocolError := ecTimeout;
      end;
      Case State of
   bdRece: begin R.d.FSize := 0; FFinishRece(Self, aaAbort); end;
      end;
      State := bdDone;
   end;
   if CancelRequested then begin
      ProtocolError := ecAbortByLocal;
      State := bdDone;
   end;
   Application.ProcessMessages;
end;

function TSMTP.NextStep: boolean;
begin
   DoStep;
   Result := (State <> bdDone) and (CP <> nil) and (CP.Carrier = CP.DCD);
end;

procedure TSMTP.Start;
begin
   inherited Start(AAcceptFile, AFinishRece, AGetNextFile, AFinishSend, AChangeOrder);
   NewTimerSecs(Timer, BinkPTimeout);
end;

end.
