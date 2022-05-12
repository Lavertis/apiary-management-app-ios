//
//  AuthChoiceView.swift
//  ApiaryManagementApp
//
//  Created by Rafał Kuźmiczuk on 12/05/2022.
//  Copyright © 2022 Rafał Kuźmiczuk. All rights reserved.
//

import SwiftUI


struct HomeView: View {
    @State var username: String? = "user"
    
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
                        .frame(width: 100)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
                    }
                    else {
                        ApariesMenuView(username: self.$username)
                        Button("Logout") {
                            self.username = nil
                        }
                        .frame(width: 120)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
                    }
                }
            }.navigationBarTitle("Apiary management")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
