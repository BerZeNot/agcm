/* Página para ediçã (alteração) de um produto */

editar_pessoa(AtomCPF, _Pedido):-
	atom_number(AtomCPF, CPF),
	( pessoa:pessoa(Nome, Endereco, Telefone,Bairro, CPF, Identidade,Complemento)
	->
	reply_html_page(
		boot5rest,
		[ title('Pessoas')],
		[ div(class(container),
			  [ \html_requires(js('agcm.js')),
			    h1('Editar Pessoa'),
			    \form_pessoa(Nome, Endereco, Telefone,Bairro, CPF, Identidade,Complemento)
			    ]) ])
		; throw(http_reply(not_found))).


form_pessoa(Nome, Endereco, Telefone,Bairro, CPF, Identidade,Complemento) -->
	html(form([ id('pessoa-form'),
				onsubmit("redirecionaResposta( event, '/pessoas' )"),
				action('/api/v1/pessoas/~w' - CPF) ],
			  [ \metodo_de_envio('PUT'), %% informa o método de envio
			  	\campo_pessoa(nome, 'Nome', text, Nome),
			  	\campo_pessoa(endereco, 'Endereco', text, Endereco),
			  	\campo_pessoa(telefone, 'Telefone', number, Telefone),
			  	\campo_pessoa(bairro, 'Bairro', text, Bairro),
			  	\campo_pessoa_nao_editavel(cpf,'CPF',number, CPF),
			  	\campo_pessoa_nao_editavel(identidade,'Identidade',text, Identidade),
			  	\campo_pessoa(complemento, 'Complemento', text, Complemento),
			  	\confirmar_ou_cancelar_pessoa('/pessoas')
			  ])).


confirmar_ou_cancelar_pessoa(RotaDeRetorno) -->
	html(div([ class('btn-group'), role(group), 'aria-label'('Confirmar ou cancelar')],
			 [ button([ type(submit),
			 			class('btn btn-outline-primary')], 'Confirmar'),
			 	a([ href(RotaDeRetorno),
			 		class('ms-3 btn btn-outline-danger')], 'Cancelar')
			 ])).

campo_pessoa(Nome, Rotulo, Tipo, Valor) -->
	html(div(class('mb-3'),
			 [ label([ for(Nome), class('form-label')], Rotulo),
			   input([ type(Tipo), class('form-control'),
			   			id(Nome), name(Nome), value(Valor)])
			 ] )).

campo_pessoa_nao_editavel(Nome, Rotulo, Tipo, Valor) -->
	html(div(class('mb-3 w-25'),
		[ label([ for(Nome), class('form-label')], Rotulo),
		  input([ type(Tipo), class('form-control'),
		  		  id(Nome),
		  		  %name(Nome), % não é para enviar o id
		  		  value(Valor),
		  		  readonly ])
		] )).

%% metodo_de_envio(Método) -->
%% 	html(input([type(hidden), name('_método'), value(Método)])).
