/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(boot5rest)).


/* Pagina para edicao (alteracao) de um itemvenda */
editar_itemvenda(AtomIdItemVenda, _Pedido):-
    atom_number(AtomIdItemVenda, IdItemVenda),
    ( itemvenda:itemvenda(IdItemVenda, IdVenda, Qtde, Valor)
    ->
    reply_html_page(
        boot5rest,
        [ title('ItemVenda')],
        [ div(class(container),
              [ 
                \html_requires(css('estiloGeral.css')),
                \html_requires(js('agcm.js')),
                h1('Editar itemvenda'),
                \form_itemvenda(IdItemVenda, IdVenda, Qtde, Valor)
              ]) ])
    ; throw(http_reply(not_found(IdItemVenda)))
    ).


form_itemvenda(IdItemVenda, IdVenda, Qtde, Valor) -->
    html(form([ id('itemvenda-form'),
                onsubmit("redirecionaResposta( event, '/itemvenda' )"),
                action('/api/v1/itemvenda/~w' - IdItemVenda) ],
              [ \metodo_de_envio('PUT'),
                \campo_nao_editavel_itemvenda(iditemvenda, 'Id - Item Venda', number, IdItemVenda),
                \campo_itemvenda(idvenda, 'Id - Venda', number, IdVenda),
                \campo_itemvenda(valor, 'Valor', float, Valor),
                \campo_itemvenda(qtde, 'Quantidade', number, Qtde),
                \confirmar_ou_cancelar_itemvenda('/itemvenda')
              ])).


confirmar_ou_cancelar_itemvenda(RotaDeRetorno) -->
    html(div([ class('btn-group'), role(group), 'aria-label'('Confirmar ou cancelar')],
             [ button([ type(submit),
                        class('btn btn-outline-primary')], 'Confirmar'),
               a([ href(RotaDeRetorno),
                   class('ms-3 btn btn-outline-danger')], 'Cancelar')
            ])).


campo_itemvenda(Nome, Rotulo, Tipo, Valor) -->
    html(div(class('mb-3'),
             [ label([ for(Nome), class('form-label')], Rotulo),
               input([ type(Tipo), class('form-control'),
                       id(Nome), name(Nome), value(Valor)])
             ] )).


campo_nao_editavel_itemvenda(Nome, Rotulo, Tipo, Valor) -->
    html(div(class('mb-3 w-25'),
             [ label([ for(Nome), class('form-label')], Rotulo),
               input([ type(Tipo), class('form-control'),
                       id(Nome),
                       value(Valor),
                       readonly ])
             ] )).


%% metodo_de_envio(Metodo) -->
%%     html(input([type(hidden), name('_metodo'), value(Metodo)])).
