unit LogView;
interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, xBase, JvEditor, ExtCtrls;

type

  TLogViewer = class(TForm)
    mmView: TJvEditor;
    TM: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mmViewGetLineAttr(Sender: TObject; var Line: String;
      index: Integer; var Attrs: TLineAttrs);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure TMTimer(Sender: TObject);
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
  AttrArray: Array[1..5] of TLineAttr =
           ((FC:clBlack;BC:clWhite;Style:[]),
            (FC:clRed;BC:clWhite;Style:[]),
            (FC:clOlive;BC:clWhite;Style:[]),
            (FC:clPurple;BC:clWhite;Style:[]),
            (FC:clBlue;BC:clWhite;Style:[{fsBold}])
           );

implementation

uses RadIni, Plus, Wizard;

{$R *.dfm}

procedure TLogViewer.SetLogName;
var
   tr: integer;
   st: TStream;
begin
   mmView.Font.Size := IniFile.LoggerFontSize;
   tr := mmView.Lines.Count;
   St := TFileStream.Create(s, fmOpenRead or fmShareDenyNone);
   try
     mmView.Lines.LoadFromStream(St);
   finally
     St.Free;
   end;
//   mmView.Lines.LoadFromFile(s);
   tr := mmView.Lines.Count - tr;
   if (mmView.TopRow + tr > mmView.Lines.Count - mmView.VisibleRowCount - 2) or (fLogName <> s) then begin
      mmView.SetLeftTop(0, mmView.Lines.Count - mmView.VisibleRowCount + 2);
   end;
   oTime := GetFileTime(s);
   fLogName := s;
end;

procedure TLogViewer.FormCreate(Sender: TObject);
var
   s: string;
begin
   LogViewer := self;
   s := IniFile.ReadString('Sizes', 'LogViewer', '');
   Left := StrToIntDef(ExtractWord(1, s, [',']), Left);
   Top := StrToIntDef(ExtractWord(2, s, [',']), Top);
   Width := StrToIntDef(ExtractWord(3, s, [',']), Width);
   Height := StrToIntDef(ExtractWord(4, s, [',']), Height);
end;

procedure TLogViewer.FormDestroy(Sender: TObject);
begin
   IniFile.WriteString('Sizes', 'LogViewer',
      IntToStr(Left) + ',' +
      IntToStr(Top) + ',' +
      IntToStr(Width) + ',' +
      IntToStr(Height));
end;

procedure TLogViewer.mmViewGetLineAttr(Sender: TObject; var Line: String; index: Integer; var Attrs: TLineAttrs);
var
   i: integer;
   r: TLineAttr;
begin
r := AttrArray[1];

if (Pos ('error',Line)<>0) or
   (Pos ('invalid',Line)<>0) or
   (Pos ('bad',Line)<>0) or
   (Pos ('SYS0',Line)<>0) or
   (Pos ('aborted',Line)<>0) then r := AttrArray[2];

if (Pos ('Calling',Line)<>0) or
   (Pos ('Initializing modem',Line)<>0) or
   (Pos ('Connect',Line)<>0) or
   (Pos ('Sending',Line)<>0) or
   (Pos ('Receiving',Line)<>0) or
   (Pos ('Sent',Line)<>0) or
   (Pos ('Received',Line)<>0) or
   (Pos ('End of batch',Line)<>0) or
   (Pos ('EMSI data receive',Line)<>0) or
   (Pos ('-Poll',Line)<>0) then r := AttrArray[3];

if (Pos ('NO DIALTONE',Line)<>0) or
   (Pos ('BUSY',Line)<>0) or
   (Pos ('ERROR',Line)<>0) or
   (Pos ('RING',Line)<>0) or
   (Pos ('OK',Line)<>0) or
   (Pos ('TAPI',Line)<>0) or
   (Pos ('"GET',Line)<>0) then r := AttrArray[4];

if (Pos ('[WZ]',Line)<>0) or
   (Pos ('Password-protected session',Line)<>0) or
   (Pos ('Non-password session',Line)<>0) or
   (Pos ('Station : ',Line)<>0) or
   (Pos ('SysOp : ',Line)<>0) or
   (Pos ('Address : ',Line)<>0) or
   (Pos ('Number : ',Line)<>0) or
   (Pos ('Flags : ',Line)<>0) or
   (Pos ('Mailer : ',Line)<>0) or
   (Pos ('EMSI Addon : ',Line)<>0) or
   (Pos ('Time : ',Line)<>0) or
   (Pos ('"PUT',Line)<>0) or
   (Pos ('+Poll',Line)<>0) then r := AttrArray[5];

   for i := Low(Attrs) to High(Attrs) do Attrs[i] := r;
end;

procedure TLogViewer.FormKeyPress(Sender: TObject; var Key: Char);
begin
   if Key = #27 then Close;
end;

procedure TLogViewer.TMTimer(Sender: TObject);
begin
   fTime := GetFileTime(LogViewer.fLogName);
   if fTime <> oTime then begin
      oTime := fTime;
      LogViewer.LogName := LogViewer.LogName;
   end;
end;

end.
