class Exercise::Create < Trailblazer::Operation
  step Model( Exercise, :new )
  step Contract::Build( constant: Exercise::Contract::Create )
  step Contract::Validate()
  step Contract::Persist()
  step :create_exercise
  step :calculate_duration
  step :set_begining
  step :set_ending
  step :save_time

  def create_exercise(ctx, params:, **)
    ctx[:exercise] = ctx[:day].exercises.create(params[:exercise])
  end

  def calculate_duration(ctx)
    ctx[:duration] = TimeDifference.between(ctx[:exercise].begining, ctx[:exercise].ending).in_hours
  end

  def set_begining(ctx, params:, **)
    ctx[:begining] = "#{ctx[:day].created_at.year}"+"-"+
    "#{ctx[:day].created_at.month}"+"-"+"#{ctx[:day].created_at.day} #{params[:exercise][:begining]}"
  end

  def set_ending(ctx, params:, **)
    ctx[:ending] = "#{ctx[:day].created_at.year}"+"-"+
    "#{ctx[:day].created_at.month}"+"-"+"#{ctx[:day].created_at.day} #{params[:exercise][:ending]}"
  end

  def save_time(ctx)
    ctx[:exercise].update(duration: ctx[:duration], begining: ctx[:begining],
                    ending: ctx[:ending], created_at: ctx[:begining],
                    updated_at: ctx[:ending])
  end
end

