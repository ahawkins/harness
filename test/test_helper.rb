require 'simplecov'
SimpleCov.start

require 'harness'

require 'minitest/unit'
require 'minitest/pride'
require 'minitest/autorun'

require 'webmock/minitest'

WebMock.disable_net_connect!

Thread.abort_on_exception = true

Harness.test_mode = true
