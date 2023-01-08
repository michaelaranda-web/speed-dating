class AssignmentMatch < ApplicationRecord
    belongs_to :assignment, :class_name => "Assignment"
end
