unit ksgeneratorcode;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LazFileUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    SaveDialog1: TSaveDialog;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LabeledEdit1Change(Sender: TObject);
    procedure LabeledEdit2Change(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

procedure window_setup();
begin
 Application.Title:='Kms script generator';
 Form1.Caption:='Kms script generator 0.2.1';
 Form1.BorderStyle:=bsDialog;
 Form1.Font.Name:=Screen.MenuFont.Name;
 Form1.Font.Size:=14;
end;

procedure interface_setup();
begin
 Form1.Button1.Enabled:=False;
 Form1.Button1.ShowHint:=False;
 Form1.LabeledEdit1.LabelPosition:=lpLeft;
 Form1.LabeledEdit2.LabelPosition:=lpLeft;
 Form1.LabeledEdit1.Text:='';
 Form1.LabeledEdit2.Text:='';
end;

procedure dialog_setup();
begin
 Form1.SaveDialog1.InitialDir:='';
 Form1.SaveDialog1.FileName:='*.bat';
 Form1.SaveDialog1.DefaultExt:='*.bat';
end;

procedure language_setup();
begin
 Form1.Button1.Caption:='Generate';
 Form1.LabeledEdit1.EditLabel.Caption:='The KMS server';
 Form1.LabeledEdit2.EditLabel.Caption:='The product key';
 Form1.SaveDialog1.Title:='Save a script';
 Form1.SaveDialog1.Filter:='A batch script|*.bat';
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
 {$I-}
 script:=ExtractFileNameWithoutExt(target)+'.bat';
 Assign(batch,script);
 Rewrite(batch);
 if IOResult()=0 then
 begin
  writeln(batch,'@echo off');
  writeln(batch,'slmgr /ipk ',key);
  writeln(batch,'slmgr /skms ',server);
  write(batch,'slmgr /ato');
  Close(batch);
 end;
 {$I+}
 generate_script:=FileExists(script);
end;

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
 setup();
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 if Form1.SaveDialog1.Execute()=True then
 begin
  if generate_script(Form1.SaveDialog1.FileName,Form1.LabeledEdit1.Text,Form1.LabeledEdit2.Text)=False then ShowMessage('The operation failed');
 end;

end;

procedure TForm1.LabeledEdit1Change(Sender: TObject);
begin
 Form1.Button1.Enabled:=(Form1.LabeledEdit1.Text<>'') and (Form1.LabeledEdit2.Text<>'');
end;

procedure TForm1.LabeledEdit2Change(Sender: TObject);
begin
 Form1.Button1.Enabled:=(Form1.LabeledEdit1.Text<>'') and (Form1.LabeledEdit2.Text<>'');
end;

end.