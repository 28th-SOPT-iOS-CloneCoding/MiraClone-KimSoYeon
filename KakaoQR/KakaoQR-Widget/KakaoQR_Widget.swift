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

struct QRCodeEntryView : View {
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
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                            Spacer()
                        }
                        
                        Image("catWithMask")
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 5)
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
        .widgetURL(URL(string: "KakaoQR://product=20"))
    }
}

struct QRCode: Widget {
    let kind: String = "KakaoQR_Widget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            QRCodeEntryView(entry: entry)
        }
        .configurationDisplayName("QR체크인")
        .description("홈 화면에서 QR체크인 페이지로 빠르게 접근합니다.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

// profile widget
struct ProfileEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        ZStack(alignment: .leading) {
            Image("profile")
                .resizable()
                .scaledToFit()
                .overlay(Color.black.opacity(0.2))
            
            VStack {
                Spacer()
                Text("김소연")
                    .font(.system(size: 15))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            .padding()
        }
        .widgetURL(URL(string: "KakaoQR://"))
    }
}

struct Profile: Widget {
    let kind: String = "KakaoProfile_Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ProfileEntryView(entry: entry)
        }
        .configurationDisplayName("내 프로필")
        .description("내 프로필 이미지를 보여주고,\n나와의 채팅방으로 빠르게 접근합니다.")
        .supportedFamilies([.systemSmall])
    }
}

@main
struct KakaoQR_Widget: WidgetBundle {
    var body: some Widget {
        Profile()
        QRCode()
    }
}

struct KakaoQR_Widget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ProfileEntryView(entry: KakaoEntry(date: Date(), image: UIImage(named: "profile")!))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            QRCodeEntryView(entry: KakaoEntry(date: Date(), image: UIImage(named: "catWithMask")!))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            QRCodeEntryView(entry: KakaoEntry(date: Date(), image: UIImage(named: "catWithMask")!))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            QRCodeEntryView(entry: KakaoEntry(date: Date(), image: UIImage(named: "catWithMask")!))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
//        .redacted(reason: .placeholder)
    }
}
