//
//  OnbViewController.swift
//  SoulSpark
//
//  Created by Владимир Кацап on 13.07.2024.
//

import UIKit

class OnbViewController: UIViewController {
    
    var onbImageView: UIImageView?
    var nabelText: UILabel?
    var firstDot, secondDot: UIView?
    var tapNumb = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        createInterface()
    }
    

    func createInterface() {
        
        onbImageView = {
            let imageView = UIImageView(image: .onb1)
            imageView.contentMode = .scaleAspectFill
            return imageView
        }()
        view.addSubview(onbImageView!)
        onbImageView?.snp.makeConstraints({ make in
            make.left.right.top.bottom.equalToSuperview()
        })
        
        let botImage = UIView()
        botImage.backgroundColor = .white
        botImage.layer.cornerRadius = 20
        view.addSubview(botImage)
        botImage.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(222)
        }
        
        nabelText = {
            let label = UILabel()
            label.text = "All your favorite teams in one place"
            label.numberOfLines = 2
            label.font = .systemFont(ofSize: 32, weight: .semibold)
            label.textColor = .black
            label.textAlignment = .center
            return label
        }()
        botImage.addSubview(nabelText!)
        nabelText?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(20)
        })
        
        let nextButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Next", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = UIColor(red: 0/255, green: 71/255, blue: 255/255, alpha: 1)
            button.layer.cornerRadius = 12
            button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
            return button
        }()
        botImage.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(58)
            make.width.equalTo(159)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.right.equalToSuperview().inset(10)
        }
        nextButton.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        
        firstDot = {
            let view = UIView()
            view.backgroundColor = UIColor(red: 25/255, green: 118/255, blue: 210/255, alpha: 1)
            view.layer.cornerRadius = 5
            return view
        }()
        botImage.addSubview(firstDot!)
        firstDot?.snp.makeConstraints({ make in
            make.height.width.equalTo(10)
            make.centerY.equalTo(nextButton)
            make.left.equalToSuperview().inset(70)
        })
        
        
        secondDot = {
            let view = UIView()
            view.backgroundColor = UIColor(red: 198/255, green: 209/255, blue: 223/255, alpha: 1)
            view.layer.cornerRadius = 5
            return view
        }()
        botImage.addSubview(secondDot!)
        secondDot?.snp.makeConstraints({ make in
            make.height.width.equalTo(10)
            make.centerY.equalTo(nextButton)
            make.left.equalTo(firstDot!.snp.right).inset(-10)
        })
        
        
    }
    
    
    
    @objc func nextPage() {
        tapNumb += 1
        
        if tapNumb == 1 {
            UIView.animate(withDuration: 0.4) { [self] in
                onbImageView?.image = UIImage.onb2
                nabelText?.text = "Record your wins in the app"
                firstDot?.backgroundColor = UIColor(red: 198/255, green: 209/255, blue: 223/255, alpha: 1)
                secondDot?.backgroundColor = UIColor(red: 25/255, green: 118/255, blue: 210/255, alpha: 1)
            }
        }
        if tapNumb == 2 {
            self.navigationController?.setViewControllers([TabBarViewController()], animated: true)
        }
    }
    

}
