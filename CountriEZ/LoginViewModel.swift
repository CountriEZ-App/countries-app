//
//  LoginViewModel.swift
//  CountriEZ
//
//  Created by Emiliano Gil  on 12/03/25.
//
import UIKit
import FirebaseAuth


protocol LoginViewModelDelegate: AnyObject {
    func didReceiveError(message: String)
}

class LoginViewModel {
    
    weak var delegate: LoginViewModelDelegate?
    
    func singUpUser (email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            guard let error = error else { return }
            let errorMessage = CostumEmailsErrors.codeError(error)
            self.delegate?.didReceiveError(message: errorMessage.errorMessage)
        }
    }
    
    func logInUser (email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result , error in
            if result != nil , error == nil {
                completion(true)
            } else {
                completion(false)
                guard let error = error else { return }
                let errorMessage = CostumEmailsErrors.codeError(error)
                self.delegate?.didReceiveError(message: errorMessage.errorMessage)
                
            }
        }
    }
    
}
