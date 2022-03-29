//
//  NooberHelper.swift
//  Noober
//
//  Created by Abhishek Agarwal on 28/03/22.
//  Copyright © 2022 Noober. All rights reserved.
//

import Foundation
import UIKit

final class NoobHelper {

    private static var isPresented = false
    private static  var apiRequestVC: UINavigationController = {
        let vc = ApiRequestsTableViewController()
        vc.tabBarItem = .init(title: "API Calls", image: UIImage.apiUnselectedImage, selectedImage: UIImage.apiselectedImage)
        return UINavigationController(rootViewController: vc)
    }()

    private static  var userDefaultsVC: UINavigationController = {
        let vc = UserDefaultsViewController()
        vc.tabBarItem = .init(title: "User Defaults", image: UIImage.userDefaultUnselectedImage, selectedImage: UIImage.userDefaultselectedImage )
        return UINavigationController(rootViewController: vc)
    }()

    private static  var tabController: UITabBarController = {
        let tabController = UITabBarController()
        tabController.viewControllers = [apiRequestVC, userDefaultsVC]
        tabController.selectedViewController = apiRequestVC
        tabController.hidesBottomBarWhenPushed = true
        return tabController
    }()

    static var presentingViewController: UIViewController? {
       var rootViewController = UIApplication.shared.keyWindow?.rootViewController
       while let controller = rootViewController?.presentedViewController {
           rootViewController = controller
       }
       return rootViewController
   }

    static func toogle() {
        if !isPresented && Noob.shared.isStarted {
            presentingViewController?.present(tabController, animated: true, completion: {
                isPresented = true
            })
        } else {
            presentingViewController?.dismiss(animated: true, completion: {
                isPresented = false
            })
        }

    }

}
