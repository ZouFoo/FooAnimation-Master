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


class CalendarViewController: UIViewController {

    let outsideMonthColor = UIColor(colorWithHexValue: 0x584a66)
    let monthColor = UIColor.white
    let selectedMonthColor = UIColor(colorWithHexValue: 0x3a294b)
    let currentDateSelectedViewColor = UIColor(colorWithHexValue: 0x4e3f5d)

    let formatter = DateFormatter()
    
    
    
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
        
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        
        
        return calendarView
    }()
    
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
        fsCalendar.appearance.headerMinimumDissolvedAlpha = 0;
        
        self.view.addSubview(fsCalendar)
        
        
        
        
    }
    
}
