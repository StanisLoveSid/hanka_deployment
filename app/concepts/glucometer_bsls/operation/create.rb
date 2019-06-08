class GlucometerBsls::Operation::Create < Trailblazer::Operation
  step Model( GlucometerBsl, :new )  
  step Contract::Build(constant: GlucometerBsls::Contract::Create)
  step Contract::Validate(key: :sugar_level)
  step Contract::Persist()
  step :set_up_date
  step :find_user
  step :find_or_create_year
  step :find_or_create_month
  step :find_or_create_day
  step :create_bsl  

  def set_up_date(ctx, params:, **)
    ctx[:found_year] = 0
    ctx[:found_month] = 0
    ctx[:found_day] = 0
    ctx[:date] = params[:sugar_level][:date].to_datetime
  end

  def find_user(ctx, params:, **)
    ctx[:user] = User.find_by(email: params[:sugar_level][:email])
  end

  def find_or_create_year(ctx, **)
    if ctx[:user].years.map(&:year_number).include? ctx[:date].year
      user_years = ctx[:user].years.map {|year| { year.year_number => year.id } }
      user_years.each { |year| ctx[:found_year] = Year.find year[ctx[:date].year] unless year[ctx[:date].year].nil? }
    else
      ctx[:found_year] = Year.create(user_id: ctx[:user].id, created_at: ctx[:date], year_number: ctx[:date].year)
    end
  end

  def find_or_create_month(ctx, params:, **)
    if ctx[:found_year].months.map{|month| month.created_at.strftime("%Y-%m") }.include? params[:sugar_level][:date].to_date.strftime("%Y-%m")
      all_months = ctx[:found_year].months.map { |month| { month.created_at.month => month.id } }
      all_months.each { |month| ctx[:found_month] = Month.find month[ctx[:date].month]  unless month[ctx[:date].month].nil? }
    else
      ctx[:found_month] = Month.create(year_id: ctx[:found_year].id, user_id: ctx[:user].id, month_name: Date::MONTHNAMES[ctx[:date].month], created_at: ctx[:date])
    end
  end

  def find_or_create_day(ctx, params:, **)
    if ctx[:found_month].days.map(&:created_at).include? params[:sugar_level][:date].to_date
      all_days =  ctx[:found_month].days.map { |day| { day.day_number => day.id } }
      all_days.each { |day| ctx[:found_day] = Day.find day[ctx[:date].day]  unless day[ctx[:date].day].nil? }
    else
      ctx[:found_day] = Day.create(day_number: ctx[:date].day, created_at: ctx[:date], user_id: ctx[:user].id, month_id: ctx[:found_month].id)
    end
  end

  def create_bsl(ctx, params:, **)
    ctx[:found_day].sugar_levels.create(mmol: params[:sugar_level][:mmol], created_at: ctx[:date])
  end
end
