class Exercise::Create < Trailblazer::Operation
  step Model( Exercise, :new )
  step :override_params
  step Contract::Build( constant: Exercise::Contract::Create )
  step Contract::Validate(key: 'exercise')
  step Contract::Persist(method: :sync)
  step :calculate_duration
  step :set_begining
  step :set_ending
  step :save_time


  def override_params(ctx, params:, **)
    params[:exercise][:day_id] = params[:day_id]
  end

  def calculate_duration(ctx, model:, **)
    binding.pry
    ctx[:duration] = TimeDifference.between(model.begining, model.ending).in_hours
  end

  def set_begining(ctx, params:, **)
    ctx[:begining] = "#{ctx[:day].created_at.year}"+"-"+
    "#{ctx[:day].created_at.month}"+"-"+"#{ctx[:day].created_at.day} #{params[:exercise][:begining]}"
    binding.pry
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

