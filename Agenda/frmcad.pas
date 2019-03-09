unit frmCad;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, strutils, db, FileUtil, DateTimePicker, Forms, Controls,
  Graphics, Dialogs, EditBtn, StdCtrls, Buttons;

type

  { TfrmCadastro }

  TfrmCadastro = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure DateTimePicker2Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FDataAtual: String;
    Fid: integer;
    FInsertRec: Boolean;
    FSelDate: TDate;
    procedure SetDataAtual(AValue: String);
    procedure Setid(AValue: integer);
    procedure SetSelDate(AValue: TDate);
  public

  published
     property SelDate   : TDate read FSelDate write SetSelDate;
     property id        : integer read Fid write Setid;
     property DataAtual : String read FDataAtual write SetDataAtual;
  end;

var
  frmCadastro: TfrmCadastro;

implementation
  uses Unit1;
{$R *.lfm}

{ TfrmCadastro }




procedure TfrmCadastro.BitBtn1Click(Sender: TObject);
begin
   if Edit1.Text = EmptyStr then
      begin
          MessageDlg('Atenção','Evento e um campo obrigatório',Mterror, [mbok],0);
          Edit1.Setfocus;
          Exit;
      end;
   With Buf do
       begin
            if Locate('hora',FormatDateTime('hh:mm',DateTimePicker2.Time),[loPartialkey,loCaseInsensitive]) = true then
                     Edit
            else
                     Insert;
                     Fields.Fieldbyname('Registro').AsString   := DateToStr(DateTimePicker1.Date);
                     Fields.Fieldbyname('hora').AsString       := FormatDateTime('hh:mm',DateTimePicker2.Time);
                     Fields.Fieldbyname('Evento').AsString     := Edit1.text;
                     Fields.Fieldbyname('Importante').AsBoolean:= CheckBox1.Checked;
                     Fields.Fieldbyname('Urgente').AsBoolean   := CheckBox2.Checked;
                     Fields.Fieldbyname('Ligar').AsBoolean     := CheckBox3.Checked;
                     Fields.Fieldbyname('Aniversariante').AsBoolean     := CheckBox4.Checked;
                     Buf.Post;
                //end
                //else begin
                //     Buf.Insert;
                //     Fields.Fieldbyname('Registro').AsString   := DateToStr(DateTimePicker1.Date);
                //     Fields.Fieldbyname('hora').AsString       := FormatDateTime('hh:mm',DateTimePicker2.Time);
                //     Fields.Fieldbyname('Evento').AsString     := Edit1.text;
                //     Fields.Fieldbyname('Importante').AsBoolean:= CheckBox1.Checked;
                //     Fields.Fieldbyname('Urgente').AsBoolean   := CheckBox2.Checked;
                //     Fields.Fieldbyname('Ligar').AsBoolean     := CheckBox3.Checked;
                //     Buf.Post;
                //end;
       end;
   FSelDate := DateTimePicker1.Date;
end;

procedure TfrmCadastro.DateTimePicker2Change(Sender: TObject);
begin
if DateTimePicker1.Enabled then
   begin
      if Buf.Locate('registro',formatdatetime('dd/mm/yyyy',DateTimePicker1.Date), [loPartialKey,loCaseInsensitive]  ) then
         if Buf.Locate('hora',formatdatetime('hh:mm',DateTimePicker2.Time), [loPartialKey,loCaseInsensitive]  ) then
             begin
                 Edit1.text        := Buf.Fields.FieldByName('Evento').Asstring;
                 CheckBox1.Checked := Buf.fields.Fieldbyname('Importante').AsBoolean;
                 CheckBox2.Checked := Buf.fields.Fieldbyname('Urgente').AsBoolean;
                 CheckBox3.Checked := Buf.fields.Fieldbyname('Ligar').AsBoolean;
                 CheckBox4.Checked := Buf.fields.Fieldbyname('Aniversariante').AsBoolean;
             end;

   end;
end;

procedure TfrmCadastro.FormCreate(Sender: TObject);
begin
  Fid := 0;
end;

procedure TfrmCadastro.SetSelDate(AValue: TDate);
begin
  if FSelDate=AValue then Exit;
  FSelDate:=AValue;
end;

procedure TfrmCadastro.Setid(AValue: integer);
begin
  if Fid=AValue then Exit;
  Fid:=AValue;
end;

procedure TfrmCadastro.SetDataAtual(AValue: String);
begin
  if FDataAtual=AValue then Exit;
  FDataAtual:=AValue;
end;


end.

