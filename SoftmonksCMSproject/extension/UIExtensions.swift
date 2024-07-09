//
//  UIExtensions.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 19/02/24.
//

import UIKit
// makin UIColor from hex values
extension UIColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            return nil
        }

        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: 1.0
        )
    }
}

extension UIViewController {
    
    func customAlert(alertTitle: String, alertDiscription: String) -> UIAlertController {
        let alertVC = UIAlertController(title: alertTitle, message: alertDiscription, preferredStyle: .alert)
        let indicatorView = UIActivityIndicatorView(frame: CGRect(x: 10, y: 15, width: 40, height: 40))
        indicatorView.hidesWhenStopped = true
        indicatorView.style = .large
        indicatorView.startAnimating()
        alertVC.view.addSubview(indicatorView)
        present(alertVC, animated: true)
        return alertVC
    }
    
    func dismissCutomAlert(loader: UIAlertController) {
        DispatchQueue.main.async {
            loader.dismiss(animated: true)
        }
    }
    
    public func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}


//toolbar function


//for gradiant view behind Designation
extension UIView {
    func setShadow(color: UIColor, opacity: Float, offset: CGSize, radius: CGFloat) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
//        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = false
    }
    
    func loadViewFromNib(nibName: String) -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }

    
    //checkInVC Bottom View
    func applyCornerRadiusAndBorder(radius: CGFloat, borderWidth: CGFloat, borderColor: String, shadowRadius: CGFloat, shadowOpacity: Float, shadowColor: String, shadowOffset: CGSize) {
            // Add corner radius
            
        let cornerRadius = min(bounds.width, bounds.height) * radius
        self.layer.cornerRadius = cornerRadius
            
            // Add border
            self.layer.borderWidth = borderWidth
        self.layer.borderColor = UIColor(hex: borderColor)?.cgColor
            self.layer.shadowRadius = shadowRadius
            self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowColor = UIColor(hex: shadowColor)?.cgColor
            self.layer.shadowOffset = shadowOffset
        }
    
    //for collectionView cells
    func addGradientBackground(firstColor: UIColor, secondColor: UIColor,angle: Double,conRads: CGFloat){
        clipsToBounds = true
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [firstColor.cgColor ,secondColor.cgColor ]
        gradientLayer.frame = self.bounds
        
        let radians = CGFloat(angle * Double.pi / 180.0)
        let endPoint = CGPoint(x: 0.5 + cos(radians) * 0.5, y: 0.5 + sin(radians) * 0.5)
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = endPoint
        print(gradientLayer.frame)
        self.layer.insertSublayer(gradientLayer, at: 0)
        let cornerRadius = min(bounds.width, bounds.height) * conRads
        layer.cornerRadius = cornerRadius
        
    }
    
    func onlyCornerRadius (conRadius: Double){
        layer.cornerRadius = conRadius
        layer.masksToBounds = true
    }
    
    func addElevatedShadow(to view: UIView, shadowColor: UIColor = UIColor.black, shadowOffset: CGSize = CGSize(width: 0, height: 2), shadowOpacity: Float = 0.2, shadowRadius: CGFloat = 4) {
        view.layer.masksToBounds = false
        view.layer.shadowColor = shadowColor.cgColor
        view.layer.shadowOffset = shadowOffset
        view.layer.shadowOpacity = shadowOpacity
        view.layer.shadowRadius = shadowRadius
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
    }
    
    
    //For designations Background
    public func applyGradient(colors: [String],angle: Double,conRads: CGFloat) {
        let colorshex = colors.map { UIColor(hex: $0) }
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colorshex.map { $0!.cgColor }
        gradientLayer.frame = bounds
        
        let radians = CGFloat(-135.0 * Double.pi / 180.0)
        let endPoint = CGPoint(x: 0.5 + cos(radians) * 0.5, y: 0.5 + sin(radians) * 0.5)
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = endPoint
        layer.insertSublayer(gradientLayer, at: 0)
        layer.cornerRadius = conRads
        layer.masksToBounds = true
    }
}



//to make text size as per screen
extension UILabel {
    func configureDynamicText(text: String) {
        self.text = text
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.5 // To Adjust minimun
        
        let screenWidth = UIScreen.main.bounds.width
        let fontSize = screenWidth / 20 // Adjust the divisor
        font = UIFont.systemFont(ofSize: fontSize)
    }
}


