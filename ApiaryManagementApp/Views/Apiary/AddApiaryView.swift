import SwiftUI
import MapKit

struct AddApiaryView: View {
    @Environment(\.managedObjectContext) private var dbContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \BeeType.name, ascending: true)], animation: .default)
    private var beeTypes: FetchedResults<BeeType>
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Apiary.name, ascending: true)], animation: .default)
    private var apiaries: FetchedResults<Apiary>
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \User.username, ascending: true)], animation: .default)
    private var users: FetchedResults<User>
    
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var user: User?
    
    @State private var name: String = ""
    @State private var location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    @State private var beeType: BeeType?
    @State private var pickerId: Int = 0
    @State private var hiveCount: Double = 10
    @State private var isEditing = false
    
    @State private var alert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMsg: String = ""
    
    @State var myAnnotation = MyAnnotation(
        title: "Katedra Informatyki",
        subtitle: "Politechnika Lubelska",
        coordinate: CLLocationCoordinate2D(
            latitude: 51.235,
            longitude: 22.553
        ),
        moveOnly: true
    )
    @State var latitude: String = "51.235"
    @State var longitude: String = "22.553"
    
    var body: some View {
        VStack {
            MapViewSingleAnnotation(myAnnotation: $myAnnotation)
                .padding(.vertical)
                .frame(height: UIScreen.main.bounds.size.height * 0.3, alignment: .center)
                .alert(isPresented: $alert) {
                    Alert(
                        title: Text(alertTitle),
                        message: Text(alertMsg)
                    )}
            Group {
                HStack {
                    Text("Latitude")
                    TextField("Latitude", text: $latitude)
                }
                HStack {
                    Text("Longitude")
                    TextField("Longitude", text: $longitude)
                }
            }.padding(.horizontal)
            
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
                
                HStack {
                    Button("Choose location", action: {
                        if self.isCoordinateValid() {
                            self.addAnnotation()
                        }
                    })
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(5)
                    .padding(.trailing)

                    Button("Add apiary") {
                        self.addApiary()
                    }
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(5)
                    .padding(.leading)
                }
            }
            Spacer()
        }
        .navigationBarTitle("New Apiary")
        .alert(isPresented: $alert) {
            Alert(title: Text(alertTitle), message: Text(alertMsg))
        }
    }
    
    private func addApiary() {
        if myAnnotation.moveOnly {
            alertTitle = "Error"
            alertMsg = "You have not chosen a location for your apiary"
            alert = true
            return
        }
        
        if name.count == 0 {
            alertTitle = "Error"
            alertMsg = "Apiary name cannot be empty"
            alert = true
            return
        }
        let arr = apiaries.filter { apiary in apiary.name == name && apiary.user!.username! == user!.username! }
        if arr.count > 0 {
            alertTitle = "Error"
            alertMsg = "You already have apiary with such name"
            alert = true
            return
        }
        
        let apiary = Apiary(context: dbContext)
        apiary.name = name
        apiary.hiveCount = Int16(hiveCount)
        apiary.beeType = beeType
        apiary.latitude = Decimal(string: latitude)! as NSDecimalNumber
        apiary.longitude = Decimal(string: longitude)! as NSDecimalNumber
        apiary.user = users.filter { $0.username == user!.username! }[0]
        
        do {
            try dbContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        self.presentationMode.wrappedValue.dismiss()
    }
    
    private func addAnnotation() {
        self.myAnnotation = MyAnnotation(
            title: "New Apiary Location",
            subtitle: user!.username! + "'s apiary",
            coordinate: CLLocationCoordinate2D(
                latitude: Double(latitude)!,
                longitude: Double(longitude)!
            ),
            moveOnly: false
        )
    }
    
    private func isCoordinateValid() -> Bool {
        guard let latitudeAsDouble = Double(latitude) else {
            self.alertTitle = "Latitude"
            self.alertMsg = "Latitude must be of type Double"
            self.alert = true
            return false
        }
        guard let longitudeAsDouble = Double(longitude) else {
            self.alertTitle = "Longitude"
            self.alertMsg = "Longitude must be of type Double"
            self.alert = true
            return false
        }
        
        guard latitudeAsDouble >= -90 && latitudeAsDouble <= 90 else {
            self.alertTitle = "Latitude"
            self.alertMsg = "Latitude must be in range [-90, 90]"
            self.alert = true
            return false
        }
        guard longitudeAsDouble >= -180 && longitudeAsDouble <= 180 else {
            self.alertTitle = "Longitude"
            self.alertMsg = "Longitude must be in range [-180, 180]"
            self.alert = true
            return false
        }
        return true
    }
}

struct AddApiaryView_Previews: PreviewProvider {
    static var previews: some View {
        AddApiaryView(user: .constant(User()))
    }
}
