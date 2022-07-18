require 'csv'

class WelcomeController < ApplicationController
  def index
    puts "*****************************hello"
  end
  
  def upload
    puts "*****************************upload"
   
    csv_text = params[:attendees].read
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      puts row
    end
  end
end
