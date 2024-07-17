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

        settingsTab()
        UserDefaults.standard.setValue(true, forKey: "tab")
    }
    
    func settingsTab() {
        let teamVC = TeamViewController()
        let teamVCTabItem = UITabBarItem(title: "", image: .tab1.resize(targetSize: CGSize(width: 24, height: 24)), tag: 0)
        teamVC.tabBarItem = teamVCTabItem
        
        let playerVC = PlayerViewController()
        let playerVCTabItem = UITabBarItem(title: "", image: .tab2.resize(targetSize: CGSize(width: 24, height: 24)), tag: 1)
        playerVC.tabBarItem = playerVCTabItem
        
        let settingsVC = SettingsViewController()
        let settingsVCTabItem = UITabBarItem(title: "", image: .tab3.resize(targetSize: CGSize(width: 24, height: 24)), tag: 2)
        settingsVC.tabBarItem = settingsVCTabItem
        
        tabBar.unselectedItemTintColor = UIColor(red: 182/255, green: 198/255, blue: 252/255, alpha: 1)
        tabBar.tintColor = UIColor(red: 0/255, green: 71/255, blue: 255/255, alpha: 1)
       
        
        tabBar.backgroundColor = .white
        tabBar.layer.shadowColor = UIColor(red: 136/255, green: 137/255, blue: 137/255, alpha: 1).cgColor
        tabBar.layer.shadowOpacity = 0.25
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        tabBar.layer.shadowRadius = 4
        tabBar.layer.masksToBounds = false
        
        viewControllers = [teamVC, playerVC, settingsVC]
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
