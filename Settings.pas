unit Settings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, sButton, Vcl.Mask,
  Vcl.ExtCtrls, Vcl.DBCtrls, Data.DB, Datasnap.DBClient, sSkinProvider,
  Vcl.Grids, Vcl.DBGrids;

type
  TSettingsForm = class(TForm)
    stDataSource: TDataSource;
    stClientDataSet: TClientDataSet;
    stClientDataSetToken: TStringField;
    Label1: TLabel;
    DBEdit1: TDBEdit;
    sButton1: TsButton;
    sButton2: TsButton;
    sSkinProvider1: TsSkinProvider;
    procedure sButton1Click(Sender: TObject);
    procedure sButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SettingsForm: TSettingsForm;

implementation

{$R *.dfm}

procedure TSettingsForm.sButton1Click(Sender: TObject);
begin
  stClientDataSet.Post();
  stClientDataSet.SaveToFile(ExtractFilePath(Application.ExeName) + 'Settings.cds');
  Close();
end;

procedure TSettingsForm.sButton2Click(Sender: TObject);
begin
  Close();
end;

end.
