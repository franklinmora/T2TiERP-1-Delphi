{*******************************************************************************
Title: T2Ti ERP
Description: Janela Cadastro de TipoAdmissao

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
@version 1.0   |   Fernando  @version 1.0.0.10
*******************************************************************************}
unit UTipoAdmissao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UTelaCadastro, DB, DBClient, Menus, StdCtrls, ExtCtrls, Buttons, Grids,
  DBGrids, JvExDBGrids, JvDBGrid, JvDBUltimGrid, ComCtrls, TipoAdmissaoVO,
  TipoAdmissaoController, Tipos, Atributos, Constantes, LabeledCtrls;

type
  [TFormDescription(TConstantes.MODULO_CADASTROS,'Tipo Admissao')]
  TFTipoAdmissao = class(TFTelaCadastro)
    BevelEdits: TBevel;
    EditCodigo: TLabeledEdit;
    EditNome: TLabeledEdit;
    MemoDescricao: TLabeledMemo;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure GridParaEdits; override;

    //Controles CRUD
    function DoInserir: Boolean; override;
    function DoEditar: Boolean; override;
    function DoExcluir: Boolean; override;
    function DoSalvar: Boolean; override;
  end;

var
  FTipoAdmissao: TFTipoAdmissao;

implementation

{$R *.dfm}

{$REGION 'Infra'}
procedure TFTipoAdmissao.FormCreate(Sender: TObject);
begin
  ClasseObjetoGridVO := TTipoAdmissaoVO;
  ObjetoController := TTipoAdmissaoController.Create;

  inherited;
end;
{$ENDREGION}

{$REGION 'Controles CRUD'}
function TFTipoAdmissao.DoInserir: Boolean;
begin
  Result := inherited DoInserir;

  if Result then
  begin
    EditCodigo.SetFocus;
  end;
end;

function TFTipoAdmissao.DoEditar: Boolean;
begin
  Result := inherited DoEditar;

  if Result then
  begin
    EditCodigo.SetFocus;
  end;
end;

function TFTipoAdmissao.DoExcluir: Boolean;
begin
  if inherited DoExcluir then
  begin
    try
      Result := TTipoAdmissaoController(ObjetoController).Exclui(IdRegistroSelecionado);
    except
      Result := False;
    end;
  end
  else
  begin
    Result := False;
  end;

  if Result then
    TTipoAdmissaoController(ObjetoController).Consulta(Filtro, Pagina);
end;

function TFTipoAdmissao.DoSalvar: Boolean;
begin
  Result := inherited DoSalvar;

  if Result then
  begin
    try
      if not Assigned(ObjetoVO) then
        ObjetoVO := TTipoAdmissaoVO.Create;

      TTipoAdmissaoVO(ObjetoVO).Codigo    := EditCodigo.Text;
      TTipoAdmissaoVO(ObjetoVO).Nome      := EditNome.Text;
      TTipoAdmissaoVO(ObjetoVO).Descricao := MemoDescricao.Text;

      if StatusTela = stInserindo then
        Result := TTipoAdmissaoController(ObjetoController).Insere(TTipoAdmissaoVO(ObjetoVO))
      else if StatusTela = stEditando then
      begin
        if TTipoAdmissaoVO(ObjetoVO).ToJSONString <> TTipoAdmissaoVO(ObjetoOldVO).ToJSONString then
        begin
          TTipoAdmissaoVO(ObjetoVO).Id := IdRegistroSelecionado;
          Result := TTipoAdmissaoController(ObjetoController).Altera(TTipoAdmissaoVO(ObjetoVO), TTipoAdmissaoVO(ObjetoOldVO));
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
procedure TFTipoAdmissao.GridParaEdits;
begin
  inherited;

  if not CDSGrid.IsEmpty then
  begin
    ObjetoVO := ObjetoController.VO<TTipoAdmissaoVO>(IdRegistroSelecionado);
    if StatusTela = stEditando then
      ObjetoOldVO := ObjetoVO.Clone;
  end;

  if Assigned(ObjetoVO) then
  begin
    EditCodigo.Text    := TTipoAdmissaoVO(ObjetoVO).Codigo;
    EditNome.Text      := TTipoAdmissaoVO(ObjetoVO).Nome;
    MemoDescricao.Text := TTipoAdmissaoVO(ObjetoVO).Descricao;
  end;
end;
{$ENDREGION}

end.
