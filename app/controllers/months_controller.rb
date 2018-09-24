class MonthsController < ApplicationController

  def create
    @year = Year.find(params[:year_id])
    if @year.months.select{|month| month.month_name == month_params[:month_name]}.empty?
      @year.months.create(month_params)
    else
      flash[:notice] = "Month already exists"
    end
    redirect_to :back
  end

  def destroy
    @year = Year.find(params[:year_id])
    @month = Month.find(params[:id])
    @month.destroy
    redirect_to year_path(@year)
  end

  def index
    @months = Month.all
  end

  def month_type
    if @month.month_name == "February"
      (1..28).to_a
    else
      (1..31).to_a
    end
  end

  def current_month?(month_name)
    @month = Month.find(params[:id])
    month_name == @month.month_name ? true : false
  end

  def calendar_months(year)
    @all_month = {}
    Date::MONTHNAMES[1..-1].each do |month_name|
      @all_month[month_name] = [false, current_month?(month_name)]
    end
    year.months.where.not(created_at: nil).each do |month|
      @all_month[month.month_name] = [true, current_month?(month.month_name)]
    end
  end

  def calendar_days(month)
    @all_days = {}
    (1..30).to_a.each do |month_day|
      @all_days[month_day] = false
    end
    @month.days.where.not(created_at: nil).each do |day|
      @all_days[day.created_at.day] = true
    end
  end

  def show
    @year = Year.find(params[:year_id])
    @month = Month.find(params[:id])
    calendar_days(@month)
    calendar_months(@year)
    @days_collection = month_type - @month.days.map(&:day_number)
    @status_hash = {}
    @sug = @month.days.map{|day| day.sugar_levels.map{|sl| sl.status }}
    @status_hash[:Low] = @sug.flatten.count("Low")
    @status_hash[:High] = @sug.flatten.count("High")
    @status_hash[:Normal] = @sug.flatten.count("Normal")
    @total = []
    @month.days.each do |day|
      mmols = day.sugar_levels.map {|e| e.mmol}
      time  = day.sugar_levels.map {|e| e.created_at}
      @total << {name: "#{day.created_at.day}", data: time.zip(mmols).to_h, type: "area"}
    end
  end

  private

  def month_params
    params.require(:month).permit(:compensation, :month_name, :year_id, :id, :user_id)
  end

end
