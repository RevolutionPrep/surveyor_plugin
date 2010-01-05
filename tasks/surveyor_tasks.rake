require 'yard'

namespace :doc do
	namespace :plugins do
		namespace :surveyor do
			YARD::Rake::YardocTask.new(:yardoc) do |t|
				t.files   = ['vendor/plugins/surveyor/lib/**/*.rb','vendor/plugins/surveyor/lib/*.rb']
				t.options = ['-odoc/plugins/surveyor', '-rvendor/plugins/surveyor/README']
			end
		end
	end
end