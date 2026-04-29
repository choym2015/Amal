//
//  Theme.swift
//  Amal
//
//  Created by 조영민 on 4/25/26.
//

import UIKit

extension UIColor {
    // MARK: - Amal Color Palette

    /// #1a5c2e — Mauritanian green. Used for headers, primary buttons, Arabic card top half.
    static let amalGreen = UIColor(hex: 0x1a5c2e)

    /// #B22222 — Moroccan red. Used for secondary buttons, romanized card bottom half, result header.
    static let amalRed = UIColor(hex: 0xB22222)

    /// #EF9F27 — Mauritanian gold. Used for progress bar, highlights, "Got it" button.
    static let amalGold = UIColor(hex: 0xEF9F27)

    /// #faf7f2 — Warm sand. App background.
    static let amalBackground = UIColor(hex: 0xfaf7f2)

    // MARK: - Hex initializer

    convenience init(hex: UInt32, alpha: CGFloat = 1.0) {
        let r = CGFloat((hex >> 16) & 0xFF) / 255.0
        let g = CGFloat((hex >> 8)  & 0xFF) / 255.0
        let b = CGFloat(hex         & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}
