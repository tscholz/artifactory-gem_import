# Artifactory::GemImport

A command line tool for importing gems into a JFrog Artifactory gem repository server.

If you just want to copy gems from your existing GemServer to the Artifactory
you might want to have a look at the `gem mirror` command and the `jfrog` command
line utility that is able to upload your files too.

If you want to migrate you local gem repository over time and if you want to keep
your old GemServer kind of "mirrored" to the Artifactory, this tool might be useful
to you e.g. as part of the CI/CD pipeline when releasing gems.

## Installation

```ruby
gem 'artifactory-gem_import'
```

## Usage

Show gems not already present in the Artifactory.
```shell
$ artifactory-gem-import show-missing --source-repo https://your-repo.local/private --target-repo https://your-artifactory.local/gems-local --target-repo-api-key <api-key> [--only "+."]
```

Import gems into the Artifactory.
```shell
$ artifactory-gem-import import --source-repo https://your-repo.local/private --target-repo https://your-artifactory.local/gems-local --target-repo-api-key <api-key>  [--only "+."]
```

Delete gems from the Artifactory. It will NOT remove the `rubygems-update` gem as it seems to be needed to keep the gem repository working. 
```shell
$ artifactory-gem-import delete --target-repo https://your-artifactory.local/gems-local --target-repo-api-key <api-key>  [--only "+."]
```

Keep in mind that Artifactory needs some time to apply your changes.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/artifactory-gem_import. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/artifactory-gem_import/blob/master/CODE_OF_CONDUCT.md).


## Code of Conduct

Everyone interacting in the Artifactory::GemImport project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/artifactory-gem_import/blob/master/CODE_OF_CONDUCT.md).
