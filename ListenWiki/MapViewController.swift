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

    @IBOutlet var mapview : MKMapView?
    
    @IBOutlet var mapSearchButton : UIButton?
    
    fileprivate let resultFetcher = MapResultFetcher()
    
    fileprivate var currentResults : MapSearchResults?
    
    @IBAction func searchTapped() {
        mapSearchButton?.isHidden = true
        guard  let mapView = mapview else {
            return
        }
        let region  = mapView.region
        resultFetcher.fetchResults(forMapRegion: region, completionHandler: {
            mapResults in
            DispatchQueue.main.async {
                self.currentResults = mapResults
                let annotations = self.getAnnotations(withMapResults : mapResults)
                self.mapview?.removeAnnotations(self.mapview!.annotations)
                self.mapview?.addAnnotations(annotations)
            }
        })
    }
    
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
        LocationRequestService.requestAuthorisationIfReqd(withManagerObj: locationManager)
    }
    
    fileprivate func setUpMapView() {
        mapview?.showsUserLocation = true
        mapview?.delegate = self
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
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        mapSearchButton?.isHidden = false
    }
    
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
            view.rightCalloutAccessoryView = UIButton(type: .contactAdd)
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? WikiLocation,let wikiPage = currentResults?.pages.first(where:{ $0.pageid == annotation.pageId }) else { return }
        
        let vc = ListenArticleViewController(wikiPage: wikiPage)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


