unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.IOUtils,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,

 {$IFDEF ANDROID}
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.provider,
  Androidapi.JNI.JavaTypes,
  Androidapi.JNI.Net,
  Androidapi.JNI.App,
  AndroidAPI.jNI.OS,
  Androidapi.JNIBridge,
  FMX.Helpers.Android,
  IdUri,
  Androidapi.Helpers,
  FMX.Platform.Android,
  {$ENDIF}

  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.ISAndroid.Permissions, System.Net.URLClient, System.Net.HttpClient,
  System.Net.HttpClientComponent, FMX.ScrollBox, FMX.Memo, FMX.Layouts, FMX.ISCalendar, FMX.ISAlcinoe, FMX.ISBase,
  FMX.ISBase.Presented, FMX.ISEditEx;

type

  TForm1 = class(TForm)
    ISAndroidPermissions1: TISAndroidPermissions;
    Button2: TButton;
    http: TNetHTTPClient;
    SendURI: TButton;
    Button6: TButton;
    ISCalendar1: TISCalendar;
    ISEditEX1: TISEditEX;
    procedure Button2Click(Sender: TObject);
    procedure httpReceiveData(const Sender: TObject; AContentLength, AReadCount: Int64; var Abort: Boolean);
    procedure httpRequestCompleted(const Sender: TObject; const AResponse: IHTTPResponse);
    procedure Button4Click(Sender: TObject);
    procedure SendURIClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    Str    : TStringStream;
    path   : String;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.httpReceiveData(const Sender: TObject; AContentLength, AReadCount: Int64; var Abort: Boolean);
begin
Button2.Text := 'Baixando '+Trunc((aReadCount/aContentLength)*100).ToString+'%';
end;

procedure TForm1.httpRequestCompleted(const Sender: TObject; const AResponse: IHTTPResponse);
begin
Str.Position := 0;
Str.SaveToFile(Path+'teste.pdf');
Str.DisposeOf;
Button2.Text := 'PDF Baixado! ';
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
Str  := TStringStream.Create;
Http.Get('https://app.jusimperium.com.br/teste.pdf', Str);
end;

procedure TForm1.SendURIClick(Sender: TObject);
{$IFDEF ANDROID}
Var
  LIntent : JIntent;
  LFile   : JFile;
{$ENDIF}
begin
{$IFDEF ANDROID}
LFile   := TJFile.JavaClass.init(StringToJString(Path+'teste.pdf'));
LIntent := TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_VIEW);
LIntent.setDataAndType(TAndroidHelper.JFileToJURI(LFile), StringToJString('application/pdf'));
LIntent.setFlags(TJIntent.JavaClass.FLAG_GRANT_READ_URI_PERMISSION);
TAndroidHelper.Activity.startActivity(LIntent);
{$ENDIF}
end;

procedure TForm1.Button4Click(Sender: TObject);
{$IFDEF ANDROID}
Var
  Intent : JIntent;
  LFile  : JFile;
  URIs   : JArrayList;
  URI    : JNet_Uri;
{$ENDIF}
begin
{$IFDEF ANDROID}
URIs   := TJArrayList.Create;
Intent := TJIntent.JavaClass.init(TJintent.JavaClass.ACTION_SEND);
LFile  := TJFile.JavaClass.init(StringToJString(Path+'teste.pdf'));
Intent.setPackage(StringToJString('com.whatsapp'));
Intent.setType(StringToJString('text/plain'));
Intent.putExtra(TJintent.JavaClass.EXTRA_TEXT, StringToJString('Texto de teste'));
Uri := TAndroidHelper.JFileToJURI(LFile);
Intent.setDataAndType(Uri, StringToJString('application/pdf'));
Uris.add(Uri);
Intent.setFlags(TJintent.JavaClass.FLAG_GRANT_READ_URI_PERMISSION);
Intent.putParcelableArrayListExtra(TJintent.JavaClass.EXTRA_STREAM, Uris);
TAndroidHelper.Activity.startActivity(Intent);
{$ENDIF}
end;

procedure TForm1.FormShow(Sender: TObject);
begin
Path := System.IOUtils.TPath.GetDocumentsPath+PathDelim;
end;

end.
