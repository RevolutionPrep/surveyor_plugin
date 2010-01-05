class Create<%= plural_name.camelize %> < ActiveRecord::Migration
	def self.up
		create_table :<%= plural_name %> do |t|
			t.integer		:surveyor_result_id
			t.timestamps
		end
	end

	def self.down
		drop_table :<%= plural_name %>
	end
end