object Config_Logv: TConfig_Logv
  Left = 261
  Top = 153
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  BorderWidth = 15
  Caption = 'Log Viewer Setup'
  ClientHeight = 250
  ClientWidth = 257
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 15
  object Label1: TLabel
    Left = 0
    Top = 101
    Width = 121
    Height = 21
    AutoSize = False
    Caption = 'Background:'
    Layout = tlCenter
  end
  object Label2: TLabel
    Left = 0
    Top = 129
    Width = 121
    Height = 17
    AutoSize = False
    Caption = 'Text:'
    Layout = tlCenter
  end
  object BcBtn: TJvColorButton
    Left = 128
    Top = 101
    Width = 129
    OtherCaption = '&Other...'
    Options = [cdAnyColor]
    OnChange = BcBtnChange
  end
  object FcBtn: TJvColorButton
    Left = 128
    Top = 125
    Width = 129
    OtherCaption = '&Other...'
    Options = [cdAnyColor]
    OnChange = BcBtnChange
  end
  object bCk: TCheckBox
    Left = 0
    Top = 153
    Width = 236
    Height = 17
    Caption = 'Bold'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = FormChange
  end
  object uCk: TCheckBox
    Left = 0
    Top = 177
    Width = 236
    Height = 17
    Caption = 'Underlined'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 3
    OnClick = FormChange
  end
  object kCk: TCheckBox
    Left = 0
    Top = 201
    Width = 236
    Height = 17
    Caption = 'Italic'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = [fsItalic]
    ParentFont = False
    TabOrder = 4
    OnClick = FormChange
  end
  object BitBtn1: TBitBtn
    Left = 0
    Top = 225
    Width = 85
    Height = 25
    TabOrder = 5
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 86
    Top = 225
    Width = 85
    Height = 25
    TabOrder = 6
    Kind = bkCancel
  end
  object Preview: TJvEditor
    Left = 0
    Top = 0
    Width = 257
    Height = 91
    Cursor = crIBeam
    Lines.Strings = (
      'Regular text'
      'Errors'
      'Protocols'
      'Modem responses'
      'Other info')
    ScrollBars = ssNone
    GutterWidth = 15
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
    KeepTrailingBlanks = True
    SelForeColor = clHighlightText
    SelBackColor = clHighlight
    SelBlockFormat = bfLine
    OnGetLineAttr = PreviewGetLineAttr
    OnScroll = UnSelAndScroll
    OnSelectionChange = UnSelAndScroll
    OnMouseDown = PreviewMouseDown
    OnPaintGutter = PreviewPaintGutter
    Align = alTop
    Ctl3D = True
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabStop = True
    UseDockManager = False
  end
  object BitBtn3: TBitBtn
    Left = 172
    Top = 225
    Width = 85
    Height = 25
    Caption = 'Help'
    TabOrder = 8
    OnClick = BitBtn3Click
    Kind = bkHelp
  end
end
