//
//  DetailCell.swift
//  Forecast
//
//  Created by Alexandra on 02.03.2024.
//

import SwiftUI

struct DetailCell: View {
    
    let title: String
    let detail: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title).font(.body).fontWeight(.light)
            Text(detail).bold()
        }
        Divider()
    }
}

