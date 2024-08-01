//
//  TabItem.swift
//  YumYum
//
//  Created by Kamil Biktineyev on 25.07.2024.
//

import Foundation

struct TabItem: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let tappedIcon: String
}
