//
//  ActorListTransitioningDelegate.swift
//  BoxOffice2
//
//  Created by 이원빈 on 2023/02/25.
//

import UIKit

final class ActorListTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        return ActorListPresentationController(
            presentedViewController: presented,
            presenting: presenting
        )
    }
}
