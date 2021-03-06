object IPcfgForm: TIPcfgForm
  Left = 283
  Top = 244
  HelpContext = 1240
  BorderStyle = bsDialog
  BorderWidth = 6
  Caption = 'TCP/IP Daemon  Configuration'
  ClientHeight = 315
  ClientWidth = 679
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
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  DesignSize = (
    679
    315)
  PixelsPerInch = 96
  TextHeight = 15
  object bOK: TButton
    Left = 601
    Top = 22
    Width = 75
    Height = 23
    Anchors = [akTop, akRight]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object bCancel: TButton
    Left = 601
    Top = 50
    Width = 75
    Height = 23
    Anchors = [akTop, akRight]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object bHelp: TButton
    Left = 601
    Top = 78
    Width = 75
    Height = 23
    Anchors = [akTop, akRight]
    Caption = 'Help'
    TabOrder = 3
    OnClick = bHelpClick
  end
  object tb: TPageControl
    Left = 0
    Top = 0
    Width = 594
    Height = 315
    ActivePage = lGeneral
    Align = alLeft
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    OnChange = tbChange
    object lGeneral: TTabSheet
      BorderWidth = 6
      Caption = 'General'
      DesignSize = (
        574
        273)
      object bvlSOCKS: TBevel
        Left = 0
        Top = 185
        Width = 574
        Height = 88
        Align = alBottom
        Anchors = [akLeft, akTop, akRight]
        Shape = bsFrame
      end
      object llInPorts: TLabel
        Left = 0
        Top = 0
        Width = 82
        Height = 15
        Caption = 'Incoming ports'
      end
      object llPassword: TLabel
        Left = 391
        Top = 226
        Width = 56
        Height = 15
        Alignment = taRightJustify
        Anchors = [akLeft, akRight, akBottom]
        Caption = 'Pass&word'
        FocusControl = lPassword
      end
      object llUserName: TLabel
        Left = 115
        Top = 226
        Width = 34
        Height = 15
        Alignment = taRightJustify
        Caption = '&Name'
        FocusControl = lUserName
      end
      object llSocksAddr: TLabel
        Left = 9
        Top = 198
        Width = 46
        Height = 15
        Alignment = taRightJustify
        Anchors = [akLeft, akRight, akBottom]
        Caption = '&Address'
        FocusControl = lSocksAddr
      end
      object llSocksPort: TLabel
        Left = 485
        Top = 198
        Width = 22
        Height = 15
        Alignment = taRightJustify
        Anchors = [akLeft, akRight, akBottom]
        Caption = '&Port'
        FocusControl = lSocksPort
      end
      object gIn: TAdvGrid
        Left = -1
        Top = 15
        Width = 398
        Height = 88
        FixedFont.Charset = DEFAULT_CHARSET
        FixedFont.Color = clWindowText
        FixedFont.Height = -12
        FixedFont.Name = 'Arial'
        FixedFont.Style = []
        ColCount = 2
        DefaultColWidth = 90
        DefaultRowHeight = 18
        RowCount = 9
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Fixedsys'
        Font.Style = []
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing, goFixedNumCols]
        ParentFont = False
        TabOrder = 0
        CheckBoxes = True
        ColWidths = (
          120
          248)
      end
      object llLimit: TGroupBox
        Left = 405
        Top = 11
        Width = 169
        Height = 91
        Anchors = [akTop, akRight, akBottom]
        Caption = 'Connections'
        TabOrder = 1
        object llCin: TLabel
          Left = 42
          Top = 18
          Width = 34
          Height = 15
          Alignment = taRightJustify
          Caption = 'Max &in'
          FocusControl = spIn
        end
        object llCout: TLabel
          Left = 35
          Top = 43
          Width = 41
          Height = 15
          Alignment = taRightJustify
          Caption = 'Max &out'
          FocusControl = spOut
        end
        object llAssumeSpeed: TLabel
          Left = 18
          Top = 68
          Width = 59
          Height = 15
          Alignment = taRightJustify
          Caption = 'BL counter'
          FocusControl = spBL
        end
        object spIn: TJvSpinEdit
          Left = 93
          Top = 13
          Width = 66
          Height = 24
          ButtonKind = bkStandard
          Increment = 4.000000000000000000
          MaxValue = 4096.000000000000000000
          Value = 16.000000000000000000
          TabOrder = 0
        end
        object spOut: TJvSpinEdit
          Left = 93
          Top = 37
          Width = 66
          Height = 24
          ButtonKind = bkStandard
          MaxValue = 1024.000000000000000000
          Value = 4.000000000000000000
          TabOrder = 1
        end
        object spBL: TJvSpinEdit
          Left = 93
          Top = 61
          Width = 66
          Height = 24
          ButtonKind = bkStandard
          MaxValue = 99999999.000000000000000000
          Value = 3.000000000000000000
          MaxLength = 2
          TabOrder = 2
        end
      end
      object rgProxyType: TRadioGroup
        Left = 0
        Top = 104
        Width = 398
        Height = 71
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = 'Proxy type'
        Columns = 2
        ItemIndex = 0
        Items.Strings = (
          'None'
          'Socks v4'
          'Socks v5'
          'HTTP <PUT>'
          'HTTP <CONNECT>')
        TabOrder = 2
        OnClick = cbSOCKSClick
      end
      object GroupBox1: TGroupBox
        Left = 405
        Top = 104
        Width = 169
        Height = 72
        Anchors = [akTop, akRight, akBottom]
        Caption = 'Traffic shaper'
        TabOrder = 3
        object llAssumeSpeedin: TLabel
          Left = 69
          Top = 17
          Width = 10
          Height = 15
          Alignment = taRightJustify
          Caption = 'In'
          FocusControl = spSPin
        end
        object llAssumeSpeedOut: TLabel
          Left = 61
          Top = 44
          Width = 19
          Height = 15
          Alignment = taRightJustify
          Caption = 'Out'
          FocusControl = spSPin
        end
        object spSPin: TJvSpinEdit
          Left = 87
          Top = 13
          Width = 73
          Height = 24
          ButtonKind = bkStandard
          Increment = 256.000000000000000000
          MaxValue = 99999999.000000000000000000
          Value = 99999999.000000000000000000
          MaxLength = 9
          TabOrder = 0
        end
        object spSPout: TJvSpinEdit
          Left = 87
          Top = 41
          Width = 73
          Height = 24
          ButtonKind = bkStandard
          Increment = 256.000000000000000000
          MaxValue = 99999999.000000000000000000
          Value = 99999999.000000000000000000
          MaxLength = 9
          TabOrder = 1
        end
      end
      object lSocksAddr: TEdit
        Left = 60
        Top = 194
        Width = 416
        Height = 23
        Anchors = [akLeft, akRight, akBottom]
        TabOrder = 4
      end
      object lSocksPort: TEdit
        Left = 512
        Top = 194
        Width = 51
        Height = 23
        Anchors = [akRight, akBottom]
        TabOrder = 5
      end
      object lPassword: TEdit
        Left = 450
        Top = 221
        Width = 113
        Height = 23
        Anchors = [akRight, akBottom]
        Enabled = False
        PasswordChar = '*'
        TabOrder = 6
      end
      object lUserName: TEdit
        Left = 153
        Top = 222
        Width = 231
        Height = 23
        Anchors = [akLeft, akRight, akBottom]
        Enabled = False
        TabOrder = 7
      end
      object cbAuth: TCheckBox
        Left = 8
        Top = 225
        Width = 103
        Height = 17
        Anchors = [akLeft, akRight, akBottom]
        Caption = 'Authenticate'
        TabOrder = 8
        OnClick = cbSOCKSClick
      end
      object cbEncryptPassword: TCheckBox
        Left = 370
        Top = 249
        Width = 199
        Height = 17
        Anchors = [akLeft, akRight, akBottom]
        Caption = 'Encrypt password in config'
        TabOrder = 9
      end
      object cbAllVIaProxy: TCheckBox
        Left = 8
        Top = 249
        Width = 148
        Height = 17
        Anchors = [akLeft, akRight, akBottom]
        Caption = 'All via proxy'
        TabOrder = 10
      end
    end
    object lStation: TTabSheet
      BorderWidth = 6
      Caption = 'Station'
      object gTpl: TAdvGrid
        Left = 0
        Top = 0
        Width = 574
        Height = 124
        FixedFont.Charset = DEFAULT_CHARSET
        FixedFont.Color = clWindowText
        FixedFont.Height = -12
        FixedFont.Name = 'Arial'
        FixedFont.Style = []
        Align = alTop
        ColCount = 2
        DefaultColWidth = 100
        DefaultRowHeight = 18
        RowCount = 6
        FixedRows = 0
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Fixedsys'
        Font.Style = []
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goEditing, goFixedNumCols]
        ParentFont = False
        TabOrder = 0
        CheckBoxes = False
      end
    end
    object lAKA: TTabSheet
      BorderWidth = 6
      Caption = 'AKA'
      object gAKA: TAdvGrid
        Left = 0
        Top = 0
        Width = 574
        Height = 273
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
          200
          324)
      end
    end
    object lBanner: TTabSheet
      BorderWidth = 6
      Caption = 'Banner'
      object eBan: TMemo
        Left = 0
        Top = 0
        Width = 568
        Height = 272
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Fixedsys'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
    object lRestrict: TTabSheet
      Tag = 8767
      BorderWidth = 2
      Caption = 'Restrictions'
      object p: TPageControl
        Left = 0
        Top = 0
        Width = 582
        Height = 281
        ActivePage = tsRequired
        Align = alClient
        MultiLine = True
        TabOrder = 0
        TabPosition = tpBottom
        object tsRequired: TTabSheet
          BorderWidth = 6
          Caption = 'Required'
          object gReqd: TAdvGrid
            Left = 0
            Top = 0
            Width = 562
            Height = 241
            FixedFont.Charset = DEFAULT_CHARSET
            FixedFont.Color = clWindowText
            FixedFont.Height = -12
            FixedFont.Name = 'Arial'
            FixedFont.Style = []
            Align = alClient
            ColCount = 2
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
              514)
          end
        end
        object tsForbidden: TTabSheet
          BorderWidth = 6
          Caption = 'Forbidden'
          object gForb: TAdvGrid
            Left = 0
            Top = 0
            Width = 561
            Height = 240
            FixedFont.Charset = DEFAULT_CHARSET
            FixedFont.Color = clWindowText
            FixedFont.Height = -12
            FixedFont.Name = 'Arial'
            FixedFont.Style = []
            Align = alClient
            ColCount = 2
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
              515)
          end
        end
      end
    end
    object lEvents: TTabSheet
      BorderWidth = 6
      Caption = 'Events'
      object labelAvl: TLabel
        Left = 0
        Top = 0
        Width = 49
        Height = 15
        Caption = '&Available'
        FocusControl = lAvl
      end
      object labelLinked: TLabel
        Left = 302
        Top = 0
        Width = 37
        Height = 15
        Caption = '&Linked'
        FocusControl = lLnk
      end
      object bRight: TSpeedButton
        Left = 266
        Top = 32
        Width = 25
        Height = 25
        Hint = 'Add'
        Caption = '&>'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Fixedsys'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        OnClick = bRightClick
      end
      object bLeft: TSpeedButton
        Left = 266
        Top = 60
        Width = 25
        Height = 25
        Hint = 'Delete'
        Caption = '&<'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Fixedsys'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        OnClick = bLeftClick
      end
      object bEdit: TSpeedButton
        Left = 266
        Top = 128
        Width = 25
        Height = 25
        Hint = 'Edit Events'
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          0400000000000001000000000000000000001000000010000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333000000
          000033333377777777773333330FFFFFFFF03FF3FF7FF33F3FF700300000FF0F
          00F077F777773F737737E00BFBFB0FFFFFF07773333F7F3333F7E0BFBF000FFF
          F0F077F3337773F3F737E0FBFBFBF0F00FF077F3333FF7F77F37E0BFBF00000B
          0FF077F3337777737337E0FBFBFBFBF0FFF077F33FFFFFF73337E0BF0000000F
          FFF077FF777777733FF7000BFB00B0FF00F07773FF77373377373330000B0FFF
          FFF03337777373333FF7333330B0FFFF00003333373733FF777733330B0FF00F
          0FF03333737F37737F373330B00FFFFF0F033337F77F33337F733309030FFFFF
          00333377737FFFFF773333303300000003333337337777777333}
        NumGlyphs = 2
        ParentShowHint = False
        ShowHint = True
        OnClick = bEditClick
      end
      object lAvl: TListBox
        Left = 0
        Top = 16
        Width = 255
        Height = 257
        ItemHeight = 15
        TabOrder = 0
        OnClick = lAvlClick
        OnDblClick = lAvlDblClick
        OnKeyPress = lAvlKeyPress
      end
      object lLnk: TListBox
        Left = 303
        Top = 16
        Width = 256
        Height = 257
        ItemHeight = 15
        TabOrder = 1
        OnClick = lAvlClick
        OnDblClick = lLnkDblClick
        OnKeyPress = lLnkKeyPress
      end
    end
    object lDNS: TTabSheet
      BorderWidth = 6
      Caption = 'DNS'
      object gDNS: TAdvGrid
        Left = 0
        Top = 0
        Width = 574
        Height = 273
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
          184
          216
          120)
      end
    end
    object lNodes: TTabSheet
      Tag = 8769
      BorderWidth = 6
      Caption = 'Nodes'
      object lAuxNodes: TLabel
        Left = 30
        Top = 251
        Width = 101
        Height = 15
        Alignment = taRightJustify
        Caption = 'Auxiliary nodes file'
        FocusControl = eAuxNode
      end
      object gOvr: TAdvGrid
        Left = 0
        Top = 0
        Width = 568
        Height = 241
        FixedFont.Charset = DEFAULT_CHARSET
        FixedFont.Color = clWindowText
        FixedFont.Height = -12
        FixedFont.Name = 'Arial'
        FixedFont.Style = []
        Align = alTop
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
          213
          310)
      end
      object eAuxNode: TEdit
        Left = 137
        Top = 247
        Width = 395
        Height = 24
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Fixedsys'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
    end
    object tsPOP3: TTabSheet
      Caption = 'POP3'
      ImageIndex = 8
      object gSMTP: TAdvGrid
        Left = 0
        Top = 0
        Width = 586
        Height = 285
        FixedFont.Charset = DEFAULT_CHARSET
        FixedFont.Color = clWindowText
        FixedFont.Height = -12
        FixedFont.Name = 'Arial'
        FixedFont.Style = []
        Align = alClient
        ColCount = 4
        DefaultRowHeight = 18
        FixedCols = 0
        RowCount = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Fixedsys'
        Font.Style = []
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing]
        ParentFont = False
        TabOrder = 0
        CheckBoxes = False
        PasswordCol = 3
        ColWidths = (
          64
          255
          125
          117)
      end
    end
    object tsSMTP: TTabSheet
      Caption = 'SMTP'
      ImageIndex = 9
      object gPOP3: TAdvGrid
        Left = 0
        Top = 0
        Width = 586
        Height = 285
        FixedFont.Charset = DEFAULT_CHARSET
        FixedFont.Color = clWindowText
        FixedFont.Height = -12
        FixedFont.Name = 'Arial'
        FixedFont.Style = []
        Align = alClient
        DefaultRowHeight = 18
        FixedCols = 0
        RowCount = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Fixedsys'
        Font.Style = []
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing]
        ParentFont = False
        TabOrder = 0
        CheckBoxes = False
        PasswordCol = 2
        ColWidths = (
          210
          73
          73
          64
          143)
      end
    end
    object tsNNTP: TTabSheet
      BorderWidth = 10
      Caption = 'NNTP'
      DesignSize = (
        566
        265)
      object lNNTPImport: TLabel
        Left = 4
        Top = 28
        Width = 168
        Height = 15
        Caption = 'Files to import NEWS List from'
      end
      object gNNTP: TAdvGrid
        Left = 0
        Top = 61
        Width = 566
        Height = 204
        FileNameCol = 1
        FixedFont.Charset = DEFAULT_CHARSET
        FixedFont.Color = clWindowText
        FixedFont.Height = -12
        FixedFont.Name = 'Arial'
        FixedFont.Style = []
        Align = alBottom
        ColCount = 2
        DefaultRowHeight = 17
        FixedCols = 0
        RowCount = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Courier'
        Font.Style = []
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing]
        ParentFont = False
        TabOrder = 0
        CheckBoxes = False
        ColWidths = (
          64
          479)
      end
      object gbCache: TGroupBox
        Left = 259
        Top = 2
        Width = 229
        Height = 45
        Anchors = [akTop, akRight]
        Caption = 'Cache'
        TabOrder = 1
        DesignSize = (
          229
          45)
        object lCache: TLabel
          Left = 42
          Top = 18
          Width = 94
          Height = 15
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          Caption = 'NNTP cache size'
        end
        object lCash2: TLabel
          Left = 202
          Top = 18
          Width = 16
          Height = 15
          Anchors = [akTop, akRight]
          Caption = 'Mb'
        end
        object xSpinCash: TJvSpinEdit
          Left = 144
          Top = 14
          Width = 51
          Height = 24
          ButtonKind = bkStandard
          MaxValue = 999.000000000000000000
          MinValue = 1.000000000000000000
          Value = 5.000000000000000000
          AutoSize = False
          MaxLength = 3
          TabOrder = 0
        end
      end
    end
    object tsBList: TTabSheet
      Caption = 'Black List'
      ImageIndex = 11
      object gBList: TAdvGrid
        Left = 0
        Top = 0
        Width = 586
        Height = 285
        FixedFont.Charset = DEFAULT_CHARSET
        FixedFont.Color = clWindowText
        FixedFont.Height = -12
        FixedFont.Name = 'Arial'
        FixedFont.Style = []
        Align = alClient
        ColCount = 4
        DefaultRowHeight = 17
        RowCount = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Courier'
        Font.Style = []
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowMoving, goEditing, goThumbTracking, goDigitalRows]
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
        CheckBoxes = False
        ColWidths = (
          31
          190
          64
          292)
      end
    end
  end
  object bImport: TButton
    Left = 601
    Top = 142
    Width = 75
    Height = 23
    Anchors = [akTop, akRight]
    Caption = '&Import...'
    TabOrder = 5
    Visible = False
    OnClick = bImportClick
  end
  object bSort: TButton
    Left = 601
    Top = 170
    Width = 75
    Height = 23
    Anchors = [akTop, akRight]
    Caption = '&Sort'
    TabOrder = 6
    Visible = False
    OnClick = bSortClick
  end
  object bEditNode: TButton
    Left = 599
    Top = 115
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = 'Edit'
    TabOrder = 4
    Visible = False
    OnClick = bEditNodeClick
  end
  object bExplain: TButton
    Left = 601
    Top = 114
    Width = 75
    Height = 23
    Anchors = [akTop, akRight]
    Caption = 'Explain...'
    TabOrder = 7
    Visible = False
    OnClick = bExplainClick
  end
  object TM: TTimer
    Interval = 100
    OnTimer = TMTimer
    Left = 640
    Top = 280
  end
end
