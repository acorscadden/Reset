//
//  ResetWidget.swift
//  ResetWidget
//
//  Created by Adrian Corscadden on 2024-10-06.
//

import WidgetKit
import SwiftUI
import SwiftData

struct Provider: TimelineProvider {

  let container: ModelContainer

  init() {
    container = try! ModelContainer(for: Reset.self)
  }

  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date())
  }

  func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
    let entry = SimpleEntry(date: Date())
    completion(entry)
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    Task {
      let descriptor = FetchDescriptor<Reset>(sortBy: [SortDescriptor(\.date)])
      if let resets = try? await container.mainContext.fetch(descriptor) {
        if !resets.isEmpty {
          let lastReset = resets.last!
          let entry = SimpleEntry(date: lastReset.date)
          let timeline = Timeline(entries: [entry], policy: .atEnd)
          completion(timeline)
        } else {
          var entries: [SimpleEntry] = []

          // Generate a timeline consisting of five entries an hour apart, starting from the current date.
          let currentDate = Date()
          for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
          }

          let timeline = Timeline(entries: entries, policy: .atEnd)
          completion(timeline)
        }
      } else {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
          let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
          let entry = SimpleEntry(date: entryDate)
          entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
      }

    }
  }

  //    func relevances() async -> WidgetRelevances<Void> {
  //        // Generate a list containing the contexts this widget is relevant in.
  //    }
}

struct SimpleEntry: TimelineEntry {
  let date: Date
}

struct ResetWidgetEntryView : View {
  var entry: Provider.Entry

  var body: some View {
    TimeSinceView(startDate: entry.date)
  }
}

struct ResetWidget: Widget {
  let kind: String = "ResetWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      ResetWidgetEntryView(entry: entry)
        .containerBackground(.fill.tertiary, for: .widget)
    }
    .configurationDisplayName("My Widget")
    .description("This is an example widget.")
  }
}

#Preview(as: .systemSmall) {
  ResetWidget()
} timeline: {
  SimpleEntry(date: .now)
  SimpleEntry(date: .now)
}
