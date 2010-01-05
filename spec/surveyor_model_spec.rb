require File.dirname(__FILE__) + '/spec_helper'

describe "SurveyorModel" do

	class TestSurvey < ActiveRecord::Base

		has_survey :api_key => "api_key", :result => :test_survey_result_id

		def self.columns() @columns ||= []; end

		def self.column(name, sql_type = nil, default = nil, null = true)
			columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
		end

		column :test_survey_result_id, :integer

	end

	before(:each) do
		@test_survey = TestSurvey.new
	end

	describe "ClassMethod" do

		describe "has_survey(options = {}) class method" do

			it "should have an API key" do
				@test_survey.survey_key.should eql("api_key")
			end

			it "should allow for alias attributes of 'surveyor_result_id'" do
				@test_survey.test_survey_result_id = 12345
				@test_survey.surveyor_result_id.should eql(12345)
			end

		end

		describe "retrieve_results(instances, options = {}) class method" do

			it "should retrieve survey results"

		end

		describe "retrieve_headcount(instances, handle, choice) class method" do

			it "should retrieve the headcount of those who answered the specified question with the specified response"

		end

		describe "retrieve_percentage_of_respondents(instances, handle, choice) class method" do

			it "should retrieve the percentage of respondents who answered the specified question with the specified response"

		end

		describe "retrieve_percentage_of_total(instances, handle, choice) class method" do

			it "should retrieve the percentage of respondents who answered the specified question with the specified response including non-responses in the total"

		end

		describe "retrieve_gpa_of_respondents(instances, handle) class method" do

			it "should retrieve the GPA of the specified question given a total of people who responded"

		end

		describe "retrieve_gpa_of_total(instances, handle) class method" do

			it "should retrieve the GPA of the specified question given a total of all surveys"

		end

	end

end