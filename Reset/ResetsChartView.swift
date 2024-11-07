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
  
  private var dateRange: (start: Date, end: Date) {
    let calendar = Calendar.current
    let now = Date()
    
    switch selectedPeriod {
    case .week:
      let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!
      let weekEnd = calendar.date(byAdding: .day, value: 6, to: weekStart)!
      return (weekStart, weekEnd)
    case .month:
      let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
      let monthEnd = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: monthStart)!
      return (monthStart, monthEnd)
    case .sixMonths:
      let startDate = calendar.date(byAdding: .month, value: -6, to: now)!
      return (startDate, now)
    case .year:
      let yearStart = calendar.date(from: calendar.dateComponents([.year], from: now))!
      let yearEnd = calendar.date(byAdding: .year, value: 1, to: yearStart)!
      return (yearStart, yearEnd)
    }
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
      
      Chart {
        ForEach(getAllDatesInRange(), id: \.self) { date in
          BarMark(
            x: .value("Date", date, unit: selectedPeriod.dateUnit),
            y: .value("Count", getCountForDate(date))
          )
        }
      }
      .chartXAxis {
        AxisMarks(values: .stride(by: selectedPeriod.dateUnit))
      }
      .padding()
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
