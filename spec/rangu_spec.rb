RSpec.describe Rangu do
  describe ".spacing" do
    it "should return nice spacing text" do
      expect(Rangu.spacing("新八的構造成分有95%是眼鏡、3%是水、2%是垃圾")).
        to eq("新八的構造成分有 95% 是眼鏡、3% 是水、2% 是垃圾")
      expect(Rangu.spacing("所以,請問Jackey的鼻子有幾個?3.14個!")).
        to eq("所以, 請問 Jackey 的鼻子有幾個? 3.14 個!")
      expect(Rangu.spacing("JUST WE就是JUST WE，既不偉大也不卑微！")).
        to eq("JUST WE 就是 JUST WE，既不偉大也不卑微！")
      expect(Rangu.spacing("搭載MP3播放器，連續播放時數最長達到124小時的超強利刃……菊一文字RX-7!")).
        to eq("搭載 MP3 播放器，連續播放時數最長達到 124 小時的超強利刃…… 菊一文字 RX-7!")
      expect(Rangu.spacing("V")).
        to eq("V")
    end

    it "can spacing with text file" do
      expect(Rangu.spacing("./spec/test_file.txt")).
        to eq("搭載 MP3 播放器，菊一文字 RX-7!\nJUST WE 就是 JUST WE，既不偉大也不卑微！")
    end

    it "can spacing with text" do
      expect(Rangu.spacing("Mr.龍島主道：「Let's Party!各位高明博雅君子！」")).
        to eq("Mr. 龍島主道：「Let's Party! 各位高明博雅君子！」")
    end

    it "can spacing with latin" do
      expect(Rangu.spacing("中文Ø漢字")).to eq("中文 Ø 漢字")
    end

    it "can spacing with general punctuation" do
      expect(Rangu.spacing("中文•漢字")).to eq("中文 • 漢字")
    end

    it "can spacing with number forms" do
      expect(Rangu.spacing("中文Ⅶ漢字")).to eq("中文 Ⅶ 漢字")
    end

    it "can spacing with cjk radicals" do
      expect(Rangu.spacing("abc⻤123")).to eq("abc ⻤ 123")
    end

    it "can spacing with kangxi radicals" do
      expect(Rangu.spacing("abc⾗123")).to eq("abc ⾗ 123")
    end

    it "can spacing with hiragana" do
      expect(Rangu.spacing("abcあ123")).to eq("abc あ 123")
    end

    it "can spacing with katakana" do
      expect(Rangu.spacing("abcア123")).to eq("abc ア 123")
    end

    it "can spacing with bopomofo" do
      expect(Rangu.spacing("abcㄅ123")).to eq("abc ㄅ 123")
    end

    it "can spacing with enclosed cjk letters and months" do
      expect(Rangu.spacing("abc㈱123")).to eq("abc ㈱ 123")
    end

    it "can spacing with cjk unified ideographs extension a" do
      expect(Rangu.spacing("abc㐂123")).to eq("abc 㐂 123")
    end

    it "can spacing with cjk unified ideographs" do
      expect(Rangu.spacing("abc丁123")).to eq("abc 丁 123")
    end

    it "can spacing with cjk compatibility ideographs" do
      expect(Rangu.spacing("abc車123")).to eq("abc 車 123")
    end

    it "can spacing with tilde" do
      expect(Rangu.spacing("前面~後面")).to eq("前面~ 後面")
      expect(Rangu.spacing("前面 ~ 後面")).to eq("前面 ~ 後面")
      expect(Rangu.spacing("前面~ 後面")).to eq("前面~ 後面")
    end

    it "can spacing with back_quote" do
      expect(Rangu.spacing("前面`後面")).to eq("前面 ` 後面")
      expect(Rangu.spacing("前面 ` 後面")).to eq("前面 ` 後面")
      expect(Rangu.spacing("前面` 後面")).to eq("前面 ` 後面")
    end

    it "can spacing with texclamation mark" do
      expect(Rangu.spacing("前面!後面")).to eq("前面! 後面")
      expect(Rangu.spacing("前面 ! 後面")).to eq("前面 ! 後面")
      expect(Rangu.spacing("前面! 後面")).to eq("前面! 後面")
    end

    it "can spacing with at" do
      expect(Rangu.spacing("前面@vinta後面")).to eq("前面 @vinta 後面")
      expect(Rangu.spacing("前面 @vinta 後面")).to eq("前面 @vinta 後面")
      expect(Rangu.spacing("前面! 後面")).to eq("前面! 後面")

      expect(Rangu.spacing("前面@陳上進 後面")).to eq("前面 @陳上進 後面")
      expect(Rangu.spacing("前面 @陳上進 後面")).to eq("前面 @陳上進 後面")
      expect(Rangu.spacing("前面 @陳上進tail")).to eq("前面 @陳上進 tail")
    end

    it "can spacing with hash" do
      expect(Rangu.spacing("前面#H2G2後面")).to eq("前面 #H2G2 後面")
      expect(Rangu.spacing("前面#銀河便車指南 後面")).to eq("前面 #銀河便車指南 後面")
      expect(Rangu.spacing("前面#銀河便車指南tail")).to eq("前面 #銀河便車指南 tail")

      expect(Rangu.spacing("前面#銀河公車指南 #銀河拖吊車指南 後面")).to eq("前面 #銀河公車指南 #銀河拖吊車指南 後面")
      expect(Rangu.spacing("前面#H2G2#後面")).to eq("前面 #H2G2# 後面")
      expect(Rangu.spacing("前面#銀河閃電霹靂車指南#後面")).to eq("前面 #銀河閃電霹靂車指南# 後面")
    end

    it "can spacing with dollar" do
      expect(Rangu.spacing("前面$後面")).to eq("前面 $ 後面")
      expect(Rangu.spacing("前面 $ 後面")).to eq("前面 $ 後面")
      expect(Rangu.spacing("前面$100後面")).to eq("前面 $100 後面")
    end

    it "can spacing with percent" do
      expect(Rangu.spacing("前面%後面")).to eq("前面 % 後面")
      expect(Rangu.spacing("前面 % 後面")).to eq("前面 % 後面")
      expect(Rangu.spacing("前面100%後面")).to eq("前面 100% 後面")
    end

    it "can spacing with caret" do
      expect(Rangu.spacing("前面^後面")).to eq("前面 ^ 後面")
      expect(Rangu.spacing("前面 ^ 後面")).to eq("前面 ^ 後面")
    end

    it "can spacing with ampersand" do
      expect(Rangu.spacing("前面&後面")).to eq("前面 & 後面")
      expect(Rangu.spacing("前面 & 後面")).to eq("前面 & 後面")
      expect(Rangu.spacing("Vinta&Mollie")).to eq("Vinta&Mollie")
      expect(Rangu.spacing("Vinta&陳上進")).to eq("Vinta & 陳上進")
      expect(Rangu.spacing("陳上進&Vinta")).to eq("陳上進 & Vinta")
      expect(Rangu.spacing("得到一個A&B的結果")).to eq("得到一個 A&B 的結果")
    end

    it "can spacing with asterisk" do
      expect(Rangu.spacing("前面*後面")).to eq("前面 * 後面")
      expect(Rangu.spacing("前面 * 後面")).to eq("前面 * 後面")
      expect(Rangu.spacing("Vinta*Mollie")).to eq("Vinta*Mollie")
      expect(Rangu.spacing("Vinta*陳上進")).to eq("Vinta * 陳上進")
      expect(Rangu.spacing("陳上進*Vinta")).to eq("陳上進 * Vinta")
      expect(Rangu.spacing("得到一個A*B的結果")).to eq("得到一個 A*B 的結果")
    end

    it "can spacing with teparentheses" do
      expect(Rangu.spacing("前面(中文123漢字)後面")).to eq("前面 (中文 123 漢字) 後面")
      expect(Rangu.spacing("前面(中文123)後面")).to eq("前面 (中文 123) 後面")
      expect(Rangu.spacing("前面(123漢字)後面")).to eq("前面 (123 漢字) 後面")
      expect(Rangu.spacing("前面(中文123漢字) tail")).to eq("前面 (中文 123 漢字) tail")
      expect(Rangu.spacing("head (中文123漢字)後面")).to eq("head (中文 123 漢字) 後面")
      expect(Rangu.spacing("head (中文123漢字) tail")).to eq("head (中文 123 漢字) tail")
    end

    it "can spacing with minus" do
      expect(Rangu.spacing("前面-後面")).to eq("前面 - 後面")
      expect(Rangu.spacing("前面 - 後面")).to eq("前面 - 後面")
      expect(Rangu.spacing("Vinta-Mollie")).to eq("Vinta-Mollie")
      expect(Rangu.spacing("Vinta-陳上進")).to eq("Vinta - 陳上進")
      expect(Rangu.spacing("陳上進-Vinta")).to eq("陳上進 - Vinta")
      expect(Rangu.spacing("得到一個A-B的結果")).to eq("得到一個 A-B 的結果")
    end

    it "can spacing with underscore" do
      expect(Rangu.spacing("前面_後面")).to eq("前面_後面")
      expect(Rangu.spacing("前面 _ 後面")).to eq("前面 _ 後面")
    end

    it "can spacing with plus" do
      expect(Rangu.spacing("前面+後面")).to eq("前面 + 後面")
      expect(Rangu.spacing("前面 + 後面")).to eq("前面 + 後面")
      expect(Rangu.spacing("Vinta+Mollie")).to eq("Vinta+Mollie")
      expect(Rangu.spacing("Vinta+陳上進")).to eq("Vinta + 陳上進")
      expect(Rangu.spacing("陳上進+Vinta")).to eq("陳上進 + Vinta")
      expect(Rangu.spacing("得到一個A+B的結果")).to eq("得到一個 A+B 的結果")
      expect(Rangu.spacing("得到一個C++的結果")).to eq("得到一個 C++ 的結果")
    end

    it "can spacing with plus" do
      expect(Rangu.spacing("前面=後面")).to eq("前面 = 後面")
      expect(Rangu.spacing("前面 = 後面")).to eq("前面 = 後面")
      expect(Rangu.spacing("Vinta=Mollie")).to eq("Vinta=Mollie")
      expect(Rangu.spacing("Vinta=陳上進")).to eq("Vinta = 陳上進")
      expect(Rangu.spacing("陳上進=Vinta")).to eq("陳上進 = Vinta")
      expect(Rangu.spacing("得到一個A=B的結果")).to eq("得到一個 A=B 的結果")
    end

    it "can spacing with braces" do
      expect(Rangu.spacing("前面{中文123漢字}後面")).to eq("前面 {中文 123 漢字} 後面")
      expect(Rangu.spacing("前面{中文123}後面")).to eq("前面 {中文 123} 後面")
      expect(Rangu.spacing("前面{123漢字}後面")).to eq("前面 {123 漢字} 後面")
      expect(Rangu.spacing("前面{中文123漢字} tail")).to eq("前面 {中文 123 漢字} tail")
      expect(Rangu.spacing("head {中文123漢字}後面")).to eq("head {中文 123 漢字} 後面")
      expect(Rangu.spacing("head {中文123漢字} tail")).to eq("head {中文 123 漢字} tail")
    end

    it "can spacing with brackets" do
      expect(Rangu.spacing("前面[中文123漢字]後面")).to eq("前面 [中文 123 漢字] 後面")
      expect(Rangu.spacing("前面[中文123]後面")).to eq("前面 [中文 123] 後面")
      expect(Rangu.spacing("前面[123漢字]後面")).to eq("前面 [123 漢字] 後面")
      expect(Rangu.spacing("前面[中文123漢字] tail")).to eq("前面 [中文 123 漢字] tail")
      expect(Rangu.spacing("head [中文123漢字]後面")).to eq("head [中文 123 漢字] 後面")
      expect(Rangu.spacing("head [中文123漢字] tail")).to eq("head [中文 123 漢字] tail")
    end

    it "can spacing with plus" do
      expect(Rangu.spacing("前面|後面")).to eq("前面 | 後面")
      expect(Rangu.spacing("前面 | 後面")).to eq("前面 | 後面")
      expect(Rangu.spacing("Vinta|Mollie")).to eq("Vinta|Mollie")
      expect(Rangu.spacing("Vinta|陳上進")).to eq("Vinta | 陳上進")
      expect(Rangu.spacing("陳上進|Vinta")).to eq("陳上進 | Vinta")
      expect(Rangu.spacing("得到一個A|B的結果")).to eq("得到一個 A|B 的結果")
    end

    it "can spacing with backslash" do
      expect(Rangu.spacing('前面\後面')).to eq('前面 \ 後面')
      expect(Rangu.spacing('前面 \ 後面')).to eq('前面 \ 後面')
    end

    it "can spacing with colon" do
      expect(Rangu.spacing("前面:後面")).to eq("前面: 後面")
      expect(Rangu.spacing("前面 : 後面")).to eq("前面 : 後面")
      expect(Rangu.spacing("前面: 後面")).to eq("前面: 後面")
    end

    it "can spacing with semicolon" do
      expect(Rangu.spacing("前面;後面")).to eq("前面; 後面")
      expect(Rangu.spacing("前面 ; 後面")).to eq("前面 ; 後面")
      expect(Rangu.spacing("前面; 後面")).to eq("前面; 後面")
    end

    it "can spacing with quote" do
      expect(Rangu.spacing('前面"中文123漢字"後面')).to eq('前面 "中文 123 漢字" 後面')
      expect(Rangu.spacing('前面"中文123"後面')).to eq('前面 "中文 123" 後面')
      expect(Rangu.spacing('前面"123漢字"後面')).to eq('前面 "123 漢字" 後面')
      expect(Rangu.spacing('前面"中文123漢字" tail')).to eq('前面 "中文 123 漢字" tail')
      expect(Rangu.spacing('head "中文123漢字"後面')).to eq('head "中文 123 漢字" 後面')
      expect(Rangu.spacing('head "中文123漢字" tail')).to eq('head "中文 123 漢字" tail')
    end

    it "can spacing with single quote" do
      expect(Rangu.spacing("前面'中文123漢字'後面")).to eq("前面 '中文 123 漢字' 後面")
      expect(Rangu.spacing("前面'中文123'後面")).to eq("前面 '中文 123' 後面")
      expect(Rangu.spacing("前面'123漢字'後面")).to eq("前面 '123 漢字' 後面")
      expect(Rangu.spacing("前面'中文123漢字' tail")).to eq("前面 '中文 123 漢字' tail")
      expect(Rangu.spacing("head '中文 123 漢字'後面")).to eq("head '中文 123 漢字' 後面")
      expect(Rangu.spacing("head '中文 123 漢字' tail")).to eq("head '中文 123 漢字' tail")
      expect(Rangu.spacing("陳上進 likes 林依諾's status.")).to eq("陳上進 likes 林依諾's status.")
    end

    it "can spacing with less than and greater than" do
      expect(Rangu.spacing("前面<中文123漢字> 後面")).to eq("前面 <中文 123 漢字> 後面")
      expect(Rangu.spacing("前面<中文123> 後面")).to eq("前面 <中文 123> 後面")
      expect(Rangu.spacing("前面<123漢字> 後面")).to eq("前面 <123 漢字> 後面")
      expect(Rangu.spacing("前面<中文123漢字> tail")).to eq("前面 <中文 123 漢字> tail")
      expect(Rangu.spacing("head<中文123漢字>後面")).to eq("head <中文 123 漢字> 後面")
      expect(Rangu.spacing("head<中文123漢字> tail")).to eq("head <中文 123 漢字> tail")
    end

    it "can spacing with less than" do
      expect(Rangu.spacing("前面<後面")).to eq("前面 < 後面")
      expect(Rangu.spacing("前面 < 後面")).to eq("前面 < 後面")
      expect(Rangu.spacing("Vinta<Mollie")).to eq("Vinta<Mollie")
      expect(Rangu.spacing("Vinta<陳上進")).to eq("Vinta < 陳上進")
      expect(Rangu.spacing("陳上進<Vinta")).to eq("陳上進 < Vinta")
      expect(Rangu.spacing("得到一個B<Z的結果")).to eq("得到一個 B<Z 的結果")
    end

    it "can spacing with comma" do
      expect(Rangu.spacing("前面,後面")).to eq("前面, 後面")
      expect(Rangu.spacing("前面 , 後面")).to eq("前面 , 後面")
      expect(Rangu.spacing("前面, 後面")).to eq("前面, 後面")
    end

    it "can spacing with greater than" do
      expect(Rangu.spacing("前面>後面")).to eq("前面 > 後面")
      expect(Rangu.spacing("前面 > 後面")).to eq("前面 > 後面")
      expect(Rangu.spacing("Vinta>Mollie")).to eq("Vinta>Mollie")
      expect(Rangu.spacing("Vinta>陳上進")).to eq("Vinta > 陳上進")
      expect(Rangu.spacing("陳上進>Vinta")).to eq("陳上進 > Vinta")
      expect(Rangu.spacing("得到一個Z>B的結果")).to eq("得到一個 Z>B 的結果")
    end

    it "can spacing with period" do
      expect(Rangu.spacing("前面.後面")).to eq("前面. 後面")
      expect(Rangu.spacing("前面 . 後面")).to eq("前面 . 後面")
      expect(Rangu.spacing("前面. 後面")).to eq("前面. 後面")
    end

    it "can spacing with question mark" do
      expect(Rangu.spacing("前面?後面")).to eq("前面? 後面")
      expect(Rangu.spacing("前面 ? 後面")).to eq("前面 ? 後面")
      expect(Rangu.spacing("前面? 後面")).to eq("前面? 後面")
    end

    it "can spacing with slash" do
      expect(Rangu.spacing("前面/後面")).to eq("前面 / 後面")
      expect(Rangu.spacing("前面 / 後面")).to eq("前面 / 後面")
      expect(Rangu.spacing("Vinta/Mollie")).to eq("Vinta/Mollie")
      expect(Rangu.spacing("Vinta/陳上進")).to eq("Vinta / 陳上進")
      expect(Rangu.spacing("陳上進/Vinta")).to eq("陳上進 / Vinta")
      expect(Rangu.spacing("得到一個Z/B的結果")).to eq("得到一個 Z/B 的結果")
    end

    it "can spacing with special_characters" do
      # \u201c and \u201d
      expect(Rangu.spacing("前面“中文123漢字”後面")).to eq("前面 “中文 123 漢字” 後面")

      # \u2026
      expect(Rangu.spacing("前面…後面")).to eq("前面… 後面")
      expect(Rangu.spacing("前面……後面")).to eq("前面…… 後面")

      # \u2027
      expect(Rangu.spacing("前面‧後面")).to eq("前面 ‧ 後面")
    end
  end

  it "has a version number" do
    expect(Rangu::VERSION).not_to be nil
  end
end
