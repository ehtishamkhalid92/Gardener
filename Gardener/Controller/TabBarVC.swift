
//  TabBarVC.swift
//  Gardener
//
//  Created by Ehtisham Khalid on 12.05.21.
//

import UIKit
import Firebase

class TabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupTab()
    }
    
    
    private func setupViews() {
        self.view.backgroundColor = .white
        self.tabBar.tintColor = mediumGreen
        self.tabBar.shadowImage = UIImage()
        self.tabBar.layer.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.9843137255, blue: 0.8901960784, alpha: 1)
        self.tabBar.layer.cornerRadius = 30
        self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        self.tabBar.layer.masksToBounds = true
    }
    
    private func setupTab(){
        //Plant
        let AddSB = UIStoryboard(name: "Plant", bundle: nil)
        let AddPlant = AddSB.instantiateViewController(withIdentifier: "PlantVC") as! PlantVC
        
        //Review
        let jobSB = UIStoryboard(name: "Hiring", bundle: nil)
        let Jobs = jobSB.instantiateViewController(withIdentifier: "HiringVC") as! HiringVC
        
        //Chat
        let ChatSB = UIStoryboard(name: "Main", bundle: nil)
        let ChatNav = UINavigationController()
        let ChatVC = ChatSB.instantiateViewController(withIdentifier: "ChatRoomVC") as! ChatRoomVC
        ChatNav.viewControllers = [ChatVC]
        
        
        let user = SessionManager.instance.userData
        
        //Data
        if user.role == "A" {
//            self.viewControllers = [AdminVC,AdminPlantVC, AdminPaymentsVC, ChatNav]
        }else if user.role == "G" {
            self.viewControllers = [Jobs, ChatNav]
        }else {
            self.viewControllers = [AddPlant, Jobs, ChatNav]
        }
    }
    
    
}



