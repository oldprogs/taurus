object DF: TDF
  Left = 348
  Top = 224
  Width = 394
  Height = 205
  BorderIcons = []
  Caption = 'DF'
  Color = clBtnFace
  Constraints.MaxWidth = 500
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnClose = FormClose
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 16
  object OK: TButton
    Left = 81
    Top = 80
    Width = 135
    Height = 41
    TabOrder = 1
    Visible = False
    OnClick = OKClick
  end
  object M1: TMemo
    Left = 0
    Top = 0
    Width = 386
    Height = 68
    TabStop = False
    Align = alTop
    Alignment = taCenter
    BorderStyle = bsNone
    Lines.Strings = (
      'Line1'
      'Line2')
    ParentColor = True
    ReadOnly = True
    TabOrder = 0
    OnEnter = M1Enter
  end
end
