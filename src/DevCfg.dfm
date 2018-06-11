object DeviceConfig: TDeviceConfig
  Left = 354
  Top = 213
  HelpContext = 1080
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Port Configuration'
  ClientHeight = 147
  ClientWidth = 509
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDblClick = gbComDirectDblClick
  DesignSize = (
    509
    147)
  PixelsPerInch = 96
  TextHeight = 15
  object bOK: TButton
    Left = 256
    Top = 113
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object bCancel: TButton
    Left = 336
    Top = 113
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object bHelp: TButton
    Left = 416
    Top = 113
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = 'Help'
    TabOrder = 2
    OnClick = bHelpClick
  end
  object gbComDirect: TGroupBox
    Left = 20
    Top = 11
    Width = 470
    Height = 92
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = ' Com Port '
    TabOrder = 3
    OnDblClick = gbComDirectDblClick
    DesignSize = (
      470
      92)
    object lComPort: TLabel
      Left = 37
      Top = 23
      Width = 52
      Height = 15
      Alignment = taRightJustify
      Caption = 'COM &Port'
      FocusControl = cbCom
    end
    object lRate: TLabel
      Left = 41
      Top = 55
      Width = 48
      Height = 15
      Alignment = taRightJustify
      Caption = '&BPS rate'
      FocusControl = cbSpeed
    end
    object lTapiDevice: TLabel
      Left = 24
      Top = 56
      Width = 65
      Height = 15
      Alignment = taRightJustify
      Caption = 'TAPI Device'
      Visible = False
    end
    object cbCom: TComboBox
      Left = 95
      Top = 19
      Width = 74
      Height = 23
      Style = csDropDownList
      ItemHeight = 15
      TabOrder = 0
      OnChange = cbComChange
    end
    object cbSpeed: TComboBox
      Left = 95
      Top = 51
      Width = 81
      Height = 23
      ItemHeight = 15
      TabOrder = 1
      OnKeyPress = cbSpeedKeyPress
      Items.Strings = (
        '9600'
        '14400'
        '19200'
        '38400'
        '56000'
        '57600'
        '115200'
        '128000'
        '256000')
    end
    object cxTAPI: TComboBox
      Left = 96
      Top = 51
      Width = 355
      Height = 23
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 15
      TabOrder = 4
      Visible = False
    end
    object cbDirect: TCheckBox
      Left = 186
      Top = 20
      Width = 103
      Height = 17
      Caption = 'Direct access'
      TabOrder = 5
      Visible = False
      OnClick = cbDirectClick
    end
    object cbAccept: TCheckBox
      Left = 293
      Top = 20
      Width = 164
      Height = 17
      Caption = 'Intercept shared calls'
      TabOrder = 6
      Visible = False
    end
    object gBits: TGroupBox
      Left = 328
      Top = 13
      Width = 129
      Height = 60
      Caption = ' Bits '
      TabOrder = 3
      DesignSize = (
        129
        60)
      object lBits: TLabel
        Left = 8
        Top = 25
        Width = 22
        Height = 15
        Caption = '8N1'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object bBits: TButton
        Left = 40
        Top = 20
        Width = 79
        Height = 22
        Anchors = [akLeft, akTop, akRight]
        Caption = '&Change...'
        TabOrder = 0
        OnClick = bBitsClick
      end
    end
    object gFlow: TGroupBox
      Left = 187
      Top = 13
      Width = 126
      Height = 60
      Caption = ' &Flow control '
      TabOrder = 2
      object cbCTS_RTS: TCheckBox
        Left = 8
        Top = 17
        Width = 105
        Height = 17
        Caption = 'CTS/&RTS'
        TabOrder = 0
      end
      object cbXon_Xoff: TCheckBox
        Left = 8
        Top = 37
        Width = 113
        Height = 17
        Caption = 'XOn/&XOff'
        TabOrder = 1
      end
    end
  end
end
