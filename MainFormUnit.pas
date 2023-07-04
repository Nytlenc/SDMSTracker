unit MainFormUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, System.JSON,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, sSkinManager, Vcl.ExtCtrls, Vcl.Menus, ClipBrd, Vcl.StdCtrls, REST.Types,
  REST.Client, Data.Bind.Components, Data.Bind.ObjectScope, REST.Authenticator.OAuth.WebForm.Win,
  REST.Authenticator.OAuth, Vcl.Grids, Data.DB, Vcl.DBGrids, acDBGrid, DateUtils, Math, System.Notification, ShellAPI;

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
    OnUpdate: TTimer;
    NotificationCenter: TNotificationCenter;
    Button2: TButton;
    Memo1: TMemo;
    Button3: TButton;
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
    procedure ShowSDMSOpenLinkForm(ClpbrdText: String);
    function SDMSAPIRequest(Resource: String; Method: TRESTRequestMethod; Params: TStringList): TJSONObject;
    function GetCrrentLaborCosts(): Extended;
    procedure FormCreate(Sender: TObject);
    procedure OnUpdateTimer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    function FindWndByName(StartHWND: HWND; AString: String): HWND;
    procedure SetCurrentWndName();
  private
    { Private declarations }
  public
    SDMSWindowName: String;
  end;

var
  MainForm: TMainForm;
  OldClpbrdText: String;
  hWindow: HWND;
  CurrentWndName: String;

implementation

{$R *.dfm}

uses Settings, SDMSLinkOpenUnit;

// General functions

function TMainForm.FindWndByName(StartHWND: HWND; AString: String): HWND;
var
  Buffer: array [0 .. 255] of char;
begin
  Result := StartHWND;
  repeat
    Result := FindWindowEx(0, Result, nil, nil);
    GetWindowText(Result, Buffer, SizeOf(Buffer));
    if StrPos(StrUpper(Buffer), PChar(UpperCase(AString))) <> nil then
      Break;
  until (Result = 0);
end;

procedure TMainForm.SetCurrentWndName();
var
  ActiveWindow: HWND;
  buf: array [0 .. 255] of char;
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

function TMainForm.SDMSAPIRequest(Resource: String; Method: TRESTRequestMethod; Params: TStringList): TJSONObject;
var
  i: Integer;
begin
  SDMSRequest.Resource := Resource;
  SDMSRequest.Method := Method;
  SDMSRequest.Params.Clear();
  for i := 0 to Params.Count - 1 do
  begin
    SDMSRequest.Params.AddItem(Params.Names[i], Params.Values[Params.Names[i]]);
  end;
  OAuth2Authenticator.AccessToken := SettingsForm.sDBToken.Text;
  SDMSRequest.Execute();
  Result := TJSONObject.Create();
  Result.Parse(TEncoding.UTF8.GetBytes(SDMSResponse.Content), 0);
end;

function TMainForm.GetCrrentLaborCosts(): Extended;
var
  SDMSObject: TJSONObject;
  SDMSTask: TJSONObject;
  JSONArray: TJSONArray;
  strduration, strdatestart, strdaternd: string;
  Params: TStringList;
  NowDate: TDateTime;
  code, mess: String;
  i: Integer;
begin
  Result := 0;
  NowDate := EncodeDateTime(YearOf(Now), MonthOf(Now), DayOf(Now), 0, 0, 0, 0);

  Params := TStringList.Create();
  Params.AddPair('performer', 'Sinichenko.AN@dns-shop.ru');
  Params.AddPair('dateStart', FormatDateTime('yyyy-mm-dd', NowDate));
  Params.AddPair('dateEnd', FormatDateTime('yyyy-mm-dd', NowDate));

  for i := 1 to 5 do
  begin
    SDMSObject := SDMSAPIRequest('/elapsedTime/report', rmGET, Params);
    Params.Free();

    code := SDMSObject.Values['code'].AsType<String>;
    mess := SDMSObject.Values['message'].AsType<String>;
    if code = '0' then
      Break;

    Sleep(5000);
  end;

  if mess <> '' then
  begin
    ShowMessage('SDMS API недоступен по причине:' + mess);
    Exit;
  end;

  JSONArray := SDMSObject.Values['data'].AsType<TJSONArray>;
  with JSONArray.GetEnumerator do
  begin
    while MoveNext do
    begin
      SDMSTask := Current.AsType<TJSONObject>;
      strduration := SDMSTask.FindValue('duration').Value;
      Result := Result + strduration.ToExtended;
    end;
  end;
  SDMSObject.Free();
end;

procedure TMainForm.OnClipboardTextChanged(ClpbrdText: String);
var
  esibPos: Integer;
begin
  esibPos := pos('#e1cib/', ClpbrdText);
  if (esibPos > 0) then
  begin
    ShowSDMSOpenLinkForm(ClpbrdText);
  end;
end;

// Timers

procedure TMainForm.Button2Click(Sender: TObject);
var
  SDMSObject: TJSONObject;
  SDMSTask: TJSONObject;
  JSONArray: TJSONArray;
  strduration, strdatestart, strdaternd: string;
  Params: TStringList;
  NowDate: TDateTime;
  code, mess: String;
  i: Integer;
begin
  NowDate := EncodeDateTime(YearOf(Now), MonthOf(Now), DayOf(Now), 0, 0, 0, 0);

  Params := TStringList.Create();
  Params.AddPair('performer', 'Sinichenko.AN@dns-shop.ru');
  Params.AddPair('dateStart', FormatDateTime('yyyy-mm-dd', NowDate));
  Params.AddPair('dateEnd', FormatDateTime('yyyy-mm-dd', NowDate));

  SDMSObject := SDMSAPIRequest('/elapsedTime/report', rmGET, Params);
  Params.Free();

  code := SDMSObject.Values['code'].AsType<String>;
  mess := SDMSObject.Values['message'].AsType<String>;

  Memo1.Lines.Add(DateTimeToStr(Now));
  Memo1.Lines.Add(Format('%s: %s', [code, mess]));

end;

procedure TMainForm.clpBrdTimerTimer(Sender: TObject);
var
  ClpbrdText: string;
begin
  ClpbrdText := GetClpBrdtext();
  if ((ClpbrdText <> '') and (ClpbrdText <> OldClpbrdText)) then
  begin
    SetCurrentWndName();
    if (pos('SDMS помощник', CurrentWndName) = 0) and (pos(SDMSWindowName, CurrentWndName) = 0) and
      (CurrentWndName <> '') then
    begin
      OnClipboardTextChanged(ClpbrdText);
    end;
    OldClpbrdText := GetClpBrdtext();
  end;
end;

procedure TMainForm.OnUpdateTimer(Sender: TObject);
var
  Today: TDateTime;
  NeedHour, NeedMinute, DayOfWeek: Integer;
  NeedCosts, CurrentCosts: Extended;
  MyNotification: TNotification;
  CheckLaborCosts, RunSDMSClient: Boolean;
  runparams, server1c, base1c: string;
  Wnd: HWND;
begin

  // TODO: прикрутить производственный календарь - пример https://isdayoff.ru/20170724
  Today := Now;
  if (DayOfTheWeek(Today) = 6) or (DayOfTheWeek(Today) = 7) then
    Exit;

  CheckLaborCosts := SettingsForm.stClientDataSet.FieldByName('CheckLaborСosts').AsBoolean;
  RunSDMSClient := SettingsForm.stClientDataSet.FieldByName('SDMSRunClient').AsBoolean;

  // Проверка трудозатрат
  if (CheckLaborCosts) then
  begin
    NeedCosts := RoundTo(6.4, -2);

    NeedHour := SettingsForm.stClientDataSet.FieldByName('LaborСostsHour').AsInteger;
    NeedMinute := SettingsForm.stClientDataSet.FieldByName('LaborСostsMinute').AsInteger;

    if (HourOf(Today) = NeedHour) and (MinuteOf(Today) = NeedMinute) and (SecondOf(Today) = 0) then
    begin
      CurrentCosts := GetCrrentLaborCosts();
      if CurrentCosts < NeedCosts then
      begin
        MyNotification := NotificationCenter.CreateNotification;
        MyNotification.Title := 'Пожалуйста, проверьте трудозатраты';
        MyNotification.AlertBody := 'По календарю: ' + FloatToStr(NeedCosts) + ' ч. Внесено: ' +
          FloatToStr(CurrentCosts) + ' ч.';
        NotificationCenter.PresentNotification(MyNotification);
      end;
    end;
  end;

  // Автозапуск SDMS
  if (RunSDMSClient) then
  begin
    NeedHour := SettingsForm.stClientDataSet.FieldByName('SDMSClientRunAtHour').AsInteger;
    NeedMinute := SettingsForm.stClientDataSet.FieldByName('SDMSClientRunAtMinute').AsInteger;

    if (HourOf(Today) = NeedHour) and (MinuteOf(Today) = NeedMinute) and (SecondOf(Today) = 0) then
    begin
      Wnd := FindWndByName(0, MainForm.SDMSWindowName);
      if (Wnd <> 0) then
        Exit;

      server1c := SettingsForm.stClientDataSet.FieldByName('SDMSClientServer').AsString;
      base1c := SettingsForm.stClientDataSet.FieldByName('SDMSClientBase').AsString;
      runparams := Format('ENTERPRISE /S"%s\%s"', [server1c, base1c]);

      ShellExecute(0, 'open', 'c:\Program Files (x86)\1cv8\common\1cestart.exe', PWideChar(runparams), nil, SW_HIDE);
    end;
  end;

end;

// Program module

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
  Params: TStringList;
begin
  TasksGrid.RowCount := 1;
  TasksGrid.Cols[0].Clear();

  Params := TStringList.Create();
  Params.AddPair('performer', 'Sinichenko.AN@dns-shop.ru');
  SDMSObject := SDMSAPIRequest('/tasks/list', rmGET, Params);
  Params.Free();

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
      TasksGrid.Cells[0, TasksGrid.RowCount - 1] := '[' + fullNumber + '] ' + name;
      TasksGrid.RowCount := TasksGrid.RowCount + 1;
    end;
  end;
  SDMSObject.Free();

  TasksGrid.RowCount := TasksGrid.RowCount - 1;
  TasksGrid.Refresh();
  TasksGrid.SetFocus();

end;

procedure TMainForm.ShowSDMSOpenLinkForm(ClpbrdText: String);
var
  x: Integer;
begin
  clpBrdTimer.Enabled := False;
  SetForegroundWindow(SDMSLinkOpen.Handle);
  SDMSLinkOpen.Show();
  SDMSLinkOpen.Left := screen.WorkAreaWidth - SDMSLinkOpen.Width;
  SDMSLinkOpen.Top := screen.WorkAreaHeight;
  SDMSLinkOpen.ClpbrdText := ClpbrdText;
  for x := 0 to SDMSLinkOpen.Height do
  begin
    Application.ProcessMessages;
    SDMSLinkOpen.Top := screen.WorkAreaHeight - x;
  end;
  clpBrdTimer.Enabled := True;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := False;
  TrayIcon.Visible := True;
  MainForm.Hide;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FormatSettings.DecimalSeparator := '.';
  SDMSWindowName := 'SDMS, версия';
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
  SettingsForm.stClientDataSet.FileName := ExtractFilePath(Application.ExeName) + 'Settings.cds';
  SettingsForm.stClientDataSet.Active := True;
  clpBrdTimer.Enabled := SettingsForm.sDBLinkReplace.Checked;
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
