# coding: utf8
import sys, os
import math
from PIL import Image

"""
与えられた画像を長辺に合わせて正方形にする
"""
if not len(sys.argv) == 2:
    print("invalid argument!")
    sys.exit()

# 既存ファイルを readモードで読み込み
logo_img = Image.open(sys.argv[1])
if logo_img.mode != "RGBA":
    logo_img = logo_img.convert("RGBA") # RGBモードに変換する

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

    marker_img.paste(logo_img, paste_box)
else:
    marker_img = logo_img.copy()

# 保存
marker_img.save(os.environ["PROJECT_HOME"]+"/lib/tmp/tmp.png", 'PNG', quality=100, optimize=True)
