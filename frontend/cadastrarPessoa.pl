/* html//1, reply_html_page */
:- use_module(library(http/html_write)).
/* html_requires*/
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(boot5rest)).

/* Página de cadastro de produto */

cadastroPessoa(_Pedido):-
	reply_html_page(
		boot5rest,
		[ title('Cadastrar Pessoa')],
		[ div(class(container),
			[\html_requires(js('agcm.js')),
			h1('Cadastro de Pessoa'),
			\form_pessoa
			]) ]).

form_pessoa -->
	html(form([ id('pessoa-form'),
				onsubmit("redirecionaResposta(event, '/pessoas' )"),
				action('/api/v1/pessoas/') ],
			  [ \metodo_de_envio('POST'),
			  	\campo_cad_pessoa(nome, 'Nome', text),
			  	\campo_cad_pessoa(endereco, 'Endereco', text),
			  	\campo_cad_pessoa(telefone, 'Telefone', number),
			  	\campo_cad_pessoa(bairro, 'Bairro', text),
			  	\campo_cad_pessoa(cpf, 'CPF', number),
			  	\campo_cad_pessoa(identidade, 'Identidade', text),
			  	\campo_cad_pessoa(complemento, 'Complemento', text),
			  	\cadastrar_ou_cancelar_pessoa('/pessoas')
			])).

cadastrar_ou_cancelar_pessoa(RotaDeRetorno) -->
	html(div([ class('btn-group'), role(group), 'aria-label'('Cadastrar ou cancelar')],
			 [ button([ type(submit),
			 			class('btn btn-outline-primary')], 'Cadastrar'),
			 	a([ href(RotaDeRetorno),
			 		class('ms-3 btn btn-outline-danger')], 'Cancelar')
			 ])).

campo_cad_pessoa(Nome, Rotulo, Tipo) -->
	html(div(class('mb-3'),
			[ label([ for(Nome), class('form-label') ], Rotulo),
			  input([ type(Tipo), class('form-control'),
			  		  id(Nome), name(Nome)])
		    ])).