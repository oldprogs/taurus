unit NdlUtil;

interface

{$I DEFINE.INC}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  StdCtrls, ExtCtrls, xBase, xFido;

type
  TNodelistCompiler = class(TForm)
    bStop: TButton;
    llStatus: TLabel;
    lStatus: TLabel;
    llNodes: TLabel;
    lNodes: TLabel;
    llNets: TLabel;
    lNets: TLabel;
    llCurFile: TLabel;
    lFile: TLabel;
    lPoints: TLabel;
    llPoints: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure TimerTimer(Sender: TObject);
  private
    Timer: TTimer;
  public
    C: T_Thread;
    Auto: Boolean;
    OK: Boolean;
    procedure WMSetOK(var Msg: TMessage); message WM_SETOK;
  end;

var
   NodelistCompiler: TNodelistCompiler;
   NodelistMissed,
   NodelistCompilation: Boolean;

type
   PNodePoint = ^TNodePoint;
   TNodePoint = record Node, Point: Integer end;

   TShortNodeIdx = packed record
     Len: Byte;
     Hub, Node, Point: Word;
   end;

   PShortNodeIdxArr = ^TShortNodeIdxArr;
   TShortNodeIdxArr = packed array[0..(MaxInt - 3) div SizeOf(TShortNodeIdx)] of TShortNodeIdx;

   TNetNodeIdx = class
     Ofs: Integer;
     Hub: word;
    Addr: TNodePoint;
   end;

   TZoneContainer = class(TSortedColl)
     ZoneData: TFidoZoneData;
     Sz, NumNodes, MemPos: Integer;
     function Compare(Key1, Key2: Pointer): Integer; override;
     function KeyOf(Item: Pointer): Pointer; override;
   end;

   TTableColl = class(TSortedColl)
     CarePos: Boolean;
     function Compare(Key1, Key2: Pointer): Integer; override;
     function KeyOf(Item: Pointer): Pointer; override;
   end;

   TNodeController = class
     Table: TTableColl;
     Stream: TDosStream;
     Cache: TFidoNodeColl;
     ZonesBin: TxMemoryStream;
     Lists: TStringList;
     constructor Create;
     function SearchNode(const Addr: TFidoAddress): TFidoNode;
     destructor Destroy; override;
     function SeekNet(Idx, Zone, Net: Integer; const Domain: string): TZoneContainer;
     function SearchNodeOfNet(ZoneIdx: Integer; const Addr: TFidoAddress): TFidoNode;
     function GetNetIdx(Zone, Net: Integer; const Domain: string): Integer;
   end;

function FindNode(const Addr: TFidoAddress): TAdvNode;
function GetScope(const Addr: TFidoAddress): TFidoNodeColl;
function GetListedNode(const Addr: TFidoAddress): TFidoNode;
procedure FreeNodeController;
procedure EnterNlCS;
procedure LeaveNlCS;
procedure InitNdlUtil;
procedure DoneNdlUtil;
procedure PurgeAdvNodeCache;
function IPFlags(const CM: boolean; const a, f: string): string;
function FindIPAddr(const fn: TFidoNode): string;

var
   NodeController: TNodeController;

implementation

uses Recs, AltRecs, LngTools, RadIni, Wizard, CfgFiles, Plus;

{$R *.DFM}

const
   NodelistVersion = 12;

var
   NodeControllerCS: TRTLCriticalSection;
   NetTablePos: DWORD;
   FileHandle: DWORD;

procedure EnterNlCS;
begin
   EnterCS(NodeControllerCS);
end;

procedure LeaveNlCS;
begin
   LeaveCS(NodeControllerCS);
end;

function TTableColl.Compare(Key1, Key2: Pointer): Integer;
var
   a: PFidoZoneData absolute Key1;
   b: PFidoZoneData absolute Key2;
begin
   if inifile.D5Out then
   if a^.Domain > b^.Domain then Result :=  1 else
   if a^.Domain < b^.Domain then Result := -1 else Result := 0
                            else Result := 0;
   if Result = 0 then Result := a^.Zone - b^.Zone;
   if Result = 0 then Result := a^.Net - b^.Net;
   if CarePos then if Result = 0 then Result := b^.Pos - a^.Pos;
end;

function TTableColl.KeyOf(Item: Pointer): Pointer;
begin
   Result := @TZoneContainer(Item).ZoneData;
end;

var
   PhantomNodes: TColl;

procedure FreeNodeController;
begin
   EnterNlCs;
   FreeObject(NodeController);
   FreeObject(PhantomNodes);
   LeaveNlCs;
end;

type
   TZoneOfsColl = class(TSortedColl)
     function Compare(Key1, Key2: Pointer): Integer; override;
     function KeyOf(Item: Pointer): Pointer; override;
   end;

function TZoneOfsColl.Compare(Key1, Key2: Pointer): Integer;
begin
   Result := Integer(Key1^) - Integer(Key2^);
end;

function TZoneOfsColl.KeyOf(Item: Pointer): Pointer;
begin
   Result := @TZoneContainer(Item).ZoneData.Pos;
end;

constructor TNodeController.Create;
var
   ZOC: TZoneOfsColl;
   I: integer;
   J: integer;
   S: string;
   L: TStringList;

function DoCreate: Boolean;
var
   Actually: DWORD;
   I,
   J,
   N: Integer;
  ZC: TZoneContainer;
begin
   Result := False;
   if Stream.Read(i, 4) <> 4 then Exit; // version
   if i <> - NodelistVersion then Exit;
   if Stream.Read(NetTablePos, 4) <> 4 then Exit;
   if (NetTablePos >= DWORD(MaxInt)) or (SetFilePointer(Stream.Handle, NetTablePos, nil, FILE_BEGIN) <> NetTablePos) then Exit;
   if Stream.Read(N, 4) <> 4 then Exit;
   if (N < 0) or (N > $FFFF) then Exit;
   for i := 1 to N do begin
      ZC := TZoneContainer.Create;
      ZC.MemPos := -1;
      if (not ReadFile(Stream.Handle, ZC.ZoneData, SizeOf(TFidoZoneData), Actually, nil)) or (SizeOf(TFidoZoneData) <> Actually) then begin
         ZC.Free;
         Exit;
      end;
      Table.Insert(ZC);
      ZOC.Insert(ZC);
   end;
   for J := 0 to ZOC.Count - 1 do begin
      ZC := ZOC[J];
      if J = ZOC.Count - 1 then N := NetTablePos else N := TZoneContainer(ZOC[J + 1]).ZoneData.Pos;
      Dec(N, ZC.ZoneData.Pos + 4);
      ZC.Sz := N;
   end;
   ZOC.DeleteAll;
   Result := True;
end;

begin
   try
      EnterNlCs;
      inherited Create;
      ZonesBin := GetMemoryStream;
      Cache := TFidoNodeColl.Create;
      Table := TTableColl.Create;
      Table.Duplicates := True;
      Table.CarePos := True;
      Stream := OpenRead(NDLPath);
      if Stream = nil then begin
         NodelistMissed := True;
         Exit;
      end;
      ZOC := TZoneOfsColl.Create;
      if not DoCreate then begin
         FreeObject(Stream);
         DeleteFile(PChar(NDLPath));
         Table.FreeAll;
      if not NodelistMissed then
      begin
            NodelistMissed := True;
         end;
      end;
      ZOC.FreeAll;
      FreeObject(ZOC);
      Table.CarePos := False;
      Lists := TStringList.Create;
      if IniFile.AutoNodelist then begin
         s := JustPathName(ParamStr(0)) + '\nodelist.sav';
         l := TStringList.Create;
         with TIniFile.Create(s) do begin
            try
               ReadSection('TimeList', l);
               for i := 0 to l.Count - 1 do begin
                  j := Lists.Add(l[i]);
                  Lists.Objects[j] := Pointer(ReadInteger('TimeList', l[i], 0));
               end;
            finally
               l.Free;
               Free;
            end;
         end;
      end;
   finally
      LeaveNlCs;
   end;
end;

function TNodeController.SeekNet(Idx, Zone, Net: Integer; const Domain: string): TZoneContainer;
var
   zc: TZoneContainer;
  nia: PShortNodeIdxArr;

procedure Look(Dir: Integer);
var
   I,
   J: Integer;
   P: Pointer;
 zca: TZoneContainer;
begin
   i := idx;
   repeat
      Inc(i, dir);
      if (i < 0) or (i >= Table.Count) then Break;
      zca := Table[i];
      if (zc.ZoneData.Zone <> zca.ZoneData.Zone) or
         (zc.ZoneData.Region <> zca.ZoneData.Region) or
         (zc.ZoneData.Net <> zca.ZoneData.Net) or
         (zc.ZoneData.Domain <> zca.ZoneData.Domain) then Break;
      if zca.MemPos <> -1 then GlobalFail('TNodeController.SeekNet(%d,%d,%d) zca.MemPos(%d) <> -1', [Idx, Zone, Net, zca.MemPos]);
      Stream.Position := zca.ZoneData.Pos;
      Stream.Read(J, 4);
      ReallocMem(nia, (zc.NumNodes + J) * SizeOf(TShortNodeIdx));
      Stream.Read(nia^[zc.NumNodes], J * SizeOf(TShortNodeIdx));
      Inc(zc.NumNodes, J);
      J := zca.Sz - J * SizeOf(TShortNodeIdx);
      GetMem(P, J);
      Stream.Read(P^, J);
      ZonesBin.Write(P^, J);
      FreeMem(P, J);
      Table.AtFree(i);
      Dec(i, dir);
   until False;
end;

var
   I,
   J,
   K: Integer;
  ni: TNetNodeIdx;
   P: Pointer;
 sni: TShortNodeIdx;
 zca: TZoneContainer;

begin
//   EnterNlCs;
   Result := nil;
   zc := Table[Idx];
   if zc.MemPos = -1 then begin
      I := Idx;
      while I > 0 do begin
         Dec(i);
         zca := Table[i];
         if (zc.ZoneData.Zone <> zca.ZoneData.Zone) or
            (zc.ZoneData.Region <> zca.ZoneData.Region) or
            (zc.ZoneData.Net <> zca.ZoneData.Net) or
            (zc.ZoneData.Domain <> zca.ZoneData.Domain) then Break;
         zc := zca;
         if zc.MemPos <> -1 then GlobalFail('TNodeController.SeekNet(%d,%d,%d) zc.MemPos(%d) <> -1', [Idx, Zone, Net, zc.MemPos]);
         Idx := i;
      end;
      zc.MemPos := ZonesBin.Size;
      ZonesBin.Position := ZonesBin.Size;
      Stream.Position := zc.ZoneData.Pos;
      Stream.Read(zc.NumNodes, 4);
      J := zc.Sz - zc.NumNodes * SizeOf(TShortNodeIdx);
      if J < 1 then exit;
      nia := nil;
      ReallocMem(nia, zc.NumNodes * SizeOf(TShortNodeIdx));
      Stream.Read(nia^, zc.NumNodes * SizeOf(TShortNodeIdx));

      GetMem(P, J);
      Stream.Read(P^, J);
      ZonesBin.Write(P^, J);
      FreeMem(P, J);

      Look(+1);

      J := zc.MemPos;
      for I := 0 to zc.NumNodes - 1 do begin
         sni := nia^[I];
         ni := TNetNodeIdx.Create;
         ni.Ofs := J; Inc(J, sni.Len);
         ni.Hub := sni.Hub;
         ni.Addr.Node := sni.Node;
         ni.Addr.Point := sni.Point;
         if zc.Search(zc.KeyOf(ni), K) then FreeObject(ni) else zc.AtInsert(K, ni);
      end;
      ReallocMem(nia, 0);
    { J - prevnode, K - Hub }
      J := -1;
      for I := 0 to zc.Count - 1 do begin
         ni := zc[I];
         if ni.Addr.Point = 0 then begin
            J := ni.Addr.Node;
            K := ni.Hub;
         end else begin
            if ni.Addr.Node = J then ni.Hub := K;
         end;
      end;
   end;
   Result := zc;
//   LeaveNlCs;
end;

function TNodeController.SearchNodeOfNet(ZoneIdx: Integer; const Addr: TFidoAddress): TFidoNode;
var
  TN: TFidoNode;
   I: Integer;
  zc: TZoneContainer;
   a: TNodePoint;
  ni: TNetNodeIdx;
begin
   Result := nil;
   zc := SeekNet(ZoneIdx, Addr.Zone, Addr.Net, Addr.Domain);
   a.Node := Addr.Node;
   a.Point := Addr.Point;
   if zc.Search(@a, I) then begin
      TN := TFidoNode.Create;
      ni := zc[I];
      ZonesBin.Position := ni.Ofs;
      TN.FillStream(Addr.Zone, Addr.Net, ZonesBin);
      TN.Hub := ni.Hub;
      TN.Region := zc.ZoneData.Region;
      if (TN.Addr.Point = 0) and (zc.Count > I + 1) then begin
         ni := zc[I + 1];
         TN.HasPoints := ni.Addr.Node = TN.Addr.Node;
      end;
      Result := TN;
   end;
end;

function TNodeController.GetNetIdx(Zone, Net: Integer; const Domain: string): Integer;
var
   z: TFidoZoneData;
begin
   z.Zone := Zone;
   z.Net := Net;
   z.Domain := LowerCase(Domain);
   if not Table.Search(@z, Result) then Result := -1;
end;

function TNodeController.SearchNode;
var
   J: Integer;
begin
   Result := nil;
      if Cache.Search(@Addr, J) then begin
         Result := Cache[J];
         Exit;
      end;
   J := GetNetIdx(Addr.Zone, Addr.Net, Addr.Domain);
   if J <> -1 then Result := SearchNodeOfNet(J, Addr);
   if Result <> nil then Cache.Insert(Result);
end;

destructor TNodeController.Destroy;
var
   s: string;
   i: integer;
begin
   if IniFile.AutoNodelist then begin
      s := JustPathName(ParamStr(0)) + '\nodelist.sav';
      with TIniFile.Create(s) do begin
         try
            EraseSection('TimeList');
            for i := 0 to Lists.Count - 1 do begin
               WriteInteger('TimeList', Lists[i], Integer(Lists.Objects[i]));
            end;
         finally
            Free;
         end;
      end;
   end;
   Lists.Free;
   FreeObject(ZonesBin);
   FreeObject(Stream);
   if PhantomNodes = nil then PhantomNodes := TColl.Create;
   PhantomNodes.Concat(Cache);
   FreeObject(Cache);
   Table.FreeAll;
   FreeObject(Table);
   NodeController := nil;
   inherited Destroy;
end;

type
   TZoneRt = record
     Zone: Integer;
     Domain: string[8];
   end;

   TZoneRoot = class
     Zone: Integer;
     FoundZC: Boolean;
     Domain: string[8];
   end;

   TZoneRootColl = class(TSortedColl)
     function Compare(Key1, Key2: Pointer): Integer; override;
     function KeyOf(Item: Pointer): Pointer; override;
   end;

   TCompileThread = class(T_Thread)
     SleepTimer: EventTimer;
     Addr: TFidoAddress;
     CompiledPoints,
     CompiledNodes,
     CompiledNets: Integer;
     Sorting: Boolean;
     D: TNodelistCompiler;
     CurFile: String;
     Error: String;
     ZCs: TZoneRootColl;
     constructor Create(AD: TNodelistCompiler);
     destructor Destroy; override;
     procedure InvokeExec; override;
     procedure UpdateStatus;
     class function ThreadName: string; override;
   end;

class function TCompileThread.ThreadName: string;
begin
   Result := 'Nodelist Compiler';
end;

constructor TCompileThread.Create;
begin
   inherited Create;
   NewTimer(SleepTimer, 1);
   ZCs := TZoneRootColl.Create;
   D := AD;
   CompiledNets := 0;
   CompiledNodes := 0;
   CompiledPoints := 0;
   Resume;
end;

procedure TCompileThread.UpdateStatus;
begin
   D.TimerTimer(D.Timer);
end;

procedure TNodelistCompiler.WMSetOK;
begin
   if OK then Exit;
   TCompileThread(C).UpdateStatus;
   FreeObject(Timer);
   OK := True;
   if Auto then PostMessage(Handle, WM_CLOSE, 0, 0) else begin
      bStop.Caption := 'OK';
      lStatus.Caption := LngStr(rsNdlFinished);
      lFile.Caption := '';
   end;
end;

function CompareZones(P1, P2: Pointer): Integer;
var
   K1,
   K2: String[10];
begin
   K1 := Format('%-5d%-5d', [TFidoZone(P1).d.Net, TFidoZone(P2).d.Net]);
   K2 := Copy(K1, 6, 5); K1[0] := #5;
   if TFidoZone(P1).d.Domain < TFidoZone(P2).d.Domain then Result := -1 else
   if TFidoZone(P1).d.Domain > TFidoZone(P2).d.Domain then Result :=  1 else
      if TFidoZone(P1).d.Zone < TFidoZone(P2).d.Zone then Result := -1 else
      if TFidoZone(P1).d.Zone > TFidoZone(P2).d.Zone then Result :=  1 else
         if K1 < K2 then Result := -1 else
         if K1 > K2 then Result := 1 else
            if TFidoZone(P1).d.Net < TFidoZone(P2).d.Net then Result := -1 else
            if TFidoZone(P1).d.Net > TFidoZone(P2).d.Net then Result := 1 else
{              if TFidoZone(P1).d.First < TFidoZone(P2).d.First then Result := -1 else
              if TFidoZone(P1).d.First > TFidoZone(P2).d.First then Result := 1 else}
                 Result := 0;
end;

procedure TCompileThread.InvokeExec;
var
   S: ShortString;
   SL: Byte absolute S;
  PCCount: Integer;
   CurHub, CurRegion,
   OldZone, OldNet,
   OldRegion: word;
   OldDomain: string[8];
   ST: DWORD;
   Zones: TColl;
   PC: TFidoNet;
   MS: TxMemoryStream;
   Point: Boolean;

   procedure SetZC(Zone: Integer; const Domain: string);
   var
      I: Integer;
      ZS: TZoneRt;
      ZR: TZoneRoot;
   begin
      ZS.Zone := Zone;
      ZS.Domain := LowerCase(Domain);
      if not ZCs.Search(@ZS, I) then begin
         ZR := TZoneRoot.Create;
         ZR.Domain := LowerCase(Domain);
         ZR.Zone := Zone;
         ZCs.AtInsert(I, ZR);
      end;
   end;

  procedure NewNet;
  var
     P: TFidoZone;
     T: TFidoZone;
     I,
     K: Integer;
     J,
     D: DWORD;
    TN: TFidoNode;
    SI: TShortNodeIdx;
    Actually: DWORD;
  begin
     if PCCount > 0 then begin
        SetZC(OldZone, OldDomain);
        P := TFidoZone.Create;
        P.d.Region := OldRegion;
        P.d.Zone := OldZone;
        P.d.Domain := OldDomain;

















































        if OldNet = 0 then
        begin
          if (OldDomain = 'fidonet') or
            ((OldDomain = '') and (OldZone in [1..7])) then
          OldNet := OldZone;
          P.d.Region := 0;
        end;
        if OldNet = 0 then
          P.d.Region := 0
        else
          P.d.Region := OldRegion;
        P.d.Net := OldNet;
        P.d.Pos := SetFilePointer(ST, 0, nil, FILE_CURRENT);
        P.d.First := 0;
        for k := 0 to Zones.Count - 1 do begin
           T := Zones[k];
           if CompareZones(T, P) = 0 then begin
              T := Zones[k];
              T.d.Region := P.d.Region;
              Zones[k] := T;
           end;
        end;
        Zones.Add(P);
        D := PCCount;
        TN := PC[0];
        P.d.First := TN.Addr.Node;
        MS.Position := 0;
        MS.Write(D, 4);
        if MS.Capacity < SizeOf(TShortNodeIdx) * D * 2 then MS.Capacity := SizeOf(TShortNodeIdx) * D * 4;
        MS.Position := 4 + SizeOf(TShortNodeIdx) * D;
        for I := 0 to PCCount - 1 do begin
           TN := PC[I];
           J := MS.Position;
           TN._Store(MS);
           DWORD(TN.TreeItem) := MS.Position - J;
        end;
        I := MS.Position;
        MS.Position := 4;
        for K := 0 to PCCount - 1 do begin
           TN := PC[K];
           SI.Len := Integer(TN.TreeItem);
           SI.Hub := TN.Hub;
           SI.Node := TN.Addr.Node;
           SI.Point := TN.Addr.Point;
           MS.Write(SI, SizeOf(SI));
        end;
        WriteFile(ST, MS.Memory^, I, Actually, nil);
        Inc(CompiledNets);
        PCCount := 0;
     end;
     OldZone := Addr.Zone;
     OldRegion := CurRegion;
     OldNet := Addr.Net;
     OldDomain := Addr.Domain;
  end;

  function Add(var X: Integer; Flag: TNodePrefixFlag): TFidoNode;
  var
     I,
     J: Integer;
     P: TFidoNode;
     C: Char;
  begin
     Result := nil;
     I := 0;
     J := 1;
     while J < SL do begin
        C := S[J];
        if C = ',' then Break;
        I := (I * 10) + Ord(C) - Ord('0');
        if (I = 0) or (I > 65535) then Exit;
        Inc(J);
     end;
     X := I;
     if (OldDomain <> Addr.Domain) or (OldZone <> Addr.Zone) or (OldNet <> Addr.Net) then NewNet;
     if PCCount < PC.Count then P := PC[PCCount] else P := TFidoNode.Create;
     P.FillNodelist(Addr, Copy(S, J + 1, 255), Flag);
     P.Hub := CurHub;
     if p.Addr.net = 0 then
        P.Region := 0
     else
        P.Region := CurRegion;
     if Flag = nfPoint then Inc(CompiledPoints) else Inc(CompiledNodes);
     if PCCount < PC.Count then PC.AtPut(PCCount, P) else PC.AtInsert(PCCount, P);
     Inc(PCCount);
     Result := P;
  end;

  function AddPoint(var X: Integer): TFidoNode;
  begin
     Result := Add(X, nfPoint);
  end;

  procedure AddNode(Flag: TNodePrefixFlag);
  begin
     Addr.Point := 0;
     if (IniFile.MainReg = 0) and (CompareAddrs(Addr, IniFile.MainAddr) = 0) then begin
        IniFile.MainReg := CurRegion;
        IniFile.StoreCfg;
     end;
     Add(Addr.Node, Flag);
     if TimerExpired(SleepTimer) then begin
        Sleep(50);
        NewTimer(SleepTimer, 10);
     end;
  end;

  procedure AddHub;
  var
     N: TFidoNode;
  begin
     Addr.Point := 0;
     N := Add(Addr.Node, nfHub);
     if N <> nil then begin
        CurHub := Addr.Node;
        N.Hub := CurHub;
     end;
  end;

  procedure SetBoss(const Domain: string);
  var
     i:integer;
  begin
     FillChar(Addr, SizeOf(Addr), 0);
     ParseAddress(ExtractWord(1, S, [',']), Addr);
     Addr.Domain := LowerCase(Domain);
     CurRegion := 0;
     CurHub := 0;
     for i := 0 to Zones.Count - 1 do begin
        if (TFidoZone(Zones.At(i)).d.Domain = Addr.Domain) and
           (TFidoZone(Zones.At(i)).d.Zone = Addr.Zone) and
           (TFidoZone(Zones.At(i)).d.Net = Addr.Net) then CurRegion := TFidoZone(Zones.At(i)).d.Region;
     end;
     Point := True;
  end;

  procedure SetNet;
  begin
     Addr.Node := 0; Addr.Point := 0; CurHub := 0;
     Add(Addr.Net, nfNet);
  end;

  procedure SetRegion;
  begin
     OldRegion := CurRegion;
     Addr.Node := 0; Addr.Point := 0; CurHub := 0; CurRegion := 0;
     Add(Addr.Net, nfRegion);
     CurRegion := Addr.Net;
  end;

  procedure SetZone;
  var
     I: Integer;
    ZS: TZoneRt;
    ZR: TZoneRoot;
  begin
     Addr.Net := 0; Addr.Node := 0; Addr.Point := 0; CurHub := 0; CurRegion:=0;
     Add(Addr.Zone, nfZone);
     SetZC(Addr.Zone, Addr.Domain);
     ZS.Zone := Addr.Zone;
     ZS.Domain := Addr.Domain;
     if not ZCs.Search(@ZS, I) then GlobalFail('%s', ['TCompileThread.ThreadExec | SetZone']);
     ZR := ZCs[i];
     ZR.FoundZC := True;
  end;

  function CompileFile(FName: String; const Domain: String; PointList: boolean): boolean;
  var
     SR: TSearchRec;
     Mask: String;
     I: Integer;
     DT: Integer;
     ZS: TZoneRt;
     S1: ShortString;
     S1L: byte absolute S1;
     F: TTextReader;
     C: Char;
     SSR: String;
     zmet,
     rmet,
     IsRegEx: Boolean;

  begin
     result := false;
     zmet := false;
     rmet := false;
     FillChar(Addr, SizeOf(Addr), 0);
     Addr.Domain := LowerCase(Domain);

     Mask := ExtractFileName(FName);
     IsRegEx := StrQuotePartEx(Mask, '~', #3, #4) <> Mask;
     S := ExtractFilePath(FName);
     if IsRegEx then FName := S + '*.*' else Replace('%', '?', FName);
     I := SysUtils.FindFirst(FName, faAnyFile, SR);
     FName := ''; DT := 0;
     while I = 0 do begin
        if _MatchMask(SR.Name, Mask, True ) and (Abs(DT) < SR.Time) and (SR.Attr and faDirectory = 0) then begin
           FName := S + SR.Name;
           DT := SR.Time
        end;
        I := SysUtils.FindNext(SR);
     end;
     if DT > 0 then begin
        I := NodeController.Lists.IndexOf(FName);
        if I = -1 then begin
           I := NodeController.Lists.Add(FName);
        end;
        NodeController.Lists.Objects[i] := Pointer(Plus.GetFileTime(FName));
     end;
     FindClose(SR);
     if FName = '' then Exit;
     CurFile := FName;
     F := CreateTextReader(FName);
     if F = nil then Exit;
     while (not F.EOF) and (not Terminated) do begin
        SSR := F.GetStr;
        if (SSR <> '') and (SSR[1] <> ';') and (Length(SSR) < 250) then begin
           S := SSR;
           I := 1;
           C := #0;
           while I <= SL do begin
              C := S[I];
              if C = ',' then Break;
              S1[I] := UpCase(C);
              Inc(I);
           end;
           if C <> ',' then Continue;
           S1L := I - 1;
           Move(S[I + 1], S[1], SL - I);
           Dec(SL, I);
           if (S1 = '') then begin
              if Point then AddPoint(Addr.Point) else AddNode(nfNormal)
           end else
           if (S1 = 'POINT') then AddPoint(Addr.Point) else
           if (S1 <> 'BOSS') and
              (S1 <> 'ZONE') and
              (S1 <> 'REGION') and
              (S1 <> 'HOST') and
              (S1 <> 'HUB') and Point then AddPoint(Addr.Point) else
           begin
              Point := False;
              if ((S1 = 'HUB') or
                  (S1 = 'HOST') or (S1 = 'REGION') or
                  (S1 = 'ZONE') or (S1 = 'PVT') or
                 (S1 = 'HOLD') or (S1 = 'DOWN')) and pointlist then
              begin
                 F.OwesStream := true;
                 FreeObject(F);
                 exit;
              end;
              if S1 = 'HUB' then AddHub else
              if S1 = 'BOSS' then SetBoss(Domain) else
              if S1 = 'HOST' then begin
                 if not zmet then begin
                    Addr.Zone := IniFile.MainAddr.Zone;
                    if Domain = '' then begin
                       Addr.Domain := LowerCase(IniFile.MainAddr.Domain);
                    end;
                    if not rmet then begin
                       curregion := IniFile.MainReg;
                    end;
                 end else begin
                    if not rmet then begin
                       curregion := 0;
                    end;
                 end;
                 SetNet;
              end else
              if S1 = 'REGION' then begin
                 if not zmet then begin
                    Addr.Zone := IniFile.MainAddr.Zone;
                    if Domain = '' then begin
                       Addr.Domain := LowerCase(IniFile.MainAddr.Domain);
                    end;
                    ZS.Zone := Addr.Zone;
                    ZS.Domain := Addr.Domain;
                    if not ZCs.Search(@ZS, I) then begin
                       S1 := S;
                       S := IntToStr(Addr.Zone) + ',';
                       SetZone;
                       S := S1;
                    end;
                 end;
                 rmet := true;
                 SetRegion;
              end else
              if S1 = 'ZONE' then begin zmet := true; SetZone end else
              if S1 = 'PVT' then AddNode(nfPvt) else
              if S1 = 'HOLD' then AddNode(nfHold) else
              if S1 = 'DOWN' then AddNode(nfDown) else AddNode(nfUrec);
           end;
        end;
     end;
     F.OwesStream := true;
     FreeObject(F);
     result := true;
  end;

procedure FlushZCs;
var
   Z,
   I: Integer;
  ZR: TZoneRoot;
begin
   for I := 0 to ZCs.Count - 1 do begin
      ZR := ZCs[I];
      if ZR.FoundZC then Continue;
      Z := ZR.Zone;
      S := Format('%d,%s,%s,%s,%s,%d,%s', [Z, '...', '...', '...', '-Unpublished-', 300, 'XA']);
      SetZone;
   end;
end;

var
   I: Integer;
   Actually: DWORD;
  _domain,
   ndls: string;
begin
   EnterNlCS;
   if NodeController = nil then NodeController := TNodeController.Create;
   Zones := nil;
   PC := nil; PCCount := 0;
   MS := TxMemoryStream.Create;
   St := _CreateFile(NDLPath, [cTruncate]);
   if St = INVALID_HANDLE_VALUE then Error := SysErrorMessage(GetLastError) else begin
      SetEndOfFile(ST);

      I := - NodelistVersion; // version
      WriteFile(ST, I, 4, Actually, nil);

      I := -3; // reserve space
      WriteFile(ST, I, 4, Actually, nil);
      Zones := TColl.Create;

      OldZone := DefaultZone;
      OldDomain := DefaultDomain;

      CurRegion := 0;
      OldRegion := 0;
      OldNet := 0;

      PC := TFidoNet.Create;
      ndls := '';
      If NodeController.Lists = nil then begin
//         ZeroHandle(ST);
//         Terminated := True;
//         LeaveNlCs;
//         exit;
         NodeController.Lists := TStringList.Create;
      end;
      NodeController.Lists.Clear;
      for I := 0 to Cfg.Nodelist.Files.Count - 1 do begin
      //дифференцировать: сначала пойнтлисты, потом нодлист.
        if (Cfg.Nodelist.Files.Count = AltCfg.NodelistDataDomain.Count) and
           (inifile.D5Out) then _domain := AltCfg.NodelistDataDomain[I]
        else _domain := '';
        if not CompileFile(Cfg.Nodelist.Files[I], _domain, true) then begin
           ndls := ndls + char(I);
        end;
      end;
      if ndls <> '' then
      while length(ndls) > 0 do begin
         if (Cfg.Nodelist.Files.Count = AltCfg.NodelistDataDomain.Count) and
            (inifile.D5Out) then _domain := AltCfg.NodelistDataDomain[integer(ndls[1])]
                            else _domain := '';
         CompileFile(Cfg.Nodelist.Files[integer(ndls[1])], _domain, false);
         delete(ndls, 1, 1);
      end;
      NewNet;
      FlushZCs;
      NewNet;
      if not Terminated then begin
         I := SetFilePointer(ST, 0, nil, FILE_CURRENT);
         SetFilePointer(ST, 4, nil, FILE_BEGIN);
         WriteFile(ST, I, 4, Actually, nil);
         SetFilePointer(ST, I, nil, FILE_BEGIN);
         Zones.Sort(CompareZones);
         I := Zones.Count;
         MS.Position := 0;
         MS.Write(I, 4);
         for I := 0 to Zones.Count - 1 do
             MS.Write(TFidoZone(Zones[I]).d, SizeOf(TFidoZoneData));
         WriteFile(ST, MS.Memory^, MS.Position, Actually, nil);
         Zones.FreeAll;
      end;
   end;
   repeat
     _PostMessage(D.Handle, WM_SETOK, 0, 0);
      Sleep(100);
   until D.OK;
   ZeroHandle(ST);
   FreeObject(MS);
   FreeObject(Zones);
   FreeObject(PC);
   Terminated := True;
   LeaveNlCs;
end;

procedure TNodelistCompiler.FormCreate(Sender: TObject);
begin
   FillForm(Self, rsNodelistCompiler);
   NodelistCompilation := True;
   Timer := TTimer.Create(Self);
   C := TCompileThread.Create(Self);
   TimerTimer(nil);
   Timer.OnTimer := TimerTimer;
   Timer.Interval := 500;
end;

procedure TNodelistCompiler.FormDestroy(Sender: TObject);
begin
   C.WaitFor;
   FreeObject(C);
   CloseHandle(filehandle);
   EnterNlCS;
   FreeObject(NodeController);
   LeaveNlCS;
   NodelistCompilation := False;
end;

procedure TNodelistCompiler.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
   if not OK then begin
      CanClose := False;
      C.Terminated := True;
      Auto := True;
   end;
end;

procedure TNodelistCompiler.TimerTimer(Sender: TObject);
begin
   with TCompileThread(C) do begin
      if Error <> '' then lStatus.Caption := StrAsg(Error) else
      if Sorting then lStatus.Caption := LngStr(rsNdlSorting)
                 else lStatus.Caption := FormatLng(rsNdlComp, [Addr.Zone, Addr.Net]);
      lNodes.Caption := Int2Str(CompiledNodes);
      lNets.Caption := Int2Str(CompiledNets);
      lPoints.Caption := Int2Str(CompiledPoints);
      lFile.Caption := StrAsg(CurFile);
   end;
end;

function IPFlags(const CM: boolean; const a, f: string): string;
const
   fs = ',IBN,BND,BNP,IFC,ITN,TEL,IEM,IMI,ISE,ITX,IUC,EVY,EMA,';
   modem = ',V22,V29,V32,V32B,V34,V42,V42B,MNP,H96,HST,H14,H16,MAX,PEP,CSP,V32T,VFC,ZYX,V90C,V90S,X2C,X2S,Z19,V110L,V110H,V120L,V120H,X75,';
   email = ',IEM,IMI,ISE,ITX,IUC,EVY,EMA,';
   ftp = ',IFT,';
   CM_ = ',IEM,IMI,ISE,ITX,IUC,EVY,EMA,';
var
   Flags, s, z: string;
   u, Local: boolean;
  _CM: boolean;
begin
   s := '';
  _CM := CM;
   Flags := f;
   delete(flags, 1, 1);
   u := false;
   while Flags <> '' do begin
      GetWrd(Flags, z, ',');
      u := u or (UpperCase(z) = 'U');
      if (pos(',' + copy(z, 1, 3) + ',', fs) <> 0) and (copy(a, 1, 3) <> copy(z, 1, 3)) and (not u) then continue;
      if (pos(',' + uppercase(z) + ',', modem) <> 0) and (not u) then continue;
      if (pos(',' + uppercase(z) + ',', ftp) <> 0) and (not u) then continue;
     _CM := _CM or (pos(',' + copy(z, 1, 3) + ',', CM_) <> 0);
      s := s + ',' + z;
   end;
   if _CM then begin
      Flags := s;
      u := false;
      s := '';
      while Flags <> '' do begin
         GetWrd(Flags, z, ',');
         if z = '' then continue;
         if (UpperCase(z) = 'U') and (not u) then begin
            u := true;
         end;
         if u and (IsTxyEx(z, Local, false) or IsTxyEx(z, Local, true)) then continue;
         s := s + ',' + z;
      end;
      if pos(',CM,', s + ',') = 0 then s := ',CM' + s;
   end;
   delete(s, 1, 1);
   z := copy(s, length(s) - 1, 2);
   if uppercase(z) = ',U' then delete(s, length(s) - 1, 2);
   result := s;
   if pos(a, result) = 0 then
      result := a + ',' + result; // вот тут вместо a можно добавлять
                                  // дефолтовый протокол, который настраивать
                                  // в ini-файле.
end;

function _IPFlags(const CM: boolean; const a, f: string): string;
var
   s: string;
   u: string;
   i: integer;
   n: integer;

   function PollFlags(const t, f: string): string;
   begin
      if t = 'CM,' then result := t + f
                   else result := f + t;
   end;

begin
   s := 'CM,';
   if not CM then begin
      s := '';
      i := pos(',U', ',' + f);
      if i > 0 then begin
         u := copy(f, i + 1, length(f) - i);
         i := pos(',T', u);
         if i > 0 then begin
            s := ',U,' + copy(u, i + 1, length(u));
         end;
      end;
      if s = '' then begin
         i := pos(',CM', ',' + f);
         if i > 0 then begin
            s := 'CM,';
         end;
      end;
   end;
   i := pos(',' + a, f);
   if i > 0 then begin
      n := pos(',' + a + ':', f);
      if n > 0 then begin
         i := n;
      end;
      u := copy(f, i + 1, length(f) - i + 1);
      i := pos(',', u);
      if i = 0 then i := length(u) + 1;
      u := copy(u, 1, i - 1);
      if WordCount(u, [':']) > 2 then begin
         replace(ExtractWord(2, u, [':']) + ':', '', u);
      end else
      if pos('.', u) > 0 then begin
         u := ExtractWord(1, u, [':']);
      end;
      Result := PollFlags(s, u);
   end else begin
      Result := PollFlags(s, a);
   end;
   if pos(',PROXY', ',' + f) > 0 then result := 'PROXY,' + result;
   if pos(',NOPROXY', ',' + f) > 0 then result := 'NOPROXY,' + result;
end;

function GetListedNode(const Addr: TFidoAddress): TFidoNode;
begin
//   EnterNlCS;
   try
      if NodeController = nil then NodeController := TNodeController.Create;
   except
//    windlgt('You should recompile your nodelists');
   end;
   if NodeController = nil then begin
      Result := nil;
   end else begin
      Result := NodeController.SearchNode(Addr);
   end;
//   LeaveNlCS;
end;

function FindDom(const Addr: TFidoAddress; const Flags: string; const CM: boolean): TColl;
var
   i: Integer;
 Dom,
   s,
   z: string;
  ad: TAdvNodeData;
begin
   Result := nil;
   Dom := '';
   CfgEnter;
   for i := 0 to MinI(CollMax(Cfg.IpDomA), CollMax(Cfg.IpDomB)) do begin
      s := Cfg.IpDomA[i];
      if MatchMaskAddressListSingle(Addr, s) then begin
         Dom := StrAsg(Cfg.IpDomB[i]);
         Break;
      end;
   end;
   CfgLeave;
   if Dom = '' then Exit;
   if Dom[Length(Dom)] = '.' then exit;
   ad := TAdvNodeData.Create;
   ad.Flags := IPFlags(CM, 'IBN', Flags);
   z := Format('"%sf%d.n%d.z%d.%s"', ['%s', Addr.Node, Addr.Net, Addr.Zone, Dom]);
   s := '';
   if Addr.Point <> 0 then s := Format('p%d.', [Addr.Point]);
   ad.IpAddr := Format(z, [s]);
   InsUA(Result, ad);
end;

function FindgAddr(const ga, Flag, Flags: string): string;
var
   i: integer;
   s: string;
   d: string;
begin
   Result := ga;
//   if ga <> '' then exit;
   i := pos(',' + Flag + ':', Flags);
   if i > 0 then begin
      s := copy(Flags, i + 1, length(Flags) - i);
      i := pos(',', s);
      if i = 0 then i := length(s) + 1;
      d := copy(s, length(Flag) + 2, i - length(Flag) - 2);
      if pos('.', d) > 0 then begin
         Result := '"' + ExtractWord(1, d, [':']) + '"';
      end;
   end;
end;

procedure FindpAddr(var c: TColl; const ga, Flag, Flags: string; CM: boolean);
var
   i: integer;
   a: TAdvNodeData;
   _Flag, s, g: string;
begin
   i := pos(',' + Flag + ',', Flags + ',');
   if i > 0 then begin
      g := ga;
      _Flag := Flag;
      if pos(':', Flag) > 0 then
      begin
        s := extractword(2, Flag, [':']);
        if (pos('.', s) > 0) or (pos('@', s) > 0) then g := '"' + s + '"'; // надо сделать, чтобы в кавычки заключались только FQDN адреса.
//        _Flag := extractword(1, Flag, [':']);
      end;
      if g <> '' then begin
         a := TAdvNodeData.Create;
         a.Flags := IPFlags(CM, _Flag, Flags);
         a.IPAddr := g;
         InsUA(c, a);
      end;
   end;
end;

function FindDO_(var CC: TColl; const CM: boolean; var ga: string; const Addr: TFidoAddress; const Flags: string): TColl;
var
   i: Integer;
   n: TFidoNode;
   a: TFidoAddress;
 fs2,
  fs: string;
  em: string;
  ss: TStringList;
   m: string;
 Dom,
 FTN,
   s,
   z: string;
   g: string;
   u: boolean;
begin
   Result := CC;
   g := '';
   fs := 'IP,TCP,INA';
   for i := 1 to WordCount(fs, [',']) do begin
      g := FindgAddr(ga, ExtractWord(i, fs, [',']), Flags);
   end;
   if g <> '' then ga := g;
   CfgEnter;
   for i := 0 to MinI(CollMax(Cfg.IpDomA), CollMax(AltCfg.IpDomC)) do begin
      s := Cfg.IpDomA[i];
      if MatchMaskAddressListSingle(Addr, s) then begin
         FTN := StrAsg(AltCfg.IpDomC[i]);
         DOM := StrAsg(Cfg.IpDomB[i]);
         Delete(DOM, 1, Length(FTN) + 1);
         Break;
      end;
   end;
   CfgLeave;
//  if FTN = '' then exit;
   fs := '';
   i := pos(',DO', Flags);
   if (ga = '') and (i = 0) and (FTN <> '') then begin
      a := Addr;
      a.Node := 0;
      n := GetListedNode(a);
      if n <> nil then begin
         i := pos(',DO', n.Flags);
         if i = 0 then begin
            a.Net := n.Region;
            n := GetListedNode(a);
            if n <> nil then begin
               i := pos(',DO', n.Flags);
               if i = 0 then begin
                  if Addr.Domain = 'fidonet' then begin
                     a.Net := a.Zone;
                  end else begin
                     a.Net := 0;
                  end;
                  n := GetListedNode(a);
                  if n <> nil then begin
                     i := pos(',DO', n.Flags);
                     if i = 0 then begin

                     end else fs := n.Flags;
                  end;
               end else fs := n.Flags;
            end;
         end else fs := n.Flags;
      end;
   end else fs := Flags;

   if (i > 0) and (FTN <> '') then begin
      z := copy(fs, i + 1, 3);
      s := copy(fs, i + 1, length(fs) - i);
      i := pos(',', s);
      if i = 0 then i := length(s) + 1;
      DOM := copy(s, 5, i - 5);
      case z[3] of
      'M':
        begin
           z := Format('"%sf%d.n%d.z%d.%s.%s"', ['%s', Addr.Node, Addr.Net, Addr.Zone, FTN, Dom]);
        end;
      '4':
        begin
           z := Format('"%sf%d.n%d.z%d.%s"', ['%s', Addr.Node, Addr.Net, Addr.Zone, Dom]);
        end;
      '3':
        begin
           z := Format('"%sf%d.n%d.z%d.%s"', ['%s', Addr.Node, Addr.Net, Addr.Zone, Dom]);
        end;
      '2':
        begin
           z := Format('"%sf%d.n%d.%s"', ['%s', Addr.Node, Addr.Net, Dom]);
        end;
      '1':
        begin
           z := Format('"%sf%d.%s"', ['%s', Addr.Node, Dom]);
        end;
      end;
      s := '';
      if Addr.Point <> 0 then s := Format('p%d.', [Addr.Point]);
      ga := Format(z, [s]);
   end;
   if (ga = '') and (FTN <> '') and (DOM <> '') then begin
      ga := Format('"%sf%d.n%d.z%d.%s.%s"', ['%s', Addr.Node, Addr.Net, Addr.Zone, FTN, DOM]);
      s := '';
      if Addr.Point <> 0 then s := Format('p%d.', [Addr.Point]);
      ga := Format(ga, [s]);
   end;
   fs := ',IBN,BND,BNP,IFC,ITN,TEL,BINKD,IEM,IMI,ISE,ITX,IUC,EVY,EMA,POP';
   em := ',IEM,IMI,ISE,ITX,IUC,EVY,EMA,';
   s := ',';

   fs2 := flags;
   u := false;

   while fs2 <> '' do begin
      GetWrd(fs2, z, ',');
      if z = '' then continue;
      u := u or (UpperCase(z) = 'U');
      if u then break;
      if (pos(copy(z, 1, 3), fs) > 0) and (pos(',' + z + ',', s) = 0) then begin
         if pos(',' + copy(z, 1, 3) + ',', em) > 0 then begin
            ss := IniFile.ReadSection('Grids', 'gPOP3');
            if ss <> nil then begin
               for i := 0 to ss.Count - 1 do begin
                  m := IniFile.ReadString('Grids', ss[i]);
                  if MatchMaskAddressListSingle(Addr, ExtractWord(5, m, ['|'])) then begin
                     if pos(':', z) > 0 then begin
                        s := s + z + ',';
                     end;
                     break;
                  end;
               end;
               ss.Free;
            end;
         end else begin
            s := s + z + ',';
         end;
      end;
   end;

   Delete(s, 1, 1);

   fs := s;
   for i := 1 to WordCount(fs, [',']) do begin
      FindpAddr(Result, ga, ExtractWord(i, fs, [',']), Flags, CM);
   end;
{  if (Result = nil) and (ga <> '') then begin
     if false then
     begin
       ad := TAdvNodeData.Create;
       ad.Flags := IPFlags(CM, 'IBN', Flags);
       ad.IPAddr := ga;
       InsUA(Result, ad);
     end else;
  end;}
end;

function FindBBS(const BBS: string): string;
begin
   Result := '';
   if pos('.', BBS) > 0 then begin
      Result := '"' + BBS + '"';
   end;
end;

function FindPHN(const PHN: string): string;
var
   s: string;
   i: integer;
begin
   Result := '';
   if pos('000-', PHN) = 1 then begin
      s := copy(PHN, 5, length(PHN) - 4);
      for i := 1 to length(s) do
         if s[i] = '-' then s[i] := '.';
      Result := {'"' + }s{ + '"'};
   end;
end;

function FindIPAddr(const fn: TFidoNode): string;
var
   q: TColl;
begin
   Result := '';
   if fn = nil then exit;
   Result := FindBBS(fn.Station);
   if Result = '' then Result := FindPHN(fn.Phone);
   if Result = '' then begin
      q := nil;
      q := FindDO_(q, True, result, fn.Addr, '');
      if q <> nil then begin
         FreeObject(q);
      end;
   end;
end;

function FindAdvNode(const Addr: TFidoAddress): TAdvNode;
var
   Nodes: array[Boolean] of TFidoNode;
   Base: Boolean;
   o,
   n: TFidoNode;
   DialupData,
   IPData,
   TmpData: TColl;

function CAND(Dialup: Boolean): TColl;
var
   an: TAdvNodeData;
begin
   Result := nil;
   if not Dialup then exit;
   if Dialup then begin
      if (n.Phone = '-Unpublished-') then exit;
      if (Pos('000-', n.Phone) > 0) then exit;
   end;
   an := TAdvNodeData.Create;
   if Dialup then an.Phone := StrAsg(n.Phone) else an.IPAddr := StrAsg(n.Phone);
   an.Flags := StrAsg(n.Flags);
   InsUA(Result, an);
end;

var
   f: TNodePrefixFlag;
   Local,
   u,
   overip,
   over: Boolean;
   s1,
   s2: string;
   ga: string;
   an: TAdvNodeData;
   i: integer;
begin
   Result := nil;
   over := False;
   f := nfOver;
   Base := False;
   Clear(Nodes, SizeOf(Nodes));
   o := GetListedNode(Addr);
   n := o;
   if o <> nil then begin
      n := o.Copy;
   end;
   if (n <> nil) and (n.Addr.Point = 0) then begin
      s1 := n.Phone;
      case IdentOvrItem(s1, False, False) of
      oiPhoneNum : begin Base := False; Nodes[False] := n end;
      oiIPSym, oiIpNum: begin Base := True; Nodes[False] := n end;
      else
        begin
          if s1 = '-Unpublished-' then
//            n := nil
          else begin
            Base := True;
            Nodes[False] := n
          end;
        end;
      end;{of case}
   end;
   DialupData := GetNodeOvrData(Addr, {$IFDEF WS}True,{$ENDIF} Nodes[Base]);
   if DaemonStarted then begin
      IPData := GetNodeOvrData(Addr, {$IFDEF WS}False,{$ENDIF} Nodes[not Base]);
   end else begin
      IPData := nil;
   end;
   overip := false;
   if n <> nil then begin
      over := (DialupData <> nil) or (IPData <> nil);
      overip := IPData <> nil;

      if overip then begin
         overip := false;
         u := false;
         an := IpData[0];
         s1 := an.Flags;
         while s1 <> '' do begin
            GetWrd(s1, s2, ',');
            u := u or (UpperCase(s2) = 'U');
            if u and IsTxyEx(s2, Local, false) then begin
               overip := true;
               break;
            end;
         end;
      end;
      if ((Base = False) and (DialupData = nil)) then DialupData := CAND(True) else
      if ((Base = True) and (IPData = nil)) then IpData := CAND(False);
   end;
   if DaemonStarted and (IPData = nil) then begin
      if n <> nil then begin
         ga := FindBBS(n.Station);
         if ga = '' then ga := FindPHN(n.Phone);
         ipData := FindDO_(IPData, DialupData <> nil, ga, Addr, ',' + n.Flags);
      end;
      if (not inifile.UseNodelistData) and (IpData = nil) then
         IpData := FindDom(Addr, ',CM,IBN', DialupData <> nil);
   end else
   if DaemonStarted then begin // Если в оверрайде указано несколько протоколов -
                               // формируем из них очередь.
      TmpData := nil;
      for i := 0 to CollMax(IpData) do begin
         an := IpData[i];
         ga := an.IPAddr;
         s1 := an.Flags;
         TmpData := FindDO_(TmpData, (DialupData <> nil) and (not overip), ga, Addr, ',' + s1);
      end;
      FreeObject(IpData);
      IpData := TmpData;
   end;
   if (DialupData = nil) and (IPData = nil) then Exit;
   Result := TAdvNode.Create;
   if n <> nil then begin
      if not over then f := n.PrefixFlag;
      Result.Speed := n.Speed;
      Result.Station := StrAsg(n.Station);
      Result.Sysop := StrAsg(n.Sysop);
      Result.Location := StrAsg(n.Location);
   end;
   Result.PrefixFlag := f;
   Result.Addr := Addr;
   Result.DialupData := DialupData;
   Result.IPData := IPData;
   FreeObject(n);
end;

type
  TAdvNodeColl = class(TSortedColl)
    function Compare(Key1, Key2: Pointer): Integer; override;
    function KeyOf(Item: Pointer): Pointer; override;
  end;

function TAdvNodeColl.Compare(Key1, Key2: Pointer): Integer;
begin
   Result := CompareAddrs(PFidoAddress(Key1)^, PFidoAddress(Key2)^);
end;

function TAdvNodeColl.KeyOf(Item: Pointer): Pointer;
begin
   Result := @TAdvNode(Item).Addr;
end;

var
   AdvNodeCache: TAdvNodeColl;
  AdvNodeMissed: TFidoAddrColl;

function FindNode(const Addr: TFidoAddress): TAdvNode;
var
   i: Integer;
   p: TExtPoll;
   e: TAdvNodeExtData;
   f: Boolean;
begin
   Result := nil;
   AdvNodeMissed.Enter;
   f := AdvNodeMissed.Search(@Addr, I);
   AdvNodeMissed.Leave;
   if f then Exit;
   Result := FindAdvNode(Addr);
   CfgEnter;
   for i := 0 to CollMax(Cfg.ExtPolls) do begin
      p := Cfg.ExtPolls[i];
      if not MatchMaskAddressListSingle(Addr, p.FAddrs) then Continue;
      e := TAdvNodeExtData.Create;
      e.Opts := StrAsg(p.FOpts);
      e.Cmd := StrAsg(p.FCmd);
      if Result = nil then begin
         Result := TAdvNode.Create;
         Result.Addr := Addr;
      end;
      Result.Ext := e;
      Break;
   end;
   CfgLeave;
   if Result = nil then begin
      AdvNodeMissed.Enter;
      if not AdvNodeMissed.Search(@Addr, I) then AdvNodeMissed.AtInsert(I, NewFidoAddr(Addr));
      AdvNodeMissed.Leave;
   end else begin
      AdvNodeCache.Enter;
      if not AdvNodeCache.Search(@Addr, I) then AdvNodeCache.AtInsert(I, Result.Copy);
      AdvNodeCache.Leave;
   end;
end;

function _GetScope(const Addr: TFidoAddress): TFidoNodeColl;

function fit(n: TfidoNode; r: word; a: TFidoAddress): boolean;
begin
   Result := False;
   if n.Addr.Point <> 0 then exit;
   Result := True;
   if n.Hub = a.Node then exit;
   if (a.Node = 0) and (a.Point = 0) then exit;
   Result := False;
end;

var
   i: integer;
   j: integer;
   r: word;
   z: TZoneContainer;
   n: TNetNodeIdx;
   o: TFidoNode;
   a: TFidoAddress;
   c: TFidoNodeColl;
   t: TFidoAddress;
begin
   Result := nil;
   t := Addr;
   if t.Point = -1 then t.Point := 0;
   o := GetListedNode(t);
   if o = nil then exit;
   a := t;
   r := o.Region;
   if r = o.Addr.Net then begin
      if (t.Domain = 'fidonet') or
        ((t.Domain = '') and (t.Zone in [1..7])) then begin
         a.Net := t.Zone;
      end else begin
         a.Net := 0;
      end;
   end;
   i := NodeController.GetNetIdx(a.Zone, a.Net, a.Domain);
   z := NodeController.SeekNet(i, a.Zone, a.Net, a.Domain);
   if i > -1 then begin
      Result := TFidoNodeColl.Create;
      for i := 0 to z.Count - 1 do begin
         n := z[i];
         a.Domain := t.Domain;
         a.Zone   := t.Zone;
         a.Net    := t.Net;
         a.Node   := n.Addr.Node;
         a.Point  := n.Addr.Point;
         o := GetListedNode(a);
         if fit(o, r, Addr) then begin
            Result.Add(o);
         end;
      end;
   end;
   if t.Node <> 0 then exit;
   for i := 0 to NodeController.Table.Count - 1 do begin
      if i >= NodeController.Table.Count then break;
      z := NodeController.Table[i];
      if (z.ZoneData.Domain = t.Domain) and
         (z.ZoneData.Zone = t.Zone) and
         (z.ZoneData.Region = t.Net) then
      begin
         a.Domain := t.Domain;
         a.Zone := t.Zone;
         a.Net := z.ZoneData.Net;
         a.Node := 0;
         a.Point := 0;
         c := _GetScope(a);
         for j := 0 to CollMax(c) do begin
            o := c[j];
            Result.Add(o);
         end;
         c.DeleteAll;
         FreeObject(c);
      end;
   end;
end;

function GetScope(const Addr: TFidoAddress): TFidoNodeColl;
begin
   EnterNlCS;
   Result := _GetScope(Addr);
   LeaveNlCS;
end;

destructor TCompileThread.Destroy;
begin
   FreeObject(ZCs);
   inherited Destroy;
end;

function TZoneContainer.Compare(Key1, Key2: Pointer): Integer;
var
   a: PNodePoint absolute Key1;
   b: PNodePoint absolute Key2;
begin
   Result := a^.Node - b^.Node;
   if Result = 0 then Result := a^.Point - b^.Point;
end;

function TZoneContainer.KeyOf(Item: Pointer): Pointer;
begin
   Result := @TNetNodeIdx(Item).Addr;
end;

procedure InitNdlUtil;
var
   an: TFidoNode;
begin
   InitializeCriticalSection(NodeControllerCS);
   AdvNodeCache := TAdvNodeColl.Create;
   AdvNodeMissed := TFidoAddrColl.Create;
   EnterNlCS;
   try
      if NodeController = nil then NodeController := TNodeController.Create;
   except
//    windlgt('You should recompile your nodelists');
   end;
   LeaveNlCS;
   if IniFile = nil then exit;
   if (IniFile.MainReg = 0) and not NodelistMissed then begin
      an := GetListedNode(IniFile.MainAddr);
      if an = nil then exit;
      Inifile.MainReg := an.Region;
   end;
end;

procedure DoneNdlUtil;
begin
   FreeObject(AdvNodeCache);
   FreeObject(AdvNodeMissed);
   PurgeCS(NodeControllerCS);
end;

procedure PurgeAdvNodeCache;
begin
   AdvNodeCache.Enter;
   AdvNodeCache.FreeAll;
   AdvNodeCache.Leave;
   AdvNodeMissed.Enter;
   AdvNodeMissed.FreeAll;
   AdvNodeMissed.Leave;
end;

function TZoneRootColl.Compare(Key1, Key2: Pointer): Integer;
begin
   if TZoneRoot(Key1).Domain < TZoneRt(Key2^).Domain then Result := -1 else
   if TZoneRoot(Key1).Domain > TZoneRt(Key2^).Domain then Result :=  1 else
   Result := TZoneRoot(Key1).Zone - TZoneRt(Key2^).Zone;
end;

function TZoneRootColl.KeyOf(Item: Pointer): Pointer;
begin
   Result := TZoneRoot(Item);
end;

end.

