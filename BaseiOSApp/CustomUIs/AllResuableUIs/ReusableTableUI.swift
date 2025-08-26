//
//  ReusableTableUI.swift
//  truckerApp
//
//  Created by Waqas Ashraf on 08/07/2025.
//

import UIKit

enum SelectionType {
    case single
    case multiple
    case none
}

enum ReusableItemType {
    case singleSelectable
    case multipleSelectable
    case infoBulletPoint
}

struct GenericReusableParentModel {
    
    var selectionType: SelectionType = .none
    var itemModel: [GenericReusableItemModel]? = nil
    
}

struct GenericReusableItemModel {
    var title: String? = nil
    var subtitle: String? = nil
    var slug: String? = nil
    var itemType: ReusableItemType? = nil
    var isSelected: Bool = false
}

class ReusableTableUI: UIView, NibInstantiatable {
    
    var listModel: GenericReusableParentModel?
    
    typealias buttonAction = ((Int, AppDialogUI) -> Void)?
    var action : buttonAction = nil
    
    
    @IBOutlet weak var itemsTableView: UITableView!
    @IBOutlet weak var itemTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var itemTableTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var itemTableLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var itemTableTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var itemTableBottomConstraint: NSLayoutConstraint!
    
    
    
    
}
