#!/usr/bin/env bash
set -euo pipefail

# Konfiguration
TILE_DIR="/bigdata/export/world/mod_tile/"
JOBS="${JOBS:-$(nproc)}"      # Anzahl paralleler Jobs (überschreibbar: JOBS=8 ./script.sh)
BATCH="${BATCH:-1000}"        # Wie viele Pfade pro Aufruf bündeln
PROGRESS="${PROGRESS:-0}"     # 1 = Fortschrittsbalken anzeigen

# Prüfen, ob GNU parallel vorhanden ist
command -v parallel >/dev/null 2>&1 || {
  echo "Fehler: GNU parallel ist nicht installiert. Bitte installiere es (z.B. apt-get install parallel)." >&2
  exit 1
}

# sudo-Timestamp auffrischen, damit nachfolgende sudo-Aufrufe ohne Passwort laufen
sudo -v

# Optionale Flags
PAR_FLAGS=(--will-cite -j "$JOBS" -N "$BATCH")
if [[ "$PROGRESS" == "1" ]]; then
  PAR_FLAGS+=(--bar)
fi

# 1) Alle Dateien anfassen (touch) — parallel und in Batches
find "$TILE_DIR" -type f -print0 \
  | parallel -0 "${PAR_FLAGS[@]}" sudo touch {}

# 2) Rechte setzen (755) — explizit auf Dateien und Verzeichnisse, Symlinks überspringen
find "$TILE_DIR" -type d -print0 \
  | parallel -0 "${PAR_FLAGS[@]}" sudo chmod 755 {}
find "$TILE_DIR" -type f -print0 \
  | parallel -0 "${PAR_FLAGS[@]}" sudo chmod 755 {}

# 3) Besitzer setzen (_renderd:_renderd) — ebenfalls ohne Symlinks
find "$TILE_DIR" \( -type d -o -type f \) -print0 \
  | parallel -0 "${PAR_FLAGS[@]}" sudo chown _renderd:_renderd {}

# 4) Dienste neu laden/neu starten
sudo systemctl daemon-reload
sudo /etc/init.d/renderd restart
