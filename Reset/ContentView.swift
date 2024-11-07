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
  @State var showResetList = false
  @State var showResetChart = false
  @State var showManualEntry = false

  var body: some View {
    NavigationStack {
      ScrollView {
        VStack {
          if let lastReset = resets.last {
            TimeSinceView(startDate: lastReset.date)
          }
          HStack {
            Button("Add Reset Now", action: addReset)
              .buttonStyle(.borderedProminent)
            Button("Add Manual Entry", action: { showManualEntry.toggle() })
              .buttonStyle(.borderedProminent)
          }

          Button("Show Reset List >>", action: { showResetList = true })
            .buttonStyle(.borderedProminent)
          Button("Show Reset Chart >>", action: { showResetChart = true })
            .buttonStyle(.borderedProminent)
        }
      }
      .navigationDestination(isPresented: $showResetList) {
        ResetList()
      }
      .navigationDestination(isPresented: $showResetChart) {
        ResetsChartView()
      }
      .sheet(isPresented: $showManualEntry, content: ManualEntryView.init)
      .safeAreaInset(edge: .top) {
        Text("Resets")
          .padding()
      }
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
