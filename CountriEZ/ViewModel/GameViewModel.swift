//
//  GameViewModel.swift
//  CountriEZ
//
//  Created by Emiliano Gil  on 20/03/25.
//

import UIKit

class GameViewModel {
    
    private var dictionaryGame: [String:String] = [:]
    
    var lastSelectedIndexPathEven: IndexPath?
    var lastSelectedIndexPathOdd: IndexPath?
    
    var countryText: String?
    var capitalText: String?
    
    var selectedIndexPaths: Set<IndexPath> = []
    
    
    let cellCollectionIdentifier = "cell-game"
    
    func randomCountries (data: [DataCountries]) -> ([String],[String]){
        let countriesRandom = data.shuffled().prefix(6)
        
        // Extraer los nombres y capitales
        for data in countriesRandom {
            dictionaryGame[data.name.nameCountry] = data.capital?.first ?? "No capital"
        }
        
        let names = Array (dictionaryGame.keys.shuffled())
        let capitals = Array (dictionaryGame.values.shuffled())
        return (names, capitals)
    }
    
    
    // MARK: - Petición a la API
    func fetchCountries(completion: @escaping([DataCountries]?, Error?) -> Void) {
        guard let url = URL(string: "https://restcountries.com/v3.1/all") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            
            do {
                let dataCountry = try JSONDecoder().decode([DataCountries].self, from: data)
                completion(dataCountry, nil)
            } catch {
                print("Error al decodificar:", error)
            }
        }.resume()
    }
    

//MARK: - Logica Juego
    
    func resetCell(to color: UIColor, cell: GameCollectionViewCell) {
        let resetAnimation = CABasicAnimation(keyPath: "backgroundColor")
        resetAnimation.fromValue = cell.contentView.layer.backgroundColor
        resetAnimation.toValue = color.cgColor
        resetAnimation.duration = 0.5
        cell.contentView.layer.add(resetAnimation, forKey: "resetColorChange")
        cell.contentView.layer.backgroundColor = color.cgColor
    }
    
    func informationOfItemSelected(at item: Int, indexPath: IndexPath, text: String) {
        if item%2 == 0{
            lastSelectedIndexPathEven = indexPath
            print("Se asigna el nombre del pais")
            countryText = text
        }else {
            lastSelectedIndexPathOdd = indexPath
            print("Se asigna el nombre de la capital")
            capitalText = text
        }
    }
    
    
    func goodOrBadSelected () -> Bool {
        guard let country = countryText, !country.isEmpty else {return false}
        if dictionaryGame[country] == capitalText {
            return true
        } else {
            return false
        }
    }
    
    func correctItemsSelected (to color: UIColor, cell: GameCollectionViewCell, lastItem: IndexPath) {
        resetCell(to: color, cell: cell)
        
        if selectedIndexPaths.contains(lastItem) {
            print("Este item ya está seleccionado y deshabilitado.")
        }else {
            print("Se guarda el item en selecciones inhabilitadas")
            selectedIndexPaths.insert(lastItem)
        }
    }
    
    
    func incorrectItemsSelected (to colorError: UIColor,to colorReset: UIColor,  cell: GameCollectionViewCell) {
        let resetAnimation = CABasicAnimation(keyPath: "backgroundColor")
        resetAnimation.fromValue = cell.contentView.layer.backgroundColor
        resetAnimation.toValue = colorError.cgColor
        resetAnimation.duration = 0.5
        cell.contentView.layer.add(resetAnimation, forKey: "resetColorChange")
        cell.contentView.layer.backgroundColor = colorReset.cgColor
        
    }
    
    func resetInformacion () {
        lastSelectedIndexPathEven = nil
        countryText = nil
        
        lastSelectedIndexPathOdd = nil
        capitalText = nil
    }
}
