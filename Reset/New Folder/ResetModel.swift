//
//  ResetModel.swift
//  Reset
//
//  Created by Adrian Corscadden on 2024-10-06.
//
import Foundation
import SwiftData

@Model
class Reset {
  var date: Date

  init(date: Date) {
    self.date = date
  }
}
