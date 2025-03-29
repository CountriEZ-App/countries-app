//
//  GameViewModel.swift
//  CountriEZ
//
//  Created by Emiliano Gil  on 20/03/25.
//

import UIKit

class GameViewModel {
    
    var dictionaryGame: [String:String] = [:]
    
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
            countryText = text
        }else {
            lastSelectedIndexPathOdd = indexPath
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
        
        if !selectedIndexPaths.contains(lastItem) {
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
