//
//  MapViewController.swift
//  Practice-Foursquare-App
//
//  Created by Kelby Mittan on 2/22/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    private let theMapView = TheMapView()
    
    private lazy var menuButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .plain, target: self, action: #selector(menuButtonPressed(_:)))
        return button
    }()
    
    private lazy var venueSearchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "search venue"
        return sb
    }()
    
    private var venues = [Venue]() {
        didSet {
            dump(venues)
        }
    }
    
    private var locationSearch = ""
    private var venueSearch = ""
    
    override func loadView() {
        view = theMapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        theMapView.backgroundColor = .systemTeal
        setupNavBar()
        theMapView.mapView.delegate = self
        theMapView.locationSearchBar.delegate = self
//        loadVenues()
    }
    
    private func setupNavBar() {
        navigationItem.setRightBarButton(menuButton, animated: true)
        navigationItem.titleView = venueSearchBar
        venueSearchBar.delegate = self
    }
    
    @objc private func menuButtonPressed(_ sender: UIBarButtonItem) {
        print("menu button pressed")
    }
    
    private func loadVenues(city: String) {
//        locationSearch = "new york"
        venueSearch = "coffee"
        FoursquareAPIClient.getVenues(location: city, search: venueSearch) { [weak self] (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let venues):
                self?.venues = venues
//                dump(venues)
                DispatchQueue.main.async {
                    self?.loadMapView()
                }
            }
        }
    }
    
    private func makeAnnotations() -> [MKPointAnnotation] {
        var annotations = [MKPointAnnotation]()
        for venue in venues {
            
            let coordinate = CLLocationCoordinate2D(latitude: venue.location.lat, longitude: venue.location.lng)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = venue.name
            annotations.append(annotation)
        }
        dump(annotations)
        return annotations
    }
    
    private func loadMapView() {
        let annotations = makeAnnotations()
        theMapView.mapView.addAnnotations(annotations)
        theMapView.mapView.showAnnotations(annotations, animated: true)
    }
    
}

extension MapViewController: UISearchBarDelegate {
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//
//        guard let text = searchBar.text else { return }
//        venueSearch = text
//        loadVenues(city: venueSearch)
//        print("searchBarCancelButtonClicked")
//    }
    
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        guard let text = searchBar.text else { return }
//        venueSearch = text
//        loadVenues(city: venueSearch)
//    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        guard let text = searchBar.text else { return false }
        venueSearch = text
        loadVenues(city: venueSearch)
        print("end editing")
        return true
    }
}

extension MapViewController: UISearchTextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        venueSearch = textField.text ?? ""
        loadVenues(city: venueSearch)
        print("search")
        textField.resignFirstResponder()
        return true
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("did select")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else {
            return nil
        }
        let identifier = "locationAnnotation"
        var annotationView: MKPinAnnotationView
        
        if let dequeView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
            annotationView = dequeView
        } else {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.canShowCallout = true
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("calloutAccessoryControlTapped")
    }
}
