//
//  Theme.swift
//  Reset
//
//  Created by Adrian Corscadden on 2024-10-05.
//

import SwiftUI

extension Color {
  static var one = Color(hex: "048A81")
  static var two = Color(hex: "06D6A0")
  static var three = Color(hex: "54C6EB")
  static var four = Color(hex: "8A89C0")
  static var five = Color(hex: "CDA2AB")
}

extension Color {
  init(hex: String) {
    let hex = hex.trimmingCharacters(in:CharacterSet.alphanumerics.inverted)
    var int: UInt64 = 0
    Scanner(string: hex).scanHexInt64(&int)
    let a, r, g, b: UInt64
    switch hex.count {
    case 3: // RGB (12-bit)
      (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
    case 6: // RGB (24-bit)
      (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
    case 8: // ARGB (32-bit)
      (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
    default:
      (a, r, g, b) = (1, 1, 1, 0)
    }

    self.init(
      .displayP3,
      red: Double(r) / 255,
      green: Double(g) / 255,
      blue:  Double(b) / 255,
      opacity: Double(a) / 255
    )
  }
}
