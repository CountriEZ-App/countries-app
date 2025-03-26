//
//  DetailCountryViewController.swift
//  CountriEZ
//
//  Created by Emiliano Gil  on 17/03/25.
//

import UIKit

class DetailCountryViewController: UIViewController {


    private let detailViewModel: DetailCountryView
    
    
    private var rightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: nil, action: nil)
        return button
    }()
    
    private var rightButton2: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Location", style: .plain, target: nil, action: nil)
        return button
    }()
    
    private lazy var imageFlag: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var tableInformation: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private var leftButton: UIBarButtonItem?
    
    private lazy var buttonMap: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.title = "Ubication"
        config.background.backgroundColor = .systemBlue
        config.baseForegroundColor = .black
        
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(viewScreenMap), for: .touchUpInside)
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var infoFlagLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 7
        label.textAlignment = .justified
        label.text = detailViewModel.labelInformation ?? "No information"
        return label
    }()
    
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [imageFlag, infoFlagLabel, tableInformation])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 30
//        stack.contentMode = .scaleToFill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var footerTable: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 80))
        view.backgroundColor = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(country: DataCountries){
        self.detailViewModel = DetailCountryView(countryData: country)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tabbar = tabBarController?.viewControllers?.first, tabbar.navigationController != self {
        
            tabBarController?.navigationItem.rightBarButtonItem?.isHidden = true
        }
        
        setupView()
        
        tableInformation.delegate = self
        tableInformation.dataSource = self
        tableInformation.register(UITableViewCell.self, forCellReuseIdentifier: detailViewModel.cellIdentifier)
        
        navigationItem.title = detailViewModel.countryIdentification.nameCommon
        
        detailViewModel.fetchImageFlag { [weak self] image, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.imageFlag.image = image ?? UIImage(systemName: "photo")
            }
            
        }
        // Agregar target y acción aquí
        rightButton.image = UIImage(systemName: detailViewModel.updateImageButton(name: detailViewModel.countryIdentification.nameCommon))
        rightButton.target = self
        rightButton.action = #selector(addFavorite)
        
        rightButton2.target = self
        rightButton2.action = #selector(viewScreenMap)
        
        navigationItem.rightBarButtonItems = [rightButton, rightButton2]
        
        //        tableInformation.tableFooterView = footerTable
        //        setupFooterTable()
//        setupLeftBarButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
//        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
//        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setupView () {
        view.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            imageFlag.heightAnchor.constraint(equalToConstant: 170)
        ])
        
    }
    
//    private func setupRightBarButton() {
//        rightButton = UIBarButtonItem(title: "Log Out", style: .done, target: self, action: #selector(addFavorite))
//        navigationItem.rightBarButtonItem = rightButton
//    }
    
    private func setupFooterTable () {
        
//        let label: UILabel = {
//            let label = UILabel ()
//            label.text = "Hola Mundo"
//            label.textColor = .white
//            label.backgroundColor = .blue
//            label.translatesAutoresizingMaskIntoConstraints = false
//            return label
//        }()
        
//        NSLayoutConstraint.activate([
//            label.leadingAnchor.constraint(equalTo: footerTable.leadingAnchor, constant: 10),
//            label.trailingAnchor.constraint(equalTo: footerTable.trailingAnchor, constant: -10)
//        ])
        
//        footerTable.addSubview(label)
        
        tableInformation.tableFooterView = footerTable
    }

    private func setupLeftBarButton() {
        leftButton = UIBarButtonItem(title: "Location", style: .done, target: self, action: #selector(viewScreenMap))
        // Agregar el botón de Back junto con el botón personalizado
            if let backButton = navigationItem.backBarButtonItem ?? navigationController?.navigationBar.backItem?.backBarButtonItem {
                navigationItem.leftBarButtonItems = [backButton, leftButton!]
            } else {
                navigationItem.leftBarButtonItems = [leftButton!]
            }
    }
    
    @objc
    func viewScreenMap (){
        let mapVC = MapViewController(coordinate: detailViewModel.coordinateCountry)
        present(mapVC, animated: true)
    }

    @objc
    func addFavorite() {
        let isFavorite = rightButton.image == UIImage(systemName: "star.fill")

//        let newImageName = isFavorite ? "star" : "star.fill"
//        rightButton.image = UIImage(systemName: newImageName)
        
        if isFavorite {
            detailViewModel.deleteCountryToFavorite(name: detailViewModel.countryIdentification.nameCommon)
            
        } else {
            detailViewModel.addCountryToFavorite(name: detailViewModel.countryIdentification.nameCommon, url: detailViewModel.imageFlag)
        }
        
        rightButton.image = UIImage(systemName: detailViewModel.updateImageButton(name: detailViewModel.countryIdentification.nameCommon))
    }
}

//MARK: - TableView
extension DetailCountryViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return detailViewModel.nameSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0, 1, 3:
            return 2
        case 2:
            return detailViewModel.language.count
        case 4:
            return 3
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let headers = detailViewModel.nameSections
        switch section {
        case 0:
            return headers[section]
        case 1:
            return headers[section]
        case 2:
            return headers[section]
        case 3:
            return headers[section]
        case 4:
            return headers[section]
        default:
            return ""
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: detailViewModel.cellIdentifier, for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        switch indexPath.section {
        case 0:
            let data = detailViewModel.countryIdentification
            content.text = indexPath.row == 0 ? data.nameCommon : data.nameOfficial
            content.secondaryText = indexPath.row == 0 ? "Common" : "Official"
            
        case 1:
            let data = detailViewModel.politicalAndAdministrativeData
            content.text = indexPath.row == 0 ? data.capital.joined(separator: ", ") : "\(data.population) people"
            content.secondaryText = indexPath.row == 0 ? "Capital" : "Population"
            
        case 2:
            content.text = detailViewModel.language[indexPath.row]
            
        case 3:
            let data = detailViewModel.economicData.first
            content.text = indexPath.row == 0 ? data?.currencyName : data?.currencySymbol
            content.secondaryText = indexPath.row == 0 ? "Currency" : "Symbol"
            
        case 4:
            let data = detailViewModel.geographicalLocation
            let texts = [data.continents.joined(separator: ", "), data.region, data.subregion]
            let subtitles = ["Continents", "Region", "Subregion"]
            
            content.text = texts[indexPath.row]
            content.secondaryText = subtitles[indexPath.row]
            
        default:
            break
        }
        
        cell.contentConfiguration = content
        return cell
    }

    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        guard section == 4 else { return nil } // Solo en la sección 4
//        
//        let view = UIView()
//        view.backgroundColor = .cyan
//        view.translatesAutoresizingMaskIntoConstraints = false
//        
//        view.addSubview(buttonMap)
//        
//        NSLayoutConstraint.activate([
//            buttonMap.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
//            buttonMap.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
//            buttonMap.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            buttonMap.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
////        ])
//        
//        return view
//    }
//
//    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return section == 4 ? 80 : 0
//    }

}
