import SwiftUI
import MapKit

struct ContentView: View {
    var body: some View {
        MapView(viewModel: MapViewModel(mapView: MKMapView()))
            .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
