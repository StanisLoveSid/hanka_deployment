class YearsController < ApplicationController

  def create
    @user = current_user
    if Year.all.select{|year| year.year_number == year_params[:year_number].to_i }.empty?
      current_user.years.create(year_params)
    else
      flash[:notice] = "Year already exists"
    end
    redirect_to :root
  end

  def destroy
    @year = Year.find(params[:id])
    @year.destroy
    redirect_to :root
  end

  def show
    @year = Year.find(params[:id])
    @total = []
    all_user_mmols = []
    all_user_times = []
    @year.months.each do |month|
      month.days.each do |day|
        all_user_mmols << day.sugar_levels.map {|e| e.mmol}
        all_user_times << day.sugar_levels.map {|e| e.created_at}
      end
      @total << {name: "#{month.month_name}", data: all_user_times.flatten.zip(all_user_mmols.flatten).to_h, type: "area"}
      all_user_mmols = []
      all_user_times = []
    end

    @status_hash = {}
    @sug = @year.months.map{|month| month.days.map{|day| day.sugar_levels.map{|sl| sl.status} }}
    @status_hash[:Low] = @sug.flatten.count("High")
    @status_hash[:High] = @sug.flatten.count("Low")
    @status_hash[:Normal] = @sug.flatten.count("Normal")
    @month_names = Date::MONTHNAMES[1..-1] - @year.months.map(&:month_name)
  end

  module Selectors
    def without_emty_slots
      select { |k, v| v != 0 }
    end
  end

  Hash.class_eval { include Selectors }

  def scopes
    @random_day_sample = Day.order("RANDOM()").includes(:bsl_predictions).where.not(bsl_predictions: {prediction: nil}).first
    @years = Year.all
    @year_collection = (1990..Time.now.year).to_a - Year.all.map(&:year_number)
    @s_l = @random_day_sample.sugar_levels.group_by_minute(:created_at).sum(:mmol)
    @result = @s_l.without_emty_slots
    @meals = @random_day_sample.meals.group_by_minute(:created_at).sum(4)
    @meals_result = @meals.without_emty_slots
    @insulin = @random_day_sample.insulin_injections.group_by_minute(:created_at).sum(3)
    @insulin_result = @insulin.without_emty_slots
    @exercise_start = @random_day_sample.exercises.group_by_minute(:begining).sum(10)
    @exercise_end = @random_day_sample.exercises.group_by_minute(:ending).sum(10)
    @warning_start = @random_day_sample.warninggs.where("reason = ?", "start").group_by_minute(:created_at).sum(15)
    @warning_end = @random_day_sample.warninggs.where("reason = ?", "end").group_by_minute(:created_at).sum(15)
    @prediction = @random_day_sample.bsl_predictions.any? ? @random_day_sample.bsl_predictions.last.prediction.round(2) : 0
  end

  def index
    scopes
    @status_hash = {}
    if user_signed_in?
      current_user.years.each do |year|
        year.months.each do |month|
          month.days.each do |day|
            sug = day.sugar_levels.map { |sl| sl.status }
            if @status_hash.empty?
              @status_hash[:Low] = sug.flatten.count("Low")
              @status_hash[:High] = sug.flatten.count("High")
              @status_hash[:Normal] = sug.flatten.count("Normal")
            else
              @status_hash[:Low] += sug.flatten.count("Low")
              @status_hash[:High] += sug.flatten.count("High")
              @status_hash[:Normal] += sug.flatten.count("Normal")
            end
          end
        end
      end
    end
    @total = []
    all_user_mmols = []
    all_user_times = []
    if user_signed_in?
      current_user.years.each do |year|
        year.months.each do |month|
          month.days.each do |day|
            all_user_mmols << day.sugar_levels.map {|e| e.mmol}
            all_user_times << day.sugar_levels.map {|e| e.created_at}
          end
        end
        @total << {name: "#{year.year_number}", data: all_user_times.flatten.zip(all_user_mmols.flatten).to_h, type: "area"}
        all_user_mmols = []
        all_user_times = []
      end
    end
    @users = User.where(role: "patient").page params[:page]
  end

  private

  def year_params
    params.require(:year).permit(:description, :year_number, :user_id)
  end

end
