//
//  ImageSaver.swift
//  HundreedWishes
//
//  Created by Александр Рахимов on 11.08.2023.
//

import Foundation
import UIKit

final class ImageSaver: NSObject {
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }

    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save finished!")
    }
}
