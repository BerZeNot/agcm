/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(boot5rest)).


/* Pagina de cadastro de cliente */
cadastroCliente(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Cliente')],
        [ div(class(container),
              [ \html_requires(js('agcm.js')),
                h1('Cadastrar cliente'),
                \form_cliente
              ]) ]).


form_cliente -->
    html(form([ id('cliente-form'),
                onsubmit("redirecionaResposta( event, '/cliente' )"),
                action('/api/v1/cliente/') ],
              [ \metodo_de_envio('POST'),
                \campo_cad_cliente(cpf, 'CPF', number),
                \campo_cad_cliente(nome, 'Nome', text),
                \campo_cad_cliente(endereco, 'Endereco', text),
                \campo_cad_cliente(telefone, 'Telefone', number),
                \campo_cad_cliente(bairro, 'Bairro', text),
                \campo_cad_cliente(identidade, 'Identidade', text),
                \campo_cad_cliente(complemento, 'Complemento', text),
                \campo_cad_cliente(compras, 'Compras', text),
                \campo_cad_cliente(numvendedor, 'Numero do Vendedor', number),
                \campo_cad_cliente(credito, 'Credito', text),
                \campo_cad_cliente(valorcredito, 'Valor do Credito', float),
                \cadastrar_ou_cancelar_cliente('/cliente')
              ])).


cadastrar_ou_cancelar_cliente(RotaDeRetorno) -->
    html(div([ class('btn-group'), role(group), 'aria-label'('Cadastrar ou cancelar')],
             [ button([ type(submit),
                        class('btn btn-outline-primary')], 'Cadastrar'),
               a([ href(RotaDeRetorno),
                   class('ms-3 btn btn-outline-danger')], 'Cancelar')
            ])).


campo_cad_cliente(Nome, Rotulo, Tipo) -->
    html(div(class('mb-3'),
             [ label([ for(Nome), class('form-label') ], Rotulo),
               input([ type(Tipo), class('form-control'),
                       id(Nome), name(Nome)])
             ] )).


%% metodo_de_envio(Metodo) -->
%%     html(input([type(hidden), name('_metodo'), value(Metodo)])).