unit LogView;
interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ImgList, Dialogs, StdCtrls, xBase, ExtCtrls, Menus,
  JvExControls, JvEditor, JvEditorCommon,
  Logv_Conf;

type

  TLogViewer = class(TForm)
    GutterImages: TImageList;
    TM: TTimer;
    PM: TPopupMenu;
    ColorsSetup1: TMenuItem;
    ClearLog1: TMenuItem;
    N1: TMenuItem;
    Panel1: TPanel;
    mmView: TJvEditor;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure TMTimer(Sender: TObject);
    procedure ColorsSetup1Click(Sender: TObject);
    procedure ClearLog1Click(Sender: TObject);
    procedure mmViewPaintGutter(Sender: TObject; Canvas: TCanvas);
    procedure mmViewGetLineAttr(Sender: TObject; var Line: string;
      Index: Integer; var Attrs: TLineAttrs);
  private
    { Private declarations }
    fLogName: string;
    fTime: cardinal;
    oTime: cardinal;
    procedure SetLogName(const s: string);
  public
    { Public declarations }
    property LogName: string read fLogName write SetLogName;
  end;

var
  LogViewer: TLogViewer;

implementation

uses RadIni, RadSav, Plus, Wizard, OutBound;

{$R *.dfm}

procedure TLogViewer.SetLogName;
var
  tr: integer;
  st: TStream;
begin
  mmView.BeginUpdate;
  mmView.Font.Name := IniFile.LoggerFontName;
  mmView.Font.Size := IniFile.LoggerFontSize;
  if not ExistFile(s) then
  begin
    mmView.Lines.Clear;
    Exit;
  end;
  tr := 0;
  St := TFileStream.Create(s, fmOpenRead or fmShareDenyNone);
  try
    mmView.Lines.LoadFromStream(St);
  finally
    St.Free;
  end;
  mmView.Lines.Add('>->->->-> EOF Marker <-<-<-<-<');
  mmView.EndUpdate;
  tr := mmView.Lines.Count - tr;
  mmView.SetLeftTop(0, mmView.Lines.Count - 40);
  if (mmView.TopRow + tr > mmView.Lines.Count - mmView.VisibleRowCount) or
    (fLogName <> s) then
    mmView.SetLeftTop(0, mmView.Lines.Count - mmView.VisibleRowCount);
  oTime := GetFileTime(s);
  fLogName := s;
end;

procedure TLogViewer.FormCreate(Sender: TObject);
var
  s: string;
begin
  LogViewer := self;
  s := SavFile.ReadString('Sizes', 'LogViewer', '');
  Left := StrToIntDef(ExtractWord(1, s, [',']), Left);
  Top := StrToIntDef(ExtractWord(2, s, [',']), Top);
  Width := StrToIntDef(ExtractWord(3, s, [',']), Width);
  Height := StrToIntDef(ExtractWord(4, s, [',']), Height);
end;

procedure TLogViewer.FormDestroy(Sender: TObject);
begin
  SavFile.WriteString('Sizes', 'LogViewer',
    IntToStr(Left) + ',' +
    IntToStr(Top) + ',' +
    IntToStr(Width) + ',' +
    IntToStr(Height));
end;

procedure TLogViewer.mmViewGetLineAttr(Sender: TObject; var Line: string;
  Index: Integer; var Attrs: TLineAttrs);
var
  i: integer;
  r: TLineAttr;
begin
  Attrs[1].FC := IniFile.LoggerFore;
  Attrs[1].Style := [];
  Attrs[1].BC := IniFile.LoggerBack;
  Attrs[1].Border := IniFile.LoggerBack;
  for i := Low(Attrs) to High(Attrs) do
    Move(Attrs[1], Attrs[i], sizeof(Attrs[1]));
  Move(Attrs[1], r, sizeof(Attrs[1]));

  r := AttrArray[1];

  if (Pos('error', Line) <> 0) or
    (Pos('invalid', Line) <> 0) or
    (Pos('bad', Line) <> 0) or
    (Pos('SYS0', Line) <> 0) or
    (Pos('aborted', Line) <> 0) then
    r := AttrArray[2];

  if (Pos('Calling', Line) <> 0) or
    (Pos('Initializing modem', Line) <> 0) or
    (Pos('Connect', Line) <> 0) or
    (Pos('Sending', Line) <> 0) or
    (Pos('Receiving', Line) <> 0) or
    (Pos('Sent', Line) <> 0) or
    (Pos('Received', Line) <> 0) or
    (Pos('End of batch', Line) <> 0) or
    (Pos('EMSI data receive', Line) <> 0) or
    (Pos('-Poll', Line) <> 0) then
    r := AttrArray[3];

  if (Pos('NO DIALTONE', Line) <> 0) or
    (Pos('BUSY', Line) <> 0) or
    (Pos('ERROR', Line) <> 0) or
    (Pos('RING', Line) <> 0) or
    (Pos('OK', Line) <> 0) or
    (Pos('TAPI', Line) <> 0) or
    (Pos('"GET', Line) <> 0) or
    (Pos('Routing', Line) <> 0) then
    r := AttrArray[4];

  if (Pos('[WZ]', Line) <> 0) or
    (Pos('Password-protected session', Line) <> 0) or
    (Pos('Non-password session', Line) <> 0) or
    (Pos('Station : ', Line) <> 0) or
    (Pos('SysOp : ', Line) <> 0) or
    (Pos('Address : ', Line) <> 0) or
    (Pos('Number : ', Line) <> 0) or
    (Pos('Flags : ', Line) <> 0) or
    (Pos('Mailer : ', Line) <> 0) or
    (Pos('EMSI Addon : ', Line) <> 0) or
    (Pos('Time : ', Line) <> 0) or
    (Pos('M_NUL : ', Line) <> 0) or
    (Pos('"PUT', Line) <> 0) or
    (Pos('+Poll', Line) <> 0) then
    r := AttrArray[5];

  if (Line = '>->->->-> EOF Marker <-<-<-<-<') then
    r := AttrArray[6];

  for i := Low(Attrs) to High(Attrs) do
    Attrs[i] := r;
end;

procedure TLogViewer.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
    Close;
end;

procedure TLogViewer.TMTimer(Sender: TObject);
begin
  fTime := GetFileTime(LogViewer.fLogName);
  if fTime <> oTime then
  begin
    oTime := fTime;
    LogViewer.LogName := LogViewer.LogName;
  end;
end;

procedure TLogViewer.ColorsSetup1Click(Sender: TObject);
begin
  DoConfigureLogV(mmView);
  mmView.Repaint;
end;

procedure TLogViewer.mmViewPaintGutter(Sender: TObject; Canvas: TCanvas);

  procedure Draw(Y, ImageIndex: integer);
  var
    Ro: integer;
    R: TRect;
  begin
    if Y <> -1 then
      with Sender as TJvEditor do
      begin
        Ro := Y - TopRow;
        R := CalcCellRect(0, Ro);
        GutterImages.Draw(Canvas,
          R.Left - GutterWidth + 1,
          R.Top + (CellRect.Height - GutterImages.Height) div 2 + 1,
          ImageIndex);
      end;
  end;

var
  i: Integer;
  R: TRect;
  oldFont: TFont;
begin
  oldFont := TFont.Create;
  try
    oldFont.Assign(Canvas.Font);
    Canvas.Font := mmView.Font;
    with mmView do
      for i := TopRow to TopRow + VisibleRowCount do
      begin
        R := Bounds(2, (i - TopRow) * CellRect.Height, GutterWidth - 2 - 5,
          CellRect.Height);
        Windows.DrawText(Canvas.Handle, PChar(IntToStr(i + 1)), -1, R, DT_RIGHT
          or DT_VCENTER or DT_SINGLELINE);
      end;
  finally
    Canvas.Font := oldFont;
    oldFont.Free;
  end;
  for i := 0 to 9 do
    if mmView.Bookmarks[i].Valid then
      Draw(mmView.Bookmarks[i].Y, i);
end;

procedure TLogViewer.ClearLog1Click(Sender: TObject);
begin
  DelFile('ViewLog', fLogName);
end;

end.
