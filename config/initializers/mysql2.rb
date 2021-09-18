require "mysql2"
require "socket"

module Mysql2Extension
  module Client
    def connect(user, pass, host, port, database, socket, flags, conn_attrs) # rubocop:disable Metrics/ParameterLists
      result = super(user, pass, host, port, database, socket, flags, conn_attrs)
      return result unless inspection_needed?

      logger.debug "  MySQL CONNECTED [#{object_id}] (#{host}/#{port}/#{database}/#{user}) : at #{silenced_caller}"
      @connection_created_time = Time.current
      result
    rescue Mysql2::Error => e
      raise e
    end

    def query(sql, options = {})
      logger.debug sql
      super
    rescue Mysql2::Error => e
      raise e
    end

    def close
      result = super
      return result unless inspection_needed?

      time_elapsed = Time.current - @connection_created_time
      logger.debug "  MySQL CLOSED    [#{object_id}] : (#{time_elapsed.to_f} sec) at #{silenced_caller}"
      result
    end

    private def silenced_caller
      cleaner.clean(caller(1))
    end

    private def logger
      @logger ||= Rails.logger
    end

    private def cleaner
      @cleaner ||= Rails.backtrace_cleaner
    end

    private def inspection_needed?
      ENV["RAILS_MYSQL_CONNECTION_INSPECTION"] == "1"
    end
  end
end
Mysql2::Client.prepend Mysql2Extension::Client
