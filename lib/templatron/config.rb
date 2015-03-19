# -*- encoding: utf-8 -*-
module Templatron

  # This part will be joined to the user Dir.home
  PREFIX = '.templatron'

  # Public: Retrieve the full path which stores templates
  def self.templates_path
    File.join(Dir.home, PREFIX)
  end
end