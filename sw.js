const CACHE_NAME = "patagonia-v1";

const URLS_TO_CACHE = [
  "./",
  "./index.html",
  "./route-map.html",

  // images
  "./route-map.png",
  "./drivers-license.jpg",
  "./passport-photo.jpg",
  "./map-corrientes-guide.png",
  "./map-corrientes-route.png",
  "./map-recoleta-guide.png",
  "./map-recoleta-overview.png",
  "./map-san-telmo-guide.png",
  "./map-san-telmo-route.png"
];

self.addEventListener("install", (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => cache.addAll(URLS_TO_CACHE))
  );
  self.skipWaiting();
});

self.addEventListener("activate", (event) => {
  event.waitUntil(self.clients.claim());
});

self.addEventListener("fetch", (event) => {
  event.respondWith(
    caches.match(event.request).then((response) => response || fetch(event.request))
  );
});
