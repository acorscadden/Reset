//
//  TimeSinceView.swift
//  Reset
//
//  Created by Adrian Corscadden on 2024-10-06.
//

import SwiftUI

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
    VStack(alignment: .leading, spacing: 0) {
      Text("\(label): \(Int(value))")
        .font(.caption)
      ProgressView(value: max(value, 0), total: maxValue)
        .progressViewStyle(LinearProgressViewStyle())
    }
  }
}

#Preview {
  TimeSinceView(startDate: Date())
}
