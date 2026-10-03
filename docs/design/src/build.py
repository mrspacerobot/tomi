# Builds ../round1.html (one static, self-contained file). Run: python3 build.py
import os, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import dir_a, dir_b, dir_c
from page import PAGE_CSS, header, direction, footer

FONTS = ("https://fonts.googleapis.com/css2?family=Bricolage+Grotesque:opsz,wght@12..96,400..800"
         "&family=Instrument+Sans:wght@400..700&family=Gloock&family=Newsreader:ital,opsz,wght@0,6..72,400..600;1,6..72,400..600"
         "&family=Figtree:wght@400..700&family=Young+Serif&family=Karla:wght@400..700&family=Caveat:wght@600..700&display=swap")

html = ['<!doctype html>\n<html lang="en">\n<head>\n<meta charset="utf-8">\n<meta name="viewport" content="width=device-width, initial-scale=1">\n',
        '<title>Tomi design round 1</title>\n',
        '<link rel="preconnect" href="https://fonts.googleapis.com">\n<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>\n',
        '<link rel="stylesheet" href="%s">\n' % FONTS.replace("&", "&amp;"),
        "<style>\n", PAGE_CSS, dir_a.CSS, dir_b.CSS, dir_c.CSS, "</style>\n</head>\n<body>\n<div class=\"wrap\">\n",
        header(),
        direction("a", dir_a), direction("b", dir_b), direction("c", dir_c),
        footer(), "</div>\n</body>\n</html>\n"]
out = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "round1.html")
text = "".join(html)
assert chr(8212) not in text and chr(8211) not in text, "dash found"
assert "#ff00ff" not in text, "missing palette key"
open(out, "w", encoding="utf-8").write(text)
print("wrote", os.path.abspath(out), len(text) // 1024, "KB")

# Optional single-phone debug pages for close inspection: DBG=1 python3 build.py
if os.environ.get("DBG"):
    head = "".join(html[:9]) + "</style></head><body>"
    for k, mod in (("a", dir_a), ("b", dir_b), ("c", dir_c)):
        for n, fn in (("home", mod.home), ("step", mod.step), ("ob", mod.onboarding)):
            page = head + '<div style="padding:10px">%s</div></body></html>' % fn()
            open(os.path.join(os.path.dirname(out), "_dbg_%s_%s.html" % (k, n)), "w", encoding="utf-8").write(page)
            if n == "home":
                page = head + '<div style="padding:10px;margin-top:-900px">%s</div></body></html>' % fn()
                open(os.path.join(os.path.dirname(out), "_dbg_%s_home2.html" % k), "w", encoding="utf-8").write(page)
