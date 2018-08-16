require "test_helper"

class Yactivestorage::FilenameTest < ActiveSupport::TestCase
  test "sanitize" do
    "%$|:;/\t\r\n\\".each_char do |character|
      filename = Yactivestorage::Filename.new("foo#{character}bar.pdf")
      assert_equal 'foo-bar.pdf', filename.sanitized
      assert_equal 'foo-bar.pdf', filename.to_s
    end
  end

  test "sanitize transcodes to valid UTF-8" do
    { "\xF6".force_encoding(Encoding::ISO8859_1) => "ö",
      "\xC3".force_encoding(Encoding::ISO8859_1) => "Ã",
      "\xAD" => "�",
      "\xCF" => "�",
      "\x00" => "",
    }.each do |actual, expected|
      assert_equal expected, Yactivestorage::Filename.new(actual).sanitized
    end
  end

  test "strings RTL override chars used to spoof unsafe excutables as docs" do
    # Would be displayed in Windows as "evilexe.pdf" due to the right-to-left
    # (RTL) override char!
    assert_equal 'evil-fdp.exe', Yactivestorage::Filename.new("evil\u{202E}fdp.exe").sanitized
  end

  test "compare case-insensitively" do
    assert_operator Yactivestorage::Filename.new('foobar.pdf'), :==, Yactivestorage::Filename.new('Foobar.PDF')
  end

  test "compare sanitized" do
    assert_operator Yactivestorage::Filename.new('foo-bar.pdf'), :==, Yactivestorage::Filename.new("foo\tbar.pdf")
  end
end
