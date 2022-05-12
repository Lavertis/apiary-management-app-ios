//
//  ApiaryListView.swift
//  ApiaryManagementApp
//
//  Created by Rafał Kuźmiczuk on 12/05/2022.
//  Copyright © 2022 Rafał Kuźmiczuk. All rights reserved.
//

import SwiftUI

struct BeeTypeListView: View {
    @Environment(\.managedObjectContext) private var dbContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \BeeType.name, ascending: true)], animation: .default)
    private var beeTypes: FetchedResults<BeeType>
    
    var body: some View {
        VStack {
            Button("Seed Bee Types") {
                self.seedBeeTypes()
            }
            List {
                ForEach(beeTypes, id: \.self) { beeType in
                    HStack {
                        Image(beeType.img!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150)
                        Text(beeType.name!)
                    }
                }
            }
        }.navigationBarTitle("Bee types")
    }
    
    func seedBeeTypes() {
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

struct BeeTypeListView_Previews: PreviewProvider {
    static var previews: some View {
        BeeTypeListView()
    }
}
