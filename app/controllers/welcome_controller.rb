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
      Attendee.create(name: row[0], age: row[1].to_i, gender: row[2].downcase, phone_number: row[3], assignments_id: @new_assignments_session.id)
    end
    
    redirect_to assignment_url(@new_assignments_session), status: :found
  end
end
