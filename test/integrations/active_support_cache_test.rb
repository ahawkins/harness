require_relative '../test_helper'
require 'harness/integration/active_support_cache'

class ActiveSupportCacheIntegration < MiniTest::Unit::TestCase
  attr_reader :cache

  class InstrumentedCache < ActiveSupport::Cache::MemoryStore
    self.instrument = true
  end

  def setup
    super
    @cache = InstrumentedCache.new
  end

  def test_fetch_counts_as_misses
    cache.fetch 'foo' do
      'bar'
    end

    assert_increment 'cache.miss'
  end

  def test_fetch_hits_count_as_hits
    cache.fetch 'foo' do
      'bar'
    end

    cache.fetch 'foo' do
      'bar'
    end

    assert_increment 'cache.hit'
  end

  def test_reads_and_writes_count_correctly
    cache.read 'foo'
    assert_increment 'cache.miss'

    cache.write 'foo', 'bar'
    cache.read 'foo'
    assert_increment 'cache.hit'
  end
end
