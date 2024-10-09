//
//  ResetList.swift
//  Reset
//
//  Created by Adrian Corscadden on 2024-10-07.
//

import SwiftUI
import SwiftData

struct ResetList: View {

  @Environment(\.modelContext) private var context
  @Query(sort: \Reset.date) var resets: [Reset]

  var body: some View {
    List {
      ForEach(resets) { reset in
        HStack {
          Text(reset.date, style: .relative)
          Button("Delete") {
            delete(reset)
          }
        }
      }
    }
  }

  func delete(_ reset: Reset) {
    context.delete(reset)
    do {
      try context.save()
    } catch let e {
      print(e)
    }
  }

}
