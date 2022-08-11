require 'csv'

class IcebreakerQuestionsController < ApplicationController
  def index
    puts "*****************************hello"
  end
  
  def upload
    csv_text = params[:icebreaker_questions_csv].read
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      IcebreakerQuestion.create(text: row[0])
    end
    
    redirect_to root_url, status: :found
  end
end
