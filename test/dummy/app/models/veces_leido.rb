# coding: UTF-8

class VecesLeido < ActiveRecord::Base
  belongs_to :leido, polymorphic: true

end
