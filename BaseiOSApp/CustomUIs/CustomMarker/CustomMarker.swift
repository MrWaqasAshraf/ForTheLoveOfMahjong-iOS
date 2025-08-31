//
//  CustomMarker.swift
//  truckerApp
//
//  Created by Waqas Ashraf on 5/20/24.
//

import UIKit

class CustomMarker: UIView, NibInstantiatable{
    
    @IBOutlet weak var markerImage: UIImageView!
    @IBOutlet weak var internalImageIcon: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var markerImageLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var markerImageTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var markerImageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var markerImageBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var markerImageHeight: NSLayoutConstraint!
    @IBOutlet weak var markerImageWidth: NSLayoutConstraint!
    
}
