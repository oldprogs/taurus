object NodeWizzardForm: TNodeWizzardForm
  Left = 239
  Top = 157
  HelpContext = 2200
  Anchors = [akTop, akRight]
  BorderStyle = bsDialog
  BorderWidth = 6
  Caption = 'Node Inspector'
  ClientHeight = 357
  ClientWidth = 643
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    643
    357)
  PixelsPerInch = 96
  TextHeight = 14
  object lPsw: TLabel
    Left = 16
    Top = 218
    Width = 50
    Height = 14
    Alignment = taRightJustify
    Caption = 'Password'
  end
  object lPostProc: TLabel
    Left = 17
    Top = 242
    Width = 50
    Height = 14
    Alignment = taRightJustify
    Caption = 'Post-proc.'
    FocusControl = ePostProc
  end
  object gbNodelist: TGroupBox
    Left = 272
    Top = 0
    Width = 287
    Height = 105
    Anchors = [akTop, akRight]
    Caption = 'Nodelist Information'
    TabOrder = 5
    object llStat: TLabel
      Left = 25
      Top = 14
      Width = 36
      Height = 14
      Alignment = taRightJustify
      Caption = 'Station:'
    end
    object llSysop: TLabel
      Left = 25
      Top = 28
      Width = 36
      Height = 14
      Alignment = taRightJustify
      Caption = 'SysOp:'
    end
    object llSite: TLabel
      Left = 17
      Top = 42
      Width = 44
      Height = 14
      Alignment = taRightJustify
      Caption = 'Location:'
    end
    object llPhn: TLabel
      Left = 26
      Top = 56
      Width = 35
      Height = 14
      Alignment = taRightJustify
      Caption = #39'Phone:'
    end
    object llSpd: TLabel
      Left = 27
      Top = 70
      Width = 34
      Height = 14
      Alignment = taRightJustify
      Caption = 'Speed:'
    end
    object llFlags: TLabel
      Left = 32
      Top = 84
      Width = 29
      Height = 14
      Alignment = taRightJustify
      Caption = 'Flags:'
    end
    object llWrkTimeUTC: TLabel
      Left = 125
      Top = 70
      Width = 56
      Height = 14
      Alignment = taRightJustify
      Caption = 'Time (UTC):'
      ParentShowHint = False
      ShowHint = True
    end
    object lStation: TEdit
      Left = 64
      Top = 14
      Width = 169
      Height = 13
      TabStop = False
      BorderStyle = bsNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentColor = True
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
    end
    object lSysop: TEdit
      Left = 64
      Top = 28
      Width = 215
      Height = 13
      TabStop = False
      BorderStyle = bsNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentColor = True
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
    end
    object lLocation: TEdit
      Left = 64
      Top = 42
      Width = 215
      Height = 13
      TabStop = False
      BorderStyle = bsNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentColor = True
      ParentFont = False
      ReadOnly = True
      TabOrder = 2
    end
    object lPhone: TEdit
      Left = 64
      Top = 56
      Width = 215
      Height = 13
      TabStop = False
      BorderStyle = bsNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentColor = True
      ParentFont = False
      ReadOnly = True
      TabOrder = 3
    end
    object lSpeed: TEdit
      Left = 64
      Top = 70
      Width = 49
      Height = 13
      TabStop = False
      BorderStyle = bsNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentColor = True
      ParentFont = False
      ReadOnly = True
      TabOrder = 4
    end
    object lWrkTimeUTC: TEdit
      Left = 182
      Top = 70
      Width = 97
      Height = 13
      TabStop = False
      AutoSize = False
      BorderStyle = bsNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentColor = True
      ParentFont = False
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 5
    end
    object lFlags: TEdit
      Left = 64
      Top = 84
      Width = 215
      Height = 13
      TabStop = False
      AutoSize = False
      BorderStyle = bsNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentColor = True
      ParentFont = False
      ReadOnly = True
      TabOrder = 6
    end
    object lStatus: TEdit
      Left = 232
      Top = 14
      Width = 41
      Height = 13
      TabStop = False
      BorderStyle = bsNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentColor = True
      ParentFont = False
      ReadOnly = True
      TabOrder = 7
    end
  end
  object gbNodeOvr: TGroupBox
    Left = 272
    Top = 108
    Width = 369
    Height = 65
    Anchors = [akTop, akRight]
    Caption = 'Node Overrides'
    TabOrder = 6
    object lDupOvr: TLabel
      Left = 14
      Top = 17
      Width = 33
      Height = 14
      Alignment = taRightJustify
      Caption = 'Dial-up'
      FocusControl = eDupOvr
    end
    object lIpOvr: TLabel
      Left = 17
      Top = 40
      Width = 30
      Height = 14
      Alignment = taRightJustify
      Caption = 'TCP/IP'
      FocusControl = eIpOvr
    end
    object eDupOvr: TEdit
      Left = 52
      Top = 14
      Width = 261
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object bEditDupOvr: TButton
      Left = 316
      Top = 15
      Width = 45
      Height = 22
      Caption = 'Edit'
      TabOrder = 1
      OnClick = bEditDupOvrClick
    end
    object eIpOvr: TEdit
      Left = 52
      Top = 37
      Width = 261
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object bEditIpOvr: TButton
      Left = 316
      Top = 38
      Width = 45
      Height = 22
      Caption = 'Edit'
      TabOrder = 3
      OnClick = bEditIpOvrClick
    end
  end
  object gbRest: TGroupBox
    Left = 416
    Top = 176
    Width = 137
    Height = 181
    Anchors = [akTop, akRight]
    Caption = 'Present in restrictions'
    TabOrder = 8
    object lIpRest: TLabel
      Left = 12
      Top = 133
      Width = 30
      Height = 14
      Caption = 'TCP/IP'
      FocusControl = lbIpRest
    end
    object lDialRest: TLabel
      Left = 12
      Top = 20
      Width = 33
      Height = 14
      Caption = 'Dial-up'
      FocusControl = lbDialRest
    end
    object lbDialRest: TListBox
      Left = 10
      Top = 40
      Width = 119
      Height = 81
      ItemHeight = 14
      TabOrder = 1
      OnDblClick = bEditDialRestClick
    end
    object bEditDialRest: TButton
      Left = 82
      Top = 17
      Width = 45
      Height = 22
      Caption = 'Edit'
      TabOrder = 0
      OnClick = bEditDialRestClick
    end
    object lbIpRest: TListBox
      Left = 10
      Top = 152
      Width = 119
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Fixedsys'
      Font.Style = []
      ItemHeight = 16
      ParentFont = False
      TabOrder = 3
      OnDblClick = bEditIpRestClick
    end
    object bEditIpRest: TButton
      Left = 82
      Top = 129
      Width = 45
      Height = 22
      Caption = 'Edit'
      TabOrder = 2
      OnClick = bEditIpRestClick
    end
  end
  object gbEncLink: TGroupBox
    Left = 560
    Top = 176
    Width = 81
    Height = 105
    Anchors = [akTop, akRight]
    Caption = 'Encrypted'
    TabOrder = 9
    DesignSize = (
      81
      105)
    object bElSet: TButton
      Left = 9
      Top = 18
      Width = 64
      Height = 22
      Anchors = [akTop, akRight]
      Caption = 'Set'
      TabOrder = 0
      OnClick = bElSetClick
    end
    object bElChange: TButton
      Left = 9
      Top = 45
      Width = 64
      Height = 22
      Anchors = [akTop, akRight]
      Caption = 'Change'
      TabOrder = 1
      OnClick = bElChangeClick
    end
    object bElRemove: TButton
      Left = 9
      Top = 72
      Width = 64
      Height = 22
      Anchors = [akTop, akRight]
      Caption = 'Remove'
      TabOrder = 2
      OnClick = bElRemoveClick
    end
  end
  object gbAkas: TGroupBox
    Left = 272
    Top = 176
    Width = 137
    Height = 181
    Anchors = [akTop, akRight]
    Caption = 'Present in AKAs'
    TabOrder = 7
    object lIpAKA: TLabel
      Left = 12
      Top = 133
      Width = 30
      Height = 14
      Caption = 'TCP/IP'
      FocusControl = lbIpAKA
    end
    object lDialAKA: TLabel
      Left = 12
      Top = 20
      Width = 33
      Height = 14
      Caption = 'Dial-up'
      FocusControl = lbDialAKA
    end
    object lbDialAKA: TListBox
      Left = 10
      Top = 40
      Width = 119
      Height = 81
      ItemHeight = 14
      TabOrder = 1
      OnDblClick = bEditDialAKAClick
    end
    object bEditDialAKA: TButton
      Left = 82
      Top = 17
      Width = 45
      Height = 22
      Caption = 'Edit'
      TabOrder = 0
      OnClick = bEditDialAKAClick
    end
    object lbIpAKA: TListBox
      Left = 10
      Top = 152
      Width = 119
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Fixedsys'
      Font.Style = []
      ItemHeight = 16
      ParentFont = False
      TabOrder = 3
      OnDblClick = bEditIpAkaClick
    end
    object bEditIpAka: TButton
      Left = 82
      Top = 129
      Width = 45
      Height = 22
      Caption = 'Edit'
      TabOrder = 2
      OnClick = bEditIpAkaClick
    end
  end
  object gbFbox: TGroupBox
    Left = 1
    Top = 76
    Width = 265
    Height = 65
    Anchors = [akLeft, akTop, akRight]
    Caption = 'File-box'
    TabOrder = 1
    DesignSize = (
      265
      65)
    object lFboxIn: TLabel
      Left = 29
      Top = 17
      Width = 8
      Height = 14
      Alignment = taRightJustify
      Caption = 'In'
      FocusControl = eFileBoxIn
    end
    object lFboxOut: TLabel
      Left = 20
      Top = 40
      Width = 17
      Height = 14
      Alignment = taRightJustify
      Caption = 'Out'
      FocusControl = eFileBoxOut
    end
    object eFileBoxIn: TEdit
      Left = 40
      Top = 14
      Width = 217
      Height = 22
      Anchors = [akLeft, akTop, akRight]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object eFileBoxOut: TEdit
      Left = 40
      Top = 37
      Width = 169
      Height = 22
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object bEditFileBox: TButton
      Left = 211
      Top = 37
      Width = 45
      Height = 22
      Anchors = [akTop, akRight]
      Caption = 'Edit'
      TabOrder = 2
      OnClick = bEditFileBoxClick
    end
  end
  object gbPoll: TGroupBox
    Left = 1
    Top = 144
    Width = 265
    Height = 65
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Poll'
    TabOrder = 2
    DesignSize = (
      265
      65)
    object lPollPer: TLabel
      Left = 24
      Top = 17
      Width = 46
      Height = 14
      Alignment = taRightJustify
      Caption = 'Periodical'
      FocusControl = ePollPer
    end
    object lPollExt: TLabel
      Left = 31
      Top = 40
      Width = 39
      Height = 14
      Alignment = taRightJustify
      Caption = 'External'
    end
    object ePollPer: TEdit
      Left = 75
      Top = 14
      Width = 182
      Height = 22
      Anchors = [akLeft, akTop, akRight]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object ePollExt: TEdit
      Left = 75
      Top = 37
      Width = 182
      Height = 22
      Anchors = [akLeft, akTop, akRight]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
  end
  object ePostProc: TEdit
    Left = 76
    Top = 240
    Width = 182
    Height = 22
    Anchors = [akLeft, akTop, akRight]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
  end
  object gbCurNode: TGroupBox
    Left = 1
    Top = 0
    Width = 265
    Height = 73
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Current Node'
    TabOrder = 0
    DesignSize = (
      265
      73)
    object cbCurNode: TComboBox
      Left = 8
      Top = 15
      Width = 250
      Height = 22
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      ItemHeight = 14
      ParentFont = False
      TabOrder = 0
      OnClick = cbCurNodeClick
    end
    object bNewNode: TButton
      Left = 105
      Top = 43
      Width = 75
      Height = 22
      Anchors = [akTop, akRight]
      Caption = 'New'
      TabOrder = 1
      OnClick = bNewNodeClick
    end
    object bDeleteNode: TButton
      Left = 185
      Top = 43
      Width = 70
      Height = 22
      Anchors = [akTop, akRight]
      Caption = 'Delete'
      TabOrder = 2
      OnClick = bDeleteNodeClick
    end
  end
  object gbAtoms: TGroupBox
    Left = 1
    Top = 264
    Width = 265
    Height = 93
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Present in Atoms'
    TabOrder = 4
    DesignSize = (
      265
      93)
    object lAtoms: TLabel
      Left = 12
      Top = 16
      Width = 33
      Height = 14
      Caption = 'Events'
      FocusControl = lbAtoms
    end
    object lbAtoms: TListBox
      Left = 10
      Top = 36
      Width = 247
      Height = 49
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 14
      TabOrder = 1
      OnDblClick = bEditEventsClick
    end
    object bEditEvents: TButton
      Left = 210
      Top = 11
      Width = 45
      Height = 22
      Anchors = [akTop, akRight]
      Caption = 'Edit'
      TabOrder = 0
      OnClick = bEditEventsClick
    end
  end
  object bOK: TButton
    Left = 565
    Top = 4
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 10
  end
  object bCancel: TButton
    Left = 565
    Top = 36
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 11
  end
  object bHelp: TButton
    Left = 565
    Top = 68
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Help'
    TabOrder = 12
    OnClick = bHelpClick
  end
  object ePsw: TEdit
    Left = 76
    Top = 213
    Width = 182
    Height = 22
    Anchors = [akLeft, akTop, akRight]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 13
  end
  object gPsw: TAdvGrid
    Left = 76
    Top = 215
    Width = 182
    Height = 18
    Cursor = crIBeam
    FixedFont.Charset = DEFAULT_CHARSET
    FixedFont.Color = clWindowText
    FixedFont.Height = -11
    FixedFont.Name = 'Arial'
    FixedFont.Style = []
    BorderStyle = bsNone
    ColCount = 1
    DefaultColWidth = 1
    DefaultRowHeight = 16
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    GridLineWidth = 0
    Options = [goEditing, goThumbTracking, goDigitalRows]
    ParentFont = False
    TabOrder = 14
    PasswordCol = 0
  end
end
