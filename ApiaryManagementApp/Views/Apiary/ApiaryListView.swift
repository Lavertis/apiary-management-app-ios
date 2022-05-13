//
//  ApiaryListView.swift
//  ApiaryManagementApp
//
//  Created by Rafał Kuźmiczuk on 13/05/2022.
//  Copyright © 2022 Rafał Kuźmiczuk. All rights reserved.
//

import SwiftUI

struct ApiaryListView: View {
    @Binding var username: String?
    
    @Environment(\.managedObjectContext) private var dbContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Apiary.name, ascending: true)], animation: .default)
    private var apiaries: FetchedResults<Apiary>
    
    var body: some View {
        VStack {
            if self.apiaries.count > 0 {
                List {
                    ForEach(apiaries.filter { $0.user?.username == username }, id: \.self) { apiary in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Name: \(apiary.name!)")
                                Text("Bee type: \(apiary.beeType!.name!)")
                                Text("Hive count: \(apiary.hiveCount)")
                                Text("Latitude: \(apiary.latitude!)")
                                Text("Latitude: \(apiary.longitude!)")
                            }
                            Spacer()
                            Image(apiary.beeType!.img!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100)
                        }
                    }.onDelete(perform: self.deleteApiary)
                }
            }
            else {
                Text("You don't have any apiary")
            }
        }.navigationBarTitle("My apiaries")
    }
    
    private func deleteApiary(offsets: IndexSet) {
        withAnimation {
            offsets.map { apiaries[$0] }.forEach(dbContext.delete)
            do {
                try dbContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ApiaryListView_Previews: PreviewProvider {
    static var previews: some View {
        ApiaryListView(username: .constant("Username"))
    }
}
