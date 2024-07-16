//
//  NewPlayerInTeamViewController.swift
//  SoulSpark
//
//  Created by Владимир Кацап on 15.07.2024.
//

import UIKit

class NewPlayerInTeamViewController: UIViewController {
    
    weak var delegate: NewEditTeamViewControllerDelegte?
    var oldPlayers = [Players]()
    var collection: UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        settingsView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.reloadCollection(arr: oldPlayers)
    }
    

    func settingsView() {
        
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
        
        let labelPat = UILabel()
        labelPat.text = "Participants"
        labelPat.font = .systemFont(ofSize: 28, weight: .semibold)
        labelPat.textColor = .black
        view.addSubview(labelPat)
        labelPat.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(hideView.snp.bottom).inset(-25)
        }
        
        view.addSubview(collection!)
        collection?.snp.makeConstraints({ make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(labelPat.snp.bottom).inset(-5)
        })
    }
    
    

}


extension NewPlayerInTeamViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playersArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "second", for: indexPath)
        cell.subviews.forEach { $0.removeFromSuperview() }

        cell.layer.cornerRadius = 16
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.25
        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.layer.shadowRadius = 4
        cell.layer.masksToBounds = false
        
        let imageView = UIImageView(image: UIImage(data: playersArr[indexPath.row].photo))
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
        nameLabel.text = playersArr[indexPath.row].name
        nameLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        cell.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).inset(-15)
            make.bottom.equalTo(cell.snp.centerY)
        }
        
        let ageLabel = UILabel()
        ageLabel.text = "\(playersArr[indexPath.row].age) years old"
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
        typeButton.setTitle(playersArr[indexPath.row].role, for: .normal)
        typeButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        cell.addSubview(typeButton)
        typeButton.snp.makeConstraints { make in
            make.height.equalTo(21)
            make.right.top.equalToSuperview().inset(15)
        }
        
 
        
        
        if oldPlayers.contains(where: { $0.name == playersArr[indexPath.row].name }) {
            cell.backgroundColor = UIColor(red: 3/255, green: 32/255, blue: 55/255, alpha: 1)
            nameLabel.textColor = .white
        } else {
            cell.backgroundColor = .white
            nameLabel.textColor = .black
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 30, height: 96)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if let index = oldPlayers.firstIndex(where: { $0.name == playersArr[indexPath.row].name }) {
            oldPlayers.remove(at: index)
        } else {
            oldPlayers.append(playersArr[indexPath.row])
        }
        print(indexPath.row)
        collection?.reloadData()
        
    }
    

}
