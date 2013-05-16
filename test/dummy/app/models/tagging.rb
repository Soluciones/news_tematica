# coding: UTF-8

class Tagging < ActiveRecord::Base #:nodoc:
  # belongs_to :tag, counter_cache: true
  belongs_to :taggable, polymorphic: true

end
