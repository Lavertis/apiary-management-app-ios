//
//  ApiaryMapView.swift
//  ApiaryManagementApp
//
//  Created by Rafał Kuźmiczuk on 13/05/2022.
//  Copyright © 2022 Rafał Kuźmiczuk. All rights reserved.
//

import SwiftUI
import MapKit

struct ApiaryMapView: View {
    @Environment(\.managedObjectContext) private var dbContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \User.username, ascending: true)], animation: .default)
    private var users: FetchedResults<User>
    
    @Binding var username: String?
    
    @State var myAnnotations = [MyAnnotation(
        title: "Katedra Informatyki",
        subtitle: "Politechnika Lubelska",
        coordinate: CLLocationCoordinate2D(
            latitude: 51.235,
            longitude: 22.553
        ),
        moveOnly: true
        )]
    
    var body: some View {
        VStack {
            Spacer()
            MapViewMultipleAnnotations(myAnnotations: $myAnnotations)
                .frame(height: UIScreen.main.bounds.size.height * 0.80)
                .onAppear {
                    let user = self.users.filter { $0.username == self.username }[0]
                    let apiaries = Array(user.apiary!) as! Array<Apiary>
                    if apiaries.count == 0 {
                        return
                    }
                    self.myAnnotations = apiaries.map { apiary in
                        MyAnnotation(
                            title: apiary.name,
                            subtitle: "\(self.username!)'s apiary",
                            coordinate: CLLocationCoordinate2D(
                                latitude: apiary.latitude as! CLLocationDegrees,
                                longitude: apiary.longitude as! CLLocationDegrees
                            ),
                            moveOnly: false
                        )
                    }
            }
        }.navigationBarTitle("Apiaries Map")
    }
}

struct ApiaryMapView_Previews: PreviewProvider {
    static var previews: some View {
        ApiaryMapView(username: .constant("Username"))
    }
}
