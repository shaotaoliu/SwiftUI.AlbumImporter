import SwiftUI

struct ContentView: View {
    @ObservedObject var vm = ViewModel()
    @State var checkAll = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.images, id: \.id) { model in
                    HStack {
                        Image(uiImage: model.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .clipped()
                        
                        Text(model.name)
                        Spacer()
                        
                        CheckButton(selected: $vm.images[vm.images.firstIndex(where: {
                            $0.id == model.id
                        })!].selected)
                    }
                    .padding()
                }
            }
            .listStyle(.plain)
            .navigationTitle("Import to Album")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button("Import") {
                vm.import()
            }.alert("Info", isPresented: $vm.hasMessage, presenting: vm.message, actions: { message in
            }, message: { message in
                Text(message)
            }), trailing: CheckButton(selected: $checkAll) {
                vm.all(selected: checkAll)
            }.padding(.trailing, 18))
        }
    }
    
    struct CheckButton: View {
        @Binding var selected: Bool
        var action: (() -> Void)? = nil
        
        var body: some View {
            Button(action: {
                selected.toggle()
                action?()
            }, label: {
                Image(systemName: selected ? "checkmark.square" : "square")
            })
                .font(.title3)
                .buttonStyle(.borderless)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
