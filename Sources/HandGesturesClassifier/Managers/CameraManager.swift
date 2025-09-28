//
//  CameraManager.swift
//  Handy
//
//  Created by Breno Marques on 28/09/25.
//

import Foundation
import ARKit

/**
 Classe responsável por gerenciar assuntos referentes à câmera
 do dispositivo e seu acesso.
 */
public class CameraManager {
    
    /**
     Confere se o aplicativo tem permissão para acessar a câmera do dispositivo.
     
     - Parameter showView: Executa uma função  caso o acesso à câmera seja garantido.
     
     - Examples:
     ```swift
     let cameraManager = CameraManager()
     
     cameraManager.checkCameraAcess {
        // Qualquer função void
     }
     ```
     */
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
