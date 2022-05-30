import SwiftUI


struct SignInView: View {
    @Environment(\.managedObjectContext) private var dbContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \User.username, ascending: true)], animation: .default)
    private var users: FetchedResults<User>
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \LoggedInUser.user, ascending: true)], animation: .default)
    private var loggedInUsers: FetchedResults<LoggedInUser>
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var alert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMsg: String = ""
    
    @Binding var globalUsername: String?
    
    var body: some View {
        VStack {
            HStack {
                Text("Username")
                TextField("Username", text: $username)
                    .autocapitalization(.none)
            }.padding()
            HStack {
                Text("Password")
                SecureField("Password", text: $password)
            }.padding(.horizontal)
            
            Button("Sign In") {
                self.signIn()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(5)
        }
        .navigationBarTitle("Sign In")
        .alert(isPresented: $alert) {
            Alert(title: Text(alertTitle), message: Text(alertMsg))
        }
    }
    
    private func signIn() {
        if username.count == 0 {
            alertTitle = "Error"
            alertMsg = "Username field cannot be empty"
            alert = true
            return
        }
        if password.count == 0 {
            alertTitle = "Error"
            alertMsg = "Password field cannot be empty"
            alert = true
            return
        }
        
        let userArr = self.users.filter { user in user.username == self.username }
        if userArr.count == 0 {
            self.alertTitle = "Error"
            self.alertMsg = "Username does not exist"
            self.alert = true
            return
        }
        if userArr.count == 1 && userArr[0].password != self.password {
            self.alertTitle = "Error"
            self.alertMsg = "Wrong password"
            self.alert = true
            return
        }
        
        do {
            loggedInUsers.filter { $0.user!.username == username }.forEach(dbContext.delete)
            let loggedInUser = LoggedInUser(context: dbContext)
            loggedInUser.user = userArr[0]
            try dbContext.save()
            self.globalUsername = userArr[0].username
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(globalUsername: .constant("Username"))
    }
}
