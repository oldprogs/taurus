unit p_POP3;

interface

uses xMisc, Types, Windows, xBase, SysUtils,
     Menus, Controls, Forms, Classes, xIP;

function CreatePOP3Protocol(CP: Pointer): Pointer;

type

   TPOP3State = (
   bdInit,
   bdUser,
   bdPass,
   bdLogin,
   bdPassw,
   bdWork,
   bdList,
   bdTops,
   bdTopr,
   bdGetm,
   bdGetb,
   bdGetf,
   bdDele,
   bdDelw,
   bdIdle,
   bdSend,
   bdDone
   );

   TCoding = (
   cUNK,
   cB64,
   cMIM,
   cUUE
   );

   TPOP3 = class(TInetProtocol)
      State: TPOP3State;
      FList: TStringColl;
      DList: TStringColl;
      function GetStateStr: string;                               override;
      procedure ReportTraf(txMail, txFiles: DWORD);               override;
      procedure Cancel;                                           override;
      constructor Create(ACP: TPort);
      destructor Destroy; override;
      function TimeoutValue: DWORD;                               override;
      procedure WriteProc(const Buf; i: DWORD);
      function CanSend: boolean;
      procedure SendStat;                                         virtual;
      function  SendList(const n: integer): string;               virtual;
      function  SendUIDL(const n: integer): string;               virtual;
      procedure SendTop(const n: integer);                        virtual;
      procedure StartRETR(const n: integer);                      virtual;
      procedure SendFile;                                         virtual;                                         
      procedure ExecDele(const n: integer);                       virtual;
      procedure AbortRece(const s: string);                       override;
      procedure FinisRece(const s: string);                       override;
      procedure AuthOK;
      procedure Quit;
      function NextStep: boolean;                                 override;
      procedure Start({RX}AAcceptFile: TAcceptFile;
                          AFinishRece: TFinishRece;
                      {TX}AGetNextFile: TGetNextFile;
                          AFinishSend: TFinishSend;
                      {CH}AChangeOrder: TChangeOrder
                      ); override;
   private
      MList: TColl;
      CList: TStringColl;
      fUser,
      fPass: string;
      fCode: TCoding;
      fTops: string;
      procedure DoStep;
   end;

implementation

uses Wizard, WSock, Outbound, Plus, Recs, xFido, RadIni, UStr, xDES;

function CreatePOP3Protocol;
begin
   Result := TPOP3.Create(CP);
end;

function TPOP3.GetStateStr: string;
begin
  case State of
  bdInit: result := 'Init';
  bdDone: result := 'Done';
  end;
end;

procedure TPOP3.ReportTraf(txMail, txFiles: DWORD);
begin
  OutSize := TxMail + TxFiles;
end;

procedure TPOP3.Cancel;
begin
  // nothing, just to avoid warning
end;

constructor TPOP3.Create;
begin
   inherited Create(ACP);
   FList := TStringColl.Create;
   MList := TStringColl.Create;
   DList := TStringColl.Create;
end;

destructor TPOP3.Destroy;
begin
   FreeObject(FList);
   FreeObject(MList);
   FreeObject(DList);
   inherited Destroy;
end;

function TPOP3.TimeoutValue;
begin
   Result := 1000;
end;

procedure TPOP3.WriteProc(const Buf; i: DWORD);
var
  p: PByteArray;
  c: DWORD;
begin
  if i = 0 then Exit;
  p := @Buf;
  for c := 0 to i - 1 do CP.PutChar(p^[c]);
  CP.Flsh;
end;

function TPOP3.CanSend: Boolean;
begin
  Result := (CP.OutUsed < 60 + 2048);
end;

procedure TPOP3.SendStat;
begin
   FillOutList := True;
   FGetNextFile(Self);
   PutString('+OK ' + IntToStr(OutFiles.Count) + ' ' + IntToStr(OutSize));
end;

function TPOP3.SendList;
var
   i: integer;
   s: string;
begin
   Result := '';
   FillOutList := True;
   FGetNextFile(Self);
   if (n > 0) and (n <= OutFiles.Count) then begin
      Result := IntToStr(n) + ' ' + ExtractWord(2, OutFiles[n - 1], [' ']);
      exit;
   end;
   for i := 0 to CollMax(OutFiles) do begin
      while FList.Count < i + 2 do FList.Add('');
      FList[i + 1] := ExtractWord(1, OutFiles[i], [' ']);
      s := OutPaths[i];
      PutString(IntToStr(i + 1) + ' ' + ExtractWord(2, OutFiles[i], [' ']));
   end;
end;

function TPOP3.SendUIDL;
var
   i: integer;
   s: string;
begin
   Result := '';
   FillOutList := True;
   FGetNextFile(Self);
   if (n > 0) and (n <= OutFiles.Count) then begin
      Result := IntToStr(n) + ' ' + ExtractWord(1, OutFiles[n - 1], [' ']) + '.' + IntToStr(FileAge(OutPaths[n - 1]));
      exit;
   end;
   for i := 0 to CollMax(OutFiles) do begin
      s := OutPaths[i];
      PutString(IntToStr(i + 1) + ' ' + ExtractWord(1, OutFiles[i], [' ']) + '.' + IntToStr(FileAge(OutPaths[i])));
   end;
end;

procedure TPOP3.SendTop;
var
   d: integer;
begin
   if (n > 0) and (n <= OutFiles.Count) then begin
      PutString('+OK');
      PutString('FROM: ' + Addr2Str(IniFile.MainAddr));
      PutString('TO: ' + Addr2Str(FiAddr));
      PutString('SUBJECT: FTN Mail Transport (' + ExtractWord(1, OutFiles[n - 1], [' ']) + ')');
      d := FileAge(OutPaths[n - 1]);
      PutString('DATE: ' + RFCDateStr(d));
      PutString('.');
   end else begin
      PutString('-ERR');
   end;
end;

procedure TPOP3.StartRETR;
var
  CRC: DWORD;
begin
   if (n > -1) and (n <= Outfiles.Count) then begin
      SendFTPFile := True;
      CustomInfo := ExtractWord(1, OutFiles[n - 1], [' ']);
      FGetNextFile(Self);
      HandleFile(T.Stream, CRC, fStam);
      PutString('+OK');
      SendHeader(OutFiles[n - 1]);
      SendSeatHd(CRC, fStam);
      State := bdSend;
      fCode := cUUE;
   end else begin
      PutString('-ERR Message not found');
   end;
end;

procedure TPOP3.SendFile;
var
   i: integer;
   s: string;
begin
   while CanSend do begin
      i := MinD(45, T.D.FSize - T.D.FPos);
      SetLength(s, i);
      i := T.Stream.Read(s[1], i);
      SetLength(s, i);
      PutString(Encode_UUEnc(s[1], Length(s)));
      Inc(T.d.FPos, i);
      if T.d.FPos = T.Stream.Size then begin
         PutString('end');
         PutString;
         PutString('.');
         State := bdIdle;
         FFinishSend(Self, aaOK);
         break;
      end;
      if T.d.FPos mod 9000 = 0 then begin
         break;
      end;
   end;
end;

procedure TPOP3.ExecDele;
begin
   if (n > 0) and (n <= FList.Count) then begin
      CustomInfo := FList[n];
      FLogFile(Self, lfDelete);
      if CustomInfo = '' then PutString('+OK ' + FList[n] + ' unlinked')
                         else PutString('-ERR ' + CustomInfo);
   end else begin
      PutString('-ERR File not found');
   end;
end;

procedure TPOP3.AbortRece;
begin
   State := bdGetm;
end;

procedure TPOP3.FinisRece;
begin
   State := bdGetb;
end;

procedure TPOP3.AuthOK;
begin
   PutString('+OK');
   FillOutList := True;
   FGetNextFile(Self);
   T.d.State := bsIdle;
   R.d.State := bsIdle;
   State := bdIdle;
end;

procedure TPOP3.Quit;
begin
   PutString('QUIT');
   State := bdDone;
end;

procedure TPOP3.DoStep;
var
   S,
   Z: string;
   A: string;
   n: integer;
   D: TMD5Byte16;
begin
   case State of
   bdInit:
      begin
         if Originator then begin
            State := bdLogin;
         end else begin
            fStam := IntToStr(GetCurrentThreadId) + '.' + IntToStr(GetTickCount);
            fStam := '<' + fStam + '@' + ProductName + '>';
            PutString('+OK Taurus-POP3 server is ready ' + fStam);
            State := bdUser;
         end;
      end;
   end;
   CheckInput;
   while LList.Count > 0 do begin
      NewTimerSecs(Timer, BinkPTimeout);
      s := LList[0];
      LList.AtFree(0);
      if s = '' then continue;
      a := s;
      if IniFile.FTPDebug then begin
         DbgLog('< ' + s);
      end;
      GetWrd(s, z, ' ');
      z := UpperCase(z);
      if z = 'QUIT' then begin
         PutString('+OK BYE');
         State := bdDone;
      end else
      case State of
      bdLogin:
         begin
            z := ExtractWord(1, ExtractWord(2, s, ['<']), ['>']);
            FLogFile(Self, lfBinkPgAddr);
            fUser := ExtractWord(1, CustomInfo, [' ']);
            fPass := ExtractWord(2, CustomInfo, [' ']);
            if z <> '' then begin
               fStam := '<' + z + '>';
               if fPass = '' then fPass := '-';
               z := fStam + fPass;
               xCalcMD5(@z[1], Length(z), D);
               z := DigestToStr(D);
               PutString('APOP ' + fUser + ' ' + z);
               State := bdWork;
            end else begin
               PutString('USER ' + fUser);
               State := bdPassw;
            end;
         end;
      bdPassw:
         begin
            if z = '+OK' then begin
               PutString('PASS ' + fPass);
               State := bdWork;
            end;
         end;
      bdWork:
         begin
            if z = '+OK' then begin
               PutString('LIST');
               State := bdList;
               FList.FreeAll;
            end;
         end;
      bdList:
         begin
            if (z <> '+OK') and (z <> '.') then begin
               FList.Add(a);
            end else
            if (z = '.') then begin
               CustomInfo := 'LIST returned ' + IntToStr(FList.Count);
               FLogFile(Self, lfLog);
               if FList.Count = 0 then begin
                  Quit;
               end else begin
                  State := bdTops;
               end;
            end;
         end;
      bdTopr:
         begin
            if CList = nil then begin
               if z = '+OK' then begin
                  CList := TStringColl.Create;
                  CList.Add(fTops);
                  MList.Add(CList);
               end else begin
                  State := bdTops;
               end;
            end else begin
               if z = '.' then begin
                  CList := nil;
                  State := bdTops;
               end else begin
                  CList.Add(a);
               end;
            end;
         end;
      bdGetb:
         begin
            fSize := fSize - DWORD(Length(a)) - 2;
            if Prefile(z, s) then begin
               if CustomInfo = 'Rece' then State := bdGetf;
            end else
            if z = '.' then begin
               State := bdGetm;
            end;
         end;
      bdGetf:
         begin
            RecFile(z, a);
         end;
      bdDelw:
         begin
            if z = '+OK' then begin
               State := bdDele;
            end else begin
               Quit;
            end;
         end;
      bdUser:
         begin
            if z = 'USER' then begin
               fUser := s;
               CustomInfo := 'Login: ' + s;
               FLogFile(Self, lfLog);
               CustomInfo := s;
               FLogFile(Self, lfBinkPAddr);
               if CustomInfo = '' then begin
                  PutString('+OK');
                  State := bdPass;
                  ParseAddress(s, FiAddr);
               end else begin
                  State := bdDone;
               end;
            end else
            if z = 'APOP' then begin
               GetWrd(s, z, ' ');
               CustomInfo := 'Login: ' + z;
               FLogFile(Self, lfLog);
               CustomInfo := z;
               FLogFile(Self, lfBinkPAddr);
               if CustomInfo = '' then begin
                  ParseAddress(z, FiAddr);
                  CustomInfo := fStam + ' ' + s;
                  FLogFile(Self, lfNodePassw);
                  if CustomInfo = '' then begin
                     AuthOK;
                  end else begin
                     PutString('-ERR Auth error');
                     State := bdDone;
                  end;
               end else begin
                  State := bdDone;
               end;
            end else begin
               PutString('-ERR');
            end;
         end;
      bdPass:
         begin
            if z = 'PASS' then begin
               fPass := s;
               CustomInfo := '- ' + s;
               FLogFile(Self, lfBinkPPwd);
               if CustomInfo = '' then begin
                  AuthOK;
               end else begin
                  PutString('-ERR ' + CustomInfo);
                  State := bdUser;
               end;
            end;
         end;
      bdIdle:
         begin
            if z = 'STAT' then begin
               SendStat;
            end else
            if z = 'LIST' then begin
               n := StrToIntDef(s, -1);
               if n <> -1 then begin
                  PutString('+OK ' + SendList(n));
               end else
               if n = -1 then begin
                  PutString('+OK');
                  SendList(n);
                  PutString('.');
               end;
            end else
            if z = 'TOP' then begin
               GetWrd(s, z, ' ');
               n := StrToIntDef(z, 0);
               SendTop(n);
            end else
            if z = 'NOOP' then begin
               PutString('+OK NOOP');
            end else
            if z = 'UIDL' then begin
               n := StrToIntDef(s, -1);
               if n <> -1 then begin
                  PutString('+OK ' + SendUIDL(n));
               end else
               if n = -1 then begin
                  PutString('+OK');
                  SendUIDL(n);
                  PutString('.');
               end;
            end else
            if z = 'RETR' then begin
               n := StrToIntDef(s, -1);
               StartRETR(n);
            end else
            if z = 'DELE' then begin
               n := StrToIntDef(s, -1);
               ExecDele(n);
            end else begin
               PutString('-ERR');
            end;
         end;
      end;
   end;
   Case State of
   bdTops:
      begin
         if FList.Count > 0 then begin
            fTops := FList[0];
            PutString('TOP ' + ExtractWord(1, FList[0], [' ']) + ' 0');
            FList.AtFree(0);
            State := bdTopr;
         end else begin
            if MList.Count = 0 then begin
               Quit;
            end else begin
               State := bdGetm;
            end;
         end;
      end;
   bdGetm:
      begin
         if MList.Count = 0 then begin
//            Quit;
            State := bdDele;
         end else begin
            CList := MList[0];
            for n := 1 to CollMax(CList) do begin
               if pos('SUBJECT: FTN MAIL TRANSPORT', UpperCase(CList[n])) = 1 then begin
                  DList.Add(ExtractWord(1, CList[0], [' ']));
                  PutString('RETR ' + ExtractWord(1, CList[0], [' ']));
                  fSize := StrToIntDef(ExtractWord(2, CList[0], [' ']), 0);
                  State := bdGetb;
               end;
            end;
            FreeObject(CList);
            MList.AtDelete(0);
         end;
      end;
   bdSend:
      begin
         SendFile;
      end;
   bdDele:
      begin
         if DList.Count = 0 then begin
            Quit;
         end else begin
            PutString('DELE ' + DList[0]);
            DList.AtDelete(0);
            State := bdDelw;
         end;
      end;
   end;
   if TimerExpired(Timer) then begin
      FLogFile(Self, lfTimeOut);
      ProtocolError := ecTimeout;
      State := bdDone;
   end;
   if CancelRequested then begin
      ProtocolError := ecAbortByLocal;
      State := bdDone;
   end;
   Application.ProcessMessages;
end;

function TPOP3.NextStep: boolean;
begin
   DoStep;
   Result := (State <> bdDone) and (CP.Carrier = CP.DCD);
end;

procedure TPOP3.Start;
begin
   inherited Start(AAcceptFile, AFinishRece, AGetNextFile, AFinishSend, AChangeOrder);
   NewTimerSecs(Timer, BinkPTimeout);
end;

end.
