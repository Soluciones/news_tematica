# coding: utf-8

class ApplicationController < ActionController::Base
  protect_from_forgery

  include ApplicationHelper, EmergiaHelper

  # Impide el acceso a usuarios no administradores
  def admin_required
    unless soy_admin?
      envia_a_login("Debe identificarse como administrador para acceder")
    end
  end

  # Impide el acceso a usuarios no gestores de usuarios
  def gestor_usr_required
    unless soy_gestor_usr?
      envia_a_login("Debe identificarse como gestor de usuarios para acceder")
    end
  end

  # Redirecciona a la pantalla de login, con un mensaje de aviso
  def envia_a_login(mensaje)
    session[:pagina_destino] = request.fullpath
    flash[:notice] = mensaje
    respond_to do |format|
      format.html { redirect_to login_path }
      format.js do
        render :update do |page|
          page.redirect_to login_path
        end
      end
    end
    return false
  end

  # Impide el acceso a usuarios no registrados
  def login_required
    unless (@yo and (@yo.estado_id > Usuario::ESTADO_SIN_ACTIVAR))
      envia_a_login("Debe identificarse como usuario para acceder")
    end
  end

  # Impide el acceso a usuarios no moderadores
  def moderador_required
    unless soy_moderador?
      envia_a_login("Debe identificarse como moderador para acceder")
    end
  end

  # Guarda la página actual en la cookie para volver tras el login
  def punto_retorno_login
    session[:pagina_destino] = request.fullpath
  end

  # Impide el acceso a usuarios no super-administradores
  def superadmin_required
    unless soy_superadmin?
      envia_a_login("Debe identificarse como super-administrador para acceder")
    end
  end


end
