{ *******************************************************************************
  Title: T2Ti ERP
  Description: Janela de Romaneio de Entrega

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
  t2ti.com@gmail.com

  @author Albert Eije
  @version 1.0
  ******************************************************************************* }
unit UVendaRomaneioEntrega;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UTelaCadastro, Menus, StdCtrls, ExtCtrls, Buttons, Grids, DBGrids,
  JvExDBGrids, JvDBGrid, JvDBUltimGrid, ComCtrls, LabeledCtrls, Atributos, Constantes,
  Mask, JvExMask, JvToolEdit, JvBaseEdits, DB, DBClient, Generics.Collections,
  WideStrings, DBXMySql, FMTBcd, Provider, SqlExpr, StrUtils, ActnList,
  PlatformDefaultStyleActnCtrls, ActnMan, ToolWin, ActnCtrls;

type
  [TFormDescription(TConstantes.MODULO_VENDAS, 'Romaneio de Entrega')]

  TFVendaRomaneioEntrega = class(TFTelaCadastro)
    DSVenda: TDataSource;
    GroupBoxParcelas: TGroupBox;
    GridParcelas: TJvDBUltimGrid;
    ScrollBox1: TScrollBox;
    EditDescricao: TLabeledEdit;
    MemoObservacao: TLabeledMemo;
    EditEntregador: TLabeledEdit;
    ComboBoxSituacao: TLabeledComboBox;
    EditDataEmissao: TLabeledDateEdit;
    EditDataPrevista: TLabeledDateEdit;
    EditDataSaida: TLabeledDateEdit;
    EditIdEntregador: TLabeledCalcEdit;
    CDSVenda: TClientDataSet;
    ActionManager1: TActionManager;
    ActionAdicionarVenda: TAction;
    ActionToolBar1: TActionToolBar;
    EditDataEncerramento: TLabeledDateEdit;
    Bevel1: TBevel;
    CDSVendaID: TIntegerField;
    CDSVendaDATA_VENDA: TDateField;
    CDSVendaCLIENTENOME: TStringField;
    CDSVendaVALOR_TOTAL: TFMTBCDField;
    ActionRemoverVenda: TAction;
    procedure FormCreate(Sender: TObject);
    procedure EditIdEntregadorKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditIdEntregadorExit(Sender: TObject);
    procedure EditIdEntregadorKeyPress(Sender: TObject; var Key: Char);
    procedure GridParcelasKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ActionAdicionarVendaExecute(Sender: TObject);
    procedure ActionRemoverVendaExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure GridParaEdits; override;
    procedure LimparCampos; override;
    procedure ControlaBotoes; override;
    procedure ControlaPopupMenu; override;

    // Controles CRUD
    function DoInserir: Boolean; override;
    function DoEditar: Boolean; override;
    function DoExcluir: Boolean; override;
    function DoSalvar: Boolean; override;
  end;

var
  FVendaRomaneioEntrega: TFVendaRomaneioEntrega;

implementation

uses VendaRomaneioEntregaVO, VendaRomaneioEntregaController, VendaCabecalhoVO,
  VendaCabecalhoController, ULookup, UDataModule, ColaboradorVO, ColaboradorController;
{$R *.dfm}

{$REGION 'Infra'}
procedure TFVendaRomaneioEntrega.FormCreate(Sender: TObject);
begin
  ClasseObjetoGridVO := TVendaRomaneioEntregaVO;
  ObjetoController := TVendaRomaneioEntregaController.Create;

  inherited;
end;

procedure TFVendaRomaneioEntrega.LimparCampos;
begin
  inherited;
  CDSVenda.EmptyDataSet;
end;

procedure TFVendaRomaneioEntrega.ControlaBotoes;
begin
  inherited;

  BotaoImprimir.Visible := False;
end;

procedure TFVendaRomaneioEntrega.ControlaPopupMenu;
begin
  inherited;

  MenuImprimir.Visible := False;
end;
{$ENDREGION}

{$REGION 'Controles CRUD'}
function TFVendaRomaneioEntrega.DoInserir: Boolean;
begin
  Result := inherited DoInserir;

  if Result then
  begin
    EditIdEntregador.SetFocus;
  end;
end;

function TFVendaRomaneioEntrega.DoEditar: Boolean;
begin
  Result := inherited DoEditar;

  if Result then
  begin
    EditIdEntregador.SetFocus;
  end;
end;

function TFVendaRomaneioEntrega.DoExcluir: Boolean;
begin
  if inherited DoExcluir then
  begin
    try
      Result := TVendaRomaneioEntregaController(ObjetoController).Exclui(IdRegistroSelecionado);
    except
      Result := False;
    end;
  end
  else
  begin
    Result := False;
  end;

  if Result then
    TVendaRomaneioEntregaController(ObjetoController).Consulta(Filtro, Pagina);
end;

function TFVendaRomaneioEntrega.DoSalvar: Boolean;
begin
  DecimalSeparator := '.';
  Result := inherited DoSalvar;

  if Result then
  begin
    try
      if not Assigned(ObjetoVO) then
        ObjetoVO := TVendaRomaneioEntregaVO.Create;

      TVendaRomaneioEntregaVO(ObjetoVO).IdColaborador := EditIdEntregador.AsInteger;
      TVendaRomaneioEntregaVO(ObjetoVO).ColaboradorPessoaNome := EditEntregador.Text;
      TVendaRomaneioEntregaVO(ObjetoVO).Descricao := EditDescricao.Text;
      TVendaRomaneioEntregaVO(ObjetoVO).DataEmissao := EditDataEmissao.Date;
      TVendaRomaneioEntregaVO(ObjetoVO).DataPrevista := EditDataPrevista.Date;
      TVendaRomaneioEntregaVO(ObjetoVO).DataSaida := EditDataSaida.Date;
      TVendaRomaneioEntregaVO(ObjetoVO).DataEncerramento := EditDataEncerramento.Date;
      TVendaRomaneioEntregaVO(ObjetoVO).Situacao := Copy(ComboBoxSituacao.Text, 1, 1);
      TVendaRomaneioEntregaVO(ObjetoVO).Observacao := MemoObservacao.Text;

      if StatusTela = stEditando then
        TVendaRomaneioEntregaVO(ObjetoVO).Id := IdRegistroSelecionado;

      // Vendas vinculadas
      CDSVenda.DisableControls;
      CDSVenda.First;
      TVendaRomaneioEntregaVO(ObjetoVO).VendasVinculadas := '';
      while not CDSVenda.Eof do
      begin
        TVendaRomaneioEntregaVO(ObjetoVO).VendasVinculadas := TVendaRomaneioEntregaVO(ObjetoVO).VendasVinculadas + '|' + CDSVendaID.AsString;
        CDSVenda.Next;
      end;
      CDSVenda.EnableControls;

      if StatusTela = stInserindo then
        Result := TVendaRomaneioEntregaController(ObjetoController).Insere(TVendaRomaneioEntregaVO(ObjetoVO))
      else if StatusTela = stEditando then
      begin
        if TVendaRomaneioEntregaVO(ObjetoVO).ToJSONString <> TVendaRomaneioEntregaVO(ObjetoOldVO).ToJSONString then
        begin
          TVendaRomaneioEntregaVO(ObjetoVO).Id := IdRegistroSelecionado;
          Result := TVendaRomaneioEntregaController(ObjetoController).Altera(TVendaRomaneioEntregaVO(ObjetoVO), TVendaRomaneioEntregaVO(ObjetoOldVO));
        end
        else
          Application.MessageBox('Nenhum dado foi alterado.', 'Mensagem do Sistema', MB_OK + MB_ICONINFORMATION);
      end;
    except
      Result := False;
    end;
  end;
  DecimalSeparator := ',';
end;
{$ENDREGION}

{$REGION 'Campos Transientes'}
// Vendedor
procedure TFVendaRomaneioEntrega.EditIdEntregadorExit(Sender: TObject);
var
  Filtro: String;
begin
  if EditIdEntregador.Value <> 0 then
  begin
    try
      Filtro := 'ID = ' + EditIdEntregador.Text;
      EditIdEntregador.Clear;
      EditEntregador.Clear;
      if not PopulaCamposTransientes(Filtro, TColaboradorVO, TColaboradorController) then
        PopulaCamposTransientesLookup(TColaboradorVO, TColaboradorController);
      if CDSTransiente.RecordCount > 0 then
      begin
        EditIdEntregador.Text := CDSTransiente.FieldByName('ID').AsString;
        EditEntregador.Text := CDSTransiente.FieldByName('PESSOA.NOME').AsString;
      end
      else
      begin
        Exit;
        EditIdEntregador.SetFocus;
      end;
    finally
      CDSTransiente.Close;
    end;
  end
  else
  begin
    EditEntregador.Clear;
  end;
end;

procedure TFVendaRomaneioEntrega.EditIdEntregadorKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_F1 then
  begin
    EditIdEntregador.Value := -1;
    EditDescricao.SetFocus;
  end;
end;

procedure TFVendaRomaneioEntrega.EditIdEntregadorKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    EditDescricao.SetFocus;
  end;
end;
{$ENDREGION}

{$REGION 'Controle de Grid'}
procedure TFVendaRomaneioEntrega.GridParaEdits;
begin
  inherited;

  if not CDSGrid.IsEmpty then
  begin
    ObjetoVO := ObjetoController.VO<TVendaRomaneioEntregaVO>(IdRegistroSelecionado);
    if StatusTela = stEditando then
      ObjetoOldVO := ObjetoController.VO<TVendaRomaneioEntregaVO>(IdRegistroSelecionado);
  end;

  if Assigned(ObjetoVO) then
  begin
    EditIdEntregador.AsInteger := TVendaRomaneioEntregaVO(ObjetoVO).IdColaborador;
    EditEntregador.Text := TVendaRomaneioEntregaVO(ObjetoVO).ColaboradorPessoaNome;
    EditDescricao.Text := TVendaRomaneioEntregaVO(ObjetoVO).Descricao;
    EditDataEmissao.Date := TVendaRomaneioEntregaVO(ObjetoVO).DataEmissao;
    EditDataPrevista.Date := TVendaRomaneioEntregaVO(ObjetoVO).DataPrevista;
    EditDataSaida.Date := TVendaRomaneioEntregaVO(ObjetoVO).DataSaida;
    EditDataEncerramento.Date := TVendaRomaneioEntregaVO(ObjetoVO).DataEncerramento;
    ComboBoxSituacao.ItemIndex := AnsiIndexStr(TVendaRomaneioEntregaVO(ObjetoVO).Situacao, ['A', 'T', 'E']);
    MemoObservacao.Text := TVendaRomaneioEntregaVO(ObjetoVO).Observacao;

    // Vendas Vinculadas
    TVendaCabecalhoController.SetDataSet(CDSVenda);
    TVendaCabecalhoController.Consulta('ID_VENDA_ROMANEIO_ENTREGA=' + CDSGrid.FieldByName('ID').AsString, 0);
  end;
end;

procedure TFVendaRomaneioEntrega.GridParcelasKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  Filtro: String;
begin
  if Key = VK_F1 then
  begin
    ActionAdicionarVenda.Execute;
  end;
  If Key = VK_RETURN then
    EditIdEntregador.SetFocus;
end;
{$ENDREGION}

{$REGION 'Actions'}
procedure TFVendaRomaneioEntrega.ActionAdicionarVendaExecute(Sender: TObject);
begin
  try
    PopulaCamposTransientesLookup(TVendaCabecalhoVO, TVendaCabecalhoController);
    if CDSTransiente.RecordCount > 0 then
    begin
      CDSVenda.Append;
      CDSVendaID.AsInteger := CDSTransiente.FieldByName('ID').AsInteger;
      CDSVendaDATA_VENDA.Value := CDSTransiente.FieldByName('DATA_VENDA').Value;
      CDSVendaCLIENTENOME.AsString := CDSTransiente.FieldByName('CLIENTE.NOME').AsString;
      CDSVendaVALOR_TOTAL.AsExtended := CDSTransiente.FieldByName('VALOR_TOTAL').AsExtended;
      CDSVenda.Post;
    end;
  finally
    CDSTransiente.Close;
  end;
end;

procedure TFVendaRomaneioEntrega.ActionRemoverVendaExecute(Sender: TObject);
begin
  TVendaRomaneioEntregaController.ExcluiVendaVinculada(CDSVenda.FieldByName('ID').AsInteger);
  TVendaCabecalhoController.SetDataSet(CDSVenda);
  TVendaCabecalhoController.Consulta('ID_VENDA_ROMANEIO_ENTREGA=' + CDSGrid.FieldByName('ID').AsString, 0);
end;

{$ENDREGION}

end.
