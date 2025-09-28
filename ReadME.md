# HandGestures Classifiers

## Instalação

Para instalar esse pacote, baixe como uma dependência pelo link `https://github.com/brenomarq/HandGesturesClassifier`.

## Exemplos de implementação

Para implementar em SwiftUI, siga esse modelo

```swift
struct ContentView: View {
    
    @State private var gesture: String = ""
    @State private var isCameraHidden: Bool = false
    
    var body: some View {
        
        VStack {
            ARViewContainer(
                gesture: $gesture,
                cameraFrame: CGRect(x: 0, y: 0, width: 100, height: 100),
                isCameraHidden: $isCameraHidden
            )
        }
        .padding()
        
    }
}
```
