unit LngTools;

{$I DEFINE.INC}

interface uses Forms, Windows;

{$I ..\LNG\LNGC.INC}
{$I ..\LNG\CCONST.INC}
{$I ..\LNG\FCONST.INC}

const
     idlEnglish    =  0;
{$IFDEF LNG_RUSSIAN} idlRussian    =  1; {$ENDIF}

var
   ResLngBase: Integer;
   CurrentLng: Integer;

procedure GridFillColLng(AG: Pointer; Id: Integer);
procedure _GridFillColLng(AG: Pointer; Id: Integer; lngbase: integer);
procedure GridFillRowLng(AG: Pointer; Id: Integer);
procedure DisplayErrorLng(Id: Integer; Handle: DWORD);
procedure DisplayInfoLng(Id: Integer; Handle: DWORD);
procedure DisplayErrorFmtLng(Id: Integer; const Args: array of const; Handle: DWORD);
function  YesNoConfirmLng(Id: Integer; AHandle: DWORD): Boolean;
function  OkCancelConfirmLng(Id: Integer; AHandle: DWORD): Boolean;
function LngStr(i: Integer): string;
function _LngStr(i: Integer; lngbase:integer): string;
function FormatLng(Id: Integer; const Args: array of const): string;
procedure FillForm(f: TForm; Id: Integer);
procedure _FillForm(f: TForm; Id: Integer; lngbase: integer);
procedure SetLanguage(Index: Integer);
procedure LanguageDone;

implementation

uses
   mGrids, xBase, SysUtils, Classes, Menus, StdCtrls, ExtCtrls,
   ComCtrls, CheckLst, Buttons;

{$R ..\LNG\ENG.RES}

{$IFDEF LNG_RUSSIAN}
{$R ..\LNG\RUS.RES}
{$ENDIF}

procedure GridFillColLng(AG: Pointer; Id: Integer);
var
   g: TAdvGrid absolute AG;
   s,
   z: string;
   i: Integer;
begin
   s := LngStr(Id);
   i := 0;
   while s <> '' do begin
      GetWrd(s, z, '|');
      g.Cells[I, 0] := ' ' + z;
      Inc(i);
   end;
end;

procedure _GridFillColLng(AG: Pointer; Id: Integer; lngbase: Integer);
var
   g: TAdvGrid absolute AG;
   s,
   z: string;
   i: Integer;
begin
   s := _LngStr(Id, lngbase);
   i := 0;
   while s <> '' do begin
      GetWrd(s, z, '|');
      g.Cells[I, 0] := ' ' + z;
      Inc(i);
   end;
end;

procedure GridFillRowLng(AG: Pointer; Id: Integer);
var
   g: TAdvGrid absolute AG;
   s,
   z: string;
   i: Integer;
begin
   s := LngStr(Id);
   i := 0;
   while s <> '' do begin
      GetWrd(s, z, '|');
      g.Cells[0, I] := ' ' + z;
      Inc(i);
   end;
end;

procedure DisplayErrorLng(Id: Integer; Handle: DWORD);
begin
   DisplayError(LngStr(Id), Handle);
end;

procedure DisplayInfoLng(Id: Integer; Handle: DWORD);
begin
   DisplayCustomInfo(LngStr(Id), Handle);
end;

procedure DisplayErrorFmtLng(Id: Integer; const Args: array of const; Handle: DWORD);
begin
   DisplayError(FormatLng(Id, Args), Handle);
end;

function LngStr(i: Integer): string;
const
   StrBufSize = $1000;
var
   Buf: array[0..StrBufSize] of Char;
   l: Integer;
begin
//  SetThreadLocale(LANG_RUSSIAN);
   l := LoadString(HInstance, i + ResLngBase, @Buf, StrBufSize);
   if l = 0 then GlobalFail('LoadString Idx %d Error %d (ResLngBase=%d)', [i, GetLastError, ResLngBase]);
   SetLength(Result, l);
   Move(Buf, Result[1], l);
end;

function _LngStr(i: Integer; lngbase:integer): string;
const
   StrBufSize = $1000;
var
   Buf: array[0..StrBufSize] of Char;
   l: Integer;
begin
//  SetThreadLocale(LANG_RUSSIAN);
   l := LoadString(HInstance, i + LngBase, @Buf, StrBufSize);
   if l = 0 then GlobalFail('LoadString Idx %d Error %d (ResLngBase=%d)', [i, GetLastError, ResLngBase]);
   SetLength(Result, l);
   Move(Buf, Result[1], l);
end;

function FormatLng(Id: Integer; const Args: array of const): string;
begin
   Result := Format(LngStr(Id), Args);
end;

function  YesNoConfirmLng(Id: Integer; AHandle: DWORD): Boolean;
begin
   Result := YesNoConfirm(LngStr(Id), AHandle);
end;

function  OkCancelConfirmLng(Id: Integer; AHandle: DWORD): Boolean;
begin
   Result := OkCancelConfirm(LngStr(Id), AHandle);
end;

procedure FillForm;
var
   s,
   z,
   u: string;
   L: TStringColl;
   i,
   j: Integer;
   n: Integer;
   C: TComponent;
   t: TTreeNode;
begin
   L := TStringColl.Create;
   L.LoadFromString(LngStr(Id));
   F.Caption := L[0];
   for i := 1 to L.Count - 1 do begin
      s := L[i];
      GetWrd(s, z, '|');
      C := F.FindComponent(z);
      if C = nil then Continue;
      GetWrd(s, z, '|');
      if C is TMenuItem then TMenuItem(C).Caption := z else
      if C is TLabel then TLabel(C).Caption := z else
      if C is TStaticText then TStaticText(C).Caption := z else
      if C is TButton then TButton(C).Caption := z else
      if C is TSpeedButton then TSpeedButton(C).Caption := z else
      if C is TCheckBox then TCheckBox(C).Caption := z else
      if C is TRadioButton then TRadioButton(C).Caption := z else
      if C is TGroupBox  then TGroupBox (C).Caption := z else
      if C is TPanel then TPanel(C).Caption := z else
      if C is TRadioGroup then begin
         TRadioGroup(C).Caption := z;
         j := 0;
         while s <> '' do begin
            GetWrd(s, z, '|');
            TRadioGroup(C).Items[j] := z;
            Inc(j);
         end;
      end else
      if C is TPageControl then begin
         TPageControl(C).Pages[0].Caption := z;
         j := 1;
         while s <> '' do begin
            GetWrd(s, z, '|');
            TPageControl(C).Pages[j].Caption := z;
            Inc(j);
         end;
      end else
      if C is TListView then begin
         TListView(C).Columns[0].Caption := z;
         j := 1;
         while s <> '' do begin
            GetWrd(s, z, '|');
            TListView(C).Columns[j].Caption := z;
            Inc(j);
         end;
      end else
      if C is THeaderControl then begin
         THeaderControl(C).Sections[0].Text := z;
         j := 1;
         while s <> '' do begin
            GetWrd(s, z, '|');
            THeaderControl(C).Sections[j].Text := z;
            Inc(j);
         end;
      end else
      if C is TComboBox then begin
         j := 0;
         while s <> '' do begin
            GetWrd(s, z, '|');
            TComboBox(C).Items[j] := z;
            Inc(j);
            if TComboBox(C).Items.Count - 1 < j then break;
         end;
      end else
      if C is TCheckListBox then begin
         j := 0;
         while s <> '' do begin
            GetWrd(s, z, '|');
            TCheckListBox(C).Items[j] := z;
            Inc(j);
            if TCheckListBox(C).Items.Count - 1 < j then break;
         end;
      end else
      if C is TTreeView then begin
         j := 0;
         s := z + '|' + s;
         while s <> '' do begin
            GetWrd(s, z, '|');
            u := z;
            n := 0;
            while u <> '' do begin
               GetWrd(u, z, ';');
               if n = 0 then begin
                  TTreeView(C).Items[j].Text := z;
               end else begin
                  t := TTreeView(C).Items[j];
                  t.Item[n - 1].Text := z;
               end;
               inc(n);
            end;
            inc(j);
         end;
      end;
   end;
   FreeObject(L);
end;

procedure _FillForm;
var
   s,
   z,
   u: string;
   L: TStringColl;
   i,
   j: Integer;
   n: Integer;
   C: TComponent;
   t: TTreeNode;
begin
   L := TStringColl.Create;
   L.LoadFromString(_LngStr(Id, lngbase));
   F.Caption := L[0];
   for i := 1 to L.Count - 1 do begin
      s := L[i];
      GetWrd(s, z, '|');
      C := F.FindComponent(z);
      if C = nil then Continue;
      GetWrd(s, z, '|');
      if C is TMenuItem then TMenuItem(C).Caption := z else
      if C is TLabel then TLabel(C).Caption := z else
      if C is TStaticText then TStaticText(C).Caption := z else
      if C is TButton then TButton(C).Caption := z else
      if C is TCheckBox then TCheckBox(C).Caption := z else
      if C is TRadioButton then TRadioButton(C).Caption := z else
      if C is TGroupBox  then TGroupBox (C).Caption := z else
      if C is TPanel then TPanel(C).Caption := z else
      if C is TRadioGroup then begin
         TRadioGroup(C).Caption := z;
         j := 0;
         while s <> '' do begin
            GetWrd(s, z, '|');
            TRadioGroup(C).Items[j] := z;
            Inc(j);
         end;
      end else
      if C is TPageControl then begin
         TPageControl(C).Pages[0].Caption := z;
         j := 1;
         while s <> '' do begin
            GetWrd(s, z, '|');
            TPageControl(C).Pages[j].Caption := z;
            Inc(j);
         end;
      end else
      if C is TListView then begin
         TListView(C).Columns[0].Caption := z;
         j := 1;
         while s <> '' do begin
            GetWrd(s, z, '|');
            TListView(C).Columns[j].Caption := z;
            Inc(j);
         end;
      end else
      if C is THeaderControl then begin
         THeaderControl(C).Sections[0].Text := z;
         j := 1;
         while s <> '' do begin
            GetWrd(s, z, '|');
            THeaderControl(C).Sections[j].Text := z;
            Inc(j);
         end;
      end else
      if C is TComboBox then begin
         j := 0;
         while s <> '' do begin
            GetWrd(s, z, '|');
            TComboBox(C).Items[j] := z;
            Inc(j);
            if TComboBox(C).Items.Count - 1 < j then break;
         end;
      end else
      if C is TCheckListBox then begin
         j := 0;
         while s <> '' do begin
            GetWrd(s, z, '|');
            TCheckListBox(C).Items[j] := z;
            Inc(j);
            if TCheckListBox(C).Items.Count - 1 < j then break;
         end;
      end else
      if C is TTreeView then begin
         j := 0;
         s := z + '|' + s;
         while s <> '' do begin
            GetWrd(s, z, '|');
            u := z;
            n := 0;
            while u <> '' do begin
               GetWrd(u, z, ';');
               if n = 0 then begin
                  TTreeView(C).Items[j].Text := z;
               end else begin
                  t := TTreeView(C).Items[j];
                  t.Item[n - 1].Text := z;
               end;
               inc(n);
            end;
            inc(j);
         end;
      end;
   end;
   FreeObject(L);
end;

procedure SetLanguage;
begin
   CurrentLng := Index;
   case Index of
   MaxInt :;
   idlRussian: ResLngBase := LngBaseRussian;
   else
      begin
         CurrentLng := 0;
         ResLngBase := LngBaseEnglish;
      end;
   end;
end;

procedure LanguageDone;
begin
end;

initialization
   ResLngBase := LngBaseEnglish;
   CurrentLng := -1;
end.
