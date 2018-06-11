unit AboutForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AboutScroll, jpeg, ExtCtrls, USrv;

type
  TAbout = class(TForm)
    Scroll: TAboutScroll;
    Image: TImage;
    procedure ScrollClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ScrollMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  protected
    procedure WMEraseBkgnd(var Msg: TWmEraseBkgnd); message WM_ERASEBKGND;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  About: TAbout;

implementation

{$R *.dfm}

procedure TAbout.ScrollClick(Sender: TObject);
begin
  Close;
end;

procedure TAbout.FormCreate(Sender: TObject);
begin
   DoubleBuffered := True;
   Image.Picture.Bitmap.Width  := Image.Picture.Width;
   Image.Picture.Bitmap.Height := 1000;
   SetWindowRgn(Handle, BitmapToRegion(Image.Picture.Bitmap), True);
end;

procedure TAbout.FormShow(Sender: TObject);
begin
   Update;
end;

procedure TAbout.WMEraseBkgnd;
begin
   Msg.Result := 1;
end;

procedure TAbout.ScrollMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   releasecapture;
   SendMessage(Handle,wm_syscommand,$F012,0);
end;

end.
