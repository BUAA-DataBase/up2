//
//  ImageHelper.swift
//  up2
//
//  Created by 周子皓 on 2024/9/27.
//

import Foundation
import Foundation
import UIKit

func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
    let size = image.size

    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height

    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if widthRatio > heightRatio {
        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
        newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
    }

    // This is the rect that we've calculated out and this is what is actually used below
    let rect = CGRect(origin: .zero, size: newSize)

    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return newImage!
}

func convertImageToBase64String(img: UIImage, targetSize: CGSize? = nil) -> String? {
    var resizedImage: UIImage
    if targetSize != nil {
        resizedImage = resizeImage(image: img, targetSize: targetSize!)
    } else {
        resizedImage = img
    }
    guard let imageData = resizedImage.jpegData(compressionQuality: 1.0) else {
        return nil
    }
    return imageData.base64EncodedString(options: .lineLength64Characters)
}
