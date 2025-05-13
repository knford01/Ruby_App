class DreamsController < ApplicationController
  def new
    @dream = Dream.new
  end

  def create
    @dream = Dream.new(dream_params)
    client = OpenAI::Client.new

    prompt = <<~PROMPT
      Rewrite the following dream description in a clear, readable format.
      Then extract 5 keywords that best describe the dream content.

      Dream: "#{@dream.raw_text}"
    PROMPT

    response = client.chat(
      parameters: {
        model: "gpt-4",
        messages: [{ role: "user", content: prompt }],
        temperature: 0.7
      }
    )

    if response.dig("choices", 0, "message", "content")
      ai_response = response["choices"][0]["message"]["content"]
      lines = ai_response.split("\n").reject(&:blank?)
      @dream.ai_summary = lines.first.strip
      @dream.ai_keywords = lines.drop(1).join(', ')
      @dream.save
      redirect_to dream_path(@dream)
    else
      flash[:error] = "AI failed to respond."
      render :new
    end
  end

  def destroy
    @dream = Dream.find(params[:id])
    @dream.destroy
    redirect_to dreams_path, notice: "Dream deleted successfully."
  end

  def index
    @dreams = Dream.order(created_at: :desc)
  end

  def show
    @dream = Dream.find(params[:id])
  end

  def search
    query = params[:q]
    @dreams = Dream.where("raw_text ILIKE ? OR ai_summary ILIKE ? OR ai_keywords ILIKE ?", "%#{query}%", "%#{query}%", "%#{query}%")
    render :index
  end

  private

  def dream_params
    params.require(:dream).permit(:raw_text)
  end
end
