//
//  BackgroundView.swift
//  YumYum
//
//  Created by Kamil Biktineyev on 30.07.2024.
//

import SwiftUI

struct BackgroundView: View {
    
    var body: some View {
        Rectangle()
            .fill(Color(.yumBackground))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
    }
}
