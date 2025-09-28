//
//  ARViewContainer.swift
//  HandGesturesClassifier
//
//  Created by Breno Marques on 28/09/25.
//

import SwiftUI

/**
 Essa View é responsável tanto por mostrar a câmera em algum lugar da tela, quanto por gerenciar
 a variável que dita qual gesto de mão está sendo capturado pelo sensor.
 
 - Examples:
 
 ```swift
 struct ContentView: View {
     
     @State private var gesture: HandPoses = .background
     @State private var isCameraHidden: Bool = false
     
     var body: some View {
         
         ZStack {
             ARViewContainer(
                 gesture: $gesture,
                 cameraFrame: CGRect(x: 0, y: 0, width: 100, height: 100),
                 isCameraHidden: $isCameraHidden
             )
             
             VStack {
                 Text(gesture.rawValue)
             }
             .padding()
         }
         
     }
 }
 ```
 */
@available(iOS 14.0, *)
public struct ARViewContainer: UIViewControllerRepresentable {
    
    @Binding var gesture: HandPoses
    var cameraFrame: CGRect
    @Binding var isCameraHidden: Bool
    
    /**
        Inicialização de uma View do tipo ARViewContainer que conforma com o protocolo UIViewControllerRepresentable, ou seja, uma ViewController de UIKit feita para ser implementada em SwiftUI.
     
        - Parameter gesture: É um binding do tipo HandPoses (Enum) que identifica o gesto da mão.
     
        - Parameter cameraFrame: É um CGRect que determina a posição da visualização da câmera na tela e o seu tamanho.
     
        - Parameter isCameraHidden: É um binding do tipo booleano que indica se a câmera deve ser escondida ou não.
     */
    public init(gesture: Binding<HandPoses>, cameraFrame: CGRect, isCameraHidden: Binding<Bool>) {
        self._gesture = gesture
        self.cameraFrame = cameraFrame
        self._isCameraHidden = isCameraHidden
    }
    
    /**
        Não é necessário utilizar essa função.
     */
    public func makeUIViewController(context: Context) -> some UIViewController {
        let arViewController = ARViewController(cameraFrame: cameraFrame, isCameraHidden: isCameraHidden)
        
        arViewController.onGestureUpdate = { newValue in
            DispatchQueue.main.async {
                self.gesture = newValue
            }
        }
        
        return arViewController
    }
    
    /**
     Não é necessário utilizar essa função.
     */
    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        let viewController = uiViewController as? ARViewController
        
        if let viewController = viewController {
            viewController.arView.isHidden = isCameraHidden
            viewController.cameraFrame = cameraFrame
        }
    }
    
}
