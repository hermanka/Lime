unit uSplash;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, odbcconn, sqldb, FileUtil, Forms, Controls, Graphics,
  Dialogs, StdCtrls, ExtCtrls;

type

  { TfrmSplash }

  TfrmSplash = class(TForm)
    btnLogin: TButton;
    eUser: TEdit;
    ePass: TEdit;
    conn: TODBCConnection;
    SQLQuery1: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    procedure btnLoginClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure ePassClick(Sender: TObject);
    procedure eUserClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Image1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmSplash: TfrmSplash;

implementation
uses uHome, md5, konekMySQL;

{ TfrmSplash }

procedure TfrmSplash.FormCreate(Sender: TObject);
begin
  conn.Driver := Koneksi('driver');
  conn.UserName := Koneksi('username');
  conn.Password := Koneksi('password');
  conn.Params.Add('SERVER='+Koneksi('server'));
  conn.Params.Add('PORT=3306');
  conn.Params.Add('DATABASE='+Koneksi('database'));
  SQLTransaction1.DataBase:=conn;
  SQLQuery1.Database:=conn;
  //conn.Connected:=TRUE;
end;

procedure TfrmSplash.Image1Click(Sender: TObject);
begin

end;



procedure TfrmSplash.btnLoginClick(Sender: TObject);
var
  passcode:string;
begin
   SQLQuery1.Active:=FALSE;
   SQLQuery1.SQL.Clear;
   SQLQuery1.SQL.Add('SELECT * FROM tb_user where username="'
   +eUser.text+'"');
   SQLQuery1.Active:=TRUE;
   passcode:=SQLQuery1.FieldByName('password').AsString;
   //update tb_user set password=md5(md5(' ')) where username='hekta';
   if(MD5Print(MD5String(MD5Print(MD5String(ePass.Text)))) = passcode) then
      begin
        frmSplash.hide;
        frmHome.show;
      end
   else
      begin
        MessageDlg('Salah!!', mtWarning,[mbOK],0);
        exit;
      end
end;

procedure TfrmSplash.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmSplash.ePassClick(Sender: TObject);
begin
  ePass.Text:='';
end;

procedure TfrmSplash.eUserClick(Sender: TObject);
begin
  eUser.Text:='';
end;

{$R *.lfm}

end.

