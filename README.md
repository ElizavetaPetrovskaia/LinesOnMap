# LinesOnMap
This project utilizes the CoreLocation and MapKit frameworks to display the user's location and track their route on a map view. The MapViewModel class acts as the delegate for the CLLocationManager, and updates the user's location and route coordinates as they move. The MapView struct is a UIViewRepresentable that displays the map view and coordinates with the MapViewModel to update the view with the latest user location and route data. The MapViewCoordinator class acts as the delegate for the MKMapView, and renders a polyline on the map view to display the user's route. This project can be used as a starting point for building a location-based app that utilizes the user's current location and displays it on a map view.
This project is a part of bigger app for drivers which I present in another repository under name "Stressless driving".
