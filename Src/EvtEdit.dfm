object EvtEditForm: TEvtEditForm
  Left = 263
  Top = 157
  HelpContext = 1900
  BorderStyle = bsDialog
  Caption = 'Edit Event'
  ClientHeight = 282
  ClientWidth = 434
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  DesignSize = (
    434
    282)
  PixelsPerInch = 96
  TextHeight = 15
  object llName: TLabel
    Left = 16
    Top = 8
    Width = 34
    Height = 15
    Caption = '&Name'
    FocusControl = iName
  end
  object llCron: TLabel
    Left = 16
    Top = 52
    Width = 27
    Height = 15
    Caption = '&Cron'
    FocusControl = iCron
  end
  object llAtoms: TLabel
    Left = 16
    Top = 96
    Width = 35
    Height = 15
    Caption = 'A&toms'
  end
  object iName: TEdit
    Left = 8
    Top = 24
    Width = 304
    Height = 23
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
  end
  object iCron: TEdit
    Left = 8
    Top = 68
    Width = 304
    Height = 24
    Anchors = [akLeft, akTop, akRight]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Fixedsys'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
  object llL: TGroupBox
    Left = 325
    Top = 8
    Width = 97
    Height = 113
    Anchors = [akTop, akRight]
    Caption = 'Duration'
    TabOrder = 3
    object llD: TLabel
      Left = 42
      Top = 25
      Width = 28
      Height = 15
      Caption = '&Days'
      FocusControl = iiD
    end
    object llH: TLabel
      Left = 42
      Top = 53
      Width = 34
      Height = 15
      Caption = '&Hours'
      FocusControl = iiH
    end
    object llM: TLabel
      Left = 42
      Top = 81
      Width = 43
      Height = 15
      Caption = '&Minutes'
      FocusControl = iiM
    end
    object iiH: TEdit
      Left = 10
      Top = 49
      Width = 24
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Fixedsys'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object iiD: TEdit
      Left = 10
      Top = 21
      Width = 24
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Fixedsys'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object iiM: TEdit
      Left = 10
      Top = 77
      Width = 24
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Fixedsys'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
  end
  object bOK: TButton
    Left = 325
    Top = 184
    Width = 95
    Height = 23
    Anchors = [akTop, akRight]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 8
  end
  object bCancel: TButton
    Left = 325
    Top = 216
    Width = 95
    Height = 23
    Anchors = [akTop, akRight]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 9
  end
  object bHelp: TButton
    Left = 325
    Top = 248
    Width = 95
    Height = 23
    Anchors = [akTop, akRight]
    Caption = 'Help'
    TabOrder = 10
    OnClick = bHelpClick
  end
  object bAddAtom: TButton
    Left = 23
    Top = 251
    Width = 85
    Height = 23
    Caption = '&Add'
    TabOrder = 5
    OnClick = bAddAtomClick
  end
  object bDelete: TButton
    Left = 215
    Top = 251
    Width = 85
    Height = 23
    Caption = 'De&lete'
    TabOrder = 7
    OnClick = bDeleteClick
  end
  object bEdit: TButton
    Left = 119
    Top = 251
    Width = 85
    Height = 23
    Caption = '&Edit'
    TabOrder = 6
    OnClick = bEditClick
  end
  object lb: TListView
    Left = 8
    Top = 112
    Width = 304
    Height = 129
    Anchors = [akLeft, akTop, akRight]
    Columns = <
      item
        Caption = 'Type'
        Width = 140
      end
      item
        Caption = 'Parameters'
        Width = -2
        WidthType = (
          -2)
      end>
    ColumnClick = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 2
    ViewStyle = vsReport
    OnChange = lbChange
    OnClick = lbClick
    OnDblClick = bEditClick
  end
  object cbPermanent: TCheckBox
    Left = 333
    Top = 128
    Width = 89
    Height = 21
    Anchors = [akTop, akRight]
    Caption = '&Permanent'
    TabOrder = 4
    OnClick = cbPermanentClick
  end
  object cbUTC: TCheckBox
    Left = 333
    Top = 152
    Width = 89
    Height = 21
    Anchors = [akTop, akRight]
    Caption = '&UTC'
    TabOrder = 11
    OnClick = cbPermanentClick
  end
end
