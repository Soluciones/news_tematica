# Engine NewsTematica

## Migraciones

Una migración no funciona si se lanza en el root del engine:

    > rails g migration add_news_tematica_id_to_redirections news_tematica_id:integer

    => script/rails:8:in 'require': cannot load such file -- rails/engine/commands (LoadError)
    => from script/rails:8:in 'main>'

Hay que lanzarla en dummy:

    > cd test/dummy
    > rails g migration add_news_tematica_id_to_redirections news_tematica_id:integer

    => invoke  active_record
    => create    db/migrate/20130626151549_add_news_tematica_id_to_redirections.rb

    > cp db/migrate/20130626151549_add_news_tematica_id_to_redirections.rb ../../db/migrate/
    > rake db:migrate


Luego, habrá que importar las migraciones a la app principal que vaya a usar el engine:

    > rnk
    > rake news_tematica:install:migrations
    > rdbp


**OJO:** Si tenemos el *database.yml* apuntando a la misma BD (que no deberíamos), el `rake db:migrate` de la app fallará porque "el campo ya existe", habrá que ajustarlo a mano... **FAIL**.


## Conexión app-engine

### En el engine:

`lib/news_tematica`: Aquí metemos las clases externas con las que vamos a interactuar. La clase estará disponible como `xxx_class`


### En la app:

`config/initializers/engines.rb`: Aquí se le pasan las clases externas que el engine necesita, en formato `NewsTematica::Clases.xxx_extern = 'Xxx'`

### Configurar para que use la working copy local

    > bundle config local.news_tematica ../news_tematica

### Deshacer configuración para volver a usar git en lugar de la working copy

    > bundle config --delete local.news_tematica

## Control de versiones

### Incrementar versión en el código

Cuando el cambio ya está _mergeado_ en `master`, es hora de incrementar el contador de versiones para hacer la subida. En `lib/news_tematica/version.rb`:

    module NewsTematica
      VERSION = "0.5.1"
    end

### Escribir changelog

En `changelog.txt`, se comentan las características que se han añadido en esta versión.

###  Subir cambios a git y crear _tag_

En la línea de comandos, desde el directorio del engine:

    > git commit -m "Cambio de version"
    > git push origin
    > git tag 0.1.0
    > git push origin 0.1.0

### App principal

Una vez esta creado el _tag_ de la nueva versión, vamos a las aplicaciones principales y editamos la línea del Gemfile:

    gem 'news_tematica', git: 'git@github.com:Soluciones/news_tematica.git', branch: 'master', tag: '0.1.0'


Y lanzamos `bundle update --source news_tematica` para que actualice a la nueva versión.
