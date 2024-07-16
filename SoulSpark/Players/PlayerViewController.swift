//
//  PlayerViewController.swift
//  SoulSpark
//
//  Created by Владимир Кацап on 16.07.2024.
//

import UIKit
 
protocol PlayerViewControllerDelegate: AnyObject {
    func reloadTable()
}

class PlayerViewController: UIViewController {
    
    var pickerArr = ["striker", "defender", "goalkeeper"]
    var picker: UISegmentedControl?
    
    //collection
    var arrPlayerSorted = [Players]()
    var collection: UICollectionView?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        createInterface()
    }
    
   

    

    func createInterface() {
        let labelTeams: UILabel = {
            let label = UILabel()
            label.text = "Players"
            label.font = .systemFont(ofSize: 34, weight: .bold)
            label.textColor = .black
            return label
        }()
        view.addSubview(labelTeams)
        labelTeams.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalToSuperview().inset(15)
        }
        
        
        picker = {
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
        view.addSubview(picker!)
        picker?.snp.makeConstraints({ make in
            make.height.equalTo(50)
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(labelTeams.snp.bottom).inset(-15)
        })
        picker?.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        
        
        let viewNewPlayer: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            view.layer.cornerRadius = 12
            view.layer.cornerRadius = 12
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOpacity = 0.25
            view.layer.shadowOffset = CGSize(width: 0, height: 2)
            view.layer.shadowRadius = 4
            view.layer.masksToBounds = false
            
            let label = UILabel()
            label.text = "Add a new player"
            label.font = .systemFont(ofSize: 17, weight: .semibold)
            label.textColor = .black
            view.addSubview(label)
            label.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(15)
                make.centerY.equalToSuperview()
            }
            
            let addButton = UIButton(type: .system)
            addButton.setImage(.plus.resize(targetSize: CGSize(width: 15, height: 15)), for: .normal)
            addButton.tintColor = .white
            addButton.backgroundColor = UIColor(red: 0/255, green: 71/255, blue: 255/255, alpha: 1)
            addButton.layer.cornerRadius = 12
            view.addSubview(addButton)
            addButton.snp.makeConstraints { make in
                make.height.width.equalTo(56)
                make.right.centerY.equalToSuperview()
            }
            addButton.addTarget(self, action: #selector(newEditPlayer), for: .touchUpInside)
            return view
        }()
        view.addSubview(viewNewPlayer)
        viewNewPlayer.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(picker!.snp.bottom).inset(-15)
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
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(viewNewPlayer.snp.bottom).inset(-10)
        })
        segmentChanged()
    }
    
    
    @objc func newEditPlayer() {
        let vc = NewAndEditPlayerViewController()
        vc.delegate = self
        vc.isNew = true
        self.present(vc, animated: true)
    }
    
    
    
    @objc func segmentChanged() {
        let selectedValue = pickerArr[picker?.selectedSegmentIndex ?? 0]
        print(selectedValue)
        arrPlayerSorted.removeAll()
        
        for i in playersArr {
            if i.role == selectedValue {
                arrPlayerSorted.append(i)
            }
        }
        collection?.reloadData()
        print(arrPlayerSorted)
    }
    
    
}

extension PlayerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if arrPlayerSorted.count == 0 {
            return 1
        } else {
            return arrPlayerSorted.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "main", for: indexPath)
        cell.subviews.forEach { $0.removeFromSuperview() }
        cell.layer.cornerRadius = 12
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.25
        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.layer.shadowRadius = 4
        cell.layer.masksToBounds = false
        cell.backgroundColor = .white
        
        
        
        if arrPlayerSorted.count == 0 {
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
        } else {
            collectionView.isUserInteractionEnabled = true
            
            let image = UIImage(data: arrPlayerSorted[indexPath.row].photo) ?? UIImage()
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.backgroundColor = .systemGray5
            imageView.layer.cornerRadius = 12
            cell.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.left.right.top.equalToSuperview()
                make.bottom.equalTo(cell.snp.centerY)
            }
            
            let nameLabel = UILabel()
            nameLabel.text = arrPlayerSorted[indexPath.row].name
            nameLabel.font = .systemFont(ofSize: 19, weight: .semibold)
            nameLabel.textColor = .black
            nameLabel.numberOfLines = 2
            cell.addSubview(nameLabel)
            nameLabel.snp.makeConstraints { make in
                make.left.right.equalToSuperview().inset(20)
                make.top.equalTo(imageView.snp.bottom).inset(-15)
            }
            
            let ageLabel = UILabel()
            ageLabel.text = "\(arrPlayerSorted[indexPath.row].age) years old"
            ageLabel.font = .systemFont(ofSize: 14, weight: .regular)
            ageLabel.textColor = .black
            ageLabel.textAlignment = .left
            cell.addSubview(ageLabel)
            ageLabel.snp.makeConstraints { make in
                make.left.right.equalToSuperview().inset(20)
                make.top.equalTo(nameLabel.snp.bottom).inset(-10)
            }
            
            let saparatorView = UIView()
            saparatorView.backgroundColor = UIColor(red: 165/255, green: 165/255, blue: 165/255, alpha: 1)
            cell.addSubview(saparatorView)
            saparatorView.snp.makeConstraints { make in
                make.height.equalTo(1)
                make.left.right.equalToSuperview().inset(20)
                make.top.equalTo(ageLabel.snp.bottom).inset(-15)
            }
            
            let roleLabel = UILabel()
            roleLabel.text = "Role"
            roleLabel.font = .systemFont(ofSize: 15, weight: .semibold)
            roleLabel.textColor = .black
            cell.addSubview(roleLabel)
            roleLabel.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(20)
                make.top.equalTo(saparatorView.snp.bottom).inset(-10)
            }
            
            let buttonRole = UIButton()
            buttonRole.setTitle(arrPlayerSorted[indexPath.row].role, for: .normal)
            buttonRole.setTitleColor(.white, for: .normal)
            buttonRole.backgroundColor = UIColor(red: 0/255, green: 71/255, blue: 255/255, alpha: 1)
            buttonRole.layer.cornerRadius = 8
            buttonRole.titleLabel?.font = .systemFont(ofSize: 11, weight: .semibold)
            buttonRole.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            cell.addSubview(buttonRole)
            buttonRole.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(20)
                make.height.equalTo(21)
                make.top.equalTo(roleLabel.snp.bottom).inset(-10)
            }
            
            
        }
        
        
        
        

        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if arrPlayerSorted.count > 0 {
            let collectionViewWidth = collectionView.bounds.width
               
               // Определяем количество ячеек в строке
               let numberOfItemsInRow: CGFloat = 2
               
               // Определяем отступы между ячейками и отступы слева/справа
               let spacing: CGFloat = 15
               let sectionInsets: CGFloat = 15 * 2 // Учитываем отступы слева и справа

               let totalSpacing = (numberOfItemsInRow - 1) * spacing + sectionInsets
               let itemWidth = (collectionViewWidth - totalSpacing) / numberOfItemsInRow
               return CGSize(width: itemWidth, height: 342)
        } else {
            return CGSize(width: collectionView.bounds.width - 30, height: 202)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15) // Отступы сверху, слева, снизу и справа
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailPlayerViewController()
        vc.delegate = self
        vc.player = arrPlayerSorted[indexPath.row]
        self.present(vc, animated: true)
    }
    
}


extension PlayerViewController: PlayerViewControllerDelegate {
    
    func reloadTable() {
        segmentChanged()
    }
    
    
}
