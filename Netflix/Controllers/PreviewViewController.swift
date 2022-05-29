//
//  PreviewViewController.swift
//  Netflix
//
//  Created by newbie on 28.05.2022.
//

import UIKit
import WebKit

class PreviewViewController: UIViewController {
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "test"
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        return titleLabel
    }()
    
    private let descriptionLabel: UILabel = {
        let deskLabel = UILabel()
        deskLabel.translatesAutoresizingMaskIntoConstraints = false
        deskLabel.text = "test label"
        deskLabel.font = .systemFont(ofSize: 18, weight: .regular)
        deskLabel.numberOfLines = 0
        return deskLabel
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Download", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 8
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(webView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(downloadButton)
        
        configureConstrains()
    }
    
    func configure(with model: MoviePreviewViewModel) {
        
        titleLabel.text = model.title ?? "???"
        descriptionLabel.text = model.description ?? "???"
        
        if let videoId = model.trailer?.id?.videoId {
            guard let url = URL(string: "https://www.youtube.com/embed/\(videoId)") else {
                return
            }
            
            let request = URLRequest(url: url)
            
            webView.load(request)
        }
    }
    
    
    private func configureConstrains() {
        let webViewConstrains = [
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 250)
        ]
        
        let titleConstrains = [
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
        ]
        
        let descriptionConstrains = [
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ]
        
        let downloadButtonConstrains = [
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            downloadButton.heightAnchor.constraint(equalToConstant: 60),
            downloadButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        
        NSLayoutConstraint.activate(webViewConstrains)
        NSLayoutConstraint.activate(titleConstrains)
        NSLayoutConstraint.activate(descriptionConstrains)
        NSLayoutConstraint.activate(downloadButtonConstrains)
    }
    
}
