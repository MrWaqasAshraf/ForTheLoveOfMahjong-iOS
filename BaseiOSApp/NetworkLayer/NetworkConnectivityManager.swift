//
//  NetworkConnectivityManager.swift
//  rebox
//
//  Created by Waqas Ashraf on 13/03/2024.
//

import Network
import UIKit

final class NetworkMonitor{
    static let shared = NetworkMonitor()
    
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    
    public private(set) var isConnected: Bool = false
    public private(set) var connectionType: ConnectionType = .unknown
    
    enum ConnectionType{
        case wifi
        case cellular
        case ethernet
        case unknown
    }
    
    private init(){
        monitor = NWPathMonitor()
    }
    
    public func startMonitoring(){
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
            self?.getConnection(path)
            AppLogger.all("There is Internet: \(self?.isConnected ?? .init())")
            if self?.isConnected == false{
                DispatchQueue.main.async {
                    let window: UIWindow? = UIApplication.shared.keyWindow
//                    self?.showInternetAlert(message: "No Internet Connection", parentView: window, backgroundColor: .clr_maroon, toastImage: .no_internet_icon, animationDelay: 10)
                }
            }
            else{
                //Remove any previous displaying GenericToast
                DispatchQueue.main.async {
                    let window: UIWindow? = UIApplication.shared.keyWindow
//                    GenericToast.removePreviousToast(parentView: window, removeInternetToast: true)
                }
            }
        }
    }
    
    public func stopMonitoring(){
        monitor.cancel()
    }
    
    private func getConnection(_ path: NWPath){
        if path.usesInterfaceType(.wifi){
            connectionType = .wifi
        }
        else if path.usesInterfaceType(.cellular){
            connectionType = .cellular
        }
        else if path.usesInterfaceType(.wiredEthernet){
            connectionType = .ethernet
        }
        else{
            connectionType = .unknown
        }
    }
    
//    private func showInternetAlert(message: String, parentView: UIView? = nil, backgroundColor: UIColor = .black.withAlphaComponent(0.8), toastImage: UIImage = .checkmark, animation: AnimationType = .appear, animationDelay: TimeInterval = 5){
//        
//        let width = UIScreen.main.bounds.width * 0.8
//        
//        let keyWindow = parentView == nil ? UIApplication.shared.connectedScenes
//                .filter({$0.activationState == .foregroundActive})
//                .compactMap({$0 as? UIWindowScene})
//                .first?.windows
//                .filter({$0.isKeyWindow}).first : parentView
//        
//        let toast = GenericToast.fromNib()
//        //
//        toast.tag = 600
//        toast.layer.cornerRadius = 15
//        toast.appIcon.layer.cornerRadius = 2
//        toast.backgroundColor = backgroundColor
//        toast.messageLbl.text = message
//        toast.appIcon.image = toastImage
//        toast.parentView = keyWindow
//        toast.alpha = animation == .appear ? 0 : 1
////        toast.action = completion
//        toast.removeBtn.addTarget(toast, action: #selector (toast.removeToastBtn(_:)), for: .touchUpInside)
//        
//        let Lblheight = FrameSize(height: message.height(withConstrainedWidth: width - 70, font: .systemFont(ofSize: 18)), width: width - 70)
//        Logger.all("Label height is: \(Lblheight)")
//        
//        let isReasonableHeight = Lblheight.height > 40 + 12 + 16
//        let calculatedWidth = Lblheight.width + 70
//        let isReasonableWidth = calculatedWidth < width
//        
//        Logger.all("Width is: \(width), calculated width is: \(calculatedWidth)")
//        
//        toast.frame.size = CGSize(width: isReasonableWidth ? calculatedWidth : width, height: isReasonableHeight ? Lblheight.height : Lblheight.height + 24)
//        toast.center.x = keyWindow?.center.x ?? .init()
//        toast.center.y = /* animation == .popUp ? (keyWindow?.frame.size.height ?? .init()) : animation == .appear ? (keyWindow?.frame.size.height ?? .init())-100 : */ 100
//        
//        keyWindow?.addSubview(toast)
//        
//        UIView.animate(withDuration: animation == .appear ? 0.5 : 0.2, delay: 0, options: animation == .appear ? .curveEaseIn : .curveEaseOut, animations: {
////            if animation == .popUp{
////                toast.center.y -= 100
////            }
////            else if animation == .dropDown{
////                toast.center.y += 100
////            }
////            else{
//                toast.alpha = 1
////            }
//        }, completion: { _ in
////            UIView.animate(withDuration: 0.5, delay: animationDelay, options: .curveEaseOut, animations: {
////                if animation == .popUp{
////                    toast.center.y += 140
////                }
////                else if animation == .dropDown{
////                    toast.center.y -= 100
////                }
////                else{
////                    toast.alpha = 0
////                }
////            }, completion: {_ in
//////                toast.removeFromSuperview()
////            })
//        })
//        
//    }
}


