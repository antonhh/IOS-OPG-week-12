//
//  ViewController.swift
//  MapDemo
//
//  Created by Anton Haastrup on 20/03/2020.
//  Copyright © 2020 Anton Haastrup. All rights reserved.
//

import UIKit
import MapKit
import FirebaseFirestore
import CoreLocation

class ViewController: UIViewController {

     @IBOutlet weak var map: MKMapView!
    
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        FirebaseRepo.startListener(vc: self)
        
    }

   
    func updateMarkers(snap : QuerySnapshot) //Now we get the raw data from firebase
    {
    let markers = MapDataAdapter.getMKAnnotationsFromData(snap: snap)
    map.removeAnnotations(map.annotations) // clear the map
    map.addAnnotations(markers)
              
          }
    
  
    
    
    
    @IBAction func longPressed(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .ended {
            let alert = UIAlertController(title: "Whats this place?", message: nil, preferredStyle: .alert)
            let cgPoint = sender.location(in: map)
            let coordinate2d = map.convert(cgPoint, toCoordinateFrom: map)
            alert.addTextField(configurationHandler: { textField in
                textField.placeholder = "Input The Location Here"
            })
             alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            if let name = alert.textFields?.first?.text {
                     
                FirebaseRepo.addMarker(title: name, lat: coordinate2d.latitude, long: coordinate2d.longitude)
                 }
                
             }))
           self.present(alert, animated: true)
        
        
            }
       
    }
}


extension ViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coord = locations.last?.coordinate{
            print("new location")
        let region = MKCoordinateRegion(center: coord, latitudinalMeters: 300, longitudinalMeters: 300)
        map.setRegion(region, animated: true)
           
    }
      
}

}
