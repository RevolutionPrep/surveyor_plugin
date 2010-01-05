module SurveyorModel

	def self.included(base)
		base.send :extend, ClassMethods
	end

	module ClassMethods

		def has_survey(options = {})
			cattr_accessor :survey_key
			self.survey_key = options[:api_key]
			send :alias_attribute, :surveyor_result_id, options[:result].to_sym if options[:result]
			send :include, InstanceMethods
		end
		
		def retrieve_results(instances, options = {})
			unless options.empty?
				typed_result = Surveyor::ActiveResourceModels::QuestionResult.find(1, :params => { :api_key => self.survey_key, :results => instances.collect { |i| i.surveyor_result_id }, :handles => options[:handles]})
			else
				typed_result = Surveyor::ActiveResourceModels::SurveyResult.find(:all, :params => { :api_key => self.survey_key, :results => instances.collect { |i| i.surveyor_result_id } }).first
			end
			case typed_result.class.to_s
			when "Surveyor::SurveyResult"
				return typed_result
			when "Surveyor::QuestionResult"
				result = Surveyor::ActiveResourceModels::SurveyResult.new
				result.total_count = typed_result.total_count
				result.questions = typed_result.questions
				return result
			end
		end
		
		def retrieve_headcount(instances, handle, choice)
			return Surveyor::ActiveResourceModels::QuestionResult.get(:headcount, :api_key => self.survey_key, :results => instances.collect { |i| i.surveyor_result_id }, :handle => handle, :choice => choice).first["headcount"].to_f
		end
		
		def retrieve_percentage_of_respondents(instances, handle, choice)
			return Surveyor::ActiveResourceModels::QuestionResult.get(:headcount, :api_key => self.survey_key, :results => instances.collect { |i| i.surveyor_result_id }, :handle => handle, :choice => choice).first["percentage_of_respondents"].to_f
		end
		
		def retrieve_percentage_of_total(instances, handle, choice)
			return Surveyor::ActiveResourceModels::QuestionResult.get(:headcount, :api_key => self.survey_key, :results => instances.collect { |i| i.surveyor_result_id }, :handle => handle, :choice => choice).first["percentage_of_total"].to_f
		end
		
		def retrieve_gpa_of_respondents(instances, handle)
			return Surveyor::ActiveResourceModels::QuestionResult.get(:gpa, :api_key => self.survey_key, :results => instances.collect { |i| i.surveyor_result_id }, :handle => handle).first["gpa_of_respondents"].to_f
		end

		def retrieve_gpa_of_total(instances, handle)
			return Surveyor::ActiveResourceModels::QuestionResult.get(:gpa, :api_key => self.survey_key, :results => instances.collect { |i| i.surveyor_result_id }, :handle => handle).first["gpa_of_total"].to_f
		end

	end

	module InstanceMethods

		def retrieve_survey
			begin
				survey =  Surveyor::ActiveResourceModels::Survey.find(self.class.survey_key)
				question_ids = survey.questions.each do |question|
					self.class.send :attr_accessor, ("#{self.class.survey_key}_" + "#{question.id}").to_sym
					self.class.send :attr_accessor, ("#{self.class.survey_key}_" + "#{question.id}" + "_type").to_sym
					if question.required == "true"
						self.class.send :validates_presence_of, ("#{self.class.survey_key}_" + "#{question.id}").to_sym
					end
				end
				return survey
			rescue ActiveResource::ResourceNotFound
				return ActiveRecord::RecordNotFound
			end
		end

	end

end

ActiveRecord::Base.send :include, SurveyorModel