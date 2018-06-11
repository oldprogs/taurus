unit MdmCmd;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, MClasses;

type
  TModemCmdForm = class(TForm)
    eModemCommand: THistoryLine;
    bSend: TButton;
    bClose: TButton;
    lModemCommand: TLabel;
    bHelp: TButton;
    cbInit: TCheckBox;
    procedure eModemCommandChange(Sender: TObject);
    procedure bSendClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bHelpClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
  public
    P: Pointer;
  end;

implementation

uses MlrThr, MlrForm, LngTools, RadSav, Wizard;

{$R *.DFM}

procedure TModemCmdForm.eModemCommandChange(Sender: TObject);
begin
  bSend.Enabled := eModemCommand.Text <> '';
end;

procedure TModemCmdForm.bSendClick(Sender: TObject);
var
  s: string;
  T: TMailerForm;
begin
  s := eModemCommand.Text;
  if s = '' then Exit;
  if s[Length(s)] <> '|' then s := s + '|';
  HistoryAdd(eModemCommand.HistoryID, s);
  T := P;
  T.InsertEvt(TMlrEvtSendMdmCmd.Create(s));
  eModemCommand.SelectAll;
end;

procedure TModemCmdForm.FormCreate(Sender: TObject);
var
   s: string;
begin
   FillForm(Self, rsModemCmdForm);
   s := SavFile.ReadString('Sizes', 'MdmCmd', '');
   Left := StrToIntDef(ExtractWord(1, s, [',']), Left);
   Top := StrToIntDef(ExtractWord(2, s, [',']), Top);
   Width := StrToIntDef(ExtractWord(3, s, [',']), Width);
   Height := StrToIntDef(ExtractWord(4, s, [',']), Height);
   cbInit.Checked := SavFile.ReadBool('Sizes', 'IniMdm', True);
end;

procedure TModemCmdForm.bHelpClick(Sender: TObject);
begin
  Application.HelpContext(HelpContext);
end;

{$I define.inc}

procedure TModemCmdForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   if ModalResult  = 1 then begin
      Action := caNone;
{$IFDEF AUTO_NODELIST}
      ModalResult := 0;
{$ENDIF}  // ;)
   end else
   if not cbInit.Checked then begin
      ModalResult := 3;
   end;
end;

procedure TModemCmdForm.FormDestroy(Sender: TObject);
begin
   SavFile.WriteString('Sizes', 'MdmCmd',
      IntToStr(Left) + ',' +
      IntToStr(Top) + ',' +
      IntToStr(Width) + ',' +
      IntToStr(Height));
   SavFile.WriteBool('Sizes', 'IniMdm', cbInit.Checked);
end;

end.
