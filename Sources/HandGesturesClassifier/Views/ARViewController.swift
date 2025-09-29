//
//  ARViewController.swift
//  HandGesturesClassifier
//
//  Created by Breno Marques on 28/09/25.
//

import ARKit

/**
 Classe responsável por gerenciar a View da câmera.
 
 - Warning: Não implementar essa classe diretamente em uma View do SwiftUI.
 */
@available(iOS 14.0, *)
public class ARViewController: UIViewController, @MainActor ARSessionDelegate {
    /**
     De preferência, não mexa nisso!!!!!!!!!!
     */
    public var arView: ARSCNView!
    
    /**
     Um CGRect que determina o posicionamento da câmera na tela do aplicativo e o seu tamanho.
     */
    public var cameraFrame: CGRect
    
    /**
     Um Bool que determina se a câmera deve ser escondida ou não.
     */
    public var isCameraHidden: Bool
    
    private var frameCounter = 0
    private let handPosePredictionInterval = 30
    private let cameraManager = CameraManager()
    
    /**
     Essa função é utilizada no Container para atualizar a variável gesture. Não acesse diretamente.
     */
    public var onGestureUpdate: ((HandPoses) -> Void)?
    
    /**
     Variável dinâmica que determina o gesto capturado pelo AR.
     */
    public var gesture: HandPoses = .background {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                
                self.onGestureUpdate? (self.gesture)
            }
        }
    }
    
    /**
     Inicialização da Classe ARViewController.
     
     - Parameter cameraFrame: Um CGRect que determina o posicionamento da câmera na tela do aplicativo e o seu tamanho.
     
     - Parameter isCameraHidden: Um Bool que determina se a câmera deve ser escondida ou não.
     */
    public init(cameraFrame: CGRect, isCameraHidden: Bool) {
        self.cameraFrame = cameraFrame
        self.isCameraHidden = isCameraHidden
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        cameraManager.checkCameraAccess { [weak self] in
            guard let self else { return }

            self.setupARView()
            
        }
        
    }
    
    
    private func setupARView() {
        arView = ARSCNView(frame: cameraFrame)
        arView.session.delegate = self
        view.addSubview(arView)
        
        let configuration = ARFaceTrackingConfiguration()
        arView.session.run(configuration)
    }
    
    
    private func updateGesture(name: String) {
        let handGesture = HandPoses(rawValue: name) ?? .background
        
        gesture = handGesture
    }
    
    
    public func session(_ session: ARSession, didUpdate frame: ARFrame) {
        frameCounter += 1
        let pixelBuffer = frame.capturedImage
        
        let handPoseRequest = VNDetectHumanHandPoseRequest()
        handPoseRequest.maximumHandCount = 1
        handPoseRequest.revision = VNDetectContourRequestRevision1
        
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        
        do {
            try handler.perform([handPoseRequest])
        } catch {
            assertionFailure("Human Pose Request failed: \(error.localizedDescription)")
        }
        
        guard let handPoses = handPoseRequest.results, !handPoses.isEmpty else {
            return
        }
        
        let handObservations = handPoses.first
        
        if frameCounter % handPosePredictionInterval == 0 {
            guard let keypointsMultiArray = try? handObservations!.keypointsMultiArray() else {
                fatalError("Failed to create key points array")
            }
            
            do {
                let config = MLModelConfiguration()
                config.computeUnits = .cpuAndGPU
                
                let model = try HandGestures.init(configuration: config)
                
                let handPosePrediction = try model.prediction(poses: keypointsMultiArray)
                
                print("handPosePrediction: \(handPosePrediction.label)")
                updateGesture(name: handPosePrediction.label)
            
            } catch let error {
                print("Failure HandyModel: \(error.localizedDescription)")
            }
            
        }
    }
    
}
