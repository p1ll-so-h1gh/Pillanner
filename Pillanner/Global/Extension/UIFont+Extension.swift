//
// UIFont+Extension.swift
// Pillanner
//
// Created by 영현 on 2/22/24.
//

import UIKit

struct FontLiteral {
    enum FontStyle {
        case regular
        case bold
    }
    static func body(style: FontStyle) -> UIFont {
        return style == .regular ? UIFont.preferredFont(forTextStyle: .body) : UIFont.preferredFont(forTextStyle: .body).withTraits(.traitBold)
    }
    static func title2(style: FontStyle) -> UIFont {
        return style == .regular ? UIFont.preferredFont(forTextStyle: .title2) : UIFont.preferredFont(forTextStyle: .title2).withTraits(.traitBold)
    }
    static func title3(style: FontStyle) -> UIFont {
        return style == .regular ? UIFont.preferredFont(forTextStyle: .title3) : UIFont.preferredFont(forTextStyle: .title3).withTraits(.traitBold)
    }
    static func largeTitle(style: FontStyle) -> UIFont {
        return style == .regular ? UIFont.preferredFont(forTextStyle: .largeTitle) : UIFont.preferredFont(forTextStyle: .largeTitle).withTraits(.traitBold)
    }
    static func subheadline(style: FontStyle) -> UIFont {
        return style == .regular ? UIFont.preferredFont(forTextStyle: .subheadline) : UIFont.preferredFont(forTextStyle: .subheadline).withTraits(.traitBold)
    }
}
extension UIFont {
    func withTraits(_ traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0)
    }
}
