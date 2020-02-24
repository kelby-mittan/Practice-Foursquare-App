//
//  MapViewController.swift
//  Practice-Foursquare-App
//
//  Created by Kelby Mittan on 2/22/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import UIKit
import MapKit
import MediumMenu

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
    
    public var annotations = [MKPointAnnotation]()
    
    override func loadView() {
        view = theMapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        theMapView.backgroundColor = .systemBackground
        setupNavBar()
        
        theMapView.mapView.delegate = self
        theMapView.locationSearchBar.delegate = self
//        venueSearchBar.delegate = self
//        loadVenues()
    }
    
    private func setupNavBar() {
        navigationItem.setRightBarButton(menuButton, animated: true)
        navigationItem.titleView = venueSearchBar
        
//        let searchController = UISearchController()
//        searchController.searchResultsUpdater = self as? UISearchResultsUpdating
//        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.searchBar.placeholder = "search venues"
//        self.navigationItem.searchController = searchController
//        self.navigationItem.setRightBarButton(menuButton, animated: true)
//        self.definesPresentationContext = true
//        searchController.delegate = self
    }
    
//    private func mediumMenu() {
//
//        let item1 = MediumMenuItem(title: "HeyNow")
//        let menu = MediumMenu(items: [item1], forViewController: self)
//        menu.textColor = .gray                      // Default is UIColor(red:0.98, green:0.98, blue:0.98, alpha:1).
////        menu.highLightTextColor =                 // Default is UIColor(red:0.57, green:0.57, blue:0.57, alpha:1).
//        menu.backgroundColor = .systemTeal                 // Default is UIColor(red:0.05, green:0.05, blue:0.05, alpha:1).
//        menu.titleFont = UIFont(name: "AvenirNext-Regular", size: 30) // Default is UIFont(name: "HelveticaNeue-Light", size: 28).
//        menu.titleAlignment = .center                                 // Default is .Left.
//        menu.height = 370                                             // Default is 466.
//        menu.bounceOffset = 10                                        // Default is 0.
////        menu.velocityTreshold = 700                                   // Default is 1000.
//        menu.panGestureEnable = false                                 // Default is true.
////        menu.highLighedIndex = 3                                      // Default is 1.
//        menu.heightForRowAtIndexPath = 40                             // Default is 57.
//        menu.heightForHeaderInSection = 0                             // Default is 30.
//        menu.enabled = false                                          // Default is true.
//        menu.animationDuration = 0.33
//    }
    
    @objc private func menuButtonPressed(_ sender: UIBarButtonItem) {
        print("menu button pressed")
//        mediumMenu()
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
    
    private func makeAnnotations() {
//        var annotations = [MKPointAnnotation]()
        for venue in venues {
            
            let coordinate = CLLocationCoordinate2D(latitude: venue.location.lat, longitude: venue.location.lng)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = venue.name
            annotations.append(annotation)
        }
        dump(annotations)
//        return annotations
    }
    
    private func loadMapView() {
        makeAnnotations()
        theMapView.mapView.addAnnotations(annotations)
        theMapView.mapView.showAnnotations(annotations, animated: true)
    }
    
}

extension MapViewController: UISearchControllerDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarSearchButtonClicked")
    }
    
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarResultsListButtonClicked")
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        print("updateSearchResults")
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("text field is \(textField.text ?? "empty")")
    }
}

extension MapViewController: UISearchTextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        venueSearch = textField.text?.lowercased() ?? ""
        loadVenues(city: venueSearch)
        textField.text = ""
        print("search")
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        annotations.removeAll()
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
