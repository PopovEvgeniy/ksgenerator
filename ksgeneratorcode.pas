unit ksgeneratorcode;

{$mode objfpc}{$H+}

interface

uses Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, LazFileUtils;

type

  { TMainWindow }

  TMainWindow = class(TForm)
    GenerateButton: TButton;
    ServerField: TLabeledEdit;
    KeyField: TLabeledEdit;
    SaveDialog: TSaveDialog;
    procedure GenerateButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ServerFieldChange(Sender: TObject);
    procedure KeyFieldChange(Sender: TObject);
  private

  public

  end;

var MainWindow: TMainWindow;

implementation

{$R *.lfm}

procedure window_setup();
begin
 Application.Title:='KMS script generator';
 MainWindow.Caption:='KMS script generator 0.2.8';
 MainWindow.BorderStyle:=bsDialog;
 MainWindow.Font.Name:=Screen.MenuFont.Name;
 MainWindow.Font.Size:=14;
end;

procedure interface_setup();
begin
 MainWindow.GenerateButton.Enabled:=False;
 MainWindow.GenerateButton.ShowHint:=False;
 MainWindow.ServerField.LabelPosition:=lpLeft;
 MainWindow.KeyField.LabelPosition:=lpLeft;
 MainWindow.ServerField.Text:='';
 MainWindow.KeyField.Text:='';
end;

procedure dialog_setup();
begin
 MainWindow.SaveDialog.InitialDir:='';
 MainWindow.SaveDialog.FileName:='*.bat';
 MainWindow.SaveDialog.DefaultExt:='*.bat';
end;

procedure language_setup();
begin
 MainWindow.GenerateButton.Caption:='Generate';
 MainWindow.ServerField.EditLabel.Caption:='The KMS server';
 MainWindow.KeyField.EditLabel.Caption:='The product key';
 MainWindow.SaveDialog.Title:='Save a script';
 MainWindow.SaveDialog.Filter:='A batch script|*.bat';
end;

procedure setup();
begin
 window_setup();
 interface_setup();
 dialog_setup();
 language_setup();
end;

function generate_script(const target:string;const server:string;const key:string):boolean;
var batch:text;
var script:string;
begin
 script:=ExtractFileNameWithoutExt(target)+'.bat';
 try
  Assign(batch,script);
  Rewrite(batch);
  writeln(batch,'@echo off');
  writeln(batch,'slmgr /ipk ',key);
  writeln(batch,'slmgr /skms ',server);
  write(batch,'slmgr /ato');
  Close(batch);
 except
  ;
 end;
 generate_script:=FileExists(script);
end;

{ TMainWindow }

procedure TMainWindow.FormCreate(Sender: TObject);
begin
 setup();
end;

procedure TMainWindow.GenerateButtonClick(Sender: TObject);
begin
 if MainWindow.SaveDialog.Execute()=True then
 begin
  if generate_script(MainWindow.SaveDialog.FileName,MainWindow.ServerField.Text,MainWindow.KeyField.Text)=False then ShowMessage('The operation failed');
 end;

end;

procedure TMainWindow.ServerFieldChange(Sender: TObject);
begin
 MainWindow.GenerateButton.Enabled:=(MainWindow.ServerField.Text<>'') and (MainWindow.KeyField.Text<>'');
end;

procedure TMainWindow.KeyFieldChange(Sender: TObject);
begin
 MainWindow.GenerateButton.Enabled:=(MainWindow.ServerField.Text<>'') and (MainWindow.KeyField.Text<>'');
end;

end.
