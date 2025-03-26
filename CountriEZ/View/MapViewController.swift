//
//  MapViewController.swift
//  CountriEZ
//
//  Created by Emiliano Gil  on 26/03/25.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MapViewModelDelegate {
    
    private let mapViewModel: MapViewModel
    
    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.preferredConfiguration = MKHybridMapConfiguration()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    private lazy var closeMapButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.borderedProminent()
        configuration.title = "Close"
        button.configuration = configuration
        button.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init(coordinate:[Double] ){
        self.mapViewModel = MapViewModel(coordinate: coordinate)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapViewModel.delegate = self

        setupViewMap()
        mapViewModel.didTapLocationButton()
    }
    

    private func setupViewMap () {
        view.addSubview(mapView) // Agrega el mapa
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        view.addSubview(closeMapButton) // Agrega el botón de cerrar
        NSLayoutConstraint.activate([
            closeMapButton.topAnchor.constraint(equalTo: view.topAnchor,
                                             constant: 20),
            closeMapButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                  constant: -20)
        ])
    }
    
    @objc
    private func closeView () {
        dismiss(animated: true, completion: nil)
    }

    func showLocation(location: CLLocationCoordinate2D) {
        let userAnnotation = MKPointAnnotation()
        userAnnotation.coordinate = location
        mapView.addAnnotation(userAnnotation)
        
        let mapRegion = MKCoordinateRegion(center: location,
                                           span: MKCoordinateSpan(latitudeDelta: 10.001,
                                                                  longitudeDelta: 10.01))
        mapView.region = mapRegion
    }
    
}


