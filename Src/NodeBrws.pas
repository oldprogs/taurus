unit NodeBrws;

interface

{$I DEFINE.INC}


uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  ComCtrls, StdCtrls, ExtCtrls, xFido, MClasses, Menus;

type
  TNodelistBrowser = class(TForm)
    Tree: TTreeView;
    pnInfo: TTransPan;
    pnAddrInfo: TTransPan;
    lAddress: TTransEdit;
    lStation: TTransEdit;
    lSysop: TTransEdit;
    lLocation: TTransEdit;
    lPhone: TTransEdit;
    lSpeed: TTransEdit;
    lFlags: TTransEdit;
    lWrkTimeUTC: TTransEdit;
    lWrkTimeLocal: TTransEdit;
    llWrkTimeLocal: TLabel;
    llWrkTimeUTC: TLabel;
    llFlags: TLabel;
    llSpd: TLabel;
    llPhn: TLabel;
    llSite: TLabel;
    llSysop: TLabel;
    llStat: TLabel;
    llAddr: TLabel;
    lStatus: TTransEdit;
    pnAddrSearch: TTransPan;
    bHelp: TButton;
    bCancel: TButton;
    bOK: TButton;
    eAddress: TEdit;
    llAddrSearch: TLabel;
    pnDivider: TPanel;
    lFlagsIp: TTransEdit;
    llFlagsIp: TLabel;
    bvlInfo: TBevel;
    PM: TPopupMenu;
    Export1: TMenuItem;
    procedure FormActivate(Sender: TObject);
    procedure TreeCollapsed(Sender: TObject; Node: TTreeNode);
    procedure TreeExpanding(Sender: TObject; Node: TTreeNode; var AllowExpansion: Boolean);
    procedure TreeClick(Sender: TObject);
    procedure TreeChange(Sender: TObject; Node: TTreeNode);
    procedure eAddressKeyPress(Sender: TObject; var Key: Char);
    procedure eAddressChange(Sender: TObject);
    procedure TreeExpanded(Sender: TObject; Node: TTreeNode);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bHelpClick(Sender: TObject);
    procedure Export1Click(Sender: TObject);
  private
    { Private declarations }
    Activated: Boolean;
    StartText: string;
  public
    DataSorted: Boolean;
  end;

procedure BrowseNodes;
function BrowseAtNode(const Addr: TFidoAddress): Boolean;
function SelectNode(var Addr: TFidoAddress): Boolean;

implementation

uses xBase, NdlUtil, CommCtrl, LngTools, Wizard, RadIni;

{$R *.DFM}

function _SelectNode(var Addr: TFidoAddress; PBaseAddr: PFidoAddress): Boolean;
var
  D: TNodelistBrowser;
begin
  try
    D := TNodelistBrowser.Create(Application);
    if (PBaseAddr <> nil) and (PBaseAddr^.Zone <> 0) then D.StartText := Addr2Str(PBaseAddr^);
    Result := (D.ShowModal = mrOK) and (ParseAddress(D.lAddress.Text, Addr));
  finally
    FreeObject(D);
  end;
end;

function SelectNode(var Addr: TFidoAddress): Boolean;
begin
  Result := _SelectNode(Addr, @Addr);
end;

procedure BrowseNodes;
var a: TFidoAddress;
begin
  FillChar(a, SizeOf(a), #0);
  SelectNode(a);
end;

function BrowseAtNode(const Addr: TFidoAddress): Boolean;
var
  a: TFidoAddress;
begin
  Result := GetListedNode(Addr) <> nil;
  if Result then _SelectNode(a, @Addr);
end;

procedure AddMore(Tree: TTreeView; Carrier: TTreeNode; Node: TFidoNode);
begin
  case GetNodeType(Node) of
    fntPoint: Exit;
    fntNode: if not Node.HasPoints then Exit;
  end;
  Tree.Items.AddChild(Carrier, '');
end;

procedure AddNode(Tree: TTreeView; Carrier: TTreeNode; Node: TFidoNode);
var
  N: TTreeNode;
  s: string;
begin
  s := '';
  if Node = nil then exit;
  case GetNodeType(Node) of
    fntZone:
       if inifile.D5Out then s := Format('Zone %d (%s), ', [Node.Addr.Zone, Node.Addr.Domain])
                        else s := Format('Zone %d, ', [Node.Addr.Zone]);
    fntRegion: s := Format('Region %d, ', [Node.Addr.Net]);
    fntNet: s := Format('Net %d, ', [Node.Addr.Net]);
    fntHub: s := Format('Hub %d, ', [Node.Addr.Node]);
    fntNode:
    begin
      case Node.PrefixFlag of
        nfPvt, nfHold, nfDown: s := Format(' (%s)', [cNodePrefixFlag[Node.PrefixFlag]]);
      end;
      s := Format('Node %d%s, ', [Node.Addr.Node, s]);
    end;
    fntPoint: s := Format('Point %d, ', [Node.Addr.Point]);
  end;
  N := Tree.Items.AddChildObject(Carrier, Format('%s%s, %s', [s, Node.Station, Node.Sysop]), Node);
  Node.TreeItem := N.ItemId;
  AddMore(Tree, N, Node);
end;

procedure AddPoints(Tree: TTreeView; Carrier: TTreeNode; Node: TFidoNode);
var
  Idx: Integer;
  ZC: TZoneContainer;
  i: Integer;
  ni: TNetNodeIdx;
  Addr: TFidoAddress;
begin
  EnterNlCs;
  Idx := NodeController.GetNetIdx(Node.Addr.Zone, Node.Addr.Net, Node.Addr.Domain);
  ZC := NodeController.SeekNet(Idx, Node.Addr.Zone, Node.Addr.Net, Node.Addr.Domain);
  Addr.Domain := Node.Addr.Domain;
  Addr.Zone := Node.Addr.Zone;
  Addr.Net := Node.Addr.Net;
  for i := 0 to zc.Count - 1 do
  begin
    ni := zc[i];
    if ni.Addr.Point = 0 then Continue;
    if ni.Addr.Node <> Node.Addr.Node then Continue;
    Addr.Node := ni.Addr.Node;
    Addr.Point := ni.Addr.Point;
    AddNode(Tree, Carrier, GetListedNode(Addr));
  end;
  LeaveNlCs;
end;

procedure AddNodes(Hubs: Boolean; Tree: TTreeView; Carrier: TTreeNode; Node: TFidoNode);
var
  Idx: Integer;
  ZC: TZoneContainer;
  I: Integer;
  ni: TNetNodeIdx;

procedure Add;
var
  a: TFidoAddress;
  N: TFidoNode;
begin
  a.Zone := Node.Addr.Zone;
  a.Net := Node.Addr.Net;
  a.Node := ni.Addr.Node;
  a.Point := ni.Addr.Point;
  a.Domain := Node.Addr.Domain;
  N := GetListedNode(a);
  AddNode(Tree, Carrier, N);
end;

var
  J: Integer;

begin
  EnterNlCs;
  {if (not Hubs) and (GetNodeType(Node) = fntHub)then} AddPoints(Tree, Carrier, Node);
  Idx := NodeController.GetNetIdx(Node.Addr.Zone, Node.Addr.Net, Node.Addr.Domain);
  ZC := NodeController.SeekNet(Idx, Node.Addr.Zone, Node.Addr.Net, Node.Addr.Domain);
  for J := 0 to Integer(Hubs) do
  for I := 0 to zc.Count - 1 do
  begin
    ni := zc[i];
    if ni.Addr.Node = 0 then Continue;
    if ni.Addr.Point <> 0 then Continue;
    if (ni.Hub = 0) or (ni.Hub = ni.Addr.Node) then
    begin
      if Hubs then
      begin
        if (ni.Hub = 0) = (J = 0) then Add;
      end;
    end else
    begin
      if (not Hubs) and (Node.Addr.Node = ni.Hub) then Add;
    end;
  end;
  LeaveNlCs;
end;

procedure AddNets(Regions: Boolean; Tree: TTreeView; Carrier: TTreeNode; Node: TFidoNode);
var
  NodeAddrNet,i: Integer;
  Z: TZoneContainer;
  ZC, RC: TFidoNode;
  ZCA, RCA: TFidoAddress;
  ZCS: TColl;
  b: Boolean;
begin
  EnterNlCs;
  ZCS := TColl.Create;
  if NodeController <> nil then
  begin
{    if Regions then
    begin
      // ??
    end else
    begin}
      NodeAddrNet := Node.Addr.Net;
//    end;
    i := -1;
    FillChar(ZCA, sizeof(ZCA), #0);
    FillChar(RCA, sizeof(ZCA), #0);
    while i < NodeController.Table.Count - 1 do
    begin
      Inc(i);
      Z := NodeController.Table[i];
      if z.ZoneData.Domain <> Node.Addr.Domain then Continue;
      if Z.ZoneData.Zone <> Node.Addr.Zone then Continue;

      if Regions then
      begin
        b := (Z.ZoneData.Net <> Z.ZoneData.Zone) and (Z.ZoneData.Net <> 0);
        if b then
        begin
          if (Z.ZoneData.Net) <> (Z.ZoneData.Region) then
          begin
            RCA.Domain := Z.ZoneData.Domain;
            RCA.Zone := Z.ZoneData.Zone;
            RCA.Net := Z.ZoneData.Net;
            RCA.Node := 0;
            RCA.Point := 0;
            RC := GetListedNode(RCA);
            b := (RC = nil) or (Z.ZoneData.Region = 0); // to show hosts w/o region
          end;
        end;
      end else
      begin
         b := (Z.ZoneData.Net <> Z.ZoneData.Region) and (NodeAddrNet = Z.ZoneData.Region);
      end;

      if b then
      begin
        ZCA.Domain := Z.ZoneData.Domain;
        ZCA.Zone := Z.ZoneData.Zone;
        ZCA.Net := Z.ZoneData.Net;
        ZC := GetListedNode(ZCA);
        if ZC <> nil then ZCS.Insert(ZC);
      end;
    end;
  end;
  LeaveNlCs;
  if NodeController <> nil then
  begin
    AddPoints(Tree, Carrier, Node);
    // Add indnodes
    AddNodes(True, Tree, Carrier, Node);
    for i := 0 to ZCS.Count - 1 do
    begin
      ZC := ZCS[i];
//      Application.ProcessMessages;
      AddNode(Tree, Carrier, ZC);
    end;
  end;
  ZCS.DeleteAll;
  FreeObject(ZCS);
end;

procedure AddSubNode(Tree: TTreeView; Carrier: TTreeNode; Node: TFidoNode);
begin
  case GetNodeType(Node) of
    fntZone:
      begin
        // Add regions of zone
        AddNets(True, Tree, Carrier, Node);
      end;
    fntRegion:
      begin
        // Add nets of regions
        AddNets(False, Tree, Carrier, Node);
      end;
    fntNet:
      begin
        AddNodes(True, Tree, Carrier, Node);
      end;
    fntHub:
      begin
        AddNodes(False, Tree, Carrier, Node);
      end;
    fntNode:
      begin
        AddPoints(Tree, Carrier, Node);
      end;
  end;
end;

procedure TNodelistBrowser.FormActivate(Sender: TObject);
var
  i: Integer;
  Z: TZoneContainer;
  ZC: TFidoNode;
  ZCA: TFidoAddress;
  ZCS: TColl;
begin
  if Activated then Exit;
  Activated := True;
  EnterNlCS;
  if NodeController = nil then NodeController := TNodeController.Create;
  ZCS := TColl.Create('');
  if NodeController <> nil then
  begin
    ZCA.Net := 0; ZCA.Node := 0; ZCA.Point := 0; ZCA.Domain := '';
    i := -1;
    while i < NodeController.Table.Count - 1 do
    begin
      Inc(i);
      Z := NodeController.Table[i];
      if ((Z.ZoneData.Net = Z.ZoneData.Zone) and (Z.ZoneData.Region = 0)) or (Z.ZoneData.Net = 0) then
      begin
        ZCA.Domain := Z.ZoneData.Domain;
        ZCA.Zone := Z.ZoneData.Zone;
        ZCA.Net := Z.ZoneData.Net;
        ZC := GetListedNode(ZCA);
        if ZC <> nil then ZCS.Insert(ZC);
      end;
    end;
  end;
  LeaveNlCS;
  if (NodeController = nil) or (ZCS.Count = 0) then
  begin
    DisplayErrorLng(rsNBNoNdl, Handle);
    _PostMessage(Handle, WM_CLOSE, 0, 0);
  end else
  begin
    for i := 0 to ZCS.Count - 1 do
    begin
      ZC := ZCS[i];
      AddNode(Tree, nil, ZC);
    end;
  end;
  ZCS.DeleteAll;
  FreeObject(ZCS);
  if StartText <> '' then eAddress.Text := StartText;
end;

procedure DeleteNode(Tree: TTreeView; Node: TTreeNode);
var
  N: TTreeNode;
  F: TFidoNode;
begin
  repeat
    N := Node.GetFirstChild;
    if N = nil then Break;
    DeleteNode(Tree, N);
  until False;
  F := Node.Data; if F <> nil then Integer(F.TreeItem) := 0;
  Tree.Items.Delete(Node);
end;

procedure TNodelistBrowser.TreeCollapsed(Sender: TObject; Node: TTreeNode);
var
  N: TTreeNode;
begin
  repeat
    N := Node.GetFirstChild;
    if N = nil then Break;
    DeleteNode(Tree, N);
  until False;
  AddMore(Tree, Node, TFidoNode(Node.Data));
end;

procedure TNodelistBrowser.TreeExpanding(Sender: TObject; Node: TTreeNode; var AllowExpansion: Boolean);
begin
  AllowExpansion := not Node.Expanded;
  if AllowExpansion then 
    AddSubNode(Tree, Node, TFidoNode(Node.Data));
end;

procedure SetCap(L: TEdit; const S: String);
begin
  L.Text := S;
end;

const Flags = ',ICM,INA,IP,TCP,IBN,BND,BINKP,IFC,ITN,IVM,IFT,ITX,IMI,IEM,ISE,IUC,GUUCP,DOM,DO4,DO3,DO2,DO1';

function DUFlags(const s: string): string;
var t,
    f: string;
begin
   t := s;
   Result := '';
   while t <> '' do begin
      GetWrd(t, f, ',');
      if pos(',' + ExtractWord(1, f, [':']), Flags) = 0 then begin
         Result := Result + ',' + f;
      end;
   end;
   Delete(Result, 1, 1);
end;

function IPFlags(const s: string): string;
var t,
    f: string;
begin
   t := s;
   Result := '';
   while t <> '' do begin
      GetWrd(t, f, ',');
      if pos(',' + ExtractWord(1, f, [':']), Flags) > 0 then begin
         Result := Result + ',' + f;
      end;
   end;
   Delete(Result, 1, 1);
end;

procedure TNodelistBrowser.TreeClick(Sender: TObject);
var
  N: TTreeNode;
  D: TFidoNode;
  s: string;
begin
  N := Tree.Selected;
  if N = nil then Exit;
  D := N.Data;
  lAddress.Text := Addr2Str(D.Addr);
  SetCap(lStation, D.Station);
  SetCap(lSysop, D.Sysop);
  SetCap(lLocation, D.Location);
  SetCap(lPhone, D.Phone);
  SetCap(lFlags, DUFlags(D.Flags));
  SetCap(lFlagsIP, IPFlags(D.Flags));
  s := FSC62TimeToStr(NodeFSC62TimeEx(D.Flags, D.Addr, False));
  SetCap(lWrkTimeUTC, s);
  s := FSC62TimeToStr(NodeFSC62TimeEx(D.Flags, D.Addr, True));
  SetCap(lWrkTimeLocal, s);
  SetCap(lStatus, cNodePrefixFlag[D.PrefixFlag]);
  lSpeed.Text := IntToStr(D.Speed);
end;

procedure TNodelistBrowser.TreeChange(Sender: TObject; Node: TTreeNode);
begin
  TreeClick(nil);
end;

procedure TNodelistBrowser.eAddressKeyPress(Sender: TObject; var Key: Char);
  var S: String;
      K: Char;
begin
  S := eAddress.Text;
  K := Key;
  Key := #0;
  if K in [':', '/', '.', '@'] then
    begin
      if Pos(K, S) > 0 then Exit;
    end;
  case K of
    #8,#27,'/',':','.','@': ;
    '0'..'9': ;
    'a'..'z',
    'A'..'Z': if pos('@', S) = 0 then exit;
     else Exit;
  end;
  Key := K;
end;

procedure TNodelistBrowser.eAddressChange(Sender: TObject);
var
  Addr: TFidoAddress;
  {I, }L: Integer;
  ExitNow: Boolean;
  S,S2: String;
  T: TNodeType;
  N: TFidoNode;
  TN: TTreeNode;
  HI: HTreeItem;
  R,k: integer;
  TmpAd: TFidoAddress;
  cls: boolean;

  procedure Expand(Zone, Net, Node, Point: Integer; const Domain: string);
  var
    TmpAddr: TFidoAddress;
    NN: TFidoNode;
    HI: HTreeItem;
  begin
    TmpAddr.Zone := Zone;
    TmpAddr.Net := Net;
    TmpAddr.Node := Node;
    TmpAddr.Point := Point;
    TmpAddr.Domain := Domain;
    NN := GetListedNode(TmpAddr);
    if NN <> nil then
    begin
      HI := NN.TreeItem;
      if HI = nil then
      begin
//        GlobalFail('%s', ['TNodelistBrowser.eAddressChange NN.TreeItem = nil']);
//        WinDlgT('TNodelistBrowser.eAddressChange NN.TreeItem = nil');
        cls := true;
        exit;
      end;
      TN := Tree.Items.GetNode(HI);
      if TN = nil then
      begin
//        GlobalFail('%s', ['TNodelistBrowser.eAddressChange Tree.Items.GetNode(HI) = nil']);
        WinDlgT('TNodelistBrowser.eAddressChange Tree.Items.GetNode(HI) = nil');
        cls := true;
        exit;
      end;
      if not TN.Expanded then TN.Expand(False);
    end;
    ExitNow := CompareAddrs(Addr, TmpAddr) = 0;
    if ExitNow then TN.Selected := True;
  end;

{var

REP: TPCRE;
b: boolean;}

begin
  FillChar(Addr, SizeOf(Addr), 0);
  S := eAddress.Text;
  L := Length(S);
  cls := false;
  if L = 0 then Exit;
  if (S[1] = ':') and (L = 1) then
  begin
    S2 := Addr2Str(IniFile.MainAddr);
    k := Pos(':', S2) - 1;
    S := Copy(S2, 1, k);
    L := k;
    TEdit(Sender).Text := S + ':';
    TEdit(Sender).SelStart := L + 1;
  end else
  if (S[1] = '.') and (L = 1) then
  begin
    S2 := Addr2StrEx(IniFile.MainAddr);
    k := Pos('.', S2) - 1;
    S := Copy(S2, 1, k);
    L := k;
    TEdit(Sender).Text := S + '.';
    TEdit(Sender).SelStart := L + 1;
  end else
  if (S[1]='/') and (L = 1) then
  begin
    S2 := Addr2Str(IniFile.MainAddr);
    k := Pos('/', S2) - 1;
    S := Copy(S2, 1, k);
    L := k;
    TEdit(Sender).Text := S + '/';
    TEdit(Sender).SelStart := L + 1;
  end else
  if S[L] = ':' then S := S + Copy(S, 1, L - 1) + '/0.0' else
    if S[L] = '/' then S := S + '0.0' else
     if S[L] = '.' then S := S + '0';
  if Pos(':', S) = 0 then S := S + ':' + S + '/0.0' else
   if Pos('/', S) = 0 then S := S + '/0.0' else
    if (Pos('.', S) = 0) and (Pos('@', S) = 0) then S := S + '.0';
(*  REP := GetRegExpr('^\d{1,5}\:\d{1,5}\/\d{1,5}\.?\d{0,5}$');
  b:=(REP.ErrPtr = 0) and (REP.Match(trim(s)) > 0);
  REP.Unlock;
  if not b then exit;
  Addr.Zone:=StrToInt(ExtractWord(1,Trim(s),[':']));
  Addr.Net:=StrToInt(ExtractWord(2,Trim(s),[':','/']));
  Addr.Node:=StrToInt(ExtractWord(3,Trim(s),[':','/','.']));
  Addr.Point:=StrToIntDef(ExtractWord(4,Trim(s),[':','/','.']),0);*)
  if not ParseAddress(S, Addr) then Exit;
  N := GetListedNode(Addr);
  if N = nil then Exit;
  HI := N.TreeItem;
  R := N.Region;
  if Integer(HI) <> 0 then
  begin
    Tree.Selected := Tree.Items.GetNode(HI);
    Exit;
  end;

  EnterNlCS;
  for t := fntZone to fntPoint do
  begin
    case t of
      fntZone:
        Expand(Addr.Zone, Addr.Zone, 0, 0, Addr.Domain);
      fntRegion:
        begin
{          I := Addr.Net; while i > 99 do i := i div 10;
          Expand(Addr.Zone, i, 0, 0);}
          Expand(Addr.Zone, R, 0, 0, Addr.Domain);
        end;
      fntNet:
        begin
          Expand(Addr.Zone, Addr.Net, 0, 0, Addr.Domain);
        end;
      fntHub:
        begin
          Expand(Addr.Zone, Addr.Net, N.Hub, 0, Addr.Domain);
        end;
      fntNode:
        begin
          Expand(Addr.Zone, Addr.Net, Addr.Node, 0, Addr.Domain);
        end;
      fntPoint:
        begin
          TmpAd.Zone := Addr.Zone;
          TmpAd.Net := Addr.Net;
          TmpAd.Node := Addr.Node;
          TmpAd.Point := 0;
          TmpAd.Domain := Addr.Domain;
          if GetListedNode(TmpAd) = nil then
          begin
            DisplayErrorFmtLng(rsNBBoNotLtd, [Addr2Str(Addr)], handle);
            exit;
          end;
          Tree.Items.GetNode(N.TreeItem).Selected := True;
        end;
    end;
    if ExitNow then Break;
    if cls then exit;
  end;
  LeaveNlCS;
end;

procedure TNodelistBrowser.TreeExpanded(Sender: TObject; Node: TTreeNode);
begin
  Tree.Items.Delete(Node.GetFirstChild);
end;

procedure TNodelistBrowser.FormDestroy(Sender: TObject);
var
  i, c: Integer;
  p: PItemList;
  x3: TRadMFRec;
  wp: MClasses._TWindowPlacement;
begin
  wp.length := sizeof(wp);
  if not GetWindowPlacement(handle, @wp) then GlobalFail('WindowPlacement error %d', [GetLastError]);
  if WindowState = wsMaximized then
  begin
    x3.Maximized := 1;
    if wp.rcNormalPosition.Left > - (wp.rcNormalPosition.Right - wp.rcNormalPosition.Left) then //DV: 07.08.01
       x3.Bounds[0] := wp.rcNormalPosition.Left
    else x3.Bounds[0] := -4;
    if wp.rcNormalPosition.Top < Screen.Height {+ height} then //DV: 07.08.01
       x3.Bounds[1] := wp.rcNormalPosition.Top
    else x3.Bounds[1] := -4;
    x3.Bounds[2] := wp.rcNormalPosition.Right  - wp.rcNormalPosition.Left;
    x3.Bounds[3] := wp.rcNormalPosition.Bottom - wp.rcNormalPosition.Top;
    IniFile.RadNB := x3;
  end
  else begin
    x3.Maximized := 0;
    if wp.rcNormalPosition.Left > - (wp.rcNormalPosition.Right - wp.rcNormalPosition.Left) then //DV: 07.08.01
       x3.Bounds[0] := wp.rcNormalPosition.Left                   //DV: 07.08.01
    else x3.Bounds[0] := -4;                                     //DV: 07.08.01
    if wp.rcNormalPosition.Top + height > 0  then              //DV: 11.02.02 - bugfix
       x3.Bounds[1] := wp.rcNormalPosition.Top                    //DV: 07.08.01
    else x3.Bounds[1] := -4;                                     //DV: 07.08.01
    x3.Bounds[2]  := Width;
    x3.Bounds[3]  := Height;
    IniFile.RadNB := x3;
  end;
  if NodeController = nil then Exit;
  EnterNlCS;
  p := NodeController.Cache.FList;
  c := NodeController.Cache.Count - 1;
  for i := 0 to c do Integer(TFidoNode(p^[i]).TreeItem) := 0;
  LeaveNlCS;
end;

procedure TNodelistBrowser.FormCreate(Sender: TObject);
begin
   if ((IniFile.RadNB.Bounds[0] <> 32767) and
       (IniFile.RadNB.Bounds[1] <> 32767) and
       (IniFile.RadNB.Bounds[2] <> 32767) and
       (IniFile.RadNB.Bounds[3] <> 32767)) and
       (IniFile.RadNB.Bounds[0] < screen.Width) and
       (IniFile.RadNB.Bounds[1] + IniFile.RadNB.Bounds[3] > 0) then
   begin
      SetBounds(IniFile.RadNB.Bounds[0], IniFile.RadNB.Bounds[1], IniFile.RadNB.Bounds[2], IniFile.RadNB.Bounds[3]);
   end;
   if IniFile.RadNB.Maximized = 1 then WindowState := wsMaximized;
   FillForm(Self, rsNodelistBrowser);
end;

procedure TNodelistBrowser.bHelpClick(Sender: TObject);
begin
  Application.HelpContext(HelpContext);
end;

procedure TNodelistBrowser.Export1Click(Sender: TObject);
var
   a: TFidoAddress;
   n: TFidoNode;
   c: TFidoNodeColl;
   f: TextFile;
   m: TextFile;
   i: integer;
   p: string;
begin
   if Tree.Selected <> nil then begin
      n := Tree.Selected.Data;
      a := n.Addr;
      c := GetScope(a);
      if c <> nil then begin
         AssignFile(f, 'Segment1.txt');
         Rewrite(f);
         AssignFile(m, 'Segment2.txt');
         Rewrite(m);
         for i := 0 to CollMax(c) do begin
            n := c[i];
            p := '    ';
            if n.PrefixFlag = nfPvt then p := 'Pvt ' else
            if n.PrefixFlag = nfHold then p := 'Hold' else
            if n.PrefixFlag = nfDown then p := 'Down';
            Writeln(f, p, ' ', Addr2Str(n.Addr), ' ', n.Sysop);
            Writeln(m, n.Sysop, ' ', Addr2Str(n.Addr));
         end;
         CloseFile(f);
         CloseFile(m);
      end;
   end;
end;

end.
