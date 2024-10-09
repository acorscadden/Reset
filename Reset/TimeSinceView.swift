//
//  TimeSinceView.swift
//  Reset
//
//  Created by Adrian Corscadden on 2024-10-06.
//

import SwiftUI

struct LinearProgressView: View {
  let label: String
  let value: Double
  let maxValue: Double
  let height = 44.0

  var body: some View {
    Capsule().fill(.gray)
      .overlay {
        ZStack(alignment: .leading) {
          GeometryReader { proxy in
            Rectangle().fill(.tint)
              .frame(width: proxy.size.width * (value / maxValue))
          }
          Text("\(Int(value)) \(label)")
            .foregroundStyle(.white)
            .padding(.leading, 8)
        }
      }
      .clipShape(Capsule())
      .frame(height: height)
  }
}

struct TimeSinceView: View {
  let startDate: Date
  @State private var now = Date()
  let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

  private func timeElapsedComponents(from startDate: Date) -> (days: Int, hours: Int, minutes: Int, seconds: Int) {
    let calendar = Calendar.current
    let components = calendar.dateComponents(
      [.day, .hour, .minute, .second],
      from: startDate,
      to: now
    )
    return (days: components.day ?? 0, hours: components.hour ?? 0, minutes: components.minute ?? 0, seconds: components.second ?? 0)
  }

  var body: some View {
    let timeComponents = timeElapsedComponents(from: startDate)
    VStack(alignment: .leading, spacing: 10) {
      LinearProgressView(label: "Weeks", value: Double(timeComponents.days/7), maxValue: 52)
        .tint(.five)
      LinearProgressView(label: "Days", value: Double(timeComponents.days%7), maxValue: 7)
        .tint(.four)
      LinearProgressView(label: "Hours", value: Double(timeComponents.hours), maxValue: 24)
        .tint(.three)
      LinearProgressView(label: "Minutes", value: Double(timeComponents.minutes), maxValue: 60)
        .tint(.two)
      LinearProgressView(label: "Seconds", value: Double(timeComponents.seconds), maxValue: 60)
        .tint(.one)
    }
    .padding()
    .onReceive(timer) { _ in
      now = Date()
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
        .progressViewStyle(.linear)
        .controlSize(.extraLarge)
    }
  }
}

#Preview {
  TimeSinceView(startDate: StartDate)
}
