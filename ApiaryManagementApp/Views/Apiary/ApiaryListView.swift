import SwiftUI

struct ApiaryListView: View {
    @Environment(\.managedObjectContext) private var dbContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Apiary.name, ascending: true)], animation: .default)
    private var apiaries: FetchedResults<Apiary>
    
    @Binding var user: User?
    @State private var listId: Int = 0
    
    var body: some View {
        VStack {
            if (self.apiaries.filter { $0.user!.username == user!.username! }).count > 0 {
                List {
                    ForEach(apiaries.filter { $0.user!.username == user!.username! }, id: \.self) { apiary in
                        NavigationLink(
                            destination: ApiaryDetailsView(user: self.$user, apiaryName: apiary.name!),
                            label: {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Name: \(apiary.name!)")
                                        Text("Bee type: \(apiary.beeType!.name!)")
                                        Text("Hive count: \(apiary.hiveCount)")
                                        Text("Latitude: \(self.getDecimalAsStr(num: apiary.latitude! as Decimal))")
                                        Text("Longitude: \(self.getDecimalAsStr(num: apiary.longitude! as Decimal))")
                                    }
                                    Spacer()
                                    Image(apiary.beeType!.img!)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100)
                                }
                        }).padding(.vertical)
                    }.onDelete(perform: self.deleteApiary)
                }.id(listId)
            }
            else {
                Text("You don't have any apiary")
            }
        }.navigationBarTitle("My Apiaries")
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
            listId = listId + 1
        }
    }
    
    private func getDecimalAsStr(num: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 3
        formatter.minimumFractionDigits = 0
        formatter.numberStyle = .decimal
        return formatter.string(for: num) ?? ""
    }
}

struct ApiaryListView_Previews: PreviewProvider {
    static var previews: some View {
        ApiaryListView(user: .constant(User()))
    }
}
