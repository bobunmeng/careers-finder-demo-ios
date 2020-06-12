//
//  SplashController.swift
//  MyCareersFinder
//
//  Created by Bo Bunmeng on 1/6/19.
//  Copyright © 2019 Bo Bunmeng. All rights reserved.
//

import UIKit

class SplashController: BaseViewController {
    
    public var transitionType: TransitionType? = nil
    public var transitionValue: NotificationType? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            guard let auth = AuthDataStoreImpl().get(), !auth.accessToken.isEmpty else {
                self.present(LoginViewController.newInstance(), animated: true, completion: nil)
                return
            }
            Alert.shared.display(message: "Navigate to VC by Notification", on: self)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.transitionType = nil
    }

}
