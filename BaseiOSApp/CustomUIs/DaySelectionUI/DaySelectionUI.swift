//
//  DaySelectionUI.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 20/09/2025.
//

import UIKit

struct ListOptionModel {
    
    var optionValue: String
    
}

class DaySelectionUI: UIView, NibInstantiatable {
    
    @IBOutlet weak var listTable: UITableView! {
        didSet {
            registerCell()
        }
    }
    @IBOutlet var listTableHeight: NSLayoutConstraint!
    
    var list: [ListOptionModel] = [.init(optionValue: "Monday"),
                                   .init(optionValue: "Tuesday"),
                                   .init(optionValue: "Wednesday"),
                                   .init(optionValue: "Thursday"),
                                   .init(optionValue: "Friday"),
                                   .init(optionValue: "Saturday"),
                                   .init(optionValue: "Sunday")]
    
    var closure: ((ListOptionModel?)->())?
    
    private func registerCell() {
        let cellNib = UINib(nibName: ListOptionCell.identifier, bundle: .main)
        listTable.register(cellNib, forCellReuseIdentifier: ListOptionCell.identifier)
    }
    
    private func remove() {
        DispatchQueue.main.async {
            self.removeFromSuperview()
        }
    }
    
    @IBAction func closeBtn(_ sender: Any) {
        remove()
    }
    
    
}

extension DaySelectionUI: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListOptionCell.identifier, for: indexPath) as! ListOptionCell
        let data = list[indexPath.row]
        cell.configureCell(data: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = list[indexPath.row]
        if let closure {
            closure(data)
            remove()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.listTableHeight.constant = self.listTable.contentSize.height
        }
    }
    
    
}
