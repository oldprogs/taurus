unit RemoteUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  Forms, Dialogs, p_RCC, Menus;

type
  TRemoteForm = class(TForm)
    MainMenu: TMainMenu;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FillMenu (const s: string);
    procedure FillForm (const s: string);
    procedure ItemClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    prot: TRCC;
  end;

var
  RemoteForm: TRemoteForm;

implementation

uses Wizard;

{$R *.dfm}

procedure TRemoteForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   MainMenu.Items.Clear;
   prot.CloseLine;
end;

procedure TRemoteForm.FillMenu;
var b,
    e: integer;
    c: integer;
    t: TMenuItem;
    n: TMenuItem;
    l: TList;
    m: string;

    procedure SetItem(const t: TMenuItem; const s: string);
    var m: string;
    begin
       m := ExtractWord(1, s, ['[']);
       if trim(m) = '' then m := '???';
       t.Caption := m;
       t.Enabled := Boolean(strtoint(ExtractWord(1, ExtractWord(2, '-' + s, ['[']), [','])));
       t.Visible := Boolean(strtoint(ExtractWord(1, ExtractWord(2, '-' + s, [',']), [']'])));
       t.OnClick := ItemClick;
    end;

begin
   c := 0;
   b := 1;
   e := 1;
   n := nil; //to avoid warning
   t := nil; //to avoid warning
   l := TList.Create;
   l.Add(MainMenu.Items);
   while e <= length(s) do begin
      case s[e] of
     '{':
         begin
            t := l[c];
            m := copy(s, b, e - b);
            if m <> '' then SetItem(t, m);
            inc(c);
            b := e + 1;
            n := TMenuItem.Create(MainMenu);
            if l.Count <= c then l.Add(n) else l[c] := n;
         end;
     '}':
         begin
            m := copy(s, b, e - b);
            if m <> '' then begin
               SetItem(n, m);
               t.Add(n);
            end else begin
               n := t;
               t := l[c - 1];
               t.Add(n);
            end;
            dec(c);
            b := e + 1;
         end;
      end;
      inc(e);
   end;
   l.Free;
end;

procedure TRemoteForm.FillForm;
begin
   //
end;

procedure TRemoteForm.ItemClick(Sender: TObject);
begin
   Prot.SList.Add('push menu MainMenu ' + TMenuItem(Sender).Caption);
end;

end.

