//
//  MapSettingsUI.swift
//  truckerApp
//
//  Created by Waqas Ashraf on 22/01/2025.
//

import UIKit

class MapSettingsUI: UIView, NibInstantiatable {
    
    static let identifier = "MapSettingsUI"
    
    @IBOutlet weak var defaultMapTypeIcon: UIImageView!
    @IBOutlet weak var defaultView: UIView!
    @IBOutlet weak var defaultMapTypeLbl: UILabel!
    @IBOutlet weak var satelliteTypeIcon: UIImageView!
    @IBOutlet weak var satelliteView: UIView!
    @IBOutlet weak var satelliteTypeLbl: UILabel!
    @IBOutlet weak var terrainTypeIcon: UIImageView!
    @IBOutlet weak var terrainView: UIView!
    @IBOutlet weak var terrainTypeLbl: UILabel!
    @IBOutlet weak var trafficViewIcon: UIImageView!
    @IBOutlet weak var trafficView: UIView!
    @IBOutlet weak var trafficViewLbl: UILabel!
    
    var selectedMapStyle: MapViewType?
    var enableTraffic: Bool?
    
    typealias buttonAction = ((MapSettingModel?, MapSettingsUI) -> Void)?
    var action : buttonAction = nil
    
    @discardableResult
    class func showBottomSheet(parentView: UIView, mapModel: MapSettingModel? = nil, disableClose: Bool = false, completion: buttonAction = nil) -> MapSettingsUI{
        let bottomSheet = MapSettingsUI.fromNib()
        bottomSheet.action = completion
        if let mapModel {
            bottomSheet.setupMapSelection(mapSetting: mapModel.mapStyle.mapType)
            bottomSheet.setupTrafficSelection(enableTraffic: mapModel.enableTraffic)
        }
        DispatchQueue.main.async {
            bottomSheet.frame = parentView.bounds
            parentView.addSubview(bottomSheet)
            
        }
        return bottomSheet
        
    }
    
    private func setupMapSelection(mapSetting: MapViewType) {
        
        selectedMapStyle = mapSetting
        
        switch mapSetting {
        case .defaultType:
//            defaultMapTypeLbl.textColor = .clr_primary_2
//            defaultView.layer.borderColor = UIColor.clr_primary_2.cgColor
            defaultView.layer.borderWidth = 1.5
//            terrainTypeLbl.textColor = .clr_violet_2_dk
            terrainView.layer.borderColor = UIColor.clear.cgColor
            terrainView.layer.borderWidth = 0
//            satelliteTypeLbl.textColor = .clr_violet_2_dk
            satelliteView.layer.borderColor = UIColor.clear.cgColor
            satelliteView.layer.borderWidth = 0
        case .terrain:
//            defaultMapTypeLbl.textColor = .clr_violet_2_dk
            defaultView.layer.borderColor = UIColor.clear.cgColor
            defaultView.layer.borderWidth = 0
//            terrainTypeLbl.textColor = .clr_primary_2
//            terrainView.layer.borderColor = UIColor.clr_primary_2.cgColor
            terrainView.layer.borderWidth = 1.5
//            satelliteTypeLbl.textColor = .clr_violet_2_dk
            satelliteView.layer.borderColor = UIColor.clear.cgColor
            satelliteView.layer.borderWidth = 0
        case .satellite:
//            defaultMapTypeLbl.textColor = .clr_violet_2_dk
            defaultView.layer.borderColor = UIColor.clear.cgColor
            defaultView.layer.borderWidth = 0
//            terrainTypeLbl.textColor = .clr_violet_2_dk
            terrainView.layer.borderColor = UIColor.clear.cgColor
            terrainView.layer.borderWidth = 0
//            satelliteTypeLbl.textColor = .clr_primary_2
//            satelliteView.layer.borderColor = UIColor.clr_primary_2.cgColor
            satelliteView.layer.borderWidth = 1.5
        }
    }
    
    func setupTrafficSelection(enableTraffic: Bool) {
//        trafficViewLbl.textColor = enableTraffic ? .clr_primary_2 : .clr_violet_2_dk
//        trafficView.layer.borderColor = enableTraffic ? UIColor.clr_primary_2.cgColor : UIColor.clear.cgColor
        trafficView.layer.borderWidth = enableTraffic ? 1.5 : 0
        self.enableTraffic = enableTraffic
    }
    
    @IBAction func defaultBtn(_ sender: Any) {
//        defaultMapTypeLbl.textColor = .clr_primary
//        defaultMapTypeIcon.layer.borderColor = UIColor.clr_primary.cgColor
//        defaultMapTypeIcon.layer.borderWidth = 1.5
        setupMapSelection(mapSetting: .defaultType)
        if let action {
            action(MapSettingModel(mapStyle: .init(mapType: .defaultType), enableTraffic: enableTraffic ?? false), self)
        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//            
//            self.removeFromSuperview()
//        }
    }
    
    @IBAction func satelliteBtn(_ sender: Any) {
//        satelliteTypeLbl.textColor = .clr_primary
//        satelliteTypeIcon.layer.borderColor = UIColor.clr_primary.cgColor
//        satelliteTypeIcon.layer.borderWidth = 1.5
        setupMapSelection(mapSetting: .satellite)
        if let action {
            action(MapSettingModel(mapStyle: .init(mapType: .satellite), enableTraffic: enableTraffic ?? false), self)
        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//            self.removeFromSuperview()
//        }
    }
    
    @IBAction func terrainBtn(_ sender: Any) {
//        terrainTypeLbl.textColor = .clr_primary
//        terrainTypeIcon.layer.borderColor = UIColor.clr_primary.cgColor
//        terrainTypeIcon.layer.borderWidth = 1.5
        setupMapSelection(mapSetting: .terrain)
        if let action {
            action(MapSettingModel(mapStyle: .init(mapType: .terrain), enableTraffic: enableTraffic ?? false), self)
        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//            self.removeFromSuperview()
//        }
    }
    
    @IBAction func trafficBtn(_ sender: Any) {
//        trafficViewLbl.textColor = .clr_primary
//        trafficViewIcon.layer.borderColor = UIColor.clr_primary.cgColor
//        trafficViewIcon.layer.borderWidth = 1.5
        var trafficEnabled = enableTraffic
        trafficEnabled?.toggle()
        setupTrafficSelection(enableTraffic: trafficEnabled ?? true)
        if let action {
            action(MapSettingModel(mapStyle: .init(mapType: selectedMapStyle ?? .defaultType), enableTraffic: enableTraffic ?? false), self)
        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//            self.removeFromSuperview()
//        }
    }
    
    @IBAction func closeBtn(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    
}
