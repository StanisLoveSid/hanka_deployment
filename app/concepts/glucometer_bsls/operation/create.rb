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
    ctx[:date] = params[:sugar_level][:date].to_datetime
  end

  def find_user(ctx, model:, **)
    ctx[:user] = User.find_by(email: model.email)
  end

  def find_or_create_year(ctx, date:, user:, **)
    if user.years.exists?( years: { year_number: date.year } )
      ctx[:found_year] = Year.find user.years.map {|year| { year.year_number => year.id } }
                                             .select { |year| year[date.year].present? }.first[date.year]
    else
      ctx[:found_year] = Year.create(user_id: user.id, created_at: date, year_number: date.year)
    end
  end

  def find_or_create_month(ctx, params:, found_year:, user:, date:, **)
    if found_year.months.map{|month| month.created_at.strftime("%Y-%m") }.include? params[:sugar_level][:date].to_date.strftime("%Y-%m")
      ctx[:found_month] = Month.find found_year.months.map { |month| { month.created_at.month => month.id } }
                                                      .select { |month| month[date.month].present? }.first[date.month]
    else
      ctx[:found_month] = Month.create(year_id: found_year.id, user_id: user.id, month_name: Date::MONTHNAMES[date.month], created_at: date)
    end
  end

  def find_or_create_day(ctx, params:, found_month:, date:, user:, **)
    if found_month.days.map(&:created_at).include? params[:sugar_level][:date].to_date
      ctx[:found_day] = Day.find found_month.days.map { |day| { day.day_number => day.id } }
                                                    .select { |day| day[date.day].present? }.first[date.day]
    else
      ctx[:found_day] = Day.create(day_number: date.day, created_at: date, user_id: user.id, month_id: found_month.id)
    end
  end

  def create_bsl(ctx, params:, found_day:, date:, **)
    found_day.sugar_levels.create(mmol: params[:sugar_level][:mmol], created_at: date)
  end
end
