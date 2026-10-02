# Step scene kit for direction B. Every scene is assembled from shared parts:
# vessel, heat, tool, food, motion. Coordinates share one 358 x 220 stage with
# the ground at y = 198, so parts line up without per-scene tuning.
from common import *

ST = B


def R(shapes):
    return render(shapes, ST)


def G(dx, dy, shapes, rot=0, about="0 0"):
    return '<g transform="translate(%s %s) rotate(%s %s)">%s</g>' % (dx, dy, rot, about, render(shapes, ST))


# ---------------------------------------------------------------- heat
def hob(flames=3, small=False):
    S = [D('rect x="92" y="189" width="174" height="9" rx="4.5"', "iron"),
         D('rect x="112" y="176" width="6" height="15" rx="2"', "iron"), D('rect x="240" y="176" width="6" height="15" rx="2"', "iron")]
    xs = {3: (151, 179, 207), 2: (165, 193), 0: ()}[flames]
    for x in xs:
        if small:
            S.append(F('path d="M%s 189c-5 0 -7 -5 -4 -9c1.600 -2.800 3.400 -4.400 4 -8c1.200 3.400 4 5.200 4.600 8.600c1 4.600 -1.200 8.400 -4.600 8.400z"' % x, "flame1"))
        else:
            S.append(F('path d="M%s 189c-8 0 -11 -8 -6.500 -14.500c2.600 -4.400 5.400 -7 6.500 -12.500c2 5.400 6.400 8.200 7.400 13.600c1.600 7.400 -1.800 13.400 -7.400 13.400z"' % x, "flame1"))
            S.append(D('path d="M%s 187.500c-3.600 0 -5 -3.600 -3 -6.600c1.200 -2 2.400 -3.200 3 -5.600c.900 2.400 2.900 3.700 3.400 6.200c.700 3.300 -.900 6 -3.400 6z"' % x, "flame2"))
    return S


def ground():
    return [L('path d="M40 198.500h278"', "ink", 2)]


def oven():
    return [F('rect x="62" y="24" width="234" height="174" rx="12"', "steel_d"),
            F('rect x="82" y="64" width="194" height="112" rx="8"', "yolk"),
            D('circle cx="96" cy="44" r="6"', "ink"), D('circle cx="118" cy="44" r="6"', "ink"), L('path d="M196 44h66"', "ink", 3),
            L('path d="M82 150h194"', "ink", 2)]


# ---------------------------------------------------------------- vessels
def pan(oil=True):
    S = [F('rect x="264" y="119" width="82" height="12" rx="6" transform="rotate(-7 264 125)"', "iron"),
         F('path d="M88 128C90 150 104 161 124 161L234 161C254 161 268 150 270 128Z"', "iron"),
         F('ellipse cx="179" cy="127" rx="92" ry="21"', "iron"),
         D('ellipse cx="179" cy="126" rx="82" ry="15.500"', "iron_l")]
    if oil:
        S.append(D('ellipse cx="179" cy="128" rx="62" ry="9"', "oil"))
    return S


def pot(fill="water"):
    return [F('rect x="90" y="100" width="20" height="10" rx="5"', "iron"), F('rect x="248" y="100" width="20" height="10" rx="5"', "iron"),
            F('path d="M108 88h142v58q0 16 -16 16h-110q-16 0 -16 -16z"', "iron"),
            F('ellipse cx="179" cy="88" rx="71" ry="13"', "iron"), D('ellipse cx="179" cy="88" rx="63" ry="9.500"', fill)]


def board():
    return [F('rect x="56" y="166" width="246" height="20" rx="8"', "wood")] + [L('path d="M40 198.500h278"', "ink", 2)]


def bowl(fill="yolk"):
    return [F('path d="M97 112h164q-4 74 -82 74t-82 -74z"', "steel_d"), F('ellipse cx="179" cy="112" rx="82" ry="15"', "steel_d"),
            D('ellipse cx="179" cy="113" rx="70" ry="10"', fill)]


def plate():
    return [F('ellipse cx="179" cy="168" rx="118" ry="26"', "white"), L('path d="M99 166a80 15 0 0 0 160 0"', "ink", 1.600)]


def tray():
    return [F('rect x="96" y="136" width="166" height="13" rx="5"', "iron")]


def colander():
    S = [F('rect x="80" y="92" width="22" height="10" rx="5"', "iron"), F('rect x="256" y="92" width="22" height="10" rx="5"', "iron"),
         F('path d="M100 84h158q-2 62 -79 62t-79 -62z"', "steel_d"), F('ellipse cx="179" cy="84" rx="79" ry="13"', "steel_d")]
    for x, y in ((138, 112), (158, 124), (179, 128), (200, 124), (220, 112), (150, 104), (208, 104), (179, 110)):
        S.append(D('circle cx="%s" cy="%s" r="2.600"' % (x, y), "ink"))
    return S


# ---------------------------------------------------------------- tools
def knife():      # local origin at the heel of the blade
    return [F('path d="M0 0h78c6 4 6 14 -8 18H0z"', "steel_d"), F('rect x="-46" y="1" width="48" height="13" rx="6"', "iron")]


def whisk():      # origin at the handle top
    return [L('path d="M0 0v52"', "ink", 5), L('path d="M0 52c-18 8 -16 40 0 44c16 -4 18 -36 0 -44zM0 52v44M-9 60c0 14 4 28 9 36M9 60c0 14 -4 28 -9 36"', "ink", 2)]


def spoon():      # origin at the handle top
    return [F('rect x="-3.500" y="0" width="7" height="78" rx="3.500"', "wood"), F('ellipse cx="0" cy="88" rx="11" ry="15"', "wood")]


def spatula():
    return [F('rect x="-3" y="0" width="6" height="64" rx="3"', "iron"), F('rect x="-15" y="60" width="30" height="34" rx="5"', "steel_d")]


def thermo():
    return [L('path d="M0 30v62"', "ink", 3), F('circle cx="0" cy="14" r="17"', "white"), L('path d="M0 14l7 -8"', "gold_d", 2.400), D('circle cx="0" cy="14" r="2.400"', "ink")]


def bottle():
    return [F('path d="M-11 0h22v44c0 6 -4 10 -8 10h-6c-4 0 -8 -4 -8 -10z"', "steel_d"), F('rect x="-5" y="52" width="10" height="20" rx="2"', "steel_d"),
            D('rect x="-11" y="10" width="22" height="18"', "eye_hl")]


# ---------------------------------------------------------------- food
def chicken():
    return food_chicken()


def tofu():
    return food_tofu()


def carrot():
    return [F('path d="M0 0c0 -9 9 -14 18 -12l62 8c6 1 6 7 0 8l-62 8c-9 2 -18 -3 -18 -12z"', "carrot"),
            F('path d="M2 -3c-10 -4 -16 -12 -15 -20c7 1 12 6 15 12c-1 -8 1 -14 6 -18c4 6 4 13 1 21z"', "green")]


def coins(n=3):
    S = []
    for i in range(n):
        S.append(F('circle cx="%s" cy="0" r="9"' % (i * 21), "carrot"))
        S.append(D('circle cx="%s" cy="0" r="3.400"' % (i * 21), "yolk"))
    return S


def onion():
    return [F('path d="M0 0a26 22 0 0 1 52 0z"', "white"), L('path d="M12 0a14 14 0 0 1 28 0M20 0a6 8 0 0 1 12 0"', "ink", 1.600)]


def cubes(pts, keys=("carrot", "green", "yolk")):
    S = []
    for i, (x, y, r) in enumerate(pts):
        S.append(F('rect x="%s" y="%s" width="13" height="13" rx="3" transform="rotate(%s %s %s)"' % (x - 6.5, y - 6.5, r, x, y), keys[i % len(keys)]))
    return S


def beans():
    return [F('rect x="%s" y="%s" width="54" height="8" rx="4" transform="rotate(%s %s %s)"' % (x, y, r, x + 27, y + 4), "green") for x, y, r in ((128, 80, -8), (168, 84, 6), (146, 90, 2))]


def noodles():
    return [L('path d="M%s 84c6 -10 -6 -16 0 -26s-6 -14 0 -22"' % x, "yolk", 4) for x in (150, 166, 182, 198, 212)]


# ---------------------------------------------------------------- motion
def steam(pts=((150, 84), (180, 76), (210, 86)), short=False):
    d = "c-7 -7 7 -12 0 -20" if short else "c-7 -7 7 -12 0 -20s7 -12 0 -20"
    return [L('path d="M%s %s%s"' % (x, y, d), "steam", 4) for x, y in pts]


def sizzle():
    return [D('circle cx="%s" cy="%s" r="2.400"' % p, "flame2") for p in ((120, 112), (240, 110), (112, 122), (246, 121))]


def arc(d, head):
    return [L('path d="%s"' % d, "gold_d", 2.600), L('path d="%s"' % head, "gold_d", 2.600)]


def bubbles(y=84):
    return [L('circle cx="%s" cy="%s" r="%s"' % (x, y - dy, r), "ink", 1.800) for x, dy, r in ((146, 0, 6), (170, 6, 4), (192, -1, 7), (214, 5, 4.500))]


def drops(xs=(150, 170, 190, 210), y=152):
    return [L('path d="M%s %sv%s"' % (x, y + (i % 2) * 6, 14 + (i % 2) * 6), "ink", 2.400) for i, x in enumerate(xs)]


# ---------------------------------------------------------------- scenes
def scene(name, food="chicken"):
    main = tofu() if food == "tofu" else chicken()
    if name == "chop":
        return R(board()) + G(84, 150, carrot()) + G(196, 156, coins(3)) + G(228, 96, knife(), -28) + R(arc("M248 70q14 10 10 28", "M252 94l6 5 5 -7"))
    if name == "crack":
        return R(ground()) + R(bowl("yolk")) + G(136, 48, [F('path d="M0 22a26 24 0 0 1 44 -14l-8 6 -6 -5 -7 8 -8 -4z"', "white")], -18) + \
            G(196, 40, [F('path d="M0 8l7 4 7 -8 6 5 8 -6a26 24 0 0 1 12 22z"', "white")], 22) + R([F('ellipse cx="179" cy="78" rx="11" ry="13"', "yolk")]) + \
            R(arc("M179 92v12", "M174 100l5 6 5 -6"))
    if name == "whisk":
        return R(ground()) + R(bowl("yolk")) + G(226, 14, whisk(), 24) + R(arc("M128 96q50 -22 100 -4", "M220 86l9 6 -8 7"))
    if name == "sear":
        return R(hob()) + R(pan()) + R(main) + R(steam()) + R(sizzle())
    if name == "flip":
        return R(hob()) + R(pan()) + '<g transform="translate(0 -40) rotate(-14 179 116)">%s</g>' % R(main) + G(272, 30, spatula(), 52) + \
            R(arc("M112 96q-10 -44 40 -56", "M144 34l9 5 -6 9"))
    if name == "toss":
        return R(hob()) + R(pan()) + R(cubes(((150, 122, 10), (176, 126, 40), (204, 121, -15)))) + R(cubes(((140, 78, 30), (176, 56, -10), (212, 72, 50)), ("green", "yolk", "carrot"))) + \
            R(arc("M118 100q12 -52 58 -62", "M168 32l9 6 -7 8")) + R(arc("M240 100q-6 -30 -22 -44", "M214 64l3 -10 9 4"))
    if name == "stir":
        return R(hob()) + R(pot("oil")) + G(214, 6, spoon(), 16) + R(arc("M140 84q38 -18 72 -2", "M204 76l9 6 -8 7")) + R(steam(((130, 62),), True))
    if name == "deglaze":
        return R(hob()) + R(pan()) + G(96, 22, bottle(), -52) + R([L('path d="M134 62q20 22 36 58"', "yolk", 5)]) + R(steam(((196, 96), (222, 90), (246, 100)), True)) + R(sizzle())
    if name == "simmer":
        return R(hob(3, small=True)) + R(pan()) + R(bubbles(126)) + R(arc("M300 84v34", "M294 110l6 9 6 -9")) + R([L('path d="M288 84h24"', "gold_d", 2.600)])
    if name == "boil":
        return R(hob()) + R(pot()) + R(beans()) + R(bubbles(70)) + R(steam(((136, 56), (224, 58)), True))
    if name == "drain":
        return R(ground()) + R(noodles()) + R(colander()) + R(drops()) + R(steam(((120, 60), (240, 60)), True))
    if name == "oven":
        return R(ground()) + R(oven()) + R(tray()) + R(cubes(((122, 128, 10), (150, 127, 30), (178, 128, -12), (206, 127, 22), (234, 128, 6))))
    if name == "rest":
        return R(board()) + '<g transform="translate(0 44)">%s</g>' % R(main) + R([F('circle cx="282" cy="72" r="24"', "white"), L('path d="M282 72v-13M282 72l9 6"', "ink", 2.600)]) + \
            R(steam(((150, 118), (206, 118)), True))
    if name == "plate":
        return R(ground()) + R(plate()) + '<g transform="translate(-6 38) scale(.96)">%s</g>' % R(main) + \
            R([F('path d="M224 160c8 -16 34 -14 38 0z"', "green"), L('path d="M112 174q40 12 96 6"', "yolk", 5)])
    if name == "temp":
        return R(board()) + '<g transform="translate(-20 44)">%s</g>' % R(main) + G(232, 56, thermo(), 28) + \
            '<text x="286" y="74" font-family="Gloock, Georgia, serif" font-size="30" fill="#172A6E">74&#176;</text>'
    return ""


SCENES = [
    ("chop", "Chop", "board, knife, carrot, cut mark"),
    ("crack", "Crack an egg", "bowl, egg, drop"),
    ("whisk", "Whisk", "bowl, whisk, swirl"),
    ("sear", "Sear", "hob, pan, main, steam, sizzle"),
    ("flip", "Flip", "hob, pan, spatula, main, arc"),
    ("toss", "Sauté toss", "hob, pan, diced veg, arcs"),
    ("stir", "Stir", "hob, pot, spoon, swirl"),
    ("deglaze", "Deglaze", "hob, pan, bottle, pour, steam"),
    ("simmer", "Simmer and reduce", "low hob, pan, bubbles, level"),
    ("boil", "Boil", "hob, pot, beans, bubbles, steam"),
    ("drain", "Drain", "colander, noodles, drops"),
    ("oven", "Oven tray", "oven, tray, diced veg"),
    ("rest", "Rest", "board, main, clock, steam"),
    ("plate", "Plate", "plate, main, greens, sauce"),
    ("temp", "Check temperature", "board, main, thermometer, reading"),
]


def scene_svg(name, food="chicken", w=200, h=125, label=""):
    return ('<svg viewBox="26 4 326 204" width="%s" height="%s" role="img" aria-label="%s">%s</svg>') % (w, h, label or name, scene(name, food))
