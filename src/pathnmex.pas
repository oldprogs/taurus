unit PathNmEx;

interface

uses windows, messages, sysutils;

type
  PSHItemID = ^TSHItemID;
  TSHItemID = packed record           { mkid }
    cb: Word;                         { Size of the ID (including cb itself) }
    abID: array[0..0] of Byte;        { The item ID (variable length) }
  end;

{ TItemIDList -- List if item IDs (combined with 0-terminator) }

  PItemIDList = ^TItemIDList;
  TItemIDList = packed record         { idl }
     mkid: TSHItemID;
   end;

  TFNBFFCallBack = function(Wnd: HWND; uMsg: UINT; lParam, lpData: LPARAM): Integer stdcall;

  PBrowseInfo = ^TBrowseInfo;
  TBrowseInfo = packed record
    hwndOwner: HWND;
    pidlRoot: PItemIDList;
    pszDisplayName: LPSTR;  { Return display name of item selected. }
    lpszTitle: LPCSTR;      { text to go in the banner over the tree. }
    ulFlags: UINT;          { Flags that control the return stuff }
    lpfn: TFNBFFCallBack;
    lParam: LPARAM;         { extra info that's passed back in callbacks }
    iImage: Integer;        { output var: where to return the Image index. }
  end;

const

{ Browsing for directory }

  BIF_RETURNONLYFSDIRS   = $0001; { For finding a folder to start document searching }
  BIF_DONTGOBELOWDOMAIN  = $0002; { For starting the Find Computer }
  BIF_STATUSTEXT         = $0004;
  BIF_RETURNFSANCESTORS  = $0008;

  BIF_BROWSEFORCOMPUTER  = $1000; { Browsing for Computers }
  BIF_BROWSEFORPRINTER   = $2000; { Browsing for Printers }
  BIF_BROWSEINCLUDEFILES = $4000; { Browsing for Everything }

{ message from browser }

  BFFM_INITIALIZED       = 1;
  BFFM_SELCHANGED        = 2;

{ messages to browser }

  BFFM_SETSTATUSTEXT      = (WM_USER + 100);
  BFFM_ENABLEOK           = (WM_USER + 101);
  BFFM_SETSELECTION       = (WM_USER + 102);

{const
  CSIDL_DRIVES             = $0011;
  CSIDL_NETWORK            = $0012;
}

function SHBrowseForFolder(var lpbi: TBrowseInfo): PItemIDList; stdcall;
  far; external 'Shell32.dll' name 'SHBrowseForFolder';
function SHGetPathFromIDList(pidl: PItemIDList; pszPath: LPSTR): BOOL; stdcall;
  far; external 'Shell32.dll' name 'SHGetPathFromIDList';
procedure CoTaskMemFree(pv: Pointer); stdcall; external 'ole32.dll'
  name 'CoTaskMemFree';
{
function SHGetSpecialFolderLocation(hwndOwner: HWND; nFolder: Integer;
  var ppidl: PItemIDList): HResult; stdcall; far; external Shell32
  name 'SHGetSpecialFolderLocation';
}

function Browse(Handle:HWnd; const Directory: string): string;

implementation

uses lngtools;

function ExplorerHook(Wnd: HWnd; Msg: UINT; LParam: LPARAM; Data: LPARAM): Integer; stdcall;
begin
  Result := 0;
  if Msg = BFFM_INITIALIZED then begin
    SendMessage(Wnd, BFFM_SETSELECTION, 1, Longint(PChar(Data)));
  end
  else if Msg = BFFM_SELCHANGED then begin
  end;
end;

function Browse(Handle:HWnd; const Directory: string): string;
var
  s: string;
  p: PChar;
  lpbi: TBrowseInfo;
  ItemIDList: PItemIDList;
begin
  result:='';
  with lpbi do
  begin
    hwndowner := Handle;
    pidlRoot := nil;
    lpszTitle := PChar(LngStr(rsSelectDirectory));
    GetMem(p,255);
    if directory <> '' then
    begin
      p:=StrPCopy(P,Directory);
      pszDisplayName := p;
    end
    else begin
      pszDisplayName := nil;
    end;
    lpfn := ExplorerHook;
    lParam := longint(pszDisplayName);
    ulFlags := BIF_RETURNONLYFSDIRS or BIF_RETURNFSANCESTORS;
  end;
  ItemIDList := SHBrowseForFolder(lpbi);
  result := '';
  if ItemIDList <> nil then
  begin
    SHGetPathFromIDList(ItemIDList,p);
    CoTaskMemFree(ItemIDList);
    s:=p;
  end;
  FreeMem(p,255);
  if s = '' then Exit
  else result := ExpandFileName(s);
end;

end.
