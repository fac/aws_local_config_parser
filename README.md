# AwsLocalConfigParser

Parse your local `"$HOME"/.aws/config` to use it within a Ruby script.

## Up and Running
1. Checkout this repo: `gh repo clone fac/aws_local_config_parser`
1. Run: `bin/setup`
1. Run: `bin/demo`

## Usage
See [`demo`](./bin/demo) for examples on how to use the gem.

Supports parsing and returning:
- Profiles with SSO
- Profiles with Access Key + Secret
- SSO Sessions

``` ruby
require 'aws_local_config_parser'

config = AwsLocalConfigParser.new

# Profile with SSO
my_sso_profile = config.profile('my-sso-profile-name')
my_sso_profile.sso_session
my_sso_profile.sso_account_id
my_sso_profile.sso_role_name
my_sso_profile.region

## Profile with Access Key + Secret
non_sso_profile = config.profile('my-non-sso-profile-name')
non_sso_profile.aws_access_key_id
non_sso_profile.aws_secret_access_key
non_sso_profile.region

## SSO Session
my_sso_session = config.sso_session('sso-session')
my_sso_session.sso_start_url
my_sso_session.sso_registration_scopes
my_sso_session.sso_region

## Listing all names
config.all_profiles
config.all_sso_sessions
```

## Making a commit
[Lefthook](https://github.com/evilmartians/lefthook/) has [been configured](./lefthook.yml) with pre-commit checks to:
- run `rubocop` for any `ruby` files

If for some reason it's necessary, it's possible to temporarily skip `lefthook` with: `LEFTHOOK=0 git commit`.

### Create a new release
Following (Sematic Versioning)[https://semver.org/], bump the version:
1. `gem bump --version "<sem_ver_bump>"`and merge the changes to `main`
1. The [Release and Build Gem](https://github.com/fac/aws_local_config_parser/actions/workflows/release_gem.yml) wokflow will trigger a new version build
1. Manually create a new [release](https://github.com/fac/int-env-management-module/releases):
  1. Click on `Draft a new release`
  1. In the `Choose a tag` dropdown, selecting the new version
  1. Click `Generate release notes` and review the notes
  1. Ensure `Set as the latest release` is checked
  1. Click `Publish release`
