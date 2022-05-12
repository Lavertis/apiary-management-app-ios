//
//  AddApiaryView.swift
//  ApiaryManagementApp
//
//  Created by Rafał Kuźmiczuk on 12/05/2022.
//  Copyright © 2022 Rafał Kuźmiczuk. All rights reserved.
//

import SwiftUI
import MapKit

struct AddApiaryView: View {
    @Binding var username: String?
    
    @Environment(\.managedObjectContext) private var dbContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \BeeType.name, ascending: true)], animation: .default)
    private var beeTypes: FetchedResults<BeeType>
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \User.username, ascending: true)], animation: .default)
    private var users: FetchedResults<User>
    
    @State private var name: String = ""
    @State private var location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    @State private var beeType: BeeType?
    @State private var pickerId: Int = 0
    @State private var hiveCount: Double = 0
    
    @State private var alert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMsg: String = ""
    
    @State private var isEditing = false
    
    @State var myAnnotation = MyAnnotation(
        title: "Katedra Informatyki",
        subtitle: "Politechnika Lubelska",
        coordinate: CLLocationCoordinate2D(
            latitude: 51.2353112433304,
            longitude: 22.5528982268185
        ),
        moveOnly: true
    )
    
    var body: some View {
        VStack {
            MapView(myAnnotation: $myAnnotation)
                .frame(height: UIScreen.main.bounds.size.height * 0.33, alignment: .center)
                .alert(isPresented: $alert) {
                    Alert(
                        title: Text(alertTitle),
                        message: Text(alertMsg)
                    )
            }
            Group {
                HStack {
                    Text("Name")
                    TextField("Name", text: $name)
                        .autocapitalization(.none)
                }
                .padding(.horizontal).padding(.top)
                
                Text("Number of beehives")
                Slider(
                    value: $hiveCount,
                    in: 0...100,
                    step: 1,
                    onEditingChanged: { editing in
                        self.isEditing = editing
                    }
                ).padding(.horizontal)
                Text(String(hiveCount)).padding(.bottom)
                
                Text("Bee type")
                Picker(selection: $beeType, label: Text("Bee type")) {
                    ForEach(beeTypes, id: \.self) { (beeType: BeeType) in
                        Text(beeType.name!).tag(beeType as BeeType?)
                    }
                }
                .id(pickerId)
                .pickerStyle(SegmentedPickerStyle())
                .onAppear {
                    self.beeType = self.beeTypes.first
                }
                .padding(.bottom)
                
                Button("Add apiary") {
                    self.addApiary()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            Spacer()
        }
        .navigationBarTitle("New apiary")
        .alert(isPresented: $alert) {
            Alert(title: Text(alertTitle), message: Text(alertMsg))
        }
    }
    
    private func addApiary() {
        if name.count == 0 {
            alertTitle = "Error"
            alertMsg = "Apiary name cannot be empty"
            alert = true
            return
        }
        
        let apiary = Apiary(context: dbContext)
        apiary.name = name
        apiary.hiveCount = Int16(hiveCount)
        apiary.beeType = beeType
        apiary.user = users.filter { user in user.username == username }[0]
        
        do {
            try dbContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct AddApiaryView_Previews: PreviewProvider {
    static var previews: some View {
        AddApiaryView(username: .constant("Username"))
    }
}
