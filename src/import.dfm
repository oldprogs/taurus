object ImportForm: TImportForm
  Left = 261
  Top = 239
  BorderStyle = bsDialog
  ClientHeight = 192
  ClientWidth = 387
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object rbBinkD: TRadioButton
    Left = 16
    Top = 16
    Width = 364
    Height = 17
    Caption = 'BinkD '#169' Dima Maloff'
    Checked = True
    TabOrder = 0
    TabStop = True
  end
  object rbBinkPlus: TRadioButton
    Left = 16
    Top = 36
    Width = 364
    Height = 17
    Caption = 'Bink/+ '#169' serge terekhov'
    TabOrder = 1
  end
  object rbTMail: TRadioButton
    Left = 16
    Top = 56
    Width = 364
    Height = 17
    Caption = 'T-Mail '#169' Andy Elkin'
    TabOrder = 2
  end
  object rbXenia: TRadioButton
    Left = 16
    Top = 76
    Width = 364
    Height = 17
    Caption = 'Xenia '#169' Arjen G. Lentz'
    TabOrder = 3
  end
  object bOK: TButton
    Left = 78
    Top = 152
    Width = 75
    Height = 23
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 6
  end
  object bCancel: TButton
    Left = 158
    Top = 152
    Width = 75
    Height = 23
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 7
  end
  object bHelp: TButton
    Left = 238
    Top = 152
    Width = 75
    Height = 23
    Caption = 'Help'
    TabOrder = 8
    OnClick = bHelpClick
  end
  object rbFrontDoor: TRadioButton
    Left = 16
    Top = 96
    Width = 364
    Height = 17
    Caption = 'FrontDoor 2.12 '#169' Joaquim Homrighausen (passwords only)'
    TabOrder = 4
  end
  object rbMainDoor: TRadioButton
    Left = 16
    Top = 116
    Width = 364
    Height = 17
    Caption = 'MainDoor 1.10 '#169' Francisco Sedano Crippa (passwords only)'
    TabOrder = 5
  end
end
