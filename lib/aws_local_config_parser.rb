# frozen_string_literal: true

require_relative 'aws_local_config_parser/version'
require_relative 'aws_local_config_parser/errors'

require 'inifile'
require 'ostruct'

class AwsLocalConfigParser
  attr_accessor :config, :config_path

  def initialize(config_path: "#{ENV["HOME"]}/.aws/config")
    @config_path = config_path
    @config = read_config_file
  end

  def read_config_file
    raise AwsLocalConfigParser::NoAwsConfig.new(config_path:) unless File.exist?(config_path)

    IniFile.load(config_path)
  end

  def config_hash
    config.to_h
  end

  def profile(profile_name)
    raise NoMatchingProfile.new(profile_name:, config_path:) unless config.has_section?("profile #{profile_name}")

    OpenStruct.new(config_hash["profile #{profile_name}"])
  end

  def sso_session(sso_session)
    raise NoMatchingSsoSession.new(sso_session:, config_path:) unless config.has_section?("sso-session #{sso_session}")

    OpenStruct.new(config_hash["sso-session #{sso_session}"])
  end

  def all_sso_sessions
    list_of_sso_sessions = config_hash.keys.select { |entry| entry.start_with?('sso-session') }.sort
    list_of_sso_sessions.map { |sso_session| sso_session.gsub('sso-session ', '') }
  end

  def all_profiles
    list_of_profiles = config_hash.keys.select { |entry| entry.start_with?('profile') }.sort
    list_of_profiles.map { |profile| profile.gsub('profile ', '') }
  end
end
