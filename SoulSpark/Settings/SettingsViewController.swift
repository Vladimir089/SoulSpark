//
//  SettingsViewController.swift
//  SoulSpark
//
//  Created by Владимир Кацап on 17.07.2024.
//

import UIKit
import StoreKit
import WebKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        createInterface()
        view.backgroundColor = .white
    }
    
    func createInterface() {
        let labelTeams: UILabel = {
            let label = UILabel()
            label.text = "Settings"
            label.font = .systemFont(ofSize: 34, weight: .bold)
            label.textColor = .black
            return label
        }()
        view.addSubview(labelTeams)
        labelTeams.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalToSuperview().inset(15)
        }
        
        let shareApp: UIButton = {
            let button = UIButton(type: .system)
            button.backgroundColor = UIColor(red: 3/255, green: 32/255, blue: 55/255, alpha: 1)
            button.layer.cornerRadius = 12
            
            let shareLabel = UILabel()
            shareLabel.text = "Share app"
            shareLabel.textColor = .white
            shareLabel.font = .systemFont(ofSize: 20, weight: .semibold)
            button.addSubview(shareLabel)
            shareLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalTo(button.snp.centerY).offset(-5)
            }
            
            let imageView = UIImageView(image: .share)
            imageView.contentMode = .scaleAspectFit
            button.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.height.width.equalTo(24)
                make.centerX.equalToSuperview()
                make.top.equalTo(button.snp.centerY).offset(5)
            }
            
            return button
        }()
        shareApp.addTarget(self, action: #selector(shareApps), for: .touchUpInside)
        
        
        view.addSubview(shareApp)
        shareApp.snp.makeConstraints { make in
            make.height.equalTo(103)
            make.left.equalToSuperview().inset(15)
            make.right.equalTo(view.snp.centerX).offset(-7.5)
            make.top.equalTo(labelTeams.snp.bottom).inset(-30)
        }
        
        
        let rateApp: UIButton = {
            let button = UIButton(type: .system)
            button.backgroundColor = UIColor(red: 3/255, green: 32/255, blue: 55/255, alpha: 1)
            button.layer.cornerRadius = 12
            
            let shareLabel = UILabel()
            shareLabel.text = "Rate Us"
            shareLabel.textColor = .white
            shareLabel.font = .systemFont(ofSize: 20, weight: .semibold)
            button.addSubview(shareLabel)
            shareLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalTo(button.snp.centerY).offset(-5)
            }
            
            let imageView = UIImageView(image: .rate)
            imageView.contentMode = .scaleAspectFit
            button.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.height.width.equalTo(24)
                make.centerX.equalToSuperview()
                make.top.equalTo(button.snp.centerY).offset(5)
            }
            
            return button
        }()
        rateApp.addTarget(self, action: #selector(rateApps), for: .touchUpInside)
        
        view.addSubview(rateApp)
        rateApp.snp.makeConstraints { make in
            make.height.equalTo(103)
            make.left.equalTo(view.snp.centerX).offset(7.5)
            make.right.equalToSuperview().inset(15)
            make.top.equalTo(labelTeams.snp.bottom).inset(-30)
        }
        
        let policyApp: UIButton = {
            let button = UIButton(type: .system)
            button.backgroundColor = UIColor(red: 3/255, green: 32/255, blue: 55/255, alpha: 1)
            button.layer.cornerRadius = 12
            
            let shareLabel = UILabel()
            shareLabel.text = "Usage Policy"
            shareLabel.textColor = .white
            shareLabel.font = .systemFont(ofSize: 20, weight: .semibold)
            button.addSubview(shareLabel)
            shareLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalTo(button.snp.centerY).offset(-5)
            }
            
            let imageView = UIImageView(image: .policy)
            imageView.contentMode = .scaleAspectFit
            button.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.height.width.equalTo(24)
                make.centerX.equalToSuperview()
                make.top.equalTo(button.snp.centerY).offset(5)
            }
            
            return button
        }()
        
        view.addSubview(policyApp)
        policyApp.snp.makeConstraints { make in
            make.height.equalTo(103)
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(rateApp.snp.bottom).inset(-15)
        }
        policyApp.addTarget(self, action: #selector(policy), for: .touchUpInside)
        
        
        
    }
    
    
    @objc func shareApps() {
        let appURL = URL(string: "sdf")!
        let activityViewController = UIActivityViewController(activityItems: [appURL], applicationActivities: nil)
        
        // Настройка для показа в виде popover на iPad
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }

        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    @objc func policy() {
        let webVC = WebViewController()
        webVC.urlString = "sdfdsf"
        present(webVC, animated: true, completion: nil)
    }
    

    @objc func rateApps() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            if let url = URL(string: "sdf") {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    
    
    
 
}



class WebViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var urlString: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        
        // Загружаем URL
        if let urlString = urlString, let url = URL(string: urlString) {
            webView.load(URLRequest(url: url))
        }
    }
}
