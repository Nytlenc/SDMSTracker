unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, sSkinManager, Vcl.ExtCtrls, Vcl.Menus,
  ClipBrd, Vcl.StdCtrls;

type
  TMainForm = class(TForm)
    sSkinManager: TsSkinManager;
    TrayIcon: TTrayIcon;
    TrayPopupMenu: TPopupMenu;
    TraySettings: TMenuItem;
    TrayExit: TMenuItem;
    clpBrdTimer: TTimer;
    Button1: TButton;
    procedure OnClipboardTextChanged(ClpbrdText: String);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure TrayIconClick(Sender: TObject);
    procedure TrayIconDblClick(Sender: TObject);
    procedure TrayExitClick(Sender: TObject);
    procedure TraySettingsClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure clpBrdTimerTimer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  OldClpbrdText: String;
  hWindow: HWND;
  CurrentWndName: String;

implementation

{$R *.dfm}

uses Settings;

procedure SetCurrentWndName();
var
  ActiveWindow: HWND;
  buf: array [0 .. 255] of char;
  WndName: string;
begin
  ActiveWindow := GetForegroundWindow;
  WndName := '';
  if (hWindow <> ActiveWindow) then
  begin
    hWindow := ActiveWindow;
    GetWindowText(hWindow, @buf[0], 256);
    WndName := String(buf);
  end;
  if WndName <> '' then
    CurrentWndName := WndName;
end;

function GetClpBrdtext(): String;
begin
  try
    Result := Clipboard.AsText;
  except
    Result := '';
  end;
end;

procedure TMainForm.OnClipboardTextChanged(ClpbrdText: String);
var
  SearchText, CutText: string;
  esibPos: Integer;
begin
  SearchText := '#e1cib/';
  esibPos := Pos(SearchText, ClpbrdText);
  if (esibPos > 0) then
  begin
    CutText := Copy(ClpbrdText, 0, esibPos);
    Clipboard.AsText := StringReplace(ClpbrdText, CutText, '', [rfReplaceAll]);
  end;
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  ShowMessage('Helo world!');
end;

procedure TMainForm.clpBrdTimerTimer(Sender: TObject);
var
  ClpbrdText: string;
begin
  SetCurrentWndName();
  ClpbrdText := GetClpBrdtext();
  if ((ClpbrdText <> '') and (ClpbrdText <> OldClpbrdText)) then
  begin
    if ((Pos('SDMS', CurrentWndName) = 0) and (CurrentWndName <> '')) then
      OnClipboardTextChanged(ClpbrdText);
    OldClpbrdText := GetClpBrdtext();
  end;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := False;
  TrayIcon.Visible := True;
  MainForm.Hide;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  if (SettingsForm.stClientDataSet.Active) then
    Exit;
  SettingsForm.stClientDataSet.FileName := ExtractFilePath(Application.ExeName)
    + 'Settings.cds';
  SettingsForm.stClientDataSet.Active := True;
end;

procedure TMainForm.TrayExitClick(Sender: TObject);
begin
  Application.Terminate();
end;

procedure TMainForm.TrayIconClick(Sender: TObject);
begin
  MainForm.Show();
end;

procedure TMainForm.TrayIconDblClick(Sender: TObject);
begin
  MainForm.Show();
end;

procedure TMainForm.TraySettingsClick(Sender: TObject);
begin
  SettingsForm.ShowModal();
end;

end.
