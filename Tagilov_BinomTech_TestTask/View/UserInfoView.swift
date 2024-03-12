//
//  UserInfoView.swift
//  Tagilov_BinomTech_TestTask
//
//  Created by Владимир on 12.03.2024.
//

import UIKit

extension MainViewController: UserInfoViewDelegate {
    func closeView() {
        userInfoView.isHidden = true
    }
}

protocol UserInfoViewDelegate {
    func closeView()
}

final class UserInfoView: UIView {
    var delegate: UserInfoViewDelegate?
    
    private let nameLabel = UILabel.createLabel()
    private let observerMethodLabel = UILabel.createLabel(font: .systemFont(ofSize: TextSize.small))
    private let calendarLabel = UILabel.createLabel(font: .systemFont(ofSize: TextSize.small))
    private let timeLabel = UILabel.createLabel(font: .systemFont(ofSize: TextSize.small))
    
    private let userImage = UIImageView.createCustomView()
    private let observerMethodIcon = UIImageView.createCustomView(image: UIImage(systemName: "wifi"), tintColor: .blue)
    private let calendarIcon = UIImageView.createCustomView(image: UIImage(systemName: "calendar"), tintColor: .blue)
    private let clockIcon = UIImageView.createCustomView(image: UIImage(systemName: "clock"), tintColor: .blue)
    
    private let historyButton = HistoryButton()
    private let closeButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isHidden = true
        configureConstraints()
        setUpUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(model: UserModel) {
        nameLabel.text = model.name
        observerMethodLabel.text = model.observerMethod.rawValue
        userImage.image = UIImage(data: model.imageData)
        calendarLabel.text = model.getLastSeenDay()
        timeLabel.text = model.getLastSeenTime()
    }
    
    private func setUpUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        userImage.layer.cornerRadius = (frame.height / 3.5) / 2
        userImage.layer.borderWidth = 3.0
        userImage.layer.borderColor = UIColor.blue.cgColor
        userImage.clipsToBounds = true
        nameLabel.textAlignment = .left
        closeButton.setBackgroundImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        setupGradientLayer()
    }
    
    private func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: -10, width: frame.width, height: 10)
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.lightGray.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        layer.addSublayer(gradientLayer)
    }
    @objc private func closeButtonAction() {
        delegate?.closeView()
    }
}

extension UserInfoView {
    private func configureConstraints() {
        let width = frame.width
        let height = frame.height
        let horizontalOffset = 16.0
        let verticalOffset = 32.0
        let horizontalSpacing = 4.0
        let iconSize = 20.0
        let labelHeight = 24.0
        
        for subview in [nameLabel, observerMethodLabel, userImage, observerMethodIcon, calendarIcon, clockIcon, historyButton, calendarLabel, timeLabel, closeButton] {
            addSubview(subview)
        }
        NSLayoutConstraint.activate([
            historyButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -verticalOffset),
            historyButton.heightAnchor.constraint(equalToConstant: height / 5),
            historyButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: width / 4),
            historyButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -width / 4),
            
            userImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalOffset),
            userImage.topAnchor.constraint(equalTo: topAnchor, constant: verticalOffset),
            userImage.bottomAnchor.constraint(equalTo: historyButton.topAnchor, constant: -verticalOffset),
            userImage.widthAnchor.constraint(equalTo: userImage.heightAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: userImage.topAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            nameLabel.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: horizontalOffset),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalOffset),
            
            observerMethodIcon.centerYAnchor.constraint(equalTo: observerMethodLabel.centerYAnchor),
            observerMethodIcon.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            observerMethodIcon.heightAnchor.constraint(equalToConstant: iconSize),
            observerMethodIcon.widthAnchor.constraint(equalToConstant: iconSize),
            
            observerMethodLabel.leadingAnchor.constraint(equalTo: observerMethodIcon.trailingAnchor, constant: horizontalSpacing),
            observerMethodLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            observerMethodLabel.bottomAnchor.constraint(equalTo: historyButton.topAnchor),
            
            calendarIcon.centerYAnchor.constraint(equalTo: observerMethodLabel.centerYAnchor),
            calendarIcon.leadingAnchor.constraint(equalTo: observerMethodLabel.trailingAnchor, constant: horizontalOffset),
            calendarIcon.heightAnchor.constraint(equalToConstant: iconSize),
            calendarIcon.widthAnchor.constraint(equalToConstant: iconSize),
            
            calendarLabel.leadingAnchor.constraint(equalTo: calendarIcon.trailingAnchor, constant: horizontalSpacing),
            calendarLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            calendarLabel.bottomAnchor.constraint(equalTo: historyButton.topAnchor),
            
            clockIcon.centerYAnchor.constraint(equalTo: calendarLabel.centerYAnchor),
            clockIcon.leadingAnchor.constraint(equalTo: calendarLabel.trailingAnchor, constant: horizontalOffset),
            clockIcon.heightAnchor.constraint(equalToConstant: iconSize),
            clockIcon.widthAnchor.constraint(equalToConstant: iconSize),
            
            timeLabel.leadingAnchor.constraint(equalTo: clockIcon.trailingAnchor, constant: horizontalSpacing),
            timeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            timeLabel.bottomAnchor.constraint(equalTo: historyButton.topAnchor),
            
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalOffset),
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: verticalOffset),
            closeButton.heightAnchor.constraint(equalToConstant: iconSize),
            closeButton.widthAnchor.constraint(equalTo: closeButton.heightAnchor)
        ])
    }
}
