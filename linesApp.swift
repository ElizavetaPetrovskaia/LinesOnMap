import CoreLocation
import MapKit
import SwiftUI

class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var routeCoordinates: [CLLocationCoordinate2D] = []
    private let mapView: MKMapView // Add a mapView property

    init(mapView: MKMapView) { // Add a mapView parameter to the init method
        self.mapView = mapView // Assign the mapView to a local variable
        super.init()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        let newCoordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)

        if userLocation == nil {
            // Center the map on the initial user location
            userLocation = newCoordinate
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: newCoordinate, span: span)
            mapView.setRegion(region, animated: true)
        } else {
            // Add the new location to the route
            userLocation = newCoordinate
            routeCoordinates.append(newCoordinate)
            
            // Create a polyline and add it to the map view
            let polyline = MKPolyline(coordinates: &routeCoordinates, count: routeCoordinates.count)
            mapView.addOverlay(polyline)
        }
    }
}

struct MapView: UIViewRepresentable {
    @ObservedObject var viewModel: MapViewModel
    let mapView = MKMapView()

    func makeUIView(context: Context) -> MKMapView {
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        // Update the map view with the latest user location and route data
        if let location = viewModel.userLocation {
            mapView.setCenter(location, animated: true)
        }

        // No need to update the route coordinates here since that's handled in the locationManager delegate method
    }

    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator()
    }
}

class MapViewCoordinator: NSObject, MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .red
            renderer.lineWidth = 4
            return renderer
        }

        return MKOverlayRenderer()
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(viewModel: MapViewModel(mapView: MKMapView()))
    }
}
