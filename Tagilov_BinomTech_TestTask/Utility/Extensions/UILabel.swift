//
//  UILabel.swift
//  Tagilov_BinomTech_TestTask
//
//  Created by Владимир on 12.03.2024.
//

import UIKit

enum TextSize {
    static let verySmall = 12.0
    static let small = 16.0
    static let medium = 24.0
    static let large = 32.0
    static let veryLarge = 64.0
}

extension UILabel {
    static func createLabel(text: String = "", font: UIFont = .systemFont(ofSize: TextSize.medium), textColor: UIColor = .black) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = textColor
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
