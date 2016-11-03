#coding: utf-8
import sys
from PIL import Image

if not len(sys.argv) == 2:
    print("invalid argument!")
    sys.exit()

print("OK")

# 既存ファイルを readモードで読み込み
img = Image.open(sys.argv[1], 'r')

# リサイズ。サイズは幅と高さをtupleで指定
img.thumbnail((100, 100), Image.ANTIALIAS)

# リサイズ後の画像を保存
resize_img.save('resize_img.png', 'PNG', quality=100, optimize=True)
