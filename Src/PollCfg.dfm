object PollSetupForm: TPollSetupForm
  Left = 213
  Top = 175
  HelpContext = 1950
  BorderStyle = bsDialog
  BorderWidth = 6
  Caption = 'Polls Set-up'
  ClientHeight = 275
  ClientWidth = 532
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    532
    275)
  PixelsPerInch = 96
  TextHeight = 14
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 532
    Height = 237
    ActivePage = tsOptions
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    HotTrack = True
    ParentFont = False
    TabOrder = 0
    TabStop = False
    object tsPeriodical: TTabSheet
      BorderWidth = 6
      Caption = 'Periodical'
      object gPeriodical: TAdvGrid
        Left = 0
        Top = 0
        Width = 512
        Height = 194
        FixedFont.Charset = DEFAULT_CHARSET
        FixedFont.Color = clWindowText
        FixedFont.Height = -12
        FixedFont.Name = 'Arial'
        FixedFont.Style = []
        Align = alClient
        ColCount = 3
        DefaultRowHeight = 18
        RowCount = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Fixedsys'
        Font.Style = []
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowMoving, goEditing, goThumbTracking, goDigitalRows]
        ParentFont = False
        TabOrder = 0
        CheckBoxes = False
        ColWidths = (
          31
          232
          226)
      end
    end
    object tsOptions: TTabSheet
      Caption = 'Options'
      object lRetry: TLabel
        Left = 379
        Top = 149
        Width = 84
        Height = 16
        Caption = '&Retry seconds'
        FocusControl = sRetry
      end
      object lCallMin: TLabel
        Left = 379
        Top = 177
        Width = 75
        Height = 16
        Caption = '&Call seconds'
        FocusControl = sCallMin
      end
      object gbTry: TGroupBox
        Left = 12
        Top = 12
        Width = 501
        Height = 125
        Caption = 'Try counters'
        TabOrder = 0
        object lBysy: TLabel
          Left = 64
          Top = 28
          Width = 30
          Height = 16
          Alignment = taRightJustify
          Caption = '&Busy'
          FocusControl = sBusy
        end
        object lNoC: TLabel
          Left = 38
          Top = 60
          Width = 56
          Height = 16
          Alignment = taRightJustify
          Caption = '&No carrier'
          FocusControl = sNoC
        end
        object lFail: TLabel
          Left = 73
          Top = 92
          Width = 21
          Height = 16
          Alignment = taRightJustify
          Caption = '&Fail'
          FocusControl = sFail
        end
        object lStandOff: TLabel
          Left = 179
          Top = 28
          Width = 101
          Height = 16
          Alignment = taRightJustify
          Caption = '&Stand-off minutes'
          FocusControl = sStandOffBusy
        end
        object Label1: TLabel
          Left = 179
          Top = 60
          Width = 101
          Height = 16
          Alignment = taRightJustify
          Caption = '&Stand-off minutes'
          FocusControl = sStandOffBusy
        end
        object Label2: TLabel
          Left = 179
          Top = 92
          Width = 101
          Height = 16
          Alignment = taRightJustify
          Caption = '&Stand-off minutes'
          FocusControl = sStandOffBusy
        end
        object sBusy: TxSpinEdit
          Left = 100
          Top = 24
          Width = 41
          Height = 26
          MaxLength = 3
          MaxValue = 99
          MinValue = 1
          TabOrder = 0
          Value = 7
        end
        object sNoC: TxSpinEdit
          Left = 100
          Top = 56
          Width = 41
          Height = 26
          MaxLength = 3
          MaxValue = 99
          MinValue = 1
          TabOrder = 1
          Value = 5
        end
        object sFail: TxSpinEdit
          Left = 100
          Top = 88
          Width = 41
          Height = 26
          MaxLength = 3
          MaxValue = 99
          MinValue = 1
          TabOrder = 2
          Value = 3
        end
        object sStandOffBusy: TxSpinEdit
          Left = 289
          Top = 24
          Width = 50
          Height = 26
          MaxLength = 5
          MaxValue = 2880
          MinValue = 1
          TabOrder = 3
          Value = 30
        end
        object sStandOffNoc: TxSpinEdit
          Left = 289
          Top = 56
          Width = 50
          Height = 26
          MaxValue = 0
          MinValue = 0
          TabOrder = 4
          Value = 30
        end
        object sStandOffFail: TxSpinEdit
          Left = 289
          Top = 88
          Width = 50
          Height = 26
          MaxValue = 0
          MinValue = 0
          TabOrder = 5
          Value = 30
        end
        object cbBusy: TCheckBox
          Left = 374
          Top = 28
          Width = 97
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Undiable'
          TabOrder = 6
          OnClick = cbClick
        end
        object cbNoc: TCheckBox
          Left = 374
          Top = 60
          Width = 97
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Undiable'
          TabOrder = 7
          OnClick = cbClick
        end
        object cbFail: TCheckBox
          Left = 374
          Top = 92
          Width = 97
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Undiable'
          TabOrder = 8
          OnClick = cbClick
        end
      end
      object cbTransmitHold: TCheckBox
        Left = 12
        Top = 149
        Width = 255
        Height = 17
        Caption = '&Transmit '#39'Hold'#39' on outgoing'
        TabOrder = 1
      end
      object cbDirectAsNormal: TCheckBox
        Left = 12
        Top = 177
        Width = 255
        Height = 17
        Caption = 'Prevent '#39'Direct'#39' from initiating a poll'
        TabOrder = 2
      end
      object sRetry: TxSpinEdit
        Left = 313
        Top = 145
        Width = 56
        Height = 26
        MaxLength = 6
        MaxValue = 14400
        MinValue = 1
        TabOrder = 3
        Value = 10
      end
      object sCallMin: TxSpinEdit
        Left = 313
        Top = 175
        Width = 56
        Height = 26
        MaxLength = 5
        MaxValue = 14400
        MinValue = 30
        TabOrder = 4
        Value = 30
      end
    end
    object tsExternal: TTabSheet
      BorderWidth = 6
      Caption = 'External'
      object gExternal: TAdvGrid
        Left = 0
        Top = 0
        Width = 512
        Height = 194
        FixedFont.Charset = DEFAULT_CHARSET
        FixedFont.Color = clWindowText
        FixedFont.Height = -12
        FixedFont.Name = 'Arial'
        FixedFont.Style = []
        Align = alClient
        ColCount = 4
        DefaultRowHeight = 18
        RowCount = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Fixedsys'
        Font.Style = []
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowMoving, goEditing, goThumbTracking, goDigitalRows]
        ParentFont = False
        TabOrder = 0
        CheckBoxes = False
        ColWidths = (
          31
          134
          140
          184)
      end
    end
    object tsAdditional: TTabSheet
      Caption = 'Additional'
      ImageIndex = 3
      object cbAskBeforeReject: TCheckBox
        Left = 26
        Top = 20
        Width = 449
        Height = 20
        Caption = 'Ask before reject'
        TabOrder = 0
      end
      object cbRejectNextTic: TCheckBox
        Left = 26
        Top = 85
        Width = 430
        Height = 20
        Caption = 'Reject next '#39'*.tic'#39' after file reject'
        TabOrder = 1
      end
      object cbAskBeforeSkip: TCheckBox
        Left = 26
        Top = 52
        Width = 449
        Height = 20
        Caption = 'Ask before skip'
        TabOrder = 2
      end
      object cbSkipNextTic: TCheckBox
        Left = 26
        Top = 117
        Width = 430
        Height = 20
        Caption = 'Skip next '#39'*.tic'#39' after file skip'
        TabOrder = 3
      end
    end
  end
  object bOK: TButton
    Left = 272
    Top = 247
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = 'O&K'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object bCancel: TButton
    Left = 352
    Top = 247
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object bHelp: TButton
    Left = 432
    Top = 247
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = 'Help'
    TabOrder = 3
    OnClick = bHelpClick
  end
end
