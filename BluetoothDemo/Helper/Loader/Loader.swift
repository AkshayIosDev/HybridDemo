//
//  CustomLoader.swift
//  PartyKings
//
//  Created by Uma Shankar on 02/03/21.
//  Copyright © 2020 Dev-Story. All rights reserved.
//

import UIKit

class Loader: UIView {
    
    static let instance = Loader()
    
    var viewColor: UIColor = .black
    var setAlpha: CGFloat = 0.4
    
    lazy var transparentView: UIView = {
        let transparentView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        transparentView.backgroundColor = viewColor.withAlphaComponent(setAlpha)
        return transparentView
    }()
    
    lazy var spinner:Spinner = {
        var loaderView = Spinner(frame: CGRect(x: transparentView.center.x - 60, y: transparentView.center.y - 60, width: 80, height: 80))
        var spin = CubeGridSpinner(primaryColor: .blue)
        loaderView = spin
        loaderView.animationSpeed = 4
        loaderView.center = transparentView.center
        loaderView.clipsToBounds = true
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        return loaderView
    }()
    
    func showLoader() {
        self.addSubview(self.transparentView)
        let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        keyWindow?.addSubview(self.transparentView)
        
        spinner.startLoading()
       
        self.transparentView.addSubview(self.spinner)
        self.spinner.heightAnchor.constraint(equalToConstant: 80).isActive = true
        self.spinner.widthAnchor.constraint(equalToConstant: 80).isActive = true
        self.spinner.centerXAnchor.constraint(equalTo: transparentView.centerXAnchor, constant: 0).isActive = true
        self.spinner.centerYAnchor.constraint(equalTo: transparentView.centerYAnchor, constant: 0).isActive = true
        self.transparentView.bringSubviewToFront(self.spinner)
    }
    
    func hideLoader() {
        self.spinner.layer.removeAllAnimations()
        self.transparentView.removeFromSuperview()
    }
    
}
