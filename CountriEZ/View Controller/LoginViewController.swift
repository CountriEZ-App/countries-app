//
//  LoginViewController.swift
//  CountriEZ
//
//  Created by Emiliano Gil  on 11/03/25.
//

import UIKit

class LoginViewController: UIViewController {
    
    private lazy var nameApp: UILabel = {
        let label = UILabel()
        label.text = "COUNTRIEZ"
        label.textColor = .systemMint
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.backgroundColor = .tertiarySystemGroupedBackground
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var textFieldEmail: UITextField = {
        let textField = UITextField()
        textField.placeholder = "E-mail"
        
        return textField
    }()
    
    private lazy var textFieldPassword: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        
        return textField
    }()
    
    private lazy var emailButton: UIButton = {
        let button = UIButton()
        
        return button
    }()
    
    private lazy var gmailButton: UIButton = {
        let button = UIButton()
        
        return button
    }()
    
    private lazy var appleButton: UIButton = {
        let button = UIButton()
        
        return button
    }()
    
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView()
        
        return stack
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemCyan
    }


}

