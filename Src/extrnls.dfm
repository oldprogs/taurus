object ExternalsForm: TExternalsForm
  Left = 234
  Top = 160
  HelpContext = 1880
  BorderStyle = bsDialog
  BorderWidth = 6
  Caption = 'Externals'
  ClientHeight = 310
  ClientWidth = 564
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
    564
    310)
  PixelsPerInch = 96
  TextHeight = 15
  object Label1: TLabel
    Left = 259
    Top = 250
    Width = 182
    Height = 15
    Alignment = taRightJustify
    Anchors = [akRight, akBottom]
    Caption = 'Click here to test selected item ->'
  end
  object btRunNow: TButton
    Left = 458
    Top = 244
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = 'Run now'
    TabOrder = 5
    OnClick = btRunNowClick
  end
  object bOK: TButton
    Left = 298
    Top = 281
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = 'O&K'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object bCancel: TButton
    Left = 378
    Top = 281
    Width = 74
    Height = 23
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object bHelp: TButton
    Left = 458
    Top = 281
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = 'Help'
    TabOrder = 4
    OnClick = bHelpClick
  end
  object bImportPwd: TButton
    Left = 44
    Top = 281
    Width = 75
    Height = 23
    Caption = 'Import...'
    TabOrder = 1
    Visible = False
  end
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 564
    Height = 233
    ActivePage = tsPP
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    HotTrack = True
    MultiLine = True
    ParentFont = False
    ParentShowHint = False
    ShowHint = False
    TabOrder = 0
    TabStop = False
    object tsPP: TTabSheet
      Tag = 1
      Caption = 'Postprocessors'
      object gExt: TAdvGrid
        Left = 0
        Top = 0
        Width = 556
        Height = 202
        FileNameCol = 2
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
          190
          312)
      end
    end
    object tsFlags: TTabSheet
      Tag = 2
      Caption = 'Flags'
      ImageIndex = 3
      object gFlags: TAdvGrid
        Left = 0
        Top = 0
        Width = 556
        Height = 202
        FileNameCol = 2
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
          190
          315)
      end
    end
    object tsDrs: TTabSheet
      Tag = 3
      Caption = 'Doors'
      object gDrs: TAdvGrid
        Left = 0
        Top = 0
        Width = 556
        Height = 202
        FileNameCol = 2
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
          88
          415)
      end
    end
    object tsCron: TTabSheet
      Tag = 4
      Caption = 'Cron'
      object gCrn: TAdvGrid
        Left = 0
        Top = 0
        Width = 556
        Height = 202
        FileNameCol = 2
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
          190
          309)
      end
    end
    object tsExteranals: TTabSheet
      Tag = 5
      Caption = 'External Tools'
      ImageIndex = -1
      object gExternals: TAdvGrid
        Left = 0
        Top = 0
        Width = 556
        Height = 202
        FileNameCol = 2
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
          190
          313)
      end
    end
    object tsHook: TTabSheet
      Tag = 6
      Caption = 'Hooks'
      object gHooks: TAdvGrid
        Left = 0
        Top = 0
        Width = 556
        Height = 202
        FileNameCol = 2
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
          193
          318)
      end
    end
  end
end
