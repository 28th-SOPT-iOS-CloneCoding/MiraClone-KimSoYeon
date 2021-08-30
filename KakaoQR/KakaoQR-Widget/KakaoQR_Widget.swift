//
//  KakaoQR_Widget.swift
//  KakaoQR-Widget
//
//  Created by soyeon on 2021/08/30.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> KakaoEntry {
        KakaoEntry(date: Date(), image: UIImage(named: "Placeholder")!)
    }

    func getSnapshot(in context: Context, completion: @escaping (KakaoEntry) -> ()) {
        let entry = KakaoEntry(date: Date(), image: UIImage(named: "Placeholder")!)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [KakaoEntry] = []
        var policy: TimelineReloadPolicy = .atEnd
        
        let entry = KakaoEntry(date: Date(), image: UIImage(named: "Placeholder")!)
        entries.append(entry)

        let timeline = Timeline(entries: entries, policy: policy)
        completion(timeline)
    }
}

struct KakaoEntry: TimelineEntry {
    let date: Date
    let image: UIImage
}

struct KakaoQR_WidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Image("Placeholder")
                .resizable()
                .scaledToFill()
        }
    }
}

@main
struct KakaoQR_Widget: Widget {
    let kind: String = "KakaoQR_Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            KakaoQR_WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct KakaoQR_Widget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            KakaoQR_WidgetEntryView(entry: KakaoEntry(date: Date(), image: UIImage(named: "Placeholder")!))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            KakaoQR_WidgetEntryView(entry: KakaoEntry(date: Date(), image: UIImage(named: "Placeholder")!))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            KakaoQR_WidgetEntryView(entry: KakaoEntry(date: Date(), image: UIImage(named: "Placeholder")!))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}
