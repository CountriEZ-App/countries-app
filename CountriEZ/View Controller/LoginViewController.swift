//
//  LoginViewController.swift
//  CountriEZ
//
//  Created by Emiliano Gil  on 11/03/25.
//

import UIKit

class LoginViewController: UIViewController {
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var nameApp: UILabel = {
        let label = UILabel()
        label.text = "COUNTRIEZ"
        label.textAlignment = .center
        label.textColor = .systemMint
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.backgroundColor = .tertiarySystemGroupedBackground
        
        return label
    }()
    
    private lazy var textFieldEmail: UITextField = {
        let textField = UITextField()
        textField.placeholder = " E-mail"
        textField.backgroundColor = .white
        textField.font = .systemFont(ofSize: 15)
        textField.layer.cornerRadius = 5
        textField.layer.masksToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private lazy var textFieldPassword: UITextField = {
        let textField = UITextField()
        textField.placeholder = " Password"
        textField.backgroundColor = .white
        textField.font = .systemFont(ofSize: 15)
        textField.layer.cornerRadius = 5
        textField.layer.masksToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private lazy var emailButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.title = " E-mail"
        config.image = UIImage(systemName: "envelope.fill")
        config.baseForegroundColor = .black
        config.buttonSize = .mini
        
        button.configuration = config
        button.backgroundColor = .systemMint
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapEmail), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var gmailButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.title = " Gmail"
        config.baseForegroundColor = .black
        config.buttonSize = .mini
        
        button.configuration = config
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        
        return button
    }()
    
    private lazy var appleButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.title = " Apple"
        config.image = UIImage(systemName: "apple.logo")
        config.baseForegroundColor = .white
        config.buttonSize = .mini
        
        button.configuration = config
        button.backgroundColor = .black
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        
        return button
    }()
    
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.spacing = 60

        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    private lazy var textFieldsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = 15
        
        return stack
    }()
    
    private lazy var buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 8
    
        return stack
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .tertiarySystemGroupedBackground
        
        setUpView()
    }

    
    func setUpView () {
        view.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 130),
            mainStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -205),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
        
        mainStack.addArrangedSubview(nameApp)
        mainStack.addArrangedSubview(setUptextFieldsStacks())
        mainStack.addArrangedSubview(setUpButtonsStack())
        
    }
    
    func setUptextFieldsStacks () -> UIStackView {
        textFieldsStack.addArrangedSubview(textFieldEmail)
        NSLayoutConstraint.activate([
            textFieldEmail.leadingAnchor.constraint(equalTo: textFieldsStack.leadingAnchor, constant: 12),
            textFieldEmail.trailingAnchor.constraint(equalTo: textFieldsStack.trailingAnchor, constant: -12)
        ])
        
        
        textFieldsStack.addArrangedSubview(textFieldPassword)
        NSLayoutConstraint.activate([
            textFieldPassword.leadingAnchor.constraint(equalTo: textFieldsStack.leadingAnchor, constant: 12),
            textFieldsStack.trailingAnchor.constraint(equalTo: textFieldsStack.trailingAnchor, constant: -12)
        ])
        
        return textFieldsStack
    }
    
    func setUpButtonsStack () -> UIStackView {
        buttonsStack.addArrangedSubview(emailButton)
        NSLayoutConstraint.activate([
            emailButton.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        buttonsStack.addArrangedSubview(gmailButton)
        buttonsStack.addArrangedSubview(appleButton)
        
        return buttonsStack
    }
    
    
    @objc
    func didTapEmail () {
        let tabBarVC = TabBarViewController()
        navigationController?.pushViewController(tabBarVC, animated: true)
    }
    
    @objc
    func didTapGmail () {
        
    }
    
    @objc
    func didTapApple () {
        
    }
    

}

