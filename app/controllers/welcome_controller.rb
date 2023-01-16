require 'csv'

class WelcomeController < ApplicationController
  def index
    puts "*****************************hello"
  end
  
  def upload
    puts "*****************************upload"
    
    @new_assignments_session = Assignment.create(num_tables: params[:num_tables], num_rounds: params[:num_rounds])

    male_attendees, female_attendees = AttendeeFinder.new.parse_csv(params[:attendees])

    PairingCalculator.new.calculate(@new_assignments_session, male_attendees, female_attendees)
    
    redirect_to assignment_url(@new_assignments_session), status: :found
  end
end
