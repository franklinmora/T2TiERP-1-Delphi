{ *******************************************************************************
  Title: T2Ti ERP
  Description: Janela Cadastro do Centro de Resultado

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

  @author Albert Eije
  @version 1.0
  ******************************************************************************* }
unit UCentroResultado;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UTelaCadastro, DB, DBClient, Menus, StdCtrls, ExtCtrls, Buttons, Grids,
  DBGrids, JvExDBGrids, JvDBGrid, JvDBUltimGrid, ComCtrls, CentroResultadoVO,
  CentroResultadoController, Tipos, Atributos, Constantes, LabeledCtrls,
  JvToolEdit, Mask, JvExMask, JvBaseEdits, StrUtils, Math;

type
  [TFormDescription(TConstantes.MODULO_FINANCEIRO, 'Centro Resultado')]

  TFCentroResultado = class(TFTelaCadastro)
    BevelEdits: TBevel;
    EditDescricao: TLabeledEdit;
    EditClassificacao: TLabeledEdit;
    EditIdPlanoCentroResultado: TLabeledCalcEdit;
    EditPlanoCentroResultado: TLabeledEdit;
    ComboBoxSofreRateio: TLabeledComboBox;
    procedure FormCreate(Sender: TObject);
    procedure EditIdPlanoCentroResultadoExit(Sender: TObject);
    procedure EditIdPlanoCentroResultadoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditIdPlanoCentroResultadoKeyPress(Sender: TObject;
      var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure GridParaEdits; override;

    // Controles CRUD
    function DoInserir: Boolean; override;
    function DoEditar: Boolean; override;
    function DoExcluir: Boolean; override;
    function DoSalvar: Boolean; override;
  end;

var
  FCentroResultado: TFCentroResultado;

implementation

uses ULookup, Biblioteca, UDataModule, PlanoCentroResultadoVO, PlanoCentroResultadoController;
{$R *.dfm}

{$REGION 'Infra'}
procedure TFCentroResultado.FormCreate(Sender: TObject);
begin
  ClasseObjetoGridVO := TCentroResultadoVO;
  ObjetoController := TCentroResultadoController.Create;

  inherited;
end;
{$ENDREGION}

{$REGION 'Controles CRUD'}
function TFCentroResultado.DoInserir: Boolean;
begin
  Result := inherited DoInserir;

  if Result then
  begin
    EditIdPlanoCentroResultado.SetFocus;
  end;
end;

function TFCentroResultado.DoEditar: Boolean;
begin
  Result := inherited DoEditar;

  if Result then
  begin
    EditIdPlanoCentroResultado.SetFocus;
  end;
end;

function TFCentroResultado.DoExcluir: Boolean;
begin
  if inherited DoExcluir then
  begin
    try
      Result := TCentroResultadoController(ObjetoController).Exclui(IdRegistroSelecionado);
    except
      Result := False;
    end;
  end
  else
  begin
    Result := False;
  end;

  if Result then
    TCentroResultadoController(ObjetoController).Consulta(Filtro, Pagina);
end;

function TFCentroResultado.DoSalvar: Boolean;
begin
  Result := inherited DoSalvar;

  if Result then
  begin
    try
      if not Assigned(ObjetoVO) then
        ObjetoVO := TCentroResultadoVO.Create;

      TCentroResultadoVO(ObjetoVO).IdPlanoCentroResultado := EditIdPlanoCentroResultado.AsInteger;
      TCentroResultadoVO(ObjetoVO).Descricao := EditDescricao.Text;
      TCentroResultadoVO(ObjetoVO).Classificacao := EditClassificacao.Text;
      TCentroResultadoVO(ObjetoVO).SofreRateiro := IfThen(ComboBoxSofreRateio.ItemIndex = 0, 'S', 'N');

      // ObjetoVO - libera objetos vinculados (TAssociation) - n�o tem necessidade de subir
      TCentroResultadoVO(ObjetoVO).PlanoCentroResultadoVO := Nil;
      if Assigned(ObjetoOldVO) then
        TCentroResultadoVO(ObjetoOldVO).PlanoCentroResultadoVO := Nil;

      if StatusTela = stInserindo then
        Result := TCentroResultadoController(ObjetoController).Insere(TCentroResultadoVO(ObjetoVO))
      else if StatusTela = stEditando then
      begin
        if TCentroResultadoVO(ObjetoVO).ToJSONString <> TCentroResultadoVO(ObjetoOldVO).ToJSONString then
        begin
          TCentroResultadoVO(ObjetoVO).Id := IdRegistroSelecionado;
          Result := TCentroResultadoController(ObjetoController).Altera(TCentroResultadoVO(ObjetoVO), TCentroResultadoVO(ObjetoOldVO));
        end
        else
          Application.MessageBox('Nenhum dado foi alterado.', 'Mensagem do Sistema', MB_OK + MB_ICONINFORMATION);
      end;
    except
      Result := False;
    end;
  end;
end;
{$ENDREGION}

{$REGION 'Controle de Grid'}
procedure TFCentroResultado.GridParaEdits;
begin
  inherited;

  if not CDSGrid.IsEmpty then
  begin
    ObjetoVO := ObjetoController.VO<TCentroResultadoVO>(IdRegistroSelecionado);
    if StatusTela = stEditando then
      ObjetoOldVO := ObjetoController.VO<TCentroResultadoVO>(IdRegistroSelecionado);
  end;

  if Assigned(ObjetoVO) then
  begin
    EditIdPlanoCentroResultado.AsInteger := TCentroResultadoVO(ObjetoVO).IdPlanoCentroResultado;
    EditPlanoCentroResultado.Text := TCentroResultadoVO(ObjetoVO).PlanoCentroResultadoNome;
    EditDescricao.Text := TCentroResultadoVO(ObjetoVO).Descricao;
    EditClassificacao.Text := TCentroResultadoVO(ObjetoVO).Classificacao;
    ComboBoxSofreRateio.ItemIndex := IfThen(TCentroResultadoVO(ObjetoVO).SofreRateiro = 'S', 0, 1);
  end;
end;
{$ENDREGION}

{$REGION 'Campos Transientes'}
procedure TFCentroResultado.EditIdPlanoCentroResultadoExit(Sender: TObject);
var
  Filtro: String;
begin
  if EditIdPlanoCentroResultado.Value <> 0 then
  begin
    try
      Filtro := 'ID = ' + EditIdPlanoCentroResultado.Text;
      EditIdPlanoCentroResultado.Clear;
      EditPlanoCentroResultado.Clear;
      if not PopulaCamposTransientes(Filtro, TPlanoCentroResultadoVO, TPlanoCentroResultadoController) then
        PopulaCamposTransientesLookup(TPlanoCentroResultadoVO, TPlanoCentroResultadoController);
      if CDSTransiente.RecordCount > 0 then
      begin
        EditIdPlanoCentroResultado.Text := CDSTransiente.FieldByName('ID').AsString;
        EditPlanoCentroResultado.Text := CDSTransiente.FieldByName('NOME').AsString + ' [' + CDSTransiente.FieldByName('MASCARA').AsString + ']';
      end
      else
      begin
        Exit;
        EditIdPlanoCentroResultado.SetFocus;
      end;
    finally
      CDSTransiente.Close;
    end;
  end
  else
  begin
    EditPlanoCentroResultado.Clear;
  end;
end;

procedure TFCentroResultado.EditIdPlanoCentroResultadoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_F1 then
  begin
    EditIdPlanoCentroResultado.Value := -1;
    EditDescricao.SetFocus;
  end;
end;

procedure TFCentroResultado.EditIdPlanoCentroResultadoKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    EditDescricao.SetFocus;
  end;
end;
{$ENDREGION}

end.
