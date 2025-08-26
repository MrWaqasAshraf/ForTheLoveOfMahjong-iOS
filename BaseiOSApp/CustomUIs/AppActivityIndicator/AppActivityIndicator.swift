//
//  AppActivityIndicator.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 05/08/2025.
//

import UIKit
import SwiftUI
//import Lottie

class ActivityIndicator{
    
    static let shared = ActivityIndicator()
    
//    var pinchImageView = LottieAnimationView()
    
    private init(){}
    
    private var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
    private var backgroundView: UIView?
    
    private var containerView = UIView()
    private var progressView = UIView()
    
    private func cutView() -> CGFloat{
        let safeAreaValue: CGFloat = getSafeArea(safeAreaInset: .top)
        return (safeAreaValue + 48 + 2)
    }
    
    func showActivityIndicator(view: UIView, showBackground: Bool = false, backgroundColor: UIColor? = nil, isFullScreen: Bool = true, loaderBgColor: UIColor = .black, _ animation: String = "loading"){
        
        DispatchQueue.main.async {
            
            //Old
            /**/
             if showBackground{
                 self.backgroundView = UIView(frame: view.bounds)
                 self.backgroundView?.backgroundColor = backgroundColor ?? .white
                 if let backgroundView = self.backgroundView{
                     view.addSubview(backgroundView)
                 }
             }
             self.activityIndicatorView.color = .black
             self.activityIndicatorView.frame = view.frame
             self.activityIndicatorView.center = view.center
             view.addSubview(self.activityIndicatorView)
             self.activityIndicatorView.startAnimating()
             
            
            
            //New
            /*
             let cutHeight: CGFloat = isFullScreen ? 0 : self.cutView()
             self.containerView.frame = CGRect(x: 0, y: cutHeight, width: view.frame.width, height: (view.frame.height))
             self.containerView.backgroundColor = showBackground ? .white : .clr_black.withAlphaComponent(0.3)
             self.pinchImageView.animation = .named(animation)
             self.pinchImageView.backgroundColor = loaderBgColor
             self.pinchImageView.layer.cornerRadius = 10
             self.pinchImageView.setupAnimationView()
             self.pinchImageView.play()
             self.pinchImageView.frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
             self.progressView.frame = CGRect(x: 0, y: 0, width: (self.pinchImageView.frame.size.width), height: 60)
             self.progressView.backgroundColor = UIColor.clear
             let progressLocationOnScreen = CGPoint(x: (view.frame.width/2), y: (view.frame.height/2)-cutHeight)
             self.progressView.center = isFullScreen ? view.center : progressLocationOnScreen
             self.progressView.addSubview(self.pinchImageView)
             self.containerView.addSubview(self.progressView)
             view.addSubview(self.containerView)
             */
            
            
            
        }
        
    }
    
    func showActivityIndicatorOnBottom(view: UIView){
        DispatchQueue.main.async {
            self.activityIndicatorView.frame = CGRect(x: 0, y: view.frame.height - 100, width: view.frame.width, height: 60)
            view.addSubview(self.activityIndicatorView)
            self.activityIndicatorView.startAnimating()
        }
    }
    
    func removeActivityIndicator(){
        DispatchQueue.main.async {
            
            self.activityIndicatorView.stopAnimating()
            self.activityIndicatorView.removeFromSuperview()
            self.backgroundView?.removeFromSuperview()
            
            //For lottie
            /*
             self.pinchImageView.stop()
             self.pinchImageView.removeFromSuperview()
             self.progressView.removeFromSuperview()
             self.containerView.removeFromSuperview()
             */
            
            
        }
    }
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    
}

//MARK: GetSafeArea

enum UiSafeArea{
    case top
    case bottom
    case left
    case right
}

func getSafeArea(safeAreaInset: UiSafeArea)-> CGFloat{
    if let safeArea = UIApplication.shared.windows.last(where: { $0.isKeyWindow }){
        switch safeAreaInset {
        case .top:
            return safeArea.safeAreaInsets.top
        case .bottom:
            return safeArea.safeAreaInsets.bottom
        case .left:
            return safeArea.safeAreaInsets.left
        case .right:
            return safeArea.safeAreaInsets.right
        }
    }
    else{
        return 0
    }
    
}

// MARK: - SwiftUI wrapper
struct ActivityIndicatorView: UIViewRepresentable {
    var isAnimating: Bool
    var style: UIActivityIndicatorView.Style = .medium
    var color: UIColor = .black

    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: style)
        indicator.color = color
        return indicator
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

// MARK: - SwiftUI convenience modifier
struct ActivityIndicatorOverlay: ViewModifier {
    var isPresented: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                Color.black.opacity(0.3).ignoresSafeArea()
                ActivityIndicatorView(isAnimating: true, style: .medium, color: .black)
                    .frame(width: 50, height: 50)
//                    .background(Color.black.opacity(0.7))
                    .cornerRadius(10)
            }
        }
    }
}

extension View {
    func activityIndicatorOverlay(isPresented: Bool) -> some View {
        self.modifier(ActivityIndicatorOverlay(isPresented: isPresented))
    }
}
