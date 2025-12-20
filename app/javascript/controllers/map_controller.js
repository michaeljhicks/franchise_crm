import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array
  }

  connect() {
    this.loadGoogleMaps()
  }

  loadGoogleMaps() {
    if (window.google && window.google.maps) {
      this.initMap()
      return
    }

    if (document.querySelector("#google-maps-script")) return

    window.initMap = this.initMap.bind(this)

    const script = document.createElement("script")
    script.id = "google-maps-script"
    // We remove "libraries=marker" because the standard red pin doesn't need it
    script.src = `https://maps.googleapis.com/maps/api/js?key=${this.apiKeyValue}&callback=initMap`
    script.async = true
    script.defer = true
    document.head.appendChild(script)
  }

  initMap() {
    const map = new google.maps.Map(this.element, {
      zoom: 4,
      center: { lat: 39.8283, lng: -98.5795 } // Center of US
    })

    const bounds = new google.maps.LatLngBounds()
    const infoWindow = new google.maps.InfoWindow()

    this.markersValue.forEach((markerData) => {
      // PURE DEFAULT GOOGLE MARKER
      // By not specifying an 'icon' or 'content', Google defaults to the Red Pin
      const marker = new google.maps.Marker({
        position: { lat: Number(markerData.lat), lng: Number(markerData.lng) },
        map: map,
        title: markerData.title
      })

      marker.addListener("click", () => {
        infoWindow.setContent(markerData.info_window_html)
        infoWindow.open(map, marker)
      })

      bounds.extend(marker.getPosition())
    })

    if (this.markersValue.length > 0) {
      map.fitBounds(bounds)
      
      // Prevent zooming in too close if there's only one customer
      const listener = google.maps.event.addListener(map, "idle", () => { 
        if (map.getZoom() > 15) map.setZoom(15); 
        google.maps.event.removeListener(listener); 
      });
    }
  }
}