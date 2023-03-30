object SDMSLinkOpen: TSDMSLinkOpen
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'SDMSLinkOpen'
  ClientHeight = 78
  ClientWidth = 317
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCloseQuery = FormCloseQuery
  OnShow = FormShow
  TextHeight = 15
  object Label1: TLabel
    Left = 9
    Top = 8
    Width = 299
    Height = 21
    Caption = #1054#1090#1082#1088#1099#1090#1100' '#1089#1089#1099#1083#1082#1091' '#1074' '#1090#1086#1085#1082#1086#1084' '#1082#1083#1080#1077#1085#1090#1077' SDMS?'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object Button1: TButton
    Left = 62
    Top = 35
    Width = 90
    Height = 30
    Caption = #1044#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 166
    Top = 35
    Width = 89
    Height = 30
    Caption = #1053#1077#1090
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = Button2Click
  end
  object sSkinProvider1: TsSkinProvider
    AddedTitle.Font.Charset = DEFAULT_CHARSET
    AddedTitle.Font.Color = clNone
    AddedTitle.Font.Height = -12
    AddedTitle.Font.Name = 'Segoe UI'
    AddedTitle.Font.Style = []
    SkinData.SkinSection = 'DIALOG'
    TitleButtons = <>
    Left = 16
    Top = 24
  end
end
