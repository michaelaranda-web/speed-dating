class AssignmentsController < ApplicationController
  def index
    puts "*****************************assignments"
  end
  
  def show
    @pairings_by_round = []
    @mingle_table_by_round = []
    pairings_already_done = []
    
    @assignments_session = Assignment.find(params[:id])
    
    @male_attendees = Attendee.where(assignments_id: @assignments_session.id, gender: "male").shuffle
    @female_attendees = Attendee.where(assignments_id: @assignments_session.id, gender: "female").shuffle
    
    number_of_assignments_needed = [@assignments_session.num_tables, @male_attendees.count, @female_attendees.count].min
    
    @assignments_session.num_rounds.times do |n|
      need_to_rerun_pairing = true
      number_of_reruns = 0
      max_num_of_reruns = 10000
      
      while need_to_rerun_pairing && number_of_reruns < max_num_of_reruns
        people_to_match_for_round = []
        assignments_for_round = []
        males_already_paired = []
        females_already_paired = []
        minglers = []
        
        minglers_from_previous_round = @mingle_table_by_round[n-1]
        if minglers_from_previous_round.present? && minglers_from_previous_round.length > 0
          minglers_from_previous_round.each do |attendee_who_mingled_last_round|
            if attendee_who_mingled_last_round.gender == "male"
              @male_attendees = move_attendee_to_start_of_line(attendee_who_mingled_last_round, @male_attendees)
            else
              @female_attendees = move_attendee_to_start_of_line(attendee_who_mingled_last_round, @female_attendees)
            end
          end
        end
      
        @male_attendees.slice(0..number_of_assignments_needed-1).shuffle.each_with_index do |male_attendee, i|
          @female_attendees.each do |female_attendee|
            pairing_string = "#{male_attendee[:name]}#{male_attendee[:id]} + #{female_attendee[:name]}#{female_attendee[:id]}"
            pairing_hash = {
              male: male_attendee[:name],
              female: female_attendee[:name]
            }
            
            if (pairings_already_done.include?(pairing_string) && number_of_reruns != max_num_of_reruns) || females_already_paired.include?(female_attendee.id) || male_and_female_mingled_last_round?(male_attendee, female_attendee, minglers_from_previous_round)
              next
            else
              assignments_for_round.push(pairing_hash)
              
              pairings_already_done.push(pairing_string)
              
              males_already_paired.push(male_attendee.id)
              females_already_paired.push(female_attendee.id)
              break
            end
          end
        end
        
        if assignments_for_round.size == number_of_assignments_needed
          need_to_rerun_pairing = false
          
          assignments_for_round = assignments_for_round.shuffle
          
          @pairings_by_round.push(assignments_for_round)
          
          @male_attendees.each do |male_attendee|
            minglers.push(male_attendee) unless males_already_paired.include?(male_attendee.id)
          end
          
          @female_attendees.each do |female_attendee|
            minglers.push(female_attendee) unless females_already_paired.include?(female_attendee.id)
          end
          
          @mingle_table_by_round.push(minglers)
        else
          if (number_of_reruns > (max_num_of_reruns * 0.9).to_i)
            pairings_already_done = pairings_already_done.drop(5)
          end
          
          @male_attendees = @male_attendees.shuffle
          @female_attendees = @female_attendees.shuffle
          number_of_reruns = number_of_reruns + 1
        end
      end
    end
  end
  
  private
  
  def move_attendee_to_start_of_line(attendee, attendee_array)
    original_array_without_attendee = attendee_array.filter {|a| a.id != attendee.id}
    [attendee, original_array_without_attendee].flatten
  end
  
  def male_and_female_mingled_last_round?(male, female, minglers_from_previous_round)
    return false if minglers_from_previous_round.nil?
    minglers_from_previous_round.include?(male) && minglers_from_previous_round.include?(female)
  end
end
