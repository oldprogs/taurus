unit FidoStat;

interface

{$I DEFINE.INC}

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, mGrids, Recs, ComCtrls, Buttons, Dialogs;

type
  TFidoTemplateEditor = class(TForm)
    bOK: TButton;
    bCancel: TButton;
    bHelp: TButton;
    lTplName: TLabel;
    lName: TEdit;
    PageControl: TPageControl;
    tsEMSI: TTabSheet;
    tsBanner: TTabSheet;
    gTpl: TAdvGrid;
    eBan: TMemo;
    tsAKA: TTabSheet;
    gAKA: TAdvGrid;
    cbGetFromFile: TCheckBox;
    sbGet: TSpeedButton;
    eFileName: TEdit;
    od: TOpenDialog;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure bHelpClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbGetFromFileClick(Sender: TObject);
    procedure SetEnabledO(enable: boolean);
    procedure sbGetClick(Sender: TObject);
  private
    Activated: Boolean;
  public
    Station: TStationRec;
    procedure SetData;
  end;

function EditStation(Station: Pointer):Boolean;

implementation uses xBase, xFido, LngTools, AltRecs;

{$R *.DFM}

procedure TFidoTemplateEditor.SetData;
begin
  lName.Text := Station.FName;
  gTpl.SetData([Station.Data]);
  eBan.SetTextBuf(PChar(Station.Banner));
  gAKA.SetData([Station.AkaA, Station.AkaB]);
end;

procedure TFidoTemplateEditor.SetEnabledO(enable: boolean);
begin
  cbGetFromFile.Checked := enable;
  eBan.Enabled := not cbGetFromFile.Checked;
  eFileName.Enabled := not eBan.Enabled;
  sbGet.Enabled := eFileName.Enabled
end;

function EditStation;
var
  FidoTemplateEditor: TFidoTemplateEditor;
begin
  FidoTemplateEditor := TFidoTemplateEditor.Create(Application);
  FidoTemplateEditor.Station := Station;
  FidoTemplateEditor.SetData;
  FidoTemplateEditor.SetEnabledO(_icvGetFromFile[0]=1);
  Result := FidoTemplateEditor.ShowModal = mrOK;
  FreeObject(FidoTemplateEditor);
end;

procedure TFidoTemplateEditor.FormActivate(Sender: TObject);
begin
  if not Activated then
  begin
    GridFillRowLng(gTpl, rsStatGrid);
    GridFillColLng(gAKA, rsStatAKA);
    Activated := True;
  end;
  {$IFDEF EXTREME}
  // grid size adjustment
  gTpl.Height := (gTpl.DefaultRowHeight + 1) * 6 + 2 + GetSystemMetrics(SM_CYBORDER) * 2;
  {$ENDIF}
end;

procedure TFidoTemplateEditor.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ModalResult <> mrOK then Exit;
  Station.FName := lName.Text;
  gTpl.GetData([Station.Data]);
  Station.Banner := ControlString(eBan);
  gAKA.GetData([Station.AkaA, Station.AkaB]);
  _icvGetFromFile[0]:=ord(cbGetFromFile.Checked);
  AltCfgEnter;
//  gFlags.GetData([AltCfg.FlagsCollA, AltCfg.FlagsCollB]);
  AltCfg.AltStationRec.BannerFile:=eFileName.Text;
  AltCfgLeave;
  AltStoreConfig(Handle);
end;

procedure TFidoTemplateEditor.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if ModalResult <> mrOK then Exit;
  CanClose := False;
  if not ValidateAddrs(gTpl[1,1], Handle) then Exit;
  if not ValidAKAGrid(gAKA) then Exit;
  CanClose := True;
end;

procedure TFidoTemplateEditor.bHelpClick(Sender: TObject);
begin
  Application.HelpContext(HelpContext);
end;

procedure TFidoTemplateEditor.FormCreate(Sender: TObject);
begin
  FillForm(Self, rsFidoTemplateEditor);
  eFileName.Text:=AltCfg.AltStationRec.BannerFile;
end;

procedure TFidoTemplateEditor.cbGetFromFileClick(Sender: TObject);
begin
  SetEnabledO(cbGetFromFile.Checked);
end;

procedure TFidoTemplateEditor.sbGetClick(Sender: TObject);
begin
  if od.Execute then eFileName.Text := od.FileName
end;

end.


