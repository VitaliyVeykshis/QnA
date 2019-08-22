# frozen_string_literal: true

RSpec.configure do |config|
  config.use_transactional_fixtures = true

  config.before do |example|
    if example.metadata[:type] == :feature
      ThinkingSphinx::Test.init
      ThinkingSphinx::Test.start index: false
    end

    ThinkingSphinx::Configuration.instance.settings['real_time_callbacks'] =
      (example.metadata[:type] == :feature)
  end

  config.after do |example|
    if example.metadata[:type] == :feature
      ThinkingSphinx::Test.stop
      ThinkingSphinx::Test.clear
    end
  end
end
