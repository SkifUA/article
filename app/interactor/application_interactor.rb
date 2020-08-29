class ApplicationInteractor
  include Interactor

  # For exception notification
  class_attribute :notify_about_exception, instance_writer: false, instance_reader: false, default: true

  # Set default callbacks
  def self.inherited(klass)
    klass.class_eval do
      before :validation
      around :interactor_logging
    end
  end

  # Call with exception
  def self.call!(context = {})
    result = self.call(context)
    if result.success?
      result
    else
      raise ApplicationInteractor::CallError.new("#{self.name} - Error in calling: #{result.errors}", result)
    end
  end

  # Run Interactor in background job
  def self.call_later(context = {}, opt = {})
    ApplicationInteractor::Job.set(opt).perform_later(handler: self.name, context: context)
  end

  # Wrapper to Interactor.call
  # Set general logs: Start/Finish and send exception to admin
  def interactor_logging(interactor)
    Rails.logger.info "#{self.class} START"
    context.interactor_start_time = Time.now
    # run current interactor
    interactor.call
  rescue => exp
    Rails.logger.error "#{self.class}.#{__method__} ERROR #{exp.message}"
    Rails.logger.error exp.backtrace.join($/)

    context.fail!(errors: context.errors || :error, exp: exp)
  ensure
    context.interactor_finish_time = Time.now
    execution_time = ((context.interactor_finish_time.to_f - context.interactor_start_time.to_f) * 1000).to_i

    if context.success?
      Rails.logger.info("#{self.class} FINISH. TIME: #{execution_time}, SUCCESS: #{context.success?}")
    else
      Rails.logger.error("#{self.class} FINISH. TIME: #{execution_time}, SUCCESS: #{context.success?}, ERRORS: #{context.errors}")
    end
  end

  # Default validator to Current Interactor
  def validation
    # Rails.logger.debug "#{self.class}.#{__method__} Default validator is empty"
  end


  # General ApplicationInteractor errors
  class Error < StandardError
  end

  # General Error in calling
  class CallError < Error
    attr_reader :context

    def initialize(message, context = nil)
      @context = context
      super(message)
    end
  end

end