//
//  ARViewController.swift
//  HandGesturesClassifier
//
//  Created by Breno Marques on 28/09/25.
//

import ARKit

@available(iOS 14.0, *)
public class ARViewController: UIViewController, @MainActor ARSessionDelegate {
    
    public var arView: ARSCNView!
    public var cameraFrame: CGRect
    public var isCameraHidden: Bool
    
    private var frameCounter = 0
    private let handPosePredictionInterval = 30
    private let cameraManager = CameraManager()
    
    public var onGestureUpdate: ((String) -> Void)?
    
    public var gesture: String = "" {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                
                self.onGestureUpdate? (self.gesture)
            }
        }
    }
    
    
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
        
        switch handGesture {
        case .open:
            gesture = "aberta"
        case .closed:
            gesture = "fechada"
        case .background:
            gesture = "background"
        }
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
