procedure InvalidateLogBox(ActiveLine: Pointer);
var
   I: Integer;
  mf: TMailerForm;
begin
   for I := 0 to MailerForms.Count - 1 do begin
      mf := MailerForms[I];
      if mf.ActiveLine = ActiveLine then mf.LogBox.DoPaint(true); //mf.LogBox.Invalidate
   end;
end;

procedure __CloseLine(AM: Integer);
var
   M: TMailerThread absolute AM;
   I: Integer;
begin
   if MailerThreads = nil then GlobalFail('%s', ['MailerThreads = nil']);
   I := MailerThreads.IndexOf(M);
   if I = -1 then GlobalFail('%s', ['_CloseLine not found']);
   MailerThreads.Enter;
   MailerThreads.AtDelete(I);
   MailerThreads.Leave;
   SendMsg(WM_UPDATETABS);
   SendMsg(WM_TABCHANGE);
   M.WaitFor;
   PostMsg(WM_UPDATEMENUS);
   FreeObject(M);
end;

procedure AddSpcLogStr(APStr: Integer; p: Pointer);
var
  ps: TStringHolder absolute APStr;
   L: TStringColl;
   s: string;
begin
   s := StrAsg(ps.s);
   FreeObject(ps);
   case Integer(p) of
   Integer(PanelOwnerPolls):
      begin
        if (FidoPolls <> nil) and (FidoPolls.Log <> nil) then L := FidoPolls.Log.Strings else exit;
      end;
   Integer(PanelOwnerDaemon):
      begin
         if (IpPolls <> nil) and (IpPolls.LogContainer <> nil) then L := IpPolls.LogContainer.Strings else exit;
      end;
   else begin GlobalFail('Unk AddSpcLogStr(%s)', [s]); Exit end;
   end;
   L.Add(S);
   while L.Count > MaxLogStrings do L.AtFree(0);
   if MailerForms <> nil then InvalidateLogBox(p);
end;

procedure ImportPwdList;
var
  sp,
   i: Integer;
   l: TStringColl;
  FName,
   s,
   z,
   k: string;
  LogStrs: TStringColl;
   A: TFidoAddrColl;
  PC: TPasswordColl;
   R: TPasswordRec;
  Files: TStringColl;
begin
   CfgEnter;
   s := StrAsg(Trim(Cfg.Passwords.AuxFile));
   CfgLeave;
   if s = '' then Exit;
   FName := MakeFullDir(HomeDir, s);
   if not FileExists(FName) then Exit;
   PC := TPasswordColl.Create;
   logstrs := TStringColl.Create;
   l := TStringColl.Create;
   l.KeepOnLoad := True;
   Files := TStringColl.Create;
   Files.Add(FName);
   Files.IgnoreCase := True;
   l.LoadFromFile(FName);
   i := 0;
   while i <= CollMax(l) do begin
      s := Trim(l[i]); Inc(i);
      if s = '' then Continue;
      case s[1] of
      ';', '#': Continue;
      end;
      if StrBegsU('INCLUDE ', s) then begin
         GetWrd(s, z, ' ');
         s := FullPath(s);
         if not Files.Search(@s, sp) then begin
            Files.AtInsert(sp, NewStr(s));
            if not l.LoadFromFile(s) then begin
               logstrs.Add(GetErrorMsg);
               ClearErrorMsg;
            end;
         end;
         Continue;
      end;
      GetWrd(s, z, '|'); if not UnpackRFC1945(z) then Continue;
      GetWrd(s, k, '|'); if not UnpackRFC1945(k) then Continue;
      z := Trim(z);
      k := Trim(k);
      if (z = '') or (k = '') then Continue;
      A := CreateAddrCollMsg(z, s);
      if A = nil then begin
         logstrs.Add(s);
         Continue;
      end;
      R := TPasswordRec.Create;
      XChg(Integer(R.AddrList), Integer(A));
      FreeObject(A);
      R.PswStr := k;
      PC.Insert(R);
   end;
   FreeObject(l);
   LogStrs.Add(Format('%d password(s) imported from %s', [PC.Count, Files.LongStringS(', ')]));
   FreeObject(Files);
   for i := 0 to LogStrs.Count - 1 do begin
      s := LogStrs[i];
      FidoPolls.Log.LogSelf('PWD-IMPORT: ' + s);
   end;
   FreeObject(LogStrs);
   EnterCS(AuxPwdsCS);
   XChg(Integer(AuxPwds), Integer(PC));
   LeaveCS(AuxPwdsCS);
   FreeObject(PC);
end;

procedure ImportOvrList(C: TAbsNodeOvrColl; const AName: string; ADialup: Boolean);
const
  SDialup : array[Boolean] of string = ('TCP/IP', 'dial-up');
var
  os,
   s,
   z,
   k,
   FName: string;
   l,
   Files,
   LogStrs,
   SC: TStringColl;
  sp,
   i: Integer;
   A: TFidoAddress;
   O: TNodeOvr;
   Local:Boolean;
begin
   if AName = '' then Exit;
   FName := MakeFullDir(HomeDir, AName);
   if not FileExists(FName) then Exit;
   logstrs := TStringColl.Create('');
   l := TStringColl.Create('');
   l.KeepOnLoad := False;
   Files := TStringColl.Create('');
   Files.Add(FName);
   Files.IgnoreCase := True;
   l.LoadFromFile(FName);
   for i := 0 to CollMax(l) do begin
      z := trim(copy(l[i], 1, pos(',', l[i])));
      s := l[i];
      Delete(s, 1, pos(',', s));
      s := Trim(s);
      SC := TStringColl.Create('');
      SC.FillEnum(s, [','], False);
      for sp := 0 to CollMax(SC) do begin
         s := SC[sp];
         Local := True;
         if (pos('-', s) <> 0) or (pos('CM', s) <> 0) then begin
            s := HumanTime2UTxyL(s,False);
            if IsTxy(s, Local) then SC[sp] := 'U,' + s;
         end;
      end;
      s := SC.LongStringD(',');
      FreeObject(SC);
      l[i] := z + s;
   end;

   i := 0;
   while i <= CollMax(l) do begin
      s := Trim(l[i]); Inc(i);
      if s = '' then Continue;
      os := s;
      case s[1] of
      ';', '#': Continue;
      end;
      if StrBegsU('INCLUDE ', s) then begin
         GetWrd(s, z, ' ');
         s := FullPath(s);
         if not Files.Search(@s, sp) then begin
            Files.AtInsert(sp, NewStr(s));
            if not l.LoadFromFile(s) then begin
               logstrs.Add(GetErrorMsg);
               ClearErrorMsg;
            end;
         end;
         Continue;
      end;
      GetWrd(s, z, '|'); if not UnpackRFC1945(z) then Continue;
      GetWrd(s, k, '|'); if not UnpackRFC1945(k) then Continue;
      z := Trim(z);
      k := Trim(k);
      if (z = '') or (k = '') then Continue;
      if not ParseAddressMsg(z, A, s) then begin
         logstrs.Add(s);
         Continue;
      end;
      s := ValidOverride(k, ADialup, z);
      if s <> '' then begin
         logstrs.Add(Format('%s - %s (%s)', [os, s, z]));
         Continue;
      end;
      O := TNodeOvr.Create;
      O.Addr := A;
      O.Ovr := k;
      C.Insert(O);
   end;
   FreeObject(l);
   LogStrs.Add(Format('%d %s node override(s) imported from %s', [C.Count, SDialup[ADialup], Files.LongStringS(', ')]));
   FreeObject(Files);
   for i := 0 to LogStrs.Count - 1 do begin
      s := LogStrs[i];
      FidoPolls.Log.LogSelf('OVR-IMPORT: ' + s);
   end;
   FreeObject(LogStrs);
end;

procedure ImportDupOvrList;
var
   C: TDialupNodeOvrColl;
   s: string;
begin
   FreeObject(AuxDialupNodeOverrides);
   PurgeCS(AuxDialupNodeOverridesCS);
   AuxDialupNodeOverrides := TDialupNodeOvrColl.Create('AuxDialupNodeOverrides');
   InitializeCriticalSection(AuxDialupNodeOverridesCS);
   C := TDialupNodeOvrColl.Create('');
   CfgEnter;
   s := StrAsg(Cfg.DialupNodeOverrides.AuxFile);
   CfgLeave;
   ImportOvrList(C, s, True);
   EnterCS(AuxDialupNodeOverridesCS);
   XChg(Integer(AuxDialupNodeOverrides), Integer(C));
   LeaveCS(AuxDialupNodeOverridesCS);
   FreeObject(C);
   PurgeAdvNodeCache;
   InvalidatePollAddrs;
  _RecalcPolls(False);
   PostMsg(WM_UPDATEMENUS);
end;

{$IFDEF WS}
procedure ImportIpOvrList;
var
   C: TIPNodeOvrColl;
   s: string;
begin
   C := TIPNodeOvrColl.Create('');
   CfgEnter;
   s := StrAsg(Cfg.IpNodeOverrides.AuxFile);
   CfgLeave;
   ImportOvrList(C, s, False);
   EnterCS(AuxIpNodeOverridesCS);
   XChg(Integer(AuxIpNodeOverrides), Integer(C));
   LeaveCS(AuxIpNodeOverridesCS);
   FreeObject(C);
   PurgeAdvNodeCache;
   InvalidatePollAddrs;
  _RecalcPolls(False);
   PostMsg(WM_UPDATEMENUS);
end;
{$ENDIF}

var
   VCompilingNodelist: Integer;

procedure VCompileNodelist(AAuto: Boolean);
var
   D: TNodelistCompiler;
begin
   if VCompilingNodelist <> 0 then Exit;
   Inc(VCompilingNodelist);
   D := TNodelistCompiler.Create(Application);
   D.Auto := AAuto;
   D.ShowModal;
   D.Free;
   PurgeAdvNodeCache;
   InvalidatePollAddrs;
  _RecalcPolls(False);
   Dec(VCompilingNodelist);
   PostMsg(WM_UPDATEVIEW);
   PostMsg(WM_UPDOUTMGR);
end;

procedure UpdateBWListBox;
var
   i: Integer;
begin
   if MailerForms <> nil then for i := 0 to MailerForms.Count - 1 do TMailerForm(MailerForms.At(i)).UpdateBWZListBox;
end;

procedure UpdateOutboundManagers;
var
   i: Integer;
begin
   if MailerForms <> nil then for i := 0 to MailerForms.Count - 1 do TMailerForm(MailerForms.At(i)).UpdateOutboundManager;
end;

procedure ClearTerms;
var
   i: Integer;
   m: TMailerForm;
   t: TMailerThread absolute AThr;
begin
   if (MailerForms = nil) or (MailerForms = nil) then Exit;
   if MailerThreads.IndexOf(t) = -1 then Exit;
   t.TermTxData.Clear; t.TermRxData.Clear;
   for i := 0 to MailerForms.Count - 1 do begin
      m := MailerForms[i];
      if m.ActiveLine <> t then Continue;
      m.TermTx.Invalidate;
      m.TermRx.Invalidate;
   end;
end;

procedure UpdateMHist(Athr:TMailerThread);
var
   i: Integer;
   m: TMailerForm;
   t: TMailerThread absolute AThr;
begin
   if (MailerForms = nil) or (MailerForms = nil) then Exit;
   if MailerThreads.IndexOf(t) = -1 then Exit;
   for i := 0 to MailerForms.Count - 1 do begin
      m := MailerForms[i];
      if m.ActiveLine <> t then Continue;
      Move(t.DU_InGr[1],t.DU_InGr[0], (TCPIP_GrDataSz - 1) * SizeOf(Integer));
      Move(t.DU_OutGr[1],t.DU_OutGr[0], (TCPIP_GrDataSz - 1) * SizeOf(Integer));
      Move(t.DU_InGr, m.DU_InGrM, SizeOf(m.DU_InGrM));
      Move(t.DU_OutGr, m.DU_OutGrM, SizeOf(m.DU_OutGrM));
      t.DU_OutGr[TCPIP_GrDataSz] := 0;
      t.DU_InGr[TCPIP_GrDataSz] := 0;
   end;
end;

procedure UpdateTerm(Struc: Integer);
var
   s: TUpdateTermStruc absolute Struc;

procedure DoIt;
var
   i: Integer;
  RR,
   R: TRect;
   u: Boolean;
   m: TMailerForm;
 mth: DWORD;
 mtd: TTermData;
  ss: string;
begin
   if (MailerForms = nil) or (MailerThreads = nil) then Exit;
   if MailerThreads.IndexOf(s.Thr) = -1 then Exit;
   ss := StrAsg(s.Str);
   u := False;
   RR.Left := High(RR.Left);
   RR.Top := High(RR.Top);
   RR.Right := -High(RR.Right);
   RR.Bottom := -High(RR.Bottom);
   for i := 1 to Length(ss) do begin
      if s.Top then mtd := s.Thr.TermTxData else mtd := s.Thr.TermRxData;
      R := mtd.PutChar(ss[i], s.Lit, s.CrL);
      if _EmptyRect(R) then Continue;
      RR.Left := MinI(RR.Left, R.Left);
      RR.Top := MinI(RR.Top, R.Top);
      RR.Right := MaxI(RR.Right, R.Right);
      RR.Bottom := MaxI(RR.Bottom, R.Bottom);
      u := True;
   end;
   if u then
   for i := 0 to MailerForms.Count - 1 do begin
      m := MailerForms[i];
      if m.ActiveLine <> s.Thr then Continue;
      if s.Top then mth := m.TermTx.Handle else mth := m.TermRx.Handle;
      InvalidateRect(mth, @RR, False);
   end;
end;

begin
   DoIt;
   s.Free;
end;

procedure UpdateLampsAll;
var
   i: Integer;
begin
   if MailerForms <> nil then begin
      MailerForms.Enter;
      for i := 0 to MailerForms.Count - 1 do TMailerForm(MailerForms.At(i)).UpdateLamps;
      MailerForms.Leave;
   end;
end;

