//
//  BackgroundView.swift
//  PhonePe
//
//  Created by Mithilesh Kumar on 10/09/18.
//  Copyright © 2018 PhonePe Internet Private Limited. All rights reserved.
//

import UIKit

private let borderWidth: CGFloat = 1
private let cornerRadius: CGFloat = 12

class BottomSheetBackgroundView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.cornerRadius = cornerRadius
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = borderWidth
        clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Make sure border isn't visible
        layer.bounds = CGRect(origin: bounds.origin,
                              size: CGSize(width: bounds.size.width + borderWidth * 2,
                                           height: bounds.size.height))
    }
    
    func removeAllSubViews() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
}
