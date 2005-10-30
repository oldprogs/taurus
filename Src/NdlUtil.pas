unit NdlUtil;

interface

{$I DEFINE.INC}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  StdCtrls, ExtCtrls, xBase, xFido;

type
  TNLHolder = class
  private
    dList: TStringList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(const f, d: string; a: TFidoAddress);
    procedure LoadFromFile(const f: string);
    procedure SaveToFile(const f: string);
    function SearchNode(const Addr: TFidoAddress): TFidoNode;
    function GetFirstNode: TFidoAddress;
    function GetNextNode(var Addr: TFidoAddress): boolean;
  end;

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

   TNodeController = class
     Cache: TFidoNodeColl;
     Lists: TStringList;
     NLHolder: TNLHolder;
     constructor Create;
     function SearchNode(const Addr: TFidoAddress): TFidoNode;
     destructor Destroy; override;
   end;

function FindNode(const Addr: TFidoAddress): TAdvNode;
function GetScope(const Addr: TFidoAddress): TFidoAddrColl;
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

uses
   Recs, AltRecs, LngTools, RadIni, Wizard, CfgFiles, Plus, UWrd;

{$R *.DFM}

const
   NodelistVersion = 12;

var
   NodeControllerCS: TRTLCriticalSection;

procedure EnterNlCS;
begin
   EnterCS(NodeControllerCS);
end;

procedure LeaveNlCS;
begin
   LeaveCS(NodeControllerCS);
end;

var
   PhantomNodes: TFidoNodeColl;

procedure FreeNodeController;
begin
   EnterNlCs;
   FreeObject(NodeController);
   FreeObject(PhantomNodes);
   LeaveNlCs;
end;

constructor TNodeController.Create;
var
   I: integer;
   J: integer;
   S: string;
   L: TStringList;

begin
   try
      EnterNlCs;
      inherited Create;
      NLHolder := TNLHolder.Create;
      NLHolder.LoadFromFile(JustPathName(ParamStr(0)) + '\Nodelist.idx');
      Cache := TFidoNodeColl.Create;
      if NLHolder.dList.Count = 0 then begin
         NodelistMissed := True;
         Exit;
      end;
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

function TNodeController.SearchNode;
var
   J: Integer;
   A: TFidoAddress;
begin
   Cache.Enter;
   try
      A := Addr;
      if IniFile.D5Out then A.Domain := FindFTNDOM(A) else A.Domain := '';
      if Cache.Search(@A, J) then begin
         Result := TFidoNode(Cache[J]).Copy;
         Exit;
      end;
      Result := NLHolder.SearchNode(A);
      if Result <> nil then begin
         Cache.Insert(Result);
         Result := Result.Copy;
      end;
   finally
      Cache.Leave;
   end;
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
   if PhantomNodes = nil then PhantomNodes := TFidoNodeColl.Create;
   PhantomNodes.Enter;
   Cache.Enter;
   try
      PhantomNodes.Concat(Cache);
   finally
      Cache.Leave;
   end;
   PhantomNodes.Leave;
   FreeObject(Cache);
   FreeObject(NLHolder);
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
   CurHub, CurRegion: word;
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

  procedure AddNode(const SSR: string);
  begin
     Addr.Node := StrToInt(wordn(SSR, ',', 2));
     if ((Addr.Domain = 'fidonet') or not IniFile.D5Out) and (Addr.Net = 0) then Addr.Net := Addr.Zone;
     Addr.Point := 0;
     if (IniFile.MainReg = 0) and (CompareAddrs(Addr, IniFile.MainAddr) = 0) then begin
        IniFile.MainReg := CurRegion;
        IniFile.StoreCfg;
     end;
     if TimerExpired(SleepTimer) then begin
        Sleep(50);
        NewTimer(SleepTimer, 10);
     end;
     Inc(CompiledNodes);
  end;

  procedure AddHub(const SSR: string);
  begin
     Addr.Node := StrToInt(wordn(SSR, ',', 2));
     Addr.Point := 0;
     CurHub := Addr.Node;
     Inc(CompiledNodes);
  end;

  procedure SetBoss(const Domain: string);
  begin
     FillChar(Addr, SizeOf(Addr), 0);
     ParseAddress(ExtractWord(1, S, [',']), Addr);
     Addr.Domain := LowerCase(Domain);
     CurRegion := 0;
     CurHub := 0;
     Point := True;
  end;

  procedure SetNet(const SSR: string);
  begin
     Addr.Net := StrToInt(wordn(SSR, ',', 2));
     Addr.Node := 0; Addr.Point := 0; CurHub := 0;
     inc(CompiledNets);
  end;

  procedure SetRegion(const SSR: string);
  begin
     Addr.Net := StrToInt(wordn(SSR, ',', 2));
     Addr.Node := 0; Addr.Point := 0; CurHub := 0; CurRegion := Addr.Net;
  end;

  procedure SetZone(const SSR: string);
  begin
     Addr.Zone := StrToInt(wordn(SSR, ',', 2));
     Addr.Net := 0; Addr.Node := 0; Addr.Point := 0; CurHub := 0; CurRegion := 0;
     if ((Addr.Domain = 'fidonet') or not IniFile.D5Out) and (Addr.Zone in [1..6]) then Addr.Net := Addr.Zone;
  end;

  procedure AddPoint(const SSR: string);
  begin
     Addr.Point := StrToInt(wordn(SSR, ',', 2));
     Inc(CompiledPoints);
  end;

var
   NL: TNLHolder;

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
     a: TFidoAddress;

  begin
     result := false;
     zmet := false;
     rmet := false;
     CurFile := FName;
     CurRegion := 0;
     FillChar(Addr, SizeOf(Addr), 0);
     Addr.Domain := LowerCase(Domain);

     Mask := ExtractFileName(FName);
     IsRegEx := StrQuotePartEx(Mask, '~', #3, #4) <> Mask;
     S := ExtractFilePath(FName);
     if IsRegEx then FName := S + '*.*' else Replace('%', '?', FName);
     I := SysUtils.FindFirst(FName, faAnyFile, SR);
     FName := ''; DT := 0;
     while I = 0 do begin
        if _MatchMask(SR.Name, Mask, True) and (Abs(DT) < SR.Time) and (SR.Attr and faDirectory = 0) then begin
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
     try
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
                if Point then AddPoint(SSR) else AddNode(SSR)
             end else
             if (S1 = 'POINT') then AddPoint(SSR) else
             if (S1 <> 'BOSS') and
                (S1 <> 'ZONE') and
                (S1 <> 'REGION') and
                (S1 <> 'HOST') and
                (S1 <> 'HUB') and Point then AddPoint(SSR) else
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
                if S1 = 'HUB' then AddHub(SSR) else
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
                   SetNet(SSR);
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
                         SetZone(SSR);
                         S := S1;
                      end;
                   end;
                   rmet := true;
                   SetRegion(SSR);
                end else
                if S1 = 'ZONE' then begin zmet := true; SetZone(SSR) end else
                if S1 = 'PVT' then AddNode(SSR) else
                if S1 = 'HOLD' then AddNode(SSR) else
                if S1 = 'DOWN' then AddNode(SSR) else AddNode(SSR);
             end;
             if not Point or (Point and (Addr.Point <> 0)) then begin
                a := Addr;
                a.ofs := F.Position;
                a.reg := CurRegion;
                a.hub := CurHub;
                NL.Add(FName, Domain, a);
             end;
          end;
       end;
     finally
     end;
     F.OwesStream := true;
     FreeObject(F);
     result := true;
  end;

  function BestChoice(const f: string): string;
  var
     st: TStrings;
     sr: TSearchRec;
     ss: string;
     OK: boolean;
     ii: integer;
  begin
     Result := f;
     ss := f;
     Replace('%', '?', ss);
     st := TStringList.Create;
     try
        if FindFirst(ss, 0, SR) = 0 then begin
           repeat
              if _MatchMask(SR.Name, ExtractFileName(f), True) then begin
                 st.AddObject(ExtractFilePath(ss) + SR.Name, Pointer(SR.Time));
              end;   
           until FindNext(SR) <> 0;
           FindClose(SR);
           OK := True;
           while OK do begin
              OK := False;
              for ii := 0 to st.Count - 2 do begin
                 if DWORD(st.Objects[ii]) < DWORD(st.Objects[ii + 1]) then begin
                    OK := True;
                    st.Exchange(ii, ii + 1);
                    break;
                 end;
              end;
           end;
           Result := st[0];
        end;
     finally
        st.Free;
     end;
  end;

var
   I: Integer;
  _domain: string;
   ndls: TStringList;
   OK: boolean;
   st: string;
begin
   EnterNlCS;
   if NodeController = nil then NodeController := TNodeController.Create;

      CurRegion := 0;
      CurHub := 0;
      CompiledNets := 0;
      CompiledNodes := 0;
      CompiledPoints := 0;

      If NodeController.Lists = nil then begin
         NodeController.Lists := TStringList.Create;
      end;
      NodeController.Lists.Clear;
      NL := TNLHolder.Create;
      ndls := TStringList.Create;
      try
         for I := 0 to Cfg.Nodelist.Files.Count - 1 do begin
            //дифференцировать: сначала пойнтлисты, потом нодлист.
            if (Cfg.Nodelist.Files.Count = AltCfg.NodelistDataDomain.Count) and
               (inifile.D5Out) then _domain := AltCfg.NodelistDataDomain[I]
            else _domain := '';
            st := bestchoice(Cfg.Nodelist.Files[I]);
            if not CompileFile(st, _domain, true) then begin
               ndls.AddObject(st + ',' + _domain, Pointer(Plus.GetFileTime(st)));
            end;
         end;
         OK := True;
         while OK do begin
            OK := False;
            for i := 0 to ndls.Count - 2 do begin
               if DWORD(ndls.Objects[i]) > DWORD(ndls.Objects[i + 1]) then begin
                  ndls.Exchange(i, i + 1);
                  OK := True;
                  break;
               end;
            end;
         end;
         while ndls.Count > 0 do begin
            CompileFile(wordn(ndls[0], ',', 1), wordn(ndls[0], ',', 2), false);
            ndls.Delete(0);
         end;
      finally
         ndls.Free;
      end;
      NL.SaveToFile(JustPathName(ParamStr(0)) + '\Nodelist.idx');
      FreeObject(NodeController.NLHolder);
      NodeController.Cache := TFidoNodeColl.Create;
      NodeController.NLHolder := NL;
   repeat
     _PostMessage(D.Handle, WM_SETOK, 0, 0);
      Sleep(100);
   until D.OK;
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
//      if pos(',CM,', s + ',') = 0 then s := ',CM' + s;
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
      n := GetListedNode(a);
      i := 0;
      if n <> nil then begin
         a.Node := n.Hub;
         a.Point := 0;
         FreeObject(n);
         n := GetListedNode(a);
         if n <> nil then begin
            i := pos(',DO', n.Flags);
         end;
      end;
      if i = 0 then begin
         a.Node := 0;
         FreeObject(n);
         n := GetListedNode(a);
         if n <> nil then begin
            i := pos(',DO', n.Flags);
            if i = 0 then begin
               a.Net := n.Region;
               FreeObject(n);
               n := GetListedNode(a);
               if n <> nil then begin
                  i := pos(',DO', n.Flags);
                  if i = 0 then begin
                     if ((Addr.Domain = 'fidonet') or not IniFile.D5Out) and (Addr.Zone in [1..6]) then begin
                        a.Net := a.Zone;
                     end else begin
                        a.Net := 0;
                     end;
                     FreeObject(n);
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
      end else fs := n.Flags;
      FreeObject(n);
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
      if (Pos('00-0', n.Phone) > 0) then exit;
   end;
   an := TAdvNodeData.Create;
   if Dialup then an.Phone := StrAsg(n.Phone) else an.IPAddr := StrAsg(n.Phone);
   an.Flags := StrAsg(DUFlags(n.Flags));
   InsUA(Result, an);
end;

var
   f: TNodePrefixFlag;
   Local,
//   u,
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
   n := GetListedNode(Addr);
   if (n <> nil) and (n.Addr.Point = 0) then begin
      s1 := n.Phone;
      case IdentOvrItem(s1, False, False) of
      oiPhoneNum : begin Base := False; Nodes[False] := n; end;
      oiIPSym,
      oiIpNum: begin Base := True; Nodes[False] := n; end;
      else
         begin
            if s1 = '-Unpublished-' then begin
//               FreeObject(n);
//               n := nil
            end else begin
               Base := True;
               Nodes[False] := n
            end;
         end;
      end;{of case}
   end;
   DialupData := GetNodeOvrData(Addr, {$IFDEF WS} True, {$ENDIF} Nodes[Base]);
   if DaemonStarted then begin
      IPData := GetNodeOvrData(Addr, {$IFDEF WS} False, {$ENDIF} Nodes[not Base]);
   end else begin
      IPData := nil;
   end;
   overip := false;
   if n <> nil then begin
      over := (DialupData <> nil) or (IPData <> nil);
      overip := IPData <> nil;

      if overip then begin
         overip := false;
//         u := false;
         an := IpData[0];
         s1 := an.Flags;
         while s1 <> '' do begin
            GetWrd(s1, s2, ',');
//            u := u or (UpperCase(s2) = 'U');
            if {u and} IsTxyEx(s2, Local, false) then begin
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
   if DaemonStarted then begin
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
   if (DialupData = nil) and (IPData = nil) then begin
      FreeObject(n);
      Exit;
   end;
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

function _GetScope(const Addr: TFidoAddress): TFidoAddrColl;
var
  SR: TFidoAddress;
  hh: boolean;
begin
   Result := nil;
   try
   if Addr.Node <> 0 then begin
      SR := Addr;
      SR.Node := 0;
      if SR.Point = word(-1) then SR.Point := 0;
      Result := TFidoAddrColl.Create;
      while NodeController.NLHolder.GetNextNode(SR) do begin
         if SR.Point <> 0 then continue;
         if SR.Net <> Addr.Net then exit;
         if SR.Hubb = Addr.Node then begin
            Result.Add(SR);
         end;
      end;
      exit;
   end;
   SR := Addr;
   SR.Node := 0;
   hh := False;
   if SR.Point = word(-1) then begin
      hh := True;
      SR.Point := 0;
   end else begin
      if ((SR.Domain = 'fidonet') or not IniFile.D5Out) and (SR.Zone in [1..6]) then SR.Net := SR.Zone;
   end;
   if Result = nil then Result := TFidoAddrColl.Create;
   if Nodecontroller = nil then exit;
   if Nodecontroller.NLHolder = nil then exit;
   while NodeController.NLHolder.GetNextNode(SR) do begin
      if SR.Point <> 0 then continue;
      if SR.Zone <> Addr.Zone then exit;
      if hh and (SR.Net <> Addr.Net) then exit;
      if hh and (SR.Hubb = 0) then begin
         Result.Add(SR);
      end else
      if SR.Region = Addr.Net then begin
         Result.Add(SR);
      end;
   end;
   finally
      if (Result <> nil) and (Result.Count = 0) then FreeObject(Result);
   end;
end;

function GetScope(const Addr: TFidoAddress): TFidoAddrColl;
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
      FreeObject(an);
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

{ TNLHolder }

constructor TNLHolder.Create;
begin
   inherited;
   dList := TStringList.Create;
end;

destructor TNLHolder.Destroy;
var
   i: integer;
begin
   for i := 0 to dList.Count - 1 do begin
      TFidoNLColl(dList.Objects[i]).Free;
   end;
   dList.Free;
   inherited;
end;

procedure TNLHolder.Add(const f, d: string; a: TFidoAddress);
var
   i: integer;
begin
   i := dList.IndexOf(d);
   if i = -1 then begin
      i := dList.Add(d);
      dList.Objects[i] := TFidoNLColl.Create;
      TFidoNLColl(dList.Objects[i]).Domain := d;
   end;
   TFidoNLColl(dList.Objects[i]).Ins(a, f);
end;

procedure TNLHolder.LoadFromFile(const f: string);
var
   i: integer;
   j: integer;
   s: TDOSStream;
   b: byte;
   w: word;
   o: dword;
   n: string;
   d: string;
   c: TFidoNLColl;
   l: TStringList;
   a: TFidoAddress;
  OK: boolean;
begin
   OK := False;
   s := CreateDOSStream(f, [cRead]);
   if s <> nil then begin
      l := nil;
      try
         l := TStringList.Create;
         l.Duplicates := dupIgnore;
         while s.Position < s.Size do begin
            c := TFidoNLColl.Create;
            s.Read(w, 2);
            for i := 0 to w - 1 do begin
               s.Read(b, 1);
               SetLength(n, b);
               s.Read(n[1], b);
               if FileExists(n) then begin
                  c.Nodelist.Add(n);
               end else begin
                  dList.Clear;
                  exit;
               end;
            end;
            s.Read(b, 1);
            SetLength(d, b);
            s.Read(d[1], b);
            s.Read(o, 4);
            c.Domain := d;
            j := l.Add(d);
            l.Objects[j] := c;
            for i := 1 to o do begin
               s.Read(a, 18);
               TFidoNLColl(l.Objects[j]).Add(a, c.Nodelist[a.fil]);
            end;
         end;
         OK := True;
         EnterNlCS;
         try
            for i := 0 to dList.Count - 1 do begin
               TFidoNLColl(dList.Objects[i]).Free;
            end;
            dList.Free;
            dList := l;
         finally
            LeaveNLCs;
         end;
      finally
         s.Free;
         if not OK then begin
            DeleteFile(f);
            for i := 0 to l.Count - 1 do begin
               TFidoNLColl(l.Objects[i]).Free;
            end;
            l.Free;
         end;
      end;
   end;
end;

procedure TNLHolder.SaveToFile(const f: string);
var
   i: integer;
   s: TDOSStream;
begin
   s := CreateDOSStream(f, [cTruncate]);
   if s <> nil then begin
      s.Free;
      for i := 0 to dList.Count - 1 do begin
         TFidoNLColl(dList.Objects[i]).SaveToFile(f);
      end;
   end;
end;

function TNLHolder.SearchNode(const Addr: TFidoAddress): TFidoNode;
var
   i: integer;
begin
   Result := nil;
   i := dList.IndexOf(Addr.Domain);
   if i = -1 then exit;
   Result := TFidoNLColl(dList.Objects[i]).SearchNode(Addr);
end;

function TNLHolder.GetNextNode(var Addr: TFidoAddress): boolean;
var
   i: integer;
begin
   Result := False;
   i := dList.IndexOf(Addr.Domain);
   if i > -1 then begin
      Result := TFidoNLColl(dList.Objects[i]).GetNextNode(Addr);
      if not Result then begin
         inc(i);
         if i < dList.Count then begin
            Result := TFidoNLColl(dList.Objects[i]).GetNextNode(Addr);
         end;
      end;
   end;
end;

function TNLHolder.GetFirstNode: TFidoAddress;
begin
   Result.Domain := '';
   Result.Zone := 0;
   Result.Net := 0;
   Result.Node := 0;
   Result.Point := 0;
   if dList.Count > 0 then begin
      Result := TFidoNLColl(dList.Objects[0]).GetFirstNode;
   end;
end;

end.


