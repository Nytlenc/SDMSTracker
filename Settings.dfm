object SettingsForm: TSettingsForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
  ClientHeight = 66
  ClientWidth = 515
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poDesktopCenter
  TextHeight = 15
  object Label1: TLabel
    Left = 8
    Top = 11
    Width = 68
    Height = 15
    Caption = 'SDMS Token:'
  end
  object DBEdit1: TDBEdit
    Left = 82
    Top = 8
    Width = 423
    Height = 23
    DataField = 'Token'
    DataSource = stDataSource
    PasswordChar = '*'
    TabOrder = 0
  end
  object sButton1: TsButton
    Left = 349
    Top = 37
    Width = 75
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    TabOrder = 1
    OnClick = sButton1Click
  end
  object sButton2: TsButton
    Left = 430
    Top = 39
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 2
    OnClick = sButton2Click
  end
  object stDataSource: TDataSource
    DataSet = stClientDataSet
    Left = 160
    Top = 16
  end
  object stClientDataSet: TClientDataSet
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'Token'
        DataType = ftString
        Size = 800
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 232
    Top = 16
    object stClientDataSetToken: TStringField
      FieldName = 'Token'
      Size = 800
    end
  end
  object sSkinProvider1: TsSkinProvider
    ShowAppIcon = False
    AddedTitle.Font.Charset = DEFAULT_CHARSET
    AddedTitle.Font.Color = clNone
    AddedTitle.Font.Height = -12
    AddedTitle.Font.Name = 'Segoe UI'
    AddedTitle.Font.Style = []
    SkinData.SkinSection = 'DIALOG'
    TitleButtons = <>
    Left = 80
    Top = 16
  end
end
