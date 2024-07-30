program Calculator5;

uses
  Vcl.Forms,
  MainForm in 'MainForm.pas' {MainFm},
  uCalculator in 'uCalculator.pas',
  uExample in 'uExample.pas',
  uActions in 'uActions.pas';

{$R *.res}


begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainFm, MainFm);
  Application.Run;
end.
