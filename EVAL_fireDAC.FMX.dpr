program EVAL_fireDAC.FMX;

uses
  System.StartUpCopy,
  FMX.Forms,
  Unit_FD.FMX in 'Unit_FD.FMX.pas' {Form_dbtest},
  Unit_dbfunctions in 'Unit_dbfunctions.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm_dbtest, Form_dbtest);
  Application.Run;
end.

