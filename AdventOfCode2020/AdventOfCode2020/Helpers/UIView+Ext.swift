//
//  UIView+Ext.swift
//  AdventOfCode2020
//
//  Created by Geir-Kåre S. Wærp on 21/10/2020.
//

import UIKit

extension UIView {
    func constrainToSuperView(leading: CGFloat = 0, trailing: CGFloat = 0, top: CGFloat = 0, bottom: CGFloat = 0, useSafeArea: Bool = false) {
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
