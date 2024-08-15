//
//  SearchPicker.swift
//  MangApp
//
//  Created by Moisés Córdova on 2024-08-14.
//

import SwiftUI

struct SearchPicker: View {
    @Binding var selectionType: SearchType
    var body: some View {
        Picker("Select Search Type", selection: $selectionType) {
            ForEach(SearchType.allCases) { searchType in
                Text(searchType.rawValue).tag(searchType)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}


#Preview {
    SearchPicker(selectionType: .constant(.author))
}
