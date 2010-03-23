module SurveyorRoutes

  def surveyor_routes
    @set.add_route("/:controller/surveyor_create", {:action => "surveyor_create"})
  end

end

ActionController::Routing::RouteSet::Mapper.send :include, SurveyorRoutes