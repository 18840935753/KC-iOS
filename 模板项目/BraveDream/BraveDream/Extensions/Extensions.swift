//
//  Extensions.swift
//  Templete
//
//  Created by kang chao on 2017/4/5.
//  Copyright © 2017年 kang chao. All rights reserved.
//

import UIKit

extension UIImage
{
    func colorToImage(color: UIColor, alpha: CGFloat, width: CGFloat, height: CGFloat) -> UIImage
    {
        let drawRect = CGRect(x: 0, y: 0, w: width, h: height)
        UIGraphicsBeginImageContextWithOptions(drawRect.size, false, 1)
        color.setFill()
        UIRectFill(drawRect)
        draw(in: drawRect, blendMode: .color, alpha: alpha)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage!
    }
}
