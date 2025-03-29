//
//  Untitled.swift
//  CountriEZ
//
//  Created by Emiliano Gil  on 16/03/25.
//
import UIKit

class SearchViewModel {
    
    //MARK: - Filtro de datos
    func filterData (data: [DataCountries], tag: Int, text: String) -> [DataCountries]{
        switch tag {
        case 0:
            return data.filter { country in
                return country.name.nameCountry.lowercased().hasPrefix(text.lowercased())
            }
        case 1:
            return data.filter { country in
                return country.languages?.values.contains{  $0.lowercased().hasPrefix(text.lowercased())} ?? false
            }
        case 2:
            return data.filter { country in
                return country.capital?.contains{$0.lowercased().hasPrefix(text.lowercased())} ?? false
            }
        case 3:
            return data.filter { country in
                return country.region.lowercased().hasPrefix(text.lowercased())
            }
        default:
            return []
        }
    }
    
    
    
}
