unit uCountMK;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, odbcconn, sqldb, db, FileUtil, Forms, Controls, Graphics,
  Dialogs, DbCtrls, StdCtrls;

type

  { TfrmHitungMK }

  TfrmHitungMK = class(TForm)
    btnGo: TButton;
    conn: TODBCConnection;
    comboProdi: TDBLookupComboBox;
    ComboKur: TDBLookupComboBox;
    comboMK: TDBLookupComboBox;
    Label5: TLabel;
    SourceCek: TDataSource;
    SourceCount: TDataSource;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Source3: TDataSource;
    Label1: TLabel;
    Source2: TDataSource;
    Source1: TDataSource;
    Q1: TSQLQuery;
    Q2: TSQLQuery;
    Q3: TSQLQuery;
    Qcount: TSQLQuery;
    QCek: TSQLQuery;
    TransCek: TSQLTransaction;
    TransCount: TSQLTransaction;
    Trans3: TSQLTransaction;
    Trans2: TSQLTransaction;
    Trans1: TSQLTransaction;
    procedure btnGoClick(Sender: TObject);
    procedure ComboKurChange(Sender: TObject);
    procedure comboProdiChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmHitungMK: TfrmHitungMK;

implementation
uses konekMySQL;
{$R *.lfm}

{ TfrmHitungMK }

procedure TfrmHitungMK.FormCreate(Sender: TObject);
begin
  conn.Driver := Koneksi('driver');
  conn.UserName := Koneksi('username');
  conn.Password := Koneksi('password');
  conn.Params.Add('SERVER='+Koneksi('server'));
  conn.Params.Add('PORT='+Koneksi('port'));
  conn.Params.Add('DATABASE='+Koneksi('database'));
  trans1.DataBase:=conn;
  trans2.DataBase:=conn;
  trans3.DataBase:=conn;
  Q1.Database:=conn;
  Q2.Database:=conn;
  Q3.Database:=conn;
  Q1.SQL.Clear;
  Q1.Transaction:=trans1;
  Q2.Transaction:=trans2;
  Q3.Transaction:=trans3;

  transCount.DataBase:=conn;
  QCount.Database:=conn;
  QCount.SQL.Clear;
  QCount.Transaction:=transCount;

  transCek.DataBase:=conn;
  QCek.Database:=conn;
  QCek.SQL.Clear;
  QCek.Transaction:=transCek;

  Q1.Active:=FALSE;
  Q1.SQL.Add('SELECT kd_progdi FROM tb_mk GROUP BY kd_progdi');
   Q1.Active:=TRUE;
   source1.DataSet:=Q1;
   source2.DataSet:=Q2;
   comboProdi.ListSource:=source1;
   comboProdi.ListField:='kd_progdi';
   comboProdi.KeyField:='kd_progdi';



end;

procedure TfrmHitungMK.comboProdiChange(Sender: TObject);
var
  kd_progdi : string;
begin
   kd_progdi:=comboProdi.KeyValue;
   Q2.Active:=FALSE;
   Q2.SQL.Clear;
   Q2.SQL.Add('SELECT kd_kur FROM tb_mk WHERE kd_progdi="' + kd_progdi + '" GROUP BY kd_kur');
   Q2.Active:=TRUE;
   source2.DataSet:=Q2;
   comboKur.ListSource:=source2;
   comboKur.ListField:='kd_kur';
   comboKur.KeyField:='kd_kur';
end;

procedure TfrmHitungMK.ComboKurChange(Sender: TObject);
var
  kd_kur, kd_progdi : string;
begin
   kd_progdi:=comboProdi.KeyValue;
   kd_kur:=comboKur.KeyValue;
   Q3.Active:=FALSE;
   Q3.SQL.Clear;
   Q3.SQL.Add('SELECT kd_mk, concat (kd_mk, " | ", nm_mk) as conce FROM tb_mk WHERE kd_progdi="' + kd_progdi + '" AND kd_kur="' + kd_kur + '"');
   Q3.Active:=TRUE;
   source3.DataSet:=Q3;
   comboMK.ListSource:=source3;
   comboMK.ListField:='conce';
   comboMK.KeyField:='kd_mk';

end;

procedure TfrmHitungMK.btnGoClick(Sender: TObject);
var
  kd_kur, kd_progdi, nim, kd_mk : string;
  n, count_krs : integer;
begin
  count_krs := 0;
  kd_progdi:=comboProdi.KeyValue;
  kd_kur:=comboKur.KeyValue;
  kd_mk:=comboMK.KeyValue;
  // cek mahasiswa di tabel mahasiswa berdasarkan prodi dan kurikulum
  QCount.Active:=FALSE;
  QCount.SQL.Clear;
  QCount.SQL.Add('SELECT nim FROM tb_mahasiswa WHERE kd_progdi="' + kd_progdi + '" AND kd_kur="' + kd_kur + '"');
  QCount.Active:=TRUE;
  while not QCount.Eof do
    begin
        nim := QCount.FieldByName('nim').AsString;
        QCek.Active:=FALSE;
        QCek.SQL.Clear;
        QCek.SQL.Add('SELECT count(*) as cek FROM tb_krs WHERE NIM="'+nim+'" AND kd_mk="'+kd_mk+'"');
        SourceCek.Dataset:=QCek;
        QCek.Active:=TRUE;
        n := QCek.FieldByName('cek').AsInteger;
        count_krs := count_krs + n;
        //progressbar1.position:=progressbar1.position+1;
        QCount.Next;
    end;
    label5.Caption:=inttostr(count_krs);
end;

end.

