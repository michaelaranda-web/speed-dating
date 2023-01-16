  class ExclusionCreator
    def parse_csv(csv_text)
      csv = CSV.parse(csv_text, :headers => true)
      csv.each do |row|
        if (row[4].present? && row[5].present?)
          male_attendee_id = nil
          female_attendee_id = nil

          if (row[3].downcase == 'male')
            male_attendee_id = Attendee.find_by!(first_name: row[0], last_name: row[1], gender: 'male').id
            female_attendee_id = Attendee.find_by!(first_name: row[4], last_name: row[5], gender: 'female').id
          else
            female_attendee_id = Attendee.find_by!(first_name: row[0], last_name: row[1], gender: 'female').id
            male_attendee_id = Attendee.find_by!(first_name: row[4], last_name: row[5], gender: 'male').id
          end

          Exclusion.create!(female_attendee_id: female_attendee_id, male_attendee_id: male_attendee_id)
        end
      end
    end
  end