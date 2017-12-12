unit export2dbf;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, dbf, db, FileUtil, Forms, Controls, Graphics, Dialogs,
  DBGrids, StdCtrls;

type

  { TfrmExport2DBF }

  TfrmExport2DBF = class(TForm)
    Button1: TButton;
    Datasource1: TDatasource;
    Dbf1: TDbf;
    DBGrid1: TDBGrid;
    procedure Button1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmExport2DBF: TfrmExport2DBF;

implementation

{$R *.lfm}

{ TfrmExport2DBF }

procedure TfrmExport2DBF.Button1Click(Sender: TObject);
begin

end;

end.

