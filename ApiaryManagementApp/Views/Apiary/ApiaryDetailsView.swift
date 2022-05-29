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
    
    @State private var apiary: Apiary?
    @State var myAnnotation = MyAnnotation(
        title: "Katedra Informatyki",
        subtitle: "Politechnika Lubelska",
        coordinate: CLLocationCoordinate2D(
            latitude: 51.235,
            longitude: 22.553
        ),
        moveOnly: false
    )
    
    @Binding var username: String?
    @State var apiaryName: String = ""
    @State var isEditShown: Bool = false
    
    var body: some View {
        VStack {
            MapViewSingleAnnotation(myAnnotation: $myAnnotation)
                .padding(.vertical)
                .frame(height: UIScreen.main.bounds.size.height * 0.4, alignment: .center)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Name: \(apiary?.name! ?? "")")
                    Text("Bee type: \(apiary?.beeType!.name! ?? "")")
                    Text("Hive count: \(Int(apiary?.hiveCount ?? 0))")
                }
                Spacer()
                if apiary != nil {
                    Image(apiary!.beeType!.img!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
                }
                }.padding()
            
            Button("Edit") {
                self.isEditShown.toggle()
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(5)
            .padding(.leading)
            .sheet(isPresented: $isEditShown, onDismiss: {
                self.myAnnotation = MyAnnotation(
                    title: self.apiary!.name,
                    subtitle: "\(self.username!)'s apiary",
                    coordinate: CLLocationCoordinate2D(
                        latitude: self.apiary!.latitude as! CLLocationDegrees,
                        longitude: self.apiary!.longitude as! CLLocationDegrees
                    ),
                    moveOnly: false
                )
            },content: {
                NavigationView {
                    EditApiaryView(isShown: self.$isEditShown, username: self.$username, name: self.$apiaryName)
                    .environment(\.managedObjectContext, self.dbContext)
                    .navigationBarTitle(Text("Apiary Details Edit"), displayMode: .inline)
                    .navigationBarItems(trailing: Button(action: {
                        self.isEditShown = false
                    }) {
                        Text("Close").bold()
                    })
                }
            })
            
            Spacer()
        }.onAppear {
            self.apiary = self.apiaries.filter { $0.name == self.apiaryName && $0.user!.username == self.username }[0]
            self.myAnnotation = MyAnnotation(
                title: self.apiary!.name,
                subtitle: "\(self.username!)'s apiary",
                coordinate: CLLocationCoordinate2D(
                    latitude: self.apiary!.latitude as! CLLocationDegrees,
                    longitude: self.apiary!.longitude as! CLLocationDegrees
                ),
                moveOnly: false
            )
        }.navigationBarTitle("Apiary Details")
    }
}

struct ApiaryDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ApiaryDetailsView(username: .constant("Username"), apiaryName: "ApiaryName")
    }
}
