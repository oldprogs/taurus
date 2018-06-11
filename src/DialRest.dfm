object RestrictCfgForm: TRestrictCfgForm
  Left = 211
  Top = 156
  HelpContext = 1100
  BorderStyle = bsDialog
  BorderWidth = 6
  Caption = 'Dialing Restrictions Scheme'
  ClientHeight = 197
  ClientWidth = 618
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object llName: TLabel
    Left = 439
    Top = 9
    Width = 84
    Height = 16
    Caption = 'Scheme name'
  end
  object lName: TEdit
    Left = 439
    Top = 26
    Width = 167
    Height = 24
    TabOrder = 1
  end
  object bOK: TButton
    Left = 439
    Top = 59
    Width = 81
    Height = 25
    Caption = 'O&K'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object bCancel: TButton
    Left = 439
    Top = 93
    Width = 81
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object bHelp: TButton
    Left = 526
    Top = 93
    Width = 80
    Height = 25
    Caption = 'Help'
    TabOrder = 5
    OnClick = bHelpClick
  end
  object p: TPageControl
    Left = 0
    Top = 0
    Width = 432
    Height = 197
    ActivePage = tsRequired
    Align = alLeft
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object tsRequired: TTabSheet
      Caption = 'Required'
      object gReqd: TAdvGrid
        Left = 1
        Top = 0
        Width = 421
        Height = 164
        FixedFont.Charset = DEFAULT_CHARSET
        FixedFont.Color = clWindowText
        FixedFont.Height = -12
        FixedFont.Name = 'Arial'
        FixedFont.Style = []
        ColCount = 2
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
        ColWidths = (
          31
          338)
      end
    end
    object tsForbidden: TTabSheet
      Caption = 'Forbidden'
      object gForb: TAdvGrid
        Left = 1
        Top = 0
        Width = 421
        Height = 164
        FixedFont.Charset = DEFAULT_CHARSET
        FixedFont.Color = clWindowText
        FixedFont.Height = -12
        FixedFont.Name = 'Arial'
        FixedFont.Style = []
        ColCount = 2
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
        ColWidths = (
          31
          338)
      end
    end
  end
  object bExplain: TButton
    Left = 526
    Top = 59
    Width = 80
    Height = 25
    Caption = 'Explain...'
    TabOrder = 3
    OnClick = bExplainClick
  end
end
