//
//  TeamViewController.swift
//  SoulSpark
//
//  Created by Владимир Кацап on 13.07.2024.
//

import UIKit

protocol TeamViewControllerDelegate: AnyObject {
    func reload()
}

class TeamViewController: UIViewController {
    
    var teamsCountLabel, playersCountLabel: UILabel?
    var collection: UICollectionView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
        fillLabels()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        createInterface()
        TeamArr = loadAthleteArrFromFile() ?? [Team]()
        playersArr = loadAthleteArrFromFile() ?? [Players]()
        fillLabels()
    }
    
    
    func loadAthleteArrFromFile() -> [Players]? {
        let fileManager = FileManager.default
        guard let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Unable to get document directory")
            return nil
        }
        let filePath = documentDirectory.appendingPathComponent("players.plist")
        do {
            let data = try Data(contentsOf: filePath)
            let athleteArr = try JSONDecoder().decode([Players].self, from: data)
            return athleteArr
        } catch {
            print("Failed to load or decode athleteArr: \(error)")
            return nil
        }
    }
    

    func createInterface() {
        
        let labelTeams: UILabel = {
            let label = UILabel()
            label.text = "Teams"
            label.font = .systemFont(ofSize: 34, weight: .bold)
            label.textColor = .black
            return label
        }()
        view.addSubview(labelTeams)
        labelTeams.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalToSuperview().inset(15)
        }
        
        let teamsView = createClearView()
        view.addSubview(teamsView)
        teamsView.snp.makeConstraints { make in
            make.height.equalTo(84)
            make.right.equalTo(view.snp.centerX).offset(-7.5)
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(labelTeams.snp.bottom).inset(-20)
        }
        
        let playersView = createClearView()
        view.addSubview(playersView)
        playersView.snp.makeConstraints { make in
            make.height.equalTo(84)
            make.right.equalTo(view.snp.centerX).offset(-7.5)
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(teamsView.snp.bottom).inset(-15)
        }
        
        let newTeamView = createClearView()
        view.addSubview(newTeamView)
        newTeamView.snp.makeConstraints { make in
            make.top.equalTo(teamsView.snp.top)
            make.bottom.equalTo(playersView.snp.bottom)
            make.right.equalToSuperview().inset(15)
            make.left.equalTo(view.snp.centerX).offset(7.5)
        }
        
        let gradientView: UIView = {
            let view = UIImageView()
            view.image = .grad
            view.contentMode = .scaleAspectFill
            return view
        }()
        newTeamView.addSubview(gradientView)
        gradientView.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.left.right.top.equalToSuperview().inset(20)
        }
        
        
        teamsCountLabel = createLabels(color: UIColor(red: 0/255, green: 71/255, blue: 255/255, alpha: 1), font: .systemFont(ofSize: 28, weight: .bold))
        teamsCountLabel?.text = "0"
        teamsView.addSubview(teamsCountLabel!)
        teamsCountLabel?.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-7)
        })
        
        let teamsTextLabel = createLabels(color: UIColor(red: 160/255, green: 159/255, blue: 161/255, alpha: 1), font: .systemFont(ofSize: 13, weight: .semibold))
        teamsTextLabel.text = "Teams"
        teamsView.addSubview(teamsTextLabel)
        teamsTextLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(teamsCountLabel!.snp.bottom).inset(-2)
        }
        
        
        playersCountLabel = createLabels(color: UIColor(red: 0/255, green: 71/255, blue: 255/255, alpha: 1), font: .systemFont(ofSize: 28, weight: .bold))
        playersCountLabel?.text = "0"
        playersView.addSubview(playersCountLabel!)
        playersCountLabel?.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-7)
        })
        
        let playersTextLabel = createLabels(color: UIColor(red: 160/255, green: 159/255, blue: 161/255, alpha: 1), font: .systemFont(ofSize: 13, weight: .semibold))
        playersTextLabel.text = "Players"
        playersView.addSubview(playersTextLabel)
        playersTextLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(playersCountLabel!.snp.bottom).inset(-2)
        }
        
        let addATeamTextLabel = createLabels(color: .black, font: .systemFont(ofSize: 16, weight: .semibold))
        addATeamTextLabel.text = "Add a team"
        newTeamView.addSubview(addATeamTextLabel)
        addATeamTextLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        let addNewTeamButton: UIButton = {
            let button = UIButton(type: .system)
            button.backgroundColor = UIColor(red: 0/255, green: 71/255, blue: 255/255, alpha: 1)
            button.layer.cornerRadius = 12
            button.clipsToBounds = true
            button.setImage(.plus.resize(targetSize: CGSize(width: 21, height: 21)), for: .normal)
            button.imageView?.contentMode = .scaleAspectFit
            button.tintColor = .white
            return button
        }()
        addNewTeamButton.addTarget(self, action: #selector(createTeam), for: .touchUpInside)
        newTeamView.addSubview(addNewTeamButton)
        addNewTeamButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.left.right.bottom.equalToSuperview().inset(20)
        }
        
        collection = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "main")
            collection.backgroundColor = .clear
            collection.showsVerticalScrollIndicator = false
            collection.delegate = self
            collection.dataSource = self
            layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
            return collection
        }()
        view.addSubview(collection!)
        collection?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(newTeamView.snp.bottom).inset(-15)
        })
        
        fillLabels()
    }
    
    
    @objc func createTeam() {
        let vc = NewEditTeamViewController()
        vc.delegate = self
        vc.isNew = true
        self.present(vc, animated: true)
    }
    
    
    func fillLabels() {
        teamsCountLabel?.text = "\(TeamArr.count)"
        playersCountLabel?.text = "\(playersArr.count)"
        collection?.reloadData()
    }
    
    func loadAthleteArrFromFile() -> [Team]? {
        let fileManager = FileManager.default
        guard let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Unable to get document directory")
            return nil
        }
        let filePath = documentDirectory.appendingPathComponent("team.plist")
        do {
            let data = try Data(contentsOf: filePath)
            let athleteArr = try JSONDecoder().decode([Team].self, from: data)
            return athleteArr
        } catch {
            print("Failed to load or decode athleteArr: \(error)")
            return nil
        }
    }
    
    
    func createClearView() -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.25
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 4
        view.layer.masksToBounds = false
        return view
    }
    
    func createLabels(color: UIColor, font: UIFont) -> UILabel {
        let label = UILabel()
        label.font = font
        label.textColor = color
        return label
    }

}


extension TeamViewController: TeamViewControllerDelegate {
    func reload() {
        fillLabels()
        collection?.reloadData()
    }
}


extension TeamViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if TeamArr.count == 0 {
            return 1
        } else {
            return TeamArr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if TeamArr.count == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "main", for: indexPath)
            cell.subviews.forEach { $0.removeFromSuperview() }
            cell.layer.cornerRadius = 12
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOpacity = 0.25
            cell.layer.shadowOffset = CGSize(width: 0, height: 2)
            cell.layer.shadowRadius = 4
            cell.layer.masksToBounds = false
            collectionView.isUserInteractionEnabled = false
            let imageView = UIImageView(image: .noTeams)
            imageView.contentMode = .scaleAspectFit
            cell.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.height.width.equalTo(100)
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(-20)
            }
            
            let label = UILabel()
            label.text = "You haven't added any entries"
            label.font = .systemFont(ofSize: 17, weight: .semibold)
            label.textColor = .black
            cell.addSubview(label)
            label.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(imageView.snp.bottom).inset(-10)
            }
            
            cell.backgroundColor = .white
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "main", for: indexPath)
            cell.subviews.forEach { $0.removeFromSuperview() }
            cell.layer.cornerRadius = 16
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOpacity = 0.25
            cell.layer.shadowOffset = CGSize(width: 0, height: 2)
            cell.layer.shadowRadius = 4
            cell.layer.masksToBounds = false
            cell.backgroundColor = .white
            collectionView.isUserInteractionEnabled = true
            
            let imageViewLogo = UIImageView(image: UIImage(data: TeamArr[indexPath.row].photo))
            imageViewLogo.backgroundColor = .systemGray5
            imageViewLogo.layer.cornerRadius = 12
            imageViewLogo.clipsToBounds = true
            imageViewLogo.contentMode = .scaleAspectFill
            cell.addSubview(imageViewLogo)
            imageViewLogo.snp.makeConstraints { make in
                make.height.width.equalTo(56)
                make.left.top.equalToSuperview().inset(20)
            }
            
            let nameLabel = UILabel()
            nameLabel.text = TeamArr[indexPath.row].name
            nameLabel.font = .systemFont(ofSize: 22, weight: .semibold)
            nameLabel.textColor = .black
            nameLabel.numberOfLines = 2
            nameLabel.textAlignment = .left
            cell.addSubview(nameLabel)
            nameLabel.snp.makeConstraints { make in
                make.left.equalTo(imageViewLogo.snp.right).inset(-20)
                make.right.equalToSuperview().inset(20)
                make.top.equalToSuperview().inset(20)
                make.height.equalTo(28)
            }
            
            let detailsButt = UIButton()
            detailsButt.setTitle("Details", for: .normal)
            detailsButt.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
            detailsButt.setTitleColor(.white, for: .normal)
            detailsButt.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            detailsButt.backgroundColor = UIColor(red: 0/255, green: 71/255, blue: 255/255, alpha: 1)
            detailsButt.layer.cornerRadius = 12
            cell.addSubview(detailsButt)
            detailsButt.snp.makeConstraints { make in
                make.height.equalTo(40)
                make.width.equalTo(73)
                make.right.bottom.equalToSuperview().inset(20)
            }
            
            let label = UILabel()
            label.numberOfLines = 0
            label.text = TeamArr[indexPath.row].description
            label.font = .systemFont(ofSize: 16, weight: .regular)
            label.textColor = UIColor(red: 160/255, green: 159/255, blue: 161/255, alpha: 1)
            label.textAlignment = .left
            cell.addSubview(label)
            label.snp.makeConstraints { make in
                make.left.equalTo(imageViewLogo.snp.right).inset(-20)
                make.right.equalToSuperview().inset(20)
                make.top.equalTo(nameLabel.snp.bottom).inset(-5)
                make.bottom.equalTo(detailsButt.snp.top).inset(-5)
            }

            if TeamArr[indexPath.row].players.count >= 3 {
                let oneImage = createImageView(image: TeamArr[indexPath.row].players[0].photo)
                oneImage.backgroundColor = .red
                let twoImage = createImageView(image: TeamArr[indexPath.row].players[1].photo)
                twoImage.backgroundColor = .blue
                let threeImage = createImageView(image: TeamArr[indexPath.row].players[2].photo)
                threeImage.backgroundColor = .green
                
                let buttonNumb = UIButton()
                buttonNumb.setTitle("+\(TeamArr[indexPath.row].players.count - 3)", for: .normal)
                buttonNumb.backgroundColor = UIColor(red: 0/255, green: 71/255, blue: 255/255, alpha: 1)
                //buttonNumb.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                buttonNumb.titleLabel?.font = .systemFont(ofSize: 12, weight: .regular)
                buttonNumb.setTitleColor(.white, for: .normal)
                buttonNumb.layer.cornerRadius = 16
                
                cell.addSubview(oneImage)
                oneImage.snp.makeConstraints { make in
                    make.height.width.equalTo(32)
                    make.left.equalTo(imageViewLogo.snp.right).inset(-20)
                    make.centerY.equalTo(detailsButt.snp.centerY)
                }
                cell.addSubview(twoImage)
                twoImage.snp.makeConstraints { make in
                    make.height.width.equalTo(32)
                    make.left.equalTo(oneImage.snp.right).inset(10)
                    make.centerY.equalTo(detailsButt.snp.centerY)
                }
                cell.addSubview(threeImage)
                threeImage.snp.makeConstraints { make in
                    make.height.width.equalTo(32)
                    make.left.equalTo(twoImage.snp.right).inset(10)
                    make.centerY.equalTo(detailsButt.snp.centerY)
                }
                cell.addSubview(buttonNumb)
                buttonNumb.snp.makeConstraints { make in
                    make.height.width.equalTo(32)
                    make.left.equalTo(threeImage.snp.right).inset(10)
                    make.centerY.equalTo(detailsButt.snp.centerY)
                }
                
            } else if TeamArr[indexPath.row].players.count >= 2 {
                let oneImage = createImageView(image: TeamArr[indexPath.row].players[0].photo)
                oneImage.backgroundColor = .red
                let twoImage = createImageView(image: TeamArr[indexPath.row].players[1].photo)
                twoImage.backgroundColor = .blue

                
                let buttonNumb = UIButton()
                buttonNumb.setTitle("+\(TeamArr[indexPath.row].players.count - 2)", for: .normal)
                buttonNumb.backgroundColor = UIColor(red: 0/255, green: 71/255, blue: 255/255, alpha: 1)
                //buttonNumb.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                buttonNumb.titleLabel?.font = .systemFont(ofSize: 12, weight: .regular)
                buttonNumb.setTitleColor(.white, for: .normal)
                buttonNumb.layer.cornerRadius = 16
                
                cell.addSubview(oneImage)
                oneImage.snp.makeConstraints { make in
                    make.height.width.equalTo(32)
                    make.left.equalTo(imageViewLogo.snp.right).inset(-20)
                    make.centerY.equalTo(detailsButt.snp.centerY)
                }
                cell.addSubview(twoImage)
                twoImage.snp.makeConstraints { make in
                    make.height.width.equalTo(32)
                    make.left.equalTo(oneImage.snp.right).inset(10)
                    make.centerY.equalTo(detailsButt.snp.centerY)
                }

                cell.addSubview(buttonNumb)
                buttonNumb.snp.makeConstraints { make in
                    make.height.width.equalTo(32)
                    make.left.equalTo(twoImage.snp.right).inset(10)
                    make.centerY.equalTo(detailsButt.snp.centerY)
                }
            } else if TeamArr[indexPath.row].players.count >= 1 {
                let oneImage = createImageView(image: TeamArr[indexPath.row].players[0].photo)
                oneImage.backgroundColor = .red

                let buttonNumb = UIButton()
                buttonNumb.setTitle("+\(TeamArr[indexPath.row].players.count - 1)", for: .normal)
                buttonNumb.backgroundColor = UIColor(red: 0/255, green: 71/255, blue: 255/255, alpha: 1)
                //buttonNumb.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                buttonNumb.titleLabel?.font = .systemFont(ofSize: 12, weight: .regular)
                buttonNumb.setTitleColor(.white, for: .normal)
                buttonNumb.layer.cornerRadius = 16
                
                cell.addSubview(oneImage)
                oneImage.snp.makeConstraints { make in
                    make.height.width.equalTo(32)
                    make.left.equalTo(imageViewLogo.snp.right).inset(-20)
                    make.centerY.equalTo(detailsButt.snp.centerY)
                }

                cell.addSubview(buttonNumb)
                buttonNumb.snp.makeConstraints { make in
                    make.height.width.equalTo(32)
                    make.left.equalTo(oneImage.snp.right).inset(10)
                    make.centerY.equalTo(detailsButt.snp.centerY)
                }
            }
            
             
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailTeamViewController()
        vc.delegate = self
        vc.index = indexPath.row
        self.present(vc, animated: true)
    }
    
    func createImageView(image: Data) -> UIImageView {
        let imageView = UIImageView(image: UIImage(data: image))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        return imageView
    }
  
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if TeamArr.count == 0 {
            return CGSize(width: collectionView.frame.width - 30, height: 202)
        } else {
            return CGSize(width: collectionView.frame.width - 30, height: 228)
        }
    }
    
    
}
