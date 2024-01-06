//
//  FontExtension.swift
//  Foolstack
//
//  Created by Evgeniy Zolkin on 15.11.2023.
//

import Foundation
import UIKit

extension CGFloat {
  static let fontMainSize: CGFloat = 17
}

enum CustomFonts: String {
  case SFSemiboldItalic = "SFUIText-SemiboldItalic"
  case SFSemibold = "SFUIText-Semibold"
  case SFMedium = "SFUIText-Medium"
  case SFRegular = "SFUIText-Regular"
  case SFUITextItalic = "SFUIText-Italic"
  case SFUITextHeavyItalic = "SFUIText-HeavyItalic"
  case SFUITextLight = "SFUIText-Light"
  case SFUITextBoldItalic = "SFUIText-BoldItalic"
  case SFUITextLightItalic = "SFUIText-LightItalic"
  case SFUITextMediumItalic = "SFUIText-MediumItalic"
  case SFUITextBold = "SFUIText-Bold"
  case SFUITextHeavy = "SFUIText-Heavy"
  case Iowan = "Iowan Old Style"// "Iowan Old Style"
  case SanFrancisco = "San Francisco"
  case Athelas_Regular = "Athelas-Regular"
  case NewYork_Regular = "NewYork"
  case Seravek = "Seravek"
  case Georgia_BoldItalic = "Georgia-BoldItalic"
  case Georgia_Italic = "Georgia-Italic"
  case Georgia = "Georgia"
  case Georgia_Bold = "Georgia-Bold"
  case TimesNewRomanPS_ItalicMT = "TimesNewRomanPS-ItalicMT"
  case TimesNewRomanPS_BoldItalicMT = "TimesNewRomanPS-BoldItalicMT"
  case TimesNewRomanPS_BoldMT = "TimesNewRomanPS-BoldMT"
  case TimesNewRomanPSMT = "TimesNewRomanPSMT"
  case Palatino_Italic = "Palatino-Italic"
  case Palatino_Roman = "Palatino-Roman"
  case Palatino_BoldItalic = "Palatino-BoldItalic"
  case Palatino_Bold = "Palatino-Bold"
  case Charter_BlackItalic = "Charter-BlackItalic"
  case Charter_Bold = "Charter-Bold"
  case Charter_Roman = "Charter-Roman"
  case Charter_Black = "Charter-Black"
  case Charter_BoldItalic = "Charter-BoldItalic"
  case Charter_Italic = "Charter-Italic"
    
  /// Transform value to a valid font instance.
  ///
  /// - Parameter size: size of the font in points; `nil` to use system font size.
  /// - Returns: instance of the font.
  public func font(size: CGFloat?) -> UIFont {
//    #if os(tvOS)
//    return UIFont(name: self.rawValue, size: (size ?? TVOS_SYSTEMFONT_SIZE))!
//    #elseif os(watchOS)
//    return UIFont(name: self.rawValue, size: (size ?? WATCHOS_SYSTEMFONT_SIZE))!
//    #else
    return UIFont(name: self.rawValue, size: (size ?? UIFont.systemFontSize))!
//    #endif
  }

    static func defaultMedium(size: CGFloat) -> UIFont {
        return CustomFonts.SFMedium.font(size: size)
    }

    static func defaultRegular(size: CGFloat) -> UIFont {
        return CustomFonts.SFRegular.font(size: size)
    }

    static func defaultBold(size: CGFloat) -> UIFont {
        return CustomFonts.SFUITextBold.font(size: size)
    }

    static func defaultSemiBold(size: CGFloat) -> UIFont {
        return CustomFonts.SFSemibold.font(size: size)
    }

    static func defaultHeavy(size: CGFloat) -> UIFont {
        return CustomFonts.SFUITextHeavy.font(size: size)
    }

    static func defaultItalic(size: CGFloat) -> UIFont {
        return CustomFonts.SFUITextItalic.font(size: size)
    }

}
