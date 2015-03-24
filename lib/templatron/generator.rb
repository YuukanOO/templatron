# -*- encoding: utf-8 -*-
require 'fileutils'
require 'templatron/config'
require 'templatron/collector'

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

      @collector = Collector.new(@template, true, true)

      process_raw_arguments(args)
    end

    # Public: Effectively process a template to generate it
    def build
      # Check template existence
      if !check_template_dir(@collector.full_path)
        puts "The template #{@template} does not appear to exist in #{@full_template_path}"
        exit
      end

      # If sets, remove the output folder first
      if @clear
        puts "Clearing #{@output}" if @verbose
        begin
          FileUtils.remove_dir(@output, true)
        rescue
          puts "Could not clear the folder, maybe someone is accessing it? Exiting..."
          exit(1)
        end
      end

      # Print details if verbose is on
      if @verbose
        puts "Starting building #{@collector.full_path} to #{@output}"
        puts "With:" if !@arguments.empty?
        @arguments.each_with_index do |arg, i|
          puts "\t{$#{i}} => #{arg}" if !arg.nil?
        end
      end

      # So process them right now
      process_files(@collector.list)
    end

    protected

    # Internal: Process each entries, copy the files and replaces variables
    # 
    # entries - An array of files to process
    def process_files(entries)
      entries.each do |path|

        # Get base path
        new_path = path.sub(@collector.full_path, '')
        
        is_dir = File.directory?(path)

        # Apply arguments to the path
        apply_arguments!(new_path)

        full_new_path = File.join(@output, new_path)

        if is_dir
          puts "Creating directory #{path} to #{full_new_path}" if @verbose
          FileUtils.mkdir_p(full_new_path)
        else
          # Now we can copy the entry
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
      str.scan(Templatron::PLACEHOLDER_REG).each do |match|
        match_i = match[0].to_i
        arg_value = @arguments[match_i]
        arg_value = match[1] if arg_value.nil?

        str.gsub!(Templatron::placeholder_reg(match_i), arg_value)
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