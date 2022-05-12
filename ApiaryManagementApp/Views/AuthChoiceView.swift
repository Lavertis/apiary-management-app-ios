//
//  AuthChoiceView.swift
//  ApiaryManagementApp
//
//  Created by Rafał Kuźmiczuk on 12/05/2022.
//  Copyright © 2022 Rafał Kuźmiczuk. All rights reserved.
//

import SwiftUI


struct AuthChoiceView: View {
    var body: some View {
        NavigationView {
            VStack {
                Group {
                    NavigationLink(destination: AuthChoiceView(), label: {
                        Text("Sign In")
                    })
                    NavigationLink(destination: AuthChoiceView(), label: {
                        Text("Sign Up")
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

struct AuthChoiceView_Previews: PreviewProvider {
    static var previews: some View {
        AuthChoiceView()
    }
}
