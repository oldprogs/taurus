object FidoAddressInput: TFidoAddressInput
  Left = 236
  Top = 258
  HelpContext = 2150
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Input the address'
  ClientHeight = 127
  ClientWidth = 374
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object bOK: TButton
    Left = 103
    Top = 86
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object bCancel: TButton
    Left = 185
    Top = 86
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object AddressBox: TGroupBox
    Left = 17
    Top = 13
    Width = 337
    Height = 61
    Caption = 'Address'
    TabOrder = 0
    object lAddress: THistoryLine
      Left = 13
      Top = 22
      Width = 225
      Height = 23
      HistoryID = 22
      TabOrder = 0
      OnKeyDown = lAddressKeyDown
      OnKeyUp = lAddressKeyUp
    end
    object bBrowse: TButton
      Left = 251
      Top = 18
      Width = 74
      Height = 25
      Caption = 'Browse'
      TabOrder = 1
      OnClick = bBrowseClick
    end
  end
  object bHelp: TButton
    Left = 267
    Top = 86
    Width = 81
    Height = 25
    Caption = 'Help'
    TabOrder = 3
    OnClick = bHelpClick
  end
end
