unit IPCfg;

{$I DEFINE.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  mGrids, Recs, StdCtrls, ComCtrls, MClasses, Buttons, xBase, ExtCtrls;

type
  TResolveThread = class(T_Thread)
     numb: integer;
     iadr: string;
     fqdn: string;
     procedure InvokeExec; override;
     class function ThreadName: string; override;
  end;

  TIPcfgForm = class(TForm)
    bOK: TButton;
    bCancel: TButton;
    bHelp: TButton;
    tb: TPageControl;
    lGeneral: TTabSheet;
    lNodes: TTabSheet;
    llInPorts: TLabel;
    gIn: TAdvGrid;
    llLimit: TGroupBox;
    llCin: TLabel;
    llCout: TLabel;
    gOvr: TAdvGrid;
    lStation: TTabSheet;
    gTpl: TAdvGrid;
    lRestrict: TTabSheet;
    spIn: TxSpinEdit;
    spOut: TxSpinEdit;
    bImport: TButton;
    lBanner: TTabSheet;
    eBan: TMemo;
    lAKA: TTabSheet;
    gAKA: TAdvGrid;
    lEvents: TTabSheet;
    lAvl: TListBox;
    labelAvl: TLabel;
    labelLinked: TLabel;
    bRight: TSpeedButton;
    bLeft: TSpeedButton;
    bEdit: TSpeedButton;
    lLnk: TListBox;
    bSort: TButton;
    p: TPageControl;
    tsRequired: TTabSheet;
    gReqd: TAdvGrid;
    tsForbidden: TTabSheet;
    gForb: TAdvGrid;
    bEditNode: TButton;
    lDNS: TTabSheet;
    gDNS: TAdvGrid;
    bExplain: TButton;
    lAuxNodes: TLabel;
    eAuxNode: TEdit;
    rgProxyType: TRadioGroup;
    GroupBox1: TGroupBox;
    llAssumeSpeedin: TLabel;
    llAssumeSpeedOut: TLabel;
    spSPin: TxSpinEdit;
    spSPout: TxSpinEdit;
    lSocksAddr: TEdit;
    lSocksPort: TEdit;
    lPassword: TEdit;
    llPassword: TLabel;
    lUserName: TEdit;
    llUserName: TLabel;
    cbAuth: TCheckBox;
    bvlSOCKS: TBevel;
    llSocksAddr: TLabel;
    llSocksPort: TLabel;
    spBL: TxSpinEdit;
    llAssumeSpeed: TLabel;
    cbEncryptPassword: TCheckBox;
    cbAllVIaProxy: TCheckBox;
    tsPOP3: TTabSheet;
    gSMTP: TAdvGrid;
    tsSMTP: TTabSheet;
    gPOP3: TAdvGrid;
    tsNNTP: TTabSheet;
    lNNTPImport: TLabel;
    gNNTP: TAdvGrid;
    xSpinCash: TxSpinEdit;
    lCache: TLabel;
    lCash2: TLabel;
    gbCache: TGroupBox;
    tsBList: TTabSheet;
    gBList: TAdvGrid;
    TM: TTimer;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bImportClick(Sender: TObject);
    procedure bHelpClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure tbChange(Sender: TObject);
    procedure lAvlClick(Sender: TObject);
    procedure bRightClick(Sender: TObject);
    procedure bLeftClick(Sender: TObject);
    procedure bEditClick(Sender: TObject);
    procedure bUPClick(Sender: TObject);
    procedure bDNClick(Sender: TObject);
    procedure bSortClick(Sender: TObject);
    procedure bEditNodeClick(Sender: TObject);
    procedure cbSOCKSClick(Sender: TObject);
    procedure lAvlKeyPress(Sender: TObject; var Key: Char);
    procedure lLnkKeyPress(Sender: TObject; var Key: Char);
    procedure lAvlDblClick(Sender: TObject);
    procedure lLnkDblClick(Sender: TObject);
    procedure bExplainClick(Sender: TObject);
    procedure TMTimer(Sender: TObject);
  private
    EvtChanged: Boolean;
    FSocksPort: Integer;
    AvlEvts,
    LnkEvts: TEventColl;
    CurEvtIds: PIntArray;
    CurEvtCnt: Integer;
    OrgEvtIds: PIntArray;
    OrgEvtCnt: Integer;
    GenCRC: DWORD;
    Ovr: TIPNodeOvrColl;
    RTh: TResolveThread;
    Activated: Boolean;
    procedure EvtUpdateLists;
    procedure EvtRefillLists;
    procedure EvtUpdateButtons;
    procedure EvtUpdateEvt;
    procedure SetData;
    function GeneralCRC: DWORD;
    function AllOK: Boolean;
    function NdOvrVld: Boolean;
    procedure UpdateSocks;
  public
  end;

function SetupIP(APageIndex: Integer): Boolean;

implementation

uses
   LngTools, xFido, AltRecs, xEvents, OvrExpl, TracePl, Wizard,
   RadIni, RadSav, WSock;

{$R *.DFM}

function SetupIP;
var
   IPcfgForm: TIPcfgForm;
begin
   IPcfgForm := TIPcfgForm.Create(Application);
   case APageIndex of
   2: IPcfgForm.tb.ActivePage := IPcfgForm.lAKA;
   4: IPcfgForm.tb.ActivePage := IPcfgForm.lRestrict;
   end;
   IPcfgForm.SetData;
   IPcfgForm.tb.ActivePageIndex := SavFile.ReadInteger('IPCfg', 'Page', 0);
   IPCfgForm.RTh := TResolveThread.Create;
   IPCfgForm.RTh.Suspended := False;
   Result := IPcfgForm.ShowModal = mrOK;
   IPCfgForm.RTh.Terminated := True;
   IPCfgForm.RTh.WaitFor;
   FreeObject(IPCfgForm.RTh);
   SavFile.WriteInteger('IPCfg', 'Page', IPcfgForm.tb.ActivePageIndex);
   if Result and IPcfgForm.EvtChanged then begin
      RecalcEvents := True;
      SetEvt(oRecalcEvents);
   end;
   FreeObject(IPcfgForm);
   if Result then PostMsg(WM_SETUPOK);
end;

function TIPcfgForm.GeneralCRC: DWORD;
var
   s: TStringColl;
   i: DWORD;
begin
   s := TStringColl.Create;
   gIn.GetData(s);
   i := s.Crc32(CRC32_INIT);
   FreeObject(s);
   i := CRC32Int(spIn.Value, i);
   i := CRC32Int(spOut.Value, i);
   i := UpdateCRC32(Byte(rgProxyType.ItemIndex), i); // visual
   i := CRC32Str(lSocksPort.Text, i);
   i := CRC32Str(lSocksAddr.Text, i);
   Result := i;
end;

procedure TIPcfgForm.SetData;
var
   i: integer;
  s1: string;
begin
   gIn.SetData([Cfg.IPData.InPorts]);
   gTpl.SetData([Cfg.IPData.StationData]);
   gReqd.SetData(Cfg.IPData.Restriction.Required);
   gForb.SetData(Cfg.IPData.Restriction.Forbidden);
   spIn.Value := Cfg.IPData.InC;
   spOut.Value := Cfg.IPData.OutC;
   spSPin.Value := IniFile.InBandwidth; // visual
   spSPout.Value := IniFile.OutBandwidth; // visual
   spBL.Value := Cfg.IPData.BList;
   if spBL.Value > 100 then begin
      spBL.Value := 3;
   end;
   SetNodeOvr(Cfg.IPNodeOverrides, gOvr);
   eAuxNode.Text := Trim(Cfg.IPNodeOverrides.AuxFile);
   eBan.SetTextBuf(PChar(Cfg.IPData.Banner));
   gAKA.SetData([Cfg.IpAkaCollA, Cfg.IpAkaCollB]);
   gDNS.SetData([Cfg.IPDomA, Cfg.IPDomB, AltCfg.ipDomC]);
   xSpinCash.Value := IniFile.CashSize div (1024 * 1024);

   for i := 0 to gDNS.RowCount - 1 do begin
      if trim(gDNS.Cells[3, i]) = '' then begin
         gDNS.Cells[3, i] := ExtractWord(1, gDNS.Cells[2, i], ['.']);
      end;
      if pos(gDNS.Cells[3, i], gDNS.Cells[2, i]) > 0 then begin
         s1 := gDNS.Cells[2, i];
         replace(gDNS.Cells[3, i] + '.', '', s1);
         gDNS.Cells[2, i] := s1;
      end else
      if copy(gDNS.Cells[2, i], 1, 1) = '.' then gDNS.Cells[2, i] := '';
   end;

   IniFile.LoadGrid(gSMTP);
   IniFile.LoadGrid(gPOP3);
   IniFile.LoadGrid(gNNTP);
   SavFile.LoadGrid('Black_List', gBList);
   for i := 1 to gBList.RowCount - 1 do begin
      gBList.Cells[3, i] := '';
   end;

   rgProxyType.ItemIndex := Integer(IniFile.ProxyType); // visual
   lSocksAddr.Text := Cfg.Proxy.Addr;
   lSocksPort.Text := IntToStr(Cfg.Proxy.Port);
   cbAuth.Checked := IniFile.EnableProxyAuth;
   lUserName.Text := IniFile.ProxyUserName;
   lPassword.Text := IniFile.ProxyPassword;
   cbAllViaProxy.Checked := IniFile.AllViaProxy;
   cbEncryptPassword.Checked := IniFile.EncryptProxyPassword;

   GenCRC := GeneralCRC;
   CurEvtCnt := Cfg.IpEvtIds.EvtCnt;
   OrgEvtCnt := Cfg.IpEvtIds.EvtCnt;
   GetMem(CurEvtIds, CurEvtCnt * SizeOf(Integer));
   GetMem(OrgEvtIds, OrgEvtCnt * SizeOf(Integer));
   Move(Cfg.IpEvtIds.EvtIds^, CurEvtIds^, CurEvtCnt * SizeOf(Integer));
   Move(Cfg.IpEvtIds.EvtIds^, OrgEvtIds^, OrgEvtCnt * SizeOf(Integer));
   EvtRefillLists;
end;

procedure TIPcfgForm.FormActivate(Sender: TObject);
begin
   if Activated then Exit;
   GridFillRowLng(gIn, rsIPInR);
   GridFillColLng(gIn, rsIPInC);
   GridFillColLng(gOvr, rsIPOvr);
   GridFillRowLng(gTpl, rsIPTpl);
   GridFillColLng(gAKA, rsIPAKA);
   GridFillColLng(gDNS, rsIPDNS);
   GridFillColLng(gSMTP, rsIpSMTP);
   GridFillColLng(gPOP3, rsIpPOP3);
   GridFillColLng(gNNTP, rsIPNNTP);
   GridFillColLng(gBList, rsIPBList);
   lSocksAddr.Width := llSocksPort.Left - lSocksAddr.Left - 6;
   UpdateSocks;
   Activated := True;
end;

procedure TIPcfgForm.FormCreate(Sender: TObject);
begin
   FillForm(Self, rsIPcfgForm);
   AvlEvts := TEventColl.Create;
   LnkEvts := TEventColl.Create;
   Ovr := TIPNodeOvrColl.Create;
end;

procedure TIPcfgForm.FormDestroy(Sender: TObject);
begin
   FreeObject(Ovr);
   FreeObject(AvlEvts);
   FreeObject(LnkEvts);
   if CurEvtIds <> nil then FreeMem(CurEvtIds, CurEvtCnt * SizeOf(Integer));
   if OrgEvtIds <> nil then FreeMem(OrgEvtIds, OrgEvtCnt * SizeOf(Integer));
end;

function TIPcfgForm.NdOvrVld: Boolean;
begin
   Result := NodeOvrValid(Ovr, gOvr, Handle, False);
end;

function ValidDNSGrid(gDNS: TAdvGrid; AHandle: DWORD): Boolean;
var
  s1,
  s2,
  s3: TStringColl;
   s: string;
   i: Integer;
begin
   Result := True;
   s1 := TStringColl.Create;
   s2 := TStringColl.Create;
   s3 := TStringColl.Create;
   gDNS.GetData([s1, s2, s3]);
   for i := 0 to CollMax(s1) do begin
      s := s1[i];
      if not ValidMaskAddressList(s, AHandle) then begin
         Result := False;
         Break;
      end;
   end;
   FreeObject(s1);
   FreeObject(s2);
   FreeObject(s3);
end;

function TIPcfgForm.AllOK: Boolean;

function ChkRestr(SC: TStringColl; const C: string): Boolean;
var
   Msgs: TStringColl;
begin
   Msgs := TStringColl.Create;
   Result := ValidRestrictionColl(SC, Msgs, rspIP);
   if not Result then begin
      tb.ActivePage := lRestrict;
      DisplayErrorFmtLng(rsIPInvC, [C, Msgs.LongString], Handle);
   end;
   FreeObject(Msgs);
end;

function RestrOK: Boolean;
var
   R,
   F: TStringColl;
begin
   R := TStringColl.Create; gReqd.GetData(R);
   F := TStringColl.Create; gForb.GetData(F);
   Result := ChkRestr(R, 'Required') and ChkRestr(F, 'Forbidden');
   FreeObject(R);
   FreeObject(F);
end;

function SocksValid: Boolean;
var
   s: string;
begin
   Result := False;
   s := _DelSpaces(lSocksPort.Text);
   FSocksPort := Vl(s);
   if (FSocksPort < 1) or (FSocksPort > 65535) then begin
      if s = '' then s := 'EMPTY';
      DisplayError(Format('Valus of Socks Port (%s) is not valid', [s]), Handle);
      Exit;
   end;
   Result := True;
end;

begin
   Result := False;
   if not ValidateAddrs(gTpl[1, 1], Handle) then begin
      tb.ActivePage := lStation;
      Exit;
   end;
   if not RestrOK then begin
      tb.ActivePage := lRestrict;
      Exit;
   end;
   if not ValidAKAGrid(gAKA) then begin
      tb.ActivePage := lAKA;
      Exit;
   end;
   if not ValidDNSGrid(gDNS, Handle) then begin
      tb.ActivePage := lDNS;
      Exit;
   end;
   if not NdOvrVld then begin
      tb.ActivePage := lNodes;
      Exit;
   end;
   if not ValidateAddrsMask(gPOP3, 1, 4, Handle) then begin
      tb.ActivePage := tsSMTP;
      Exit;
   end;
   if not ValidateAddrsMask(gNNTP, 1, 0, Handle) then begin
      tb.ActivePage := tsNNTP;
      Exit;
   end;
   if not SocksValid then Exit;
   Result := True;
end;

procedure TIPcfgForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
   if ModalResult <> mrOK then Exit;
   CanClose := AllOK;
end;

procedure TIPcfgForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
   s: string;
   z: string;
   i: Integer;
begin
   if ModalResult <> mrOK then Exit;
   s := Trim(eAuxNode.Text);
   CfgEnter;
   gIn.GetData([Cfg.IPData.InPorts]);
   gTpl.GetData([Cfg.IPData.StationData]);
   gAka.GetData([Cfg.IpAkaCollA, Cfg.IpAkaCollB]);
   for i := 0 to gDNS.RowCount - 1 do begin
      gDNS.Cells[2, i] := gDNS.Cells[3, i] + '.' + gDNS.Cells[2, i];
   end;
   gDNS.GetData([Cfg.IpDomA, Cfg.IpDomB, AltCfg.ipDomC]);
   gReqd.GetData(Cfg.IPData.Restriction.Required);
   gForb.GetData(Cfg.IPData.Restriction.Forbidden);
   IniFile.SaveGrid(gSMTP);
   for i := 1 to gPOP3.Rowcount - 1 do begin
      z := gPOP3.Cells[0, i];
      if length(z) > 0 then begin
         if z[1] in ['a'..'z', 'A'..'Z'] then begin
            z := '"' + z + '"';
            gPOP3.Cells[0, i] := z;
         end;
      end;
   end;
   IniFile.SaveGrid(gPOP3);
   IniFile.SaveGrid(gNNTP);
   SavFile.SaveGrid('Black_List', gBList);
   Cfg.IPData.InC := spIn.Value;
   Cfg.IPData.OutC := spOut.Value;
   Cfg.IPData.BList := spBL.Value;
   Cfg.IPData.Banner := ControlString(eBan);
   Ovr.AuxFile := s;
   Xchg(Integer(Cfg.IPNodeOverrides), Integer(Ovr));
   EvtUpdateEvt;
   if Cfg.IpEvtIds.EvtCnt > 0 then FreeMem(Cfg.IpEvtIds.EvtIds, Cfg.IpEvtIds.EvtCnt*SizeOf(Integer));

   if not EvtChanged then begin
      if CurEvtCnt <> OrgEvtCnt then EvtChanged := True else begin
         for i := 0 to CurEvtCnt - 1 do begin
            if CurEvtIds^[i] <> OrgEvtIds^[i] then begin
               EvtChanged := True;
               Break;
            end;
         end;
      end;
   end;

   Cfg.IpEvtIds.EvtCnt := CurEvtCnt; CurEvtCnt := 0;
   Cfg.IpEvtIds.EvtIds := CurEvtIds; CurEvtIds := nil;
   Cfg.Proxy.Addr := lSocksAddr.Text;
   Cfg.Proxy.Port := FSocksPort;
   Cfg.Proxy.Enabled := rgProxyType.ItemIndex > 0;

   CfgLeave;
   StoreConfig(Handle);
   AltStoreConfig(Handle);

   IniFile.ProxyType := TProxyType(rgProxyType.ItemIndex);
   IniFile.EnableProxyAuth := cbAuth.Checked;
   IniFile.ProxyUserName := lUserName.Text;
   IniFile.ProxyPassword := lPassword.Text;
   IniFile.AllViaProxy := cbAllViaProxy.Checked;
   IniFile.EncryptProxyPassword := cbEncryptPassword.Checked;

   IniFile.InBandwidth := spSPin.Value;
   IniFile.OutBandwidth := spSPout.Value;
   IniFile.CashSize := xSpinCash.Value * 1024 * 1024;

   IniFile.StoreCfg;

   if DaemonStarted and (GenCRC <> GeneralCRC) then DisplayInfoLng(rsIPRestart, Handle);
   PostMsg(WM_IMPORTIPOVRL);
end;

procedure TIPcfgForm.bImportClick(Sender: TObject);
begin
   if not AllOK then Exit;
   DoImportOp(Ovr, gOvr, False, False);
end;

procedure TIPcfgForm.bHelpClick(Sender: TObject);
begin
   Application.HelpContext(HelpContext);
end;

procedure TIPcfgForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   if Key = VK_F1 then bHelp.Click;
end;

procedure TIPcfgForm.tbChange(Sender: TObject);
var
   v: Boolean;
begin
   v := tb.ActivePage.Tag = 8769;
   bImport.Visible := v;
   bSort.Visible := v;
   bEditNode.Visible := v;
   bExplain.Visible := tb.ActivePage.Tag = 8767;
end;

procedure TIPcfgForm.EvtUpdateLists;
begin
   FillListBoxNamed(lAvl, AvlEvts);
   FillListBoxNamed(lLnk, LnkEvts);
   EvtUpdateButtons;
end;

procedure TIPcfgForm.EvtRefillLists;
begin
   AvlEvts.FreeAll;
   LnkEvts.FreeAll;
   TossItems(AvlEvts, LnkEvts, Pointer(Cfg.Events.Copy), CurEvtIds, CurEvtCnt);
   EvtUpdateLists;
end;

procedure TIPcfgForm.EvtUpdateButtons;
begin
   bRight.Enabled := AvlEvts.Count > 0;
   bLeft.Enabled := LnkEvts.Count > 0;
end;

procedure TIpCfgForm.EvtUpdateEvt;
var
   i: Integer;
begin
   CurEvtCnt := LnkEvts.Count;
   ReallocMem(CurEvtIds, CurEvtCnt * SizeOf(Integer));
   for i := 0 to CurEvtCnt - 1 do begin
      CurEvtIds^[i] := TElement(LnkEvts[i]).Id;
   end;
end;

procedure TIPcfgForm.lAvlClick(Sender: TObject);
begin
   EvtUpdateButtons;
end;

procedure TIPcfgForm.bRightClick(Sender: TObject);
begin
   MoveColl(AvlEvts, LnkEvts, lAvl.ItemIndex);
   EvtUpdateLists;
end;

procedure TIPcfgForm.bLeftClick(Sender: TObject);
begin
   MoveColl(LnkEvts, AvlEvts, lLnk.ItemIndex);
   EvtUpdateLists;
end;

procedure TIPcfgForm.bEditClick(Sender: TObject);
begin
   EvtUpdateEvt;
   if SetupEvents then begin
      EvtRefillLists;
      EvtChanged := True;
   end;
end;

procedure TIPcfgForm.bUPClick(Sender: TObject);
begin
  {}
end;

procedure TIPcfgForm.bDNClick(Sender: TObject);
begin
  {}
end;

procedure TIPcfgForm.bSortClick(Sender: TObject);
begin
   if not NdOvrVld then Exit;
   Ovr.Sort(_OvrSort);
   SetNodeOvr(Ovr, gOvr);
end;

procedure TIPcfgForm.bEditNodeClick(Sender: TObject);
var
   C: TColl;
 Msg,
Item: string;
 Idx: Integer;
begin
   if not NdOvrVld then Exit;
   Idx := gOvr.Row - 1;
   if (Idx < 0) or (Idx >= Ovr.Count) then Exit;
   C := ParseOverride(TNodeOvr(Ovr[Idx]).Ovr, Msg, Item, False);
   if CollCount(C) > 0 then begin
      if EditOverrideEx(C, False, TNodeOvr(Ovr[Idx]).Addr) then gOvr[2, Idx + 1] := OvrColl2Str(C);
   end;
   FreeObject(C);
end;

procedure TIPcfgForm.cbSOCKSClick(Sender: TObject);
begin
   UpdateSocks;
end;

procedure TIPcfgForm.UpdateSocks;
var
   b: Boolean;
begin
   b := rgProxyType.ItemIndex > 0;
   llSocksAddr.Enabled := b;
   lSocksAddr.Enabled := b;
   llSocksPort.Enabled := b;
   lSocksPort.Enabled := b;

   lUserName.Enabled := cbAuth.Checked;
   llUserName.Enabled := cbAuth.Checked;
   lPassword.Enabled := cbAuth.Checked;
   llPassword.Enabled := cbAuth.Checked;
end;

procedure TIPcfgForm.lAvlKeyPress(Sender: TObject; var Key: Char);
begin
   if Key = ' ' then bRight.Click;
end;

procedure TIPcfgForm.lLnkKeyPress(Sender: TObject; var Key: Char);
begin
   if Key = ' ' then bLeft.Click;
end;

procedure TIPcfgForm.lAvlDblClick(Sender: TObject);
begin
   bRight.Click;
end;

procedure TIPcfgForm.lLnkDblClick(Sender: TObject);
begin
   bLeft.Click;
end;

procedure TIPcfgForm.bExplainClick(Sender: TObject);
var
Strs: TStringColl;
   d: TRestrictionData;
begin
   if not CloseQuery then Exit;
   Strs := TStringColl.Create;
   d := TRestrictionData.Create;
   d.Required := TStringColl.Create;
   d.Forbidden := TStringColl.Create;
   gReqd.GetData(d.Required);
   gForb.GetData(d.Forbidden);
   ReportRestrictionData(Strs, d);
   FreeObject(d);
   DisplayInfoFormEx(LngStr(rsExplIpRS), Strs);
   FreeObject(Strs);
end;

class function TResolveThread.ThreadName: string;
begin
   Result := 'Resolver';
end;

procedure TResolveThread.InvokeExec;
var
   w: DWORD;
   h: PHostEnt;
begin
   if (iadr <> '') and (fqdn = '') then begin
      w := inet_addr(PChar(iadr));
      if w <>  INADDR_NONE then begin
         h := GetHostByAddr(@w, SizeOf(w), AF_INET);
         if h <> nil then begin
            fqdn := h.h_name;
         end else begin
            fqdn  := '-Unresolved-';
         end;
      end;
   end else begin
      Sleep(100);
   end;
end;

procedure TIPcfgForm.TMTimer(Sender: TObject);
var
   i: integer;
begin
   if (RTh.iadr = '') then begin
      for i := 1 to gBList.RowCount - 1 do begin
         if (gBList.Cells[1, i] <> '') and (gBList.Cells[3, i] = '') then begin
            RTh.numb := i;
            RTh.iadr := gBList.Cells[1, i];
            exit;
         end;
      end;
   end else
   if (RTh.fqdn <> '') then begin
      gBList.Cells[3, RTh.numb] := RTh.fqdn;
      RTh.iadr := '';
      RTh.fqdn := '';
   end;
end;

end.

