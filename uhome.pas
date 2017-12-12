unit uHome;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ExtCtrls;

type

  { TfrmHome }

  TfrmHome = class(TForm)
    Image1: TImage;
    MainMenu1: TMainMenu;
    menuBentrok: TMenuItem;
    MenuItem1: TMenuItem;
    mnTaksir: TMenuItem;
    PopMenuCekBentrok: TMenuItem;
    PopMenuHnrjaga: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    menuHnrJaga: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    PopMenuKopSoal: TMenuItem;
    menuTray: TMenuItem;
    popMenuShow: TMenuItem;
    popMenuClose: TMenuItem;
    menuSoalUjian: TMenuItem;
    popTray: TPopupMenu;
    tryForlap: TTrayIcon;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure menuBentrokClick(Sender: TObject);
    procedure menuHnrJagaClick(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure menuKRSClick(Sender: TObject);
    procedure mnTaksirClick(Sender: TObject);
    procedure PopMenuCekBentrokClick(Sender: TObject);
    procedure PopMenuKopSoalClick(Sender: TObject);
    procedure PopMenuHnrjagaClick(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure menuTrayClick(Sender: TObject);
    procedure popMenuCloseClick(Sender: TObject);
    procedure menuNilaiClick(Sender: TObject);
    procedure menuSoalUjianClick(Sender: TObject);
    procedure menuTRNLMClick(Sender: TObject);
    procedure menuTRAKMClick(Sender: TObject);
    procedure popMenuShowClick(Sender: TObject);
    procedure tryForlapDblClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmHome: TfrmHome;

implementation
uses uTRAKM, uTRNLM, uNilaiSimakad, uSoalUjian, uHnrSoal, uhonorjaga, uSplash, uBentrok, jdwgen, uTaksir;

{ TfrmHome }

procedure TfrmHome.menuTRAKMClick(Sender: TObject);
begin
  frmTRAKM.ShowModal;
end;

procedure TfrmHome.popMenuShowClick(Sender: TObject);
begin
  frmHome.Show;
  TryForlap.hide;
end;



procedure TfrmHome.tryForlapDblClick(Sender: TObject);
begin
  frmHome.Show;
end;

procedure TfrmHome.menuTRNLMClick(Sender: TObject);
begin
  frmNilai2TRNLM.ShowModal;
end;

procedure TfrmHome.menuNilaiClick(Sender: TObject);
begin

end;



procedure TfrmHome.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
   frmSplash.Close;
end;

procedure TfrmHome.FormCreate(Sender: TObject);
begin

end;

procedure TfrmHome.menuBentrokClick(Sender: TObject);
begin
  frmBentrok.ShowModal;
end;

procedure TfrmHome.menuHnrJagaClick(Sender: TObject);
begin
  frmHnrJaga.ShowModal;
end;

procedure TfrmHome.MenuItem12Click(Sender: TObject);
begin
 frmNilai2TRNLM.ShowModal;
end;

procedure TfrmHome.MenuItem1Click(Sender: TObject);
begin
  frmJdwGen.ShowModal;
end;

procedure TfrmHome.MenuItem3Click(Sender: TObject);
begin
     //frmNilai2TRNLM.ShowModal;

end;

procedure TfrmHome.menuKRSClick(Sender: TObject);
begin

end;

procedure TfrmHome.mnTaksirClick(Sender: TObject);
begin
  frmTaksir.ShowModal;
end;

procedure TfrmHome.PopMenuCekBentrokClick(Sender: TObject);
begin
  frmBentrok.ShowModal;
end;

procedure TfrmHome.PopMenuKopSoalClick(Sender: TObject);
begin
   frmSoalUjian.ShowModal;
end;

procedure TfrmHome.PopMenuHnrjagaClick(Sender: TObject);
begin
  frmHnrJaga.ShowModal;
end;

procedure TfrmHome.MenuItem6Click(Sender: TObject);
begin
  frmTRNLM.ShowModal;
end;

procedure TfrmHome.menuTrayClick(Sender: TObject);
begin
  TryForlap.Show;
  hide;
end;

procedure TfrmHome.popMenuCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmHome.menuSoalUjianClick(Sender: TObject);
begin
  frmSoalUjian.ShowModal;
end;


{$R *.lfm}

end.

