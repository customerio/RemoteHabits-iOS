//
//  BaseViewController.swift
//  Remote Habits Mobile App
//
//  Created by Amandeep Kaur on 25/11/21.
//

import UIKit

class RHBaseViewController: UIViewController {

    var loaderView : UIView?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Common Methods
    func addDefaultBackground() {
        self.view.backgroundColor = RHColor.DefaultBackground
    }
    
    func addLoginBackground() {
        let imageBg = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        imageBg.image = UIImage(named: RHConstants.kBackground)
        self.view.addSubview(imageBg)
        self.view.sendSubviewToBack(imageBg)
    }
    
    @objc func goBack() {
        self.dismiss(animated: true, completion: nil)
    }

    
    private func addLoader() {
        loaderView = UIView()
        loaderView?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height) // Set X and Y whatever you want
        loaderView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        
        let miniSpace = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        miniSpace.center = self.view.center
        miniSpace.layer.cornerRadius = 40
        
        // add image for loader background
        let imageBg = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        imageBg.image = UIImage(named: RHConstants.kBackground)
        imageBg.layer.cornerRadius = 40
        imageBg.layer.masksToBounds = true
        
        
        // add shadow
        miniSpace.layer.shadowColor = UIColor.gray.cgColor
        miniSpace.layer.shadowOpacity = 0.3
        miniSpace.layer.shadowOffset = CGSize.zero
        miniSpace.layer.shadowRadius = 6
        
        miniSpace.addSubview(imageBg)
        miniSpace.rotate()
        
        let activityView = UIActivityIndicatorView(style: .large)
        activityView.center = CGPoint(x: 40, y: 40)
        miniSpace.addSubview(activityView)
        loaderView?.addSubview(miniSpace)
        self.view.addSubview(loaderView!)
        activityView.startAnimating()
    }
    
    func configureNavigationBar(titleColor: UIColor = .black, backgoundColor: UIColor = .white, title: String, hideBack : Bool, showLogo : Bool = false) {

        if hideBack {
            self.navigationItem.setHidesBackButton(hideBack, animated: true)
        }
        else {
            let btnLeftOnBar: UIButton = UIButton()
            btnLeftOnBar.setImage(UIImage(named: RHConstants.kBack), for: .normal)
            btnLeftOnBar.addTarget(self, action: #selector(self.goBack), for: .touchUpInside)
            btnLeftOnBar.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            let barButton = UIBarButtonItem(customView: btnLeftOnBar)
            self.navigationItem.leftBarButtonItem = barButton

        }
        if showLogo {
            
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
            let imageView = UIImageView(frame: CGRect(x: headerView.center.x - 24, y: 0, width: 24, height: 24))
            imageView.contentMode = .scaleAspectFit
            let image = UIImage(named: RHConstants.kLogo)
            imageView.image = image
            headerView.addSubview(imageView)
            navigationItem.titleView = headerView
        }
        
        // Change background color of the navigation bar
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: titleColor]
            navBarAppearance.backgroundColor = backgoundColor
            
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.compactAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
            
            navigationController?.navigationBar.prefersLargeTitles = false
            navigationController?.navigationBar.isTranslucent = false
            navigationItem.title = title
            
        } else {
            // Important - This is fallback on earlier versions
            navigationController?.navigationBar.barTintColor = backgoundColor
            navigationController?.navigationBar.isTranslucent = false
            navigationItem.title = title
        }
    }
    
    func showLoader() {
        addLoader()
    }
    
    func hideLoader() {
        loaderView?.removeFromSuperview()
    }

    /*
    // MARK: - --NAVIGATION--

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIView{
    func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 2
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
}
