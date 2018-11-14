//
//  CalendarViewController.swift
//  FooAnimation-Master
//
//  Created by ZouDafu on 2018/10/8.
//  Copyright © 2018 ZouFoo. All rights reserved.
//

import UIKit
import JTAppleCalendar
import FSCalendar
import EventKit

class CalendarViewController: UIViewController {

    
    // MARK: - Attributes
    let outsideMonthColor = UIColor(colorWithHexValue: 0x584a66)
    let monthColor = UIColor.white
    let selectedMonthColor = UIColor(colorWithHexValue: 0x3a294b)
    let currentDateSelectedViewColor = UIColor(colorWithHexValue: 0x4e3f5d)

    let formatter = DateFormatter()
    
    var gregorianCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)

    
    
    //MARK: - UI
    lazy var yearLabel: UILabel = {
        let _label = UILabel(frame: CGRect(x: 10, y: 108, width: 100, height: 20))
        _label.font = UIFont.systemFont(ofSize: 16)
        _label.textColor = UIColor(colorWithHexValue: 0x77618b)
        _label.text = "year"
        return _label
    }()
    
    lazy var monthLabel: UILabel = {
        let _label = UILabel(frame: CGRect(x: 10, y: 128, width: 200, height: 40))
        _label.font = UIFont.systemFont(ofSize: 22)
        _label.textColor = UIColor.white
        _label.text = "month"
        return _label
    }()
    
    lazy var calendarView: JTAppleCalendarView = {
        
        let calendarView = JTAppleCalendarView(frame: CGRect(x: 0, y: 168, width: Int(SCREEN_WIDTH), height: 280 ))
        calendarView.calendarDelegate = self
        calendarView.calendarDataSource = self
        calendarView.register(CustomCell.self, forCellWithReuseIdentifier:"CustomCell")
        calendarView.isPagingEnabled = true
        calendarView.showsHorizontalScrollIndicator = false
        calendarView.showsVerticalScrollIndicator = false
        calendarView.scrollDirection = .horizontal
        calendarView.backgroundColor = UIColor(colorWithHexValue: 0x4a355b)
        calendarView.allowsDateCellStretching = false
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        
        return calendarView
    }()
    
    
    let rightButton : UIButton = {
        let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        rightButton.setTitle("```", for: .normal)
//        rightButton.addTarget(self, action: "showMoreAction", for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(showMoreAction), for: UIControl.Event.touchUpInside)
        
        return rightButton
    }()
    
    
    // MARK: - life
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "日历calendar"
        view.addSubview(calendarView)
        calendarView.visibleDates { visibleDates in
            let date = visibleDates.monthDates.first!.date
            
            self.formatter.dateFormat = "yyyy"
            self.yearLabel.text = self.formatter.string(from: date)
            
            self.formatter.dateFormat = "MMMM"
            self.monthLabel.text = self.formatter.string(from: date)
        }
        view.addSubview(yearLabel)
        view.addSubview(monthLabel)
        view.backgroundColor = UIColor(colorWithHexValue: 0x554467)
        
        setup()
    }
    
    func setup() {
        
        let rightbtn = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        rightbtn.setTitle("```", for: .normal)
        rightbtn.setTitleColor(.blue, for: .normal)
        rightbtn.addTarget(self, action: #selector(showMoreAction), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightbtn)
    
        let store = EKEventStore()
        let eArray = store.calendars(for: EKEntityType.event)
        print(eArray)
    }
    
    @objc func showMoreAction() {
        print("tap right barbutton")
        
        let store = EKEventStore()
        store.requestAccess(to: .event) { (bool, error) in
            if bool == false {
                //  没必要的三目运算
                let alert = UIAlertController(title: bool ?"⏰ 初始化成功" : "⏰ 初始化失败", message: nil, preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
            
            
        }
        let newEvent = EKEvent(eventStore: store)
        let alarm = EKAlarm(relativeOffset: -60 * 15) //（提醒时间） 以开始时间为0点，负前正后
        newEvent.title =  "这是我的事件2" //标题
        newEvent.notes = "吃完饭 来一根去不" //备注
        newEvent.addAlarm(alarm) // 添加提醒
        newEvent.startDate = Date() // 事件开始时间
        newEvent.endDate = newEvent.startDate.addingTimeInterval(300) // 事件结束时间
        newEvent.calendar = store.defaultCalendarForNewEvents

        do {
            try store.save(newEvent, span: .thisEvent)
            let alert = UIAlertController(title: "⏰ 提醒添加成功", message: nil, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
        } catch{ //} let error as NSError {
            let alert = UIAlertController(title:"⏰ 提醒添加失败", message: nil, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        
        //删除事件
//        let store = EKEventStore()
//        store.requestAccess(to: .event) { (bool, error) in
//            print(bool ? "⏰ 初始化成功" : "⏰ 初始化失败")
//        }
//        do {
//            try store.remove(yourevent, span: .thisEvent)
//            print("⏰ 提醒删除成功")
//        } catch let error as NSError {
//            print (error, "⏰ 提醒删除失败")
//        }


    }
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let vailCell = view as? CustomCell else {return}
        if cellState.isSelected {
            vailCell.label.textColor = selectedMonthColor
        } else {
            if cellState.dateBelongsTo == .thisMonth{
                vailCell.label.textColor = monthColor
            } else {
                vailCell.label.textColor = outsideMonthColor
            }
        }
    }
    
    func handleCellSelected(view: JTAppleCell?, cellState: CellState) {
        guard let vailCell = view as? CustomCell else {return}
        if cellState.isSelected {
            vailCell.backView.isHidden = false
        } else {
            vailCell.backView.isHidden = true
        }
    }
}


extension CalendarViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2018 01 01")!
        let endDate = formatter.date(from: "2018 12 31")!
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)

        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
        cell.label.text = cellState.text
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)

        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        print(date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)

    }

    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        
        formatter.dateFormat = "yyyy"
        yearLabel.text = formatter.string(from: date)
        
        formatter.dateFormat = "MMMM"
        monthLabel.text = formatter.string(from: date)
    }
}


extension UIColor {
    convenience init(colorWithHexValue value: Int, alpha: CGFloat = 1.0){
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}



//    FSCalendar   =============+++++++++===========++++++++++===========

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    
    override func loadView() {
        // 初始化View
        
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .white
        self.view = view
        
        
        let fsCalendar = FSCalendar(frame: CGRect(x: 0, y: 450, width: view.frame.size.width, height: 300))
//        fsCalendar.backgroundColor = .orange
        fsCalendar.delegate = self
        fsCalendar.dataSource = self
        fsCalendar.appearance.headerMinimumDissolvedAlpha = 0
        fsCalendar.appearance.weekdayTextColor = .orange
        fsCalendar.appearance.titleDefaultColor = .white
        fsCalendar.appearance.headerTitleColor = .white
        
        //        fsCalendar.scope = .week

        fsCalendar.firstWeekday = 2

        fsCalendar.headerHeight = 0
        
        fsCalendar.placeholderType = .fillHeadTail
        
        self.view.addSubview(fsCalendar)
        
        
    }
    

    //今天显示的文字
    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        if (self.gregorianCalendar?.isDateInToday(date))!{
            return "今天"
        }
        return nil
    }
    
    //显示圆点事件
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let string1 = "2018-10-18"
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY-MM-dd"
        let newDate = dateformatter.date(from: string1)
        
        print(date)
        print(newDate!)
        if date == newDate{
            return  2
        }
        
        return 1
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print(calendar.currentPage)
        
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(date)
    }
}
