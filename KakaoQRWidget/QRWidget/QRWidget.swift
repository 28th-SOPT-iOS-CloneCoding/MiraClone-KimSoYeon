//
//  QRWidget.swift
//  QRWidget
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
        
        let entry = KakaoEntry(date: Date(),image: UIImage(named: "Placeholder")!)
        entries.append(entry)
        
        let timeline = Timeline(entries: entries, policy: policy)
        completion(timeline)
    }
}

struct KakaoEntry: TimelineEntry {
    let date: Date
    let image: UIImage
}

struct QRWidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    @Environment(\.colorScheme) var scheme
    
    var entry: Provider.Entry

    var body: some View {
        Image(uiImage: entry.image)
            .resizable()
            .scaledToFill()
    }
}

@main
struct QRWidget: Widget {
    let kind: String = "QRWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            QRWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("QR체크인")
        .description("홈 화면에서 QR체크인 페이지로\n빠르게 접근합니다.")
    }
}

struct QRWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            QRWidgetEntryView(entry: KakaoEntry(date: Date(), image: UIImage(named: "Placeholder")!))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            QRWidgetEntryView(entry: KakaoEntry(date: Date(), image: UIImage(named: "Placeholder")!))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            QRWidgetEntryView(entry: KakaoEntry(date: Date(), image: UIImage(named: "Placeholder")!))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
        
    }
}
