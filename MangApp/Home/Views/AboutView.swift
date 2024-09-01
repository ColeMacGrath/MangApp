//
//  AboutView.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-11.
//

import SwiftUI
import SwiftData

struct AboutView: View {
    @Environment(\.modelContext) private var context: ModelContext
    @Environment(\.presentationMode) private var presentationMode
    @Environment(LoginModel.self) private var model
    private let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    private let appBuild = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    
    var body: some View {
        @Bindable var model = model
        NavigationStack {
            ZStack {
#if os(iOS)
                Color(UIColor.systemGroupedBackground)
                    .ignoresSafeArea()
#endif
                
                VStack {
                    Image("appicon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 150)
                    
                    List {
                        if let appVersion, let appBuild {
                            Text("App Version: \(appVersion)")
                            Text("App Build: \(appBuild)")
                        }
                        
                        Section {
                            HStack {
                                Spacer()
                                Button("Sign out", role: .destructive) {
                                    model.logOut()
                                }
                                Spacer()
                            }
                        }
                    }
                    
                    HStack {
                        Text("Made with \("♥️") in")
                        Image(systemName: "swift")
                    }
                    .foregroundStyle(.secondary)
                }
                .padding()
#if os(iOS)
                .navigationBarTitle("MangaApp", displayMode: .inline)
#endif
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    AboutView()
        .environment(LoginModel())
}
