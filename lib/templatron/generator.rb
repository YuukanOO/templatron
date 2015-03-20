# -*- encoding: utf-8 -*-
require 'fileutils'
require 'templatron/config'

module Templatron

  # Base class used to generates skeleton from template
  # Basically, you just instantiate a Generator and call its #build method
  class Generator

    # Public: Initialize this Generator
    # 
    # template_name - Name of the template to generate
    # args          - Array of arguments to use
    # output_dir    - Where to put the generated stuff
    # delete_dir    - Should I clean the output folder?
    # verbose       - Should I explain?
    def initialize(template_name, args, output_dir, delete_dir, verbose)
      @template = template_name
      @output = File.expand_path(output_dir)
      @verbose = verbose
      @clear = delete_dir
      @full_template_path = File.join(Templatron::templates_path, @template)

      process_raw_arguments(args)
    end

    # Public: Effectively process a template to generate it
    def build
      # Check template existence
      if !check_template_dir(@full_template_path)
        puts "The template #{@template} does not appear to exist in #{@full_template_path}"
        exit
      end

      # If sets, remove the output folder first
      if @clear
        puts "Clearing #{@output}" if @verbose
        FileUtils.remove_dir(@output, true)
      end

      # Print details if verbose is on
      if @verbose
        puts "Starting building #{@full_template_path} to #{@output}"
        puts "With:"
        @arguments.each_with_index do |arg, i|
          puts "\t{$#{i}} => #{arg}" if !arg.nil?
        end
      end

      # And then process each files/folder
      collect_str = File.join(@full_template_path, '**', '*')
      # At this point, all file entries have been collected
      entries = Dir[collect_str].map { |p| p if File.file?(p) }.compact
      # So process them right now
      process_files(entries)
    end

    protected

    # Internal: Process each entries, copy the files and replaces variables
    # 
    # entries - An array of files to process
    def process_files(entries)
      entries.each do |path|

        # Get base path
        new_path = path.sub(@full_template_path, '')
        
        # Apply arguments to the path
        apply_arguments!(new_path)

        # Now we can copy the entry
        full_new_path = File.join(@output, new_path)

        puts "Copying #{path} to #{full_new_path}" if @verbose

        FileUtils.mkdir_p(File.dirname(full_new_path))
        FileUtils.copy(path, full_new_path)

        file_content = File.read(full_new_path)
        apply_arguments!(file_content)
        File.open(full_new_path, 'w') do |f|
          f.puts file_content
        end
      end
    end

    # Internal: Process raw arguments to check for pairs
    # 
    # args - Raw args send by the command line
    def process_raw_arguments(args)
      @arguments = []

      args.each_with_index do |arg, i|
        parts = arg.split('=')

        if parts.length == 1
          @arguments[i] = arg
        elsif parts.length == 2
          @arguments[parts[0].gsub(/[^0-9]/, '').to_i] = parts[1]
        else
          puts "Could not process argument #{arg}"
        end
      end
    end

    # Internal: Replace variable placeholders with given variable values
    # 
    # str - Where to look & replace
    def apply_arguments!(str)
      str.scan(/{\$(\d*)\W?([\w\s]*)}/).each do |match|
        match_i = match[0].to_i
        arg_value = @arguments[match_i]
        arg_value = match[1] if arg_value.nil?
        str.gsub!(/{\$#{match_i}\W?([\w\s]*)}/, arg_value)
      end
    end

    # Internal: Check if the template directory exists
    # 
    # dir - Where to look
    def check_template_dir(dir)
      Dir.exist?(dir)
    end
  end
end