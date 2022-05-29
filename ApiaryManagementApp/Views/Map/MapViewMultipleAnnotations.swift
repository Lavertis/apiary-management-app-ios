import SwiftUI
import MapKit


struct MapViewMultipleAnnotations: UIViewRepresentable {
    @Binding var myAnnotations: [MyAnnotation]
    
    func makeUIView(context: Context) -> MKMapView {
        let myMap = MKMapView(frame: .zero)
        return myMap
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: myAnnotations[0].coordinate, span: span)
        uiView.setRegion(region, animated: true)
        if !myAnnotations[0].moveOnly {
            uiView.addAnnotations(myAnnotations)
        }
    }
}
