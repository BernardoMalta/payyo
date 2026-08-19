# Fonte das peças de Instagram

Os PNGs em `social/` são gerados a partir dos HTML desta pasta. Para mudar um texto,
edite o HTML e rode o render — não edite o PNG.

Cada `.board` é uma peça. Avatar é 1080×1080, slide de carrossel é 1080×1350
(4:5, o vertical máximo que o Instagram aceita).

## Re-renderizar

Precisa de Chrome e Python com Pillow.

```bash
./render.sh lancamento.html    # gera os PNGs de social/
./render.sh quem-somos.html
```

O script tira um print da página inteira e recorta cada `.board` em um arquivo.
O `--virtual-time-budget` dá tempo das fontes do Google carregarem antes do print;
sem ele as peças saem com fonte de sistema.

## Antes de publicar

Confira o avatar reduzido a 32 px. É o tamanho real dele em comentário e no anel
de story, e é onde acabamento brilhante vira mancha.
