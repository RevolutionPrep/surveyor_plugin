module Surveyor

  module ActiveResourceModels

    class QuestionResult < ActiveResource::Base

      self.site = Surveyor::site
      self.prefix = "/api/#{Surveyor::version.gsub('.','_')}/"
      self.user = Surveyor::user
      self.password = Surveyor::password

    end

  end

end