/* Página para ediçã (alteração) de um produto */

editar_produto(AtomId, _Pedido):-
	atom_number(AtomId, Id),
	( produto:produto(Id, Nome, QtdAtual, QtdMinima, Preco1, Descricao, Preco2)
	->
	reply_html_page(
		boot5rest,
		[ title('Produtos')],
		[ div(class(container),
			  [ 
			  	\html_requires(css('estiloGeral.css')),
			  	\html_requires(js('agcm.js')),
			    h1('Editar Produto'),
			    \form_produto(Id, Nome, QtdAtual, QtdMinima, Preco1, Descricao, Preco2)
			    ]) ])
		; throw(http_reply(not_found))).


form_produto(Id, Nome, QtdAtual, QtdMinima, Preco1, Descricao, Preco2) -->
	html(form([ id('produto-form'),
				onsubmit("redirecionaResposta( event, '/produtos' )"),
				action('/api/v1/produtos/~w' - Id) ],
			  [ \metodo_de_envio('PUT'), %% informa o metodo de envio
			  	\campo_nao_editavel_produto(id,'Id',text, Id),
			  	\campo_produto(nome, 'Nome', text, Nome),
			  	\campo_produto(qtdeAtual, 'Quantidade Atual', number, QtdAtual),
			  	\campo_produto(qtdMinima, 'Quantidade Minima', number, QtdMinima),
			  	\campo_produto(preco1, 'Preço 1', float, Preco1),
			  	\campo_produto(descricao, 'Descricao', text, Descricao),
			  	\campo_produto(preco2, 'Preço 2', float, Preco2),
			  	\confirmar_ou_cancelar_produto('/produtos')
			  ])).


confirmar_ou_cancelar_produto(RotaDeRetorno) -->
	html(div([ class('btn-group'), role(group), 'aria-label'('Confirmar ou cancelar')],
			 [ button([ type(submit),
			 			class('btn btn-outline-primary')], 'Confirmar'),
			 	a([ href(RotaDeRetorno),
			 		class('ms-3 btn btn-outline-danger')], 'Cancelar')
			 ])).

campo_produto(Nome, Rotulo, Tipo, Valor) -->
	html(div(class('mb-3'),
			 [ label([ for(Nome), class('form-label')], Rotulo),
			   input([ type(Tipo), class('form-control'),
			   			id(Nome), name(Nome), value(Valor)])
			 ] )).

campo_nao_editavel_produto(Nome, Rotulo, Tipo, Valor) -->
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
