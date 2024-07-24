//
//  Modifiers.swift
//  YumYum
//
//  Created by Kamil Biktineyev on 21.07.2024.
//

import SwiftUI

// Модификатор для добавления внешних теней
struct OuterShadowsStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(.yumBackground)
            .cornerRadius(20)
            .shadow(color: .yumLightShadow, radius: 5, x: -5, y: -5)
            .shadow(color: .yumDarkShadow, radius: 5, x: 5, y: 5)
    }
}

// Модификатор для добавления внутренних теней
struct InnerShadowsStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .cornerRadius(20)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(
                        .shadow(.inner(color: .yumLightShadow, radius: 3, x: -3, y: -3))
                        .shadow(.inner(color: .yumDarkShadow, radius: 3, x: 3, y: 3))
                    )
                    .foregroundColor(Color.yumBackground)
            )
    }
}
