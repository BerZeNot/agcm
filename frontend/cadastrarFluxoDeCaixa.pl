/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(boot5rest)).


/* Pagina de cadastro de fluxo de caixa */
cadastroFluxoDeCaixa(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Fluxo de Caixa')],
        [ div(class(container),
              [ \html_requires(js('agcm.js')),
                h1('Cadastrar fluxo de caixa'),
                \form_fluxodecaixa
              ]) ]).


form_fluxodecaixa -->
    html(form([ id('fluxodecaixa-form'),
                onsubmit("redirecionaResposta( event, '/fluxodecaixa' )"),
                action('/api/v1/fluxodecaixa/') ],
              [ \metodo_de_envio('POST'),
                \campo_cad_fluxodecaixa(numerotransacao, 'Numero da Transacao', number),
                \campo_cad_fluxodecaixa(valor, 'Valor', float),
                \cadastrar_ou_cancelar_fluxodecaixa('/fluxodecaixa')
              ])).


cadastrar_ou_cancelar_fluxodecaixa(RotaDeRetorno) -->
    html(div([ class('btn-group'), role(group), 'aria-label'('Cadastrar ou cancelar')],
             [ button([ type(submit),
                        class('btn btn-outline-primary')], 'Cadastrar'),
               a([ href(RotaDeRetorno),
                   class('ms-3 btn btn-outline-danger')], 'Cancelar')
            ])).


campo_cad_fluxodecaixa(Nome, Rotulo, Tipo) -->
    html(div(class('mb-3'),
             [ label([ for(Nome), class('form-label') ], Rotulo),
               input([ type(Tipo), class('form-control'),
                       id(Nome), name(Nome)])
             ] )).


%% metodo_de_envio(Metodo) -->
%%     html(input([type(hidden), name('_metodo'), value(Metodo)])).
