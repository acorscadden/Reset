//
//  ContentView.swift
//  Reset
//
//  Created by Adrian Corscadden on 2024-10-05.
//

import SwiftUI
import SwiftData

struct ContentView: View {

  @Environment(\.modelContext) private var context
  @Query(sort: \Reset.date) var resets: [Reset]

  var body: some View {
    ScrollView {
      VStack {
        if let lastReset = resets.last {
          TimeSinceView(startDate: lastReset.date)
        }
        Button("Add Reset", action: addReset)
          .buttonStyle(.borderedProminent)
        ForEach(resets) { reset in
          VStack(alignment: .leading) {
            Text(reset.date, style: .relative)
          }
        }
        DateGapsHeatmapView(dates: resets.map { $0.date })
      }
    }
    .safeAreaInset(edge: .top) {
      Text("Resets")
        .padding()
    }
    .onAppear {
//      preloadData()
    }
  }

  func addReset() {
    let newReset = Reset(date: Date())
    context.insert(newReset)
    do {
      try context.save()
      print("inserted one resets")
    } catch let e {
      print(e)
    }
  }

  func preloadData() {
    let reset1 = Reset(date: StartDate)
    let reset2 = Reset(date: reset2)
    let reset3 = Reset(date: reset3)
    let reset4 = Reset(date: reset4)
    let reset5 = Reset(date: reset5)
    let reset6 = Reset(date: reset6)

    context.insert(reset1)
    context.insert(reset2)
    context.insert(reset3)
    context.insert(reset4)
    context.insert(reset5)
    context.insert(reset6)

    do {
      try context.save()
      print("inserted three resets")
    } catch let e {
      print(e)
    }
  }
}


//#Preview {
//  ContentView()
//}
