unit konekMySQL;

{$mode objfpc}{$H+}

interface
function Koneksi(param:string):string;

implementation
Uses
  Classes,SysUtils,INIFiles;


function Koneksi(param:string):string;
var
   INI:TINIFile;
   server,pass: string;

begin
   INI := TINIFile.Create('config.ini');
   server := INI.ReadString('INICONFIG','server','');
   if (server='localhost') then
      begin
           pass:= 'swu';
      end
   else
       begin
            pass:='purw0k3rt0';
       end;

   CASE param OF
        'server'   : Koneksi:=server;
        'username' : Koneksi:=INI.ReadString('INICONFIG','user','');
        'password' : Koneksi:=pass;
        'database' : Koneksi:=INI.ReadString('INICONFIG','dbname','');
        'driver' :  Koneksi:='MYSQL ODBC 3.51 DRIVER';

   ELSE
        Koneksi:='';
   end;

end;

end.

