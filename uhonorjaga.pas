unit uHonorJaga;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, odbcconn, sqldb, db, FileUtil, RTTICtrls, LR_DBSet,
  LR_Class, Forms, Controls, Graphics, Dialogs, DBGrids, DbCtrls, StdCtrls,
  EditBtn, ComCtrls, Buttons, ExtCtrls;

type

  { TfrmHnrJaga }

  TfrmHnrJaga = class(TForm)
    bitHapus: TBitBtn;
    bitPost: TBitBtn;
    bitSimpan: TBitBtn;
    BitPrint: TBitBtn;
    btnHonorDosen: TButton;
    comboPrint: TComboBox;
    comboPK: TComboBox;
    conn: TODBCConnection;
    Datasource1: TDatasource;
    DateEdit1: TDateEdit;
    DBLookComboFilter: TDBLookupComboBox;
    DSComboFilter: TDatasource;
    DatasourceListJam: TDatasource;
    DatasourceListKary: TDatasource;
    DBGrid1: TDBGrid;
    comboKary: TDBLookupComboBox;
    comboJam: TDBLookupComboBox;
    frDBDataSet1: TfrDBDataSet;
    frReport1: TfrReport;
    GroupJaga: TGroupBox;
    ImageList1: TImageList;
    Label1: TLabel;
    PageControl2: TPageControl;
    ProgressBar1: TProgressBar;
    QueryCount: TSQLQuery;
    SpeedButton1: TSpeedButton;
    SQLGetHonor: TSQLQuery;
    SQLPost: TSQLQuery;
    SQLQuery1: TSQLQuery;
    SQLlistKary: TSQLQuery;
    SQLinsert: TSQLQuery;
    SQLlistJam: TSQLQuery;
    SQLgetInfo: TSQLQuery;
    SQLComboFilter: TSQLQuery;
    SQLQuery2: TSQLQuery;
    SQLTemp: TSQLQuery;
    SQLRekapTotal: TSQLQuery;
    SQLQueryDel: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    tabAdd: TTabSheet;
    tabPrint: TTabSheet;
    togPetugas: TToggleBox;
    procedure bitHapusClick(Sender: TObject);
    procedure bitPostClick(Sender: TObject);
    procedure BitPrintClick(Sender: TObject);
    procedure bitSimpanClick(Sender: TObject);
    procedure btnCetakClick(Sender: TObject);
    procedure btnHapusClick(Sender: TObject);
    procedure btnHonorDosenClick(Sender: TObject);
    procedure btnKoorClick(Sender: TObject);
    procedure btnPostClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure BtnPwsClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure comboJamChange(Sender: TObject);
    procedure comboKaryChange(Sender: TObject);
    procedure comboPrintChange(Sender: TObject);
    procedure DateEdit1Change(Sender: TObject);
    procedure DBLookComboFilterChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure togPetugasChange(Sender: TObject);
    procedure togPetugasClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmHnrJaga: TfrmHnrJaga;

implementation
uses konekMySQL, uHnrSoal;
{$R *.lfm}

{ TfrmHnrJaga }



procedure TfrmHnrJaga.FormCreate(Sender: TObject);
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
  SQLTemp.Database:=conn;
  SQLgetInfo.Active:=False;
  SQLgetInfo.SQL.Clear;
  SQLgetInfo.SQL.Add('SELECT *, '+
  'case'+
    ' when substring(th_akdm,1,1)=1 then "GANJIL"'+
    ' else "GENAP"'+
'end as smt, '+
'substring(th_akdm,2,10) as tahun '+
'FROM tb_swu LIMIT 1');
  SQLgetInfo.Active:=True;
  th_akdm:=SQLgetInfo.FieldByName('th_akdm').AsString;
  ujian:=SQLgetInfo.FieldByName('ujian').AsString;

  SQLQuery1.Database:=conn;
  SQLQuery1.Active:=False;
  SQLQuery1.SQL.Clear;
  SQLQuery1.SQL.Add('select tb_ujian_hnr_jaga.*, tb_kary.nama, tb_jam_ujian.jam_awal as jam_jaga'
                            +' from tb_ujian_hnr_jaga,tb_kary,tb_jam_ujian'
                            +' where tb_ujian_hnr_jaga.nik=tb_kary.niK and'
                            +' tb_ujian_hnr_jaga.th_akdm="'+th_akdm+'" and'
                            +' tb_ujian_hnr_jaga.ujian="'+ujian+'" and'
                            +' tb_ujian_hnr_jaga.jam=tb_jam_ujian.kd_jam_ujian'
                            +' Order BY tb_ujian_hnr_jaga.tgl, tb_ujian_hnr_jaga.jam');
  SQLQuery1.Active:=True;
  SQLlistKary.Active:=True;
  SQLlistJam.Active:=True;

  SQLComboFilter.Active:=False;
  SQLComboFilter.SQL.Clear;
  SQLComboFilter.SQL.Add('select tgl from tb_ujian_hnr_jaga where th_akdm="'+th_akdm+'" AND ujian="'+ujian+'" Group by tgl Order by tgl');
  SQLComboFilter.Active:=True;
  DBLookComboFilter.Items.Add('--');
  DBLookComboFilter.Text:='Filter';
  groupjaga.Enabled:=FALSE;
  groupjaga.Visible:=FALSE;

end;


function honor_jaga(jenis:string):string;
var
    SQLTemp: TSQLQuery;
begin
SQLTemp.Active:=False;
SQLTemp.SQL.Clear;
SQLTemp.SQL.Add('select pengaturan from tb_setting where nama_pengaturan="'+jenis+'"');
SQLTemp.Active:=True;
honor_jaga:=SQLTemp.FieldByName('pengaturan').AsString;
end;

procedure TfrmHnrJaga.SpeedButton1Click(Sender: TObject);
var
  th_akdm, ujian:string;
begin
  th_akdm:=SQLgetInfo.FieldByName('th_akdm').AsString;
  ujian:=SQLgetInfo.FieldByName('ujian').AsString;
  SQLComboFilter.Active:=False;
  SQLComboFilter.SQL.Clear;
  SQLComboFilter.SQL.Add('select tgl from tb_ujian_hnr_jaga where th_akdm="'+th_akdm+'" AND ujian="'+ujian+'" Group by tgl Order by tgl');
  SQLComboFilter.Active:=True;
  DBLookComboFilter.Items.Add('--');
  DBLookComboFilter.Text:='Filter';
end;

procedure TfrmHnrJaga.togPetugasChange(Sender: TObject);
begin
  if togPetugas.Checked=TRUE then
  begin
  GroupJaga.Enabled:=TRUE;
  GroupJaga.Visible:=TRUE;
  togPetugas.Caption:='Batal';
  end
  else
  begin
  GroupJaga.Enabled:=FALSE;
  GroupJaga.Visible:=FALSE;
  togPetugas.Caption:='Honor Jaga Ujian';
  end;
end;

procedure TfrmHnrJaga.togPetugasClick(Sender: TObject);
begin

end;

procedure TfrmHnrJaga.BtnPwsClick(Sender: TObject);
begin

end;

procedure TfrmHnrJaga.Button1Click(Sender: TObject);
begin
  GroupJaga.Enabled:=TRUE;
end;

procedure TfrmHnrJaga.comboJamChange(Sender: TObject);
begin

end;

procedure TfrmHnrJaga.comboKaryChange(Sender: TObject);
begin

end;

procedure TfrmHnrJaga.DateEdit1Change(Sender: TObject);
var
   realDate:TDateTime;
   getDay:string;
begin
  SQLlistJam.Active:=False;
  realDate := strtodate(dateEdit1.Text);
  getDay:=intToStr(DayOfWeek(realDate));
    CASE getDay OF
   '1','7':
     begin
       SQLListJam.SQL.Clear;
       SQLListJam.SQL.Add('select * from tb_jam_ujian WHERE klp_jam="2" order by KLP_JAM, kd_jam_ujian');
     end;
   ELSE
     SQLListJam.SQL.Clear;
     SQLListJam.SQL.Add('select * from tb_jam_ujian WHERE klp_jam="1" order by KLP_JAM, kd_jam_ujian');
   end;
  SQLlistJam.Active:=True;
end;

procedure TfrmHnrJaga.DBLookComboFilterChange(Sender: TObject);
var
  th_akdm, date, dateY:string;
begin
date:=DBLookComboFilter.Text;
CASE date OF
'--' :
  begin
    th_akdm:=SQLgetInfo.FieldByName('th_akdm').AsString;
    SQLQuery1.Active:=False;
    SQLQuery1.SQL.Clear;
    SQLQuery1.SQL.Add('select tb_ujian_hnr_jaga.*, tb_kary.nama, tb_jam_ujian.jam_awal as jam_jaga'
                          +' from tb_ujian_hnr_jaga,tb_kary,tb_jam_ujian'
                          +' where tb_ujian_hnr_jaga.nik=tb_kary.niK and'
                          +' tb_ujian_hnr_jaga.th_akdm="'+th_akdm+'" and'
                          +' tb_ujian_hnr_jaga.jam=tb_jam_ujian.kd_jam_ujian'
                          +' Order BY tb_ujian_hnr_jaga.tgl, tb_ujian_hnr_jaga.jam');
    SQLQuery1.Active:=True;
    SQLQuery1.refresh;
  end;
  ELSE
      dateY:=FormatDateTime('YYYY/MM/DD',StrToDate(date));
      th_akdm:=SQLgetInfo.FieldByName('th_akdm').AsString;
      SQLQuery1.Active:=False;
      SQLQuery1.SQL.Clear;
      SQLQuery1.SQL.Add('select tb_ujian_hnr_jaga.*, tb_kary.nama, tb_jam_ujian.jam_awal as jam_jaga'
                          +' from tb_ujian_hnr_jaga,tb_kary,tb_jam_ujian'
                          +' where tb_ujian_hnr_jaga.nik=tb_kary.niK and'
                          +' tb_ujian_hnr_jaga.th_akdm="'+th_akdm+'" and'
                          +' tb_ujian_hnr_jaga.jam=tb_jam_ujian.kd_jam_ujian and'
                          +' tb_ujian_hnr_jaga.tgl="'+dateY+'"'
                          +' Order BY tb_ujian_hnr_jaga.tgl, tb_ujian_hnr_jaga.jam');
      SQLQuery1.Active:=True;
      SQLQuery1.refresh;
  end;
end;

procedure TfrmHnrJaga.BitPrintClick(Sender: TObject);
var
  th_akdm, get_combo, ujian, titel_ujian, smt, tahun:string;
begin
tahun:=SQLgetInfo.FieldByName('tahun').AsString;
th_akdm:=SQLgetInfo.FieldByName('th_akdm').AsString;
ujian:=SQLgetInfo.FieldByName('ujian').AsString;
smt:=SQLgetInfo.FieldByName('smt').AsString;

CASE ujian OF
'A' : titel_ujian:='UJIAN AKHIR SEMESTER '+smt+' '+tahun;
'B' : titel_ujian:='UJIAN TENGAH SEMESTER '+smt+' '+tahun;
ELSE titel_ujian:='';
END;
get_combo:=comboPrint.text;
  CASE get_combo OF
'Rekap Honor Pengawas' :
  begin
  frVariables['titel']:='HONORARIUM PENGAWAS '+titel_ujian;
  SQLQuery1.Active:=False;
  SQLQuery1.SQL.Clear;
  SQLQuery1.SQL.Add('select tb_ujian_hnr_jaga.*, tb_kary.nama, tb_jam_ujian.jam_awal as jam_jaga'
                            +' from tb_ujian_hnr_jaga,tb_kary,tb_jam_ujian'
                            +' where tb_ujian_hnr_jaga.nik=tb_kary.niK and'
                            +' tb_ujian_hnr_jaga.th_akdm="'+th_akdm+'" and'
                            +' tb_ujian_hnr_jaga.ujian="'+ujian+'" and'
                            +' tb_ujian_hnr_jaga.jam=tb_jam_ujian.kd_jam_ujian'
                            +' AND tb_ujian_hnr_jaga.pk="P"'
                            +' Order BY tb_ujian_hnr_jaga.tgl, tb_ujian_hnr_jaga.jam');


  SQLQuery1.Active:=True;
  SQLQuery1.Refresh;
  FrDBDataset1.Dataset:=SQLQuery1;
  frReport1.LoadFromFile('report/honor_jaga.lrf');
  frReport1.Showreport;
  end;
'Rekap Honor Koordinator' :
  begin
  frVariables['titel']:='HONORARIUM KOORDINATOR PENGAWAS '+titel_ujian;
  SQLQuery1.Active:=False;
  SQLQuery1.SQL.Clear;
  SQLQuery1.SQL.Add('select tb_ujian_hnr_jaga.*, tb_kary.nama, tb_jam_ujian.jam_awal as jam_jaga'
                            +' from tb_ujian_hnr_jaga,tb_kary,tb_jam_ujian'
                            +' where tb_ujian_hnr_jaga.nik=tb_kary.niK and'
                            +' tb_ujian_hnr_jaga.th_akdm="'+th_akdm+'" and'
                            +' tb_ujian_hnr_jaga.ujian="'+ujian+'" and'
                            +' tb_ujian_hnr_jaga.jam=tb_jam_ujian.kd_jam_ujian'
                            +' AND tb_ujian_hnr_jaga.pk="K"'
                            +' Order BY tb_ujian_hnr_jaga.tgl, tb_ujian_hnr_jaga.jam');


  SQLQuery1.Active:=True;
  SQLQuery1.Refresh;
  FrDBDataset1.Dataset:=SQLQuery1;
  frReport1.LoadFromFile('report/honor_jaga.lrf');
  frReport1.Showreport;
  end;
'Rekap Honor Dosen' :
  begin
  frVariables['titel']:='HONORARIUM KOREKSI & PEMBUATAN SOAL '+titel_ujian;
  SQLRekapTotal.Active:=False;
  SQLRekapTotal.SQL.Clear;
  SQLRekapTotal.Database:=conn;
  SQLRekapTotal.SQL.Add('select tb_ujian_hnr_soal.*, tb_kary.nama, tb_mk.nm_mk '
                            +' from tb_ujian_hnr_soal,tb_kary, tb_mk'
                            +' where tb_ujian_hnr_soal.nik=tb_kary.niK and'
                            +' tb_ujian_hnr_soal.th_akdm="'+th_akdm+'" and'
                            +' tb_ujian_hnr_soal.ujian="'+ujian+'" and'
                            +' tb_ujian_hnr_soal.kd_mk=tb_mk.kd_mk'
                            +' Order BY tb_kary.nama, tb_ujian_hnr_soal.id_jadwal ');

  SQLRekapTotal.Active:=True;
  SQLRekapTotal.Refresh;
  FrDBDataset1.Dataset:=SQLRekapTotal;
  frReport1.LoadFromFile('report/honor_soal.lrf');
  frReport1.Showreport;
  end;
'Rekap Total Honor' :
  begin
  frVariables['titel']:='TOTAL HONORARIUM '+titel_ujian;
  SQLRekapTotal.Active:=False;
  SQLRekapTotal.SQL.Clear;
  SQLRekapTotal.Database:=conn;
  SQLRekapTotal.SQL.Add('select tb_ujian_hnr_total.*, tb_kary.nama'
                            +' from tb_ujian_hnr_total,tb_kary'
                            +' where tb_ujian_hnr_total.nik=tb_kary.niK and'
                            +' tb_ujian_hnr_total.th_akdm="'+th_akdm+'" and'
                            +' tb_ujian_hnr_total.ujian="'+ujian+'"'
                            +' Order BY tb_kary.nama');

  SQLRekapTotal.Active:=True;
  SQLRekapTotal.Refresh;
  FrDBDataset1.Dataset:=SQLRekapTotal;
  frReport1.LoadFromFile('report/honor_total.lrf');
  frReport1.Showreport;
  end;
ELSE
  MessageDlg('Tidak ada yang dipilih',mtConfirmation,[mbOK],0)
  end;
end;

procedure TfrmHnrJaga.bitPostClick(Sender: TObject);
var
  th_akdm, tipe, ujian:string;
begin
progressbar1.visible:=TRUE;
th_akdm:=SQLgetInfo.FieldByName('th_akdm').AsString;
ujian:=SQLgetInfo.FieldByName('ujian').AsString;
tipe:='J';
progressbar1.position:=0;

QueryCount.Active:=FALSE;
SQLQuery2.Active:=FALSE;
SQLQuerydel.active:=FALSE;
SQLGetHonor.active:=FALSE;
SQLPost.active:=FALSE;

SQLQuerydel.Database:=conn;
QueryCount.Database:=conn;
SQLQuery2.Database:=conn;
SQLGetHonor.Database:=conn;
SQLPost.Database:=conn;

SQLQuerydel.SQL.Clear;
QueryCount.SQL.Clear;
SQLQuery2.SQL.Clear;
SQLgetHonor.SQL.Clear;
SQLPost.SQL.Clear;

SQLQuerydel.SQL.Add('delete from tb_ujian_hnr_total where th_akdm="'
+th_akdm+'" AND ujian="'
+ujian+'" AND tipe="'
+tipe+'"');
SQLQuerydel.ExecSQL;
SQLQuerydel.SQL.Clear;

QueryCount.SQL.Add('select count(*) from'
+'('
+' SELECT nik'
+' from tb_ujian_hnr_jaga'
+' where th_akdm="'+th_akdm+'" and ujian="'+ujian+'"'
+' group by nik'
+' ) as hnr_jaga');

SQLQuery2.SQL.Add('SELECT *'
+' from tb_ujian_hnr_jaga'
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
  SQLGetHonor.SQL.Add('SELECT sum(honor) as total_honor_jaga'
  +' from tb_ujian_hnr_jaga'
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
  '","'+SQLGetHonor.FieldByName('total_honor_jaga').AsString+'")');
     SQLPost.ExecSQL;
     SQLPost.SQL.Clear;
     SQLQuery2.Next;
  end;
//SQLQuery1.Refresh;
MessageDlg('Selesai!', mtInformation,[mbOK],0);
progressbar1.visible:=FALSE;
end;

procedure TfrmHnrJaga.bitHapusClick(Sender: TObject);
var
  id:string;
begin
  try
  id:=SQLQuery1.FieldByName('id').AsString;
  SQLQueryDel.Database:=conn;
  SQLQueryDel.SQL.Clear;
  If MessageDlg('Yakin menghapus data ?',mtConfirmation,[mbYes,mbNo],0)=mrYES then
  begin
  SQLQueryDel.SQL.Add('DELETE FROM tb_ujian_hnr_jaga WHERE id="'+id+'"');
  SQLQueryDel.ExecSQL;
  SQLQuery1.Refresh;
  end;

except
  MessageDlg('Data gagal dihapus',mtInformation,[mbOK],0);
end;
end;

procedure TfrmHnrJaga.bitSimpanClick(Sender: TObject);
var
  kary, jam, th_akdm, ujian, pk, honor:string;
  date : string;
begin
    try
  kary:=comboKary.KeyValue;
  date:=FormatDateTime('YYYY/MM/DD',StrToDate(dateEdit1.Text));
  jam:=combojam.KeyValue;

  th_akdm:=SQLgetInfo.FieldByName('th_akdm').AsString;
  ujian:=SQLgetInfo.FieldByName('ujian').AsString;
  if comboPK.ItemIndex=0 then
  begin
   pk:='P';
   if strtoint(jam)>=7 then
   begin
    SQLTemp.Active:=False;
SQLTemp.SQL.Clear;
SQLTemp.SQL.Add('select pengaturan from tb_setting where nama_pengaturan="hnr_pengawas_2"');
SQLTemp.Active:=True;
honor:=SQLTemp.FieldByName('pengaturan').AsString;
   end
   else
   begin
         SQLTemp.Active:=False;
SQLTemp.SQL.Clear;
SQLTemp.SQL.Add('select pengaturan from tb_setting where nama_pengaturan="hnr_pengawas_1"');
SQLTemp.Active:=True;
honor:=SQLTemp.FieldByName('pengaturan').AsString;
   end;
  end
  else
  begin
    pk:='K';
    if strtoint(jam)>=7 then
    begin
                SQLTemp.Active:=False;
SQLTemp.SQL.Clear;
SQLTemp.SQL.Add('select pengaturan from tb_setting where nama_pengaturan="hnr_koord_2"');
SQLTemp.Active:=True;
honor:=SQLTemp.FieldByName('pengaturan').AsString;
    end
    else
    begin
                SQLTemp.Active:=False;
SQLTemp.SQL.Clear;
SQLTemp.SQL.Add('select pengaturan from tb_setting where nama_pengaturan="hnr_koord_1"');
SQLTemp.Active:=True;
honor:=SQLTemp.FieldByName('pengaturan').AsString;
    end;
  end;
  SQLinsert.SQL.Clear;
  SQLinsert.SQL.Add('INSERT INTO tb_ujian_hnr_jaga VALUES("","'+th_akdm+'","'+ujian+'","'+kary+'","'+date+'","'+jam+'","'+pk+'","'+honor+'")');
  SQLinsert.ExecSQL;
  SQLinsert.SQL.Clear;
  SQLQuery1.Refresh;
  except
      MessageDlg('Isian belum lengkap!',mtInformation,[mbOK],0);
  end;
//ThisDate := strtodate(dateEdit1.Text);
//MessageDlg(inttostr(DayOfWeek(thisdate)),mtConfirmation,[mbYes,mbNo],0);
//MessageDlg(FormatDateTime('DD/MM/YYYY',ThisDate),mtConfirmation,[mbYes,mbNo],0);
//DecodeDate(Date,YY,MM,DD);
//MessageDlg(Format ('Today is %d/%d/%d',[dd,mm,yy]),mtConfirmation,[mbYes,mbNo],0);
// DaysPassed == 15

end;

procedure TfrmHnrJaga.btnCetakClick(Sender: TObject);
begin

end;

procedure TfrmHnrJaga.btnHapusClick(Sender: TObject);
begin

end;


procedure TfrmHnrJaga.btnHonorDosenClick(Sender: TObject);
begin
  frmHnrSoal.ShowModal;
end;

procedure TfrmHnrJaga.btnKoorClick(Sender: TObject);
begin

end;

procedure TfrmHnrJaga.btnPostClick(Sender: TObject);
begin

end;


procedure TfrmHnrJaga.btnSaveClick(Sender: TObject);
begin

end;





procedure TfrmHnrJaga.comboPrintChange(Sender: TObject);
begin

end;





end.

