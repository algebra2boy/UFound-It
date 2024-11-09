import SwiftUI

struct LostItem: Identifiable {
    let id = UUID()
    var title: String
    var description: String
}

struct ProfileView: View {
    
    @State private var items = [
        LostItem(title: "Wallet", description: "Black leather wallet with credit cards and ID."),
        LostItem(title: "Keys", description: "Bunch of keys on a keychain with a car key and house key."),
        LostItem(title: "Phone", description: "iPhone 13 in a blue case.")
    ]
    
    @State private var isAddingItem = false
    
    var body: some View {
        VStack {
            // Title
            Text("Request Lost Items")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            // List of cards with items
            List {
                // Add new item card
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                        .foregroundColor(.blue)
                    Text("Lost Item")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
                .onTapGesture {
                    isAddingItem.toggle()
                }
                .padding(.bottom, 10)
                
                // Cards for existing lost items
                ForEach(items) { item in
                    VStack(alignment: .leading) {
                        Text(item.title)
                            .font(.headline)
                            .padding(.bottom, 2)
                        Text(item.description)
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .contextMenu {
                        Button(action: {
                            if let index = items.firstIndex(where: { $0.id == item.id }) {
                                items.remove(at: index)
                            }
                        }) {
                            Text("Delete")
                            Image(systemName: "trash")
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
            .padding(.top)
        }
        .sheet(isPresented: $isAddingItem) {
            AddLostItemView(items: $items)
        }
    }
}

struct AddLostItemView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var items: [LostItem]
    @State private var title: String = ""
    @State private var description: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Item Details")) {
                    TextField("Item Title", text: $title)
                    TextField("Description", text: $description)
                }
                
                Button("Add Item") {
                    let newItem = LostItem(title: title, description: description)
                    items.append(newItem)
                    presentationMode.wrappedValue.dismiss()  // Dismiss the sheet
                }
                .disabled(title.isEmpty || description.isEmpty)
            }
            .navigationBarTitle("Add New Lost Item", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()  // Dismiss the sheet
            })
        }
    }
}

#Preview {
    ProfileView()
}
