object AtomEditorForm: TAtomEditorForm
  Left = 227
  Top = 156
  HelpContext = 1890
  BorderStyle = bsDialog
  BorderWidth = 6
  Caption = 'Edit Event Atom'
  ClientHeight = 367
  ClientWidth = 515
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    515
    367)
  PixelsPerInch = 96
  TextHeight = 15
  object Bevel2: TBevel
    Left = 0
    Top = 0
    Width = 424
    Height = 66
    Anchors = [akLeft, akTop, akRight]
    Shape = bsFrame
  end
  object llTyp: TLabel
    Left = 13
    Top = 8
    Width = 26
    Height = 15
    Caption = '&Type'
  end
  object cb: TComboBox
    Left = 10
    Top = 27
    Width = 405
    Height = 23
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    DropDownCount = 20
    ItemHeight = 15
    TabOrder = 0
    OnChange = cbChange
  end
  object bOK: TButton
    Left = 432
    Top = 0
    Width = 80
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object bCancel: TButton
    Left = 432
    Top = 34
    Width = 80
    Height = 25
    Anchors = [akTop, akRight]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object bHelp: TButton
    Left = 432
    Top = 68
    Width = 80
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Help'
    TabOrder = 4
    OnClick = bHelpClick
  end
  object nb: TNotebook
    Left = 0
    Top = 66
    Width = 424
    Height = 296
    Anchors = [akLeft, akTop, akRight, akBottom]
    Ctl3D = True
    PageIndex = 1
    ParentCtl3D = False
    TabOrder = 1
    object TPage
      Left = 0
      Top = 0
      Caption = '0'
    end
    object TPage
      Left = 0
      Top = 0
      Caption = '1'
      DesignSize = (
        424
        296)
      object bvl1: TBevel
        Left = 0
        Top = 0
        Width = 424
        Height = 73
        Align = alTop
        Constraints.MaxHeight = 73
        Constraints.MinHeight = 73
        Shape = bsFrame
      end
      object lString: TLabel
        Left = 13
        Top = 9
        Width = 3
        Height = 15
        FocusControl = iString
      end
      object iString: TEdit
        Left = 10
        Top = 32
        Width = 403
        Height = 24
        Anchors = [akLeft, akTop, akRight]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Fixedsys'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = '2'
      DesignSize = (
        424
        296)
      object bvl2: TBevel
        Left = 0
        Top = 0
        Width = 424
        Height = 73
        Align = alTop
        Constraints.MaxHeight = 73
        Constraints.MinHeight = 73
        Shape = bsFrame
      end
      object lCombo: TLabel
        Left = 13
        Top = 9
        Width = 3
        Height = 15
        FocusControl = cbCombo
      end
      object cbCombo: TComboBox
        Left = 9
        Top = 32
        Width = 405
        Height = 23
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 15
        TabOrder = 0
        OnClick = cbComboClick
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = '3'
      object bvl3: TBevel
        Left = 0
        Top = 0
        Width = 424
        Height = 57
        Align = alTop
        Constraints.MaxHeight = 57
        Constraints.MinHeight = 57
        Shape = bsFrame
      end
      object lSpin: TLabel
        Left = 90
        Top = 20
        Width = 28
        Height = 15
        Caption = 'lSpin'
        FocusControl = sSpin
      end
      object sSpin: TxSpinEdit
        Left = 10
        Top = 16
        Width = 73
        Height = 24
        MaxValue = 0
        MinValue = 0
        TabOrder = 0
        Value = 0
        OnChange = sSpinChange
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = '4'
      DesignSize = (
        424
        296)
      object bvl4: TBevel
        Left = 0
        Top = 0
        Width = 424
        Height = 49
        Align = alTop
        Constraints.MaxHeight = 49
        Constraints.MinHeight = 49
        Shape = bsFrame
      end
      object cbCheckBox: TCheckBox
        Left = 12
        Top = 15
        Width = 398
        Height = 18
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        OnClick = cbCheckBoxClick
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = '5'
      DesignSize = (
        424
        296)
      object bvl5: TBevel
        Left = 0
        Top = 0
        Width = 424
        Height = 122
        Align = alTop
        Constraints.MaxHeight = 122
        Constraints.MinHeight = 122
        Shape = bsFrame
      end
      object lDstrA: TLabel
        Left = 13
        Top = 9
        Width = 3
        Height = 15
        FocusControl = iString
      end
      object lDstrB: TLabel
        Left = 13
        Top = 60
        Width = 3
        Height = 15
        FocusControl = iString
      end
      object iDstrA: TEdit
        Left = 10
        Top = 26
        Width = 400
        Height = 24
        Anchors = [akLeft, akTop, akRight]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Fixedsys'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
      object iDstrB: TEdit
        Left = 10
        Top = 78
        Width = 400
        Height = 24
        Anchors = [akLeft, akTop, akRight]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Fixedsys'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = '6'
      DesignSize = (
        424
        296)
      object bvl6: TBevel
        Left = 0
        Top = 0
        Width = 414
        Height = 297
        Anchors = [akLeft, akTop, akRight, akBottom]
        Constraints.MaxHeight = 297
        Constraints.MinHeight = 297
        Shape = bsFrame
      end
      object MemoPageControl: TPageControl
        Left = 0
        Top = 0
        Width = 424
        Height = 297
        ActivePage = tsMemoA
        Align = alTop
        TabOrder = 0
        object tsMemoA: TTabSheet
          Caption = 'tsMemoA'
          object MemoA: TMemo
            Left = 0
            Top = 0
            Width = 416
            Height = 267
            Align = alClient
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Fixedsys'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            WordWrap = False
          end
        end
        object tsMemoB: TTabSheet
          Caption = 'tsMemoB'
          ImageIndex = 1
          object MemoB: TMemo
            Left = 0
            Top = 0
            Width = 416
            Height = 216
            Align = alClient
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Fixedsys'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            WordWrap = False
          end
        end
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = '7'
      DesignSize = (
        424
        296)
      object bvl7: TBevel
        Left = 0
        Top = 0
        Width = 424
        Height = 297
        Anchors = [akLeft, akTop, akRight, akBottom]
        Constraints.MaxHeight = 297
        Constraints.MinHeight = 297
        Shape = bsFrame
      end
      object lGrid: TLabel
        Left = 13
        Top = 9
        Width = 3
        Height = 15
        FocusControl = eGrid
      end
      object StringGrid: TAdvGrid
        Left = 0
        Top = 72
        Width = 424
        Height = 224
        FixedFont.Charset = DEFAULT_CHARSET
        FixedFont.Color = clWindowText
        FixedFont.Height = -12
        FixedFont.Name = 'Arial'
        FixedFont.Style = []
        Align = alBottom
        DefaultRowHeight = 18
        RowCount = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Fixedsys'
        Font.Style = []
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowMoving, goEditing, goThumbTracking, goDigitalRows]
        ParentFont = False
        TabOrder = 0
        CheckBoxes = False
        OnRowInsert = StringGridRowInsert
        OnRowDelete = StringGridRowDelete
        ColWidths = (
          30
          107
          111
          80
          85)
      end
      object eGrid: TEdit
        Left = 10
        Top = 32
        Width = 402
        Height = 24
        Anchors = [akLeft, akTop, akRight]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Fixedsys'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = '8'
    end
    object TPage
      Left = 0
      Top = 0
      Caption = '9'
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'A'
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'B'
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'C'
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'D'
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'E'
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'F'
    end
  end
end
