unit Watcher;

{$I define.inc}

interface

uses Plus, Windows, xBase, Classes;

type
  TDirectoryWatcher = class(T_Thread)
    hDirectoryWatcherEvent: THandle;
    hOutboundWatcher,
    hHomeDirWatcher: THandle;
    hFileFlagsWatcher: THandle;
    hNodelistsWatcher: PWOHandleArray;
    hNetmailWatcher: PWOHandleArray;
{    hNTOutboundWatcher: THandle;}
    fSize: integer;
    nSize: integer;
    fTime: TFileTime;
    Busy: boolean;
    constructor Create;
    destructor Destroy; override;
    procedure FillArray;
    procedure FillNetm;
    procedure CheckLists;
    procedure InvokeExec; override;
    procedure InvokeDone; override;
    class function ThreadName: string; override;
  public
    property OutBoundWatcher: THandle read hOutboundWatcher;
  end;

  TWatcherType = (
                   wtOutbound,
                   wtFileFlags,
                   wtHomeDir,
                   wtStopEvent
                 );
var
  DirectoryWatcher: TDirectoryWatcher;
  IgnoreNextEvent: boolean;

procedure StartWatcher;
procedure StopWatcher;

function GetBuildDateStr(const fn: string): string;

implementation

uses
   Forms, SysUtils, Recs, RadIni, MlrThr, Wizard, NdlUtil, RadSav,
   OutBound, xFido;

constructor TDirectoryWatcher.Create;
var
  Subtree: boolean;
  outboundpath: string;
begin
  inherited Create;

  hDirectoryWatcherEvent := CreateEvt(False);
  ResetEvent(hDirectoryWatcherEvent);

  Subtree := True;
  if not IniFile.D5Out then outboundpath := IniFile.Outbound
  else outboundpath := ExtractFilePath(IniFile.Outbound);
  hOutboundWatcher := FindFirstChangeNotification(PChar(FullPath(outboundpath)),
                      Bool(Integer(Subtree)), FILE_NOTIFY_CHANGE_FILE_NAME + FILE_NOTIFY_CHANGE_SIZE);

  Subtree := False;

  hFileFlagsWatcher := FindFirstChangeNotification(PChar(FullPath(IniFile.FlagsDir)),
                      Bool(Integer(Subtree)), FILE_NOTIFY_CHANGE_FILE_NAME + FILE_NOTIFY_CHANGE_LAST_WRITE);

  Subtree := False;
  hHomeDirWatcher := FindFirstChangeNotification(PChar(JustPathName(IniFName)),
                      Bool(Integer(Subtree)), FILE_NOTIFY_CHANGE_LAST_WRITE);

  Priority := tpLowest;
{  if (Win32Platform = VER_PLATFORM_WIN32_NT) then begin
     hNTOutboundWatcher := CreateFile (
          PChar(FullPath(outboundpath)),
          GENERIC_READ or GENERIC_WRITE,         // access (read-write) mode
          FILE_SHARE_READ or FILE_SHARE_DELETE,  // share mode
          nil,                                   // security descriptor
          OPEN_EXISTING,                         // how to create
          FILE_FLAG_BACKUP_SEMANTICS,            // file attributes
          0                                      // file with attributes to copy
        );
  end;}
end;

procedure TDirectoryWatcher.FillArray;
var
   l: TStringList;
   i: integer;
begin
   EnterNlCs;
   try
      if NodeController = nil then exit;
      if NodeController.Lists = nil then exit;
      l := TStringList.Create;
      l.CaseSensitive := False;
      l.Duplicates := dupIgnore;
      l.Sorted := True;
      for i := 0 to NodeController.Lists.Count - 1 do begin
         l.Add(JustPathName(NodeController.Lists[i]));
      end;
      if hNodelistsWatcher <> nil then begin
         for i := 0 to fSize - 1 do begin
            FindCloseChangeNotification(hNodelistsWatcher[i]);
         end;
         FreeMem(hNodelistsWatcher, fSize * SizeOf(THandle));
      end;
      fSize := l.Count;
      GetMem(hNodelistsWatcher, fSize * SizeOf(THandle));
      for i := 0 to fSize - 1 do begin
         hNodelistsWatcher[i] := FindFirstChangeNotification(PChar(FullPath(l[i])),
                                 Bool(Integer(False)), FILE_NOTIFY_CHANGE_FILE_NAME + FILE_NOTIFY_CHANGE_LAST_WRITE);
      end;
      l.Free;
   finally
      LeaveNlCs;
   end;
end;

procedure TDirectoryWatcher.FillNetm;
var
   d: TDualColl;
   i: integer;
begin
   if hNetmailWatcher <> nil then begin
      for i := 0 to nSize - 1 do begin
         FindCloseChangeNotification(hNetmailWatcher[i]);
      end;
      FreeMem(hNetmailWatcher, nSize * SizeOf(THandle));
      hNetmailWatcher := nil;
   end;
   d := IniFile.GetStrings('gNetPath');
   nSize := d.Count;
   if nSize > 0 then begin
      GetMem(hNetmailWatcher, SizeOf(THandle) * nSize);
      for i := 0 to nSize - 1 do begin
         hNetmailWatcher[i] := FindFirstChangeNotification(PChar(TDualRec(d[i]^).St1^),
                               False, FILE_NOTIFY_CHANGE_LAST_WRITE);
      end;
   end;
end;

destructor TDirectoryWatcher.Destroy;
var
   i: integer;
begin
   FindCloseChangeNotification(hOutboundWatcher);
   FindCloseChangeNotification(hFileFlagsWatcher);
   FindCloseChangeNotification(hHomeDirWatcher);
   CloseHandle(hDirectoryWatcherEvent);
{   CloseHandle(hNTOutboundWatcher);}
   for i := 0 to nSize - 1 do begin
      FindCloseChangeNotification(hNetmailWatcher[i]);
   end;
   for i := 0 to fSize - 1 do begin
      FindCloseChangeNotification(hNodelistsWatcher[i]);
   end;
   FreeMem(hNodelistsWatcher);
   FreeMem(hNetmailWatcher);
   inherited Destroy;
end;

procedure TDirectoryWatcher.CheckLists;
var
   i: integer;
   o,
   c: Int64;
begin
   if IniFile = nil then exit;
   if IniFile.AutoNodelist then begin
      EnterNlCs;
      try
         if (NodeController <> nil) and (NodeController.Lists <> nil) then begin
            for i := 0 to NodeController.Lists.Count - 1 do begin
               o := Int64(NodeController.Lists.Objects[i]);
               c := Plus.GetFileTime(NodeController.Lists[i]);
               if o <> c then begin
                  PostMsg(WM_COMPILENL);
                  break
               end;
            end;
         end;
      finally
         LeaveNlCs;
      end;
   end;
end;

procedure RemoveFromColl(st: string);
var
   i: integer;
   j: integer;
   o: TOutFile;
   n: TOutNode;
   a: TFidoAddress;
begin
   EnterCS(OutMgrThread.NodesCS);
   try
      GetBSOAddr(st, a);
      for i := 0 to CollMax(OutMgrThread.Nodes) do begin
         n := OutMgrThread.Nodes[i];
         for j := 0 to CollMax(n.Files) do begin
            o := n.Files[j];
            if Pos(UpperCase(st), UpperCase(o.Name)) > 0 then
            begin
               n.Files.AtFree(j);
               n.FStatus := n.FStatus - [o.FStatus];
               if n.Files.Count = 0 then begin
                  FreeObject(n.Files);
               end;
               if n.FStatus = [] then begin
                  OutMgrThread.Nodes.Delete(n);
                  FreeObject(n.Files);
                  FreeObject(n);
               end;
               PostMsg(WM_UPDOUTMGR);
               exit;
            end;
         end;
         if CompareAddrs(a, n.Address) = 0 then begin
            n.FStatus := n.FStatus - [GetBSOStatus(st)];
            if n.FStatus = [] then begin
               OutMgrThread.Nodes.Delete(n);
               FreeObject(n.Files);
               FreeObject(n);
            end;
            PostMsg(WM_UPDOUTMGR);
            exit;
         end;
      end;
   finally
      LeaveCS(OutMgrThread.NodesCS);
   end;
end;

procedure InsertToColl(st: string);
var
   i: integer;
   j: integer;
   o: TOutFile;
   n: TOutNode;
   a: TFidoAddress;
begin
   if GetBSOAddr(st, a) then begin
      EnterCS(OutMgrThread.NodesCS);
      try
         for i := 0 to CollMax(OutMgrThread.Nodes) do begin
            n := OutMgrThread.Nodes[i];
            if CompareAddrs(a, n.Address) = 0 then begin
               for j := 0 to CollMax(n.Files) do begin
                  o := n.Files[j];
                  if Pos(UpperCase(st), UpperCase(o.Name)) > 0 then
                  begin
                     exit;
                  end;
               end;
               n.FStatus := n.FStatus + [GetBSOStatus(st)];
               PostMsg(WM_UPDOUTMGR);
               exit;
            end;
         end;
         n := TOutNode.Create;
         n.FStatus := [GetBSOStatus(st)];
         n.Address := a;
         OutMgrThread.Nodes.Insert(n);
         PostMsg(WM_UPDOUTMGR);
      finally
         LeaveCS(OutMgrThread.NodesCS);
      end;
   end;
end;

type
  _FILE_NOTIFY_INFORMATION = record
      NextEntryOffset: DWORD ;
      Action: DWORD;
      FileNameLength: DWORD;
      FileName: array[0..0] of WCHAR;
   end;

   FNI = array[0..255] of _FILE_NOTIFY_INFORMATION;

procedure TDirectoryWatcher.InvokeExec;
var
   HandlesArray: PWOHandleArray;
   WaitResult: DWORD;
   i: integer;
   n: integer;
  p3: TFileTime;
//  FB,
//  TB:^FNI;
//  ln: integer;
//  st: WideString;
begin
   if Terminated {or ApplicationDowned} or ExitNow then exit;
   if hOutboundWatcher = INVALID_HANDLE_VALUE then begin Terminated := True; Exit end;
   if hFileFlagsWatcher = INVALID_HANDLE_VALUE then begin Terminated := True; Exit end;
   if hHomeDirWatcher = INVALID_HANDLE_VALUE then begin Terminated := True; Exit end;
   if hDirectoryWatcherEvent = INVALID_HANDLE_VALUE then begin Terminated := True; Exit end;

   if IniFile.AutoNodelist then begin
      FillArray;
   end;

   FillNetm;

   n := Integer(wtStopEvent);
   GetMem(HandlesArray, (n + 1 + fSize + nSize) * SizeOf(THandle));

   try

      HandlesArray[0] := hOutboundWatcher;
      HandlesArray[1] := hFileFlagsWatcher;
      HandlesArray[2] := hHomeDirWatcher;
      HandlesArray[n] := hDirectoryWatcherEvent;

      for i := 1 to fSize do begin
         HandlesArray[n + i] := hNodelistsWatcher[i - 1];
      end;

      n := Integer(wtStopEvent) + fSize;

      for i := 1 to nSize do begin
         HandlesArray[n + i] := hNetmailWatcher[i - 1];
      end;

      n := Integer(wtStopEvent);

      Busy := False;
      WaitResult := WaitForMultipleObjects(n + 1 + fSize + nSize, HandlesArray, False, INFINITE) - WAIT_OBJECT_0;

      if ExitNow then exit;
      if Terminated then exit;

      if WaitResult = WAIT_FAILED then begin
         sleep(1000);
         exit;
      end;

      if Terminated then exit;
      if IniFile = nil then exit;

      Busy := True;

      case WaitResult of
      0:
         begin
            if (not Terminated) and (Application <> nil) and (Application.MainForm <> nil) then begin
               if not IgnoreNextEvent then begin
                  ScanCounter := 1;
               end;
               IgnoreNextEvent := False;
  {             if (Win32Platform = VER_PLATFORM_WIN32_NT) then begin
                  ln := 0;
                  GetMem(FB, SizeOf(FB^));
                  TB := FB;
                  try
                     if ReadDirectoryChanges(hNTOutboundWatcher, FB, SizeOf(FB^), True, FILE_NOTIFY_CHANGE_FILE_NAME, @ln, nil, nil) then begin
                        for i := 1 to ln do begin
                           SetLength(st, FB[0].FileNameLength div 2);
                           move(FB[0].FileName[0], st[1], FB[0].FileNameLength);
                           if (FB[0].Action = FILE_ACTION_REMOVED) or
                              (FB[0].Action = FILE_ACTION_RENAMED_OLD_NAME) then begin
                              RemoveFromColl(st);
                           end else
                           if (FB[0].Action = FILE_ACTION_ADDED) then begin
                              InsertToColl(st);
                           end;
                           if FB[0].NextEntryOffset = 0 then begin
                              break;
                           end else begin
                              FB := Pointer(DWORD(FB) + FB[0].NextEntryOffset);
                           end;
                        end;
                     end else begin
                     end;
                  finally
                     FreeMem(TB, SizeOf(FB^));
                  end;
               end;}
               FindNextChangeNotification(hOutboundWatcher);
               FindNextChangeNotification(hOutboundWatcher);
            end;
         end;
      1:
         begin
            if (not Terminated) and (Application <> nil) and (Application.MainForm <> nil) then begin
               PostMessage(Application.MainForm.Handle, WM_CHECKFILEFLAGS, 0, 0);
               FindNextChangeNotification(hFileFlagsWatcher);
               FindNextChangeNotification(hFileFlagsWatcher);
            end;
         end;
      2:
         begin
            if (not Terminated) and (Application <> nil) and (Application.MainForm <> nil) then begin
               getfiletime(SysUtils.FileOpen(IniFName, SysUtils.fmShareDenyNone), nil, nil, @p3);
               if (p3.dwLowDateTime <> FTime.dwLowDateTime) or (p3.dwHighDateTime <> FTime.dwHighDateTime) then begin
                  PostMessage(Application.MainForm.Handle, WM_CFGREREAD, 0, 0);
                  FTime.dwLowDateTime := p3.dwLowDateTime;
                  FTime.dwHighDateTime := p3.dwHighDateTime;
               end;
               FindNextChangeNotification(hHomeDirWatcher);
               FindNextChangeNotification(hHomeDirWatcher);
            end;
         end;
      3..999:
         begin
            if (not Terminated) and (Application <> nil) and (Application.MainForm <> nil) and (IniFile.AutoNodelist) then begin
               if WaitResult <= DWORD(n + fSize) then begin
                  CheckLists;
               end else begin
                  PostMessage(MainWinHandle, WM_CHECKNETMAIL, 0, 0);
               end;
            end;
            exit;
         end;
      end;
      if IniFile.AutoNodelist then CheckLists;
   finally
      n := Integer(wtStopEvent);
      FreeMem(HandlesArray, (n + 1 + fSize + nSize) * SizeOf(THandle));
   end;
end;

procedure TDirectoryWatcher.InvokeDone;
begin
   Busy := False;
   inherited;
end;

class function TDirectoryWatcher.ThreadName: string;
begin
   Result := 'Directory Watcher';
end;

procedure StartWatcher;
begin
   DirectoryWatcher := TDirectoryWatcher.Create;
   DirectoryWatcher.Priority := tpIdle;
   DirectoryWatcher.Suspended := False;
end;

procedure StopWatcher;
begin
  DirectoryWatcher.Terminated := True;
  DirectoryWatcher.Priority := tpHighest;
  while DirectoryWatcher.Busy do begin
     sleep(100);
     Application.ProcessMessages;
  end;
  SetEvt(DirectoryWatcher.hDirectoryWatcherEvent);
  DirectoryWatcher.WaitFor;
  FreeObject(DirectoryWatcher);
end;

// (c) 2001 Chelmodeyev AV'
function GetBuildDateStr;

type

   TExeHeader = record
      F1  : array [0..23] of char;
      Flag  : Byte;
      F2  : array [0..34] of char;
      AdrPE  : LongInt;  //OffSet to PE Header
   end;

   TPEHeader = record
      Sign  : array [0..5] of char;
      NObj  : Word;
      F3  : array [0..11] of char;
      NTHead  : Word;
      F4  : array [0..226] of Char
   end;

   Trsrc = record
      ObjName  : array [0..7] of char;
      F5  : array [0..11] of char;
      PhysOffs  : DWord;
      F6  : array [0..11] of char;
   End;

   TFirst = record
      F7  : array [0..3] of char;
      CompD  : DWord;
   end;

var

   fname: tfilestream;
   n    : Integer;
   EH   : TExeHeader;
   PEH  : TPEHeader;
   RSRC : Trsrc;
   First: TFirst;

begin

   FName := TFileStream.Create(Fn, fmOpenRead or fmShareDenyNone);
   fname.seek(0, soFrombeginning);
   fname.read(EH, 64);
   fname.seek(EH.AdrPE, soFrombeginning);
   fname.read(PEH, 248);
   fname.seek(EH.AdrPE + 248, soFrombeginning);

   For n := 1 to PEH.Nobj do begin
      fname.read(RSRC, 40);
      if RSRC.ObjName = '.rsrc' then begin
         fname.seek(RSRC.PhysOffs, soFrombeginning);
         fname.read(First, 8);
         Break;
      end;
   end;
   If RSRC.ObjName <> '.rsrc' then
      result := 'unknown'
   else
      result := FormatDateTime('mmmm d, yyyy', FileDateToDateTime(First.CompD));
   fname.free;
end;

end.
