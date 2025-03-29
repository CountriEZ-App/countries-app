//
//  GameViewController.swift
//  CountriEZ
//
//  Created by Emiliano Gil  on 11/03/25.
//

import UIKit

//import QuartzCore

class GameViewController: UIViewController {
    
    let gameViewModel = GameViewModel()

    var dataGameCountries: [DataCountries] = []
    var gameCountries: ([String], [String]) = ([], [])
    
    private var rightButtonReset: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "arrow.2.squarepath"), style: .plain, target: nil, action: nil)
        button.tintColor = Theme.buttonsColor
        return button
    }()
    
    private lazy var collectionGame: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        //Espacio entre filas
        layout.minimumLineSpacing = 16
        //
        layout.minimumInteritemSpacing = 16
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .systemBackground
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.backgroundColor
        collectionGame.backgroundColor = Theme.backgroundColor
        
        rightButtonReset.target = self
        rightButtonReset.action = #selector(didTapReset)
        navigationItem.rightBarButtonItem = rightButtonReset
        
        //Colecction
        collectionGame.delegate = self
        collectionGame.dataSource = self
        collectionGame.register(GameCollectionViewCell.self, forCellWithReuseIdentifier: gameViewModel.cellCollectionIdentifier)
        
        
        setupCollection()
        
        
        // Peticion URL
        APIService.shared.fetchCountries { data, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {return }
                self.dataGameCountries = data
                self.gameCountries = self.gameViewModel.randomCountries(data: self.dataGameCountries)
                self.collectionGame.reloadData()
            }
        }
        
    }


    private func setupCollection () {
        view.addSubview(collectionGame)
        
        NSLayoutConstraint.activate([
            collectionGame.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionGame.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionGame.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionGame.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc
    private func didTapReset() {
        gameViewModel.dictionaryGame.removeAll()
        gameViewModel.selectedIndexPaths.removeAll()
        gameCountries = gameViewModel.randomCountries(data: dataGameCountries)
        
        
        for cell in collectionGame.visibleCells {
            if let gameCell = cell as? GameCollectionViewCell {
                gameViewModel.resetCell(to: .systemGray5, cell: gameCell)
            }
        }
        
        collectionGame.reloadData()
    }

}

//MARK: - CollectionView
extension GameViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameCountries.0.count + gameCountries.1.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: gameViewModel.cellCollectionIdentifier, for: indexPath) as? GameCollectionViewCell else {
                return UICollectionViewCell()
            }

        cell.contentView.backgroundColor = Theme.itemCollection
        cell.label.textColor = Theme.textColor
        
        // Mostrar nombres de países y capitales en diferetes columnas
        if indexPath.item%2 == 0 {
            cell.label.text = gameCountries.0[indexPath.item / 2]
        } else {
            cell.label.text = gameCountries.1[(indexPath.item / 2) - Int(0.5)]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 60) / 2
        return CGSize(width: width, height: 95)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        guard let cell = collectionView.cellForItem(at: indexPath) as? GameCollectionViewCell else { return }
        
        // Volver al color original si hay una celda previamente seleccionada
        if indexPath.item%2 == 0 {
            if let lastIndexPath = gameViewModel.lastSelectedIndexPathEven, !lastIndexPath.isEmpty, let lastCell = collectionView.cellForItem(at: lastIndexPath) as? GameCollectionViewCell {
                gameViewModel.resetCell(to: Theme.itemCollection, cell: lastCell)
            }
        } else {
            if let lastIndexPath = gameViewModel.lastSelectedIndexPathOdd, !lastIndexPath.isEmpty, let lastCell = collectionView.cellForItem(at: lastIndexPath) as? GameCollectionViewCell{
                gameViewModel.resetCell(to: Theme.itemCollection, cell: lastCell)
            }
        }
        
        //Verde al seleccionar
        gameViewModel.resetCell(to: Theme.correctAnswer, cell: cell)

        //Informacion del item seleccionado
        guard let text = cell.label.text else {return}
        gameViewModel.informationOfItemSelected(at: indexPath.item, indexPath: indexPath, text: text)
        
        //Validar que hay un pais y una capital seleccionadas
        guard let countrySelect = gameViewModel.countryText, !countrySelect.isEmpty, let capitalSelect = gameViewModel.capitalText, !capitalSelect.isEmpty else {return}
        
        print("El país es: \(countrySelect), su capital: \(capitalSelect)")
        //Validar que la seleccion es correcta o no
        let result = gameViewModel.goodOrBadSelected()
        print(result ? "Correcto" : "Incorrecto")
        
        //Azul si es correcto
        if result {
            
            if let lastIndexPathEven = gameViewModel.lastSelectedIndexPathEven,
               let lastCellEven = collectionView.cellForItem(at: lastIndexPathEven) as? GameCollectionViewCell,
               let lastIndexPathObb = gameViewModel.lastSelectedIndexPathOdd,
               let lastCellObb = collectionView.cellForItem(at: lastIndexPathObb) as? GameCollectionViewCell {
                
                gameViewModel.correctItemsSelected(to: Theme.correctAnswer, cell: lastCellEven, lastItem: lastIndexPathEven)
                
                gameViewModel.correctItemsSelected(to: Theme.correctAnswer, cell: lastCellObb, lastItem: lastIndexPathObb)
                
                gameViewModel.resetInformacion()
            }
            
        }
        //Rojo a Por defecto si es incorrecto
        else {
            
            if let lastIndexPathEven = gameViewModel.lastSelectedIndexPathEven,
               let lastCellEven = collectionView.cellForItem(at: lastIndexPathEven) as? GameCollectionViewCell,
               let lastIndexPathObb = gameViewModel.lastSelectedIndexPathOdd,
               let lastCellObb = collectionView.cellForItem(at: lastIndexPathObb) as? GameCollectionViewCell{
                
                gameViewModel.incorrectItemsSelected(to: Theme.wrongAnswer, to: Theme.itemCollection, cell: lastCellEven)
                
                gameViewModel.incorrectItemsSelected(to: Theme.wrongAnswer, to: Theme.itemCollection, cell: lastCellObb)
                
                gameViewModel.resetInformacion()
            }
        }
    }
    
    //Deshabilita los items que ya se validaron correctos
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return !gameViewModel.selectedIndexPaths.contains(indexPath)
    }


}
