unit uTRNLM;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, dbf, db, FileUtil, Forms, Controls, Graphics, Dialogs,
  DBGrids, DbCtrls, StdCtrls;

type

  { TfrmTRNLM }

  TfrmTRNLM = class(TForm)
    btnFilter: TButton;
    Datasource1: TDatasource;
    Dbf1: TDbf;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    eTHS: TEdit;
    Label1: TLabel;
    procedure btnFilterClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmTRNLM: TfrmTRNLM;

implementation

{$R *.lfm}

{ TfrmTRNLM }

procedure TfrmTRNLM.FormCreate(Sender: TObject);
begin
  Dbf1.FilePathFull := '\data\';
  Dbf1.TableName:='TRNLM.dbf';
  Dbf1.Active:=TRUE;
end;

procedure TfrmTRNLM.btnFilterClick(Sender: TObject);
begin
    Dbf1.Active:=FALSE;
  if (eTHS.Text='') Then
  Begin
      Dbf1.Filtered:=false;
  end
  Else
  Begin
  Dbf1.Filter:='THSMSTRNLM="'+eTHS.Text+'"';
  Dbf1.Filtered:=true;
  End;
  Dbf1.Active:=TRUE;
end;

end.

