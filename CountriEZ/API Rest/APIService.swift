//
//  APIService.swift
//  CountriEZ
//
//  Created by Emiliano Gil  on 28/03/25.
//

import Foundation
import UIKit

class APIService {
    // ALL https://restcountries.com/v3.1/all
    // NAME https://restcountries.com/v3.1/name/deutschland
    // language  https://restcountries.com/v3.1/lang/spanish
    // capital https://restcountries.com/v3.1/capital/tallin
    // region https://restcountries.com/v3.1/region/europe
    
    private let urlCountriez = "https://restcountries.com/v3.1/all"
    
    static let shared = APIService()
    private init() {}
    
    private var cachedCountries: [DataCountries]?
    
    // MARK: - Petición a la API
    func fetchCountries(completion: @escaping([DataCountries]?, Error?) -> Void) {
        
        // Si ya tenemos cache, regresamos eso
        if let cached = cachedCountries {
            completion(cached, nil)
            return
        }
        
        guard let url = URL(string: urlCountriez) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            
            do {
                let dataCountry = try JSONDecoder().decode([DataCountries].self, from: data)
                self.cachedCountries = dataCountry // guardamos en cache
                completion(dataCountry, nil)
            } catch {
                print("Error al decodificar:", error)
            }
        }.resume()
    }
    
    
    //MARK: - Peticion de la bandera
    func fetchImageFlag (urlImage: String ,completion: @escaping (UIImage?, Error?) -> Void) {
        
        guard let url = URL(string: urlImage) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            
            guard let data = data, let image = UIImage(data: data), error == nil else { return }
            completion (image, nil)
        }
        
        task.resume()
    }
    
}
