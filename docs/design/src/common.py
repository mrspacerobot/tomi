# Shared drawing kit for the Tomi design round 1 mockups.
# Every illustration is a list of shapes that is rendered in one of three
# styles, which is the same idea the SwiftUI scene kit will use:
#   flat    - cut-paper fills, no outlines            (direction A)
#   print   - line work plus offset spot-colour fills (direction B)
#   outline - inked outline plus flat fills, sticker  (direction C)

def F(el, key):            # filled shape
    return ("F", el, key)

def D(el, key):            # detail: flat fill, never outlined or offset
    return ("D", el, key)

def L(el, key, w=3):       # line only
    return ("L", el, key, w)


class Pal(dict):
    """Palette with a visible fallback so a missing key is easy to spot."""
    def get(self, k, d=None):
        return self[k] if k in self else "#ff00ff"


class LockPal(dict):
    """Unlit silhouette palette: everything collapses to two quiet tones."""
    DARK = {"iron", "ink", "red_d", "wood_d", "steel_d", "glass"}
    def __init__(self, light, dark, skip=("steam", "shadow", "hl", "shade", "oil", "blush", "flame1", "flame2")):
        super().__init__()
        self.light, self.dark, self.skip = light, dark, set(skip)
    def __contains__(self, k):
        return True
    def get(self, k, d=None):
        if k in self.skip:
            return None
        return self.dark if k in self.DARK else self.light


def render(shapes, st, sticker=False):
    pal = st["pal"]
    mode = st["mode"]
    out = []
    if sticker and st.get("sticker"):
        for sh in shapes:
            if sh[0] == "F":
                out.append('<%s fill="#fff" stroke="#fff" stroke-width="%s" stroke-linejoin="round"/>' % (sh[1], st["sticker"]))
    for sh in shapes:
        k, el, key = sh[0], sh[1], sh[2]
        col = pal.get(key)
        if k == "F":
            if mode == "flat":
                if col:
                    out.append('<%s fill="%s"/>' % (el, col))
            elif mode == "print":
                out.append('<%s fill="%s"/>' % (el, st["paper"]))
                if col:
                    out.append('<g transform="translate(%s %s)"><%s fill="%s"/></g>' % (st["off"][0], st["off"][1], el, col))
                out.append('<%s fill="none" stroke="%s" stroke-width="%s" stroke-linejoin="round" stroke-linecap="round"/>' % (el, st["line"], st["lw"]))
            else:
                out.append('<%s fill="%s" stroke="%s" stroke-width="%s" stroke-linejoin="round" stroke-linecap="round"/>' % (el, col or "none", st["line"], st["lw"]))
        elif k == "D":
            if col:
                out.append('<%s fill="%s"/>' % (el, col))
        else:
            if col:
                out.append('<%s fill="none" stroke="%s" stroke-width="%s" stroke-linecap="round" stroke-linejoin="round"/>' % (el, col, sh[3]))
    return "".join(out)


# ---------------------------------------------------------------- styles
A = {
    "mode": "flat",
    "pal": Pal(
        red="#E0452F", red_d="#B8321F", shade="rgba(140,28,16,.30)", hl="rgba(255,255,255,.40)",
        green="#3E8F5C", white="#FFFDF6", hat_line="#D5CDB9", hat_shade="#E9E2D0", ink="#16302B", blush="rgba(255,176,158,.80)",
        eye_hl="#FFFFFF", wood="#D8A268", wood_d="#B8804A", shadow="rgba(22,48,43,.16)",
        iron="#22332F", iron_l="#3A4E49", steel="#B4C1BC", steel_d="#8FA09A", oil="rgba(245,197,67,.55)",
        flame1="#F08A2C", flame2="#F5C543", gold="#DE9A45", gold_d="#A9661F", meat="#F3D3AC", tofu="#F4E8C8", tofu_d="#C9A45E",
        steam="rgba(22,48,43,.28)", yolk="#F5C543", eggwhite="#FFFDF6", steak="#9A5A3A", steak_d="#6E3B22",
        carrot="#F08A2C", leaf="#3E8F5C", bowl="#2C6A5F", olive="#C7B13A", paper="#FFFDF6", spruce="#1F4F47",
        glass="#22332F", water="#9CC7CF", fish="#7FB3BF", cheese="#F5C543",
    ),
}
B = {
    "mode": "print", "paper": "#FBFAF5", "line": "#1D3690", "lw": 2, "off": (2.5, 2),
    "pal": Pal(
        red="#E4472F", red_d="#E4472F", shade=None, hl=None,
        green="#93A5E3", white=None, hat_line="#1D3690", hat_shade=None, ink="#1D3690", blush=None,
        eye_hl="#FBFAF5", wood="#F1C232", wood_d="#F1C232", shadow=None,
        iron="#1D3690", iron_l="#4D63B5", steel=None, steel_d="#C9D1EE", oil="rgba(241,194,50,.7)",
        flame1="#E4472F", flame2="#F1C232", gold="#F1C232", gold_d="#E4472F", meat=None, tofu=None, tofu_d="#E4472F",
        steam="rgba(29,54,144,.45)", yolk="#F1C232", eggwhite=None, steak="#E4472F", steak_d="#1D3690",
        carrot="#E4472F", leaf="#1D3690", bowl="#C9D1EE", olive="#F1C232", paper=None, spruce="#1D3690",
        glass="#1D3690", water="#C9D1EE", fish="#C9D1EE", cheese="#F1C232",
    ),
}
C = {
    "mode": "outline", "line": "#3A2233", "lw": 2.2, "sticker": 9,
    "pal": Pal(
        red="#DE4B33", red_d="#C23C27", shade="rgba(110,20,30,.20)", hl="rgba(255,255,255,.45)",
        green="#7C9A3C", white="#FFFDF6", hat_line="#3A2233", hat_shade=None, ink="#3A2233", blush="rgba(255,180,160,.85)",
        eye_hl="#FFFFFF", wood="#E2A72E", wood_d="#C98A1E", shadow=None,
        iron="#4B5D66", iron_l="#6A7E88", steel="#C9D3D6", steel_d="#9FB0B5", oil="rgba(226,167,46,.55)",
        flame1="#E9792B", flame2="#F3C441", gold="#E7AE55", gold_d="#A9561F", meat="#F7DDB8", tofu="#FBF1D6", tofu_d="#C98A1E",
        steam="rgba(58,34,51,.38)", yolk="#F3C441", eggwhite="#FFFDF6", steak="#A4583A", steak_d="#3A2233",
        carrot="#E9792B", leaf="#7C9A3C", bowl="#2E7D7A", olive="#C7B13A", paper="#FFFDF6", spruce="#2E7D7A",
        glass="#4B5D66", water="#A9D3D6", fish="#7FB7C0", cheese="#F3C441",
    ),
}


# ---------------------------------------------------------------- Tomi
def _arm(sx, sy, ang, prop=None):
    t = 'transform="translate(%s %s) rotate(%s)"' % (sx, sy, ang)
    out = []
    if prop == "spoon":
        out.append(F('rect x="-2.3" y="16" width="4.6" height="30" rx="2.3" %s' % t, "wood"))
        out.append(F('ellipse cx="0" cy="50" rx="6.5" ry="9" %s' % t, "wood"))
    out.append(F('rect x="-4.5" y="-3" width="9" height="23" rx="4.5" %s' % t, "red_d"))
    out.append(F('circle cx="0" cy="21" r="6.2" %s' % t, "red_d"))
    return out


def tomi_shapes(mood="happy"):
    S = [D('ellipse cx="60" cy="121.5" rx="27" ry="4.5"', "shadow")]
    front = []
    if mood == "happy":
        S += _arm(25, 84, 30) + _arm(95, 80, -140)
    elif mood == "cheer":
        S += _arm(25, 80, 142) + _arm(95, 80, -142)
    elif mood == "tip":
        S += _arm(25, 84, 30) + _arm(95, 82, -128, "spoon")
    elif mood == "think":
        S += _arm(25, 84, 28)
        front = _arm(93, 106, 124)
    else:
        S += _arm(25, 84, 30) + _arm(95, 84, -30)
    S += [
        F('ellipse cx="46" cy="115.5" rx="10" ry="5.5"', "red_d"),
        F('ellipse cx="74" cy="115.5" rx="10" ry="5.5"', "red_d"),
        F('path d="M60 41C79 36 101 47 101 74C101 99 82 112 60 112C38 112 19 99 19 74C19 47 41 36 60 41Z"', "red"),
        D('path d="M19.6 81C24 100 40 112 60 112C81 112 97 100 100.4 81C94 96 79 104.5 60 104.5C41 104.5 26 96 19.6 81Z"', "shade"),
        D('ellipse cx="35" cy="59" rx="7" ry="4" transform="rotate(-34 35 59)"', "hl"),
        F('path d="M51 46C44 41 33 44 28 52C38 55 47 53 54 49Z"', "green"),
        F('path d="M69 45C77 40 88 43 92 51C83 54 74 52 66 48Z"', "green"),
        F('path d="M60 45C55.5 50 56.5 56 60 59.5C63.5 56 64.5 50 60 45Z"', "green"),
    ]
    hat = 'transform="translate(1 6) rotate(-8 60 30)"'
    S += [
        F('path d="M43 30C30 29 28 12 42 12C43 -2 77 -2 78 12C92 12 90 29 77 30Z" %s' % hat, "white"),
        D('path d="M43 30C38 29.6 34.6 26.6 33.6 22.6C38 26 46 27 60 27S82 26 86.4 22.6C85.4 26.6 82 29.6 77 30Z" %s' % hat, "hat_shade"),
        L('path d="M51 13.5q-2.5 7 -.5 13" %s' % hat, "hat_line", 1.6),
        L('path d="M69 13.5q2.5 7 .5 13" %s' % hat, "hat_line", 1.6),
        F('rect x="42.5" y="27" width="35" height="12.5" rx="3.5" %s' % hat, "white"),
    ]
    # faces
    def eye(cx, cy, rx=4.2, ry=5.6):
        return [D('ellipse cx="%s" cy="%s" rx="%s" ry="%s"' % (cx, cy, rx, ry), "ink"),
                D('circle cx="%s" cy="%s" r="1.5"' % (cx + 1.4, cy - 2.2), "eye_hl")]
    cheeks = [D('ellipse cx="35.5" cy="85" rx="6" ry="3.6"', "blush"), D('ellipse cx="84.5" cy="85" rx="6" ry="3.6"', "blush")]
    if mood == "happy":
        S += eye(47, 73) + eye(73, 73) + cheeks
        S += [D('path d="M51.5 84.5Q60 96 68.5 84.5Q60 88 51.5 84.5Z"', "ink")]
    elif mood == "cheer":
        S += cheeks
        S += [L('path d="M41.5 75q5.5 -7 11 0"', "ink", 3), L('path d="M67.5 75q5.5 -7 11 0"', "ink", 3),
              D('path d="M50 83Q60 99 70 83Q60 86.5 50 83Z"', "ink")]
    elif mood == "tip":
        S += eye(47, 73) + eye(73, 73) + cheeks
        S += [L('path d="M67 61.5q6 -4.5 12 -1"', "ink", 2.6), L('path d="M41 62.5q6 -2 12 0"', "ink", 2.6),
              D('path d="M52 85Q60 95 68 85Q60 88 52 85Z"', "ink")]
    elif mood == "think":
        S += eye(48.5, 71.5) + eye(74.5, 71.5) + cheeks
        S += [L('path d="M67.5 60q6 -4.5 12 -.5"', "ink", 2.6), L('path d="M41 63q5.5 -2.5 11 0"', "ink", 2.6),
              L('path d="M52.500 86.500q4.500 4 10 .5"', "ink", 3)]
    else:  # wow
        S += eye(47, 73, 5, 6.2) + eye(73, 73, 5, 6.2) + cheeks
        S += [L('path d="M40.5 62q6.5 -5 13 0"', "ink", 2.6), L('path d="M66.5 62q6.5 -5 13 0"', "ink", 2.6),
              D('ellipse cx="60" cy="90" rx="4.6" ry="5.6"', "ink")]
    return S + front


def tomi(st, mood="happy", size=96, cls="tomi", label=True):
    vb = "-22 -8 180 136" if mood == "tip" else ("-4 -8 128 136")
    w = size * (180 / 128.0) if mood == "tip" else size
    h = size * (136 / 128.0)
    aria = 'role="img" aria-label="Tomi the tomato chef, %s"' % mood if label else 'aria-hidden="true"'
    return '<svg class="%s" viewBox="%s" width="%.0f" height="%.0f" %s>%s</svg>' % (
        cls, vb, w, h, aria, render(tomi_shapes(mood), st, sticker=True))


def tomi_face(st, size=28):
    """Head only crop for small buttons."""
    return '<svg class="tomi-face" viewBox="14 0 92 100" width="%s" height="%.0f" aria-hidden="true">%s</svg>' % (
        size, size * 100 / 92.0, render([s for s in tomi_shapes("happy") if "translate(25" not in s[1] and "translate(95" not in s[1] and "121.5" not in s[1]], st))


# ---------------------------------------------------------------- step scene (sear)
def food_chicken():
    return [
        F('path d="M129 119C126 105 146 96 166 98C180 92 204 93 218 99C230 104 234 114 229 122C222 131 202 132 184 131C162 134 132 133 129 119Z"', "meat"),
        D('path d="M135 115C134 105 150 99 167 101C181 95 203 96 215 101C225 105 228 112 224 117C217 124 200 124 184 123C164 126 137 125 135 115Z"', "gold"),
        L('path d="M155 106l7 11"', "gold_d", 3.6), L('path d="M176 103l8 13"', "gold_d", 3.6), L('path d="M198 104l7 12"', "gold_d", 3.6),
    ]

def food_tofu():
    return [
        F('rect x="126" y="101" width="48" height="24" rx="4" transform="rotate(-4 150 113)"', "tofu"),
        L('path d="M131 124.5l40 -2.8"', "tofu_d", 3.5),
        F('rect x="184" y="100" width="48" height="24" rx="4" transform="rotate(4 208 112)"', "tofu"),
        L('path d="M188.5 121.5l40 2.8"', "tofu_d", 3.5),
    ]

def sear_shapes(food="chicken"):
    S = []
    # heat
    S += [D('rect x="92" y="189" width="174" height="9" rx="4.5"', "iron"),
          D('rect x="112" y="176" width="6" height="15" rx="2"', "iron"), D('rect x="240" y="176" width="6" height="15" rx="2"', "iron")]
    for x in (151, 179, 207):
        S.append(F('path d="M%s 189c-8 0 -11 -8 -6.5 -14.5c2.6 -4.4 5.4 -7 6.5 -12.5c2 5.4 6.4 8.2 7.4 13.6c1.6 7.4 -1.8 13.4 -7.4 13.4z"' % x, "flame1"))
        S.append(D('path d="M%s 187.5c-3.6 0 -5 -3.6 -3 -6.6c1.2 -2 2.4 -3.2 3 -5.6c0.9 2.4 2.9 3.7 3.4 6.2c0.7 3.3 -0.9 6 -3.4 6z"' % x, "flame2"))
    # vessel
    S += [
        F('rect x="264" y="119" width="82" height="12" rx="6" transform="rotate(-7 264 125)"', "iron"),
        F('path d="M88 128C90 150 104 161 124 161L234 161C254 161 268 150 270 128Z"', "iron"),
        F('ellipse cx="179" cy="127" rx="92" ry="21"', "iron"),
        D('ellipse cx="179" cy="126" rx="82" ry="15.5"', "iron_l"),
        D('ellipse cx="179" cy="128" rx="62" ry="9"', "oil"),
    ]
    # food
    S += food_tofu() if food == "tofu" else food_chicken()
    # motion
    for x, y in ((150, 84), (180, 76), (210, 86)):
        S.append(L('path d="M%s %sc-7 -7 7 -12 0 -20s7 -12 0 -20"' % (x, y), "steam", 4))
    for x, y in ((120, 112), (240, 110), (112, 122), (246, 121)):
        S.append(D('circle cx="%s" cy="%s" r="2.4"' % (x, y), "flame2"))
    return S


# ---------------------------------------------------------------- small food stickers (onboarding)
def food_icon(kind):
    if kind == "everything":   # drumstick
        return [F('path d="M11 9c6 -6 16 -5 20 1s3 14 -4 18c-5 3 -10 2 -13 -1l-5 5c-2 2 -6 -1 -4 -4l5 -5c-3 -4 -3 -10 1 -14z" transform="translate(0 0)"', "gold"),
                F('circle cx="6.5" cy="33.5" r="3.6"', "white"), F('circle cx="10.5" cy="36.5" r="3.6"', "white")]
    if kind == "vegetarian":   # carrot
        return [F('path d="M14 14c4 -3 10 -1 12 3c2 5 -6 14 -18 21c-2 1 -4 -1 -3 -3c5 -9 5 -18 9 -21z"', "carrot"),
                F('path d="M21 13c-2 -5 0 -9 3 -11c1 3 1 6 0 9c2 -3 6 -5 10 -4c-1 4 -5 7 -10 8z"', "leaf"),
                L('path d="M13 22l4 2M10 29l4 2"', "ink", 1.6)]
    if kind == "vegan":        # sprig
        return [L('path d="M20 37V12"', "ink", 2.2),
                F('path d="M20 13c-1 -6 3 -10 8 -11c1 6 -2 10 -8 11z"', "leaf"),
                F('path d="M20 23c-7 0 -12 -4 -13 -10c7 -1 12 3 13 10z"', "leaf"),
                F('path d="M20 30c1 -6 6 -9 12 -9c0 6 -5 10 -12 9z"', "leaf")]
    # fish
    return [F('path d="M4 20c5 -8 14 -10 22 -6l8 -6v24l-8 -6c-8 4 -17 2 -22 -6z"', "fish"),
            D('circle cx="12" cy="18" r="1.8"', "ink"), L('path d="M19 15.5q3 4.5 0 9"', "ink", 1.6)]


def food_svg(st, kind, size=40):
    return '<svg viewBox="0 0 40 40" width="%s" height="%s" aria-hidden="true">%s</svg>' % (size, size, render(food_icon(kind), st))


# ---------------------------------------------------------------- UI icons
ICONS = {
    "close": '<path d="M6 6l12 12M18 6L6 18"/>',
    "back": '<path d="M15 5l-7 7 7 7"/>',
    "arrow": '<path d="M5 12h14M13 6l6 6-6 6"/>',
    "speaker": '<path d="M4 9.5v5h3.5L12 18.5v-13L7.5 9.5z"/><path d="M15.5 9a4.2 4.2 0 0 1 0 6M18 6.5a7.8 7.8 0 0 1 0 11"/>',
    "mic": '<path d="M12 3.5a3 3 0 0 0-3 3v5a3 3 0 0 0 6 0v-5a3 3 0 0 0-3-3z"/><path d="M5.5 11.5a6.5 6.5 0 0 0 13 0M12 18v3"/>',
    "camera": '<path d="M4 8.5h3.2L8.8 6h6.4l1.6 2.5H20V19H4z"/><circle cx="12" cy="13.4" r="3.4"/>',
    "lock": '<path d="M7.5 11V8a4.5 4.5 0 0 1 9 0v3"/><rect x="5" y="11" width="14" height="9.5" rx="2"/>',
    "check": '<path d="M5 12.5l4.5 4.5L19 7.5"/>',
    "timer": '<circle cx="12" cy="13.5" r="7.5"/><path d="M12 13.5V9.5M9.5 3h5M12 3v3"/>',
    "chat": '<path d="M4.5 5.5h15v10.5h-8l-4.5 3.5V16H4.5z"/>',
    "play": '<path d="M8 5.5v13l10-6.5z"/>',
}

def icon(name, size=24, sw=2, color="currentColor", cap="round"):
    return ('<svg class="ic" viewBox="0 0 24 24" width="%s" height="%s" fill="none" stroke="%s" stroke-width="%s" '
            'stroke-linecap="%s" stroke-linejoin="%s" aria-hidden="true">%s</svg>') % (size, size, color, sw, cap, "round" if cap == "round" else "miter", ICONS[name])


# ---------------------------------------------------------------- data
SKILLS = [
    # id, name, blurb, unit, state, cooks, needs (short), recipes cooked
    ("knife", "Knife basics", "Dice, mince and slice safely", 0, "mastered", 2, "", ["Chopped Greek salad", "Garlic and chili greens"]),
    ("eggs", "Eggs 101", "Scramble, fry, soft-boil", 0, "mastered", 2, "", ["Soft scramble on toast", "Spinach and parmesan omelette"]),
    ("boil", "Boil & blanch", "Salted water, timing, shocking veg", 0, "progress", 1, "", ["Green beans, lemon butter"]),
    ("saute", "Sauté", "Hot pan, small pieces, keep it moving", 1, "ready", 0, "", []),
    ("sear", "Searing", "Dry surface, hot pan, hands off", 1, "mastered", 2, "", ["Crisp-skin chicken thighs", "Seared mushrooms on toast"]),
    ("rice", "Rice & grains", "Ratios, absorption, resting", 1, "locked", 0, "Boil & blanch", []),
    ("roast", "Roasting", "High oven heat, spacing, browning", 2, "ready", 0, "", []),
    ("pansauce", "Pan sauces", "Deglaze the fond, reduce, mount with butter", 2, "next", 0, "", []),
    ("emulsion", "Emulsions", "Vinaigrettes, mayo, why they hold", 2, "ready", 0, "", []),
    ("pasta", "Pasta & starch water", "Al dente, glossy sauces", 3, "locked", 0, "Boil & blanch, Sauté", []),
    ("braise", "Braising", "Low and slow in liquid", 3, "locked", 0, "Roasting", []),
    ("balance", "Balancing flavor", "Salt, acid, fat, heat, sweet", 3, "locked", 0, "Pan sauces, Emulsions", []),
]
UNITS = [
    ("Foundations", "Knife, eggs and water"),
    ("Heat control", "Make the pan work for you"),
    ("Building flavor", "Browning, sauces, emulsions"),
    ("Putting it together", "Cook without a recipe"),
]
SK = {s[0]: s for s in SKILLS}

LESSON = "Seared chicken thighs with lemon-butter pan sauce"
STEP1 = "Pat 4 chicken thighs dry and salt both sides. <b>Sear skin-side down</b> in a hot pan with a little oil for 7 to 8 minutes, <b>without moving them</b>."
TIP1 = "Dry skin browns. Wet skin steams."
DIETS = [
    ("everything", "Everything", "Meat, fish, the lot"),
    ("vegetarian", "Vegetarian", "No meat or fish"),
    ("vegan", "Vegan", "Plants only"),
    ("pescatarian", "Pescatarian", "Fish, but no meat"),
]


def statusbar(color):
    return ('<div class="sb" style="color:%s" aria-hidden="true"><span class="sb-t">18:42</span><span class="sb-i"></span>'
            '<span class="sb-r"><svg viewBox="0 0 18 12" width="18" height="12"><rect x="0" y="8" width="3" height="4" rx="1" fill="currentColor"/><rect x="5" y="5.5" width="3" height="6.5" rx="1" fill="currentColor"/><rect x="10" y="3" width="3" height="9" rx="1" fill="currentColor"/><rect x="15" y="0" width="3" height="12" rx="1" fill="currentColor"/></svg>'
            '<svg viewBox="0 0 27 13" width="27" height="13"><rect x=".5" y=".5" width="23" height="12" rx="3.5" fill="none" stroke="currentColor" opacity=".45"/><rect x="2" y="2" width="16" height="9" rx="2" fill="currentColor"/><rect x="25" y="4.5" width="2" height="4" rx="1" fill="currentColor" opacity=".45"/></svg></span></div>') % color


def phone(id_, code, title, note, screen_cls, body, sb_color, height=None):
    style = ' style="height:%spx"' % height if height else ""
    return ('<figure class="shot" id="%s"><figcaption><span class="code">%s</span><b>%s</b><span class="cap-note">%s</span></figcaption>'
            '<div class="phone"><div class="screen %s"%s>%s%s<div class="hb" aria-hidden="true"></div></div></div></figure>') % (
                id_, code, title, note, screen_cls, style, statusbar(sb_color), body)
