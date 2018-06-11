object ModemCmdForm: TModemCmdForm
  Left = 172
  Top = 219
  HelpContext = 2180
  BorderStyle = bsDialog
  Caption = 'Send Modem Commands'
  ClientHeight = 101
  ClientWidth = 398
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    398
    101)
  PixelsPerInch = 96
  TextHeight = 15
  object lModemCommand: TLabel
    Left = 16
    Top = 8
    Width = 103
    Height = 15
    Caption = 'Modem Command'
  end
  object eModemCommand: THistoryLine
    Left = 16
    Top = 24
    Width = 369
    Height = 24
    HistoryID = 333
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Fixedsys'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnChange = eModemCommandChange
  end
  object bSend: TButton
    Left = 150
    Top = 64
    Width = 75
    Height = 23
    Anchors = [akTop, akRight]
    Caption = '&Send'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = bSendClick
  end
  object bClose: TButton
    Left = 230
    Top = 64
    Width = 75
    Height = 23
    Anchors = [akTop, akRight]
    Cancel = True
    Caption = 'Close'
    ModalResult = 2
    TabOrder = 2
  end
  object bHelp: TButton
    Left = 309
    Top = 64
    Width = 76
    Height = 23
    HelpContext = 1220
    Anchors = [akTop, akRight]
    Caption = 'Help'
    TabOrder = 3
    OnClick = bHelpClick
  end
  object cbInit: TCheckBox
    Left = 16
    Top = 68
    Width = 121
    Height = 14
    Anchors = [akTop, akRight]
    Caption = 'Init on exit'
    Checked = True
    State = cbChecked
    TabOrder = 4
  end
end
