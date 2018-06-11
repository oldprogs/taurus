object OvrExplainForm: TOvrExplainForm
  Left = 209
  Top = 186
  HelpContext = 2100
  BorderStyle = bsDialog
  BorderWidth = 6
  ClientHeight = 214
  ClientWidth = 568
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 15
  object bOK: TButton
    Left = 296
    Top = 183
    Width = 75
    Height = 23
    Caption = 'O&K'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object bCancel: TButton
    Left = 376
    Top = 183
    Width = 75
    Height = 23
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object bHelp: TButton
    Left = 456
    Top = 183
    Width = 75
    Height = 23
    Caption = 'Help'
    TabOrder = 2
    OnClick = bHelpClick
  end
  object gOvr: TAdvGrid
    Left = 0
    Top = 0
    Width = 568
    Height = 169
    FixedFont.Charset = DEFAULT_CHARSET
    FixedFont.Color = clWindowText
    FixedFont.Height = -12
    FixedFont.Name = 'Arial'
    FixedFont.Style = []
    Align = alTop
    DefaultRowHeight = 18
    RowCount = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Fixedsys'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowMoving, goColMoving, goEditing, goDigitalRows]
    ParentFont = False
    TabOrder = 3
    CheckBoxes = False
    ColWidths = (
      31
      154
      120
      117
      121)
  end
end
