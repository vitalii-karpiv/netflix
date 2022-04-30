//
//  MainHeaderUIView.swift
//  Netflix
//
//  Created by newbie on 30.04.2022.
//

import UIKit

class HomeHeaderUIView: UIView {
    
    private let downloadButton: UIButton = {
        let donwloadButton = UIButton()
        donwloadButton.setTitle("Download", for: .normal)
        donwloadButton.layer.borderWidth = 1
        donwloadButton.layer.borderColor = UIColor.white.cgColor
        donwloadButton.translatesAutoresizingMaskIntoConstraints = false
        return donwloadButton
    }()
    
    private let playButton: UIButton = {
        let playButton = UIButton()
        playButton.setTitle("Play", for: .normal)
        playButton.layer.borderWidth = 1
        playButton.layer.borderColor = UIColor.white.cgColor
        playButton.translatesAutoresizingMaskIntoConstraints = false
        return playButton
    }()
    
    private let headerImageView: UIImageView = {
        let headerImageView = UIImageView()
        headerImageView.contentMode = .scaleAspectFill
        headerImageView.clipsToBounds = true
        headerImageView.image = UIImage(named: "elite")
        return headerImageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headerImageView)
        addGradient()
        addSubview(playButton)
        addSubview(downloadButton)
        applyConstrains()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        headerImageView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    private func applyConstrains() {
        let playButtonConstrains = [
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            playButton.widthAnchor.constraint(equalToConstant: 110)
        ]
        
        let downloadButtonConstrains = [
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            downloadButton.widthAnchor.constraint(equalToConstant: 110)
        ]
        
        NSLayoutConstraint.activate(playButtonConstrains + downloadButtonConstrains)
    }
    
}
