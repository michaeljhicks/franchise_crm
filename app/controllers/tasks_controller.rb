class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task

  def toggle
    # Use the "bang" method to ensure we get an error if the save fails
    if @task.completed_at?
        @task.update!(completed_at: nil)
    else
        @task.update!(completed_at: Time.current)
    end

    # Simple, standard redirect. No more Turbo Streams.
    redirect_to @task.job, notice: "Task updated!"
    end

  private

  def set_task
    # This is the correct, secure way to find the task.
    @task = current_user.tasks.find(params[:id])
end
end