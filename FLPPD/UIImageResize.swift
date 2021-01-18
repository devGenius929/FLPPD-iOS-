//
//  UIImageResize.swift
//  FLPPD
//
//  Created by Vlad Konon on 3/28/18.
//  Copyright © 2018 New Centuri Properties LLC. All rights reserved.
//

import UIKit

extension UIImage {
    
    func resizedImage(toSize size:CGSize) -> UIImage?
    {
        guard let imgRef = self.cgImage else {
            return nil
        }
        var dstSize = size
        // the below values are regardless of orientation : for UIImages from Camera, width>height (landscape)
        let srcSize = CGSize(width: imgRef.width, height: imgRef.height)
        
        /* Don't resize if we already meet the required destination size. */
        if (srcSize.equalTo(dstSize)) {
            return self;
        }
        
        let scaleRatio = dstSize.width / srcSize.width
        let orient = self.imageOrientation
        var transform = CGAffineTransform.identity
        switch(orient) {
            
        case .up: //EXIF = 1
            transform = CGAffineTransform.identity
        case .upMirrored: //EXIF = 2
            transform = CGAffineTransform(translationX: srcSize.width, y: 0.0)
            transform = transform.scaledBy(x: -1.0, y: 1.0)
        case .down: //EXIF = 3
            transform = CGAffineTransform(translationX: srcSize.width, y: srcSize.height)
            transform = transform.rotated(by: CGFloat.pi)
        case .downMirrored: //EXIF = 4
            transform = CGAffineTransform(translationX: 0.0, y: srcSize.height);
            transform = transform.scaledBy(x: 1.0, y: -1.0)
        case .leftMirrored: //EXIF = 5
            dstSize = CGSize(width:dstSize.height, height:dstSize.width)
            transform = CGAffineTransform(translationX: srcSize.height, y: srcSize.width);
            transform = transform.scaledBy(x: -1, y: 1)
            transform = transform.rotated(by:3.0 * (CGFloat.pi / 2.0))
        case .left: //EXIF = 6
            dstSize = CGSize(width:dstSize.height, height:dstSize.width)
            transform = CGAffineTransform(translationX: 0.0, y: srcSize.width)
            transform = transform.rotated(by: 3.0 * (CGFloat.pi / 2.0))
        case .rightMirrored: //EXIF = 7
            dstSize = CGSize(width:dstSize.height, height:dstSize.width)
            transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
        case .right: //EXIF = 8
            dstSize = CGSize(width:dstSize.height, height:dstSize.width)
            transform = CGAffineTransform(translationX: srcSize.height, y: 0.0);
            transform = transform.rotated(by: CGFloat.pi / 2.0)
        }
        
        /////////////////////////////////////////////////////////////////////////////
        // The actual resize: draw the image on a new context, applying a transform matrix
        UIGraphicsBeginImageContextWithOptions(dstSize, false, self.scale);
        
        guard let context = UIGraphicsGetCurrentContext() else  {
            return nil
        }
        if (orient == .right || orient == .left) {
            context.scaleBy(x: -scaleRatio, y: scaleRatio)
            context.translateBy(x: -srcSize.height, y: 0)
        } else {
            context.scaleBy(x: scaleRatio, y: -scaleRatio)
            context.translateBy(x: 0, y: -srcSize.height)
        }
        context.concatenate(transform);
        // we use srcSize (and not dstSize) as the size to specify is in user space (and we use the CTM to apply a scaleRatio)
        context.draw(imgRef, in: CGRect(x: 0, y: 0, width: srcSize.width, height: srcSize.height))
        let  resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage;
    }
    /////////////////////////////////////////////////////////////////////////////
    func resizedImage(toFitInSize size:CGSize, scaleIfSmaller scale:Bool) -> UIImage?
    {
        // get the image size (independant of imageOrientation)
        guard let imgRef = self.cgImage else {
            return nil
        }
        var boundingSize = size
        // the below values are regardless of orientation : for UIImages from Camera, width>height (landscape)
        let srcSize = CGSize(width: imgRef.width, height: imgRef.height)
        // adjust boundingSize to make it independant on imageOrientation too for farther computations
        let orient = self.imageOrientation
        switch (orient) {
        case .left, .right, .leftMirrored, .rightMirrored:
            boundingSize = CGSize(width:boundingSize.height, height:boundingSize.width)
        default:
            break
        }
        
        // Compute the target CGRect in order to keep aspect-ratio
        var dstSize = CGSize()
        
        if ( !scale && (srcSize.width < boundingSize.width) && (srcSize.height < boundingSize.height) ) {
            dstSize = srcSize; // no resize (we could directly return 'self' here, but we draw the image anyway to take image orientation into account)
        } else {
            let wRatio = boundingSize.width / srcSize.width
            let hRatio = boundingSize.height / srcSize.height
            
            if (wRatio < hRatio) {
                //NSLog(@"Width imposed, Height scaled ; ratio = %f",wRatio);
                dstSize = CGSize(width:boundingSize.width, height:CGFloat(floorf(Float(srcSize.height * wRatio))))
            } else {
                //NSLog(@"Height imposed, Width scaled ; ratio = %f",hRatio);
                dstSize = CGSize(width:CGFloat(floorf(Float(srcSize.width * hRatio))), height:boundingSize.height)
            }
        }
        
        return resizedImage(toSize: dstSize)
    }
    func croped(toRect rect:CGRect) -> UIImage?
    {
        
        guard let imgRef = self.cgImage else {
            return nil
        }
        var rectTransform = CGAffineTransform()
        switch (self.imageOrientation) {
        case .left:
            rectTransform = CGAffineTransform(rotationAngle: CGFloat.pi / 2).translatedBy(x: 0, y: -self.size.height)
        case .right:
            rectTransform = CGAffineTransform(rotationAngle: -(CGFloat.pi / 2)).translatedBy(x:  -self.size.width, y: 0)
        case .down:
            rectTransform = CGAffineTransform(rotationAngle: -CGFloat.pi).translatedBy(x: -self.size.width, y: -self.size.height)
        default:
            rectTransform = CGAffineTransform.identity
        };
        rectTransform = rectTransform.scaledBy(x: self.scale, y: self.scale)
        guard let imageRef = imgRef.cropping(to: rect.applying(rectTransform)) else {
            return nil
        }
        let result = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
        return result
    }
}
