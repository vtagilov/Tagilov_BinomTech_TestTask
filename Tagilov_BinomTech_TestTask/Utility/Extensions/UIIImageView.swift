//
//  UIIImageView.swift
//  Tagilov_BinomTech_TestTask
//
//  Created by Владимир on 12.03.2024.
//

import UIKit

extension UIImageView {
    static func createCustomView(image: UIImage? = UIImage(), tintColor: UIColor = .black) -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = image
        imageView.tintColor = tintColor
        imageView.contentMode = .scaleAspectFill
        return imageView
    }
}
