unit p_NNTP;

interface

uses xMisc, Types, Windows, xBase, SysUtils, Menus,
     Controls, Forms, Classes, xIP, Netmail, xFido;

function CreateNNTPProtocol(CP: Pointer): Pointer;

const
   IdxVer = $0001;

type

   TNNTPState = (
   bdInit,
   bdAuth,
   bdPass,
   bdIdle,
   bdSend,
   bdPost,
   bdSeek,
   bdData,
   bdDone
   );

   TEchomail = class(TNetmail)
      Counter: integer;
      fAddres: TFidoAddress;
      constructor Create; virtual;
      function findArt(const n: integer; const e: string): TNetmailMsg;
      procedure SaveIdx;
      function GetGroup(const g: string): PGroup;
   protected
      procedure SetAddress(a: TFidoAddress);
   public
      property Address: TFidoAddress read fAddres write SetAddress;
   end;

   TNNTP = class(TInetProtocol)
      State: TNNTPState;
      function GetStateStr: string;                               override;
      procedure ReportTraf(txMail, txFiles: DWORD);               override;
      procedure Cancel;                                           override;
      constructor Create(ACP: TPort);
      destructor Destroy; override;
      function TimeoutValue: DWORD;                               override;
      procedure WriteProc(const Buf; i: DWORD);
      procedure SendList(const s: string = '');                   virtual;
      procedure FinisSend(const s: string = '');                  override;
      function RecStep: boolean;
      function NextStep: boolean;                                 override;
      procedure Start({RX}AAcceptFile: TAcceptFile;
                          AFinishRece: TFinishRece;
                      {TX}AGetNextFile: TGetNextFile;
                          AFinishSend: TFinishSend;
                      {CH}AChangeOrder: TChangeOrder
                      ); override;
   private
      fUser,
      fPass: string;
      fCode: TCoding;
      fEcho: TEchomail;
      Group: string;
      fBase: integer;
      fNumb: integer;
      fCurr: integer;
      fArea: string;
      fChrs: string;
      fEdit: string;
      rMsId: string;
      procedure DoStep;
   end;

implementation

uses
   Wizard, WSock, Outbound, Plus, Recs, RadIni, UStr, xDES,
   DateUtils, Crypt, RadSav;

function CreateNNTPProtocol;
begin
   Result := TNNTP.Create(CP);
end;

function FindHolder(const a: TFidoAddress): TEchomail;
var
   i: integer;
   h: TEchomail;
begin
   Result := nil;
   EchoMailHolder.Enter;
   for i := 0 to CollMax(EchomailHolder) do begin
      h := EchoMailHolder[i];
      if CompareAddrs(h.Address, a) = 0 then begin
         Result := h;
         break;
      end;
   end;
   EchoMailHolder.Leave;
end;

constructor TEchoMail.Create;
begin
   inherited;
   Echomail := True;
   Counter := 1;
   EchoMailHolder.Enter;
   EchoMailHolder.Add(Self);
   EchoMailHolder.Leave;
end;

function TEchoMail.findArt;
var
   i: integer;
begin
   try
      NetColl.Enter;
      for i := 0 to CollMax(NetColl) do begin
         Result := NetColl[i];
         if Result.Echo = e then begin
            if Result.Numb = Cardinal(n) then begin
               exit;
            end;
         end;
      end;
      Result := nil;
   finally
      NetColl.Leave;
   end;
end;

procedure TEchomail.SetAddress;
var
   i: TFileStream;
   m: TNetmailMsg;
   n: string;
   j: integer;
   k: integer;
   l: integer;
   r: PGroup;
   s: string;
   b: byte;
begin
   if CompareAddrs(a, fAddres) <> 0 then begin
      fAddres := a;
      n := GetOutFileName(a, osNone) + '.idx';
      if ExistFile(n) then begin
         NetColl.Enter;
         NetColl.FreeAll;
         FilColl.Clear;
         LstColl.Clear;
         i := TFileStream.Create(n, fmOpenRead);
         j := 0;
         i.Read(j, 2);
         if j = $1111 then begin
            i.Read(j, 2);
            if j = IdxVer then begin
               i.Read(j, 2);
               for k := 0 to j - 1 do begin
                  i.Read(b, 1);
                  SetLength(s, b);
                  i.Read(s[1], b);
                  GetMem(r, SizeOf(TGroup));
                  i.Read(r.base, SizeOf(r.base));
                  r.numb := 0;
                  l := LstColl.Add(s);
                  LstColl.Objects[l] := Pointer(r);
               end;
            end else begin
               i.Free;
               NetColl.Leave;
               exit;
            end;
         end else begin
            i.Position := 0;
         end;
         while i.Position < i.Size do begin
            m := TNetmailMSG.Create;
            m.Get(i);
            j := LstColl.Add(m.Echo);
            r := Pointer(LstColl.Objects[j]);
            if r = nil then begin
               GetMem(r, SizeOf(TGroup));
               r.base := m.Numb - 1;
               r.numb := 0;
            end else begin
               if m.Numb <> r.base + r.numb + 1 then begin
                  m.Numb := r.base + r.numb + 1;
                  fBackup := True;
               end;
            end;
            if ExistFile(m.Pack) then begin
               NetColl.Add(m);
               FilColl.Add(m.Pack);
               inc(r.numb);
            end else begin
               fBackup := True;
               r.base := m.Numb;
               FreeObject(m);
            end;
            LstColl.Objects[j] := Pointer(r);
         end;
         i.Free;
         NetColl.Leave;
      end;
   end;
end;

procedure TEchoMail.SaveIdx;
var
   n: integer;
   i: TFileStream;
   s: string;
   b: byte;
   r: PGroup;
begin
   if fBackup then begin
      NetColl.Enter;
      i := TFileStream.Create(GetOutFileName(Address, osNone) + '.idx', fmCreate);
      n := $1111;
      i.Write(n, 2);
      n := IdxVer;
      i.Write(n, 2);
      n := LstColl.Count;
      i.Write(n, 2);
      for n := 0 to LstColl.Count - 1 do begin
         s := LstColl[n];
         b := Length(s);
         i.Write(b, 1);
         i.Write(s[1], b);
         r := Pointer(LstColl.Objects[n]);
         if r <> nil then begin
            i.Write(r.base, SizeOf(r.base));
         end else begin
            i.Write(r, SizeOf(r.base));
         end;
      end;
      for n := 0 to CollMax(NetColl) do begin
         NetColl[n].Put(i);
      end;
      i.Free;
      fBackup := False;
      NetColl.Leave;
   end;
end;

function TEchomail.GetGroup;
var
   i: integer;
begin
   Result := nil;
   i := LstColl.IndexOf(g);
   if i > -1 then begin
      Result := Pointer(LstColl.Objects[i]);
   end;
end;

function TNNTP.GetStateStr: string;
begin
  case State of
  bdInit: result := 'Init';
  bdDone: result := 'Done';
  end;
end;

procedure TNNTP.ReportTraf(txMail, txFiles: DWORD);
begin
  OutSize := TxMail + TxFiles;
end;

procedure TNNTP.Cancel;
begin
  // nothing, just to avoid warning
end;

constructor TNNTP.Create;
begin
   inherited Create(ACP);
end;

destructor TNNTP.Destroy;
begin
   if fEcho <> nil then begin
      Dec(fEcho.Counter);
      if fEcho.Counter = 0 then begin
         EchoMailHolder.Delete(fEcho);
         FreeObject(fEcho);
      end;
   end;
   inherited Destroy;
end;

function TNNTP.TimeoutValue;
begin
   Result := 1000;
end;

procedure TNNTP.WriteProc(const Buf; i: DWORD);
var
  p: PByteArray;
  c: DWORD;
begin
  if i = 0 then Exit;
  p := @Buf;
  for c := 0 to i - 1 do CP.PutChar(p^[c]);
  CP.Flsh;
end;

procedure TNNTP.SendList;
var
   i: integer;
   n: integer;
   l: string;
begin
   for i := 0 to fEcho.LstColl.Count - 1 do begin
      l := fEcho.LstColl[i];
      n := Integer(fEcho.LstColl.Objects[i]);
      if s = '' then begin
         l := l + ' ' + IntToStr(n) + ' 1 y';
      end;
      PutString(l);
   end;
end;

procedure TNNTP.FinisSend;
begin
   State := bdIdle;
end;

function TNNTP.RecStep;
var
   i: integer;
begin
   Result := True;
   if fLine = '' then exit;
   for i := 1 to Length(fLine) do begin
     if fLine[i] = 'Í' then fLine[i] := 'H';
   end;
   NewTimerSecs(Timer, BinkPTimeout);
   if (R.Stream.Write(fLine[1], Length(fLine)) <> DWORD(Length(fLine))) or (GetErrorNum <> 0) then
   begin
      AbortRece(GetErrorMsg);
      FFinishRece(Self, aaSysError);
      Result := False;
      exit;
   end else begin
//      R.d.FPos := R.Stream.Position;
   end;
end;

procedure TNNTP.DoStep;
var
   I: integer;
   N: integer;
   S,
   Z: string;
   A: string;
   b,
   e: integer;
   m: TNetmailMsg;
   h: PktHeaderRec;
   p: PackedMsgHeaderRec;
   l: TStringList;
   d: TDualColl;
   g: PGroup;
begin
   case State of
   bdInit:
      begin
         fStam := IntToStr(GetCurrentThreadId) + '.' + IntToStr(GetTickCount);
         fStam := '<' + fStam + '@' + ProductName + '>';
         PutString('201 Taurus-NNTP server is ready ' + fStam);
         State := bdAuth;
      end;
   end;
   CheckInput;
   while LList.Count > 0 do begin
      NewTimerSecs(Timer, BinkPTimeout);
      s := LList[0];
      LList.AtFree(0);
      if not (State in [bdPost, bdSeek, bdData]) then begin
         if s = '' then continue;
      end;
      a := s;
      if IniFile.FTPDebug then begin
         DbgLog('< ' + s);
      end;
      GetWrd(s, z, ' ');
      z := UpperCase(z);
      if z = 'QUIT' then begin
         PutString('205 BYE');
         State := bdDone;
      end else
      case State of
      bdAuth:
         begin
            if z = 'AUTHINFO' then begin
               GetWrd(s, z, ' ');
               z := UpperCase(z);
               if z = 'USER' then begin
                  fUser := s;
                  CustomInfo := 'Login: ' + s;
                  FLogFile(Self, lfLog);
                  CustomInfo := s;
                  FLogFile(Self, lfBinkPAddr);
                  if CustomInfo = '' then begin
                     PutString('381 password is needed');
                     ParseAddress(s, FiAddr);
                  end else begin
                     State := bdDone;
                  end;
               end else
               if z = 'PASS' then begin
                  fPass := s;
                  CustomInfo := '- ' + s;
                  FLogFile(Self, lfBinkPPwd);
                  if CustomInfo = '' then begin
                     DummyNextFile := True;
                     FGetNextFile(Self);
                     T.d.State := bsIdle;
                     R.d.State := bsIdle;
                     PutString('281 Authorization OK');
                     State := bdIdle;
                     FillOutList := True;
                     FGetNextFile(Self);
                     fEcho := FindHolder(FiAddr);
                     if fEcho = nil then begin
                        fEcho := TEchoMail.Create;
                        fEcho.Address := FiAddr;
                        d := IniFile.GetStrings('gNNTP');
                        if d <> nil then begin
                           i := d.MatchAddr('gNNTP', FiAddr);
                           if i > -1 then begin
                              z := TDualRec(d[i]^).st2^;
                           end;
                        end;
                        if ExistFile(z) then begin
                           l := TStringList.Create;
                           l.LoadFromFile(z);
                           for i := 0 to l.Count - 1 do begin
                              z := l[i];
                              if z = '' then continue;
                              if z[1] = ';' then continue;
                              if WordCount(z, [' ']) > 1 then begin
                                 z := ExtractWord(2, z, [' ']);
                              end;
                              fEcho.LstColl.Add(z);
                           end;
                           l.Free;
                        end;
                        for i := 0 to CollMax(OutPaths) do begin
                           s := UpperCase(OutPaths[i]);
                           if (fEcho.FilColl.IndexOf(s) = -1) and
                              (pos('.PKT', s) = Length(s) - 3) then begin
                              fEcho.ScanPacket(s);
                           end;
                        end;
                        fEcho.SaveIdx;
                     end else begin
                        Inc(fEcho.Counter);
                     end;
                  end else begin
                     PutString('502 ' + CustomInfo);
                     State := bdAuth;
                  end;
               end else begin
                  PutString('500');
               end;
            end else begin
               if fUser = '' then begin
                  PutString('480 Authorization is required');
               end else begin
                  if z = 'MODE' then begin
                     PutString('200');
                  end else begin
                     PutString('502');
                  end;
               end;
            end;
         end;
      bdIdle:
         begin
            if (z = 'LIST') or (z = 'NEWGROUPS') then begin
               CustomInfo := z + ' ' + s;
               FLogFile(Self, lfLog);
               if (s = '') or (z = 'NEWGROUPS') then begin
                  PutString('215 List of newsgroups');
                  SendList;
                  PutString('.');
               end else
               if s = 'NEWSGROUPS' then begin
                  PutString('215 List of newsgroups');
                  SendList(s);
                  PutString('.');
               end else begin
                  PutString('503 not supported');
               end;
            end else
            if z = 'GROUP' then begin
               CustomInfo := z + ' ' + s;
               FLogFile(Self, lfLog);
               i := fEcho.LstColl.IndexOf(s);
               if i > -1 then begin
                  Group := s;
                  g := Pointer(fEcho.LstColl.Objects[i]);
                  if g <> nil then begin
                     fBase := g.base;
                     fNumb := g.numb;
                  end else begin
                     fBase := 0;
                     fNumb := 0;
                  end;
                  s := '211 ' + IntToStr(fNumb) + ' ' + IntToStr(fBase + 1) + ' ' + IntToStr(fBase + fNumb) + ' ' + s;
                  PutString(s);
                  CustomInfo := s;
                  FLogFile(Self, lfLog);
               end else begin
                  PutString('411 group not found');
                  CustomInfo := 'Group not found';
                  FLogFile(Self, lfLog);
               end;
            end else
            if z = 'XOVER' then begin
               CustomInfo := z + ' ' + s;
               FLogFile(Self, lfLog);
               if Group <> '' then begin
                  if s = '' then begin
                     PutString('420 no article selected');
                  end else begin
                     PutString('224 overview list');
                     s := s + '-0';
                     b := StrToIntDef(ExtractWord(1, s, ['-']), 1);
                     e := StrToIntDef(ExtractWord(2, s, ['-']), fNumb);
                     if e = 0 then e := b;
                     fCurr := 0;
                     for i := b to e do begin
                        for n := 0 to CollMax(fEcho.NetColl) do begin
                           m := fEcho.NetColl[n];
                           if m.Echo = Group then begin
                              if m.Numb = Cardinal(i) then begin
                                 PutString(IntToStr(i) + #9 + Dos2Win(m.Subj) + #9 + m.Frnm + #9 + m.Date + #9 + m.MsId + #9 + m.Frnm + #9 + IntToStr(m.Size) + #9 + IntToStr(m.Line));
                                 break;
                              end;
                           end;
                        end;
                     end;
                     PutString('.');
                  end;
               end else begin
                  PutString('412 no group selected')
               end;
            end else
            if z = 'ARTICLE' then begin
               CustomInfo := z + ' ' + s;
               FLogFile(Self, lfLog);
               if s = '' then begin
                  PutString('420 no article selected');
               end else begin
                  if group = '' then begin
                     PutString('412 no group selected');
                  end else begin
                     m := fEcho.FindArt(StrToIntDef(s, 0), Group);
                     if m = nil then begin
                        PutString('423 article ' + s + ' not found');
                     end else begin
                        SendFTPFile := True;
                        CustomInfo := m.Pack;
                        fName := m.Pack;
                        FGetNextFile(Self);
                        if (t.d.FName <> '') and (T.Stream <> nil) then begin
                           PutString('220 ' + s + ' <' + m.MsId + '>');
                           PutString('From: ' + m.Frnm + ' <' + Addr2Str(m.From) + '>');
                           PutString('NewsGroups: ' + Group);
                           PutString('Subject: ' + m.Subj);
                           PutString('Date: ' + m.Date);
                           PutString('Message-ID: ' + m.MsId);
                           PutString('X-Mailer: ' + ProductName + '/' + ProductVersion);
                           PutString('Mime-Version: 1.0');
                           PutString('Content-Type: text/plain; charset=' + m.IChr);
                           PutString('Content-Transfer-Encoding: 8bit');
                           PutString;
                           T.Stream.Position := m.bOff;
                           T.d.FPos  := 0;
                           T.d.FOfs  := 0;
                           T.d.FSize := m.Size - m.bOff + m.Offs - m.Addy + SizeOf(m.Head);
                           State := bdSend;
                           exit;
                        end;
                     end;
                  end;
               end;
            end else
            if z = 'POST' then begin
               CustomInfo := z + ' ' + s;
               FLogFile(Self, lfLog);
               R.ClearFileInfo;
               nFrom := '';
               nDest := '';
               nSubj := '';
               R.D.FName   := Format('%.8x.PKT', [GetTickCount xor xRandom32]);
               R.d.FTime   := uGetSystemTime;
               R.d.FSize   := fSize;
               case FAcceptFile(Self) of
               aaOK :
                  begin
                     PutString('340 continue posting');
                     R.d.FSize := fSize;
                     rMsId := '';
                     State := bdSeek;
                  end;
               else
                  begin
                     PutString('441');
                     State := bdIdle;
                  end;
               end;
            end else begin
               PutString('503 not supported');
            end;
         end;
      bdSeek:
         begin
            if z = 'FROM:' then begin
               nFrom := ExtractWord(1, ExtractWord(1, s, ['<']), ['"']);
               nDest := 'All';
            end else
            if z = 'REFERENCES:' then begin
               m := fEcho.FindMessage(s);
               if m <> nil then begin
                  nDest := m.Frnm;
                  aDest := m.From;
                  rMsId := m.MsId;
                  for i:= 1 to Length(rMsId) do begin
                     if rMsId[i] = '#' then rMsId[i] := ' ';
                  end;
               end;
            end else
            if z = 'NEWSGROUPS:' then begin
               fArea := s;
            end else
            if z = 'SUBJECT:' then begin
               nSubj := s;
            end else
            if z = 'CONTENT-TYPE:' then begin
               fChrs := ExtractParam('charset', s, fChrs);
               if UpperCase(fChrs) = 'WINDOWS-1251' then fChrs := 'CP1251';
            end else
            if z = 'CONTENT-TRANSFER-ENCODING:' then begin
               if UpperCase(s) = 'BASE64' then fCode := cB64;
            end else
            if z = 'X-NEWSREADER:' then begin
               GetWrd(a, z, ' ');
               fEdit := a;
            end else
            if z = '' then begin
               fillchar(h, sizeof(h), 0);
               h.OrigNode  := FiAddr.Node;
               h.DestNode  := inifile.MainAddr.Node;
               h.Year      := CurrentYear;
               h.Month     := MonthOf(Date);
               h.Day       := DayOf(Date);
               h.Hour      := HourOf(Time);
               h.Minute    := MinuteOf(Time);
               h.Second    := SecondOf(Time);
               h.Baud      := 300;
               h.PktType   := 2;
               h.OrigNet   := FiAddr.Net;
               h.DestNet   := inifile.MainAddr.Net;
               h.ProdCode  := $FF;
               h.SerialNo  := $FF;
               h.OrigZone  := FiAddr.Zone;
               h.DestZone  := inifile.MainAddr.Zone;
               h.OrigPoint := FiAddr.Point;
               h.DestPoint := inifile.MainAddr.Point;
               if fPass <> '' then begin
                  move(fPass[1], h.Password, Length(fPass));
               end;
               p.MsgType   := 2;
               p.OrigNode  := aFrom.Node;
               p.DestNode  := aDest.Node;
               p.OrigNet   := aFrom.Net;
               p.DestNet   := aDest.Net;
               p.Attribute := 0;
               p.Cost      := 0;
               z := FormatDateTime('dd mmm yy  hh:nn:ss', Date + Time);
               move(z[1], p.DateTime, Length(z));
               R.Stream.Write(h, SizeOf(h));
               R.Stream.Write(p, SizeOf(p));
               z := Trim(nDest) + #0;
               R.Stream.Write(z[1], Length(z));
               z := Trim(nFrom) + #0;
               R.Stream.Write(z[1], Length(z));
               z := Trim(nSubj) + #0;
               R.Stream.Write(z[1], Length(z));
               z := 'AREA: ' + fArea + #13;
               R.Stream.Write(z[1], Length(z));
               z := #1'MSGID: ' + Addr2Str(FiAddr) + ' ' + JustName(R.d.FName) + #13;
               R.Stream.Write(z[1], Length(z));
               if rMsId <> '' then begin
                  z := #1'REPLY: ' + rMsId + #13;
                  R.Stream.Write(z[1], Length(z));
               end;
               if fChrs = '' then fChrs := 'IBMPC';
               z := #1'CHRS: ' + fChrs + ' 2'#13;
               R.Stream.Write(z[1], Length(z));
               if fEdit <> '' then begin
                  z := #1'PID: ' + fEdit + #13;
                  R.Stream.Write(z[1], Length(z));
               end;
               State := bdData;
            end;
         end;
      bdData:
         begin
            R.d.FPos := R.d.FPos + DWORD(Length(a)) + 2;
            if z = '.' then begin
               z := #13'--- ' + Station[0] + #13;
               R.Stream.Write(z[1], Length(z));
               z := ' * Origin: N-GATE/TAURUS (' + Addr2Str(FiAddr) + ')'#13;
               R.Stream.Write(z[1], Length(z));
               z := #0#0#0;
               R.Stream.Write(z[1], 3);
               R.d.FSize := R.Stream.Position;
               R.d.FPos  := R.Stream.Position;
               FFinishRece(Self, aaOK);
               PutString('240 article posted ok');
               State := bdIdle;
            end else begin
               if fCode = cB64 then begin
                  fLine := DecodeB64(Trim(a));
                  if fLine = '' then begin
                     fLine := #13;
                  end;
               end else begin
                  fLine := a + #13;
               end;
               RecStep;
            end;
         end;
      end;
   end;
   Case State of
   bdSend:
      begin
         SendFile;
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

function TNNTP.NextStep: boolean;
begin
   DoStep;
   Result := (State <> bdDone) and (CP.Carrier = CP.DCD);
end;

procedure TNNTP.Start;
begin
   inherited Start(AAcceptFile, AFinishRece, AGetNextFile, AFinishSend, AChangeOrder);
   NewTimerSecs(Timer, BinkPTimeout);
end;

end.
