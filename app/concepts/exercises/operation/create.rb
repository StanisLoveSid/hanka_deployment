class Exercises::Operation::Create < Trailblazer::Operation
  step :set_date
  step Model( Exercise, :new )
  step :override_params
  step Contract::Build(constant: Exercises::Contract::Create)
  step Contract::Validate(key: :exercise)
  step Contract::Persist(method: :sync)
  step :calculate_duration
  step :set_time
  step :save_time
  step :set_exercise

  def set_date(ctx, params:, **)
    ctx[:day] = Day.find_by(id: params[:day_id])
    ctx[:month] = Month.find(ctx[:day].month_id)
    ctx[:year] = Year.find(ctx[:month].year_id)
    rescue NoMethodError
      nil
  end

  def override_params(ctx, params:, **)
    params[:exercise][:day_id] = params[:day_id]
  end

  def calculate_duration(ctx, model:, **)
    ctx[:duration] = TimeDifference.between(model.begining, model.ending).in_hours
  end

  def set_time(ctx, model:, day:, **)
    begining = model.begining.to_time
    ending = model.ending.to_time
    date_formating = lambda do |day, time|
      DateTime.new(day.created_at.year, day.created_at.month, day.created_at.day, time.hour, time.min)
                   .strftime('%Y-%m-%d %H:%M')
    end

    ctx[:ending] = date_formating.call(day, ending)
    ctx[:begining] = date_formating.call(day, begining)
  end

  def save_time(ctx, model:, duration:, begining:, ending:, **)
    model.update(duration: duration, begining: begining,
                    ending: ending, created_at: begining,
                    updated_at: ending)
  end

  def set_exercise(ctx, params:, **)
    ctx[:exercise] = ctx[:day].exercises.last
  end
end

