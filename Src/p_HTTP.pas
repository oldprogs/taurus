unit p_HTTP;

interface

uses xMisc, Types, Windows, xBase, SysUtils,
     Menus, Controls, Forms, Classes, xIP;

function CreateHTTPProtocol(CP: Pointer): Pointer;

const
   MaxSndBlkSz            = $4000;

var
   StartSndBlkSz: integer =  $200;
   SubBlkSz     : integer =  $400;

type

   THTTPState = (
   bdInit,
   bdPost,
   bdBody,
   bdSend,
   bdRece,
   bdFile,
   bdDone
   );

   THTTPContent = (
   cnNone,
   cnText,
   cnBin,
   cnDele,
   cnRead,
   cnPost,
   cnList
   );

   THTTPMethod = (
   mNone,
   mGet,
   mPost
   );

   TBinkPOutA  = array[0..MaxSndBlkSz - 1] of Char;
   TBinkPArray = array[0..2 * bdK32 - 1] of Char;

   THTTP = class(TInetProtocol)
      function GetStateStr: string;                               override;
      procedure ReportTraf(txMail, txFiles: DWORD);               override;
      procedure Cancel;                                           override;
      constructor Create(ACP: TPort);
      destructor Destroy; override;
      function TimeoutValue: DWORD;                               override;
      procedure WriteProc(const Buf; i: DWORD);
      function CanSend: boolean;
      procedure SendStep;
      procedure ReceStep;
      procedure DeleFile(const n: string);
      procedure BeginTable;
      procedure FinisTable;
      procedure MakeList;
      procedure SendList;
      procedure ReadMail;
      procedure ReadPKT;
      procedure DelePKT;
      procedure PostPKT;
      procedure WriteHead;
      procedure WriteBody(const s: string);
      function NextStep: boolean;                                 override;
      procedure Start({RX}AAcceptFile: TAcceptFile;
                          AFinishRece: TFinishRece;
                      {TX}AGetNextFile: TGetNextFile;
                          AFinishSend: TFinishSend;
                      {CH}AChangeOrder: TChangeOrder
                      ); override;
      function GetPage: integer;
      property Page: integer read GetPage;
   private
      State: THTTPState;
       aOut: TBinkPOutA;
       aRec: TBinkPArray;
       iRec: DWORD;
  TxBlkSize, TxBlkPos,
  TxBlkRead: DWORD;
      fRest: DWORD;
      fHTML: string;
      fRepl,
      fPage,
      fTitl,
      fBody: string;
      fSize: integer;
      fUser,
      fPass: string;
      fCont: THTTPContent;
      fDate: string;
      fLoca: string;
      fMeth: THTTPMethod;
      fBoun: string;
      procedure DoStep;
   end;

implementation

uses Wizard, WSock, Outbound, Plus, Recs, xFido, RadIni, NetMail,
     DateUtils, NdlUtil, Crypt, UStr;

const
   sBody = '<h1>Taurus HTTP Server</h1>' +
           '<table><tr><td align="center">' +
           '<font face="Courier New">' +
           '<br><br>Use your 5d FTN address to log in ..<br><br>' +
           '</font>' +
           'Running mail only - disconnect immediately' +
           '</td></tr></table>';

function CreateHTTPProtocol;
begin
   Result := THTTP.Create(CP);
end;

function THTTP.GetStateStr: string;
begin
  case State of
  bdInit: result := 'Init';
  bdDone: result := 'Done';
  end;
end;

procedure THTTP.ReportTraf(txMail, txFiles: DWORD);
begin
  //nothing, just to avoid warning
end;

procedure THTTP.Cancel;
begin
  // nothing, just to avoid warning
end;

constructor THTTP.Create;
begin
   inherited Create(ACP);
end;

destructor THTTP.Destroy;
begin
   inherited Destroy;
end;

function THTTP.TimeoutValue;
begin
   Result := 1000;
end;

procedure THTTP.WriteProc(const Buf; i: DWORD);
var
  p: PByteArray;
  c: DWORD;
begin
  if i = 0 then Exit;
  p := @Buf;
  for c := 0 to i - 1 do CP.PutChar(p^[c]);
  CP.Flsh;
end;

function THTTP.CanSend: Boolean;
begin
  Result := (CP.OutUsed < T.D.BlkLen + 2048);
end;

procedure THTTP.SendStep;
var
   i: DWORD;
begin
   i := MinD(T.D.BlkLen, T.D.FSize - T.D.FPos);
   SetLastError(0);
   if (T.Stream.Read(aOut, i) <> i) or (GetLastError <> 0) then
   begin
      FFinishSend(Self, aaSysError);
      State := bdDone;
      exit;
   end else
   begin
      TxBlkSize := i;
      TxBlkRead := i;
      TxBlkPos  := 0;
   end;
   if CanSend then
   begin
      NewTimerSecs(Timer, BinkPTimeout);
      WriteProc(aOut[TxBlkPos], i);
      if T.D.BlkLen < MaxSndBlkSz then T.D.BlkLen := T.D.BlkLen shl 1;
      if T.D.BlkLen > MaxSndBlkSz then T.D.BlkLen := MaxSndBlkSz;
      if TxBlkPos + i = TxBlkSize then begin
         Inc(T.D.FPos, TxBlkRead);
      end;
      if T.D.FPos = T.D.FSize then
      begin
         while CP.OutUsed > 0 do Application.ProcessMessages;
         FFinishSend(Self, aaOK);
         State := bdDone;
         exit;
      end else
      begin
         Inc(TxBlkPos, i);
      end;
   end else
   if T.D.BlkLen > 512 then begin
      T.D.BlkLen := T.D.BlkLen shr 1;
   end;
end;

procedure THTTP.DeleFile;
var
   z: TBWZRec;
begin
   fCont := cnDele;
   z := GetBWZ(JustFileNameOnly(n), 0, 0, FiAddr, nil);
   if z <> nil then begin
      if FileExists(z.GetBWZFName) then begin
         if DeleteFile(z.GetBWZFName) then begin
            fRepl := '302 OK';
            FreeBWZ(z);
         end else begin
            fRepl := '500 Cannot delete file';
         end;
      end else begin
         fRepl := '404 object does not exist';
      end;
   end else begin
      CustomInfo := n;
      FLogFile(Self, lfDelete);
      if CustomInfo = '' then fRepl := '302 OK'
                         else fRepl := '500 ' + CustomInfo;
   end;
   fLoca := '/';
end;

procedure THTTP.ReceStep;
var
   c: byte;
begin
   iRec := 0;
   if CP.CharReady then begin
      NewTimerSecs(Timer, BinkPTimeout);
      While CP.CharReady do begin
         CP.GetChar(c);
         aRec[iRec] := Char(c);
         inc(iRec);
         if iRec = SizeOf(aRec) then break;
      end;
   end;
   iRec := MinD(iRec, R.d.FSize - R.d.FPos);
   if (R.Stream.Write(aRec, iRec) <> iRec) or (GetErrorNum <> 0) then
   begin
      State := bdInit;
      fRepl := '500 SysError';
      exit;
   end else begin
      R.d.FPos := R.Stream.Position;
      iRec := 0;
      if R.d.FPos = R.d.FSize then begin
         FFinishRece(Self, aaOK);
         State := bdInit;
         fMeth := mGet;
         fCont := cnPost;
         fRepl := '302 OK';
         fLoca := '/';
      end;
   end;
end;

function THTTP.GetPage;
var
   D: TSystemTime;
begin
   fDate := RFCDateUTC;
   if not (fCont in [cnDele, cnRead, cnPost]) then begin
      if fUser <> '' then fRepl := '200 OK' else
      if fHTML = '/' then fRepl := '401 Access denied'
                     else fRepl := '404 Object not found';
   end else begin
      fCont := cnText;
      if fLoca = '' then begin
         fLoca := '/';
      end;
   end;
   if fCont = cnText then begin
      fPage := '<html><head><title>' + fTitl + '</title></head>'#10 +
               '<body>' +
                fBody +
                '</body></html>';
      fSize := Length(fPage);
   end else
   if fCont = cnBin then begin
      fPage := '';
      if pos ('.BWZ', fHTML) = 0 then begin
         Delete(fHTML, 1, 1);
         SendFTPFile := True;
         CustomInfo := fHTML;
         T.D.BlkLen := StartSndBlkSz;
         FGetNextFile(Self);
         if T.Stream <> nil then begin
            T.d.FPos := fRest;
            T.Stream.Position := fRest;
            if fRest <> 0 then begin
               FLogFile(Self, lfSendSync);
            end;
            if T.Stream <> nil then begin
               fSize := T.Stream.Size;
               uNix2WinTime(T.d.FTime, D);
               fDate := RFCDateStr(D);
            end else begin
               fSize := 0;
            end;
            State := bdSend;
         end else begin
            fRepl := '404 Object not found';
            fSize := 0;
            State := bdDone;
         end;
      end else begin
         fRepl := '404 File cannot be loaded from BWZ';
         fSize := 0;
         State := bdDone;
      end;
   end else
   if fCont = cnList then begin
      fSize := Length(fBody);
      fPage := fBody;
   end;
   Result := fSize;
end;

procedure THTTP.BeginTable;
begin
   if fRepl = '' then begin
      fRepl := '200';
   end;
   fBody := '<h1>Taurus HTTP FTN Server</h1><br>' +
            '<font face="Courier New">' +
            '<table><tr><td>Outgoing traffic for node: </td><td width="30"></td>' +
            '<td><strong>' + fUser + '</strong></td></tr></table><br>' +
            '<table>';
end;

procedure THTTP.FinisTable;
begin
   fBody := fBody + '</table><br><br><strong>Report is generated on: ' + RFCDateUTC + '</strong></font>';
end;

procedure THTTP.MakeList;
var
   i: integer;
   n: integer;
   t: string;
begin
   fCont := cnText;
   FillOutList := True;
   FGetNextFile(Self);
   if pos('delete?', fHTML) = 2 then begin
      fCont := cnDele;
      DeleFile(ExtractWord(2, fHTML, ['?']));
      FillOutList := True;
      FGetNextFile(Self);
   end;
   BeginTable;
   if CollMax(OutFiles) > -1 then begin
      for i := 0 to CollMax(OutFiles) do begin
         n := FileAge(OutPaths[i]);
         if n > -1 then begin
            t := ExtractWord(1, OutFiles[i], [' ']);
            fBody := fBody +
                  '<tr><td><a href=' + t + '><strong>' + t + '</strong></td><td width="30"></td>' +
                  '<td align=right>' + Size2KB(GetFileSize(OutPaths[i])) + '</td><td width="30"></td>' +
                  '<td>' + RFCDateStr(GetFileTime(OutPaths[i])) + '</td><td width="30"></td>' +
                  '<td><a href=delete?' + t + '>delete</td>';
            IF IsNetMailExt(ExtractFileExt(t)) then begin
               fBody := fBody +
                  '<td>&nbsp&nbsp<a href=read?' + t + '>read</td>';
            end;
            fBody := fBody + '</tr>';
         end;
      end;
   end else begin
      fBody := fBody + '<tr><td>Queue is empty</td></tr>';
   end;
   fBody := fBody + '</table><br><br><table>' +
                    '<FORM ENCTYPE="multipart/form-data" METHOD=POST>' +
                    'File to upload: <INPUT NAME="userfile" TYPE="file">' +
                    '&nbsp&nbsp&nbsp' +
                    '<INPUT TYPE="submit" VALUE="Upload">' +
                    '</FORM><br><br>';
   if fPass <> '' then begin
      fBody := fBody +
                    '<FORM METHOD=GET Action=pkt>' +
                    'Post message to sysop:' + '&nbsp&nbsp&nbsp' +
                    '<INPUT TYPE=hidden Name=Reply Value=New>' +
                    '<INPUT TYPE="submit" VALUE="Post">' +
                    '</FORM>';
   end else begin
      fBody := fBody + 'Size of upload for unsecure session is limited to: ' + Size2kb(IniFile.ReadInteger('Main', 'MaxISize', 50 * 1024));
   end;
   FinisTable;
end;

procedure THTTP.SendList;
var
   i: integer;
   n: integer;
   t: string;
begin
   fCont := cnList;
   FillOutList := True;
   FGetNextFile(Self);
   fBody := '';
   if CollMax(OutFiles) > -1 then begin
      for i := 0 to CollMax(OutFiles) do begin
         n := FileAge(OutPaths[i]);
         if n > -1 then begin
            t := ExtractWord(1, OutFiles[i], [' ']);
            fBody := fBody + t + ' ' + IntToStr(GetFileSize(OutPaths[i])) + ' ' + IntToStr(GetFileTime(OutPaths[i])) + #13#10;
         end;
      end;
   end;
   fBody := fBody + #13;
end;

procedure THTTP.ReadMail;
var
   i: integer;
   m: TNetmailMsg;
begin
   fCont := cnRead;
   fRepl := '200 OK';
   fBody := '<h1>Taurus HTTP FTN Server</h1><br>' +
            '<font face="Courier New">' +
            '<table><tr><td>Outgoing traffic for node: </td><td width="30"></td>' +
            '<td><strong>' + fUser + '</strong></td></tr></table><br>' +
            '<table>';
   with NetmailHolder do begin
      ScanMail;
      NetColl.Enter;
      for i := 0 to CollMax(NetColl) do begin
         m := NetColl[i];
         if MatchMaskAddress(m.Addr, Addr2Str(FiAddr)) then begin
            fBody := fBody +
                  '<tr><td><a href=pkt?' + m.MsId + '><strong>' + m.MsId + '</strong></td><td width="30"></td>' +
                  '<td align=right>' + Size2KB(m.Size) + '</td><td width="30"></td>' +
                  '<td>' + m.Head.DateTime + '</td><td width="30"></td>' +
                  '<td><a href=remove?' + m.MsId + '>delete</td>';
            fBody := fBody + '</tr>';
         end;
      end;
      NetColl.Leave;
   end;
   fBody := fBody + '</table><br><br><strong>Report is generated on: ' + RFCDateUTC + '</strong></font>';
end;

procedure THTTP.ReadPKT;
var
   i: integer;
   m: TNetmailMsg;
  cp: string;
begin
   with NetmailHolder do begin
      fCont := cnText;
      m := FindMessage(ExtractWord(2, fHTML, ['?']));
      if m <> nil then begin
         fRepl := '200';
         SendFTPFile := True;
         CustomInfo := m.Pack;
         FGetNextFile(Self);
         if (t.d.FName <> '') and (T.Stream <> nil) then begin
            cp := m.IChr;
            T.Stream.Position := m.bOff;
            T.d.FPos  := 0;
            T.d.FOfs  := 0;
            T.d.FSize := m.Size - m.bOff + m.Offs - m.Addy + SizeOf(m.Head);
            SetLength(fBody, T.d.FSize);
            T.Stream.Read(fBody[1], T.d.FSize);
            FFinishSend(Self, aaOK);
            i := 0;
            while i < Length(fBody) do begin
               inc(i);
               if fBody[i] =  #1 then fBody[i] := '@' else
               if fBody[i] = #13 then begin
                  fBody := copy(fBody, 1, i - 1) + '<br>' + copy(fBody, i + 1, Length(fBody) - i);
               end;
            end;
            fBody :=
              '<META http-equiv=Content-Type content="text/html; charset=' + cp + '">' +
              '<font face="Courier New">' +
               fBody +
              '<br><form method=get>' +
              '<input type=hidden name=Reply Value=' + m.MsId + '><input type=submit value="Reply"></form>' +
              '</font>';
         end;
      end else begin
         fRepl := '404 Object not found';
      end;
   end;
end;

procedure THTTP.DelePKT;
var
   m: TNetmailMsg;
   z: string;
begin
   z := ExtractWord(2, fHTML, ['?']);
   fCont := cnDele;
   with NetmailHolder do begin
      m := FindMessage(z);
      if m <> nil then begin
         DeleteMail(m.MsId);
         fRepl := '302 OK';
         fLoca := '/read?00000001.out';
         CustomInfo := 'Msg: ' + m.MsId + ' deleted';
         FLogFile(Self, lfLog);
         exit;
      end;
   end;
   CustomInfo := 'Error deleting Msg: ' + z;
   FLogFile(Self, lfLog);
   fRepl := '404 object not found';
end;

procedure THTTP.PostPKT;
var
   i: integer;
   m: TNetmailMsg;
  cp: string;
   a: TAdvNode;
nfrom,
ndest,
fsubj: string;
afrom,
adest: TFidoAddress;
begin
   with NetmailHolder do begin
      fCont := cnText;
      cp := ExtractWord(2, fHTML, ['=']);
      m := nil;
      if cp <> 'New' then begin
         NetmailHolder.ScanMail;
         m := FindMessage(ExtractWord(2, fHTML, ['=']));
      end;
      if m <> nil then begin
         fRepl := '200 OK';
         SendFTPFile := True;
         CustomInfo := m.Pack;
         FGetNextFile(Self);
         if (t.d.FName <> '') and (T.Stream <> nil) then begin
            cp := m.IChr;
            T.Stream.Position := m.bOff;
            T.d.FPos  := 0;
            T.d.FOfs  := 0;
            T.d.FSize := m.Size - m.bOff + m.Offs - m.Addy + SizeOf(m.Head);
            SetLength(fBody, T.d.FSize);
            T.Stream.Read(fBody[1], T.d.FSize);
            FFinishSend(Self, aaOK);
            fBody := ' >' + fBody;
            i := 0;
            while i < Length(fBody) do begin
               inc(i);
               if fBody[i] =  #1 then fBody[i] := '@' else
               if fBody[i] = #13 then begin
                  fBody := copy(fBody, 1, i) + ' >' + copy(fBody, i + 1, Length(fBody) - i);
               end;
            end;
            a := FindNode(m.Addr);
            if a <> nil then begin
               m.Tonm := a.Sysop;
               FreeObject(a);
            end;
            fBody :=
              'Hi, ' + ExtractWord(1, m.Frnm, [' ']) + ' !'#13#13 +
              m.Head.DateTime + ' you said me:'#13#13 + fBody + #13#13 +
              'Best regards, '#13 +
              '              ' + ExtractWord(1, m.Tonm, [' ']) + #13#13 +
              '--- Taurus-Web-Service'#13;
            a := FindNode(m.Addr);
            if a <> nil then begin
               m.Tonm := a.Sysop;
               FreeObject(a);
            end;
            fBody :=
              '<META http-equiv=Content-Type content="text/html; charset=' + cp + '">' +
              '<form method=post>' +
              '<input type=hidden name=Post Value=' + m.MsId + '>' +
              '<input type=hidden name=From Value=' + EncodeB64(m.Frnm) + '|' + Addr2Str(m.From) + '>' +
              '<input type=hidden name=Dest Value=' + EncodeB64(m.Tonm) + '|' + Addr2Str(m.Addr) + '>' +
              '<input type=hidden name=Subj Value=' + EncodeB64(m.Subj) + '>' +
              '<textarea rows=24 cols=80 name=Body value="abc">' + fBody + '</textarea>' +
              '<input type=submit value="Post"></form>';
         end;
      end else begin
         fRepl := '200 OK';
         if FiSysop = '' then begin
            nFrom := 'Web poster';
         end else begin
            nFrom := FiSysop;
         end;
         nDest := Station[2];
         aFrom := FiAddr;
         aDest := IniFile.MainAddr;
         fSubj := 'Posted from web';
         fBody :=
            'Hi, ' + ExtractWord(1, Station[2], [' ']) + ' !'#13#13#13 +
            'Best regards, ' + nFrom + #13#13 +
            '--- Taurus-Web-Service'#13;
         fBody :=
            '<META http-equiv=Content-Type content="text/html; charset=cp866">' +
            '<form method=post>' +
            '<input type=hidden name=Post Value=New>' +
            '<input type=hidden name=From Value=' + EncodeB64(nDest) + '|' + Addr2Str(aDest) + '>' +
            '<input type=hidden name=Dest Value=' + EncodeB64(nFrom) + '|' + Addr2Str(aFrom) + '>' +
            '<input type=hidden name=Subj Value=' + EncodeB64(fSubj) + '>' +
            '<textarea rows=24 cols=80 name=Body value="abc">' + fBody + '</textarea>' +
            '<input type=submit value="Post"></form>';
      end;
   end;
end;

procedure THTTP.WriteHead;
var
   h: PktHeaderRec;
   m: PackedMsgHeaderRec;
   z: string;
begin
   fillchar(h, sizeof(h), 0);
   h.OrigNode  := inifile.MainAddr.Node;
   h.DestNode  := inifile.MainAddr.Node;
   h.Year      := CurrentYear;
   h.Month     := MonthOf(Date);
   h.Day       := DayOf(Date);
   h.Hour      := HourOf(Time);
   h.Minute    := MinuteOf(Time);
   h.Second    := SecondOf(Time);
   h.Baud      := 300;
   h.PktType   := 2;
   h.OrigNet   := inifile.MainAddr.Net;
   h.DestNet   := inifile.MainAddr.Net;
   h.ProdCode  := $FF;
   h.SerialNo  := $FF;
   h.OrigZone  := inifile.MainAddr.Zone;
   h.DestZone  := inifile.MainAddr.Zone;
   h.OrigPoint := inifile.MainAddr.Point;
   h.DestPoint := inifile.MainAddr.Point;
   m.MsgType   := 2;
   m.OrigNode  := aDest.Node;
   m.DestNode  := aFrom.Node;
   m.OrigNet   := aDest.Net;
   m.DestNet   := aFrom.Net;
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
         z := Trim(nFrom) + #0;
         R.Stream.Write(z[1], Length(z));
         z := Trim(nDest) + #0;
         R.Stream.Write(z[1], Length(z));
         z := Trim(nSubj) + #0;
         R.Stream.Write(z[1], Length(z));
         z := #1'INTL ' + ExtractWord(1, Addr2Str(aFrom), ['@']) + ' ' + ExtractWord(1, Addr2Str(aDest), ['@']) + #13;
         R.Stream.Write(z[1], Length(z));
         z := #1'MSGID: ' + Addr2Str(aDest) + ' ' + JustName(R.d.FName) + #13;
         R.Stream.Write(z[1], Length(z));
         State := bdBody;
      end;
   aaRefuse :
      begin
         fRepl := '400';
         State := bdInit;
      end;
   aaAcceptLater :
      begin
         fRepl := '400';
         State := bdInit;
      end;
   aaAbort :
      begin
         fRepl := '400';
         State := bdInit;
      end;
   end;
end;

procedure THTTP.WriteBody;
var
   e: string;
   i: integer;
begin
   e := s;
   for i := 1 to Length(e) do begin
      if e[i] = '+' then e[i] := ' ';
   end;
   R.Stream.Write(e[1], Length(s));
   R.d.FPos := R.Stream.Position;
   if fSize = 0 then begin
      e := #13#1'Via ' + ExtractWord(1, Station[1], [' ']) + ' R-GATE/Taurus ' + RFCDateUTC + #13;
      R.Stream.Write(e[1], Length(e));
      e := #0#0#0;
      R.Stream.Write(e[1], 3);
      R.d.FPos := R.Stream.Position;
      if R.d.FSize < R.d.FPos then begin
         R.d.FSize := R.d.FPos;
      end;
      FFinishRece(Self, aaOK);
      State := bdInit;
      fMeth := mGet;
      fCont := cnPost;
      fRepl := '302 OK';
      if fLoca = '' then begin
         fLoca := '/read?00000000.out';
      end;
   end;
end;

procedure THTTP.DoStep;
var
   S,
   Z: string;
   A: string;
   i: integer;
begin
   case State of
   bdInit:
      begin
         fStam := IntToStr(GetCurrentThreadId) + '.' + IntToStr(GetTickCount);
         fStam := '<' + fStam + '@' + ProductName + '>';
      end;
   end;
   if State <> bdRece then begin
      CheckInput;
   end;
   while LList.Count > 0 do begin
      NewTimerSecs(Timer, BinkPTimeout);
      s := LList[0];
      a := s;
      LList.AtFree(0);
      if s = '' then begin
         if (fMeth = mPost) and (State <> bdPost) then begin
            State := bdPost;
            continue;
         end;
      end;
      if IniFile.FTPDebug then begin
         DbgLog('< ' + s);
      end;
      GetWrd(s, z, ' ');
      z := UpperCase(z);
      if z = 'GET' then begin
         fMeth := mGet;
         fHTML := ExtractWord(1, s, [' ']);
         replace('+', ' ', fHTML);
         UnpackRFC1945(fHTML);
         fUser := '';
         fPass := '';
         DbgLog('GET ' + fHTML);
      end else
      if z = 'PUT' then begin
         fMeth := mPost;
         fHTML := ExtractWord(1, s, [' ']);
         replace('+', ' ', fHTML);
         UnpackRFC1945(fHTML);
         fUser := '';
         fPass := '';
         DbgLog('PUT ' + fHTML);
      end else
      if z = 'POST' then begin
         fMeth := mPost;
         fHTML := ExtractWord(1, s, [' ']);
         replace('+', ' ', fHTML);
         UnpackRFC1945(fHTML);
         fUser := '';
         fPass := '';
         DbgLog('POST ' + fHTML);
      end else
      if z = 'AUTHORIZATION:' then begin
         GetWrd(s, z, ' ');
         z := UpperCase(z);
         if z = 'BASIC' then begin
            GetWrd(s, z, ' ');
            A := DecodeB64(z);
            GetWrd(a, fUser, ':');
            GetWrd(a, s, ':');
            fUser := fUser + ':' + s;
            GetWrd(a, fPass, ':');
            CustomInfo := fUser;
            FLogFile(Self, lfBinkPAddr);
            if CustomInfo = '' then begin
               CustomInfo := '- ' + fPass;
               FLogFile(Self, lfBinkPPwd);
               if CustomInfo = '' then begin
                  ParseAddress(fUser, FiAddr);
                  fUser := Addr2Str(FiAddr);
                  CustomInfo := #1;
                  FLogFile(Self, lfNodePassw);
                  fPass := FiPassword;
                  if (fHTML = '/') or (pos('/delete?', fHTML) = 1) then begin
                     if fMeth = mGet then begin
                        MakeList;
                     end else begin
                        State := bdFile;
                     end;
                  end else
                  if (pos('/LIST?', UpperCase(fHTML)) = 1) then begin
                     SendList;
                  end else
                  if (pos('/read?', fHTML) = 1) then begin
                     ReadMail;
                  end else
                  if (pos('/pkt?Reply=', fHTML) = 1) then begin
                     PostPKT;
                  end else
                  if (pos('/pkt?', fHTML) = 1) then begin
                     ReadPKT;
                  end else
                  if (pos('/remove?', fHTML) = 1) then begin
                     DelePKT;
                  end else begin
                     fCont := cnBin;
                     fBody := '';
                  end;
               end else begin
                  fUser := '';
                  State := bdDone;
               end
            end else begin
               fUser := '';
               State := bdDone;
            end;
         end;
      end else
      case State of
      bdPost:
         begin
            fSize := fSize - length(a) - 2;
            if z = 'CONTENT-DISPOSITION:' then begin
               R.d.FName := JustFileName(ExtractWord(1, ExtractParam('filename', s, R.d.FName), ['"']));
               R.d.FTime := uGetSystemTime;
            end else
            if z = 'CONTENT-TYPE:' then begin
            end else
            if (R.d.FName <> '') and (R.d.FTime <> 0) then begin
               R.d.FSize := fSize;
               if (fSize < IniFile.ReadInteger('Main', 'MaxISize', 50 * 1024)) or
                  (fPass <> '') then begin
                  case FAcceptFile(Self) of
                  aaOK :
                     begin
                        State := bdRece;
                        fSize := fSize - Length(fBoun) - 8;
                        R.d.FSize := fSize;
                        Break;
                     end;
                  else
                     begin
                        State := bdDone;
                        fMeth := mGet;
                        fCont := cnPost;
                        fRepl := '400 File is refused';
                     end;
                  end;
               end else begin
                  State := bdDone;
                  fMeth := mGet;
                  fCont := cnPost;
                  fRepl := '400 File is too large';
               end;
            end;
         end;
      bdFile:
         begin
            if z = 'CONTENT-DISPOSITION:' then begin
            end else
            if z = 'CONTENT-TYPE:' then begin
            end;
         end;
      else
         case fMeth of
         mGet:;
         mPost:
            begin
               if z = 'CONTENT-LENGTH:' then begin
                  fSize := StrToIntDef(s, 0);
               end else
               if z = 'CONTENT-TYPE:' then begin
                  fBoun := ExtractParam('boundary', s, fBoun);
               end;
            end;
         end;
      end;
   end;
   if (fHTML <> '') and (fMeth = mGet) then begin
      GetPage;
      PutString('HTTP/1.1 ' + fRepl);
      PutString('Server: ' + ProductName + '/' + ProductVersion + '/' + ProductPlatform);
      PutString('WWW-Authenticate: Basic realm="Outbound"');
      PutString('Connection: close');
      PutString('Expires: ' + RFCDateUTC);
      PutString('Date: ' + RFCDateUTC);
      if fLoca <> '' then begin
         PutString('Location: ' + fLoca);
         fLoca := '';
      end;
      PutString('Last-Modified: ' + fDate);
      if fCont = cnText then begin
         PutString('Content-Type: text/html');
         State := bdDone;
      end else
      if fCont = cnBin then begin
         PutString('Content-Type: binary');
         if fSize > 0 then begin
            State := bdSend;
         end else begin
            State := bdDone;
         end;
      end else
      if fCont = cnList then begin
         PutString('Content-Type: text');
         fCont := cnText;
         State := bdDone;
      end;
      PutString('Content-Length: ' + IntToStr(fSize));
      PutString;
      if fCont = cnText then PutString(fPage);
      fHTML := '';
   end;
   if fMeth = mPost then begin
      if tBuff <> '' then begin
         fSize := fSize - Length(tBuff);
         s := tBuff;
         tBuff := '';
         replace('+', ' ', s);
         UnpackRFC1945(s);
         case State of
         bdPost:
            begin
               for i := 1 to 5 do begin
                  GetWrd(s, z, '&');
                  GetWrd(z, a, '=');
                  if a = 'Post' then begin
                     if z = 'New' then fLoca := '/';
                  end else
                  if a = 'From' then begin
                     GetWrd(z, a, '|');
                     nFrom := DecodeB64(a);
                     ParseAddress(z, aFrom);
                  end else
                  if a = 'Dest' then begin
                     GetWrd(z, a, '|');
                     nDest := DecodeB64(a);
                     ParseAddress(z, aDest);
                  end else
                  if a = 'Subj' then begin
                     nSubj := DecodeB64(z);
                  end else
                  if a = 'Body' then begin
                  end;
               end;
               WriteHead;
               WriteBody(z);
            end;
         bdBody:
            begin
               WriteBody(s);
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
   bdSend: FFinishSend(Self, aaAbort);
      end;
      State := bdDone;
   end;
   case State of
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

function THTTP.NextStep: boolean;
begin
   DoStep;
   Result := (State <> bdDone) and (CP.Carrier = CP.DCD);
end;

procedure THTTP.Start;
begin
   fTitl := 'Taurus HTTP Server';
   fBody := sBody;
   inherited Start(AAcceptFile, AFinishRece, AGetNextFile, AFinishSend, AChangeOrder);
   NewTimerSecs(Timer, BinkPTimeout);
end;

end.
