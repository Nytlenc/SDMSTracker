unit Settings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, sButton, Vcl.Mask,
  Vcl.ExtCtrls, Vcl.DBCtrls, Data.DB, Datasnap.DBClient, sSkinProvider,
  Vcl.Grids, Vcl.DBGrids, sLabel, sDBEdit, sCheckBox, sDBCheckBox, sDBComboBox,
  acDBComboBoxEx, sGroupBox;

type
  TSettingsForm = class(TForm)
    stDataSource: TDataSource;
    stClientDataSet: TClientDataSet;
    stClientDataSetToken: TStringField;
    sButton1: TsButton;
    sButton2: TsButton;
    sSkinProvider1: TsSkinProvider;
    sDBLinkReplace: TsDBCheckBox;
    sDBToken: TsDBEdit;
    sLabel1: TsLabel;
    stClientDataSetUseLinkReplace: TBooleanField;
    sLabel2: TsLabel;
    sLabel3: TsLabel;
    stClientDataSetCheckLabor—osts: TBooleanField;
    sDBCheckLabor—osts: TsDBCheckBox;
    stClientDataSetLabor—ostsHour: TIntegerField;
    sDBLaborCostsHour: TsDBComboBoxEx;
    stClientDataSetLabor—ostsMinute: TIntegerField;
    sDBLaborCostsMinute: TsDBComboBoxEx;
    sRunSDMSClient: TsGroupBox;
    sLabel4: TsLabel;
    sDBSDMSClientRunAtHour: TsDBComboBoxEx;
    sLabel5: TsLabel;
    sDBSDMSClientRunAtMinute: TsDBComboBoxEx;
    sLabel6: TsLabel;
    sLabel7: TsLabel;
    sLabel8: TsLabel;
    sDBSDMSClientBase: TsDBEdit;
    sDBSDMSClientServer: TsDBEdit;
    stClientDataSetSDMSRunClient: TBooleanField;
    stClientDataSetSDMSClientServer: TStringField;
    stClientDataSetSDMSClientBase: TStringField;
    stClientDataSetSDMSClientRunAtHour: TIntegerField;
    stClientDataSetSDMSClientRunAtMinute: TIntegerField;
    procedure sButton1Click(Sender: TObject);
    procedure sButton2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EnableDisableSDMSGroupBox(Enable: Boolean);
    procedure sRunSDMSClientCheckBoxChanged(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SettingsForm: TSettingsForm;

implementation

{$R *.dfm}

uses MainFormUnit;

procedure TSettingsForm.EnableDisableSDMSGroupBox(Enable: Boolean);
begin
  sLabel4.Enabled := Enable;
  sDBSDMSClientRunAtHour.Enabled := Enable;
  sLabel5.Enabled := Enable;
  sDBSDMSClientRunAtMinute.Enabled := Enable;
  sLabel6.Enabled := Enable;
  sLabel7.Enabled := Enable;
  sDBSDMSClientServer.Enabled := Enable;
  sDBSDMSClientBase.Enabled := Enable;
end;

procedure TSettingsForm.FormCreate(Sender: TObject);
var
  I: Integer;
begin

  for I := 0 to 23 do
  begin
    sDBLaborCostsHour.Items.Add(IntToStr(I));
    sDBSDMSClientRunAtHour.Items.Add(IntToStr(I));
  end;

  for I := 0 to 59 do
  begin
    sDBLaborCostsMinute.Items.Add(IntToStr(I));
    sDBSDMSClientRunAtMinute.Items.Add(IntToStr(I));
  end;

end;

procedure TSettingsForm.FormShow(Sender: TObject);
begin
  sRunSDMSClient.Checked := stClientDataSet.FieldByName('SDMSRunClient').AsBoolean;
  EnableDisableSDMSGroupBox(sRunSDMSClient.Checked);
  stClientDataSet.Edit();
end;

procedure TSettingsForm.sButton1Click(Sender: TObject);
begin
  stClientDataSet.FieldByName('SDMSRunClient').Value := sRunSDMSClient.Checked;

  stClientDataSet.Post();
  stClientDataSet.SaveToFile(ExtractFilePath(Application.ExeName) + 'Settings.cds');
  MainForm.clpBrdTimer.Enabled := sDBLinkReplace.Checked;
  Close();
end;

procedure TSettingsForm.sButton2Click(Sender: TObject);
begin
  stClientDataSet.Cancel();
  Close();
end;

procedure TSettingsForm.sRunSDMSClientCheckBoxChanged(Sender: TObject);
begin
  EnableDisableSDMSGroupBox(sRunSDMSClient.Checked);
end;

end.
