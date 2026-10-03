# Direction A - Tomi's kitchen. Cut-paper kitchen scene, enamel palette.
from common import *

LOCK = {"mode": "flat", "pal": LockPal("#CDD8D1", "#B9C7BF")}
INK = "#16302B"

CSS = r"""
/* ============ A: Tomi's kitchen ============ */
.a-screen{--wall:#E9EFEA;--line:#D7E1DA;--ink:#16302B;--muted:#40574F;--spruce:#1F4F47;--butter:#F5C543;--tomato:#D23B25;--paper:#FFFDF6;--wood:#D8A268;
  background:var(--wall);color:var(--ink);font-family:"Instrument Sans",system-ui,-apple-system,"Helvetica Neue",Arial,sans-serif;font-size:15px;line-height:1.35}
.a-d{font-family:"Bricolage Grotesque","Instrument Sans",system-ui,sans-serif;font-variation-settings:"opsz" 40;letter-spacing:-.01em}
.a-tiles{background-color:var(--wall);background-image:linear-gradient(var(--line) 1px,transparent 1px),linear-gradient(90deg,var(--line) 1px,transparent 1px);background-size:30px 30px;background-position:-1px -1px}
.a-head{padding:66px 20px 18px;display:flex;flex-direction:column;gap:4px}
.a-eyebrow{margin:0;font-size:13px;font-weight:600;color:var(--muted)}
.a-head h1{margin:0;font-size:30px;line-height:34px;font-weight:800}
.a-stats{display:grid;grid-template-columns:1fr 1fr;margin-top:14px}
.a-stat{display:flex;align-items:center;gap:10px;min-width:0}
.a-stat + .a-stat{padding-left:16px;border-left:1.5px solid #C9D5CD}
.a-stat svg{flex:none}
.a-stat b{display:block;font-size:14.5px;line-height:18px;font-weight:700}
.a-stat span{display:block;font-size:12.5px;line-height:16px;color:var(--muted);font-weight:500}
.a-scene{position:relative;width:390px}
.a-scene > svg{position:absolute;inset:0;display:block}
.a-note{position:absolute;left:150px;top:14px;width:224px;background:var(--paper);border-radius:6px 6px 18px 6px;padding:20px 14px 14px;transform:rotate(-1.2deg);box-shadow:0 10px 18px -12px rgba(22,48,43,.55),0 1px 0 rgba(22,48,43,.08);display:flex;flex-direction:column;gap:6px}
.a-note::before{content:"";position:absolute;left:50%;top:-9px;width:62px;height:20px;margin-left:-31px;background:rgba(245,197,67,.86);transform:rotate(2.5deg)}
.a-note .k{margin:0;font-size:12px;font-weight:700;color:#B02E1C}
.a-note h2{margin:0;font-size:17.5px;line-height:21px;font-weight:700}
.a-note .m{margin:0 0 4px;font-size:12.5px;line-height:16px;color:var(--muted);font-weight:500}
.a-btn{display:flex;align-items:center;justify-content:center;gap:8px;min-height:56px;padding:0 24px;border-radius:999px;border:0;background:var(--tomato);color:#fff;font:700 17px/1 "Bricolage Grotesque","Instrument Sans",sans-serif;letter-spacing:0}
.a-btn.sm{min-height:44px;font-size:15.5px;padding:0 16px}
.a-btn.sec{background:var(--paper);color:var(--spruce);box-shadow:inset 0 0 0 1.5px var(--spruce)}
.a-fridge-hit{position:absolute;left:18px;top:28px;width:118px;height:340px;border-radius:22px}
.a-scan{position:absolute;left:26px;top:152px;width:88px;background:var(--paper);border-radius:4px;padding:8px 6px 9px;text-align:center;font:700 13.5px/16px "Bricolage Grotesque","Instrument Sans",sans-serif;transform:rotate(-3deg);box-shadow:0 4px 8px -5px rgba(22,48,43,.5)}
.a-scan small{display:block;font:500 11.5px/14px "Instrument Sans",sans-serif;color:var(--muted);margin-top:2px}
.a-tag{position:absolute;transform:translateX(-50%);background:var(--paper);border-radius:9px;padding:5px 6px 6px;text-align:center;box-shadow:0 1px 0 rgba(22,48,43,.14);display:flex;flex-direction:column;align-items:center;gap:1px;min-height:38px;justify-content:center}
.a-tag b{font-size:13px;line-height:15px;font-weight:700;text-wrap:balance}
.a-tag .st{display:inline-flex;align-items:center;gap:4px;font-size:11.5px;line-height:14px;font-weight:600;color:var(--muted);white-space:nowrap}
.a-tag.locked{background:transparent;box-shadow:inset 0 0 0 1.5px #B9C7BF;color:var(--muted)}
.a-tag.locked b{font-weight:600}
.a-tag.next{box-shadow:0 0 0 2px var(--tomato)}
.a-tag.next .st{color:#B02E1C}
.a-flag{position:absolute;transform:translateX(-50%);background:var(--tomato);color:#fff;font:700 12px/22px "Instrument Sans",sans-serif;padding:0 9px;border-radius:7px;white-space:nowrap}
.a-flag::after{content:"";position:absolute;left:50%;bottom:-5px;margin-left:-5px;border:5px solid transparent;border-top-color:var(--tomato);border-bottom:0}
/* step */
.a-top{display:flex;align-items:center;gap:10px;padding:58px 12px 0 8px}
.a-ib{width:44px;height:44px;border-radius:50%;display:grid;place-items:center;flex:none;color:var(--ink)}
.a-ib.on{background:var(--paper);color:var(--spruce)}
.a-prog{flex:1;display:grid;grid-template-columns:repeat(6,1fr);gap:5px}
.a-prog i{height:6px;border-radius:3px;background:#C9D5CD}
.a-prog i.on{background:var(--tomato)}
.a-body{padding:6px 16px 0;display:flex;flex-direction:column;gap:16px}
.a-kick{margin:0;font-size:13px;font-weight:700;color:var(--muted)}
.a-illo{border-radius:26px;overflow:hidden;height:232px;position:relative}
.a-illo svg{display:block;width:100%;height:100%}
.a-steptext{margin:0;font-size:20px;line-height:27px;font-weight:500;letter-spacing:-.005em}
.a-steptext b{font-weight:700}
.a-timer{display:flex;align-items:center;gap:12px;background:var(--paper);border-radius:22px;padding:10px 10px 10px 16px}
.a-timer .t{font:800 36px/40px "Bricolage Grotesque",sans-serif;font-variant-numeric:tabular-nums;letter-spacing:-.01em}
.a-timer .l{flex:1;min-width:0;font-size:12.5px;line-height:15px;color:var(--muted);font-weight:500}
.a-tip{display:flex;align-items:flex-end;gap:6px}
.a-tip .who{flex:none;width:92px;height:74px;position:relative}
.a-tip .who svg{position:absolute;left:-12px;bottom:-4px}
.a-bub{text-wrap:balance;flex:1;min-width:0;background:var(--butter);border-radius:18px 18px 18px 4px;padding:10px 14px 11px;font-size:15.5px;line-height:20px;font-weight:600}
.a-bub small{display:block;font-size:12px;line-height:15px;font-weight:700;color:#5E4300}
.a-foot{position:absolute;left:0;right:0;bottom:0;padding:0 16px 34px;display:flex;flex-direction:column;gap:10px}
.a-ask{display:flex;align-items:center;gap:8px;height:52px;border-radius:26px;background:var(--paper);padding:0 4px 0 6px;font-size:15px;color:var(--muted);font-weight:500;box-shadow:inset 0 0 0 1.5px #C9D5CD}
.a-ask span{flex:1}
.a-ask .face{width:36px;height:36px;border-radius:50%;background:var(--butter);overflow:hidden;display:flex;justify-content:center;align-items:flex-start;padding-top:3px;flex:none}
.a-ask .mic{width:44px;height:44px;border-radius:22px;background:var(--spruce);color:#fff;display:grid;place-items:center}
.a-nav{display:flex;gap:10px}
.a-nav .a-btn{flex:1}
.a-round{width:56px;height:56px;border-radius:50%;background:var(--paper);box-shadow:inset 0 0 0 1.5px var(--spruce);color:var(--spruce);display:grid;place-items:center;flex:none}
/* onboarding */
.a-ob-top{display:flex;align-items:center;gap:14px;padding:66px 20px 0}
.a-ob-top .n{font-size:13px;font-weight:700;color:var(--muted);white-space:nowrap}
.a-ob-prog{flex:1;display:grid;grid-template-columns:repeat(4,1fr);gap:5px}
.a-ob-prog i{height:6px;border-radius:3px;background:#C9D5CD}
.a-ob-prog i.on{background:var(--tomato)}
.a-ob-scene{position:relative;height:200px;margin-top:14px}
.a-ob-scene > svg.bg{position:absolute;inset:0}
.a-ob-scene .tomi{position:absolute;left:26px;top:44px}
.a-ob-bub{position:absolute;left:158px;top:34px;width:204px;background:var(--paper);border-radius:18px 18px 18px 4px;padding:12px 14px;font-size:15.5px;line-height:20px;font-weight:600;box-shadow:0 8px 14px -12px rgba(22,48,43,.6)}
.a-ob-body{padding:20px 16px 0;display:flex;flex-direction:column;gap:10px}
.a-ob-body h1{margin:0 4px;font-size:32px;line-height:36px;font-weight:800}
.a-ob-body p.sub{margin:0 4px 6px;font-size:15px;line-height:20px;color:var(--muted)}
.a-opt{display:flex;align-items:center;gap:12px;min-height:66px;padding:0 16px 0 12px;background:var(--paper);border-radius:20px;box-shadow:inset 0 0 0 1.5px #D3DDD5}
.a-opt .fi{width:44px;height:44px;border-radius:14px;background:var(--wall);display:grid;place-items:center;flex:none}
.a-opt b{display:block;font:700 17px/21px "Bricolage Grotesque",sans-serif}
.a-opt span.d{display:block;font-size:13px;line-height:16px;color:var(--muted)}
.a-opt .tx{flex:1;min-width:0}
.a-opt .rd{width:26px;height:26px;border-radius:50%;box-shadow:inset 0 0 0 2px #9DB0A6;flex:none;display:grid;place-items:center;color:#fff}
.a-opt.sel{box-shadow:inset 0 0 0 2.5px var(--spruce);background:#F3F8F0}
.a-opt.sel .rd{background:var(--spruce);box-shadow:none}
.a-chip{display:inline-flex;align-items:center;gap:6px;height:32px;padding:0 12px 0 10px;border-radius:16px;background:var(--paper);font-size:14px;font-weight:600;box-shadow:inset 0 0 0 1.5px #C9D5CD}
.a-chip i{width:8px;height:8px;border-radius:50%;background:var(--butter)}
.a-card{background:var(--paper);border-radius:22px;padding:14px 16px}
"""


# ---------------------------------------------------------------- kitchen objects
def pan(cx, by, kind=None, flame=False):
    S = []
    if flame:
        for dx in (-13, 0, 13):
            S.append(F('path d="M%s %sc-4.6 0 -6.2 -4.6 -3.6 -8.2c1.4 -2.4 3 -3.8 3.6 -6.8c1.2 3 3.6 4.4 4.2 7.4c.8 4 -1 7.6 -4.2 7.6z"' % (cx + dx, by + 9.5), "flame1"))
            S.append(D('path d="M%s %sc-2 0 -2.8 -2 -1.6 -3.6c.6 -1 1.3 -1.7 1.6 -3c.5 1.3 1.6 2 1.9 3.3c.4 1.8 -.5 3.3 -1.9 3.3z"' % (cx + dx, by + 8.5), "flame2"))
    S += [
        F('rect x="%s" y="%s" width="32" height="5.5" rx="2.75" transform="rotate(-10 %s %s)"' % (cx + 24, by - 17, cx + 24, by - 14), "iron"),
        F('path d="M%s %sC%s %s %s %s %s %sL%s %sC%s %s %s %s %s %sZ"' % (cx - 28, by - 13, cx - 27, by - 4, cx - 22, by, cx - 14, by, cx + 14, by, cx + 22, by, cx + 27, by - 4, cx + 28, by - 13), "iron"),
        F('ellipse cx="%s" cy="%s" rx="28" ry="7"' % (cx, by - 13), "iron"),
        D('ellipse cx="%s" cy="%s" rx="24" ry="4.8"' % (cx, by - 13.5), "iron_l"),
    ]
    if kind == "egg":
        S += [D('ellipse cx="%s" cy="%s" rx="15.5" ry="4.2"' % (cx - 1, by - 14), "eggwhite"),
              D('ellipse cx="%s" cy="%s" rx="5.2" ry="2.6"' % (cx + 2, by - 15), "yolk")]
    elif kind == "saute":
        for dx, dy, key, r in ((-11, -15, "leaf", 20), (-2, -13, "carrot", -15), (8, -15, "yolk", 30), (-6, -31, "carrot", 40), (7, -36, "leaf", -20), (15, -27, "yolk", 10)):
            S.append(D('rect x="%s" y="%s" width="6.5" height="6.5" rx="1.6" transform="rotate(%s %s %s)"' % (cx + dx - 3, by + dy - 3, r, cx + dx, by + dy), key))
        S.append(L('path d="M%s %sq-4 -6 -1 -12"' % (cx - 15, by - 22), "steam", 2.5))
        S.append(L('path d="M%s %sq4 -6 1 -12"' % (cx + 22, by - 24), "steam", 2.5))
    elif kind == "steak":
        S += [F('path d="M%s %sc0 -5 8 -7.5 15 -6.5s14.5 1.5 13.5 6.500s-8 5 -14.500 5s-14 0 -14 -5z"' % (cx - 14, by - 15.5), "steak"),
              L('path d="M%s %sl4 5M%s %sl4 5"' % (cx - 5, by - 19.5, cx + 3, by - 20), "steak_d", 2)]
    elif kind == "sauce":
        S += [D('ellipse cx="%s" cy="%s" rx="19" ry="3.6"' % (cx, by - 13.5), "gold"),
              L('path d="M%s %sL%s %s"' % (cx - 8, by - 15, cx - 23, by - 42), "wood", 4.5),
              L('path d="M%s %sc-4 -5 4 -8 0 -13"' % (cx + 2, by - 26), "steam", 2.5),
              L('path d="M%s %sc-4 -5 4 -8 0 -13"' % (cx + 13, by - 22), "steam", 2.5)]
    return S


def saucepan(cx, by):
    return [
        F('rect x="%s" y="%s" width="34" height="6" rx="3"' % (cx + 24, by - 26), "iron"),
        F('path d="M%s %sh54v22q0 8 -8 8h-38q-8 0 -8 -8z"' % (cx - 27, by - 30), "steel"),
        F('ellipse cx="%s" cy="%s" rx="27" ry="5.5"' % (cx, by - 30), "steel_d"),
        D('ellipse cx="%s" cy="%s" rx="23" ry="3.6"' % (cx, by - 30), "water"),
        D('circle cx="%s" cy="%s" r="2.2"' % (cx - 9, by - 30.5), "paper"), D('circle cx="%s" cy="%s" r="1.6"' % (cx + 4, by - 29.5), "paper"), D('circle cx="%s" cy="%s" r="2"' % (cx + 12, by - 31), "paper"),
        L('path d="M%s %sc-5 -5 5 -9 0 -15"' % (cx - 8, by - 40), "steam", 2.6),
        L('path d="M%s %sc-5 -5 5 -9 0 -15"' % (cx + 8, by - 44), "steam", 2.6),
    ]


def ricepot(cx, by):
    return [
        F('rect x="%s" y="%s" width="9" height="6" rx="3"' % (cx - 34, by - 22), "iron"),
        F('rect x="%s" y="%s" width="9" height="6" rx="3"' % (cx + 25, by - 22), "iron"),
        F('path d="M%s %sh54v18q0 8 -8 8h-38q-8 0 -8 -8z"' % (cx - 27, by - 26), "steel"),
        F('path d="M%s %sq2 -13 29 -13t29 13z"' % (cx - 29, by - 26), "steel_d"),
        F('circle cx="%s" cy="%s" r="4"' % (cx, by - 41), "iron"),
    ]


def stockpot(cx, by):
    S = [L('path d="M%s %sL%s %s"' % (cx + dx, by - 42, cx + dx * 2.6, by - 62), "yolk", 2.4) for dx in (-6, -2, 2, 6)]
    return S + [
        F('rect x="%s" y="%s" width="9" height="6" rx="3"' % (cx - 31, by - 34), "iron"),
        F('rect x="%s" y="%s" width="9" height="6" rx="3"' % (cx + 22, by - 34), "iron"),
        F('path d="M%s %sh48v38q0 6 -6 6h-36q-6 0 -6 -6z"' % (cx - 24, by - 44), "steel"),
        F('ellipse cx="%s" cy="%s" rx="24" ry="5"' % (cx, by - 44), "steel_d"),
    ]


def emulsion(cx, by):
    return [
        F('rect x="%s" y="%s" width="7" height="14" rx="1.5"' % (cx - 46.5, by - 47), "olive"),
        F('rect x="%s" y="%s" width="18" height="35" rx="5"' % (cx - 52, by - 35), "olive"),
        D('rect x="%s" y="%s" width="10" height="5.5" rx="1.5"' % (cx - 48, by - 52), "iron"),
        D('rect x="%s" y="%s" width="18" height="12"' % (cx - 52, by - 24), "paper"),
        L('path d="M%s %sL%s %s"' % (cx + 18, by - 27, cx + 40, by - 62), "steel_d", 4),
        L('path d="M%s %sc-9 3 -12 -5 -8 -11M%s %sc-4 5 -12 2 -12 -7M%s %sc0 6 -8 8 -13 2"' % (cx + 18, by - 27, cx + 18, by - 27, cx + 18, by - 27), "steel_d", 2),
        F('path d="M%s %sh56q-1 25 -28 25t-28 -25z"' % (cx - 18, by - 25), "bowl"),
        F('ellipse cx="%s" cy="%s" rx="28" ry="5.5"' % (cx + 10, by - 25), "bowl"),
        D('ellipse cx="%s" cy="%s" rx="24" ry="3.8"' % (cx + 10, by - 25), "yolk"),
    ]


def balance(cx, by):
    return [
        F('path d="M%s %sh16l-2 -15q-3 -6 0 -12l2 -9h-16l2 9q3 6 0 12z"' % (cx - 46, by), "wood_d"),
        F('circle cx="%s" cy="%s" r="5.5"' % (cx - 38, by - 41), "wood_d"),
        F('rect x="%s" y="%s" width="30" height="22" rx="6"' % (cx - 15, by - 22), "paper"),
        F('rect x="%s" y="%s" width="34" height="8" rx="4"' % (cx - 17, by - 28), "wood"),
        F('circle cx="%s" cy="%s" r="3"' % (cx + 52, by - 12), "yolk"),
        F('ellipse cx="%s" cy="%s" rx="16" ry="12"' % (cx + 37, by - 12), "yolk"),
    ]


def board(by):
    return [
        F('rect x="250" y="%s" width="126" height="10" rx="4"' % (by - 10), "wood_d"),
        # carrot
        F('path d="M262 %sc0 -6 6 -9 12 -8l34 5c4 1 4 5 0 6l-34 5c-6 1 -12 -2 -12 -8z"' % (by - 18), "carrot"),
        F('path d="M263 %sc-6 -3 -10 -8 -9 -13c4 1 8 4 10 8c-1 -5 0 -9 3 -12c3 4 3 9 1 14z"' % (by - 20), "leaf"),
        D('circle cx="312" cy="%s" r="5.5"' % (by - 15.5), "carrot"), D('circle cx="312" cy="%s" r="2.2"' % (by - 15.5), "yolk"),
        D('circle cx="324" cy="%s" r="5.5"' % (by - 15.5), "carrot"), D('circle cx="324" cy="%s" r="2.2"' % (by - 15.5), "yolk"),
        # knife
        F('path d="M318 %sL354 %sC358 %s 359 %s 356 %sL334 %sZ"' % (by - 23, by - 58, by - 52, by - 44, by - 38, by - 21), "steel"),
        F('rect x="-5" y="-26" width="10" height="27" rx="4" transform="translate(359 %s) rotate(44)"' % (by - 56), "iron"),
    ]


def tray(cx, cy):
    S = [L('path d="M%s %sh104"' % (cx - 52, cy + 22), "iron_l", 2.5),
         F('rect x="%s" y="%s" width="92" height="8" rx="4"' % (cx - 46, cy + 12), "iron")]
    for dx, key, r in ((-30, "carrot", 7), (-14, "leaf", 6), (2, "red", 7.5), (18, "carrot", 6), (32, "leaf", 6.5)):
        S.append(D('circle cx="%s" cy="%s" r="%s"' % (cx + dx, cy + 12 - r + 1.5, r), key))
    return S


def dutch(cx, cy):
    return [
        L('path d="M%s %sh104"' % (cx - 52, cy + 22), "iron_l", 2.5),
        F('rect x="%s" y="%s" width="10" height="7" rx="3.5"' % (cx - 42, cy - 4), "red_d"),
        F('rect x="%s" y="%s" width="10" height="7" rx="3.5"' % (cx + 32, cy - 4), "red_d"),
        F('path d="M%s %sh66v22q0 8 -8 8h-50q-8 0 -8 -8z"' % (cx - 33, cy - 8), "red"),
        F('path d="M%s %sq3 -12 35 -12t35 12z"' % (cx - 35, cy - 8), "red_d"),
        F('circle cx="%s" cy="%s" r="4.5"' % (cx, cy - 23), "iron"),
    ]


def badge(state, cooks=0, needs=""):
    if state == "mastered":
        return ('<svg viewBox="0 0 14 14" width="14" height="14" aria-hidden="true"><circle cx="7" cy="7" r="7" fill="#F5C543"/>'
                '<path d="M3.8 7.3l2.2 2.2 4.2 -4.6" fill="none" stroke="#16302B" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/></svg>Mastered')
    pips = lambda n: ('<svg viewBox="0 0 22 10" width="22" height="10" aria-hidden="true">'
                      '<circle cx="5" cy="5" r="4" fill="%s" stroke="#16302B" stroke-width="1.5"/>'
                      '<circle cx="17" cy="5" r="4" fill="%s" stroke="#16302B" stroke-width="1.5"/></svg>') % (
                          "#16302B" if n > 0 else "none", "#16302B" if n > 1 else "none")
    if state == "progress":
        return pips(cooks) + "%s of 2 cooks" % cooks
    if state == "ready":
        return pips(0) + "Ready"
    if state == "next":
        return pips(0) + "Tonight"
    return icon("lock", 12, 2.2) + "Needs " + needs


def tag(sid, cx, top, w, needs=None):
    s = SK[sid]
    st = s[4]
    cls = {"locked": " locked", "next": " next"}.get(st, "")
    return '<div class="a-tag%s" style="left:%spx;top:%spx;width:%spx"><b>%s</b><span class="st">%s</span></div>' % (
        cls, cx, top, w, s[1], badge(st, s[5], needs or s[6]))


def lit(sid):
    return LOCK if SK[sid][4] == "locked" else A


def cal_svg():
    return ('<svg viewBox="0 0 40 44" width="40" height="44" aria-hidden="true"><rect x="2" y="5" width="36" height="37" rx="7" fill="#FFFDF6"/>'
            '<path d="M2 12a7 7 0 0 1 7 -7h22a7 7 0 0 1 7 7v4H2z" fill="#D23B25"/><rect x="11" y="1" width="4" height="9" rx="2" fill="#16302B"/><rect x="25" y="1" width="4" height="9" rx="2" fill="#16302B"/>'
            '<text x="20" y="36" text-anchor="middle" font-family="Bricolage Grotesque, sans-serif" font-weight="800" font-size="21" fill="#16302B">3</text></svg>')


def jug_svg():
    return ('<svg viewBox="0 0 40 44" width="40" height="44" aria-hidden="true">'
            '<path d="M29 12h4a5 5 0 0 1 5 5v8a5 5 0 0 1 -5 5h-4" fill="none" stroke="#8FA09A" stroke-width="3.5"/>'
            '<path d="M4 4h27l-1.500 34a4 4 0 0 1 -4 4h-16a4 4 0 0 1 -4 -4z" fill="#FFFDF6"/>'
            '<path d="M5 15.500h25l-1 22.500a4 4 0 0 1 -4 4h-15a4 4 0 0 1 -4 -4z" fill="#F5C543"/>'
            '<path d="M23 12h6M25 19h4.500M23 26h6M25 33h4" stroke="#16302B" stroke-width="1.6" stroke-linecap="round"/></svg>')


def scene():
    o = []   # svg
    h = []   # html overlays
    W = 390
    CT = 308
    Y0 = 402
    SY = Y0 + 408
    H = SY + 268
    r = lambda sh, st=A: render(sh, st)
    # ---- wall 1
    o.append('<rect x="0" y="0" width="390" height="%s" fill="none"/>' % H)
    # fridge
    o.append('<ellipse cx="77" cy="%s" rx="66" ry="5" fill="rgba(22,48,43,.14)"/>' % (CT + 69))
    o.append('<rect x="30" y="%s" width="14" height="10" rx="2" fill="#16302B"/><rect x="110" y="%s" width="14" height="10" rx="2" fill="#16302B"/>' % (CT + 58, CT + 58))
    o.append('<rect x="18" y="28" width="118" height="%s" rx="22" fill="#F5C543"/>' % (CT + 60 - 28))
    o.append('<path d="M122 28h-8a22 22 0 0 1 22 22v%sa22 22 0 0 1 -22 22h8z" fill="none"/>' % (CT - 34))
    o.append('<rect x="18" y="228" width="118" height="4" fill="#D9A521"/>')
    o.append('<rect x="118" y="92" width="8" height="78" rx="4" fill="#FFFDF6"/><rect x="118" y="246" width="8" height="46" rx="4" fill="#FFFDF6"/>')
    o.append('<circle cx="72" cy="104" r="40" fill="rgba(255,253,246,.42)"/><circle cx="72" cy="104" r="31" fill="#D23B25"/>')
    o.append('<g transform="translate(57 89)" fill="none" stroke="#fff" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><path d="M3 8h5l2.500 -4h9L22 8h5v15H3z"/><circle cx="15" cy="15" r="4.600"/></g>')
    # magnets on freezer door
    o.append('<circle cx="42" cy="262" r="7" fill="#1F4F47"/><rect x="58" y="252" width="34" height="26" rx="3" fill="#FFFDF6" transform="rotate(4 75 265)"/>'
             '<path d="M63 272l8 -9 6 6 4 -4 7 8z" fill="#3E8F5C" transform="rotate(4 75 265)"/><circle cx="85" cy="259" r="3" fill="#D23B25" transform="rotate(4 75 265)"/>')
    # counter
    o.append('<rect x="144" y="%s" width="246" height="48" fill="#1F4F47"/>' % (CT + 12))
    o.append('<rect x="232" y="%s" width="2" height="48" fill="#163B35"/><rect x="160" y="%s" width="56" height="5" rx="2.500" fill="#8FA09A"/>' % (CT + 12, CT + 24))
    o.append('<rect x="144" y="%s" width="246" height="8" fill="#16302B"/>' % (CT + 60))
    o.append('<rect x="136" y="%s" width="254" height="12" fill="#D8A268"/><rect x="136" y="%s" width="254" height="3.500" fill="#E7BC88"/>' % (CT, CT))
    o.append(r(board(CT)))
    # floor 1
    for i in range(15):
        o.append('<rect x="%s" y="%s" width="26" height="26" fill="%s"/>' % (i * 26, CT + 68, "#C6D2CA" if i % 2 else "#D6DFD8"))
    o.append('<rect x="0" y="%s" width="390" height="2" fill="#B9C7BF"/>' % (CT + 68))
    h.append('<div class="a-fridge-hit" role="button" aria-label="Scan your fridge"></div>')
    h.append('<div class="a-scan">Scan your fridge<small>Last scan 18:20</small></div>')
    h.append('<div class="a-note"><p class="k">Tonight\'s lesson</p><h2 class="a-d">%s</h2><p class="m">Pan sauces &middot; 30 min &middot; +40 XP</p>'
             '<div class="a-btn sm" role="button">Start cooking</div></div>' % LESSON)
    h.append('<div style="position:absolute;left:150px;top:%spx">%s</div>' % (CT - 87, tomi(A, "happy", 86)))
    h.append(tag("knife", 313, CT + 17, 132))

    # ---- wall 2
    # top shelf
    sy1 = Y0 + 92
    o.append('<rect x="18" y="%s" width="354" height="8" rx="2" fill="#D8A268"/><rect x="18" y="%s" width="354" height="2.500" rx="1" fill="#E7BC88"/>' % (sy1, sy1))
    o.append(r(emulsion(100, sy1), lit("emulsion")))
    o.append(r(balance(276, sy1), lit("balance")))
    h.append(tag("emulsion", 98, sy1 + 14, 136))
    h.append(tag("balance", 276, sy1 + 14, 192))
    # pot shelf
    sy2 = Y0 + 236
    o.append('<rect x="18" y="%s" width="354" height="8" rx="2" fill="#D8A268"/><rect x="18" y="%s" width="354" height="2.500" rx="1" fill="#E7BC88"/>' % (sy2, sy2))
    o.append(r(saucepan(74, sy2), lit("boil")))
    o.append(r(ricepot(195, sy2), lit("rice")))
    o.append(r(stockpot(314, sy2), lit("pasta")))
    h.append(tag("boil", 78, sy2 + 14, 112))
    h.append(tag("rice", 195, sy2 + 14, 112, "Boil"))
    h.append(tag("pasta", 312, sy2 + 14, 116, "Boil, Sauté"))
    # range
    o.append('<ellipse cx="195" cy="%s" rx="186" ry="5" fill="rgba(22,48,43,.14)"/>' % (SY + 243))
    o.append('<rect x="34" y="%s" width="16" height="10" rx="2" fill="#16302B"/><rect x="340" y="%s" width="16" height="10" rx="2" fill="#16302B"/>' % (SY + 232, SY + 232))
    o.append('<path d="M18 %sh354v218a10 10 0 0 1 -10 10h-334a10 10 0 0 1 -10 -10z" fill="#FFFDF6"/>' % (SY + 8))
    o.append('<rect x="14" y="%s" width="362" height="12" rx="4" fill="#16302B"/>' % SY)
    xs = [62, 150.5, 239, 327.5]
    kinds = [("eggs", "egg"), ("saute", "saute"), ("sear", "steak"), ("pansauce", "sauce")]
    for x, (sid, kind) in zip(xs, kinds):
        o.append('<path d="M%s %sv-8M%s %sv-8M%s %sh44" stroke="#16302B" stroke-width="3" stroke-linecap="round" fill="none"/>' % (x - 20, SY, x + 20, SY, x - 22, SY - 8))
        o.append(r(pan(x - 4, SY - 9.5, kind, flame=(sid == "pansauce")), lit(sid)))
        on = SK[sid][4] in ("next",)
        o.append('<circle cx="%s" cy="%s" r="9" fill="#1F4F47"/><path d="M%s %s%s" stroke="#FFFDF6" stroke-width="2.600" stroke-linecap="round"/>' % (
            x, SY + 28, x, SY + 28, "l5 -5" if on else "v-6"))
        if on:
            o.append('<circle cx="%s" cy="%s" r="13" fill="none" stroke="#D23B25" stroke-width="2"/>' % (x, SY + 28))
    for x, sid in zip(xs, ["eggs", "saute", "sear", "pansauce"]):
        h.append(tag(sid, x, SY + 46, 84))
    h.append('<div class="a-flag" style="left:%spx;top:%spx">Next up</div>' % (323.5, SY - 86))
    # oven
    oy = SY + 92
    o.append('<rect x="18" y="%s" width="354" height="2" fill="#E6E0CF"/>' % (oy - 2))
    o.append('<rect x="40" y="%s" width="310" height="6" rx="3" fill="#8FA09A"/>' % (oy + 8))
    for x0, sid, fn in ((30, "roast", tray), (201, "braise", dutch)):
        is_lit = SK[sid][4] != "locked"
        o.append('<rect x="%s" y="%s" width="159" height="62" rx="12" fill="%s"/>' % (x0, oy + 22, "#F5C543" if is_lit else "#B9C7BF"))
        if is_lit:
            o.append('<rect x="%s" y="%s" width="143" height="30" rx="8" fill="#FBE08C"/>' % (x0 + 8, oy + 28))
        o.append(r(fn(x0 + 79.5, oy + 50), lit(sid)))
    h.append(tag("roast", 109.5, oy + 92, 150))
    h.append(tag("braise", 280.5, oy + 92, 150))
    for i in range(15):
        o.append('<rect x="%s" y="%s" width="26" height="26" fill="%s"/>' % (i * 26, SY + 242, "#C6D2CA" if i % 2 else "#D6DFD8"))
    o.append('<rect x="0" y="%s" width="390" height="2" fill="#B9C7BF"/>' % (SY + 242))
    return H, "".join(o), "".join(h)


def home():
    H, svg, over = scene()
    body = ('<header class="a-head"><p class="a-eyebrow">Friday 2 October</p><h1 class="a-d">Tonight in your kitchen</h1>'
            '<div class="a-stats"><div class="a-stat">%s<div><b>3 nights in a row</b><span>Cook tonight for 4</span></div></div>'
            '<div class="a-stat">%s<div><b>Level 2</b><span>40 XP to level 3</span></div></div></div></header>'
            '<div class="a-scene a-tiles" style="height:%spx"><svg viewBox="0 0 390 %s" width="390" height="%s" role="img" aria-label="Kitchen scene: fridge, counter, shelves, stove and oven, each holding skills">%s</svg>%s</div>') % (
                cal_svg(), jug_svg(), H, H, H, svg, over)
    return phone("dir-a-home", "A1", "Home", "full scroll height, the kitchen is the skill map", "a-screen", body, INK)


def illo(food="chicken", w=358, h=232):
    tiles = "".join('<path d="M%s -20v217" stroke="#D0DBD3" stroke-width="1"/>' % x for x in range(29, 358, 30)) + \
            "".join('<path d="M0 %sh358" stroke="#D0DBD3" stroke-width="1"/>' % y for y in range(-13, 197, 30))
    return ('<svg viewBox="0 -14 358 232" width="%s" height="%s" preserveAspectRatio="xMidYMid slice" role="img" aria-label="A %s searing in a hot pan over a flame">'
            '<rect x="0" y="-20" width="358" height="240" fill="#DFE8E2"/>%s<rect x="0" y="197" width="358" height="25" fill="#1F4F47"/>%s</svg>') % (
                w, h, "chicken thigh" if food == "chicken" else "slab of tofu", tiles, render(sear_shapes(food), A))


def step():
    body = ('<div class="a-top"><div class="a-ib" role="button" aria-label="Close lesson">%s</div>'
            '<div class="a-prog" role="img" aria-label="Step 1 of 6"><i class="on"></i><i></i><i></i><i></i><i></i><i></i></div>'
            '<div class="a-ib on" role="button" aria-label="Read aloud is on">%s</div></div>'
            '<div class="a-body"><p class="a-kick">Step 1 of 6</p><div class="a-illo">%s</div>'
            '<p class="a-steptext">%s</p>'
            '<div class="a-timer"><span class="t">7:30</span><span class="l">Skin-side down. I\'ll ring when it\'s time to flip.</span><div class="a-btn sm" role="button" style="background:#1F4F47">%s Start timer</div></div>'
            '<div class="a-tip"><div class="who">%s</div><div class="a-bub"><small>Tomi\'s tip</small>%s</div></div></div>'
            '<div class="a-foot"><div class="a-ask" role="button">%s<span>Ask Tomi about this step</span><div class="mic" role="button" aria-label="Hold to talk">%s</div></div>'
            '<div class="a-nav"><div class="a-round" role="button" aria-label="Back">%s</div><div class="a-btn" role="button">Next step %s</div></div></div>') % (
                icon("close", 24, 2.4), icon("speaker", 22, 2.2), illo(), STEP1, icon("timer", 18, 2.2), tomi(A, "tip", 78), TIP1,
                '<div class="face">%s</div>' % tomi_face(A, 30), icon("mic", 20, 2.2), icon("back", 24, 2.4), icon("arrow", 20, 2.4))
    return phone("dir-a-step", "A2", "Lesson step", "step 1 of 6, 390 x 844", "a-screen", body, INK, 844)


def onboarding():
    bg = ('<svg class="bg" viewBox="0 0 390 200" width="390" height="200" aria-hidden="true">'
          '<rect x="0" y="148" width="390" height="12" fill="#D8A268"/><rect x="0" y="148" width="390" height="3.500" fill="#E7BC88"/><rect x="0" y="160" width="390" height="40" fill="#1F4F47"/>'
          '<rect x="232" y="174" width="56" height="5" rx="2.500" fill="#8FA09A"/><rect x="194" y="160" width="2" height="40" fill="#163B35"/>'
          '</svg>')
    opts = ""
    for k, name, desc in DIETS:
        sel = k == "vegetarian"
        opts += ('<div class="a-opt%s" role="radio" aria-checked="%s"><div class="fi">%s</div><div class="tx"><b>%s</b><span class="d">%s</span></div>'
                 '<div class="rd">%s</div></div>') % (" sel" if sel else "", "true" if sel else "false", food_svg(A, k, 30), name, desc, icon("check", 16, 3) if sel else "")
    body = ('<div class="a-ob-top"><div class="a-ob-prog" aria-hidden="true"><i class="on"></i><i></i><i></i><i></i></div><span class="n">1 of 4</span></div>'
            '<div class="a-ob-scene a-tiles">%s%s<div class="a-ob-bub">Hi, I\'m Tomi. Four quick questions, then we cook.</div></div>'
            '<div class="a-ob-body"><h1 class="a-d">What do you eat?</h1><p class="sub">I\'ll only pick lessons that fit. You can change this later in Settings.</p>%s</div>'
            '<div class="a-foot"><div class="a-btn" role="button">Continue</div></div>') % (bg, tomi(A, "happy", 112), opts)
    return phone("dir-a-onboarding", "A3", "Onboarding, question 1", "390 x 844", "a-screen", body, INK, 844)


PALETTE = [("#E9EFEA", "Tile wall", "background"), ("#FFFDF6", "Enamel", "cards, labels"), ("#16302B", "Cast iron", "text"),
           ("#1F4F47", "Spruce", "cabinets, secondary"), ("#D23B25", "Tomato", "primary action"), ("#F5C543", "Butter", "lit, mastered, tips"),
           ("#D8A268", "Butcher block", "counters, shelves"), ("#40574F", "Sage ink", "secondary text")]


def style():
    return {
        "id": "dir-a-style",
        "palette": PALETTE,
        "dark": {"#16302B", "#1F4F47", "#D23B25", "#40574F"},
        "type": ('<div class="a-screen ts"><p class="a-d" style="font-size:34px;line-height:36px;font-weight:800;margin:0">Hot pan, dry skin</p>'
                 '<p class="tn">Bricolage Grotesque 800 and 700. Titles, buttons, timer digits.</p>'
                 '<p style="font-size:17px;line-height:23px;margin:10px 0 0;font-weight:500">Sear skin-side down for 7 to 8 minutes, without moving them.</p>'
                 '<p class="tn">Instrument Sans 500 to 700. Steps, labels, body.</p></div>'),
        "buttons": ('<div class="a-screen ts" style="display:flex;flex-direction:column;gap:10px"><div class="a-btn">Start cooking</div><div class="a-btn sec">Scan again</div></div>'),
        "card": ('<div class="a-screen ts" style="display:flex;flex-direction:column;gap:12px"><div class="a-card"><b class="a-d" style="font-size:17px">Pan sauces</b>'
                 '<div style="font-size:13.5px;color:#40574F;margin-top:2px">Deglaze the fond, reduce, mount with butter</div></div>'
                 '<div style="display:flex;gap:8px;flex-wrap:wrap"><span class="a-chip"><i></i>Chicken thighs</span><span class="a-chip"><i></i>Lemon</span></div>'
                 '<div style="display:flex;gap:8px;flex-wrap:wrap;position:relative;height:40px">%s%s</div></div>') % (
                     '<div class="a-tag" style="position:static;transform:none;width:108px"><b>Searing</b><span class="st">%s</span></div>' % badge("mastered"),
                     '<div class="a-tag locked" style="position:static;transform:none;width:118px;margin-left:8px"><b>Braising</b><span class="st">%s</span></div>' % badge("locked", 0, "Roasting")),
        "moods": '<div class="a-screen ts moods">%s%s%s</div>' % (
            '<figure>%s<figcaption>Hello</figcaption></figure>' % tomi(A, "happy", 100),
            '<figure>%s<figcaption>Thinking</figcaption></figure>' % tomi(A, "think", 100),
            '<figure>%s<figcaption>Nailed it</figcaption></figure>' % tomi(A, "cheer", 100)),
        "parts": '<div class="a-screen ts parts"><div style="border-radius:16px;overflow:hidden">%s</div><div style="border-radius:16px;overflow:hidden">%s</div></div>' % (illo("chicken", 196, 127), illo("tofu", 196, 127)),
        "tomi_note": "Cut paper: flat fills, no outlines, one shade layer. He lives in the scene and stands on things.",
    }
