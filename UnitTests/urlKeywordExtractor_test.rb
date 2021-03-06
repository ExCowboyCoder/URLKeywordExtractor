require 'test/unit'
require 'benchmark'
require_relative '../Core/DataEnrichers/url_keyword_extractor'


class UrlKeywordExtractorTests < Test::Unit::TestCase
  #Test URLS
  SIMPLE_TEST_URL ='https://www.google.com/search?q=What+is+the+weather+like+on+mars&aqs=chrome.0.69i57j0l3j69i62l2.10643j0&sourceid=chrome&ie=UTF-8'
  CASE_ONLY_TEST_URL = 'https://www.google.com/search?q=WhatIsTheWeatherLikeOnMars&aqs=chrome.0.69i57j0l3j69i62l2.10643j0&sourceid=chrome&ie=UTF-8'
  DIFFICULT_TEST_URL = 'https://www.google.com/search?q=whatistheweatherlikeonmars&aqs=chrome.0.69i57j0l3j69i62l2.10643j0&sourceid=chrome&ie=UTF-8'
  REAL_DATA_TEST_URL = 'http://national.citysearch.com/profile/605382452/murrieta_ca/real_goods_solar.html?publisher=freedirectoryguide&raid=89308492&c=000700000960d3614b4154491ca2957ced3f4fd342&cgrefid=678007fdb555440689670c6c68fc59b1'

  #Expected Test Results
  EXPECTED = {queryKeywords: %w(what is the weather like on mars),pathKeywords:%w(google search)}

  attr_accessor :extractor

  def setup
    @extractor =  UrlKeywordExtractor.new
  end

  def teardown
    # Do nothing
  end

  def test_extractor_exists
    assert_not_nil @extractor
  end

  def test_extractor_returns_hash
    keywords = @extractor.extract SIMPLE_TEST_URL, %w(aqs sourceid ie)
    assert keywords.kind_of?(Hash)
  end

  def test_correct_for_simple_test_path
    result = @extractor.extract(SIMPLE_TEST_URL, %w(aqs sourceid ie))
    assert_equal(EXPECTED[:pathKeywords], result[:pathKeywords])
  end

  def test_correct_for_simple_test_path
    result = @extractor.extract(SIMPLE_TEST_URL, %w(aqs sourceid ie))
    assert_equal(EXPECTED[:pathKeywords], result[:pathKeywords])
  end

  def test_correct_for_simple_test
    result = @extractor.extract(SIMPLE_TEST_URL, %w(aqs sourceid ie))
    assert_equal(EXPECTED[:queryKeywords], result[:queryKeywords])
  end

  def test_correct_for_case_only_test
    result = @extractor.extract(CASE_ONLY_TEST_URL, %w(aqs sourceid ie))
    assert_equal(EXPECTED[:queryKeywords], result[:queryKeywords])
  end

  def test_correct_for_difficult_test
    result = @extractor.extract(DIFFICULT_TEST_URL, %w(aqs sourceid ie))
    assert_equal(EXPECTED[:queryKeywords], result[:queryKeywords])
  end

  def test_real_world_url
    result = @extractor.extract(REAL_DATA_TEST_URL)
    p result
  end

  def test_performant_for_simple_test
    time = Benchmark.measure {@extractor.extract(SIMPLE_TEST_URL, %w(aqs sourceid ie))}
    assert time.real < 0.001
  end

  def test_performant_for_case_only_test
    time = Benchmark.measure {@extractor.extract(CASE_ONLY_TEST_URL, %w(aqs sourceid ie))}
    assert time.real < 0.001
  end

  def test_performant_for_difficult_test
    time = Benchmark.measure {@extractor.extract(DIFFICULT_TEST_URL, %w(aqs sourceid ie))}
    assert time.real < 0.005
  end



end