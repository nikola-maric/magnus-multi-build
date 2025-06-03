require "minitest/autorun"
require "magnus_multi_build"

class TestMagnusMultiBuild < Minitest::Test
  def test_reverse_string
    result = RustStringUtils.reverse("hello")
    assert_equal "olleh", result
  end

  def test_reverse_empty_string
    result = RustStringUtils.reverse("")
    assert_equal "", result
  end

  def test_reverse_unicode
    result = RustStringUtils.reverse("café")
    assert_equal "éfac", result
  end
end