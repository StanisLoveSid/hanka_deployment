class Exercise::Create < Trailblazer::Operation
  step :process!

  def process!(options, day)
    day = Day.find(options['params'][:day_id])
    day.exercises.create(options['params'].require(:exercise).permit(:status, :begining, :ending, :description, :created_at, :day_id, :id))
    last_exercise = day.exercises.last
    duration = TimeDifference.between(last_exercise.begining, last_exercise.ending).in_hours
    time_creation_begining = "#{day.created_at.year}"+"-"+
      "#{day.created_at.month}"+"-"+"#{day.created_at.day} #{options['params'][:exercise][:begining]}"
    time_creation_ending = "#{day.created_at.year}"+"-"+
      "#{day.created_at.month}"+"-"+"#{day.created_at.day} #{options['params'][:exercise][:ending]}"
    last_exercise.update(duration: duration, begining: time_creation_begining,
                         ending: time_creation_ending, created_at: time_creation_begining,
                         updated_at: time_creation_ending)
  end
end

# class Exercise::Create < Trailblazer::Operation
#   step :create_exercise
#   step :calculate_duration
#   step :set_begining
#   step :set_ending
#   step :save_time

#   def save_time(duration)
#     exercise.update(duration: duration, begining: time_creation_begining,
#                     ending: time_creation_ending, created_at: time_creation_begining,
#                     updated_at: time_creation_ending)
#   end

#   def set_ending(options, day)
#     "#{day.created_at.year}"+"-"+"#{day.created_at.month}"+"-"+"#{day.created_at.day} #{options['params'][:exercise][:ending]}"
#   end

#   def set_begining(options, day)
#     "#{day.created_at.year}"+"-"+"#{day.created_at.month}"+"-"+"#{day.created_at.day} #{options['params'][:exercise][:begining]}"
#   end

#   def calculate_duration(exercise)
#     save_time TimeDifference.between(exercise.begining, exercise.ending).in_hours
#   end

#   def create_exercise(options, day)
#     calculate_duration day.exercises.create(options['params'].require(:exercise).permit(:status, :begining, :ending, :description, :created_at, :day_id, :id))
#   end
# end
