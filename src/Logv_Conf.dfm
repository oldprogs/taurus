object Config_Logv: TConfig_Logv
  Left = 255
  Top = 175
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  BorderWidth = 15
  Caption = 'Log Viewer Setup'
  ClientHeight = 255
  ClientWidth = 335
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object BitBtn1: TButton
    Left = 0
    Top = 229
    Width = 85
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object BitBtn2: TButton
    Left = 130
    Top = 229
    Width = 85
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object Preview: TJvEditor
    Left = 0
    Top = 0
    Width = 335
    Height = 114
    Cursor = crIBeam
    Lines.Strings = (
      'Regular text'
      'Errors'
      'Protocols'
      'Modem responses'
      'Other info'
      '>->->->-> EOF Marker <-<-<-<-<')
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
    BracketHighlighting.StringEscape = #39#39
    SelForeColor = clHighlightText
    SelBackColor = clHighlight
    SelBlockFormat = bfLine
    OnGetLineAttr = PreviewGetLineAttr
    OnScroll = UnSelAndScroll
    OnSelectionChange = UnSelAndScroll
    OnMouseDown = PreviewMouseDown
    OnPaintGutter = PreviewPaintGutter
    Align = alTop
    ParentColor = False
    TabStop = True
    UseDockManager = False
  end
  object BitBtn3: TButton
    Left = 251
    Top = 229
    Width = 85
    Height = 25
    Caption = 'Help'
    TabOrder = 3
    OnClick = BitBtn3Click
  end
  object GroupBox1: TGroupBox
    Left = 224
    Top = 120
    Width = 110
    Height = 103
    Caption = ' Font style '
    TabOrder = 4
    object bCk: TCheckBox
      Left = 10
      Top = 18
      Width = 97
      Height = 17
      Caption = 'Bold'
      TabOrder = 0
      OnClick = FormChange
    end
    object uCk: TCheckBox
      Left = 10
      Top = 47
      Width = 97
      Height = 17
      Caption = 'Underlined'
      TabOrder = 1
      OnClick = FormChange
    end
    object kCk: TCheckBox
      Left = 10
      Top = 77
      Width = 97
      Height = 17
      Caption = 'Italic'
      TabOrder = 2
      OnClick = FormChange
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 120
    Width = 218
    Height = 103
    Caption = ' Font colors '
    TabOrder = 5
    object Label1: TLabel
      Left = 8
      Top = 18
      Width = 61
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Background'
      Layout = tlCenter
    end
    object Label2: TLabel
      Left = 8
      Top = 47
      Width = 61
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Text'
      Layout = tlCenter
    end
    object Label3: TLabel
      Left = 8
      Top = 77
      Width = 61
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Border'
      Layout = tlCenter
    end
    object BcBtn: TJvColorButton
      Left = 75
      Top = 15
      Width = 129
      OtherCaption = '&Other...'
      Options = [cdAnyColor]
      OnChange = BcBtnChange
      TabOrder = 0
      TabStop = False
    end
    object FcBtn: TJvColorButton
      Left = 75
      Top = 43
      Width = 129
      OtherCaption = '&Other...'
      Options = [cdAnyColor]
      OnChange = BcBtnChange
      TabOrder = 1
      TabStop = False
    end
    object BrdCBtn: TJvColorButton
      Left = 75
      Top = 72
      Width = 129
      OtherCaption = '&Other...'
      Options = [cdAnyColor]
      OnChange = BcBtnChange
      TabOrder = 2
      TabStop = False
    end
  end
end
