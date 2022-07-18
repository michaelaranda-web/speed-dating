require 'csv'

class WelcomeController < ApplicationController
  def index
    puts "*****************************hello"
  end
  
  def upload
    puts "*****************************upload"
    
    puts params[:num_tables]
    puts params[:num_rounds]
   
    csv_text = params[:attendees].read
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      Attendee.create(name: row[0], age: row[1].to_i, gender: row[2], phone_number: row[3])
    end
    
    redirect_to assignments_url
  end
end
