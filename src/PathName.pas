unit PathName;

{$I DEFINE.INC}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  StdCtrls, mGrids, ExtCtrls;

type
  TPathNamesForm = class(TForm)
    gSpec: TAdvGrid;
    bBrowse: TButton;               
    bOK: TButton;
    bCancel: TButton;
    bHelp: TButton;
    llDefZone: TLabel;
    Edit1: TEdit;
    CB: TCheckBox;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bHelpClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bBrowseClick(Sender: TObject);
  private
    { Private declarations }
    Activated: Boolean;
    procedure SetData;
    procedure UpdateConfig;
  public
    { Public declarations }
  end;

function SetupPathNames: Boolean;

implementation

uses
xBase, AltRecs, Recs, LngTools, ShellApi, PathNmEx, RadIni, FileCtrl, xFido, AdrIBox;

{$R *.DFM}

var FidoAddr: TFidoAddress;

procedure TPathNamesForm.FormActivate(Sender: TObject);
begin
  if not Activated then
  begin
    GridFillRowLng(gSpec, rsPNgrid);
    Activated := True;
  end;
end;

procedure TPathNamesForm.SetData;
begin
  Edit1.Text := Addr2Str(IniFile.MainAddr);
  gSpec.Cells[1, 0] := IniFile.HomeDir;
  gSpec.Cells[1, 1] := IniFile.CfgDir;
  gSpec.Cells[1, 2] := IniFile.InSecure;
  gSpec.Cells[1, 3] := IniFile.InCommon;
  gSpec.Cells[1, 4] := IniFile.InTemp;
  gSpec.Cells[1, 5] := IniFile.Outbound;
  gSpec.Cells[1, 6] := IniFile.Log;
  gSpec.Cells[1, 7] := IniFile.FlagsDir;
  CB.Checked := IniFile.D5out;
end;

function SetupPathNames;
var
  PathNamesForm: TPathNamesForm;
begin
  PathNamesForm := TPathNamesForm.Create(Application);
  PathNamesForm.SetData;
  Result := PathNamesForm.ShowModal = mrOK;
  FreeObject(PathNamesForm);
end;

procedure TPathNamesForm.UpdateConfig;
begin
  IniFile.D5out := CB.Checked;
  AltStoreConfig(Handle);
  IniFile.InSecure := gSpec.Cells[1, 2];
  IniFile.InCommon := gSpec.Cells[1, 3];
  IniFile.InTemp := gSpec.Cells[1, 4];
  IniFile.Outbound := gSpec.Cells[1, 5];
  IniFile.Log := gSpec.Cells[1, 6];
  IniFile.FlagsDir := gSpec.Cells[1, 7];
  IniFile.MainAddr := FidoAddr;
  if IniFile.HomeDir <> gSpec.Cells[1, 0] then begin
    IniFile.HomeDir := gSpec.Cells[1, 0];
    IniFile.CfgDir := gSpec.Cells[1, 1];
    If not DirectoryExists(IniFile.HomeDir) then CreateDir(IniFile.HomeDir);
    DisplayInfoLng(rsPNHdc, Handle);
    ShellExecute(0,nil,PChar(ParamStr(0)),
        PChar('delay5000'), PChar(ExtractFilePath(ParamStr(0))), sw_shownormal);
    PostCloseMessage;
    exit
  end;
  if IniFile.CfgDir <> gSpec.Cells[1, 1] then begin
    IniFile.CfgDir := gSpec.Cells[1, 1];
    DisplayInfoLng(rsCDCh, Handle);
    ShellExecute(0, nil, PChar(ParamStr(0)),
        PChar('delay5000'), PChar(ExtractFilePath(ParamStr(0))), sw_shownormal);
    PostCloseMessage;
    exit
  end;
  IniFile.StoreCFG;
end;

procedure TPathNamesForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ModalResult <> mrOK then Exit;
  if not ParseAddress(Edit1.Text,FidoAddr) then
  begin
    DisplayErrorLng(rsAdrInNoValidAdr, Handle);
    Action:=caNone;
    exit;
  end;
  UpdateConfig;
end;

procedure TPathNamesForm.bHelpClick(Sender: TObject);
begin
  Application.HelpContext(HelpContext);
end;

procedure TPathNamesForm.FormCreate(Sender: TObject);
begin
  FillForm(Self, rsPathNamesForm);
end;

procedure TPathNamesForm.bBrowseClick(Sender: TObject);
begin
  if InputSingleAddress(LngStr(rsMMBrsNdlAt), FidoAddr, nil) then
    Edit1.Text:=Addr2Str(FidoAddr);
end;

end.
