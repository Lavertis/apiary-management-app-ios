//
//  ApariesMenuView.swift
//  ApiaryManagementApp
//
//  Created by Rafał Kuźmiczuk on 12/05/2022.
//  Copyright © 2022 Rafał Kuźmiczuk. All rights reserved.
//

import SwiftUI

struct ApariesMenuView: View {
    @Binding var username: String?
    
    @Environment(\.managedObjectContext) private var dbContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \BeeType.name, ascending: true)], animation: .default)
    private var beeTypes: FetchedResults<BeeType>
    
    var body: some View {
        VStack {
            Group {
                NavigationLink(destination: AddApiaryView(username: $username), label: {
                    Text("Add Apiary")
                })
                NavigationLink(destination: ApiaryListView(username: $username), label: {
                    Text("My Apiaries")
                })
                NavigationLink(destination: BeeTypeListView(), label: {
                    Text("Bee Types")
                })
            }
            .frame(width: 120)
            .padding()
            .background(Color.orange)
            .foregroundColor(.white)
            .cornerRadius(5)
            .padding()
        }.navigationBarTitle("Apiaries")
    }
}

struct ApariesMenuView_Previews: PreviewProvider {
    static var previews: some View {
        ApariesMenuView(username: .constant("Username"))
    }
}
