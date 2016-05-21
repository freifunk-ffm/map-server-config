# Server config files hopglass map-server mit Prometheus und Grafana

## Installation

Die Datei install.sh enthält eine Schritt für Schritt Anleitung nach welcher die hopglass-map installiert ist. Als Betriebssystem wird debian etch angenommen. Die Verwendeten Komponenten sind:

- Webserver (Nginx, weil gzip-Komprimierung und reverse proxies damit einfacher sind)
- eine aktuelle Version von NodeJS (Version >4.3) (https://nodejs.org/en/download/package-manager/)
- Hopglass Server (https://github.com/plumpudding/hopglass-server)
- Hopglass Viewer (https://github.com/plumpudding/hopglass)
- Prometheus (http://prometheus.io)
- Grafana (http://grafana.org)

Die angepassten configs finden sich in den jeweiligen Unterverzeichnissen.

## Wartung

Änderungen bitte per Diskussion im PR

## Issues

Zur Zeit müssen ggf. die MAC Adressen der Supernodes nach einer Änderung händisch in den hopglass-server eingepflegt werden. Dies funktioniert über die Datei [hopglass-server/alias.json](hopglass-server/alias.json)

Diskussion: https://github.com/freifunk-ffm/map-server-config/issues/2

Zukünftig könnten wir über die Verwendung von https://github.com/ffnord/ffnord-alfred-announce nachdenken, welches als respondd client auf den Supernodes läuft und diese damit "automatisch" über den hopglass-server auf die Karte bringt.

## FFFFM-features

z.Zt gibt es per [hopglass-server/alias.json](hopglass-server/alias.json) eine MAC-basierte differenzierte Visualisierung der je zwei verwendeten fastd Instanzen pro supernode.

## Live

Zur Zeit ist diese map anzuschauen unter: http://ffffmmap.ffdus.de/
