import SwiftUI

struct BeeTypeListView: View {
    @Environment(\.managedObjectContext) private var dbContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \BeeType.name, ascending: true)], animation: .default)
    private var beeTypes: FetchedResults<BeeType>
    
    @State private var showImage: Bool = false
    @State private var currentImg: String = ""
    @State private var offset: CGSize = .zero
    @State private var scale: CGFloat = 1
    
    var body: some View {
        ZStack {
            List {
                ForEach(beeTypes, id: \.self) { beeType in
                    HStack {
                        Image(beeType.img!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150)
                            .gesture(LongPressGesture()
                                .onEnded { _ in
                                    self.currentImg = beeType.img!
                                    self.showImage = true
                            })
                        Text(beeType.name!)
                    }
                }
            }
            if showImage {
                Image(self.currentImg)
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.size.width * 0.8)
                    .scaleEffect(self.scale)
                    .offset(self.offset)
                    .gesture(DragGesture()
                        .onEnded({ value in
                            if abs(value.translation.width) > (UIScreen.main.bounds.size.width * 0.4) {
                                self.showImage = false
                            }
                            if abs(value.translation.height) > (UIScreen.main.bounds.size.height * 0.3) {
                                self.showImage = false
                            }
                            self.offset = .zero
                            self.scale = 1
                        })
                        .onChanged({ value in
                            self.offset = value.translation
                            
                            let widthOffsetPctg = abs(self.offset.width) / UIScreen.main.bounds.size.width
                            let heightOffsetPctg = abs(self.offset.height) / UIScreen.main.bounds.size.height
                            let maxVal = max(widthOffsetPctg, heightOffsetPctg)
                            self.scale = 1 - 1.5 * maxVal
                        }))
            }
        }.navigationBarTitle("Bee types")
    }
}

struct BeeTypeListView_Previews: PreviewProvider {
    static var previews: some View {
        BeeTypeListView()
    }
}
