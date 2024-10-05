//
//  Constants.swift
//  Reset
//
//  Created by Adrian Corscadden on 2024-10-05.
//

import Foundation

let StartDate: Date = {
    var dateComponents = DateComponents()
    dateComponents.year = 2024
    dateComponents.month = 10
    dateComponents.day = 4
    dateComponents.hour = 22
    dateComponents.minute = 0
    return Calendar.current.date(from: dateComponents)!
}()
