if Rails.env.production?
  Rails.application.config.xray = {
    # default segment name generated by XRay middleware
    name: "ecs-rails-sample",
    patch: %I[net_http aws_sdk],
    # record db transactions as subsegments
    active_record: true,
    context_missing: "LOG_ERROR",
  }
end
