# -*- encoding: utf-8 -*-
require 'templatron/config'

module Templatron

  # Collector stuff
  # Show templates and related informations
  class Collector

    attr_accessor :full_path

    # Public: Initialize the collector instance
    # 
    # path - Relative path of a template
    # include_files - Also include files or not
    # include_sub - Incluse subfolders?
    # verbose - Verbose mode?
    def initialize(path, include_files, include_sub, verbose = false)
      @full_path = File.join(Templatron::templates_path, path)
      @verbose = verbose
      @include_files = include_files
      @include_subfolders = include_sub
    end

    # Public: List the content of this template
    def list
      puts "Listing content: of directory #{@full_path}" if @verbose

      v = ['**']
      v << '*' if @include_subfolders

      collect_str = File.join(@full_path, v)

      entries = Dir[collect_str]
      entries.map! { |e| e if File.directory?(e) }.compact! if !@include_files

      entries
    end

  end

end