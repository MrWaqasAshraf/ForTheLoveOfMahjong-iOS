//
//  ReusableLabelUI.swift
//  truckerApp
//
//  Created by Waqas Ashraf on 08/07/2025.
//

import UIKit

class ReusableLabelUI: UIView, NibInstantiatable {
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var titleLeadConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleTrailingConstraint: NSLayoutConstraint!
    
}
