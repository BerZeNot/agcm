/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(boot5rest)).


/* Pagina de cadastro de itemvenda */
cadastroItemVenda(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('ItemVenda')],
        [ div(class(container),
              [ 
                \html_requires(css('estiloGeral.css')),
                \html_requires(js('agcm.js')),
                h1('Cadastrar item de venda'),
                \form_itemvenda
              ]) ]).


form_itemvenda -->
    html(form([ id('itemvenda-form'),
                onsubmit("redirecionaResposta( event, '/itemvenda' )"),
                action('/api/v1/itemvenda/') ],
              [ \metodo_de_envio('POST'),
                \campo_cad_itemvenda(iditemvenda, 'Id - ItemVenda', number),
                \campo_cad_itemvenda(idvenda, 'Id - Venda', number),
                \campo_cad_itemvenda(qtde, 'Quantidade', number),
                \campo_cad_itemvenda(valor, 'Valor', float),
                \cadastrar_ou_cancelar_itemvenda('/itemvenda')
              ])).


cadastrar_ou_cancelar_itemvenda(RotaDeRetorno) -->
    html(div([ class('btn-group'), role(group), 'aria-label'('Cadastrar ou cancelar')],
             [ button([ type(submit),
                        class('btn btn-outline-primary')], 'Cadastrar'),
               a([ href(RotaDeRetorno),
                   class('ms-3 btn btn-outline-danger')], 'Cancelar')
            ])).


campo_cad_itemvenda(Nome, Rotulo, Tipo) -->
    html(div(class('mb-3'),
             [ label([ for(Nome), class('form-label') ], Rotulo),
               input([ type(Tipo), class('form-control'),
                       id(Nome), name(Nome)])
             ] )).


%% metodo_de_envio(Metodo) -->
%%     html(input([type(hidden), name('_metodo'), value(Metodo)])).
