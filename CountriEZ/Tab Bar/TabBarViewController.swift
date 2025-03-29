//
//  TabBarViewController.swift
//  CountriEZ
//
//  Created by Emiliano Gil  on 11/03/25.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    private let tabBarViewModel: TabBarViewModel
    
    private let provedorUser: ProviderUser
    private let emailUser: String
    
    private var rightButton: UIBarButtonItem?
    
    init(provedor: ProviderUser, email: String){
        self.tabBarViewModel = TabBarViewModel(provedor: provedor)
        self.provedorUser = provedor
        self.emailUser = email
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        navigationItem.setHidesBackButton(true, animated: false)
        setupRightBarButton()
        setupTabBar()
        
        let defaults = UserDefaults.standard
        defaults.set(provedorUser == .google ? "google" : "normal", forKey: "proveedor")
        defaults.set(emailUser, forKey: "email")
        defaults.synchronize()
       
    }
    
    
    private func setupRightBarButton() {
        rightButton = UIBarButtonItem(title: "Log Out", style: .done, target: self, action: #selector(didTapLogOut))
        rightButton?.tintColor = Theme.buttonsColor
        // Cambiar fuente a bold y tamaño
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 19, weight: .heavy) // Aquí defines tamaño y grosor
        ]
        
        rightButton?.setTitleTextAttributes(attributes, for: .normal)
        rightButton?.setTitleTextAttributes(attributes, for: .highlighted)
        navigationItem.rightBarButtonItem = rightButton
    }

    
    
    private func setupTabBar () {
        
        let searchVC = SearchViewController()
        let favoriteVC = FavoriteViewController()
        let gameVC = GameViewController()
        
        searchVC.tabBarItem.title = "Search"
        searchVC.tabBarItem.image = UIImage(systemName: "magnifyingglass.circle")
        searchVC.tabBarItem.selectedImage = UIImage(systemName: "magnifyingglass.circle.fill")
        
        let searchNV = UINavigationController(rootViewController: searchVC)
        
        
        favoriteVC.tabBarItem.title = "Favorite"
        favoriteVC.tabBarItem.image = UIImage(systemName: "star")
        favoriteVC.tabBarItem.selectedImage = UIImage(systemName: "star.fill")
        
        let favoriteNV = UINavigationController(rootViewController: favoriteVC)
        
        gameVC.tabBarItem.title = "Game"
        gameVC.tabBarItem.image = UIImage(systemName: "gamecontroller.circle")
        gameVC.tabBarItem.selectedImage = UIImage(systemName: "gamecontroller.circle.fill")
        
        let gameNV = UINavigationController(rootViewController: gameVC)
        
        viewControllers = [searchNV, favoriteNV, gameNV]
        
        tabBar.tintColor = Theme.buttonsColor 
        tabBar.unselectedItemTintColor = Theme.buttonsColor
    }
    
    
    @objc
    private func didTapLogOut() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "proveedor")
        defaults.removeObject(forKey: "email")
        defaults.synchronize()
        
        
        tabBarViewModel.logOut { [weak self] result in
            if result {
                self?.navigationController?.popViewController(animated: true)
            } else {
                print("Error al cerrar sesión")
            }
        }
        
    }
    
    
    // MARK: - UITabBarControllerDelegate
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 1 || tabBarController.selectedIndex == 2 {
            navigationController?.setNavigationBarHidden(true, animated: true)
        } else {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    

}


