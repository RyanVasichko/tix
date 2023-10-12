if ENV["VERBOSE_SQL_LOGGING"]
  ActiveRecord::Base.logger = Logger.new(STDOUT)
end
