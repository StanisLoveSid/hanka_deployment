class Exercises::Operation::Create < Trailblazer::Operation
  step Model( Exercise, :new )
  step Contract::Build(constant: Exercises::Contract::Create)
  step Contract::Validate(key: :exercise)
  step Contract::Persist(method: :sync)
  step :set_date
  step :set_exercise
  step :calculate_duration
  step :set_time
  step :save_time

  def set_date(ctx, model:, **)
    ctx[:day] = Day.find(model.day_id)
    ctx[:month] = Month.find(ctx[:day].month_id)
    ctx[:year] = Year.find(ctx[:month].year_id)
  end

  def calculate_duration(ctx, model:, **)
    ctx[:duration] = TimeDifference.between(model.begining, model.ending).in_hours
  end

  def set_time(ctx, model:, day:, **)
    begining = model.begining.to_time
    ending = model.ending.to_time
    date_formating = lambda do |current_day, time|
      DateTime.new(current_day.year, current_day.month, current_day.day, time.hour, time.min)
                   .strftime('%Y-%m-%d %H:%M')
    end

    ctx[:ending] = date_formating.call(day.created_at, ending)
    ctx[:begining] = date_formating.call(day.created_at, begining)
  end

  def save_time(ctx, model:, duration:, begining:, ending:, **)
    model.update(duration: duration, begining: begining,
                    ending: ending, created_at: begining,
                    updated_at: ending)
  end

  def set_exercise(ctx, day:, **)
    ctx[:exercise] = day.exercises.last
  end
end

