//
//  AuthChoiceView.swift
//  ApiaryManagementApp
//
//  Created by Rafał Kuźmiczuk on 12/05/2022.
//  Copyright © 2022 Rafał Kuźmiczuk. All rights reserved.
//

import SwiftUI


struct HomeView: View {
    @State var username: String? = nil
    
    var body: some View {
        NavigationView {
            VStack {
                if username != nil {
                    Text("Current user: \(username ?? "")").padding()
                }
                Group {
                    if username == nil {
                        
                        NavigationLink(destination: SignInView(globalUsername: self.$username), label: {
                            Text("Sign In")
                        })
                        NavigationLink(destination: SignUpView(), label: {
                            Text("Sign Up")
                        })
                    }
                    else {
                        Button("Logout") {
                            self.username = nil
                        }
                    }
                    NavigationLink(destination: UserListView(), label: {
                        Text("User List")
                    })
                }
                .frame(width: 100)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding()
                
            }.navigationBarTitle("Apiary management")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
