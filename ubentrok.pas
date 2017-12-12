unit uBentrok;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, odbcconn, sqldb, db, FileUtil, Forms, Controls, Graphics,
  Dialogs, StdCtrls, DBGrids, ComCtrls, Calendar, EditBtn;

type

  { TfrmBentrok }

  TfrmBentrok = class(TForm)
    btnCekBentrok: TButton;
    btnCekJadwalUjian: TButton;
    conn: TODBCConnection;
    Datasource1: TDatasource;
    DBGrid1: TDBGrid;
    eIDJadwal: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    lblTHAKDM: TLabel;
    ProgressBar1: TProgressBar;
    SQLQuery1: TSQLQuery;
    SQLGetInfo: TSQLQuery;
    SQLtmpJad: TSQLQuery;
    SQLtmp2: TSQLQuery;
    SQLtmp: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    procedure btnCekBentrokClick(Sender: TObject);
    procedure btnCekJadwalUjianClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmBentrok: TfrmBentrok;

implementation
uses konekMySQL;

{ TfrmBentrok }

procedure TfrmBentrok.FormCreate(Sender: TObject);
begin
frmBentrok.Height:=75;
conn.Driver := Koneksi('driver');
conn.UserName := Koneksi('username');
conn.Password := Koneksi('password');
conn.Params.Add('SERVER='+Koneksi('server'));
conn.Params.Add('PORT='+Koneksi('port'));
conn.Params.Add('DATABASE='+Koneksi('database'));
SQLTransaction1.DataBase:=conn;
SQLQuery1.Database:=conn;
SQLQuery1.SQL.Clear;
SQLQuery1.SQL.Add('SELECT * FROM forlap_trnlm');
Datasource1.Dataset:=SQLQuery1;
//DBGrid1.Datasource:=Datasource1;
SQLQuery1.Active:=TRUE;
SQLgetInfo.Active:=False;
SQLgetInfo.SQL.Clear;
SQLgetInfo.SQL.Add('SELECT pengaturan FROM tb_setting where nama_pengaturan="th_akdm" LIMIT 1');
SQLgetInfo.Active:=True;
lblTHAKDM.Caption:='TH AKDM di tb_setting : '+SQLgetInfo.FieldByName('pengaturan').AsString;
end;

procedure TfrmBentrok.btnCekBentrokClick(Sender: TObject);
var
  th_akdm,nim:string;
begin
  SQLgetInfo.Active:=False;
  SQLgetInfo.SQL.Clear;
  SQLgetInfo.SQL.Add('SELECT pengaturan FROM tb_setting where nama_pengaturan="th_akdm" LIMIT 1');
  SQLgetInfo.Active:=True;

  frmBentrok.Height:=75;
  DBGrid1.visible:=FALSE;
  progressbar1.visible:=TRUE;
  progressbar1.position:=0;
  th_akdm:=SQLgetInfo.FieldByName('pengaturan').AsString;
  SQLQuery1.Active:=FALSE;
  SQLQuery1.SQL.Clear;
  SQLQuery1.SQL.Add('SELECT nim FROM tb_krs WHERE TH_AKDM="'+th_akdm+'" AND id_jadwal ="'+eIDJadwal.Text+'"');
  SQLQuery1.Active:=TRUE;

  SQLtmp2.Active:=False;
  SQLtmp2.SQL.Clear;
  //hitung jumlah nim
  SQLtmp2.SQL.Add('select count(*) from'
  +'('
  +' SELECT nim'
  +' from tb_krs'
  +' where TH_AKDM="'+th_akdm+'" AND id_jadwal ="'+eIDJadwal.Text+'"'
  +' group by NIM'
  +' ) as total');
  SQLtmp2.Active:=TRUE;
  progressbar1.max:=StrToInt(SQLtmp2.FieldByName('count(*)').AsString);

  SQLtmp2.Active:=False;
  SQLtmp2.SQL.Clear;
  SQLtmp2.SQL.Add('DELETE FROM _tb_bentrok_mk');
  SQLtmp2.ExecSQL;
  while not SQLQuery1.Eof do
  begin
     nim:=SQLQuery1.FieldByName('nim').AsString;
     SQLtmp.Active:=False;
     SQLtmp.SQL.Clear;
     SQLtmp.SQL.Add('SELECT tb_krs.id_jadwal,tb_krs.kd_mk,tb_mk.nm_mk,tb_mk.smt FROM tb_krs,tb_mk WHERE tb_krs.TH_AKDM="'+th_akdm+'" AND tb_krs.nim ="'+nim+'" AND tb_mk.kd_mk=tb_krs.kd_mk GROUP BY tb_krs.kd_mk');
     SQLtmp.Active:=True;
     while not SQLtmp.Eof do
     begin
     SQLtmp2.Active:=False;
     SQLtmp2.SQL.Clear;
     SQLtmp2.SQL.Add('INSERT INTO _tb_bentrok_mk VALUES("'
     +SQLtmp.FieldByName('id_jadwal').AsString+'","'+SQLtmp.FieldByName('kd_mk').AsString+'","'+SQLtmp.FieldByName('nm_mk').AsString+'","'
     +SQLtmp.FieldByName('smt').AsString+'")');
     SQLtmp2.ExecSQL;
     SQLtmp2.SQL.Clear;
     SQLtmp.Next;
     end;
     progressbar1.position:=progressbar1.position+1;
     SQLQuery1.Next;
  end;
  MessageDlg('Selesai!', mtInformation,[mbOK],0);

  // Setting Kolom DBGRID
  DBGrid1.Columns.Clear;
  DBGrid1.Columns.Add;
  with DBGrid1.Columns[DBGrid1.Columns.Count - 1] do begin
    FieldName := 'id_jadwal';
    Title.Caption := 'ID';
    Width := 30;
  end;
  DBGrid1.Columns.Add;
  with DBGrid1.Columns[DBGrid1.Columns.Count - 1] do begin
    FieldName := 'kd_mk';
    Title.Caption := 'Kode MK';
    Width := 100;
  end;
  DBGrid1.Columns.Add;
  with DBGrid1.Columns[DBGrid1.Columns.Count - 1] do begin
    FieldName := 'nm_mk';
    Title.Caption := 'Mata Kuliah yang tidak boleh seJadwal';
  end;
  DBGrid1.Columns.Add;
  with DBGrid1.Columns[DBGrid1.Columns.Count - 1] do begin
    FieldName := 'smt';
    Title.Caption := 'smt';
    Width := 30;
  end;
  // Akhir Setting Kolom DBGRID

  SQLtmp2.Active:=False;
  SQLtmp2.SQL.Clear;
  SQLtmp2.SQL.Add('SELECT * FROM _tb_bentrok_mk GROUP BY id_jadwal ORDER BY id_jadwal,smt,nm_mk');
  SQLtmp2.Active:=True;
  Datasource1.Dataset:=SQLtmp2;
  DBGrid1.Datasource:=Datasource1;
  frmBentrok.Height:=340;
  DBGrid1.visible:=TRUE;

end;

procedure TfrmBentrok.btnCekJadwalUjianClick(Sender: TObject);
var
  ujian,th_akdm,nim,id_jadwal,id_jadwal2,kd_mk,kd_jam,tipe,kd_mk2,tipe2,cek,tgl:string;
begin
  SQLgetInfo.Active:=False;
  SQLgetInfo.SQL.Clear;
  SQLgetInfo.SQL.Add('SELECT pengaturan FROM tb_setting where nama_pengaturan="th_akdm" LIMIT 1');
  SQLgetInfo.Active:=True;

  frmBentrok.Height:=75;
  DBGrid1.visible:=FALSE;
  progressbar1.visible:=TRUE;
  progressbar1.position:=0;
  th_akdm:=SQLgetInfo.FieldByName('pengaturan').AsString;

    SQLgetInfo.Active:=False;
    SQLgetInfo.SQL.Clear;
    SQLgetInfo.SQL.Add('SELECT pengaturan FROM tb_setting where nama_pengaturan="ujian" LIMIT 1');
    SQLgetInfo.Active:=True;

  ujian:=SQLgetInfo.FieldByName('pengaturan').AsString;
  SQLQuery1.Active:=FALSE;
  SQLQuery1.SQL.Clear;
  //mendapatkan nim pada KRS sesuai th akdm
  SQLQuery1.SQL.Add('SELECT NIM FROM tb_krs WHERE TH_AKDM="'+th_akdm+'" GROUP BY NIM');

  SQLtmp2.Active:=False;
  SQLtmp2.SQL.Clear;
  //hitung jumlah nim
  SQLtmp2.SQL.Add('select count(*) from'
  +'('
  +' SELECT nim'
  +' from tb_krs'
  +' where th_akdm="'+th_akdm+'"'
  +' group by NIM'
  +' ) as total');
  SQLtmp2.Active:=TRUE;
  progressbar1.max:=StrToInt(SQLtmp2.FieldByName('count(*)').AsString);

  SQLQuery1.Active:=TRUE;
  SQLtmp2.Active:=False;
  SQLtmp2.SQL.Clear;
  //kosongkan temporary
  SQLtmp2.SQL.Add('DELETE FROM _tb_cek_bentrok_ujian');
  SQLtmp2.ExecSQL;
  SQLtmp2.Active:=False;
  SQLtmp2.SQL.Clear;
  //kosongkan temporary
  SQLtmp2.SQL.Add('DELETE FROM _tb_cek_bentrok_ujian_hasil');
  SQLtmp2.ExecSQL;

  while not SQLQuery1.Eof do
  begin

     nim:=SQLQuery1.FieldByName('nim').AsString;
     SQLtmp.Active:=False;
     SQLtmp.SQL.Clear;
     // ambil id_jadwal dan kd_mk untuk nim tertentu
     SQLtmp.SQL.Add('SELECT ID_JADWAL,KD_MK FROM tb_krs WHERE NIM="'+nim+'" AND TH_AKDM="'+th_akdm+'"');
     SQLtmp.Active:=True;
     while not SQLtmp.Eof do
     begin
     id_jadwal:=SQLtmp.FieldByName('id_jadwal').AsString;
     kd_mk:=SQLtmp.FieldByName('kd_mk').AsString;
     SQLtmpJad.Active:=False;
     SQLtmpJad.SQL.Clear;
     // ambil tgl dan kd_jam ujian untuk masing2 id_jadwal
     SQLtmpJad.SQL.Add('SELECT TGL_U'+ujian+'S,KD_JAM_U'+ujian+'S,jenis FROM tb_jadwal WHERE ID_JADWAL="'+id_jadwal+'" AND TH_AKDM="'+th_akdm+'"');
     SQLtmpJad.Active:=TRUE;
     while not SQLtmpJad.Eof do
     begin
     tgl:=SQLtmpJad.FieldByName('TGL_U'+ujian+'S').AsString;
     kd_jam:=SQLtmpJad.FieldByName('KD_JAM_U'+ujian+'S').AsString;
     tipe:=SQLtmpJad.FieldByName('jenis').AsString;
     SQLtmp2.Active:=False;
     SQLtmp2.SQL.Clear;
     SQLtmp2.SQL.Add('SELECT cek FROM _tb_cek_bentrok_ujian WHERE tgl="'+tgl+'" AND jam="'+kd_jam+'"');
     SQLtmp2.Active:=TRUE;
     cek:=SQLtmp2.FieldByName('cek').AsString;
     if cek='1' then
     begin

          SQLtmp2.Active:=False;
          SQLtmp2.SQL.Clear;
          SQLtmp2.SQL.Add('SELECT id_jadwal,kd_mk,tipe FROM _tb_cek_bentrok_ujian WHERE tgl="'+tgl+'" AND jam="'+kd_jam+'"');
          SQLtmp2.Active:=TRUE;
          id_jadwal2:=SQLtmp2.FieldByName('id_jadwal').AsString;
          kd_mk2:=SQLtmp2.FieldByName('kd_mk').AsString;
          tipe2:=SQLtmp2.FieldByName('tipe').AsString;
          SQLtmp2.Active:=False;
          SQLtmp2.SQL.Clear;
          SQLtmp2.SQL.Add('INSERT INTO _tb_cek_bentrok_ujian_hasil (NIM,id_jadwal1,mk1,tipe1,id_jadwal2,mk2,tipe2) VALUES ("'+nim+'","'+id_jadwal+'","'+kd_mk+'","'+tipe+'","'+id_jadwal2+'","'+kd_mk2+'","'+tipe2+'")');
          SQLtmp2.ExecSQL;
     end
     else
     begin
          SQLtmp2.Active:=False;
          SQLtmp2.SQL.Clear;
          SQLtmp2.SQL.Add('INSERT INTO _tb_cek_bentrok_ujian (tgl,jam,cek,id_jadwal,kd_mk,tipe) VALUES ("'+tgl+'","'+kd_jam+'","1","'+id_jadwal+'","'+kd_mk+'","'+tipe+'")');
          SQLtmp2.ExecSQL;
     end;
     SQLtmpJad.Next;
     end;
     SQLtmp.Next;
     end;

     SQLtmp2.Active:=False;
     SQLtmp2.SQL.Clear;
     //kosongkan temporary
     SQLtmp2.SQL.Add('DELETE FROM _tb_cek_bentrok_ujian');
     SQLtmp2.ExecSQL;
     SQLtmp2.Active:=False;
     progressbar1.position:=progressbar1.position+1;
     SQLQuery1.Next;
  end;
  MessageDlg('Selesai!', mtInformation,[mbOK],0);
  // Setting Kolom DBGRID
  DBGrid1.Columns.Clear;
  DBGrid1.Columns.Add;
  with DBGrid1.Columns[DBGrid1.Columns.Count - 1] do begin
    FieldName := 'tipe1';
    Title.Caption := 'T/P';
    Width := 35;
    Alignment:=taCenter;
    Title.Alignment:=taCenter;
  end;
  DBGrid1.Columns.Add;
  with DBGrid1.Columns[DBGrid1.Columns.Count - 1] do begin
    FieldName := 'mk1';
    Title.Caption := 'MK 1';
    Width := 180;
  end;
  DBGrid1.Columns.Add;
  with DBGrid1.Columns[DBGrid1.Columns.Count - 1] do begin
    FieldName := 'id_jadwal1';
    Title.Caption := 'ID 1';
    Width := 40;
    Alignment:=taCenter;
    Title.Alignment:=taCenter;
  end;
  DBGrid1.Columns.Add;
  with DBGrid1.Columns[DBGrid1.Columns.Count - 1] do begin
    FieldName := ' ';
    Title.Caption := ' ';
    Width := 30;
    Color:=$00CACACA;
  end;
  DBGrid1.Columns.Add;
  with DBGrid1.Columns[DBGrid1.Columns.Count - 1] do begin
    FieldName := 'id_jadwal2';
    Title.Caption := 'ID 2';
    Width := 40;
    Alignment:=taCenter;
    Title.Alignment:=taCenter;
  end;
  DBGrid1.Columns.Add;
  with DBGrid1.Columns[DBGrid1.Columns.Count - 1] do begin
    FieldName := 'mk2';
    Title.Caption := 'MK 2';
    Width := 180;
  end;
  DBGrid1.Columns.Add;
  with DBGrid1.Columns[DBGrid1.Columns.Count - 1] do begin
    FieldName := 'tipe2';
    Title.Caption := 'T/P';
    Width := 35;
    Alignment:=taCenter;
    Title.Alignment:=taCenter;
  end;
  // Akhir Setting Kolom DBGRID

  SQLtmp2.Active:=False;
  SQLtmp2.SQL.Clear;
  SQLtmp2.SQL.Add('SELECT * FROM _tb_cek_bentrok_ujian_hasil WHERE id_jadwal1!=id_jadwal2 GROUP BY ID_JADWAL1, TIPE1 ORDER BY id_jadwal1');
  SQLtmp2.Active:=True;
  Datasource1.Dataset:=SQLtmp2;
  DBGrid1.Datasource:=Datasource1;
  frmBentrok.Height:=340;
  DBGrid1.visible:=TRUE;
end;

{$R *.lfm}

end.

