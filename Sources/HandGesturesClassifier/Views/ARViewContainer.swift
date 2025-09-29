//
//  ARViewContainer.swift
//  HandGesturesClassifier
//
//  Created by Breno Marques on 28/09/25.
//

import SwiftUI

///`ARViewContainer` é o ponto de entrada do package para a sua aplicação SwiftUI.
///
/// `ARViewContainer` é um wrapper SwiftUI que integra um `ARViewController`
/// dentro de uma interface SwiftUI.
///
/// Ele permite que o estado da mão detectado pelo AR seja transmitido para
/// SwiftUI através do binding `gesture`, e controla a exibição da
/// visualização AR com o binding `isCameraHidden`. Além disso, ele controla
/// o tamanho e a posição da View pelo parâmetro `cameraFrame`.
///
/// ### Parameter:
/// - `isCameraHidden`: controla se a visualização AR deve ser exibida.
/// - `gesture`: recebe atualizações do estado da mão detectado pelo AR.
/// - `cameraFrame`: controla a posição e o tamanho da câmera.
///
/// ### Funcionalidades:
/// - `makeUIViewController`: cria e configura o `ARViewController`, incluindo
///   o callback `onHandStateChanged` para atualizar o binding `gesture`.
/// - `updateUIViewController`: mantém o binding `isCameraHidden` sincronizado
///   com o `ARViewController`.
///
/// ### Como implementar:
/// ```swift
///struct ContentView: View {
///    // Confere o gesto de mão atual
///    @State private var gesture: HandPoses = .background
///    // Controla a visibilidade da câmera
///    @State private var isCameraHidden: Bool = false
///
///    var body: some View {
///
///        ZStack {
///            ARViewContainer(
///                gesture: $gesture,
///                // Controla o tamanho e o posicionamento da câmera
///                cameraFrame: CGRect(x: 0, y: 0, width: 100, height: 100),
///                isCameraHidden: $isCameraHidden
///            )
///
///            VStack {
///                Text(gesture.rawValue)
///            }
///            .padding()
///        }
///
///    }
///}
/// ```
/// - Não da para finalizar a câmera depois que ela foi instanciada, não venha me perguntar nada sobre isso.
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
