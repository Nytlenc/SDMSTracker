unit Settings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, sButton, Vcl.Mask,
  Vcl.ExtCtrls, Vcl.DBCtrls, Data.DB, Datasnap.DBClient, sSkinProvider,
  Vcl.Grids, Vcl.DBGrids, sLabel, sDBEdit, sCheckBox, sDBCheckBox;

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
    procedure sButton1Click(Sender: TObject);
    procedure sButton2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
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

procedure TSettingsForm.FormShow(Sender: TObject);
begin
  stClientDataSet.Edit();
end;

procedure TSettingsForm.sButton1Click(Sender: TObject);
begin
  stClientDataSet.Post();
  stClientDataSet.SaveToFile(ExtractFilePath(Application.ExeName) +
    'Settings.cds');
  MainForm.clpBrdTimer.Enabled := sDBLinkReplace.Checked;
  Close();
end;

procedure TSettingsForm.sButton2Click(Sender: TObject);
begin
  stClientDataSet.Cancel();
  Close();
end;

end.
