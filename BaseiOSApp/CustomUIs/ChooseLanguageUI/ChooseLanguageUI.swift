//
//  ChooseLanguageUI.swift
//  truckerApp
//
//  Created by Waqas Ashraf on 28/11/2024.
//

import UIKit

struct LangaugeModel: Codable {
    
    var languageSlug: String
    var languageName: String
    var languageSymbol: String
    var isSelected: Bool
    
}

enum LangaugeSlug: String {
    case english = "english"
    case esponol = "esponol"
}

enum LanguageSymbols: String {
    case english = "en"
    case spanish = "es"
}

class ChooseLanguageUI: UIView, NibInstantiatable {
    
    @IBOutlet weak var langaugesTable: UITableView!
    @IBOutlet weak var langaugeTableHeight: NSLayoutConstraint!
    
    private var languages: Bindable<[LangaugeModel]> = Bindable([.init(languageSlug: LangaugeSlug.english.rawValue, languageName: "English", languageSymbol: LanguageSymbols.english.rawValue, isSelected: appSelectedLanguage?.languageSlug == LangaugeSlug.english.rawValue), .init(languageSlug: LangaugeSlug.esponol.rawValue, languageName: "Espanol", languageSymbol: LanguageSymbols.spanish.rawValue, isSelected: appSelectedLanguage?.languageSlug == LangaugeSlug.esponol.rawValue)])
    
    var disableClose: Bool = false
    
    typealias buttonAction = ((LangaugeModel?, ChooseLanguageUI) -> Void)?
    var action : buttonAction = nil
    
    @discardableResult
    class func showBottomSheet(parentView: UIView, disableClose: Bool = false, completion: buttonAction = nil) -> ChooseLanguageUI{
        let bottomSheet = ChooseLanguageUI.fromNib()
        bottomSheet.action = completion
        bottomSheet.disableClose = disableClose
        bottomSheet.bindViewModel()
        bottomSheet.registerCell()
        DispatchQueue.main.async {
            bottomSheet.frame = parentView.bounds
            parentView.addSubview(bottomSheet)
            
        }
        return bottomSheet
        
    }
    
    func registerCell() {
        let cellNib = UINib(nibName: LangaugeTableCell.identifier, bundle: .main)
        langaugesTable.register(cellNib, forCellReuseIdentifier: LangaugeTableCell.identifier)
    }
    
    private func selectLanguage(indexPath: Int) {
        var mutableLanguages = languages.value
        for (index, langauage) in (mutableLanguages ?? []).enumerated() {
            if index == indexPath {
                if mutableLanguages?[index].isSelected == false {
                    mutableLanguages?[index].isSelected = true
                }
            }
            else {
                mutableLanguages?[index].isSelected = false
            }
        }
        languages.value = mutableLanguages
    }
    
    @IBAction func closeBtn(_ sender: Any) {
        if !disableClose {
            self.removeFromSuperview()
        }
    }
    
}

extension ChooseLanguageUI: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        languages.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = langaugesTable.dequeueReusableCell(withIdentifier: LangaugeTableCell.identifier, for: indexPath) as! LangaugeTableCell
        let data = languages.value?[indexPath.row]
        cell.configureCellWithLangaugeData(data: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = languages.value?[indexPath.row]
        selectLanguage(indexPath: indexPath.row)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let action = self.action {
                action(data, self)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        10
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.langaugeTableHeight.constant = self.langaugesTable.contentSize.height
        }
    }
    
}

extension ChooseLanguageUI {
    
    private func bindViewModel() {
        languages.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.langaugesTable.reloadData()
            }
        }
    }
    
}
