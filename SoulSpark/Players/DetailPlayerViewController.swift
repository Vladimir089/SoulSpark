//
//  DetailPlayerViewController.swift
//  SoulSpark
//
//  Created by Владимир Кацап on 16.07.2024.
//

import UIKit

protocol DetailPlayerViewControllerDelegate: AnyObject {
    func reload(player: Players)
    func del()
}

class DetailPlayerViewController: UIViewController {
    
    weak var delegate: PlayerViewControllerDelegate?
    var player: Players?
    
    //ui
    var imageViewPhoto: UIImageView?
    var nameLabel, yearsLabel: UILabel?
    var roleButton: UIButton?
    var mathesLabel, goalsLabel, fineslabel: UILabel?
    var descLabel: UILabel?
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.reloadTable()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        createInterface()
    }
    

    func createInterface() {
        
        let hideView = UIView()
        hideView.backgroundColor = UIColor(red: 60/255, green: 60/255, blue: 67/255, alpha: 0.3)
        hideView.layer.cornerRadius = 2.5
        view.addSubview(hideView)
        hideView.snp.makeConstraints { make in
            make.height.equalTo(5)
            make.width.equalTo(36)
            make.top.equalToSuperview().inset(5)
            make.centerX.equalToSuperview()
        }
        
        let saveButton = UIButton(type: .system)
        saveButton.setTitle("Edit", for: .normal)
        saveButton.tintColor = UIColor(red: 0/255, green: 71/255, blue: 255/255, alpha: 1)
        saveButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(20)
        }
        saveButton.addTarget(self, action: #selector(openEditPage), for: .touchUpInside)
        
        imageViewPhoto = {
            let imageView = UIImageView(image: UIImage(data: player?.photo ?? Data()))
            imageView.layer.cornerRadius = 12
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
            return imageView
        }()
        view.addSubview(imageViewPhoto!)
        imageViewPhoto?.snp.makeConstraints({ make in
            make.height.width.equalTo(170)
            make.centerX.equalToSuperview()
            make.top.equalTo(saveButton.snp.bottom).inset(-20)
        })
        
        nameLabel = {
            let label = UILabel()
            label.text = player?.name
            label.font = .systemFont(ofSize: 20, weight: .semibold)
            label.textColor = .black
            return label
        }()
        view.addSubview(nameLabel!)
        nameLabel?.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageViewPhoto!.snp.bottom).inset(-15)
        })
        
        yearsLabel = {
            let label = UILabel()
            
            let age: String = player?.age  ?? ""
            label.text = "\(age) years old"
            label.font = .systemFont(ofSize: 16, weight: .regular)
            label.textColor = UIColor(red: 160/255, green: 159/255, blue: 161/255, alpha: 1)
            return label
        }()
        view.addSubview(yearsLabel!)
        yearsLabel?.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLabel!.snp.bottom).inset(-10)
        })
        
        roleButton = {
            let button = UIButton()
            button.setTitle(player?.role, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = UIColor(red: 0/255, green: 71/255, blue: 255/255, alpha: 1)
            button.layer.cornerRadius = 8
            button.titleLabel?.font = .systemFont(ofSize: 11, weight: .semibold)
            button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            return button
        }()
        view.addSubview(roleButton!)
        roleButton?.snp.makeConstraints({ make in
            make.height.equalTo(21)
            make.centerX.equalToSuperview()
            make.top.equalTo(yearsLabel!.snp.bottom).inset(-10)
        })
        
        let statLabel = UILabel()
        statLabel.text = "Statistics"
        statLabel.textColor = .black
        statLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        view.addSubview(statLabel)
        statLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(roleButton!.snp.bottom).inset(-25)
        }
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 42
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.height.equalTo(37)
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(statLabel.snp.bottom).inset(-20)
        }
        
        
        
        mathesLabel = UILabel()
        goalsLabel = UILabel()
        fineslabel = UILabel()

        let viewOne = createView(image: UIImage.match, mainLabel: mathesLabel ?? UILabel(), secondText: "Matches")
        let viewTwo = createView(image: UIImage.goal, mainLabel: goalsLabel ?? UILabel(), secondText: "Goals")
        let viewThree = createView(image: UIImage.fine, mainLabel: fineslabel ?? UILabel(), secondText: "Fines")
        
        stackView.addArrangedSubview(viewOne)
        stackView.addArrangedSubview(viewTwo)
        stackView.addArrangedSubview(viewThree)
        
        
        descLabel = UILabel()
        descLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        descLabel?.textColor = UIColor(red: 160/255, green: 159/255, blue: 161/255, alpha: 1)
        descLabel?.numberOfLines = 0
        descLabel?.textAlignment = .left
        descLabel?.text = player?.descriptiion
        view.addSubview(descLabel!)
        descLabel?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(stackView.snp.bottom).inset(-15)
        })
    }
    
    @objc func openEditPage() {
        let vc = NewAndEditPlayerViewController()
        vc.editDelegate = self
        vc.player = player
        vc.isNew = false
        self.present(vc, animated: true)
    }
    
    
   
    
    func reloadAll() {
        imageViewPhoto?.image = UIImage(data: player?.photo ?? Data())
        nameLabel?.text = player?.name
        let age: String = player?.age  ?? ""
        yearsLabel?.text = "\(age) years old"
        roleButton?.setTitle(player?.role, for: .normal)
        mathesLabel?.text = player?.matches
        goalsLabel?.text = player?.goals
        fineslabel?.text = player?.fine
        descLabel?.text = player?.descriptiion
    }
    
    
    func createView(image: UIImage, mainLabel: UILabel, secondText: String) -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.width.equalTo(29)
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        
        
        mainLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        mainLabel.textColor = .black
        view.addSubview(mainLabel)
        mainLabel.snp.makeConstraints { make in
            make.top.right.equalToSuperview()
        }
        
  
        
        switch mainLabel {
        case mathesLabel:
            mainLabel.text = player?.matches
        case goalsLabel:
            mainLabel.text = player?.goals
        case fineslabel:
            mainLabel.text = player?.fine
        default:
            break
        }
        
        let secondLabel = UILabel()
        secondLabel.text = secondText
        secondLabel.font = .systemFont(ofSize: 11, weight: .semibold)
        secondLabel.textColor = .black
        view.addSubview(secondLabel)
        secondLabel.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview()
        }
        
        
        return view
    }
 

}


extension DetailPlayerViewController: DetailPlayerViewControllerDelegate {
    func del() {
        dismiss(animated: true)
        delegate?.reloadTable()
    }
    
    func reload(player: Players) {
        self.player = player
        reloadAll()
    }
}
