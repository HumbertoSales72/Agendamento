unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, dateutils, strutils, FileUtil, LazUTF8, Forms, Controls,
  Graphics, Dialogs, Grids, Buttons, ExtDlgs, Calendar, DBGrids, StdCtrls,
  ExtCtrls, frmCad, Types, BufDataset, db;

type

  { TForm1 }

  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    Calendar1: TCalendar;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    ImageList1: TImageList;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    StringGrid1: TStringGrid;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure Calendar1DblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure StringGrid1ButtonClick(Sender: TObject; aCol, aRow: Integer);
    procedure StringGrid1Click(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure StringGrid1GetCellHint(Sender: TObject; ACol, ARow: Integer;
      var HintText: String);
    procedure StringGrid1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    procedure atualizaPanelDate(DataAtual: TDate);
    procedure IrParaHora(Hora: String);
    procedure IrParaHoraAtual;
    procedure recriar(DataAtual: String);

  public

  end;


var
  Form1: TForm1;
    Buf: TBufDataset;
    Rect,OldRect : TRect;
implementation

{$R *.lfm}

{ TForm1 }


procedure cantosarredondados(const controle: twincontrol);
var
  abitmap: graphics.tbitmap;
begin
  try
      abitmap := graphics.tbitmap.create;
      abitmap.monochrome := true;
      abitmap.width := controle.width; // or form1.width
      abitmap.height := controle.height; // or form1.height
      abitmap.canvas.brush.color:=clblack;
      abitmap.canvas.fillrect(0, 0, controle.width, controle.height);
      abitmap.canvas.brush.color:=clwhite;
      abitmap.canvas.roundrect(0,0,controle.width,controle.height,20,20);
      controle.setshape(abitmap);
  finally
      abitmap.free;
  end;

end;

procedure TForm1.atualizaPanelDate(DataAtual: TDate);
begin
  Panel1.Caption := FormatDateTime('dd',DataAtual);
  Panel2.Caption := 'Hoje';//FormatDateTime('Dddd',DataAtual);
  Label1.Caption := #13#13#13#13 + FormatDateTime('Dddd',DataAtual);//FormatDateTime('yyyy',DataAtual);
  Label2.Caption := UTF8UpperCase(FormatDateTime('Mmmm',DataAtual));
end;

procedure TForm1.IrParaHora(Hora : String);
var
  Tm: String;
  i: Integer;
begin
  With StringGrid1 do
   for i := 1 to RowCount -1 do
       begin
           if Cells[0,i] = Hora then
                   begin
                       StringGrid1.Row:= i + 11;
                       StringGrid1.Row:= i;
                       break;
                   end;
       end;

end;

procedure TForm1.IrParaHoraAtual;
var
   Tm : String;
   i  : Integer;
begin
  Tm := FormatDateTime('hh',Now);
  With StringGrid1 do
    for i := 1 to RowCount -1 do
      begin
         if  Copy(Cells[0,i] ,1,2) = tm then
                 begin
                     StringGrid1.Row:= i + 11;
                     StringGrid1.Row:= i;
                     break;
                 end;
      end;
end;

procedure TForm1.recriar(DataAtual : String);
var
  t  : TTime;
  i  : Integer;
begin
  StringGrid1.OnClick:= nil;
  OldRect.Left := Default(Integer); //para nao mostrar a imagem do botao apagar na nova grid preenchida
  with Buf do
      begin
          if DataAtual = EmptyStr then
             DataAtual := Datetostr(Date);
          Panel3.Caption := FormatDateTime('ddd, dd "de" mmmm "de" yyyy',StrtoDate(DataAtual) );
          Filtered := False;
          Filter   :=  'Registro = ' + Quotedstr( DataAtual );
          Filtered := True;
          IndexFieldNames:= 'hora';
          StringGrid1.RowCount:= 1;
          if IsEmpty then
                  begin
                      t := 0;
                      for i := 1 to 48 do
                          begin
                              Stringgrid1.RowCount := Stringgrid1.RowCount + 1;
                              Stringgrid1.Cells[0,i] := FormatDateTime('hh:mm',t);
                              t := IncMinute(t,30);
                              Buf.Insert;
                              Buf.Fields.Fieldbyname('Registro').AsString := DataAtual;
                              Buf.Fields.Fieldbyname('hora').AsString     := FormatDateTime('hh:mm',t);
                              Buf.Post;
                          end;
                  end
                  Else begin
                        First;
                        While not eof do
                            begin
                                Stringgrid1.RowCount := Stringgrid1.RowCount + 1;
                                Stringgrid1.Cells[0,Stringgrid1.RowCount -1] := Fields.Fieldbyname('hora').AsString;
                                Stringgrid1.Cells[1,Stringgrid1.RowCount -1] := Fields.Fieldbyname('Evento').AsString;
                                Stringgrid1.Cells[2,Stringgrid1.RowCount -1] := ifthen( Fields.Fieldbyname('Importante').AsBoolean = true, 's');
                                Stringgrid1.Cells[3,Stringgrid1.RowCount -1] := ifthen( Fields.Fieldbyname('Urgente').AsBoolean = true, 's');
                                Stringgrid1.Cells[4,Stringgrid1.RowCount -1] := ifthen( Fields.Fieldbyname('Ligar').AsBoolean = true, 's');
                                Stringgrid1.Cells[5,Stringgrid1.RowCount -1] := ifthen( Fields.Fieldbyname('Aniversariante').AsBoolean = true, 's');
                                Next;
                            end;
                  end;
      end;
 IrParaHoraAtual;
 StringGrid1.OnClick:= @StringGrid1Click;
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
var
  Tm: String;
  i: Integer;
begin
  Tm := FormatDateTime('hh',Now);
  With StringGrid1 do
   for i := 1 to RowCount -1 do
       begin
           if  Copy(Cells[0,i] ,1,2) = tm then
                   begin
                       StringGrid1.Row:= i + 11;
                       StringGrid1.Row:= i;
                       break;
                   end;
       end;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
var
  FEvento : String;
begin
  if InputQuery('Evento','Informe o texto do evento abaixo:', FEvento) then
          begin
              if Buf.Locate('Evento',FEvento,[loPartialKey,loCaseInsensitive]) = False then
                  MessageDlg('Atenção','Nada foi encontrado!',Mtinformation,[mbok],0)
              else begin
                   IrParaHora(Buf.Fields.Fieldbyname('hora').Asstring);
              end;

          end;
end;

procedure TForm1.BitBtn3Click(Sender: TObject);
var
  Tm: String;
begin
  if InputQuery('Hora','Digite a hora. Ex: 08:30',Tm) then
      IrParaHora(Tm);
end;

procedure TForm1.BitBtn4Click(Sender: TObject);
var
  i : Integer;
  T : TTime;
  DataAtual : String;
begin
  With TfrmCadastro.Create(nil) do
        begin
           DateTimePicker1.DateTime:= Calendar1.DateTime;
           DateTimePicker2.Time    := Time;
           With Buf do
                begin
                   DataAtual := Fields.FieldByName('registro').AsString;
                   Filtered := False;
                   Filter   :=  'Registro = ' + Quotedstr( Calendar1.Date );
                   Filtered := True;
                   if IsEmpty then
                       begin
                           t := 0;
                           for i := 1 to 48 do
                               begin
                                   Stringgrid1.RowCount := Stringgrid1.RowCount + 1;
                                   Stringgrid1.Cells[0,i] := FormatDateTime('hh:mm',t);
                                   t := IncMinute(t,30);
                                   Buf.Insert;
                                   Buf.Fields.Fieldbyname('Registro').AsString := Calendar1.Date;
                                   Buf.Fields.Fieldbyname('hora').AsString     := FormatDateTime('hh:mm',t);
                                   Buf.Post;
                               end;
                       end;
                   Filtered := False;
                   Filter   :=  'Registro = ' + Quotedstr( DataAtual );
                   Filtered := True;

                end;
           if ShowModal = mrOK then
               Recriar(Calendar1.Date);
           free;
        end;
end;

procedure TForm1.BitBtn5Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.Calendar1DblClick(Sender: TObject);
begin
  recriar( Calendar1.Date );
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  t  : TTime;
  i: Integer;
  s, Tm: String;
begin
  FormatSettings.ShortDateFormat := 'dd/mm/yyyy';
  Buf := TBufDataSet.Create(Nil);
  with Buf,Buf.FieldDefs do
      begin
          if FileExists('Agenda.dat') then
            LoadFromFile('Agenda.dat')
          else begin
              Add('id',ftAutoInc);
              Add('Registro',ftString,10);
              Add('Hora',ftString,5);
              Add('Evento',ftString,150);
              Add('Importante',ftBoolean);
              Add('Urgente',ftBoolean);
              Add('Ligar',ftBoolean);
              Add('Aniversariante',ftBoolean);
              AddIndex('hora','hora',[]);
              CreateDataset;
              IndexFieldNames:= 'hora';
          end;
          Open;
          datasource1.dataset := buf;
      end;
  recriar(FormatDateTime('dd/mm/yyyy',Date) );
  Calendar1.DateTime:= now;
  ImageList1.GetBitmap(5,BitBtn1.Glyph);
  ImageList1.GetBitmap(5,BitBtn2.Glyph);
  ImageList1.GetBitmap(5,BitBtn3.Glyph);
  ImageList1.GetBitmap(6,BitBtn4.Glyph);
  ImageList1.GetBitmap(7,BitBtn5.Glyph);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Buf.SaveToFile('Agenda.dat');
  Buf.Free;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
    atualizaPanelDate(Date);
    cantosarredondados(Panel1);
end;

procedure TForm1.Panel1Click(Sender: TObject);
begin
  recriar( Datetostr(Date) );
  Calendar1.DateTime := Today;
end;

procedure TForm1.StringGrid1ButtonClick(Sender: TObject; aCol, aRow: Integer);
var
  DateNow: String;
begin
  With TfrmCadastro.Create(nil) do
        begin
                 DateNow                 := buf.Fields.fieldbyname('Registro').AsString;
                 DateTimePicker1.Date    := buf.Fields.fieldbyname('Registro').AsDatetime;
                 DateTimePicker2.Time    := StrTotime(Stringgrid1.Cells[Acol -1,Arow]);
                 Edit1.text              := Stringgrid1.Cells[Acol,Arow];
                 CheckBox1.Checked       := StringGrid1.Cells[2,StringGrid1.Row] = 's';
                 CheckBox2.Checked       := StringGrid1.Cells[3,StringGrid1.Row] = 's';
                 CheckBox3.Checked       := StringGrid1.Cells[4,StringGrid1.Row] = 's';
                 CheckBox4.Checked       := StringGrid1.Cells[5,StringGrid1.Row] = 's';
                 DateTimePicker1.Enabled := False;
                 DateTimePicker2.Enabled := False;
                 DataAtual := StringGrid1.Cells[ACol - 1,ARow];
                 if ShowModal = mrOK then
                     Recriar(DateNow);
                 free;
        end;
end;

procedure TForm1.StringGrid1Click(Sender: TObject);
var
  ARow,Acol : Integer;
  minuto: Word;
begin
    Stringgrid1.OnMouseMove:= Nil;
    Stringgrid1.MouseToCell(Rect.CenterPoint.x,Rect.CenterPoint.y, ACol,ARow);
    if (Acol = 6) and (ARow > 0) and (StringGrid1.Cells[1,ARow] <> '') then
        if Messagedlg('Remoção de Evento','Remover evento: ' + StringGrid1.Cells[1,ARow],MtConfirmation,[mbyes,mbno],0) = Mryes then
            begin
                if Buf.Locate('hora',StringGrid1.Cells[0,ARow],[loPartialKey,loCaseInsensitive]) then
                    begin
                        minuto := MinuteOf(buf.Fields.FieldByName('hora').AsDateTime);
                        if ( minuto = 0 ) or ( minuto = 30 ) then
                            begin
                                Buf.Edit;
                                Buf.FieldByName('Evento').AsString := '';
                                Buf.FieldByName('Importante').AsBoolean := False;
                                Buf.FieldByName('Urgente').AsBoolean := False;
                                Buf.FieldByName('Ligar').AsBoolean := False;
                                Buf.FieldByName('Aniversariante').AsBoolean := False;
                                Buf.Post;
                            end
                            Else
                                Buf.Delete;
                        OldRect.Left := Default(Integer);
                    end;
              recriar(Buf.FieldByName('Registro').AsString);
            end;
     StringGrid1.OnMouseMove:= @StringGrid1MouseMove;
end;

procedure TForm1.StringGrid1DrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
var
  Col,Row : Integer;
begin
  if  (gdRowHighlight in aState)  then
    begin
      StringGrid1.Canvas.Brush.Color:= $004D71F4;
      StringGrid1.Canvas.Font.Color  := clWhite;
      StringGrid1.Canvas.Font.Style := [fsBold];
      StringGrid1.Canvas.FillRect(ARect);
      StringGrid1.DefaultDrawCell(aCol,aRow,aRect,aState);
    end;
  if (Acol = 2) and (ARow > 0) and (Stringgrid1.Cells[acol,arow] <>'') then
          ImageList1.Draw(StringGrid1.Canvas,ARect.Left,Arect.top,0);
  if (Acol = 3) and (ARow > 0) and (Stringgrid1.Cells[acol,arow] <>'') then
          ImageList1.Draw(StringGrid1.Canvas,ARect.Left,Arect.top,1);
  if (Acol = 4) and (ARow > 0) and (Stringgrid1.Cells[acol,arow] <>'') then
          ImageList1.Draw(StringGrid1.Canvas,ARect.Left,Arect.top,2);
  if (Acol = 5) and (ARow > 0) and (Stringgrid1.Cells[acol,arow] <>'') then
          ImageList1.Draw(StringGrid1.Canvas,ARect.Left,Arect.top,3);
  if (Acol = 6) and (ARow > 0) and (Stringgrid1.Cells[1,arow] <>'') then
          ImageList1.Draw(StringGrid1.Canvas,ARect.Left,Arect.top,4);
end;

procedure TForm1.StringGrid1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  ACol,Arow : Integer;
begin
    //para mover o mouse e mudar o icone precisa de 3 eventos
    //Ondrawcell.. onde desenha o icone
    //MouseMove.. para mudar os icones ao mover
    //Para Apagar;
    StringGrid1.MouseToCell(x,y,Acol,Arow);
    Rect := StringGrid1.CellRect(ACol,ARow);
  if (OldRect <> Rect) and (OldRect.Left <> Default(Integer) )  then
     begin
        ImageList1.Draw(StringGrid1.Canvas,OldRect.Left,OldRect.top,4);
     end;
  if (Acol = 6) and (ARow > 0) and (Stringgrid1.Cells[1,arow] <> '') then
     begin
        ImageList1.Draw(StringGrid1.Canvas,Rect.Left,rect.top,4,False);
        OldRect := Rect;
     end;

end;


procedure TForm1.StringGrid1GetCellHint(Sender: TObject; ACol, ARow: Integer;
  var HintText: String);
begin
  if ACol = 2 then
      if StringGrid1.Cells[Acol,Arow] <> '' then
          HintText := 'Importante';
  if ACol = 3 then
      if StringGrid1.Cells[Acol,Arow] <> '' then
          HintText := 'Urgente';
  if ACol = 4 then
      if StringGrid1.Cells[Acol,Arow] <> '' then
          HintText := 'Ligar';
  if ACol = 5 then
      if StringGrid1.Cells[Acol,Arow] <> '' then
          HintText := 'Aniversáriante';
  if ACol = 6 then
      if StringGrid1.Cells[Acol,Arow] <> '' then
          HintText := 'Remover Evento';
end;



end.


