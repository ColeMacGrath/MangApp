//
//  OfflineInfoView.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-18.
//

import SwiftUI

struct OfflineInfoView: View {
    @Environment(\.presentationMode) private var presentationMode
    @Environment(CollectionModel.self) private var model
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        @Bindable var model = model
        
        VStack(alignment: .center) {
            Image(systemName: "bolt.horizontal.icloud.fill")
                .font(.system(size: 70))
                .foregroundStyle(.accent)
            Text("You are switching to offline mode.")
                .bold()
                .font(.largeTitle)
            Spacer()
            HStack {
                Image(systemName: "iphone.gen3")
                    .font(.system(size: 60))
                VStack(alignment: .leading) {
                    Text("Your information will be stored on the device.")
                        .font(.title)
                    Text("In offline mode, you’ll be able to view and edit your saved mangas, but all your information will remain on your device only.")
                        .foregroundStyle(.secondary)
                }
                
                
            }
            
            Spacer()
            
            ColoredRoundedButton(title: "Go to offline") {
                model.offline = true
                model.isDataLoaded = false
                model.loadInitialMangas(context: modelContext)
                presentationMode.wrappedValue.dismiss()
            }
            ColoredRoundedButton(title: "Cancel", backgroundColor: Color(uiColor: .systemGray4), foregroundColor: .black) {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }.buttonStyle(.automatic)
            }
            
        }
    }
}

#Preview {
    NavigationStack {
        OfflineInfoView()
            .environment(CollectionModel())
    }
}
