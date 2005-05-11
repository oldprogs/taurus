unit Netmail;

interface

uses Windows, xBase, xFido, MClasses, Classes, MlrThr;

{$I ftsc.inc}

type

   TNetmailMsg = class
      Addr: TFidoAddress;
      From: TFidoAddress;
      Lock: TFidoAddress;
      Tonm: string;
      Frnm: string;
      Subj: string;
      Pack: string;
      MsId: string;
      Chrs: string;
      Echo: string;
      Offs: int64;
      bOff: int64;
      HRec: PktHeaderRec;
      Head: PackedMsgHeaderRec;
      Size: int64;
      hLen: integer;
      Line: integer;
      Addy: integer;
      Numb: dword;
      Body: Pointer;
      Dele: boolean;
      Fido: boolean;
      Attr: system.word;
      Flgs: string;
      Klug: TStringColl;
      Text: boolean;
      function IChr: string;
      function Date: string;
      destructor Destroy; override;
      procedure Put(s: TStream);
      procedure Get(s: TStream);
   end;

   TNetmailPkt = class
      Pack: string;
      Mark: cardinal;
   end;

   TGroup = record
      base,
      numb: dword;
   end;
   PGroup =^TGroup;

   TPktColl = class(TColl)
      function  FindName(const n: string): integer;
      procedure DeleName(const n: string);
      function  GetAnItem(i: integer): TNetmailPkt;
      procedure SetItem(i: integer; p: TNetmailPkt);
      property  Items[i: integer]: TNetmailPkt read GetAnItem write SetItem; default;
   end;

   TNetColl = class(TColl)
   protected
      procedure MarkDel(Fido: boolean);
      procedure Unmark(n: string);
      function  GetNMsg(i: integer): TNetmailMSG;
   public
      property  Items[i: integer]: TNetmailMsg read GetNMsg; default;
   end;

   TLogProcedure = procedure(Tag: TLogTag; const Str: string) of object;

   TNetmail = class
   private
      PktColl: TPktColl;
      MsgColl: TstringColl;
      procedure FreePack(p: TNetmailPkt);
      procedure Scan(const path: string);
      procedure MoveMail(n: TNetmailMsg; const t: TFidoAddress; const a: string; Active: boolean);
      procedure PackMail(const a: TFidoAddress; const r, e, p: string; Active: boolean);
      procedure DelMail(n: TNetmailMsg);
   protected
      fBackup: Boolean;
   public
      Echomail: boolean;
      NetColl: TNetColl;
      LstColl: TStringList;
      FilColl: TStringList;
      NeedScan: boolean;
      MaxMSG: integer;
      constructor Create; virtual;
      destructor Destroy; override;
      procedure ScanMSG;
      procedure ScanMail;
      procedure FillMSG(const n: TStream; var l: TNetmailMsg);
      procedure ScanMesage(const pack: string);
      procedure ScanPacket(const pack: string);
      procedure Route(const a: TFidoAddress; w: string; Active: boolean; Log: TLogProcedure);
      procedure DeleteMail(const Id: string);
      function FindMessage(const Id: string): TNetmailMsg;
   end;

   TMemStream = class(TMemoryStream)
      procedure LoadFromFile(const n: string); reintroduce;
   end;

   TNetStream = class(TFileStream)
      constructor Create(const n: string; m: DWORD);
   end;

   TNetLogger = class
      LogColl: TStringColl;
      MLogger: TMailerThreadLogger;
   public
      constructor Create;
      destructor Destroy; override;
      procedure Log(const s: string);
      procedure LogMSG(m: TNetmailMSG; n: integer; p: string);
   end;

procedure FreeNetmailHolder;
function  ClearAttach(d: TFidoAddress; m, a: string): string;
function  ChangAttach(m, a: string): boolean;
procedure UnpackPKT(p: string; l: TMailerThreadLogger);
procedure FinalizePKT(a: TFidoAddress; p: string);
procedure NewMessage(a: TFidoAddress; o, u: string);
procedure WriteLine(n: string);
procedure EndMessage;
procedure MergeMail(const a: TFidoAddress; const n, o: string);

var
   NetmailHolder: TNetmail;
   EchomailHolder: TColl;
   NetmailLog: string;
   NetmailLogger: TNetLogger = nil;

implementation

uses
   RadIni, RRegExp, SysUtils, Wizard, Outbound, DateUtils,
   Forms, Watcher, JclDateTime, RadSav, Recs, Plus, UStr;

procedure FreeNetmailHolder;
begin
   FreeObject(NetmailHolder);
   FreeObject(NetmailLogger);
end;

function ClearAttach;
var
   e: TNetmail;
   g: TNetmailMSG;
   i: integer;
   r: PktHeaderRec;
   p: PackedMsgHeaderRec;
   n: TMemStream;
   h: _fidomsgtype;
   s: string;
   z: string;
   t: string;
   b: boolean;
begin
   Result := '';
   if not ExistFile(m) then exit;
   e := TNetmail.Create;
   e.ScanMesage(m);
   for i := 0 to CollMax(e.NetColl) do begin
      g := e.NetColl[i];
      if CompareAddrs(d, g.Addr) <> 0 then begin
         fillchar(r, sizeof(r), 0);
         fillchar(p, sizeof(p), 0);
         r.OrigNode  := inifile.MainAddr.Node;
         r.DestNode  := d.Node;
         r.Year      := CurrentYear;
         r.Month     := MonthOf(Date);
         r.Day       := DayOf(Date);
         r.Hour      := HourOf(Time);
         r.Minute    := MinuteOf(Time);
         r.Second    := SecondOf(Time);
         r.Baud      := 300;
         r.PktType   := 2;
         r.OrigNet   := inifile.MainAddr.Net;
         r.DestNet   := d.Net;
         r.ProdCode  := $FF;
         r.SerialNo  := $15;
         r.OrigZone  := inifile.MainAddr.Zone;
         r.DestZone  := d.Zone;
         r.OrigPoint := inifile.MainAddr.Point;
         r.DestPoint := d.Point;
         p.MsgType   := 2;
         p.OrigNode  := g.From.Node;
         p.DestNode  := g.Addr.Node;
         p.OrigNet   := g.From.Net;
         p.DestNet   := g.Addr.Net;
         p.Attribute := g.Attr;
         p.Cost      := 0;
         z := FormatDateTime('dd mmm yy  hh:nn:ss', Date + Time);
         move(z[1], p.DateTime, Length(z));
         s := AddBackSlash(IniFile.Outbound) + Format('%.8x.PKT', [GetTickCount xor xRandom32]);
         Result := s;
         n := TMemStream.Create;
         n.Write(r, SizeOf(r));
         n.Write(p, SizeOf(p));
         z := g.ToNm + #0;
         n.Write(z[1], Length(z));
         z := g.FrNm + #0;
         n.Write(z[1], Length(z));
         z := JustFileName(a) + #0;
         n.Write(z[1], Length(z));
         n.Write(Pointer(Integer(g.Body) + g.hLen)^, g.Size - g.hLen);
         z := #0#0;
         n.Write(z[1], Length(z));
         n.SaveToFile(s);
         n.Free;
      end;
   end;
   FreeObject(e);
   n := TMemStream.Create;
   if n <> nil then begin
      try
         n.LoadFromFile(m);
      except
         n.Free;
         exit;
      end;
      n.Read(h, sizeof(h));
      if h.attr and Fileattached = 0 then begin
         n.Free;
         exit;
      end;
      s := h.subject;
      t := '';
      b := False;
      while s <> '' do begin
         GetWrd(s, z, ' ');
         if z = a then begin
            b := True;
         end else begin
            if ExistFile(z) then begin
               t := t + z + ' ';
            end else begin
               b := True;
            end;
         end;
      end;
      if b then begin
         if t <> '' then begin
            FillChar(h.subject, SizeOf(h.subject), #0);
            move(t[1], h.subject, Length(t));
         end else begin
            if Result <> '' then begin
               Result := Result + ' ' + m;
            end else begin
               if h.attr and KillSent > 0 then begin
                  DelFile('ClearAttach', m);
                  n.Free;
                  Exit;
               end else begin
                  h.attr := h.attr or Sent_;
               end;
            end;
         end;
         n.Position := 0;
         n.Write(h, SizeOf(h));
         n.SaveToFile(m);
      end;
      n.Free;
   end;
end;

function ChangAttach;
var
   n: TMemStream;
   h: _fidomsgtype;
   z: string;
   t: string;
   s: string;
   b: boolean;
begin
   Result := False;
   if not ExistFile(m) then exit;
   n := TMemStream.Create;
   if n <> nil then begin
      try
         n.LoadFromFile(m);
      except
         n.Free;
         exit;
      end;
      n.Read(h, sizeof(h));
      if h.attr and Fileattached = 0 then begin
         n.Free;
         exit;
      end;
      s := h.subject;
      t := '';
      b := False;
      while s <> '' do begin
         GetWrd(s, z, ' ');
         if Pos(JustFileName(UpperCase(z)), UpperCase(a)) <> 0 then begin
            b := True;
            t := t + a + ' ';
         end else begin
            if ExistFile(z) then begin
               t := t + z + ' ';
            end else begin
               b := True;
            end;
         end;
      end;
      if b then begin
         if t <> '' then begin
            FillChar(h.subject, SizeOf(h.subject), #0);
            move(t[1], h.subject, Length(t));
         end;
         n.Position := 0;
         n.Write(h, SizeOf(h));
         n.SaveToFile(m);
         Result := True;
      end;
      n.Free;
   end;
end;

var
   s: TFileStream;

procedure NewMessage;
var
   h: _fidomsgtype;
   t: string;
   x: integer;
   d: TDualColl;
   p: string;
begin
   x := 0;
   if NetmailHolder <> nil then begin
      NetmailHolder.NetColl.Enter;
      x := NetmailHolder.MaxMSG;
      NetmailHolder.NetColl.Leave;
   end;
   FillChar(h, SizeOf(h), #0);
   t := 'Taurus ' + CProductVersionA + '/W32';
   move(t[1], h.from, Length(t));
   move(o[1], h.towhom, Length(o));
   move(u[1], h.subject, Length(u));
   t := FormatDateTime('dd mmm yy  hh:nn:ss', Date + Time);
   move(t[1], h.azdate, Length(t));
   h.dest_node := a.Node;
   h.orig_node := IniFile.MainAddr.Node;
   h.orig_net  := IniFile.MainAddr.Net;
   h.dest_net  := a.Net;
   h.attr := Pvt or Local or KillSent;
   d := IniFile.GetStrings('gNetPath');
   p := '';
   if CollMax(d) > -1 then begin
      p := TDualRec(d[0]^).St1^;
   end;
   repeat
      inc(x);
      t := AddBackSlash(p) + IntToStr(x) + '.MSG';
   until not ExistFile(t);
   s := TFileStream.Create(t, fmCreate or fmShareExclusive);
   s.Write(h, SizeOf(h));
   t := #1'MSGID: ' + Addr2Str(IniFile.MainAddr) + ' ' + Format('%.8x', [GetTickCount xor xRandom32]) + #13;
   s.Write(t[1], Length(t));
   t := #1'INTL ' +
          ExtractWord(1, ExtractWord(1, Addr2Str(a), ['@']), ['.']) + ' ' +
          ExtractWord(1, ExtractWord(1, Addr2Str(IniFile.MainAddr), ['@']), ['.']) + #13;
   s.Write(t[1], Length(t));
   if a.Point <> 0 then begin
      t := #1'TOPT ' + IntToStr(a.Point) + #13;
      s.Write(t[1], Length(t));
   end;
   if IniFile.MainAddr.Point <> 0 then begin
      t := #1'FMPT ' + IntToStr(IniFile.MainAddr.Point) + #13;
      s.Write(t[1], Length(t));
   end;
end;

procedure WriteLine;
begin
   s.Write(n[1], Length(n));
end;

procedure EndMessage;
begin
   WriteLine(#13'--- Taurus ' + CProductVersionA + '/W32'#13);
   s.Free;
end;

procedure UnpackPKT;
var
   n: TNetmail;
   i: integer;
   j: integer;
   m: TNetmailMSG;
   h: _fidomsgtype;
   s: TFileStream;
   x: Integer;
   t: string;
   o: integer;
   d: TDualColl;
   z: string;
begin
   x := 0;
   if NetmailHolder <> nil then begin
      NetmailHolder.NetColl.Enter;
      x := NetmailHolder.MaxMSG;
      NetmailHolder.NetColl.Leave;
   end;
   n := TNetmail.Create;
   n.ScanPacket(p);
   for i := 0 to CollMax(n.NetColl) do begin
      m := n.NetColl[i];
      if m.Echo <> '' then begin
         FreeObject(n);
         exit;
      end;
      if i > 0 then begin
         m.HRec.PktType := 0;
      end;
      FillChar(h, SizeOf(h), #0);
      move(m.Frnm[1], h.from, Length(m.Frnm));
      move(m.Tonm[1], h.towhom, Length(m.Tonm));
      if m.Attr and FileAttached <> 0 then begin
         m.Subj := JustPathName(p) + '\' + m.Subj;
      end;
      move(m.Subj[1], h.subject, Length(m.Subj));
      move(m.Date[1], h.azdate, Length(m.Date));
      h.dest_node := m.Addr.Node;
      h.orig_node := m.From.Node;
      h.orig_net  := m.From.Net;
      h.dest_net  := m.Addr.Net;
      h.date_arrived := DateTimeToDosDateTime(Date + Time);
      h.date_arrived := (h.date_arrived and $FFFF0000) shr 16 + (h.date_arrived and $0000FFFF) shl 16;
      h.attr := h.attr and (not Local);
      if not AddrColl.Search(@m.Addr, j) then begin
         h.attr := m.Attr or KillSent or InTransit;
      end else begin
         h.attr := m.Attr and (not InTransit);
      end;
      d := IniFile.GetStrings('gNetPath');
      z := '';
      if CollMax(d) > -1 then begin
         z := TDualRec(d[0]^).St1^;
      end;
      repeat
         inc(x);
         t := AddBackSlash(z) + IntToStr(x) + '.MSG';
      until not ExistFile(t);
      s := TFileStream.Create(t, fmCreate or fmShareExclusive);
      s.Write(h, SizeOf(h));
      o := m.bOff - m.Offs - SizeOf(PackedMsgHeaderRec);
      s.Write(Pointer(Integer(m.Body) + o)^, m.Size - o - 1);
      s.Free;
      NetmailLogger.MLogger := L;
      NetmailLogger.LogMSG(m, x, '+');
      NetmailLogger.MLogger := nil;
      if (m.Attr and AuditRequest > 0) or
        ((m.Attr and ReturnReceiptRequest > 0) and (AddrColl.Search(@m.Addr, o))) then
      begin
         NewMessage(m.From, m.Frnm, 'Transit confirmation');
         WriteLine(
              #13' Your message to: ' + Addr2Str(m.Addr) + ' (' + m.Tonm + ')'#13 +
                 '            from: ' + m.Date + #13 +
                 '         subject: ' + m.Subj + #13 +
              #13' was received at: ' + Addr2Str(IniFile.MainAddr) + #13 +
                 '              on: ' + FormatDateTime('dd mmm yy  hh:nn:ss', Date + Time) + #13#13 +
              #13'   Message route:'#13#13
                  );
         for o := 0 to CollMax(m.Klug) do begin
            t := m.Klug[o];
            if copy(t, 2, 4) = 'Via ' then begin
               t[1] := '@';
               WriteLine(t);
            end;
         end;
         WriteLine(#13);
         EndMessage;
      end;
   end;
   FreeObject(n);
   DelFile('UnpackPKT', p);
end;

procedure FinalizePKT;
var
   n: TNetmail;
   i: integer;
   m: TNetmailMSG;
   t: string;
   o: integer;
begin
   n := TNetmail.Create;
   n.ScanPacket(p);
   for i := 0 to CollMax(n.NetColl) do begin
      m := n.NetColl[i];
      if m.Echo <> '' then begin
         FreeObject(n);
         exit;
      end;
      if i = 0 then begin
         NetmailLogger.Log('');
      end;
      m.HRec.PktType := 0;
      NetmailLogger.LogMSG(m, 0, '-');
      if (m.Attr and AuditRequest > 0) then begin
         NewMessage(m.From, m.Frnm, 'Transit confirmation');
         WriteLine(
              #13' Your message to: ' + Addr2Str(m.Addr) + ' (' + m.Tonm + ')'#13 +
                 '            from: ' + m.Date + #13 +
                 '         subject: ' + m.Subj + #13 +
              #13'  was routed via: ' + Addr2Str(a) + #13 +
                 '              on: ' + FormatDateTime('dd mmm yy  hh:nn:ss', Date + Time) + #13#13 +
              #13'   Message route:'#13#13
                  );
         for o := 0 to CollMax(m.Klug) do begin
            t := m.Klug[o];
            if copy(t, 2, 4) = 'Via ' then begin
               t[1] := '@';
               WriteLine(t);
            end;
         end;
         WriteLine(#13);
         EndMessage;
      end;
   end;
   FreeObject(n);
end;

function TNetmailMsg.IChr;
begin
   if Chrs = '' then begin
      Result := 'ibm866';
   end else
   if Chrs = 'CP866 2' then begin
      Result := 'ibm866';
   end else
   if Chrs = 'ALT 2' then begin
      Result := 'ibm866';
   end else
   if Chrs = 'CP1125 2' then begin
      Result := 'ibm866';
   end else
   if pos('CP', UpperCase(Chrs)) = 1 then begin
      Result := ExtractWord(1, Chrs, [' ']);
   end else
   if Chrs = 'UKR 2' then begin
      Result := 'ibm866';
   end else
   if Chrs = 'IBMPC 2' then begin
      Result := 'ibm866';
   end else
   if Chrs = '+7 FIDO 2' then begin
      Result := 'ibm866';
   end else
   if Chrs = '+7_FIDO 2' then begin
      Result := 'ibm866';
   end else begin
      Result := 'ibm866';
   end;
end;

function TNetmailMSG.Date;
begin
   Result := copy(Head.DateTime, 1, 19);
end;

destructor TNetmailMsg.Destroy;
begin
   if Body <> nil then begin
      FreeMem(Body, Size);
   end;
   FreeObject(Klug);
   inherited;
end;

procedure TNetmailMSG.Put;
   procedure WriteStr(t: string);
   var
      b: byte;
   begin
      b := Length(t);
      s.Write(b, 1);
      s.Write(t[1], b);
   end;
begin
   s.Write(Addr, SizeOf(Addr));
   s.Write(From, SizeOf(Addr));
   WriteStr(Tonm);
   WriteStr(Frnm);
   WriteStr(Subj);
   WriteStr(Pack);
   WriteStr(MsId);
   WriteStr(Chrs);
   WriteStr(Echo);
   s.Write(Offs, SizeOf(Offs));
   s.Write(bOff, SizeOf(bOff));
   s.Write(Head, SizeOf(Head));
   s.Write(Size, SizeOf(Size));
   s.Write(Addy, SizeOf(Addy));
   s.Write(Line, SizeOf(Line));
   s.Write(Numb, SizeOf(Numb));
end;

procedure TNetmailMSG.Get;
   function ReadStr: string;
   var
      b: byte;
   begin
      s.Read(b, 1);
      SetLength(Result, b);
      s.Read(Result[1], b);
   end;
begin
   s.Read(Addr, SizeOf(Addr));
   s.Read(From, SizeOf(From));
   Tonm := ReadStr;
   Frnm := ReadStr;
   Subj := ReadStr;
   Pack := ReadStr;
   MsId := ReadStr;
   Chrs := ReadStr;
   Echo := ReadStr;
   s.Read(Offs, SizeOf(Offs));
   s.Read(bOff, SizeOf(bOff));
   s.Read(Head, SizeOf(Head));
   s.Read(Size, SizeOf(Size));
   s.Read(Addy, SizeOf(Addy));
   s.Read(Line, SizeOf(Line));
   s.Read(Numb, SizeOf(Numb));
end;

function TPktColl.FindName;
var
   i: integer;
begin
   Result := -1;
   for i := 0 to count - 1 do begin
      if UpperCase(n) = UpperCase(Items[i].Pack) then begin
         Result := i;
         exit;
      end;
   end;
end;

procedure TPktColl.DeleName;
var
   i: integer;
begin
   Enter;
   i := FindName(n);
   if i > -1 then begin
      AtFree(i);
   end;
   Leave;
end;

function TPktColl.GetAnItem;
begin
   Result := inherited Items[i];
end;

procedure TPktColl.SetItem;
begin
   Enter;
   inherited Items[i] := p;
   Leave;
end;

procedure TNetColl.MarkDel;
var
   i: integer;
begin
   for i := 0 to Count - 1 do begin
      if Items[i].Fido = Fido then begin
         Items[i].Dele := True;
      end;
   end;
end;

procedure TNetColl.Unmark;
var
   i: integer;
begin
   for i := 0 to Count - 1 do begin
      if Items[i].Pack = n then begin
         Items[i].Dele := False;
      end;
   end;
end;

function TNetColl.GetNMsg;
begin
   result := inherited Items[i];
end;

constructor TNetmail.Create;
begin
   inherited Create;
   PktColl := TPktColl.Create;
   MsgColl := TStringColl.Create;
   LstColl := TStringList.Create;
   LstColl.Sorted := True;
   FilColl := TStringList.Create;
   FilColl.Sorted := True;
   NetColl := TNetColl.Create;
   if NetmailLogger = nil then begin
      NetmailLogger := TNetLogger.Create;
   end;
end;

destructor TNetmail.Destroy;
var
   r: PGroup;
   i: integer;
begin
   FreeObject(NetColl);
   for i := 0 to LstColl.Count - 1 do begin
      r := Pointer(LstColl.Objects[i]);
      FreeMem(r, SizeOf(TGroup));
   end;
   LstColl.Free;
   FilColl.Free;
   FreeObject(MsgColl);
   FreeObject(PktColl);
   inherited;
end;

procedure TNetmail.FreePack;
var
   i: integer;
   m: TNetmailMsg;
begin
   NetColl.Enter;
   for i := CollMax(NetColl) downto 0 do begin
      m := NetColl[i];
      if m.Pack = p.Pack then begin
         NetColl.AtDelete(i);
         FreeObject(m);
      end;
   end;
   NetColl.Leave;
end;

procedure TNetMail.ScanMSG;
var
   SR: tuFindData;
   FP: string;
   CC: integer;
   PK: TNetmailPKT;
   NN: integer;
   PN: integer;
   DC: TDualColl;
begin
   if not IniFile.ScanMSG then exit;
   DC := IniFile.GetStrings('gNetPath');
   NetColl.Enter;
   NetColl.MarkDel(True);
   MaxMSG := 0;
   for PN := 0 to CollMax(DC) do begin
   FP := AddBackSlash(TDualRec(DC.Items[PN]^).St1^);
   if uFindFirst(FP + '*.MSG', SR) then begin
      PktColl.Enter;
      repeat
         Application.ProcessMessages;
         NN := Vl(ExtractWord(1, SR.FName, ['.']));
         if NN > 0 then begin
            if (PN = 0) and (MaxMSG < NN) then begin
               MaxMSG := NN;
            end;
            CC := PktColl.FindName(FP + SR.FName);
            if (CC = -1) or (PktColl.Items[CC].Mark <> SR.Info.Time) then begin
               if CC = -1 then begin
                  PK := TNetmailPKT.Create;
                  PktColl.Add(PK);
               end else begin
                  PK := PktColl[CC];
               end;
               ScanMesage(FP + SR.FName);
               PK.Pack := FP + SR.FName;
               PK.Mark := SR.Info.Time;
            end else
            if CC > -1 then begin
               NetColl.Unmark(FP + SR.FName);
            end;
         end;
      until not uFindNext(SR);
      uFindClose(SR);
      PktColl.Leave;
   end;
   end;
   NetColl.Leave;
end;

procedure TNetMail.ScanMail;
var
   i: integer;
   p: string;
   e: string;
   m: TNetmailMSG;
  SR: tuFindData;
begin
   ScanMSG;
   NetColl.Enter;
   NetColl.MarkDel(False);
   p := ExtractFilePath(ExtractDir(inifile.Outbound));
   if uFindFirst(p + '*.*', SR) then begin
      repeat
         if SR.FName[1] = '.' then continue;
         if SR.Info.Attr and FILE_ATTRIBUTE_DIRECTORY <> 0 then begin
            e := ExtractFileExt(SR.FName);
            Delete(e, 1, 1);
            if (VlH(e) > 0) or (e = '') then begin
               if IniFile.D5Out then begin
                  Scan(p + SR.FName);
               end else
               if Pos(UpperCase(IniFile.Outbound), UpperCase(p + SR.FName)) > 0 then begin
                  Scan(p + SR.FName);
               end;
            end;
         end;
      until not uFindNext(SR);
      uFindClose(SR);
   end;
   for i := CollMax(NetColl) downto 0 do begin
      if NetColl[i].Dele then begin
         m := NetColl[i];
         PktColl.DeleName(m.Pack);
         NetColl.AtFree(i);
      end;
   end;
   NetColl.Leave;
end;

procedure TNetmail.Scan;
var
   SR: tuFindData;
   RE: TPCRE;
   BN: string;
   BF: TBusyFlag;
   CC: integer;
   PK: TNetmailPKT;
begin
   if uFindFirst(path + '\*.*', SR) then begin
      RE := GetRegExpr('^[0-9a-f]{8}\.[icdnoh]{1}ut$');
      RE.PattOptions := [poCaseless];
      repeat
         if SR.FName[1] = '.'  then continue;
         if SR.Info.Attr and FILE_ATTRIBUTE_DIRECTORY <> 0 then begin
            if VlH(ExtractFileName(SR.FName)) > 0 then begin
               RE.Unlock;
               scan(path + '\' + SR.FName);
               RE.Lock;
            end;
         end else begin
            if RE.Match(SR.FName) > 0 then begin
               PktColl.Enter;
               CC := PktColl.FindName(path + '\' + SR.FName);
               if (CC = -1) or (PktColl.Items[CC].Mark <> SR.Info.Time) then begin
                  if CC = - 1 then begin
                     PK := TNetmailPKT.Create;
                     PK.Pack := path + '\' + SR.FName;
                     PktColl.Add(PK);
                  end else begin
                     PK := PktColl[CC];
                     FreePack(PK);
                  end;
                  BN := ChangeFileExt(path + '\' + SR.FName, '.bsy');
                  CC := 0;
                  while ExistFile(BN) do begin
                     Sleep(100);
                     Application.ProcessMessages;
                     inc(CC);
                     if CC = 50 then break;
                  end;
                  if not ExistFile(BN) then begin
                     Application.ProcessMessages;
                     IgnoreNextEvent := True;
                     BF := TBusyFlag.Create(BN, False);
                     ScanPacket(path + '\' + SR.FName);
                     PK.Mark := SR.Info.Time;
                     IgnoreNextEvent := True;
                     BF.Finish;
                     BF.Free;
                  end;
               end else
               if CC > -1 then begin
                  NetColl.Unmark(path + '\' + SR.FName);
               end;
               PktColl.Leave;
            end;
         end;
      until not uFindNext(SR);
      RE.Unlock;
      uFindClose(SR);
   end;
end;

procedure SetValue(var a: integer; const b: integer);
begin
   if a = 0 then begin
      a := b;
   end;
end;

procedure TNetmail.FillMSG;
var
   b: byte;
   c: integer;
   i: integer;
   j: integer;
   p: pbytearray;
   u: string;
   t: string;
   z: string;
   a,
   e: integer;
   g: TNetmailMSG;
   d: integer;
   r: PGroup;
   s: integer;

   procedure putstr(const s: string);
   var
      t: string;
      l: integer;
   begin
      t := s + #0;
      l := Length(t);
      move(t[1], p[i], l);
      inc(i, l);
   end;

begin
   try
      GetMem(p, n.Size + 80);
   except
      exit;
   end;
   i := 0;
   if l.Fido then begin
      c := 3;
      putstr(l.Tonm);
      putstr(l.Frnm);
      putstr(l.Subj);
      s := SizeOf(_fidomsgtype) - i;
      l.hLen := i;
   end else begin
      c := 0;
      s := 0;
   end;
   a := 0;
   e := 0;
   d := 0;
   u := #1'Via ' + Addr2Str(inifile.MainAddr) + ' Taurus ' + CProductVersionA + '/W32 ' + RFCDateStr + #13#0;
   repeat
      t := '';
      repeat
         b := 0;
         n.Read(b, 1);
         p[i] := b;
         inc(i);
         if b = 01 then t := '';
         t := t + chr(b);
         if (b = 13) or (b = 0) then begin
            if t[1] = #1 then begin
               if l.Klug = nil then begin
                  l.Klug := TStringColl.Create;
               end;
               l.Klug.Add(t);
               if copy(t, 2, 5) = 'TOPT ' then begin
                  a := StrToInt(ExtractWord(1, ExtractWord(2, t, [' ']), [#13]));
               end else
               if copy(t, 2, 5) = 'FMPT ' then begin
                  e := StrToInt(ExtractWord(1, ExtractWord(2, t, [' ']), [#13]));
               end else
               if copy(t, 2, 5) = 'INTL ' then begin
                  ParseAddress(ExtractWord(1, ExtractWord(2, t, [' ']), [#13]), l.Addr);
                  ParseAddress(ExtractWord(1, ExtractWord(3, t, [' ']), [#13]), l.From);
               end else
               if copy(t, 3, 5) = 'SGID:' then begin
                  GetWrd(t, z, ' ');
                  GetWrd(t, z, #13);
                  for j := 1 to Length(z) do begin
                     if z[j] = ' ' then z[j] := '#';
                  end;
                  l.MsId := z;
               end else
               if copy(t, 2, 5) = 'FLAGS' then begin
                  GetWrd(t, z, ' ');
                  l.Flgs := copy(t, 1, Length(t) - 1);
               end else
               if copy(t, 2, 5) = 'CHRS:' then begin
                  GetWrd(t, z, ' ');
                  GetWrd(t, z, #13);
                  l.Chrs := z;
               end;
            end else
            if copy(t, 1, 5) = 'AREA:' then begin
               GetWrd(t, z, ':');
               GetWrd(t, z, #13);
               l.Echo := z;
               j := LstColl.Add(z);
               r := Pointer(LstColl.Objects[j]);
               if r = nil then begin
                  GetMem(r, SizeOf(TGroup));
                  r.base := 0;
                  r.numb := 0;
               end;
               inc(r.numb);
               l.Numb := r.base + r.numb;
               LstColl.Objects[j] := Pointer(r);
            end else
            if copy(t, 2, 9) = '* Origin:' then begin
               z := ExtractWord(1, ExtractWord(WordCount(t, ['(']), t, ['(']), [')']);
               ParseAddress(z, l.From);
            end else begin
               l.Text := True;
            end;
            if b = 13 then begin
               t := '';
               inc(d);
            end;
         end;
      until (b = 0) or (i >= n.Size - s);
      if c = 0 then begin
         l.Tonm := copy(t, 1, Length(t) - 1);
      end else
      if c = 1 then begin
         l.Frnm := copy(t, 1, Length(t) - 1);
      end else
      if c = 2 then begin
         l.Subj := copy(t, 1, Length(t) - 1);
         l.bOff := n.Position;
      end;
      inc(c);
   until (c = 4) or (i >= n.Size - s);
   if b <> 0 then inc(i);
   if pos('Via ' + Addr2Str(inifile.MainAddr) + ' Taurus ', t) = 0 then begin
      move(u[1], p[i - 1], length(u));
      i := i + length(u) - 1;
      l.Addy := length(u) - 1;
   end;
   SetValue(l.Addr.Zone, IniFile.MainAddr.Zone);
   SetValue(l.From.Zone, IniFile.MainAddr.Zone);
   SetValue(l.Addr.Net, l.Head.DestNet);
   SetValue(l.From.Net, l.Head.OrigNet);
   SetValue(l.Addr.Node, l.Head.DestNode);
   SetValue(l.From.Node, l.Head.OrigNode);
   SetValue(l.From.Point, e);
   SetValue(l.Addr.Point, a);
   l.Addr.Domain := FindFTNDOM(l.Addr);
   l.From.Domain := FindFTNDOM(l.From);
   l.Size        := i;
   l.Line        := d;
   if l.MsId = '' then begin
      l.MsId := Addr2Str(l.From) + '#' + Format('%.8x', [GetTickCount xor xRandom32]) + '#gate';
   end;
   if not EchoMail then begin
      GetMem(l.Body, l.Size);
      move(p^, l.Body^, l.Size);
   end;
   g := FindMessage(l.MsId);
   if (g = nil) then begin
      if l.Fido and AddrColl.Search(@l.Addr, e) then begin
         FreeObject(l);
      end else begin
         NetColl.Add(l);
         fBackup := True;
      end;
   end else begin
      g.Dele := False;
      g.bOff := l.bOff;
      g.Offs := l.Offs;
      g.Pack := l.Pack;
      FreeObject(l);
   end;
   FreeMem(p, n.Size + 80);
end;

procedure TNetmail.ScanMesage;
var
   n: TMemStream;
   h: _fidomsgtype;
   l: TNetmailMsg;
   o: TStringColl;
   s: string;
   z: string;
   t: string;
begin
   if not ExistFile(pack) then exit;
   n := TMemStream.Create;
   if n <> nil then begin
      try
         n.LoadFromFile(pack);
      except
         n.Free;
         exit;
      end;
      if n.Size > SizeOf(h) then begin
         n.Read(h, sizeof(h));
         if (((h.attr and InTransit) > 0) or ((h.attr and Local) > 0)) and ((h.Attr and Sent_) = 0) then begin
            l := TNetmailMsg.Create;
            l.Offs := n.Position;
            l.bOff := n.Position;
            l.Pack := pack;
            l.Fido := True;
            l.Head.MsgType := 2;
            l.Head.OrigNode := h.orig_node;
            l.Head.DestNode := h.dest_node;
            l.Head.OrigNet  := h.orig_net;
            l.Head.DestNet  := h.dest_net;
            l.Frnm := h.from;
            l.Tonm := h.towhom;
            l.Subj := h.subject;
            s := (PChar(@h.azdate));
            s := Format('%19s', [s]) + #0;
            move(s[1], h.azdate, 20);
            move(h.azdate, l.Head.DateTime, 20);
            l.Attr := h.attr;
            l.Head.Attribute := h.attr and not (Recd or Sent_ or InTransit or Orphan or KillSent or Local or HoldForPickup or FileRequest or FileUpdateReq);
            FillMSG(n, l);
            if (l <> nil) and ((h.attr and FileRequest) > 0) then begin
               s := GetOutFileName(l.Addr, osrequest);
               if FidoOut.Lock(l.Addr, osBusy, True) then begin
                  o := TStringColl.Create;
                  if ExistFile(s) then begin
                     o.LoadFromFile(s);
                  end;
                  t := l.Subj;
                  while t <> '' do begin
                     GetWrd(t, z, ' ');
                     o.Add(z);
                  end;
                  o.SaveToFile(s);
                  n.Position := 0;
                  h.attr := h.attr and (not FileRequest);
                  n.Write(h, SizeOf(h));
                  n.SaveToFile(pack);
                  FidoOut.Unlock(l.Addr, osBusy);
               end;
            end;
         end;
      end;
      n.Free;
   end;
end;

procedure TNetmail.ScanPacket;
var
   n: TMemStream;
   h: PktHeaderRec;
   m: PackedMsgHeaderRec;
   l: TNetmailMsg;
   s: string;
begin
   if not ExistFile(pack) then exit;
   if EchoMail and (FilColl.IndexOf(pack) > -1) then exit;
   NetColl.Enter;
   n := TMemStream.Create;
   if n <> nil then begin
      try
         n.LoadFromFile(pack);
      except
         n.Free;
         NetColl.Leave;
         exit;
      end;
      if n.Size > SizeOf(h) then begin
      n.Read(h, sizeof(h));
      if h.OrigNode = $3250 then begin
         n.Free;
         NetColl.Leave;
         exit;
      end;
      while n.Position < n.Size - sizeof(m) + 3 do begin
         l := TNetmailMsg.Create;
         l.Offs := n.Position;
         l.Pack := pack;
         n.Read(m, sizeof(m));
         s := (PChar(@m.DateTime));
         s := Format('%19s', [s]) + #0;
         move(s[1], m.DateTime, 20);
         l.HRec := h;
         l.Head := m;
         l.Lock.Zone  := h.DestZone;
         l.Lock.Net   := h.DestNet;
         l.Lock.Node  := h.DestNode;
         l.Lock.Point := h.DestPoint;
         l.Attr       := m.Attribute;
         FillMSG(n, l);
         if l <> nil then begin
            SetValue(l.From.Net, m.OrigNet);
            SetValue(l.From.Node, m.OrigNode);
            SetValue(l.Addr.Net, m.DestNet);
            SetValue(l.Addr.Node, m.DestNode);
            l.From.Domain := FindFTNDOM(l.From);
            l.Addr.Domain := FindFTNDOM(l.Addr);
            l.Lock.Domain := FindFTNDOM(l.Lock);
         end;
         Application.ProcessMessages;
      end;
      end;
      n.Free;
   end;
   NetColl.Leave;
end;

procedure TNetmail.MoveMail(n: TNetmailMsg; const t: TFidoAddress; const a: string; Active: boolean);
var
   s: string;
   w: string;
   i: TFileStream;
   h: PktHeaderRec;
   b: byte;
   o: boolean;
   u: TOutStatus;
begin
   if n.Fido and (n.Attr and FileAttached > 0) then exit;
   s := GetOutFileName(t, osNone);
   if pos(UpperCase(s), UpperCase(n.Pack)) > 0 then exit;
   MsgColl.Add('Routing ' + Addr2Str(n.From) + ' -> ' + Addr2Str(n.Addr) + ' via ' + Addr2Str(t));
   if Active then begin
      if n.Fido and (pos('IMM', n.Flgs) > 0) then begin
         s := s + '.iut';
         u := osImmedMail;
      end else
      if n.Fido and (pos('DIR', n.Flgs) > 0) then begin
         s := s + '.dut';
         u := osDirectMail;
      end else begin
         s := s + '.cut';
         u := osCrashMail;
      end;
   end else begin
      s := s + '.out';
      u := osNormalMail;
   end;
   b := 0;
   o := False;
   if not ExistFile(s) then begin
      o := True;
      fillchar(h, sizeof(h), 0);
      h.OrigNode  := inifile.MainAddr.Node;
      h.DestNode  := t.Node;
      h.Year      := CurrentYear;
      h.Month     := MonthOf(Date);
      h.Day       := DayOf(Date);
      h.Hour      := HourOf(Time);
      h.Minute    := MinuteOf(Time);
      h.Second    := SecondOf(Time);
      h.Baud      := 300;
      h.PktType   := 2;
      h.OrigNet   := inifile.MainAddr.Net;
      h.DestNet   := t.Net;
      h.ProdCode  := $FF;
      h.SerialNo  := $15;
      h.OrigZone  := inifile.MainAddr.Zone;
      h.DestZone  := t.Zone;
      h.OrigPoint := inifile.MainAddr.Point;
      h.DestPoint := t.Point;
      w           := UpperCase(a);
      move(w[1], h.Password, minI(8, length(a)));
      i := TFileStream.Create(s, fmCreate);
      i.Write(h, sizeof(h));
      i.Write(b, 1);
      i.Write(b, 1);
      i.Free;
   end;
   try
      i := TFileStream.Create(s, fmOpenWrite);
   except
      MsgColl.Add('Failed to open ' + s);
      exit;
   end;
   i.Seek(-2, soFromEnd);
   i.Write(n.Head, sizeof(n.Head));
   i.Write(n.Body^, n.Size);
   i.Write(b, 1);
   i.Write(b, 1);
   i.Free;
   DelMail(n);
   if o then begin
      FidoOut.AddOutbound(t, s, u, kaBSOKillAfter);
   end;
   ScanActive := True;
   ScanCounter := 1;
end;

procedure TNetmail.PackMail;
var
   i: integer;
   m: TNetmailMsg;
begin
   for i := 0 to CollMax(NetColl) do begin
      m := NetColl[i];
      if MatchMaskAddress(m.Addr, r) and not MatchMaskAddressListSingle(m.Addr, e) then begin
         if existfile(m.Pack) then begin
            if (Pos('DIR', m.Flgs) = 0) or (CompareAddrs(m.Addr, a) = 0) then begin
               MoveMail(m, a, p, Active);
            end;
         end else begin
            FreeMem(m.Body, m.Size);
            m.Body := nil;
            m.MsId := '';
            FillChar(m.Addr, SizeOf(m.Addr), #0);
         end;
      end;
   end;
   for i := CollMax(NetColl) downto 0 do begin
      m := NetColl[i];
      if (m.Body = nil) or not FileExists(m.Pack) then begin
         NetColl.AtFree(i);
      end;
   end;
end;

procedure TNetmail.Route;
var
   i: integer;
   o: string;
   s: string;
   t: string;
   p: string;
   e: string;
   b: string;
   n: integer;
begin
   NetColl.Enter;
   if IniFile.DynamicRouting or IniFile.ScanMSG then
   if FidoOut.Lock(a, osBusy, True) then begin
      for i := 0 to IniFile.NetmailAddrTo.Count - 1 do begin
         o := IniFile.NetmailAddrTo[i];
         if MatchMaskAddress(a, o) then begin
            s := IniFile.NetmailAddrFrom[i];
            e := '';
            repeat
               GetWrd(s, t, ' ');
               if (t <> '') and (t[1] = '!') then begin
                  Delete(t, 1, 1);
                  e := e + ' ' + t;
               end;
            until s = '';
            b := '';
            s := IniFile.NetmailAddrFrom[i];
            for n := 1 to WordCount(s, [' ']) do begin
               t := ExtractWord(n, s, [' ']);
               if t[1] <> '!' then b := b + ' ' + t;
            end;
            s := b;
            p := IniFile.NetmailPwd[i];
            if p = '' then p := w;
            repeat
               GetWrd(s, t, ' ');
               if (o = t) then begin
                  PackMail(a, Addr2Str(a), '', p, Active);
               end else begin
                  PackMail(a, t, e, p, Active);
               end;
               while MsgColl.Count > 0 do begin
                  Log(ltInfo, MsgColl[0]);
                  MsgColl.AtFree(0);
               end;
            until s = '';
//            break;
         end;
      end;
      FidoOut.Unlock(a, osBusy);
   end;
   NetColl.Leave;
end;

procedure TNetmail.DeleteMail;
var
   i: integer;
   m: TNetmailMsg;
begin
   NetColl.Enter;
   for i := 0 to CollMax(NetColl) do begin
      m := NetColl[i];
      if m.MsId = Id then begin
         DelMail(m);
      end;
   end;
   NetColl.Leave;
end;

procedure TNetmail.DelMail;
var
   i: TFileStream;
   z: int64;
   p: pointer;
   g: integer;
   e: TNetmailMsg;
   h: _fidomsgtype;
begin
   NetColl.Enter;
   FreeMem(n.Body, n.Size);
   n.Body := nil;
   n.MsId := '';
   if ExistFile(n.Pack) then begin
      if n.Fido then begin
         if (n.Attr and KillSent) > 0 then begin
            DeleteFile(n.Pack);
         end else begin
            i := TFileStream.Create(n.Pack, fmOpenReadWrite);
            i.Read(h, SizeOf(h));
            h.attr := h.attr or Sent_;
            i.Position := 0;
            i.Write(h, SizeOf(h));
            i.Free;
         end;
      end else
      try
         FidoOut.Lock(n.Lock, osBusy, True);
         i := TFileStream.Create(n.Pack, fmOpenReadWrite);
         i.Seek(n.Offs + sizeof(n.Head) + n.Size - n.Addy, soFromBeginning);
         z := i.Size - i.Position;
         GetMem(p,  z);
         i.Read(p^, z);
         i.Seek(n.Offs, soFromBeginning);
         i.Write(p^, z);
         FreeMem(p,  z);
         SetEndOfFile(i.Handle);
         z := i.Size;
         i.Free;
         if z = 60 then begin
            DeleteFile(n.Pack);
         end;
      finally
         FidoOut.Unlock(n.Lock, osBusy);
      end;
      for g := 0 to CollMax(NetColl) do begin
         e := NetColl[g];
         if (e.Pack = n.Pack) and (e <> n) and (e.Offs > n.Offs) then begin
            e.bOff := e.bOff - sizeof(n.Head) - n.Size + n.Addy;
            e.Offs := e.Offs - sizeof(n.Head) - n.Size + n.Addy;
         end;
      end;
   end else begin
      for g := 0 to CollMax(NetColl) do begin
         e := NetColl[g];
         if (e.Pack = n.Pack) then begin
            FreeMem(e.Body, e.Size);
            e.Body := nil;
            FillChar(e.Addr, sizeof(e.Addr), 0);
         end;
      end;
   end;
   FillChar(n.Addr, sizeof(n.Addr), 0);
   NetColl.Leave;
end;

function TNetmail.FindMessage;
var
   i: integer;
   m: TNetmailMsg;
begin
   NetColl.Enter;
   Result := nil;
   for i := 0 to CollMax(NetColl) do begin
      m := NetColl[i];
      if m.MsId = Id then begin
         Result := m;
         break;
      end;
   end;
   NetColl.Leave;
end;

procedure TMemStream.LoadFromFile;
var
   h: THandle;
begin
   h := _CreateFile(n, [cRead]);
   if h = INVALID_HANDLE_VALUE then Exit;
   ZeroHandle(h);
   inherited;
end;

constructor TNetStream.Create;
var
   h: THandle;
begin
   h := _CreateFile(n, [cRead, cWrite]);
   if h = INVALID_HANDLE_VALUE then Exit;
   ZeroHandle(h);
   inherited;
end;

procedure MergeMail(const a: TFidoAddress; const n, o: string);
var
   i,
   p: TNetStream;
begin
   if FidoOut.Lock(a, osBusyEx, True) then begin
      if FidoOut.Lock(a, osBusy, True) then begin
         if not FileExists(o) then begin
            RenameFile(n, o);
         end else
         if GetPKTFileType(n) = pftFSC39 then begin
            i := TNetStream.Create(o, fmOpenRead);
            if i <> nil then begin
               p := TNetStream.Create(n, fmOpenReadWrite);
               if p <> nil then begin
                  i.Seek($3A, soFromBeginning);
                  p.Seek(-2, soFromEnd);
                  p.CopyFrom(i, i.Size - $3A);
                  FreeObject(i);
                  FreeObject(p);
                  DeleteFile(o);
                  RenameFile(n, o);
                  FreeObject(p);
               end;
               FreeObject(i);
            end;
         end else begin
            // hope this shit never happen or
            // PKT in a ?lo technique should be used
         end;
         FidoOut.Unlock(a, osBusy);
      end;
      FidoOut.Unlock(a, osBusyEx);
   end;
end;

constructor TNetLogger.Create;
begin
   inherited;
   LogColl := TStringColl.Create;
   Log('Begin v' + ProductVersion);
end;

destructor TNetLogger.Destroy;
begin
   Log('End');
   FreeObject(LogColl);
   inherited;
end;

procedure TNetLogger.Log;
var
   t: THandle;
begin
   LogColl.Add(s);
   NetmailLog   := MakeNormName(dLog, IniFile.net_log);
   if _LogOK(NetmailLog, t) then begin
      While LogColl.Count > 0 do begin
        _LogWriteStr(' ' + uFormat(uGetLocalTime) + ' ' + Dos2Win(LogColl[0]), t);
         LogColl.AtFree(0);
      end;
      ZeroHandle(t);
   end;
end;

procedure TNetLogger.LogMSG;
var
   a: TFidoAddress;
   s: string;
begin
   if m.HRec.PktType <> 0 then begin
      m.HRec.PktType := 0;
      a.Zone  := m.HRec.OrigZone;
      a.Net   := m.HRec.OrigNet;
      a.Node  := m.HRec.OrigNode;
      a.Point := m.HRec.OrigPoint;
      s := Addr2Str(a) + ' => ';
      a.Zone  := m.HRec.DestZone;
      a.Net   := m.HRec.DestNet;
      a.Node  := m.HRec.DestNode;
      a.Point := m.HRec.DestPoint;
      s := 'PKT: ' + s + Addr2Str(a);
      Log('');
      Log(s);
      if MLogger <> nil then begin
         MLogger.Log(ltInfo, s);
      end;
   end;
   s := m.Frnm + ' (' + Addr2Str(m.From) + ') => ' + m.Tonm + ' (' + Addr2Str(m.Addr) + '); Subj: ' + m.Subj + ', Date: ' + m.Date + ', MsgId: ' + m.MsId;
   Log('[' + p + '] ' + s);
   if MLogger <> nil then begin
      MLogger.Log(ltInfo, '#' + IntToStr(n) + ' ' + s);
   end;
end;

initialization

NetmailHolder := nil;
EchomailHolder := TColl.Create;

finalization

FreeObject(EchomailHolder);

end.
