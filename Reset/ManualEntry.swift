//
//  ManualEntry.swift
//  Reset
//
//  Created by Adrian Corscadden on 2024-10-11.
//

import SwiftUI

struct ManualEntryView: View {

  @State var date = Date()
  @Environment(\.dismiss) var dismiss
  @Environment(\.modelContext) var context

  var body: some View {
    VStack {
      HStack {
        Text("Manual Entry")
          .font(.headline)
        Spacer()
        Button {
          dismiss()
        } label: {
          Image(systemName: "xmark")
            .padding()
            .background(.tint.opacity(0.2))
            .clipShape(Circle())
        }
      }
      DatePicker("Enter a Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
      Button("Save", action: save)
        .buttonStyle(.borderedProminent)
    }
    .padding()
  }

  func save() {
    let newReset = Reset(date: date)
    context.insert(newReset)
    do {
      try context.save()
      print("inserted one resets")
    } catch let e {
      print(e)
    }
    dismiss()
  }
}

#Preview {
  ManualEntryView()
}
