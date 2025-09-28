//
//  ARViewContainer.swift
//  HandGesturesClassifier
//
//  Created by Breno Marques on 28/09/25.
//

import SwiftUI

@available(iOS 14.0, *)
public struct ARViewContainer: UIViewControllerRepresentable {
    
    @Binding var gesture: String
    var cameraFrame: CGRect
    @Binding var isCameraHidden: Bool
    
    
    public init(gesture: Binding<String>, cameraFrame: CGRect, isCameraHidden: Binding<Bool>) {
        self._gesture = gesture
        self.cameraFrame = cameraFrame
        self._isCameraHidden = isCameraHidden
    }
    
    
    public func makeUIViewController(context: Context) -> some UIViewController {
        let arViewController = ARViewController(cameraFrame: cameraFrame, isCameraHidden: isCameraHidden)
        
        arViewController.onGestureUpdate = { newValue in
            DispatchQueue.main.async {
                self.gesture = newValue
            }
        }
        
        return arViewController
    }
    
    
    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        let viewController = uiViewController as? ARViewController
        
        viewController?.arView.isHidden = isCameraHidden
        viewController?.cameraFrame = cameraFrame
    }
    
}
