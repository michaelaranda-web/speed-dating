#this class will parse the csv and either find or create the attendee returning a list of female and male attendees

class AttendeeFinder
    def parse_csv(csv_text)
      attendees = [];

      csv = CSV.parse(csv_text, :headers => true)
      csv.each do |row|
        attendee = Attendee.find_by(first_name: row[0], last_name: row[1], gender: row[3].downcase)

        if attendee.nil?
          attendee = Attendee.create(first_name: row[0], last_name: row[1], age: row[2].to_i, gender: row[3].downcase, phone_number: row[4])
        end

        attendees.push(attendee)
      end

      male_attendees = attendees.select { |attendee| attendee.gender == "male" }
      female_attendees = attendees.select { |attendee| attendee.gender == "female" }

      return male_attendees, female_attendees
    end
  end