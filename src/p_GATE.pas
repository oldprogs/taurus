unit p_GATE;

interface

uses p_POP3, xBase, xMisc;

function CreateGATEProtocol(CP: Pointer): Pointer;

type

   TGATE = class(TPOP3)
      procedure SendStat; override;
      function  SendList(const n: integer): string; override;
      function  SendUIDL(const n: integer): string; override;
      procedure SendTop(const n: integer); override;
      procedure StartRETR(const n: integer); override;
      procedure SendFile; override;
      procedure FinisSend(const s: string = '');  override;
      procedure ExecDele(const n: integer); override;
   end;

implementation

uses Netmail, xFido, SysUtils, Wizard, Forms;

function CreateGATEProtocol;
begin
   Result := TGATE.Create(CP);
end;

procedure TGATE.SendStat;
var
   i: integer;
   c,
   s: int64;
   m: TNetmailMsg;
begin
   if NetmailHolder = nil then begin
      NetmailHolder := TNetmail.Create;
   end;
   with NetmailHolder do begin
      ScanMail;
      NetColl.Enter;
      c := 0;
      s := 0;
      for i := 0 to CollMax(NetColl) do begin
         m := NetColl[i];
         if MatchMaskAddress(m.Addr, Addr2Str(FiAddr)) then begin
            inc(c);
            s := s + m.Size - m.bOff + m.Offs - m.Addy + SizeOf(m.Head);
         end;
      end;
      NetColl.Leave;
      PutString('+OK ' + IntToStr(c) + ' ' + IntToStr(s));
   end;
end;

function TGATE.SendList;
var
   i: integer;
   c: integer;
   m: TNetmailMsg;
begin
   with NetmailHolder do begin
      ScanMail;
      NetColl.Enter;
      c := 1;
      for i := 0 to CollMax(NetColl) do begin
         m := NetColl[i];
         if MatchMaskAddress(m.Addr, Addr2Str(FiAddr)) then begin
            while FList.Count < c + 1 do FList.Add('');
            FList[c] := m.MsId;
            if (n = -1) or (n = c) then begin
               PutString(IntToStr(c) + ' ' + IntToStr(m.Size - m.bOff + m.Offs - m.Addy + SizeOf(m.Head)));
            end;
            inc(c);
         end;
      end;
      NetColl.Leave;
   end;
end;

function TGATE.SendUIDL;
var
   i: integer;
   c: integer;
   m: TNetmailMsg;
begin
   with NetmailHolder do begin
      ScanMail;
      NetColl.Enter;
      c := 1;
      for i := 0 to CollMax(NetColl) do begin
         m := NetColl[i];
         if MatchMaskAddress(m.Addr, Addr2Str(FiAddr)) then begin
            while FList.Count < c + 1 do FList.Add('');
            FList[c] := m.MsId;
            if (n = -1) or (n = c) then begin
               PutString(IntToStr(c) + ' ' + m.MsId);
            end;
            inc(c);
         end;
      end;
      NetColl.Leave;
   end;
end;

procedure TGATE.SendTop;
var
   m: TNetmailMsg;
begin
   with NetmailHolder do begin
      try
      ScanMail;
      NetColl.Enter;
      if (n > 0) and (n <= FList.Count) then begin
         m := FindMessage(FList[n]);
         if m <> nil then begin
            PutString('+OK');
            PutString('From: ' + m.Frnm + '<' + Addr2Str(m.From) + '>');
            PutString('To: '   + m.Tonm + '<' + Addr2Str(m.Addr) + '>');
            PutString('Subject: ' + m.Subj);
            PutString('Date: ' + m.Date);
            PutString('Message-ID: ' + m.MsId);
            PutString('X-Mailer: ' + ProductName + '/' + ProductVersion);
            PutString('Content-Type: text/plain; charset=' + m.IChr);
            PutString('Content-Transfer-Encoding: 8bit');
            PutString('.');
            exit;
         end;
      end;
      finally
      NetColl.Leave;
      end;
   end;
   PutString('-ERR Msg not found');
end;

procedure TGATE.StartRETR;
var
   m: TNetmailMsg;
begin
   with NetmailHolder do begin
      try
      ScanMail;
      NetColl.Enter;
      if (n > 0) and (n <= FList.Count) then begin
         m := FindMessage(FList[n]);
         if m <> nil then begin
            SendFTPFile := True;
            CustomInfo := m.Pack;
            fName := m.Pack;
            FGetNextFile(Self);
            if (t.d.FName <> '') and (T.Stream <> nil) then begin
               PutString('+OK');
               PutString('From: ' + m.Frnm + ' <' + Addr2Str(m.From) + '>');
               PutString('To: '   + m.Tonm + ' <' + Addr2Str(m.Addr) + '>');
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
               if m.Fido then begin
                  T.d.FSize := T.d.FSize + SizeOf(m.Head);
               end;
               State := bdSend;
               exit;
            end;
         end;
      end;
      finally
      NetColl.Leave;
      end;
   end;
   PutString('-ERR Msg not found');
end;

procedure TGATE.SendFile;
begin
   TInetProtocol(Self).SendFile;
end;

procedure TGATE.FinisSend;
begin
   State := bdIdle;
end;

procedure TGATE.ExecDele;
var
   m: TNetmailMsg;
begin
   with NetmailHolder do begin
      if (n > 0) and (n <= FList.Count) then begin
         m := FindMessage(FList[n]);
         if m <> nil then begin
            DeleteMail(m.MsId);
            PutString('+OK');
            CustomInfo := 'Msg: ' + IntToStr(n) + ', ' + m.MsId + ' deleted';
            FLogFile(Self, lfLog);
            exit;
         end;
      end;
   end;
   CustomInfo := 'Error deleting Msg: ' + IntToStr(n);
   FLogFile(Self, lfLog);
   PutString('-ERR Msg not found');
end;

end.
