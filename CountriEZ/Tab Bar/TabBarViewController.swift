//
//  TabBarViewController.swift
//  CountriEZ
//
//  Created by Emiliano Gil  on 11/03/25.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBar()
        // Do any additional setup after loading the view.
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
        
        viewControllers = [searchNV, favoriteNV, gameVC]
    }

}
