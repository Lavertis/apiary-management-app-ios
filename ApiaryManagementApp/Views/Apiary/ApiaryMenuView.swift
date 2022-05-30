import SwiftUI

struct ApiaryMenuView: View {
    @Binding var user: User?
    
    @Environment(\.managedObjectContext) private var dbContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \BeeType.name, ascending: true)], animation: .default)
    private var beeTypes: FetchedResults<BeeType>
    
    var body: some View {
        VStack {
            Group {
                NavigationLink(destination: AddApiaryView(user: $user), label: {
                    Text("Add Apiary")
                })
                NavigationLink(destination: ApiaryListView(user: $user), label: {
                    Text("My Apiaries")
                })
                NavigationLink(destination: ApiaryMapView(user: $user), label: {
                    Text("My Apiaries Map")
                })
                NavigationLink(destination: BeeTypeListView(), label: {
                    Text("Bee Types")
                })
            }
            .frame(width: 130)
            .padding()
            .background(Color.orange)
            .foregroundColor(.white)
            .cornerRadius(5)
            .padding()
        }.navigationBarTitle("Apiary menu")
    }
}

struct ApariesMenuView_Previews: PreviewProvider {
    static var previews: some View {
        ApiaryMenuView(user: .constant(User()))
    }
}
