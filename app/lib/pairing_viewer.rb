class PairingViewer
  def views(assignment)
    pairings_by_round = []
    mingle_table_by_round = []

    assignment.num_rounds.times do |index|
      assignments_for_round = []
      minglers_for_round = []

      assignment_matches = AssignmentMatch.where(assignment_id: assignment.id, round: index)

      assignment_matches.each do |assignment_match|
        if assignment_match.is_mingler?
          attendee = if (assignment_match.female_attendee_id)
                      Attendee.find_by_id(assignment_match.female_attendee_id)
                     else
                       Attendee.find_by_id(assignment_match.male_attendee_id)
                     end

          minglers_for_round.push(attendee)
        else
          male_attendee = Attendee.find_by_id(assignment_match.male_attendee_id)
          female_attendee = Attendee.find_by_id(assignment_match.female_attendee_id)

          pairing_hash = {
            male: "#{male_attendee[:first_name]} #{male_attendee[:last_name][0]}.",
            female: "#{female_attendee[:first_name]} #{female_attendee[:last_name][0]}."
          }

          assignments_for_round.push(pairing_hash)
        end
      end

      pairings_by_round.push(assignments_for_round)
      mingle_table_by_round.push(minglers_for_round)
    end

    return pairings_by_round, mingle_table_by_round
  end
end