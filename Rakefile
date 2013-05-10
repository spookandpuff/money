# encoding: UTF-8
require 'rubygems'
require 'bundler'
require 'yard'
require 'rspec'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)
YARD::Rake::YardocTask.new {|t| t.files = ['lib/**/*.rb']}
Bundler::GemHelper.install_tasks

task :default => :spec
