//
//  CalenderExtension.swift
//  Watering
//
//  Created by Ehtisham Khalid on 23.04.21.
//  Copyright © 2021 Macbook. All rights reserved.
//
import UIKit

extension Date {
    
    func convertToTimeZone(initTimeZone: TimeZone, timeZone: TimeZone) -> Date {
        let delta = TimeInterval(timeZone.secondsFromGMT() - initTimeZone.secondsFromGMT())
        return addingTimeInterval(delta)
    }
    
    func getFormatedStringInEnglish(timezon: TimeZone = TimeZone.current)->String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        //dateFormatter.dateFormat = "MM-dd-yyyy"
        switch true {
        case Calendar.current.isDateInToday(self) || Calendar.current.isDateInYesterday(self):
            dateFormatter.doesRelativeDateFormatting = true
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .short
        case Calendar.current.isDate(self, equalTo: Date(), toGranularity: .weekOfYear):
            dateFormatter.dateFormat = "EEEE h:mm a"
        case Calendar.current.isDate(self, equalTo: Date(), toGranularity: .year):
            dateFormatter.dateFormat = "E, d MMM, h:mm a"
        default:
            dateFormatter.dateFormat = "MMM d, yyyy, h:mm a"
        }
        
        dateFormatter.locale = Locale(identifier: "en_US")
        let text = dateFormatter.string(from: self)
        return text
    }
    func isInSameDayOf(date: Date) -> Bool {
        return Calendar.current.isDate(self, inSameDayAs:date)
    }
    
    func to_Date_String(format: String = "yyyy-MM-dd") -> String {
        let df = DateFormatter()
        df.locale = Locale.init(identifier: "en_GB")
        df.dateFormat = format
        return df.string(from: self)
    }
    
    func toSlashDateString() -> String {
        let df = DateFormatter()
        df.locale = Locale.init(identifier: "en_GB")
        df.dateFormat = "yyyy/MM/dd"
        return df.string(from: self)
    }
    
    func timeAsString() -> String {
        let df = DateFormatter()
        df.calendar = Calendar.current
        df.setLocalizedDateFormatFromTemplate("hh:mm")
        return df.string(from: self)
    }
    
    func monthNameAsString() -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("MMMM")
        return df.string(from: self)
    }
    
    func dayAsString() -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("EEE")
        return df.string(from: self)
    }
    
    func dayFullNameAsString() -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("EEEE")
        return df.string(from: self)
    }
    
    func dateAsString() -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("dd")
        return df.string(from: self)
    }
    
    func dateWMonthAsString() -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("dd , MMM")
        return df.string(from: self)
    }
    
    func yearAsString() -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("yyyy")
        return df.string(from: self)
    }
    
    func monthAsString() -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("MM")
        return df.string(from: self)
    }
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    func incrementDays(numberOfDays: Int) -> Date {
        let date = Calendar.current.date(byAdding: .day, value: numberOfDays, to: self)
        return date!
    }
    
    func incrementMonths(numberOfMonths: Int) -> Date {
        let date = Calendar.current.date(byAdding: .month, value: numberOfMonths, to: self)
        return date!
    }
}



extension UIView {
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
    }
    
    func roundLeftCorners(){
        self.clipsToBounds = true
        self.layer.cornerRadius = 24
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }
    
    func roundRightCorners(){
        self.clipsToBounds = true
        self.layer.cornerRadius = 24
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    }
    
    func unroundAllCorners(){
        self.clipsToBounds = false
        self.layer.cornerRadius = 0
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner]
    }

    func applyCircleShadow(shadowRadius: CGFloat = 6,
                           shadowOpacity: Float = 0.3,
                           shadowColor: CGColor = UIColor.black.cgColor,
                           shadowOffset: CGSize = CGSize.zero) {
        layer.cornerRadius = frame.size.height / 2
        layer.masksToBounds = false
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
    }
    
    @IBInspectable var isCircleMe: Bool {
        get {
            return self.isCircleMe
        }
        set {
            if newValue == true {
                let radius = self.bounds.width / 2
                self.layer.cornerRadius = radius
                self.layer.masksToBounds = true
                self.clipsToBounds = true
            }
        }
    }
    
    @IBInspectable var shadowOnCalender: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadow()
            }
        }
    }
    
    @IBInspectable var BorderColor: UIColor {
        get {
            return UIColor.init(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable var BorderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var viewcornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            
            // Don't touch the masksToBound property if a shadow is needed in addition to the cornerRadius
            if shadowOnCalender == false {
                self.layer.masksToBounds = true
            }
        }
    }
    
    func addShadow(shadowColor: CGColor = UIColor.lightGray.cgColor,
                   shadowOffset: CGSize = CGSize(width: 1, height: 1.0),
                   shadowOpacity: Float = 0.6,
                   shadowRadius: CGFloat = 6) {
        
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
    
    
   
    
}


extension UIColor {
    
    convenience init(rgb: UInt, alpha: CGFloat = 1) {
        
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    
    static func randomFloat() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
    
    static func random() -> UIColor {
        return UIColor(red:   UIColor.randomFloat(),
                       green: UIColor.randomFloat(),
                       blue:  UIColor.randomFloat(),
                       alpha: 1.0)
    }
}

extension Calendar{
    func isDate(_ date: Date, indates: [Date])-> Bool{
        var isInSameDays = false
        for d in indates{
            if self.isDate(date, inSameDayAs: d){
                isInSameDays = true
            }
        }
        return isInSameDays
    }
}

