program ksgenerator;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, ksgeneratorcode
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.MainFormOnTaskbar:=True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
