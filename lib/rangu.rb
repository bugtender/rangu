# frozen_string_literal: true

require "rangu/version"

module Rangu
  # Spacing rules adapted from pangu.py 4.0.6.1.
  CJK = "\\u2e80-\\u2eff\\u2f00-\\u2fdf\\u3040-\\u309f\\u30a0-\\u30fa\\u30fc-\\u30ff" \
        "\\u3100-\\u312f\\u3200-\\u32ff\\u3400-\\u4dbf\\u4e00-\\u9fff\\uf900-\\ufaff"

  ANY_CJK = /[#{CJK}]/

  CONVERT_TO_FULLWIDTH_CJK_SYMBOLS_CJK = /([#{CJK}])( *(?::+|\.) *)([#{CJK}])/
  CONVERT_TO_FULLWIDTH_CJK_SYMBOLS = /([#{CJK}]) *([~!;,?]+) */
  DOTS_CJK = /(\.{2,}|…)([#{CJK}])/
  FIX_CJK_COLON_ANS = /([#{CJK}]):([A-Z0-9()])/

  CJK_QUOTE = /([#{CJK}])([`"״])/
  QUOTE_CJK = /([`"״])([#{CJK}])/
  FIX_QUOTE_ANY_QUOTE = /([`"״]+)(\s*)(.+?)(\s*)([`"״]+)/

  CJK_SINGLE_QUOTE_BUT_POSSESSIVE = /([#{CJK}])('[^s])/
  SINGLE_QUOTE_CJK = /(')([#{CJK}])/
  FIX_POSSESSIVE_SINGLE_QUOTE = /([#{CJK}A-Za-z0-9])( )('s)/

  HASH_ANS_CJK_HASH = /([#{CJK}])(#)([#{CJK}]+)(#)([#{CJK}])/
  CJK_HASH = /([#{CJK}])(#([^ ]))/
  HASH_CJK = /(([^ ])#)([#{CJK}])/

  CJK_OPERATOR_ANS = %r{([#{CJK}])([+\-*/=&|<>])([A-Za-z0-9])}
  ANS_OPERATOR_CJK = %r{([A-Za-z0-9])([+\-*/=&|<>])([#{CJK}])}

  FIX_SLASH_AS = %r{(/) ([a-z\-_./]+)}
  FIX_SLASH_AS_SLASH = %r{([/.])([A-Za-z\-_./]+) (/)}

  CJK_LEFT_BRACKET = /([#{CJK}])([\(\[\{<>“])/
  RIGHT_BRACKET_CJK = /([)\]}<>”])([#{CJK}])/
  FIX_LEFT_BRACKET_ANY_RIGHT_BRACKET = /([\(\[\{<“]+)(\s*)(.+?)(\s*)([)\]}>”]+)/
  ANS_CJK_LEFT_BRACKET_ANY_RIGHT_BRACKET = /([A-Za-z0-9#{CJK}]) *(“)([A-Za-z0-9#{CJK}\-_ ]+)(”)/
  LEFT_BRACKET_ANY_RIGHT_BRACKET_ANS_CJK = /(“)([A-Za-z0-9#{CJK}\-_ ]+)(”) *([A-Za-z0-9#{CJK}])/

  AN_LEFT_BRACKET = /([A-Za-z0-9])([\(\[\{])/
  RIGHT_BRACKET_AN = /([)\]}])([A-Za-z0-9])/

  CJK_ANS = %r{([#{CJK}])([A-Za-z\u0370-\u03ff0-9@$%\^&*\-+\\=|/\u00a1-\u00ff\u2150-\u218f\u2700—\u27bf])}
  ANS_CJK = %r{([A-Za-z\u0370-\u03ff0-9~!$%\^&*\-+\\=|;:,./?\u00a1-\u00ff\u2150-\u218f\u2700—\u27bf])([#{CJK}])}

  S_A = /(%)([A-Za-z])/
  MIDDLE_DOT = /( *)([·•‧])( *)/

  TILDES = /~+/
  EXCLAMATION_MARKS = /!+/
  SEMICOLONS = /;+/
  COLONS = /:+/
  COMMAS = /,+/
  PERIODS = /\.+/
  QUESTION_MARKS = /\?+/

  def self.spacing(text)
    return text.dup if text.length <= 1 || !ANY_CJK.match?(text)

    new_text = normalize_fullwidth_symbols_between_cjk(text.dup)
    new_text = normalize_fullwidth_symbols_after_cjk(new_text)

    new_text = new_text.gsub(DOTS_CJK, "\\1 \\2")
    new_text = new_text.gsub(FIX_CJK_COLON_ANS, "\\1：\\2")

    new_text = new_text.gsub(CJK_QUOTE, "\\1 \\2")
    new_text = new_text.gsub(QUOTE_CJK, "\\1 \\2")
    new_text = new_text.gsub(FIX_QUOTE_ANY_QUOTE, "\\1\\3\\5")

    new_text = new_text.gsub(CJK_SINGLE_QUOTE_BUT_POSSESSIVE, "\\1 \\2")
    new_text = new_text.gsub(SINGLE_QUOTE_CJK, "\\1 \\2")
    new_text = new_text.gsub(FIX_POSSESSIVE_SINGLE_QUOTE, "\\1's")

    new_text = new_text.gsub(HASH_ANS_CJK_HASH, "\\1 \\2\\3\\4 \\5")
    new_text = new_text.gsub(CJK_HASH, "\\1 \\2")
    new_text = new_text.gsub(HASH_CJK, "\\1 \\3")

    new_text = new_text.gsub(CJK_OPERATOR_ANS, "\\1 \\2 \\3")
    new_text = new_text.gsub(ANS_OPERATOR_CJK, "\\1 \\2 \\3")

    new_text = new_text.gsub(FIX_SLASH_AS, "\\1\\2")
    new_text = new_text.gsub(FIX_SLASH_AS_SLASH, "\\1\\2\\3")

    new_text = new_text.gsub(CJK_LEFT_BRACKET, "\\1 \\2")
    new_text = new_text.gsub(RIGHT_BRACKET_CJK, "\\1 \\2")
    new_text = new_text.gsub(FIX_LEFT_BRACKET_ANY_RIGHT_BRACKET, "\\1\\3\\5")
    new_text = new_text.gsub(ANS_CJK_LEFT_BRACKET_ANY_RIGHT_BRACKET, "\\1 \\2\\3\\4")
    new_text = new_text.gsub(LEFT_BRACKET_ANY_RIGHT_BRACKET_ANS_CJK, "\\1\\2\\3 \\4")

    new_text = new_text.gsub(AN_LEFT_BRACKET, "\\1 \\2")
    new_text = new_text.gsub(RIGHT_BRACKET_AN, "\\1 \\2")

    new_text = new_text.gsub(CJK_ANS, "\\1 \\2")
    new_text = new_text.gsub(ANS_CJK, "\\1 \\2")
    new_text = new_text.gsub(S_A, "\\1 \\2")
    new_text.gsub(MIDDLE_DOT, "・").strip
  end

  class << self
    alias spacing_text spacing
  end

  def self.spacing_file(path)
    spacing(File.read(path, encoding: Encoding::UTF_8))
  end

  def self.normalize_fullwidth_symbols_between_cjk(text)
    while (matched = CONVERT_TO_FULLWIDTH_CJK_SYMBOLS_CJK.match(text))
      text[matched.begin(0)...matched.end(0)] = "#{matched[1]}#{convert_to_fullwidth(matched[2])}#{matched[3]}"
    end

    text
  end
  private_class_method :normalize_fullwidth_symbols_between_cjk

  def self.normalize_fullwidth_symbols_after_cjk(text)
    while (matched = CONVERT_TO_FULLWIDTH_CJK_SYMBOLS.match(text))
      prefix = text[0, matched.begin(0) + 1].strip
      suffix = text[matched.end(0)..].strip
      text = "#{prefix}#{convert_to_fullwidth(matched[2])}#{suffix}"
    end

    text
  end
  private_class_method :normalize_fullwidth_symbols_after_cjk

  def self.convert_to_fullwidth(symbols)
    symbols = symbols.gsub(TILDES, "～")
    symbols = symbols.gsub(EXCLAMATION_MARKS, "！")
    symbols = symbols.gsub(SEMICOLONS, "；")
    symbols = symbols.gsub(COLONS, "：")
    symbols = symbols.gsub(COMMAS, "，")
    symbols = symbols.gsub(PERIODS, "。")
    symbols.gsub(QUESTION_MARKS, "？").strip
  end
  private_class_method :convert_to_fullwidth
end
