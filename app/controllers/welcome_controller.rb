require 'csv'

class WelcomeController < ApplicationController
  def index
    puts "*****************************hello"

    @assignments = Assignment.last(5).reverse
  end
  
  def upload
    puts "*****************************upload"

    clear_db = params[:clear_db]
    if clear_db
      Assignment.destroy_all
      Exclusion.destroy_all
      Attendee.destroy_all
    end

    puts params[:actions]

    csv_text = params[:attendees].read
    male_attendees, female_attendees = AttendeeFinder.new.parse_csv(csv_text)
    if params[:actions] == "actions_attendees"
      flash[:success] = "Attendees Loaded"
      redirect_to upload_url and return
    end

    ExclusionCreator.new.parse_csv(csv_text)
    if params[:actions] == "actions_attendees_exclusions"
      flash[:success] = "Attendees Loaded and Exclusions Done"
      redirect_to upload_url and return
    end

    @new_assignments_session = Assignment.create(num_tables: params[:num_tables], num_rounds: params[:num_rounds])
    PairingCalculator.new.calculate(@new_assignments_session, male_attendees, female_attendees)

    redirect_to assignment_url(@new_assignments_session), status: :found
  end
end
