//
//  RN_widget.swift
//  RN-widget
//
//  Created by Gunjan Tripathi on 14/10/20.
//

import WidgetKit
import SwiftUI

struct Shared:Decodable {
  let c_name: String,
      c_age: Int,
      c_email: String
  
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
      SimpleEntry(date: Date(), name: "NA", age: 0, email: "NA" )
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), name: "NA", age: 0, email: "NA")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        var name = ""
        var age = 0
        var email = ""
        let sharedDefaults = UserDefaults.init(suiteName: "group.com.yourcompanyname")
          if sharedDefaults != nil {
                do{
                  let shared = sharedDefaults?.string(forKey: "myAppData")
                  if(shared != nil){
                  let data = try JSONDecoder().decode(Shared.self, from: shared!.data(using: .utf8)!)
                      name = data.c_name
                      age = data.c_age
                      email = data.c_email
                  }
                }catch{
                  print(error)
                }
          }

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, name: name, age: age, email: email )
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let name: String
    let age: Int
    let email: String
}

struct RN_widgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
      ZStack{
        Color(red: 0.09, green: 0.63, blue: 0.52)
          VStack(alignment: .leading) {
                  Image("contact")
                      .resizable()
                      .aspectRatio(contentMode: .fit)
                      .frame(width: 25, height: 25, alignment: .trailing )
                      .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                      .overlay(
                          Circle().stroke(Color.black)
                  )
            Spacer()
            
            Text(entry.name)
            .font(.system(size:10))
            .bold()
            
            Text("\(entry.age)" + " years old")
            .font(.system(size:10))
            .bold()
            Spacer()
            
            Text(entry.email)
            .font(.system(size:10))
            Spacer()
          
          }
          .padding(.all)
      }
        
    }
}

@main
struct RN_widget: Widget {
    let kind: String = "RN_widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            RN_widgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct RN_widget_Previews: PreviewProvider {
    static var previews: some View {
      RN_widgetEntryView(entry: SimpleEntry(date: Date(), name: "", age: 0, email: ""))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
