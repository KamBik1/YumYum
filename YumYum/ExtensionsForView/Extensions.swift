//
//  Extensions.swift
//  YumYum
//
//  Created by Kamil Biktineyev on 22.07.2024.
//

import SwiftUI

// Расширение для добавления теней
extension View {
    func outerShadowsStyle() -> some View {
        modifier(OuterShadowsStyle())
    }
    
    func innerShadowsStyle() -> some View {
        modifier(InnerShadowsStyle())
    }
    
    func applyShadowStyle(_ isPressed: Bool) -> some View {
        Group {
            if isPressed {
                self.innerShadowsStyle()
            } else {
                self.outerShadowsStyle()
            }
        }
    }
}

// Расширение, чтобы убрать клавиатуру во view
extension View {
    func hideKeyboardOnTap() -> some View {
        self.onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}

// Расширение, чтобы убрать клавиатуру
extension UIApplication {
    func endEditing() {
        self.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
