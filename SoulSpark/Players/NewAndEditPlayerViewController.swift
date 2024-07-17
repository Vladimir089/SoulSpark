//
//  NewAndEditPlayerViewController.swift
//  SoulSpark
//
//  Created by Владимир Кацап on 16.07.2024.
//

import UIKit

class NewAndEditPlayerViewController: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    var player: Players?
    var isNew = true
    
    var pickerArr = ["striker", "defender", "goalkeeper"]
    weak var delegate: PlayerViewControllerDelegate?
    weak var editDelegate: DetailPlayerViewControllerDelegate?
    
    //ui
    var imageViewPhoto: UIImageView?
    var segmentedRole: UISegmentedControl?
    var nameTextField: UITextField?
    var ageTextField: UITextField?
    var matchesTextField, goalsTextField, fineTextField: UITextField?
    var desctiptionTextView: UITextView?
    
    var saveButton: UIButton?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.view.transform = CGAffineTransform(translationX: 0, y: -280)
            
        }
    }
    
    
    func checkButton() {
        if nameTextField?.text?.count ?? 0 > 0 , ageTextField?.text?.count ?? 0 > 0 , matchesTextField?.text?.count ?? 0 > 0 , goalsTextField?.text?.count ?? 0 > 0 , fineTextField?.text?.count ?? 0 > 0 {
            saveButton?.isUserInteractionEnabled = true
            saveButton?.alpha = 1
        } else {
            saveButton?.isUserInteractionEnabled = false
            saveButton?.alpha = 0.5
        }
    }
    
    
    func checkIsNew() {
        if isNew == false {
            imageViewPhoto?.image = UIImage(data: player?.photo ?? Data())
            
            var index = 0
            
            let role: String = player?.role ?? ""
            
            for i in pickerArr {
                if i == role  {
                    print(i, index)
                    segmentedRole?.selectedSegmentIndex = index
                }
                index += 1
            }
            nameTextField?.text = player?.name ?? ""
            ageTextField?.text = player?.age ?? ""
            matchesTextField?.text = player?.matches ?? ""
            goalsTextField?.text = player?.goals ?? ""
            fineTextField?.text = player?.fine ?? ""
            desctiptionTextView?.text = player?.descriptiion ?? ""
            saveButton?.isUserInteractionEnabled = true
            saveButton?.alpha = 1
            
            
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.view.transform = .identity
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        createInterface()
        checkIsNew()
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
        
        saveButton = UIButton(type: .system)
        saveButton?.setTitle("Save", for: .normal)
        saveButton?.tintColor = UIColor(red: 30/255, green: 171/255, blue: 78/255, alpha: 1)
        saveButton?.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        view.addSubview(saveButton!)
        saveButton?.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(20)
        }
        saveButton?.isUserInteractionEnabled = false
        saveButton?.alpha = 0.5
        saveButton?.addTarget(self, action: #selector(save), for: .touchUpInside)
        
        imageViewPhoto = {
            let imageView = UIImageView(image: .standartTeam)
            imageView.contentMode = .scaleAspectFill
            imageView.layer.borderColor = UIColor(red: 0/255, green: 71/255, blue: 255/255, alpha: 1).cgColor
            imageView.layer.borderWidth = 2
            imageView.backgroundColor = .clear
            imageView.isUserInteractionEnabled = true
            imageView.layer.cornerRadius = 16
            imageView.clipsToBounds = true
            return imageView
        }()
        view.addSubview(imageViewPhoto!)
        imageViewPhoto?.snp.makeConstraints({ make in
            make.height.width.equalTo(140)
            make.centerX.equalToSuperview()
            make.top.equalTo(saveButton!.snp.bottom).inset(-10)
        })
        let gestureSelectPhoto = UITapGestureRecognizer(target: self, action: #selector(setImage))
        imageViewPhoto?.addGestureRecognizer(gestureSelectPhoto)
        
        let delButton = UIButton(type: .system)
        delButton.setTitle("Delete     ", for: .normal)
        delButton.alpha = 0
        delButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        delButton.setTitleColor(.red, for: .normal)
        let imageViewDell = UIImageView(image: .del)
        imageViewDell.contentMode = .scaleAspectFit
        delButton.addSubview(imageViewDell)
        imageViewDell.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.right.centerY.equalToSuperview()
        }
        delButton.addTarget(self, action: #selector(del), for: .touchUpInside)
        view.addSubview(delButton)
        delButton.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.width.equalTo(100)
            make.centerX.equalToSuperview()
            make.top.equalTo(imageViewPhoto!.snp.bottom).inset(-15)
        }
        
        if isNew == false {
            delButton.alpha = 1
        } else {
            delButton.alpha = 0
        }
        
        
        
        
        segmentedRole = {
            let picker = UISegmentedControl(items: pickerArr)
            picker.selectedSegmentTintColor = UIColor(red: 0/255, green: 71/255, blue: 255/255, alpha: 1)
            picker.backgroundColor = .white
            picker.layer.cornerRadius = 12
            picker.layer.shadowColor = UIColor.black.cgColor
            picker.layer.shadowOpacity = 0.25
            picker.layer.shadowOffset = CGSize(width: 0, height: 2)
            picker.layer.shadowRadius = 4
            picker.layer.masksToBounds = false
            picker.selectedSegmentIndex = 0
            // Устанавливаем атрибуты текста для нормального состояния
            let normalTextAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 13, weight: .regular),
                .foregroundColor: UIColor.black
            ]
            picker.setTitleTextAttributes(normalTextAttributes, for: .normal)
            
            // Устанавливаем атрибуты текста для выбранного состояния
            let selectedTextAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 13, weight: .semibold),
                .foregroundColor: UIColor.white
            ]
            picker.setTitleTextAttributes(selectedTextAttributes, for: .selected)
            
            return picker
        }()
        view.addSubview(segmentedRole!)
        segmentedRole?.snp.makeConstraints({ make in
            make.height.equalTo(50)
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(delButton.snp.bottom).inset(-10)
        })
        
        let titleLabel = cteateBlackLabel(text: "Title")
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(segmentedRole!.snp.bottom).inset(-15)
        }
        
        nameTextField = createTextField()
        view.addSubview(nameTextField!)
        nameTextField?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(54)
            make.top.equalTo(titleLabel.snp.bottom).inset(-10)
        })
        
        
        let ageLabel = cteateBlackLabel(text: "Age")
        view.addSubview(ageLabel)
        ageLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(nameTextField!.snp.bottom).inset(-15)
        }
        ageTextField = createTextField()
        view.addSubview(ageTextField!)
        ageTextField?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(54)
            make.top.equalTo(ageLabel.snp.bottom).inset(-10)
        })
        
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.backgroundColor = .clear
        stackView.spacing = 15
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview().inset(15)
            make.top.equalTo(ageTextField!.snp.bottom).inset(-15)
        }
        
        let winsView = UIView()
        let winsLabel = cteateBlackLabel(text: "Matches")
        winsView.addSubview(winsLabel)
        winsLabel.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
        }
        matchesTextField = createTextField()
        winsView.addSubview(matchesTextField!)
        matchesTextField?.snp.makeConstraints({ make in
            make.height.equalTo(54)
            make.left.right.equalToSuperview()
            make.top.equalTo(winsLabel.snp.bottom).inset(-10)
        })
        
        
        let defView = UIView()
        let defLabel = cteateBlackLabel(text: "Goals")
        defView.addSubview(defLabel)
        defLabel.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
        }
        goalsTextField = createTextField()
        defView.addSubview(goalsTextField!)
        goalsTextField?.snp.makeConstraints({ make in
            make.height.equalTo(54)
            make.left.right.equalToSuperview()
            make.top.equalTo(defLabel.snp.bottom).inset(-10)
        })
        
        
        let drawView = UIView()
        let drawLabel = cteateBlackLabel(text: "Fine")
        drawView.addSubview(drawLabel)
        drawLabel.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
        }
        fineTextField = createTextField()
        drawView.addSubview(fineTextField!)
        fineTextField?.snp.makeConstraints({ make in
            make.height.equalTo(54)
            make.left.right.equalToSuperview()
            make.top.equalTo(drawLabel.snp.bottom).inset(-10)
        })
        
        stackView.addArrangedSubview(winsView)
        stackView.addArrangedSubview(defView)
        stackView.addArrangedSubview(drawView)
        
        
        
        let descLabel = cteateBlackLabel(text: "Description")
        view.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(fineTextField!.snp.bottom).inset(-15)
        }
        
        desctiptionTextView = {
            let textView = UITextView()
            textView.backgroundColor = .white
            textView.textColor = .black
            textView.layer.cornerRadius = 12
            textView.layer.borderWidth = 1
            textView.layer.borderColor = UIColor.gray.cgColor
            textView.contentInset  = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            return textView
        }()
        view.addSubview(desctiptionTextView!)
        desctiptionTextView?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.top.equalTo(descLabel.snp.bottom).inset(-10)
        })
        
        
        
        
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(hideKeyboardGesture)
        
    }
    
    @objc func hideKeyboard() {
        checkButton()
        view.endEditing(true)
    }
    
    @objc func del() {
        var index = 0
        
        let name:String  = player?.name ?? ""
        let role:String  = player?.role ?? ""
        let match:String  = player?.matches ?? ""
        
        for i in playersArr {
            if i.name == name , i.role == role, i.matches == match {
                playersArr.remove(at: index)
            }
            index += 1
        }
        
        do {
            let data = try JSONEncoder().encode(playersArr) //тут мкассив конвертируем в дату
            try saveAthleteArrToFile(data: data)
            self.dismiss(animated: true)
            editDelegate?.del()
        } catch {
            print("Failed to encode or save athleteArr: \(error)")
        }
        
        
    }
    
    
    
    
    @objc func save() {
        
        let player = Players(photo: imageViewPhoto?.image?.jpegData(compressionQuality: 0.5) ?? Data(), name: nameTextField?.text ?? "", age: ageTextField?.text ?? "", role: pickerArr[segmentedRole?.selectedSegmentIndex ?? 0], matches: matchesTextField?.text ?? "", goals: goalsTextField?.text ?? "", fine: fineTextField?.text ?? "", descriptiion: desctiptionTextView?.text ?? "")
        
        if isNew == true {
            playersArr.append(player)
        } else {
            var index = 0
            for i in playersArr {
                if i.name == player.name {
                    playersArr[index] = player
                }
                index += 1
            }
        }
        
        
        do {
            let data = try JSONEncoder().encode(playersArr) //тут мкассив конвертируем в дату
            try saveAthleteArrToFile(data: data)
            delegate?.reloadTable()
            editDelegate?.reload(player: player)
            self.dismiss(animated: true)
        } catch {
            print("Failed to encode or save athleteArr: \(error)")
        }
        
        
        
    }
    
    func saveAthleteArrToFile(data: Data) throws {
        let fileManager = FileManager.default
        if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = documentDirectory.appendingPathComponent("players.plist")
            try data.write(to: filePath)
        } else {
            throw NSError(domain: "SaveError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to get document directory"])
        }
    }
    
   
    
    
    @objc func setImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = false
        checkButton()
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let pickedImage = info[.originalImage] as? UIImage {
            imageViewPhoto?.image = pickedImage
            checkButton()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        checkButton()
    }
    
    
    func cteateBlackLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
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
 
}


extension NewAndEditPlayerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        checkButton()
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        checkButton()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkButton()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        checkButton()
    }
}
