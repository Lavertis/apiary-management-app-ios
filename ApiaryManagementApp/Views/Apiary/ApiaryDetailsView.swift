//
//  ApiaryDetailsView.swift
//  ApiaryManagementApp
//
//  Created by Rafał Kuźmiczuk on 13/05/2022.
//  Copyright © 2022 Rafał Kuźmiczuk. All rights reserved.
//

import SwiftUI
import MapKit

struct ApiaryDetailsView: View {
    @Environment(\.managedObjectContext) private var dbContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Apiary.name, ascending: true)], animation: .default)
    private var apiaries: FetchedResults<Apiary>
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \User.username, ascending: true)], animation: .default)
    private var users: FetchedResults<User>
    
    @State private var apiary: Apiary?
    @State var myAnnotation = MyAnnotation(
        title: "Katedra Informatyki",
        subtitle: "Politechnika Lubelska",
        coordinate: CLLocationCoordinate2D(
            latitude: 51.2353112433304,
            longitude: 22.5528982268185
        ),
        moveOnly: false
    )
    
    @Binding var username: String?
    @State var apiaryName: String?
    
    var body: some View {
        VStack {
            MapView(myAnnotation: $myAnnotation)
                .padding(.bottom)
                .frame(height: UIScreen.main.bounds.size.height * 0.4, alignment: .center)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Name: \(apiary?.name! ?? "")")
                    Text("Bee type: \(apiary?.beeType!.name! ?? "")")
                    Text("Hive count: \(Int(apiary?.hiveCount ?? 0))")
                }
                Spacer()
                Image(apiary?.beeType!.img! ?? "")
                .resizable()
                .scaledToFit()
                .frame(width: 100)
            }.padding(.horizontal)
            
            Spacer()
        }.onAppear {
            self.apiary = self.apiaries.filter {
                $0.name == self.apiaryName! && $0.user!.username == self.username
            }[0]
            self.myAnnotation = MyAnnotation(
                title: self.apiary!.name,
                subtitle: "\(self.username!)'s apiary",
                coordinate: CLLocationCoordinate2D(
                    latitude: self.apiary!.latitude as! CLLocationDegrees,
                    longitude: self.apiary!.longitude as! CLLocationDegrees
                ),
                moveOnly: false
            )
        }
    }
}

struct ApiaryDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ApiaryDetailsView(username: .constant("Username"), apiaryName: "ApiaryName")
    }
}
