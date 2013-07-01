# Engine NewsTematica

## Migraciones

Una migración no funciona si se lanza en el root del engine:

    rails g migration add_news_tematica_id_to_redirections news_tematica_id:integer

    => script/rails:8:in 'require': cannot load such file -- rails/engine/commands (LoadError)
from script/rails:8:in 'main>'

Hay que lanzarla en dummy:

    cd test/dummy
    rails g migration add_news_tematica_id_to_redirections news_tematica_id:integer

    => invoke  active_record
    => create    db/migrate/20130626151549_add_news_tematica_id_to_redirections.rb

    cp db/migrate/20130626151549_add_news_tematica_id_to_redirections.rb ../../db/migrate/
    rake db:migrate


Luego, habrá que importar las migraciones a la app principal que vaya a usar el engine:

    rnk
    rake news_tematica:install:migrations
    rdbp


**OJO:** Si tenemos el *database.yml* apuntando a la misma BD (que no deberíamos), el `rake db:migrate` de la app fallará porque "el campo ya existe", habrá que ajustarlo a mano... **FAIL**.


## Conexión app-engine

### En el engine:

`lib/news_tematica`  -> Aquí metemos las clases externas con las que vamos a interactuar
La clase estará disponible como `xxx_class`


### En la app:

`config/initializers/engines.rb`  -> Aquí se le pasan las clases externas que el engine necesita, en formato `NewsTematica::Clases.xxx_extern = 'Xxx'`


## Control de versiones

Cuando el cambio ya está terminado, es hora de incrementar el contador de versiones para hacer la subida:

En `lib/news_tematica/version.rb`:

    VERSION = "0.1.0"

En `changelog.txt`, se comentan las características que se han añadido en esta versión.

En la línea de comandos, desde el directorio del engine:

    git commit -m blablabla
    git tag 0.1.0
    git push origin 0.1.0

Y cuando en el engine ya se ha mergeado a master esta versión, es hora de buscar la nueva versión desde la app principal:

    rnk
    bundle update news_tematicas
