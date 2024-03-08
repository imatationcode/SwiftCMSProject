

//add the protocole beside UIViewController in class declaration and call addLogoToFooter func in viewdidLoad() in whichever Screen you want add the footer
import UIKit
protocol LogoDisplayable {
    func addLogoToFooter()
}

extension LogoDisplayable where Self: UIViewController {
    func addLogoToFooter() {
        let screenHeight = UIScreen.main.bounds.height
        let logoHeightPercentage: CGFloat = 0.15
        
        
        let logoHeight = screenHeight * logoHeightPercentage
        let logoWidth = logoHeight
        
        //assign logo
        let logoImageView = UIImageView(image: UIImage(named: "titleSoftmonks"))
        let BottomSpacing: CGFloat = 0.04
        
        logoImageView.frame = CGRect(
            x: (view.frame.size.width - logoWidth) / 2,
            y: view.frame.size.height - logoHeight + view.frame.size.height * BottomSpacing ,
            width: logoWidth,
            height: logoHeight
        )
        logoImageView.contentMode = .scaleAspectFit // Maintain the image's aspect ratio
        view.addSubview(logoImageView)
        
        
    }
}
