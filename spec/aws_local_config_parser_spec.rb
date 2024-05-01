# frozen_string_literal: true

RSpec.describe AwsLocalConfigParser do
  it 'has a version number' do
    expect(AwsLocalConfigParser::VERSION).not_to be nil
  end

  subject(:local_config_parser) { AwsLocalConfigParser.new(config_path:) }
  let(:config_path) { './spec/fixtures/aws/config' }

  describe '#initialize' do
    context 'when a config file exists' do
      it 'loads and parses the config' do
        expect { local_config_parser }.to_not raise_error
      end
    end

    context 'when a config file does not exist' do
      let(:config_path) { 'file/path/does/not/exist' }
      it 'raises an error' do
        expect { local_config_parser }.to raise_error(
          AwsLocalConfigParser::NoAwsConfig,
          /No AWS config file at: '#{config_path}'/
        )
      end
    end
  end

  describe '#profile' do
    let(:profile) { local_config_parser.profile(profile_name) }

    context 'when the profile exists in the config' do
      let(:profile_name) { 'sso-dev-full' }

      it 'returns the profile as a ruby object' do
        expect(profile.class).to be OpenStruct
      end

      it 'has an region' do
        expect(profile.region).to eq 'dev-profile region'
      end

      context 'when the profile is an sso profile' do
        it 'has a sso_session' do
          expect(profile.sso_session).to eq 'sso-dev'
        end

        it 'has a sso_account_id' do
          expect(profile.sso_account_id).to eq 'account_number_1234'
        end

        it 'has a sso_role_name' do
          expect(profile.sso_role_name).to eq 'sso_account_role_name'
        end
      end

      context 'when the profile is not an sso profile' do
        let(:profile_name) { 'non-sso-profile' }

        it 'has a aws_access_key_id' do
          expect(profile.aws_access_key_id).to eq 'aws_access_key_id_value'
        end

        it 'has a aws_secret_access_key' do
          expect(profile.aws_secret_access_key).to eq 'aws_secret_access_key_value'
        end
      end
    end

    context 'when the profile does not exists in the config' do
      let(:profile_name) { 'profile-does-not-exist' }

      it 'raises an error' do
        expect { local_config_parser.profile(profile_name) }.to raise_error(
          AwsLocalConfigParser::NoMatchingProfile,
          /No matching profile, '#{profile_name}', in '#{config_path}'/
        )
      end
    end
  end

  describe '#sso_session' do
    let(:sso_session) { local_config_parser.sso_session(sso_session_name) }

    context 'when the sso_session exists in the config' do
      let(:sso_session_name) { 'sso-dev' }

      it 'returns the profile as a ruby object' do
        expect(sso_session.class).to be OpenStruct
      end

      it 'has a region' do
        expect(sso_session.sso_region).to eq 'dev region'
      end

      it 'has a sso_start_url' do
        expect(sso_session.sso_start_url).to eq 'https://sso-dev.awsapps.com/start/'
      end

      it 'has a sso_registration_scopes' do
        expect(sso_session.sso_registration_scopes).to eq 'sso:account:access'
      end
    end

    context 'when the sso_session does not exists in the config' do
      let(:sso_session_name) { 'sso-session-does-not-exist' }

      it 'raises an error' do
        expect { sso_session }.to raise_error(
          AwsLocalConfigParser::NoMatchingSsoSession,
          /No matching sso-session, '#{sso_session_name}', in '#{config_path}'/
        )
      end
    end
  end

  describe '#all_sso_sessions' do
    it 'reruns a list of the sso_sessions' do
      expect(local_config_parser.all_sso_sessions).to match_array(%w[sso-dev sso-prod])
    end
  end

  describe '#all_profiles' do
    it 'reruns a list of the profiles' do
      expect(local_config_parser.all_profiles).to match_array(
        %w[
          non-sso-profile
          sso-dev-full
          sso-sandbox-full
          sso-stage-full
        ]
      )
    end
  end
end
