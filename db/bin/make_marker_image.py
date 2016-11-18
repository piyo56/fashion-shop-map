# coding: utf8
import sys, os
import math
from PIL import Image

"""
与えられた画像をgmapのmarker用に整形する
"""
if not len(sys.argv) == 2:
    print("invalid argument!")
    sys.exit()

# 既存ファイルを readモードで読み込み
logo_img = Image.open(sys.argv[1], 'r')
if logo_img.mode != "RGBA":
    logo_img = logo_img.convert("RGBA") # RGBモードに変換する
basename = sys.argv[1].split("/")[-1].split(".")[0]

width  = logo_img.size[0]
height = logo_img.size[1]

# 画素値をロードしてロゴの代表色をピック
data = logo_img.load()
logo_color = data[3,3]

# もし画像が正方形でない場合は長辺に合わせて正方形にする
if width != height:
    length = width > height and width or height
    marker_img = Image.new("RGBA", (length, length), logo_color)

    if width > height:
        left_top_y = math.floor((width - height) / 2)
        paste_box = (0, left_top_y)
    else:
        left_top_x = math.floor((height - width) / 2)
        paste_box = (left_top_x, 0)

    marker_img.paste(img, paste_box)
else:
    marker_img = logo_img.copy()

# 30x30にリサイズして外側に黒枠線を付ける。(32x32)
if width != 32:
    marker_img.thumbnail((32, 32), Image.ANTIALIAS)

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

marker_pin_img.save("{}/app/assets/images/{}.png".format(os.environ["PROJECT_HOME"], basename), 'PNG', quality=100, optimize=True)
