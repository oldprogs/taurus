object AttachStatusForm: TAttachStatusForm
  Left = 261
  Top = 237
  HelpContext = 1170
  BorderStyle = bsDialog
  BorderWidth = 6
  Caption = 'Attach Status'
  ClientHeight = 212
  ClientWidth = 241
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object bAttach: TRadioGroup
    Left = 0
    Top = 0
    Width = 145
    Height = 132
    Caption = 'Attach status'
    ItemIndex = 4
    Items.Strings = (
      '&Hold'
      '&Normal'
      '&Direct'
      '&Crash'
      'Crash && &Poll'
      'Call&Back')
    TabOrder = 0
  end
  object bOK: TButton
    Left = 156
    Top = 8
    Width = 75
    Height = 23
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object bCancel: TButton
    Left = 156
    Top = 36
    Width = 75
    Height = 23
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object bHelp: TButton
    Left = 156
    Top = 64
    Width = 75
    Height = 23
    Caption = 'Help'
    TabOrder = 4
    OnClick = bHelpClick
  end
  object bOnSent: TRadioGroup
    Left = 0
    Top = 137
    Width = 145
    Height = 73
    Caption = 'On sent'
    ItemIndex = 0
    Items.Strings = (
      'Nothing'
      'Kill'
      'Truncate')
    TabOrder = 1
  end
end
