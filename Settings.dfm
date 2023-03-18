object SettingsForm: TSettingsForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
  ClientHeight = 65
  ClientWidth = 511
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poDesktopCenter
  OnShow = FormShow
  TextHeight = 15
  object sLabel1: TsLabel
    Left = 8
    Top = 11
    Width = 68
    Height = 15
    Caption = 'SDMS '#1090#1086#1082#1077#1085':'
  end
  object sButton1: TsButton
    Left = 349
    Top = 37
    Width = 75
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    TabOrder = 0
    OnClick = sButton1Click
  end
  object sButton2: TsButton
    Left = 430
    Top = 37
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 1
    OnClick = sButton2Click
  end
  object sDBLinkReplace: TsDBCheckBox
    Left = 4
    Top = 38
    Width = 222
    Height = 19
    Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1079#1072#1084#1077#1085#1091' '#1089#1089#1099#1083#1086#1082' SDMS'
    Alignment = taLeftJustify
    TabOrder = 2
    DataField = 'UseLinkReplace'
    DataSource = stDataSource
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object sDBToken: TsDBEdit
    Left = 82
    Top = 8
    Width = 423
    Height = 23
    Color = 3553081
    DataField = 'Token'
    DataSource = stDataSource
    TabOrder = 3
  end
  object stDataSource: TDataSource
    DataSet = stClientDataSet
    Left = 288
    Top = 8
  end
  object stClientDataSet: TClientDataSet
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'Token'
        DataType = ftString
        Size = 800
      end
      item
        Name = 'UseLinkReplace'
        DataType = ftBoolean
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 328
    Top = 8
    object stClientDataSetToken: TStringField
      FieldName = 'Token'
      Size = 800
    end
    object stClientDataSetUseLinkReplace: TBooleanField
      FieldName = 'UseLinkReplace'
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
    Left = 248
    Top = 8
  end
end
