object FidoTemplateEditor: TFidoTemplateEditor
  Left = 215
  Top = 173
  HelpContext = 1070
  Anchors = [akRight, akBottom]
  BorderStyle = bsDialog
  BorderWidth = 6
  Caption = 'Edit station template'
  ClientHeight = 280
  ClientWidth = 513
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
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
    513
    280)
  PixelsPerInch = 96
  TextHeight = 16
  object lTplName: TLabel
    Left = 40
    Top = 216
    Width = 89
    Height = 16
    Alignment = taRightJustify
    Anchors = [akLeft, akBottom]
    Caption = 'Template name'
  end
  object bOK: TButton
    Left = 212
    Top = 245
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = 'O&K'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object bCancel: TButton
    Left = 292
    Top = 245
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object bHelp: TButton
    Left = 372
    Top = 245
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = 'Help'
    TabOrder = 4
    OnClick = bHelpClick
  end
  object lName: TEdit
    Left = 136
    Top = 213
    Width = 375
    Height = 24
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 1
  end
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 513
    Height = 201
    ActivePage = tsEMSI
    Align = alTop
    Anchors = [akLeft, akRight, akBottom]
    HotTrack = True
    TabOrder = 0
    TabStop = False
    object tsEMSI: TTabSheet
      Caption = 'EMSI'
      object gTpl: TAdvGrid
        Left = 0
        Top = 0
        Width = 505
        Height = 145
        FixedFont.Charset = DEFAULT_CHARSET
        FixedFont.Color = clWindowText
        FixedFont.Height = -12
        FixedFont.Name = 'Arial'
        FixedFont.Style = []
        Align = alTop
        ColCount = 2
        DefaultRowHeight = 18
        RowCount = 6
        FixedRows = 0
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Fixedsys'
        Font.Style = []
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goEditing, goFixedNumCols]
        ParentFont = False
        TabOrder = 0
        CheckBoxes = False
        ColWidths = (
          121
          295)
      end
    end
    object tsBanner: TTabSheet
      Caption = 'Banner'
      DesignSize = (
        505
        170)
      object sbGet: TSpeedButton
        Left = 475
        Top = 140
        Width = 20
        Height = 20
        Anchors = [akRight, akBottom]
        Caption = '. . .'
        OnClick = sbGetClick
      end
      object eBan: TMemo
        Left = 6
        Top = 6
        Width = 489
        Height = 125
        Anchors = [akLeft, akTop, akRight, akBottom]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Fixedsys'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 0
      end
      object cbGetFromFile: TCheckBox
        Left = 7
        Top = 142
        Width = 111
        Height = 14
        Anchors = [akLeft, akBottom]
        Caption = 'Get from file'
        TabOrder = 1
        OnClick = cbGetFromFileClick
      end
      object eFileName: TEdit
        Left = 150
        Top = 140
        Width = 325
        Height = 24
        Anchors = [akLeft, akRight, akBottom]
        TabOrder = 2
      end
    end
    object tsAKA: TTabSheet
      Caption = 'AKA'
      object gAKA: TAdvGrid
        Left = 0
        Top = 0
        Width = 505
        Height = 170
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
          165
          202)
      end
    end
  end
  object od: TOpenDialog
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 160
    Top = 244
  end
end
