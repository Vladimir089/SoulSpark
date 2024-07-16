//
//  DetailTeamViewController.swift
//  SoulSpark
//
//  Created by Владимир Кацап on 16.07.2024.
//

import UIKit

protocol DetailTeamViewControllerDelegate: AnyObject {
    func reload()
    func del()
}

class DetailTeamViewController: UIViewController {
    
    var index = 0
    var collection: UICollectionView?
    var logoImageView: UIImageView?
    var nameTeamLabel: UILabel?
    var descLabel: UILabel?
    weak var delegate: TeamViewControllerDelegate?
    
    var winsLabel, defLabel, drawLabel: UILabel?
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.reload()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        createInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadViews()
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
        
        logoImageView = {
            let imageView = UIImageView(image: UIImage(data: TeamArr[index].photo))
            imageView.layer.cornerRadius = 12
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
            return imageView
        }()
        view.addSubview(logoImageView!)
        logoImageView?.snp.makeConstraints({ make in
            make.height.width.equalTo(56)
            make.left.top.equalToSuperview().inset(30)
        })
        
        let editButton = UIButton(type: .system)
        editButton.setImage(.blackPencil.resize(targetSize: CGSize(width: 24, height: 24)), for: .normal)
        editButton.tintColor = .black
        editButton.backgroundColor = .white
        view.addSubview(editButton)
        editButton.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.right.top.equalToSuperview().inset(30)
        }
        editButton.addTarget(self, action: #selector(openEdit), for: .touchUpInside)
        
        nameTeamLabel = UILabel()
        nameTeamLabel?.text = TeamArr[index].name
        nameTeamLabel?.font = .systemFont(ofSize: 28, weight: .semibold)
        nameTeamLabel?.textColor = .black
        nameTeamLabel?.numberOfLines = 0
        nameTeamLabel?.textAlignment = .left
        view.addSubview(nameTeamLabel!)
        nameTeamLabel?.snp.makeConstraints({ make in
            make.left.equalTo(logoImageView!.snp.right).inset(-15)
            make.right.equalTo(editButton.snp.left).inset(-15)
            make.top.equalToSuperview().inset(25)
        })
        
        descLabel = UILabel()
        descLabel?.text = TeamArr[index].description
        descLabel?.numberOfLines = 0
        descLabel?.textAlignment = .left
        descLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        descLabel?.textColor = UIColor(red: 160/255, green: 159/255, blue: 161/255, alpha: 1)
        view.addSubview(descLabel!)
        descLabel?.snp.makeConstraints({ make in
            make.left.equalTo(logoImageView!.snp.right).inset(-15)
            make.right.equalToSuperview().inset(30)
            make.top.equalTo(nameTeamLabel!.snp.bottom).inset(-10)
        })
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 15
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.height.equalTo(84)
            make.left.right.equalToSuperview().inset(30)
            make.top.equalTo(descLabel!.snp.bottom).inset(-15)
        }
        
        let oneView = createViews(text: "Wins")
        winsLabel = UILabel()
        winsLabel?.text = TeamArr[index].wins
        winsLabel?.font = .systemFont(ofSize: 28, weight: .semibold)
        winsLabel?.textColor = .black
        oneView.addSubview(winsLabel!)
        winsLabel?.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(oneView.snp.centerY).offset(5)
        })
        stackView.addArrangedSubview(oneView)
        
        
        let twoView = createViews(text: "Defeats")
        defLabel = UILabel()
        defLabel?.text = TeamArr[index].defeats
        defLabel?.font = .systemFont(ofSize: 28, weight: .semibold)
        defLabel?.textColor = .black
        twoView.addSubview(defLabel!)
        defLabel?.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(twoView.snp.centerY).offset(5)
        })
        stackView.addArrangedSubview(twoView)
        
        
        let threeView = createViews(text: "Draw")
        drawLabel = UILabel()
        drawLabel?.text = TeamArr[index].draw
        drawLabel?.font = .systemFont(ofSize: 28, weight: .semibold)
        drawLabel?.textColor = .black
        threeView.addSubview(drawLabel!)
        drawLabel?.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(threeView.snp.centerY).offset(5)
        })
        stackView.addArrangedSubview(threeView)
        
        
        
        let partLabel = UILabel()
        partLabel.font = .systemFont(ofSize: 28, weight: .semibold)
        partLabel.textColor = .black
        partLabel.text = "Participants"
        view.addSubview(partLabel)
        partLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(30)
            make.top.equalTo(stackView.snp.bottom).inset(-15)
        }
        
        collection = {
            let layout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
            layout.scrollDirection = .vertical
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "second")
            collection.showsVerticalScrollIndicator = false
            collection.delegate = self
            collection.dataSource = self
            return collection
        }()
        view.addSubview(collection!)
        collection?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
            make.top.equalTo(partLabel.snp.bottom).inset(-10)
        })
        
    }
    
    func reloadViews() {
        collection?.reloadData()
        nameTeamLabel?.text = TeamArr[index].name
        descLabel?.text = TeamArr[index].description
        winsLabel?.text = TeamArr[index].wins
        defLabel?.text = TeamArr[index].defeats
        drawLabel?.text = TeamArr[index].draw
        logoImageView?.image = UIImage(data: TeamArr[index].photo)
    }
    
    
    @objc func openEdit() {
        let vc = NewEditTeamViewController()
        vc.isNew = false
        vc.index = index
        vc.editDelegate = self
        self.present(vc, animated: true)
    }
    
    
    func createViews(text: String) -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.25
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.masksToBounds = false
        
        let label = UILabel()
        label.text = text
        label.textColor = UIColor(red: 160/255, green: 159/255, blue: 161/255, alpha: 1)
        label.font = .systemFont(ofSize: 12, weight: .regular)
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.snp.centerY).offset(5)
        }
        
        return view
    }

}


extension DetailTeamViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TeamArr[index].players.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //ТАБЛИЦА С ИГРОКАМИ
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "second", for: indexPath)
        
        cell.subviews.forEach { $0.removeFromSuperview() }
        
        cell.layer.cornerRadius = 16
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.25
        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.layer.shadowRadius = 4
        cell.layer.masksToBounds = false
        cell.backgroundColor = .white
        
        
       
        let imageView = UIImageView(image: UIImage(data: TeamArr[index].players[indexPath.row].photo))
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 28
            imageView.backgroundColor = .systemGray5
            imageView.clipsToBounds = true
            cell.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.height.width.equalTo(56)
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().inset(15)
            }
            
            let nameLabel = UILabel()
            nameLabel.text = TeamArr[index].players[indexPath.row].name
            nameLabel.font = .systemFont(ofSize: 17, weight: .semibold)
            cell.addSubview(nameLabel)
            nameLabel.snp.makeConstraints { make in
                make.left.equalTo(imageView.snp.right).inset(-15)
                make.bottom.equalTo(cell.snp.centerY)
            }
            
            let ageLabel = UILabel()
            ageLabel.text = "\(TeamArr[index].players[indexPath.row].age) years old"
            ageLabel.font = .systemFont(ofSize: 15, weight: .regular)
            ageLabel.textColor =  UIColor(red: 160/255, green: 159/255, blue: 161/255, alpha: 1)
            cell.addSubview(ageLabel)
            ageLabel.snp.makeConstraints { make in
                make.left.equalTo(imageView.snp.right).inset(-15)
                make.top.equalTo(cell.snp.centerY)
            }
            
            
            let typeButton = UIButton()
            typeButton.backgroundColor = UIColor(red: 0/255, green: 71/255, blue: 255/255, alpha: 1)
            typeButton.layer.cornerRadius = 8
            typeButton.titleLabel?.textColor = .white
            typeButton.titleLabel?.font = .systemFont(ofSize: 11, weight: .semibold)
            typeButton.setTitle(TeamArr[index].players[indexPath.row].role, for: .normal)
            typeButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            cell.addSubview(typeButton)
            typeButton.snp.makeConstraints { make in
                make.height.equalTo(21)
                make.right.top.equalToSuperview().inset(15)
            
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 30, height: 96)
    }
    
}
 

extension DetailTeamViewController: DetailTeamViewControllerDelegate {
    func del() {
        self.dismiss(animated: true)
    }
    
    func reload() {
        reloadViews()
    }
    
    
}
