require 'rake'
require 'spec/rake/spectask'
require 'rake/rdoctask'

desc 'Default: run specs.'
task :default => :spec

desc 'Run the specs'
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_opts = ['--colour --format specdoc --loadby mtime --reverse -b']
  t.spec_files = FileList['spec/**/*_spec.rb']
end

desc 'Generate documentation for the surveyor plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Surveyor'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
