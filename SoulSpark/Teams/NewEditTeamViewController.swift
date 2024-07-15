//
//  NewEditTeamViewController.swift
//  SoulSpark
//
//  Created by Владимир Кацап on 15.07.2024.
//

import UIKit

protocol NewEditTeamViewControllerDelegte: AnyObject {
    func reloadCollection(arr: [Players])
}

class NewEditTeamViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    weak var delegate: TeamViewControllerDelegate?
    weak var editDelegate: DetailTeamViewControllerDelegate?
    
    var isNew = true
    var index = 0
    
    var playersArrNew = [Players]()
    var logoImageView: UIImageView?
    var descriptionTextView: UITextView?
    var winsTextField, defeatsTextField, drawTextField: UITextField?
    var titleTextField: UITextField?
    
    //ui
    var mainCollection, playersCollectionView: UICollectionView?
    var logoImage: UIImage?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.reload()
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.view.transform = CGAffineTransform(translationX: 0, y: -100)
            
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.view.transform = .identity
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.reload()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        createInterface()
        checIsNew()
    }
    
    func reload() {
        mainCollection?.reloadData()
        playersCollectionView?.reloadData()
    }
    
    func checIsNew() {
        if isNew == false {
            print(234)
            logoImageView?.image = UIImage(data: TeamArr[index].photo)
            titleTextField?.text = TeamArr[index].name
            descriptionTextView?.text = TeamArr[index].description
            winsTextField?.text = TeamArr[index].wins
            defeatsTextField?.text = TeamArr[index].defeats
            drawTextField?.text = TeamArr[index].draw
            playersArrNew = TeamArr[index].players
        }
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
        
        
        playersCollectionView = {
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
        
        
        
        mainCollection = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "main")
            collection.backgroundColor = .clear
            collection.showsVerticalScrollIndicator = false
            collection.delegate = self
            collection.dataSource = self
            return collection
        }()
        view.addSubview(mainCollection!)
        mainCollection?.snp.makeConstraints({ make in
            make.top.equalToSuperview().inset(40)
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
            
        })
        
        let saveButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Save", for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
            button.setTitleColor(UIColor(red: 30/255, green: 171/255, blue: 78/255, alpha: 1), for: .normal)
            return button
        }()
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.right.equalToSuperview().inset(15)
        }
        saveButton.addTarget(self, action: #selector(saveTeam), for: .touchUpInside)
       
    }
    
    
    @objc func saveTeam() {
        
        let team = Team(photo: logoImageView?.image?.jpegData(compressionQuality: 0.5) ?? Data(), name: titleTextField?.text ?? "", description: descriptionTextView?.text ?? "", wins: winsTextField?.text ?? "", defeats: defeatsTextField?.text ?? "", draw: drawTextField?.text ?? "", players: playersArrNew)
        
        
        
        
        if isNew == true {
            TeamArr.append(team)
            
            do {
                let data = try JSONEncoder().encode(TeamArr) //тут мкассив конвертируем в дату
                try saveAthleteArrToFile(data: data)
                self.dismiss(animated: true)
            } catch {
                print("Failed to encode or save athleteArr: \(error)")
            }
            
            
        } else {
            TeamArr[index] = team
            do {
                let data = try JSONEncoder().encode(TeamArr) //тут мкассив конвертируем в дату
                try saveAthleteArrToFile(data: data)
                editDelegate?.reload()
                self.dismiss(animated: true)
            } catch {
                print("Failed to encode or save athleteArr: \(error)")
            }
        }
    }
    
    func saveAthleteArrToFile(data: Data) throws {
        let fileManager = FileManager.default
        if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = documentDirectory.appendingPathComponent("team.plist")
            try data.write(to: filePath)
        } else {
            throw NSError(domain: "SaveError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to get document directory"])
        }
    }
    
    
    func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .black
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }
    
    func createTextField() -> UITextField {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.placeholder = "Text"
        textField.delegate = self
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.rightViewMode = .always
        textField.textColor = .black
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.gray.cgColor
        return textField
    }
    
    
    @objc func hideKey() {
        view.endEditing(true)
    }
    
    
    @objc func openAllPlayers() {
        let vc = NewPlayerInTeamViewController()
        vc.delegate = self
        vc.oldPlayers = playersArrNew
        self.present(vc, animated: true)
    }
    
    
    @objc func setImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = false
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let pickedImage = info[.originalImage] as? UIImage {
            logoImageView?.image = pickedImage
            logoImage = pickedImage
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}

extension NewEditTeamViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mainCollection {
            return 2
        } else {
            if playersArrNew.count == 0 {
                return 1
            } else {
                return playersArrNew.count
            }
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == mainCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "main", for: indexPath)
            cell.subviews.forEach { $0.removeFromSuperview() }
            
            if indexPath.row == 0 {
                cell.backgroundColor = .white
                
                let gestureHideKey = UITapGestureRecognizer(target: self, action: #selector(hideKey))
                cell.addGestureRecognizer(gestureHideKey)
                
                logoImageView = {
                    
                    let imageView = UIImageView(image: logoImage ?? .standartTeam)
                    imageView.contentMode = .scaleAspectFit
                    imageView.layer.borderColor = UIColor(red: 0/255, green: 71/255, blue: 255/255, alpha: 1).cgColor
                    imageView.layer.borderWidth = 2
                    imageView.layer.cornerRadius = 16
                    imageView.clipsToBounds = true
                    imageView.isUserInteractionEnabled = true
                    return imageView
                }()
                
                
                
                
                
                let gesture = UITapGestureRecognizer(target: self, action: #selector(setImage))
                logoImageView?.addGestureRecognizer(gesture)
                cell.addSubview(logoImageView!)
                logoImageView?.snp.makeConstraints({ make in
                    make.height.width.equalTo(140)
                    make.centerX.equalToSuperview()
                    make.top.equalToSuperview()
                })
                
                let titleText = createLabel(text: "Title")
                cell.addSubview(titleText)
                titleText.snp.makeConstraints { make in
                    make.top.equalTo(logoImageView!.snp.bottom).inset(-20)
                    make.left.equalToSuperview().inset(15)
                }
                
                titleTextField = createTextField()
                cell.addSubview(titleTextField!)
                titleTextField?.snp.makeConstraints({ make in
                    make.height.equalTo(54)
                    make.left.right.equalToSuperview().inset(15)
                    make.top.equalTo(titleText.snp.bottom).inset(-10)
                })
                
                let descTextLabel = createLabel(text: "Description")
                cell.addSubview(descTextLabel)
                descTextLabel.snp.makeConstraints { make in
                    make.top.equalTo(titleTextField!.snp.bottom).inset(-20)
                    make.left.equalToSuperview().inset(15)
                }
                
                descriptionTextView = {
                    let textView = UITextView()
                    textView.textColor = .black
                    textView.layer.cornerRadius = 12
                    textView.layer.borderWidth = 1
                    textView.layer.borderColor = UIColor.gray.cgColor
                    textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                    textView.backgroundColor = .white
                    return textView
                }()
                cell.addSubview(descriptionTextView!)
                descriptionTextView?.snp.makeConstraints({ make in
                    make.height.equalTo(160)
                    make.left.right.equalToSuperview().inset(15)
                    make.top.equalTo(descTextLabel.snp.bottom).inset(-10)
                })
                
                
                let stackView = UIStackView()
                stackView.axis = .horizontal
                stackView.backgroundColor = .clear
                stackView.spacing = 15
                stackView.distribution = .fillEqually
                cell.addSubview(stackView)
                stackView.snp.makeConstraints { make in
                    make.left.right.bottom.equalToSuperview().inset(15)
                    make.top.equalTo(descriptionTextView!.snp.bottom).inset(-15)
                }
                
                let winsView = UIView()
                let winsLabel = createLabel(text: "Wins")
                winsView.addSubview(winsLabel)
                winsLabel.snp.makeConstraints { make in
                    make.left.top.equalToSuperview()
                }
                winsTextField = createTextField()
                winsView.addSubview(winsTextField!)
                winsTextField?.snp.makeConstraints({ make in
                    make.height.equalTo(54)
                    make.left.right.equalToSuperview()
                    make.top.equalTo(winsLabel.snp.bottom).inset(-10)
                })
                
                
                let defView = UIView()
                let defLabel = createLabel(text: "Defeats")
                defView.addSubview(defLabel)
                defLabel.snp.makeConstraints { make in
                    make.left.top.equalToSuperview()
                }
                defeatsTextField = createTextField()
                defView.addSubview(defeatsTextField!)
                defeatsTextField?.snp.makeConstraints({ make in
                    make.height.equalTo(54)
                    make.left.right.equalToSuperview()
                    make.top.equalTo(defLabel.snp.bottom).inset(-10)
                })
                
                
                let drawView = UIView()
                let drawLabel = createLabel(text: "Draw")
                drawView.addSubview(drawLabel)
                drawLabel.snp.makeConstraints { make in
                    make.left.top.equalToSuperview()
                }
                drawTextField = createTextField()
                drawView.addSubview(drawTextField!)
                drawTextField?.snp.makeConstraints({ make in
                    make.height.equalTo(54)
                    make.left.right.equalToSuperview()
                    make.top.equalTo(drawLabel.snp.bottom).inset(-10)
                })
                
                stackView.addArrangedSubview(winsView)
                stackView.addArrangedSubview(defView)
                stackView.addArrangedSubview(drawView)
                
                if isNew == false {
                    logoImageView?.image = UIImage(data: TeamArr[index].photo)
                    titleTextField?.text = TeamArr[index].name
                    descriptionTextView?.text = TeamArr[index].description
                    winsTextField?.text = TeamArr[index].wins
                    defeatsTextField?.text = TeamArr[index].defeats
                    drawTextField?.text = TeamArr[index].draw
                }
                
                
                
                

            } else {
                cell.backgroundColor = .white
                let playersLabel = UILabel()
                playersLabel.text = "Participants"
                playersLabel.textColor = .black
                playersLabel.font = .systemFont(ofSize: 28, weight: .bold)
                cell.addSubview(playersLabel)
                playersLabel.snp.makeConstraints { make in
                    make.top.equalToSuperview()
                    make.left.equalToSuperview().inset(15)
                }
                
                let addButton = UIButton(type: .system)
                addButton.setImage(.blackPlus.resize(targetSize: CGSize(width: 24, height: 24)), for: .normal)
                addButton.backgroundColor = .clear
                addButton.tintColor = .black
                cell.addSubview(addButton)
                addButton.snp.makeConstraints { make in
                    make.height.width.equalTo(24)
                    make.centerY.equalTo(playersLabel.snp.centerY)
                    make.right.equalToSuperview().inset(15)
                }
                addButton.addTarget(self, action: #selector(openAllPlayers), for: .touchUpInside)
                
                cell.addSubview(playersCollectionView!)
                playersCollectionView?.backgroundColor = .white
                
                playersCollectionView?.snp.makeConstraints({ make in
                    make.bottom.left.right.equalToSuperview()
                    make.top.equalTo(playersLabel.snp.bottom).inset(-10)
                })

                
            }

            return cell
            
        } else {
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
            
            
            if playersArrNew.count == 0 {
                let label = UILabel()
                label.text = "You haven't added any entries"
                label.font = .systemFont(ofSize: 17, weight: .semibold)
                label.textColor = .black
                cell.addSubview(label)
                label.snp.makeConstraints { make in
                    make.centerX.centerY.equalToSuperview()
                }
            } else {
                let imageView = UIImageView(image: UIImage(data: playersArrNew[indexPath.row].photo))
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
                nameLabel.text = playersArrNew[indexPath.row].name
                nameLabel.font = .systemFont(ofSize: 17, weight: .semibold)
                cell.addSubview(nameLabel)
                nameLabel.snp.makeConstraints { make in
                    make.left.equalTo(imageView.snp.right).inset(-15)
                    make.bottom.equalTo(cell.snp.centerY)
                }
                
                let ageLabel = UILabel()
                ageLabel.text = "\(playersArrNew[indexPath.row].age) years old"
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
                typeButton.setTitle(playersArrNew[indexPath.row].role, for: .normal)
                typeButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                cell.addSubview(typeButton)
                typeButton.snp.makeConstraints { make in
                    make.height.equalTo(21)
                    make.right.top.equalToSuperview().inset(15)
                }
            }
            
            return cell
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == mainCollection {
            if indexPath.row == 0 {
                return CGSize(width: collectionView.frame.width, height: 590)
            } else {
                if playersArrNew.count == 0 {
                    return CGSize(width: collectionView.frame.width, height: 190)
                } else {
                    return CGSize(width: collectionView.frame.width, height: CGFloat(36 + (playersArrNew.count * 110)))
                }
            }
        } else {
            return CGSize(width: collectionView.frame.width - 15, height: 96)
        }
    }
    
    

    
}

extension NewEditTeamViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}


extension NewEditTeamViewController: NewEditTeamViewControllerDelegte {
    func reloadCollection(arr: [Players]) {
        playersArrNew = arr
        playersCollectionView?.reloadData()
        mainCollection?.reloadItems(at: [IndexPath(row: 1, section: 0)])
    }
    
    
}
