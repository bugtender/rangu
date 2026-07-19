# frozen_string_literal: true

require "test_helper"

class RanguTest < Minitest::Test
  def test_spacing_does_not_modify_its_input
    input = "中文ABC"

    result = Rangu.spacing(input)

    assert_equal "中文 ABC", result
    assert_equal "中文ABC", input
    refute_same input, result
  end

  def test_spacing_accepts_frozen_input
    input = "中文ABC"

    assert_predicate input, :frozen?
    assert_equal "中文 ABC", Rangu.spacing(input)
  end

  def test_spacing_returns_a_new_string_when_no_spacing_is_needed
    input = "plain text"

    result = Rangu.spacing(input)

    assert_equal input, result
    refute_same input, result
  end

  def test_spacing_text_is_an_alias_for_spacing
    input = "中文ABC"

    result = Rangu.spacing_text(input)

    assert_equal Rangu.spacing(input), result
    assert_equal "中文ABC", input
    refute_same input, result
  end

  def test_spacing_treats_an_existing_path_as_text
    Tempfile.create("rangu") do |file|
      file.write("中文ABC")
      file.close

      result = Rangu.spacing(file.path)

      assert_equal file.path, result
      refute_same file.path, result
    end
  end

  def test_should_return_nice_spacing_text
    assert_equal "新八的構造成分有 95% 是眼鏡、3% 是水、2% 是垃圾", Rangu.spacing(+"新八的構造成分有95%是眼鏡、3%是水、2%是垃圾")
    assert_equal "所以, 請問 Jackey 的鼻子有幾個? 3.14 個!", Rangu.spacing(+"所以,請問Jackey的鼻子有幾個?3.14個!")
    assert_equal "JUST WE 就是 JUST WE，既不偉大也不卑微！", Rangu.spacing(+"JUST WE就是JUST WE，既不偉大也不卑微！")
    assert_equal "搭載 MP3 播放器，連續播放時數最長達到 124 小時的超強利刃…… 菊一文字 RX-7!", Rangu.spacing(+"搭載MP3播放器，連續播放時數最長達到124小時的超強利刃……菊一文字RX-7!")
    assert_equal "V", Rangu.spacing(+"V")
  end

  def test_can_spacing_with_text_file
    Tempfile.create("rangu") do |file|
      contents = "搭載MP3播放器，菊一文字RX-7!\nJUST WE就是JUST WE，既不偉大也不卑微！"
      file.write(contents)
      file.close

      result = Rangu.spacing_file(file.path)

      assert_equal "搭載 MP3 播放器，菊一文字 RX-7!\nJUST WE 就是 JUST WE，既不偉大也不卑微！", result
      assert_equal contents, File.read(file.path, encoding: Encoding::UTF_8)
    end
  end

  def test_spacing_file_propagates_file_errors
    assert_raises(Errno::ENOENT) { Rangu.spacing_file("missing-rangu-file.txt") }
  end

  def test_can_spacing_with_text
    assert_equal "Mr. 龍島主道：「Let's Party! 各位高明博雅君子！」", Rangu.spacing(+"Mr.龍島主道：「Let's Party!各位高明博雅君子！」")
  end

  def test_can_spacing_with_latin
    assert_equal "中文 Ø 漢字", Rangu.spacing(+"中文Ø漢字")
  end

  def test_can_spacing_with_general_punctuation
    assert_equal "中文 • 漢字", Rangu.spacing(+"中文•漢字")
  end

  def test_can_spacing_with_number_forms
    assert_equal "中文 Ⅶ 漢字", Rangu.spacing(+"中文Ⅶ漢字")
  end

  def test_can_spacing_with_cjk_radicals
    assert_equal "abc ⻤ 123", Rangu.spacing(+"abc⻤123")
  end

  def test_can_spacing_with_kangxi_radicals
    assert_equal "abc ⾗ 123", Rangu.spacing(+"abc⾗123")
  end

  def test_can_spacing_with_hiragana
    assert_equal "abc あ 123", Rangu.spacing(+"abcあ123")
  end

  def test_can_spacing_with_katakana
    assert_equal "abc ア 123", Rangu.spacing(+"abcア123")
  end

  def test_can_spacing_with_bopomofo
    assert_equal "abc ㄅ 123", Rangu.spacing(+"abcㄅ123")
  end

  def test_can_spacing_with_enclosed_cjk_letters_and_months
    assert_equal "abc ㈱ 123", Rangu.spacing(+"abc㈱123")
  end

  def test_can_spacing_with_cjk_unified_ideographs_extension_a
    assert_equal "abc 㐂 123", Rangu.spacing(+"abc㐂123")
  end

  def test_can_spacing_with_cjk_unified_ideographs
    assert_equal "abc 丁 123", Rangu.spacing(+"abc丁123")
  end

  def test_can_spacing_with_cjk_compatibility_ideographs
    assert_equal "abc 車 123", Rangu.spacing(+"abc車123")
  end

  def test_can_spacing_with_tilde
    assert_equal "前面~ 後面", Rangu.spacing(+"前面~後面")
    assert_equal "前面 ~ 後面", Rangu.spacing(+"前面 ~ 後面")
    assert_equal "前面~ 後面", Rangu.spacing(+"前面~ 後面")
  end

  def test_can_spacing_with_back_quote
    assert_equal "前面 ` 後面", Rangu.spacing(+"前面`後面")
    assert_equal "前面 ` 後面", Rangu.spacing(+"前面 ` 後面")
    assert_equal "前面 ` 後面", Rangu.spacing(+"前面` 後面")
  end

  def test_can_spacing_with_texclamation_mark
    assert_equal "前面! 後面", Rangu.spacing(+"前面!後面")
    assert_equal "前面 ! 後面", Rangu.spacing(+"前面 ! 後面")
    assert_equal "前面! 後面", Rangu.spacing(+"前面! 後面")
  end

  def test_can_spacing_with_at
    assert_equal "前面 @vinta 後面", Rangu.spacing(+"前面@vinta後面")
    assert_equal "前面 @vinta 後面", Rangu.spacing(+"前面 @vinta 後面")
    assert_equal "前面! 後面", Rangu.spacing(+"前面! 後面")

    assert_equal "前面 @陳上進 後面", Rangu.spacing(+"前面@陳上進 後面")
    assert_equal "前面 @陳上進 後面", Rangu.spacing(+"前面 @陳上進 後面")
    assert_equal "前面 @陳上進 tail", Rangu.spacing(+"前面 @陳上進tail")
  end

  def test_can_spacing_with_hash
    assert_equal "前面 #H2G2 後面", Rangu.spacing(+"前面#H2G2後面")
    assert_equal "前面 #銀河便車指南 後面", Rangu.spacing(+"前面#銀河便車指南 後面")
    assert_equal "前面 #銀河便車指南 tail", Rangu.spacing(+"前面#銀河便車指南tail")

    assert_equal "前面 #銀河公車指南 #銀河拖吊車指南 後面", Rangu.spacing(+"前面#銀河公車指南 #銀河拖吊車指南 後面")
    assert_equal "前面 #H2G2# 後面", Rangu.spacing(+"前面#H2G2#後面")
    assert_equal "前面 #銀河閃電霹靂車指南# 後面", Rangu.spacing(+"前面#銀河閃電霹靂車指南#後面")
  end

  def test_can_spacing_with_dollar
    assert_equal "前面 $ 後面", Rangu.spacing(+"前面$後面")
    assert_equal "前面 $ 後面", Rangu.spacing(+"前面 $ 後面")
    assert_equal "前面 $100 後面", Rangu.spacing(+"前面$100後面")
  end

  def test_can_spacing_with_percent
    assert_equal "前面 % 後面", Rangu.spacing(+"前面%後面")
    assert_equal "前面 % 後面", Rangu.spacing(+"前面 % 後面")
    assert_equal "前面 100% 後面", Rangu.spacing(+"前面100%後面")
  end

  def test_can_spacing_with_caret
    assert_equal "前面 ^ 後面", Rangu.spacing(+"前面^後面")
    assert_equal "前面 ^ 後面", Rangu.spacing(+"前面 ^ 後面")
  end

  def test_can_spacing_with_ampersand
    assert_equal "前面 & 後面", Rangu.spacing(+"前面&後面")
    assert_equal "前面 & 後面", Rangu.spacing(+"前面 & 後面")
    assert_equal "Vinta&Mollie", Rangu.spacing(+"Vinta&Mollie")
    assert_equal "Vinta & 陳上進", Rangu.spacing(+"Vinta&陳上進")
    assert_equal "陳上進 & Vinta", Rangu.spacing(+"陳上進&Vinta")
    assert_equal "得到一個 A&B 的結果", Rangu.spacing(+"得到一個A&B的結果")
  end

  def test_can_spacing_with_asterisk
    assert_equal "前面 * 後面", Rangu.spacing(+"前面*後面")
    assert_equal "前面 * 後面", Rangu.spacing(+"前面 * 後面")
    assert_equal "Vinta*Mollie", Rangu.spacing(+"Vinta*Mollie")
    assert_equal "Vinta * 陳上進", Rangu.spacing(+"Vinta*陳上進")
    assert_equal "陳上進 * Vinta", Rangu.spacing(+"陳上進*Vinta")
    assert_equal "得到一個 A*B 的結果", Rangu.spacing(+"得到一個A*B的結果")
  end

  def test_can_spacing_with_teparentheses
    assert_equal "前面 (中文 123 漢字) 後面", Rangu.spacing(+"前面(中文123漢字)後面")
    assert_equal "前面 (中文 123) 後面", Rangu.spacing(+"前面(中文123)後面")
    assert_equal "前面 (123 漢字) 後面", Rangu.spacing(+"前面(123漢字)後面")
    assert_equal "前面 (中文 123 漢字) tail", Rangu.spacing(+"前面(中文123漢字) tail")
    assert_equal "head (中文 123 漢字) 後面", Rangu.spacing(+"head (中文123漢字)後面")
    assert_equal "head (中文 123 漢字) tail", Rangu.spacing(+"head (中文123漢字) tail")
  end

  def test_can_spacing_with_minus
    assert_equal "前面 - 後面", Rangu.spacing(+"前面-後面")
    assert_equal "前面 - 後面", Rangu.spacing(+"前面 - 後面")
    assert_equal "Vinta-Mollie", Rangu.spacing(+"Vinta-Mollie")
    assert_equal "Vinta - 陳上進", Rangu.spacing(+"Vinta-陳上進")
    assert_equal "陳上進 - Vinta", Rangu.spacing(+"陳上進-Vinta")
    assert_equal "得到一個 A-B 的結果", Rangu.spacing(+"得到一個A-B的結果")
  end

  def test_can_spacing_with_underscore
    assert_equal "前面_後面", Rangu.spacing(+"前面_後面")
    assert_equal "前面 _ 後面", Rangu.spacing(+"前面 _ 後面")
  end

  def test_can_spacing_with_plus
    assert_equal "前面 + 後面", Rangu.spacing(+"前面+後面")
    assert_equal "前面 + 後面", Rangu.spacing(+"前面 + 後面")
    assert_equal "Vinta+Mollie", Rangu.spacing(+"Vinta+Mollie")
    assert_equal "Vinta + 陳上進", Rangu.spacing(+"Vinta+陳上進")
    assert_equal "陳上進 + Vinta", Rangu.spacing(+"陳上進+Vinta")
    assert_equal "得到一個 A+B 的結果", Rangu.spacing(+"得到一個A+B的結果")
    assert_equal "得到一個 C++ 的結果", Rangu.spacing(+"得到一個C++的結果")
  end

  def test_can_spacing_with_equal
    assert_equal "前面 = 後面", Rangu.spacing(+"前面=後面")
    assert_equal "前面 = 後面", Rangu.spacing(+"前面 = 後面")
    assert_equal "Vinta=Mollie", Rangu.spacing(+"Vinta=Mollie")
    assert_equal "Vinta = 陳上進", Rangu.spacing(+"Vinta=陳上進")
    assert_equal "陳上進 = Vinta", Rangu.spacing(+"陳上進=Vinta")
    assert_equal "得到一個 A=B 的結果", Rangu.spacing(+"得到一個A=B的結果")
  end

  def test_can_spacing_with_braces
    assert_equal "前面 {中文 123 漢字} 後面", Rangu.spacing(+"前面{中文123漢字}後面")
    assert_equal "前面 {中文 123} 後面", Rangu.spacing(+"前面{中文123}後面")
    assert_equal "前面 {123 漢字} 後面", Rangu.spacing(+"前面{123漢字}後面")
    assert_equal "前面 {中文 123 漢字} tail", Rangu.spacing(+"前面{中文123漢字} tail")
    assert_equal "head {中文 123 漢字} 後面", Rangu.spacing(+"head {中文123漢字}後面")
    assert_equal "head {中文 123 漢字} tail", Rangu.spacing(+"head {中文123漢字} tail")
  end

  def test_can_spacing_with_brackets
    assert_equal "前面 [中文 123 漢字] 後面", Rangu.spacing(+"前面[中文123漢字]後面")
    assert_equal "前面 [中文 123] 後面", Rangu.spacing(+"前面[中文123]後面")
    assert_equal "前面 [123 漢字] 後面", Rangu.spacing(+"前面[123漢字]後面")
    assert_equal "前面 [中文 123 漢字] tail", Rangu.spacing(+"前面[中文123漢字] tail")
    assert_equal "head [中文 123 漢字] 後面", Rangu.spacing(+"head [中文123漢字]後面")
    assert_equal "head [中文 123 漢字] tail", Rangu.spacing(+"head [中文123漢字] tail")
  end

  def test_can_spacing_with_pipe
    assert_equal "前面 | 後面", Rangu.spacing(+"前面|後面")
    assert_equal "前面 | 後面", Rangu.spacing(+"前面 | 後面")
    assert_equal "Vinta|Mollie", Rangu.spacing(+"Vinta|Mollie")
    assert_equal "Vinta | 陳上進", Rangu.spacing(+"Vinta|陳上進")
    assert_equal "陳上進 | Vinta", Rangu.spacing(+"陳上進|Vinta")
    assert_equal "得到一個 A|B 的結果", Rangu.spacing(+"得到一個A|B的結果")
  end

  def test_can_spacing_with_backslash
    assert_equal '前面 \ 後面', Rangu.spacing(+'前面\後面')
    assert_equal '前面 \ 後面', Rangu.spacing(+'前面 \ 後面')
  end

  def test_can_spacing_with_colon
    assert_equal "前面: 後面", Rangu.spacing(+"前面:後面")
    assert_equal "前面 : 後面", Rangu.spacing(+"前面 : 後面")
    assert_equal "前面: 後面", Rangu.spacing(+"前面: 後面")
  end

  def test_can_spacing_with_semicolon
    assert_equal "前面; 後面", Rangu.spacing(+"前面;後面")
    assert_equal "前面 ; 後面", Rangu.spacing(+"前面 ; 後面")
    assert_equal "前面; 後面", Rangu.spacing(+"前面; 後面")
  end

  def test_can_spacing_with_quote
    assert_equal '前面 "中文 123 漢字" 後面', Rangu.spacing(+'前面"中文123漢字"後面')
    assert_equal '前面 "中文 123" 後面', Rangu.spacing(+'前面"中文123"後面')
    assert_equal '前面 "123 漢字" 後面', Rangu.spacing(+'前面"123漢字"後面')
    assert_equal '前面 "中文 123 漢字" tail', Rangu.spacing(+'前面"中文123漢字" tail')
    assert_equal 'head "中文 123 漢字" 後面', Rangu.spacing(+'head "中文123漢字"後面')
    assert_equal 'head "中文 123 漢字" tail', Rangu.spacing(+'head "中文123漢字" tail')
  end

  def test_can_spacing_with_single_quote
    assert_equal "前面 '中文 123 漢字' 後面", Rangu.spacing(+"前面'中文123漢字'後面")
    assert_equal "前面 '中文 123' 後面", Rangu.spacing(+"前面'中文123'後面")
    assert_equal "前面 '123 漢字' 後面", Rangu.spacing(+"前面'123漢字'後面")
    assert_equal "前面 '中文 123 漢字' tail", Rangu.spacing(+"前面'中文123漢字' tail")
    assert_equal "head '中文 123 漢字' 後面", Rangu.spacing(+"head '中文 123 漢字'後面")
    assert_equal "head '中文 123 漢字' tail", Rangu.spacing(+"head '中文 123 漢字' tail")
    assert_equal "陳上進 likes 林依諾's status.", Rangu.spacing(+"陳上進 likes 林依諾's status.")
  end

  def test_can_spacing_with_less_than_and_greater_than
    assert_equal "前面 <中文 123 漢字> 後面", Rangu.spacing(+"前面<中文123漢字> 後面")
    assert_equal "前面 <中文 123> 後面", Rangu.spacing(+"前面<中文123> 後面")
    assert_equal "前面 <123 漢字> 後面", Rangu.spacing(+"前面<123漢字> 後面")
    assert_equal "前面 <中文 123 漢字> tail", Rangu.spacing(+"前面<中文123漢字> tail")
    assert_equal "head <中文 123 漢字> 後面", Rangu.spacing(+"head<中文123漢字>後面")
    assert_equal "head <中文 123 漢字> tail", Rangu.spacing(+"head<中文123漢字> tail")
  end

  def test_can_spacing_with_less_than
    assert_equal "前面 < 後面", Rangu.spacing(+"前面<後面")
    assert_equal "前面 < 後面", Rangu.spacing(+"前面 < 後面")
    assert_equal "Vinta<Mollie", Rangu.spacing(+"Vinta<Mollie")
    assert_equal "Vinta < 陳上進", Rangu.spacing(+"Vinta<陳上進")
    assert_equal "陳上進 < Vinta", Rangu.spacing(+"陳上進<Vinta")
    assert_equal "得到一個 B<Z 的結果", Rangu.spacing(+"得到一個B<Z的結果")
  end

  def test_can_spacing_with_comma
    assert_equal "前面, 後面", Rangu.spacing(+"前面,後面")
    assert_equal "前面 , 後面", Rangu.spacing(+"前面 , 後面")
    assert_equal "前面, 後面", Rangu.spacing(+"前面, 後面")
  end

  def test_can_spacing_with_greater_than
    assert_equal "前面 > 後面", Rangu.spacing(+"前面>後面")
    assert_equal "前面 > 後面", Rangu.spacing(+"前面 > 後面")
    assert_equal "Vinta>Mollie", Rangu.spacing(+"Vinta>Mollie")
    assert_equal "Vinta > 陳上進", Rangu.spacing(+"Vinta>陳上進")
    assert_equal "陳上進 > Vinta", Rangu.spacing(+"陳上進>Vinta")
    assert_equal "得到一個 Z>B 的結果", Rangu.spacing(+"得到一個Z>B的結果")
  end

  def test_can_spacing_with_period
    assert_equal "前面. 後面", Rangu.spacing(+"前面.後面")
    assert_equal "前面 . 後面", Rangu.spacing(+"前面 . 後面")
    assert_equal "前面. 後面", Rangu.spacing(+"前面. 後面")
  end

  def test_can_spacing_with_question_mark
    assert_equal "前面? 後面", Rangu.spacing(+"前面?後面")
    assert_equal "前面 ? 後面", Rangu.spacing(+"前面 ? 後面")
    assert_equal "前面? 後面", Rangu.spacing(+"前面? 後面")
  end

  def test_can_spacing_with_slash
    assert_equal "前面 / 後面", Rangu.spacing(+"前面/後面")
    assert_equal "前面 / 後面", Rangu.spacing(+"前面 / 後面")
    assert_equal "Vinta/Mollie", Rangu.spacing(+"Vinta/Mollie")
    assert_equal "Vinta / 陳上進", Rangu.spacing(+"Vinta/陳上進")
    assert_equal "陳上進 / Vinta", Rangu.spacing(+"陳上進/Vinta")
    assert_equal "得到一個 Z/B 的結果", Rangu.spacing(+"得到一個Z/B的結果")
  end

  def test_can_spacing_with_special_characters
    # \u201c and \u201d
    assert_equal "前面 “中文 123 漢字” 後面", Rangu.spacing(+"前面“中文123漢字”後面")

    # \u2026
    assert_equal "前面… 後面", Rangu.spacing(+"前面…後面")
    assert_equal "前面…… 後面", Rangu.spacing(+"前面……後面")

    # \u2027
    assert_equal "前面 ‧ 後面", Rangu.spacing(+"前面‧後面")
  end

  def test_has_a_version_number
    refute_nil Rangu::VERSION
  end
end
