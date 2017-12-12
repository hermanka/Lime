unit uSoalUjian;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, odbcconn, sqldb, db, FileUtil, LR_Class, LR_DBSet, Forms,
  Controls, Graphics, Dialogs, DbCtrls, DBGrids, Buttons, StdCtrls, ExtCtrls;

type

  { TfrmSoalUjian }

  TfrmSoalUjian = class(TForm)
    btnSimpan: TButton;
    btnSimpann: TButton;
    btnPrint: TButton;
    btnCount: TButton;
    ComboSorter: TComboBox;
    comSifat: TComboBox;
    Datasource1: TDatasource;
    conn: TODBCConnection;
    DBGrid1: TDBGrid;
    eid: TEdit;
    frDBDataSet1: TfrDBDataSet;
    frDBDataSet2: TfrDBDataSet;
    frReport1: TfrReport;
    frReport2: TfrReport;
    gSifat: TGroupBox;
    Label1: TLabel;
    SQLGetInfo: TSQLQuery;
    SQLGetSetting: TSQLQuery;
    SQLTemp: TSQLQuery;
    SQLQuery1: TSQLQuery;
    SQLPrintSingle: TSQLQuery;
    SQLUpdate: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    procedure btnEditClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure btnSimpannClick(Sender: TObject);
    procedure btnCountClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ComboSorterChange(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure DBGrid1EditingDone(Sender: TObject);
    procedure DBGrid2EditingDone(Sender: TObject);
    procedure edSifatEditingDone(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure gSifatClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmSoalUjian: TfrmSoalUjian;

implementation
uses konekMySQL;

{$R *.lfm}

procedure TfrmSoalUjian.FormCreate(Sender: TObject);
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
SQLGetSetting.Active:=False;
SQLGetSetting.SQL.Clear;
SQLGetSetting.SQL.Add('SELECT pengaturan FROM tb_setting WHERE nama_pengaturan="comSifatUjian"');
SQLGetSetting.Active:=True;
while not SQLGetSetting.EOF do begin
      comSifat.Items.Add(SQLGetSetting.Fields[0].AsString);
      SQLGetSetting.Next;
end;

SQLgetInfo.Active:=False;
SQLgetInfo.SQL.Clear;
SQLgetInfo.SQL.Add('SELECT th_akdm, ujian FROM tb_setting_lime limit 1');
SQLgetInfo.Active:=True;
th_akdm:=SQLgetInfo.FieldByName('th_akdm').AsString;
ujian:=SQLgetInfo.FieldByName('ujian').AsString;

if ujian='A' then
   begin
      ujian:='TGL_UAS';
   end
else
    begin
      ujian:='TGL_UTS';
    end;

SQLQuery1.Active:=False;
SQLQuery1.SQL.Clear;
SQLQuery1.Database:=conn;
SQLQuery1.SQL.Add('select tb_jadwal.kd_mk, tb_mk.nm_mk as nama_mk, tb_jadwal.jenis, tb_jadwal.id_jadwal, tb_setting_lime.th_akdm, tb_kary.nama as nama_dosen,'+
     'case tb_setting_lime.ujian '+
     'when "A" then "UAS" '+
     'when "T" then "UTS" '+
     'end as ujian,'+

     'case tb_setting_lime.ujian '+
          'when "A" then tb_jadwal.tgl_uas '+
          'when "T" then tb_jadwal.tgl_uts '+
          'end as tanggal,'+

     'case tb_setting_lime.ujian '+
          'when "A" then tb_jadwal.kd_jam_uas '+
          'when "T" then tb_jadwal.kd_jam_uts '+
          'end as jam,'+

     'case tb_jadwal.jenis '+
          'when "T1" then "TEORI" '+
          'when "T2" then "PRAKTEK" '+
          'when "P1" then "PRAKTEK" '+
          'when "P2" then "PRAKTEK" '+
     'end as tp,'+

     'substring(tb_jadwal.kelompok,5,1) as kelas,'+

     'case '+
          'when kd_hari>5 then "90" '+
     'else "100" '+
     'end as waktu,'+

     'case '+
    'when substring(tb_jadwal.th_akdm,1,1)=1 then "Ganjil" '+
    'else "Genap" '+
    'end as smt, tb_soal.id_soal, tb_soal.sifat, tb_soal.MHS, tb_soal.th_akdm as th_akdm_soal '+

    'from tb_mk, tb_jadwal,tb_setting_lime, tb_kary, tb_soal where '+
    'tb_jadwal.th_akdm=tb_setting_lime.th_akdm AND '+
    'tb_jadwal.kd_mk=tb_mk.kd_mk AND '+
    'tb_jadwal.nik=tb_kary.nik AND '+
    'tb_jadwal.id_jadwal=tb_soal.id_jadwal AND '+
    'tb_jadwal.th_akdm=tb_soal.th_akdm AND '+
    'tb_jadwal.kd_mk=tb_soal.kd_mk AND '+
    'tb_jadwal.jenis=tb_soal.jenis '+
    'group by tb_soal.id_soal');

    SQLTemp.Active:=False;
    SQLTemp.SQL.Clear;

   SQLTemp.SQL.Add(SQLQuery1.SQL.GetText);
   SQLQuery1.Active:=True;


end;

procedure TfrmSoalUjian.FormShow(Sender: TObject);
begin

end;

procedure TfrmSoalUjian.gSifatClick(Sender: TObject);
begin

end;

procedure TfrmSoalUjian.Button2Click(Sender: TObject);
begin

end;

procedure TfrmSoalUjian.ComboSorterChange(Sender: TObject);
var
  sort,ujian:string;
begin
//SQLTemp.SQL.Clear;
//SQLTemp.SQL.Add(SQLQuery1.SQL.GetText);
SQLgetInfo.Active:=False;
SQLgetInfo.SQL.Clear;
SQLgetInfo.SQL.Add('SELECT pengaturan FROM tb_setting WHERE nama_pengaturan="ujian"');
SQLgetInfo.Active:=True;
ujian:=SQLgetInfo.FieldByName('pengaturan').AsString;
if ujian='A' then
   begin
      ujian:='TGL_UAS';
   end
else
    begin
      ujian:='TGL_UTS';
    end;

   sort:=ComboSorter.Text;
   CASE sort OF
   'Jadwal' :
     begin
       SQLQuery1.Active:=FALSE;
       SQLQuery1.SQL.Clear;
       SQLQuery1.SQL.Add(SQLTemp.SQL.GetText+' order by tb_jadwal.'+ujian+',jam');
       SQLQuery1.Active:=TRUE;
     end;
   'Dosen' :
     begin
       SQLQuery1.Active:=FALSE;
       SQLQuery1.SQL.Clear;
       SQLQuery1.SQL.Add(SQLTemp.SQL.GetText+' order by nama_dosen, nama_mk, id_jadwal');
       SQLQuery1.Active:=TRUE;
     end;
   'Mata Kuliah' :
     begin
       SQLQuery1.Active:=FALSE;
       SQLQuery1.SQL.Clear;
       SQLQuery1.SQL.Add(SQLTemp.SQL.GetText+' order by nama_mk, id_jadwal');
       SQLQuery1.Active:=TRUE;
     end;
     ELSE
     SQLQuery1.Active:=FALSE;
     SQLQuery1.SQL.Clear;
     SQLQuery1.SQL.Add(SQLTemp.SQL.GetText);
     SQLQuery1.Active:=TRUE;
   end;
end;

procedure TfrmSoalUjian.DBGrid1CellClick(Column: TColumn);
begin
 gSifat.Enabled:=true;
  comSifat.Text:=SQLQuery1.FieldByName('sifat').asString;
  eid.Text:=SQLQuery1.FieldByName('id_soal').asString;
end;

procedure TfrmSoalUjian.btnEditClick(Sender: TObject);
begin
  gSifat.Enabled:=true;
  comSifat.Text:=SQLQuery1.FieldByName('sifat').asString;
  eid.Text:=SQLQuery1.FieldByName('id_soal').asString;
end;

procedure TfrmSoalUjian.btnPrintClick(Sender: TObject);
var
  strsql, th_akdm, ujian:string;
begin
  strsql:=SQLPrintSingle.SQL.GetText;
  eid.text:=SQLQuery1.FieldByName('id_soal').asString;

  SQLPrintSingle.Active:=False;
  SQLPrintSingle.SQL.Clear;
  SQLPrintSingle.SQL.Add(strsql+' AND tb_soal.id_soal="'+eid.text+'" limit 1');
  SQLPrintSingle.Active:=True;
  SQLPrintSingle.Refresh;
  frReport1.LoadFromFile('report/kop_ujian_single.lrf');
  frReport1.Showreport;
  SQLPrintSingle.Active:=False;
  SQLPrintSingle.SQL.Clear;
  SQLPrintSingle.SQL.Add(strsql);
  strsql:='';
end;

procedure TfrmSoalUjian.btnSimpannClick(Sender: TObject);
var
  ak:string;
begin
  SQLUpdate.Active:=False;
  SQLUpdate.SQL.Clear;
  ak:=SQLQuery1.FieldByName('th_akdm').asString;
  SQLUpdate.SQL.Add('Update tb_soal set sifat="'+comSifat.Text+'" Where id_soal="'+eid.text+'" AND th_akdm="'+ak+'"');
  SQLUpdate.ExecSQL;
  SQLQuery1.Refresh;
  gSifat.Enabled:=false;
end;

procedure TfrmSoalUjian.btnCountClick(Sender: TObject);
var
  th_akdm,sql,id_jadwal,jml, th_akdm_soal:string;
begin
If MessageDlg('Anda akan menghitung ulang jumlah mahasiswa ?',mtConfirmation,[mbYes,mbNo],0)=mrYES then
begin
sql := SQLTemp.sql.GetText;

  th_akdm:=SQLgetInfo.FieldByName('th_akdm').AsString;

  while not SQLQuery1.EOF do begin
    id_jadwal:=SQLQuery1.FieldByName('id_jadwal').asString;
      SQLTemp.Active:=False;
      SQLTemp.SQL.Clear;
      SQLTemp.SQL.Add('select count(*) as jml from tb_krs where id_jadwal="'+id_jadwal+'" and th_akdm="'+th_akdm+'"');
      SQLTemp.Active:=TRUE;
      jml := SQLTemp.FieldByName('jml').asString;
      th_akdm_soal:=SQLQuery1.FieldByName('th_akdm_soal').AsString;
      SQLUpdate.Active:=False;
      SQLUpdate.SQL.Clear;
      SQLUpdate.SQL.Add('Update tb_soal set MHS="'+jml+'" Where id_jadwal="'+id_jadwal+'" AND th_akdm="'+th_akdm_soal+'"');
      SQLUpdate.ExecSQL;
      SQLQuery1.Next;
  end;
  SQLQuery1.Refresh;
  SQLTemp.SQL.Add(sql);
  end;
end;

procedure TfrmSoalUjian.DBGrid1EditingDone(Sender: TObject);
begin

end;

procedure TfrmSoalUjian.DBGrid2EditingDone(Sender: TObject);
begin


end;

procedure TfrmSoalUjian.edSifatEditingDone(Sender: TObject);
begin

end;

procedure TfrmSoalUjian.SpeedButton1Click(Sender: TObject);
begin

end;


end.

