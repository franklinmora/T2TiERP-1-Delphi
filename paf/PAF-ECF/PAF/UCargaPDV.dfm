object FCargaPDV: TFCargaPDV
  Left = 99
  Top = 297
  Align = alBottom
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'FCargaPDV'
  ClientHeight = 58
  ClientWidth = 632
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  ExplicitWidth = 320
  ExplicitHeight = 240
  PixelsPerInch = 96
  TextHeight = 13
  object JvProgressBar1: TJvProgressBar
    Left = 0
    Top = 0
    Width = 632
    Height = 58
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alClient
    TabOrder = 0
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 100
    OnTimer = Timer1Timer
    Left = 24
    Top = 8
  end
end
