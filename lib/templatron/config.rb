# -*- encoding: utf-8 -*-
module Templatron

  # This part will be joined to the user Dir.home
  PREFIX = '.templatron'

  PLACEHOLDER_REG = /{\$(\d*)\W?([\w\s]*)}/

  # Public: Retrieve the full path which stores templates
  def self.templates_path
    File.join(Dir.home, PREFIX)
  end

  # Public: Retrieve the placeholder reg for replacement
  # 
  # match_i - Match key
  # 
  # Returns the regex for replacement
  def self.placeholder_reg(match_i)
    /{\$#{match_i}\W?([\w\s]*)}/
  end

  # Public: Retrieve the placeholder reg block which contains
  # the whole placeholder markup
  # 
  # key - Key to look for
  # 
  # Returns the regex needed to retrieve the whole placeholder markup
  def self.placeholder_block_reg(key)
    /({\$\d*\W?[#{key}]*})/
  end
end