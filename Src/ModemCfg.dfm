object ModemEditor: TModemEditor
  Left = 225
  Top = 195
  HelpContext = 1090
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  BorderStyle = bsDialog
  BorderWidth = 6
  Caption = 'Modem configuration'
  ClientHeight = 301
  ClientWidth = 474
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
  DesignSize = (
    474
    301)
  PixelsPerInch = 96
  TextHeight = 15
  object bOK: TButton
    Left = 235
    Top = 269
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = 'O&K'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object bCancel: TButton
    Left = 315
    Top = 269
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object bHelp: TButton
    Left = 395
    Top = 269
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = 'Help'
    TabOrder = 3
    OnClick = bHelpClick
  end
  object pg: TPageControl
    Left = 0
    Top = 0
    Width = 474
    Height = 253
    ActivePage = General
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    object General: TTabSheet
      BorderWidth = 10
      Caption = 'General'
      DesignSize = (
        446
        203)
      object llName: TLabel
        Left = 10
        Top = 1
        Width = 34
        Height = 15
        Caption = '&Name'
        FocusControl = lName
      end
      object llCmds: TLabel
        Left = 10
        Top = 45
        Width = 66
        Height = 15
        Caption = '&Commands'
        FocusControl = gCmd
      end
      object lName: TEdit
        Left = 1
        Top = 18
        Width = 443
        Height = 23
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
      end
      object gCmd: TAdvGrid
        Left = 0
        Top = 64
        Width = 446
        Height = 139
        FixedFont.Charset = DEFAULT_CHARSET
        FixedFont.Color = clWindowText
        FixedFont.Height = -12
        FixedFont.Name = 'Arial'
        FixedFont.Style = []
        Align = alBottom
        ColCount = 2
        DefaultColWidth = 140
        DefaultRowHeight = 18
        RowCount = 7
        FixedRows = 0
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Fixedsys'
        Font.Style = []
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goEditing, goFixedNumCols]
        ParentFont = False
        TabOrder = 1
        CheckBoxes = False
      end
    end
    object Responses: TTabSheet
      BorderWidth = 10
      Caption = 'Responses'
      object gStd: TAdvGrid
        Left = 0
        Top = 19
        Width = 446
        Height = 184
        FixedFont.Charset = DEFAULT_CHARSET
        FixedFont.Color = clWindowText
        FixedFont.Height = -12
        FixedFont.Name = 'Arial'
        FixedFont.Style = []
        Align = alBottom
        ColCount = 2
        DefaultColWidth = 80
        DefaultRowHeight = 18
        RowCount = 9
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
        RightMargin = 12
        ColWidths = (
          80
          180)
      end
    end
    object Flags: TTabSheet
      BorderWidth = 10
      Caption = 'Flags'
      object gFlg: TAdvGrid
        Left = 0
        Top = 0
        Width = 446
        Height = 203
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
          158
          234)
      end
    end
    object tsFax: TTabSheet
      Caption = 'Fax'
      object gbIntFax: TGroupBox
        Left = 8
        Top = 154
        Width = 443
        Height = 49
        Caption = '&Internal receiver settings'
        TabOrder = 2
        object cbDTE: TCheckBox
          Left = 12
          Top = 20
          Width = 245
          Height = 17
          Caption = 'Switch &DTE to 19.2 Kbps'
          TabOrder = 0
        end
      end
      object gbExt: TGroupBox
        Left = 8
        Top = 76
        Width = 443
        Height = 61
        Caption = 'External Receiver settings'
        TabOrder = 1
        object lExtR: TLabel
          Left = 30
          Top = 24
          Width = 82
          Height = 15
          Alignment = taRightJustify
          Caption = '&Command line'
          FocusControl = lFax
        end
        object lFax: TEdit
          Left = 116
          Top = 20
          Width = 314
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Fixedsys'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
      end
      object rgExt: TRadioGroup
        Left = 8
        Top = 11
        Width = 185
        Height = 45
        Caption = '&Fax receiver'
        Columns = 2
        Items.Strings = (
          'E&xternal'
          'I&nternal')
        TabOrder = 0
        OnClick = rgExtClick
      end
    end
  end
end
