//
//  BaseViewController.swift
//  Remote Habits Mobile App
//
//  Created by Amandeep Kaur on 25/11/21.
//

import UIKit

class RHBaseViewController: UIViewController {

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
    /*
    // MARK: - --NAVIGATION--

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
