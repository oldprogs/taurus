object EventsForm: TEventsForm
  Left = 319
  Top = 244
  HelpContext = 1900
  BorderStyle = bsDialog
  Caption = 'Events Configuration'
  ClientHeight = 258
  ClientWidth = 453
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    453
    258)
  PixelsPerInch = 96
  TextHeight = 15
  object lv: TListView
    Left = 6
    Top = 6
    Width = 364
    Height = 204
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <
      item
        Caption = 'Name'
        Width = 120
      end
      item
        Caption = 'Cron'
        Width = 120
      end
      item
        Caption = 'Duration'
        Width = 65
      end
      item
        Caption = 'Atoms'
        Width = 55
      end>
    ColumnClick = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ReadOnly = True
    RowSelect = True
    ParentFont = False
    PopupMenu = PopupMenu
    TabOrder = 0
    ViewStyle = vsReport
    OnChange = lvChange
    OnClick = lvClick
    OnDblClick = bEditClick
  end
  object bNew: TButton
    Left = 379
    Top = 8
    Width = 64
    Height = 23
    Anchors = [akTop, akRight]
    Caption = '&New'
    TabOrder = 1
    OnClick = bNewClick
  end
  object bEdit: TButton
    Left = 379
    Top = 36
    Width = 64
    Height = 23
    Anchors = [akTop, akRight]
    Caption = '&Edit'
    TabOrder = 2
    OnClick = bEditClick
  end
  object bCopy: TButton
    Left = 379
    Top = 64
    Width = 64
    Height = 23
    Anchors = [akTop, akRight]
    Caption = '&Copy'
    TabOrder = 3
    OnClick = bCopyClick
  end
  object bDelete: TButton
    Left = 379
    Top = 92
    Width = 64
    Height = 23
    Anchors = [akTop, akRight]
    Caption = 'Dele&te'
    TabOrder = 4
    OnClick = bDeleteClick
  end
  object bOK: TButton
    Left = 139
    Top = 223
    Width = 72
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 5
  end
  object bCancel: TButton
    Left = 219
    Top = 223
    Width = 72
    Height = 23
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 6
  end
  object bHelp: TButton
    Left = 299
    Top = 223
    Width = 72
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = 'Help'
    TabOrder = 7
    OnClick = bHelpClick
  end
  object PopupMenu: TPopupMenu
    Left = 354
    Top = 176
    object ppNew: TMenuItem
      Caption = '&New'
      ShortCut = 16462
      OnClick = bNewClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object ppEdit: TMenuItem
      Caption = '&Edit'
      ShortCut = 16453
      OnClick = bEditClick
    end
    object ppCopy: TMenuItem
      Caption = '&Copy'
      ShortCut = 16451
      OnClick = bCopyClick
    end
    object ppDelete: TMenuItem
      Caption = 'Dele&te'
      ShortCut = 16452
      OnClick = bDeleteClick
    end
    object mPopup: TMenuItem
      Caption = 'Popup'
      ShortCut = 32889
      Visible = False
    end
  end
end
