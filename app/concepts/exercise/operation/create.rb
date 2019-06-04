class Exercise::Create < Trailblazer::Operation
  step :set_day
  step :set_month
  step :set_year
  step Model( Exercise, :new )
  step :override_params
  step Contract::Build( constant: Exercise::Contract::Create )
  step Contract::Validate(key: 'exercise')
  step Contract::Persist(method: :sync)
  step :calculate_duration
  step :set_begining
  step :set_ending
  step :save_time
  step :set_exercise

  def set_day(ctx, params:, **)
    ctx[:day] = Day.find(params[:day_id])
  end

  def set_month(ctx)
    ctx[:month] = Month.find(ctx[:day].month_id)
  end

  def set_year(ctx)
    ctx[:year] = Year.find(ctx[:month].year_id)
  end

  def override_params(ctx, params:, **)
    params[:exercise][:day_id] = params[:day_id]
  end

  def calculate_duration(ctx, model:, **)
    ctx[:duration] = TimeDifference.between(model.begining, model.ending).in_hours
  end

  def set_begining(ctx, params:, **)
    time = params[:exercise][:begining].to_time
    ctx[:begining] = DateTime.new(ctx[:day].created_at.year, ctx[:day].created_at.month, ctx[:day].created_at.day,
                                  time.hour, time.min).strftime('%Y-%m-%d %H:%M')
  end

  def set_ending(ctx, params:, **)
    time = params[:exercise][:ending].to_time
    ctx[:ending] = DateTime.new(ctx[:day].created_at.year, ctx[:day].created_at.month, ctx[:day].created_at.day,
                                  time.hour, time.min).strftime('%Y-%m-%d %H:%M')
  end

  def save_time(ctx, model:, **)
    model.update(duration: ctx[:duration], begining: ctx[:begining],
                    ending: ctx[:ending], created_at: ctx[:begining],
                    updated_at: ctx[:ending])
  end

  def set_exercise(ctx)
    ctx[:exercise] = ctx[:day].exercises.last(2).first
  end
end

