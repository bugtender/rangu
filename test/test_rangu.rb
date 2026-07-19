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

  def test_spacing_handles_empty_and_single_character_strings
    ["", "中", "A"].each do |input|
      result = Rangu.spacing(input)

      assert_equal input, result
      refute_same input, result
    end
  end

  def test_spacing_is_idempotent
    spaced = Rangu.spacing("  喬治•R•R•馬丁使用Ruby4.0!  ")

    assert_equal spaced, Rangu.spacing(spaced)
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
    assert_equal "所以，請問 Jackey 的鼻子有幾個？3.14 個！", Rangu.spacing(+"所以,請問Jackey的鼻子有幾個?3.14個!")
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
    assert_equal "中文・漢字", Rangu.spacing(+"中文•漢字")
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
    assert_equal "前面～後面", Rangu.spacing(+"前面~後面")
    assert_equal "前面～後面", Rangu.spacing(+"前面 ~ 後面")
    assert_equal "前面～後面", Rangu.spacing(+"前面~ 後面")
  end

  def test_can_spacing_with_back_quote
    assert_equal "前面 ` 後面", Rangu.spacing(+"前面`後面")
    assert_equal "前面 ` 後面", Rangu.spacing(+"前面 ` 後面")
    assert_equal "前面 ` 後面", Rangu.spacing(+"前面` 後面")
  end

  def test_can_spacing_with_texclamation_mark
    assert_equal "前面！後面", Rangu.spacing(+"前面!後面")
    assert_equal "前面！後面", Rangu.spacing(+"前面 ! 後面")
    assert_equal "前面！後面", Rangu.spacing(+"前面! 後面")
  end

  def test_can_spacing_with_at
    assert_equal "前面 @vinta 後面", Rangu.spacing(+"前面@vinta後面")
    assert_equal "前面 @vinta 後面", Rangu.spacing(+"前面 @vinta 後面")
    assert_equal "前面！後面", Rangu.spacing(+"前面! 後面")

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
    assert_equal "前面：後面", Rangu.spacing(+"前面:後面")
    assert_equal "前面：後面", Rangu.spacing(+"前面 : 後面")
    assert_equal "前面：後面", Rangu.spacing(+"前面: 後面")
  end

  def test_can_spacing_with_semicolon
    assert_equal "前面；後面", Rangu.spacing(+"前面;後面")
    assert_equal "前面；後面", Rangu.spacing(+"前面 ; 後面")
    assert_equal "前面；後面", Rangu.spacing(+"前面; 後面")
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
    assert_equal "前面 ' 中文 123 漢字 ' 後面", Rangu.spacing(+"前面'中文123漢字'後面")
    assert_equal "前面 ' 中文 123' 後面", Rangu.spacing(+"前面'中文123'後面")
    assert_equal "前面 '123 漢字 ' 後面", Rangu.spacing(+"前面'123漢字'後面")
    assert_equal "前面 ' 中文 123 漢字 ' tail", Rangu.spacing(+"前面'中文123漢字' tail")
    assert_equal "head ' 中文 123 漢字 ' 後面", Rangu.spacing(+"head '中文 123 漢字'後面")
    assert_equal "head ' 中文 123 漢字 ' tail", Rangu.spacing(+"head '中文 123 漢字' tail")
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
    assert_equal "前面，後面", Rangu.spacing(+"前面,後面")
    assert_equal "前面，後面", Rangu.spacing(+"前面 , 後面")
    assert_equal "前面，後面", Rangu.spacing(+"前面, 後面")
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
    assert_equal "前面。後面", Rangu.spacing(+"前面.後面")
    assert_equal "前面。後面", Rangu.spacing(+"前面 . 後面")
    assert_equal "前面。後面", Rangu.spacing(+"前面. 後面")
  end

  def test_can_spacing_with_question_mark
    assert_equal "前面？後面", Rangu.spacing(+"前面?後面")
    assert_equal "前面？後面", Rangu.spacing(+"前面 ? 後面")
    assert_equal "前面？後面", Rangu.spacing(+"前面? 後面")
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
    assert_equal "前面・後面", Rangu.spacing(+"前面‧後面")
  end

  def test_has_a_version_number
    assert_equal "1.0.0", Rangu::VERSION
  end
end

class RanguSpacingRegressionTest < Minitest::Test
  def test_basic_character_boundaries
    assert_equal "Vinta_Mollie", Rangu.spacing("Vinta_Mollie")
    assert_equal "Vinta _ Mollie", Rangu.spacing("Vinta _ Mollie")
    assert_equal "中文 abc", Rangu.spacing("中文abc")
    assert_equal "abc 中文", Rangu.spacing("abc中文")
    assert_equal "中文 123", Rangu.spacing("中文123")
    assert_equal "123 中文", Rangu.spacing("123中文")
  end

  def test_latin_greek_and_number_form_boundaries
    assert_equal "中文 Ø 漢字", Rangu.spacing("中文 Ø 漢字")
    assert_equal "中文 β 漢字", Rangu.spacing("中文β漢字")
    assert_equal "中文 β 漢字", Rangu.spacing("中文 β 漢字")
    assert_equal "我是 α，我是 Ω", Rangu.spacing("我是α，我是Ω")
    assert_equal "中文 Ⅶ 漢字", Rangu.spacing("中文 Ⅶ 漢字")
  end

  def test_cjk_character_blocks
    assert_equal "abc ⻤ 123", Rangu.spacing("abc ⻤ 123")
    assert_equal "abc ⾗ 123", Rangu.spacing("abc ⾗ 123")
    assert_equal "abc あ 123", Rangu.spacing("abc あ 123")
    assert_equal "abc ア 123", Rangu.spacing("abc ア 123")
    assert_equal "abc ㄅ 123", Rangu.spacing("abc ㄅ 123")
    assert_equal "abc ㈱ 123", Rangu.spacing("abc ㈱ 123")
    assert_equal "abc 㐂 123", Rangu.spacing("abc 㐂 123")
    assert_equal "abc 丁 123", Rangu.spacing("abc 丁 123")
    assert_equal "abc 車 123", Rangu.spacing("abc 車 123")
  end

  def test_operators_and_paths
    assert_equal "长者的智慧和复杂的维斯特洛 - 文章", Rangu.spacing("长者的智慧和复杂的维斯特洛- 文章")
    assert_equal "Mollie / 陳上進 / Vinta", Rangu.spacing("Mollie/陳上進/Vinta")
    assert_equal "得到一個 A/B 的結果", Rangu.spacing("得到一個A/B的結果")
    assert_equal "2016-12-26 (奇幻电影节) / 2017-01-20 (美国) / 詹姆斯麦卡沃伊", Rangu.spacing("2016-12-26(奇幻电影节) / 2017-01-20(美国) / 詹姆斯麦卡沃伊")
    assert_equal "/home/ 和 /root 是 Linux 中的頂級目錄", Rangu.spacing("/home/和/root是Linux中的頂級目錄")
    assert_equal "當你用 cat 和 od 指令查看 /dev/random 和 /dev/urandom 的內容時", Rangu.spacing("當你用cat和od指令查看/dev/random和/dev/urandom的內容時")
    assert_equal "得到一個 A<B 的結果", Rangu.spacing("得到一個A<B的結果")
    assert_equal "得到一個 A>B 的結果", Rangu.spacing("得到一個A>B的結果")
  end

  def test_mentions_and_hashtags
    assert_equal "請 @vinta 吃大便", Rangu.spacing("請@vinta吃大便")
    assert_equal "請 @陳上進 吃大便", Rangu.spacing("請@陳上進 吃大便")
    assert_equal "前面 #後面", Rangu.spacing("前面#後面")
    assert_equal "前面 C# 後面", Rangu.spacing("前面C#後面")
    assert_equal "前面 #銀河便車指南 後面", Rangu.spacing("前面 #銀河便車指南 後面")
  end

  def test_ascii_punctuation_conversion
    assert_equal "前面... 後面", Rangu.spacing("前面...後面")
    assert_equal "前面.. 後面", Rangu.spacing("前面..後面")
    assert_equal "前面～後面", Rangu.spacing("前面 ~後面")
    assert_equal "前面！後面", Rangu.spacing("前面 !後面")
    assert_equal "前面；後面", Rangu.spacing("前面 ;後面")
    assert_equal "前面：後面", Rangu.spacing("前面 :後面")
    assert_equal "電話：123456789", Rangu.spacing("電話:123456789")
    assert_equal "前面：) 後面", Rangu.spacing("前面:)後面")
  end

  def test_ascii_punctuation_context
    assert_equal "前面：I have no idea 後面", Rangu.spacing("前面:I have no idea後面")
    assert_equal "前面: I have no idea 後面", Rangu.spacing("前面: I have no idea後面")
    assert_equal "前面，後面", Rangu.spacing("前面 ,後面")
    assert_equal "前面，", Rangu.spacing("前面,")
    assert_equal "前面，", Rangu.spacing("前面, ")
    assert_equal "前面。後面", Rangu.spacing("前面 .後面")
    assert_equal "黑人問號.jpg 後面", Rangu.spacing("黑人問號.jpg 後面")
    assert_equal "前面？後面", Rangu.spacing("前面 ?後面")
    assert_equal "所以，請問 Jackey 的鼻子有幾個？3.14 個", Rangu.spacing("所以，請問Jackey的鼻子有幾個?3.14個")
  end

  def test_middle_dot_normalization
    assert_equal "前面・後面", Rangu.spacing("前面·後面")
    assert_equal "喬治・R・R・馬丁", Rangu.spacing("喬治·R·R·馬丁")
    assert_equal "M・奈特・沙马兰", Rangu.spacing("M·奈特·沙马兰")
    assert_equal "前面・後面", Rangu.spacing("前面•後面")
    assert_equal "喬治・R・R・馬丁", Rangu.spacing("喬治•R•R•馬丁")
    assert_equal "M・奈特・沙马兰", Rangu.spacing("M•奈特•沙马兰")
    assert_equal "喬治・R・R・馬丁", Rangu.spacing("喬治‧R‧R‧馬丁")
    assert_equal "M・奈特・沙马兰", Rangu.spacing("M‧奈特‧沙马兰")
  end

  def test_brackets_quotes_and_possessives
    assert_equal "前面 <中文 123 漢字> 後面", Rangu.spacing("前面<中文123漢字>後面")
    assert_equal "前面 <中文 123> 後面", Rangu.spacing("前面<中文123>後面")
    assert_equal "前面 <123 漢字> 後面", Rangu.spacing("前面<123漢字>後面")
    assert_equal "head <中文 123 漢字> 後面", Rangu.spacing("head <中文123漢字>後面")
    assert_equal "head <中文 123 漢字> tail", Rangu.spacing("head <中文123漢字> tail")
    assert_equal "前面 (中文 123) tail", Rangu.spacing("前面(中文123) tail")
    assert_equal "(or simply \"React\")", Rangu.spacing("(or simply \"React\")")
    assert_equal "OperationalError: (2006, 'MySQL server has gone away')", Rangu.spacing("OperationalError: (2006, 'MySQL server has gone away')")
    assert_equal "我看过的电影 (1404)", Rangu.spacing("我看过的电影(1404)")
    assert_equal "Chang Stream (变更记录流) 是指 collection (数据库集合) 的变更事件流", Rangu.spacing("Chang Stream(变更记录流)是指collection(数据库集合)的变更事件流")
  end

  def test_quotes_and_possessives
    assert_equal "前面 `中間` 後面", Rangu.spacing("前面`中間`後面")
    assert_equal "前面 \"中文 123\" tail", Rangu.spacing("前面\"中文123\" tail")
    assert_equal "Ruby's 'private' methods remain private.", Rangu.spacing("Ruby's 'private' methods remain private.")
    assert_equal "举个栗子，如果一道题只包含 'A' ~ 'Z' 意味着字符集大小是", Rangu.spacing("举个栗子，如果一道题只包含'A' ~ 'Z'意味着字符集大小是")
    assert_equal "前面 ״中間״ 後面", Rangu.spacing("前面״中間״後面")
    assert_equal "阿里云开源 “计算王牌” Blink，实时计算时代已来", Rangu.spacing("阿里云开源“计算王牌”Blink，实时计算时代已来")
    assert_equal "苹果撤销 Facebook “企业证书” 后者股价一度短线走低", Rangu.spacing("苹果撤销Facebook“企业证书”后者股价一度短线走低")
    assert_equal "【UCG 中字】“數毛社” DF 的《戰神 4》全新演示解析", Rangu.spacing("【UCG中字】“數毛社”DF的《戰神4》全新演示解析")
    assert_equal "丹寧控注意 Levi's 全館任 2 件 25% OFF 滿額再享 85 折！", Rangu.spacing("丹寧控注意Levi's全館任2件25%OFF滿額再享85折！")
  end

  def test_spacing_text_regressions
    assert_equal "請使用 uname -m 指令來檢查你的 Linux 作業系統是 32 位元或是 [敏感词已被屏蔽] 位元", Rangu.spacing_text("請使用uname -m指令來檢查你的Linux作業系統是32位元或是[敏感词已被屏蔽]位元")
  end
end
