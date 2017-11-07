//
//  NRTabView.swift
//  NRTabView
//
//  Created by nabinrai on 11/2/17.
//  Copyright © 2017 nabin. All rights reserved.
//

import UIKit

//MARK:-
//MARK:- Circular Button
//MARK:-

public var minimumScale: CGFloat = 1.3
public var pressSpringDamping: CGFloat = 0.4
public var pressSpringDuration = 0.4

enum ButtonShape{
    case circle,square
}

extension UIView {
    //MARK:- Animaitons
    open func buttonZoomIn(){
        // print("zooom in")
        UIView.animate(withDuration: pressSpringDuration, delay: 0, usingSpringWithDamping: pressSpringDamping, initialSpringVelocity: 1, options: [.curveLinear, .allowUserInteraction], animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: minimumScale, y: minimumScale)
        }, completion: nil)
    }
    
    
    
    open func buttonZoomOut(){
        // print("zooom out")
        UIView.animate(withDuration: pressSpringDuration, delay: 0, usingSpringWithDamping: pressSpringDamping, initialSpringVelocity: 1, options: [.curveLinear, .allowUserInteraction], animations: { () -> Void in
            self.transform = .identity
        }, completion: nil)
    }

}


//MARK:-
//MARK:-
//MARK:-

//MARK:- NRTabViewDelegate
protocol NRTabViewDelegate : class{
    func didSelect(_ button:UIButton, ofIndex index:Int)
    
}



//MARK:-
//MARK:- NRTabView
//MARK:-

///A custom segment control that has elegent bubble animaiton on selection and deleseciton.
class NRTabView: UIControl {
    
    ///Delegate
    weak var delegate:NRTabViewDelegate?
    var buttonShape: ButtonShape = .circle
   
    ///
    ///Default:- 0    Default selection button
    var currentIndex:Int = 0 {
        didSet {
            self.makeDefaultSelection(defaultSelection: currentIndex)
        }
    }
    
    var buttons: [UIButton] = []
    
    /// Default number of bottons is 7
    var numberOfButtons: Int = 7{
        didSet{
            print(numberOfButtons)
            removeButonsFromStack()
            populateButtons()
        }
    }
    
    //MARK: manage colors
    @IBInspectable var selectedTitleColor:UIColor = .white {
        didSet {
            self.updateColor()
        }
    }
    
    @IBInspectable var titleColor:UIColor = .white {
        didSet {
            self.updateColor()
        }
    }
    
    @IBInspectable var selectedBubbleColor:UIColor = .purple {
        didSet {
            self.updateColor()
        }
    }
    
    @IBInspectable var buttonsColor: UIColor = .gray {
        didSet{
            self.updateColor()
        }
    }
    
//    var buttonsColors: [UIColor]?{
//        didSet {
//            self.updateColor()
//        }
//    }
    
    private func updateColor() {
        UIView.animate(withDuration: 0.3) {
            
            for bubbleView in self.stackView.arrangedSubviews{
                for  button in bubbleView.subviews {
                    if button.isKind(of: UIButton.self){
                        
                        button.backgroundColor = button.tag == self.currentIndex ? self.selectedBubbleColor : self.buttonsColor
                        
                        for subView in button.subviews {
                            if subView.isKind(of: UILabel.self) {
                                (subView as! UILabel).textColor = bubbleView.tag == self.currentIndex ? self.selectedTitleColor : self.titleColor
                            }
                        }
                    }
                }
            }
        }
    }
    
   
    
    //MARK:- init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.defaultSetting()
        self.addViews()
        self.getButtonCircle()
        self.updateColor()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder:coder)
        
        self.defaultSetting()
        self.addViews()
        self.updateColor()
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        switch buttonShape {
        case .circle:
            self.getButtonCircle()
        default:
            break
        }
        self.makeDefaultSelection(defaultSelection: self.currentIndex)

    }

    //MARK:- button selection
    @objc func handleClicked(sender: UIButton){
        //  print("tapped")
        self.currentIndex = sender.tag
        self.updateColor()
        
        self.sendActions(for: .touchUpInside)
        
        if let delegate = self.delegate {
            delegate.didSelect(sender, ofIndex: currentIndex)
        }
    }
    
    //MARK:- methods
    private func getViewWithButton(title: String, buttonTag: Int) -> UIView{
        
        let baseView = UIView()
        baseView.backgroundColor = .clear
        baseView.tag = buttonTag
        
        let button = UIButton()
        button.addTarget(self, action:#selector(handleClicked(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        //if buttonTag == 1{button.isSelected = true }else{button.isSelected = false}
        button.tag = buttonTag
        button.backgroundColor = self.buttonsColor
        buttons.append(button)
        
        let titleLbl = UILabel()
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        titleLbl.textAlignment = .center
        titleLbl.baselineAdjustment = .alignCenters
        titleLbl.numberOfLines = 0
        titleLbl.text = "\(title)"
        //titleLbl.textFont = 3
        
        button.addSubview(titleLbl)
        
        titleLbl.heightAnchor.constraint(equalTo: button.widthAnchor, multiplier: 0.95).isActive = true
        titleLbl.widthAnchor.constraint(equalTo: button.widthAnchor, multiplier: 0.95).isActive = true
        titleLbl.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        titleLbl.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
        
        baseView.addSubview(button)
        
        button.centerYAnchor.constraint(equalTo: baseView.centerYAnchor).isActive = true
        button.centerXAnchor.constraint(equalTo: baseView.centerXAnchor).isActive = true
        button.heightAnchor.constraint(equalTo: baseView.widthAnchor, multiplier: 0.8).isActive = true
        button.widthAnchor.constraint(equalTo: baseView.widthAnchor, multiplier: 0.8).isActive = true
        
        return baseView
        
    }
    
    private func getButtonCircle(){
        stackView.layoutIfNeeded()
        for v in stackView.arrangedSubviews{
            for  b in v.subviews {
                if b.isKind(of: UIButton.self){
                    b.layer.cornerRadius = b.frame.width/2
                    b.clipsToBounds = true
                }
            }
        }
    }
    
    func makeDefaultSelection(defaultSelection: Int){
        stackView.layoutSubviews()
        for v in stackView.arrangedSubviews{
            for  bTag in 0...v.subviews.count-1 {
                if let b = v.subviews[bTag] as? UIButton{
                    switch b.tag{
                    case defaultSelection:
                        b.buttonZoomIn()
                    default:
                        b.buttonZoomOut()
                    }
                }
            }
        }
    }
    
    lazy var stackView: UIStackView = {
        let s = UIStackView()
        s.axis = .horizontal
        s.distribution = .fillEqually
        s.alignment = .fill
        s.spacing = 0
        return s
    }()
    
    private func removeButonsFromStack(){
        for bubbleView in self.stackView.arrangedSubviews{
            bubbleView.removeFromSuperview()
        }
    }
    
    private func populateButtons() {
        for buttonIndex in 0...numberOfButtons-1{
            let v = getViewWithButton(title: "\(buttonIndex + 1)", buttonTag: buttonIndex)
            print(buttonIndex)
            self.stackView.addArrangedSubview(v)
        }
    }
    
    private func addViews(){
        
        self.populateButtons()
        
        self.addSubview(stackView)
        //managing constraints
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        self.stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        
    }
    
    
    private func setTitles(){
        for v in stackView.arrangedSubviews{
            for  b in v.subviews {
                if b.isKind(of: UIButton.self){
                    for lbl in b.subviews{
                        if 
                    
                    }
                }
            }
        }
        
    }
    
    private func defaultSetting(){
        self.backgroundColor = .clear
    }
    
}
