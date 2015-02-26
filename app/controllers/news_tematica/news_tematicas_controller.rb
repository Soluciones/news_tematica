# coding: utf-8

module NewsTematica
  class NewsTematicasController < ApplicationController
    include Clases
    before_filter :admin_required

    def index
      @titulo = 'Newsletters temáticas'
      @news_tematicas = newstematica_klass.order('fecha_envio DESC')
    end

    def show
      @news_tematica = newstematica_klass.find(params[:id]).decorate
      redirections = @news_tematica.redirections.collect(&:id)
      @clics_count = visita_class.where(redirection_id: redirections).count
      @titulo = @news_tematica.titulo
    end

    def new
      nombre_tematica = tematica_class.nombre_suscripcion(params[:tematica_id])
      @titulo = "Nueva newsletter de #{ nombre_tematica }"
      @news_tematica = newstematica_klass.nueva_con_fechas_por_defecto(params[:tematica_id])
      @news_tematica.calcula_fecha_desde
    end

    def create
      carga_variables_preview newstematica_klass.new(news_tematica_params)
      @news_tematica.html = dame_html
      if @news_tematica.save
        redirect_to edit_news_tematica_path(@news_tematica)
      else
        @titulo = "Nueva newsletter temática"
        render 'new'
      end
    end

    def preview
      carga_variables_preview newstematica_klass.find(params[:id])
      render text: dame_html, layout: false
    end

    def edit
      @news_tematica = newstematica_klass.find(params[:id])
      redirect_to news_tematica_path(@news_tematica) if @news_tematica.enviada
    end

    def update
      @news_tematica = newstematica_klass.find(params[:id])
      if @news_tematica.enviada
        render(text: 'Esta newsletter ya ha sido enviada, no puede modificarse ni volverse a enviar.')
      elsif !@news_tematica.update_attributes(news_tematica_params)
        render("edit")
      elsif params[:commit].downcase.include?('mandrill')
        @news_tematica.enviar!
        redirect_to news_tematicas_path
      else
        redirect_to(edit_news_tematica_path(@news_tematica))
      end
    end

    def elegir_contenidos
      @news_tematica = NewsTematicaDecorator.decorate(newstematica_klass.find(params[:id]))
      @titulo = "Elegir contenidos para la newsletter"
      @titulares = @news_tematica.titulares
      @masleidos = @news_tematica.lo_mas_leido[0..9]
      @temas = @news_tematica.temas[0..9]
    end

    def contenidos_elegidos
      @news_tematica = NewsTematicaDecorator.decorate(newstematica_klass.find(params[:id]))
      titulares_desordenados = contenido_class.where(id: params[:titulares])
      if params[:prioridades_titulares].present?
        titulares_priorizados = @news_tematica.prioriza_como_te_diga(titulares_desordenados, params[:prioridades_titulares])
      else
        titulares_priorizados = @news_tematica.prioriza titulares_desordenados
      end
      @titulares = ContenidoEnNewsDecorator.decorate_collection(titulares_priorizados[0..4])
      @otros_titulares = titulares_priorizados[5..9]
      @masleidos = contenido_class.where(id: params[:masleidos]).to_a.sort_by { |msg| 100 - msg.contador_veces_leido * msg.factor_corrector_para_nuevos }
      @temas = @news_tematica.prioriza contenido_class.where(id: params[:temas])
      @banner_lateral = @news_tematica.banner_lateral
      @banner_inferior = @news_tematica.banner_inferior
      @news_tematica.update_attribute('html', dame_html)
      redirect_to edit_news_tematica_path(@news_tematica)
    end

  private

    def newstematica_klass
      NewsTematica.respond_to?(:new) ? NewsTematica : NewsTematica::NewsTematica
    end

    def carga_variables_preview(news_tematica)
      @news_tematica = news_tematica.decorate
      todos_los_titulares = @news_tematica.titulares
      @titulares = ContenidoEnNewsDecorator.decorate_collection(todos_los_titulares[0..4])
      @otros_titulares = (todos_los_titulares - @titulares)[0..4]
      @masleidos = @news_tematica.lo_mas_leido[0..4]
      @temas = (@news_tematica.temas - @masleidos)[0..4]
      @banner_lateral = @news_tematica.banner_lateral
      @banner_inferior = @news_tematica.banner_inferior
    end

    def dame_html
      html_limpio = render_to_string('news_tematica/news_tematicas/_preview', layout: false)
      html_inlineado = Premailer.new(html_limpio, with_html_string: true, input_encoding: 'UTF-8').to_inline_css
    end

    def news_tematica_params
      params.require(:news_tematica).
        permit(:id, :tematica_id, :titulo, :html, :fecha_desde, :fecha_hasta, :fecha_envio,
               :banner_1_url_imagen, :banner_1_url_destino, :banner_1_texto_alt,
               :banner_2_url_imagen, :banner_2_url_destino, :banner_2_texto_alt,
               :enviada)
    end
  end
end
