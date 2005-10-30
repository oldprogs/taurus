unit Extrnls;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  mGrids, StdCtrls, ComCtrls, Buttons;

type
  TExternalsForm = class(TForm)
    bOK: TButton;
    bCancel: TButton;
    bHelp: TButton;
    bImportPwd: TButton;
    PageControl: TPageControl;
    tsPP: TTabSheet;
    tsDrs: TTabSheet;
    gExt: TAdvGrid;
    gDrs: TAdvGrid;
    tsCron: TTabSheet;
    gCrn: TAdvGrid;
    tsFlags: TTabSheet;
    gFlags: TAdvGrid;
    btRunNow: TButton;
    Label1: TLabel;
    tsExteranals: TTabSheet;
    gExternals: TAdvGrid;
    tsHook: TTabSheet;
    gHooks: TAdvGrid;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormActivate(Sender: TObject);
    procedure bHelpClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btRunNowClick(Sender: TObject);
  private
    Activated: Boolean;
    procedure SetData;
  public
  end;


function ConfigureExternals: Boolean;

implementation 

uses Recs, AltRecs, xBase, LngTools, MlrThr, RadIni;

{$R *.DFM}

function ConfigureExternals: Boolean;
var
   ExternalsForm: TExternalsForm;
begin
   ExternalsForm := TExternalsForm.Create(Application);
   ExternalsForm.SetData;
   Result := ExternalsForm.ShowModal = mrOK;
   FreeObject(ExternalsForm);
end;

procedure TExternalsForm.SetData;
var
   i: integer;
begin
   gExt.SetData([Cfg.ExtCollA, Cfg.ExtCollB]);
   gDrs.SetData([Cfg.DrsCollA, Cfg.DrsCollB]);
   gCrn.SetData([Cfg.CrnCollA, Cfg.CrnCollB]);
   gFlags.SetData([AltCfg.FlagsCollA, AltCfg.FlagsCollB]);
   for i := 1 to IniFile.ExtApp.Count do begin
     gExternals.AddLine;
     gExternals.Cells[1,I] := IniFile.ExtApp.Table[I,2];
     gExternals.Cells[2,I] := IniFile.ExtApp.Table[I,1];
   end;
   gExternals.DelLine;
   IniFile.LoadGrid(gHooks);
end;

procedure TExternalsForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
   if ModalResult <> mrOK then Exit;
   if (gCrn.RowCount = 2) and (gCrn[1, 1] = '') and (gCrn[2, 1] = '') then Exit;
   CanClose := CronGridValid(gCrn);
end;

procedure TExternalsForm.FormActivate(Sender: TObject);
begin
   if Activated then Exit;
   Activated := True;
   GridFillColLng(gExt, rsExtExt);
   GridFillColLng(gDrs, rsExtDrs);
   GridFillColLng(gCrn, rsExtCrn);
   GridFillColLng(gFlags, rsExtFlags);
   GridFillColLng(gExternals, rsExtTools);
   GridFillColLng(gHooks, rsExtHooks);
end;

procedure TExternalsForm.bHelpClick(Sender: TObject);
begin
   Application.HelpContext(HelpContext);
end;

procedure TExternalsForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
   i: integer;
   x: TRadArrRec;
begin
   if ModalResult <> mrOK then Exit;
   CfgEnter;
   gExt.GetData([Cfg.ExtCollA, Cfg.ExtCollB]);
   gDrs.GetData([Cfg.DrsCollA, Cfg.DrsCollB]);
   gCrn.GetData([Cfg.CrnCollA, Cfg.CrnCollB]);
   CfgLeave;
   StoreConfig(Handle);
   for i := 1 to gExternals.RowCount - 1 do begin
      x.Table[i, 1] := gExternals.Cells[2, i];
      x.Table[i, 2] := gExternals.Cells[1, i];
   end;
   x.Count := gExternals.RowCount - 1;
   IniFile.ExtApp := x;
   IniFile.StoreCFG;
   IniFile.SaveGrid(gHooks);
   AltCfgEnter;
   gFlags.GetData([AltCfg.FlagsCollA, AltCfg.FlagsCollB]);
   AltCfgLeave;
   AltStoreConfig(Handle);
end;

procedure TExternalsForm.FormCreate(Sender: TObject);
begin
   FillForm(Self, rsExternalsForm);
end;

procedure TExternalsForm.btRunNowClick(Sender: TObject);

var
   Dir, ComSpec, es, ff{, pclass}: string;
   PDir: Pointer;
   PI: TProcessInformation;
   ProcNfo: MlrThr.TProcessNfo;
//  ProcessColl: TColl;

const
   IDet : array[Boolean] of DWORD = (0, DETACHED_PROCESS);

   function CmdPattern(const shell:string): string;
   begin
      if (Win32Platform = VER_PLATFORM_WIN32_NT) and (shell <> 'command.com') then begin
         Result := '%s /C "%s"';
      end else begin
         Result := '%s /C %s';
      end;
   end;

begin
   ComSpec := GetEnvVariable('COMSPEC');
   case PageControl.ActivePage.Tag of
    1: es := gExt.Cells[2, gExt.row];
    2: es := gFlags.Cells[2, gFlags.row];
    3: es := gDrs.Cells[2, gDrs.row];
    4: es := gCrn.Cells[2, gCrn.row];
    5: es := gExternals.Cells[2, gExternals.row];
    6: es := gHooks.Cells[2, gHooks.row];
    else GlobalFail('PageControl.ActivePage.Tag = %d (out of range)', [PageControl.ActivePage.Tag]);
   end;
//  PDir := nil;
   GetWrd(es, ff, ' ');
   Dir := ExtractFileDir(ff);
   if DirExists(Dir) = 1 then PDir := PChar(Dir) else PDir := PChar(HomeDir);
   if MatchMask(ff, '*.exe') then begin
      case PageControl.ActivePage.Tag of
      1: es := gExt.Cells[2, gExt.row];
      2: es := gFlags.Cells[2, gFlags.row];
      3: es := gDrs.Cells[2, gDrs.row];
      4: es := gCrn.Cells[2, gCrn.row];
      5: es := gExternals.Cells[2, gExternals.row];
      6: es := gHooks.Cells[2, gHooks.row];
      else GlobalFail('PageControl.ActivePage.Tag = %d (out of range)', [PageControl.ActivePage.Tag]);
      end;
   end else begin
      case PageControl.ActivePage.Tag of
      1: es := Format(CmdPattern(ComSpec), [Comspec, gExt.Cells[2, gExt.row]]);
      2: es := Format(CmdPattern(ComSpec), [Comspec, gFlags.Cells[2, gFlags.row]]);
      3: es := Format(CmdPattern(ComSpec), [Comspec, gDrs.Cells[2, gDrs.row]]);
      4: es := Format(CmdPattern(ComSpec), [Comspec, gCrn.Cells[2, gCrn.row]]);
      5: es := Format(CmdPattern(ComSpec), [Comspec, gExternals.Cells[2, gExternals.row]]);
      6: es := Format(CmdPattern(ComSpec), [Comspec, gHooks.Cells[2, gHooks.row]]);
      else GlobalFail('PageControl.ActivePage.Tag = %d (out of range)', [PageControl.ActivePage.Tag]);
      end;
   end;
   if not ExecProcess(es, PI, nil, Pdir, False, IDet[false] or NORMAL_PRIORITY_CLASS or CREATE_SUSPENDED, swShow) then
   else
   begin
      ProcNfo := TProcessNfo.Create;
      ProcNfo.PI := PI;
      ProcNfo.Name := gExt.Cells[2,gExt.row];
      ResumeThread(PI.hThread);
   end;
end;

end.

