unit Netmail;

interface

uses Windows, xBase, xFido, MClasses, Classes;

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
      Head: PackedMsgHeaderRec;
      Size: int64;
      Line: integer;
      Addy: integer;
      Numb: dword;
      Body: Pointer;
      Dele: boolean;
      Fido: boolean;
      Attr: system.word;
      Flgs: string;
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
      constructor Create; virtual;
      destructor Destroy; override;
      procedure ScanMSG;
      procedure ScanMail;
      procedure FillMSG(const n: TStream; var l: TNetmailMsg);
      procedure ScanMesage(const pack: string);
      procedure ScanPacket(const pack: string);
      procedure Route(const a: TFidoAddress; Active: boolean; Log: TLogProcedure);
      procedure DeleteMail(const Id: string);
      function FindMessage(const Id: string): TNetmailMsg;
   end;

procedure FreeNetmailHolder;

var
   NetmailHolder: TNetmail;
   EchomailHolder: TColl;

implementation

uses
   RadIni, RRegExp, SysUtils, Wizard, Outbound, DateUtils,
   IniFiles, Forms, Watcher;

procedure FreeNetmailHolder;
begin
   FreeObject(NetmailHolder);
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

function TPktColl.GetAnItem;
begin
   Result := inherited Items[i];
end;

procedure TPktColl.SetItem;
begin
   inherited Items[i] := p;
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
   for i := NetColl.Count - 1 downto 0 do begin
      m := NetColl[i];
      if m.Pack = p.Pack then begin
        NetColl.AtFree(i);
      end;
   end;
   NetColl.Leave;
   PktColl.Delete(p);
   FreeObject(p);
end;

procedure TNetMail.ScanMSG;
var
   SR: tuFindData;
   FP: string;
   CC: integer;
   PK: TNetmailPKT;
begin
   if not IniFile.ScanMSG then exit;
   FP := AddBackSlash(IniFile.ReadString('MSG', 'Netmail', ''));
   if uFindFirst(FP + '*.MSG', SR) then begin
      NetColl.Enter;
      NetColl.MarkDel(True);
      PktColl.Enter;
      repeat
         if Vl(ExtractFileName(SR.FName)) > 0 then begin
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
      NetColl.Leave;
   end;
end;

procedure TNetMail.ScanMail;
var
   i: integer;
   p: string;
   e: string;
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
      if NetColl[i].Dele then NetColl.AtFree(i);
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
   GetMem(p, n.Size + 80);
   i := 0;
   if l.Fido then begin
      c := 3;
      putstr(l.Tonm);
      putstr(l.Frnm);
      putstr(l.Subj);
      s := SizeOf(_fidomsgtype) - i;
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
            if copy(t, 2, 5) = 'CHRS:' then begin
               GetWrd(t, z, ' ');
               GetWrd(t, z, #13);
               l.Chrs := z;
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
            if copy(t, 2, 5) = 'FLAGS' then begin
               GetWrd(t, z, ' ');
               l.Flgs := copy(t, 1, Length(t) - 1);
            end else
            if copy(t, 2, 9) = '* Origin:' then begin
               z := ExtractWord(1, ExtractWord(WordCount(t, ['(']), t, ['(']), [')']);
               ParseAddress(z, l.From);
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
   SetValue(l.From.Point, e);
   SetValue(l.Addr.Point, a);
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
   if g = nil then begin
      NetColl.Add(l);
      fBackup := True;
   end else begin
      g.Dele := False;
      g.bOff := l.bOff;
      g.Offs := l.Offs;
      FreeObject(l);
   end;
   FreeMem(p, n.Size + 80);
end;

procedure TNetmail.ScanMesage;
var
   n: TMemoryStream;
   h: _fidomsgtype;
   l: TNetmailMsg;
   o: TStringColl;
   s: string;
   z: string;
   k: TKillAction;
begin
   if not ExistFile(pack) then exit;
   NetColl.Enter;
   n := TMemoryStream.Create;
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
         if (((h.attr and InTransit) > 0) or ((h.attr and Local) > 0)) and ((h.Attr and Sent_) = 0) then begin
            l := TNetmailMsg.Create;
            l.Offs := n.Position;
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
            move(h.azdate, l.Head.DateTime, 20);
            l.Attr := h.attr;
            l.Head.Attribute := h.attr and not (Recd or Sent_ or InTransit or Orphan or KillSent or Local or HoldForPickup or FileRequest or FileUpdateReq);
            FillMSG(n, l);
            if (l <> nil) and ((h.attr and FileAttached) > 0) then begin
               o := TStringColl.Create;
               s := l.Subj;
               while s <> '' do begin
                  GetWrd(s, z, ' ');
                  o.Add(z);
               end;
               k := kaBsoNothingAfter;
               if pos('KFS', l.Flgs) > 0 then begin
                  k := kaBsoKillAfter;
               end else
               if pos('TFS', l.Flgs) > 0 then begin
                  k := kaBsoTruncateAfter;
               end;
               FidoOut.AttachFiles(l.Addr, o, osNormal, k);
               FreeObject(o);
               n.Position := 0;
               h.attr := h.attr and (not FileAttached);
               n.Write(h, SizeOf(h));
               n.SaveToFile(pack);
            end else
            if (l <> nil) and ((h.attr and FileRequest) > 0) then begin
               //
            end;
         end;
      end;
      n.Free;
   end;
   NetColl.Leave;
end;

procedure TNetmail.ScanPacket;
var
   n: TMemoryStream;
   h: PktHeaderRec;
   m: PackedMsgHeaderRec;
   l: TNetmailMsg;
begin
   if not ExistFile(pack) then exit;
   if EchoMail and (FilColl.IndexOf(pack) > -1) then exit;
   NetColl.Enter;
   n := TMemoryStream.Create;
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
      while n.Position < n.Size - sizeof(m) + 3 do begin
         l := TNetmailMsg.Create;
         l.Offs := n.Position;
         l.Pack := pack;
         n.Read(m, sizeof(m));
         l.Head := m;
         l.Lock.Zone  := h.DestZone;
         l.Lock.Net   := h.DestNet;
         l.Lock.Node  := h.DestNode;
         l.Lock.Point := h.DestPoint;
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
      move(w[1], h.Password, length(a));
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
end;

procedure TNetmail.PackMail;
var
   i: integer;
   m: TNetmailMsg;
begin
   NetColl.Enter;
   for i := 0 to CollMax(NetColl) do begin
      m := NetColl[i];
      if MatchMaskAddress(m.Addr, r) and not MatchMaskAddressListSingle(m.Addr, e) then begin
         if existfile(m.Pack) then begin
            if not m.Fido or (Pos('DIR', m.Flgs) = 0) or (CompareAddrs(m.Addr, a) = 0) then begin
               MoveMail(m, a, p, Active);
               ScanActive := True;
               ScanCounter := 1;
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
   NetColl.Leave;
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
   if IniFile.DynamicRouting then
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

initialization

NetmailHolder := nil;
EchomailHolder := TColl.Create;

finalization

FreeObject(EchomailHolder);

end.
