object NetCfg: TNetCfg
  Left = 103
  Top = 134
  Width = 858
  Height = 480
  BorderWidth = 5
  Caption = 'Routing Table'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Arail'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object gNetmail: TAdvGrid
    Left = 0
    Top = 0
    Width = 840
    Height = 400
    FixedFont.Charset = DEFAULT_CHARSET
    FixedFont.Color = clWindowText
    FixedFont.Height = -12
    FixedFont.Name = 'Arial'
    FixedFont.Style = []
    Align = alClient
    ColCount = 4
    DefaultRowHeight = 17
    RowCount = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowMoving, goEditing, goDigitalRows]
    ParentFont = False
    TabOrder = 0
    CheckBoxes = False
    PasswordCol = 3
    ColWidths = (
      31
      157
      557
      85)
  end
  object Footer: TJvFooter
    Left = 0
    Top = 400
    Width = 840
    Height = 40
    Align = alBottom
    BevelVisible = True
    DesignSize = (
      840
      40)
    object bOK: TJvFooterBtn
      Left = 680
      Top = 8
      Width = 74
      Height = 23
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 0
      OnClick = bOKClick
      HotTrackFont.Charset = DEFAULT_CHARSET
      HotTrackFont.Color = clWindowText
      HotTrackFont.Height = -11
      HotTrackFont.Name = 'MS Sans Serif'
      HotTrackFont.Style = []
      ButtonIndex = 0
      SpaceInterval = 6
    end
    object bCancel: TJvFooterBtn
      Left = 761
      Top = 8
      Width = 74
      Height = 23
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
      HotTrackFont.Charset = DEFAULT_CHARSET
      HotTrackFont.Color = clWindowText
      HotTrackFont.Height = -11
      HotTrackFont.Name = 'MS Sans Serif'
      HotTrackFont.Style = []
      ButtonIndex = 1
      SpaceInterval = 6
    end
  end
  object FS: TJvFormPlace
    Top = 408
  end
end
