# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

require 'templatron/version'

Gem::Specification.new do |s|
  s.name = 'templatron'
  s.version = Templatron::VERSION
  s.authors = ['Julien Leicher']
  s.email = ['jleicher@gmail.com']
  s.licenses    = ['MIT']
  s.homepage = 'https://github.com/YuukanOO/templatron'
  s.summary = 'An easy to use scaffold generator'
  s.description = 'Defines templates with variables and generates whatever you want'
  s.add_runtime_dependency "clamp", "~> 0.6.4"

  s.rubyforge_project = 'templatron'

  s.files = Dir['lib/**/*', 'bin/**/*']
  s.executables = ['templatron']
end