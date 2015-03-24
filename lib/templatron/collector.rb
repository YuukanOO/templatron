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
      @full_path = File.join(Templatron::templates_path, expand_path(path))
      @verbose = verbose
      @include_files = include_files
      @include_subfolders = include_sub
    end

    # Public: List the content of this template
    # 
    # Returns the list of entries for this instance
    def list
      puts "Listing content: of directory #{@full_path}" if @verbose

      v = ['**']
      v << '*' if @include_subfolders

      entries = Dir.glob(escape_glob(File.join(@full_path, v)))
      entries.map! { |e| e if File.directory?(e) }.compact! if !@include_files

      entries
    end

    protected

    # Internal: Escape special characters, needed for glob to work
    # 
    # str - String to escape
    # 
    # Returns an escaped string
    def escape_glob(str)
      str.gsub(/[\\\{\}\[\]\?]/) { |x| "\\"+x }
    end

    # Internal: Expand the path by looking in each subfolders and replacing default
    # placeholder values with their real names
    # 
    # Notes
    #   It may need a little refactoring
    # 
    # path - Path to expand
    # 
    # Examples
    # 
    #   Given base/profile/authors, it will returns base/profile/{$1 authors}
    # 
    # Returns the real path
    def expand_path(path)
      tmp = path
      final_path_components = []

      until (p = File.split(tmp)).first == '.'
        tmp = p.first
        component = p.last

        # Gets all entries in this folder
        base_path = File.join(Templatron::templates_path, tmp)

        Dir.glob(escape_glob(File.join(base_path, '*'))).each do |e|
          next if !File.directory?(e) # Only process folders

          e.scan(Templatron::PLACEHOLDER_REG).each do |match|
            # Replace this component if it matches the user input
            if component.include?(match[1])
              component.sub!(match[1], e.match(Templatron::placeholder_block_reg(match[1])).to_s)
            end
          end
        end

        final_path_components << component
      end

      final_path_components << p.last

      File.join(final_path_components.reverse)
    end

  end

end