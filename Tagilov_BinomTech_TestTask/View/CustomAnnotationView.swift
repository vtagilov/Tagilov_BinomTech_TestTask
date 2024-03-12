//
//  CustomAnnotationView.swift
//  Tagilov_BinomTech_TestTask
//
//  Created by Владимир on 12.03.2024.
//

import UIKit

final class CustomAnnotationView: UIView {
    var onSelect: (() -> Void)?
    var model: UserModel?
    
    private let button = UIButton()
    private let userImage = UIImageView.createCustomView()
    private let nameLabel = UILabel.createLabel(font: .boldSystemFont(ofSize: TextSize.verySmall))
    private let infoLabel = UILabel.createLabel(font: .boldSystemFont(ofSize: TextSize.verySmall), textColor: .darkGray)
    private let backgroundView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(model: UserModel) {
        self.model = model
        userImage.image = UIImage(data: model.imageData)
        nameLabel.text = model.name
        infoLabel.text = "\(model.observerMethod.rawValue), \(model.getLastSeenTime())"
    }
    
    private func setUpUI() {
        self.backgroundColor = .none
        
        button.setImage(UIImage(named: "TrackerImage"), for: .normal)
        button.frame = frame
        button.center = center
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        userImage.frame = CGRect(x: 10.5, y: 8, width: frame.width - 22, height: frame.height - 22)
        userImage.layer.cornerRadius = (userImage.frame.width) / 2
        userImage.clipsToBounds = true
        
        backgroundView.frame = CGRect(x: frame.maxX - 20, y: frame.maxY - 20, width: 90, height: 40)
        backgroundView.backgroundColor = .white
        backgroundView.layer.cornerRadius = 20.0
        
        nameLabel.textAlignment = .left
        nameLabel.frame = CGRect(x: backgroundView.frame.minX + 10, y: backgroundView.frame.minY, width: backgroundView.frame.width - 20, height: backgroundView.frame.height / 2)
        
        infoLabel.textAlignment = .left
        infoLabel.frame = CGRect(x: backgroundView.frame.minX + 10, y: backgroundView.frame.midY, width: backgroundView.frame.width - 20, height: backgroundView.frame.height / 2)
        
        for subview in [button, userImage, backgroundView, nameLabel, infoLabel] {
            addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = true
        }
    }
    
    @objc private func buttonAction() {
        if onSelect != nil {
            onSelect!()
        }
    }
}
