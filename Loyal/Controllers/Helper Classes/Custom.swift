//Button=============================================

import Foundation
import UIKit

@IBDesignable
class ButtonCustom: UIButton {
    let gradientLayer = CAGradientLayer()
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
            }
        }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
            }
        }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
            
        }
    }
   @IBInspectable
    var topGradientColor: UIColor? {
        didSet {
            setGradient(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor)
        }
    }
    
    @IBInspectable
    var bottomGradientColor: UIColor? {
        didSet {
            setGradient(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor)
        }
    }
    
    private func setGradient(topGradientColor: UIColor?, bottomGradientColor: UIColor?) {
        if let topGradientColor = topGradientColor, let bottomGradientColor = bottomGradientColor {
            gradientLayer.frame = bounds
            gradientLayer.colors = [topGradientColor.cgColor, bottomGradientColor.cgColor]
            gradientLayer.borderColor = layer.borderColor
            gradientLayer.borderWidth = layer.borderWidth
            gradientLayer.cornerRadius = layer.cornerRadius
            layer.insertSublayer(gradientLayer, at: 0)
        } else {
            gradientLayer.removeFromSuperlayer()
        }
    }
    
}

//Image=============================================


import UIKit

@IBDesignable
class ImageCustom: UIImageView {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = cornerRadius > 0
    }
}
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
        layer.borderWidth = borderWidth
    }
        
    }
    
    @IBInspectable var isRound: Bool = false {
        didSet {
            if isRound {
                layer.cornerRadius = self.frame.height/2
                layer.masksToBounds = true
            }
        }
    }
    
    @IBInspectable var zIndex: CGFloat = 0 {
        didSet {
            layer.zPosition = zIndex
        }
    }

    @IBInspectable var borderColor: UIColor? {
        didSet {
        layer.borderColor = borderColor?.cgColor
        }
    }
}

//Label=============================================

import Foundation
import UIKit

@IBDesignable
class LabelCustom: UILabel {
    
    @IBInspectable var rotation: Int {
            get {
                return 0
            } set {
                let radians = CGFloat(CGFloat(Double.pi) * CGFloat(newValue) / CGFloat(180.0))
                self.transform = CGAffineTransform(rotationAngle: radians)
            }
        }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        
        didSet {
            
            layer.borderColor = borderColor?.cgColor
           
        }
    }
    
    
    @IBInspectable var isRound: Bool = false {
        didSet {
            
            if(isRound){
                 
                layer.cornerRadius = self.frame.height/2
                
                layer.masksToBounds = true
                
            }
            
        }
        
    }
    
    
    
    
    
}







//txtField=============================================



import UIKit

@IBDesignable

class TextFieldCustom: UITextField {
    
    
    
    var bottomBorderSelectedColor:UIColor? = UIColor.white
    
    
    
    var padding: UIEdgeInsets {
        
        get {
            
            return UIEdgeInsets(top: 0, left: paddingValue, bottom: 0, right: paddingValue)
           
            
        }
        
    }
    
    
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        
        return bounds.inset(by: padding)
        
        
    }
    
    
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        
        return bounds.inset(by: padding)
        
    }
    
    
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
      
        return bounds.inset(by: padding)
        
    }
    
    
    
    @IBInspectable var editable: Bool = true{
        
        didSet {
            
            self.editable = false
            
        }
        
    }
    
    
    
    @IBInspectable var placeHolderColor:UIColor = .black{
        
        
        
        didSet{
            
            
self.attributedPlaceholder = NSAttributedString(string: self.placeholder!,
                                                            
                                                            attributes: [NSAttributedString.Key.foregroundColor: placeHolderColor])
            
        }
        
        
        
    }
    
    
    
    
    
    
    
    @IBInspectable var paddingValue: CGFloat = 0
    
    
    
    @IBInspectable var bottomValue: CGFloat = 0{
        
        
        
        didSet {
            
            let border = CALayer()
            
            let width = bottomValue
            
            border.borderColor = bottomBorderSelectedColor?.cgColor
            
            border.frame = CGRect(x: 0, y: self.frame.height - width, width:  self.frame.width, height: self.frame.size.height)
            
            
            
            border.borderWidth = width
            
            self.layer.addSublayer(border)
            
            self.layer.masksToBounds = true
            
        }
        
    }
    
    
    
    @IBInspectable var bottomColor: UIColor? = UIColor.white {
        
        didSet {
            
            bottomBorderSelectedColor = self.bottomColor
            
        }
        
    }
    
    
    
    
    
    @IBInspectable var borderColor: UIColor? = UIColor.clear {
        
        didSet {
            
            layer.borderColor = self.borderColor?.cgColor
            
        }
        
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        
        didSet {
            
            layer.borderWidth = self.borderWidth
            
        }
        
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        
        didSet {
            
            layer.cornerRadius = self.cornerRadius
            
            layer.masksToBounds = self.cornerRadius > 0
            
        }
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
    }
    
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
    }
    
    
    
    override func draw(_ rect: CGRect) {
        
        self.layer.cornerRadius = self.cornerRadius
        
        self.layer.borderWidth = self.borderWidth
        
        self.layer.borderColor = self.borderColor?.cgColor
        
    }
    
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 0
    
    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        if let image = leftImage {
            leftViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            imageView.tintColor = color
            leftView = imageView
        } else {
            leftViewMode = UITextField.ViewMode.always
            leftView = nil
        }
        
        // Placeholder text color
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: color])
    }
    
}





//View=============================================



import UIKit



@IBDesignable

class ViewCustom: UIView {
    
    
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        
        didSet {
            
            layer.cornerRadius = cornerRadius
            
            layer.masksToBounds = cornerRadius > 0
            
        }
        
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        
        didSet {
            
            layer.borderWidth = borderWidth
            
        }
        
    }
    
    @IBInspectable var borderColor: UIColor? {
        
        didSet {
            
            layer.borderColor = borderColor?.cgColor
            
        }
        
    }
    
    
    
    @IBInspectable var shadowWidth:CGFloat = 0{
        
        
        
        didSet {
            
            layer.shadowColor = shadowColor.cgColor
            
            layer.shadowOffset = CGSize(width: shadowWidth, height: shadowHeight)
            
            layer.shadowOpacity = shadowOpacity
            
            layer.masksToBounds = false
            
            layer.shadowRadius = shadowRadius
            
        }
        
        
        
    }
    
    @IBInspectable var shadowHeight:CGFloat = 0{
        
        
        
        didSet {
            
            layer.shadowColor = shadowColor.cgColor
            
            layer.shadowOffset = CGSize(width: shadowWidth, height: shadowHeight)
            
            layer.shadowOpacity = shadowOpacity
            
            layer.masksToBounds = false
            
            layer.shadowRadius = shadowRadius
            
        }
        
    }
    
    @IBInspectable var shadowOpacity:Float = 0.0{
        
        
        
        didSet {
            
            layer.shadowColor = shadowColor.cgColor
            
            layer.shadowOffset = CGSize(width: shadowWidth, height: shadowHeight)
            
            layer.shadowOpacity = shadowOpacity
            
            layer.masksToBounds = false
            
            layer.shadowRadius = shadowRadius
            
        }
        
    }
    
    @IBInspectable var shadowColor:UIColor = UIColor.clear{
        
        didSet {
            
            layer.shadowColor = shadowColor.cgColor
            
            layer.shadowOffset = CGSize(width: shadowWidth, height: shadowHeight)
            
            layer.shadowOpacity = shadowOpacity
            
            layer.masksToBounds = false
            
            layer.shadowRadius = shadowRadius
            
        }
        
        
        
    }
    
    
    
    @IBInspectable var shadowRadius:CGFloat = 0.0{
        
        didSet {
            
            layer.shadowColor = shadowColor.cgColor
            
            layer.shadowOffset = CGSize(width: shadowWidth, height: shadowHeight)
            
            layer.shadowOpacity = shadowOpacity
            
            layer.masksToBounds = false
            
            layer.shadowRadius = shadowRadius
            
        }
        
        
        
    }
    
    
    
    @IBInspectable var isRound: Bool = false {
        
        didSet {
            
            if(isRound){
                
                
                
                layer.cornerRadius = self.frame.height/2
                
                layer.masksToBounds = true
                
            }
            
        }
        
    }
    
    
    @IBInspectable var startColor: UIColor = .clear {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var middleColor: UIColor = .clear {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var endColor: UIColor = .clear {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowX: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowY: CGFloat = -3 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowBlur: CGFloat = 3 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var startPointX: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var startPointY: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var endPointX: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var endPointY: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowGradientColor: UIColor = .clear {
        didSet {
            setNeedsLayout()
        }
    }
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.colors = [startColor.cgColor, middleColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: startPointX, y: startPointY)
        gradientLayer.endPoint = CGPoint(x: endPointX, y: endPointY)
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = CGSize(width: shadowX, height: shadowY)
        layer.shadowRadius = shadowBlur
        layer.shadowOpacity = 1
    }
    
    
}

class CustomSlider: UISlider {
    @IBInspectable var trackHeight: CGFloat = 2
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(origin: bounds.origin, size: CGSize(width: bounds.width, height: trackHeight))
    }
}









@IBDesignable
class ShadowView: UIView {
    @IBInspectable var shadowColor: UIColor?{
        set {
            guard let uiColor = newValue else { return }
            layer.shadowColor = uiColor.cgColor
        }
        get{
            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
    }

    @IBInspectable var shadowOpacity: Float{
        set {
            layer.shadowOpacity = newValue
        }
        get{
            return layer.shadowOpacity
        }
    }

    @IBInspectable var shadowOffset: CGSize{
        set {
            layer.shadowOffset = newValue
        }
        get{
            return layer.shadowOffset
        }
    }

    @IBInspectable var shadowRadius: CGFloat{
        set {
            layer.shadowRadius = newValue
        }
        get{
            return layer.shadowRadius
        }
    }
    
    
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        
        didSet {
            
            layer.cornerRadius = cornerRadius
            
            layer.masksToBounds = cornerRadius > 0
            
        }
        
    }
    
    
    
  /*
    private var shadowLayer: CAShapeLayer!

        override func layoutSubviews() {
            super.layoutSubviews()

            if shadowLayer == nil {
                shadowLayer = CAShapeLayer()
                shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 12).cgPath
                shadowLayer.fillColor = UIColor.white.cgColor

                shadowLayer.shadowColor = UIColor.darkGray.cgColor
                shadowLayer.shadowPath = shadowLayer.path
                shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
                shadowLayer.shadowOpacity = 0.8
                shadowLayer.shadowRadius = 2

                layer.insertSublayer(shadowLayer, at: 0)
                //layer.insertSublayer(shadowLayer, below: nil) // also works
            }
        }
    */
    
}
