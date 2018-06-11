unit Logv_Conf;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, 
  JvComponent, JvEditor, JvEditorCommon, JvColorButton, JvColorBox, JvExControls;

type
  TConfig_Logv = class(TForm)
    BitBtn1: TButton;
    BitBtn2: TButton;
    Preview: TJvEditor;
    BitBtn3: TButton;
    GroupBox1: TGroupBox;
    bCk: TCheckBox;
    uCk: TCheckBox;
    kCk: TCheckBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    BcBtn: TJvColorButton;
    FcBtn: TJvColorButton;
    BrdCBtn: TJvColorButton;
    procedure PreviewGetLineAttr(Sender: TObject; var Line: String; index: Integer; var Attrs: TLineAttrs);
    procedure PreviewPaintGutter(Sender: TObject; Canvas: TCanvas);
    procedure FormChange(Sender: TObject);
    procedure UnSelAndScroll(Sender: TObject);
    procedure UpdateForm(Sender: TObject);
    procedure PreviewMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure BcBtnChange(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
  private
    { Private declarations }
    LogView: TJvEditor;
  public
    { Public declarations }
  end;

var
  Config_Logv: TConfig_Logv;
  Sel: integer;
  fC: boolean;

  AttrArray: Array[1..6] of TLineAttr =
           ((FC: clBlack; BC: clWhite; Style: []; Border: clWhite),
            (FC: clRed; BC: clWhite; Style: []; Border: clWhite),
            (FC: clGreen; BC: clWhite; Style: []; Border: clWhite),
            (FC: clMaroon; BC: clWhite; Style: []; Border: clWhite),
            (FC: clNavy; BC: clWhite; Style: []; Border: clWhite),
            (FC: clYellow; BC: clRed; Style: []; Border: clWhite)
           );

procedure DoConfigureLogV(const Host: TJvEditor);

implementation

uses Wizard;

{$R *.dfm}

procedure DoConfigureLogV;
var
   s: TFileStream;
begin
  Config_Logv := TConfig_Logv.Create(nil);
  Config_Logv.LogView := Host;
  sel := 1;
  Config_Logv.Preview.Font.Name := Host.Font.Name;
  Config_Logv.Preview.Font.Size := Host.Font.Size;
  Config_Logv.UpdateForm(nil);
  if Config_Logv.ShowModal = mrOk then
  begin
    s := TFileStream.Create(JustPathName(ParamStr(0)) + '\Taurus.lvc', fmCreate);
    s.Write(AttrArray, SizeOf(AttrArray));
    s.Free;
  end;
  Config_Logv.Free;
end;

procedure TConfig_Logv.PreviewPaintGutter(Sender: TObject; Canvas: TCanvas);
begin
  with Canvas do
  begin
    Pen.Color := clBlack;
    Pen.Style := psSolid;
    Brush.Color := clRed;
    Brush.Style := bsSolid;
    Rectangle(0, (TextHeight('M') * Sel), 12, (TextHeight('M') * (Sel - 1)));
 end;
end;

procedure TConfig_Logv.PreviewGetLineAttr(Sender: TObject; var Line: String; index: Integer; var Attrs: TLineAttrs);
var
  i:integer;
begin
  for i := 0 to 1024 do
    Attrs[i] := AttrArray[index + 1];
end;

procedure TConfig_Logv.UnSelAndScroll(Sender: TObject);
begin
  Preview.SetLeftTop(0, 0);
  Preview.SelStart := 0;
  Preview.SelLength := 0;
end;

procedure TConfig_Logv.PreviewMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Sel := Preview.CaretY + 1;
  UpdateForm(self);
end;

procedure TConfig_Logv.BitBtn3Click(Sender: TObject);
begin
//  ShowMessage ('А хелп то тут ;)');
end;

procedure TConfig_Logv.UpdateForm(Sender: TObject);
begin
  fC := False;
  FcBtn.Color := AttrArray[sel].FC;
  BcBtn.Color := AttrArray[sel].BC;
  BrdCBtn.Color := AttrArray[sel].Border;
  bCk.Checked := (fsBold in AttrArray[sel].Style);
  uCk.Checked := (fsUnderline in AttrArray[sel].Style);
  kCk.Checked := (fsItalic in AttrArray[sel].Style);
  fC := True;
  Preview.Invalidate;
  Logview.Repaint;
end;

procedure TConfig_Logv.FormChange(Sender: TObject);
begin
  AttrArray[sel].FC := FcBtn.Color;
  AttrArray[sel].BC := BcBtn.Color;
  AttrArray[sel].Style := [];
  AttrArray[sel].Border := BrdCBtn.Color;
  if bCk.Checked then
    Include(AttrArray[sel].Style, fsBold);
  if uCk.Checked then
    Include(AttrArray[sel].Style, fsUnderline);
  if kCk.Checked then
    Include(AttrArray[sel].Style, fsItalic);
  UpdateForm(Self);
end;

procedure TConfig_Logv.BcBtnChange(Sender: TObject);
begin
  if fC then
    FormChange(self);
end;

var
  s: TFileStream;

initialization
  if ExistFile(JustPathName(ParamStr(0)) + '\Taurus.lvc') then
  begin
    s := TFileStream.Create(JustPathName(ParamStr(0)) + '\Taurus.lvc', fmOpenRead);
    s.Read(AttrArray, SizeOf(AttrArray));
    s.Free;
  end;

end.
