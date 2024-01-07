//
//  Calender.swift
//  MainRoot
//
//  Created by Cole Parsons on 12/7/22.
//

import Foundation
import ElegantCalendar
import SwiftUI
import UIKit

struct CalendarView: View {

    @ObservedObject private var calendarManager: ElegantCalendarManager

    //let visitsByDay: [Date: [Visit]]
    let visitsByDay: [Date: [JobDate]]
    @State var job = [Job]();
    //let cal: CalendarView
    //DarkThemePreview {
        //self.preview
    //}

    //@State private var calendarTheme: DarkThemePreview<cal>//.orangeYellow

    init(ascVisits: [JobDate], initialMonth: Date?) {
            let configuration = CalendarConfiguration(
                calendar: currentCalendar,
                startDate: ascVisits.first!.arrivalDate,
                endDate: ascVisits.last!.arrivalDate)

            calendarManager = ElegantCalendarManager(
                configuration: configuration,
                initialMonth: initialMonth)

            visitsByDay = Dictionary(
                grouping: ascVisits,
                by: { currentCalendar.startOfDay(for: $0.arrivalDate) })

            calendarManager.datasource = self
            calendarManager.delegate = self
        }

    var body: some View {
        ZStack {
            ElegantCalendarView(calendarManager: calendarManager)
                .foregroundColor(Color.secondary)
                .background(Color.black.edgesIgnoringSafeArea(.all))
                .cornerRadius(4)
                //.vertical()
                .padding(.top, 80)
                //.padding(.bottom, -60)
            
        }.padding(.top, -50)
    }

    //private var changeThemeButton: some View {
        //ChangeThemeButton(calendarTheme: $calendarTheme)
    //}
    
}

extension CalendarView: ElegantCalendarDataSource {

    func calendar(backgroundColorOpacityForDate date: Date) -> Double {
        let startOfDay = currentCalendar.startOfDay(for: date)
        return 0.80//Double((visitsByDay[startOfDay]?.count ?? 0) + 3) / 10.0
    }
    
    func getDate(d: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
        let date = dateFormatter.date(from: d)
        
        return date!
    }

    func calendar(canSelectDate date: Date) -> Bool {
        let day = currentCalendar.dateComponents([.day], from: date).day!
        return day != 4
    }

    func calendar(viewForSelectedDate date: Date, dimensions size: CGSize) -> AnyView {
        let startOfDay = currentCalendar.startOfDay(for: date)
        return VisitsListView(height: size.height, jobdates: visitsByDay[startOfDay] ?? []).erased
    }
    
}

extension CalendarView: ElegantCalendarDelegate {

    func calendar(didSelectDay date: Date) {
        print("Selected date: \(date)")
    }

    func calendar(willDisplayMonth date: Date) {
        print("Month displayed: \(date)")
    }

    func calendar(didSelectMonth date: Date) {
        print("Selected month: \(date)")
    }

    func calendar(willDisplayYear date: Date) {
        print("Year displayed: \(date)")
    }

}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        
        CalendarView(ascVisits: JobDate.mocks(start: .daysFromToday(days: -365*2), end: .daysFromToday(days: 365*2)), initialMonth: nil)
    }
    static func getString(d: Date) -> String{
        let string = "20:32 Wed, 30 Oct 2019"
        let formatter4 = DateFormatter()
        formatter4.dateFormat = "HH:mm E, d MMM y"
        print(formatter4.date(from: string) ?? "Unknown date")
        
        return string
    }
    
}
