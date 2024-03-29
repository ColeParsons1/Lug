//
//  ElegantCalendarDelegate.swift
//  MainRoot
//
//  Created by Cole Parsons on 12/9/22.
//

import Foundation
import SwiftUI

public protocol ElegantCalendarDelegate: MonthlyCalendarDelegate, YearlyCalendarDelegate { }

public protocol MonthlyCalendarDelegate {

    func calendar(didSelectDay date: Date)
    func calendar(willDisplayMonth date: Date)

}

public extension MonthlyCalendarDelegate {

    func calendar(didSelectDay date: Date) { }
    func calendar(willDisplayMonth date: Date) { }

}

public protocol YearlyCalendarDelegate {

    func calendar(didSelectMonth date: Date)
    func calendar(willDisplayYear date: Date)

}

public extension YearlyCalendarDelegate {

    func calendar(didSelectMonth date: Date) { }
    func calendar(willDisplayYear date: Date) { }

}
