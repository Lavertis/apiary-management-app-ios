//
//  UserListView.swift
//  ApiaryManagementApp
//
//  Created by Rafał Kuźmiczuk on 12/05/2022.
//  Copyright © 2022 Rafał Kuźmiczuk. All rights reserved.
//

import SwiftUI

struct UserListView: View {
    @Environment(\.managedObjectContext) private var dbContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \User.username, ascending: true)], animation: .default)
    private var users: FetchedResults<User>
    
    var body: some View {
        VStack {
            if self.users.count > 0 {
                List {
                    ForEach(users, id: \.self) { user in
                        Text("Login: \(user.username!)")
                    }.onDelete(perform: self.deleteUser)
                }
            }
            else {
                Text("There are no users")
            }
        }
    }
    
    private func deleteUser(offsets: IndexSet) {
        withAnimation {
            offsets.map { users[$0] }.forEach(dbContext.delete)
            do {
                try dbContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView()
    }
}
