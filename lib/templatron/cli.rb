# -*- encoding: utf-8 -*-
require 'clamp'
require 'templatron/version'
require 'templatron/config'
require 'templatron/generator'

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

    def execute
      path = Templatron::templates_path
      puts "Listing templates from: #{path}"
      entries = Dir[File.join(path, '**')].map { |e| e if File.directory?(e) }.compact

      entries.each { |e| puts "\t #{e.sub(path, '')}" }
    end
  end

  # Use to build stuff!
  class BuildCommand < AbstractCommand
    parameter 'TEMPLATE_NAME', 'Template to generate from',
      :attribute_name => :template
    parameter '[ARGS] ...', 'Template arguments',
      :attribute_name => :arguments
    option ['-o', '--output'], 'OUTPUT_DIR', 'Where to put the generated files',
      :attribute_name => :output,
      :default => Dir.pwd
    option ['-d', '--delete'], :flag, 'Clear the output folder first', :default => false

    def execute
      # Instantiate the generator and build the stuff
      gen = Generator.new(
        template, 
        arguments, 
        output,
        delete?, 
        verbose?)
      gen.build
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