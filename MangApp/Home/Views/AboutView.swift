//
//  AboutView.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-11.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.presentationMode) private var presentationMode
    @Environment(LoginModel.self) private var model
    var body: some View {
        @Bindable var model = model
        NavigationStack {
            Form {
                List {
                    SubtitleRowView(title: "Name", subtitle: "Juan Pérez")
                    SubtitleRowView(title: "Mail", subtitle: "Mail@mail.com")
                    
                    Section {
                        Button("Sign out", role: .destructive) {
                            model.logOut()
                        }
                    }
                }
            }
#if !os(macOS)
            .navigationBarTitle("About", displayMode: .inline)
#endif
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }.buttonStyle(.automatic)
                }
            }
        }
    }
}

#Preview {
    AboutView()
        .environment(LoginModel())
}
