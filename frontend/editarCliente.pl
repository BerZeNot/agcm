/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(boot5rest)).


/* Pagina para edicao (alteracao) de um cliente  */
editar_cliente(AtomCPF, _Pedido):-
    atom_number(AtomCPF, CPF),
    ( cliente:cliente(CPF, Nome, Endereco, Telefone, Bairro, Identidade, Complemento,
			Compras, NumVendedor, Credito, ValorCredito)
    ->
    reply_html_page(
        boot5rest,
        [ title('Cliente')],
        [ div(class(container),
              [ 
                \html_requires(css('estiloGeral.css')),
                \html_requires(js('agcm.js')),
                h1('Editar cliente'),
                \form_cliente(CPF, Nome, Endereco, Telefone, Bairro, Identidade,
                              Complemento, Compras, NumVendedor, Credito, ValorCredito)
              ]) ])
    ; throw(http_reply(not_found(CPF)))
    ).


form_cliente(CPF, Nome, Endereco, Telefone, Bairro, Identidade,
             Complemento, Compras, NumVendedor, Credito, ValorCredito) -->
    html(form([ id('cliente-form'),
                onsubmit("redirecionaResposta( event, '/cliente' )"),
                action('/api/v1/cliente/~w' - CPF) ],
              [ \metodo_de_envio('PUT'),
                \campo_nao_editavel_cliente(cpf, 'CPF', number, CPF),
                \campo_cliente(nome, 'Nome', text, Nome),
                \campo_cliente(endereco, 'Endereco', text, Endereco),
                \campo_cliente(telefone, 'Telefone', number, Telefone),
                \campo_cliente(bairro, 'Bairro', text, Bairro),
                \campo_cliente(identidade, 'Identidade', text, Identidade),
                \campo_cliente(complemento, 'Complemento', text, Complemento),
                \campo_cliente(compras, 'Compras', text, Compras),
                \campo_cliente(numvendedor, 'Numero do Vendedor', number, NumVendedor),
                \campo_cliente(credito, 'Credito', text, Credito),
                \campo_cliente(valorcredito, 'Valor do Credito', float, ValorCredito),
                \confirmar_ou_cancelar_cliente('/cliente')
              ])).


confirmar_ou_cancelar_cliente(RotaDeRetorno) -->
    html(div([ class('btn-group'), role(group), 'aria-label'('Confirmar ou cancelar')],
             [ button([ type(submit),
                        class('btn btn-outline-primary')], 'Confirmar'),
               a([ href(RotaDeRetorno),
                   class('ms-3 btn btn-outline-danger')], 'Cancelar')
            ])).


campo_cliente(Nome, Rotulo, Tipo, Valor) -->
    html(div(class('mb-3'),
             [ label([ for(Nome), class('form-label')], Rotulo),
               input([ type(Tipo), class('form-control'),
                       id(Nome), name(Nome), value(Valor)])
             ] )).


campo_nao_editavel_cliente(Nome, Rotulo, Tipo, Valor) -->
    html(div(class('mb-3 w-25'),
             [ label([ for(Nome), class('form-label')], Rotulo),
               input([ type(Tipo), class('form-control'),
                       id(Nome),
                       % name(Nome),%  nao eh para enviar o CPF
                       value(Valor),
                       readonly ])
             ] )).


%% metodo_de_envio(Metodo) -->
%%     html(input([type(hidden), name('_metodo'), value(Metodo)])).