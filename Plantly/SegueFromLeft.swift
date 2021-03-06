//
//  SegueFromLeft.swift
//  Plantly
//
//  Created by Chloe Yan on 4/12/20.
//  Copyright © 2020 Chloe Yan. All rights reserved.
//

import UIKit

class SegueFromLeft: UIStoryboardSegue {
    
    override func perform() {
        let src = self.source
        let dst = self.destination

        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
        src.view.transform = CGAffineTransform(translationX: -src.view.frame.size.width, y: 0)
        dst.modalPresentationStyle = .fullScreen

        UIView.animate(withDuration: 0.25,
                              delay: 0.0,
                            options: .curveEaseInOut,
                         animations: {
                                dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
                                },
                        completion: { finished in
                                src.present(dst, animated: false, completion: nil)
                                    }
                        )
    }
    
}
