class <%= plural_name.camelize %>Controller < ApplicationController

  has_survey :api_key => "API_KEY"

  def new

  end

  def surveyor_redirect
    # This is where you will handle any logic and redirection after the Surveyor form has been submitted successfully
    # The model can be recalled using @surveyor
    respond_to do |format|
      format.html { redirect_to root_url }
    end
  end

  def surveyor_failover
    # This is where you will handle logic and redirection if the Surveyor form has an error
    # The model can be recalled using @surveyor
    respond_to do |format|
      format.html { redirect_to new_<%= singular_name %>_path }
    end
  end

end