:- module(vendas,[
	cadastraNovaVenda/5,
	atualizaVenda/5,
	cancelaVenda/1
]).
:- use_module(library(persistency)).
:- use_module(fluxodecaixa).
:- use_module(funcionarios).
:- use_module(chave, []).


:- persistent
   vendas(
          idVenda:positive_integer,
          idVendedor:positive_integer,
          idTransacaoFluxoCaixa:positive_integer,
		  datahora:string,
		  formaPagamento:positive_integer
		  ).
:- initialization(at_halt(db_sync(gc(always)))).

carrega_tab(ArqTabela):- db_attach(ArqTabela, []).

cadastraNovaVenda(IdVenda, IdVendedor, IdTransacaoFluxoCaixa, DataHoraAtual, FormaPagamento):-
       funcionarios:funcionarios(IdVendedor,
								 _Nome,
								 _Endereco,
								 _Telefone,
								 _Bairro,
								 _Cpf,
							     _Identidade,
								 _Complemento,
								 _NumeroFuncionario,
								 _Admissao,
								 _CarteiraTrabalho,
				                 _Ferias,
				                 _Horario),
	   fluxodecaixa:fluxodecaixa(IdTransacaoFluxoCaixa, _NumeroTransacao, _Valor),
	   chave:pk(vendas, IdVenda),
       with_mutex(vendas,
	   assert_vendas(IdVenda,IdVendedor,IdTransacaoFluxoCaixa,DataHoraAtual,FormaPagamento)).
	   
atualizaVenda(IdVenda, IdVendedor, IdTransacaoFluxoCaixa, DataHoraAtual, FormaPagamento):-
       vendas:vendas(IdVenda,_IdVendedor,_IdTransacaoFluxoCaixa,_DataHoraAtual,_FormaPagamento),
	   with_mutex(
	        vendas,
			attVenda(IdVenda,IdVendedor,IdTransacaoFluxoCaixa,DataHoraAtual,FormaPagamento)
	        % retractall_vendas(IdVenda, _, _, _, _),
			% assert_vendas(IdVenda,IdVendedor,IdTransacaoFluxoCaixa,DataHoraAtual,FormaPagamento)
	   ).
	   
attVenda(IdVenda,IdVendedor,IdTransacaoFluxoCaixa,DataHoraAtual,FormaPagamento):-
	vendas:retractall_vendas(IdVenda, _, _, _, _),
	vendas:assert_vendas(IdVenda,IdVendedor,IdTransacaoFluxoCaixa,DataHoraAtual,FormaPagamento).
	   
cancelaVenda(IdVenda):-
		with_mutex(vendas,
			retract_vendas(IdVenda,_NumeroVendedor,_NumeroTransacaoFluxoCaixa,_DataHora,_FormaPagamento)).

