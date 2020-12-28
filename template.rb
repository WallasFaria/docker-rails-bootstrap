uncomment_lines 'Gemfile', /gem 'redis'/
gem 'sidekiq'
gem 'dotenv'

gem_group :development do
  gem 'annotate'
  gem 'active_record_doctor'
  gem 'bundler-audit'
  gem 'overcommit'
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'rubycritic', require: false
  gem 'fasterer', require: false
  gem 'reek'
  gem 'rails_best_practices'
  gem 'brakeman', require: false
end

gem_group :development, :test do
  gem 'pry-rails'
  gem 'rspec-rails'
end

gem_group :test do
  gem 'shoulda-matchers'
  gem 'faker'
  gem 'factory_bot_rails'
  gem 'database_cleaner'
  gem 'cucumber-rails', require: false
end

after_bundle do
  # uncomment_lines 'config/puma.rb', /WEB_CONCURRENCY/
  # uncomment_lines 'config/puma.rb', /preload_app/

  generate('rspec:install')
  generate('cucumber:install')
  generate('annotate:install')

  inject_into_file '.gitignore' do
    <<~EOF
      /.env
      /.cache
      /.yarn
      /.bundle
      /.vscode
      /db/postgres/backup.dump
    EOF
  end

  environment do
    <<~RUBY
      config.i18n.default_locale = :'pt-BR'
      config.time_zone = 'UTC'
      config.active_job.queue_adapter = :sidekiq
      config.generators do |generator|
        generator.assets false
        generator.helper false
        generator.jbuilder false
      end
    RUBY
  end

  run 'mkdir -p db/postgres'

  copy_file __dir__ + '/template/init-db.sh', 'db/postgres/init-db.sh'
  copy_file __dir__ + '/template/action_mailer.rb', 'config/initializers/action_mailer.rb'
  copy_file __dir__ + '/template/overcommit.yml', '.overcommit.yml'
  copy_file __dir__ + '/template/sidekiq.yml', 'config/sidekiq.yml'
  copy_file __dir__ + '/template/rubocop.yml', '.rubocop.yml'
  copy_file __dir__ + '/template/fasterer.yml', '.fasterer.yml'
  copy_file __dir__ + '/template/config.reek', 'config.reek'

  run 'overcommit --install'

  inject_into_file 'spec/rails_helper.rb', after: 'RSpec.configure do |config|' do
    <<~RUBY
        config.include FactoryBot::Syntax::Methods

        config.before(:suite) do
          DatabaseCleaner.strategy = :transaction
          DatabaseCleaner.clean_with(:truncation)
        end

        Shoulda::Matchers.configure do |config|
          config.integrate do |with|
            with.test_framework :rspec
            with.library :rails
          end
        end
    RUBY
  end
end
