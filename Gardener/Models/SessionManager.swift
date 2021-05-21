//
//  SessionManager.swift
//  Gardener
//
//  Created by Ehtisham Khalid on 12.05.21.
//

import Foundation
import Firebase

class SessionManager {
    
    //MARK:- UserDefaults Strings
    static let instance = SessionManager()
    var userData = UserModel()
    let defaults = UserDefaults.standard
    let user = "user"
    
    //MARK:- Private Functions
    func loginData() {
        if let savedPerson = defaults.object(forKey: self.user) as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(UserModel.self, from: savedPerson) {
                self.userData = loadedPerson
            }
        }
        if self.userData.isProfileCompleted == false {
            let SB = UIStoryboard(name: "Main", bundle: nil)
            let vc = SB.instantiateViewController(withIdentifier: "dateOfBirthVC") as! dateOfBirthVC
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = vc
        }else {
            let SB = UIStoryboard(name: "Main", bundle: nil)
            let vc = SB.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = vc
        }
        
    }
    
    
    func isUserLoggedIn() -> Bool {
      return Auth.auth().currentUser != nil
    }
    
    func logout() {
        do {
          try Auth.auth().signOut()
            defaults.set(nil, forKey: self.user)
            let SB = UIStoryboard(name: "Main", bundle: nil)
            let vc = SB.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = vc
        } catch {
            print("Error")
        }
    }
}
