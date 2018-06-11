unit pref;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, MClasses, ExtCtrls, CheckLst;

type
  TPreferences = class(TForm)
    bOK: TButton;
    bCancel: TButton;
    bHelp: TButton;
    cdColorSelect: TColorDialog;
    cbLanguage: TComboBox;
    lLanguage: TLabel;
    lScan: TLabel;
    seTime: TxSpinEdit;
    gbColors: TGroupBox;
    Shape1: TShape;
    lBackColor: TLabel;
    Shape2: TShape;
    lForeColor: TLabel;
    DefaultColors: TButton;
    sbSystemColors: TButton;
    cbStandartFlags: TCheckBox;
    cbColor: TComboBox;
    gbBOptions: TGroupBox;
    clOptions: TCheckListBox;
    procedure sbSystemColorsClick(Sender: TObject);
    procedure DefaultColorsClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tbMainChange(Sender: TObject);
    procedure Shape1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Shape2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure rbGaugeClick(Sender: TObject);
    procedure bHelpClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure SetData;
    procedure GetData;
  public
    { Public declarations }
  end;

  function SetPref(var i:integer): Boolean;

var
  Preferences: TPreferences;
  icvColorStored: Boolean;
  _icvLogBoxBack,
  _icvSndTotBack,
  _icvRcvTotBack,
  _icvbwListBoxBack,
  _icvbwListBoxFore,
  _icvSndTotFore,
  _icvRcvTotFore,
  _icvLogBoxFore,

  _icvOldMail7Fore,
  _icvOldMail14Fore,
  _icvOldMail21Fore,
  _icvOldMail28Fore,
  _icvOldMail7Back,
  _icvOldMail14Back,
  _icvOldMail21Back,
  _icvOldMail28Back  : integer;

const
  cAlwaysInTray   = 0;
  cUseSpace       = 1;
  cShowBalloon    = 2;
  cShowBalloonMin = 3;
  cSesOK          = 4;
  cSesFail        = 5;
  cHtmlHelp       = 6;

implementation

uses xBase, Recs, FileCtrl, LngTools, RadIni;

{$R *.DFM}

function SetPref(var i:integer): Boolean;
begin
  Preferences := TPreferences.Create(Application);
  Preferences.SetData;
  Preferences.cbColor.ItemIndex:=0;
  Preferences.cbLanguage.ItemIndex:=inifile.lang;
  Result := Preferences.ShowModal = mrOK;
  if result then
  begin
    Preferences.GetData;
    i:=IniFile.lang;
    IniFile.StoreCFG;
  end;
  FreeObject(Preferences);
end;

procedure TPreferences.DefaultColorsClick(Sender: TObject);
begin
  case cbColor.ItemIndex of
    0:
      begin
        _icvSndTotBack := clYellow;
        _icvRcvTotBack := clYellow;
        _icvSndTotFore := clBlack;
        _icvRcvTotFore := clBlack;
      end;
    1:
      begin
        _icvLogBoxBack := clBtnFace;
        _icvLogBoxFore := clWindowText;
      end;
    2:
      begin
        _icvbwListBoxBack := clYellow;
        _icvbwListBoxFore := clBlack;
      end;
    3:
      begin
        _icvOldMail7Fore := clRed;
        _icvOldMail7Back := clWindow;
      end;
    4:
      begin
        _icvOldMail14Fore := clRed;
        _icvOldMail14Back := clWindow;
      end;
    5:
      begin
        _icvOldMail21Fore := clRed;
        _icvOldMail21Back := clWindow;
      end;
    6:
      begin
        _icvOldMail28Fore := clRed;
        _icvOldMail28Back := clWindow;
      end;
  end;
  tbMainChange(nil);
end;

procedure TPreferences.sbSystemColorsClick(Sender: TObject);
begin
  case cbColor.ItemIndex of
    0:
      begin
        _icvSndTotBack := clWindow;
        _icvRcvTotBack := clWindow;
        _icvSndTotFore := clWindowText;
        _icvRcvTotFore := clWindowText;
      end;
    1:
      begin
        _icvLogBoxBack := clBtnFace;
        _icvLogBoxFore := clWindowText;
      end;
    2:
      begin
        _icvbwListBoxBack := clWindow;
        _icvbwListBoxFore := clWindowText
      end;
    3:
      begin
        _icvOldMail7Fore := clWindowText;
        _icvOldMail7Back := clWindow;
      end;
    4:
      begin
        _icvOldMail14Fore := clWindowText;
        _icvOldMail14Back := clWindow;
      end;
    5:
      begin
        _icvOldMail21Fore := clWindowText;
        _icvOldMail21Back := clWindow;
      end;
    6:
      begin
        _icvOldMail28Fore := clWindowText;
        _icvOldMail28Back := clWindow;
      end;
  end;
  tbMainChange(nil);
end;

procedure TPreferences.GetData;
begin
  inifile.lang := Preferences.cbLanguage.ItemIndex;
  inifile.AlwaysInTray  :=  Preferences.clOptions.Checked[cAlwaysInTray];
  inifile.UseSpace      :=  Preferences.clOptions.Checked[cUseSpace];
  inifile.NoHTML        :=  Preferences.clOptions.Checked[cHtmlHelp];
  IniFile.SessionOKFlag      := Preferences.clOptions.Checked[cSesOK];
  IniFile.SessionAbortedFlag := Preferences.clOptions.Checked[cSesFail];
  IniFile.ShowBalloon        := Preferences.clOptions.Checked[cShowBalloon];
  IniFile.ShowBalloonMin     := Preferences.clOptions.Checked[cShowBalloonMin];
end;

procedure TPreferences.SetData;
begin
//  seTime.Value:=icvTFSFlags;
//  Preferences := TPreferences(Sender);
  Preferences.clOptions.Checked[cAlwaysInTray] := inifile.AlwaysInTray;
  Preferences.clOptions.Checked[cUseSpace] := inifile.UseSpace;
  Preferences.clOptions.Checked[cHtmlHelp] := IniFile.NoHTML;

  Preferences.clOptions.Checked[cSesOK]:=IniFile.SessionOKFlag;
  Preferences.clOptions.Checked[cSesFail]:=IniFile.SessionAbortedFlag;
  Preferences.clOptions.Checked[cShowBalloon] := IniFile.ShowBalloon;
  Preferences.clOptions.Checked[cShowBalloonMin] := IniFile.ShowBalloonMin;

  _icvSndTotBack:=IniFile.GaugeBack;
  _icvRcvTotBack:=IniFile.GaugeBack;
  _icvSndTotFore:=IniFile.GaugeFore;
  _icvRcvTotFore:=IniFile.GaugeFore;
  _icvbwListBoxBack:=IniFile.BadWazooBack;
  _icvbwListBoxFore:=IniFile.BadWazooFore;
  _icvLogBoxBack:=IniFile.LoggerBack;
  _icvLogBoxFore:=IniFile.LoggerFore;

  _icvOldMail7Fore  := inifile.OldMail7Fore;
  _icvOldMail14Fore := inifile.OldMail14Fore;
  _icvOldMail21Fore := inifile.OldMail21Fore;
  _icvOldMail28Fore := inifile.OldMail28Fore;
  _icvOldMail7Back  := inifile.OldMail7Back;
  _icvOldMail14Back := inifile.OldMail14Back;
  _icvOldMail21Back := inifile.OldMail21Back;
  _icvOldMail28Back := inifile.OldMail28Back;

  Shape1.Brush.Color := _icvSndTotBack;
  Shape2.Brush.Color := _icvSndTotFore;
end;

procedure TPreferences.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ModalResult <> mrOK then Exit;

  IniFile.GaugeFore:=_icvSndTotFore;
  IniFile.GaugeBack:=_icvSndTotBack;
  IniFile.LoggerFore:=_icvLogBoxFore;
  IniFile.LoggerBack:=_icvLogBoxBack;
  IniFile.BadWazooFore:=_icvbwListBoxFore;
  IniFile.BadWazooBack:=_icvbwListBoxBack;

  inifile.OldMail7Fore      :=  _icvOldMail7Fore;
  inifile.OldMail14Fore     :=  _icvOldMail14Fore;
  inifile.OldMail21Fore     :=  _icvOldMail21Fore;
  inifile.OldMail28Fore     :=  _icvOldMail28Fore;
  inifile.OldMail7Back      :=  _icvOldMail7Back;
  inifile.OldMail14Back     :=  _icvOldMail14Back;
  inifile.OldMail21Back     :=  _icvOldMail21Back;
  inifile.OldMail28Back     :=  _icvOldMail28Back;

//  IniFile.SessionOKFlag := cbSesOK.Checked;
//  IniFile.SessionAbortedFlag := cbSesFail.Checked;

end;

procedure TPreferences.tbMainChange(Sender: TObject);
begin
  case cbColor.ItemIndex of
    0:
      begin
        Shape1.Brush.Color := _icvSndTotBack;
        Shape2.Brush.Color := _icvSndTotFore;
      end;
    1:
      begin
        Shape1.Brush.Color := _icvLogBoxBack;
        Shape2.Brush.Color := _icvLogBoxFore;
      end;
    2:
      begin
        Shape1.Brush.Color := _icvbwListBoxBack;
        Shape2.Brush.Color := _icvbwListBoxFore;
      end;
    3:
      begin
        Shape1.Brush.Color := _icvOldMail7Back;
        Shape2.Brush.Color := _icvOldMail7Fore;
      end;
    4:
      begin
        Shape1.Brush.Color := _icvOldMail14Back;
        Shape2.Brush.Color := _icvOldMail14Fore;
      end;
    5:
      begin
        Shape1.Brush.Color := _icvOldMail21Back;
        Shape2.Brush.Color := _icvOldMail21Fore;
      end;
    6:
      begin
        Shape1.Brush.Color := _icvOldMail28Back;
        Shape2.Brush.Color := _icvOldMail28Fore;
      end;
  end;
end;

procedure TPreferences.Shape1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    if not cdColorSelect.Execute then exit;
    case cbColor.ItemIndex of
      0:
        begin
          _icvSndTotBack := cdColorSelect.Color;
          _icvRcvTotBack := cdColorSelect.Color;
        end;
      1: _icvLogBoxBack := cdColorSelect.Color;
      2: _icvbwListBoxBack := cdColorSelect.Color;
      3: _icvOldMail7Back := cdColorSelect.Color;
      4: _icvOldMail14Back := cdColorSelect.Color;
      5: _icvOldMail21Back := cdColorSelect.Color;
      6: _icvOldMail28Back := cdColorSelect.Color;
    end;
    tbMainChange(nil);
  end;
end;

procedure TPreferences.Shape2MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    if not cdColorSelect.Execute then exit;
    case cbColor.ItemIndex of
      0:
        begin
          _icvSndTotFore := cdColorSelect.Color;
          _icvRcvTotFore := cdColorSelect.Color;
        end;
      1: _icvLogBoxFore := cdColorSelect.Color;
      2: _icvbwListBoxFore := cdColorSelect.Color;
      3: _icvOldMail7Fore := cdColorSelect.Color;
      4: _icvOldMail14Fore := cdColorSelect.Color;
      5: _icvOldMail21Fore := cdColorSelect.Color;
      6: _icvOldMail28Fore := cdColorSelect.Color;
    end;
    tbMainChange(nil);
  end;
end;

procedure TPreferences.rbGaugeClick(Sender: TObject);
begin
  tbMainChange(nil);
end;

procedure TPreferences.bHelpClick(Sender: TObject);
begin
  Application.HelpContext(HelpContext)
end;

procedure TPreferences.FormCreate(Sender: TObject);
begin
  FillForm(self, rsPreferences);
end;

end.
