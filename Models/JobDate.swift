//
//  JobDate.swift
//  MainRoot
//
//  Created by Cole Parsons on 12/10/22.
//

import Foundation
import ElegantCalendar
import SwiftUI
import UIKit

struct JobDate {
    
    @State var jobs = JobDate.self
    @State var job = [Job]();
    //@State var jd = [JobDate]
    //@State var job = [Job]()
    //let locationName: String
    //let id: Int
    //let Business_Name: String
    var Name: String
    let tagColor: Color
    var arrivalDate: Date
    //var seq: Int
        
    
    //var Date_Needed: Date
    
    var duration: String {
        arrivalDate.timeOnlyWithPadding
    }
    
    //loadMyJobs()
    
    //let d : String
    
    //ForEach(jobs){
        
    //}
    
    func loadMyJobs()-> [Job] {
        let url = URL(string: "http://192.168.1.4:8000/myjobs/")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Basic Q29sZTpjb2xlY29sZWNvbGU=", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode([Job].self, from: data) {
                    DispatchQueue.main.async {
                        self.job = response
                        //generateVisits(start: Date, end: Date, job: job)
                        //return job
                    }
                    //return
                }
            }
            
            
        }.resume()
        return job
        
        
    }

    func getDate(d: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
        let date = dateFormatter.date(from: d)
        
        return date!
    }
    
}


extension JobDate: Identifiable {

    var id: Int {
        UUID().hashValue
    }

}

extension JobDate{
    
    static func mocks(start: Date, end: Date) -> [JobDate] {
        currentCalendar.generateVisits(start: start, end: end)
        
    }
    
    static func mock(withDate date: Date) -> JobDate {
        JobDate(Name: Calendar.Name,
              tagColor: .randomColor,
                arrivalDate: Calendar.arrivalDate)
    }
        
    static func getDate(d: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
        let date = dateFormatter.date(from: d)
    
        return date!
    }
    
    
}



let visitCountRange = 1...3

private extension Calendar {
    static var job = [Job]()
    static var jbs = [Job]();
    //static var i : [Job] = [Job]
    static var Name: String = ""
    static var c: Int = 0
    static var arrivalDate: Date = Date()
    //let visitCountRange = 1...20
    
    func generateVisits(start: Date, end: Date) -> [JobDate] {
        var visits = [JobDate]()
        //let jobs = Calendar.loadMyJobs()
        //var j = Calendar.loadMyJobs()
        //print(j)
        
            
        enumerateDates(
            startingAfter: start,
            matching: .everyDay,
            matchingPolicy: .nextTime) { date, _, stop in
            if let date = date {
                if date < end {
                    
                    //print(Calendar.c)
                    //print(b)
                    let ct = Calendar.getCount(withDate: Date())
                    for _ in 0...ct{
                        //print(Calendar.jbs[i].Business_Name)
                        //print("looped")
                        //var b = Calendar.mock(withDate: Date())
                        //visits = Calendar.mock(withDate: Date())
                        //print("i")
                        //let n = i.Business_Name
                        //print(n)
                        //let n = Calendar.mock(withDate: Date())
                        
                        //print(Calendar.mock(withDate: Date()))
                        visits.append(JobDate(Name: Calendar.mock(withDate: Date()), tagColor: .randomColor, arrivalDate: date))
                        //print(n)
                        //Calendar.c += 1
                        //Calendar.arrivalDate = date
                        //Calendar.seq += 1
                        //print(Calendar.mock(withDate: Date()))
                    }
                } else {
                    //.resume()
                    stop = true
                    //return
                }
            }
        }
        return visits
        
        
        
    }
    
    static func getCount(withDate date: Date) -> Int{
        
        
        //var c: Int
        let url = URL(string: "http://192.168.1.4:8000/jobs/")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Basic Q29sZTpjb2xlY29sZWNvbGU=", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode([Job].self, from: data) {
                    DispatchQueue.main.async {
                        jbs = response
 
                        var cnt = jbs.count
                            //print("2nd loop")
                        print(cnt)
                        //Name = jbs[Calendar.c].Business_Name
                            //print(k)
                            //JobDate(Name: item.Business_Name, tagColor: .randomColor, arrivalDate: getDate(d: item.Date_Needed))
                            //print("item")
                            //Name = jbs[c].Business_Name
                            //print(Name)
                            //visits.append(JobDate(Name: Name, tagColor: .randomColor, arrivalDate: date))
                            //Calendar.seq += 1
                           // print(seq)
                            //return
                            //Calendar.arrivalDate = getDate(d: item.Date_Needed)
                        //}
                        //return
                        //if c >= jbs.count{
                            //print("returned")
                            //return
                        //}
                    }
                    return
                }
                //return Calendar.Name
            }

            
        }.resume()
        return jbs.count
        
        
    }
    
    static func mock(withDate date: Date) -> String{
        
        
        //var c: Int
        var visits = [JobDate]()
        let url = URL(string: "http://192.168.1.4:8000/jobs/")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Basic Q29sZTpjb2xlY29sZWNvbGU=", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode([Job].self, from: data) {
                    DispatchQueue.main.async {
                        jbs = response
 
                        //var cnt = jbs.count
                            //print("2nd loop")
                        //print(cnt)
                        Name = jbs[0].Business_Name
                            //print(k)
                            //JobDate(Name: item.Business_Name, tagColor: .randomColor, arrivalDate: getDate(d: item.Date_Needed))
                            //print("item")
                            //Name = jbs[c].Business_Name
                            //print(Name)
                        visits.append(JobDate(Name: Name, tagColor: .randomColor, arrivalDate: date))
                            //Calendar.seq += 1
                           // print(seq)
                            //return
                            //Calendar.arrivalDate = getDate(d: item.Date_Needed)
                        //}
                        //return
                        //if c >= jbs.count{
                            //print("returned")
                            //return
                        //}
                        //return
                    }
                    return
                }
                //return Calendar.Name
            }

            
        }.resume()
        return Calendar.Name
        
        
    }
    
    
    
    
    func getDate(d: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
        let date = dateFormatter.date(from: d)
        
        return date!
    }
    
    
    
    
    //return jobs
}

fileprivate let colorAssortment: [Color] = [.turquoise, .forestGreen, .darkPink, .darkRed, .lightBlue, .salmon, .military]

private extension Color {

    static var randomColor: Color {
        let randomNumber = arc4random_uniform(UInt32(colorAssortment.count))
        return colorAssortment[Int(randomNumber)]
    }

}

private extension Color {

    static let turquoise = Color(red: 24, green: 147, blue: 120)
    static let forestGreen = Color(red: 22, green: 128, blue: 83)
    static let darkPink = Color(red: 179, green: 102, blue: 159)
    static let darkRed = Color(red: 185, green: 22, blue: 77)
    static let lightBlue = Color(red: 72, green: 147, blue: 175)
    static let salmon = Color(red: 219, green: 135, blue: 41)
    static let military = Color(red: 117, green: 142, blue: 41)

}

fileprivate extension Color {

    init(red: Int, green: Int, blue: Int) {
        self.init(red: Double(red)/255, green: Double(green)/255, blue: Double(blue)/255)
    }

}

fileprivate extension DateComponents {

    static var everyDay: DateComponents {
        DateComponents(hour: 0, minute: 0, second: 0)
    }

}
