//
//  TabBarViewController.swift
//  SoulSpark
//
//  Created by Владимир Кацап on 13.07.2024.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        del() //УДАЛИТЬ
        settingsTab()
    }
    
    func settingsTab() {
        let teamVC = TeamViewController()
        let teamVCTabItem = UITabBarItem(title: "", image: .tab1.resize(targetSize: CGSize(width: 24, height: 24)), tag: 0)
        teamVC.tabBarItem = teamVCTabItem
        
        tabBar.unselectedItemTintColor = UIColor(red: 182/255, green: 198/255, blue: 252/255, alpha: 1)
        tabBar.tintColor = UIColor(red: 0/255, green: 71/255, blue: 255/255, alpha: 1)
       
        
        tabBar.backgroundColor = .white
        tabBar.layer.shadowColor = UIColor(red: 136/255, green: 137/255, blue: 137/255, alpha: 1).cgColor
        tabBar.layer.shadowOpacity = 0.25
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        tabBar.layer.shadowRadius = 4
        tabBar.layer.masksToBounds = false
        
        viewControllers = [teamVC]
    }
    
    
  
    
    
    func del() {  //ЭТО УДАЛИТЬ
        let player1 = Players(photo: Data(), name: "1", age: "1", role: "1", matches: "1", goals: "1", fine: "1", descriptiion: "1")
        let player2 = Players(photo: Data(), name: "2", age: "2", role: "2", matches: "2", goals: "2", fine: "2", descriptiion: "2")
        let player3 = Players(photo: Data(), name: "3", age: "3", role: "3", matches: "3", goals: "3", fine: "3", descriptiion: "3")
        let player4 = Players(photo: Data(), name: "4", age: "4", role: "4", matches: "4", goals: "4", fine: "4", descriptiion: "4")
        let player5 = Players(photo: Data(), name: "5", age: "5", role: "5", matches: "5", goals: "5", fine: "5", descriptiion: "5")
        playersArr.append(player1)
        playersArr.append(player2)
        playersArr.append(player3)
        playersArr.append(player4)
        playersArr.append(player5)
        
    }
}


extension UIImage {
    func resize(targetSize: CGSize) -> UIImage {
        let size = self.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        self.draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
