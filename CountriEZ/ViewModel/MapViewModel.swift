//
//  MapViewModel.swift
//  CountriEZ
//
//  Created by Emiliano Gil  on 26/03/25.
//

import UIKit
import MapKit
//import CoreLocation

protocol MapViewModelDelegate: AnyObject {
    func showLocation(location: CLLocationCoordinate2D)
}

class MapViewModel {
    
    private let coordinateCuntry: [Double]
    weak var delegate: MapViewModelDelegate?
    
    init(coordinate: [Double]) {
        self.coordinateCuntry = coordinate
    }
    
    func didTapLocationButton() {
        let locationCountry = CLLocationCoordinate2D(latitude: coordinateCuntry[0],
                                                     longitude: coordinateCuntry[1])
//        print("Ubicación de la pizzería al tocar su boton: \(locationCountry.latitude), \(locationCountry.longitude)")
        delegate?.showLocation(location: locationCountry)
    }
}
