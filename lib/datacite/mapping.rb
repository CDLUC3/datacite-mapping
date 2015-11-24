module Datacite
  module Mapping

    Dir.glob(File.expand_path('../mapping/*.rb', __FILE__)).sort.each(&method(:require))

    class << self
      attr_writer :log
    end

    def self.log
      self.log_device = $stdout unless @log
      @log
    end

    def self.log_device=(value)
      @log = new_logger(logdev: value)
    end

    private

    def self.new_logger(logdev:, level: Logger::DEBUG, shift_age: 10, shift_size: 1024 * 1024)
      logger = Logger.new(logdev, shift_age, shift_size)
      logger.level = level
      logger.formatter = proc do |severity, datetime, progname, msg|
        "#{datetime.to_time.utc} #{severity} -#{progname}- #{msg}\n"
      end
      logger
    end
  end
end
