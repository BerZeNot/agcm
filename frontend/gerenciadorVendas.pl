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
                a(href('/'),img(src('/img/house.svg'))),
				\html_requires(css('estiloGeral.css')),
				\html_requires(js('agcm.js')),
				form([onsubmit("'redirecionaResposta( event, '/gerenciadorVendas' )'"), action('/')],
				   [
						\cabecalhoVenda,
						\pessoasVenda,
						\formaPagamento,
						\itensVenda
				   ]
				)
			])
		]
	).


cabecalhoVenda -->
	html(
		div( id('cabecalhoVenda'),
			[ label( for('codVenda'),'Venda: '),
			  input( [type('number'), name('codVenda')])
			]
		)
	).

pessoasVenda -->
	html(
		div(
			id('pessoasVenda'),
			[ label(for('codVendedor'),'Vendedor'),
			  input([type('number'), name('codVendedor')]),
			  label(for('codCliente'),'Cliente: '),
			  input([type('number'), name('codCliente')])
			]

		)
	).

formaPagamento -->
	html(
		div(
			id('formaPagamento'),
			[
				p('Forma de pagamento: '),
				input([type('radio'), name('formaPagamento'), id('aVista'),value('1'), 'checked']),
				label([for('aVista')],'A vista'),

				input([type('radio'), name('formaPagamento'), id('aPrazo'),value('2')]),
				label([for('aPrazo')],'A prazo')
			]
		)
	).

itensVenda -->
	html(
		div(
			id('itensVenda'),
			[
				label( for('qtd'),'Qtde: '),
				input( [type('number'), name('itensVenda'), id('qtd')]),

				label( for('descricao'),'Descricao: '),
				input( [type('text'), name('itensVenda'), id('descricao'), readonly]),

				label( for('valorUnitario'),'Valor Un: '),
				input( [type('number'), name('itensVenda'), id('valorUnitario'), readonly]),

				label( for('valorTotal'),'Valor Total: '),
				input( [type('number'), name('itensVenda'), id('valorTotal'), readonly]),

				label( for('total'),'Total: '),
				input( [type('number'), name('itensVenda'), id('total'), readonly])

			]

		)
	).
