program EVAL_fireDAC.FMX;

uses
  System.StartUpCopy,
  FMX.Forms,
  Unit_FD.FMX in 'Unit_FD.FMX.pas' {Form_dbtest},
  Unit_DatabaseTypes in '..\..\..\..\code_shared_libraries\Unit_DatabaseTypes.pas',
  TCheckListBox.FMX in '..\..\..\..\code_shared_libraries\TCheckListBox.FMX.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm_dbtest, Form_dbtest);
  Application.Run;
end.

