/* html//1, reply_html_page */
:- use_module(library(http/html_write)).
/* html_requires*/
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(boot5rest)).

/* Página de cadastro de produto */

cadastroProduto(_Pedido):-
	reply_html_page(
		boot5rest,
		[ title('Cadastrar Produto')],
		[ div(class(container),
			[
				\html_requires(css('estiloGeral.css')),
				\html_requires(js('agcm.js')),
				h1('Cadastro de Produto'),
				\form_produto
			]) ]).

form_produto -->
	html(form([ id('produto-form'),
				onsubmit("redirecionaResposta(event, '/produtos' )"),
				action('/api/v1/produtos/') ],
			  [ \metodo_de_envio('POST'),
			  	\campo_cad_produto(nome, 'Nome', text),
			  	\campo_cad_produto(qtdeAtual, 'Quantidade Atual', number),
			  	\campo_cad_produto(qtdMinima, 'Quantidade Minima', number),
			  	\campo_cad_produto(preco1, 'Preco 1', float),
			  	\campo_cad_produto(descricao, 'Descricao', text),
			  	\campo_cad_produto(preco2, 'Preco 2', float),
			  	\cadastrar_ou_cancelar_produto('/produtos')
			])).

cadastrar_ou_cancelar_produto(RotaDeRetorno) -->
	html(div([ class('btn-group'), role(group), 'aria-label'('Cadastrar ou cancelar')],
			 [ button([ type(submit),
			 			class('btn btn-outline-primary')], 'Cadastrar'),
			 	a([ href(RotaDeRetorno),
			 		class('ms-3 btn btn-outline-danger')], 'Cancelar')
			 ])).

campo_cad_produto(Nome, Rotulo, Tipo) -->
	html(div(class('mb-3'),
			[ label([ for(Nome), class('form-label') ], Rotulo),
			  input([ type(Tipo), class('form-control'),
			  		  id(Nome), name(Nome)])
		    ])).

%% Método já definido na página de editar produtos
%% metodo_de_envio(Método) -->
%% 	html(input([type(hidden), name('_método'), value(Método)])).