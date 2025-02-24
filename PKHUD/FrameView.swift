//
//  HUDView.swift
//  PKHUD
//
//  Created by Philip Kluz on 6/16/14.
//  Copyright (c) 2016 NSExceptional. All rights reserved.
//  Licensed under the MIT license.
//

import UIKit

/// Provides the general look and feel of the PKHUD, into which the eventual content is inserted.
internal class FrameView: UIVisualEffectView {

    internal init() {
        let blurEffectStyle: UIBlurEffect.Style
        if #available(iOS 13.0, *) {
            blurEffectStyle = .systemUltraThinMaterial
        } else {
            blurEffectStyle = .light
        }
        super.init(effect: UIBlurEffect(style: blurEffectStyle))
        DispatchQueue.main.async {
            self.commonInit()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        DispatchQueue.main.async {
            self.commonInit()
        }
    }

    private func commonInit() {
        if #available(iOS 13.0, *) {
            backgroundColor = .clear
        } else {
            backgroundColor = UIColor(white: 0.8, alpha: 0.36)
        }
        layer.cornerRadius = 9.0
        layer.masksToBounds = true

        contentView.addSubview(content)

        let offset = 20.0

        let motionEffectsX = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        motionEffectsX.maximumRelativeValue = offset
        motionEffectsX.minimumRelativeValue = -offset

        let motionEffectsY = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        motionEffectsY.maximumRelativeValue = offset
        motionEffectsY.minimumRelativeValue = -offset

        let group = UIMotionEffectGroup()
        group.motionEffects = [motionEffectsX, motionEffectsY]

        addMotionEffect(group)
    }

    private var _content = UIView()
    internal var content: UIView {
        get {
            return _content
        }
        set {
            _content.removeFromSuperview()
            _content = newValue
            _content.alpha = 0.85
            _content.clipsToBounds = true
            _content.contentMode = .center
            frame.size = _content.bounds.size
            contentView.addSubview(_content)
        }
    }
}
