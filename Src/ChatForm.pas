unit ChatForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls;

type
  TChat = class(TForm)
    Status: TStatusBar;
    Panel1: TPanel;
    eType: TEdit;
    Panel2: TPanel;
    Memo1: TMemo;
    Memo2: TMemo;
    procedure Memo2KeyPress(Sender: TObject; var Key: Char);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure EnableMenuItems(e: boolean);
    procedure FormDeactivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
//    Log: TLogContainer;
    ChatStr: string;
    DispStr: string;
    LastKey: TDateTime;
    oldshortcut1,
    oldshortcut2,
    oldshortcut3: TShortCut;
    fRemoteVisible: boolean;
    function GetChatStr: string;
    function GetTimeout: integer;
    procedure SetRemoteVisible(v: boolean);
  public
    { Public declarations }
    procedure AddMsg(const t: string);
    property ChatBuf: string read GetChatStr;
    property TimeOut: integer read GetTimeout;
    property RemoteVisible: boolean read fRemoteVisible write SetRemoteVisible;
  end;

implementation

uses MlrForm, MlrThr, Plus, Util, xbase, wizard, BleepInt, RadIni;

{$R *.dfm}

procedure TChat.Memo2KeyPress(Sender: TObject; var Key: Char);
var
  Ch: char;
  St: string;
begin
   LastKey := Time();
   if Key = #27 then begin
      Visible := False;
      exit;
   end;
   Ch := Key;
   if Key = #13 then
   begin
     ChatStr := Win2Dos(eType.Text) + #10;
     DispStr := ChatStr;
     eType.Text := '';
   end else begin
     eType.Text := eType.Text + Ch;
     St := eType.Text;
     processbs(St);
     eType.Text := St;
     eType.SelStart := Length(eType.Text);
   end;
{   ChatStr := ChatStr + Win2Dos(Ch);}
end;

function TChat.GetChatStr;
var
  str, str1: string;
  i: integer;
begin
   Result := ChatStr;
   ChatStr := '';
   if DispStr = '' then exit;
   Memo2.Text := Memo2.Text + ExtractWord(1, Dos2Win(DispStr), [#13, #10]);
   if wordcount(DispStr, [#10, #13]) > 1 then
   begin
     for i := 2 to WordCount(DispStr, [#10, #13]) do
     begin
       str1 := ExtractWord(i, DispStr, [#10, #13]);
       Memo2.Lines.Add(str1);
     end;
   end else
   if DispStr[length(DispStr)] = #$a then Memo2.Lines.Add('');
   str:=Memo2.Lines.Strings[Memo2.Lines.Count - 1];
   processbs(str);
   Memo2.Lines.Strings[Memo2.Lines.Count-1] := str;
   DispStr := '';
end;

function TChat.GetTimeout;
begin
   result := round((Time() - LastKey) * 100000);
end;

procedure TChat.SetRemoteVisible;
begin
   fRemoteVisible := v;
end;

procedure TChat.FormResize(Sender: TObject);
begin
//   Memo1.Height := (ClientHeight - Status.Height) div 2;
  Memo1.Height := Panel2.Height div 2;
//  Memo2.Height := Memo1.Height;
end;

procedure TChat.FormActivate(Sender: TObject);
begin
   EnableMenuItems(False);
   FlashWindow(Handle, false);
end;

procedure TChat.FormShow(Sender: TObject);
begin
   ChatStr := #10' * Remote sysop entered chat * '#10#10;
   fRemoteVisible := True;
   if IniFile.ChatBell then
   begin
      BleepInt.Bleep(bInterrupt);
      BleepInt.Bleep(bInterrupt);
      BleepInt.Bleep(bInterrupt);
      BleepInt.Bleep(bInterrupt);
      EnableMenuItems(False);
   end;
   FlashWindow(Handle, false);
end;

procedure TChat.FormDeactivate(Sender: TObject);
begin
   EnableMenuItems(True);
end;

procedure TChat.EnableMenuItems;
var i: integer;
    f: TForm;
begin
   if MailerForms <> nil then
   for i := 0 to MailerForms.Count - 1 do begin
      f := Mailerforms[i];
      if f is TMailerForm then begin
         if e then begin
            TMailerForm(f).mlAbortOperation.ShortCut := oldshortcut1;
            TMailerForm(f).mlResetTimeOut.ShortCut := oldshortcut2;
            TMailerForm(f).mpPause.ShortCut := oldshortcut3
         end else begin
            oldshortcut1 := TMailerForm(f).mlAbortOperation.ShortCut;
            oldshortcut2 := TMailerForm(f).mlResetTimeOut.ShortCut;
            oldshortcut3 := TMailerForm(f).mpPause.ShortCut;
            TMailerForm(f).mlAbortOperation.ShortCut := 0;
            TMailerForm(f).mlResetTimeOut.ShortCut := 0;
            TMailerForm(f).mpPause.ShortCut := 0;
         end;
{         TMailerForm(f).mlAbortOperation.Enabled := e;
         TMailerForm(f).mlResetTimeOut.Enabled := e;
//         TMailerForm(f).mLine.Enabled := e;}
      end;
   end;
end;

procedure TChat.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if fRemoteVisible then begin
     ChatStr := #10' * Remote sysop finished chatting. * '#10#10;
  end;
end;

procedure TChat.AddMsg;
var r: string;
    s: string;
    u: string;
    i: integer;
begin
   r := '';
   s := t;
   for i := 1 to length(s) do begin
      if not (s[i] in [#10, #13]) then begin
        r := r + s[i];
//        processbs(r);
      end else begin
         r := plus.Dos2Win(r);
         processbs(r);
         Memo1.Lines.Add(r);
         r := '';
      end;
   end;
   if r <> '' then begin
      i := Memo1.Lines.Count - 1;
      if i = - 1 then begin
         Memo1.Lines.Add('');
         i := 0;
      end;
      s := Memo1.Lines[i];
      u := Dos2Win(r);
      u := s + u;
      processbs(u);
      Memo1.Lines[i] := u;
   end;
end;

procedure TChat.FormCreate(Sender: TObject);
begin
{  Log := TLogContainer.Create;
  Log.FTag := ltRasDial;
  Log.FMsg := WM_ADDRASDIAL;
  Log.FName := MakeNormName(dlog, Format('chat_%s.log',['logname']);}
end;

end.
