require "rangu/version"

module Rangu
  CJK_QUOTE         = /([\u2e80-\u2eff\u2f00-\u2fdf\u3040-\u309f\u30a0-\u30ff\u3100-\u312f\u3200-\u32ff\u3400-\u4dbf\u4e00-\u9fff\uf900-\ufaff])(["\'])/i
  QUOTE_CJK         = /(["\'])([\u3040-\u312f\u3200-\u32ff\u3400-\u4dbf\u4e00-\u9fff\uf900-\ufaff])/i

  FIX_QUOTE         = /(["\'\(\[\{<\u201c]+)(\s*)(.+?)(\s*)(["\'\)\]\}>\u201d]+)/i
  FIX_SINGLE_QUOTE  = /([\u2e80-\u2eff\u2f00-\u2fdf\u3040-\u309f\u30a0-\u30ff\u3100-\u312f\u3200-\u32ff\u3400-\u4dbf\u4e00-\u9fff\uf900-\ufaff])( )(\')([A-Za-zΑ-Ωα-ω])/i

  CJK_HASH          = /([\u2e80-\u2eff\u2f00-\u2fdf\u3040-\u309f\u30a0-\u30ff\u3100-\u312f\u3200-\u32ff\u3400-\u4dbf\u4e00-\u9fff\uf900-\ufaff])(#(\S+))/i
  HASH_CJK          = /((\S+)#)([\u2e80-\u2eff\u2f00-\u2fdf\u3040-\u309f\u30a0-\u30ff\u3100-\u312f\u3200-\u32ff\u3400-\u4dbf\u4e00-\u9fff\uf900-\ufaff])/i

  CJK_OPERATOR_ANS  = /([\u2e80-\u2eff\u2f00-\u2fdf\u3040-\u309f\u30a0-\u30ff\u3100-\u312f\u3200-\u32ff\u3400-\u4dbf\u4e00-\u9fff\uf900-\ufaff])([\+\-\*\/=&\\|<>])([A-Za-zΑ-Ωα-ω0-9])/i
  ANS_OPERATOR_CJK  = /([A-Za-zΑ-Ωα-ω0-9])([\+\-\*\/=&\\|<>])([\u2e80-\u2eff\u2f00-\u2fdf\u3040-\u309f\u30a0-\u30ff\u3100-\u312f\u3200-\u32ff\u3400-\u4dbf\u4e00-\u9fff\uf900-\ufaff])/i

  CJK_BRACKET_CJK   = /([\u2e80-\u2eff\u2f00-\u2fdf\u3040-\u309f\u30a0-\u30ff\u3100-\u312f\u3200-\u32ff\u3400-\u4dbf\u4e00-\u9fff\uf900-\ufaff])([\(\[\{<\u201c]+(.*?)[\)\]\}>\u201d]+)([\u2e80-\u2eff\u2f00-\u2fdf\u3040-\u309f\u30a0-\u30ff\u3100-\u312f\u3200-\u32ff\u3400-\u4dbf\u4e00-\u9fff\uf900-\ufaff])/i
  CJK_BRACKET       = /([\u2e80-\u2eff\u2f00-\u2fdf\u3040-\u309f\u30a0-\u30ff\u3100-\u312f\u3200-\u32ff\u3400-\u4dbf\u4e00-\u9fff\uf900-\ufaff])([\(\[\{<\u201c>])/i
  BRACKET_CJK       = /([\)\]\}>\u201d<])([\u2e80-\u2eff\u2f00-\u2fdf\u3040-\u309f\u30a0-\u30ff\u3100-\u312f\u3200-\u32ff\u3400-\u4dbf\u4e00-\u9fff\uf900-\ufaff])/i
  FIX_BRACKET       = /([\(\[\{<\u201c]+)(\s*)(.+?)(\s*)([\)\]\}>\u201d]+)/i

  FIX_SYMBOL        = /([\u2e80-\u2eff\u2f00-\u2fdf\u3040-\u309f\u30a0-\u30ff\u3100-\u312f\u3200-\u32ff\u3400-\u4dbf\u4e00-\u9fff\uf900-\ufaff])([~!;:,\.\?\u2026])([A-Za-zΑ-Ωα-ω0-9])/i

  CJK_ANS           = /([\u2e80-\u2eff\u2f00-\u2fdf\u3040-\u309f\u30a0-\u30ff\u3100-\u312f\u3200-\u32ff\u3400-\u4dbf\u4e00-\u9fff\uf900-\ufaff])([A-Za-zΑ-Ωα-ω0-9`\$%\^&\*\-=\+\\\|\/@\u00a1-\u00ff\u2022\u2027\u2150-\u218f])/i
  ANS_CJK           = /([A-Za-zΑ-Ωα-ω0-9`~\$%\^&\*\-=\+\\\|\/!;:,\.\?\u00a1-\u00ff\u2022\u2026\u2027\u2150-\u218f])([\u2e80-\u2eff\u2f00-\u2fdf\u3040-\u309f\u30a0-\u30ff\u3100-\u312f\u3200-\u32ff\u3400-\u4dbf\u4e00-\u9fff\uf900-\ufaff])/i

  def self.spacing_text(text)
    text.gsub!(CJK_QUOTE, "\\1 \\2")
    text.gsub!(QUOTE_CJK, "\\1 \\2")

    text.gsub!(FIX_QUOTE, "\\1\\3\\5")
    text.gsub!(FIX_SINGLE_QUOTE, "\\1\\3\\4")

    text.gsub!(CJK_HASH, "\\1 \\2")
    text.gsub!(HASH_CJK, "\\1 \\3")

    text.gsub!(CJK_OPERATOR_ANS, "\\1 \\2 \\3")
    text.gsub!(ANS_OPERATOR_CJK, "\\1 \\2 \\3")

    old_text = text
    text.gsub!(CJK_BRACKET_CJK, "\\1 \\2 \\4")
    if old_text == text
      text.gsub!(CJK_BRACKET, "\\1 \\2")
      text.gsub!(BRACKET_CJK, "\\1 \\2")
    end
    text.gsub!(FIX_BRACKET, "\\1\\3\\5")

    text.gsub!(FIX_SYMBOL, "\\1\\2 \\3")

    text.gsub!(CJK_ANS, "\\1 \\2")
    text.gsub!(ANS_CJK, "\\1 \\2")
    text
  end

  def self.spacing(text)
    spacing_text(text)
  end
end
