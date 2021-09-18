require "logger"
require "json"
require "active_support"

class AppFormatter < ::Logger::Formatter
  include ActiveSupport::TaggedLogging::Formatter

  DEFAULT_PARAMS_PROC = proc { {} }

  attr_writer :params_proc

  def initialize(*_args)
    super
    @params_proc = nil
  end

  def call(severity, time, progname, msg)
    message_params = {}
    message_params[:severity] = severity
    message_params[:time] = time
    message_params[:progname] = progname
    message_params[:message] = msg2str(msg)
    message_params.merge!(build_params)

    # JSONで出力する
    "#{message_params.to_json}\n"
  end

  def self.global_formatter
    @global_formatter ||= self.new
  end

  private def build_params
    params_proc = @params_proc || DEFAULT_PARAMS_PROC
    params = params_proc.call
    raise ArgumentError, "request_info should be a Hash. it was #{params.inspect}" unless params.is_a? Hash

    params
  end

  private def msg2str(msg)
    case msg
    when ::String
      msg
    when ::Exception
      "#{msg.message} (#{msg.class}) #{msg.backtrace.inspect}"
    else
      msg.inspect
    end
  end
end
