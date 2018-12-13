//
//  ADKActionController.swift
//  ADKActionSheet
//
//  Created by Work on 28/11/18.
//  Copyright © 2018 Work. All rights reserved.
//

import Foundation
import UIKit

fileprivate var isPresenting = false


open class ADKActionController : UIViewController {
    
    fileprivate var sections : [Action<ActionData>] = [Action<ActionData>]()
    
    public var scale: CGSize? = CGSize(width: 0.9, height: 0.9)
    
    lazy open var backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return backgroundView
    }()
    
    lazy open var collectionViewLayout: DynamicCollectionViewFlowLayout = { [unowned self] in
        let collectionViewLayout = DynamicCollectionViewFlowLayout()
        collectionViewLayout.useDynamicAnimator = false
        collectionViewLayout.minimumInteritemSpacing = 0.0
        collectionViewLayout.minimumLineSpacing = 0
        return collectionViewLayout
        }()
    
    
    lazy open var collectionView: UICollectionView = { [unowned self] in
        let collectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: self.collectionViewLayout)
        collectionView.alwaysBounceVertical = false
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .clear
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ADKActionController.tapGestureDidRecognize(_:)))
        collectionView.backgroundView = UIView(frame: collectionView.bounds)
        collectionView.backgroundView?.isUserInteractionEnabled = true
        collectionView.backgroundView?.addGestureRecognizer(tapRecognizer)
        collectionView.backgroundColor = UIColor.white
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(ADKActionController.swipeGestureDidRecognize(_:)))
        swipeGesture.direction = .down
        collectionView.addGestureRecognizer(swipeGesture)
        return collectionView
        }()
    
    // MARK: - View controller behavior
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ADKActionController.tapGestureDidRecognize(_:)))
        backgroundView.isUserInteractionEnabled = true
        backgroundView.addGestureRecognizer(tapRecognizer)
        
        view.addSubview(backgroundView)
        view.addSubview(collectionView)
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        backgroundView.frame = view.bounds
        
        //CollectionView
        collectionView.register(UINib(nibName: "ActionSheetCell", bundle: nil), forCellWithReuseIdentifier: "ActionSheetCell")
        collectionView.frame = view.bounds
        collectionView.frame.origin.y = (UIScreen.main.bounds.height - CGFloat((sections.count*60)))
        collectionViewLayout.footerReferenceSize = CGSize(width: 320, height: 0)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        transitioningDelegate = self
        modalPresentationStyle = .custom
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        transitioningDelegate = self
        modalPresentationStyle = .custom
    }
    
    // COMMENT: Function to add actions to the sheet
    open func addAction( action : Action<ActionData>) {
        
        sections.append(action)
    }
    
    
    @objc func tapGestureDidRecognize(_ gesture: UITapGestureRecognizer) {
        
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func swipeGestureDidRecognize(_ gesture: UISwipeGestureRecognizer) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}


extension ADKActionController : UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return sections.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActionSheetCell", for: indexPath) as! ActionSheetCell
        
        let sectionValue = sections[indexPath.row]
        
        cell.lblActionTitle.text = sectionValue.data?.title
        if let image = sectionValue.data?.image {
            
            cell.imgAction.image = image
            cell.leadingConstraintLblActionTitle.constant = 25
        }
        else {
            
            cell.leadingConstraintLblActionTitle.constant = -25
        }
        
        
        return cell
    }
}

extension ADKActionController : UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let section = sections[indexPath.row]
        
        self.dismiss(animated: true) {
            section.handler?(section)
        }
    }
    
    // COMMENT : To add highlight to cell when tapped
    open func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        
        UIView.animate(withDuration: 0.5) {
            
            let cell = collectionView.cellForItem(at: indexPath) as? ActionSheetCell
            cell!.contentView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        }
        return true
    }
    
    open func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        
        UIView.animate(withDuration: 0.5) {
            let cell = collectionView.cellForItem(at: indexPath) as? ActionSheetCell
            
            cell!.contentView.backgroundColor = .clear
        }
    }
}

extension ADKActionController : UICollectionViewDelegateFlowLayout {
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let referenceWidth = collectionView.bounds.size.width
        return CGSize(width: referenceWidth , height: 60)
    }
}


extension ADKActionController : UIViewControllerAnimatedTransitioning {
    
    open func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }
    
    open func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
}


extension ADKActionController : UIViewControllerTransitioningDelegate {
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return isPresenting ? 0 : TimeInterval(0.7)
    }
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let fromView = fromViewController.view
        
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let toView = toViewController.view
        
        if isPresenting {
            toView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            containerView.addSubview(toView!)
            
            transitionContext.completeTransition(true)
            presentView(toView!, presentingView: fromView!, animationDuration: TimeInterval(0.7), completion: nil)
        } else {
            dismissView(fromView!, presentingView: toView!, animationDuration: TimeInterval(0.7)) { completed in
                if completed {
                    fromView?.removeFromSuperview()
                }
                transitionContext.completeTransition(completed)
            }
        }
    }
    
    open func presentView(_ presentedView: UIView, presentingView: UIView, animationDuration: Double, completion: ((_ completed: Bool) -> Void)?) {
        onWillPresentView()
        UIView.animate(withDuration: animationDuration,
                       delay: TimeInterval(0.0),
                       usingSpringWithDamping: CGFloat(1.0),
                       initialSpringVelocity: CGFloat(0.0),
                       options: UIView.AnimationOptions.curveEaseOut.union(.allowUserInteraction),
                       animations: { [weak self] in
                        
                        presentingView.transform = .identity
                        self?.performCustomPresentationAnimation(presentedView, presentingView: presentingView)
            },
                       completion: { [weak self] finished in
                        self?.onDidPresentView()
                        completion?(finished)
        })
    }
    
    open func dismissView(_ presentedView: UIView, presentingView: UIView, animationDuration: Double, completion: ((_ completed: Bool) -> Void)?) {
        onWillDismissView()
        
        UIView.animate(withDuration: animationDuration,
                       delay: TimeInterval(0.0),
                       usingSpringWithDamping: CGFloat(1.0),
                       initialSpringVelocity: CGFloat(0.0),
                       options: UIView.AnimationOptions.curveEaseOut.union(.allowUserInteraction),
                       animations: { [weak self] in
                        if let _ = self?.scale {
                            presentingView.transform = CGAffineTransform.identity
                        }
                        self?.performCustomDismissingAnimation(presentedView, presentingView: presentingView)
            },
                       completion: { [weak self] _ in
                        self?.onDidDismissView()
                        completion?(true)
        })
    }
    
    open func onWillPresentView() {
        backgroundView.alpha = 0.0
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.layoutSubviews()
        // Override this to add custom behavior previous to start presenting view animated.
        // Tip: you could start a new animation from this method
    }
    
    open func performCustomPresentationAnimation(_ presentedView: UIView, presentingView: UIView) {
        backgroundView.alpha = 1.0
        collectionView.frame.origin.y = (UIScreen.main.bounds.height - CGFloat((sections.count*60)))
        // Override this to add custom animations. This method is performed within the presentation animation block
    }
    
    open func onDidPresentView() {
        // Override this to add custom behavior when the presentation animation block finished
    }
    
    open func onWillDismissView() {
        // Override this to add custom behavior previous to start dismissing view animated
        // Tip: you could start a new animation from this method
    }
    
    open func performCustomDismissingAnimation(_ presentedView: UIView, presentingView: UIView) {
        backgroundView.alpha = 0.0
        collectionView.frame.origin.y = UIScreen.main.bounds.height//contentHeight + (settings.cancelView.showCancel ? settings.cancelView.height : 0) + settings.animation.dismiss.offset
        // Override this to add custom animations. This method is performed within the presentation animation block
    }
    
    open func onDidDismissView() {
        // Override this to add custom behavior when the presentation animation block finished
    }
}
