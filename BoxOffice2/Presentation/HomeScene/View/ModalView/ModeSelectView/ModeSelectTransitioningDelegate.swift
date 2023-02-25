//
//  ModeSelectTransitioningDelegate.swift
//  BoxOffice2
//
//  Created by 이원빈 on 2023/02/24.
//

import UIKit

final class ModeSelectTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        return ModeSelectPresentationController(
            presentedViewController: presented,
            presenting: presenting
        )
    }
}
