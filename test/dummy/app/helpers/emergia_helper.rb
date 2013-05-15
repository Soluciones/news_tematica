# coding: UTF-8

# Methods added to this helper will be available to all templates in all the applications.
module EmergiaHelper

  # Devuelve TRUE si el usuario ha hecho login con el nivel de permisos correspondiente o superior, o FALSE si no
  def soy_admin?
    soy_tipos_usuario?([Usuario::ESTADO_ADMIN, Usuario::ESTADO_GESTOR_USR, Usuario::ESTADO_SUPERADMIN])
  end
  def soy_gestor_usr?
    soy_tipos_usuario?([Usuario::ESTADO_GESTOR_USR, Usuario::ESTADO_SUPERADMIN])
  end
  def soy_moderador?
    soy_tipos_usuario?([Usuario::ESTADO_MODERADOR, Usuario::ESTADO_ADMIN, Usuario::ESTADO_GESTOR_USR, Usuario::ESTADO_SUPERADMIN])
  end
  def soy_superadmin?
    soy_tipos_usuario?([Usuario::ESTADO_SUPERADMIN])
  end

  # Devuelve TRUE si el usuario ha hecho login y su estado es el que se pasa como parámetro
  def soy_tipos_usuario?(estados)
    permiso = @yo and estados.include?@yo.estado_id
  end

end
