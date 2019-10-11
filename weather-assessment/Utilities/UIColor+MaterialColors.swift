//
//  UIColor+MaterialColors.swift
//  weather-assessment
//
//  Created by Eugenio Baglieri on 10/10/2019.
//  Copyright © 2019 PED. All rights reserved.
//

import UIKit

extension UIColor {
    
    struct MaterialColors {
        static var turquoise: UIColor { return UIColor(r: 26, g: 188, b: 156) }
        static var emerald: UIColor { return UIColor(r: 46, g: 204, b: 113) }
        static var peterriver: UIColor { return UIColor(r: 52, g: 152, b: 219) }
        static var amethyst: UIColor { return UIColor(r: 155, g: 89, b: 182) }
        static var greenSea: UIColor { return UIColor(r: 22, g: 160, b: 133) }
        static var carrot: UIColor { return UIColor(r: 230, g: 126, b: 34) }
        static var alizarin: UIColor { return UIColor(r: 231, g: 76, b: 60) }
        static var sunflower: UIColor { return UIColor(r: 241, g: 196, b: 15) }
        static var pomegranate: UIColor { return UIColor(r: 192, g: 57, b: 43) }
        static var asbestos: UIColor { return UIColor(r: 127, g: 140, b: 141) }
        private init() {}
    }
    
    convenience init(r: UInt8, g: UInt8, b: UInt8, alpha: CGFloat = 1.0) {
        self.init(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: alpha)
    }
    
}



extension UIColor.MaterialColors {

    static var allCases: [UIColor] {
        return [turquoise, emerald, peterriver, amethyst, greenSea, carrot, alizarin, sunflower, pomegranate, asbestos]
    }
    
    static func random() -> UIColor {
        return allCases.randomElement()!
    }
}
