# frozen_string_literal: true

class AwsLocalConfigParser
  class NoAwsConfig < StandardError
    attr_reader :config_path

    def initialize(config_path:)
      @config_path = config_path
      super(msg: message)
    end

    def message
      "No AWS config file at: '#{config_path}'."
    end
  end

  class NoMatchingProfile < StandardError
    attr_reader :profile_name, :config_path

    def initialize(profile_name:, config_path:)
      @profile_name = profile_name
      @config_path = config_path
      super(msg: message)
    end

    def message
      "No matching profile, '#{profile_name}', in '#{config_path}'."
    end
  end

  class NoMatchingSsoSession < StandardError
    attr_reader :sso_session, :config_path

    def initialize(sso_session:, config_path:)
      @sso_session = sso_session
      @config_path = config_path
      super(msg: message)
    end

    def message
      "No matching sso-session, '#{sso_session}', in '#{config_path}'."
    end
  end
end
