object MailerForm: TMailerForm
  Left = 192
  Top = 128
  Width = 737
  Height = 564
  HelpContext = 1500
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu
  OldCreateOrder = False
  Position = poDefaultPosOnly
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnHelp = FormHelp
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object MainTabControl: TTabControl
    Left = 0
    Top = 0
    Width = 729
    Height = 512
    Align = alClient
    HotTrack = True
    TabOrder = 0
    Tabs.Strings = (
      'Polls')
    TabIndex = 0
    OnChange = MainTabControlChange
    DesignSize = (
      729
      512)
    object lTime0: TLabel
      Left = 503
      Top = 3
      Width = 91
      Height = 16
      Alignment = taRightJustify
      Anchors = []
      Caption = 'Taurus uptime: '
      Layout = tlCenter
    end
    object lTime1: TLabel
      Left = 612
      Top = 3
      Width = 108
      Height = 16
      Alignment = taRightJustify
      Anchors = []
      Caption = '100 days 00:00:00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold, fsUnderline]
      ParentFont = False
      Layout = tlCenter
    end
    object MainPanel: TTransPan
      Left = 4
      Top = 27
      Width = 721
      Height = 481
      Align = alClient
      BevelOuter = bvNone
      BorderStyle = bsSingle
      ParentBackground = False
      TabOrder = 0
      EraseBackGround = True
      object LogBox: TLogger
        Left = 0
        Top = 329
        Width = 717
        Height = 108
        Cursor = crHandPoint
        Align = alClient
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'FixedSys'
        Font.Pitch = fpFixed
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 4
      end
      object TopNotebookPanel: TTransPan
        Left = 0
        Top = 0
        Width = 717
        Height = 329
        Align = alTop
        BevelOuter = bvNone
        ParentBackground = False
        TabOrder = 0
        object PollsListPanel: TTransPan
          Left = 0
          Top = 0
          Width = 717
          Height = 329
          Align = alClient
          BevelOuter = bvNone
          ParentBackground = False
          TabOrder = 0
          Visible = False
          EraseBackGround = True
          object PollsListView: TAdvListView
            Left = 0
            Top = 0
            Width = 717
            Height = 329
            Align = alClient
            AllocBy = 128
            BorderStyle = bsNone
            Columns = <
              item
                Caption = 'Node'
                Width = 123
              end
              item
                Caption = 'Numbers'
                Width = 209
              end
              item
                Caption = 'Owner'
                Width = 98
              end
              item
                Caption = 'State'
                Width = 74
              end
              item
                Caption = 'Busy'
                Width = 49
              end
              item
                Caption = 'No c.'
                Width = 49
              end
              item
                Caption = 'Fail'
                Width = 49
              end
              item
                Caption = 'Type'
                Width = 74
              end>
            ColumnClick = False
            ReadOnly = True
            RowSelect = True
            PopupMenu = PollPopupMenu
            TabOrder = 0
            ViewStyle = vsReport
            OnClick = PollsListViewClick
            OnDblClick = PollsListViewDblClick
            OnKeyDown = PollsListViewKeyDown
            OnApiDropFiles = PollsListViewApiDropFiles
          end
        end
        object DaemonPanel: TTransPan
          Left = 0
          Top = 0
          Width = 717
          Height = 329
          Align = alClient
          BevelOuter = bvNone
          ParentBackground = False
          TabOrder = 2
          Visible = False
          EraseBackGround = True
          object MainDaemonPanel: TTransPan
            Left = 10
            Top = 0
            Width = 697
            Height = 315
            Align = alClient
            BevelOuter = bvNone
            ParentBackground = False
            TabOrder = 0
            object Panel7: TTransPan
              Left = 0
              Top = 158
              Width = 697
              Height = 157
              Align = alBottom
              BevelOuter = bvNone
              ParentBackground = False
              TabOrder = 0
              object Panel9: TTransPan
                Left = 0
                Top = 0
                Width = 112
                Height = 157
                Align = alLeft
                BevelOuter = bvNone
                BorderWidth = 8
                ParentBackground = False
                TabOrder = 0
                object DaemonPI: TTransPan
                  Left = 8
                  Top = 8
                  Width = 96
                  Height = 20
                  Align = alTop
                  Alignment = taLeftJustify
                  BevelOuter = bvNone
                  Caption = ' Input'
                  ParentBackground = False
                  TabOrder = 0
                end
                object Panel16: TTransPan
                  Left = 8
                  Top = 28
                  Width = 96
                  Height = 121
                  Align = alClient
                  BorderWidth = 1
                  ParentBackground = False
                  TabOrder = 1
                  object gInput: TNavyGauge
                    Left = 2
                    Top = 2
                    Width = 92
                    Height = 117
                    Align = alClient
                  end
                end
              end
              object Panel12: TTransPan
                Left = 112
                Top = 0
                Width = 585
                Height = 157
                Align = alClient
                BevelOuter = bvNone
                BorderWidth = 8
                ParentBackground = False
                TabOrder = 1
                object DaemonPIH: TTransPan
                  Left = 8
                  Top = 8
                  Width = 569
                  Height = 20
                  Align = alTop
                  Alignment = taLeftJustify
                  BevelOuter = bvNone
                  Caption = ' Input History'
                  ParentBackground = False
                  TabOrder = 0
                end
                object Panel18: TTransPan
                  Left = 8
                  Top = 28
                  Width = 569
                  Height = 121
                  Align = alClient
                  BorderWidth = 1
                  ParentBackground = False
                  TabOrder = 1
                  object gInputGraph: TNavyGraph
                    Left = 2
                    Top = 2
                    Width = 565
                    Height = 117
                    Align = alClient
                    EraseBackGround = True
                  end
                end
              end
            end
            object Panel6: TTransPan
              Left = 0
              Top = 0
              Width = 697
              Height = 158
              Align = alClient
              BevelOuter = bvNone
              ParentBackground = False
              TabOrder = 1
              object Panel8: TTransPan
                Left = 0
                Top = 0
                Width = 112
                Height = 158
                Align = alLeft
                BevelOuter = bvNone
                BorderWidth = 8
                ParentBackground = False
                TabOrder = 0
                object DaemonPO: TTransPan
                  Left = 8
                  Top = 8
                  Width = 96
                  Height = 20
                  Align = alTop
                  Alignment = taLeftJustify
                  BevelOuter = bvNone
                  Caption = ' Output'
                  ParentBackground = False
                  TabOrder = 0
                end
                object Panel111: TTransPan
                  Left = 8
                  Top = 28
                  Width = 96
                  Height = 122
                  Align = alClient
                  BorderWidth = 1
                  ParentBackground = False
                  TabOrder = 1
                  object gOutput: TNavyGauge
                    Left = 2
                    Top = 2
                    Width = 92
                    Height = 118
                    Align = alClient
                  end
                end
              end
              object Panel10: TTransPan
                Left = 112
                Top = 0
                Width = 585
                Height = 158
                Align = alClient
                BevelOuter = bvNone
                BorderWidth = 8
                ParentBackground = False
                TabOrder = 1
                object DaemonPOH: TTransPan
                  Left = 8
                  Top = 8
                  Width = 569
                  Height = 20
                  Align = alTop
                  Alignment = taLeftJustify
                  BevelOuter = bvNone
                  Caption = ' Output History'
                  ParentBackground = False
                  TabOrder = 0
                end
                object Panel17: TTransPan
                  Left = 8
                  Top = 28
                  Width = 569
                  Height = 122
                  Align = alClient
                  BorderWidth = 1
                  ParentBackground = False
                  TabOrder = 1
                  object gOutputGraph: TNavyGraph
                    Left = 2
                    Top = 2
                    Width = 565
                    Height = 118
                    Align = alClient
                    EraseBackGround = True
                  end
                end
              end
            end
          end
          object Panel19: TTransPan
            Left = 0
            Top = 315
            Width = 717
            Height = 14
            Align = alBottom
            BevelOuter = bvNone
            ParentBackground = False
            TabOrder = 1
            EraseBackGround = True
          end
          object Panel20: TTransPan
            Left = 707
            Top = 0
            Width = 10
            Height = 315
            Align = alRight
            BevelOuter = bvNone
            ParentBackground = False
            TabOrder = 2
            EraseBackGround = True
          end
          object Panel21: TTransPan
            Left = 0
            Top = 0
            Width = 10
            Height = 315
            Align = alLeft
            BevelOuter = bvNone
            ParentBackground = False
            TabOrder = 3
            Visible = False
            EraseBackGround = True
          end
        end
        object MailerAPanel: TTransPan
          Left = 0
          Top = 0
          Width = 717
          Height = 329
          Align = alClient
          BevelOuter = bvNone
          ParentBackground = False
          TabOrder = 1
          Visible = False
          EraseBackGround = True
          object SplitterAPanel: TSplitter
            Left = 393
            Top = 0
            Width = 4
            Height = 329
            Align = alRight
            AutoSnap = False
            ResizeStyle = rsUpdate
            OnMoved = SplitterAPanelMoved
          end
          object TermsPanel: TTransPan
            Left = 397
            Top = 0
            Width = 320
            Height = 329
            Align = alRight
            BevelOuter = bvNone
            ParentBackground = False
            TabOrder = 0
            object TermRx: TMicroTerm
              Left = 10
              Top = 156
              Width = 305
              Height = 144
            end
            object TermTx: TMicroTerm
              Left = 10
              Top = 9
              Width = 305
              Height = 144
            end
          end
          object DialupInfoPanel: TTransPan
            Left = 0
            Top = 0
            Width = 393
            Height = 329
            Align = alClient
            BevelOuter = bvNone
            ParentBackground = False
            TabOrder = 1
            EraseBackGround = True
            object Panel4: TTransPan
              Left = 0
              Top = 66
              Width = 393
              Height = 256
              Align = alTop
              BevelOuter = bvNone
              BorderWidth = 3
              ParentBackground = False
              TabOrder = 1
              EraseBackGround = True
              object GroupBox2: TGroupBox
                Left = 9
                Top = 3
                Width = 381
                Height = 250
                Align = alClient
                Caption = ' badwazoo.lst '
                ParentBackground = False
                TabOrder = 0
                object Panel11: TTransPan
                  Left = 2
                  Top = 18
                  Width = 377
                  Height = 230
                  Align = alClient
                  BevelOuter = bvNone
                  BorderWidth = 4
                  ParentBackground = False
                  TabOrder = 0
                  EraseBackGround = True
                  object bwListView: TListView
                    Left = 4
                    Top = 4
                    Width = 369
                    Height = 222
                    Align = alClient
                    Columns = <
                      item
                        Caption = 'Filename'
                        MinWidth = 70
                        Width = 86
                      end
                      item
                        Caption = 'Temp Size'
                        MinWidth = 50
                        Width = 86
                      end
                      item
                        Caption = 'Full Size'
                        MinWidth = 50
                        Width = 86
                      end
                      item
                        Caption = 'From Node'
                        MinWidth = 50
                        Width = 86
                      end
                      item
                        Caption = 'FileTime'
                        MinWidth = 50
                        Width = 62
                      end>
                    ColumnClick = False
                    GridLines = True
                    ReadOnly = True
                    RowSelect = True
                    PopupMenu = pBWZ
                    TabOrder = 0
                    ViewStyle = vsReport
                    OnClick = bwListBoxClick
                  end
                end
              end
              object Panel5: TTransPan
                Left = 3
                Top = 3
                Width = 6
                Height = 250
                Align = alLeft
                BevelOuter = bvNone
                ParentBackground = False
                TabOrder = 1
                EraseBackGround = True
              end
            end
            object StatusCarrier: TTransPan
              Left = 0
              Top = 0
              Width = 393
              Height = 66
              Align = alTop
              BevelOuter = bvNone
              BorderWidth = 3
              ParentBackground = False
              TabOrder = 0
              EraseBackGround = True
              object Panel1: TTransPan
                Left = 3
                Top = 3
                Width = 6
                Height = 60
                Align = alLeft
                BevelOuter = bvNone
                ParentBackground = False
                TabOrder = 1
                EraseBackGround = True
              end
              object StatusBox: TGroupBox
                Left = 9
                Top = 3
                Width = 381
                Height = 60
                Align = alClient
                Caption = ' Status '
                ParentBackground = False
                TabOrder = 0
                object lStatus: TLabel
                  Left = 14
                  Top = 25
                  Width = 22
                  Height = 16
                  Caption = 'Idle'
                  Transparent = False
                  Layout = tlCenter
                end
                object TimeoutBox: TTransPan
                  Left = 266
                  Top = 18
                  Width = 113
                  Height = 40
                  Align = alRight
                  BevelOuter = bvNone
                  ParentBackground = False
                  TabOrder = 0
                  Visible = False
                  EraseBackGround = True
                  object lTimeout: TLabel
                    Left = 71
                    Top = 8
                    Width = 21
                    Height = 16
                    Caption = '999'
                  end
                  object bStart: TSpeedButton
                    Left = 4
                    Top = 3
                    Width = 30
                    Height = 26
                    Glyph.Data = {
                      36010000424D3601000000000000760000002800000014000000100000000100
                      040000000000C000000000000000000000001000000010000000000000000000
                      80000080000000808000800000008000800080800000C0C0C000808080000000
                      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
                      333333330000333333333333333333330000338FF33333333333FF3300003380
                      F333333333FF0F3300003380F3333333FF000F3300003380F33333FF00000F33
                      00003380F333FF0000000F3300003380F33F000000000F3300003380F3880000
                      00000F3300003380F333880000000F3300003380F333338800000F3300003380
                      F333333388000F3300003380F333333333880F3300003388F333333333338F33
                      0000333333333333333333330000333333333333333333330000}
                    OnClick = bStartClick
                  end
                  object bAdd: TSpeedButton
                    Left = 32
                    Top = 3
                    Width = 30
                    Height = 26
                    Glyph.Data = {
                      36010000424D3601000000000000760000002800000011000000100000000100
                      040000000000C000000000000000000000001000000010000000000000000000
                      80000080000000808000800000008000800080800000C0C0C000808080000000
                      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
                      333330000000333333333333333330000000333F333333333333300000003380
                      FF333333333330000000338000FF333333333000000033800000FF3333333000
                      00003380000000FF333330000000338000000000FF3330000000338000000000
                      88F3300000003380000000883333300000003380000088333333300000003380
                      0088333333333000000033808833333333333000000033883333333333333000
                      0000333333333333333330000000333333333333333330000000}
                    OnClick = bAddClick
                  end
                end
              end
            end
          end
        end
        object MailerBPanel: TTransPan
          Left = 0
          Top = 0
          Width = 717
          Height = 329
          Align = alClient
          BevelOuter = bvNone
          ParentBackground = False
          TabOrder = 3
          Visible = False
          EraseBackGround = True
          object SplitterBPanel: TSplitter
            Left = 375
            Top = 0
            Width = 4
            Height = 329
            AutoSnap = False
            ResizeStyle = rsUpdate
            OnMoved = SplitterBPanelMoved
          end
          object Panel3: TTransPan
            Left = 379
            Top = 0
            Width = 338
            Height = 329
            Align = alClient
            BevelOuter = bvNone
            BorderWidth = 12
            ParentBackground = False
            TabOrder = 1
            EraseBackGround = True
            object SessionHist: TTransPan
              Left = 12
              Top = 222
              Width = 314
              Height = 95
              Align = alBottom
              ParentBackground = False
              TabOrder = 1
              EraseBackGround = True
              object MHistO: TNavyGraph
                Left = 1
                Top = 1
                Width = 312
                Height = 46
                Align = alTop
                EraseBackGround = True
              end
              object MHistI: TNavyGraph
                Left = 1
                Top = 48
                Width = 312
                Height = 46
                Align = alBottom
                EraseBackGround = True
              end
            end
            object SessionNfoPnl: TTransPan
              Left = 12
              Top = 12
              Width = 314
              Height = 207
              Align = alTop
              BevelOuter = bvNone
              ParentBackground = False
              TabOrder = 0
              object gTabCnt: TTabControl
                Left = 0
                Top = 0
                Width = 314
                Height = 207
                Align = alClient
                TabOrder = 0
                Tabs.Strings = (
                  'Info')
                TabIndex = 0
                OnChange = gTabCntChange
                object gTitles: TAdvGrid
                  Left = 4
                  Top = 27
                  Width = 105
                  Height = 176
                  FixedFont.Charset = DEFAULT_CHARSET
                  FixedFont.Color = clWindowText
                  FixedFont.Height = -13
                  FixedFont.Name = 'Arial'
                  FixedFont.Style = []
                  Align = alLeft
                  Color = clBtnFace
                  ColCount = 2
                  DefaultColWidth = 80
                  DefaultRowHeight = 18
                  Enabled = False
                  RowCount = 8
                  FixedRows = 0
                  Options = [goFixedVertLine, goFixedHorzLine]
                  ScrollBars = ssNone
                  TabOrder = 0
                  CheckBoxes = False
                end
                object gNfo: TAdvGrid
                  Left = 109
                  Top = 27
                  Width = 201
                  Height = 176
                  FixedFont.Charset = DEFAULT_CHARSET
                  FixedFont.Color = clWindowText
                  FixedFont.Height = -13
                  FixedFont.Name = 'Arial'
                  FixedFont.Style = []
                  Align = alClient
                  Color = clBtnFace
                  ColCount = 1
                  DefaultColWidth = 1000
                  DefaultRowHeight = 18
                  FixedCols = 0
                  RowCount = 8
                  FixedRows = 0
                  Options = [goHorzLine]
                  ScrollBars = ssHorizontal
                  TabOrder = 2
                  CheckBoxes = False
                end
                object gLst: TAdvGrid
                  Left = 113
                  Top = 30
                  Width = 307
                  Height = 172
                  FixedFont.Charset = DEFAULT_CHARSET
                  FixedFont.Color = clWindowText
                  FixedFont.Height = -13
                  FixedFont.Name = 'Arial'
                  FixedFont.Style = []
                  ColCount = 3
                  DefaultColWidth = 160
                  DefaultRowHeight = 18
                  RowCount = 2
                  Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goDigitalRows]
                  ScrollBars = ssVertical
                  TabOrder = 1
                  Visible = False
                  CheckBoxes = False
                  ColWidths = (
                    31
                    171
                    60)
                end
              end
            end
          end
          object Panel2: TTransPan
            Left = 0
            Top = 0
            Width = 375
            Height = 329
            Align = alLeft
            BevelOuter = bvNone
            ParentBackground = False
            TabOrder = 0
            DesignSize = (
              375
              329)
            object SndBox: TGroupBox
              Left = 10
              Top = 10
              Width = 365
              Height = 119
              Anchors = [akLeft, akTop, akRight]
              Caption = 'Sending'
              ParentBackground = False
              TabOrder = 0
              DesignSize = (
                365
                119)
              object lSndFile: TLabel
                Left = 14
                Top = 25
                Width = 80
                Height = 16
                Caption = 'Taurus.exe'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -15
                Font.Name = 'Fixedsys'
                Font.Style = []
                ParentFont = False
                ParentShowHint = False
                ShowAccelChar = False
                ShowHint = True
              end
              object llSndCPS: TLabel
                Left = 239
                Top = 22
                Width = 27
                Height = 16
                Anchors = [akTop, akRight]
                Caption = 'CPS'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -15
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
                Visible = False
              end
              object lSndCPS: TLabel
                Left = 211
                Top = 22
                Width = 25
                Height = 16
                Alignment = taRightJustify
                Anchors = [akTop, akRight]
                Caption = '100'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -15
                Font.Name = 'MS Sans Serif'
                Font.Style = [fsBold]
                ParentFont = False
                Visible = False
              end
              object llSndSize: TLabel
                Left = 20
                Top = 74
                Width = 29
                Height = 16
                Caption = 'Size:'
                Visible = False
              end
              object lSndSize: TLabel
                Left = 55
                Top = 74
                Width = 5
                Height = 16
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -15
                Font.Name = 'MS Sans Serif'
                Font.Style = [fsBold]
                ParentFont = False
                Visible = False
              end
              object SndTot: TxGauge
                Left = 281
                Top = 20
                Width = 70
                Height = 70
                Kind = gkPie
                BorderStyle = bsNone
                Progress = 0
                Visible = False
              end
              object llFileSndTime: TLabel
                Left = 20
                Top = 92
                Width = 53
                Height = 16
                Caption = 'File time:'
                Layout = tlCenter
                Visible = False
              end
              object lFileSndTime: TLabel
                Left = 79
                Top = 92
                Width = 57
                Height = 16
                Caption = '00:00:00'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -15
                Font.Name = 'MS Sans Serif'
                Font.Style = [fsBold]
                ParentFont = False
                Layout = tlCenter
                Visible = False
              end
              object llTotalSndTime: TLabel
                Left = 167
                Top = 92
                Width = 62
                Height = 16
                Caption = 'Total time:'
                Layout = tlCenter
                Visible = False
              end
              object lTotalSndTime: TLabel
                Left = 234
                Top = 92
                Width = 57
                Height = 16
                Caption = '00:00:00'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -15
                Font.Name = 'MS Sans Serif'
                Font.Style = [fsBold]
                ParentFont = False
                Layout = tlCenter
                Visible = False
              end
              object SndBar: TProgressBar
                Left = 15
                Top = 44
                Width = 250
                Height = 19
                Anchors = [akLeft, akTop, akRight]
                Smooth = True
                TabOrder = 0
                Visible = False
              end
            end
            object RcvBox: TGroupBox
              Left = 10
              Top = 133
              Width = 365
              Height = 119
              Anchors = [akLeft, akTop, akRight]
              Caption = 'Receiving'
              ParentBackground = False
              TabOrder = 2
              DesignSize = (
                365
                119)
              object lRcvFile: TLabel
                Left = 14
                Top = 25
                Width = 80
                Height = 16
                Caption = 'Taurus.exe'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -15
                Font.Name = 'Fixedsys'
                Font.Style = []
                ParentFont = False
                ParentShowHint = False
                ShowAccelChar = False
                ShowHint = True
              end
              object llRcvCPS: TLabel
                Left = 239
                Top = 22
                Width = 27
                Height = 16
                Anchors = [akTop, akRight]
                Caption = 'CPS'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -15
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
                Visible = False
              end
              object lRcvCPS: TLabel
                Left = 211
                Top = 22
                Width = 25
                Height = 16
                Alignment = taRightJustify
                Anchors = [akTop, akRight]
                Caption = '100'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -15
                Font.Name = 'MS Sans Serif'
                Font.Style = [fsBold]
                ParentFont = False
                Visible = False
              end
              object llRcvSize: TLabel
                Left = 20
                Top = 74
                Width = 29
                Height = 16
                Caption = 'Size:'
                Visible = False
              end
              object lRcvSize: TLabel
                Left = 55
                Top = 74
                Width = 5
                Height = 16
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -15
                Font.Name = 'MS Sans Serif'
                Font.Style = [fsBold]
                ParentFont = False
                Visible = False
              end
              object RcvTot: TxGauge
                Left = 281
                Top = 20
                Width = 70
                Height = 70
                Kind = gkPie
                BorderStyle = bsNone
                Progress = 0
                Visible = False
              end
              object llFileRcvTime: TLabel
                Left = 20
                Top = 91
                Width = 53
                Height = 16
                Caption = 'File time:'
                Layout = tlCenter
                Visible = False
              end
              object lFileRcvTime: TLabel
                Left = 79
                Top = 91
                Width = 57
                Height = 16
                Caption = '00:00:00'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -15
                Font.Name = 'MS Sans Serif'
                Font.Style = [fsBold]
                ParentFont = False
                Layout = tlCenter
                Visible = False
              end
              object llTotalRcvTime: TLabel
                Left = 167
                Top = 91
                Width = 62
                Height = 16
                Caption = 'Total time:'
                Layout = tlCenter
                Visible = False
              end
              object lTotalRcvTime: TLabel
                Left = 236
                Top = 91
                Width = 57
                Height = 16
                Caption = '00:00:00'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -15
                Font.Name = 'MS Sans Serif'
                Font.Style = [fsBold]
                ParentFont = False
                Layout = tlCenter
                Visible = False
              end
              object RcvBar: TProgressBar
                Left = 15
                Top = 44
                Width = 250
                Height = 19
                Anchors = [akLeft, akTop, akRight]
                Smooth = True
                TabOrder = 0
                Visible = False
              end
            end
            object SessionBox: TGroupBox
              Left = 11
              Top = 255
              Width = 364
              Height = 59
              Anchors = [akLeft, akTop, akRight]
              Caption = 'SessionBox'
              ParentBackground = False
              TabOrder = 1
              DesignSize = (
                364
                59)
              object llSessionTime: TLabel
                Left = 15
                Top = 26
                Width = 115
                Height = 16
                Alignment = taRightJustify
                Caption = 'Total elapsed time:'
                Layout = tlCenter
                Visible = False
              end
              object lSessionTime: TLabel
                Left = 139
                Top = 26
                Width = 57
                Height = 16
                Caption = '00:00:00'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -15
                Font.Name = 'MS Sans Serif'
                Font.Style = [fsBold]
                ParentFont = False
                Layout = tlCenter
                Visible = False
              end
              object llSessionCost: TLabel
                Left = 259
                Top = 26
                Width = 30
                Height = 16
                Alignment = taRightJustify
                Anchors = [akTop, akRight]
                Caption = 'Cost:'
                Layout = tlCenter
              end
              object lSessionCost: TLabel
                Left = 295
                Top = 26
                Width = 37
                Height = 16
                Anchors = [akTop, akRight]
                Caption = '00.00'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -15
                Font.Name = 'MS Sans Serif'
                Font.Style = [fsBold]
                ParentFont = False
                Layout = tlCenter
              end
            end
          end
        end
      end
      object ChatPan: TTransPan
        Left = 0
        Top = 329
        Width = 717
        Height = 108
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 3
        Visible = False
        OnResize = ChatPanResize
        object ChatCaptionPan: TTransPan
          Left = 0
          Top = 0
          Width = 717
          Height = 23
          Align = alTop
          TabOrder = 2
          OnConstrainedResize = ChatCaptionPanConstrainedResize
          EraseBackGround = True
          DesignSize = (
            717
            23)
          object imgHeader: TImage
            Left = 1
            Top = 1
            Width = 715
            Height = 21
            Align = alClient
            Picture.Data = {
              07544269746D617086050000424D86050000000000001E040000280000006801
              000001000000010008000000000068010000120B0000120B0000FA000000FA00
              00007F7E7F007E7D7E007D7C7D007574750074737400727172006C6B6C006A69
              6A00676667006665660065646500BFBEBF00BEBDBE00BCBBBC00BAB9BA00B8B7
              B800B6B5B600B0AFB000ABAAAB00A6A5A600A4A3A400A1A0A100969596009594
              9500949394009291920091909100908F9000818081007F7E7E00777676007574
              74006F6E6E006C6B6B006B6A6A006A69690066656500C0BFBF00BEBDBD00BCBB
              BB00B1B0B000ACABAB00AAA9A900A2A1A100A09F9F009E9D9D00989797008E8D
              8D008C8B8B008B8A8A0084838300828181007D7D7C007B7B7A007A7A79007979
              78007676750074747300737372006C6C6B006B6B6A006A6A6900696968006666
              6500C0C0BF00B5B5B400B4B4B300B2B2B100B1B1B000B0B0AF00AEAEAD00ADAD
              AC00A5A5A400969695008A8A890086868500858584007A7B7A00797A79007778
              7700727372006D6E6D006768670065666500BFC0BF00BEBFBE00BABBBA00B9BA
              B900B8B9B800B7B8B700B6B7B600B4B5B400AEAFAE00ACADAC00AAABAA00A6A7
              A600999A99009899980096979600949594008F908F008E8F8E008C8D8C008687
              8600808180007B7C7C007576760072737300707171006F7070006D6E6E006465
              6500BFC0C000BDBEBE00B9BABA00B8B9B900B6B7B700B5B6B600B1B2B200ADAE
              AE00ABACAC00AAABAB00A9AAAA009D9E9E0098999900929393008D8E8E008B8C
              8C008889890087888800848585007F8080007D7D7E0078787900717172007070
              71006C6C6D0066666700BCBCBD00BABABB00B6B6B700B4B4B500B2B2B300B0B0
              B100AEAEAF00ADADAE00A9A9AA00A8A8A900A6A6A700A4A4A5009D9D9E009C9C
              9D009B9B9C00949495009393940091919200909091008E8E8F008C8C8D008282
              830081818200C0C0C000BFBFBF00BEBEBE00BDBDBD00BCBCBC00BBBBBB00BABA
              BA00B9B9B900B8B8B800B7B7B700B6B6B600B5B5B500B4B4B400B3B3B300B2B2
              B200B1B1B100AFAFAF00AEAEAE00ADADAD00ACACAC00ABABAB00A9A9A900A8A8
              A800A7A7A700A6A6A600A5A5A500A4A4A400A3A3A300A2A2A200A1A1A100A0A0
              A0009F9F9F009E9E9E009D9D9D009C9C9C009B9B9B009A9A9A00999999009898
              9800979797009696960095959500939393009292920091919100909090008F8F
              8F008E8E8E008D8D8D008C8C8C008B8B8B008A8A8A0089898900888888008787
              87008686860084848400838383008282820081818100808080007F7F7F007E7E
              7E007C7C7C007B7B7B007A7A7A00797979007878780077777700767676007575
              750074747400737373007272720071717100707070006F6F6F006E6E6E006D6D
              6D006C6C6C006B6B6B006A6A6A00696969006868680067676700666666006565
              65006464640000000000F8F8F8F86F0AF7F753090924F63FF68908F5F5F5F5F4
              52F4F4F4F4F4F33EF323073DF2F2F2223CF1F121063BF088EFF0EF6E516EEE20
              EEEEEDED6D6DEC8787EB6CEA0586EA3A506BE90404391FE803E7E76A38E61EE5
              E5E54FE485E437E3E34E36E2354DE1E1E069E0023484DF01DFDF1D00DE83DDDD
              681CDC33A0DBDB9FDA323232D9D9824C4BD8D8D867D7D7D781D6D6D680D5D54A
              4AD431D4D330307F9ED266D12F2F7ED09D65CFCF1B64CECE1A9CCD9B9B19CCCC
              7DCBCB9A189A996317CACA4916C962C8C8C82EC8C761C77CC66060C5C5C4C4C4
              98C3C3C397C2962D7BC1C1C0C0C0C02CBF15BEBEBE2BBDBDBDBCBCBC14BB4895
              BABA13B9B95F94B8B8B7B7B7B793B62A7A925E1279B57829B4B45D47B3779146
              B2905CB1B145118F2844B0B07643AFAF8E8EAEAE42ADAD5B8D41AC7510ABAB8C
              5A74AA59A90FA9A97358A8A872570EA7A78B568BA6A60D270DA58AA5A58AA4A4
              0C71A426A3A3550BA2A2A2A2A254257040A1}
            Stretch = True
          end
          object sbCloseChat: TSpeedButton
            Left = 642
            Top = 2
            Width = 18
            Height = 18
            Hint = 'Close chat'
            Anchors = [akTop, akRight]
            Caption = 'r'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBtnText
            Font.Height = 19
            Font.Name = 'Webdings'
            Font.Style = []
            Layout = blGlyphTop
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            Spacing = 0
            Transparent = False
            OnClick = sbCloseChatClick
          end
          object lChatCaption: TLabel
            Left = 7
            Top = 4
            Width = 55
            Height = 20
            Caption = 'Caption'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -16
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            Transparent = True
          end
        end
        object Panel13: TTransPan
          Left = 0
          Top = 77
          Width = 717
          Height = 31
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 0
          DesignSize = (
            717
            31)
          object eType: TEdit
            Left = 1
            Top = 4
            Width = 863
            Height = 24
            Anchors = [akLeft, akTop, akRight, akBottom]
            TabOrder = 0
            OnKeyPress = eTypeKeyPress
          end
        end
        object Panel15: TTransPan
          Left = 0
          Top = 23
          Width = 717
          Height = 54
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          object ChatMemo1: TMemo
            Left = 0
            Top = 0
            Width = 717
            Height = 191
            TabStop = False
            Align = alTop
            Color = 14415353
            ReadOnly = True
            ScrollBars = ssVertical
            TabOrder = 0
            OnKeyPress = ChatMemo2KeyPress
          end
          object ChatMemo2: TMemo
            Left = 0
            Top = 191
            Width = 717
            Height = 198
            TabStop = False
            Align = alClient
            Color = 14415353
            ReadOnly = True
            ScrollBars = ssVertical
            TabOrder = 1
            OnKeyPress = ChatMemo2KeyPress
          end
        end
      end
      object BottomPanel: TTransPan
        Left = 0
        Top = 437
        Width = 717
        Height = 40
        Align = alBottom
        BevelOuter = bvNone
        ParentBackground = False
        ParentColor = True
        TabOrder = 1
        object MailerBtnPanel: TTransPan
          Left = 0
          Top = 0
          Width = 717
          Height = 40
          Align = alClient
          BevelOuter = bvNone
          ParentBackground = False
          TabOrder = 0
          Visible = False
          object bAbort: TSpeedButton
            Left = 9
            Top = 4
            Width = 32
            Height = 32
            Hint = 'Abort & Reset'
            Flat = True
            Glyph.Data = {
              DE010000424DDE01000000000000760000002800000024000000120000000100
              0400000000006801000000000000000000001000000010000000000000000000
              8000008000000080800080000000800080008080000080808000C0C0C0000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333111111
              33333333333F7777773F33330000391331999999113333377F3733333377F333
              000039911999999999133337F7733FFFFF337F3300003999999FFFFF99913337
              F333F77777F337F30000399999F33333F9991337F33F7333337F337F00003999
              993333333F991337F33733333337F37F00003999999333333F991337FFFF7F33
              3337777300003FFFFFFF33333333333777777733333333330000333333333333
              333333333333333333FFFFFF000033333333333311111133FFFF333333777777
              00003F991333333F99999137777F333337F3333700003F9913333333F9999137
              F37F333333733337000033F991333331199991337337FFFFF7733337000033F9
              99111119999991337F3377777333FF370000333F9999999999FF913337FF3333
              33FF77F700003333FF999999FF33F3333377FFFFFF7733730000333333FFFFFF
              3333333333337777773333330000333333333333333333333333333333333333
              0000}
            NumGlyphs = 2
            ParentShowHint = False
            ShowHint = True
            OnClick = bAbortClick
          end
          object bRefuse: TSpeedButton
            Left = 85
            Top = 4
            Width = 32
            Height = 32
            Hint = 'Reject file (delete on remote)'
            Enabled = False
            Flat = True
            Glyph.Data = {
              DE010000424DDE01000000000000760000002800000024000000120000000100
              0400000000006801000000000000000000001000000010000000000000000000
              8000008000000080800080000000800080008080000080808000C0C0C0000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00311116333331
              11133333FFFF333333FFFF330000339991333333291333337733F33333773F33
              0000333291633333291333333373F33333373F33000033329213333696633333
              33733F333373F33300003333991633629133333333373F333733F33300003333
              6991162916333333333733FF733F333300003333329922916333333333337333
              33F333330000333333699922613333333333373333F7FF330000331111669913
              6913333337FFF7733F373F3300003369921692136913333337733F733F373F33
              000033336921991129133333333733F33FF73F33000033333392992991333333
              333373333333F33300003333333229991333333333333733333F333300003333
              33332291333333333333337333F3333300003333333119133333333333333337
              3F333333000033333336921333333333333333733F3333330000333333369913
              33333333333333733F3333330000333333336663333333333333333777333333
              0000}
            NumGlyphs = 2
            ParentShowHint = False
            ShowHint = True
            OnClick = bRefuseClick
          end
          object bSkip: TSpeedButton
            Left = 47
            Top = 4
            Width = 32
            Height = 32
            Hint = 'Skip file (receive later)'
            Enabled = False
            Flat = True
            Glyph.Data = {
              DE010000424DDE01000000000000760000002800000024000000120000000100
              0400000000006801000000000000000000001000000010000000000000000000
              80000080000000808000800000008000800080800000C0C0C000808080000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00344446333334
              44433333FFFF333333FFFF33000033AAA43333332A4333338833F33333883F33
              00003332A46333332A4333333383F33333383F3300003332A2433336A6633333
              33833F333383F33300003333AA463362A433333333383F333833F33300003333
              6AA4462A46333333333833FF833F33330000333332AA22246333333333338333
              33F3333300003333336AAA22646333333333383333F8FF33000033444466AA43
              6A43333338FFF8833F383F330000336AA246A2436A43333338833F833F383F33
              000033336A24AA442A433333333833F33FF83F330000333333A2AA2AA4333333
              333383333333F3330000333333322AAA4333333333333833333F333300003333
              333322A4333333333333338333F333330000333333344A433333333333333338
              3F333333000033333336A24333333333333333833F333333000033333336AA43
              33333333333333833F3333330000333333336663333333333333333888333333
              0000}
            NumGlyphs = 2
            ParentShowHint = False
            ShowHint = True
            OnClick = bSkipClick
          end
          object bAnswer: TSpeedButton
            Left = 123
            Top = 4
            Width = 32
            Height = 32
            Hint = 'Answer call'
            Enabled = False
            Flat = True
            Glyph.Data = {
              76010000424D7601000000000000760000002800000020000000100000000100
              0400000000000001000000000000000000001000000010000000000000000000
              800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333303333
              333333333337FF3333333333330003333333333333777F333333333333080333
              3333333F33777FF33F3333B33B000B33B3333373F777773F7333333BBB0B0BBB
              33333337737F7F77F333333BBB0F0BBB33333337337373F73F3333BBB0F7F0BB
              B333337F3737F73F7F3333BB0FB7BF0BB3333F737F37F37F73FFBBBB0BF7FB0B
              BBB3773F7F37337F377333BB0FBFBF0BB333337F73F333737F3333BBB0FBF0BB
              B3333373F73FF7337333333BBB000BBB33333337FF777337F333333BBBBBBBBB
              3333333773FF3F773F3333B33BBBBB33B33333733773773373333333333B3333
              333333333337F33333333333333B333333333333333733333333}
            NumGlyphs = 2
            ParentShowHint = False
            ShowHint = True
            OnClick = bAnswerClick
          end
          object bKillBWZ: TSpeedButton
            Left = 161
            Top = 4
            Width = 32
            Height = 32
            Hint = 'Delete BWZ line'
            Enabled = False
            Flat = True
            Glyph.Data = {
              76010000424D7601000000000000760000002800000020000000100000000100
              0400000000000001000000000000000000001000000000000000000000000000
              8000008000000080800080000000800080008080000080808000C0C0C0000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
              333333333333333FF8F33333333333003033333333FFFF7787333333300000FF
              0333333FF77777FF733333000FFF444033333F77788877778F33730FFFF4FFFF
              03337F7F888788FF78F3130FFF4FF444F0337F78F87FF77787331180F4714FFF
              033377F787777888733371780717FFF03333777F777788F78F338117011FF44F
              033337777778877878F3871111FF4FFFF033377777F878888733871110F4FFFF
              0333377777F788FF73337111170FF44033337777777FF777FF33117311704FF0
              0333777377777F8778F3333331170FFFF033333337777FFFF733333333117000
              0333333333777777733333333333333333333333333333333333}
            NumGlyphs = 2
            ParentShowHint = False
            ShowHint = True
            OnClick = bbDeleteClick
          end
          object bChat: TSpeedButton
            Left = 199
            Top = 4
            Width = 32
            Height = 32
            Hint = 'Open Chat'
            Enabled = False
            Flat = True
            Glyph.Data = {
              CE070000424DCE07000000000000360000002800000024000000120000000100
              1800000000009807000000000000000000000000000000000000FFEFE1FFEFE1
              FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1DFE1
              E5FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FF
              EFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1
              FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1BDB1A78179
              7261879928D2FA2FE7FF28EDFF1FECFF33DCFDA8DDF0FFEFE1FFEFE1FFEFE1FF
              EFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1
              FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEF
              E1FFEFE18FC98700B01A05AE6306E4FF1EF5FF66F8FF50F7FF3AF6FF2FF5FF20
              E8FFA8DCF0FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1A3B1B4A3B1B4
              A3B1B4A3B1B4A3B1B4A3B1B4A3B1B4A3B1B4FFEFE1FFEFE1FFEFE1FFEFE1FFEF
              E1FFEFE1FFEFE1CDC0B4827A73857D7540A74C00D32D01D3EC15F4FF7BCBFF5F
              ABFF57BBFF489BFF3FD7FF38F6FF33DAFEFFEFE1FFEFE1FFEFE1FFEFE1FFEFE1
              FFEFE1A3B1B4A3B1B4A3B1B4A3B1B4A3B1B4A3B1B4A3B1B4A3B1B4A3B1B4A3B1
              B4FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1A8D5A20AAC3406B834449A4D309A3F00
              D6351CEAFFADFBFF8DBDFFA6FBFF94FAFF74F9FF3AB9FF3BF6FF23ECFFFFEFE1
              FFEFE1FFEFE1A3B1B4A3B1B4A3B1B4A3B1B4A3B1B4A3B1B4A3B1B4A3B1B4A3B1
              B4A3B1B4A3B1B4A3B1B4A3B1B4FFEFE1FFEFE1FFEFE1FFEFE1FFEFE113B94400
              E45600E25000C93B1A912900D23800E9FFC9FCFFD8FDFFC1FCFFAFFBFF8CFAFF
              62F8FF4EF7FF21ECFFFFEFE1FFEFE1FFEFE1A3B1B4A3B1B4A3B1B4A3B1B4A3B1
              B4A3B1B4A3B1B4A3B1B4A3B1B4A3B1B4A3B1B4A3B1B4A3B1B4FFEFE1FFEFE1FF
              EFE1FFEFE1FFEFE113BB4800E85E00E55700E25000BB3300B53434E9FFD2FDFF
              F6FFFF000000C4FCFF00000073F8FF45F6FF00E7FFFFEFE1FFEFE1FFEFE1A3B1
              B4A3B1B4A3B1B4A3B1B4A3B1B4A3B1B4A3B1B4A3B1B4A3B1B4A3B1B4A3B1B4A3
              B1B4A3B1B4FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1A8D6A521B14800D85200E558
              00D05A009C9A0FD1F950F7FFFAFFFFF2FEFFD1FDFFADFBFF8AF9FF4FF7FF24CC
              F6FFEFE1FFEFE1FFEFE1A3B1B4A3B1B4A3B1B4A3B1B4A3B1B4A3B1B4A3B1B4A3
              B1B4A3B1B4A3B1B4A3B1B4A3B1B4A3B1B4FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1
              C1CBB1368A4513A03700B135009C8A00EBEA00F5FF28E0FF51F7FFB3FBFFAFFB
              FF5EF7FF4EF7FF14E6FE87AAB7FFEFE1FFEFE1FFEFE1A3B1B4A3B1B4A3B1B4A3
              B1B4A3B1B4A3B1B4A3B1B4A3B1B4A3B1B4A3B1B4A3B1B4A3B1B4A3B1B4FFEFE1
              FFEFE1FFEFE1FFEFE1C3DFBA07BE4E00F17300EE6D00EB66009F9800FFFF00FF
              FF00F5FF20D5FB75EBFE94F6FF57EFFF2ED6EC4BB193FFEFE1FFEFE1FFEFE1A3
              B1B4A3B1B4A3B1B4A3B1B4A3B1B4A3B1B4A3B1B4A3B1B4A3B1B4A3B1B4A3B1B4
              A3B1B4A3B1B4FFEFE1FFEFE1FFEFE1FFEFE1FFEFE18FD09800EE7900F47B00F1
              7400E66600A57C00C7C700FFFF00FFFF00A6A500A632089820349D42528150CD
              C0B4FFEFE1FFEFE1FFEFE1A3B1B4A3B1B4A3B1B4A3B1B4A3B1B4A3B1B4A3B1B4
              A3B1B4A3B1B4A3B1B4A3B1B4A3B1B4A3B1B4FFEFE1FFEFE1FFEFE1FFEFE1FFEF
              E1FFEFE13BC26A2FD27300AF3D00BF4900E76800A37E00A5A200A19C00C37100
              E14D00D7430BA529699865857D75DCCFC2FFEFE1FFEFE1FFEFE1A3B1B4A3B1B4
              A3B1B4A3B1B4A3B1B4A3B1B4A3B1B4A3B1B4A3B1B4A3B1B4A3B1B4A3B1B4A3B1
              B4FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE135B95F00EE7B00F57D00EA6F00
              9C2900EC6900C14300C03E00E45500E14F00DE4806B62F7A9872BDB1A7FFEFE1
              FFEFE1FFEFE1FFEFE1A3B1B4A3B1B4A3B1B4A3B1B4A3B1B4A3B1B4A3B1B4A3B1
              B4A3B1B4A3B1B4A3B1B4A3B1B4FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE100
              D86D00FA8A00EF7C20A3480AC85600EF7000ED6912912A00D04B00E45600E14F
              00DF4947874BEEDED1FFEFE1FFEFE1FFEFE1FFEFE1A3B1B4A3B1B4FFEFE1A3B1
              B4A3B1B4A3B1B4A3B1B4A3B1B4A3B1B4A3B1B4FFEFE1FFEFE1FFEFE1FFEFE1FF
              EFE1FFEFE1FFEFE1FFEFE145C3712FD67C4FC171FFEFE100D25E00F27700F071
              3BAB5C49A35B0AC04500DC5114A936E0E6CAFFEFE1FFEFE1FFEFE1FFEFE1FFEF
              E1FFEFE1FFEFE1FFEFE1A3B1B4A3B1B4A3B1B4A3B1B4A3B1B4FFEFE1A3B1B4FF
              EFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1
              FFEFE100D56400F57E00F3782EA053BDB1A7E0E7CB8FCC90FFEFE1FFEFE1FFEF
              E1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1A3B1B4A3B1B4A3B1B4A3
              B1B4FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1
              FFEFE1FFEFE1FFEFE1FFEFE1FFEFE145C26E00CC5C00C24F8FCF95FFEFE1FFEF
              E1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FF
              EFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1
              FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEF
              E1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FF
              EFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1
              FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1FFEFE1}
            NumGlyphs = 2
            ParentShowHint = False
            ShowHint = True
            OnClick = bChatClick
          end
          object LampsPanelCarrier: TTransPan
            Left = 552
            Top = 0
            Width = 165
            Height = 40
            Align = alRight
            BevelOuter = bvNone
            BorderWidth = 3
            ParentBackground = False
            TabOrder = 0
            object LampsPanel: TTransPan
              Left = 3
              Top = 3
              Width = 159
              Height = 34
              Align = alClient
              BevelOuter = bvLowered
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Small Fonts'
              Font.Style = []
              ParentBackground = False
              ParentFont = False
              TabOrder = 0
              Visible = False
              object mlRXD: TModemLamp
                Left = 133
                Top = 5
                Kind = mlkBlue
              end
              object lRXD: TLabel
                Left = 127
                Top = 16
                Width = 20
                Height = 11
                Caption = 'RXD'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -9
                Font.Name = 'Small Fonts'
                Font.Style = []
                ParentFont = False
              end
              object mlTXD: TModemLamp
                Left = 103
                Top = 5
                Kind = mlkBlue
              end
              object lTXD: TLabel
                Left = 97
                Top = 16
                Width = 19
                Height = 11
                Caption = 'TXD'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -9
                Font.Name = 'Small Fonts'
                Font.Style = []
                ParentFont = False
              end
              object mlCTS: TModemLamp
                Left = 74
                Top = 5
              end
              object lCTS: TLabel
                Left = 69
                Top = 16
                Width = 19
                Height = 11
                Caption = 'CTS'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -9
                Font.Name = 'Small Fonts'
                Font.Style = []
                ParentFont = False
              end
              object lDSR: TLabel
                Left = 39
                Top = 16
                Width = 20
                Height = 11
                Caption = 'DSR'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -9
                Font.Name = 'Small Fonts'
                Font.Style = []
                ParentFont = False
              end
              object mlDSR: TModemLamp
                Left = 44
                Top = 5
              end
              object mlDCD: TModemLamp
                Left = 15
                Top = 5
                Kind = mlkRed
              end
              object lDCD: TLabel
                Left = 9
                Top = 16
                Width = 21
                Height = 11
                Caption = 'DCD'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -9
                Font.Name = 'Small Fonts'
                Font.Style = []
                ParentFont = False
              end
            end
          end
        end
        object DaemonBtnPanel: TTransPan
          Left = 0
          Top = 0
          Width = 717
          Height = 40
          Align = alClient
          BevelOuter = bvNone
          ParentBackground = False
          TabOrder = 2
          Visible = False
          object RasBtnPan: TTransPan
            Left = 505
            Top = 0
            Width = 212
            Height = 40
            Align = alRight
            BevelOuter = bvNone
            ParentBackground = False
            TabOrder = 0
            object CancelButton: TButton
              Left = 108
              Top = 9
              Width = 100
              Height = 25
              Cancel = True
              Caption = 'Cancel'
              TabOrder = 0
              OnClick = CancelButtonClick
            end
            object ConnectButton: TButton
              Left = 0
              Top = 9
              Width = 100
              Height = 25
              Caption = 'Connect'
              Default = True
              TabOrder = 1
              OnClick = ConnectButtonClick
            end
          end
          object RasLabelPan: TTransPan
            Left = 0
            Top = 0
            Width = 505
            Height = 40
            Align = alClient
            BevelOuter = bvNone
            ParentBackground = False
            TabOrder = 1
            DesignSize = (
              505
              40)
            object lStatus2: TLabel
              Left = 33
              Top = 14
              Width = 148
              Height = 16
              Caption = 'Connected to Corex VPN'
            end
            object lTimeCon: TLabel
              Left = 491
              Top = 14
              Width = 57
              Height = 16
              Anchors = [akTop, akRight]
              Caption = '11:11:11'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ParentFont = False
            end
          end
        end
        object PollBtnPanel: TTransPan
          Left = 0
          Top = 0
          Width = 717
          Height = 40
          Align = alClient
          BevelOuter = bvNone
          ParentBackground = False
          TabOrder = 1
          Visible = False
          object bDeleteAllPolls: TSpeedButton
            Left = 161
            Top = 4
            Width = 31
            Height = 32
            Hint = 'Delete all Polls'
            Enabled = False
            Flat = True
            Glyph.Data = {
              DE010000424DDE01000000000000760000002800000024000000120000000100
              0400000000006801000000000000000000001000000010000000000000000000
              8000008000000080800080000000800080008080000080808000C0C0C0000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333337733333
              333333333333F3333333333300003333911733333973333333377F333333F333
              000033369111733391173333337F37F333F77F33000033919111173911117333
              337F337F3F7337F30000339119111171111173337F7F3337F733337F00003391
              11911111111733337F37F33373333F730000333911191111117333337F337F33
              3333F73300003333911111111733333337F337F3333373330000333339119111
              17333333337F337F333733330000333333191111173333333337F3733337F333
              000033333391117111733333333377333337F333000033333911171911173333
              333373337F337F330000333399117111911173333337F33737F337F300003339
              11913911191113333377FF7F337F337F00003339116333911191933337F37737
              F337FFF700003333913333391113333337FF73337F3377730000333333333333
              919333333377333337FFF3330000333333333333333333333333333333777333
              0000}
            NumGlyphs = 2
            ParentShowHint = False
            ShowHint = True
            OnClick = bDeleteAllPollsClick
          end
          object bResetPoll: TSpeedButton
            Left = 85
            Top = 4
            Width = 31
            Height = 32
            Hint = 'Reset Poll'
            Enabled = False
            Flat = True
            Glyph.Data = {
              DE010000424DDE01000000000000760000002800000024000000120000000100
              0400000000006801000000000000000000001000000010000000000000000000
              80000080000000808000800000008000800080800000C0C0C000808080000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333444444
              33333333333F8888883F33330000324334222222443333388F3833333388F333
              000032244222222222433338F8833FFFFF338F3300003222222AAAAA22243338
              F333F88888F338F30000322222A33333A2224338F33F8333338F338F00003222
              223333333A224338F33833333338F38F00003222222333333A444338FFFF8F33
              3338888300003AAAAAAA33333333333888888833333333330000333333333333
              333333333333333333FFFFFF000033333333333344444433FFFF333333888888
              00003A444333333A22222438888F333338F3333800003A2243333333A2222438
              F38F333333833338000033A224333334422224338338FFFFF8833338000033A2
              22444442222224338F3388888333FF380000333A2222222222AA243338FF3333
              33FF88F800003333AA222222AA33A3333388FFFFFF8833830000333333AAAAAA
              3333333333338888883333330000333333333333333333333333333333333333
              0000}
            NumGlyphs = 2
            ParentShowHint = False
            ShowHint = True
            OnClick = bResetPollClick
          end
          object bDeletePoll: TSpeedButton
            Left = 47
            Top = 4
            Width = 31
            Height = 32
            Hint = 'Delete Poll'
            Enabled = False
            Flat = True
            Glyph.Data = {
              DE010000424DDE01000000000000760000002800000024000000120000000100
              0400000000006801000000000000000000001000000010000000000000000000
              8000008000000080800080000000800080008080000080808000C0C0C0000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
              333333333333333333333333000033337733333333333333333F333333333333
              0000333D55733333D73333333377F333333F33330000333D5557333D55733333
              37F37F333F77F3330000333D555573D55557333337F337F3F7337F3300003333
              D55557555557333337F3337F733337F3000033333D55555555733333337F3337
              3333F7330000333333D55555573333333337F333333F73330000333333355555
              7333333333337F333337333300003333333D555573333333333337F333733333
              0000333333D555557333333333333733337F3333000033333D55575557333333
              33337333337F333300003333D55573D55573333333373337F337F33300003333
              D557333D55573333337F33737F337F33000033333D533333D5553333337FF733
              37F337F300003333333333333D5D333333377333337FFF730000333333333333
              3333333333333333333777330000333333333333333333333333333333333333
              0000}
            NumGlyphs = 2
            ParentShowHint = False
            ShowHint = True
            OnClick = bDeletePollClick
          end
          object bNewPoll: TSpeedButton
            Left = 9
            Top = 4
            Width = 30
            Height = 32
            Hint = 'Create Poll'
            Flat = True
            Glyph.Data = {
              36060000424D3606000000000000360000002800000020000000100000000100
              1800000000000006000000000000000000000000000000000000FF00FFFF00FF
              FF00FF8000008000008000008000008000008000008000008000008000008000
              00800000FF00FFFF00FFFF00FFFF00FFFF00FF99A8AC99A8AC99A8AC99A8AC99
              A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99A8ACFF00FFFF00FF0000FFFF00FF
              FF00FF800000FFFF00FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF00
              00800000FF00FFFF00FF99A8ACFF00FFFF00FF99A8AC99A8AC99A8AC99A8AC99
              A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99A8ACFF00FFFF00FFFF00FFFF0000
              FF0000800000FFFF00C0C0C00000FFC0C0C00000FFC0C0C00000FFC0C0C0FF00
              00800000FF00FF0000FFFF00FF99A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99
              A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99A8ACFF00FF99A8ACFF0000FF00FF
              0000FF800000FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00
              008000000000FF0000FF99A8ACFF00FF99A8AC99A8AC99A8AC99A8AC99A8AC99
              A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99A8ACFF0000FF00FF
              0000FF0000FF800000FFFF00C0C0C00000FFC0C0C00000FFC0C0C0FFFF008000
              000000FF0000FFFF00FF99A8ACFF00FF99A8AC99A8AC99A8AC99A8AC99A8AC99
              A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99A8ACFF00FFFF0000FF00FF
              FF00FF0000FF0000FF800000FFFF00FFFF00FFFF00FFFF00FFFF008000000000
              FF0000FFFF00FFFF00FF99A8ACFF00FFFF00FF99A8AC99A8AC99A8AC99A8AC99
              A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99A8ACFF00FFFF00FFFF00FF800000
              FF0000FF00000000FF8000008000008000008000008000008000008000000000
              FFFF00FFFF00FFFF00FFFF00FF99A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99
              A8AC99A8AC99A8AC99A8AC99A8AC99A8ACFF00FFFF00FFFF00FFFF00FF800000
              FF0000FF0000FF0000800000FF00FF0000FF0000FFFF00FFFF00FF800000FF00
              FFFF00FFFF00FFFF00FFFF00FF99A8AC99A8AC99A8AC99A8AC99A8ACFF00FF99
              A8AC99A8ACFF00FFFF00FF99A8ACFF00FFFF00FFFF00FFFF00FFFF00FF800000
              FF0000FF0000FF0000800000C0C0C0FF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FF99A8AC99A8AC99A8AC99A8AC99A8AC99A8ACFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF800000
              FFFF00FFFF00FF0000FF0000FF00000000FF0000FFFF00FF800000FF00008000
              00800000FF00FFFF00FFFF00FF99A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99
              A8AC99A8ACFF00FF99A8AC99A8AC99A8AC99A8ACFF00FFFF00FFFF00FFFF00FF
              FF0000FFFF00FFFF00FFFF00FF0000800000800000FF0000800000FF0000FF00
              00FF0000800000FF00FFFF00FFFF00FF99A8AC99A8AC99A8AC99A8AC99A8AC99
              A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99A8ACFF00FFFF00FFFF00FF
              FF00FF800000800000800000FFFF00FFFF00FFFF00FFFF00FF0000FFFF00FFFF
              00FFFF00800000FF00FFFF00FFFF00FFFF00FF99A8AC99A8AC99A8AC99A8AC99
              A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99A8ACFF00FFFF00FFFF00FF
              FF00FF0000FF0000FF808080FF0000800000800000FF0000FFFF00FFFF00FF00
              00FF0000FF00FFFF00FFFF00FFFF00FFFF00FF99A8AC99A8AC99A8AC99A8AC99
              A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99A8ACFF00FFFF00FFFF00FFFF00FF
              0000FF0000FFFF00FFFF00FFFF00FF0000FF0000FF808080800000FF0000FF00
              000000FFFF00FFFF00FFFF00FFFF00FF99A8AC99A8ACFF00FFFF00FFFF00FF99
              A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99A8ACFF00FFFF00FFFF00FF0000FF
              0000FFFF00FFFF00FFFF00FFFF00FF0000FF0000FFFF00FFFF00FFFF00FFFF00
              FF0000FF0000FFFF00FFFF00FF99A8AC99A8ACFF00FFFF00FFFF00FFFF00FF99
              A8AC99A8ACFF00FFFF00FFFF00FFFF00FF99A8AC99A8ACFF00FFFF00FF0000FF
              FF00FFFF00FFFF00FFFF00FFFF00FF0000FF0000FFFF00FFFF00FFFF00FFFF00
              FFFF00FF0000FFFF00FFFF00FF99A8ACFF00FFFF00FFFF00FFFF00FFFF00FF99
              A8AC99A8ACFF00FFFF00FFFF00FFFF00FFFF00FF99A8ACFF00FF}
            NumGlyphs = 2
            ParentShowHint = False
            ShowHint = True
            OnClick = bNewPollClick
          end
          object bTracePoll: TSpeedButton
            Left = 123
            Top = 4
            Width = 31
            Height = 32
            Hint = 'Poll Info'
            Enabled = False
            Flat = True
            Glyph.Data = {
              6E020000424D6E0200000000000076000000280000002A000000150000000100
              040000000000F801000000000000000000001000000010000000000000000000
              8000008000000080800080000000800080008080000080808000C0C0C0000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
              8888888888888888888888888888880000008888888888888888888888888888
              8888888888888800000088888888888888888888888888888888888888888800
              0000888888887444788888888888888888FFF888888888000000888888874444
              478888888888888888777F888888880000008888888444784488888888888888
              878877F888888800000088888884447887888888888888888788F77F88888800
              000088888887444888888888888888888788F888888888000000888888887447
              888888888888888888787F888888880000008888888874447888888888888888
              88787F888888880000008888888887447888888888888888888787F888888800
              000088888888884447888888888888888F88787F888888000000888888878874
              448888888888888887F8787F8888880000008888888448744488888888888888
              877F787F88888800000088888887444447888888888888888877777F88888800
              00008888888874447888888888888888888777F8888888000000888888888888
              8888888888888888888FF8888888880000008888888887447888888888888888
              88877F888888880000008888888884444888888888888888887887F888888800
              00008888888884444888888888888888887887F8888888000000888888888744
              788888888888888888877F88888888000000}
            NumGlyphs = 2
            ParentShowHint = False
            ShowHint = True
            OnClick = bTracePollClick
          end
          object bPause: TSpeedButton
            Left = 198
            Top = 4
            Width = 31
            Height = 32
            Hint = 'Pause Poll'
            Enabled = False
            Flat = True
            Glyph.Data = {
              DE010000424DDE01000000000000760000002800000024000000120000000100
              0400000000006801000000000000000000001000000000000000000000000000
              8000008000000080800080000000800080008080000080808000C0C0C0000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
              3333333333333333333333330000333333444444333333333333FFFFFF333333
              00003333444444444433333333FF777777FF3333000033344444444444433333
              3F7733333377F333000033444444444444443333F733333333333F7300003344
              4444444444443333F733333333333F730000344444EE44EE4444433F7333FF33
              FF3333F70000344444EE44EE4444433F7333FF73FF7333F70000344444EE44EE
              4444433F7333FF73FF7333F70000344444EE44EE4444433F7333FF73FF7333F7
              0000344444EE44EE4444433F7333FF73FF7333F70000344444EE44EE4444433F
              7333FF73FF7333F7000033444444444444443333F333777377733F7300003344
              4444444444443333F333333333333F730000333444444444444333333F333333
              3333F73300003333444444444433333333F3333333FF73330000333333444444
              33333333333FFFFFFF7733330000333333333333333333333333777777333333
              0000}
            NumGlyphs = 2
            ParentShowHint = False
            ShowHint = True
            OnClick = mpPauseClick
          end
          object lInfo1: TLabel
            Left = 357
            Top = 0
            Width = 360
            Height = 40
            Align = alRight
            Caption = 'Last in: -:---/---@-------- --/--/-- 00:00:00'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Fixedsys'
            Font.Style = []
            ParentFont = False
            Layout = tlCenter
          end
        end
        object OutMgrBtnPanel: TTransPan
          Left = 0
          Top = 0
          Width = 717
          Height = 40
          Align = alClient
          BevelOuter = bvNone
          ParentBackground = False
          TabOrder = 3
          Visible = False
          object bReread: TSpeedButton
            Left = 9
            Top = 4
            Width = 32
            Height = 32
            Hint = 'Rescan'
            Enabled = False
            Flat = True
            Glyph.Data = {
              DE010000424DDE01000000000000760000002800000024000000120000000100
              0400000000006801000000000000000000001000000010000000000000000000
              80000080000000808000800000008000800080800000C0C0C000808080000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333444444
              33333333333F8888883F33330000324334222222443333388F3833333388F333
              000032244222222222433338F8833FFFFF338F3300003222222AAAAA22243338
              F333F88888F338F30000322222A33333A2224338F33F8333338F338F00003222
              223333333A224338F33833333338F38F00003222222333333A444338FFFF8F33
              3338888300003AAAAAAA33333333333888888833333333330000333333333333
              333333333333333333FFFFFF000033333333333344444433FFFF333333888888
              00003A444333333A22222438888F333338F3333800003A2243333333A2222438
              F38F333333833338000033A224333334422224338338FFFFF8833338000033A2
              22444442222224338F3388888333FF380000333A2222222222AA243338FF3333
              33FF88F800003333AA222222AA33A3333388FFFFFF8833830000333333AAAAAA
              3333333333338888883333330000333333333333333333333333333333333333
              0000}
            NumGlyphs = 2
            ParentShowHint = False
            ShowHint = True
            OnClick = bRereadClick
          end
          object llTotalAtInbound: TLabel
            Left = 102
            Top = 2
            Width = 99
            Height = 16
            Alignment = taRightJustify
            Caption = 'Total at inbound:'
          end
          object llAvaibleAtInbound: TLabel
            Left = 87
            Top = 21
            Width = 114
            Height = 16
            Alignment = taRightJustify
            Caption = 'Avaible at inbound:'
          end
          object lTotalAtInbound: TLabel
            Left = 204
            Top = 2
            Width = 30
            Height = 16
            Caption = '0 Mb'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lAvaibleAtInbound: TLabel
            Left = 204
            Top = 21
            Width = 30
            Height = 16
            Caption = '0 Mb'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lOutboundSize: TLabel
            Left = 411
            Top = 2
            Width = 30
            Height = 16
            Caption = '0 Mb'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object llOutboundSize: TLabel
            Left = 319
            Top = 2
            Width = 88
            Height = 16
            Alignment = taRightJustify
            Caption = 'Outbound size:'
          end
        end
      end
      object OutMgrPanel: TTransPan
        Left = 0
        Top = 0
        Width = 676
        Height = 31
        BevelOuter = bvNone
        ParentBackground = False
        TabOrder = 2
        Visible = False
        object OutMgrBevel: TBevel
          Left = 0
          Top = 28
          Width = 676
          Height = 3
          Align = alBottom
          Shape = bsBottomLine
        end
        object OutMgrOutline: TxOutlin
          Left = 0
          Top = 21
          Width = 676
          Height = 7
          FileNameCol = 0
          FixedFont.Charset = DEFAULT_CHARSET
          FixedFont.Color = clWindowText
          FixedFont.Height = -13
          FixedFont.Name = 'MS Sans Serif'
          FixedFont.Style = []
          OutlineStyle = osText
          Options = []
          Style = otOwnerDraw
          ItemHeight = 16
          OnDrawItem = OutMgrOutlineDrawItem
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          TabOrder = 1
          OnMouseDown = OutMgrOutlineMouseDown
          OnDblClick = OutMgrOutlineDblClick
          OnKeyDown = OutMgrOutlineKeyDown
          BorderStyle = bsNone
          ItemSeparator = '\'
          ParentFont = False
          PopupMenu = OutMgrPopup
          EraseBackGround = True
          OnApiDropFiles = OutMgrOutlineApiDropFiles
          Data = {1F}
        end
        object OutMgrHeader: THeaderControl
          Left = 0
          Top = 0
          Width = 676
          Height = 21
          HotTrack = True
          Sections = <
            item
              ImageIndex = -1
              Text = 'Outbound'
              Width = 180
            end
            item
              ImageIndex = -1
              Text = 'Sysop Name'
              Width = 200
            end
            item
              Alignment = taRightJustify
              ImageIndex = -1
              Text = 'Size'
              Width = 100
            end
            item
              ImageIndex = -1
              Text = 'Type'
              Width = 60
            end
            item
              ImageIndex = -1
              Text = 'On sent'
              Width = 60
            end
            item
              ImageIndex = -1
              Text = 'Age'
              Width = 80
            end>
          OnSectionClick = OutMgrHeaderSectionClick
          OnSectionResize = OutMgrHeaderSectionResize
        end
      end
    end
  end
  object MainMenu: TMainMenu
    Images = ilMainMenu
    OwnerDraw = True
    Left = 458
    Top = 290
    object mSystem: TMenuItem
      Caption = '&System'
      HelpContext = 1560
      object mwCreateMirror: TMenuItem
        Caption = '&Mirror '
        ImageIndex = 0
        ShortCut = 115
        OnClick = mwCreateMirrorClick
      end
      object mwRemoteMirror: TMenuItem
        Caption = 'Mirror (remote)'
        Enabled = False
        Visible = False
        OnClick = mwRemoteMirrorClick
      end
      object mwClose: TMenuItem
        Caption = '&Close Window'
        ImageIndex = 1
        ShortCut = 32883
        OnClick = mwCloseClick
      end
      object N26: TMenuItem
        Caption = '-'
      end
      object mfRestart: TMenuItem
        Caption = 'Restart'
        ImageIndex = 2
        OnClick = mfRestartClick
      end
      object N17: TMenuItem
        Caption = '-'
      end
      object mfExit: TMenuItem
        Caption = 'E&xit'
        ImageIndex = 3
        ShortCut = 32856
        OnClick = mfExitClick
      end
    end
    object mLine: TMenuItem
      Caption = '&Line'
      HelpContext = 1540
      object msOpenDialup: TMenuItem
        Caption = 'Open Dial-up Line'
      end
      object mfRunIPDaemon: TMenuItem
        Caption = 'TCP/IP Daemon'
        Enabled = False
        ShortCut = 32816
        OnClick = mfRunIPDaemonClick
      end
      object mnuTerminal: TMenuItem
        Caption = 'Terminal'
        Enabled = False
        OnClick = mnuTerminalClick
      end
      object N13: TMenuItem
        Caption = '-'
      end
      object mlAbortOperation: TMenuItem
        Caption = '&Reset'
        Enabled = False
        ImageIndex = 4
        ShortCut = 27
        OnClick = bAbortClick
      end
      object mlAnswer: TMenuItem
        Caption = '&Answer Call'
        Enabled = False
        ImageIndex = 5
        ShortCut = 16449
        OnClick = bAnswerClick
      end
      object mlSendMdmCmds: TMenuItem
        Caption = 'Send &Modem Commands'
        Enabled = False
        ImageIndex = 6
        ShortCut = 120
        OnClick = mlSendMdmCmdsClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object mlResetTimeOut: TMenuItem
        Caption = '&Flush Timeout'
        Enabled = False
        ImageIndex = 7
        ShortCut = 16418
        OnClick = bStartClick
      end
      object mlIncTimeout: TMenuItem
        Caption = 'Add to &Timeout'
        Enabled = False
        ImageIndex = 8
        ShortCut = 16417
        OnClick = bAddClick
      end
      object N12: TMenuItem
        Caption = '-'
      end
      object mlSkip: TMenuItem
        Caption = 'Skip File (receive &later)'
        Enabled = False
        ImageIndex = 9
        ShortCut = 16460
        OnClick = bSkipClick
      end
      object mlRefuse: TMenuItem
        Caption = '&Reject File'
        Enabled = False
        ImageIndex = 10
        ShortCut = 16466
        OnClick = bRefuseClick
      end
      object mlChat: TMenuItem
        Caption = 'Open Chat'
        Enabled = False
        ImageIndex = 11
        ShortCut = 49219
        OnClick = bChatClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object mlClose: TMenuItem
        Caption = '&Close'
        Enabled = False
        ImageIndex = 12
        ShortCut = 16498
        OnClick = mlCloseClick
      end
    end
    object mPoll: TMenuItem
      Caption = '&Poll'
      HelpContext = 1550
      object mpCreate: TMenuItem
        Caption = '&Create Crash Poll'
        ImageIndex = 13
        ShortCut = 116
        OnClick = bNewPollClick
      end
      object mpNormalPoll: TMenuItem
        Caption = 'Create &Normal Poll'
        ImageIndex = 14
        ShortCut = 57460
        OnClick = tpCreateNormalPollClick
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object mpPause: TMenuItem
        Caption = '&Pause'
        Enabled = False
        ImageIndex = 15
        ShortCut = 190
        OnClick = mpPauseClick
      end
      object mnuNow2: TMenuItem
        Caption = 'Call Now'
        Visible = False
      end
      object mpTrace: TMenuItem
        Caption = '&Info'
        Enabled = False
        ImageIndex = 16
        ShortCut = 8308
        OnClick = bTracePollClick
      end
      object mpReset: TMenuItem
        Caption = '&Reset'
        Enabled = False
        ImageIndex = 17
        ShortCut = 32884
        OnClick = bResetPollClick
      end
      object mpDelete: TMenuItem
        Caption = '&Delete'
        Enabled = False
        ImageIndex = 18
        ShortCut = 16500
        OnClick = bDeletePollClick
      end
      object mpDeleteAll: TMenuItem
        Caption = 'Delete &All'
        Enabled = False
        ImageIndex = 19
        ShortCut = 24692
        OnClick = bDeleteAllPollsClick
      end
    end
    object mConfig: TMenuItem
      Caption = '&Config'
      HelpContext = 1520
      object mcMasterPassword: TMenuItem
        Caption = '&Master Password'
        ImageIndex = 20
        object mcMasterPwdCreate: TMenuItem
          Caption = 'Set Up...'
          Enabled = False
          ImageIndex = 21
          OnClick = mcMasterPwdCreateClick
        end
        object mcMasterPwdChange: TMenuItem
          Caption = 'Change...'
          Enabled = False
          ImageIndex = 22
          OnClick = mcMasterPwdChangeClick
        end
        object mcMasterPwdRemove: TMenuItem
          Caption = 'Remove...'
          Enabled = False
          ImageIndex = 23
          OnClick = mcMasterPwdRemoveClick
        end
      end
      object mcStartup: TMenuItem
        Caption = '&Start-up'
        HelpContext = 1040
        ImageIndex = 24
        ShortCut = 16467
        OnClick = mcStartupClick
      end
      object mcPathnames: TMenuItem
        Caption = '&Paths'
        ImageIndex = 25
        ShortCut = 49232
        OnClick = mcPathnamesClick
      end
      object mcNodelist: TMenuItem
        Caption = '&Nodelist'
        ImageIndex = 26
        ShortCut = 16462
        OnClick = mcNodelistClick
      end
      object mcPasswords: TMenuItem
        Caption = 'Pass&words'
        ImageIndex = 27
        ShortCut = 16471
        OnClick = NodesPasswords1Click
      end
      object mnuPrefEx: TMenuItem
        Caption = 'Extended Preferences...'
        ImageIndex = 28
        ShortCut = 16464
        OnClick = mnuPrefExClick
      end
      object N16: TMenuItem
        Caption = '-'
      end
      object mcDialup: TMenuItem
        Caption = '&Dial-up'
        ImageIndex = 29
        ShortCut = 16452
        OnClick = mcDialupClick
      end
      object mcDaemon: TMenuItem
        Caption = '&TCP/IP Daemon'
        ImageIndex = 30
        ShortCut = 16468
        OnClick = mcDaemonClick
      end
      object N15: TMenuItem
        Caption = '-'
      end
      object mcFileBoxes: TMenuItem
        Caption = 'File-&boxes'
        ImageIndex = 31
        ShortCut = 16450
        OnClick = mcFileBoxesClick
      end
      object mcPolls: TMenuItem
        Caption = 'P&olls'
        ImageIndex = 32
        ShortCut = 16463
        OnClick = mcPollsClick
      end
      object maFileRequests: TMenuItem
        Caption = '&File Requests'
        ImageIndex = 33
        ShortCut = 16454
        OnClick = maFileRequestsClick
      end
      object maExternals: TMenuItem
        Caption = 'E&xternals'
        ImageIndex = 34
        ShortCut = 16472
        OnClick = mcExternalsClick
      end
      object maEvents: TMenuItem
        Caption = 'E&vents'
        ImageIndex = 35
        ShortCut = 16470
        OnClick = maEventsClick
      end
      object maEncryptedLinks: TMenuItem
        Caption = '&Encrypted Links'
        ImageIndex = 36
        ShortCut = 16453
        OnClick = maEncryptedLinksClick
      end
      object N23: TMenuItem
        Caption = '-'
      end
      object maNodes: TMenuItem
        Caption = 'Node &Inspector'
        ImageIndex = 37
        ShortCut = 16457
        OnClick = maNodesClick
      end
    end
    object mTool: TMenuItem
      Caption = '&Tool'
      HelpContext = 1570
      object mtCompileNodelist: TMenuItem
        Caption = '&Compile Nodelist'
        ImageIndex = 48
        ShortCut = 8309
        OnClick = mtCompileNodelistClick
      end
      object mtCompileNodelistInv: TMenuItem
        Caption = '&Compile Nodelist'
        ShortCut = 32885
        Visible = False
      end
      object mtBrowseNodelist: TMenuItem
        Caption = '&Browse Nodelist'
        ImageIndex = 38
        ShortCut = 117
        OnClick = mtBrowseNodelistClick
      end
      object mtBrowseNodelistAt: TMenuItem
        Caption = 'Browse Nodelist at...'
        ImageIndex = 39
        ShortCut = 16501
        OnClick = mtBrowseNodelistAtClick
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object tExternal: TMenuItem
        Caption = 'External Tools'
        ImageIndex = 40
        object eaNone: TMenuItem
          Caption = '-none-'
          Enabled = False
        end
      end
      object N7: TMenuItem
        Caption = '-'
      end
      object mtEditFileRequest: TMenuItem
        Caption = 'Edit File &Request...'
        ImageIndex = 41
        ShortCut = 118
        OnClick = mtEditFileRequestClick
      end
      object mtAttachFiles: TMenuItem
        Caption = 'Attach Files...'
        ImageIndex = 42
        ShortCut = 119
        OnClick = mtAttachFilesClick
      end
      object mtCreateFlag: TMenuItem
        Caption = 'Create a Flag...'
        ImageIndex = 43
        ShortCut = 16503
        OnClick = mtCreateFlagClick
      end
      object mtOutSmartMenu: TMenuItem
        Caption = 'Outbound SmartMenu'
        Enabled = False
        ShortCut = 16416
        OnClick = mtOutSmartMenuClick
      end
      object N28: TMenuItem
        Caption = '-'
      end
      object mtViewLogs: TMenuItem
        Caption = 'View Logs'
        object LName: TMenuItem
          AutoHotkeys = maManual
          Caption = 'Access.log'
          OnClick = LNameClick
        end
      end
    end
    object mHelp: TMenuItem
      Caption = '&Help'
      HelpContext = 1530
      object mhContents: TMenuItem
        Caption = 'Help &Topics'
        ImageIndex = 44
        OnClick = mhContentsClick
      end
      object N9: TMenuItem
        Caption = '-'
      end
      object mnuWebSites: TMenuItem
        Caption = 'Web Sites'
        ImageIndex = 45
        object mhWebSite: TMenuItem
          Caption = 'Argus &Web Site (on-line)'
          OnClick = mhWebSiteClick
        end
        object mnuRadiusOnWeb: TMenuItem
          Caption = 'Taurus Web Site'
          OnClick = mnuRadiusOnWebClick
        end
        object mnuArgusClone: TMenuItem
          Caption = 'All Argus clones'
          OnClick = mnuArgusCloneClick
        end
      end
      object N8: TMenuItem
        Caption = '-'
      end
      object mhAbout: TMenuItem
        Caption = '&About'
        ImageIndex = 46
        ShortCut = 32880
        OnClick = mhAboutClick
      end
    end
  end
  object PollPopupMenu: TPopupMenu
    Images = ilMainMenu
    OwnerDraw = True
    OnPopup = PollPopupMenuPopup
    Left = 514
    Top = 290
    object ppCreatePoll: TMenuItem
      Caption = '&Create Crash Poll'
      ImageIndex = 13
      ShortCut = 116
      OnClick = bNewPollClick
    end
    object ppNormalPoll: TMenuItem
      Caption = 'Create &Normal Poll'
      ImageIndex = 14
      ShortCut = 57460
      OnClick = tpCreateNormalPollClick
    end
    object N11: TMenuItem
      Caption = '-'
    end
    object ppPause: TMenuItem
      Caption = '&Pause'
      Enabled = False
      ImageIndex = 15
      ShortCut = 190
      OnClick = mpPauseClick
    end
    object mnuNow: TMenuItem
      Caption = 'Call now'
      Enabled = False
      Visible = False
    end
    object ppTracePoll: TMenuItem
      Caption = '&Info'
      Enabled = False
      ImageIndex = 16
      ShortCut = 16500
      OnClick = bTracePollClick
    end
    object ppResetPoll: TMenuItem
      Caption = '&Reset'
      Enabled = False
      ImageIndex = 17
      ShortCut = 8308
      OnClick = bResetPollClick
    end
    object ppDeletePoll: TMenuItem
      Caption = '&Delete'
      Enabled = False
      ImageIndex = 18
      ShortCut = 32884
      OnClick = bDeletePollClick
    end
    object ppDeleteAllPolls: TMenuItem
      Caption = 'Delete &All'
      Enabled = False
      ImageIndex = 19
      ShortCut = 24692
      OnClick = bDeleteAllPollsClick
    end
  end
  object OutMgrPopup: TPopupMenu
    HelpContext = 2070
    Images = ilMainMenu
    OwnerDraw = True
    OnPopup = OutMgrPopupPopup
    Left = 342
    Top = 290
    object ompHelp: TMenuItem
      Caption = 'Help on SmartMenu'
      OnClick = ompHelpClick
    end
    object N25: TMenuItem
      Caption = '-'
    end
    object ompRescan: TMenuItem
      Caption = 'Rescan Outbound'
      ImageIndex = 17
      OnClick = bRereadClick
    end
    object N14: TMenuItem
      Caption = '-'
    end
    object ompPoll: TMenuItem
      Caption = 'Poll 2:469/38'
      ImageIndex = 14
      OnClick = ompPollClick
    end
    object ompAttach: TMenuItem
      Caption = 'Attach to 2:469/38'
      ImageIndex = 42
      OnClick = ompAttachClick
    end
    object ompEditFreq: TMenuItem
      Caption = 'Edit file request for 2:469/38'
      ImageIndex = 41
      OnClick = ompEditFreqClick
    end
    object ompBrowseNL: TMenuItem
      Caption = 'Browse nodelist at 2:469/38'
      ImageIndex = 38
      OnClick = ompBrowseNLClick
    end
    object ompCreateFlag: TMenuItem
      Caption = 'Create Flag for 2:469/38'
      ImageIndex = 43
      object ompCfImmed: TMenuItem
        Caption = 'Immediate'
        OnClick = ompCfImmedClick
      end
      object ompCfCrash: TMenuItem
        Caption = 'Crash'
        OnClick = ompCfCrashClick
      end
      object ompCfDirect: TMenuItem
        Caption = 'Direct'
        OnClick = ompCfDirectClick
      end
      object ompCfNormal: TMenuItem
        Caption = 'Normal'
        OnClick = ompCfNormalClick
      end
      object ompCfHold: TMenuItem
        Caption = 'Hold'
        OnClick = ompCfHoldClick
      end
      object ompCfPause: TMenuItem
        Caption = 'Pause'
        OnClick = ompCfPauseClick
      end
    end
    object N22: TMenuItem
      Caption = '-'
    end
    object ompOpen: TMenuItem
      Caption = 'Open Current File'
      OnClick = ompOpenClick
    end
    object ompCur: TMenuItem
      Tag = 1
      Caption = '000032e3.su2'
      object opmReaddress: TMenuItem
        Caption = 'Readdress'
        OnClick = opmReaddressClick
      end
      object opmFinalize: TMenuItem
        Caption = 'Finalise'
        OnClick = opmFinalizeClick
      end
      object N21: TMenuItem
        Caption = '-'
      end
      object opmImmed: TMenuItem
        Caption = 'Change to Immediate'
        OnClick = opmImmedClick
      end
      object opmCrash: TMenuItem
        Caption = 'Change to Crash'
        OnClick = opmCrashClick
      end
      object opmDirect: TMenuItem
        Caption = 'Change to Direct'
        OnClick = opmDirectClick
      end
      object opmNormal: TMenuItem
        Caption = 'Change to Normal'
        OnClick = opmNormalClick
      end
      object opmHold: TMenuItem
        Caption = 'Change to Hold'
        OnClick = opmHoldClick
      end
      object N19: TMenuItem
        Caption = '-'
      end
      object opmUnlink: TMenuItem
        Caption = 'Unlink'
        OnClick = opmUnlinkClick
      end
      object opmPurge: TMenuItem
        Caption = 'Remove Broken Links'
        OnClick = opmPurgeClick
      end
    end
    object N20: TMenuItem
      Caption = '-'
    end
    object ompName: TMenuItem
      Tag = 2
      Caption = '000032e3.* of 2:469/38'
    end
    object ompExt: TMenuItem
      Tag = 3
      Caption = '*.su?  of 2:469/38'
    end
    object ompStat: TMenuItem
      Tag = 4
      Caption = 'All Hold Files of 2:469/38'
      Enabled = False
    end
    object ompAll: TMenuItem
      Tag = 5
      Caption = 'All Entries of 2:469/38'
    end
    object N18: TMenuItem
      Caption = '-'
    end
    object ompEntire: TMenuItem
      Tag = 6
      Caption = 'Entire Outbound'
    end
  end
  object TrayPopupMenu: TPopupMenu
    Images = ilMainMenu
    OwnerDraw = True
    OnPopup = TrayPopupMenuPopup
    Left = 486
    Top = 290
    object tpRestore: TMenuItem
      Caption = '&Restore'
      OnClick = tpRestoreClick
    end
    object tpMinimize: TMenuItem
      Caption = '&Minimize'
      OnClick = TrayIconClick
    end
    object N27: TMenuItem
      Caption = '-'
    end
    object mnuLines: TMenuItem
      Caption = 'Lines'
    end
    object mnu_tray_TCP: TMenuItem
      Caption = 'TCP/IP Daemon'
      Enabled = False
      OnClick = mfRunIPDaemonClick
    end
    object N10: TMenuItem
      Caption = '-'
    end
    object tpCreatePoll: TMenuItem
      Caption = 'Create Crash &Poll'
      ImageIndex = 13
      OnClick = tpCreatePollClick
    end
    object tpCreateNormalPoll: TMenuItem
      Caption = 'Create &Normal Poll'
      ImageIndex = 14
      OnClick = tpCreateNormalPollClick
    end
    object N24: TMenuItem
      Caption = '-'
    end
    object tpEditFileRequest: TMenuItem
      Caption = 'Edit File Request'
      ImageIndex = 41
      OnClick = tpEditFileRequestClick
    end
    object tpBrowseNodelist: TMenuItem
      Caption = '&Browse Nodelist'
      ImageIndex = 38
      OnClick = tpBrowseNodelistClick
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object tpExit: TMenuItem
      Caption = 'E&xit'
      ImageIndex = 3
      OnClick = mfExitClick
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object tpCancel: TMenuItem
      Caption = 'Cancel'
    end
  end
  object pBWZ: TPopupMenu
    Images = ilMainMenu
    MenuAnimation = [maLeftToRight, maTopToBottom]
    OwnerDraw = True
    OnPopup = pBWZPopup
    Left = 391
    Top = 290
    object mnuDelBWZ: TMenuItem
      Caption = 'Delete %s from BadWazoo'
      Enabled = False
      ImageIndex = 47
      ShortCut = 46
      OnClick = bbDeleteClick
    end
    object mnuTossBwz: TMenuItem
      Caption = 'Toss badwazoo'
      OnClick = mnuTossBwzClick
    end
  end
  object ilMainMenu: TImageList
    Left = 545
    Top = 290
    Bitmap = {
      494C010131003600040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      000000000000360000002800000040000000E0000000010020000000000000E0
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000484848000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000928F8F00565351004C48470053504F00918F8F0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000918F8F005C58
      550048413F005646420054433F004B3D3900474242008E8C8C00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000008B8B8B00635D5B007C6D
      61006E5953006A524E00624D4800594642004B3D3A0047424200918F8E000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008A8A8A0056555500ADA5A1008F78
      71007C625C00745B56006C5853005B49440051413D0045393500534F4E000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004E4E4B00ADAA9A00B2A18F009074
      6C00836761007E67620080777500575351004D49480048454300535151000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000003939290085832F00AE9D7D00987A
      71008C6E6700876D680098919000C8C7C700D1D0D000C4C4C300979797000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000393929008B893700CDC3AC00A58A
      800093756D008E726C00918785009C9594009B959400908D8C00979696000000
      0000000000001F1F1F001F1F1F00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004E4E4B00AEAB9900BBAB8D00B199
      8500A5898000957770008E736C00846C67006F5D5A0058535200999898000000
      0000000000002424240024242400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008A8A8A004A4A3D007A752C00BCAB
      8F00D1C3BB00A3877F00876B6500775F5A00584F4D0094919000000000000000
      0000000000002222220031313100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000858582004A4A3C00B3AE
      A700AB9C8D008E7C6E00574D49005F5957009895940000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000008A8A8A004F4E
      4E003F3C3A00484543008B8A8A00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080008080800000000000000000000000000000000000000000000000
      C8005F5F5F0059A1A10063A5A50000151500000000000000000000000E000000
      DF0000004D000000000032323700000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C000C000000000008080800000000000000000000000
      00000000000000000000000000000000000000000000A4A0A000F0FBFF00F0FB
      FF00F0FBFF00F0FBFF00F0FBFF0080E0E00080E0E00080E0E00080E0E00080E0
      E00080E0E0008080800000000000000000000000000000000000000000000000
      6900B1B1B10071717100476E6E0000ACAC00000000000A0A0A00151529000000
      FF0000007200000000000000690000006B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008000A000C000C00000000000FFFFFF00C0C0C000FFFFFF000000
      00000000000000000000000000000000000000000000A4A0A000F0FBFF00F0FB
      FF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF0080E0E00080E0
      E00080E0E00080808000000000000000000000000000000000000000AD000000
      6900003B3B00636363003F3F3F00004F4F000000000008080800111125000000
      FF000000FF0000000000000069000000D7000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      00008000A000C000A000C000C0000000000080808000FFFFFF00C0C0C000FFFF
      FF00C0C0C00000000000000000000000000000000000A4A0A000F0FBFF00F0FB
      FF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF0080E0
      E00080E0E0008080800000000000000000000000000000001C000000FF000000
      BC003737A9000000FF002727F2004D4DBF000000A0000000FF0000005B000000
      FF000000FF00000084000000FF000000FF000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF008000000080000000800000000000
      000000000000000000000000000000000000000000000000000000000000C000
      A000C000A000C000A000C000C000C0C0C000000000000000000080808000C0C0
      C000FFFFFF00C0C0C000FFFFFF000000000000000000A4A0A000F0FBFF00F0FB
      FF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FB
      FF0080E0E0008080800000000000000000000000000000001C000000FF000000
      69000000FF000000FF000000FF000000FF00000056000000FF0000005B000000
      FF000000FF00000084000000FF000000FF00808080000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000000000000000000008000A000C000
      C000C000C000C000C000C0C0C000800060008000600080006000000000000000
      000080808000FFFFFF0080808000FFFFFF0000000000A4A0A000F0FBFF00F0FB
      FF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FB
      FF0080E0E0008080800000000000000000000000000000001C000000FF000000
      69000000FF000000FF000000FF000000FF000000D1000000AF000000F2000000
      FF000000FF00000084000000FF000000FF00000080000000000000000000FFFF
      FF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF0080000000800000008000
      0000FFFFFF0000000000000000000000000000000000800080008000A000C000
      C000C000C000C0C0C0008000800080006000800060008000600040E0E0008000
      6000000000000000000080808000FFFFFF0000000000A4A0A000F0FBFF00F0FB
      FF00FF000000FF000000FF000000FF000000F0FBFF00F0FBFF00F0FBFF00F0FB
      FF0080E0E00080808000000000000000000000000000000016000000CC000000
      5400141488002D2D50002B2B4E0027274A000505C4000000CA0000009D000000
      CD000000FF00000082000000FF000000EF000000800000008000C0C0C0000000
      0000FFFFFF0080000000808080000000800080000000FFFFFF00FFFFFF00FFFF
      FF0000000000000000000000000000000000000000008000A000C000A000C000
      C000C0C0C0008000800080008000800060008000600080006000800060008000
      60008000600080006000000000000000000000000000A4A0A000F0FBFF00FF00
      0000F0FBFF00F0FBFF00F0FBFF00F0FBFF00FF000000F0FBFF00F0FBFF00F0FB
      FF0080E0E0008080800000000000000000000000000016161600CCC3CC005400
      54007979790093939300B0B0B000D2D2D2001A1A46000500C3009D7A9D00C9BC
      CA000000A40000007B000000FF0000009700808080000000800080808000C0C0
      C00000000000808080000000800080808000FFFFFF00FFFFFF00FFFFFF000000
      00000000000000000000000000000000000000000000C000A000C000A000C0C0
      C0008000800080008000800080008000600040E0E00080006000800060008000
      60008000600080006000000000000000000000000000A4A0A000FF000000F0FB
      FF00F0FBFF00FF000000F0FBFF00FF000000F0FBFF00F0FBFF00F0FBFF00F0FB
      FF0080E0E0008080800000000000000000000000000008080800555155002608
      26001C1C7F0035354A0035354A0035354A000707A9000D0331005B145B004D33
      50000000DF000000DA000000F70000000000C0C0C00000008000000080008080
      8000000000000000800000008000FFFFFF00FFFFFF008000000080000000FFFF
      FF000000000000000000000000000000000000000000C000C000C0C0C000C000
      A0008000A00040E0E000800080008000600040E0E00080006000800060008000
      60008000600000000000000000000000000000000000A4A0A000FF000000F0FB
      FF00FF000000F0FBFF00FF000000F0FBFF00FF000000F0FBFF00F0FBFF00F0FB
      FF00F0FBFF008080800000000000000000000000000014141400DDDDDD006868
      68000000FD000000FF000000FF000000FF000000FF0023235600FBFBFB00BEBE
      BF000202B7000000FF000000950000008F00C0C0C00080808000000080000000
      80000000800000008000FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000000000000000000000000000C0C0C000C000C000C000
      A0008000A00040E0E000800080008000800040E0E00080008000800080008000
      80000000000000000000000000000000000000000000A4A0A000FF000000F0FB
      FF00FF000000F0FBFF00FF000000F0FBFF00F0FBFF00FF000000F0FBFF00F0FB
      FF00F0FBFF0080808000000000000000000000000000A7A7A700000000003F3F
      3F0000003B00000072000000720000007200000072000000880000008D000404
      3800727272000000FF00000069000000AD00C0C0C00080808000000080000000
      80000000800000000000FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000000000000000000000000000000000000000000000000000C000
      A000C000A000C000A00040E0E00040E0E0008000A00080008000800080000000
      00000000000000000000000000000000000000000000A4A0A000FF000000F0FB
      FF00F0FBFF00FF000000FF000000F0FBFF00F0FBFF00FF000000F0FBFF00F0FB
      FF00F0FBFF008080800000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FD000000C4000000C40036366D00000000008080800000008000000080000000
      8000000080008080800000000000FFFFFF00FFFFFF0080000000800000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C000A000C000A000C000A000C000A0008000A000000000000000
      00000000000000000000000000000000000000000000A4A0A000F0FBFF00FF00
      0000F0FBFF00F0FBFF00F0FBFF00F0FBFF00FF000000F0FBFF00808080008080
      8000808080008080800000000000000000000000000000000000000000000000
      000000004E000000FF000000FF000000FF000000FF000000FF000000FF000000
      FD000000960000000000000069000000CF000000800000008000808080000000
      00000000800000008000808080000000000080000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C000C000C000C00000000000000000000000
      00000000000000000000000000000000000000000000A4A0A000F0FBFF00F0FB
      FF00FF000000FF000000FF000000FF000000F0FBFF00F0FBFF00A4A0A000C0C0
      C000C0C0C0000000000000000000000000000000000000000000000000000000
      00000000000000000C00000047000000AD000000AD000000AD000909AA002D2D
      39000000000000000000000000000000A5000000000000000000000000000000
      00000000000000008000000080008080800000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000A4A0A000F0FBFF00F0FB
      FF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00A4A0A000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000008000000080008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000A4A0A000A4A0A000A4A0
      A000A4A0A000A4A0A000A4A0A000A4A0A000A4A0A000A4A0A000A4A0A0000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000806060008060
      6000806060008060600080606000806060008060600080606000000000000000
      0000000000000000000000000000000000000000000000000000C0C0C0008060
      6000806060008060600080606000806060008060600080606000806060008060
      6000806060008060600000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F0FBFF00C0C0C000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C000C0C0C000806060000000
      0000000000000000000000000000000000000000000000000000C0C0C000F0FB
      FF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FB
      FF00F0FBFF008060600000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC0000000000000000000F0FBFF00C0C0C0008060
      600080606000806060008060600080606000C0C0C000C0C0C000806060008060
      6000000000000000000000000000000000000000000000000000C0C0C000F0FB
      FF00A4A0A000A4A0A000A4A0A000A4A0A000A4A0A000A4A0A000A4A0A000A4A0
      A000F0FBFF008060600000000000000000000000000000000000808080008080
      8000806060008060600000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC0000000000000000000F0FBFF00C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C00080E0A00000600000C0C0C000806060008060
      6000000000000000000000000000000000000000000000000000C0C0C000F0FB
      FF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FB
      FF00F0FBFF008060600000000000000000000000000000000000000000008080
      8000806060000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC000000000000000000000000000F0FBFF00F0FB
      FF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00A4A0A0008060
      6000000000000000000000000000000000000000000000000000C0C0C000F0FB
      FF00A4A0A000A4A0A000A4A0A000A4A0A000A4A0A000A4A0A000A4A0A000A4A0
      A000F0FBFF008060600000000000000000000000000000000000000000008080
      8000806060000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC00000000000000000000000000000000000F0FB
      FF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00A4A0
      A000000000000000000000000000000000000000000000000000C0C0C000F0FB
      FF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FB
      FF00F0FBFF008060600000000000000000000000000000000000000000008080
      8000806060000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC000000000000000000000000000000000000000
      0000C0200000402000008020000080200000C0C0C000C0C0C000806060008060
      6000806060008060600080606000806060000000000000000000C0C0C0008060
      600080606000A4A0A000A4A0A000A4A0A000A4A0A000A4A0A000A4A0A000A4A0
      A000F0FBFF008060600000000000000000000000000000000000000000008080
      8000806060000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC000000000000000000000000000000000000000
      0000C0604000FF000000C0200000C0C0C000C0C0C000F0FBFF00F0FBFF00F0FB
      FF00F0FBFF00F0FBFF00F0FBFF00806060000000000000000000FF000000FF00
      0000F0FBFF0080606000F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FB
      FF00F0FBFF008060600000000000000000000000000000000000000000008060
      60000020C00000000000000000000000000000000000000000000020C0000000
      FF000000FF0000000000000000000000000000000000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC000000000000000000000000000000000000000
      0000C0806000C0604000FF00000040200000C0C0C000F0FBFF00806060008060
      60008060600080606000F0FBFF008060600000000000FF000000C0C0C000F0FB
      FF00FF00000080606000A4A0A000A4A0A000A4A0A000F0FBFF00F0FBFF00F0FB
      FF00F0FBFF008060600000000000000000000000000000000000000000008060
      60000020C0000000FF000000FF000000FF000000FF000020C0000000FF000000
      FF000000FF0000000000000000000000000000000000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC000000000000000000000000000000000000000
      0000C080600000000000C0808000FF000000C0C0C000F0FBFF00F0FBFF00F0FB
      FF00F0FBFF00F0FBFF00F0FBFF008060600000000000FF000000C0C0C000F0FB
      FF00FF00000080606000F0FBFF00F0FBFF00F0FBFF00F0FBFF00A4A0A000A4A0
      A000A4A0A000A4A0A00000000000000000000000000000000000000000008060
      60000020C0000000FF000000FF000000FF000000FF000020C0000000FF000000
      FF000000FF0000000000000000000000000000000000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC000000000000000000000000000000000000000
      0000000000000000000000000000C080600080200000F0FBFF00806060008060
      60008060600080606000F0FBFF008060600000000000FF00000080606000F0FB
      FF00FF00000080606000A4A0A000A4A0A000A4A0A000F0FBFF00C0C0C00080C0
      C00080C0C000A4A0A00000000000000000000000000000000000000000008060
      60000020C0000000FF000000FF000000FF000000FF000020C0000000FF000000
      FF000000FF0000000000000000000000000000000000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F0FBFF00F0FBFF00F0FB
      FF00F0FBFF00F0FBFF00F0FBFF008060600000000000FF00000080606000F0FB
      FF00FF00000080606000F0FBFF00F0FBFF00F0FBFF00F0FBFF00C0C0C00080C0
      C000A4A0A0000000000000000000000000000000000000000000000000008060
      60000020C0000000FF000000FF000000FF000000FF000020C0000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F0FBFF0080606000F0FB
      FF00A4A0A000A4A0A000A4A0A000A4A0A00000000000FF00000080606000F0FB
      FF00FF000000F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00C0C0C000A4A0
      A000000000000000000000000000000000000000000000000000000000008060
      60000020C0000000FF000000FF000000FF000000FF000020C0000000FF000000
      FF000000FF0000000000000000000000000000000000C0A06000C0A06000C0A0
      6000C0A06000C0A06000C0A06000C0A06000C0A06000C0A06000C0A06000C0A0
      6000C0A06000C0A06000C0A06000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F0FBFF00F0FBFF00F0FB
      FF00C0C0C00080C0C00080C0C000A4A0A00000000000FF00000080606000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C0000000
      0000000000000000000000000000000000000000000000000000000000008060
      60000020C0000000FF000000FF000000FF000000FF000020C0000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F0FBFF00F0FBFF00F0FB
      FF00C0C0C00080C0C000A4A0A0000000000000000000FF000000806060008060
      600080606000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000020
      C000000000000020C0000000FF000000FF000000FF000020C000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F0FBFF00F0FBFF00F0FB
      FF00C0C0C000A4A0A00000000000000000000000000000000000FF000000FF00
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000600000006000000000000000000000804060008040
      6000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000A4A0A00080606000A4A0A0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008060600080606000000000000000000000000000806060008060
      6000806060008060600080606000806060008060600080606000806060008060
      6000806060008060600000000000000000000000000000000000000000000000
      00000000000000C0400080E0A00000C0400000600000C060C000F0FBFF00C060
      C000804060000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000A4A0A00080606000A4A0A000C0C0C0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000080606000A4A0A000A4A0A0008060600000000000C0C0C000F0FBFF00F0FB
      FF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FB
      FF00F0FBFF008060600000000000000000000000000000000000000000000000
      00000000000000C0400080E0A00000C0400000600000C060C000F0FBFF00C060
      C000804060000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000080606000A4A0A000C0C0C000A4A0A0000000000000000000000000008060
      6000A4A0A000A4A0A000A4A0A000806060008060600080606000806060008060
      6000A4A0A000A4A0A000C0C0C0008060600000000000C0C0C000F0FBFF00F0FB
      FF0000000000F0FBFF00F0FBFF0000000000F0FBFF00F0FBFF0000000000F0FB
      FF00F0FBFF008060600000000000000000000000000000000000000000000000
      00000000000000C0400080E0A00000C0400000600000C060C000F0FBFF00C060
      C000804060000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008060
      6000A4A0A000C0C0C000A4A0A000000000000000000000000000FFFFFF00FFFF
      FF0080606000A4A0A000A4A0A000FFFFFF00FFFFFF00FFFFFF0080606000A4A0
      A000A4A0A000C0C0C000A4A0A0008060600000000000C0C0C000F0FBFF00F0FB
      FF0000000000F0FBFF00F0FBFF0000000000F0FBFF0000000000F0FBFF000000
      0000F0FBFF008060600000000000000000000000000000000000000000000000
      00000000000000C0400080E0A00000C0400000600000C060C000F0FBFF00C060
      C000804060000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080606000C0C0
      C000C0C0C0000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0080606000C0C0
      C000C0C0C000A4A0A000FFFFFF008060600000000000C0C0C000F0FBFF000000
      000000000000F0FBFF000000000000000000F0FBFF0000000000F0FBFF000000
      0000F0FBFF00806060000000000000000000C0C0C000C0C0C000006060000060
      60000060600000C0400080E0A00000C0400000600000C060C000F0FBFF00C060
      C000804060000000000000000000000000000000000000000000000000000000
      0000806060008060600080606000000000000000000080606000C0C0C000A4A0
      A000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00806060008060600080606000FFFFFF00FFFFFF0080606000C0C0C000A4A0
      A000A4A0A000F0FBFF00C0C0C0008060600000000000C0C0C000F0FBFF00F0FB
      FF0000000000F0FBFF00F0FBFF0000000000F0FBFF00F0FBFF0000000000F0FB
      FF00F0FBFF00806060000000000000000000C0C0C0008060600000C0C00000A0
      A00000A0A00080E0A00080E0A00080E0A00000C04000C060C000F0FBFF00C060
      C000804060008080800000000000000000000000000000000000806060008060
      6000C0C0A000C0C0A000C0C0A0008060600080606000C0C0C000A4A0A0000000
      0000000000000000000000000000000000000000000000000000806060008060
      6000C0C0A000C0C0A000C0C0A0008060600080606000C0C0C000A4A0A000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF008060600000000000C0C0C000F0FBFF00F0FB
      FF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FB
      FF00F0FBFF00806060000000000000000000C0C0C000FFFFFF00FFFFFF0000C0
      C00000C0C000FFFFFF00A4A0A00080606000FFFFFF00C060C000F0FBFF00C060
      C0008040600080808000000000000000000000000000A4A0A000F0CAA60080A0
      4000F0CAA60040804000C0C0A00040804000C0C0A00080606000000000000000
      00000000000000000000000000000000000000000000A4A0A000F0CAA60080A0
      4000F0CAA60040804000C0C0A00040804000C0C0A00080606000F0FBFF00C0C0
      C000A4A0A00080606000806060008060600000000000C0C0C000F0FBFF00F0FB
      FF0000000000F0FBFF00F0FBFF0000000000F0FBFF00F0FBFF00F0FBFF00F0FB
      FF00F0FBFF00806060000000000000000000C0C0C000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00A4A0A00080606000FFFFFF00F0FBFF00F0FBFF00F0FB
      FF00C060C00080808000000000000000000000000000A4A0A000F0CAA60080A0
      400080A04000F0CAA60080A0400040804000C0C0A00080606000000000000000
      00000000000000000000000000000000000000000000A4A0A000F0CAA60080A0
      400080A04000F0CAA60080A0400040804000C0C0A00080606000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF008060600000000000C0C0C000F0FBFF00F0FB
      FF0000000000F0FBFF0000000000F0FBFF0000000000F0FBFF00F0FBFF00F0FB
      FF00F0FBFF00806060000000000000000000C0C0C000FFFFFF0000A04000FFFF
      FF00FFFFFF00FFFFFF00A4A0A000A4A0A00080606000FFFFFF00A4A0A0008060
      6000FFFFFF00808080000000000000000000A4A0A000F0CAA600F0CAA60080C0
      4000F0CAA60080C08000F0CAA60080C04000C0C0A000C0C0A000806060000000
      000000000000000000000000000000000000A4A0A000F0CAA600F0CAA60080C0
      4000F0CAA60080C08000F0CAA60080C04000C0C0A000C0C0A00080606000F0FB
      FF00C0C0C000A4A0A000806060008060600000000000C0C0C000F0FBFF000000
      000000000000F0FBFF0000000000F0FBFF0000000000F0FBFF00A4A0A000A4A0
      A000A4A0A000A4A0A0000000000000000000C0C0C000FFFFFF0000A0400000A0
      400000A04000FFFFFF00C0C0C000C0C0C00080606000FFFFFF00A4A0A0008060
      6000FFFFFF00808080000000000000000000A4A0A000F0CAA600F0CAA600F0CA
      A60080C0800080C0800080C08000F0CAA600F0CAA600F0CAA600806060000000
      000000000000000000000000000000000000A4A0A000F0CAA600F0CAA600F0CA
      A60080C0800080C0800080C08000F0CAA600F0CAA600F0CAA60080606000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF008060600000000000C0C0C000F0FBFF00F0FB
      FF0000000000F0FBFF00F0FBFF0000000000F0FBFF00F0FBFF00C0C0C00080C0
      C00080C0C000A4A0A0000000000000000000C0C0C000FFFFFF0000C04000F0FB
      FF00F0FBFF00FFFFFF00FFFFFF00FFFFFF0080606000A4A0A000C0C0C000A4A0
      A00080606000808080000000000080606000A4A0A000F0CAA600F0CAA600F0CA
      A60080C0800080C0800080C08000F0CAA600F0CAA60080806000806060000000
      000000000000000000000000000000000000A4A0A000F0CAA600F0CAA600F0CA
      A60080C0800080C0800080C08000F0CAA600F0CAA6008080600080606000F0FB
      FF00C0C0C000FFFFFF00FFFFFF008060600000000000C0C0C000F0FBFF00F0FB
      FF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00C0C0C00080C0
      C000A4A0A000000000000000000000000000C0C0C000FFFFFF00FFFFFF0000A0
      A00000A0A000FFFFFF0080606000FFFFFF00A4A0A000A4A0A000C0C0C000C0C0
      C000A4A0A00080606000A4A0A0008060600000000000A4A0A000F0CAA600F0CA
      A600C0A0800080604000C0A08000F0CAA600F0CAA600A4A0A000000000000000
      00000000000000000000000000000000000000000000A4A0A000F0CAA600F0CA
      A600C0A0800080604000C0A08000F0CAA600F0CAA600A4A0A000F0FBFF00C0C0
      C000A4A0A000FFFFFF00FFFFFF00A4A0A00000000000C0C0C000F0FBFF00F0FB
      FF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00C0C0C000A4A0
      A00000000000000000000000000000000000C0C0C000F0FBFF00FFFFFF008060
      600080606000FFFFFF00C0C0C000A4A0A000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000A4A0A00000000000A4A0A000F0CAA600F0CA
      A600F0CAA600F0CAA600F0CAA600F0CAA600F0CAA600A4A0A000000000000000
      00000000000000000000000000000000000000000000A4A0A000F0CAA600F0CA
      A600F0CAA600F0CAA600F0CAA600F0CAA600F0CAA600A4A0A000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00A4A0A0000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C0000000
      000000000000000000000000000000000000C0C0C000C0C0C000F0FBFF00FFFF
      FF00FFFFFF00FFFFFF00C0C0C000FFFFFF00C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000A4A0A000000000000000000000000000A4A0A000A4A0
      A000F0CAA600F0CAA600F0CAA600A4A0A000A4A0A00000000000000000000000
      0000000000000000000000000000000000000000000000000000A4A0A000A4A0
      A000F0CAA600F0CAA600F0CAA600A4A0A000A4A0A00000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000FFFFFF00FFFFFF00C0C0C000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00C0C0C000A4A0A00000000000000000000000000000000000000000000000
      0000A4A0A000A4A0A000A4A0A000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000A4A0A000A4A0A000A4A0A000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000006000000060000000000000000000008040
      6000804060000000000000000000000000000000000000000000000000000000
      000000000000000000000060000000A0000080E0C00080E0C00000C0400000C0
      400000A0000000A0000000600000404040000000000000000000000000000000
      0000000000000000000000000000000000004000600000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000806060008060600080606000806060008060600080606000806060008060
      6000806060008060600080606000000000000000000000000000000000000000
      0000000000000000000000C0400080E0A00000C0400000600000C060C000F0FB
      FF00C060C0008040600000000000000000000000000000000000000000000000
      0000000000000000000000000000404040004040400040404000404040004040
      4000404040004040400040404000000000000000000000000000000000000000
      0000000000000000000040006000400060004080A00040606000400060000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FB
      FF00F0FBFF00F0FBFF00806060000000000000000000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC00000C0400080E0A00000C0400000600000C060C000F0FB
      FF00C060C00080406000C0DCC000000000000000000000000000000000000000
      00000000000000000000F0FBFF0080808000FFFFFF0040404000C0C0C0004040
      4000C0C0C0008080800040404000000000000000000000000000000000000000
      000040006000404060004080A00040C0E00040C0E00080E0E00080C0E0004060
      600040006000000000000000000000000000000000000000000000000000C0C0
      C000F0FBFF00C0C0C000C0C0C000C0C0C000A4A0A000A4A0A000A4A0A000A4A0
      A000A4A0A000F0FBFF00806060000000000000000000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC00000C0400080E0A00000C0400000600000C060C000F0FB
      FF00C060C00080406000C0DCC000000000000000000000000000000000000000
      000000000000F0FBFF00F0FBFF0080808000FFFFFF00FFFFFF0040404000C0C0
      C000C0C0C0008080800040404000000000000000000000000000000000004040
      60004080A00040C0E00040C0E00040C0E00040C0E00080E0E00080E0E00080E0
      E00080C0E0008040600000000000000000000000000000000000000000000060
      0000006000000060000000A04000F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FB
      FF00F0FBFF00F0FBFF00806060000000000000000000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC00000C0400080E0A00000C0400000600000C060C000F0FB
      FF00C060C00080406000C0DCC000000000000000000000000000000000000000
      0000F0FBFF00F0FBFF00F0FBFF0080808000C0C0C000FFFFFF00C0C0C000C0C0
      C000C0C0C0008080800040404000000000000000000000000000400060004080
      A00040C0E00040C0E00040C0E00040C0E00080E0E00040A0C00080E0E00080E0
      E00080E0E00040A0C0004000600000000000000000000000000000C0400000A0
      40000060000000A040000060000000600000C0C0C000A4A0A000A4A0A000A4A0
      A000A4A0A000F0FBFF00806060000000000000000000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC00000C0400080E0A00000C0400000600000C060C000F0FB
      FF00C060C00080406000C0DCC00000000000000000000000000000000000F0FB
      FF00F0FBFF00F0FBFF0080606000C0C0C00080808000C0C0C00080808000C0C0
      C0008080800040404000806060000000000000000000400060004080A00040A0
      C0004080A00040C0E00040C0E00080E0E00040A0C00040A0C00040A0C00040A0
      C00080E0E00040A0C0004040600040006000000000000000000000C0400000C0
      400000600000F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FB
      FF00F0FBFF00F0FBFF00806060000000000000000000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC00080E0A00080E0A00080E0A00000C04000C060C000F0FB
      FF00C060C00080406000C0DCC000000000000000000000000000F0FBFF00F0FB
      FF00F0FBFF00F0FBFF00F0FBFF0080606000C0C0C00080808000FFFFFF008080
      800040404000000000000000000000000000000000004040600080E0E00080E0
      E0004080A0004080A00080E0E00040A0C00080C0E00040A0C00080C0E00080C0
      E00080C0E0004080A000F0FBFF0080406000000000000000000000C0400000C0
      400000600000C0C0C000A4A0A000A4A0A000A4A0A000A4A0A000A4A0A000A4A0
      A000A4A0A000F0FBFF00806060000000000000000000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC000A4A0A00080606000C0DCC000C060C000F0FB
      FF00C060C00080406000C0DCC0000000000000000000F0FBFF00F0FBFF00F0FB
      FF0080606000C0C0C000F0FBFF00F0FBFF008060600080808000FFFFFF008080
      800040404000000000000000000000000000000000004040600080E0E00080E0
      E00040A0C00040A0C00080E0E00080C0E00040A0C00040A0C00080C0E00040C0
      E0004080A000F0FBFF00F0FBFF0080406000000000000000000000C0400000C0
      400000600000F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FB
      FF00F0FBFF00F0FBFF00806060000000000000000000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC000A4A0A00080606000C0DCC000F0FBFF00F0FB
      FF00F0FBFF00C060C000C0DCC00000000000F0FBFF00F0FBFF00F0FBFF00F0FB
      FF00F0FBFF0080606000C0C0C000F0FBFF0080808000C0C0C00040404000C0C0
      C00080808000404040000000000000000000000000004000600040A0C00080E0
      E00040C0E0004060600040A0C00080E0E00080E0E00080C0E00080E0E0004060
      8000C0808000C0808000F0FBFF008040600000C0400000C0400000C0200000C0
      4000006000000060000000600000C0C0C000A4A0A000A4A0A000F0FBFF00F0FB
      FF00F0FBFF00F0FBFF00806060000000000000000000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0C0C000A4A0A000A4A0A00080606000C0DCC000A4A0
      A00080606000C0DCC000C0DCC00000000000F0FBFF00F0FBFF0080606000C0C0
      C000F0FBFF00F0FBFF008060600080808000C0C0C00080808000C0C0C0004040
      4000C0C0C00080808000404040000000000000000000000000004000600040A0
      C00080E0E0004080A000406080004080A00040A0C00040A0C00040606000C080
      8000C0808000C0808000F0FBFF00804060000000000080E0C00040E0800000C0
      400000E0400000E04000F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00A4A0
      A000A4A0A000A4A0A000A4A0A0000000000000000000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0C0C000C0C0C000C0C0C00080606000C0DCC000A4A0
      A00080606000C0DCC000C0DCC00000000000F0FBFF00F0FBFF00F0FBFF008060
      6000C0C0C000F0FBFF00F0FBFF0080808000FFFFFF00FFFFFF00C0C0C000C0C0
      C000C0C0C0008080800040404000000000000000000000000000000000004000
      60004060600040A0C00080C0E00040A0C0004080A00040A0C000406080008040
      6000C0808000C0808000F0FBFF0080406000000000000000000080E0C00040E0
      800000E04000C0C0C000A4A0A000A4A0A000A4A0A000A4A0A000F0FBFF00C0C0
      C00080C0C00080C0C000A4A0A0000000000000000000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0C0C000C0C0C000C0C0C000C0C0C000A4A0A000C0C0
      C000A4A0A00080606000C0DCC0000000000000000000F0FBFF00F0FBFF00F0FB
      FF0080606000C0C0C000F0FBFF0080808000FFFFFF00FFFFFF00C0C0C000C0C0
      C000C0C0C0008080800040404000000000000000000000000000000000000000
      0000000000004000600080406000406080004060800040A0C00040A0C000C080
      8000C0808000C0808000F0FBFF004040600000000000000000000000000080E0
      C000F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00C0C0
      C00080C0C000A4A0A00000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000A4A0A000A4A0A000C0C0
      C000C0C0C000A4A0A00080606000806060000000000000000000F0FBFF00F0FB
      FF00F0FBFF008060600000000000404040004040400040404000404040004040
      4000404040004040400040404000000000000000000000000000000000000000
      00000000000000000000400060004060800040608000C0808000C0808000C080
      8000C0808000C0808000F0FBFF0080406000000000000000000000000000C0C0
      C000F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00C0C0
      C000A4A0A00000000000000000000000000000000000C0A06000C0A06000C0A0
      6000C0A06000C0A06000C0A06000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000000000000000000000000000F0FB
      FF00F0FBFF00F0FBFF000060000000A0000080E0C00080E0C00000C0400000C0
      400000A0000000A0000000600000404040000000000000000000000000000000
      00000000000000000000400060004040600080406000F0FBFF00F0FBFF00F0FB
      FF00F0FBFF00F0FBFF00F0FBFF0080406000000000000000000000000000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C0000000000000000000000000000000
      0000F0FBFF00F0FBFF0000600000006000000060000000600000006000000060
      0000006000000060000000600000404040000000000000000000000000000000
      0000000000000000000000000000000000004000600080406000804060008040
      6000804060008040600080406000400060000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000A4A0A0000000000000000000000000000000
      000000000000F0FBFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000006000000060
      0000000000000000000000000000000000000000000080406000804060000000
      0000000000000000000000000000000000000000000000000000000000004060
      6000404040004040400040404000404040004040400040404000404040004040
      4000402020008080800000000000000000000000000000600000006000000000
      0000000000000000000080406000804060000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000C0400080E0A00000C0
      400000600000000000000000000000000000C060C000F0FBFF00C060C0008040
      600000000000000000000000000000000000000000000000000080808000C0C0
      C000C0DCC0008080800040404000406060004040400040404000406060004040
      4000C0C0C00080606000C0C0C0000000000000C0400080E0A00000C040000060
      000000000000C060C000F0FBFF00C060C0008040600080404000802020008020
      0000802000008020200080404000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000C0400080E0A00000C0
      400000600000000000000000000000000000C060C000F0FBFF00C060C0008040
      600000000000000000000000000000000000000000000000000080808000FFFF
      FF00A4A0A00080606000A4A0A000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000F0FBFF0080606000A4A0A0000000000000C0400080E0A00000C040000060
      000000000000C060C000F0FBFF00C060C00080406000C0806000F0CAA600F0CA
      A600F0CAA600F0CAA600C0604000000000000000000080808000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080000000000000000000000000000000000000C0400080E0A00000C0
      400000600000000000000000000000000000C060C000F0FBFF00C060C0008040
      600000000000000000000000000000000000000000000000000080808000A4A0
      A00040404000402020004040400080808000F0FBFF00F0FBFF00F0FBFF00F0FB
      FF00F0FBFF0080606000C0C0C0000000000000C0400080E0A00000C040000060
      000000000000C060C000F0FBFF00C060C0008040600000000000000000000000
      000000000000000000000000000000000000000000008080800080E0E00080E0
      E00080E0E00080E0E00040E0E00040E0E00040C0E00000C0E00000C0C00000C0
      C000808080008080800000000000000000000000000000C0400080E0A00000C0
      400000600000000000000000000000000000C060C000F0FBFF00C060C0008040
      6000000000000000000000000000000000000000000000000000808080004060
      6000A4A0A000A4A0A000A4A0A00040404000C0C0C000F0FBFF00F0FBFF00F0FB
      FF000000000080606000C0C0C0000000000000C0400080E0A00000C040000060
      000000000000C060C000F0FBFF00C060C0008040600080606000806040008040
      4000804040008040400080404000000000000000000080808000F0FBFF000000
      000000000000000000000000000040E0E00040C0E00040C0E00000C0C00000C0
      C0008080800080E0E00080808000000000000000000000C0400080E0A00000C0
      400000600000000000000000000000000000C060C000F0FBFF00C060C0008040
      6000000000000000000000000000000000000000000000000000808080008080
      8000C0DCC000C0DCC000C0DCC00040606000C0C0C00080808000808080008080
      8000A4A0A00040606000C0C0C0000000000080E0A00080E0A00080E0A00000C0
      4000C0402000C060C000F0FBFF00C060C00080406000C0604000FF000000C020
      0000C0604000C0A08000C0200000808060000000000080808000F0FBFF000000
      000080E0E00080E0E0000000000080E0E00040E0E00040C0E00040C0E00000C0
      C0008080800080E0E00040C0E000808080000000000080E0A00080E0A00080E0
      A00000C04000000000000000000000000000C060C000F0FBFF00C060C0008040
      6000000000000000000000000000000000000000000000000000808080008080
      8000F0FBFF00F0FBFF00F0FBFF00806060008080800040404000406060004060
      60004060600080606000C0C0C0000000000000000000A4A0A000806060000000
      000080200000C060C000F0FBFF00C060C0008040600000000000C0806000C020
      00000000000000000000C0604000804040000000000080808000F0FBFF000000
      000000000000000000000000000080E0E00040E0E00040E0E00040C0E00000C0
      E0008080800080E0E00040C0E000808080000000000000000000A4A0A0008060
      600000000000000000000000000000000000C060C000F0FBFF00C060C0008040
      6000000000000000000000000000000000000000000000000000808080008080
      8000C0DCC000C0C0C000C0DCC00040606000A4A0A00040606000806060008060
      60004060600040606000C0C0C0000000000000000000A4A0A000806060000000
      000080200000C060C000F0FBFF00C060C0008040600000000000C06040008020
      00000000000000000000C0806000802020000000000080808000F0FBFF00F0FB
      FF0080E0E00080E0E00080E0E00080E0E00080E0E00040E0E00040C0E00040C0
      E0008080800080E0E00040C0E000808080000000000000000000A4A0A0008060
      600000000000000000000000000000000000F0FBFF00F0FBFF00F0FBFF00C060
      C000000000000000000000000000000000000000000000000000808080008080
      8000C0C0C000A4A0A000C0DCC00040606000A4A0A00080606000806060008060
      60008060600040606000C0C0C0000000000000000000A4A0A000806060000000
      000080200000F0FBFF00F0FBFF00F0FBFF00C060C00000000000C06040008020
      00000000000000000000C0806000802000000000000080808000F0FBFF00F0FB
      FF00F0FBFF0080E0E00080E0E00080E0E00080E0E00040E0E00040E0E00040C0
      E0008080800080E0E00040C0E0008080800000000000FFFFFF00A4A0A000A4A0
      A0008060600000000000000000000000000000000000A4A0A000806060000000
      0000000000000000000000000000000000000000000000000000808080008080
      8000C0DCC000C0C0C000F0FBFF0040606000A4A0A00040606000806060008060
      60008060600080606000C0C0C0000000000000000000A4A0A000A4A0A0008060
      60008020000000000000A4A0A000806060000000000000000000C06040008020
      00000000000000000000C0806000802000000000000080808000F0FBFF00F0FB
      FF00F0FBFF00F0FBFF0080E0E00080E0E00080E0E00080E0E00040E0E00040E0
      E0008080800080E0E00040C0E0008080800000000000FFFFFF00C0C0C000C0C0
      C0008060600000000000000000000000000000000000A4A0A000806060000000
      0000000000000000000000000000000000000000000000000000808080008080
      8000C0DCC000F0FBFF00F0FBFF00406060008080800040404000404040004060
      60004040400040606000C0C0C0000000000000000000C0C0C000C0C0C0008060
      6000C0402000C0604000A4A0A000806060000000000000000000FF0000008020
      00000000000000000000C0604000C04020000000000080808000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      80008080800080E0E00040C0E0008080800000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00000000000000000000000000A4A0A000C0C0C000A4A0A0008060
      6000000000000000000000000000806060000000000000000000808080008080
      8000F0FBFF00F0FBFF00F0FBFF0040606000A4A0A000C0C0C000A4A0A000C0C0
      C000C0C0C00080606000C0C0C000000000000000000000FFFF00F0FBFF000000
      000000000000A4A0A000C0C0C000A4A0A0008060600080606000802000000000
      00000000000000000000FF0000008060600000000000000000008080800080E0
      E00000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF000000
      000080E0E0008080800040C0E000808080000000000000000000000000000000
      0000A4A0A0008060600000000000A4A0A000A4A0A000C0C0C000C0C0C000A4A0
      A0008060600080606000A4A0A000806060000000000000000000808080008080
      8000F0FBFF00F0FBFF00F0FBFF0040404000C0C0C000F0FBFF00F0FBFF00F0FB
      FF00F0FBFF0080606000C0C0C0000000000000000000A4A0A000806060000000
      0000A4A0A000A4A0A000C0C0C000C0C0C000A4A0A0008060600080606000A4A0
      A00080606000C0604000FF000000000000000000000000000000000000008080
      800000000000FFFFFF000000000000000000FFFFFF00FFFFFF00FFFFFF000000
      000040C0E00040C0E00080808000808080000000000000000000000000000000
      0000FFFFFF00C0C0C000A4A0A000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000A4A0A0000000000000000000808080008080
      8000A4A0A000A4A0A000A4A0A00080808000C0DCC000C0DCC000C0DCC000C0DC
      C000F0FBFF0080606000C0C0C0000000000000000000FFFFFF00C0C0C000A4A0
      A000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000A4A0A000FF00000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF000000
      0000808080008080800080808000808080000000000000000000000000000000
      0000FFFFFF00C0C0C000FFFFFF00C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000A4A0A00000000000000000000000000080808000F0FB
      FF00A4A0A000A4A0A000A4A0A000F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FB
      FF00FFFFFF0080606000A4A0A0000000000000000000FFFFFF00C0C0C000FFFF
      FF00C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000A4A0
      A000806060000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00C0C0C000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00A4A0A00000000000000000000000000000000000C0C0C000A4A0
      A000C0C0C000C0C0C000C0C0C000A4A0A000A4A0A000A4A0A000A4A0A000A4A0
      A000A4A0A00080808000000000000000000000000000FFFFFF00FFFFFF00C0C0
      C000FFFFFF00FFFFFF0000A0A00000A0A00000A0A00000A0A000A4A0A0000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000006060000060
      6000006060000060600000606000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000A0A00000C0C00000C0
      C00000C0C00000C0C00000A0A000006060000000000000000000000000000000
      000000000000000000000000000000000000C0808000C0404000C0404000C040
      4000C0404000C0404000C0404000C0202000C0404000C0404000C0404000C040
      4000C0404000C0404000C0202000C08080000000000000000000006020000060
      2000006020000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0C0C000C0C0C0000060
      6000006060000060600000606000C0C0C000C0C0C00000606000006060000060
      600000606000C0C0C000C0C0C0000000000000A0A00000C0C00000C0C000FFFF
      FF0000C0C000FFFFFF0000C0C00000A0A0000060600000000000006060000000
      000000000000000000000000000000000000C0000000C0000000C0000000C000
      0000C0000000C0000000C0000000C0000000C0000000C0000000C0000000C000
      0000C0000000C0000000C0000000C0404000000000000060200000A0000000A0
      000000A000000060200000000000000000000000000000000000000000000000
      00000060200000A00000000000000000000000000000C0C0C0008060600000C0
      C00000A0A00000A0A00000606000806060008060600000C0C00000A0A00000A0
      A0000060600080606000806060000000000000A0A00000FFFF0000C0C0000060
      6000FFFFFF0000C0C000FFFFFF0000C0C00000A0A00000606000FFFFFF000060
      600000000000006060000000000000000000C0000000C0202000C0202000C000
      0000C0404000C0604000C0404000C0000000C0202000C0404000C0202000C040
      4000C0404000C0000000C0202000C0404000000000000060200000A000000000
      000000A0000000A0000000000000006020000000000000000000000000000000
      00000060200000A00000000000000000000000000000C0C0C000FFFFFF00FFFF
      FF0000C0C00000C0C000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000C0C00000C0
      C000FFFFFF00FFFFFF00806060000000000000A0A00000FFFF0000606000FFFF
      FF0000606000FFFFFF0000C0C00000C0C00000C0C00000C0C00000C0C00000A0
      A0000060600000C0C0000060600000000000C0202000C0404000C0000000FFFF
      FF00FFFFFF00F0FBFF00FFFFFF00C0202000C0806000FFFFFF00C0808000FFFF
      FF00F0CAA600C0000000C0404000C0404000000000000060200000A000000000
      000000000000000000000000000000A000000000000000000000000000000060
      200000A0000000000000000000000000000000000000C0C0C000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00806060000000000000A0A00000FFFF0000C0C0000060
      6000FFFFFF0000C0C000FFFFFF0000C0C00000A0A00000A0A00000C0C00000C0
      C00000C0C00000C0C00000C0C00000606000C0202000C0604000C0202000FFFF
      FF00F0CAA600C0404000FFFFFF00C0604000C0404000FFFFFF00F0CAA600F0FB
      FF00C0202000C0404000C0404000C0604000000000000060200000A000000000
      0000000000000000000000000000000000000000000000000000000000000060
      200000A0000000000000000000000000000000000000C0C0C000FFFFFF0000A0
      4000FFFFFF00FFFFFF0000A04000FFFFFF00FFFFFF0080606000806060008060
      6000FFFFFF00FFFFFF00806060000000000000A0A00000FFFF0000C0C00000C0
      C00000C0C00000C0C00000C0C00000C0C00000A0A00000A0A00000A0A00000A0
      A00000A0A00000A0A00000A0A00000C0C000C0202000C0604000C0202000FFFF
      FF00F0CAA600C0404000FFFFFF00C0606000C0404000FFFFFF00FFFFFF00F0CA
      A600C0404000C0604000C0404000C0604000000000000060200000A000000000
      000000000000000000000000000000A0000000000000000000000060200000A0
      00000000000000000000000000000000000000000000C0C0C000FFFFFF0000A0
      400000A0400000A0400000A04000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00806060000000000000A0A00000A0A00000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000A0A0000060600000000000006060000000
      000000000000000000000000000000000000C0202000C0806000C0404000FFFF
      FF00F0CAA600C0404000FFFFFF00C0604000C0404000FFFFFF00C0806000FFFF
      FF00C0806000C0404000C0606000C0604000000000000060200000A000000000
      000000A0000000A00000000000000060200000000000000000000060200000A0
      00000000000000000000000000000000000000000000C0C0C000FFFFFF0000C0
      4000F0FBFF00F0FBFF0000C04000FFFFFF00FFFFFF0080606000806060008060
      6000FFFFFF00FFFFFF00806060000000000000A0A00000FFFF0000A0A00000A0
      A00000A0A00000A0A00000A0A00000C0C00000A0A00000606000FFFFFF000060
      600000000000006060000000000000000000C0404000C0806000C0404000FFFF
      FF00FFFFFF00F0CAA600FFFFFF00C0404000C0806000FFFFFF00C0604000C040
      4000C0404000C0806000C0806000C0604000000000000060200000A0000000A0
      000000A00000006020000000000000000000000000000060200000A000000000
      00000000000000000000000000000000000000000000C0C0C000FFFFFF00FFFF
      FF0000A0A00000A0A000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00806060000000000000A0A00000FFFF0000606000FFFF
      FF0000606000FFFFFF0000C0C00000C0C00000C0C00000C0C00000C0C00000A0
      A0000060600000C0C0000060600000000000C0404000C0A08000C0806000C060
      4000FFFFFF00FFFFFF00C0808000C0404000C0806000F0CAA600C0404000C080
      6000C0A08000C0806000C0806000C06060000000000000000000006020000060
      200000602000000000000000000000000000000000000060200000A000000000
      00000000000000000000000000000000000000000000C0C0C000F0FBFF00FFFF
      FF008060600080606000FFFFFF00FFFFFF00806060008060600080606000FFFF
      FF00FFFFFF00FFFFFF00A4A0A0000000000000A0A00000FFFF0000C0C0000060
      6000FFFFFF0000C0C000FFFFFF0000C0C00000A0A00000A0A00000C0C00000C0
      C00000C0C00000C0C00000C0C00000606000C0404000C0806000C0A08000C080
      6000C0604000C0404000C0806000C0806000C0806000C0606000C0806000C0A0
      8000C0A08000C0A08000C0806000C06060000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0C0C000C0C0C000F0FB
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00A4A0A000C0C0C0000000000000A0A00000FFFF0000C0C00000C0
      C00000C0C00000C0C00000C0C00000C0C00000A0A00000A0A00000A0A00000A0
      A00000A0A00000A0A00000A0A00000C0C000C0A0A000C0606000C0606000C080
      6000C0806000C0806000C0806000C0606000C0606000C0806000C0806000C060
      6000C0606000C0606000C0604000F0CAA6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000000000000000000000A0A00000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000A0A0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000A0A00000A0
      A00000A0A00000A0A00000A0A000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000006060000060
      6000006060000060600000606000000000000000000000000000000000000000
      0000802000008020000080200000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000A0A00000C0C00000C0
      C00000C0C00000C0C00000A0A000006060000000000000000000802000008020
      0000C040A000C040A000C040A000802000000000000000000000006060000060
      6000006060000060600000606000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000A0A00000C0C00000C0C000C0C0
      C00000C0C000C0C0C00000C0C00000A0A000006060008020000000606000C040
      A000C040A000C040A000C040A000C040A0000000000000A0A00000C0C00000C0
      C00000C0C00000C0C00000A0A000006060000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000A0A00000FFFF0000C0C0000060
      6000C0C0C00000C0C000C0C0C00000C0C00000A0A00000606000C0C0C0000060
      6000C0C0C00000606000C040A000C040A00000A0A00000C0C00000C0C000FFFF
      FF0000C0C000FFFFFF0000C0C00000A0A0000060600000000000006060000000
      000000000000000000000000000000000000000000000000FF00000080000000
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000006060000060
      6000006060000060600000606000000000000000000000000000000000000000
      00000000000000000000000000000000000000A0A00000FFFF00006060000060
      6000006060000060600000C0C00000C0C00000C0C00000C0C00000C0C00000A0
      A0000060600000C0C000006060000000000000A0A00000FFFF0000C0C0000060
      6000FFFFFF0000C0C000FFFFFF0000C0C00000A0A00000606000FFFFFF000060
      6000C040A00000606000C040A00000000000000000008060E0004040E0000000
      8000000080000060600000606000000000000000000000000000000000000000
      0000000080000000000000000000000000000000000000A0A00000C0C00000C0
      C00000C0C00000C0C00000A0A000006060000000000000000000000000000000
      00000000000000000000000000000000000000A0A00000FFFF0000C0C0000060
      600000C0C00000C0C00000A0A00000C0C00000A0A00000A0A00000C0C00000C0
      C00000C0C00000C0C00000C0C0000060600000A0A00000FFFF0000606000FFFF
      FF0000606000FFFFFF0000C0C00000C0C00000C0C00000C0C00000C0C00000A0
      A0000060600000C0C00000606000000000000000000000A0A0008060E0004040
      E0000000800000C0C00000A0A000006060000000000000000000000000000020
      C0000000000000000000000000000000000000A0A00000C0C00000C0C000FFFF
      FF0000C0C000FFFFFF0000C0C00000A0A0000060600000000000006060000000
      00000000000000000000000000000000000000A0A00000FFFF0000C0C00000C0
      C00000C0C00000C0C00000C0C00000C0C00000A0A00000A0A00000A0A00000A0
      A00000A0A00000A0A00000A0A00000C0C00000A0A00000FFFF0000C0C0000060
      6000FFFFFF0000C0C000FFFFFF0000C0C00000A0A00000A0A00000C0C00000C0
      C00000C0C00000C0C00000C0C0000060600000A0A00000C0C00000C0C0008060
      E0000000FF000000800000C0C00000A0A00000606000000000000000FF000020
      C0000000000000000000000000000000000000A0A00000FFFF0000C0C0000060
      6000FFFFFF0000C0C000FFFFFF0000C0C00000A0A00000606000FFFFFF000060
      6000000000000060600000000000000000000000000000A0A00000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000A0A000C040A000C040A000C040A000C040
      A000C040A00000000000000000000000000000A0A00000FFFF0000C0C00000C0
      C00000C0C00000C0C00000C0C00000C0C00000A0A00000A0A00000A0A00000A0
      A00000A0A00000A0A00000A0A00000C0C00000A0A00000FFFF0000C0C0000060
      60008060E0000000FF000000800000C0C00000A0A0000000FF000000FF000060
      60000000000000606000000000000000000000A0A00000FFFF0000606000FFFF
      FF0000606000FFFFFF0000C0C00000C0C00000C0C00000C0C00000C0C00000A0
      A0000060600000C0C0000060600000000000000000000000000000A0A00000A0
      A00000A0A00000A0A00000A0A000C040A000C040A000C040A000C040A000C040
      A00000000000000000000000000000000000C040A00000A0A00000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000A0A000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00F0FBFF00C040A0000000000000A0A00000FFFF0000606000FFFF
      FF00006060008060E0000000FF00000080000020C0000000FF0000C0C00000A0
      A0000060600000C0C000006060000000000000A0A00000FFFF0000C0C0000060
      6000FFFFFF0000C0C000FFFFFF0000C0C00000A0A00000A0A00000C0C00000C0
      C00000C0C00000C0C00000C0C000006060000000000000000000000000008020
      0000C040A000C040A000C040A000C040A00000606000C040A000C040A0000000
      000000000000000000000000000000000000C040A000F0FBFF0000A0A00000A0
      A00000A0A00000A0A00000A0A00080200000FFFFFF00FFFFFF0080200000FFFF
      FF00FFFFFF00F0FBFF00C040A0000000000000A0A00000FFFF0000C0C0000060
      6000FFFFFF0000C0C0000000FF000000FF000020C00000A0A00000C0C00000C0
      C00000C0C00000C0C00000C0C0000060600000A0A00000FFFF0000C0C00000C0
      C00000C0C00000C0C00000C0C00000C0C00000A0A00000A0A00000A0A00000A0
      A00000A0A00000A0A00000A0A00000C0C0000000000000000000C040A0000060
      6000C040A000C040A000C040A00000C0C000C040A00000000000000000000000
      000000000000000000000000000000000000C040A000F0FBFF00FFFFFF00C0C0
      C00040804000C0C0C00080200000FFFFFF00C0C0C00080200000FFFFFF008020
      0000FFFFFF00F0FBFF00C040A0000000000000A0A00000FFFF0000C0C00000C0
      C00000C0C0000020C0000000FF004040E0004040E0000000800000A0A00000A0
      A00000A0A00000A0A00000A0A00000C0C0000000000000A0A00000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000A0A0000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080808000C040
      A00000606000C040A00000C0C000C040A0000000000000000000000000000000
      000000000000000000000000000000000000C040A000F0FBFF00FFFFFF004080
      40008080800040804000FFFFFF0080200000FFFFFF00FFFFFF00C0C0C000FFFF
      FF00FFFFFF00F0FBFF00C040A000000000000000000000A0A00000FFFF0000FF
      FF000020C0000000FF000000FF0000A0A000000000004040E000000080000000
      000000000000000000000000000000000000000000000000000000A0A00000A0
      A00000A0A00000A0A00000A0A000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C0C0C000C0C0
      C000C040A00000C0C000C040A000000000000000000000000000000000000000
      000000000000000000000000000000000000C040A000F0FBFF00FFFFFF00C0C0
      C00040804000C0C0C000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00F0FBFF00C040A000000000000000000000000000000080000020
      C0000000FF000000FF0000A0A0000000000000000000000000004040E0000000
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080808000C0C0C000C0C0C000C0C0
      C00080808000C040A00000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C040A000F0FBFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00F0FBFF00C040A00000000000000000000000FF000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000004040
      E0000020C0000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000C0C0C0000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C040A000F0FBFF00F0FBFF00F0FB
      FF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FB
      FF00F0FBFF00F0FBFF00C040A00000000000000000008060E0008060E0004040
      E000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C040A000C040A000C040A000C040
      A000C040A000C040A000C040A000C040A000C040A000C040A000C040A000C040
      A000C040A000C040A000C040A000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800080000000800000008000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008000000080000000800000008000000080000000000000000000
      0000000000000000000000000000000000000000000000000000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      8000000080008080800000000000000000000000000000000000000000000000
      FF00808080000000000000000000000000000000000000000000000000000000
      0000808080008000000080000000800000008000000080000000808080000000
      0000000000000000000000000000000000000080000080000000000000000000
      0000800000000080000000800000008000000080000000800000800000008000
      0000000000000000000000000000000000000000000000000000800080008000
      8000808080000000000000000000000000000000000000000000000000008080
      80000000000000000000000000000000000000000000808000000000FF000000
      80000000800000008000808080000000000000000000000000000000FF000000
      8000000080008080800000000000000000000000000000000000000000000000
      0000800000008000000080000000808080000000000080000000800000000000
      0000000000000000000000000000000000000080000000800000800000008000
      0000008000000080000000800000008000000080000000800000008000000080
      0000800000000000000000000000000000000000000000000000800080008000
      8000800080008080800000000000000000000000000000000000800080008000
      8000808080000000000000000000000000000000FF00000080000000FF000000
      800000008000000080000000800080808000000000000000FF00000080000000
      8000000080000000800080808000000000000000000000000000000000000000
      0000800000008000000080000000808080000000000000000000808080000000
      0000000000000000000000000000000000000080000000800000008000000080
      0000008000000080000000FF000000FF000000FF000000FF0000008000000080
      0000008000008000000000000000000000000000000000000000800080008000
      8000800080008000800080808000000000000000000080008000800080008000
      8000800080008080800000000000000000000000FF0000008000000080000000
      FF00000080000000800000008000000080008080800000008000000080000000
      8000000080000000800080808000000000000000000000000000000000000000
      0000808080008000000080000000800000008080800000000000000000000000
      0000000000000000000000000000000000000080000000800000008000000080
      00000080000000FF00000000000000000000000000000000000000FF00000080
      0000008000000080000080000000000000000000000000000000000000008000
      8000800080008000800080008000808080008000800080008000800080008000
      8000800080008080800000000000000000000000FF0000008000000080000000
      80000000FF000000800000008000000080000000800000008000000080000000
      8000000080008080800000000000000000000000000000000000000000000000
      0000000000008080800080000000800000008000000080808000000000000000
      0000000000000000000000000000000000000080000000800000008000000080
      00000080000000000000000000000000000000000000000000000000000000FF
      0000008000000080000080000000000000000000000000000000000000000000
      0000800080008000800080008000800080008000800080008000800080008000
      800080808000000000000000000000000000000000000000FF00000080000000
      8000000080000000FF0000008000000080000000800000008000000080000000
      8000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000800000008000000080808000000000000000
      0000000000000000000000000000000000000080000000800000008000000080
      00000080000000800000000000000000000000000000000000000000000000FF
      0000800000008000000080000000000000000000000000000000000000000000
      0000000000008000800080008000800080008000800080008000800080008080
      80000000000000000000000000000000000000000000000000000000FF000000
      8000000080000000800000008000000080000000800000008000000080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000808080000000000000000000800000008000000080000000808080000000
      00000000000000000000000000000000000000FF000000FF000000FF000000FF
      000000FF000000FF000000FF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008000800080008000800080008000800080008000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF0000008000000080000000FF00000080000000800000008000000080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000800000008000000000000000808080008000000080000000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000008000
      0000800000008000000080000000800000000000000000000000000000000000
      0000000000000000000080008000800080008000800080008000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000080000000FF0000008000000080000000800000008000000080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000808080008000000080000000800000008000000080000000808080000000
      00000000000000000000000000000000000000FF000080000000800000008000
      0000000000000000000000000000000000000000000000FF0000008000000080
      0000008000000080000000800000800000000000000000000000000000000000
      0000000000008000800080008000800080008000800080008000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000800000008000000080008080800000008000000080000000
      8000808080000000000000000000000000000000000000000000000000000000
      0000000000008080800080000000800000008000000080808000000000000000
      00000000000000000000000000000000000000FF000000800000008000008000
      000000000000000000000000000000000000000000000000000000FF00000080
      0000008000000080000000800000800000000000000000000000000000000000
      0000800080008000800080008000808080008000800080008000800080008080
      8000000000000000000000000000000000000000000000000000000000000000
      FF0000008000000080000000800080808000000080000000FF00000080000000
      8000000080008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FF0000008000000080
      0000800000000000000000000000000000000000000080000000800000000080
      0000008000000080000000800000800000000000000000000000000000008000
      8000800080008000800080808000000000000000000080008000800080008000
      80008080800000000000000000000000000000000000000000000000FF000000
      FF000000800000008000808080000000800000008000000080000000FF000000
      8000000080000000800080808000000000000000000000000000000000000000
      0000000000000000000080808000800000008000000080808000000000000000
      0000000000000000000000000000000000000000000000FF0000008000000080
      0000008000008000000080000000800000008000000000800000008000000080
      0000008000000080000000800000800000000000000000000000000000008000
      8000800080008080800000000000000000000000000000000000800080008000
      800080008000808080000000000000000000000000000000FF00000080000000
      80000000FF0000008000000000000000FF000000800000008000000080000000
      FF00000080000000800000008000000000000000000000000000000000000000
      0000000000000000000080000000800000008000000080000000000000000000
      000000000000000000000000000000000000000000000000000000FF00000080
      0000008000000080000000800000008000000080000000800000008000000080
      000000FF000000FF000000800000800000000000000000000000000000000000
      0000800080000000000000000000000000000000000000000000000000008000
      800080008000800080000000000000000000000000000000FF00000080000000
      8000808000000000000000000000000000000000FF0000008000000080000000
      80000000FF00000080000000FF00000000000000000000000000000000000000
      0000000000000000000080000000800000008000000080000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      000000FF0000008000000080000000800000008000000080000000FF000000FF
      0000000000000000000000FF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008000800000000000000000000000000000000000000000000000FF000000
      800000000000000000000000000000000000000000000000FF00000080000000
      8000000080000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000800000008000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FF000000FF000000FF000000FF000000FF0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      80000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000808080008080800080808000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000000000000000000000000000000FFFF00000000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080000000800000008000000080000000800080808000808080008080
      8000000000000000000000000000000000000000FF0000000000000000008000
      0000FFFF0000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF0000008000000000000000000000000000000000FFFF0000FFFF008000
      0000FFFF0000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF0000008000000000FFFF0000FFFF000000000000000000000000000000
      0000000000008000200080002000800020008000200080002000800020000000
      0000000000000000000000000000000000000000000000000000000000000000
      80000000FF000000FF000000FF000000FF000000FF000000FF000000FF008080
      80008080800080808000000000000000000000000000FF000000FF0000008000
      0000FFFF0000C0C0C0000000FF00C0C0C0000000FF00C0C0C0000000FF00C0C0
      C000FF00000080000000000000000000FF0000000000FF000000FF0000008000
      0000FFFF0000C0C0C00000000000C0C0C00000000000C0C0C00000000000C0C0
      C000FF0000008000000000FFFF00000000000000000000000000000000008000
      4000800040008000400080002000800020008000200080002000800020008000
      20008000200000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF0000008000808080000000000000000000FF000000000000000000FF008000
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FF000000800000000000FF000000FF00FF00000000000000000000008000
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FF0000008000000000000000000000000000000000000000C00040008000
      4000800040008000400080004000800040008000400080004000800020008000
      20008000200080002000000000000000000000000000000080000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF00808080008080800000000000FF000000000000000000FF000000
      FF0080000000FFFF0000C0C0C0000000FF00C0C0C0000000FF00C0C0C000FFFF
      0000800000000000FF000000FF0000000000FF00000000000000000000000000
      000080000000FFFF0000C0C0C00000000000C0C0C00000000000C0C0C000FFFF
      0000800000000000000000000000000000000000000000000000C0004000C000
      4000C0004000C000400080004000800040008000400080004000800040008000
      400080002000800020000000000000000000000080000000FF000000FF000000
      FF00FFFFFF000000FF000000FF000000FF000000FF00FFFFFF00FFFFFF000000
      FF000000FF000000FF008080800000000000FF00000000000000000000000000
      FF000000FF0080000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00008000
      00000000FF000000FF000000000000000000FF00000000000000000000000000
      00000000000080000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00008000
      00000000000000000000000000000000000000000000C0204000C0204000C000
      4000C0004000C0C00000FFFF0000C0004000C0004000C0C00000FFFF00008000
      400080002000800020008000200000000000000080000000FF000000FF000000
      FF00FFFFFF00FFFFFF000000FF000000FF00FFFFFF00FFFFFF00FFFFFF000000
      FF000000FF000000FF0080808000808080000000000080000000FF000000FF00
      00000000FF008000000080000000800000008000000080000000800000008000
      00000000FF0000000000000000000000000000FFFF0080000000FF000000FF00
      000000FFFF008000000080000000800000008000000080000000800000008000
      000000FFFF0000FFFF0000FFFF0000FFFF0000000000C0204000C0204000C020
      4000C0204000C0C00000C0C00000C0004000C0004000C0C00000C0C000008000
      4000800040008000200080002000000000000000FF000000FF000000FF000000
      FF000000FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000FF000000
      FF000000FF000000FF0000008000808080000000000080000000FF000000FF00
      0000FF00000080000000000000000000FF000000FF0000000000000000008000
      00000000000000000000000000000000000000FFFF0080000000FF000000FF00
      0000FF0000008000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF008000
      000000FFFF0000FFFF0000FFFF0000FFFF0000000000C0204000C0204000C020
      4000C0204000C0C00000C0C00000C0004000C0004000C0C00000C0C000008000
      4000800040008000200080002000000000000000FF000000FF000000FF000000
      FF000000FF000000FF00FFFFFF00FFFFFF00FFFFFF000000FF000000FF000000
      FF000000FF000000FF0000008000808080000000000080000000FF000000FF00
      0000FF00000080000000C0C0C000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000FF000000FF00
      0000FF00000080000000C0C0C00000FFFF0000FFFF0000000000000000000000
      00000000000000000000000000000000000000000000C0204000C0204000C020
      4000C0204000C0C00000C0C00000C0004000C0004000C0C00000C0C000008000
      4000800040008000200080002000000000000000FF000000FF000000FF000000
      FF000000FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000FF000000FF000000
      FF000000FF000000FF0000008000808080000000000080000000FFFF0000FFFF
      0000FF000000FF000000FF0000000000FF000000FF000000000080000000FF00
      0000800000008000000000000000000000000000000080000000FFFF0000FFFF
      0000FF000000FF000000FF00000000FFFF0000FFFF000000000080000000FF00
      00008000000080000000000000000000000000000000C0206000C0204000C020
      4000C0204000C0C00000C0C00000C0004000C0004000C0C00000C0C000008000
      4000800040008000200080002000000000000000FF000000FF000000FF000000
      FF00FFFFFF00FFFFFF00FFFFFF000000FF00FFFFFF00FFFFFF000000FF000000
      FF000000FF000000FF0000008000000000000000000000000000FF000000FFFF
      0000FFFF0000FFFF0000FF0000008000000080000000FF00000080000000FF00
      0000FF000000FF00000080000000000000000000000000000000FF000000FFFF
      0000FFFF0000FFFF0000FF0000008000000080000000FF00000080000000FF00
      0000FF000000FF000000800000000000000000000000C0206000C0206000C020
      6000C0204000FFFF0000C0C00000C0204000C0204000FFFF0000C0C00000C000
      400080004000800040008000200000000000000080000000FF000000FF00FFFF
      FF00FFFFFF00FFFFFF000000FF000000FF000000FF00FFFFFF00FFFFFF000000
      FF000000FF000000FF0080808000000000000000000000000000000000008000
      00008000000080000000FFFF0000FFFF0000FFFF0000FFFF0000FF000000FFFF
      0000FFFF0000FFFF000080000000000000000000000000000000000000008000
      00008000000080000000FFFF0000FFFF0000FFFF0000FFFF0000FF000000FFFF
      0000FFFF0000FFFF000080000000000000000000000000000000C0206000C020
      6000C0206000C0204000C0204000C0204000C0204000C0204000C0004000C000
      400080004000800040000000000000000000000000000000FF000000FF000000
      FF00FFFFFF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000800000000000000000000000000000000000000000000000
      FF000000FF0080808000FF0000008000000080000000FF000000FFFF0000FFFF
      0000FF000000FF000000000000000000000000000000000000000000000000FF
      FF0000FFFF0080808000FF0000008000000080000000FF000000FFFF0000FFFF
      0000FF000000FF00000000000000000000000000000000000000C0406000C020
      6000C0206000C0206000C0204000C0204000C0204000C0204000C0004000C000
      40008000400080004000000000000000000000000000000080000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF0000000000000000000000000000000000000000000000FF000000
      FF000000000000000000000000000000FF000000FF008080800080000000FF00
      0000FF0000000000FF000000000000000000000000000000000000FFFF0000FF
      FF0000000000000000000000000000FFFF0000FFFF008080800080000000FF00
      0000FF00000000FFFF000000000000000000000000000000000000000000C040
      6000C0206000C0206000C0204000C0204000C0204000C0204000C0204000C000
      4000C00040000000000000000000000000000000000000000000000080000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      800000000000000000000000000000000000000000000000FF000000FF000000
      00000000000000000000000000000000FF000000FF0000000000000000000000
      0000000000000000FF000000FF00000000000000000000FFFF0000FFFF000000
      000000000000000000000000000000FFFF0000FFFF0000000000000000000000
      00000000000000FFFF0000FFFF00000000000000000000000000000000000000
      000000000000C0206000C0206000C0204000C0204000C0204000C02040000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000080000000FF000000FF000000FF000000FF0000008000000080000000
      000000000000000000000000000000000000000000000000FF00000000000000
      00000000000000000000000000000000FF000000FF0000000000000000000000
      000000000000000000000000FF00000000000000000000FFFF00000000000000
      000000000000000000000000000000FFFF0000FFFF0000000000000000000000
      0000000000000000000000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000800000008000
      0000800000008080000000000000000000000000000000000000000000008000
      0000800000008000000080000000000000000000000000008000000080000000
      8000000080008080000000000000000000000000000000000000000000000000
      8000000080000000800000008000000000000000000000000000000000000000
      00000000000000000000BDB1A700817972006187990028D2FA002FE7FF0028ED
      FF001FECFF0033DCFD00A8DDF000000000000000000000000000000000000000
      0000000000008000200080002000800020008000200080002000800020000000
      000000000000000000000000000000000000000000000000000000FF000000FF
      000000FF00008000000000000000000000000000000000000000000000000000
      00000080000000FF0000800000000000000000000000000000000000FF000000
      FF000000FF000000800000000000000000000000000000000000000000000000
      0000008000000000FF0000008000000000000000000000000000000000000000
      0000000000008FC9870000B01A0005AE630006E4FF001EF5FF0066F8FF0050F7
      FF003AF6FF002FF5FF0020E8FF00A8DCF0000000000000000000000000008000
      4000800040008000400080002000800020008000200080002000800020008000
      2000800020000000000000000000000000000000000000000000000000000080
      000000FF00008000000080800000000000000000000000000000000000000000
      00000080000000FF000080000000000000000000000000000000000000000080
      00000000FF000000800080800000000000000000000000000000000000000000
      0000008000000000FF0000008000000000000000000000000000CDC0B400827A
      7300857D750040A74C0000D32D0001D3EC0015F4FF007BCBFF005FABFF0057BB
      FF00489BFF003FD7FF0038F6FF0033DAFE000000000000000000C00040008000
      4000800040008000400080004000800040008000400080004000800040008000
      2000800020008000200000000000000000000000000000000000000000000080
      000000FF00000080000080000000000000000000000000000000000000008080
      000000FF00008080000080800000000000000000000000000000000000000080
      00000000FF000080000000008000000000000000000000000000000000008080
      00000000FF0080800000808000000000000000000000A8D5A2000AAC340006B8
      3400449A4D00309A3F0000D635001CEAFF00ADFBFF008DBDFF00A6FBFF0094FA
      FF0074F9FF003AB9FF003BF6FF0023ECFF000000000000000000C0004000C000
      4000C0004000C0004000C0004000C0C00000FFFF000080004000800040008000
      4000800020008000200000000000000000000000000000000000000000000000
      00008080000000FF000000FF00008000000080000000808000000080000000FF
      0000800000008080000000000000000000000000000000000000000000000000
      00000000FF000000FF0000008000808000000000000000000000808000000080
      00000000FF000000800000000000000000000000000013B9440000E4560000E2
      500000C93B001A91290000D2380000E9FF00C9FCFF00D8FDFF00C1FCFF00AFFB
      FF008CFAFF0062F8FF004EF7FF0021ECFF0000000000C0204000C0204000C000
      4000C0004000C0004000C0004000C0C00000C0C00000C0004000800040008000
      4000800040008000200080002000000000000000000000000000000000000000
      0000000000000080000000FF000000FF00000080000000800000008000008000
      0000808000000000000000000000000000000000000000000000000000000000
      000000000000008000000000FF000000FF0000800000008000000000FF000000
      8000808000000000000000000000000000000000000013BB480000E85E0000E5
      570000E2500000BB330000B5340034E9FF00D2FDFF00F6FFFF0000000000C4FC
      FF000000000073F8FF0045F6FF0000E7FF0000000000C0204000C0204000C020
      4000C0204000C0004000C0004000C0C00000C0C00000C0004000800040008000
      4000800040008000200080002000000000000000000000000000000000000000
      000000000000000000008080000000FF000000FF000000FF0000008000000080
      0000808000008000000080800000000000000000000000000000000000000000
      00000000000000000000808000000000FF000000FF000000FF00008000000080
      00008080000000008000000000000000000000000000A8D6A50021B1480000D8
      520000E5580000D05A00009C9A000FD1F90050F7FF00FAFFFF00F2FEFF00D1FD
      FF00ADFBFF008AF9FF004FF7FF0024CCF60000000000C0204000C0204000C020
      4000FFFF0000C0C00000C0C00000C0C00000C0C00000C0C00000C0C00000C0C0
      0000800040008000200080002000000000000000000000000000800000008000
      00008000000080000000808000008080000000FF000000FF0000800000000000
      00008080000000FF000080000000000000000000000000000000000080000000
      8000000080000000800080800000808000000000FF000000FF00000080000000
      0000808000000000FF00000080000000000000000000C1CBB100368A450013A0
      370000B13500009C8A0000EBEA0000F5FF0028E0FF0051F7FF00B3FBFF00AFFB
      FF005EF7FF004EF7FF0014E6FE0087AAB70000000000C0204000C0204000C020
      4000C0C00000C0C00000C0C00000C0C00000C0C00000C0C00000C0C00000FFFF
      00008000400080002000800020000000000000000000000000008080000000FF
      000000FF000000800000800000008080000000FF000000800000800000000000
      00008080000000FF000080000000000000000000000000000000808000000000
      FF000000FF000080000000008000808000000000FF0000800000000080000000
      0000808000000000FF000000800000000000C3DFBA0007BE4E0000F1730000EE
      6D0000EB6600009F980000FFFF0000FFFF0000F5FF0020D5FB0075EBFE0094F6
      FF0057EFFF002ED6EC004BB193000000000000000000C0206000C0204000C020
      4000C0204000C0004000C0004000C0C00000C0C00000C0004000C00040008000
      4000800040008000200080002000000000000000000000000000000000000000
      00008080000000FF0000008000008000000000FF000000FF0000800000008000
      00000080000000FF000080000000000000000000000000000000000000000000
      0000808000000000FF0000800000000080000000FF000000FF00000080000000
      8000008000000000FF0000008000000000008FD0980000EE790000F47B0000F1
      740000E6660000A57C0000C7C70000FFFF0000FFFF0000A6A50000A632000898
      2000349D420052815000CDC0B4000000000000000000C0206000C0206000C020
      6000C0204000C0004000C0004000C0C00000C0C00000C0004000C0004000C000
      4000800040008000400080002000000000000000000000000000000000000000
      0000000000000000000000000000008000000080000000FF000000FF000000FF
      0000800000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000800000008000000000FF000000FF000000
      FF0000008000000000000000000000000000000000003BC26A002FD2730000AF
      3D0000BF490000E7680000A37E0000A5A20000A19C0000C3710000E14D0000D7
      43000BA5290069986500857D7500DCCFC2000000000000000000C0206000C020
      6000C0206000C0204000C0204000FFFF0000C0C00000C0204000C0004000C000
      4000800040008000400000000000000000000000000000000000000000000000
      000000000000000000000000000000000000008000000080000000FF00008000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000800000008000000000FF000000
      800000000000000000000000000000000000000000000000000035B95F0000EE
      7B0000F57D0000EA6F00009C290000EC690000C1430000C03E0000E4550000E1
      4F0000DE480006B62F007A987200BDB1A7000000000000000000C0406000C020
      6000C0206000C0206000C0204000C0204000C0204000C0204000C0004000C000
      4000800040008000400000000000000000000000000000000000000000000000
      0000000000000000000000000000800000008000000000FF0000800000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000008000000080000000FF00000080000000
      000000000000000000000000000000000000000000000000000000D86D0000FA
      8A0000EF7C0020A348000AC8560000EF700000ED690012912A0000D04B0000E4
      560000E14F0000DF490047874B00EEDED100000000000000000000000000C040
      6000C0206000C0206000C0204000C0204000C0204000C0204000C0204000C000
      4000C00040000000000000000000000000000000000000000000000000000000
      00000000000000000000000000008080000000FF000000800000800000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808000000000FF0000800000000080000000
      000000000000000000000000000000000000000000000000000045C371002FD6
      7C004FC171000000000000D25E0000F2770000F071003BAB5C0049A35B000AC0
      450000DC510014A93600E0E6CA00000000000000000000000000000000000000
      000000000000C0206000C0206000C0204000C0204000C0204000C02040000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000008080000000FF000000FF0000800000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808000000000FF000000FF00000080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000D5640000F57E0000F378002EA05300BDB1A700E0E7
      CB008FCC90000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080000080800000808000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080000080800000808000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000045C26E0000CC5C0000C24F008FCF9500000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000020C0000020C0000020C0000020C0000020C0000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000020C0000020C0004020E0004020E0004020E0004020E0004020E0000020
      C0000020C0000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008000200080002000800020008000200080002000800020000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008000200080002000800020008000200080002000800020000000
      0000000000000000000000000000000000000020C00000000000000000000020
      C0004040E0004040E0004040E0004040E0004040E0004040E0004040E0004040
      E0004040E0000020C00000000000000000000000000000000000000000000000
      0000000000000000000000000000C0C0C0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      4000800040008000400080002000800020008000200080002000800020008000
      2000800020000000000000000000000000000000000000000000000000008000
      4000800040008000400080002000800020008000200080002000800020008000
      2000800020000000000000000000000000000020C0000020C0000020C0004040
      E0004040E0004040E0008080E0008080E0008080E0008080E0008080E0004040
      E0004040E0004040E0000020C00000000000000000000000000000FFFF000000
      00000000000000FFFF0000000000000000000000000000FFFF00000000000000
      000000FFFF000000000000000000000000000000000000000000C00040008000
      4000800040008000400080004000800040008000400080004000800020008000
      2000800020008000200000000000000000000000000000000000C00040008000
      4000800040008000400080004000800040008000400080004000800020008000
      2000800020008000200000000000000000000020C0004040E0004040E0004040
      E0004040E0008080E00000000000000000000000000000000000000000008080
      E0004040E0004040E0004040E0000020C00000000000000000000000000000FF
      FF0000FFFF0000FFFF000000000000FFFF000000000000FFFF0000FFFF0000FF
      FF00000000000000000000000000000000000000000000000000C0004000C0C0
      0000FFFF0000C0004000C0C00000FFFF00008000400080004000C0C00000FFFF
      0000800020008000200000000000000000000000000000000000C0004000C000
      4000C0004000FFFF000080004000800040008000400080004000800040008000
      4000800020008000200000000000000000000020C0004060E0004060E0004060
      E0008080E0000000000000000000000000000000000000000000000000000000
      00008080E0004060E0004060E0000020C00000000000000000000000000000FF
      FF0000FFFF0000FFFF0000000000FFFFFF000000000000FFFF0000FFFF0000FF
      FF000000000000000000000000000000000000000000C0204000C0204000C0C0
      0000C0C00000C0004000C0C00000C0C00000C0004000C0004000C0C00000C0C0
      00008000400080002000800020000000000000000000C0204000C0204000C000
      4000FFFF0000C0C00000C0004000C00040008000400080004000800040008000
      4000800020008000200080002000000000000020C0008060E0008060E0008080
      E000000000000000000000000000000000000000000000000000000000000000
      00008080E0008080E0008080E0008080E000000000000000000000FFFF0000FF
      FF0000FFFF0000000000FFFFFF0080808000FFFFFF000000000000FFFF0000FF
      FF0000FFFF0000000000000000000000000000000000C0204000C0204000C0C0
      0000C0C00000C0204000C0C00000C0C00000C0004000C0004000C0C00000C0C0
      00008000400080004000800020000000000000000000C0204000C0204000FFFF
      0000C0C00000C0C00000C0004000C0004000C000400080004000800040008000
      4000800040008000200080002000000000008080E0008080E0008080E0008080
      E0008080E0000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF0000FF
      FF0000000000FFFFFF0000FFFF008080800000FFFF00FFFFFF000000000000FF
      FF0000FFFF0000000000000000000000000000000000C0204000C0204000C0C0
      0000C0C00000C0C00000C0C00000C0C00000C0004000C0004000C0C00000C0C0
      00008000400080004000800020000000000000000000C0204000FFFF0000C0C0
      0000C0C00000C0C00000FFFF0000C0C00000C0C00000C0C00000C0C00000C0C0
      0000C0C000008000200080002000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000020
      C0000020C0000020C0000020C0000020C00000FFFF0000FFFF0000FFFF0000FF
      FF000000000000FFFF00FFFFFF0080808000FFFFFF0000FFFF000000000000FF
      FF0000FFFF0000FFFF0000FFFF000000000000000000C0204000C0204000C0C0
      0000FFFF0000C0204000C0C00000C0C00000C0004000C0004000C0C00000C0C0
      00008000400080004000800020000000000000000000C0204000C0C00000C0C0
      0000C0C00000C0C00000C0C00000C0C00000C0C00000C0C00000C0C00000C0C0
      0000FFFF00008000200080002000000000000020C0000020C0000020C0000020
      C000000000000000000000000000000000000000000000000000000000000000
      00000020C0004020E0004020E0000020C000000000000000000000FFFF0000FF
      FF0000000000FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF000000000000FF
      FF0000FFFF0000000000000000000000000000000000C0206000C0204000C0C0
      0000C0C00000C0204000C0C00000C0C00000C0204000C0204000FFFF0000C0C0
      0000C0204000C0204000800020000000000000000000C0206000C0204000C0C0
      0000C0C00000C0C00000C0004000C0004000C0004000C0004000C00040008000
      4000800040008000200080002000000000000020C0004040E0004040E0000020
      C000000000000000000000000000000000000000000000000000000000000020
      C0004040E0004040E0004040E0000020C000000000000000000000FFFF0000FF
      FF0000FFFF0000000000FFFFFF0000FFFF00FFFFFF000000000000FFFF0000FF
      FF0000FFFF0000000000000000000000000000000000C0206000C0204000C020
      6000C0C00000C0C00000C0C00000C0C00000FFFF0000C0C00000C0C00000C0C0
      0000C0C00000C0C00000800020000000000000000000C0206000C0206000C020
      6000C0C00000C0C00000C0004000C0004000C0004000C0004000C0004000C000
      4000800040008000400080002000000000008080E0004040E0004040E0004040
      E0000020C00000000000000000000000000000000000000000000020C0004040
      E0004040E0004040E0004040E0000020C00000000000000000000000000000FF
      FF0000FFFF0000FFFF0000000000000000000000000000FFFF0000FFFF0000FF
      FF00000000000000000000000000000000000000000000000000C0206000C020
      6000C0206000FFFF0000C0C00000C0C00000C0C00000C0C00000C0C00000C0C0
      0000C0C00000FFFF000000000000000000000000000000000000C0206000C020
      6000C0206000C0C00000C0204000C0204000C0204000C0204000C0004000C000
      400080004000800040000000000000000000000000008080E0004040E0004040
      E0004040E0000020C0000020C0000020C0000020C0000020C0004040E0004040
      E0004040E0008080E0008080E0000020C00000000000000000000000000000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF00000000000000000000000000000000000000000000000000C0406000C020
      6000C0206000C0206000C0204000C0204000C0204000C0204000C0004000C000
      4000800040008000400000000000000000000000000000000000C0406000C020
      6000C0206000C0206000C0204000C0204000C0204000C0204000C0004000C000
      40008000400080004000000000000000000000000000000000008080E0004060
      E0004060E0004060E0004060E0004060E0004060E0004060E0004060E0004060
      E0008080E00000000000000000008080E000000000000000000000FFFF000000
      00000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00000000000000
      000000FFFF00000000000000000000000000000000000000000000000000C040
      6000C0206000C0206000C0204000C0204000C0204000C0204000C0204000C000
      4000C0004000000000000000000000000000000000000000000000000000C040
      6000C0206000C0206000C0204000C0204000C0204000C0204000C0204000C000
      4000C00040000000000000000000000000000000000000000000000000008080
      E0008080E0008060E0008060E0008060E0008060E0008060E0008080E0008080
      E000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C0206000C0206000C0204000C0204000C0204000C02040000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C0206000C0206000C0204000C0204000C0204000C02040000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080E0008080E0008080E0008080E0008080E000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      C8005F5F5F0059A1A10063A5A50000151500000000000000000000000E000000
      DF0000004D000000000032323700000000000000000000000000626262000000
      0000000000000000000000000000000000000000000000000000626262000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C0C0C000A4A0A000808080008080800080808000808080008080
      8000A4A0A000A4A0A00000000000000000000000000000000000000000000000
      6900B1B1B10071717100476E6E0000ACAC00000000000A0A0A00151529000000
      FF0000007200000000000000690000006B000000000000000000565656000000
      0000000000000000000000000000000000000000000000000000565656000000
      0000000000003E3E3E0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800080808000A4A0A0000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C0C0C000A4A0A00080808000808080008080800080808000808080008080
      80008080800080808000A4A0A0000000000000000000000000000000AD000000
      6900003B3B00636363003F3F3F00004F4F000000000008080800111125000000
      FF000000FF0000000000000069000000D70000000000000000007A7A7A00D4FF
      FF00000000000000000000FFFF000000000000000000000000007A7A7A000000
      0000000000005656560000000000000000000000000000000000000000000000
      0000000000000000000000000000406080004040400040404000C0C0C0000000
      0000000000000000000000000000000000000000000000000000000000004000
      E0004000E0004000E0004000E0004000E0004000E0004000E0004000E0008080
      8000808080008080800080808000A4A0A0000000000000001C000000FF000000
      BC003737A9000000FF002727F2004D4DBF000000A0000000FF0000005B000000
      FF000000FF00000084000000FF000000FF0000000000000000006E6E6E0000FF
      FF00000000000000000000FFFF000000000000000000000000007A7A7A006E6E
      6E00000000007A7A7A0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C0A0E00000000000000000000000
      00000000000000000000000000000000000000000000000000004000E0004000
      E0004000E0004000E0004000E0004000E0004000E0004000E0004000E0004000
      E000808080008080800080808000A4A0A0000000000000001C000000FF000000
      69000000FF000000FF000000FF000000FF00000056000000FF0000005B000000
      FF000000FF00000084000000FF000000FF00000000007A7A7A006E6E6E000000
      00007A7A7A007A7A7A00FF8EFF007A7A7A007A7A7A00000000007A7A7A006E6E
      6E00000000007A7A7A006E6E6E00000000000000000000000000000000000000
      00000000000000000000C0C0C000C0A0E000C0A0E00040204000000000000000
      000000000000000000000000000000000000000000004000E0004000E0004000
      E0004000E0004000E0004000E0004000E0004000E0004000E0004000E0004000
      E0004000E0008080800080808000808080000000000000001C000000FF000000
      69000000FF000000FF000000FF000000FF000000D1000000AF000000F2000000
      FF000000FF00000084000000FF000000FF00000000007A7A7A006E6E6E007A7A
      7A007A7A7A007A7A7A007A7A7A00000000007A7A7A0000000000868686007A7A
      7A00000000007A7A7A006E6E6E00000000000000000000000000000000000000
      0000000000000000000040204000C0A0E0008080800080808000808080008080
      8000000000000000000000000000000000004000E0004000E0004000E0004000
      E0004000E0004000E0004000E0004000E0004000E0004000E0004000E0004000
      E0004000E0004000E000808080008080800000000000000016000000CC000000
      5400141488002D2D50002B2B4E0027274A000505C4000000CA0000009D000000
      CD000000FF00000082000000FF000000EF00000000007A7A7A006E6E6E007A7A
      7A007A7A7A007A7A7A007A7A7A00626262007A7A7A007A7A7A00868686006E6E
      6E0000000000868686006E6E6E00000000000000000000000000000000000000
      0000000000008080800040608000C0A0E0000000000000000000000000008080
      8000A4A0A0000000000000000000000000004000E0004000E000F0FBFF00F0FB
      FF004000E000F0FBFF004000E000F0FBFF004000E000F0FBFF004000E000F0FB
      FF004000E0004000E0004000E000808080000000000016161600CCC3CC005400
      54007979790093939300B0B0B000D2D2D2001A1A46000500C3009D7A9D00C9BC
      CA000000A40000007B000000FF0000009700000000007A7A7A006E6E6E006262
      62000000000000000000000000004E4EA8000000FF007A7A7A00868686006E6E
      6E00000000007A7A7A0058588A000000FF000000000000000000000000000000
      00008080800000000000404040004020400040608000C0A0E000C0A0E0000000
      0000000000000000000000000000000000004000E0004000E000F0FBFF004000
      E0004000E000F0FBFF008060E000F0FBFF004000E000F0FBFF004000E000F0FB
      FF004000E0004000E0004000E000808080000000000008080800555155002608
      26001C1C7F0035354A0035354A0035354A000707A9000D0331005B145B004D33
      50000000DF000000DA000000F7000000000000000000FFB1FF00FF6BFF000000
      000000000000FFFFFF00FFFFFF00000000002F2FB3000000FF00FFB1FF006E6E
      6E00868686006E6E6E000000FF0070708E000000000000000000000000004020
      400080A0C00040404000C0A0E000C0A0E000C0A0E000C0A0E000C0A0E0004020
      4000808080000000000000000000000000004000E0004000E000F0FBFF00F0FB
      FF004000E0008060E000F0FBFF004000E0004000E000F0FBFF004000E000F0FB
      FF004000E0004000E0004000E000808080000000000014141400DDDDDD006868
      68000000FD000000FF000000FF000000FF000000FF0023235600FBFBFB00BEBE
      BF000202B7000000FF000000950000008F000000000000000000000000006262
      620000000000000000000000000062626200000000000000AE000000FF007A7A
      7A00868686000000FF0000006E000000000000000000000000000000000080A0
      C000402040008080800040404000404040004040400040404000406080004020
      4000808080000000000000000000000000004000E0004000E000F0FBFF004000
      E0004000E000F0FBFF00F0FBFF00F0FBFF004000E000F0FBFF004000E000F0FB
      FF004000E0004000E0004000E000A4A0A00000000000A7A7A700000000003F3F
      3F0000003B00000072000000720000007200000072000000880000008D000404
      3800727272000000FF00000069000000AD0000000000E6E6E600FFFFFF009292
      92009292920092929200929292009292920000000000FFFFFF000000FF003535
      C4002424CE000000FF00A4A0A00000000000000000000000000000000000C0A0
      E0004040400080A0C000C0A0E000C0A0E000C0A0E000C0A0E000C0A0E0004060
      8000A4A0A0000000000000000000000000004000E0004000E000F0FBFF00F0FB
      FF004000E000F0FBFF004000E000F0FBFF004000E000F0FBFF00F0FBFF00F0FB
      FF00F0FBFF004000E0004000E000A4A0A0000000000000000000000000000000
      00000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FD000000C4000000C40036366D00000000000000000000000000000000000000
      0000000000000000000000000000000000006E6E6E006E6E6E00000000000000
      FF000000FF00000000000000000000000000000000000000000000000000C0A0
      E00040204000C0A0E00080A0C000404040000000000000000000000000000000
      0000808080000000000000000000000000004000E0004000E0004000E0004000
      E0004000E0004000E0004000E0004000E0004000E0004000E0004000E0004000
      E0004000E0004000E0004000E000C0C0C0000000000000000000000000000000
      000000004E000000FF000000FF000000FF000000FF000000FF000000FF000000
      FD000000960000000000000069000000CF00000000000000000000000000AAAA
      AA0086868600868686007A7A7A007A7A7A007A7A7A007A7A7A00696973000000
      FF000000FF0000003B0000000000000000000000000000000000000000004020
      40008080800040606000C0A0E000C0A0E000C0A0E000C0A0E000C0A0E0004040
      4000000000000000000000000000000000004000E0004000E0004000E0004000
      E0004000E0004000E0004000E0004000E0004000E0004000E0004000E0004000
      E0004000E0004000E000C0C0C000000000000000000000000000000000000000
      00000000000000000C00000047000000AD000000AD000000AD000909AA002D2D
      39000000000000000000000000000000A5000000000000000000000000000000
      0000AAAAAA00AAAAAA00AAAAAA008686860086868600868686000000FF000000
      4600000000000000FF00B3B3C300000000000000000000000000000000000000
      000040404000C0A0E000C0A0E000406080000000000040204000406080004020
      400000000000000000000000000000000000000000004000E0004000E0004000
      E0004000E0004000E0004000E0004000E0004000E0004000E0004000E0004000
      E0004000E000C0C0C00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000161616000000FF004523B9000000
      00000000000072728C000000FF00000000000000000000000000000000000000
      000000000000808080004020400080A0C000C0A0E000C0A0E000000000000000
      00000000000000000000000000000000000000000000000000004000E0004000
      E0004000E0004000E0004000E0004000E0004000E0004000E0004000E0004000
      E000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007B0789000000FF00000000000000
      000000000000000000005D5DA1000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004000
      E0004000E0004000E0004000E0004000E0004000E0004000E0004000E0000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000E00000000100010000000000000700000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000E8A2000000000000EAAA000000000000
      E8A2000000000000FFFF000000000000F07F000000000000C03F000000000000
      801F000000000000001D00000000000000190000000000000010000000000000
      0019000000000000001900000000000000310000000000008063000000000000
      C1FF000000000000FFFF000000000000FC7FC003E0C5FFFFF81F8003E084FFCB
      F0078003C084F807E00180038000C00FC0008003800040078000800380004003
      0000800380000007000080038000000F00018003800100070003800380000003
      00078003A0000007800F8003F001000FE01F8003F0041007F83F8007F80EF803
      FE7F800FFFFFFC07FFFF801FFFFFFFFFFFFFC03FC003FFFF0000801FC003FFFF
      0000800FC003C3FF0000800FC003E7FF0000C00FC003E7FF0000E00FC003E7FF
      0000F000C003E7FF0000F000C003E7C70000F0008003E0070000F4008003E007
      0000FE008003E0070000FF808007E0070000FF80800FE0070000FF80801FE007
      0000FF8183FFE83FFFFFFF83C7FFFFFFFFFFFCCFFFF8FFF9C003F807FFF0FFF0
      8003F807FFF0E0008003F807FFE1C0008003F807FFC7C00080030007F18FC000
      80030003C01FC00080030003803F800080030003803F800080030003001F0000
      80030003001F000080030002001F000080070000803F8000800F0000803F8001
      801F0001C07FC07FFFFF0003F1FFF1FFFFFFFFFFFE67FC00FF7FF0010000FE01
      FC1FE0010000FC01F007E0010000F801E003E0010000F001C001C0010000E001
      8000C0010000C0078000C001000080078000C001000000038000000100000001
      C000800100000001E000C00100008001F800E0030000C001FC00E0070000E000
      FC00E00F0000F000FF00FFFFFE00FBFFCF9FE0039CFFFFFF870FC0010801FFFF
      870FC00108018007870FC001087F8003870FC00908018001870FC00100008000
      870FC001904C8000CF0FC001904C8000CF0FC001904C8000879FC00104CC8000
      879FC00100CC8000870EC001081CC000F200C0019001E000F000C0018003F000
      F001C0018007F00FF003C003801FF01FFFFFFFFFFFFFFFFFFFFFFFFFFFFFC1FF
      FFFFFFFFFFFF80FF0000C7FF8001005F000083F38001000B000092F380010001
      00009EE78001000000009FE78001000000009ECF8001005F000092CF8001000B
      0000839F800100010000C79F800100000000FFFF800100000000FFFF800180FF
      FFFFFFFFFFFFC1FFFFFFFFFFFFFFFFFFFFFFC1F1FFFFFFFFFFFF80C0C1FFFFFF
      FFFF000080FFDFFFFFFF000000008FFFC1FF0001000081F780FF0000000080EF
      005F00000000004F000B80070000000B0001C00F000000010000E01F00000000
      0000C07F0000000080FFC0FF0000809FC1FF81FF0000C1CFFFFF03FF000087E7
      FFFF8FFF00008FFBFFFFDFFF0001FFFFF83FF83FCFFFC3E7F01F300FC7EF81C3
      F09F0007C3C70081F0DF0003C1830001F07F03C1E0030003F83F07E1F0078007
      FC3F03E1F80FC00FF61F01FFF81FE00FF21FFFC0FC1FF00FF01F0F80F81FF007
      F83F0FC0F00FE003FFFF8780E187C001FC3F8000E3C38201FC3FC000F7E38701
      FC3FE00DFFF7CF87FC3FF83FFFFFFFC7FC3FE003A003F81FF00F60038000E007
      E00380028001C003C003400060038001800140017007800100016003780F0000
      00008007000000000000826F00000000000081FF807F00000000804380430000
      0001C001C00100000001E001E00180018003E003E00380018007CE03CE03C003
      C00F9E799E79E007F01FBE7DBE7DF81FF81F83E183E1FC01E007C3F1C3F1F800
      C003E1F1E1F1C0008001E1E1E1E180008001F003F0C380000000F807F8078000
      0000FC01FC0380000000C011C01180000000C011C01100010000F001F0010001
      0000FE07FE0780008001FF0FFF0FC0008001FE1FFE1FC000C003FE1FFE1FC401
      E007FE1FFE1FFC07F81FFF1FFF1FFC3FFC1FFEFFF81FF81FF007FC7FE007E007
      6003FC7FC003C0030001D8378001800103E0E00F8001800107F0E00F00000000
      0FF0C0070000000007FFC00700000000FFE00001000000000FF0C00700000000
      0FE0C0070000000007C0E00F800180018000E00F80018001C006D837C003C003
      E00FFEFFE007E007F83FFEFFF81FF81FE0C5CF8FFFFFF803E084C309FF1FF001
      C084C109FE1FE00080008109FE3FC00080008001FC3F800080008001FC0F0000
      80008001F807000080008000F00F000080018000E007000080008001E0070000
      A0008000E0070000F0010004E0070000F004E001E00F0001F80EF009F00F8003
      FFFFFC19F81FC00FFFFFFF3CFFFFE01F00000000000000000000000000000000
      000000000000}
  end
  object ilTray: TImageList
    Height = 7
    Masked = False
    Width = 5
    Left = 573
    Top = 290
    Bitmap = {
      494C010103000400040005000700FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000140000000700000001002000000000003002
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF000000FF000000000000FF000000FF000000FF000000FF000000000000C0C0
      C000C0C0C000C0C0C000C0C0C000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000000000FF000000FF
      000000FF000000FF000000000000C0C0C000C0C0C000C0C0C000C0C0C0000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF000000FF000000000000FF000000FF000000FF000000FF000000000000C0C0
      C000C0C0C000C0C0C000C0C0C000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000000000FF000000FF
      000000FF000000FF000000000000C0C0C000C0C0C000C0C0C000C0C0C0000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF000000FF000000000000FF000000FF000000FF000000FF000000000000C0C0
      C000C0C0C000C0C0C000C0C0C000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000000000FF000000FF
      000000FF000000FF000000000000C0C0C000C0C0C000C0C0C000C0C0C0000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000424D3E000000000000003E00000028000000140000000700000001000100
      000000001C0000000000000000000000000000000000000000000000FFFFFF00
      840000008400000084000000840000008400000084000000FFC0000000000000
      000000000000000000000000000000000000}
  end
end
