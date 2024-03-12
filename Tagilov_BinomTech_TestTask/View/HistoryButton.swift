//
//  HistoryButton.swift
//  Tagilov_BinomTech_TestTask
//
//  Created by Владимир on 12.03.2024.
//

import UIKit

final class HistoryButton: UIButton {
    let cornerRadius = 16.0
    
    init() {
        super.init(frame: .zero)
        setUpUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        layer.cornerRadius = cornerRadius
        layer.backgroundColor = UIColor.blue.cgColor
        setTitle("Посмотреть историю", for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
    }
}
