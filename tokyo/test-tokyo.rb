require 'minitest/autorun'
require 'open3'
require 'rbconfig'
require 'tmpdir'
require 'json'

class TokyoTest < Minitest::Test
  DIR = File.expand_path(__dir__)
  NAMES = %w[東京 神田 秋葉原 御徒町 上野 鶯谷 日暮里 西日暮里 田端 駒込 巣鴨 大塚 池袋 目白 高田馬場 新大久保 新宿 代々木 原宿 渋谷 恵比寿 目黒 五反田 大崎 品川 高輪ゲートウェイ 田町 浜松町 新橋 有楽町].freeze
  ENCODED = '#y$n*GxXRgFo)sM-m\'M-m8v&pSh+z.wUjN8Eu,+Lf,iKQlBi(sPJtUeTHn+qVkNYZ[]^_`8gIOg,rW%g'.scan(/.+?[a-z`]/).freeze

  def run_ruby(source, *args)
    out, err, status = Open3.capture3(RbConfig.ruby, '-', *args, stdin_data: source)
    assert status.success?, err
    assert_empty err
    out
  end

  def station(source)
    source[/\At=%w\{(.*?)\}\*"";/m, 1].delete(" \n").scan(/.+?[a-z`]/).last
  end

  def original_glyphs
    maker = File.read(File.join(DIR, 'tokyo-maker.rb'))
    font = maker[/F=%q\{(.*?)\};/m, 1]
    refute_includes font, ';;', 'Semicolon normalization must preserve the original compressed font'
    decoder = maker[ maker.index('w=3024;')...maker.index('c+=Zlib::Inflate') ]
    scope = Object.new.instance_eval { binding }
    eval("F=#{font.dump};" + decoder, scope)
    scope.local_variable_get(:c)
  end

  def assert_artwork(source, encoded, original, added)
    white = []
    encoded.chars.each_with_index do |ch, i|
      extra = 'YZ[]^_`'.index(ch)
      rows = if extra
        added.fetch('輪ゲートウェイ'[extra]).map { |row| row.chars.map { |pixel| pixel * 2 }.join }
      else
        j = ch.ord % 54 * 56
        Array.new(28) { |y| original[y * 3024 + j, 56].map { |pixel| pixel == 1 ? '#' : '.' }.join }
      end
      rows.each_with_index do |row, y|
        row.chars.each_with_index { |pixel, x| white << [15 + i * 38 + 9 + y, 10 + x] if pixel == '#' }
      end
    end
    actual = []
    source.lines[0...-2].each_with_index do |line, y|
      line.chomp.chars.each_with_index { |ch, x| actual << [y, x] if ch == ' ' }
    end
    assert_equal white, actual, 'Only the station glyphs may introduce spaces into the artwork'
  end

  def test_vertical_long_mark
    rows = JSON.parse(File.read(File.join(DIR, 'new-glyphs.json'))).fetch('ー')
    points = rows.each_with_index.flat_map { |row, y| row.chars.each_with_index.map { |pixel, x| [x, y] if pixel == '#' }.compact }
    xs, ys = points.transpose
    assert_operator ys.max - ys.min, :>, 4 * (xs.max - xs.min), 'The long mark must be vertical'
  end

  def test_generation_and_both_complete_cycles
    source = File.read(File.join(DIR, 'tokyo.rb'))
    original = original_glyphs
    added = JSON.parse(File.read(File.join(DIR, 'new-glyphs.json')))
    generated, err, status = Open3.capture3(RbConfig.ruby, File.join(DIR, 'tokyo-maker.rb'))
    assert status.success?, err
    assert_empty err
    assert_equal source, generated
    assert_equal ENCODED[0], station(source)
    Dir.mktmpdir('tokyo-quine') do |dir|
      Dir.chdir(dir) do
        [[], ['x']].each do |args|
          current = source
          step = args.empty? ? 1 : -1
          30.times do |i|
            assert_equal ENCODED[(i * step) % 30], station(current), NAMES[(i * step) % 30]
            assert current.lines.all? { |line| line.chomp.size == 76 }, '76 columns, including the header'
            assert_artwork(current, station(current), original, added)
            if station(current) == ENCODED[25]
              assert_equal 15 + 8 * 38 + 8 + 2, current.lines.size
              glyphs = JSON.parse(File.read(File.join(DIR, 'new-glyphs.json')))
              '輪ゲートウェイ'.chars.each_with_index do |ch, index|
                actual = current.lines[15 + (index + 1) * 38 + 9, 28].map { |row| row[10, 56].chars.map { |c| c == ' ' ? '#' : '.' }.join }
                expected = glyphs.fetch(ch).map { |row| row.chars.map { |c| c * 2 }.join }
                assert_equal expected, actual, ch
              end
            end
            current = run_ruby(current, *args)
          end
          assert_equal source, current, 'A full lap must reproduce the source byte for byte'
        end
        assert_equal source, run_ruby(run_ruby(source), 'x'), 'The two directions must undo each other'
      end
    end
  end
end
