object NodeListCfgForm: TNodeListCfgForm
  Left = 207
  Top = 147
  Width = 508
  Height = 402
  HelpContext = 1010
  BorderIcons = [biSystemMenu, biMaximize]
  BorderWidth = 6
  Caption = 'Nodelist Configuration'
  Color = clBtnFace
  TransparentColorValue = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  PrintScale = poPrintToFit
  Scaled = False
  OnActivate = FormActivate
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  DesignSize = (
    488
    360)
  PixelsPerInch = 96
  TextHeight = 14
  object bOK: TButton
    Left = 237
    Top = 334
    Width = 77
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = 'O&K'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object bCancel: TButton
    Left = 322
    Top = 334
    Width = 78
    Height = 23
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object bHelp: TButton
    Left = 409
    Top = 334
    Width = 77
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = 'Help'
    TabOrder = 3
    OnClick = bHelpClick
  end
  object pg: TPageControl
    Left = 0
    Top = 0
    Width = 488
    Height = 325
    ActivePage = Files
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    MultiLine = True
    ParentFont = False
    TabOrder = 0
    object Files: TTabSheet
      Caption = 'Files'
      DesignSize = (
        480
        294)
      object PanelGrid1: TPanel
        Left = 8
        Top = 8
        Width = 480
        Height = 279
        Anchors = [akLeft, akTop, akRight, akBottom]
        BevelOuter = bvNone
        TabOrder = 0
        object gNL: TAdvGrid
          Left = 0
          Top = 0
          Width = 480
          Height = 279
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
            273
            147)
        end
      end
    end
    object Phones: TTabSheet
      Caption = #39'Phones'
      DesignSize = (
        480
        294)
      object Panel1: TPanel
        Left = 8
        Top = 8
        Width = 480
        Height = 279
        Anchors = [akLeft, akTop, akRight, akBottom]
        BevelOuter = bvNone
        TabOrder = 0
        object gPhn: TAdvGrid
          Left = 0
          Top = 0
          Width = 480
          Height = 279
          FixedFont.Charset = DEFAULT_CHARSET
          FixedFont.Color = clWindowText
          FixedFont.Height = -12
          FixedFont.Name = 'Arial'
          FixedFont.Style = []
          Align = alClient
          ColCount = 3
          DefaultColWidth = 100
          DefaultRowHeight = 18
          RowCount = 2
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Fixedsys'
          Font.Style = []
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goEditing, goThumbTracking, goDigitalRows]
          ParentFont = False
          TabOrder = 0
          CheckBoxes = False
          ColWidths = (
            31
            118
            300)
        end
      end
    end
  end
end
