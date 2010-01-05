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
	
	before(:all) do
		FakeWeb.allow_net_connect = false
		FakeWeb.register_uri(:get,
		"http://generic:password@localhost:3001/api/1_1/question_results/headcount.xml?api_key=api_key&choice=Green&handle=color&results%5B%5D=1&results%5B%5D=2&results%5B%5D=3",
		:body => 	"<question_results type=\"array\">
						<question_result>
							<headcount>1</headcount>
							<percentage_of_respondents>0.5</percentage_of_respondents>
							<percentage_of_total>0.333333333</percentage_of_total>
						</question_result>
					</question_results>")
		FakeWeb.register_uri(:get,
							"http://generic:password@localhost:3001/api/1_1/question_results/gpa.xml?api_key=api_key&handle=color&results%5B%5D=1&results%5B%5D=2&results%5B%5D=3",
		:body => 	"<question_results type=\"array\">
						<question_result>
							<gpa_of_respondents>4.0</gpa_of_respondents>
							<gpa_of_total>3.95</gpa_of_total>
						</question_result>
					</question_results>")
	end

	before(:each) do
		@test_survey = TestSurvey.new
	end

	describe "ClassMethod" do

		describe "has_survey(options = {})" do

			it "should have an API key" do
				@test_survey.survey_key.should eql("api_key")
			end

			it "should allow for alias attributes of 'surveyor_result_id'" do
				@test_survey.test_survey_result_id = 12345
				@test_survey.surveyor_result_id.should eql(12345)
			end

		end

		describe "retrieve_results(instances, options = {})" do

			it "should retrieve entire survey results"

			it "should retrieve survey results for individual questions based on the question handles passed as options[:handle]"

		end

		describe "retrieve_headcount(instances, handle, choice)" do

			it "should retrieve the headcount of those who answered the specified question with the specified response" do
				surveys = []
				3.times do |i|
					surveys << TestSurvey.new(:test_survey_result_id => i+1)
				end
				count = TestSurvey.retrieve_headcount(surveys, "color", "Green")
				count.should eql(1.0)
			end

		end

		describe "retrieve_percentage_of_respondents(instances, handle, choice)" do

			it "should retrieve the percentage of respondents who answered the specified question with the specified response" do
				surveys = []
				3.times do |i|
					surveys << TestSurvey.new(:test_survey_result_id => i+1)
				end
				percentage = TestSurvey.retrieve_percentage_of_respondents(surveys, "color", "Green")
				percentage.should eql(0.5)
			end

		end

		describe "retrieve_percentage_of_total(instances, handle, choice)" do

			it "should retrieve the percentage of respondents who answered the specified question with the specified response including non-responses in the total" do
				surveys = []
				3.times do |i|
					surveys << TestSurvey.new(:test_survey_result_id => i+1)
				end
				percentage = TestSurvey.retrieve_percentage_of_total(surveys, "color", "Green")
				percentage.should eql(0.333333333)
			end

		end

		describe "retrieve_gpa_of_respondents(instances, handle)" do

			it "should retrieve the GPA of the specified question given a total of people who responded" do
				surveys = []
				3.times do |i|
					surveys << TestSurvey.new(:test_survey_result_id => i+1)
				end
				percentage = TestSurvey.retrieve_gpa_of_respondents(surveys, "color")
				percentage.should eql(4.0)
			end

		end

		describe "retrieve_gpa_of_total(instances, handle)" do

			it "should retrieve the GPA of the specified question given a total of all surveys" do
				surveys = []
				3.times do |i|
					surveys << TestSurvey.new(:test_survey_result_id => i+1)
				end
				percentage = TestSurvey.retrieve_gpa_of_total(surveys, "color")
				percentage.should eql(3.95)
			end

		end

	end

	describe "InstanceMethod" do

		describe "retrieve_survey" do

			it "should retrieve the survey from the Surveyor Server Application, applying the attribute accessors as necessary"

		end

	end

end