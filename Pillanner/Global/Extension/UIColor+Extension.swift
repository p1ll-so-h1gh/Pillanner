//
//  UIColor+Extension.swift
//  Pillanner
//
//  Created by 영현 on 2/22/24.
//

import UIKit

//MARK: - UIColor(hexCode: "hexCode") 로 사용할 수 있도록 하는 Extension
extension UIColor {
    convenience init(hexCode: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}

// MARK: - Point Colors
extension UIColor {
    static var mainThemeColor: UIColor {
        return UIColor(hexCode: "EDCAB8")
    }
    
    static var pointThemeColor: UIColor {
        return UIColor(hexCode: "E0966F")
    }
    
    static var pointThemeColor2: UIColor {
        return UIColor(hexCode: "FFC0B4")
    }
    
    static var pointThemeColor3: UIColor {
        return UIColor(hexCode: "F6EFFF")
    }
    
    static var pointThemeColor4: UIColor {
        return UIColor(hexCode: "FF9898")
    }
    
    static var primaryLabelColor: UIColor {
        return UIColor(hexCode: "000000")
    }
    
    static var secondaryLabelColor: UIColor {
        return UIColor(hexCode: "828282")
    }
    
    static var tertiaryLabelColor: UIColor {
        return UIColor(hexCode: "ABABAB")
    }
    
    static var primaryBackgroundColor: UIColor {
        return UIColor(hexCode: "FFFFFF")
    }
    
    static var dayBackgroundPurpleColor: UIColor {
        return UIColor(hexCode: "FEE9FE")
    }
    
    static var dayBackgroundBlueColor: UIColor {
        return UIColor(hexCode: "E2FAFF")
    }
}

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}


