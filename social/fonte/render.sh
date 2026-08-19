#!/usr/bin/env bash
# Renderiza um HTML de peças em PNGs, um por .board.
#   ./render.sh quem-somos.html
set -euo pipefail

FONTE="${1:?uso: ./render.sh <arquivo.html>}"
BASE="$(basename "$FONTE" .html)"
DIR="$(cd "$(dirname "$0")" && pwd)"
SAIDA="$DIR/.."

CHROME="/c/Program Files/Google/Chrome/Application/chrome.exe"
[ -x "$CHROME" ] || CHROME="$(command -v google-chrome || command -v chromium)"

# altura total = soma dos .board; medida pelo próprio Chrome
ALTURA=$(python - "$DIR/$FONTE" <<'PY'
import re, sys
html = open(sys.argv[1], encoding='utf-8').read()
# conta boards e usa as alturas declaradas no CSS
avatares = len(re.findall(r'class="board avatar"', html))
slides   = len(re.findall(r'class="board(?! avatar)', html))
print(avatares * 1080 + slides * 1350)
PY
)

echo "renderizando $FONTE ($ALTURA px)…"
"$CHROME" --headless --disable-gpu --hide-scrollbars --virtual-time-budget=6000 \
  --screenshot="$DIR/_tmp.png" --window-size=1080,"$ALTURA" \
  "file://$(cd "$DIR" && pwd -W 2>/dev/null || pwd)/$FONTE"

python - "$DIR/_tmp.png" "$SAIDA" "$BASE" <<'PY'
import sys
from PIL import Image
tmp, saida, base = sys.argv[1], sys.argv[2], sys.argv[3]
im = Image.open(tmp)
y, n = 0, 1
while y < im.size[1]:
    alt = 1080 if im.size[1] - y >= 1080 and (im.size[1] - y) % 1350 else 1350
    alt = min(alt, im.size[1] - y)
    im.crop((0, y, 1080, y + alt)).save(f"{saida}/{base}-{n:02d}.png")
    print(" ", f"{base}-{n:02d}.png", f"1080x{alt}")
    y += alt; n += 1
PY

rm -f "$DIR/_tmp.png"
echo "pronto — confira o avatar a 32 px antes de publicar"
