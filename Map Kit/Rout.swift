import UIKit
import MapKit

class Rout: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var addresses : [String]!
    var location1 : CLLocation!
    var location2 : CLLocation!
    var annotation: Spot?
    
    @IBOutlet weak var map: MKMapView!
    
    var mapHasCenterOnce = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = kCLDistanceFilterNone
    
        map.userTrackingMode = MKUserTrackingMode.follow
        for adress in addresses{
            
            coordinates(forAddress: adress) {
                (location) in
                if adress == self.addresses[0]{
                    self.location1 = CLLocation(latitude: (location?.latitude)!, longitude: (location?.longitude)!)}
                
                if adress == self.addresses[1]{
                    self.location2 = CLLocation(latitude: (location?.latitude)!, longitude: (location?.longitude)!)}
                guard let location = location else {
                    // Handle error here.
                    return
                }
                self.annotation = Spot(latitude: location.latitude, longitude: location.longitude, address: adress)
                self.map.addAnnotation(self.annotation!)
                self.centerMapOnLocation(location: location)
                
                
            }
        }
    }
    
    @IBAction func Route(_ sender: Any) {
        let request = MKDirectionsRequest()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: location1.coordinate.latitude, longitude: location1.coordinate.longitude), addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: location2.coordinate.latitude, longitude: location2.coordinate.longitude), addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        
        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            
            for route in unwrappedResponse.routes {
                self.map.add(route.polyline)
                self.map.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blue
        return renderer
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        locationAuthStatus()
    }
    
    @IBAction func map(_ sender: Any) {
    }
    
    func locationAuthStatus(){
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            map.showsUserLocation = true
        }
        else{
            locationManager.requestWhenInUseAuthorization()
            
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Access the last object from locations to get perfect current location
        if let location = locations.last {
            let span = MKCoordinateSpanMake(0.00775, 0.00775)
            let myLocation = CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude)
            let region = MKCoordinateRegionMake(myLocation, span)
            map.setRegion(region, animated: true)
        }
        self.map.showsUserLocation = true
        manager.stopUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            map.showsUserLocation = true
        }
    }
    func centerMapOnLocation(location: CLLocationCoordinate2D){
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location, 90000, 90000)
        map.setRegion(coordinateRegion, animated: true)
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annotationView : MKAnnotationView?
        let annoIdentifire = "Destination"
      
        if let deqAnno = mapView.dequeueReusableAnnotationView(withIdentifier: annoIdentifire){
            annotationView = deqAnno
            annotationView?.annotation = annotation
        }
        else {
            let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annoIdentifire)
            av.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView = av
        }
        if let annotationView = annotationView, let _ = annotation as? Spot{
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "Map Pin")
            let btn = UIButton()
            
            btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            btn.setImage(UIImage(named: "Map Marker"), for: .normal)
            annotationView.rightCalloutAccessoryView = btn
            
        }
        return annotationView
    }
    
    
    func coordinates(forAddress address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) {
            (placemarks, error) in
            guard error == nil else {
                print("Geocoding error: \(error!)")
                completion(nil)
                return
            }
            completion(placemarks?.first?.location?.coordinate)
        }
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if let anno = view.annotation as? Spot{
            let place = MKPlacemark(coordinate: anno.coordinate)
            let destination = MKMapItem(placemark: place)
            destination.name = "Destination \(String(describing: anno.title))"
            let regionDistance: CLLocationDistance = 1000
            let regionSpan = MKCoordinateRegionMakeWithDistance(anno.coordinate,regionDistance, regionDistance)
            let options = [MKLaunchOptionsMapCenterKey : NSValue(mkCoordinate : regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan:regionSpan.span), MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving] as [String : Any]
            MKMapItem.openMaps(with: [destination], launchOptions: options)
        }
    }
    
    
}

