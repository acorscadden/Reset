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
    SimpleEntry(date: Date(), displayDate: .now)
  }

  func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
    let entry = SimpleEntry(date: Date(), displayDate: .now)
    completion(entry)
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    Task {
      let descriptor = FetchDescriptor<Reset>(sortBy: [SortDescriptor(\.date)])
      if let resets = try? await container.mainContext.fetch(descriptor) {
        if !resets.isEmpty {
          let lastReset = resets.last!
          var entries = [SimpleEntry]()
          for minute in 0 ..< 60 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minute, to: .now)!
            let entry = SimpleEntry(date: entryDate, displayDate: lastReset.date)
            entries.append(entry)
          }
          let timeline = Timeline(entries: entries, policy: .atEnd)
          completion(timeline)
        } else {
          let timeline = Timeline(entries: [SimpleEntry(date: .now, displayDate: .now)], policy: .atEnd)
          completion(timeline)
        }
      } else {
        let timeline = Timeline(entries: [SimpleEntry(date: .now, displayDate: .now)], policy: .atEnd)
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
  let displayDate: Date
}

struct ResetWidgetEntryView : View {
  var entry: Provider.Entry

  var body: some View {
    TimeSinceView(startDate: entry.displayDate)
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
  SimpleEntry(date: .now, displayDate: .now)
  SimpleEntry(date: .now, displayDate: .now)
}
