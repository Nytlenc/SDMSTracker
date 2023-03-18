program SDMSTracker;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {MainForm},
  Settings in 'Settings.pas' {SettingsForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TSettingsForm, SettingsForm);
  Application.Run;
end.
