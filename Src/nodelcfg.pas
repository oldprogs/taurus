unit NodeLCfg;

{$I DEFINE.INC}

interface

uses
  Forms, Controls, mGrids, ComCtrls, Classes, StdCtrls, Windows, ExtCtrls;

type
  TNodeListCfgForm = class(TForm)
    bOK: TButton;
    bCancel: TButton;
    bHelp: TButton;
    pg: TPageControl;
    Files: TTabSheet;
    Phones: TTabSheet;
    PanelGrid1: TPanel;
    gNL: TAdvGrid;
    Panel1: TPanel;
    gPhn: TAdvGrid;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bHelpClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    Activated: Boolean;
    Crc32: DWORD;
    procedure SetData;
  public
    { Public declarations }
  end;

procedure SetupNodelist;

implementation

uses xBase, Recs, LngTools, xFido, AltRecs, Wizard;

{$R *.DFM}

procedure TNodeListCfgForm.FormActivate(Sender: TObject);
begin
  if not Activated then
  begin
    GridFillColLng(gNL, rsNdlCNL);
    GridFillColLng(gPhn, rsNdlCPhn);
  end;
end;

procedure SetupNodelist;
var
  NodeListCfgForm: TNodeListCfgForm;
begin
  NodeListCfgForm := TNodeListCfgForm.Create(Application);
  NodeListCfgForm.SetData;
  NodeListCfgForm.ShowModal;
  FreeObject(NodeListCfgForm);
end;

procedure TNodeListCfgForm.SetData;
begin
  with Cfg.Nodelist do
  begin
    gNL.SetData([Files, AltCfg.NodelistDataDomain]);
    gPhn.SetData([SrcPfx, DstPfx]);
    Crc32 := Files.Crc32(AltCfg.NodelistDataDomain.Crc32(SrcPfx.Crc32(DstPfx.Crc32(CRC32_INIT))));
    gNL.RenumberRows;
    gPhn.RenumberRows;
  end
end;

procedure TNodeListCfgForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
  var i: integer;
      s: string;
begin
  if ModalResult <> mrOK then Exit;
  for i := 1 to gNL.RowCount - 1 do begin
     s := gNL.Cells[2, i];
     if pos('.', s) > 0 then Action := caNone;
     if pos('@', s) > 0 then Action := caNone;
     s := ExtractWord(1, gNL.Cells[2, i], ['.']);
     if (length(s) > 0) and (s[1] = '@') then delete(s, 1, 1);
     gNL.Cells[2, i] := s;
  end;
  with Cfg.Nodelist do
  begin
    CfgEnter;
    AltCfgEnter;
    gNL.GetData([Files, AltCfg.NodelistDataDomain]);
    AltCfgLeave;
    gPhn.GetData([SrcPfx, DstPfx]);
    CfgLeave;
    if Crc32 = Files.Crc32(AltCfg.NodelistDataDomain.Crc32(SrcPfx.Crc32(DstPfx.Crc32(CRC32_INIT)))) then Exit;
  end;
  StoreConfig(Handle);
  AltStoreConfig(Handle);
end;

procedure TNodeListCfgForm.bHelpClick(Sender: TObject);
begin
  Application.HelpContext(HelpContext);
end;

procedure TNodeListCfgForm.FormCreate(Sender: TObject);
begin
  pg.Height := Height - 77;
  FillForm(Self, rsNodeListCfgForm);
end;

procedure TNodeListCfgForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  SrcPfx, DstPfx: TStringColl;

function CheckColl(AColl: TStringColl; AColumn: Integer): Boolean;
var
  s: string;
  i: Integer;
begin
  for i := 0 to CollMax(AColl) do
  begin
    s := AColl[i];
    if not ValidPhnPrefix(s) then
    begin
      pg.ActivePage := Phones;
      gPhn.Col := AColumn;
      gPhn.Row := i + 1;
      gPhn.SetFocus;
      DisplayErrorFmtLng(rsDlPfxNV, [s, i + 1], Handle);
      CanClose := False;
      Break;
    end;
  end;
  Result := CanClose;
end;

begin
  if ModalResult <> mrOK then Exit;
  SrcPfx := TStringColl.Create;
  DstPfx := TStringColl.Create;
  gPhn.GetData([SrcPfx, DstPfx]);
  repeat
    if not CheckColl(SrcPfx, 1) then Break;
//    if not CheckColl(DstPfx, 2) then Break;
  until True;
  FreeObject(SrcPfx);
  FreeObject(DstPfx);
end;

end.
