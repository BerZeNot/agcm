/* html//1, reply_html_pages */
:- use_module(library(http/html_write)).
/* html_requires */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(boot5rest)).

:- ensure_loaded(frontend(multiPagina)).


gerenciadorVendas(_):-
	reply_html_page(
		boot5rest,
		[ title('Gerenciador de Vendas')],
		[ div(class('container'),
			[
				\html_requires(css('estiloGeral.css')),
				\html_requires(css('gerenciadorVendas.css')),
				\html_requires(js('agcm.js')),
				form([onsubmit("'redirecionaResposta( event, '/gerenciadorVendas' )'"), action('/')],
				   [
						\cabecalhoVenda,
						\pessoasVenda,
						\formaPagamento,
						\itensVenda,
						\itensVenda,
						\itensVenda,
						\itensVenda,
						\itensVenda,
						\total,
						\cadastrar_ou_cancelar_venda('/')
				   ]
				)
			])
		]
	).


cabecalhoVenda -->
	html(
		div( id('cabecalhoVenda'),

			[
				div(id('boxLinkHome'),
					[a([id('linkHome'),href('/')],img(src('/img/house.svg')))]),
				div(id('boxCodVenda'),
					[
						label( [id('codVenda'),for('codVenda')],'Venda:'),
			  			input( [type('number'), id('codVenda'),name('codVenda'), class('form-control'), readonly])
					])
				
				
			]
		)
	).

pessoasVenda -->
	html(
		div(
			id('pessoasVenda'),
			[ label(for('codVendedor'),'Vendedor:'),
			  input([type('number'), id('codVendedor'), name('codVendedor'), class('form-row')]),
			  label(for('codCliente'),'Cliente: '),
			  input([type('number'), id('codCliente'), name('codCliente'), class('form-row')])
			]

		)
	).

formaPagamento -->
	html(
		div(
			[id('formaPagamento'),class('form-group')],
			[
				p('Forma de pagamento: '),
				input([type('radio'), name('formaPagamento'), id('aVista'),value('1'), class('form-check-input'), 'checked']),
				label([for('aVista')],'A vista'),

				input([type('radio'), name('formaPagamento'), id('aPrazo'),value('2'), class('form-check-input')]),
				label([for('aPrazo')],'A prazo')
			]
		)
	).

itensVenda -->
	html([
		div(
			id('itensVenda'),
			[
				label( for('qtd'),'Qtde:'),
				input( [type('number'), name('itensVenda'), id('qtd'), class('form-row')]),

				label( for('cod'),'Cod: '),
				input( [type('number'), name('itensVenda'), id('cod'), class('form-row')]),


				label( for('descricao'),'Descricao:'),
				input( [type('text'), name('itensVenda'), id('descricao'), class('form-row'), readonly]),

				label( for('valorUnitario'),'Valor Un:'),
				input( [type('number'), name('itensVenda'), id('valorUnitario'), class('form-row'), readonly]),

				label( for('valorTotal'),'Valor Total:'),
				input( [type('number'), name('itensVenda'), id('valorTotal'), class('form-row'), readonly])

			]

		)
		]
	).


total -->
	html(

		div(id(total),
			[	label( for('total'),'Total:'),
				input( [type('number'), name('itensVenda'), id('total'), class('form-row'), readonly])
			]
		)
	).

cadastrar_ou_cancelar_venda(RotaDeRetorno) -->
	html(div([ class('btn-group'), role(group), 'aria-label'('Cadastrar ou cancelar')],
			 	[ button([ type(submit),
			 			class('btn btn-primary')], 'Cadastrar'),
			 	a([ href(RotaDeRetorno),
			 		class('ms-3 btn btn-danger')], 'Cancelar')
		 	]
		)).