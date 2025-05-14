class WorkDaysController < ApplicationController
  before_action :set_work_day, only: [:show, :destroy]

  def index
    if params[:start_date] && params[:end_date]
      @work_days = WorkDay.where(entry_date: params[:start_date]..params[:end_date])
    else
      @work_days = WorkDay.all
    end
  end

  def show
    @work_entries = @work_day.work_entries
  end

  def new
    @work_day = WorkDay.new  # Initializes a new empty WorkDay object
  end

  def create
    @work_day = WorkDay.new(work_day_params)
    if @work_day.save
      redirect_to work_days_path, notice: "Work day created successfully."
    else
      render :new
    end
  end

  def destroy
    @work_day = WorkDay.find(params[:id])
    @work_day.destroy
    redirect_to work_days_path, notice: "Work day deleted successfully."
  end

  private

  def work_day_params
    params.require(:work_day).permit(:entry_date, :description)
  end

  def set_work_day
    @work_day = WorkDay.find(params[:id])
  end
end 
