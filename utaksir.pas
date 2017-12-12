unit uTaksir;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, odbcconn, sqldb, db, FileUtil, Forms, Controls, Graphics,
  Dialogs, DbCtrls, StdCtrls, DBGrids, Grids, ComCtrls;

type

  { TfrmTaksir }

  TfrmTaksir = class(TForm)
    btnGo: TButton;
    btnInc: TButton;
    btnIterate: TButton;
    conn: TODBCConnection;
    SourceInc: TDataSource;
    grid2: TDBGrid;
    lblCount: TLabel;
    ProgressBar1: TProgressBar;
    Source2: TDataSource;
    Grid1: TDBGrid;
    Label1: TLabel;
    SourceAKDM: TDataSource;
    comboAKDM: TDBLookupComboBox;
    Source: TDataSource;
    Qakdm: TSQLQuery;
    Q1: TSQLQuery;
    Q2: TSQLQuery;
    Qjdw: TSQLQuery;
    QCount: TSQLQuery;
    QNilai: TSQLQuery;
    Qinsert: TSQLQuery;
    Qinc: TSQLQuery;
    Qupdate: TSQLQuery;
    Trans1: TSQLTransaction;
    procedure btnGoClick(Sender: TObject);
    procedure btnIncClick(Sender: TObject);
    procedure btnIterateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmTaksir: TfrmTaksir;

implementation
uses konekMySQL;
{$R *.lfm}

{ TfrmTaksir }

procedure TfrmTaksir.FormCreate(Sender: TObject);
begin
lblCount.Caption:='';
conn.Driver := Koneksi('driver');
conn.UserName := Koneksi('username');
conn.Password := Koneksi('password');
conn.Params.Add('SERVER='+Koneksi('server'));
conn.Params.Add('PORT='+Koneksi('port'));
conn.Params.Add('DATABASE='+Koneksi('database'));
trans1.DataBase:=conn;
Q1.Database:=conn;
Qinc.Database:=conn;
Qakdm.Database:=conn;
Q2.Database:=conn;
Qjdw.Database:=conn;
QCount.Database:=conn;
QNilai.Database:=conn;
Qinsert.Database:=conn;
Qupdate.Database:=conn;
Qinsert.Transaction:=trans1;
Q1.SQL.Clear;
Qinc.SQL.Clear;
Qakdm.SQL.Clear;
Qupdate.SQL.Clear;
Qakdm.SQL.Add('SELECT * FROM tb_th_akdm');
//Source.Dataset:=Qakdm;
SourceAKDM.Dataset:=Qakdm;
SourceInc.Dataset:=Qinc;
//Grid1.Datasource:=SourceAKDM;
Qakdm.Active:=TRUE;
Q1.Active:=FALSE;
Q1.SQL.Clear;
Q1.SQL.Add('select tb_taksir.kd_mk, COUNT(*) as jml_mhs, tb_taksir.kd_progdi, tb_taksir.kd_kur, tb_taksir.kelas, tb_mk.nm_mk '+
                       'from tb_taksir, tb_mk '+
                       'where tb_taksir.kd_mk=tb_mk.kd_mk '+
                       'AND tb_taksir.inc="0"'+
                       'group by kelas, kd_mk order by kelas, kd_mk');
Q1.Active:=TRUE;
Qinc.Active:=FALSE;
Qinc.SQL.Clear;
Qinc.SQL.Add('select tb_taksir.kd_mk, COUNT(*) as jml_mhs, tb_taksir.kd_progdi, tb_taksir.kd_kur, tb_taksir.kelas, tb_mk.nm_mk '+
                       'from tb_taksir, tb_mk '+
                       'where tb_taksir.kd_mk=tb_mk.kd_mk '+
                       'AND tb_taksir.inc="1"'+
                       'group by kelas, kd_mk order by kelas, kd_mk');
Qinc.Active:=TRUE;

Source.Dataset:=Q1;
grid1.DataSource:=Source;
grid2.DataSource:=SourceInc;
end;



procedure TfrmTaksir.btnGoClick(Sender: TObject);
var
  th_akdm, kd_kur, kd_progdi, kd_mk, nim, kelompok, tmp, sks: string;
  count : integer;
begin
   count:=0;
   progressbar1.visible:=TRUE;
   progressbar1.position:=0;


   th_akdm := comboAKDM.KeyValue;
   QCount.Active:=FALSE;
   QCount.SQL.Clear;
   QNilai.Active:=FALSE;
   QNilai.SQL.Clear;
   Q1.Active:=FALSE;
   Q1.SQL.Clear;
   Q2.Active:=FALSE;
   Q2.SQL.Clear;
   Qjdw.Active:=FALSE;
   Qjdw.SQL.Clear;
   Q1.SQL.Add('SELECT tb_mhs_aktif.NIM, tb_mahasiswa.KD_KUR, tb_mahasiswa.kd_progdi, tb_mahasiswa.kelompok '+
                      'FROM tb_mhs_aktif, tb_mahasiswa '+
                      'WHERE tb_mhs_aktif.NIM=tb_mahasiswa.NIM '+
                      'AND tb_mhs_aktif.TH_AKDM="'+th_akdm+'" and tb_mahasiswa.STAT_STUDI="A"');

   Source.Dataset:=Q1;
   Q1.Active:=TRUE;
   QCount.SQL.Add('SELECT count(*) as total '+
                      'FROM tb_mhs_aktif, tb_mahasiswa '+
                      'WHERE tb_mhs_aktif.NIM=tb_mahasiswa.NIM '+
                      'AND tb_mhs_aktif.TH_AKDM="'+th_akdm+'" and tb_mahasiswa.STAT_STUDI="A"');
   QCount.Active:=TRUE;
   progressbar1.max:=StrToInt(QCount.FieldByName('total').AsString);

   Qinsert.Active:=False;
   Qinsert.SQL.Clear;
   Qinsert.SQL.Add('DELETE FROM tb_taksir');
   Qinsert.ExecSQL;

    while not Q1.Eof do
    begin
        kd_kur    := Q1.FieldByName('KD_KUR').AsString;
        kd_progdi := Q1.FieldByName('kd_progdi').AsString;
        kelompok := Q1.FieldByName('kelompok').AsString;
        nim := Q1.FieldByName('nim').AsString;
        Q2.Active:=FALSE;
        Q2.SQL.Clear;
        Q2.SQL.Add('SELECT * FROM tb_mk WHERE kd_kur="'+kd_kur+'" AND kd_progdi="'+kd_progdi+'" AND status=1');
        Source2.Dataset:=Q2;
        Q2.Active:=TRUE;
        while not Q2.Eof do
        begin
             kd_mk := Q2.FieldByName('kd_mk').AsString;
             sks := Q2.FieldByName('sks').AsString;
             // memastikan mk sudah ditawarkan semester sebelumnya
             Qjdw.Active:=FALSE;
             Qjdw.SQL.Clear;
             Qjdw.SQL.Add('SELECT KD_MK FROM tb_jadwal WHERE th_akdm="'+th_akdm+'" AND kd_mk="'+kd_mk+'" LIMIT 1');
             Qjdw.Active:=TRUE;

             if ( Qjdw.FieldByName('KD_MK').AsString='' ) THEN
             begin
                    // memastikan mk sudah diambil mahasiswa & punya nilai
                    QNilai.Active:=False;
                    QNilai.SQL.Clear;
                    QNilai.SQL.Add('SELECT KD_MK FROM tb_nilai WHERE nim="'+nim+'" AND kd_mk="'+kd_mk+'" LIMIT 1');
                    QNilai.Active:=TRUE;
                    if ( QNilai.FieldByName('KD_MK').AsString='' ) THEN
                    begin
                         //memo.Lines.Add(kd_mk);
                         count := count+1;

                         Qinsert.Active:=False;
                         Qinsert.SQL.Clear;
                         Qinsert.SQL.Add('INSERT INTO tb_taksir VALUES("'+th_akdm+'","'+nim+'","'+kelompok+'","'+kd_kur+'", "'+kd_progdi+'", "'+kd_mk+'","'+sks+'", "")');
                         Qinsert.ExecSQL;
                    end;
             end;
             Q2.Next;
        end;
        progressbar1.position:=progressbar1.position+1;
        Q1.Next;
    end;
    lblCount.caption:=IntToStr(count);
    Q1.Active:=FALSE;
    Q1.SQL.Clear;
    Q1.SQL.Add('SELECT tb_mhs_aktif.NIM, tb_mahasiswa.KD_KUR, tb_mahasiswa.kd_progdi, tb_mahasiswa.kelompok '+
                      'FROM tb_mhs_aktif, tb_mahasiswa '+
                      'WHERE tb_mhs_aktif.NIM=tb_mahasiswa.NIM '+
                      'AND tb_mhs_aktif.TH_AKDM="'+th_akdm+'"');
    Q1.Active:=TRUE;
    Source.Dataset:=Q1;
    grid1.DataSource:=Source;

end;

procedure TfrmTaksir.btnIncClick(Sender: TObject);
var
  th_akdm, kelas, kd_kur, kd_progdi, kd_mk: string;
begin

  kelas:=Q1.FieldByName('kelas').AsString;
  kd_kur:=Q1.FieldByName('kd_kur').AsString;
  kd_progdi:=Q1.FieldByName('kd_progdi').AsString;
  kd_mk:=Q1.FieldByName('kd_mk').AsString;
  Qinc.Active:=FALSE;
  //Q1.Active:=FALSE;
  Qupdate.Active:=False;
  Qupdate.SQL.Clear;
  Qupdate.SQL.Add('UPDATE tb_taksir SET inc="1" WHERE kelas="'+kelas+'" AND kd_kur="'+kd_kur+'" AND kd_progdi="'+kd_progdi+'" AND kd_mk="'+kd_mk+'"');
  Qupdate.ExecSQL;


  Q1.Refresh;
  Qinc.Active:=TRUE;
end;

procedure TfrmTaksir.btnIterateClick(Sender: TObject);
var
  sks, nim, kd_mk, kelas, kd_progdi, kd_kur, th_akdm: string;
  tot_sks : integer;
begin
  progressbar1.visible:=TRUE;
   progressbar1.position:=0;
   QCount.Active:=FALSE;
   QCount.SQL.Clear;
   QCount.SQL.Add('SELECT count(*) as total '+
                      'FROM tb_taksir '+
                      'WHERE th_akdm="'+th_akdm+'"');
   QCount.Active:=TRUE;
   progressbar1.max:=StrToInt(QCount.FieldByName('total').AsString);

   th_akdm := comboAKDM.KeyValue;
   Q1.Active:=FALSE;
   Q1.SQL.Clear;
   Q1.SQL.Add('SELECT * FROM tb_taksir WHERE TH_AKDM="'+th_akdm+'" GROUP BY nim');
   Q1.Active:=TRUE;
    while not Q1.Eof do
    begin
        nim := Q1.FieldByName('nim').AsString;
        Q2.Active:=FALSE;
        Q2.SQL.Clear;
        Q2.SQL.Add('SELECT * FROM tb_taksir WHERE th_akdm="'+th_akdm+'" AND nim="'+nim+'" ORDER BY kd_mk');
        Q2.Active:=TRUE;
        tot_sks := 0;
         while not Q2.Eof do
         begin
            sks := Q2.FieldByName('sks').AsString;
            kd_mk := Q2.FieldByName('kd_mk').AsString;
            kelas := Q2.FieldByName('kelas').AsString;
            kd_progdi := Q2.FieldByName('kd_progdi').AsString;
            kd_kur := Q2.FieldByName('kd_kur').AsString;
            tot_sks := tot_sks+strtoint(sks);
            if (tot_sks>24) THEN
            begin
              Qupdate.Active:=False;
              Qupdate.SQL.Clear;
              Qupdate.SQL.Add('DELETE FROM tb_taksir WHERE nim="'+nim+'" AND kelas="'+kelas+'" AND kd_kur="'+kd_kur+'" AND kd_progdi="'+kd_progdi+'" AND kd_mk="'+kd_mk+'" AND th_akdm="'+th_akdm+'"');
              Qupdate.ExecSQL;
            end;
            Q2.Next;
         end;
         progressbar1.position:=progressbar1.position+1;
         Q1.Next;
    end;
end;


end.

