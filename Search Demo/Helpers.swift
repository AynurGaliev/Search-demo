//
//  Helpers.swift
//  Search Demo
//
//  Created by Aynur Galiev on 25.ноября.2016.
//  Copyright © 2016 Aynur Galiev. All rights reserved.
//

import Foundation
import UIKit

let StatusBarHeight = UIApplication.shared.statusBarFrame.height

extension UIView {
    
    var bottom: CGFloat {
        return self.frame.origin.y + self.frame.size.height
    }
    
    var top: CGFloat {
        return self.frame.origin.y
    }
    
    var leading: CGFloat {
        return self.frame.origin.x
    }
    
    var trailing: CGFloat {
        return self.frame.origin.x + self.frame.size.width
    }
    
    var width: CGFloat {
        return self.frame.size.width
    }
    
    var height: CGFloat {
        return self.frame.size.height
    }
}

extension UITableView {
    
    override open var contentInset: UIEdgeInsets {
        
        set(newValue) {
        
            if self.isTracking {
                let difference = newValue.top - self.contentInset.top
                var translation = self.panGestureRecognizer.translation(in: self)
                translation.y -= difference*1.45
                self.panGestureRecognizer.setTranslation(translation, in: self)
            }
            super.contentInset = newValue
        }
        get {
            return super.contentInset
        }
    }
}

extension UIColor {
    
    public func fs_hexString() -> String {
        
        // Special case, as white doesn't fall into the RGB color space
        if (self == UIColor.white) {
            return "ffffff"
        }
        
        var red     : CGFloat = 0
        var blue    : CGFloat = 0
        var green   : CGFloat = 0
        var alpha   : CGFloat = 0
        
        self.getRed(&(red), green: &green, blue: &blue, alpha: &alpha)
        
        let hexString = NSString(format: "%02x%02x%02x", (Int(red*255)), (Int(green*255)), (Int(blue*255))) as String
        
        return hexString
    }
    
}

extension UISearchBar {
    
    var fs_backgroundColor : UIColor? {
        get {
            for subview in self.subviews[0].subviews {
                if let lImageView = subview as? UIImageView {
                    lImageView.clipsToBounds = true
                    if lImageView.subviews.count == 0 {
                        let view = lImageView.viewWithTag(100500)
                        return view?.backgroundColor
                    } else {
                        return lImageView.subviews[0].backgroundColor
                    }
                }
            }
            
            return nil
        }
        set {
            for subview in self.subviews[0].subviews {
                if let lImageView = subview as? UIImageView {
                    lImageView.clipsToBounds = true
                    if lImageView.subviews.count == 0 {
                        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 64))
                        view.backgroundColor = newValue
                        view.tag = 100500
                        lImageView.addSubview(view)
                    } else {
                        lImageView.subviews[0].backgroundColor = newValue
                    }
                }
            }
        }
    }
}

public enum FSConstraint {
    
    public static func Visual (
        _ format  : String,
        options : NSLayoutFormatOptions = NSLayoutFormatOptions(),
        metrics : [String : AnyObject]? = nil,
        views   : [String : AnyObject]) -> [NSLayoutConstraint]
    {
        let constraints = NSLayoutConstraint.constraints(withVisualFormat: format, options: options, metrics: metrics, views: views)
        return constraints
    }
    
    public static func Edges (_ view: UIView, edges: UIEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)) -> [NSLayoutConstraint] {
        
        let dict = ["view": view]
        let metrics = ["LEFT": edges.left, "TOP": edges.top, "RIGHT": edges.right, "BOTTOM": edges.bottom]
        
        var constraints:[NSLayoutConstraint] = []
        
        constraints += Visual("H:|-LEFT-[view]-RIGHT-|", options: [], metrics: metrics as [String : AnyObject]?, views: dict)
        constraints += Visual("V:|-TOP-[view]-BOTTOM-|", options: [], metrics: metrics as [String : AnyObject]?, views: dict)
        
        return constraints
    }
    
    public static func Size (_ view:UIView, size:CGSize) -> [NSLayoutConstraint] {
        let dict = ["view":view]
        let metrics = ["WIDTH":size.width, "HEIGHT":size.height]
        
        var constraints:[NSLayoutConstraint] = []
        
        constraints += Visual("H:[view(WIDTH)]", options: [], metrics: metrics as [String : AnyObject]?, views: dict)
        constraints += Visual("V:[view(HEIGHT)]", options: [], metrics: metrics as [String : AnyObject]?, views: dict)
        
        return constraints
    }
    
    public static func Center (_ view: UIView, centerOffset: CGPoint = CGPoint.zero) -> [NSLayoutConstraint] {
        return [
            NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: view.superview!, attribute: .centerX, multiplier: 1, constant: centerOffset.x),
            NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: view.superview!, attribute: .centerY, multiplier: 1, constant: centerOffset.y)
        ]
    }
    
    public static func CenterY (_ view: UIView, offset: CGFloat = 0) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: view.superview, attribute: .centerY, multiplier: 1, constant: offset)
    }
    
    public static func CenterX (_ view: UIView, offset: CGFloat = 0) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: view.superview, attribute: .centerX, multiplier: 1, constant: offset)
    }
    
    public static func ProportionalWidth (_ firstView: UIView, secondView: UIView, multipler: CGFloat, constant: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: firstView, attribute: .width, relatedBy: .equal, toItem: secondView, attribute: .width, multiplier: multipler, constant: constant)
    }
    
    public static func ProportionalHeight (_ firstView: UIView, secondView: UIView, multipler: CGFloat, constant: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: firstView, attribute: .height, relatedBy: .equal, toItem: secondView, attribute: .height, multiplier: multipler, constant: constant)
    }
    
    public static func ProportionalHeightToWidth (_ firstView: UIView, secondView: UIView, multipler: CGFloat, constant: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: firstView, attribute: .height, relatedBy: .equal, toItem: secondView, attribute: .width, multiplier: multipler, constant: constant)
    }
    
    public static func ProportionalWidthToHeight (_ firstView: UIView, secondView: UIView, multipler: CGFloat, constant: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: firstView, attribute: .width, relatedBy: .equal, toItem: secondView, attribute: .height, multiplier: multipler, constant: constant)
    }
    
}
