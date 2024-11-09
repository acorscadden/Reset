//
//  ResetsChartView.swift
//  Reset
//
//  Created by Adrian Corscadden on 2024-11-07.
//

import SwiftUI
import SwiftData
import Charts

struct ResetsChartView: View {
  @Query(sort: \Reset.date, order: .reverse) var resets: [Reset]
  @State private var selectedPeriod: TimePeriod = .week
  @State private var offsetPeriods: Int = 0

  private var dateRange: (start: Date, end: Date) {
    let calendar = Calendar.current
    let now = calendar.date(byAdding: getOffsetComponent(), value: offsetPeriods, to: Date())!

    switch selectedPeriod {
    case .week:
      let weekStart = calendar.date(byAdding: .day, value: -6, to: now)!
      return (weekStart, now)
    case .month:
      let monthStart = calendar.date(byAdding: .day, value: -29, to: now)!
      return (monthStart, now)
    case .sixMonths:
      let startDate = calendar.date(byAdding: .month, value: -6, to: now)!
      return (startDate, now)
    case .year:
      let startDate = calendar.date(byAdding: .year, value: -1, to: now)!
      return (startDate, now)
    }
  }

  private var dateRangeText: String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return "\(formatter.string(from: dateRange.start)) - \(formatter.string(from: dateRange.end))"
  }

  var body: some View {
    VStack {
      Picker("Time Period", selection: $selectedPeriod) {
        ForEach(TimePeriod.allCases, id: \.self) { period in
          Text(period.rawValue).tag(period)
        }
      }
      .pickerStyle(SegmentedPickerStyle())
      .padding()
      .onChange(of: selectedPeriod) {
        offsetPeriods = 0 // Reset offset when period changes
      }

      // Navigation controls
      HStack {
        Button(action: { moveDate(forward: false) }) {
          Image(systemName: "chevron.left")
            .imageScale(.large)
        }

        Text(dateRangeText)
          .font(.subheadline)
          .foregroundColor(.secondary)

        Button(action: { moveDate(forward: true) }) {
          Image(systemName: "chevron.right")
            .imageScale(.large)
        }
        .disabled(offsetPeriods >= 0) // Disable forward navigation beyond current date
      }
      .padding(.horizontal)

      Chart {
        ForEach(getAllDatesInRange(), id: \.self) { date in
          BarMark(
            x: .value("Date", date, unit: selectedPeriod.dateUnit),
            y: .value("Count", getCountForDate(date))
          )
        }
      }
      .chartXAxis {
        switch selectedPeriod {
        case .week, .month:
          AxisMarks(values: .stride(by: .day)) { value in
            if let date = value.as(Date.self) {
              AxisValueLabel {
                Text(date, format: .dateTime.day())
              }
            }
          }
        case .sixMonths, .year:
          AxisMarks(values: .stride(by: .month)) { value in
            if let date = value.as(Date.self) {
              AxisValueLabel {
                Text(date, format: .dateTime.month(.abbreviated))
              }
            }
          }
        }
      }
      .padding()
      Spacer()
        .frame(height: 250.0)
    }
  }

  private func getAllDatesInRange() -> [Date] {
    let calendar = Calendar.current
    let range = dateRange
    var dates: [Date] = []
    var date = range.start

    while date <= range.end {
      dates.append(date)
      date = calendar.date(byAdding: .day, value: 1, to: date)!
    }

    return dates
  }

  private func getCountForDate(_ date: Date) -> Int {
    let calendar = Calendar.current
    return resets.filter { calendar.isDate($0.date, inSameDayAs: date) }.count
  }

  private func moveDate(forward: Bool) {
    offsetPeriods += forward ? 1 : -1
  }

  private func getOffsetComponent() -> Calendar.Component {
    switch selectedPeriod {
    case .week:
      return .weekOfYear
    case .month:
      return .month
    case .sixMonths:
      return .month
    case .year:
      return .year
    }
  }
}

enum TimePeriod: String, CaseIterable {
  case week = "W"
  case month = "M"
  case sixMonths = "6M"
  case year = "Y"
}

// Add these extensions to support the chart formatting
extension TimePeriod {
  var dateUnit: Calendar.Component {
    switch self {
    case .week, .month:
      return .day
    case .sixMonths:
      return .month
    case .year:
      return .month
    }
  }
}
