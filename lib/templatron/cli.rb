# -*- encoding: utf-8 -*-
require 'templatron/version'
require 'templatron/config'
require 'templatron/generator'
require 'optparse'
require 'ostruct'

module Templatron

  # Public: CLI Stuff, parse command line inputs to determine what to do
  def self.execute

    usage = 'Usage: templatron TEMPLATE_NAME [args] [-o output_dir]'

    # If no argument has been given, print usage
    if ARGV.length == 0
      puts usage
      exit
    end

    # Defines the structure and default values
    options = OpenStruct.new
    options.output_dir = Dir.pwd
    options.verbose = false
    options.delete_dir = false

    # Defines options parser
    opt_parser = OptionParser.new do |opts|
      opts.banner = usage
      opts.default_argv = '-h'

      opts.separator ''
      opts.separator 'Features:'

      # Defines where to put generated files
      opts.on('-o', '--output PATH', 'Where to put the generated files') do |dir|
        options.output_dir = dir
      end

      # Should we remove the output directory first
      opts.on('-d', '--delete', 'If set, clear the output directory first') do
        options.delete_dir = true
      end

      opts.separator ''
      opts.separator 'Common options:'

      # Verbose mode
      opts.on('-v', '--verbose', 'Verbose mode') do
        options.verbose = true
      end

      # Print the help
      opts.on_tail('-h', '--help', 'Show this message') do
        puts opts
        puts ''
        puts "Templates path: #{Templatron::templates_path}"
        exit
      end

      # Print version number
      opts.on_tail('--version', 'Show version') do
        puts Templatron::VERSION
        exit
      end
    end

    opt_parser.parse!(ARGV)

    # Instantiate the generator and build the stuff
    gen = Generator.new(
      ARGV[0], 
      ARGV[1..ARGV.length], 
      options.output_dir,
      options.delete_dir, 
      options.verbose)
    gen.build
  end

end