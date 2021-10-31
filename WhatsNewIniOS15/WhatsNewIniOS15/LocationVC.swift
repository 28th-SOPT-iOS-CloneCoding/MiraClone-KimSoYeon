//
//  LocationVC.swift
//  WhatsNewIniOS15
//
//  Created by soyeon on 2021/10/31.
//

import UIKit

import CoreLocationUI
import CoreLocation

import MapKit

class LocationVC: UIViewController, CLLocationManagerDelegate {
    
    let manager = CLLocationManager()
    let mapView = MKMapView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(mapView)
        mapView.frame = CGRect(x: 20, y: 50, width: view.frame.width.self-40, height: view.frame.height.self-220)
        
        manager.delegate = self
        
        createButton()
    }
    
    private func createButton() {
        let button = CLLocationButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        button.label = .currentLocation
        button.icon = .arrowOutline
        button.cornerRadius = 12
        button.center = CGPoint(x: view.center.x, y: view.frame.height-70)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc
    func didTapButton() {
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.manager.stopUpdatingLocation()
        
        mapView.setRegion(MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)), animated: true)
    }
}
