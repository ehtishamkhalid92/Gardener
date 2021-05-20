//
//  CalendarDateCell.swift
//  Watering
//
//  Created by Ehtisham Khalid on 23.04.21.
//  Copyright © 2021 Macbook. All rights reserved.
//

import UIKit

class CalendarDateCell: UICollectionViewCell{
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var selectionBackView: UIView!
    @IBOutlet weak var dayLabel: UILabel!
    
    
    var day: Day? {
      didSet {
        guard let day = day else { return }
        dayLabel.text = day.number
        accessibilityLabel = accessibilityDateFormatter.string(from: day.date)
        updateSelectionStatus()
      }
    }
    

    private lazy var accessibilityDateFormatter: DateFormatter = {
      let dateFormatter = DateFormatter()
      dateFormatter.calendar = Calendar(identifier: .gregorian)
      dateFormatter.setLocalizedDateFormatFromTemplate("EEEE, MMMM d")
      return dateFormatter
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
}
private func getDate(today:Date) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    dateFormatter.timeStyle = .none
    dateFormatter.dateStyle = .short
    let dateAsString = dateFormatter.string(from: today)
    return dateFormatter.date(from: dateAsString)!
}

private extension CalendarDateCell {
  // 1
    
  func updateSelectionStatus() {
    guard let day = day else { return }
    if day.isSelected {
      applySelectedStyle()
    } else {
      applyDefaultStyle(isWithinDisplayedMonth: day.isWithinDisplayedMonth)
    }
  }

  // 2
  var isSmallScreenSize: Bool {
    let isCompact = traitCollection.horizontalSizeClass == .compact
    let smallWidth = UIScreen.main.bounds.width <= 350
    let widthGreaterThanHeight =
      UIScreen.main.bounds.width > UIScreen.main.bounds.height

    return isCompact && (smallWidth || widthGreaterThanHeight)
  }

  // 3
  func applySelectedStyle() {
    accessibilityTraits.insert(.selected)
    accessibilityHint = nil
    self.shadowView.isHidden = false
    dayLabel.textColor = .white
    selectionBackView.backgroundColor = UIColor(hexString: "#029272")
    
    selectionBackView.layer.masksToBounds = false
    selectionBackView.layer.shadowOffset = CGSize(width: 1, height: 2)
    selectionBackView.layer.shadowRadius = 2.0
    selectionBackView.layer.shadowOpacity = 1.0
    selectionBackView.layer.shadowColor = #colorLiteral(red: 0.4996092492, green: 0.4996092492, blue: 0.4996092492, alpha: 1)
    
  }

  // 4
  func applyDefaultStyle(isWithinDisplayedMonth: Bool) {
    accessibilityTraits.remove(.selected)
    accessibilityHint = "Tap to select"
    self.shadowView.isHidden = true
    dayLabel.textColor = isWithinDisplayedMonth ? .label : .secondaryLabel
    selectionBackView.backgroundColor = .clear
    
    selectionBackView.layer.shadowRadius = 0
    selectionBackView.layer.shadowOpacity = 0
  }
}
