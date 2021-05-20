//
//  JobRequestStepOneVC.swift
//  Gardener
//
//  Created by Ehtisham Khalid on 19.05.21.
//

import UIKit

class JobRequestStepOneVC: UIViewController {

    //MARK:- Properties.
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var segmentControl: CustomSegmentedControl!
    @IBOutlet weak var calendarCollection: UICollectionView!
    @IBOutlet weak var headerDateLabel: UILabel!
    
    
    //MARK:- Variables.
    private let calendar = Calendar(identifier: .gregorian)
    private lazy var dimmedBackgroundView: UIView = {
      let view = UIView()
      view.translatesAutoresizingMaskIntoConstraints = false
      view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
      return view
    }()
    var multipleselection = false
    private var selectedDates = [Date]()
    private var baseDate: Date = Date(){
      didSet {
        self.headerDateLabel.text = baseDate.to_Date_String(format: "MMMM YYYY")
        print{"Date is \(self.baseDate.toSlashDateString())"}
        days = generateDaysInMonth(for: baseDate)
        calendarCollection.reloadData()
      }
    }

    let daysNames = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
    private lazy var days = generateDaysInMonth(for: baseDate)

    private var numberOfWeeksInBaseDate: Int {
      calendar.range(of: .weekOfMonth, in: .month, for: baseDate)?.count ?? 0
    }

    public var selectedDateChanged: ((Date) -> Void)?
    public var selectedDatesChanged: (([Date])-> Void)?

    private lazy var dateFormatter: DateFormatter = {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "d"
      return dateFormatter
    }()
    
    //MARK:- View Life Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        self.baseDate = Date()
        selectedDatesChanged = {
            dates in
            for d in dates{
                print("Date Selected \(d.getFormatedStringInEnglish())")
            }
        }
        setupViews()
    }
    
    
    //MARK:- Actions
    @IBAction func segmentControlTapped(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            multipleselection = false
        }else {
            multipleselection = true
        }
        selectedDates.removeAll()
        days = generateDaysInMonth(for: Date())
        calendarCollection.reloadData()
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func continueBtnTapped(sender: UIButton){
        if selectedDates.count > 0 {
            print("Sleected Date =\(selectedDates)")
            print("Selected Segment =\(segmentControl.selectedSegmentIndex)")
            let SB = UIStoryboard(name: "Hiring", bundle: nil)
            let vc = SB.instantiateViewController(identifier: "JobRequestStepTwoVC") as! JobRequestStepTwoVC
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }else {
            Toast.show(message: "Please select the date(s) you want your plants watered.", controller: self)
        }
        
    }
    
    @IBAction func nextBtnAction(_ sender: UIButton) {
        self.baseDate = self.calendar.date(
          byAdding: .month,
          value: 1,
          to: self.baseDate
          ) ?? self.baseDate
    }
    
    @IBAction func previousBtnAction(_ sender: UIButton) {
        self.baseDate = self.calendar.date(
          byAdding: .month,
          value: -1,
          to: self.baseDate
          ) ?? self.baseDate
    }
    
    //MARK:- Private Functions
    private func setupViews() {
        continueBtn.addButtonShadow()
        continueBtn.addTarget(self, action: #selector(continueBtnTapped(sender:)), for: .touchUpInside)
    }

}
//MARK:- Collection view Delegate.
extension JobRequestStepOneVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return 7
        }
        return days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        if indexPath.section == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarHeaderCell", for: indexPath) as! CalendarHeaderCell
            let d = self.daysNames[indexPath.item]
            cell.dayLabel.text = d
            cell.dayLabel.textColor = .secondaryLabel
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "datecell", for: indexPath) as! CalendarDateCell
            let day = days[indexPath.row]
            
            if indexPath.item % 7 == 0{
                cell.backView.roundLeftCorners()
            }
            else if indexPath.item % 7 == 6{
                cell.backView.roundRightCorners()
            }
            else{
                cell.backView.unroundAllCorners()
            }
            cell.day = day
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    private func getDate(today:Date) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .short
        let dateAsString = dateFormatter.string(from: today)
        return dateFormatter.date(from: dateAsString)!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1{
            let day = days[indexPath.row]
            let current = getDate(today: Date()).timeIntervalSince1970
            let get = getDate(today: day.date).timeIntervalSince1970
            if get < current{
                return
            }
              if day.isWithinDisplayedMonth{
                  if self.multipleselection{
                      if calendar.isDate(day.date, indates: self.selectedDates){
                          self.selectedDates.removeAll{$0.isInSameDayOf(date: day.date)}
                      }
                      else{
                          self.selectedDates.append(day.date)
                      }
                    selectedDatesChanged!(self.selectedDates)
                  }
                  else{
                    self.selectedDates.removeAll()
                    self.selectedDates.append(day.date)
                    selectedDatesChanged!(self.selectedDates)
                  }
                    days = generateDaysInMonth(for: baseDate)
                    print(days)
                    collectionView.reloadData()
              }
              else{
                  
              }
        }
      
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let width = collectionView.frame.width / 7
      let height = collectionView.frame.height / CGFloat(numberOfWeeksInBaseDate + 1)
      return CGSize(width: width, height: height)
    }
}

private extension JobRequestStepOneVC {
  // 1
  func monthMetadata(for baseDate: Date) throws -> MonthMetadata {
    // 2
    guard
      let numberOfDaysInMonth = calendar.range(
        of: .day,
        in: .month,
        for: baseDate)?.count,
      let firstDayOfMonth = calendar.date(
        from: calendar.dateComponents([.year, .month], from: baseDate))
      else {
        // 3
        throw CalendarDataError.metadataGeneration
    }

    // 4
    let firstDayWeekday = calendar.component(.weekday, from: firstDayOfMonth)

    // 5
    return MonthMetadata(
      numberOfDays: numberOfDaysInMonth,
      firstDay: firstDayOfMonth,
      firstDayWeekday: firstDayWeekday)
  }

  enum CalendarDataError: Error {
    case metadataGeneration
  }
    
    func generateDaysInMonth(for baseDate: Date) -> [Day] {
      // 2
      guard let metadata = try? monthMetadata(for: baseDate) else {
        fatalError("An error occurred when generating the metadata for \(baseDate)")
      }

      let numberOfDaysInMonth = metadata.numberOfDays
      let offsetInInitialRow = metadata.firstDayWeekday
      let firstDayOfMonth = metadata.firstDay

      // 3
      var days: [Day] = (1..<(numberOfDaysInMonth + offsetInInitialRow))
        .map { day in
          // 4
          let isWithinDisplayedMonth = day >= offsetInInitialRow
          // 5
          let dayOffset =
            isWithinDisplayedMonth ?
            day - offsetInInitialRow :
            -(offsetInInitialRow - day)
          
          // 6
          return generateDay(
            offsetBy: dayOffset,
            for: firstDayOfMonth,
            isWithinDisplayedMonth: isWithinDisplayedMonth)
        }
        days += generateStartOfNextMonth(using: firstDayOfMonth)
      return days
    }

    // 7
    func generateDay(
      offsetBy dayOffset: Int,
      for baseDate: Date,
      isWithinDisplayedMonth: Bool
    ) -> Day {
        
      let date = calendar.date(
        byAdding: .day,
        value: dayOffset,
        to: baseDate)
        ?? baseDate
//        print("Date \(date.toSlashDateString()) | \(selectedDate.toSlashDateString())")
        
      return Day(
        date: date,
        number: dateFormatter.string(from: date),
        isSelected: calendar.isDate(date, indates: self.selectedDates),
        isWithinDisplayedMonth: isWithinDisplayedMonth
      )
    }
    // 1
    func generateStartOfNextMonth(
      using firstDayOfDisplayedMonth: Date
    ) -> [Day] {
      // 2
      guard
        let lastDayInMonth = calendar.date(
          byAdding: DateComponents(month: 1, day: -1),
          to: firstDayOfDisplayedMonth)
        else {
          return []
      }

      // 3
      let additionalDays = 7 - calendar.component(.weekday, from: lastDayInMonth)
      guard additionalDays > 0 else {
        return []
      }
      
      // 4
      let days: [Day] = (1...additionalDays)
        .map {
          generateDay(
          offsetBy: $0,
          for: lastDayInMonth,
          isWithinDisplayedMonth: false)
        }

      return days
    }
}
