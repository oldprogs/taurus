unit AboutScroll;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, 
  Controls, Forms, Dialogs, Menus, ExtCtrls;

type

  TAboutScroll = class(TGraphicControl)
  private
    fDelay: Word;
    fActive: Boolean;
    fAlignment: TAlignment;
    fMaxFontStep: Word;
    fStep: Word;
    fColorAnimation: Boolean;
    fColorStart: TColor;
    fColorStop: TColor;
    MaxTextSize: TSize;
    TextLen: Integer;
    Timer: TTimer;
    IsFontChanged: Boolean;
    ColorDir: Integer;
    ThisColor: Byte;
    MaxDeltaRGB: Integer;
    OffScreen: TBitmap;
    Drawing: Boolean;
    StartRGB: array[1..3] of Byte;
    DeltaRGB: array[1..3] of Integer;
    fScrollText: TStringList;
    fTop: integer;
    procedure SetDelay(Value: Word);
    procedure SetStep(Value: Word);
    procedure SetActive(Value: Boolean);
    procedure SetMaxStep(Value: Word);
    procedure SetAlignment(Value: TAlignment);
    procedure SetColorStart(Value: TColor);
    procedure SetColorStop(Value: TColor);
    function IsFontStored: Boolean;
    function IsSizeStored: Boolean;
    procedure TimerExpired(Sender: TObject);
    procedure CMTextChanged(var Msg: TMessage); message CM_TEXTCHANGED;
    procedure CMFontChanged(var Msg: TMessage); message CM_FONTCHANGED;
    procedure ResetColors;
    function MakeFontColor: TColor;
    procedure PaintFrame(ACanvas: TCanvas);
  protected
    procedure Paint; override;
    procedure Loaded; override;
    procedure SetScrollText(s: TStringList);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AdjustClientSize;
    procedure NextFrame;
  published
    property ScrollText: TStringList read fScrollText write SetScrollText;
    property Active: Boolean read fActive write SetActive default True;
    property Align;
    property Alignment: TAlignment read fAlignment write SetAlignment default taCenter;
    property Anchors;
    property Autosize;
    property ColorAnimation: Boolean read fColorAnimation write fColorAnimation default True;
    property ColorStart: TColor read fColorStart write SetColorStart default clYellow;
    property ColorStop: TColor read fColorStop write SetColorStop default clRed;
    property Color;
    property Delay: Word read fDelay write SetDelay default 70;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font stored IsFontStored;
    property Height stored IsSizeStored;
    property MaxStep: Word read fMaxFontStep write SetMaxStep default 20;
    property ParentColor;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Step: Word read fStep write SetStep default 2;
    property Visible;
    property Width stored IsSizeStored;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;

procedure Register;

implementation

uses USrv;

{$R *.dcr}

{ TAboutScroll }

constructor TAboutScroll.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csOpaque, csReplicatable];
  Randomize;
  fScrollText := TStringList.Create;
  fScrollText.Add(Name);
  OffScreen := TBitmap.Create;
  fActive := False;
  fAlignment := taCenter;
  fColorAnimation := True;
  fColorStart := clYellow;
  fColorStop := clRed;
  fStep := 2;
  fDelay := 70;
  fMaxFontStep := 20;
  Font.Name := 'Times New Roman';
  Font.Size := 10;
  Font.Style := [fsBold];
  IsFontChanged := False;
  TextLen := 0;
  Drawing := False;
  ResetColors;
  Active := True;
  Width := 100;
  Height := 100;
end;

destructor TAboutScroll.Destroy;
begin
  Active := False;
  OffScreen.Free;
  fScrollText.Free;
  inherited Destroy;
end;

procedure TAboutScroll.Loaded;
begin
  inherited Loaded;
end;

procedure TAboutScroll.Paint;
begin
  if not Drawing then
  begin
    Drawing := True;
    try
      OffScreen.Width := ClientWidth;
      OffScreen.Height := ClientHeight;
      PaintFrame(OffScreen.Canvas);
      Canvas.Draw(0, 0, OffScreen);
    finally
      Drawing := False;
    end;
  end;
end;

procedure TAboutScroll.CMTextChanged(var Msg: TMessage);
begin
  inherited;
end;

procedure TAboutScroll.CMFontChanged(var Msg: TMessage);
begin
  inherited;
  IsFontChanged := True;
end;

procedure TAboutScroll.AdjustClientSize;
begin
  if not (csReading in ComponentState) then
    SetBounds(Left, Top, MaxTextSize.CX , MaxTextSize.CY);
end;

procedure TAboutScroll.SetDelay(Value: Word);
begin
  if fDelay <> Value then
  begin
    fDelay := Value;
    if Assigned(Timer) then Timer.Interval := fDelay;
  end;
end;

procedure TAboutScroll.SetMaxStep(Value: Word);
begin
  if fMaxFontStep <> Value then
  begin
    fMaxFontStep := Value;
    if fStep > fMaxFontStep then
      fStep := fMaxFontStep;
  end;
end;

procedure TAboutScroll.SetStep(Value: Word);
begin
  if Value > fMaxFontStep then
    Value := fMaxFontStep;
  if fStep <> Value then
    fStep := Value;
end;

procedure TAboutScroll.SetActive(Value: Boolean);
begin
  if fActive <> Value then
  begin
    fActive := Value;
    if fActive then
    begin
      Timer := TTimer.Create(Self);
      Timer.Interval := fDelay;
      Timer.OnTimer := TimerExpired;
    end
    else
    begin
      Timer.Free;
      Timer := nil;
    end;
  end;
end;

procedure TAboutScroll.SetAlignment(Value: TAlignment);
begin
  if fAlignment <> Value then
  begin
    fAlignment := Value;
    Invalidate;
  end;
end;

procedure TAboutScroll.SetColorStart(Value: TColor);
begin
  if fColorStart <> Value then
  begin
    fColorStart := Value;
    ResetColors;
  end;
end;

procedure TAboutScroll.SetColorStop(Value: TColor);
begin
  if fColorStop <> Value then
  begin
    fColorStop := Value;
    ResetColors;
  end;
end;

function TAboutScroll.IsFontStored: Boolean;
begin
  Result := IsFontChanged;
end;

function TAboutScroll.IsSizeStored: Boolean;
begin
  Result := True;
end;

procedure TAboutScroll.ResetColors;
var
  I: Integer;
  StartColor, StopColor: LongInt;
begin
  StartColor  := ColorToRGB(fColorStart);
  StopColor   := ColorToRGB(fColorStop);
  StartRGB[1] := LoByte(LoWord(StartColor));
  StartRGB[2] := HiByte(LoWord(StartColor));
  StartRGB[3] := LoByte(HiWord(StartColor));
  DeltaRGB[1] := LoByte(LoWord(StopColor)) - StartRGB[1];
  DeltaRGB[2] := HiByte(LoWord(StopColor)) - StartRGB[2];
  DeltaRGB[3] := LoByte(HiWord(StopColor)) - StartRGB[3];
  MaxDeltaRGB := 0;
  for I := 1 to 3 do
    if MaxDeltaRGB < Abs(DeltaRGB[I]) then
      MaxDeltaRGB := Abs(DeltaRGB[I]);
  ThisColor := 0;
  ColorDir := 1;
end;

function TAboutScroll.MakeFontColor: TColor;
var
  I: Integer;
  ColorRGB: array[1..3] of Byte;
begin
  for I := 1 to 3 do
  begin
    ColorRGB[I] := StartRGB[I];
    if ThisColor > Abs(DeltaRGB[I]) then
      Inc(ColorRGB[I], DeltaRGB[I])
    else if DeltaRGB[I] > 0 then
      Inc(ColorRGB[I], ThisColor mod (DeltaRGB[I]+1))
    else if DeltaRGB[I] < 0 then
      Dec(ColorRGB[I], ThisColor mod (DeltaRGB[I]-1));
  end;
  Result := TColor(RGB(ColorRGB[1], ColorRGB[2], ColorRGB[3]));
  Inc(ThisColor, ColorDir);
  if (ThisColor = MaxDeltaRGB) or (ThisColor = 0) then ColorDir := -ColorDir;
end;

procedure TAboutScroll.NextFrame;
begin
  Refresh;
  exit;
end;

procedure DrawShadow(c: TCanvas; s: string; r: TRect);
var i, j: integer;
{       n: integer;}
       t: TRect;
begin
   i := 1;
   j := 1;
{   for i := 2 downto 0 do begin
      for j := 1 downto -1 do begin
         if i = j then begin}
{         n := (i * 2 + 2 + j * 2) * $19;}
         c.Font.Color := {n shl 16 + n shl 8 + n} clBlack;
         t := r;
         t.Left   := t.Left   {+ 2} + i;
         t.Top    := t.Top    {+ 2} + j;
         t.Right  := t.Right  {- 2} + i;
         t.Bottom := t.Bottom {- 2} + j;
         DrawText(c.Handle, PChar(s), length(s), t, DT_NOCLIP or DT_CENTER);
{         end;
      end;
   end;}
end;

procedure TAboutScroll.PaintFrame(ACanvas: TCanvas);
var
  I, X{,
  J}: Integer;
  R,
  H: TRect;
  S: string;
  G: HRGN;
begin
  ACanvas.Font := Font;
  ACanvas.Brush.Color := Color;
  CopyParentImage(Self, ACanvas);

  if not visible then exit;

  if fScrollText <> nil then begin

     if AutoSize then begin
        x := 0;
        for i := 0 to fScrollText.Count - 1 do begin
           if Length(fScrollText[i]) > x then begin
              x := length(fScrollText[i]);
              s := fScrollText[i];
           end;
        end;

        ACanvas.Font.Height := 40;

        while (ACanvas.TextWidth(s) + 20 > Width) and (ACanvas.Font.Height > 0) do begin
           ACanvas.Font.Height := ACanvas.Font.Height - 1;
        end;

     end;

     ACanvas.Brush.Style := bsCLear;
     G := CreateRectRGN(Left, Top, Left + Width, Top + Height);
     SelectClipRGN(Canvas.Handle, G);
     s := fScrollText.Text;

     H := Rect(0, 0, Width, 0);
     DrawText(ACanvas.Handle, PChar(s), Length(s), H, DT_NOCLIP or DT_CENTER or DT_CALCRECT);

{     ACanvas.Font.Color := clBlack;}
     R := Rect(2, fTop + 2, Width, Height);
     DrawShadow(ACanvas, s, R);
{     DrawText(ACanvas.Handle, PChar(s), length(s), R, DT_NOCLIP or DT_CENTER);}

     ACanvas.Font.Color := MakeFontColor;
     R := Rect(0, fTop + 0, Width, Height);
     DrawText(ACanvas.Handle, PChar(s), length(s), R, DT_NOCLIP or DT_CENTER);

     i := 0;
     repeat
        inc(i);
        R := Rect(2, fTop + i * H.Bottom + 2, Width, Height);
        DrawShadow(ACanvas, s, R);
        ACanvas.Font.Color := MakeFontColor;
        R := Rect(0, fTop + i * h.Bottom + 0, Width, Height);
        DrawText(ACanvas.Handle, PChar(s), length(s), R, DT_NOCLIP or DT_CENTER);
     until i * h.Bottom > Height;

     SelectClipRgn(Canvas.Handle, 0);
     DeleteObject(G);
     Dec(fTop);
     if fTop + H.Bottom <= 0 then fTop := 0;
  end;
end;

procedure TAboutScroll.TimerExpired(Sender: TObject);
begin
  NextFrame;
end;

procedure TAboutScroll.SetScrollText;
begin
  fScrollText.Assign(s);
end;

procedure Register;
begin
  RegisterComponents('Argus', [TAboutScroll]);
end;

end.
