program Calculator4;

uses
  Vcl.Forms,
  MainForm in 'MainForm.pas' {MainFm},
  uCalculator in 'uCalculator.pas',
  uRecord in 'uRecord.pas',
  uActions in 'uActions.pas';

{$R *.res}


begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainFm, MainFm);
  Application.Run;
end.
