//
//  SignInView.swift
//  ApiaryManagementApp
//
//  Created by Rafał Kuźmiczuk on 12/05/2022.
//  Copyright © 2022 Rafał Kuźmiczuk. All rights reserved.
//

import SwiftUI


struct SignInView: View {
    @Environment(\.managedObjectContext) private var dbContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \User.username, ascending: true)], animation: .default)
    private var users: FetchedResults<User>
    
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
        
        let arr = self.users.filter { user in user.username == self.username }
        if arr.count == 0 {
            self.alertTitle = "Error"
            self.alertMsg = "Username does not exist"
            self.alert = true
            return
        }
        if arr.count == 1 && arr[0].password != self.password {
            self.alertTitle = "Error"
            self.alertMsg = "Wrong password"
            self.alert = true
            return
        }
        
        self.globalUsername = arr[0].username
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(globalUsername: .constant("Username"))
    }
}
