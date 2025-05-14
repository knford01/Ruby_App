class WorkEntriesController < ApplicationController
  before_action :set_work_day, only: [:new, :create, :destroy]
  before_action :set_work_entry, only: [:destroy]

  def new
    @work_entry = @work_day.work_entries.build  # Creating a new WorkEntry for the specific WorkDay
  end

  def create
    @work_day = WorkDay.find(params[:work_day_id])
    @work_entry = @work_day.work_entries.new(work_entry_params)

    if @work_entry.raw_text.present?
      ai_response = process_with_ai(@work_entry.raw_text)
      @work_entry.ai_summary = ai_response[:rewritten]
      @work_entry.ai_keywords = ai_response[:keywords]
    end

    if @work_entry.save
      redirect_to work_day_path(@work_day), notice: "Work entry saved with AI support!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @work_entry.destroy
    redirect_to work_day_path(@work_day), notice: "Work entry deleted successfully."
  end

  private

  def set_work_day
    @work_day = WorkDay.find(params[:work_day_id])  # This makes sure you're working with a specific WorkDay
  end

  def set_work_entry
    @work_entry = @work_day.work_entries.find(params[:id])
  end

  def work_entry_params
    params.require(:work_entry).permit(:raw_text)
  end

  def process_with_ai(text)
    prompt = "Rewrite this workplace activity to be clear and professional, then list 3-5 keywords: #{text}"
    response = OpenAI::Client.new.chat(
      parameters: {
        model: "gpt-4",
        messages: [{ role: "user", content: prompt }],
        temperature: 0.7
      }
    )

    content = response.dig("choices", 0, "message", "content")

    if content&.include?("Keywords:")
      rewritten, keywords = content.split("Keywords:")
      {
        rewritten: rewritten.strip,
        keywords: keywords.strip
      }
    else
      {
        rewritten: text,
        keywords: ""
      }
    end
  rescue => e
    Rails.logger.error("AI processing error: #{e.message}")
    {
      rewritten: text,
      keywords: ""
    }
  end

  def extract_keywords(text)
    text.split(" ").uniq.take(5).join(", ")
  end
end
