import SwiftUI
import MapKit

/// MapKit's MKMapView representable.
public struct MapView: UIViewRepresentable {
  /// - Parameters:
  ///   - visibleRect: Binding for map's visible rect.
  ///   - annotations: Array of MKAnnotation objects to render on the map.
  ///   - annotationViewFactory: Factory that provides the view associated with the specified annotation object.
  ///   - overlays: Array of MKOverlay objects to render on the map.
  ///   - overlayRendererFactory: Factory that returns renderer object to use when drawing the specified overlay.
  public init(
    visibleRect: Binding<MKMapRect>,
    annotations: [MKAnnotation],
    annotationViewFactory: AnnotationViewFactory,
    overlays: [MKOverlay],
    overlayRendererFactory: OverlayRendererFactory
  ) {
    self._visibleRect = visibleRect
    self.annotations = annotations
    self.annotationViewFactory = annotationViewFactory
    self.overlays = overlays
    self.overlayRendererFactory = overlayRendererFactory
  }

  @Binding var visibleRect: MKMapRect
  var annotations: [MKAnnotation]
  let annotationViewFactory: AnnotationViewFactory
  var overlays: [MKOverlay]
  let overlayRendererFactory: OverlayRendererFactory

  public func makeCoordinator() -> MapViewCoordinator {
    MapViewCoordinator(view: self)
  }

  public func makeUIView(context: Context) -> MKMapView {
    let view = MKMapView()
    annotationViewFactory.register(in: view)
    view.delegate = context.coordinator
    return view
  }

  public func updateUIView(_ uiView: MKMapView, context: Context) {
    uiView.setVisibleMapRect(visibleRect, animated: false)

    uiView.annotations.forEach { annotation in
      if !annotations.contains(where: { $0.isEqual(annotation) }) {
        uiView.removeAnnotation(annotation)
      }
    }
    annotations.forEach { annotation in
      if !uiView.annotations.contains(where: { $0.isEqual(annotation) }) {
        uiView.addAnnotation(annotation)
      }
    }

    uiView.overlays.forEach { overlay in
      if !overlays.contains(where: { $0.isEqual(overlay) }) {
        uiView.removeOverlay(overlay)
      }
    }
    overlays.forEach { overlay in
      if !uiView.overlays.contains(where: { $0.isEqual(overlay) }) {
        uiView.addOverlay(overlay)
      }
    }
  }
}
