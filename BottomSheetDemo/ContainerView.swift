//
//  ContainerView.swift
//  BottomSheetDemo
//
//  Created by Mithilesh Kumar on 12/09/18.
//  Copyright © 2018 PhonePe. All rights reserved.
//

import UIKit

final class ContainerView: UIView {
    private weak var mainView: UIView?
    private weak var bottomSheetView: UIView?
    private(set) weak var sheetBackgroundView: BottomSheetBackgroundView?
    private weak var sheetBackgroundTopConstraint: NSLayoutConstraint?
    
    init(mainViewController: UIViewController, bottomSheetViewController: UIViewController?) {
        self.mainView = mainViewController.view
        self.bottomSheetView = bottomSheetViewController?.view
        
        super.init(frame: .zero)
        
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var topDistance: CGFloat = 0 {
        didSet {
            sheetBackgroundTopConstraint?.constant = topDistance
        }
    }
    
    private func setupView() {
        guard let mainView = self.mainView else {
            return
        }
        
        self.addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        let vMainViewConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[mainView]-0-|", options: .alignAllCenterX, metrics: nil, views: ["mainView": mainView])
        let hMainViewConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[mainView]-0-|", options: .alignAllCenterX, metrics: nil, views: ["mainView": mainView])
        self.addConstraints(vMainViewConstraint + hMainViewConstraint)
        
        // The sheet table view goes all the way up to the status bar
        guard let sheetView = self.bottomSheetView else {
            return
        }
        
        self.addBackgroundView()
        self.add(sheetView: sheetView)
    }
    
    func addBackgroundView() {
        let backgroudView = BottomSheetBackgroundView()
        
        self.addSubview(backgroudView)
        self.sheetBackgroundView = backgroudView
        
        backgroudView.translatesAutoresizingMaskIntoConstraints = false
        
        let topConstraint = backgroudView.topAnchor.constraint(equalTo: topAnchor)
        
        NSLayoutConstraint.activate([
            topConstraint,
            backgroudView.heightAnchor.constraint(equalTo: heightAnchor),
            backgroudView.leftAnchor.constraint(equalTo: leftAnchor),
            backgroudView.rightAnchor.constraint(equalTo: rightAnchor)])
        sheetBackgroundTopConstraint = topConstraint
    }
    
    func add(sheetView: UIView) {
        self.bottomSheetView = sheetView
        
        sheetBackgroundView?.addSubview(sheetView)
        sheetView.translatesAutoresizingMaskIntoConstraints = false
        let vSheetViewConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[sheetView]-0-|", options: .alignAllCenterX, metrics: nil, views: ["sheetView": sheetView])
        let hSheetViewConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[sheetView]-0-|", options: .alignAllCenterX, metrics: nil, views: ["sheetView": sheetView])
        sheetBackgroundView?.addConstraints(vSheetViewConstraint + hSheetViewConstraint)
    }
    
    func show(bottomSheetViewController: BottomSheetViewController) {
        if self.sheetBackgroundView == nil {
            self.addBackgroundView()
        }
        
        add(sheetView: bottomSheetViewController.view)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let mainView = self.mainView,
            let sheetBackground = self.sheetBackgroundView,
            let sheetView = self.bottomSheetView else {
                
                return nil
        }
        
        if sheetBackground.bounds.contains(sheetBackground.convert(point, from: self)) {
            return sheetView.hitTest(sheetView.convert(point, from: self), with: event)
        }
        return mainView.hitTest(mainView.convert(point, from: self), with: event)
    }
}
