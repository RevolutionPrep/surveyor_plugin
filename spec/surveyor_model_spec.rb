require File.dirname(__FILE__) + '/spec_helper'

describe "SurveyorModel" do

	class TestSurvey < ActiveRecord::Base

		has_survey :api_key => "api_key", :result => :alias_result_id
		attr_accessor :alias_result_id

		def self.columns() @columns ||= []; end

		def self.column(name, sql_type = nil, default = nil, null = true)
			columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
		end

		column :recommendable_type, :string
		column :recommendable_id, :integer
		column :email, :string
		column :body, :text

	end

	before(:each) do
		@test_survey = TestSurvey.new
	end

	it "should have an API key" do
		@test_survey.survey_key.should eql("api_key")
	end

	it "should allow for alias attributes of 'surveyor_result_id'" do
		@test_survey.alias_result_id = 12345
		@test_survey.surveyor_result_id.should eql(12345)
	end

	it "should retrieve survey results"

end