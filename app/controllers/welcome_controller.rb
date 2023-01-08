require 'csv'

class WelcomeController < ApplicationController
  def index
    puts "*****************************hello"
  end
  
  def upload
    puts "*****************************upload"
    
    @new_assignments_session = Assignment.create(num_tables: params[:num_tables], num_rounds: params[:num_rounds])
   
    csv_text = params[:attendees].read
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      Attendee.create(first_name: row[0], last_name: row[1], age: row[2].to_i, gender: row[3].downcase, phone_number: row[4], assignments_id: @new_assignments_session.id)
    end
    
    redirect_to assignment_url(@new_assignments_session), status: :found
  end
end
