# coding: utf8
import sys, os
import math
from PIL import Image

"""
与えられた画像をgmapのmarker用に整形する
読み込み画像は正方形であると仮定
"""
if not len(sys.argv) == 2:
    print("invalid argument!")
    sys.exit()

# 読み込み
logo_img = Image.open(sys.argv[1], 'r')
if logo_img.mode != "RGBA":
    logo_img = logo_img.convert("RGBA") # RGBモードに変換する
basename = sys.argv[1].split("/")[-1].split(".")[0]

width  = logo_img.size[0]
height = logo_img.size[1]

# 32x32にリサイズ
if width != 32:
    logo_img.thumbnail((32, 32), Image.ANTIALIAS)

# 画素値をロードしてロゴの代表色をピック
data = logo_img.load()
logo_color = data[3,3]

# ピン用の下三角画像を読み込み
pin_img_path = os.environ.get("PROJECT_HOME") + "/app/assets/images/pin.png"
pin_img = Image.open(pin_img_path)
data = pin_img.load()
for x in range(0, pin_img.size[0]):
    for y in range(0, pin_img.size[1]):
        if data[x, y] != (0,0,0,0):
            pixel = list(data[x,y])
            pixel[:3] = logo_color[:3]
            data[x, y] = tuple(pixel)

# ロゴとピン画像をバーティカルジョインする
marker_pin_img = Image.new("RGBA", (32, 44), (0, 0, 0, 0))
marker_pin_img.paste(marker_img, (0, 0))
marker_pin_img.paste(pin_img, (8, 32))

# 保存
marker_pin_img.save("{}/app/assets/images/{}.png".format(os.environ["PROJECT_HOME"], basename), 'PNG', quality=100, optimize=True)
