//
//  IndicatorView.swift
//  GeekMobile
//
//  Created by Egor on 25.03.2021.
//

import UIKit

class IndicatorView: UIView {

    @IBOutlet weak var dot1: UIView!
    @IBOutlet weak var dot2: UIView!
    @IBOutlet weak var dot3: UIView!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dot1.layer.cornerRadius = 8
        dot2.layer.cornerRadius = 8
        dot3.layer.cornerRadius = 8
        
        UIView.animate(withDuration: 0.75, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.dot1.backgroundColor = .clear
        }, completion: nil)

        UIView.animate(withDuration: 0.75, delay: 0.25, options: [.repeat, .autoreverse], animations: {
            self.dot2.backgroundColor = .clear
        }, completion: nil)

        UIView.animate(withDuration: 0.75, delay: 0.5, options: [.repeat, .autoreverse], animations: {
            self.dot3.backgroundColor = .clear
        }, completion: nil)
    }

}
