//
//  MapViewController.swift
//  ListenWiki
//
//  Created by Tarun Bhargava on 31/03/19.
//  Copyright © 2019 FlawlessApps. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet var mapview : MKMapView!
    
        
    fileprivate var currentResults : MapSearchResults?
    
    let networkController = NetworkController()
    
    
    let mapSearchButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .cyan
        let str = NSAttributedString(string: "Search this area", attributes: [.foregroundColor : UIColor.darkText, .font : UIFont.italicSystemFont(ofSize: 10)])
        button.setAttributedTitle(str, for: .normal)
        let strHighlited = NSAttributedString(string: "Search this area", attributes: [.foregroundColor : UIColor.darkText.withAlphaComponent(0.5), .font : UIFont.italicSystemFont(ofSize: 10)])
        button.setAttributedTitle(strHighlited, for: .highlighted)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        button.layer.cornerRadius = 5
        return button
    }()
    
    
    lazy var locationManager : CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyBest
        return lm
    }()
    
    private var currentLocation : CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Map"
        setUpMapView()
        setUpSearchButton()
        LocationRequestService.requestAuthorisationIfReqd(withManagerObj: locationManager)
    }
    
    private func setUpMapView() {
        mapview.showsUserLocation = true
        mapview.delegate = self
    }
    
    
    
    private func setUpSearchButton() {
        mapview.addSubview(mapSearchButton)
        NSLayoutConstraint.activate([
            mapSearchButton.centerXAnchor.constraint(equalTo: mapview.centerXAnchor),
            mapSearchButton.topAnchor.constraint(equalTo: mapview.topAnchor, constant: 30),
            mapSearchButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 140)
        ])
        mapSearchButton.addTarget(self, action: #selector(searchTapped), for: .touchUpInside)
    }
    
    @objc func searchTapped() {
        guard  let mapView = mapview else {
            return
        }
        self.setAsSearching(searchOngoing:true)
        let region  = mapView.region
        networkController.request(payload: PayloadGenerator(requestType: .fetchLocations(region: region)).generatePayload(), completion:{ [weak self]
            (result: Result<MapSearchResults, Error>) in
            DispatchQueue.main.async { [weak self] in
                do {
                    let response = try result.get()
                    self?.handleLocationResponse(results:response)
                } catch  {
                    let alert = UIAlertController(title: "Oops!", message: "Something went wrong!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
                self?.setAsSearching(searchOngoing:false)
            }
        })
    }
    
    private func setAsSearching(searchOngoing: Bool) {
        if searchOngoing {
            mapview.isUserInteractionEnabled = false
            mapSearchButton.isUserInteractionEnabled = false
            let str = NSAttributedString(string: "Searching...", attributes: [.foregroundColor : UIColor.darkText, .font : UIFont.italicSystemFont(ofSize: 10)])
            mapSearchButton.setAttributedTitle(str, for: .normal)
        }
        else {
            mapview.isUserInteractionEnabled = true
            mapSearchButton.isUserInteractionEnabled = true
            let str = NSAttributedString(string: "Search this area", attributes: [.foregroundColor : UIColor.darkText, .font : UIFont.italicSystemFont(ofSize: 10)])
            mapSearchButton.setAttributedTitle(str, for: .normal)
        }
    }
    
    private func handleLocationResponse(results:MapSearchResults) {
        self.currentResults = results
        let annotations = self.getAnnotations(withMapResults : results)
        self.mapview.removeAnnotations(self.mapview!.annotations)
        self.mapview.addAnnotations(annotations)
    }

    
    fileprivate func getAnnotations(withMapResults results: MapSearchResults) -> [WikiLocation] {
        var array = [WikiLocation]()
        for page in results.pages {
            guard let coordinates = page.coordinates,let lat = coordinates.lat,let long = coordinates.lon,!page.title.isEmpty else {
                continue
            }
            let title = page.title
            let image = page.thumbnail?.source ?? "NAN"
            let annotationCoordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
            array.append(WikiLocation(title: title, imageUrl: image,pageId:page.pageid, coordinate:annotationCoordinates ))
        }
        return array
    }
    
    fileprivate func shouldUpdateLocation(newLocation:CLLocation) -> Bool {
        guard let temp = currentLocation else {
            return false
        }
        return temp.distance(from: newLocation) > Double(integerLiteral: 1000)
    }
}


// MARK:Location delegate

extension MapViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        LocationRequestService.requestAuthorisationIfReqd(withManagerObj: locationManager)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location  = locations.first {
                currentLocation = location
        }
    }
}


// MARK:MapViewDelegate

extension MapViewController: MKMapViewDelegate {
    
    //https://www.raywenderlich.com/548-mapkit-tutorial-getting-started
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? WikiLocation else { return nil }
        let identifier = "com.ListenWiki.AnnotationMarker"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .infoDark)
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? WikiLocation,let wikiPage = currentResults?.pages.first(where:{ $0.pageid == annotation.pageId }) else { return }
        
        let vc = ListenArticleViewController(wikiPage: wikiPage,networkController:networkController)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


