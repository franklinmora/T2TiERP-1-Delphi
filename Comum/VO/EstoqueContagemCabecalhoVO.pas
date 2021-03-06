{*******************************************************************************
Title: T2Ti ERP                                                                 
Description:  VO  relacionado � tabela [ESTOQUE_CONTAGEM_CABECALHO] 
                                                                                
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
                                                                                
@author Albert Eije (t2ti.com@gmail.com)                    
@version 1.0                                                                    
*******************************************************************************}
unit EstoqueContagemCabecalhoVO;

interface

uses
  JsonVO, Atributos, Classes, Constantes, Generics.Collections, DBXJSON, DBXJSONReflect,
  SysUtils, EstoqueContagemDetalheVO;

type
  [TEntity]
  [TTable('ESTOQUE_CONTAGEM_CABECALHO')]
  TEstoqueContagemCabecalhoVO = class(TJsonVO)
  private
    FID: Integer;
    FID_EMPRESA: Integer;
    FDATA_CONTAGEM: TDateTime;
    FESTOQUE_ATUALIZADO: String;

    FListaEstoqueContagemDetalheVO: TObjectList<TEstoqueContagemDetalheVO>;

  public 
    constructor Create; overload; override;
    constructor Create(pJsonValue: TJSONValue); overload; override;
    destructor Destroy; override;
    function ToJSON: TJSONValue; override;

    [TId('ID')]
    [TGeneratedValue(sAuto)]
    [TFormatter(ftZerosAEsquerda, taCenter)]
    property Id: Integer  read FID write FID;
    [TColumn('ID_EMPRESA','Id Empresa',80,[], False)]
    [TFormatter(ftZerosAEsquerda, taCenter)]
    property IdEmpresa: Integer  read FID_EMPRESA write FID_EMPRESA;
    [TColumn('DATA_CONTAGEM','Data Contagem',80,[ldGrid, ldLookup, ldCombobox], False)]
    property DataContagem: TDateTime  read FDATA_CONTAGEM write FDATA_CONTAGEM;
    [TColumn('ESTOQUE_ATUALIZADO','Estoque Atualizado',8,[ldGrid, ldLookup, ldCombobox], False)]
    property EstoqueAtualizado: String  read FESTOQUE_ATUALIZADO write FESTOQUE_ATUALIZADO;

    [TManyValuedAssociation(True,'ID_ESTOQUE_CONTAGEM_CABECALHO','ID')]
    property ListaEstoqueContagemDetalheVO: TObjectList<TEstoqueContagemDetalheVO> read FListaEstoqueContagemDetalheVO write FListaEstoqueContagemDetalheVO;
  end;

implementation

constructor TEstoqueContagemCabecalhoVO.Create;
begin
  inherited;
  ListaEstoqueContagemDetalheVO := TObjectList<TEstoqueContagemDetalheVO>.Create;
end;

constructor TEstoqueContagemCabecalhoVO.Create(pJsonValue: TJSONValue);
var
  Deserializa: TJSONUnMarshal;
begin
  if pJsonValue is TJSONNull then
    Exception.Create('Erro ao criar objeto com um valor nulo.');

  Deserializa := TJSONUnMarshal.Create;
  try
    Self.Free;

    //Lista detalhe
    Deserializa.RegisterReverter(TEstoqueContagemCabecalhoVO, 'FListaEstoqueContagemDetalheVO', procedure(Data: TObject; Field: String; Args: TListOfObjects)
    var
      Obj: TObject;
    begin
      if not Assigned(TEstoqueContagemCabecalhoVO(Data).FListaEstoqueContagemDetalheVO) then
        TEstoqueContagemCabecalhoVO(Data).FListaEstoqueContagemDetalheVO := TObjectList<TEstoqueContagemDetalheVO>.Create;

      for Obj in Args do
      begin
        TEstoqueContagemCabecalhoVO(Data).FListaEstoqueContagemDetalheVO.Add(TEstoqueContagemDetalheVO(Obj));
      end
    end);

    Self := Deserializa.Unmarshal(pJsonValue) as TEstoqueContagemCabecalhoVO;
  finally
    Deserializa.Free;
  end;
end;

destructor TEstoqueContagemCabecalhoVO.Destroy;
begin
  ListaEstoqueContagemDetalheVO.Free;

  inherited;
end;

function TEstoqueContagemCabecalhoVO.ToJSON: TJSONValue;
var
  Serializa: TJSONMarshal;
begin
  Serializa := TJSONMarshal.Create(TJSONConverter.Create);
  try
    //Lista detalhe
    Serializa.RegisterConverter(TEstoqueContagemCabecalhoVO, 'FListaEstoqueContagemDetalheVO', function(Data: TObject; Field: string): TListOfObjects
      var
        I: Integer;
      begin
        if Assigned(TEstoqueContagemCabecalhoVO(Data).FListaEstoqueContagemDetalheVO) then
        begin
          SetLength(Result, TEstoqueContagemCabecalhoVO(Data).FListaEstoqueContagemDetalheVO.Count);
          for I := 0 to TEstoqueContagemCabecalhoVO(Data).FListaEstoqueContagemDetalheVO.Count - 1 do
          begin
            Result[I] := TEstoqueContagemCabecalhoVO(Data).FListaEstoqueContagemDetalheVO.Items[I];
          end;
        end;
      end);

  Exit(serializa.Marshal(Self));
  finally
    Serializa.Free;
  end;
end;


end.
