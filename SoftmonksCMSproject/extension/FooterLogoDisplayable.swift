

//add the protocole beside UIViewController in class declaration and call addLogoToFooter func in viewdidLoad() in whichever Screen you want add the footer
import UIKit
protocol LogoDisplayable {
    func addLogoToFooter()
}

extension LogoDisplayable where Self: UIViewController {
    func addLogoToFooter() {
        let logoImageView = UIImageView(image: UIImage(named: "titleSoftmonks"))
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.contentMode = .scaleAspectFit
        view.addSubview(logoImageView)
        let logoHeight: CGFloat
        if UIDevice.current.userInterfaceIdiom == .pad {
            logoHeight = 40
        } else {
            logoHeight = 25
        }
        NSLayoutConstraint.activate([
            logoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            logoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            logoImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: logoHeight)
        ])
    }
}
