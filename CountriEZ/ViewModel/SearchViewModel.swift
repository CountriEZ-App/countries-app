//
//  Untitled.swift
//  CountriEZ
//
//  Created by Emiliano Gil  on 16/03/25.
//
import UIKit

class SearchViewModel {
    
    // ALL https://restcountries.com/v3.1/all
    // NAME https://restcountries.com/v3.1/name/deutschland
    // language  https://restcountries.com/v3.1/lang/spanish
    // capital https://restcountries.com/v3.1/capital/tallin
    // region https://restcountries.com/v3.1/region/europe
    
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
