class AssignmentsController < ApplicationController
  def index
    puts "*****************************assignments"
  end
  
  def show
    assignment = Assignment.find(params[:id])
    @icebreaker_questions = IcebreakerQuestion.first(assignment.num_rounds)

    @pairings_by_round, @mingle_table_by_round = PairingViewer.new.views(assignment)
  end
  
  private


end
