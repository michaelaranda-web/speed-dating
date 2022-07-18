class AssignmentsController < ApplicationController
  def index
    puts "*****************************assignments"
  end
  
  def show
    @pairings_by_round = []
    @mingle_table_by_round = []
    pairings_already_done = []
    
    @assignments_session = Assignment.find(params[:id])
    
    @male_attendees = Attendee.where(assignments_id: @assignments_session.id, gender: "M").shuffle
    @female_attendees = Attendee.where(assignments_id: @assignments_session.id, gender: "F").shuffle
    
    number_of_assignments_needed = [@assignments_session.num_tables, @male_attendees.count].min
    
    @assignments_session.num_rounds.times do |n|
      assignments_for_round = []
      males_already_paired = []
      females_already_paired = []
      minglers = []
      
      @male_attendees.slice(0..number_of_assignments_needed-1).each_with_index do |male_attendee, i|
        @female_attendees.each do |female_attendee|
          pairing_string = "#{male_attendee[:name]} + #{female_attendee[:name]}"
          if pairings_already_done.include?(pairing_string) || females_already_paired.include?(female_attendee.id)
            next
          else
            assignments_for_round.push("#{pairing_string} @ Table #{i+1}")
            pairings_already_done.push(pairing_string)
            males_already_paired.push(male_attendee.id)
            females_already_paired.push(female_attendee.id)
            break
          end
        end
      end
      
      @pairings_by_round.push(assignments_for_round)
      
      @male_attendees.each do |male_attendee|
        minglers.push(male_attendee) unless males_already_paired.include?(male_attendee.id)
      end
      
      @female_attendees.each do |female_attendee|
        minglers.push(female_attendee) unless females_already_paired.include?(female_attendee.id)
      end
      
      @mingle_table_by_round.push(minglers)
    end
  end
end
