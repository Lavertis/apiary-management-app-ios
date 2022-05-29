import SwiftUI


struct HomeView: View {
    @Environment(\.managedObjectContext) private var dbContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \BeeType.name, ascending: true)], animation: .default)
    private var beeTypes: FetchedResults<BeeType>
    
    @State var username: String?
    
    var body: some View {
        NavigationView {
            VStack {
                if username != nil {
                    Text("Logged in as: \(username ?? "")").padding()
                }
                Group {
                    if username == nil {
                        Group {
                            NavigationLink(destination: SignInView(globalUsername: self.$username), label: {
                                Text("Sign In")
                            })
                            NavigationLink(destination: SignUpView(), label: {
                                Text("Sign Up")
                            })
                            NavigationLink(destination: UserListView(), label: {
                                Text("User list")
                            })
                        }
                        .frame(width: 115)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                        .padding()
                    }
                    else {
                        ApiaryMenuView(username: self.$username)
                        Button("Logout") {
                            self.username = nil
                        }
                        .frame(width: 130)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                        .padding()
                    }
                }
            }.navigationBarTitle("Apiary management")
        }.onAppear(perform: self.seedBeeTypes)
    }
    
    private func seedBeeTypes() {
        if beeTypes.count > 0 {
            return
        }
        let beeType1 = BeeType(context: dbContext)
        beeType1.name = "Bumblebee"
        beeType1.img = "Bumblebee"
        
        let beeType2 = BeeType(context: dbContext)
        beeType2.name = "Carpenter bee"
        beeType2.img = "Carpenter_Bee"
        
        let beeType3 = BeeType(context: dbContext)
        beeType3.name = "Honey bee"
        beeType3.img = "Honey_Bee"
        
        do {
            try dbContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
