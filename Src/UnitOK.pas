unit UnitOK;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, Menus;

const
  WM_UClose = WM_USER + 300;

type
  TDF = class(TForm)
    OK: TButton;
    M1: TMemo;
    procedure OKClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure WMClose(var Msg: TMessage); message WM_UClose;
    procedure HKEnter(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure M1Enter(Sender: TObject);
  private
    { Private declarations }
    BB: string;
  public
    { Public declarations }
    ModResult: integer;
  end;

  function MsgOK(C, M: string; B: string = ''): integer; overload;
  function MsgOK(C, M: string; B: array of pchar): integer; overload;

var
  DF: TDF;

implementation

uses UWrd, Math;

{$R *.DFM}

function MsgOK(C, M: string; B: string = ''): integer;
var ST: TStringList;
    CN: integer;
    Wd,
    Ht: integer;
    BW: integer;
    BL: integer;
    II: integer;
    MM: TButton;
    OK: boolean;
begin
   DF := TDF.Create(Application);
   DF.M1.Color := DF.Color;
   BW := 0;
   for ii := 1 to words(B, '/') do begin
      BW := Max(BW, DF.Canvas.TextWidth('  ' + wordn(B, '/', ii) + '  '));
   end;
   if BW < 80 then BW := 80;
   BL := BW * words(B, '/') + 20 * (words(B, '/') - 1);

   if DF.Constraints.MaxWidth < BL + 80 then begin
      DF.Constraints.MaxWidth := BL + 80;
      DF.Constraints.MinWidth := BL + 80;
      DF.Width                := BL + 80;
      DF.Invalidate;
   end;

   MM := nil;

   if B <> 'SHOW' then begin
      for ii := 1 to words(B, '/') do begin
         MM := TButton.Create(DF);
         MM.Width       := BW;
         MM.Caption     := '  ' + wordn(B, '/', ii) + '  ';
         MM.ParentFont  := True;
         MM.OnClick     := DF.OKClick;
         MM.Tag         := ii;
         DF.InsertControl(MM);
      end;
   end;

   DF.Caption := C;
   DF.M1.Lines.Clear;
   DF.M1.Lines.Add(#13#10#13#10 + M);
   ST := TStringList.Create;
   ST.Assign(DF.M1.Lines);
   Wd := 0;
   Ht := 0;
   for CN := 0 to ST.Count - 1 do begin
      If DF.Canvas.TextWidth(ST[CN]) + 40 > Wd then
         Wd := DF.Canvas.TextWidth(ST[CN]) + 80;
      Ht := Ht + DF.Canvas.TextHeight('H') + 2;
   end;
   ST.Free;
   DF.ClientWidth := Max(Wd, BL + 80);
   if (Wd < DF.OK.Width) and (B = '') then DF.ClientWidth := DF.OK.Width + 2;
   DF.M1.Height := Ht;
   if (B = '') or (B = 'SHOW') then begin
      DF.OK.Left      := DF.Width div 2 - DF.OK.Width div 2 - 5;
      DF.OK.Top       := DF.M1.Height + 40;
      DF.ClientHeight := DF.M1.Height + DF.OK.Height + 60;
      DF.OK.Visible   := True;
   end else begin
      DF.OK.Free;
      DF.ClientHeight  := DF.M1.Height + MM.Height + 60;
      OK := True;
      while OK do begin
         OK := False;
         for ii := 0 to DF.ComponentCount - 1 do begin
            if DF.Components[ii] is TButton then begin
               MM := DF.Components[ii] as TButton;
               MM.Left := DF.Width div 2 - BL div 2 + (MM.Tag - 1) * (BW + 20) - (DF.Width - DF.ClientWidth) div 2;
               MM.Top  := DF.M1.Height + 40;
               if MM.Left < 20 then begin
                  DF.Constraints.MaxWidth := DF.Width - 2 * (MM.Left - 20);
                  DF.Constraints.MinWidth := DF.Constraints.MaxWidth;
                  DF.Width                := DF.Constraints.MaxWidth;
                  OK := True;
                  break;
               end;
            end;
         end;
      end;
   end;
   DF.ModResult := 0;
   Result := 0;
   if B = 'SHOW' then begin
      DF.BB := B;
      DF.Show;
   end else begin
      DF.ShowModal;
      Result := DF.ModResult;
      DF.Free;
      DF := nil;
   end;
end;

function MsgOK(C, M: string; B: array of pchar): integer; overload;
var i: integer;
    s: string;
begin
   s := '';
   for i := 0 to high(B) do s := s + '/' + B[i];
   s := copy(s, 2, length(s) - 1);
   Result := MsgOK(C, M, S);
end;

procedure TDF.OKClick(Sender: TObject);
begin
   if Sender is TButton then begin
      ModResult := (Sender as TButton).Tag;
   end else begin
      ModResult := 1;
   end;
   ModalResult := 2;
end;

procedure TDF.FormKeyPress(Sender: TObject; var Key: Char);
begin
   if Key = #13 then begin
      OKClick(DF.ActiveControl);
   end else
   if Key = #27 then begin
      ModResult   := 0;
      ModalResult := mrCancel;
   end;
end;

procedure TDF.WMClose;
begin
   inherited;
   ModResult := Msg.WParam;
   ModalResult := 2;
   if BB = 'SHOW' then Close;
end;

procedure TDF.HKEnter(Sender: TObject);
begin
   M1.SelectAll;
   M1.CopyToClipboard;
end;

procedure TDF.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Action := caHide;
   if BB = 'SHOW' then Action := caFree;
end;

procedure TDF.M1Enter(Sender: TObject);
begin
   DF.Next;
end;

end.
