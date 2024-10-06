//
//  ContentView.swift
//  Reset
//
//  Created by Adrian Corscadden on 2024-10-05.
//

import SwiftUI
import SwiftData

struct TimeSinceView: View {
  let startDate: Date
  @State private var now = Date()
  let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

  private func timeElapsedComponents(from startDate: Date) -> (days: Int, hours: Int, minutes: Int, seconds: Int) {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.day, .hour, .minute, .second], from: startDate, to: now)
    return (days: components.day ?? 0, hours: components.hour ?? 0, minutes: components.minute ?? 0, seconds: components.second ?? 0)
  }

  var body: some View {
    let timeComponents = timeElapsedComponents(from: startDate)
    VStack(alignment: .leading, spacing: 10) {
      ProgressBar(label: "Days", value: Double(timeComponents.days), maxValue: 365)
        .tint(.four)
      ProgressBar(label: "Hours", value: Double(timeComponents.hours), maxValue: 24)
        .tint(.three)
      ProgressBar(label: "Minutes", value: Double(timeComponents.minutes), maxValue: 60)
        .tint(.two)
      ProgressBar(label: "Seconds", value: Double(timeComponents.seconds), maxValue: 60)
        .tint(.one)
    }
    .padding()
    .onReceive(timer) { _ in
      now = Date()  // Update the current time
    }
  }
}

struct ProgressBar: View {
  var label: String
  var value: Double
  var maxValue: Double

  var body: some View {
    VStack(alignment: .leading) {
      Text("\(label): \(Int(value))")
      ProgressView(value: value, total: maxValue)
        .progressViewStyle(LinearProgressViewStyle())
    }
  }
}

struct ContentView: View {

  @Environment(\.modelContext) private var context
  @Query(sort: \Reset.date) var resets: [Reset]

  var body: some View {
    ScrollView {
      VStack {
        TimeSinceView(startDate: resets.last!.date)
        Button("Add Reset", action: addReset)
          .buttonStyle(.borderedProminent)
        ForEach(resets) { reset in
          VStack(alignment: .leading) {
            Text(reset.date, style: .relative)
          }
        }
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

    context.insert(reset1)
    context.insert(reset2)
    context.insert(reset3)

    do {
      try context.save()
      print("inserted three resets")
    } catch let e {
      print(e)
    }
  }
}


#Preview {
  ContentView()
}
