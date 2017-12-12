unit uNilaiSimakad;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, odbcconn, sqldb, db, dbf, FileUtil, Forms, Controls,
  Graphics, Dialogs, DBGrids, StdCtrls, ComCtrls, DbCtrls, types;

type

  { TfrmNilai2TRNLM }

  TfrmNilai2TRNLM = class(TForm)
    btnGo: TButton;
    btnGoTRNLP: TButton;
    btnKonv: TButton;
    btnFilter: TButton;
    Button1: TButton;
    btnTRNLM2TRAKM: TButton;
    btnExTRNLM: TButton;
    btnExTRAKM: TButton;
    Button2: TButton;
    btnExTRNLP: TButton;
    cKDJEN: TComboBox;
    cKDJENTRNLP: TComboBox;
    cKDPS: TComboBox;
    cKDPSTRNLP: TComboBox;
    ComboKDJen: TComboBox;
    ComboKDProdi: TComboBox;
    cTHMax: TComboBox;
    cPSKonv: TComboBox;
    cPSReset: TComboBox;
    Datasource1: TDatasource;
    Dbf1: TDbf;
    DBGrid1: TDBGrid;
    conn: TODBCConnection;
    DBNavigator1: TDBNavigator;
    ePSSWUTRNLP: TEdit;
    eSMT: TEdit;
    eSMT2: TEdit;
    eSMTTRNLP: TEdit;
    eSMT_EXPORT: TEdit;
    eSMT_TRAKM: TEdit;
    eFilter: TEdit;
    ePSSWU: TEdit;
    eKDPT: TEdit;
    eTA: TEdit;
    eTA2: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label2: TLabel;
    Label20: TLabel;
    lblPS: TLabel;
    lblJmlLulus: TLabel;
    lblJmlKeluar: TLabel;
    lblJmlNonAktif: TLabel;
    lblJmlCuti: TLabel;
    lblJmlBaru: TLabel;
    lblJmlAktif: TLabel;
    lblProdi: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    mDelTRNLP: TMemo;
    Memo4: TMemo;
    Memo5: TMemo;
    Memo6: TMemo;
    mqTRNLP: TMemo;
    pageInitiate: TPageControl;
    ProgressBar1: TProgressBar;
    qTemp1: TSQLQuery;
    QueryCountNIM: TSQLQuery;
    SQLKonvNIMUpdate: TSQLQuery;
    SQLQuery1: TSQLQuery;
    QueryCount: TSQLQuery;
    SQLAmbilNilai: TSQLQuery;
    SQLKonvNIM: TSQLQuery;
    QuerySKS: TSQLQuery;
    qTemp: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    tabNilai: TTabSheet;
    tabKonvNIM: TTabSheet;
    TabSheet1: TTabSheet;
    tabExport: TTabSheet;
    TabSheet2: TTabSheet;
    tabCount: TTabSheet;
    tabTRAKM: TTabSheet;
    procedure btnExTRAKMClick(Sender: TObject);
    procedure btnExTRNLPClick(Sender: TObject);
    procedure btnKonvClick(Sender: TObject);
    procedure btnFilterClick(Sender: TObject);
    procedure btnGoClick(Sender: TObject);
    procedure btnTRNLM2TRAKMClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnExTRNLMClick(Sender: TObject);
    procedure btnGoTRNLPClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure cKDJENChange(Sender: TObject);
    procedure cKDJENTRNLPChange(Sender: TObject);
    procedure cKDPSChange(Sender: TObject);
    procedure cKDPSTRNLPChange(Sender: TObject);
    procedure ComboKDJenChange(Sender: TObject);
    procedure ComboKDProdiChange(Sender: TObject);
    procedure DBNavigator1Click(Sender: TObject; Button: TDBNavButtonType);
    procedure FormCreate(Sender: TObject);
    procedure mDelTRNLPChange(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmNilai2TRNLM: TfrmNilai2TRNLM;

implementation
uses konekMySQL;

{ TfrmNilai2TRNLM }

procedure TfrmNilai2TRNLM.FormCreate(Sender: TObject);
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
SQLQuery1.SQL.Add('SELECT * FROM forlap_trnlm');
Datasource1.Dataset:=SQLQuery1;
DBGrid1.Datasource:=Datasource1;
SQLQuery1.Active:=TRUE;

end;

procedure TfrmNilai2TRNLM.mDelTRNLPChange(Sender: TObject);
begin

end;

procedure TfrmNilai2TRNLM.PageControl1Change(Sender: TObject);
begin

end;



procedure TfrmNilai2TRNLM.btnGoClick(Sender: TObject);
var
  nilai, bobot:string;
  posisi:integer;
begin
// input nilai
progressbar1.position:=0;

QueryCount.Active:=FALSE;
SQLAmbilNilai.Active:=FALSE;
SQLQuery1.Active:=FALSE;

QueryCount.Database:=conn;
SQLAmbilNilai.Database:=conn;

QueryCount.SQL.Clear;
SQLAmbilNilai.SQL.Clear;
SQLQuery1.SQL.Clear;

SQLAmbilNilai.SQL.Add('DELETE FROM forlap_trnlm WHERE kd_prodi="'+cKDPS.Text+'" AND nilai!=""');
SQLAmbilNilai.ExecSQL;
SQLAmbilNilai.SQL.Clear;

QueryCount.SQL.Add('SELECT count(*) as total FROM tb_krs WHERE TH_AKDM="'+eTA.Text+'" AND NIM LIKE "%'+ePSSWU.Text+'%"');
SQLQuery1.SQL.Add('SELECT * FROM tb_krs WHERE TH_AKDM="'+eTA.Text+'" AND NIM LIKE "%'+ePSSWU.Text+'%"');
SQLQuery1.Active:=TRUE;
QueryCount.Active:=TRUE;
progressbar1.max:=StrToInt(QueryCount.FieldByName('total').AsString);

while not SQLQuery1.Eof do
  begin
  progressbar1.position:=progressbar1.position+1;
  nilai:=SQLQuery1.FieldByName('NILAI_UAS_FINAL').AsString;
  case nilai of
     'A' : bobot:='4';
     'B' : bobot:='3';
     'C' : bobot:='2';
     'D' : bobot:='1';
     'E' : bobot:='0';
  ELSE
      bobot:='0';
      nilai:='E';
  end;
  SQLAmbilNilai.SQL.Clear;
  SQLAmbilNilai.SQL.Add('INSERT INTO forlap_trnlm VALUES("'
  +eSMT.Text+
  '","'+eKDPT.Text+
  '","'+cKDJen.Text+
  '","'+cKDPS.Text+
  '","'+SQLQuery1.FieldByName('NIM').AsString+
  '","'+SQLQuery1.FieldByName('KD_MK').AsString+
  '","'+nilai+
  '","'+bobot+'","01")');

     SQLAmbilNilai.ExecSQL;
     SQLQuery1.Next;
  end;
//SQLQuery1.Refresh;
SQLQuery1.Active:=FALSE;
SQLQuery1.SQL.Clear;
SQLQuery1.SQL.Add('SELECT * FROM forlap_trnlm');
Datasource1.Dataset:=SQLQuery1;
DBGrid1.Datasource:=Datasource1;
SQLQuery1.Active:=TRUE;
posisi:=progressbar1.position;
progressbar1.position:=0;

// input KRS
progressbar1.position:=0;

QueryCount.Active:=FALSE;
SQLAmbilNilai.Active:=FALSE;
SQLQuery1.Active:=FALSE;

QueryCount.Database:=conn;
SQLAmbilNilai.Database:=conn;

QueryCount.SQL.Clear;
SQLAmbilNilai.SQL.Clear;
SQLQuery1.SQL.Clear;

SQLAmbilNilai.SQL.Add('DELETE FROM forlap_trnlm WHERE kd_prodi="'+cKDPS.Text+'" AND nilai=""');
SQLAmbilNilai.ExecSQL;
SQLAmbilNilai.SQL.Clear;

QueryCount.SQL.Add('SELECT count(*) as total FROM tb_krs WHERE TH_AKDM="'+eTA2.Text+'" AND NIM LIKE "%'+ePSSWU.Text+'%"');
SQLQuery1.SQL.Add('SELECT * FROM tb_krs WHERE TH_AKDM="'+eTA2.Text+'" AND NIM LIKE "%'+ePSSWU.Text+'%"');
SQLQuery1.Active:=TRUE;
QueryCount.Active:=TRUE;
progressbar1.max:=StrToInt(QueryCount.FieldByName('total').AsString);

while not SQLQuery1.Eof do
  begin
  progressbar1.position:=progressbar1.position+1;
  nilai:='';
  bobot:='';

  SQLAmbilNilai.SQL.Clear;
  SQLAmbilNilai.SQL.Add('INSERT INTO forlap_trnlm VALUES("'
  +eSMT2.Text+
  '","'+eKDPT.Text+
  '","'+cKDJen.Text+
  '","'+cKDPS.Text+
  '","'+SQLQuery1.FieldByName('NIM').AsString+
  '","'+SQLQuery1.FieldByName('KD_MK').AsString+
  '","'+nilai+
  '","'+bobot+'","01")');

     SQLAmbilNilai.ExecSQL;
     SQLQuery1.Next;
  end;
//SQLQuery1.Refresh;
SQLQuery1.Active:=FALSE;
SQLQuery1.SQL.Clear;
SQLQuery1.SQL.Add('SELECT * FROM forlap_trnlm');
Datasource1.Dataset:=SQLQuery1;
DBGrid1.Datasource:=Datasource1;
SQLQuery1.Active:=TRUE;
MessageDlg(IntToStr(progressbar1.position+posisi)+' Record NILAI & KRS Selesai Disalin!', mtInformation,[mbOK],0);
progressbar1.position:=0;

end;

procedure TfrmNilai2TRNLM.btnTRNLM2TRAKMClick(Sender: TObject);
var
  nim,nilai:string;
 // sks_count,mutu:integer;
 sks_t,t_mutu :Integer;

 ipk:double;
begin
progressbar1.position:=0;

QueryCount.Active:=FALSE;
QuerySKS.Active:=FALSE;
qTemp.Active:=FALSE;
SQLAmbilNilai.Active:=FALSE;
SQLQuery1.Active:=FALSE;

QueryCount.Database:=conn;
qtemp.Database:=conn;
QuerySKS.Database:=conn;
SQLAmbilNilai.Database:=conn;

QueryCount.SQL.Clear;
QuerySKS.SQL.Clear;
qtemp.SQL.Clear;
SQLAmbilNilai.SQL.Clear;
SQLQuery1.SQL.Clear;

SQLAmbilNilai.SQL.Add('DELETE FROM forlap_trakm WHERE smt="'+eSMT_TRAKM.Text+'"');
SQLAmbilNilai.ExecSQL;
SQLAmbilNilai.SQL.Clear;

QueryCount.SQL.Add('select count(*) as total from (select * from forlap_trnlm WHERE smt="'+eSMT_TRAKM.Text+'" GROUP BY nim) as total');
SQLQuery1.SQL.Add('SELECT * FROM forlap_trnlm WHERE smt="'+eSMT_TRAKM.Text+'" GROUP BY nim');
SQLQuery1.Active:=TRUE;
QueryCount.Active:=TRUE;
progressbar1.max:=StrToInt(QueryCount.FieldByName('total').AsString);

while not SQLQuery1.Eof do
  begin
  QuerySKS.Active:=FALSE;
  QuerySKS.SQL.Clear;
  qTemp.Active:=FALSE;
  qTemp.SQL.Clear;

  progressbar1.position:=progressbar1.position+1;
  nim:=SQLQuery1.FieldByName('nim').AsString;
  QuerySKS.SQL.Add('select SUM(tb_mk.sks) as sks_tot from tb_nilai, tb_mk where tb_nilai.KD_MK=tb_mk.kd_mk and tb_nilai.nim="'+nim+'"');
  QuerySKS.Active:=TRUE;
  qTemp.SQL.Add('select sum(case tb_nilai.nilai '
                        +'when "A" then 4*tb_mk.sks '
                        +'when "B" then 3*tb_mk.sks '
                        +'when "C" then 2*tb_mk.sks '
                        +'when "D" then 1*tb_mk.sks '
                        +'when "E" then 0 '
                        +'ELSE 0 '
                        +'end) as total_mutu '
                        +'from '
                        +'tb_nilai,tb_mk '
                        +'where tb_nilai.KD_MK=tb_mk.kd_mk and nim="'+nim+'"');
  qTemp.Active:=TRUE;
  t_mutu := strToInt(qTemp.FieldByName('total_mutu').AsString);
  sks_t :=  strToInt(QuerySKS.FieldByName('sks_tot').AsString);


  //t_mutu := 4;
  //sks_t :=  2;
  ipk:=t_mutu/sks_t;

  SQLAmbilNilai.SQL.Add('INSERT INTO forlap_trakm VALUES("'
  +eSMT_TRAKM.Text+
  '","'+SQLQuery1.FieldByName('kd_pts').AsString+
  '","'+SQLQuery1.FieldByName('kd_jen').AsString+
  '","'+SQLQuery1.FieldByName('kd_prodi').AsString+
  '","'+nim+
  '","'+''+
  '","'+''+
  '","'+QuerySKS.FieldByName('sks_tot').AsString+
  '","'+floatToStr(ipk)+'")');

     SQLAmbilNilai.ExecSQL;
     SQLAmbilNilai.SQL.Clear;
     SQLQuery1.Next;
  end;
//SQLQuery1.Refresh;
SQLQuery1.Active:=FALSE;
SQLQuery1.SQL.Clear;
SQLQuery1.SQL.Add('SELECT * FROM forlap_trakm');
Datasource1.Dataset:=SQLQuery1;
DBGrid1.Datasource:=Datasource1;
SQLQuery1.Active:=TRUE;
MessageDlg(IntToStr(progressbar1.position)+' record TRAKM Selesai diisi!', mtInformation,[mbOK],0);
progressbar1.position:=0;
end;

procedure TfrmNilai2TRNLM.Button1Click(Sender: TObject);
begin
  try
  SQLAmbilNilai.Database:=conn;
  SQLAmbilNilai.SQL.Clear;
  If MessageDlg('Yakin menghapus data nilai ?',mtConfirmation,[mbYes,mbNo],0)=mrYES then
  begin
  SQLAmbilNilai.SQL.Add('DELETE FROM forlap_trnlm WHERE NIM LIKE "%'+cPSReset.text+'%" OR KD_MK LIKE "%'+cPSReset.text+'%"');
  SQLAmbilNilai.ExecSQL;
  SQLQuery1.Refresh;
  end;

except
  MessageDlg('Data barang gagal dihapus',mtInformation,[mbOK],0);
end;
end;

procedure TfrmNilai2TRNLM.btnExTRNLMClick(Sender: TObject);
begin
try
progressbar1.position:=0;
Dbf1.FilePathFull := '\data\';
Dbf1.TableName:='TRNLM.dbf';
Dbf1.Active:=TRUE;

QueryCount.Active:=FALSE;
SQLQuery1.Active:=FALSE;

QueryCount.Database:=conn;

QueryCount.SQL.Clear;
SQLQuery1.SQL.Clear;
QueryCount.SQL.Add('select count(*) as total from forlap_trnlm WHERE smt="'+eSMT_EXPORT.Text+'"');
SQLQuery1.SQL.Add('SELECT * FROM forlap_trnlm WHERE smt="'+eSMT_EXPORT.Text+'"');
SQLQuery1.Active:=TRUE;
QueryCount.Active:=TRUE;
progressbar1.max:=StrToInt(QueryCount.FieldByName('total').AsString);

while not SQLQuery1.Eof do
  begin
  progressbar1.position:=progressbar1.position+1;

  Dbf1.Insert;
  Dbf1.FieldByName('THSMSTRNLM').AsString:=SQLQuery1.FieldByName('smt').AsString;
  Dbf1.FieldByName('KDPTITRNLM').AsString:=SQLQuery1.FieldByName('kd_pts').AsString;
  Dbf1.FieldByName('KDJENTRNLM').AsString:=SQLQuery1.FieldByName('kd_jen').AsString;
  Dbf1.FieldByName('KDPSTTRNLM').AsString:=SQLQuery1.FieldByName('kd_prodi').AsString;
  Dbf1.FieldByName('NIMHSTRNLM').AsString:=SQLQuery1.FieldByName('nim').AsString;
  Dbf1.FieldByName('KDKMKTRNLM').AsString:=SQLQuery1.FieldByName('kd_mk').AsString;
  Dbf1.FieldByName('NLAKHTRNLM').AsString:=SQLQuery1.FieldByName('nilai').AsString;
  Dbf1.FieldByName('BOBOTTRNLM').AsString:=SQLQuery1.FieldByName('bobot').AsString;
  Dbf1.FieldByName('KELASTRNLM').AsString:=SQLQuery1.FieldByName('kelas').AsString;
  Dbf1.Post;

  SQLQuery1.Next;
  end;
//SQLQuery1.Refresh;
SQLQuery1.Active:=FALSE;
SQLQuery1.SQL.Clear;
SQLQuery1.SQL.Add('SELECT * FROM forlap_trnlm');
Datasource1.Dataset:=SQLQuery1;
DBGrid1.Datasource:=Datasource1;
SQLQuery1.Active:=TRUE;
MessageDlg(IntToStr(progressbar1.position)+' record TRNLM Selesai diekspor!', mtInformation,[mbOK],0);
progressbar1.position:=0;
Dbf1.Active:=FALSE;
except
  MessageDlg('Kosong!!', mtInformation,[mbOK],0);
end;
end;

procedure TfrmNilai2TRNLM.btnGoTRNLPClick(Sender: TObject);
var
  nim,nilai,bobot:string;
begin
try
if (eSMTTRNLP.Text='') OR (cKDJENTRNLP.Text='') OR (cKDPSTRNLP.Text='') OR (ePSSWUTRNLP.Text='') then
   begin
   MessageDlg('Ada yang belum diisi!', mtInformation,[mbOK],0);
   end
else
begin
progressbar1.position:=0;

QueryCount.Active:=FALSE;
QuerySKS.Active:=FALSE;
qTemp.Active:=FALSE;
SQLAmbilNilai.Active:=FALSE;
SQLQuery1.Active:=FALSE;

QueryCount.Database:=conn;
qtemp.Database:=conn;
QuerySKS.Database:=conn;
SQLAmbilNilai.Database:=conn;

QueryCount.SQL.Clear;
QuerySKS.SQL.Clear;
qtemp.SQL.Clear;
SQLAmbilNilai.SQL.Clear;
SQLQuery1.SQL.Clear;

SQLAmbilNilai.SQL.Add('DELETE FROM forlap_trnlp WHERE smt="'+eSMTTRNLP.Text+'"');
SQLAmbilNilai.ExecSQL;
SQLAmbilNilai.SQL.Clear;

QueryCount.SQL.Add('select count(*) as total from tb_nilai WHERE '+mqTRNLP.Text);
SQLQuery1.SQL.Add('SELECT * FROM tb_nilai WHERE '+mqTRNLP.Text);
SQLQuery1.Active:=TRUE;
QueryCount.Active:=TRUE;
progressbar1.max:=StrToInt(QueryCount.FieldByName('total').AsString);

while not SQLQuery1.Eof do
  begin
  progressbar1.position:=progressbar1.position+1;
  nilai:=SQLQuery1.FieldByName('nilai').AsString;
  case nilai of
     'A' : bobot:='4';
     'B' : bobot:='3';
     'C' : bobot:='2';
     'D' : bobot:='1';
     'E' : bobot:='0';
  ELSE
      bobot:='0';
      nilai:='E';
  end;
  SQLAmbilNilai.SQL.Add('INSERT INTO forlap_trnlp VALUES("'
  +eSMTTRNLP.Text+
  '","'+eKDPT.Text+
  '","'+cKDJenTRNLP.Text+
  '","'+cKDPSTRNLP.Text+
  '","'+SQLQuery1.FieldByName('NIM').AsString+
  '","'+SQLQuery1.FieldByName('KD_MK').AsString+
  '","'+nilai+
  '","'+bobot+'","01","'+SQLQuery1.FieldByName('ket').AsString+'")');

     SQLAmbilNilai.ExecSQL;
     SQLAmbilNilai.SQL.Clear;
     SQLQuery1.Next;
  end;
//SQLQuery1.Refresh;
SQLQuery1.Active:=FALSE;
SQLQuery1.SQL.Clear;
SQLQuery1.SQL.Add('SELECT * FROM forlap_trnlp');
Datasource1.Dataset:=SQLQuery1;
DBGrid1.Datasource:=Datasource1;
SQLQuery1.Active:=TRUE;
MessageDlg(IntToStr(progressbar1.position)+' record TRNLP Selesai diisi!', mtInformation,[mbOK],0);
progressbar1.position:=0;
end
except
  MessageDlg('Ada yang salah dengan query Anda!', mtInformation,[mbOK],0);
end;
end;

procedure TfrmNilai2TRNLM.Button2Click(Sender: TObject);
begin
try
progressbar1.position:=0;

SQLAmbilNilai.Active:=FALSE;
SQLQuery1.Active:=FALSE;

SQLAmbilNilai.Database:=conn;

SQLAmbilNilai.SQL.Clear;
SQLQuery1.SQL.Clear;

SQLAmbilNilai.SQL.Add('DELETE FROM forlap_trnlp WHERE ket like "%'+mDelTRNLP.Text+'%"');
SQLAmbilNilai.ExecSQL;
SQLAmbilNilai.SQL.Clear;

SQLQuery1.Active:=FALSE;
SQLQuery1.SQL.Clear;
SQLQuery1.SQL.Add('SELECT * FROM forlap_trnlp');
Datasource1.Dataset:=SQLQuery1;
DBGrid1.Datasource:=Datasource1;
SQLQuery1.Active:=TRUE;
MessageDlg('TRNLP Selesai dibersihkan!', mtInformation,[mbOK],0);
except
  MessageDlg('Ada yang salah dengan query Anda!', mtInformation,[mbOK],0);
end;
end;





procedure TfrmNilai2TRNLM.btnFilterClick(Sender: TObject);
var
strsql : string;
begin
SQLQuery1.Active:=FALSE;
SQLQuery1.SQL.Clear;
if eFilter.Text='' Then
begin
strsql:='SELECT * FROM forlap_trnlm';
end
else
begin
strsql:='SELECT * FROM forlap_trnlm WHERE NIM like "%'+eFilter.Text+'%"';
end;

SQLQuery1.SQL.Add(strsql);
//Datasource1.Dataset:=SQLQuery1;
//DBGrid1.Datasource:=Datasource1;
SQLQuery1.Active:=TRUE;
end;

procedure TfrmNilai2TRNLM.btnKonvClick(Sender: TObject);
begin
progressbar1.position:=0;

SQLKonvNIM.Active:=FALSE;
SQLKonvNIM.Database:=conn;
SQLKonvNIM.SQL.Clear;

SQLKonvNIMUpdate.Active:=FALSE;
SQLKonvNIMUpdate.Database:=conn;
SQLKonvNIMUpdate.SQL.Clear;

QueryCountNIM.Active:=FALSE;
QueryCountNIM.Database:=conn;
QueryCountNIM.SQL.Clear;

// Konversi TRNLM
QueryCountNIM.SQL.Add('SELECT Count(*) as total from forlap_trnlm where NIM LIKE "%'+cPSKonv.Text+cTHmax.Text+'%"');

SQLKonvNIM.SQL.Add('SELECT forlap_trnlm.NIM,tb_mahasiswa.NIM_LAMA FROM forlap_trnlm,tb_mahasiswa WHERE forlap_trnlm.NIM LIKE "%'
+cPSKonv.Text+cTHmax.Text+'%" AND forlap_trnlm.NIM=tb_mahasiswa.NIM');
SQLKonvNIM.Active:=TRUE;

QueryCountNIM.Active:=TRUE;
progressbar1.max:=StrToInt(QueryCountNIM.FieldByName('total').AsString);

while not SQLKonvNIM.Eof do
  begin
  progressbar1.position:=progressbar1.position+1;

  SQLKonvNIMUpdate.SQL.Add('UPDATE forlap_trnlm SET NIM ="'
  +SQLKonvNIM.FieldByName('NIM_LAMA').AsString+
  '" WHERE NIM="'+SQLKonvNIM.FieldByName('NIM').AsString+
  '"');

     SQLKonvNIMUpdate.ExecSQL;
     SQLKonvNIMUpdate.SQL.Clear;
     SQLKonvNIM.Next;
  end;
progressbar1.position:=0;

// Konversi TRAKM
SQLKonvNIM.Active:=FALSE;
SQLKonvNIM.SQL.Clear;

SQLKonvNIMUpdate.Active:=FALSE;
SQLKonvNIMUpdate.SQL.Clear;

QueryCountNIM.Active:=FALSE;
QueryCountNIM.SQL.Clear;

QueryCountNIM.SQL.Add('SELECT Count(*) as total from forlap_trakm where NIM LIKE "%'+cPSKonv.Text+cTHmax.Text+'%"');

SQLKonvNIM.SQL.Add('SELECT forlap_trakm.NIM,tb_mahasiswa.NIM_LAMA FROM forlap_trakm,tb_mahasiswa WHERE forlap_trakm.NIM LIKE "%'
+cPSKonv.Text+cTHmax.Text+'%" AND forlap_trakm.NIM=tb_mahasiswa.NIM');
SQLKonvNIM.Active:=TRUE;

QueryCountNIM.Active:=TRUE;
progressbar1.max:=StrToInt(QueryCountNIM.FieldByName('total').AsString);

while not SQLKonvNIM.Eof do
  begin
  progressbar1.position:=progressbar1.position+1;

  SQLKonvNIMUpdate.SQL.Add('UPDATE forlap_trakm SET NIM ="'
  +SQLKonvNIM.FieldByName('NIM_LAMA').AsString+
  '" WHERE NIM="'+SQLKonvNIM.FieldByName('NIM').AsString+
  '"');

     SQLKonvNIMUpdate.ExecSQL;
     SQLKonvNIMUpdate.SQL.Clear;
     SQLKonvNIM.Next;
  end;
progressbar1.position:=0;
end;



procedure TfrmNilai2TRNLM.btnExTRAKMClick(Sender: TObject);
begin
try
progressbar1.position:=0;

Dbf1.FilePathFull := '\data\';
Dbf1.TableName:='TRAKM.dbf';
Dbf1.Active:=TRUE;

QueryCount.Active:=FALSE;
SQLQuery1.Active:=FALSE;

QueryCount.Database:=conn;

QueryCount.SQL.Clear;
SQLQuery1.SQL.Clear;

QueryCount.SQL.Add('select count(*) as total from forlap_trakm WHERE smt="'+eSMT_EXPORT.Text+'"');
SQLQuery1.SQL.Add('SELECT * FROM forlap_trakm WHERE smt="'+eSMT_EXPORT.Text+'"');
SQLQuery1.Active:=TRUE;
QueryCount.Active:=TRUE;
progressbar1.max:=StrToInt(QueryCount.FieldByName('total').AsString);

while not SQLQuery1.Eof do
  begin
  progressbar1.position:=progressbar1.position+1;

  Dbf1.Insert;
  Dbf1.FieldByName('THSMSTRAKM').AsString:=SQLQuery1.FieldByName('smt').AsString;
  Dbf1.FieldByName('KDPTITRAKM').AsString:=SQLQuery1.FieldByName('kd_pts').AsString;
  Dbf1.FieldByName('KDJENTRAKM').AsString:=SQLQuery1.FieldByName('kd_jen').AsString;
  Dbf1.FieldByName('KDPSTTRAKM').AsString:=SQLQuery1.FieldByName('kd_prodi').AsString;
  Dbf1.FieldByName('NIMHSTRAKM').AsString:=SQLQuery1.FieldByName('nim').AsString;
  Dbf1.FieldByName('SKSEMTRAKM').AsString:='';
  Dbf1.FieldByName('NLIPSTRAKM').AsString:='';
  Dbf1.FieldByName('SKSTTTRAKM').AsString:=SQLQuery1.FieldByName('sks_tot').AsString;
  Dbf1.FieldByName('NLIPKTRAKM').AsString:=SQLQuery1.FieldByName('ipk').AsString;
  Dbf1.Post;

  SQLQuery1.Next;
  end;
//SQLQuery1.Refresh;
SQLQuery1.Active:=FALSE;
SQLQuery1.SQL.Clear;
SQLQuery1.SQL.Add('SELECT * FROM forlap_trnlm');
Datasource1.Dataset:=SQLQuery1;
DBGrid1.Datasource:=Datasource1;
SQLQuery1.Active:=TRUE;
MessageDlg(IntToStr(progressbar1.position)+' record TRAKM Selesai diekspor!', mtInformation,[mbOK],0);
progressbar1.position:=0;
Dbf1.Active:=FALSE;
except
  MessageDlg('Kosong!', mtInformation,[mbOK],0);
end;
end;

procedure TfrmNilai2TRNLM.btnExTRNLPClick(Sender: TObject);
begin
try
progressbar1.position:=0;
Dbf1.FilePathFull := '\data\';
Dbf1.TableName:='TRNLP.dbf';
Dbf1.Active:=TRUE;

QueryCount.Active:=FALSE;
SQLQuery1.Active:=FALSE;

QueryCount.Database:=conn;

QueryCount.SQL.Clear;
SQLQuery1.SQL.Clear;
QueryCount.SQL.Add('select count(*) as total from forlap_trnlp WHERE smt="'+eSMT_EXPORT.Text+'"');
SQLQuery1.SQL.Add('SELECT * FROM forlap_trnlp WHERE smt="'+eSMT_EXPORT.Text+'"');
SQLQuery1.Active:=TRUE;
QueryCount.Active:=TRUE;
progressbar1.max:=StrToInt(QueryCount.FieldByName('total').AsString);

while not SQLQuery1.Eof do
  begin
  progressbar1.position:=progressbar1.position+1;

  Dbf1.Insert;
  Dbf1.FieldByName('THSMSTRNLP').AsString:=SQLQuery1.FieldByName('smt').AsString;
  Dbf1.FieldByName('KDPTITRNLP').AsString:=SQLQuery1.FieldByName('kd_pts').AsString;
  Dbf1.FieldByName('KDJENTRNLP').AsString:=SQLQuery1.FieldByName('kd_jen').AsString;
  Dbf1.FieldByName('KDPSTTRNLP').AsString:=SQLQuery1.FieldByName('kd_prodi').AsString;
  Dbf1.FieldByName('NIMHSTRNLP').AsString:=SQLQuery1.FieldByName('nim').AsString;
  Dbf1.FieldByName('KDKMKTRNLP').AsString:=SQLQuery1.FieldByName('kd_mk').AsString;
  Dbf1.FieldByName('NLAKHTRNLP').AsString:=SQLQuery1.FieldByName('nilai').AsString;
  Dbf1.FieldByName('BOBOTTRNLP').AsString:=SQLQuery1.FieldByName('bobot').AsString;
  Dbf1.FieldByName('KELASTRNLP').AsString:=SQLQuery1.FieldByName('kelas').AsString;
  Dbf1.Post;

  SQLQuery1.Next;
  end;
//SQLQuery1.Refresh;
SQLQuery1.Active:=FALSE;
SQLQuery1.SQL.Clear;
SQLQuery1.SQL.Add('SELECT * FROM forlap_trnlp');
Datasource1.Dataset:=SQLQuery1;
DBGrid1.Datasource:=Datasource1;
SQLQuery1.Active:=TRUE;
MessageDlg(IntToStr(progressbar1.position)+' record TRNLP Selesai diekspor!', mtInformation,[mbOK],0);
progressbar1.position:=0;
Dbf1.Active:=FALSE;
except
  MessageDlg('Kosong!!', mtInformation,[mbOK],0);
end;
end;

procedure TfrmNilai2TRNLM.cKDJENChange(Sender: TObject);
var
  kdjen:string;
begin
kdjen:=cKDJEN.Text;
  CASE kdjen OF
   'C':
     begin
     cKDPS.items.Clear;
     cKDPS.Items.Add('55201');
     cKDPS.Items.Add('57201');
     end;
   'E':
     begin
     cKDPS.items.Clear;
     cKDPS.Items.Add('55401');
     cKDPS.Items.Add('57402');
     end;
   ELSE
     cKDPS.Items.Add('');
   end;
end;

procedure TfrmNilai2TRNLM.cKDJENTRNLPChange(Sender: TObject);
var
  kdjen:string;
begin
kdjen:=cKDJENTRNLP.Text;
  CASE kdjen OF
   'C':
     begin
     cKDPSTRNLP.items.Clear;
     cKDPSTRNLP.Items.Add('55201');
     cKDPSTRNLP.Items.Add('57201');
     end;
   'E':
     begin
     cKDPSTRNLP.items.Clear;
     cKDPSTRNLP.Items.Add('55401');
     cKDPSTRNLP.Items.Add('57402');
     end;
   ELSE
     cKDPSTRNLP.Items.Add('');
   end;
end;



procedure TfrmNilai2TRNLM.cKDPSChange(Sender: TObject);
var
  KDPSSWU:String;
begin
KDPSSWU:=cKDPS.Text;
CASE KDPSSWU OF
   '55201': ePSSWU.Text:='STI';
   '57201': ePSSWU.Text:='SSI';
   '55401': ePSSWU.Text:='DTI';
   '57402': ePSSWU.Text:='DKA';
   ELSE
     cKDPS.Items.Add('');
   end;
end;

procedure TfrmNilai2TRNLM.cKDPSTRNLPChange(Sender: TObject);
var
  KDPSSWU:String;
begin
KDPSSWU:=cKDPSTRNLP.Text;
CASE KDPSSWU OF
   '55201': ePSSWUTRNLP.Text:='STI';
   '57201': ePSSWUTRNLP.Text:='SSI';
   '55401': ePSSWUTRNLP.Text:='DTI';
   '57402': ePSSWUTRNLP.Text:='DKA';
   ELSE
     cKDPSTRNLP.Items.Add('');
   end;
end;

procedure TfrmNilai2TRNLM.ComboKDJenChange(Sender: TObject);
var
  kdjen:string;
begin
kdjen:=ComboKDJen.Text;
  CASE kdjen OF
   'C':
     begin
     ComboKDProdi.items.Clear;
     ComboKDProdi.Items.Add('55201');
     ComboKDProdi.Items.Add('57201');
     end;
   'E':
     begin
     ComboKDProdi.items.Clear;
     ComboKDProdi.Items.Add('55401');
     ComboKDProdi.Items.Add('57402');
     end;
   ELSE
     ComboKDProdi.Items.Add('');
   end;
end;

procedure TfrmNilai2TRNLM.ComboKDProdiChange(Sender: TObject);
var
  KDPSSWU, mhsAktif_L, mhsAktif_P, mhsBaru_L, mhsBaru_P, mhsCuti_L,
    mhsCuti_P, mhsNon_L, mhsNon_P, mhsKeluar_L, mhsKeluar_P,
    mhsLulus_L, mhsLulus_P:String;
begin
KDPSSWU:=comboKDProdi.Text;

qTemp1.Database:=conn;
qTemp1.Active:=FALSE;
qTemp1.SQL.Clear;
CASE KDPSSWU OF
   '55201':
     begin
     lblPS.Caption:='S1 Teknik Informatika';
     end;

   '57201':
     begin
     lblPS.Caption:='S1 Sistem Informasi';
     end;

   '55401':
     begin
     lblPS.Caption:='D3 Teknik Informatika';
     end;

   '57402':
     begin
     lblPS.Caption:='D3 Komputerisasi Akuntansi';
     end;
   ELSE
     comboKDProdi.Items.Add('');
   end;

     qTemp1.SQL.Add('select count(*) as total from forlap_trakm, forlap_msmhs where forlap_trakm.smt="'+eSMT.Text+'" and forlap_trakm.kd_prodi="'+KDPSSWU+'" and forlap_trakm.nim=forlap_msmhs.nim and forlap_msmhs.kd_jk="L"');
     qTemp1.Active:=TRUE;
     mhsAktif_L:=qTemp1.FieldByName('total').AsString;

     qTemp1.Active:=FALSE;
     qTemp1.SQL.Clear;
     qTemp1.SQL.Add('select count(*) as total from forlap_trakm, forlap_msmhs where forlap_trakm.smt="'+eSMT.Text+'" and forlap_trakm.kd_prodi="'+KDPSSWU+'" and forlap_trakm.nim=forlap_msmhs.nim and forlap_msmhs.kd_jk="P"');
     qTemp1.Active:=TRUE;
     mhsAktif_P:=qTemp1.FieldByName('total').AsString;

     qTemp1.Active:=FALSE;
     qTemp1.SQL.Clear;
     qTemp1.SQL.Add('select count(*) as total from forlap_msmhs where smt_msk="'+eSMT.Text+'" and kd_ps="'+KDPSSWU+'" and kd_jk="L"');
     qTemp1.Active:=TRUE;
     mhsBaru_L:=qTemp1.FieldByName('total').AsString;

     qTemp1.Active:=FALSE;
     qTemp1.SQL.Clear;
     qTemp1.SQL.Add('select count(*) as total from forlap_msmhs where smt_msk="'+eSMT.Text+'" and kd_ps="'+KDPSSWU+'" and kd_jk="P"');
     qTemp1.Active:=TRUE;
     mhsBaru_P:=qTemp1.FieldByName('total').AsString;

     qTemp1.Active:=FALSE;
     qTemp1.SQL.Clear;
     qTemp1.SQL.Add('select count(*) as total from forlap_trlsm, forlap_msmhs where forlap_trlsm.smt="'+eSMT.Text+'" and forlap_trlsm.kd_prodi="'+KDPSSWU+'" and forlap_trlsm.nim=forlap_msmhs.nim and forlap_msmhs.kd_jk="L" and forlap_trlsm.status="C"');
     qTemp1.Active:=TRUE;
     mhsCuti_L:=qTemp1.FieldByName('total').AsString;

     qTemp1.Active:=FALSE;
     qTemp1.SQL.Clear;
     qTemp1.SQL.Add('select count(*) as total from forlap_trlsm, forlap_msmhs where forlap_trlsm.smt="'+eSMT.Text+'" and forlap_trlsm.kd_prodi="'+KDPSSWU+'" and forlap_trlsm.nim=forlap_msmhs.nim and forlap_msmhs.kd_jk="P" and forlap_trlsm.status="C"');
     qTemp1.Active:=TRUE;
     mhsCuti_P:=qTemp1.FieldByName('total').AsString;

     qTemp1.Active:=FALSE;
     qTemp1.SQL.Clear;
     qTemp1.SQL.Add('select count(*) as total from forlap_trlsm, forlap_msmhs where forlap_trlsm.smt="'+eSMT.Text+'" and forlap_trlsm.kd_prodi="'+KDPSSWU+'" and forlap_trlsm.nim=forlap_msmhs.nim and forlap_msmhs.kd_jk="L" and forlap_trlsm.status="N"');
     qTemp1.Active:=TRUE;
     mhsNon_L:=qTemp1.FieldByName('total').AsString;

     qTemp1.Active:=FALSE;
     qTemp1.SQL.Clear;
     qTemp1.SQL.Add('select count(*) as total from forlap_trlsm, forlap_msmhs where forlap_trlsm.smt="'+eSMT.Text+'" and forlap_trlsm.kd_prodi="'+KDPSSWU+'" and forlap_trlsm.nim=forlap_msmhs.nim and forlap_msmhs.kd_jk="P" and forlap_trlsm.status="N"');
     qTemp1.Active:=TRUE;
     mhsNon_P:=qTemp1.FieldByName('total').AsString;

     qTemp1.Active:=FALSE;
     qTemp1.SQL.Clear;
     qTemp1.SQL.Add('select count(*) as total from forlap_trlsm, forlap_msmhs where forlap_trlsm.smt="'+eSMT.Text+'" and forlap_trlsm.kd_prodi="'+KDPSSWU+'" and forlap_trlsm.nim=forlap_msmhs.nim and forlap_msmhs.kd_jk="L" and forlap_trlsm.status="K"');
     qTemp1.Active:=TRUE;
     mhsKeluar_L:=qTemp1.FieldByName('total').AsString;

     qTemp1.Active:=FALSE;
     qTemp1.SQL.Clear;
     qTemp1.SQL.Add('select count(*) as total from forlap_trlsm, forlap_msmhs where forlap_trlsm.smt="'+eSMT.Text+'" and forlap_trlsm.kd_prodi="'+KDPSSWU+'" and forlap_trlsm.nim=forlap_msmhs.nim and forlap_msmhs.kd_jk="P" and forlap_trlsm.status="K"');
     qTemp1.Active:=TRUE;
     mhsKeluar_P:=qTemp1.FieldByName('total').AsString;

     qTemp1.Active:=FALSE;
     qTemp1.SQL.Clear;
     qTemp1.SQL.Add('select count(*) as total from forlap_trlsm, forlap_msmhs where forlap_trlsm.smt="'+eSMT.Text+'" and forlap_trlsm.kd_prodi="'+KDPSSWU+'" and forlap_trlsm.nim=forlap_msmhs.nim and forlap_msmhs.kd_jk="L" and forlap_trlsm.status="L"');
     qTemp1.Active:=TRUE;
     mhsLulus_L:=qTemp1.FieldByName('total').AsString;

     qTemp1.Active:=FALSE;
     qTemp1.SQL.Clear;
     qTemp1.SQL.Add('select count(*) as total from forlap_trlsm, forlap_msmhs where forlap_trlsm.smt="'+eSMT.Text+'" and forlap_trlsm.kd_prodi="'+KDPSSWU+'" and forlap_trlsm.nim=forlap_msmhs.nim and forlap_msmhs.kd_jk="P" and forlap_trlsm.status="L"');
     qTemp1.Active:=TRUE;
     mhsLulus_P:=qTemp1.FieldByName('total').AsString;

     lblPS.Visible:=TRUE;
     lblJmlAktif.Visible:=TRUE;
     lblJmlBaru.Visible:=TRUE;
     lblJmlCuti.Visible:=TRUE;
     lblJmlNonAktif.Visible:=TRUE;
     lblJmlKeluar.Visible:=TRUE;
     lblJmlLulus.Visible:=TRUE;

     lblJmlAktif.Caption:='Aktif (+Baru) - L:'+mhsAktif_L+' P:'+mhsAktif_P;
     lblJmlBaru.Caption:='Baru - L:'+mhsBaru_L+' P:'+mhsBaru_P;
     lblJmlCuti.Caption:='Cuti - L:'+mhsCuti_L+' P:'+mhsCuti_P;
     lblJmlNonAktif.Caption:='NonAktif - L:'+mhsNon_L+' P:'+mhsNon_P;
     lblJmlKeluar.Caption:='Keluar - L:'+mhsKeluar_L+' P:'+mhsKeluar_P;
     lblJmlLulus.Caption:='Lulus - L:'+mhsLulus_L+' P:'+mhsLulus_P;
end;

procedure TfrmNilai2TRNLM.DBNavigator1Click(Sender: TObject;
  Button: TDBNavButtonType);
begin

end;




{$R *.lfm}

end.

