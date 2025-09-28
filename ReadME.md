# HandGestures Classifiers

## Objetivo

Esse pacote possui um modelo de ML treinado para detectar se a mão está 
aberta ou fechada. Além disso, ele contém uma View que pode ser utilizada
para mostrar a câmera em tempo real e verificar qual gesto de mão
foi capturado.

## Instalação

Para instalar esse pacote com o SPM, baixe como uma dependência pelo link `https://github.com/brenomarq/HandGesturesClassifier`.

## Exemplos de implementação

Para implementar a View em SwiftUI, siga esse exemplo:

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
        }
        .padding()
        
    }
}
```
