class Assignment < ApplicationRecord
    has_many :assignment_matches, dependent: :destroy
end
