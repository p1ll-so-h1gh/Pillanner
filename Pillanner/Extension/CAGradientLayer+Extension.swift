//
//  CAGradientLayer+Extension.swift
//  Pillanner
//
//  Created by 영현 on 2/22/24.
//

import UIKit

extension CAGradientLayer {
    static func dayBackgroundLayer(view: UIView) -> CAGradientLayer {
        var layer = CAGradientLayer()
        layer.frame = view.bounds
        layer.colors = [UIColor.dayBackgroundPurpleColor, UIColor.dayBackgroundPurpleColor]
        return layer
    }
}
