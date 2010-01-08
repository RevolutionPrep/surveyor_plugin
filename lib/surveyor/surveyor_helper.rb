module SurveyorHelper

	class SurveyorTextHelper
		include Singleton
		include ActiveSupport::Inflector
	end

	def helper
		SurveyorTextHelper.instance
	end

	def display_survey(instances, options = {})
		if instances.to_a.length == 1
			unless instances.to_a.first.surveyor_result_id
				survey = instances.retrieve_survey
				instances.attributes = params["surveyor"].reject { |key,value| key == "class" } if params["surveyor"]
				show_survey_form(survey,instances)
			else
				survey_result = Surveyor::ActiveResourceModels::SurveyResult.find(instances.to_a.first.surveyor_result_id)
				show_survey_result(survey_result)
			end
		else
			survey_results = instances.first.class.retrieve_results(instances,options)
			show_cumulative_survey_results(survey_results)
		end
	end

	def show_survey_form(survey,parent_class)
		form = ""

		form << "<form action=\"/#{helper.underscore(helper.pluralize(parent_class.class.to_s))}/surveyor_create\" class=\"surveyor\" id=\"new_surveyor\" method=\"post\">"

		form << "<div class=\"hidden\">"
		form << "<input name=\"authenticity_token\" type=\"hidden\" value=\"#{form_authenticity_token}\" />"
		form << "</div>"
		
		if parent_class.id
			form << "<input id=\"surveyor_id\" name=\"surveyor[id]\" type=\"hidden\" value=\"#{parent_class.id}\" />"
		end

		form << "<ul>"

		survey.questions.each do |question|
			
			form << "<li class=\"radio\" id=\"surveyor_#{survey.key}_#{question.id}_input\">"
			form << "<label for=\"surveyor_#{survey.key}_#{question.id}_\" class=\"question#{question.required == "true" && flash[:error] ? " is_required" : ""}\">#{question.statement} #{question.required == "true" ? "(required)" : ""}</label>"
			form << "<ul>"
			
			case question.sub_type
			when "MultipleChoiceQuestion"

				question.choices.each do |choice|
					form << "<li><label for=\"surveyor_#{survey.key}_#{question.id}_\"><input id=\"surveyor_#{survey.key}_#{question.id}\" name=\"surveyor[#{survey.key}_#{question.id}][]\" type=\"radio\" value=\"#{choice.id}\" /> #{choice.value}</label></li>"
				end

				form << "</ul>"
				form << "</li>"

				form << "<br />"

				form << "<li class=\"hidden\" id=\"surveyor_#{survey.key}_#{question.id}_type_input\">"
				form << "<input id=\"surveyor_#{survey.key}_#{question.id}_type\" name=\"surveyor[#{survey.key}_#{question.id}_type]\" type=\"hidden\" value=\"multiple_choice_question\" />"
				form << "</li>"

			when "RatingQuestion"

				question.choices.each do |choice|
					form << "<li><label for=\"surveyor_#{survey.key}_#{question.id}_\"><input id=\"surveyor_#{survey.key}_#{question.id}\" name=\"surveyor[#{survey.key}_#{question.id}][]\" type=\"radio\" value=\"#{choice.id}\" /> #{choice.value}</label></li>"
				end

				form << "</ul>"
				form << "</li>"

				form << "<br />"

				form << "<li class=\"hidden\" id=\"surveyor_#{survey.key}_#{question.id}_type_input\">"
				form << "<input id=\"surveyor_#{survey.key}_#{question.id}_type\" name=\"surveyor[#{survey.key}_#{question.id}_type]\" type=\"hidden\" value=\"rating_question\" />"
				form << "</li>"

			when "ShortAnswerQuestion"

				form << "<textarea cols=\"60\" id=\"surveyor_#{survey.key}_#{question.id}\" name=\"surveyor[#{survey.key}_#{question.id}]\" rows=\"15\"></textarea>"
				form << "</ul>"
				form << "</li>"

				form << "<br />"

				form << "<li class=\"hidden\" id=\"surveyor_#{survey.key}_#{question.id}_type_input\">"
				form << "<input id=\"surveyor_#{survey.key}_#{question.id}_type\" name=\"surveyor[#{survey.key}_#{question.id}_type]\" type=\"hidden\" value=\"short_answer_question\" />"
				form << "</li>"

			end
			
			form << "</li>"
		end

		form << "</ul>"

		form << "<ul>"
		
		form << "<input id=\"surveyor_class\" name=\"surveyor[class]\" type=\"hidden\" value=\"#{parent_class.class.to_s}\" />"
		
		form << "<div class=\"clear\"></div>"
		form << "<li class=\"commit\">"
		form << "<input class=\"create\" id=\"surveyor_submit\" name=\"commit\" type=\"submit\" value=\"Submit\" />"
		form << "</li>"
		form << "</ul>"

		form << "<div class=\"clear\"></div>"

		form << "</form>"

		return form
	end
	
	def show_survey_result(survey_result)
		results = ""
		
		results << "<div class=\"surveyor\">"
		results << "<ul>"
	
		survey_result.question_results.each do |question_result|
			results << "<li>"
			results << "<p><strong>#{question_result.question.statement}</strong></p>"
			results << "<ul>"
		
			case question_result.question.sub_type
			when "MultipleChoiceQuestion", "RatingQuestion"
				question_result.question.choices.each do |choice|
					results << "<li#{" class=\"selected\"" if choice.id == question_result.response}>#{choice.value}</li>"
				end
			when "ShortAnswerQuestion"
				results << "<li class=\"selected\">#{question_result.response}</li>" unless question_result.response.blank?
			end
		
			results << "</ul>"
		
			results << "</li>"
		end
	
		results << "</ul>"
		results << "</div>"
		
		return results
	end
	
	def show_cumulative_survey_results(survey_result)
		results = ""
		
		results << "<div class=\"surveyor\">"
		results << "<ul>"
		
		results << "<li><p><strong>Results out of #{survey_result.total_count} surveys submitted:</strong></p></li>"
	
		survey_result.questions.each do |question|
			results << "<li>"
			results << "<p><strong>#{question.statement}</strong></p>"
			
			results << "<table>"
			
			case question.sub_type
			when "MultipleChoiceQuestion", "RatingQuestion"
				results << "<tr>"
				results << "<th>Choice</th>"
				results << "<th>Count</th>"
				results << "<th>Percentage of Respondents</th>"
				results << "<th>Percentage of Total</th>"
				results << "</tr>"
				question.choices.each do |choice|
					results << "<tr class=#{cycle("even","odd")}>"
					results << "<td>#{choice.value}</td>" #{" (" + choice.grade_point + ")" if question.sub_type == "RatingQuestion"}
					results << "<td>#{choice.response_count}</td>"
					results << "<td>#{'%.2f' % (choice.percentage_of_respondents.to_f*100)}%</td>"
					results << "<td>#{'%.2f' % (choice.percentage_of_total.to_f*100)}%</td>"
					results << "</tr>"
				end
				if question.sub_type == "RatingQuestion"
					results << "<tr class=#{cycle("even","odd")}><td/><td/><td/><td/></tr>"
					results << "<tr class=#{cycle("even","odd")}><th/><th>Response Count Total</th><th>GPA of Respondents</th><th>GPA of Total</th></tr>"
					results << "<tr class=#{cycle("even","odd")}><td/><td>#{question.respondent_count}</td><td>#{'%.2f' % question.gpa_of_respondents}</td><td>#{'%.2f' % question.gpa_of_total}</td></tr>"
				end
			when "ShortAnswerQuestion"
				question.results.each do |result|
					results << "<tr class=\"#{cycle("even short_answer","odd short_answer")}\"><td>#{result.response}</td></tr>" unless result.response.blank?
				end
			end
			
			results << "</table>"
			
			results << "</li>"
			
			reset_cycle("default")
		end
	
		results << "</ul>"
		results << "</div>"
		
		return results
	end

end

ActionView::Base.send :include, SurveyorHelper