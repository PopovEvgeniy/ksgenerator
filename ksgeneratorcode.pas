unit ksgeneratorcode;

{
 This sofware was made by Popov Evgeniy Alekseyevich.
 It is distributed under the GNU GENERAL PUBLIC LICENSE (Version 2 or higher).
}

{$mode objfpc}
{$H+}

interface

uses Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

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
    procedure window_setup();
    procedure dialog_setup();
    procedure interface_setup();
    procedure language_setup();
    procedure setup();
  public
    { public declarations }
  end;

var MainWindow: TMainWindow;

implementation

{$R *.lfm}

procedure TMainWindow.window_setup();
begin
 Application.Title:='KMS script generator';
 Self.Caption:='KMS script generator 0.3.7';
 Self.BorderStyle:=bsDialog;
 Self.Font.Name:=Screen.MenuFont.Name;
 Self.Font.Size:=14;
end;

procedure TMainWindow.interface_setup();
begin
 Self.GenerateButton.Enabled:=False;
 Self.GenerateButton.ShowHint:=False;
 Self.ServerField.LabelPosition:=lpLeft;
 Self.KeyField.LabelPosition:=lpLeft;
 Self.ServerField.Text:='';
 Self.KeyField.Text:='';
end;

procedure TMainWindow.dialog_setup();
begin
 Self.SaveDialog.InitialDir:='';
 Self.SaveDialog.FileName:='';
 Self.SaveDialog.DefaultExt:='.bat';
end;

procedure TMainWindow.language_setup();
begin
 Self.GenerateButton.Caption:='Generate';
 Self.ServerField.EditLabel.Caption:='The KMS server';
 Self.KeyField.EditLabel.Caption:='The product key';
 Self.SaveDialog.Title:='Save a script';
 Self.SaveDialog.Filter:='A batch script|*.bat';
end;

procedure TMainWindow.setup();
begin
 Self.window_setup();
 Self.interface_setup();
 Self.dialog_setup();
 Self.language_setup();
end;

function generate_script(const target:string;const server:string;const key:string):boolean;
var batch:text;
var success:boolean;
begin
 {$I-}
 Assign(batch,target);
 Rewrite(batch);
 success:=IOResult()=0;
 if success then
 begin
  writeln(batch,'@echo off');
  writeln(batch,'slmgr /ipk ',key);
  writeln(batch,'slmgr /skms ',server);
  writeln(batch,'slmgr /ato');
  write(batch,'slmgr /xpr');
  Close(batch);
 end;
 {$I+}
 generate_script:=success;
end;

{ TMainWindow }

procedure TMainWindow.FormCreate(Sender: TObject);
begin
 Self.setup();
end;

procedure TMainWindow.GenerateButtonClick(Sender: TObject);
begin
 if Self.SaveDialog.Execute()=True then
 begin
  if generate_script(Self.SaveDialog.FileName,Self.ServerField.Text,Self.KeyField.Text)=False then ShowMessage('The operation failed');
 end;

end;

procedure TMainWindow.ServerFieldChange(Sender: TObject);
begin
 Self.GenerateButton.Enabled:=(Self.ServerField.Text<>'') and (Self.KeyField.Text<>'');
end;

procedure TMainWindow.KeyFieldChange(Sender: TObject);
begin
 Self.GenerateButton.Enabled:=(Self.ServerField.Text<>'') and (Self.KeyField.Text<>'');
end;

end.
