unit MainFormUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, System.JSON,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, sSkinManager, Vcl.ExtCtrls, Vcl.Menus,
  ClipBrd, Vcl.StdCtrls, REST.Types, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, REST.Authenticator.OAuth.WebForm.Win,
  REST.Authenticator.OAuth, Vcl.Grids, Data.DB, Vcl.DBGrids, acDBGrid;

type
  TMainForm = class(TForm)
    sSkinManager: TsSkinManager;
    TrayIcon: TTrayIcon;
    TrayPopupMenu: TPopupMenu;
    TraySettings: TMenuItem;
    TrayExit: TMenuItem;
    clpBrdTimer: TTimer;
    SDMSClient: TRESTClient;
    SDMSRequest: TRESTRequest;
    SDMSResponse: TRESTResponse;
    OAuth2Authenticator: TOAuth2Authenticator;
    Button1: TButton;
    TasksGrid: TStringGrid;
    procedure OnClipboardTextChanged(ClpbrdText: String);
    procedure TaskGridAutoSizeCol(Grid: TStringGrid; Column: Integer);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure TrayIconClick(Sender: TObject);
    procedure TrayIconDblClick(Sender: TObject);
    procedure TrayExitClick(Sender: TObject);
    procedure TraySettingsClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure clpBrdTimerTimer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ShowSDMSOpenLinkForm();
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

uses Settings, SDMSLinkOpenUnit;

procedure SetCurrentWndName();
var
  ActiveWindow: HWND;
  buf: array [0 .. 255] of Char;
  WNDName: string;
begin
  ActiveWindow := GetForegroundWindow;
  WNDName := '';
  if (hWindow <> ActiveWindow) then
  begin
    hWindow := ActiveWindow;
    GetWindowText(hWindow, @buf[0], 256);
    WNDName := String(buf);
  end;
  if WNDName <> '' then
    CurrentWndName := WNDName;
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
  esibPos := pos(SearchText, ClpbrdText);
  if (esibPos > 0) then
  begin
    CutText := Copy(ClpbrdText, 0, esibPos);
    Clipboard.AsText := StringReplace(ClpbrdText, CutText, '', [rfReplaceAll]);
    ShowSDMSOpenLinkForm();
  end;
end;

procedure TMainForm.TaskGridAutoSizeCol(Grid: TStringGrid; Column: Integer);
var
  i, W, WMax: Integer;
begin
  WMax := 0;
  for i := 0 to (Grid.RowCount - 1) do
  begin
    W := Grid.Canvas.TextWidth(Grid.Cells[Column, i]);
    if W > WMax then
      WMax := W;
  end;
  Grid.ColWidths[Column] := WMax + 5;
end;

procedure TMainForm.Button1Click(Sender: TObject);
var
  SDMSObject: TJSONObject;
  SDMSTask: TJSONObject;
  JSONArray: TJSONArray;
  id, Name, number, fullNumber, link: string;
begin
  TasksGrid.RowCount := 1;
  TasksGrid.Cols[0].Clear();
  SDMSRequest.Resource := '/tasks/list';
  SDMSRequest.Method := rmGET;
  SDMSRequest.Params.Clear();
  SDMSRequest.Params.AddItem('performer', 'Sinichenko.AN@dns-shop.ru',
    pkGETorPOST);
  OAuth2Authenticator.AccessToken := SettingsForm.sDBToken.Text;
  SDMSRequest.Execute();
  SDMSObject := TJSONObject.Create();
  SDMSObject.Parse(TEncoding.UTF8.GetBytes(SDMSResponse.Content), 0);
  try
    JSONArray := SDMSObject.Values['data'].AsType<TJSONArray>;
    with JSONArray.GetEnumerator do
    begin
      while MoveNext do
      begin
        SDMSTask := Current.AsType<TJSONObject>;
        id := SDMSTask.FindValue('id').Value;
        name := SDMSTask.FindValue('name').Value;
        number := SDMSTask.FindValue('number').Value;
        fullNumber := SDMSTask.FindValue('fullNumber').Value;
        link := SDMSTask.FindValue('link').Value;
        TasksGrid.Cells[0, TasksGrid.RowCount - 1] := '[' + fullNumber +
          '] ' + name;
        TasksGrid.RowCount := TasksGrid.RowCount + 1;
      end;
    end;
  finally
    TasksGrid.RowCount := TasksGrid.RowCount - 1;
    SDMSObject.Free();
    TasksGrid.Refresh();
    TasksGrid.SetFocus();
  end;
end;

procedure TMainForm.ShowSDMSOpenLinkForm();
var
  x: Integer;
begin
  clpBrdTimer.Enabled := False;
  SetForegroundWindow(SDMSLinkOpen.Handle);
  SDMSLinkOpen.Show();
  SDMSLinkOpen.Left := screen.WorkAreaWidth - SDMSLinkOpen.Width;
  SDMSLinkOpen.Top := screen.WorkAreaHeight;
  for x := 0 to SDMSLinkOpen.Height do
  begin
    Application.ProcessMessages;
    SDMSLinkOpen.Top := screen.WorkAreaHeight - x;
  end;
  clpBrdTimer.Enabled := True;
end;

procedure TMainForm.clpBrdTimerTimer(Sender: TObject);
var
  ClpbrdText: string;
begin
  ClpbrdText := GetClpBrdtext();
  if ((ClpbrdText <> '') and (ClpbrdText <> OldClpbrdText)) then
  begin
    SetCurrentWndName();
    if (pos('SDMS помощник', CurrentWndName) = 0) and
      (pos('SDMS, версия', CurrentWndName) = 0) and (CurrentWndName <> '') then
    begin
      OnClipboardTextChanged(ClpbrdText);
    end;
    OldClpbrdText := GetClpBrdtext();
  end;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := False;
  TrayIcon.Visible := True;
  MainForm.Hide;
end;

procedure TMainForm.FormResize(Sender: TObject);
begin
  TasksGrid.ColWidths[0] := TasksGrid.Width;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  if (not sSkinManager.Active) then
    sSkinManager.Active := True;

  if (SettingsForm.stClientDataSet.Active) then
    Exit;
  SettingsForm.stClientDataSet.FileName := ExtractFilePath(Application.ExeName)
    + 'Settings.cds';
  SettingsForm.stClientDataSet.Active := True;
  if (SettingsForm.sDBLinkReplace.Checked) then
    clpBrdTimer.Enabled := True;
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
  if (SettingsForm.FormState <> [fsModal]) then
    SettingsForm.ShowModal();
end;

end.
