unit p_FTP;

interface

uses xMisc, Types, Windows, xBase, SysUtils,
     Menus, Controls, Forms, Classes, xIP;

function CreateFTPProtocol(CP: Pointer): Pointer;

const
   MaxSndBlkSz            = $2000;

var
   StartSndBlkSz: integer =  $200;
   SubBlkSz     : integer =  $400;

type

   TFTPState = (
   bdInit,
   bdUser,
   bdPass,
   bdLogin,
   bdPassw,
   bdServ,
   bdSend,
   bdRece,
   bdDone
   );

   TBinkPOutA  = array[0..MaxSndBlkSz - 1] of Char;
   TBinkPArray = array[0..2 * bdK32 - 1] of Char;

   TFTP = class(TInetProtocol)
      function GetStateStr: string;                               override;
      procedure ReportTraf(txMail, txFiles: DWORD);               override;
      procedure Cancel;                                           override;
      constructor Create(ACP: TPort);
      destructor Destroy; override;
      function TimeoutValue: DWORD;                               override;
      function DataSock: TSockPort;
      procedure SendFile(const n: string; BWZ: boolean);
      procedure ReceFile(const n: string);
      procedure DeleFile(const n: string);
      procedure SendList(const m: string; L: boolean);
      procedure WriteProc(const Buf; i: DWORD);
      function CanSend: boolean;
      procedure SendStep;
      procedure ReceStep;
      procedure AbortRece(const s: string = '');                  override;
      procedure FinisRece(const s: string = '');                  override;
      function NextStep: boolean;                                 override;
      procedure Start({RX}AAcceptFile: TAcceptFile;
                          AFinishRece: TFinishRece;
                      {TX}AGetNextFile: TGetNextFile;
                          AFinishSend: TFinishSend;
                      {CH}AChangeOrder: TChangeOrder
                      ); override;
   private
      State: TFTPState;
      dAddr: string;
      dPort: integer;
       aOut: TBinkPOutA;
       aRec: TBinkPArray;
       iRec: DWORD;
      dSock: TSockPort;
  TxBlkSize, TxBlkPos,
  TxBlkRead: DWORD;
      Tries: byte;
      Secur: boolean;
      fRest: DWORD;
      fList: string;
      rList: string;
      tList: string;
      aList: TStringColl;
      dList: TStringColl;
      procedure DoStep;
   end;

implementation

uses Wizard, WSock, Outbound, Plus, Recs, xFido, RadIni;

function CreateFTPProtocol;
begin
   Result := TFTP.Create(CP);
end;

function TFTP.GetStateStr: string;
begin
  case State of
  bdInit: result := 'Init';
  bdUser: result := 'Login';
  bdPass: result := 'Password';
  bdServ: result := 'Session';
  bdDone: result := 'Done';
  end;
end;

procedure TFTP.ReportTraf(txMail, txFiles: DWORD);
begin
  // nothing, just to avoid warning
end;

procedure TFTP.Cancel;
begin
  // nothing, just to avoid warning
end;

constructor TFTP.Create;
var
   i: integer;
   n: integer;
   s: string;
begin
   inherited Create(ACP);
   CfgEnter;
   aList := Cfg.FreqData.pnPaths.Copy;
   for i := 0 to CollMax(aList) do begin
      s := aList[i];
      for n := 1 to Length(s) do begin
         if s[n] in [':', '\'] then s[n] := '_';
      end;
      aList[i] := s + ' ' + aList[i]; 
   end;
   aList.Prev := aList;
   dList := aList;
   CfgLeave;
end;

destructor TFTP.Destroy;
begin
   FreeObject(dSock);
   FreeObject(dList);
   inherited Destroy;
end;

function TFTP.TimeoutValue;
begin
   Result := 1000;
end;

function TFTP.DataSock;
var
   New: THandle;
   Tsa: TSockAddr;
begin
   Result := nil;
   New := socket(AF_INET, SOCK_STREAM, 0);
   if New = INVALID_SOCKET then exit;
   FillChar(Tsa, SizeOf(Tsa), 0);
   Tsa.sin_family := AF_INET;
   Tsa.sin_addr.S_addr := Inet_Addr(PChar(dAddr));
   Tsa.sin_port := HToNS(dPort);
   if connect(New, Tsa, SizeOf(Tsa)) = 0 then begin
      PutString('150 Data socket created');
      Inc(SocksAlloc);
      Result := OpenPort(New, ptFTP, dPort);
      Result.CallerId := dAddr;
   end else begin
      closesocket(New);
   end;
end;

procedure TFTP.DeleFile;
var
   z: TBWZRec;
begin
   z := GetBWZ(n, 0, 0, FiAddr, nil);
   if z <> nil then begin
      if FileExists(z.GetBWZFName) then begin
         if DeleteFile(z.GetBWZFName) then begin
            PutString('250 ' + z.FName + ' deleted');
            FreeBWZ(z);
         end else begin
            PutString('550 Cannot delete file');
         end;
      end else begin
         PutString('550 File not found');
      end;
   end else begin
      CustomInfo := n;
      FLogFile(Self, lfDelete);
      if CustomInfo = '' then PutString('250 ' + n + ' unlinked')
                         else PutString('550 ' + CustomInfo);
   end;
end;

procedure TFTP.SendFile;
begin
   if BWZ then begin
      FFinishSend(Self, aaAbort);
      PutString('425 File cannot be loaded from BWZ');
      exit;
   end;
   dSock := DataSock;
   if dSock <> nil then begin
      State := bdSend;
      SendFTPFile := True;
      CustomInfo := n;
      T.D.BlkLen := StartSndBlkSz;
      FGetNextFile(Self);
      if CustomInfo = '' then begin
         T.d.FPos := fRest;
         T.Stream.Position := fRest;
         if fRest <> 0 then begin
            FLogFile(Self, lfSendSync);
         end;
      end else begin
         PutString('425 ' + CustomInfo);
         FreeObject(dSock);
         State := bdServ;
         exit;
      end;
   end else begin
      FFinishSend(Self, aaAbort);
      PutString('425 socket creation error');
   end;
end;

procedure TFTP.ReceFile;
begin
   dSock := DataSock;
   if dSock <> nil then begin
      State := bdServ;
      CustomInfo := n;
      R.d.FName := n;
      R.d.FTime := uGetSystemTime;
      R.d.FOfs := 0;
      R.d.FSize := 0;
      case FAcceptFile(Self) of
      aaOK : State := bdRece;
      aaRefuse :
         begin
            PutString('426 file refused');
            FreeObject(dSock);
         end;
      aaAcceptLater :
         begin
            PutString('426 file will be accepted later');
            FreeObject(dSock);
         end;
      aaAbort :
         begin
            PutString('426 operation aborted');
            FreeObject(dSock);
         end;
       end;
   end else begin
      PutString('425 data socket error');
   end;
end;

procedure TFTP.SendList;
var Tsp: TSockPort;
      i: integer;
      n: integer;
      s: string;
      a: string;
      b: string;
      d: TStringColl;

      function MakeLine(const a, s: string; l: boolean): string;
      var
         n,
         r: int64;
         d: TDateTime;
      begin
         Result := '';
         r := GetFileSize(s);
         if r > -1 then begin
            n := FileAge(s);
            Result := '-';
         end else begin
            if not l then exit;
            r := GetDirSize(s);
            if r > -1 then begin
               n := GetDirTime(s);
               Result := 'd';
            end else exit;
         end;
         if (r <> -1) and (MatchMask(s, m)) then begin
            if l then begin
               d := FileDateToDateTime(n);
               Result := Result + 'rwxrwxrwx 1 fido fido ' + IntToStr(r) + FormatDateTime(' mmm d yyyy ', d) + a + #13#10;
            end else begin
               Result := a + #13#10;
            end;
         end;
      end;
begin
   Tsp := DataSock;
   if Tsp <> nil then begin
      if fList = '' then begin
         for i := 0 to CollMax(dList) do begin
            s := ExtractWord(2, dList[i], [' ']);
            if s = '' then begin
               s := dList[i];
            end;
            a := s;
            for n := 1 to Length(s) do begin
               if s[n] in [':', '\'] then s[n] := '_';
            end;
            dList[i] := s + ' ' + a;
         end;
         for i := 0 to CollMax(dList) do begin
            a := ExtractWord(1, dList[i], [' ']);
            s := ExtractWord(2, dList[i], [' ']);
            a := MakeLine(a, s, l);
            if a <> '' then begin
               Tsp.SendString(a);
               Tsp.Flsh;
            end;
         end;
         FillOutList := True;
         FGetNextFile(Self);
         for i := 0 to CollMax(OutFiles) do begin
            a := ExtractWord(1, OutFiles[i], [' ']);
            s := OutPaths[i];
            a := MakeLine(a, s, l);
            if a <> '' then begin
               Tsp.SendString(a);
               Tsp.Flsh;
            end;
         end;
      end else begin
         i := dList.Matched(fList);
         if (i > -1) or (dList.Name = fList) then begin
            if dList.Name <> fList then begin
               rList := ExtractWord(2, dList[i], [' ']);
               d := dList.Objects[i];
               if d = nil then begin
                  d := GetfileList(rList, fList);
                  d.Prev := dList;
                  d.Mark := rList;
                  dList.Objects[i] := d;
               end;
               dList := d;
            end else begin
               d := dList;
               rList := d.Mark;
            end;
            for i := 0 to CollMax(d) do begin
               a := ExtractWord(1, d[i], [' ']);
               b := rList + '\' + a;
               d[i] := a + ' ' + b;
               s := MakeLine(a, b, l);
               if s <> '' then begin
                  Tsp.SendString(s);
                  Tsp.Flsh;
               end;
            end;
         end;
      end;
      While Tsp.OutUsed > 0 do Application.ProcessMessages;
      FreeObject(Tsp);
      PutString('226 Data transfer completed');
   end else begin
      PutString('425 data socket error');
   end;
end;

procedure TFTP.WriteProc(const Buf; i: DWORD);
var
  p: PByteArray;
  c: DWORD;
begin
  if i = 0 then Exit;
  p := @Buf;
  for c := 0 to i - 1 do dSock.PutChar(p^[c]);
  dSock.Flsh;
end;

function TFTP.CanSend: Boolean;
begin
  Result := (dSock.OutUsed < T.D.BlkLen * 4);
end;

procedure TFTP.SendStep;
var
   i: DWORD;
   a: integer;
   e: integer;
begin
   if CanSend then begin
      i := MinD(T.D.BlkLen, T.D.FSize - T.D.FPos);
      SetLastError(0);
      a := T.Stream.Read(aOut, i);
      e := GetLastError;
      if (a <> i) or (e <> 0) then begin
         CustomInfo := Format('Read Error, i = %d, a = %d, e = %d, offset = ', [i, a, e, T.Stream.Position]);
         FLogFile(Self, lfLog);
         FFinishSend(Self, aaSysError);
         FreeObject(dSock);
         State := bdServ;
         exit;
      end else begin
         TxBlkSize := i;
         TxBlkRead := i;
         TxBlkPos  := 0;
      end;
      NewTimerSecs(Timer, BinkPTimeout);
      WriteProc(aOut[TxBlkPos], i);
      if T.D.BlkLen < MaxSndBlkSz then T.D.BlkLen := T.D.BlkLen shl 1;
      if T.D.BlkLen > MaxSndBlkSz then T.D.BlkLen := MaxSndBlkSz;
      if TxBlkPos + i = TxBlkSize then begin
         Inc(T.D.FPos, TxBlkRead);
      end;
      if T.D.FPos = T.D.FSize then begin
         while dSock.OutUsed > 0 do Application.ProcessMessages;
         PutString('226 Data transfer completed');
         FreeObject(dSock);
         FFinishSend(Self, aaOK);
         FreeObject(dSock);
         State := bdServ;
         exit;
      end else begin
         Inc(TxBlkPos, i);
      end;
   end else
   if T.D.BlkLen > 512 then begin
      T.D.BlkLen := T.D.BlkLen shr 1;
   end;
end;

procedure TFTP.ReceStep;
var
   c: byte;
begin
   iRec := 0;
   if dSock.CharReady then begin
      NewTimerSecs(Timer, BinkPTimeout);
      While dSock.CharReady do begin
         dSock.GetChar(c);
         aRec[iRec] := Char(c);
         inc(iRec);
         if iRec = SizeOf(aRec) then break;
      end;
   end;
   if (R.Stream.Write(aRec, iRec) <> iRec) or (GetErrorNum <> 0) then
   begin
      PutString('426 ' + GetErrorMsg);
      FreeObject(dSock);
      FFinishRece(Self, aaSysError);
      FreeObject(dSock);
      State := bdServ;
      exit;
   end else begin
      R.d.FPos := R.Stream.Position;
      R.d.FSize := R.d.FPos;
      iRec := 0;
   end;
   if not dSock.DCD then begin
      if CP.CharReady then exit;
      PutString('226 data socket closed');
      FreeObject(dSock);
      R.d.FPos := R.Stream.Position;
      R.d.FSize := R.d.FPos;
      FFinishRece(Self, aaOK);
      FreeObject(dSock);
      State := bdServ;
      exit;
   end;
end;

procedure TFTP.DoStep;
var
   S,
   Z: string;
   I: integer;
   B: TBWZRec;
   L: boolean;
begin
   case State of
   bdInit:
      begin
         if originator then begin
            State := bdLogin;
         end else begin
            State := bdUser;
            PutString('220 ' + ProductName + '-FTP Server is ready at ' + RFCDateStr);
         end;
      end;
   end;
   CheckInput;
   while LList.Count > 0 do begin
      NewTimerSecs(Timer, BinkPTimeout);
      s := LList[0];
      LList.AtFree(0);
      if s = '' then continue;
      if IniFile.FTPDebug then begin
         DbgLog('< ' + s);
      end;
      GetWrd(s, z, ' ');
      if (UpperCase(z) = 'USER') and (State = bdUser) then begin
         CustomInfo := 'Login: ' + s;
         FLogFile(Self, lfLog);
         CustomInfo := s;
         FLogFile(Self, lfBinkPAddr);
         if CustomInfo = '' then begin
            PutString('331 OK');
            State := bdPass;
            ParseAddress(s, FiAddr);
         end else begin
            inc(Tries);
            if Tries < 3 then begin
               PutString('530 Login error');
            end else begin
               PutString('530 That''s enough');
               State := bdDone;
            end;
         end;
      end else
      if (UpperCase(z) = 'PASS') and (State = bdPass) then begin
         CustomInfo := '- ' + s;
         FLogFile(Self, lfBinkPPwd);
         if CustomInfo = '' then begin
            Secur := s <> '';
            PutString('230-System information');
            PutString('--- SYS ' + Station.Station);
            PutString('--- ZYZ ' + Station.Sysop);
            PutString('--- LOC ' + Station.Location);
            PutString('--- PHN ' + Station.Phone);
            PutString('--- NDL ' + Station.Flags);
            PutString('--- TIM ' + RFCDateStr);
            PutString('--- VER ' + ProductName + '/' + ProductVersion + '/' + ProductPlatform + '/FTP/1.0');
            PutString('230 Welcome to the ' + Station.Station + ' FTP service');
            DummyNextFile := True;
            FGetNextFile(Self);
            T.d.State := bsIdle;
            R.d.State := bsIdle;
            State := bdServ;
         end else begin
            PutString('530 ' + CustomInfo);
         end;
      end else
      if (UpperCase(z) = 'ABOR') and ((State = bdSend) or (State = bdRece)) then begin
         PutString('226 operation aborted');
         Case State of
      bdRece: begin R.d.FSize := 0; FFinishRece(Self, aaAbort); end;
      bdSend: FFinishSend(Self, aaAbort);
         end;
         State := bdServ;
         FreeObject(dSock);
      end else
      if (State = bdServ) then begin
         if (UpperCase(z) = 'PWD') or
            (UpperCase(z) = 'XPWD') then begin
            if fList <> '' then begin
               PutString('257 "' + fList + '"');
            end else begin
               PutString('257 "/"');
            end;
         end else
         if (UpperCase(z) = 'CDUP') then begin
            CustomInfo := 'CDUP: ' + s;
            FLogFile(Self, lfLog);
            tList := JustPathName(tList);
            fList := JustFileName(tList);
            rList := JustPathName(rList);
            dList := dList.Prev;
            PutString('250 ' + tList);
         end else
         if (UpperCase(z) = 'CWD') or
            (UpperCase(z) = 'XCWD') then begin
            CustomInfo := 'XCWD: ' + s;
            FLogFile(Self, lfLog);
            if s = '..' then begin
               tList := JustPathName(tList);
               fList := JustFileName(tList);
               rList := JustPathName(rList);
               dList := dList.Prev;
               PutString('250 ' + tList);
            end else
            if dList <> nil then begin
               i := dList.Matched(s);
               if i > -1 then begin
                  fList := ExtractWord(1, dList[i], [' ']);
                  if tList = '\' then tList := '';
                  tList := tList + '\' + fList;
                  if dList.Objects[i] <> nil then dList := dList.Objects[i];
                  PutString('250 ' + tList);
               end else begin
                  PutString('550 path not found');
               end;
            end else begin
               PutString('451 internal error');
            end;
         end else
         if UpperCase(z) = 'PORT' then begin
            dAddr := '';
            for i := 1 to 4 do begin
               dAddr := dAddr + ExtractWord(i, s, [',']) + '.';
            end;
            Delete(dAddr, Length(dAddr), 1);
            dPort := StrToInt(ExtractWord(5, s, [','])) shl 8;
            dPort := dPort + StrToInt(ExtractWord(6, s, [',']));
            PutString('200 ' + dAddr + ':' + IntToStr(dPort));
         end else
         if UpperCase(z) = 'SYST' then begin
            PutString('215 WINDOWS Type: L8 Vers: ' + GetOsVer);
         end else
         if UpperCase(z) = 'MODE S' then begin
            PutString('200 MODE set to stream');
         end else
         if UpperCase(z) = 'TYPE' then begin
            PutString('200 type changed to ' + s);
         end else
         if UpperCase(z) = 'PASV' then begin
            PutString('502 passive mode is not supported');
         end else
         if UpperCase(z) = 'RETR' then begin
            if fList = '' then begin
               s := JustFileName(s);
               SendFile(s, pos('.BWZ', s) > 0);
               fRest := 0;
            end else begin
               i := dList.Matched(s);
               if i > -1 then begin
                  s := ExtractWord(2, dList[i], [' ']);
                  SendFile(s, False);
               end;
            end;
         end else
         if UpperCase(z) = 'REST' then begin
            fRest := StrToIntDef(s, -1);
            if fRest <> dword(-1) then begin
               PutString('350 mark accepted');
            end else begin
               fRest := 0;
               PutString('501 bad mark: ' + s);
            end;
         end else
         if UpperCase(z) = 'STOR' then begin
            s := JustFileName(s);
            ReceFile(s);
            fRest := 0;
         end else
         if UpperCase(z) = 'APPE' then begin
            s := JustFileName(s);
            ReceFile(s);
            fRest := 0;
         end else
         if (UpperCase(z) = 'LIST') or
            (UpperCase(z) = 'NLST') then begin
            L := pos('LIST', UpperCase(z)) > 0;
            CustomInfo := z;
            FLogFile(Self, lfLog);
            repeat
               GetWrd(s, z, ' ');
               if (z <> '') and (z[1] <> '-') then begin
                  SendList(JustFileName(z), L);
                  exit;
               end;
            until z = '';
            SendList('*', L);
         end else
         if UpperCase(z) = 'SIZE' then begin
            s := JustFileName(s);
            b := GetBWZ(s, 0, 0, FiAddr, nil);
            if b <> nil then begin
               PutString('213 ' + IntToStr(b.TmpSize));
            end else begin
               PutString('213 -1');
            end;
         end else
         if UpperCase(z) = 'DELE' then begin
            CustomInfo := 'DELE: ' + s;
            FLogFile(Self, lfLog);
            DeleFile(s);
            if CustomInfo <> '' then begin
               FLogFile(Self, lfLog);
            end;
         end else
         if UpperCase(z) = 'QUIT' then begin
            CustomInfo := 'QUIT';
            FLogFile(Self, lfLog);
            State := bdDone;
            PutString('200 BYE');
         end else begin
            PutString('502 command is not supported');
         end;
      end else begin
         PutString('530 not logged in');
      end;
   end;
   if TimerExpired(Timer) or (not CP.DCD) then begin
      FLogFile(Self, lfTimeOut);
      Case State of
   bdRece: begin R.d.FSize := 0; FFinishRece(Self, aaAbort); end;
   bdSend: FFinishSend(Self, aaAbort);
      end;
      FreeObject(dSock);
      State := bdDone;
   end;
   case State of
   bdUser:;
   bdPass:;
   bdLogin:;
   bdPassw:;
   bdServ:;
   bdSend: SendStep;
   bdRece: ReceStep;
   bdDone:;
   end;
   if CancelRequested then begin
      ProtocolError := ecAbortByLocal;
      State := bdDone;
   end;
   Application.ProcessMessages;
end;

procedure TFTP.AbortRece;
begin
   //
end;

procedure TFTP.FinisRece;
begin
   //
end;

function TFTP.NextStep: boolean;
begin
   DoStep;
   Result := (State <> bdDone) and (CP.Carrier = CP.DCD);
end;

procedure TFTP.Start;
begin
   inherited Start(AAcceptFile, AFinishRece, AGetNextFile, AFinishSend, AChangeOrder);
   NewTimerSecs(Timer, BinkPTimeout);
end;

end.
