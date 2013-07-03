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
      @news_tematica = NewsTematica.find(params[:id])
      @titulo = @news_tematica.titulo
    end

    def new
      @tematica = tematica_class.find(params[:tematica_id])
      @titulo = "Nueva newsletter de #{ @tematica.nombre }"
      @news_tematica = NewsTematica.new(tematica_id: @tematica.id, fecha_hasta: Time.zone.now, fecha_envio: 6.hours.from_now)
      @news_tematica.calcula_fecha_desde
      @tematicas_dropdown = tematica_class.datos_dropdown
    end

    def create
      @news_tematica = NewsTematicaDecorator.decorate(NewsTematica.new(params[:news_tematica]))
      todos_los_titulares = @news_tematica.titulares
      @titulares = todos_los_titulares[0..4]
      @otros_titulares = (todos_los_titulares - @titulares)[0..4]
      @masleidos = @news_tematica.lo_mas_leido[0..4]
      @temas = (@news_tematica.temas - @masleidos)[0..4]
      @banner_lateral = @news_tematica.banner_lateral
      @banner_inferior = @news_tematica.banner_inferior
      @news_tematica.html = Premailer.new(render_to_string('news_tematica/news_tematicas/_preview', layout: false), with_html_string: true).to_inline_css
      if @news_tematica.save
        redirect_to edit_news_tematica_path(@news_tematica)
      else
        @titulo = "Nueva newsletter temática"
        @tematicas_dropdown = tematica_class.datos_dropdown
        render 'new'
      end
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
      todos_los_titulares = @news_tematica.titulares
      @titulares = todos_los_titulares[0..19]
      @masleidos = @news_tematica.lo_mas_leido[0..9]
      @temas = @news_tematica.temas[0..9]
    end

    def contenidos_elegidos
      @news_tematica = NewsTematicaDecorator.decorate(NewsTematica.find(params[:id]))
      titulares = @news_tematica.prioriza contenido_class.where(id: params[:titulares])
      @titulares = titulares[0..4]
      @otros_titulares = titulares[5..9]
      @masleidos = contenido_class.where(id: params[:masleidos]).all.sort_by { |msg| 100 - msg.veces_leido.contador * msg.factor_corrector_para_nuevos }
      @temas = @news_tematica.prioriza contenido_class.where(id: params[:temas])
      @banner_lateral = @news_tematica.banner_lateral
      @banner_inferior = @news_tematica.banner_inferior
      @news_tematica.update_attribute('html', Premailer.new(render_to_string('news_tematica/news_tematicas/_preview', layout: false), with_html_string: true).to_inline_css)
      redirect_to edit_news_tematica_path(@news_tematica)
    end

  end
end
