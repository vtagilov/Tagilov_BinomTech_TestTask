//
//  ViewController.swift
//  Tagilov_BinomTech_TestTask
//
//  Created by Владимир on 07.03.2024.
//

import UIKit
import MapboxMaps

final class MainViewController: UIViewController {
    private let standartZoom = 15.0
    private let animationDuration = 1.0
    
    private var cancelables = Set<AnyCancelable>()
    private var locationTrackingCancellation: AnyCancelable?

    private var mapView: MapView!
    private lazy var trackingButton = UIButton(frame: .zero)
    
    private let plusButton = UIButton(frame: .zero)
    private let minusButton = UIButton(frame: .zero)
    private let trackButton = UIButton(frame: .zero)

    internal lazy var userInfoView = UserInfoView(frame: .init(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 4))
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpTestData()
    }
    
    private func setUpTestData() {
        struct TestData {
            static let testModels: [UserModel] = [
                UserModel(name: "Илья", imageData: UIImage(named: "face1")!.pngData()!, lastSeenDate: Date(timeIntervalSince1970: 1609453292), observerMethod: .GPS),
                UserModel(name: "Антон", imageData: UIImage(named: "face2")!.pngData()!, lastSeenDate: Date(timeIntervalSince1970: 1609839592), observerMethod: .GPS),
                UserModel(name: "Катя", imageData: UIImage(named: "face3")!.pngData()!, lastSeenDate: Date(timeIntervalSince1970: 1610012392), observerMethod: .GPS),
                UserModel(name: "Дима", imageData: UIImage(named: "face4")!.pngData()!, lastSeenDate: Date(timeIntervalSince1970: 1610107992), observerMethod: .GPS),
                UserModel(name: "Гриша", imageData: UIImage(named: "face5")!.pngData()!, lastSeenDate: Date(timeIntervalSince1970: 1610199592), observerMethod: .GPS)
            ]
            static let testLocations: [CLLocationCoordinate2D] = [
                CLLocationCoordinate2D(latitude: 55.755428469337396, longitude: 37.62208446752445),
                CLLocationCoordinate2D(latitude: 55.76803821450676, longitude: 37.60546586720848),
                CLLocationCoordinate2D(latitude: 55.723338858477156, longitude: 37.63177074494767),
                CLLocationCoordinate2D(latitude: 55.70180488084075, longitude: 37.5791220522304),
                CLLocationCoordinate2D(latitude: 55.71821843420897, longitude: 37.551663782420775),
            ]
        }
        for i in 0 ..< TestData.testModels.count {
            addAnnotationToMap(model: TestData.testModels[i], location: TestData.testLocations[i])
        }
    }
    
    private func setUpUI() {
        userInfoView.delegate = self
        setupButtons()
        setUpMapView()
        configureConstraints()
    }
    
    private func setUpMapView() {
        let cameraOptions = CameraOptions(center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), zoom: standartZoom)
        let options = MapInitOptions(cameraOptions: cameraOptions, styleURI: .init(.standard))
        mapView = MapView(frame: view.bounds, mapInitOptions: options)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)
        mapView.location.options.puckType = .puck2D()
        mapView.location.options.puckBearingEnabled = true
        mapView.gestures.delegate = self
        startTracking()
    }

    private func setupButtons() {
        trackingButton.addTarget(self, action: #selector(switchTracking), for: .touchUpInside)
        trackingButton.setImage(UIImage(named: "LocationButton"), for: .normal)
        
        minusButton.addTarget(self, action: #selector(zoomAction), for: .touchUpInside)
        minusButton.setImage(UIImage(named: "MinusButton"), for: .normal)
        
        plusButton.addTarget(self, action: #selector(zoomAction), for: .touchUpInside)
        plusButton.setImage(UIImage(named: "PlusButton"), for: .normal)
    }
    
    func addAnnotationToMap(model: UserModel, location: CLLocationCoordinate2D) {
        let annotationView = CustomAnnotationView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        annotationView.onSelect = {
            self.userInfoView.isHidden = false
            self.userInfoView.configureView(model: model)
        }
        annotationView.configure(model: model)
        let annotation = ViewAnnotation(coordinate: location, view: annotationView)
        mapView.viewAnnotations.add(annotation)
    }

}

//  Map's functions
extension MainViewController: GestureManagerDelegate {
    private func startTracking() {
        locationTrackingCancellation = mapView.location.onLocationChange.observe { [weak mapView] newLocation in
            guard let location = newLocation.last, let mapView else { return }
            mapView.camera.ease(
                to: CameraOptions(center: location.coordinate, zoom: self.standartZoom),
                duration: self.animationDuration)
        }
        trackingButton.setImage(UIImage(named: "ActiveLocationButton"), for: .normal)
    }
    
    private func stopTracking() {
        trackingButton.setImage(UIImage(named: "LocationButton"), for: .normal)
        locationTrackingCancellation = nil
    }
    
    @objc func switchTracking() {
        let isTrackingNow = locationTrackingCancellation != nil
        if isTrackingNow {
            stopTracking()
        } else {
            startTracking()
        }
    }
    
    @objc private func zoomAction(_ sender: UIButton) {
        let isTrackingNow = locationTrackingCancellation != nil
        if isTrackingNow {
            stopTracking()
        }
        var newZoom = mapView.mapboxMap.cameraState.zoom
        if sender === plusButton {
            newZoom += 1
        } else if sender === minusButton {
            newZoom -= 1
        }
        let newCameraOptions = CameraOptions(zoom: newZoom)
        mapView.camera.ease(to: newCameraOptions, duration: 0.1)
    }
    
    func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didEnd gestureType: MapboxMaps.GestureType, willAnimate: Bool) {}
    public func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didBegin gestureType: MapboxMaps.GestureType) {
        stopTracking()
    }
    public func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didEndAnimatingFor gestureType: MapboxMaps.GestureType) {}
}

extension MainViewController {
    private func configureConstraints() {
        let buttonWidth = 64.0
        let verticalOffset = 8.0
        let userInfoViewHeight = 200.0
        for subview in [trackingButton, minusButton, plusButton, userInfoView, trackButton] {
            subview.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subview)
        }
        NSLayoutConstraint.activate([
            plusButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            plusButton.rightAnchor.constraint(equalTo: view.rightAnchor),
            plusButton.widthAnchor.constraint(equalTo: plusButton.heightAnchor),
            plusButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            
            minusButton.topAnchor.constraint(equalTo: plusButton.bottomAnchor, constant: verticalOffset),
            minusButton.rightAnchor.constraint(equalTo: view.rightAnchor),
            minusButton.widthAnchor.constraint(equalTo: minusButton.heightAnchor),
            minusButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            
            trackingButton.topAnchor.constraint(equalTo: minusButton.bottomAnchor, constant: verticalOffset),
            trackingButton.rightAnchor.constraint(equalTo: view.rightAnchor),
            trackingButton.widthAnchor.constraint(equalTo: trackingButton.heightAnchor),
            trackingButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            
            trackButton.topAnchor.constraint(equalTo: trackingButton.bottomAnchor, constant: verticalOffset),
            trackButton.rightAnchor.constraint(equalTo: view.rightAnchor),
            trackButton.widthAnchor.constraint(equalTo: trackButton.heightAnchor),
            trackButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            
            userInfoView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            userInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            userInfoView.heightAnchor.constraint(equalToConstant: userInfoViewHeight)
        ])
    }
}
