unit uTRAKM;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, dbf, db, sqldb, pqconnection, IBConnection, FileUtil,
  Forms, Controls, Graphics, Dialogs, DbCtrls, DBGrids, StdCtrls, ComCtrls;

type

  { TfrmTRAKM }

  TfrmTRAKM = class(TForm)
    btnFilter: TButton;
    btnSave: TButton;
    btnUbah: TButton;
    Button1: TButton;
    Datasource1: TDatasource;
    DBEdit1: TDBEdit;
    Dbf1: TDbf;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    eUbah: TEdit;
    eNIM: TEdit;
    eTHS: TEdit;
    Label1: TLabel;
    procedure btnFilterClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnUbahClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure eTHSEnter(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmTRAKM: TfrmTRAKM;

implementation

{$R *.lfm}

{ TfrmTRAKM }

procedure TfrmTRAKM.FormCreate(Sender: TObject);
begin
  Dbf1.FilePathFull := '\data\';
  Dbf1.TableName:='TRAKM.dbf';
  Dbf1.Active:=TRUE;
end;

procedure TfrmTRAKM.eTHSEnter(Sender: TObject);
begin

end;

procedure TfrmTRAKM.btnFilterClick(Sender: TObject);
begin
  Dbf1.Active:=FALSE;
  if (eTHS.Text='') Then
  Begin
      Dbf1.Filtered:=false;
  end
  Else
  Begin
  Dbf1.Filter:='THSMSTRAKM="'+eTHS.Text+'"';
  Dbf1.Filtered:=true;
  End;
  Dbf1.Active:=TRUE;
end;

procedure TfrmTRAKM.btnSaveClick(Sender: TObject);
begin
 Dbf1.Insert;
 Dbf1.FieldByName('THSMSTRAKM').AsString:= eNIM.Text;
 Dbf1.Post;
end;

procedure TfrmTRAKM.btnUbahClick(Sender: TObject);
begin
 eUbah.Text:=dbf1.FieldByName('THSMSTRAKM').AsString;
end;

procedure TfrmTRAKM.Button1Click(Sender: TObject);
begin
 dbf1.Delete;
end;

end.

