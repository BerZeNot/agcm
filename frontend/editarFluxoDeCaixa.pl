/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(boot5rest)).


/* Pagina para edicao de um fluxodecaixa  */
editar_fluxodecaixa(AtomId, _Pedido):-
    atom_number(AtomId, Id),
    ( fluxodecaixa:fluxodecaixa(Id, NumeroTransacao, Valor)
    ->
    reply_html_page(
        boot5rest,
        [ title('Fluxo de Caixa')],
        [ div(class(container),
              [ 
                \html_requires(css('estiloGeral.css')),
                \html_requires(js('agcm.js')),
                h1('Editar fluxo de caixa'),
                \form_fluxodecaixa(Id, NumeroTransacao, Valor)
              ]) ])
    ; throw(http_reply(not_found(Id)))
    ).


form_fluxodecaixa(Id, NumeroTransacao, Valor) -->
    html(form([ id('fluxodecaixa-form'),
                onsubmit("redirecionaResposta( event, '/fluxodecaixa' )"),
                action('/api/v1/fluxodecaixa/~w' - Id) ],
              [ \metodo_de_envio('PUT'),
                \campo_nao_editavel_fluxodecaixa(id, 'Id', number, Id),
                \campo_fluxodecaixa(numerotransacao, 'Numero da Transacao', number, NumeroTransacao),
                \campo_fluxodecaixa(valor, 'Valor', number, Valor),
                \confirmar_ou_cancelar_fluxodecaixa('/fluxodecaixa')
              ])).


confirmar_ou_cancelar_fluxodecaixa(RotaDeRetorno) -->
    html(div([ class('btn-group'), role(group), 'aria-label'('Confirmar ou cancelar')],
             [ button([ type(submit),
                        class('btn btn-outline-primary')], 'Confirmar'),
               a([ href(RotaDeRetorno),
                   class('ms-3 btn btn-outline-danger')], 'Cancelar')
            ])).


campo_fluxodecaixa(Nome, Rotulo, Tipo, Valor) -->
    html(div(class('mb-3'),
             [ label([ for(Nome), class('form-label')], Rotulo),
               input([ type(Tipo), class('form-control'),
                       id(Nome), name(Nome), value(Valor)])
             ] )).


campo_nao_editavel_fluxodecaixa(Nome, Rotulo, Tipo, Valor) -->
    html(div(class('mb-3 w-25'),
             [ label([ for(Nome), class('form-label')], Rotulo),
               input([ type(Tipo), class('form-control'),
                       id(Nome),
                       % name(Nome),%  nao eh para enviar o Id
                       value(Valor),
                       readonly ])
             ] )).


%% metodo_de_envio(Metodo) -->
%%     html(input([type(hidden), name('_metodo'), value(Metodo)])).