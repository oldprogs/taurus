object LogViewer: TLogViewer
  Left = 201
  Top = 134
  Width = 696
  Height = 480
  Caption = 'Log Viewer'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object mmView: TJvEditor
    Left = 0
    Top = 0
    Width = 688
    Height = 450
    Cursor = crIBeam
    GutterWidth = 0
    RightMarginVisible = False
    RightMarginColor = clSilver
    ReadOnly = True
    HideCaret = True
    Completion.ItemHeight = 13
    Completion.Interval = 800
    Completion.ListBoxStyle = lbStandard
    Completion.CaretChar = '|'
    Completion.CRLF = '/n'
    Completion.Separator = '='
    TabStops = '3 5'
    SelForeColor = clHighlightText
    SelBackColor = clHighlight
    OnGetLineAttr = mmViewGetLineAttr
    Align = alClient
    Color = clWhite
    Ctl3D = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabStop = True
    UseDockManager = False
  end
end
