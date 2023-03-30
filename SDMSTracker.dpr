program SDMSTracker;

uses
  Vcl.Forms,
  MainFormUnit in 'MainFormUnit.pas' {MainForm},
  Settings in 'Settings.pas' {SettingsForm},
  SDMSLinkOpenUnit in 'SDMSLinkOpenUnit.pas' {SDMSLinkOpen};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TSettingsForm, SettingsForm);
  Application.CreateForm(TSDMSLinkOpen, SDMSLinkOpen);
  Application.Run;
end.
