//
//  UIView+Ext.swift
//  Advent of Code 2021
//
//  Created by Geir-Kåre S. Wærp on 28/11/2021.
//

import Foundation
import UIKit

extension UIView {
    func constrainToSuperView(top: CGFloat = 0, leading: CGFloat = 0, trailing: CGFloat = 0, bottom: CGFloat = 0, useSafeArea: Bool = false) {
        let leadingAnchor: NSLayoutXAxisAnchor = useSafeArea ? self.superview!.safeAreaLayoutGuide.leadingAnchor : self.superview!.leadingAnchor
        let trailingAnchor: NSLayoutXAxisAnchor = useSafeArea ? self.superview!.safeAreaLayoutGuide.trailingAnchor : self.superview!.trailingAnchor
        let topAnchor: NSLayoutYAxisAnchor = useSafeArea ? self.superview!.safeAreaLayoutGuide.topAnchor : self.superview!.topAnchor
        let bottomAnchor: NSLayoutYAxisAnchor = useSafeArea ? self.superview!.safeAreaLayoutGuide.bottomAnchor : self.superview!.bottomAnchor
        NSLayoutConstraint.activate([self.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leading),
                                     self.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -trailing),
                                     self.topAnchor.constraint(equalTo: topAnchor, constant: top),
                                     self.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottom)])
    }
}
