//
//  variableTextsize.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 31/05/24.
//

import UIKit

func adjustFontSizeForDevice(textFields: [UITextField], labels: [UILabel]) {
        let scaleFactor: CGFloat
        if UIDevice.current.userInterfaceIdiom == .pad {
            scaleFactor = 1.5 // Example scale factor for iPad
        } else {
            scaleFactor = 1.0 // No scaling for iPhone
        }

        changeFontSize(for: textFields, scaleFactor: scaleFactor)
        changeFontSize(for: labels, scaleFactor: scaleFactor)
    }

func changeFontSize(for textElementArray: [UIView], scaleFactor: CGFloat) {
    for view in textElementArray {
        if let textField = view as? UITextField {
            textField.font = textField.font?.withSize(textField.font!.pointSize * scaleFactor)
        } else if let label = view as? UILabel {
            label.font = label.font?.withSize(label.font.pointSize * scaleFactor)
        }
    }
}
