# -*- encoding: utf-8 -*-
require 'clamp'
require 'templatron/version'
require 'templatron/config'
require 'templatron/generator'
require 'templatron/collector'

module Templatron

  # Represents a base class with command flags
  class AbstractCommand < Clamp::Command
    option ['-v', '--verbose'], :flag, 'Enable verbose mode', :default => false
    option '--version', :flag, 'Show the current version' do
      puts Templatron::VERSION
      exit(0)
    end
  end

  # Use to list the template dir
  class ListCommand < AbstractCommand
    parameter '[SUB_PATH]', 'Relative path to list from',
      :attribute_name => :subpath,
      :default => ''
    option ['-a', '--all'], :flag, 'Also show files', :default => false

    def execute
      col = Collector.new(subpath, all?, false, verbose?)
      entries = col.list

      entries.each { |e| puts e.sub(col.full_path, '') }
    end
  end

  # Use to build stuff!
  class BuildCommand < AbstractCommand
    parameter 'TEMPLATE_NAME', 'Template to generate from',
      :attribute_name => :template
    parameter '[ARGS] ...', 'Template arguments',
      :attribute_name => :arguments
    option ['-o', '--output'], 'OUTPUT_DIR', 'Where to put the generated files',
      :default => Dir.pwd
    option ['-d', '--delete'], :flag, 'Clear the output folder first', 
      :default => false

    def execute
      # Instantiate the generator and build the stuff
      gen = Generator.new(
        template, 
        arguments, 
        output,
        delete?, 
        verbose?)
      t_start = Time.now      
      gen.build
      t_end = Time.now
      puts "BUILT in #{t_end - t_start} seconds"
    end
  end

  # Entry point of the cli
  class MainCommand < AbstractCommand
    subcommand 'build', 'Build from templates', BuildCommand
    subcommand 'list', 'List available templates', ListCommand
  end

  # Public: CLI Stuff, parse command line inputs to determine what to do
  def self.execute
    MainCommand.run
  end

end