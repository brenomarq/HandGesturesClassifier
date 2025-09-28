//
//  CameraManager.swift
//  Handy
//
//  Created by Breno Marques on 28/09/25.
//

import Foundation
import ARKit

public class CameraManager {
    
    public func checkCameraAccess(showView: @Sendable @escaping () -> Void) {
        switch (AVCaptureDevice.authorizationStatus(for: .video)) {
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { enabled in
                DispatchQueue.main.async {
                    if enabled {
                        showView()
                    } else {
                        print("Algum problema ocorreu.")
                    }
                }
            }
            
        case .restricted:
            print("Acesso restrito")
            
        case .denied:
            print("Acesso negado")
            
        case .authorized:
            print("Acesso autorizado")
            showView()
            
        @unknown default:
            print("Algum problema ocorreu")
        }
        
    }
    
}
