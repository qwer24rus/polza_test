RSpec.configure do |config|
  require "capybara/cuprite"
  Capybara.javascript_driver = :cuprite
  Capybara.register_driver(:cuprite) do |app|
    Capybara::Cuprite::Driver.new(app,
                                  window_size: [1200, 800],
                                  browser_options: {
                                    'lang' => 'en-US',
                                    'blink-settings' => 'imagesEnabled=false',
                                    'disable-gpu' => nil,
                                    'disable-dev-shm-usage' => nil,
                                    'disable-infobars' => nil,
                                    'disable-extensions' => nil,
                                    'disable-popup-blocking' => nil
                                  },
                                  process_timeout: 200,
                                  timeout: 30,
                                  inspector: true,
                                  js_errors: false,
                                  headless: !ENV['HEADLESS'].in?(%w[n 0 no false]),
    )
  end
end