require 'directory_watcher'
require 'daemons'
require 'yaml'
require 'logger'
require 'fileutils'
require "bundler"

class Jekyllbox
  def initialize(full_path)
    @config = YAML.load(File.read(File.expand_path("../config.yml", full_path)))

    Dir.mkdir(@config['output_directory']) unless Dir.exist?(@config['output_directory'])
    Dir.mkdir(@config['input_directory']) unless Dir.exist?(@config['input_directory'])

    FileUtils.cd(@config['input_directory'])

    build_directory_watcher
    bundle_install
    build
    run_directory_watcher
  end

  private
  def run_directory_watcher
    puts "Input directory: #{@config['input_directory']}"
    puts "Output directory: #{@config['output_directory']}"
    puts "Starting jekyllbox"
    puts
    loop do
      @dw.run_once
      sleep 1
    end
  end

  def build_directory_watcher
    assert_correct_directory!

    @dw = DirectoryWatcher.new '.', glob: '**/*', pre_load: true, scanner: :rev
    @dw.add_observer {|*args| on_file_change(args)}
  end

  def bundle_install
    assert_correct_directory!

    Bundler.with_clean_env { %x(bundle install) }
  end

  def on_file_change(events)
    puts events
    puts
    build
  end

  def build
    assert_correct_directory!

    puts "bundle exec jekyll build --config #{File.join(@config['input_directory'], "_config.yml")} --source #{@config['input_directory']} --destination #{@config['output_directory']} --trace"
    Bundler.with_clean_env { %x(bundle exec jekyll build --config #{File.join(@config['input_directory'], "_config.yml")} --source #{@config['input_directory']} --destination #{@config['output_directory']} --trace) }
    puts "done"
  end

  def assert_correct_directory!
    raise "Wrong directory!" unless Dir.pwd == @config['input_directory']
  end
end

full_path = File.expand_path(__FILE__)
Jekyllbox.new(full_path)