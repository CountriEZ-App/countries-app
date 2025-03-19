//
//  TabBarViewModel.swift
//  CountriEZ
//
//  Created by Emiliano Gil  on 16/03/25.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class TabBarViewModel {
    
    let provedor: ProviderUser
    
    init(provedor: ProviderUser){
        self.provedor = provedor
    }
    
    
    func logOut(completion: @escaping (Bool) -> Void) {
        switch provedor {
        case .normal:
            do {
                try Auth.auth().signOut()
                completion(true)
            } catch  {
                completion(false)
            }
        case .google:
            GIDSignIn.sharedInstance.signOut()
            do {
                try Auth.auth().signOut()
                completion(true)
            } catch  {
                completion(false)
            }
        }
    }
    
}
