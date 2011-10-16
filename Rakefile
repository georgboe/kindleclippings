require 'rubygems'
require 'rake'
require 'rspec/core/rake_task'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "kindleclippings"
    gem.summary = %Q{A gem to parse Kindle's "My Clippings.txt" file into ruby objects.}
    gem.description = %Q{A gem to parse Kindle's "My Clippings.txt" file into ruby objects.}
    gem.email = "georg.boe@gmail.com"
    gem.homepage = "http://github.com/georgboe/kindleclippings"
    gem.authors = ["Georg Alexander Boe"]
    gem.files = FileList['lib/**/*.rb']
    gem.test_files = []
    gem.add_development_dependency "rspec", ">= 1.2.9"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "kindleclippings #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
