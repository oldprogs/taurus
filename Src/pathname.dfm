object PathNamesForm: TPathNamesForm
  Left = 229
  Top = 174
  HelpContext = 1670
  BorderStyle = bsDialog
  BorderWidth = 6
  Caption = 'Path Names'
  ClientHeight = 249
  ClientWidth = 448
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    448
    249)
  PixelsPerInch = 96
  TextHeight = 14
  object llDefZone: TLabel
    Left = 172
    Top = 189
    Width = 48
    Height = 14
    Alignment = taRightJustify
    Anchors = [akRight, akBottom]
    Caption = 'Main AKA'
  end
  object gSpec: TAdvGrid
    Left = 9
    Top = 3
    Width = 424
    Height = 158
    FixedFont.Charset = DEFAULT_CHARSET
    FixedFont.Color = clWindowText
    FixedFont.Height = -12
    FixedFont.Name = 'Arial'
    FixedFont.Style = []
    ColCount = 2
    DefaultRowHeight = 18
    RowCount = 8
    FixedRows = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Fixedsys'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goEditing, goFixedNumCols]
    ParentFont = False
    TabOrder = 0
    ColWidths = (
      107
      281)
  end
  object bBrowse: TButton
    Left = 356
    Top = 185
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = '&Browse...'
    TabOrder = 1
    OnClick = bBrowseClick
  end
  object bOK: TButton
    Left = 196
    Top = 219
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = 'O&K'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object bCancel: TButton
    Left = 276
    Top = 219
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object bHelp: TButton
    Left = 356
    Top = 219
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = 'Help'
    TabOrder = 4
    OnClick = bHelpClick
  end
  object Edit1: TEdit
    Left = 232
    Top = 185
    Width = 121
    Height = 22
    Anchors = [akRight, akBottom]
    TabOrder = 5
    Text = '2:2/0'
  end
  object Button1: TButton
    Left = 400
    Top = 5
    Width = 31
    Height = 20
    Caption = '...'
    TabOrder = 6
    OnClick = Button1Click
  end
  object Button2: TButton
    Tag = 1
    Left = 400
    Top = 24
    Width = 31
    Height = 20
    Caption = '...'
    TabOrder = 7
    OnClick = Button1Click
  end
  object Button3: TButton
    Tag = 2
    Left = 400
    Top = 43
    Width = 31
    Height = 20
    Caption = '...'
    TabOrder = 8
    OnClick = Button1Click
  end
  object Button4: TButton
    Tag = 3
    Left = 400
    Top = 62
    Width = 31
    Height = 20
    Caption = '...'
    TabOrder = 9
    OnClick = Button1Click
  end
  object Button5: TButton
    Tag = 4
    Left = 400
    Top = 81
    Width = 31
    Height = 20
    Caption = '...'
    TabOrder = 10
    OnClick = Button1Click
  end
  object Button6: TButton
    Tag = 5
    Left = 400
    Top = 100
    Width = 31
    Height = 20
    Caption = '...'
    TabOrder = 11
    OnClick = Button1Click
  end
  object Button7: TButton
    Tag = 6
    Left = 400
    Top = 119
    Width = 31
    Height = 20
    Caption = '...'
    TabOrder = 12
    OnClick = Button1Click
  end
  object Button8: TButton
    Tag = 7
    Left = 400
    Top = 138
    Width = 31
    Height = 20
    Caption = '...'
    TabOrder = 13
    OnClick = Button1Click
  end
  object CB: TCheckBox
    Left = 9
    Top = 189
    Width = 159
    Height = 14
    Anchors = [akRight, akBottom]
    Caption = '5D outbound support'
    TabOrder = 14
  end
end
