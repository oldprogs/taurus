object PathNamesForm: TPathNamesForm
  Left = 229
  Top = 174
  HelpContext = 1670
  BorderStyle = bsDialog
  BorderWidth = 6
  Caption = 'Path Names'
  ClientHeight = 241
  ClientWidth = 442
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
    442
    241)
  PixelsPerInch = 96
  TextHeight = 14
  object llDefZone: TLabel
    Left = 166
    Top = 181
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
    FileNameCol = 1
    FileNameDir = True
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
    CheckBoxes = False
    ColWidths = (
      120
      281)
  end
  object bBrowse: TButton
    Left = 350
    Top = 177
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = '&Browse...'
    TabOrder = 1
    OnClick = bBrowseClick
  end
  object bOK: TButton
    Left = 190
    Top = 211
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = 'O&K'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object bCancel: TButton
    Left = 270
    Top = 211
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object bHelp: TButton
    Left = 350
    Top = 211
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = 'Help'
    TabOrder = 4
    OnClick = bHelpClick
  end
  object Edit1: TEdit
    Left = 226
    Top = 177
    Width = 121
    Height = 22
    Anchors = [akRight, akBottom]
    TabOrder = 5
    Text = '2:2/0'
  end
  object CB: TCheckBox
    Left = 3
    Top = 181
    Width = 159
    Height = 14
    Anchors = [akRight, akBottom]
    Caption = '5D outbound support'
    TabOrder = 6
  end
end
