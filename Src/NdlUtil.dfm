object NodelistCompiler: TNodelistCompiler
  Left = 212
  Top = 177
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Compiling The Nodelist'
  ClientHeight = 171
  ClientWidth = 373
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 16
  object llStatus: TLabel
    Left = 103
    Top = 19
    Width = 42
    Height = 16
    Alignment = taRightJustify
    Caption = 'Status:'
  end
  object lStatus: TLabel
    Left = 152
    Top = 19
    Width = 31
    Height = 15
    Caption = 'blank'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    ShowAccelChar = False
  end
  object llNodes: TLabel
    Left = 48
    Top = 89
    Width = 97
    Height = 16
    Alignment = taRightJustify
    Caption = 'Nodes compiled:'
  end
  object lNodes: TLabel
    Left = 152
    Top = 89
    Width = 31
    Height = 15
    Caption = 'blank'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object llNets: TLabel
    Left = 58
    Top = 65
    Width = 87
    Height = 16
    Alignment = taRightJustify
    Caption = 'Nets compiled:'
  end
  object lNets: TLabel
    Left = 152
    Top = 65
    Width = 31
    Height = 15
    Caption = 'blank'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object llCurFile: TLabel
    Left = 79
    Top = 42
    Width = 66
    Height = 16
    Alignment = taRightJustify
    Caption = 'Current file:'
  end
  object lFile: TLabel
    Left = 152
    Top = 42
    Width = 31
    Height = 15
    Caption = 'blank'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lPoints: TLabel
    Left = 152
    Top = 113
    Width = 31
    Height = 15
    Caption = 'blank'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object llPoints: TLabel
    Left = 48
    Top = 113
    Width = 97
    Height = 16
    Alignment = taRightJustify
    Caption = 'Points compiled:'
  end
  object bStop: TButton
    Left = 155
    Top = 138
    Width = 75
    Height = 23
    Cancel = True
    Caption = 'Stop'
    ModalResult = 2
    TabOrder = 0
  end
end
