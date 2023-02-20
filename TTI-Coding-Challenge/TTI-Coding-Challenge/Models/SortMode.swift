// 
// Created by Shawn James
// SortMode.swift

import Foundation

enum SortMode: String, CaseIterable {
    case best
    case hot
    case top
    case new
    
    var displayName: String {
        self.rawValue.capitalized
    }
    
    var path: String {
        "\(self.rawValue).json"
    }
}
