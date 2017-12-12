program lime;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, uTRAKM, dbflaz, runtimetypeinfocontrols, uHome, uTRNLM, uNilaiSimakad,
  konekMySQL, uSoalUjian, uSplash, uHnrSoal, uHonorJaga, export2dbf, uBentrok,
  jdwgen, uTaksir, uCountMK
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TfrmSplash, frmSplash);
  Application.CreateForm(TfrmHitungMK, frmHitungMK);
  Application.CreateForm(TfrmTaksir, frmTaksir);
  Application.CreateForm(TfrmBentrok, frmBentrok);
  Application.CreateForm(TfrmHome, frmHome);
  Application.CreateForm(TfrmSoalUjian, frmSoalUjian);
  Application.CreateForm(TfrmHnrSoal, frmHnrSoal);
  Application.CreateForm(TfrmHnrJaga, frmHnrJaga);
  Application.CreateForm(TfrmExport2DBF, frmExport2DBF);
  Application.CreateForm(TfrmJdwGen, frmJdwGen);
  Application.Run;
end.

