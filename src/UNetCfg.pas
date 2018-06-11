unit UNetCfg;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
   Dialogs, mGrids, JvFormPlacement, JvComponent, StdCtrls, Buttons, JvBitBtn,
   JvFooter, ExtCtrls;

type
   TNetCfg = class(TForm)
      gNetmail: TAdvGrid;
      FS: TJvFormPlacement;
      Footer: TJvFooter;
      bOK: TJvFooterBtn;
      bCancel: TJvFooterBtn;
      procedure FormCreate(Sender: TObject);
      procedure bOKClick(Sender: TObject);
   private
     { Private declarations }
   public
     { Public declarations }
   end;

var
  NetCfg: TNetCfg;

implementation

uses RadIni, LngTools;

{$R *.dfm}

procedure TNetCfg.FormCreate(Sender: TObject);
begin
   GridFillColLng(gNetmail, rsNetmailGrid);
   gNetmail.SetData([IniFile.NetmailAddrTo, IniFile.NetmailAddrFrom, IniFile.NetmailPwd]);
end;

procedure TNetCfg.bOKClick(Sender: TObject);
var
   i: integer;
begin
   with IniFile do begin
      if NetmailAddrTo.Count <> 0 then begin
         NetmailAddrTo.FreeAll;
         NetmailAddrFrom.FreeAll;
         NetmailPwd.FreeAll;
      end;
      for i := 0 to gNetmail.RowCount - 2 do begin
         gNetmail.GetData([NetmailAddrTo, NetmailAddrFrom, NetmailPwd]);
      end;
   end;
end;

end.
