unit jdwgen;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, odbcconn, sqldb, db, FileUtil, Forms, Controls, Graphics,
  Dialogs, StdCtrls, DBGrids, ComCtrls, DbCtrls;

type

  { TfrmJdwGen }

  TfrmJdwGen = class(TForm)
    btnGenerate: TButton;
    conn: TODBCConnection;
    Datasource1: TDataSource;
    datasourceListTHakdm: TDataSource;
    DBGrid1: TDBGrid;
    comboTHAKDM: TDBLookupComboBox;
    Label1: TLabel;
    Label2: TLabel;
    ProgressBar1: TProgressBar;
    SQLGetInfo: TSQLQuery;
    SQLQuery1: TSQLQuery;
    SQLlistTHakdm: TSQLQuery;
    SQLtmp: TSQLQuery;
    SQLtmp2: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    procedure btnGenerateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmJdwGen: TfrmJdwGen;

implementation
uses konekMySQL;

{$R *.lfm}

{ TfrmJdwGen }

procedure TfrmJdwGen.FormCreate(Sender: TObject);
begin
  conn.Driver := Koneksi('driver');
  conn.UserName := Koneksi('username');
  conn.Password := Koneksi('password');
  conn.Params.Add('SERVER='+Koneksi('server'));
  conn.Params.Add('PORT='+Koneksi('port'));
  conn.Params.Add('DATABASE='+Koneksi('database'));
  SQLTransaction1.DataBase:=conn;
  SQLQuery1.Database:=conn;
  SQLQuery1.SQL.Clear;

  SQLgetInfo.Active:=False;
  SQLgetInfo.SQL.Clear;
  SQLgetInfo.SQL.Add('SELECT * FROM tb_swu LIMIT 1');
  SQLgetInfo.Active:=True;
  SQLlistTHakdm.Active:=True;
  frmJdwGen.Height:=75;
end;

procedure TfrmJdwGen.btnGenerateClick(Sender: TObject);
var
  th_akdm, jamAwal, jamAkhir, dosen: string;
begin
  frmJdwGen.Height:=75;
  th_akdm:=comboTHAKDM.KeyValue;
  progressbar1.visible:=TRUE;
  progressbar1.position:=0;
  SQLQuery1.Active:=FALSE;
  SQLQuery1.SQL.Clear;
  SQLQuery1.SQL.Add('SELECT '+
                            'tb_mk.smt,tb_mk.kd_kur,tb_mk.nm_mk,tb_mk.sks_t,tb_mk.sks_p,tb_mk.sks,tb_mk.kd_progdi,'+
                            'tb_hari.HARI, '+
                            'tb_ruang.NM_RUANG, '+
                            'tb_jadwal.ID_JADWAL,tb_jadwal.TH_AKDM,tb_jadwal.KD_MK, tb_jadwal.KELOMPOK,tb_jadwal.NIK,'+
                            'tb_jadwal.KELAS,tb_jadwal.JJAD,tb_jadwal.JADKE,tb_jadwal.jenis,tb_jadwal.KD_HARI,tb_jadwal.KD_JAM_AWAL, tb_jadwal.KD_JAM_AKHIR ' +
                            'FROM tb_jadwal '+
                            'INNER JOIN tb_mk ON tb_jadwal.KD_MK = tb_mk.kd_mk '+
                            'INNER JOIN tb_hari ON tb_jadwal.KD_HARI = tb_hari.KD_HARI '+
                            'INNER JOIN tb_ruang ON tb_jadwal.KD_RUANG = tb_ruang.KD_RUANG '+
                            'WHERE TH_AKDM="'+th_akdm+'" ORDER BY tb_jadwal.ID_JADWAL');
  SQLQuery1.Active:=TRUE;


  // hitung jumlah record id_jadwal
  SQLtmp2.Active:=False;
  SQLtmp2.SQL.Clear;
  SQLtmp2.SQL.Add('select count(*) from'
  +'('
  +SQLQuery1.SQL.Text
  +' ) as total');
  SQLtmp2.Active:=TRUE;
  progressbar1.max:=StrToInt(SQLtmp2.FieldByName('count(*)').AsString);

  // delete record tb_jadwal_temp
  SQLtmp2.Active:=False;
  SQLtmp2.SQL.Clear;
  SQLtmp2.SQL.Add('DELETE FROM tb_jadwal_temp');
  SQLtmp2.ExecSQL;

  while not SQLQuery1.Eof do
  begin
     // Cari Dosen
     SQLtmp2.Active:=FALSE;
     SQLtmp2.SQL.Clear;
     SQLtmp2.SQL.Add('SELECT * FROM tb_kary WHERE NIK="'+SQLQuery1.FieldByName('NIK').AsString+'"');
     SQLtmp2.Active:=TRUE;
     dosen := SQLtmp2.FieldByName('nama').AsString;

     // Cari Jam Awal Perkuliahan
     SQLtmp2.Active:=FALSE;
     SQLtmp2.SQL.Clear;
     SQLtmp2.SQL.Add('SELECT * FROM tb_jamkul WHERE kd_jamkul="'+SQLQuery1.FieldByName('KD_JAM_AWAL').AsString+'"');
     SQLtmp2.Active:=TRUE;
     jamAwal := SQLtmp2.FieldByName('jam_awal').AsString;

     // Cari Jam Akhir Perkuliahan
     SQLtmp2.Active:=FALSE;
     SQLtmp2.SQL.Clear;
     SQLtmp2.SQL.Add('SELECT * FROM tb_jamkul WHERE kd_jamkul="'+SQLQuery1.FieldByName('KD_JAM_AKHIR').AsString+'"');
     SQLtmp2.Active:=TRUE;
     jamAkhir := SQLtmp2.FieldByName('jam_akhir').AsString;

     SQLtmp.Active:=False;
     SQLtmp.SQL.Clear;
     SQLtmp.SQL.Add('INSERT INTO tb_jadwal_temp VALUES("'
     +SQLQuery1.FieldByName('ID_JADWAL').AsString+'","'
     +SQLQuery1.FieldByName('TH_AKDM').AsString+'","'
     +SQLQuery1.FieldByName('smt').AsString+'","'
     +SQLQuery1.FieldByName('KD_MK').AsString+'","'
     +SQLQuery1.FieldByName('nm_mk').AsString+'","'
     +SQLQuery1.FieldByName('kd_kur').AsString+'","'
     +SQLQuery1.FieldByName('KELOMPOK').AsString+'","'
     +SQLQuery1.FieldByName('kd_progdi').AsString+'","'
     +SQLQuery1.FieldByName('KELAS').AsString+'","'
     +dosen+'","'
     +SQLQuery1.FieldByName('KD_HARI').AsString+'","'
     +SQLQuery1.FieldByName('KD_JAM_AWAL').AsString+'","'
     +SQLQuery1.FieldByName('KD_JAM_AKHIR').AsString+'","'
     +SQLQuery1.FieldByName('HARI').AsString+'","'
     +jamAwal+'","'
     +jamAkhir+'","'
     +SQLQuery1.FieldByName('NM_RUANG').AsString+'","'
     +SQLQuery1.FieldByName('JJAD').AsString+'","'
     +SQLQuery1.FieldByName('JADKE').AsString+'","'
     +SQLQuery1.FieldByName('sks').AsString+'","'
     +SQLQuery1.FieldByName('sks_t').AsString+'","'
     +SQLQuery1.FieldByName('sks_p').AsString+'","'
     +SQLQuery1.FieldByName('jenis').AsString+'")');
     SQLtmp.ExecSQL;
     SQLtmp.SQL.Clear;
     progressbar1.position:=progressbar1.position+1;
     SQLQuery1.Next;
  end;
  MessageDlg('Selesai!', mtInformation,[mbOK],0);
  SQLQuery1.Active:=FALSE;
  SQLQuery1.SQL.Clear;
  SQLQuery1.SQL.Add('SELECT * FROM tb_jadwal_temp WHERE TH_AKDM="'+th_akdm+'" ORDER BY ID_JADWAL');
  SQLQuery1.Active:=TRUE;
  Datasource1.Dataset:=SQLQuery1;
  DBGrid1.Datasource:=Datasource1;
  DBGrid1.Visible:=TRUE;
  frmJdwGen.Height:=340;
end;

end.

