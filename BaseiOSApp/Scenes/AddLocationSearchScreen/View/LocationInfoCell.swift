//
//  LocationInfoCell.swift
//  rebox
//
//  Created by Waqas Ashraf on 14/03/2024.
//

import UIKit

class LocationInfoCell: UITableViewCell {

    static let identifier = "LocationInfoCell"
    
    var closure: (()->())? = nil
    
    @IBOutlet weak var leadingImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subtitleLbl: UILabel!
    @IBOutlet weak var trailingImage: UIImageView!
    @IBOutlet weak var deleteSearchBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureLocationCell(locationName: String, location: String) {
        titleLbl.text = locationName
        subtitleLbl.text = location
    }
    
    @IBAction func deleteSearchBtn(_ sender: Any) {
        if let closure{
            closure()
        }
    }
    
}
