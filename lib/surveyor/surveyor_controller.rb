module SurveyorController

  def self.included(base)
    base.send :extend, ClassMethods
  end

  module ClassMethods

    def has_survey(options = {})
      cattr_accessor :survey_key
      self.survey_key = options[:api_key]
      send :include, InstanceMethods
    end

  end

  module InstanceMethods

    def surveyor_create
      survey_results = Hash.new
      if params["surveyor"]
        params["surveyor"].each_pair do |key,value|
          survey_results.store(key,value.to_s) unless key == "id"
        end
        survey_results.store("key","#{self.survey_key}")
        if params["surveyor"]["id"]
          @surveyor = params["surveyor"]["class"].constantize.find(params["surveyor"]["id"])
        else
          @surveyor = params["surveyor"]["class"].constantize.new
        end
        @surveyor.retrieve_survey
        @surveyor.update_attributes(params["surveyor"].reject { |key,value| key == "class" })
        if @surveyor.valid?
          survey_result = Surveyor::ActiveResourceModels::SurveyResult.create(survey_results)
          @surveyor.surveyor_result_id = survey_result.id
          @surveyor.save
          surveyor_redirect
        else
          surveyor_failover
        end
      else
        surveyor_failover
      end
    end

  end

end

ActionController::Base.send :include, SurveyorController