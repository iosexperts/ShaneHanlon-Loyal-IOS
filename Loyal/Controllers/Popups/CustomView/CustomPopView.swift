//
//  CustomPopView.swift
//  Loyal
//
//  Created by user on 08/04/21.
//

import UIKit

class CustomPopView: UIView {
    // Our custom view from the XIB file
static let shared = CustomPopView()
    var view: UIView!
    var isMoveNextTapped : ((Bool) -> Void)?
    @IBOutlet weak var lblPhone: UILabel!
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        xibSetup()
//        self.view = loadViewFromNib() as! CustomView
    }
    
    @IBAction func BtnCancelAct(_ sender: UIButton) {
     //   print("BtnCancelAct")
        isMoveNextTapped?(false)
    }
    
    @IBAction func BtnSubmitAct(_ sender: UIButton) {
        //print("BtnSubmitAct")
        isMoveNextTapped?(true)
    }
    
    func SetupUI(phone:String)  {
        lblPhone.text = phone
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of:self))
        let nib = UINib(nibName: "CustomPopView", bundle: bundle)
        
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    

}
