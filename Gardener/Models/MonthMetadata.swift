//
//  MonthMetadata.swift
//  Gardener
//
//  Created by Ehtisham Khalid on 19.05.21.
//

import Foundation

struct MonthMetadata {
  let numberOfDays: Int
  let firstDay: Date
  let firstDayWeekday: Int
}

struct Day {
  let date: Date
  let number: String
  let isSelected: Bool
  let isWithinDisplayedMonth: Bool
}
