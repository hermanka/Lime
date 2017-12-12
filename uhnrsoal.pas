unit uHnrSoal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, odbcconn, sqldb, db, FileUtil, LR_Class, LR_DBSet, Forms,
  Controls, Graphics, Dialogs, DBGrids, StdCtrls, ComCtrls;

type

  { TfrmHnrSoal }

  TfrmHnrSoal = class(TForm)
    btnHitung: TButton;
    btnPost: TButton;
    Button1: TButton;
    Datasource1: TDatasource;
    DBGrid1: TDBGrid;
    conn: TODBCConnection;
    frDBDataSet1: TfrDBDataSet;
    frReport1: TfrReport;
    ProgressBar1: TProgressBar;
    SQLPost: TSQLQuery;
    SQLQuery1: TSQLQuery;
    SQLGetInfo: TSQLQuery;
    QueryCount: TSQLQuery;
    SQLHitungHonor: TSQLQuery;
    SQLdel: TSQLQuery;
    SQLGetMhs: TSQLQuery;
    SQLQuery2: TSQLQuery;
    SQLGetHonor: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    procedure btnHitungClick(Sender: TObject);
    procedure btnPostClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmHnrSoal: TfrmHnrSoal;

implementation
uses konekMySQL;

{$R *.lfm}

{ TfrmHnrSoal }

procedure TfrmHnrSoal.FormCreate(Sender: TObject);
var
  th_akdm, ujian:string;
begin

conn.Driver := Koneksi('driver');
conn.UserName := Koneksi('username');
conn.Password := Koneksi('password');
conn.Params.Add('SERVER='+Koneksi('server'));
conn.Params.Add('PORT=3306');
conn.Params.Add('DATABASE='+Koneksi('database'));
SQLTransaction1.DataBase:=conn;


  SQLgetInfo.Database:=conn;
  SQLgetInfo.Active:=False;
  SQLgetInfo.SQL.Clear;
  SQLgetInfo.SQL.Add('SELECT * FROM tb_swu LIMIT 1');
  SQLgetInfo.Active:=True;
  th_akdm:=SQLgetInfo.FieldByName('th_akdm').AsString;
  ujian:=SQLgetInfo.FieldByName('ujian').AsString;

  SQLQuery1.Database:=conn;
  SQLQuery1.Active:=False;
  SQLQuery1.SQL.Clear;
  SQLQuery1.SQL.Add('SELECT tb_ujian_hnr_soal.*, tb_mk.nm_mk, tb_kary.nama'
  +' from tb_ujian_hnr_soal, tb_mk, tb_kary'
  +' where tb_ujian_hnr_soal.th_akdm="'+th_akdm+'" and tb_ujian_hnr_soal.ujian="'+ujian+'" and tb_ujian_hnr_soal.kd_mk=tb_mk.kd_mk '
  +' and tb_ujian_hnr_soal.nik=tb_kary.nik'
  +' order by tb_ujian_hnr_soal.nik, tb_ujian_hnr_soal.id_jadwal ');
  SQLQuery1.Active:=True;


end;

procedure TfrmHnrSoal.btnHitungClick(Sender: TObject);
var
  th_akdm, ujian:string;
  total_honor:double;
begin
th_akdm:=SQLgetInfo.FieldByName('th_akdm').AsString;
ujian:=SQLgetInfo.FieldByName('ujian').AsString;
progressbar1.position:=0;

QueryCount.Active:=FALSE;
SQLQuery1.Active:=FALSE;
SQLdel.active:=FALSE;
SQLHitungHonor.Active:=FALSE;
SQLGetMhs.Active:=FALSE;

SQLdel.Database:=conn;
QueryCount.Database:=conn;
SQLHitungHonor.Database:=conn;
SQLQuery1.Database:=conn;
SQLGetMhs.Database:=conn;

SQLdel.SQL.Clear;
QueryCount.SQL.Clear;
SQLQuery1.SQL.Clear;
SQLHitungHonor.SQL.Clear;
SQLGetMhs.SQL.Clear;

SQLdel.SQL.Add('delete from tb_ujian_hnr_soal where th_akdm="'+th_akdm+'" AND ujian="'+ujian+'"');
SQLdel.ExecSQL;
SQLdel.SQL.Clear;

QueryCount.SQL.Add('select count(*) from'
+'('
+' SELECT id_jadwal'
+' from tb_jadwal'
+' where th_akdm="'+th_akdm+'" and nik!="DoPem"'
+' group by id_jadwal, jenis'
+' ) as total');

SQLQuery1.SQL.Add('select tb_jadwal.id_jadwal, tb_jadwal.jenis, tb_jadwal.KD_MK, tb_jadwal.nik'
+' from tb_jadwal,tb_mk,tb_kary'
+' where tb_jadwal.th_akdm="'+th_akdm+'" and'
+' tb_jadwal.nik!="DoPem" and'
+' tb_jadwal.kd_mk=tb_mk.kd_mk and'
+' tb_jadwal.NIK=tb_kary.niK'
+' group by tb_jadwal.id_jadwal,tb_jadwal.jenis');

SQLQuery1.Active:=TRUE;
QueryCount.Active:=TRUE;
progressbar1.max:=StrToInt(QueryCount.FieldByName('count(*)').AsString);

while not SQLQuery1.Eof do
  begin
  progressbar1.visible:=TRUE;
  progressbar1.position:=progressbar1.position+1;
  SQLGetMhs.Active:=FALSE;
  SQLGetMhs.SQL.Clear;
  SQLGetMhs.SQL.Add('SELECT count(*) as total_mhs'
  +' from tb_krs'
  +' where th_akdm="'+th_akdm+'" and id_jadwal="'+SQLQuery1.FieldByName('id_jadwal').AsString+'"');
  SQLGetMhs.Active:=TRUE;
  //total_honor:='10000';
  total_honor:=10000+(1000*SQLGetMhs.FieldByName('total_mhs').asFloat);
  SQLHitungHonor.SQL.Add('INSERT INTO tb_ujian_hnr_soal VALUES("'
  +th_akdm+
  '","'+ujian+
  '","'+SQLQuery1.FieldByName('id_jadwal').AsString+
  '","'+SQLQuery1.FieldByName('jenis').AsString+
  '","'+SQLQuery1.FieldByName('kd_mk').AsString+
  '","'+SQLQuery1.FieldByName('nik').AsString+
  '","'+FloatToStr(total_honor)+'")');
     SQLHitungHonor.ExecSQL;
     SQLHitungHonor.SQL.Clear;
     SQLQuery1.Next;
  end;
//SQLQuery1.Refresh;
SQLQuery1.Active:=FALSE;
SQLQuery1.SQL.Clear;
SQLQuery1.SQL.Add('SELECT tb_ujian_hnr_soal.*, tb_mk.nm_mk, tb_kary.nama'
+' from tb_ujian_hnr_soal, tb_mk, tb_kary'
+' where tb_ujian_hnr_soal.th_akdm="'+th_akdm+'" and tb_ujian_hnr_soal.kd_mk=tb_mk.kd_mk'
+' and tb_ujian_hnr_soal.nik=tb_kary.nik'
+' order by tb_ujian_hnr_soal.nik, tb_ujian_hnr_soal.id_jadwal ');
Datasource1.Dataset:=SQLQuery1;
DBGrid1.Datasource:=Datasource1;
SQLQuery1.Active:=TRUE;
SQLQuery1.Refresh;
MessageDlg('Selesai!', mtInformation,[mbOK],0);
progressbar1.visible:=FALSE;
end;

procedure TfrmHnrSoal.btnPostClick(Sender: TObject);
var
  th_akdm, tipe, ujian:string;
begin
th_akdm:=SQLgetInfo.FieldByName('th_akdm').AsString;
ujian:=SQLgetInfo.FieldByName('ujian').AsString;
tipe:='S';
progressbar1.position:=0;

QueryCount.Active:=FALSE;
SQLQuery2.Active:=FALSE;
SQLdel.active:=FALSE;
SQLGetHonor.active:=FALSE;
SQLPost.active:=FALSE;

SQLdel.Database:=conn;
QueryCount.Database:=conn;
SQLQuery2.Database:=conn;
SQLGetHonor.Database:=conn;
SQLPost.Database:=conn;

SQLdel.SQL.Clear;
QueryCount.SQL.Clear;
SQLQuery2.SQL.Clear;
SQLgetHonor.SQL.Clear;
SQLPost.SQL.Clear;

SQLdel.SQL.Add('delete from tb_ujian_hnr_total where th_akdm="'
+th_akdm+'" AND ujian="'
+ujian+'" AND tipe="'
+tipe+'"');
SQLdel.ExecSQL;
SQLdel.SQL.Clear;

QueryCount.SQL.Add('select count(*) from'
+'('
+' SELECT nik'
+' from tb_ujian_hnr_soal'
+' where th_akdm="'+th_akdm+'" and ujian="'+ujian+'"'
+' group by nik'
+' ) as total_hnr_soal');

SQLQuery2.SQL.Add('SELECT *'
+' from tb_ujian_hnr_soal'
+' where th_akdm="'+th_akdm+'" and ujian="'+ujian+'"'
+' group by nik');

SQLQuery2.Active:=TRUE;
QueryCount.Active:=TRUE;
progressbar1.max:=StrToInt(QueryCount.FieldByName('count(*)').AsString);

while not SQLQuery2.Eof do
  begin
  progressbar1.visible:=TRUE;
  progressbar1.position:=progressbar1.position+1;
  SQLGetHonor.Active:=FALSE;
  SQLGetHonor.SQL.Clear;
  SQLGetHonor.SQL.Add('SELECT sum(honor) as total_honor_dosen'
  +' from tb_ujian_hnr_soal'
  +' where th_akdm="'
  +th_akdm+'" and nik="'
  +SQLQuery2.FieldByName('nik').AsString+'" and ujian="'
  +ujian+'"');
  SQLGetHonor.Active:=TRUE;

  SQLPost.SQL.Add('INSERT INTO tb_ujian_hnr_total VALUES("'+
  '","'+th_akdm+
  '","'+tipe+
  '","'+ujian+
  '","'+SQLQuery2.FieldByName('nik').AsString+
  '","'+SQLGetHonor.FieldByName('total_honor_dosen').AsString+'")');
     SQLPost.ExecSQL;
     SQLPost.SQL.Clear;
     SQLQuery2.Next;
  end;
//SQLQuery1.Refresh;
MessageDlg('Selesai!', mtInformation,[mbOK],0);
progressbar1.visible:=FALSE;
end;

procedure TfrmHnrSoal.Button1Click(Sender: TObject);
begin
  close;
end;

end.

