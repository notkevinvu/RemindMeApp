//
//  UIView_Constraints.swift
//  RemindMe
//
//  Created by Kevin Vu on 10/8/20.
//  Copyright © 2020 Kevin Vu. All rights reserved.
//

import UIKit

extension UIView {
    func setAndActivateConstraints(top: NSLayoutYAxisAnchor,
                                   bottom: NSLayoutYAxisAnchor,
                                   leading: NSLayoutXAxisAnchor,
                                   trailing: NSLayoutXAxisAnchor) {
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: top),
            self.bottomAnchor.constraint(equalTo: bottom),
            self.leadingAnchor.constraint(equalTo: leading),
            self.trailingAnchor.constraint(equalTo: trailing)
        ])
    }
}
