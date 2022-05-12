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
    
    @State private var usernameExistsAlert: Bool = false
    
    var body: some View {
        VStack {
            ForEach(users, id: \.self) { user in
                Text(user.username!)
            }
            Group {
                HStack {
                    Text("Username")
                    TextField("Username", text: $username)
                }
                HStack {
                    Text("Password")
                    TextField("Password", text: $password)
                    
                }
                Button("Sign Up") {
                    self.signUp()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }.padding()
        }
        .navigationBarTitle("Sign Up")
        .alert(isPresented: $usernameExistsAlert) {
            Alert(title: Text("Error"), message: Text("Username already exists"))
        }
    }
    
    private func signUp() {
        let arr = self.users.filter { user in user.username == self.username}
        if arr.count == 1 {
            self.usernameExistsAlert = true
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
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
