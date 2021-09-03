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
        KakaoEntry(date: Date(), image: UIImage(named: "catWithMask")!)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (KakaoEntry) -> ()) {
        let entry = KakaoEntry(date: Date(), image: UIImage(named: "catWithMask")!)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [KakaoEntry] = []
        let policy: TimelineReloadPolicy = .atEnd
        
        let entry = KakaoEntry(date: Date(), image: UIImage(named: "catWithMask")!)
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
                Image("catWithMask")
                    .resizable()
                    .scaledToFill()
            case .systemMedium:
                HStack(alignment: .center) {
                    Image("catWithMask")
                        .resizable()
                        .frame(width: 200, height: 200, alignment: .center)
                        .scaledToFill()
                    Spacer()
                    
                    VStack(alignment: .center, spacing: 7) {
                        Text("QR 체크인")
                            .font(.system(size: 13))
                            .fontWeight(.semibold)
                        
                        Text("홈에서 빠르고 손쉽게\n체크인을 햘 수 있어요!")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 10))
                            .lineSpacing(2)
                    }
                    
                    Spacer()
                }
            case .systemLarge:
                ZStack {
                    Color.init(UIColor(red: 255.0 / 255.0, green: 232.0 / 255.0, blue: 18.0 / 255.0, alpha: 1.0))
                    VStack {
                        HStack {
                            Text("빠르고 간편한\nKakao QR 체크인")
                                .font(.system(size: 20))
                            Spacer()
                        }
                        
                        Image("catWithMask")
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 3)
                            )
                    }
                    .padding()
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
            KakaoQR_WidgetEntryView(entry: KakaoEntry(date: Date(), image: UIImage(named: "catWithMask")!))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            KakaoQR_WidgetEntryView(entry: KakaoEntry(date: Date(), image: UIImage(named: "catWithMask")!))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            KakaoQR_WidgetEntryView(entry: KakaoEntry(date: Date(), image: UIImage(named: "catWithMask")!))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
//        .redacted(reason: .placeholder)
    }
}


