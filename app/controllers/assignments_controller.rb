class AssignmentsController < ApplicationController
  def index
    puts "*****************************assignments"
  end
  
  def show
    @assignments_session = Assignment.find(params[:id])
    
    puts "*******************"
    puts @assignments_session.id
    
    @attendees = Attendee.where(assignments_id: @assignments_session.id)
    
    @attendees.each do |attendee|
      puts attendee.name
    end
  end
end
