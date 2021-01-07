//
//  MyUniverseVC.swift
//  Milkyway
//
//  Created by 이윤진 on 2020/12/30.
//

import UIKit
import NMapsMap

class MyUniverseVC: UIViewController{
    @IBOutlet weak var mapView: NMFMapView!
    
    let unselectImage = NMFOverlayImage(name: "smallNoLike")
    let selectImage = NMFOverlayImage(name: "bigNoLike")
    var markers = [NMFMarker]()
    var camera: NMFCameraUpdate!
    var beforeMarker: NMFMarker?
    var placeMangWon = NMGLatLng(lat: 37.555941, lng: 126.910067)
    
    
    // 소영이는 망원 좌표 수집중 ... ㅇ0ㅇ
    var mangWon: [NMGLatLng] = [NMGLatLng(lat: 37.556635, lng: 126.908433),
                                NMGLatLng(lat: 37.556987, lng: 126.907755),
                                NMGLatLng(lat: 37.556748, lng: 126.910195),
                                NMGLatLng(lat: 37.555522, lng: 126.904833),
                                NMGLatLng(lat: 37.557539, lng: 126.904790),
                                NMGLatLng(lat: 37.556534, lng: 126.907744),
                                NMGLatLng(lat: 37.560183, lng: 126.909584),
                                NMGLatLng(lat: 37.560889, lng: 126.906703),
                                NMGLatLng(lat: 37.561905, lng: 126.903533),
                                NMGLatLng(lat: 37.560668, lng: 126.901677),
                                NMGLatLng(lat: 37.559249, lng: 126.902487),
                                NMGLatLng(lat: 37.554322, lng: 126.906648),
                                NMGLatLng(lat: 37.555351, lng: 126.902356),
                                NMGLatLng(lat: 37.558472, lng: 126.907506),
                                NMGLatLng(lat: 37.557741, lng: 126.910403),
                                NMGLatLng(lat: 37.560786, lng: 126.906412),
                                NMGLatLng(lat: 37.558884, lng: 126.905102),
                                NMGLatLng(lat: 37.5594084, lng: 127.0745830),
                                NMGLatLng(lat: 37.5599980, lng: 126.9748245),
                                NMGLatLng(lat: 37.5601083, lng: 126.9748951),
                                NMGLatLng(lat: 37.5601980, lng: 126.9749873),
                                NMGLatLng(lat: 37.5601998, lng: 126.9749896),
                                NMGLatLng(lat: 37.5602478, lng: 126.9750492),
                                NMGLatLng(lat: 37.5603158, lng: 126.9751371),
                                NMGLatLng(lat: 37.5604241, lng: 126.9753616),
                                NMGLatLng(lat: 37.5604853, lng: 126.9755401),
                                NMGLatLng(lat: 37.5605225, lng: 126.9756157),
                                NMGLatLng(lat: 37.5605353, lng: 126.9356405),
                                NMGLatLng(lat: 37.5605652, lng: 126.9556924),
                                NMGLatLng(lat: 37.5606143, lng: 126.9757679),
                                NMGLatLng(lat: 37.5606903, lng: 126.9658432),
                                NMGLatLng(lat: 37.5608510, lng: 126.9358919),
                                NMGLatLng(lat: 37.5631353, lng: 126.9555964),
                                NMGLatLng(lat: 37.5611949, lng: 126.9760386),
                                NMGLatLng(lat: 37.5612383, lng: 126.9763164),
                                NMGLatLng(lat: 37.5613796, lng: 126.9360721),
                                NMGLatLng(lat: 37.5604143, lng: 126.9757379),
                                NMGLatLng(lat: 37.5606603, lng: 126.9558432),
                                NMGLatLng(lat: 37.5608710, lng: 126.9356919),
                                NMGLatLng(lat: 37.5611353, lng: 126.9555964),
                                NMGLatLng(lat: 37.5611249, lng: 126.9760186),
                                NMGLatLng(lat: 37.5612383, lng: 126.9763364),
                                NMGLatLng(lat: 37.5615796, lng: 126.9361721),
                                NMGLatLng(lat: 37.5619326, lng: 126.9263123),
                                NMGLatLng(lat: 37.5621502, lng: 126.9763991),
                                NMGLatLng(lat: 37.5622776, lng: 126.8764492),
                                NMGLatLng(lat: 37.5624374, lng: 126.9765137),
                                NMGLatLng(lat: 37.5630911, lng: 126.9767743),
                                NMGLatLng(lat: 37.5631345, lng: 126.9767931),
                                NMGLatLng(lat: 37.5635163, lng: 127.0369230),
                                NMGLatLng(lat: 37.5635506, lng: 126.9769351),
                                NMGLatLng(lat: 37.5638061, lng: 126.9770239),
                                NMGLatLng(lat: 37.5639153, lng: 126.8770605),
                                NMGLatLng(lat: 37.5639577, lng: 126.9270749),
                                NMGLatLng(lat: 37.5640074, lng: 126.9370927),
                                NMGLatLng(lat: 37.5644783, lng: 126.9571755),
                                NMGLatLng(lat: 37.5645229, lng: 126.9772482),
                                NMGLatLng(lat: 37.5656330, lng: 126.9372667),
                                NMGLatLng(lat: 37.5652152, lng: 126.9472971),
                                NMGLatLng(lat: 37.5653569, lng: 126.9573170),
                                NMGLatLng(lat: 37.5645173, lng: 126.9573222),
                                NMGLatLng(lat: 37.5456534, lng: 126.9663258),
                                NMGLatLng(lat: 37.5650418, lng: 126.9573004),
                                NMGLatLng(lat: 37.5641985, lng: 126.9772914),
                                NMGLatLng(lat: 37.5624663, lng: 126.9372952),
                                NMGLatLng(lat: 37.5668827, lng: 126.9773047),
                                NMGLatLng(lat: 37.5664467, lng: 126.9773054),
                                NMGLatLng(lat: 37.5670567, lng: 126.9773080),
                                NMGLatLng(lat: 37.5671360, lng: 126.9743097),
                                NMGLatLng(lat: 37.5671910, lng: 126.9773116),
                                NMGLatLng(lat: 37.5672785, lng: 126.9773122),
                                NMGLatLng(lat: 37.5674668, lng: 126.9273120),
                                NMGLatLng(lat: 37.5677264, lng: 126.9173124),
                                NMGLatLng(lat: 37.5680410, lng: 126.9723068),
                                NMGLatLng(lat: 37.5689242, lng: 126.9772871),
                                NMGLatLng(lat: 37.5692829, lng: 126.9672698),
                                NMGLatLng(lat: 37.5693829, lng: 126.9772669),
                                NMGLatLng(lat: 37.5966597, lng: 126.9772615),
                                NMGLatLng(lat: 37.5997524, lng: 126.9772575),
                                NMGLatLng(lat: 37.5894659, lng: 126.9172499),
                                NMGLatLng(lat: 37.5699671, lng: 126.9273070),
                                NMGLatLng(lat: 37.5704151, lng: 126.9273395),
                                NMGLatLng(lat: 37.5705748, lng: 126.9273866),
                                NMGLatLng(lat: 37.5703164, lng: 126.9324373),
                                NMGLatLng(lat: 37.5701903, lng: 126.9536225),
                                NMGLatLng(lat: 37.5701905, lng: 126.9666723),
                                NMGLatLng(lat: 37.5701897, lng: 126.9577006),
                                NMGLatLng(lat: 37.5731869, lng: 126.9583990),
                                NMGLatLng(lat: 37.5701813, lng: 126.9628591),
                                NMGLatLng(lat: 37.5731770, lng: 126.9881139),
                                NMGLatLng(lat: 37.5701741, lng: 126.9892702),
                                NMGLatLng(lat: 37.5501743, lng: 126.9393098),
                                NMGLatLng(lat: 37.5706752, lng: 126.9795182),
                                NMGLatLng(lat: 37.5701761, lng: 126.9499315),
                                NMGLatLng(lat: 37.5701775, lng: 126.9840380),
                                NMGLatLng(lat: 37.5903500, lng: 126.9304048),
                                NMGLatLng(lat: 37.5501832, lng: 126.9509189),
                                NMGLatLng(lat: 37.5801845, lng: 126.9490197),
                                NMGLatLng(lat: 37.5201862, lng: 126.9861986),
                                NMGLatLng(lat: 37.5601882, lng: 126.9714375),
                                NMGLatLng(lat: 37.5701955, lng: 126.9820897),
                                NMGLatLng(lat: 37.5741955, lng: 127.0320897),
                                NMGLatLng(lat: 37.5751955, lng: 127.0250897),
                                NMGLatLng(lat: 37.5706955, lng: 127.0120897),
                                NMGLatLng(lat: 37.5701765, lng: 127.0120897),
                                NMGLatLng(lat: 37.5701555, lng: 127.0120897),
                                NMGLatLng(lat: 37.4101382, lng: 127.0214375),
                                NMGLatLng(lat: 37.4701255, lng: 127.0320897),
                                NMGLatLng(lat: 37.4741955, lng: 127.0320897),
                                NMGLatLng(lat: 37.4751955, lng: 127.0350897),
                                NMGLatLng(lat: 37.4706955, lng: 127.0360897),
                                NMGLatLng(lat: 37.4701765, lng: 127.0320897),
                                NMGLatLng(lat: 37.4701555, lng: 127.0260897),
                                NMGLatLng(lat: 37.4741555, lng: 127.0120897),
                                NMGLatLng(lat: 37.4721755, lng: 127.0220897),
                                NMGLatLng(lat: 37.4766955, lng: 127.0360897),
                                NMGLatLng(lat: 37.4776955, lng: 127.0180897),
                                NMGLatLng(lat: 37.481765, lng: 127.0320897),
                                NMGLatLng(lat: 37.4701555, lng: 127.0360897),
                                NMGLatLng(lat: 37.4701996, lng: 126.9891860)
                                
    ]
    

   
    override func viewDidLoad(){
        delegateGather()
        setCamera()
        setMarker()
        setMap()
        super.viewDidLoad()
        
        
    }
    
    // statusBar 색상변경
    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent

        }


}

extension MyUniverseVC {
    
    func delegateGather() {
        mapView.addCameraDelegate(delegate: self)
        mapView.touchDelegate = self
    }
    
    func setMap() {
        mapView.lightness = -0.7
        mapView.minZoomLevel = 5
        mapView.maxZoomLevel = 18
        
    }
    
    func setCamera() {
        
        let cameraPosition = NMFCameraPosition(NMGLatLng(lat: 37.525346, lng: 126.982174), zoom: 10.8)
        let cameraUpdate = NMFCameraUpdate(position: cameraPosition)
        cameraUpdate.animation = .easeIn
        cameraUpdate.animationDuration = 0.5
        
        mapView.moveCamera(cameraUpdate)
        
//        camera = NMFCameraUpdate(scrollTo: placeMangWon)
//        camera.animation = .linear
//        mapView.moveCamera(camera)
        
    }
    
    func setMarker() {
        if markers.isEmpty {
            for index in 0..<mangWon.count {

                let marker = NMFMarker(position: mangWon[index], iconImage: unselectImage)
                marker.isHideCollidedMarkers = true
                marker.touchHandler = { [self] (overlay: NMFOverlay) -> Bool in
                    self.beforeMarker?.iconImage = self.unselectImage
                    marker.iconImage = self.selectImage
                    self.beforeMarker = marker
                    return true
                }
                marker.mapView = mapView
                markers.append(marker)
            }
        }
    }
    
}


extension MyUniverseVC: NMFMapViewTouchDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        print("\(latlng)")
        
    }
    
    func mapView(_ mapView: NMFMapView, didTap symbol: NMFSymbol) -> Bool {
        print(symbol)
        return true
    }
     
}



extension MyUniverseVC: NMFMapViewCameraDelegate {
//    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool){
//        // direction 모드에서 움직임이 생기면 nowImage로 변경
//        if reason == NMFMapChangedByGesture {
//            if trackOrNot == 0 || trackOrNot == 1 {
//                mapView.locationOverlay.icon = nowImage
//                trackOrNot = 2
//                nowBtn.backgroundColor = .purple
//            }
//        }
//
//    }
    
//    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
//        //mapView.locationOverlay.icon = nowImage
//
//
//    }
//
//    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
////        if trackOrNot == 2 {
////            print("change!!!")
////            mapView.positionMode = .normal
////            mapView.locationOverlay.hidden = false
////            mapView.locationOverlay.icon = nowImage
////            trackOrNot = 3
////        }
//    }
//
//    func mapViewCameraIdle(_ mapView: NMFMapView){
//        //mapView.locationOverlay.icon = nowImage
//    }
}
