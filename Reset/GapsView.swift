import SwiftUI

struct DateGapsHeatmapView: View {
  var dates: [Date]

  var body: some View {
    let sortedDates = dates.sorted()

    // Get the range between the first and last date
    guard let firstDate = sortedDates.first, let lastDate = sortedDates.last else {
      return AnyView(Text("No data available"))
    }

    // Group dates by occurrences (count the number of incidents per day)
    let incidentsPerDay = Dictionary(grouping: sortedDates, by: { $0 })
      .mapValues { $0.count }

    // Generate a sequence of all days between the first and last date
    let allDays = Calendar.current.generateDates(
      from: firstDate,
      to: lastDate,
      byAdding: .day
    )

    // Prepare the data for each day (set to 0 incidents if the day is not in the dates array)
    let chartData = allDays.map { day in
      DayGapData(date: day, incidents: incidentsPerDay[day] ?? 0)
    }

    let weeks = groupByWeeks(dates: allDays)

    return AnyView(
      ScrollView(.horizontal) {
        VStack(alignment: .leading) {
          // Display column headers (weeks)
          HStack {
            ForEach(weeks.indices, id: \.self) { index in
              Text("Week \(index + 1)")
                .font(.caption)
//                .multilineTextAlignment(.center)
            }
          }

          // Display the grid of rectangles
          ScrollView(.vertical) {
            LazyVGrid(
              columns: Array(repeating: GridItem(.flexible(), spacing: 1), count: 7),
              spacing: 1
            ) {
              ForEach(chartData) { data in
                Rectangle()
                  .fill(.red.opacity(data.incidents > 0 ? min(Double(data.incidents)/1.5, 1.0) : 0.1))
//                  .frame(width: 30, height: 30)
              }
            }
          }
        }
        .padding()
      }
    )
  }

  // Helper function to group days by weeks
  private func groupByWeeks(dates: [Date]) -> [[Date]] {
    var weeks: [[Date]] = []
    var currentWeek: [Date] = []
    let calendar = Calendar.current

    for date in dates {
      let weekOfYear = calendar.component(.weekOfYear, from: date)
      if currentWeek.isEmpty || calendar.component(.weekOfYear, from: currentWeek.last!) == weekOfYear {
        currentWeek.append(date)
      } else {
        weeks.append(currentWeek)
        currentWeek = [date]
      }
    }

    if !currentWeek.isEmpty {
      weeks.append(currentWeek)
    }

    return weeks
  }
}

// Data model for chart
struct DayGapData: Identifiable {
  let id = UUID()
  let date: Date
  let incidents: Int
}

extension Calendar {
  func generateDates(
    from startDate: Date,
    to endDate: Date,
    byAdding component: Calendar.Component
  ) -> [Date] {
    var dates = [Date]()
    var currentDate = startDate

    while currentDate <= endDate {
      dates.append(currentDate)
      currentDate = self.date(byAdding: component, value: 1, to: currentDate)!
    }

    return dates
  }
}

struct DateGapsHeatmapView_Previews: PreviewProvider {
  static var previews: some View {
    DateGapsHeatmapView(dates: [
      StartDate,
      reset2,
      reset3
    ])
//    DateGapsHeatmapView(dates: [
//      Date(),
//      Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
//      Calendar.current.date(byAdding: .day, value: 3, to: Date())!,
//      Calendar.current.date(byAdding: .day, value: 5, to: Date())!,
//      Calendar.current.date(byAdding: .day, value: 10, to: Date())!,
//      Calendar.current.date(byAdding: .day, value: 15, to: Date())!,
//      Calendar.current.date(byAdding: .day, value: 20, to: Date())!,
//      Calendar.current.date(byAdding: .day, value: 25, to: Date())!,
//      Calendar.current.date(byAdding: .day, value: 30, to: Date())!,
//      Calendar.current.date(byAdding: .day, value: 35, to: Date())!,
//      Calendar.current.date(byAdding: .day, value: 50, to: Date())!,
//      Calendar.current.date(byAdding: .day, value: 70, to: Date())!,
//      Calendar.current.date(byAdding: .day, value: 100, to: Date())!,
//
//      // Example with 5 incidents on the same date
//      Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
//      Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
//      Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
//      Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
//      Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
//      Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
//      Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
//      Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
//      Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
//      Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
//    ])
  }
}
