% html_requires
:- use_module(library(http/html_head)).

% html, html_post, html_root_attribute
:- use_module(library(http/html_write)).

:- multifile
        user:body//2.

%% <link rel="icon" type="image/png" sizes="32x32" href="/favicon-32x32.png">


user:body(boot5rest, Corpo) -->
       html(body([ \html_post(head,
                              [ meta([name(viewport),
                                      content([ 'width=device-width',
                                                'initial-scale=1',
                                                'shrink-to-fit=no'
                                              ])]), meta(charset('utf-8')),
                                link([rel('icon'),type('image/icon'), sizes('48x48'), href('favicon.ico')])],
                   \html_root_attribute(lang,'pt-br'),
                   \html_requires(css('bootstrap.min.css')),
                   \html_requires(js('rest.js')),

                   Corpo,

                   script([ src('/js/bootstrap.bundle.min.js'),
                            type('text/javascript')], [])
                 ])).
