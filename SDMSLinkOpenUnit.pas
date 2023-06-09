unit SDMSLinkOpenUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, sSkinProvider, Vcl.StdCtrls,
  SendInputHelper, ClipBrd;

type
  TSDMSLinkOpen = class(TForm)
    sSkinProvider1: TsSkinProvider;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    ClpbrdText: String;
  end;

var
  SDMSLinkOpen: TSDMSLinkOpen;

implementation

{$R *.dfm}

uses MainFormUnit;

procedure TSDMSLinkOpen.Button1Click(Sender: TObject);
var
  Wnd: HWND;
  SIH: TSendInputHelper;
  CutText: String;
  esibPos: Integer;
begin
  esibPos := pos('#e1cib/', ClpbrdText);
  CutText := Copy(ClpbrdText, 0, esibPos);
  Clipboard.AsText := StringReplace(ClpbrdText, CutText, '', [rfReplaceAll]);
  Close();
  Wnd := MainForm.FindWndByName(0, MainForm.SDMSWindowName);
  if (Wnd = 0) or (Wnd = Application.Handle) then
  begin
    ShowMessage('��� ������ ����������� �������� ������ ������ SDMS');
    Exit;
  end;

  ShowWindow(Wnd, SW_SHOWMAXIMIZED);
  SetForegroundWindow(Wnd);

  SIH := TSendInputHelper.Create;
  try
    // Shift + F11
    SIH.AddShift([ssShift], True, False);
    SIH.AddVirtualKey(VK_F11, True, False);
    sleep(100);
    SIH.AddVirtualKey(VK_F11, False, True);
    SIH.AddShift([ssShift], False, True);
    SIH.Flush;

    // Shift + Insert
    SIH.AddShift([ssShift], True, False);
    SIH.AddVirtualKey(VK_INSERT, True, False);
    sleep(100);
    SIH.AddVirtualKey(VK_INSERT, False, True);
    SIH.AddShift([ssShift], False, True);
    SIH.Flush;

    // Enter
    SIH.AddVirtualKey(VK_RETURN, True, False);
    sleep(100);
    SIH.AddVirtualKey(VK_RETURN, False, True);
    SIH.Flush;
  finally
    SIH.Free;
  end;
end;

procedure TSDMSLinkOpen.Button2Click(Sender: TObject);
begin
  Close();
end;

procedure TSDMSLinkOpen.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  x: Integer;
begin
  for x := 0 to Height do
  begin
    Application.ProcessMessages;
    Top := (screen.WorkAreaHeight - Height) + x;
  end;
end;

procedure TSDMSLinkOpen.FormShow(Sender: TObject);
begin
  Left := screen.WorkAreaWidth - Width;
  Top := screen.WorkAreaHeight;
end;

end.
