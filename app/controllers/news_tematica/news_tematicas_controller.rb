# coding: utf-8

module NewsTematica
  class NewsTematicasController < ApplicationController
    include Clases
    before_filter :admin_required

    def index
      @titulo = 'Newsletters temáticas'
      @news_tematicas = NewsTematica.order('fecha_envio DESC')
    end

    def show
      @news_tematica = NewsTematica.find(params[:id]).decorate
      redirections = @news_tematica.redirections.collect(&:id)
      @clics_count = visita_class.where(redirection_id: redirections).count
      @titulo = @news_tematica.titulo
    end

    def new
      nombre_tematica = tematica_class.nombre_suscripcion(params[:tematica_id])
      @titulo = "Nueva newsletter de #{ nombre_tematica }"
      @news_tematica = NewsTematica.new(tematica_id: params[:tematica_id], fecha_hasta: Time.zone.now, fecha_envio: 6.hours.from_now)
      @news_tematica.calcula_fecha_desde
      @tematicas_dropdown = tematica_class.todas
    end

    def create
      carga_variables_preview NewsTematica.new(params[:news_tematica])
      @news_tematica.html = dame_html
      if @news_tematica.save
        redirect_to edit_news_tematica_path(@news_tematica)
      else
        @titulo = "Nueva newsletter temática"
        @tematicas_dropdown = tematica_class.todas
        render 'new'
      end
    end

    def preview
      carga_variables_preview NewsTematica.find(params[:id])
      render text: dame_html, layout: false
    end

    def edit
      @news_tematica = NewsTematica.find(params[:id])
      redirect_to news_tematica_path(@news_tematica) if @news_tematica.enviada
    end

    def update
      @news_tematica = NewsTematica.find(params[:id])
      if @news_tematica.enviada
        render(text: 'Esta newsletter ya ha sido enviada, no puede modificarse ni volverse a enviar.')
      elsif !@news_tematica.update_attributes(params[:news_tematica])
        render("edit")
      elsif params[:commit].downcase.include?('sendgrid')
        @news_tematica.a_sendgrid!
        redirect_to news_tematicas_path
      else
        redirect_to(edit_news_tematica_path(@news_tematica))
      end
    end

    def elegir_contenidos
      @news_tematica = NewsTematicaDecorator.decorate(NewsTematica.find(params[:id]))
      @titulo = "Elegir contenidos para la newsletter"
      @titulares = @news_tematica.titulares
      @masleidos = @news_tematica.lo_mas_leido[0..9]
      @temas = @news_tematica.temas[0..9]
    end

    def contenidos_elegidos
      @news_tematica = NewsTematicaDecorator.decorate(NewsTematica.find(params[:id]))
      titulares_desordenados = contenido_class.where(id: params[:titulares])
      if params[:prioridades_titulares].present?
        titulares_priorizados = @news_tematica.prioriza_como_te_diga(titulares_desordenados, params[:prioridades_titulares])
      else
        titulares_priorizados = @news_tematica.prioriza titulares_desordenados
      end
      @titulares = ContenidoEnNewsDecorator.decorate_collection(titulares_priorizados[0..4])
      @otros_titulares = titulares_priorizados[5..9]
      @masleidos = contenido_class.where(id: params[:masleidos]).all.sort_by { |msg| 100 - msg.contador_veces_leido * msg.factor_corrector_para_nuevos }
      @temas = @news_tematica.prioriza contenido_class.where(id: params[:temas])
      @banner_lateral = @news_tematica.banner_lateral
      @banner_inferior = @news_tematica.banner_inferior
      @news_tematica.update_attribute('html', dame_html)
      redirect_to edit_news_tematica_path(@news_tematica)
    end

  private

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
      html_inlineado = Premailer.new(html_limpio, with_html_string: true).to_inline_css
      restaura_tags_sendgrid html_inlineado
    end

    def restaura_tags_sendgrid(html)
      html.gsub('%5B', '[')
          .gsub('%5D', ']')
    end
  end
end
