module Surveyor

  mattr_accessor :site
  mattr_accessor :version
  mattr_accessor :user
  mattr_accessor :password

  require 'surveyor/surveyor_model'
  require 'surveyor/surveyor_controller'
  require 'surveyor/surveyor_helper'
  require 'surveyor/surveyor_routes'

end