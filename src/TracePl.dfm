object DisplayInfoForm: TDisplayInfoForm
  Left = 156
  Top = 145
  BorderStyle = bsDialog
  BorderWidth = 6
  ClientHeight = 389
  ClientWidth = 732
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    732
    389)
  PixelsPerInch = 96
  TextHeight = 15
  object bOK: TButton
    Left = 640
    Top = 354
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object Field: TMemo
    Left = 0
    Top = 0
    Width = 732
    Height = 335
    TabStop = False
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = [fsBold]
    Lines.Strings = (
      'Test text')
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 1
    WantReturns = False
    WordWrap = False
  end
end
