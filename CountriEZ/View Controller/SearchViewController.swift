//
//  SearchViewController.swift
//  PruebaCountiEZ
//
//  Created by Zelene Yosseline Isayana Montes Cantero on 11/03/25.
//

import UIKit
import Lottie

class SearchViewController: UIViewController {
    // ALL https://restcountries.com/v3.1/all
    // NAME https://restcountries.com/v3.1/name/deutschland
    // language  https://restcountries.com/v3.1/lang/spanish
    // capital https://restcountries.com/v3.1/capital/tallinn
    // region https://restcountries.com/v3.1/region/europe
    
    var animationLottie: LottieAnimationView!

    let label: UILabel = {
        let label = UILabel()
        label.text = "Search Country"
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let labelDetail: UILabel = {
        let label = UILabel()
        label.text = "Selecciona una opcion de busqueda"
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let buttonSearchAll: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.bordered()
        configuration.title = "All Countries"
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(searchAllCountry), for: .touchUpInside)
        button.configuration = configuration
        return button
    }()

    let buttonSearchName: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.bordered()
        configuration.title = "Name"
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(searchName), for: .touchUpInside)
        button.configuration = configuration
        return button
    }()
    
    let buttonSearchLanguage: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.bordered()
        configuration.title = "Language"
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(searchLanguage), for: .touchUpInside)
        button.configuration = configuration
        return button
    }()
    
    let buttonSearchCapital: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.bordered()
        configuration.title = "Capital"
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(searchCapital), for: .touchUpInside)
        button.configuration = configuration
        return button
    }()
    
    let buttonSearchRegion: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.bordered()
        configuration.title = "Region"
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(searchRegion), for: .touchUpInside)
        button.configuration = configuration
        return button
    }()
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    let tableView = UITableView(frame: .zero, style: .plain)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        constraints()
        
        //Search Bar
        searchBar.delegate = self
        
        //Table View
//        tableView.dataSource = self
//        tableView.delegate = self
    }
    
    
    func constraintButton(){
        [label, labelDetail, buttonSearchAll, buttonSearchName, buttonSearchLanguage, buttonSearchCapital, buttonSearchRegion].forEach(view.addSubview)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            labelDetail.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5),
            labelDetail.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            labelDetail.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            
            buttonSearchAll.topAnchor.constraint(equalTo: labelDetail.bottomAnchor, constant: 20),
            buttonSearchAll.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 45),
            
            
            buttonSearchName.topAnchor.constraint(equalTo: labelDetail.bottomAnchor, constant: 20),
            buttonSearchName.leadingAnchor.constraint(equalTo: buttonSearchAll.trailingAnchor, constant: 10),
            
            
            buttonSearchLanguage.topAnchor.constraint(equalTo: labelDetail.bottomAnchor, constant: 20),
            buttonSearchLanguage.leadingAnchor.constraint(equalTo: buttonSearchName.trailingAnchor, constant: 10),

            
            buttonSearchCapital.topAnchor.constraint(equalTo: buttonSearchAll.bottomAnchor, constant: 10),
            buttonSearchCapital.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 120),
            
            
            buttonSearchRegion.topAnchor.constraint(equalTo: buttonSearchAll.bottomAnchor, constant: 10),
            buttonSearchRegion.leadingAnchor.constraint(equalTo: buttonSearchCapital.trailingAnchor, constant: 10),
      
        ])
    }

    func constraintAnimationLottie(){
        animationLottie = LottieAnimationView(name: "AnimationWorld")
        animationLottie.contentMode = .scaleAspectFit
        animationLottie.loopMode = .loop
        animationLottie.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(animationLottie)
        animationLottie.play()
        
        NSLayoutConstraint.activate([
            animationLottie.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationLottie.topAnchor.constraint(equalTo: buttonSearchRegion.bottomAnchor, constant: 30),
            animationLottie.widthAnchor.constraint(equalToConstant: 200),
            animationLottie.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func constraintSearchBar(){
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 450),
            searchBar.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        ])
    }
    
    func constraints(){
        constraintButton()
        constraintAnimationLottie()
        constraintSearchBar()
    }
}


// MARK: - Search Bar
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
}


