require 'minitest/autorun'
require 'minitest/stub_const'
require 'gender_detector'

class GenderDetectorTest < MiniTest::Test
  def setup
    @d = GenderDetector.new
  end

  def test_get_gender
    assert_equal :male, @d.get_gender('Bob')
    assert_equal :female, @d.get_gender('Sally')
    assert_equal :andy, @d.get_gender('Pauley')
  end

  def test_get_gender_data
    assert_equal [
      {
           :gender => :male,
          :country => :the_netherlands,
        :frequency => 0.38
      }, {
           :gender => :male,
          :country => :usa,
        :frequency => 0.31
      }, {
           :gender => :male,
          :country => :ireland,
        :frequency => 0.23
      }, {
           :gender => :male,
          :country => :belgium,
        :frequency => 0.15
      }, {
           :gender => :male,
          :country => :great_britain,
        :frequency => 0.15
      }, {
           :gender => :male,
          :country => :norway,
        :frequency => 0.08
      }, {
           :gender => :male,
          :country => :swiss,
        :frequency => 0.08
      }
    ], @d.get_gender_data('Bob')
    assert_equal [ {
           :gender => :female,
          :country => :great_britain,
        :frequency => 0.46
      }, {
           :gender => :female,
          :country => :usa,
        :frequency => 0.38
      }, {
           :gender => :female,
          :country => :ireland,
        :frequency => 0.38
      }, {
           :gender => :female,
          :country => :denmark,
        :frequency => 0.23
      }, {
           :gender => :female,
          :country => :sweden,
        :frequency => 0.15
      }, {
           :gender => :female,
          :country => :the_netherlands,
        :frequency => 0.15
      }, {
           :gender => :female,
          :country => :belgium,
        :frequency => 0.15
      }
    ], @d.get_gender_data('Sally')
    assert_equal [
      {
           :gender => :andy,
          :country => :usa,
        :frequency => 0.08
      }
    ], @d.get_gender_data('Pauley')
  end

  def test_gender_international
    assert @d.knows_country?(:great_britain)
    assert_equal :female, @d.get_gender('Álfrún')
  end

  def test_country_specific_preference
    assert_equal :mostly_female, @d.get_gender('Jamie')
    # jamie oliver?
    assert_equal :mostly_male, @d.get_gender('Jamie', :great_britain)
    assert_equal [
      {
           :gender => :mostly_male,
          :country => :great_britain,
        :frequency => 0.31
      }
    ], @d.get_gender_data('Jamie', :great_britain)
  end

  def test_case_insensitivity
    d = GenderDetector.new(case_sensitive: false)
    assert_equal :female, d.get_gender('sally')
    assert_equal :female, d.get_gender('Sally')
  end

  def test_name_exists
    d = GenderDetector.new(case_sensitive: false)
    assert d.name_exists?('Sally')
    assert d.name_exists?('Carlos')
    assert d.name_exists?('Rosario')
  end

  def test_utf8
    d = GenderDetector.new(case_sensitive: false)
    assert_equal :male, d.get_gender('Bob')
    assert_equal :female, d.get_gender('ÁLFRÚN')
  end
end
