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
        let policy: TimelineReloadPolicy = .atEnd
        
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
    @Environment(\.widgetFamily) var size
    
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            switch size {
            case .systemSmall:
                Image("Placeholder")
                    .resizable()
                    .scaledToFill()
            case .systemMedium:
                VStack {
                    Text("Medium Size")
                }
            case .systemLarge:
                VStack {
                    Text("Large Size")
                }
            @unknown default:
                VStack {
                    Text("Default")
                }
            }
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
        .configurationDisplayName("QR체크인")
        .description("홈 화면에서 QR체크인 페이지로 빠르게 접근합니다.")
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


// MARK: - View (When Widget Touched)

struct QRView: View {
    var body: some View {
        VStack {
            Text("Widget으로 넘어오셨군요!")
        }
    }
}

