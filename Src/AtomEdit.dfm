object AtomEditorForm: TAtomEditorForm
  Left = 227
  Top = 156
  HelpContext = 1890
  BorderStyle = bsDialog
  BorderWidth = 6
  Caption = 'Edit Event Atom'
  ClientHeight = 317
  ClientWidth = 432
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
  PixelsPerInch = 96
  TextHeight = 15
  object Bevel2: TBevel
    Left = 0
    Top = 0
    Width = 337
    Height = 68
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
    Top = 25
    Width = 316
    Height = 23
    Style = csDropDownList
    DropDownCount = 20
    ItemHeight = 15
    TabOrder = 0
    OnChange = cbChange
  end
  object bOK: TButton
    Left = 345
    Top = 0
    Width = 80
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object bCancel: TButton
    Left = 345
    Top = 30
    Width = 80
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object bHelp: TButton
    Left = 345
    Top = 60
    Width = 80
    Height = 25
    Caption = 'Help'
    TabOrder = 4
    OnClick = bHelpClick
  end
  object nb: TNotebook
    Left = 0
    Top = 66
    Width = 337
    Height = 237
    PageIndex = 7
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
      object bvl1: TBevel
        Left = 0
        Top = 0
        Width = 337
        Height = 76
        Align = alTop
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
        Top = 26
        Width = 316
        Height = 24
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
      object bvl2: TBevel
        Left = 0
        Top = 0
        Width = 337
        Height = 76
        Align = alTop
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
        Left = 10
        Top = 26
        Width = 316
        Height = 24
        Style = csDropDownList
        ItemHeight = 0
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
        Width = 337
        Height = 57
        Align = alTop
        Shape = bsFrame
      end
      object lSpin: TLabel
        Left = 90
        Top = 20
        Width = 3
        Height = 15
        FocusControl = sSpin
      end
      object sSpin: TxSpinEdit
        Left = 10
        Top = 16
        Width = 73
        Height = 23
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
      object bvl4: TBevel
        Left = 0
        Top = 0
        Width = 337
        Height = 46
        Align = alTop
        Shape = bsFrame
      end
      object cbCheckBox: TCheckBox
        Left = 12
        Top = 14
        Width = 316
        Height = 18
        TabOrder = 0
        OnClick = cbCheckBoxClick
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = '5'
      object bvl5: TBevel
        Left = 0
        Top = 0
        Width = 337
        Height = 122
        Align = alTop
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
        Width = 316
        Height = 24
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
        Width = 316
        Height = 24
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
      object bvl6: TBevel
        Left = 0
        Top = 0
        Width = 337
        Height = 225
        Align = alTop
        Shape = bsFrame
      end
      object MemoPageControl: TPageControl
        Left = 0
        Top = 2
        Width = 337
        Height = 223
        ActivePage = tsMemoA
        TabOrder = 0
        object tsMemoA: TTabSheet
          Caption = 'tsMemoA'
          object MemoA: TMemo
            Left = 0
            Top = 0
            Width = 328
            Height = 193
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
            Width = 328
            Height = 193
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
      object bvl7: TBevel
        Left = 0
        Top = 0
        Width = 337
        Height = 228
        Align = alTop
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
        Top = 69
        Width = 337
        Height = 159
        FixedFont.Charset = DEFAULT_CHARSET
        FixedFont.Color = clWindowText
        FixedFont.Height = -12
        FixedFont.Name = 'Arial'
        FixedFont.Style = []
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
        OnRowInsert = StringGridRowInsert
        OnRowDelete = StringGridRowDelete
        ColWidths = (
          30
          84
          86
          80
          77)
      end
      object eGrid: TEdit
        Left = 10
        Top = 26
        Width = 316
        Height = 24
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
