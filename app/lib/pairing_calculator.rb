class PairingCalculator
  def calculate(assignment, male_attendees, female_attendees)
    pairings_by_round = []
    mingle_table_by_round = []
    pairings_already_done = []

    number_of_assignments_needed = [assignment.num_tables, male_attendees.count, female_attendees.count].min

    assignment.num_rounds.times do |n|
      need_to_rerun_pairing = true
      number_of_reruns = 0
      max_num_of_reruns = 10000

      while need_to_rerun_pairing && number_of_reruns < max_num_of_reruns
        assignments_for_round = []
        males_already_paired = []
        females_already_paired = []
        minglers = []

        minglers_from_previous_round = mingle_table_by_round[n - 1]
        if minglers_from_previous_round.present? && minglers_from_previous_round.length > 0
          minglers_from_previous_round.each do |attendee_who_mingled_last_round|
            if attendee_who_mingled_last_round.gender == "male"
              male_attendees = move_attendee_to_start_of_line(attendee_who_mingled_last_round, male_attendees)
            else
              female_attendees = move_attendee_to_start_of_line(attendee_who_mingled_last_round, female_attendees)
            end
          end
        end

        male_attendees_to_match = male_attendees.slice(0..number_of_assignments_needed - 1).shuffle
        male_attendees_to_match.each do |male_attendee|
          female_attendees_not_matched_with_male_in_prior_assignment = calculate_non_exclusion_list(male_attendee, female_attendees)
          female_attendees_not_matched_with_male_in_prior_assignment.each do |female_attendee|
            pairing_string = "#{male_attendee[:first_name]}#{male_attendee[:last_name]}#{male_attendee[:id]} + #{female_attendee[:first_name]}#{female_attendee[:last_name]}#{female_attendee[:id]}"
            pairing_hash = {
              male_attendee_id: male_attendee[:id],
              female_attendee_id: female_attendee[:id]
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

          pairings_by_round.push(assignments_for_round)

          male_attendees.each do |male_attendee|
            minglers.push(male_attendee) unless males_already_paired.include?(male_attendee.id)
          end

          female_attendees.each do |female_attendee|
            minglers.push(female_attendee) unless females_already_paired.include?(female_attendee.id)
          end

          mingle_table_by_round.push(minglers)
        else
          if (number_of_reruns > (max_num_of_reruns * 0.9).to_i)
            pairings_already_done = pairings_already_done.drop(5)
          end

          male_attendees = male_attendees.shuffle
          female_attendees = female_attendees.shuffle
          number_of_reruns = number_of_reruns + 1
        end
      end
    end

    save_records!(assignment, pairings_by_round, mingle_table_by_round)

    return pairings_by_round, mingle_table_by_round
  end

  private

  def calculate_non_exclusion_list(male_attendee, female_attendees)
    female_attendees - Attendee.where(id: AssignmentMatch.where(male_attendee_id: male_attendee.id, is_mingler: false).pluck(:female_attendee_id))
  end
  def move_attendee_to_start_of_line(attendee, attendee_array)
    original_array_without_attendee = attendee_array.filter {|a| a.id != attendee.id}
    [attendee, original_array_without_attendee].flatten
  end

  def male_and_female_mingled_last_round?(male, female, minglers_from_previous_round)
    return false if minglers_from_previous_round.nil?
    minglers_from_previous_round.include?(male) && minglers_from_previous_round.include?(female)
  end

  def save_records!(assignment, pairings_by_round, mingle_table_by_round)
    ActiveRecord::Base.transaction do
      pairings_by_round.each_with_index do |pairings, index|
          pairings.each do |pairing|
            AssignmentMatch.create!(
              assignment_id: assignment.id,
              male_attendee_id: pairing[:male_attendee_id],
              female_attendee_id: pairing[:female_attendee_id],
              is_mingler: false,
              round: index
            )
          end
        end

        mingle_table_by_round.each_with_index do |minglers_by_round, index|
            minglers_by_round.each do |mingler|
              male_attendee_id = mingler.gender == "male" ? mingler.id : nil
              female_attendee_id = mingler.gender == "female" ? mingler.id : nil

              AssignmentMatch.create!(
                assignment_id: assignment.id,
                male_attendee_id: male_attendee_id,
                female_attendee_id: female_attendee_id,
                is_mingler: true,
                round: index
              )
            end
        end
      end
    end
  end