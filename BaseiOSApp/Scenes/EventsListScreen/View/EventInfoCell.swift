//
//  EventInfoCell.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 13/09/2025.
//

import UIKit

class EventInfoCell: UITableViewCell {
    
    static let identifier = "EventInfoCell"

    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventNameLbl: UILabel!
    @IBOutlet weak var eventAddressLbl: UILabel!
    @IBOutlet weak var eventTypeLbl: UILabel!
    @IBOutlet weak var eventCategoryLbl: UILabel!
    @IBOutlet weak var favIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCellWithEventData(data: MahjongEventData?, flowtype: EventsListType? = nil) {
        eventNameLbl.text = data?.name ?? "N/A"
        eventAddressLbl.text = data?.address ?? "N/A"
        eventTypeLbl.text = data?.type ?? "N/A"
        eventCategoryLbl.text = data?.category ?? "N/A"
        eventImage.getFullUrlImage(url: data?.image, placeHolderImage: .mahjong_logo_2)
        favIcon.isHidden = !(flowtype == .favourites)
    }
    
}
