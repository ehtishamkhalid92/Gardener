//
//  TabBarVC.swift
//  Watering
//
//  Created by Ehtisham Khalid on 09.01.21.
//  Copyright © 2021 Macbook. All rights reserved.
//

import UIKit
import Firebase

class TabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        applyCustomViewOnTabbar()
        setupViews()
        setupTab()
        getProductDataFromDatabase()
    }
    
    private func applyCustomViewOnTabbar(){
        view.backgroundColor = .white
        tabBar.backgroundImage = UIImage.from(color: .clear)
        tabBar.shadowImage = UIImage()
        
        let tabbarBackgroundView = RoundShadowView(frame: tabBar.frame)
        tabbarBackgroundView.cornerRadius = 25
        tabbarBackgroundView.backgroundColor = .white
        tabbarBackgroundView.frame = tabBar.frame
        view.addSubview(tabbarBackgroundView)
        
        let fillerView = UIView()
        fillerView.frame = tabBar.frame
        fillerView.roundCorners([.topLeft, .topRight], radius: 25)
        fillerView.backgroundColor = .white
        view.addSubview(fillerView)
        
        view.bringSubviewToFront(tabBar)
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        tabBar.shadowImage = UIImage()
        self.tabBar.layer.backgroundColor = UIColor.white.cgColor
        self.tabBar.layer.shadowColor = UIColor.black.cgColor
        self.tabBar.layer.shadowOffset = CGSize(width: 0, height: -8.0)
        self.tabBar.layer.shadowOpacity = 0.12
        self.tabBar.layer.shadowRadius = 10.0
        self.tabBar.layer.cornerRadius = 30
        self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        self.tabBar.layer.masksToBounds = true
        
    }
    
    private func setupTab(){
        //Plant
        let AddSB = UIStoryboard(name: "AddPlant", bundle: nil)
        let AddPlant = AddSB.instantiateViewController(withIdentifier: "AddPlantVC") as! AddPlantVC
        
        //Review
        let reviewSB = UIStoryboard(name: "Review", bundle: nil)
        let Jobs = reviewSB.instantiateViewController(withIdentifier: "AddGetPlantWaterVC") as! AddGetPlantWaterVC
        
        //Chat
        let ChatSB = UIStoryboard(name: "Chat", bundle: nil)
        let ChatNav = UINavigationController()
        let ChatVC = ChatSB.instantiateViewController(withIdentifier: "ChatLogVC") as! ChatLogVC
        ChatNav.viewControllers = [ChatVC]
        
        //...............Admin Tab..............//
        
        //Admin
        let AdminSB = UIStoryboard(name: "Chat", bundle: nil)
        let AdminVC = AdminSB.instantiateViewController(withIdentifier: "AdminUserVC") as! AdminUserVC
        
        //All Plants
        let AdminPlantVC = AdminSB.instantiateViewController(withIdentifier: "AdminAllPlantsVC") as! AdminAllPlantsVC
        
        //Payments
        let AdminPaymentsVC = AdminSB.instantiateViewController(withIdentifier: "AdminPaymentTrackVC") as! AdminPaymentTrackVC
        
        let userRole = UserDefaults.standard.string(forKey: SessionManager.shared.userRole)?.lowercased()
        
        //Data
        if userRole == "admin" {
            self.viewControllers = [AdminVC,AdminPlantVC, AdminPaymentsVC, ChatNav]
        }else if userRole == "wcan" {
            self.viewControllers = [Jobs, ChatNav]
        }else {
            self.viewControllers = [AddPlant, Jobs, ChatNav]
        }
    }
    
    private func getProductDataFromDatabase() {
        let ref = Database.database().reference()
        ref.child("Inbox").observe(.childAdded) { (snapshot) in
            var array = [chatRoomModel]()
            var data = chatRoomModel()
            let dict  = snapshot.value as? NSDictionary
            data.chatId = dict?["chatId"] as? String ?? ""
            data.toId = dict?["toId"] as? String ?? ""
            data.toName = dict?["toName"] as? String ?? ""
            data.toImage = dict?["toImage"] as? String ?? ""
            data.fromId = dict?["fromId"] as? String ?? ""
            data.fromName = dict?["fromName"] as? String ?? ""
            data.fromImage = dict?["fromImage"] as? String ?? ""
            data.lastMsgSenderID = dict?["lastMsgSenderID"] as? String ?? ""
            data.Lastmsg = dict?["Lastmsg"] as? String ?? ""
            data.isRead = dict?["isRead"] as? Bool ?? false
            data.time = dict?["time"] as? String ?? ""
            data.jobID = dict?["jobID"] as? Int ?? -1
            data.rating = dict?["ratings"] as? String ?? "0"
            data.reviews = dict?["reviews"] as? Int ?? 0
            let userId = UserDefaults.standard.string(forKey: SessionManager.shared.userId) ?? ""
            
            if data.toId == userId || data.fromId == userId {
                array.append(data)
            }
            
            for item in array {
                if item.isRead == false && item.lastMsgSenderID != userId {
                    //Chat
                    if let tabItems = self.tabBar.items {
                        // In this case we want to modify the badge number of the third tab:
                        let tabItem = tabItems.last
                        tabItem?.badgeColor = .clear
                        tabItem?.badgeValue = "●"
                        tabItem?.setBadgeTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(hexString: "#029272")], for: .normal)
                    }
                }
            }
        }
    }
    
}



