//
//  SearchBar.swift
//  WeathreForecasting
//
//  Created by Sajjeel Hussain Khilji on 12/10/2024.
//

import Foundation
import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var onSearchButtonClicked: () -> Void
    
    var body: some View {
        HStack {
            TextField("Enter city name", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .accessibility(identifier: "Enter city name")
            
            Button(action: onSearchButtonClicked) {
                Image(systemName: "magnifyingglass")
            }
            .accessibility(identifier: "Fetch Weather")
        }
        .padding()
    }
}
