//
//  SignUpView.swift
//  ApiaryManagementApp
//
//  Created by Rafał Kuźmiczuk on 12/05/2022.
//  Copyright © 2022 Rafał Kuźmiczuk. All rights reserved.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.managedObjectContext) private var dbContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \User.username, ascending: true)], animation: .default)
    private var users: FetchedResults<User>
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var alert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMsg: String = ""
    
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
            Button("Sign Up") {
                self.signUp()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(5)
            .padding()
        }
        .navigationBarTitle("Sign Up")
        .alert(isPresented: $alert) {
            Alert(title: Text(alertTitle), message: Text(alertMsg))
        }
    }
    
    private func signUp() {
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
        if arr.count == 1 {
            self.alertTitle = "Error"
            self.alertMsg = "Username already exists"
            self.alert = true
            return
        }
        
        let user = User(context: dbContext)
        user.username = username
        user.password = password
        do {
            try dbContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        self.alertTitle = "Information"
        self.alertMsg = "Account created. You can now log in."
        self.alert = true
        username = ""
        password = ""
        print("User created")
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
