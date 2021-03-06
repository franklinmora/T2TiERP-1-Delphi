{*******************************************************************************
Title: T2Ti ERP
Description: Gera arquivo da mem�ria da fita detalhe.

The MIT License

Copyright: Copyright (C) 2010 T2Ti.COM

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

       The author may be contacted at:
           t2ti.com@gmail.com</p>

@author Albert Eije (T2Ti.COM) | Gilson Lima
@version 1.0
*******************************************************************************}
unit UArquivoMFD;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvExDBGrids, StdCtrls, JvExStdCtrls,
  JvButton, JvCtrls, Buttons, JvExButtons, JvBitBtn, pngimage, ExtCtrls, Mask,
  JvEdit, JvValidateEdit, JvEnterTab, JvComponentBase, DateUtils;

type
  TFArquivoMfd = class(TForm)
    Image1: TImage;
    RadioGroup2: TRadioGroup;
    panPeriodo: TPanel;
    mkeDataIni: TMaskEdit;
    Label1: TLabel;
    mkeDataFim: TMaskEdit;
    Label2: TLabel;
    panCOO: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    editInicio: TJvValidateEdit;
    editFim: TJvValidateEdit;
    botaoConfirma: TJvBitBtn;
    botaoCancela: TJvImgBtn;
    JvEnterAsTab1: TJvEnterAsTab;
    procedure Confirma;
    procedure RadioGroup2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure botaoConfirmaClick(Sender: TObject);
    procedure mkeDataFimExit(Sender: TObject);
    procedure editFimExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FArquivoMfd: TFArquivoMfd;
const
  NOME_ARQUIVO = 'ArquivoMFD.txt';

implementation

Uses
  UCaixa, UDataModule, EAD_Class, SWSystem;

{$R *.dfm}

procedure TFArquivoMfd.FormActivate(Sender: TObject);
begin
  Color := StringToColor(UCaixa.Configuracao.CorJanelasInternas);
  mkeDataIni.Text := DateToStr(StartOfTheMonth(FDataModule.ACBrECF.DataHora));
  mkeDataFim.Text := DateToStr(FDataModule.ACBrECF.DataHora);
  editFim.Text    := FDataModule.ACBrECF.NumCOO;
  mkeDataIni.SetFocus;
end;

procedure TFArquivoMfd.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFArquivoMfd.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if key = 123 then
    Confirma;
end;

procedure TFArquivoMfd.mkeDataFimExit(Sender: TObject);
begin
   if StrToDate(mkeDataFim.text) < StrToDate(mkeDataIni.text) then
      Begin
        Application.MessageBox('Data Final deve ser Maior que Data Inicial', 'Informa��o do Sistema', MB_OK + MB_ICONINFORMATION);
        mkeDataFim.SetFocus;
      End;
end;

procedure TFArquivoMfd.RadioGroup2Click(Sender: TObject);
begin
  if RadioGroup2.ItemIndex = 0 then
  begin;
    panCOO.Enabled := False;
    panCOO.BevelOuter := bvLowered;
    panPeriodo.Enabled := True;
    panPeriodo.BevelOuter := bvRaised;
  end
  else
  begin
    panCOO.Enabled := True;
    panCOO.BevelOuter := bvRaised;
    panPeriodo.Enabled := False;
    panPeriodo.BevelOuter := bvLowered;
  end;
end;

procedure TFArquivoMfd.botaoConfirmaClick(Sender: TObject);
begin
  Confirma;
end;

procedure TFArquivoMfd.confirma;
var
  Mensagem: String;
  aData : TDateTime;
begin
  if Application.MessageBox('Deseja gerar o arquivo da MFD - Mem�ria Fita Detalhe?', 'Pergunta do Sistema', Mb_YesNo + Mb_IconQuestion) = IdYes then
  begin
    //por data

    if radiogroup2.ItemIndex = 0 then
       Begin
        aData := strtodate(mkeDataFim.Text);
        if aData >= FDataModule.ACBrECF.DataHora then
           begin
             mensagem := 'Data Final Precisa Ser Menor Que '+DateToStr(FDataModule.ACBrECF.DataHora);
             Application.MessageBox(PWideChar(mensagem), 'Informa��o do Sistema', MB_OK + MB_ICONINFORMATION);
             Exit;
           end;
        try
          FDataModule.ACBrECF.ArquivoMFD_DLL(StrToDateTime(mkeDataIni.Text) - 1,StrToDateTime(mkeDataFim.Text),NOME_ARQUIVO);
        Except
        end;
       End

    //por reducao
    else if radiogroup2.ItemIndex = 1 then
         begin
           if (StrToInt(editFim.Text)) > (StrToInt(FDataModule.ACBrECF.NumCOO)) then
               Begin
                 mensagem := 'N�mero do COO N�o Pode Ser Maior Que '+FDataModule.ACBrECF.NumCOO;
                 Application.MessageBox(PWideChar(mensagem), 'Informa��o do Sistema', MB_OK + MB_ICONINFORMATION);
                 Exit;
               End;
           try
             FDataModule.ACBrECF.ArquivoMFD_DLL(StrToInt(editInicio.Text),StrToInt(editFim.Text),NOME_ARQUIVO);
           Except
           end;
         end;

    TEAD_Class.SingEAD(NOME_ARQUIVO);

    Mensagem := 'Arquivo armazenado em: ' + gsAppPath + NOME_ARQUIVO;
    Application.MessageBox(PWideChar(mensagem), 'Informa��o do Sistema', MB_OK + MB_ICONINFORMATION);
  end;
end;

procedure TFArquivoMfd.editFimExit(Sender: TObject);
begin
   if StrToInt(editFim.text) < StrToInt(editInicio.text) then
      Begin
        Application.MessageBox('COO Final deve ser Maior que COO Inicial', 'Informa��o do Sistema', MB_OK + MB_ICONINFORMATION);
        mkeDataFim.SetFocus;
      End;
end;

end.
