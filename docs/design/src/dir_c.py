# Direction C - Recipe box. Index cards, tab dividers, Tomi's handwriting.
from common import *

INK = "#36202F"

CSS = r"""
/* ============ C: Recipe box ============ */
.c-screen{--bg:#EFE4CF;--card:#FFFCF4;--ink:#36202F;--plum:#5A2748;--teal:#2E7D7A;--teal-d:#235F5C;--mustard:#E9B440;--tomato:#CF3F28;--kraft:#DBC59C;--muted:#674F5F;--blue:#BFD5E2;--edge:rgba(54,32,47,.22);
  background:var(--bg);color:var(--ink);font-family:"Karla",system-ui,-apple-system,"Helvetica Neue",Arial,sans-serif;font-size:15.5px;line-height:1.35}
.c-d{font-family:"Young Serif",Georgia,"Times New Roman",serif;font-weight:400;letter-spacing:-.005em}
.c-h{font-family:"Caveat","Bradley Hand","Segoe Print",cursive;font-weight:700}
.c-card{background:var(--card);border-radius:5px;box-shadow:0 0 0 1px var(--edge),0 10px 16px -12px rgba(54,32,47,.6)}
.c-red{background-image:linear-gradient(#E8907E,#E8907E);background-size:100% 1.5px;background-position:0 var(--rl,40px);background-repeat:no-repeat}
.c-ruled{background-image:linear-gradient(#E8907E,#E8907E),repeating-linear-gradient(to bottom,transparent 0,transparent 25px,var(--blue) 25px,var(--blue) 26px);background-size:100% 1.5px,100% 100%;background-position:0 var(--rl,40px),0 var(--rl,40px);background-repeat:no-repeat,no-repeat}
.c-head{display:flex;align-items:flex-end;justify-content:space-between;gap:8px;padding:64px 20px 0}
.c-head .k{font-size:13px;font-weight:700;color:var(--muted)}
.c-head h1{font-size:30px;line-height:34px;margin-top:2px}
.c-head .s{font-size:14.5px;line-height:19px;color:var(--muted);margin-top:3px;font-weight:500}
.c-head .tomi{margin:0 -8px -6px 0}
.c-log{margin:16px 16px 0;padding:12px 16px 14px;display:flex;flex-direction:column;gap:10px}
.c-log .top{display:flex;align-items:baseline;justify-content:space-between;gap:8px}
.c-log .top b{font-size:14px;font-weight:700}
.c-log .top .c-h{font-size:23px;line-height:22px;color:var(--tomato);transform:rotate(-2deg)}
.c-days{display:grid;grid-template-columns:repeat(7,1fr);gap:8px}
.c-day{display:flex;flex-direction:column;align-items:center;gap:3px;font-size:12px;line-height:14px;font-weight:700;color:var(--muted)}
.c-day i{position:relative;display:block;width:100%;height:32px;border:1.5px solid var(--ink);border-radius:4px;background:var(--card)}
.c-day i svg{position:absolute;left:50%;top:-6px;margin-left:-15px}
.c-day.today{color:var(--ink)}
.c-day.today i{border-style:dashed;border-color:var(--tomato);background:#FBEBD2}
.c-xp{display:flex;align-items:center;gap:10px;font-size:13.5px;line-height:18px;font-weight:600}
.c-xp .lv{font-size:17px;line-height:20px;white-space:nowrap}
.c-xp .bar{flex:1;min-width:0;height:12px;position:relative}
.c-xp .bar svg{display:block;width:100%;height:12px}
.c-xp .n{color:var(--muted);white-space:nowrap}
.c-tonight{position:relative;margin:22px 16px 0;padding:16px 16px 16px;transform:rotate(-1deg);display:flex;flex-direction:column;gap:9px;--rl:42px}
.c-tonight .k{font-size:13px;line-height:18px;font-weight:700;color:var(--tomato)}
.c-tonight h2{font-size:21.5px;line-height:26px;max-width:218px}
.c-tonight .m{font-size:13.5px;line-height:18px;color:var(--muted);font-weight:500}
.c-tonight .m b{color:var(--ink)}
.c-snap{position:absolute;right:12px;top:-14px;width:92px;background:#fff;padding:6px 6px 4px;transform:rotate(5deg);box-shadow:0 0 0 1px var(--edge),0 8px 12px -8px rgba(54,32,47,.6);text-align:center}
.c-snap svg{display:block;width:80px;height:74px}
.c-snap span{display:block;font-size:17px;line-height:19px;color:var(--ink)}
.c-clip{position:absolute;right:52px;top:-30px;transform:rotate(5deg)}
.c-chips{display:flex;flex-wrap:wrap;gap:6px 7px;max-width:226px}
.c-chip{display:inline-flex;align-items:center;height:27px;padding:0 9px;background:#F6DFA4;border-radius:2px;font-size:13.5px;font-weight:600;color:var(--ink)}
.c-chip:nth-child(odd){transform:rotate(-1.200deg)}
.c-chip:nth-child(even){transform:rotate(1deg)}
.c-btn{display:flex;align-items:center;justify-content:center;gap:8px;min-height:54px;padding:0 20px;border-radius:12px;background:var(--plum);color:#fff;font:700 17px/1 "Karla",system-ui,sans-serif}
.c-btn.sec{background:var(--card);color:var(--ink);box-shadow:inset 0 0 0 1.5px var(--ink)}
.c-btn.sm{min-height:44px;font-size:15.5px;padding:0 14px;border-radius:10px}
.c-row{display:flex;gap:10px}
.c-row .grow{flex:1;min-width:0}
.c-boxh{display:flex;align-items:baseline;justify-content:space-between;gap:10px;padding:30px 20px 12px}
.c-boxh h2{font-size:22px;line-height:26px}
.c-boxh span{font-size:13.5px;color:var(--muted);font-weight:500}
.c-stack{margin:0 10px;padding:38px 7px 0;background:var(--teal-d);border-radius:14px 14px 0 0;box-shadow:inset 0 10px 14px -8px rgba(0,0,0,.35)}
.c-sk{position:relative;margin-top:-26px}
.c-sk .tabrow{height:26px;display:flex;padding:0 10px}
.c-sk.p1 .tabrow{justify-content:flex-start}.c-sk.p2 .tabrow{justify-content:center}.c-sk.p3 .tabrow{justify-content:flex-end}
.c-tab{display:inline-flex;align-items:center;gap:5px;height:27px;padding:0 12px;border-radius:9px 9px 0 0;background:var(--card);font-size:13.5px;font-weight:700;white-space:nowrap;box-shadow:0 0 0 1px var(--edge);position:relative;clip-path:inset(-2px -2px 1px -2px)}
.c-sk .body{background:var(--card);border-radius:4px 4px 0 0;box-shadow:0 0 0 1px var(--edge),0 -8px 10px -9px rgba(54,32,47,.55);height:60px;padding:0 12px;position:relative}
.c-sk .line{display:flex;align-items:center;gap:8px;height:34px;font-size:13.5px;font-weight:500}
.c-sk .line .tx{flex:1;min-width:0;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.c-sk .line .n{font-weight:700;white-space:nowrap;font-variant-numeric:tabular-nums}
.c-sk.div .c-tab,.c-sk.div .body{background:var(--kraft)}
.c-sk.div .c-tab{font-family:"Young Serif",Georgia,serif;font-weight:400;font-size:15px;padding:0 14px}
.c-sk.div .line{font-weight:600}
.c-sk.mastered .c-tab{background:var(--mustard)}
.c-sk.locked .c-tab,.c-sk.locked .body{background:#EFE6D2;color:var(--muted)}
.c-sk.next{margin-left:-3px;margin-right:-3px;transform:rotate(-.800deg)}
.c-sk.next .c-tab{background:var(--tomato);color:#fff}
.c-sk.next .body{height:auto;padding:12px 12px 40px;box-shadow:0 0 0 1px var(--edge),0 -12px 16px -10px rgba(54,32,47,.7);--rl:38px;display:flex;flex-direction:column;gap:8px}
.c-pull .bl{font-size:14.5px;line-height:19px;font-weight:500;padding-right:70px;min-height:44px}
.c-slot{display:flex;align-items:center;gap:8px;min-height:44px;padding:4px 10px;border:1.5px dashed #9C8794;border-radius:4px;background:rgba(255,252,244,.8);font-size:13.5px;color:var(--muted);font-weight:500}
.c-slot .c-h{font-size:20px;line-height:20px;color:var(--ink);flex:1;min-width:0}
.c-slot b{font-size:12px;font-weight:700;color:var(--tomato);white-space:nowrap}
.c-pull .tomi{position:absolute;right:0;top:4px}
.c-front{position:relative;z-index:4;margin:-26px 10px 0;height:96px;background:var(--teal);border-radius:3px 3px 16px 16px;box-shadow:0 -1px 0 rgba(255,255,255,.25) inset,0 14px 18px -14px rgba(54,32,47,.7);display:grid;place-items:center}
.c-plate{background:var(--card);border:3px solid #D0A64A;border-radius:4px;padding:6px 18px 7px;text-align:center}
.c-plate b{display:block;font-size:16px;line-height:20px;font-weight:400}
.c-plate span{display:block;font-size:12.5px;line-height:16px;color:var(--muted);font-weight:600}
.c-homepad{height:46px}
/* step */
.c-top{display:flex;align-items:center;padding:58px 16px 0 6px;gap:4px}
.c-ib{width:44px;height:44px;display:grid;place-items:center;flex:none;border-radius:12px}
.c-ib.on{background:var(--card);box-shadow:0 0 0 1.5px var(--ink)}
.c-top .mid{flex:1;text-align:center;font-size:18px;line-height:22px;padding-left:10px}
.c-tabs{display:flex;align-items:flex-end;gap:4px;padding:10px 16px 0;height:42px}
.c-tabs span{display:grid;place-items:center;height:24px;flex:1;border-radius:8px 8px 0 0;background:var(--kraft);font-size:13px;font-weight:700;color:var(--ink);box-shadow:0 0 0 1px var(--edge)}
.c-tabs span.on{flex:none;width:88px;height:31px;background:var(--card);color:var(--ink);font-size:14px;clip-path:inset(-2px -2px 1px -2px)}
.c-stepcard{position:relative;margin:0 16px;padding:12px 14px 14px;border-radius:0 5px 5px 5px;display:flex;flex-direction:column;gap:12px;box-shadow:0 0 0 1px var(--edge),5px 5px 0 -1px #F7F0E0,5px 5px 0 0 var(--edge),10px 10px 0 -1px #EFE6D2,10px 10px 0 0 var(--edge)}
.c-illo{height:188px;border-radius:4px;overflow:hidden;background:#F7EDD6}
.c-illo svg{display:block;width:100%;height:100%}
.c-steptext{font-size:20px;line-height:27px;font-weight:500;letter-spacing:-.01em}
.c-steptext b{font-weight:700;background:linear-gradient(transparent 62%,#F6DFA4 62%)}
.c-timer{display:flex;align-items:center;gap:10px;padding-top:10px;border-top:1.5px solid #E8907E}
.c-timer .t{font:700 36px/38px "Karla",sans-serif;letter-spacing:-.02em;font-variant-numeric:tabular-nums}
.c-timer .l{flex:1;min-width:0;font-size:12.5px;line-height:16px;color:var(--muted);font-weight:500}
.c-sticky{position:relative;margin:22px 16px 0 60px;padding:8px 12px 10px 38px;background:#F7D774;transform:rotate(1.200deg);box-shadow:0 8px 10px -8px rgba(54,32,47,.6)}
.c-sticky small{display:block;font-size:12px;line-height:15px;font-weight:700;color:#5C4300;font-family:"Karla",sans-serif}
.c-sticky p{font-size:22.5px;line-height:24px;white-space:nowrap}
.c-sticky .tomi{position:absolute;left:-58px;bottom:-8px;transform:rotate(-1.200deg)}
.c-foot{position:absolute;left:0;right:0;bottom:0;padding:0 16px 34px;display:flex;flex-direction:column;gap:10px}
/* onboarding */
.c-ob-top{display:flex;align-items:center;gap:12px;padding:68px 20px 0;font-size:13px;font-weight:700;color:var(--muted)}
.c-ob-pips{display:flex;gap:5px}
.c-ob-pips i{width:22px;height:15px;border-radius:2px;background:var(--kraft);box-shadow:0 0 0 1px var(--edge)}
.c-ob-pips i.on{background:var(--tomato)}
.c-ob-hero{display:flex;align-items:center;gap:6px;padding:20px 20px 0 12px}
.c-ob-hero p{font-size:25px;line-height:27px;flex:1;min-width:0;transform:rotate(-1.500deg)}
.c-ob-body{padding:20px 16px 0}
.c-ob-body h1{font-size:32px;line-height:36px;margin:0 4px}
.c-ob-body .sub{font-size:15px;line-height:20px;color:var(--muted);margin:6px 4px 0;font-weight:500}
.c-opts{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:16px 12px;margin-top:20px}
.c-opt{position:relative;padding:14px 12px 13px;display:flex;flex-direction:column;gap:2px;min-height:158px;--rl:70px}
.c-opt b{font-size:19px;line-height:26px;font-weight:400;margin-top:6px}
.c-opt span.d{font-size:13.5px;line-height:26px;color:var(--muted);font-weight:500}
.c-opt.sel{box-shadow:0 0 0 2.5px var(--plum),0 10px 16px -12px rgba(54,32,47,.6);transform:rotate(-1.200deg)}
.c-opt .tick{position:absolute;right:-8px;top:-10px;width:36px;height:36px;border-radius:50%;background:var(--plum);display:grid;place-items:center;color:#fff;box-shadow:0 0 0 3px #fff,0 4px 6px rgba(54,32,47,.35)}
.c-opt .box{position:absolute;right:10px;top:10px;width:22px;height:22px;border:1.5px solid var(--ink);border-radius:4px}
"""

TICK = '<svg viewBox="0 0 30 30" width="30" height="30" aria-hidden="true"><path d="M5 16c3 2.500 5 5.500 6.500 9C15 17 20 9.500 27 4" fill="none" stroke="#5A2748" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/></svg>'


def mark(state, cooks=0):
    if state == "mastered":
        return ('<svg viewBox="0 0 18 18" width="18" height="18" aria-hidden="true"><circle cx="9" cy="9" r="8.200" fill="#5A2748"/>'
                '<path d="M5 9.400l2.700 2.700 5.300 -5.700" fill="none" stroke="#fff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg>')
    if state == "locked":
        return icon("lock", 15, 2.2)
    f = lambda on: "#36202F" if on else "#FFFCF4"
    return ('<svg viewBox="0 0 26 18" width="26" height="18" aria-hidden="true"><rect x="1" y="3" width="11" height="13" rx="1.500" fill="%s" stroke="#36202F" stroke-width="1.500"/>'
            '<rect x="14" y="3" width="11" height="13" rx="1.500" fill="%s" stroke="#36202F" stroke-width="1.500"/></svg>') % (f(cooks > 0), f(cooks > 1))


def fridge_snap():
    return ('<svg viewBox="0 0 80 74" aria-hidden="true"><rect width="80" height="74" fill="#CFE3E2"/>'
            '<rect x="20" y="6" width="40" height="64" rx="5" fill="#FFFCF4" stroke="#36202F" stroke-width="2"/><path d="M20 30h40" stroke="#36202F" stroke-width="2"/>'
            '<path d="M53 14v9M53 37v12" stroke="#36202F" stroke-width="2.400" stroke-linecap="round"/>'
            '<circle cx="31" cy="46" r="5" fill="#DE4B33" stroke="#36202F" stroke-width="1.600"/><ellipse cx="42" cy="59" rx="6" ry="4.500" fill="#F3C441" stroke="#36202F" stroke-width="1.600"/>'
            '<rect x="27" y="14" width="9" height="11" rx="2" fill="#7C9A3C" stroke="#36202F" stroke-width="1.600"/></svg>')


def clip():
    return ('<svg class="c-clip" viewBox="0 0 22 54" width="22" height="54" aria-hidden="true"><path d="M6 14v26a5 5 0 0 0 10 0V10a7 7 0 0 0 -14 0v32" fill="none" stroke="#7D8A90" stroke-width="2.400" stroke-linecap="round"/></svg>')


def sk_card(i, s):
    sid, name, blurb, unit, state, cooks, needs, recipes = s
    pos = "p%s" % (i % 3 + 1)
    if state == "next":
        pos = "p1"
        return ('<div class="c-sk next %s" id="c-skill-%s"><div class="tabrow"><span class="c-tab">Pan sauces &middot; next up</span></div>'
                '<div class="body c-pull">%s<p class="bl">%s. Two cooks to master.</p>'
                '<div class="c-slot"><span class="c-h">Seared chicken thighs, lemon-butter pan sauce</span><b>Tonight</b></div>'
                '<div class="c-slot">%s<span>Empty slot. A second cook masters it.</span></div></div></div>') % (pos, sid, tomi(C, "tip", 50), blurb, mark("ready", 0))
    if state == "mastered":
        tx, n = " &middot; ".join(recipes), "2 of 2"
        tab = icon("check", 14, 3) + name
    elif state == "progress":
        tx, n = recipes[0] + " &middot; one more to master", "1 of 2"
        tab = name
    elif state == "ready":
        tx, n = "Ready to cook. No cards yet", "0 of 2"
        tab = name
    else:
        tx, n = "Opens after " + needs.replace(", ", " and "), "Locked"
        tab = icon("lock", 13, 2.4) + name
    return ('<div class="c-sk %s %s" id="c-skill-%s"><div class="tabrow"><span class="c-tab">%s</span></div>'
            '<div class="body"><div class="line">%s<span class="tx">%s</span><span class="n">%s</span></div></div></div>') % (state, pos, sid, tab, mark(state, cooks), tx, n)


def home():
    stack = ""
    i = 0
    for u, (uname, usub) in enumerate(UNITS):
        sk = [s for s in SKILLS if s[3] == u]
        done = len([s for s in sk if s[4] == "mastered"])
        stack += ('<div class="c-sk div p1" id="c-unit-%s"><div class="tabrow"><span class="c-tab">%s</span></div><div class="body"><div class="line"><span class="tx">%s</span><span class="n">%s of %s mastered</span></div></div></div>') % (u + 1, uname, usub, done, len(sk))
        for s in sk:
            stack += sk_card(i + 1, s)
            i += 1
    days = ""
    for j, d in enumerate("MTWTFSS"):
        cls = " today" if j == 4 else ""
        days += '<div class="c-day%s"><span>%s</span><i>%s</i></div>' % (cls, d, TICK if j in (1, 2, 3) else "")
    xpbar = ('<svg viewBox="0 0 150 12" preserveAspectRatio="none" aria-hidden="true"><path d="M2 7h146" stroke="#36202F" stroke-opacity=".28" stroke-width="2" stroke-linecap="round"/>'
             '<path d="M3 6.500c18 -1.500 36 1.500 54 0s36 1 53 -.500" fill="none" stroke="#E2A72E" stroke-width="6" stroke-linecap="round"/></svg>')
    body = ('<header class="c-head"><div><p class="k">Friday 2 October</p><h1 class="c-d">Your recipe box</h1><p class="s">7 recipes inside. 3 of 12 skills mastered.</p></div>%s</header>'
            '<section class="c-card c-log" aria-label="Cook\'s log"><div class="top"><b>This week</b><span class="c-h">3 nights in a row!</span></div><div class="c-days">%s</div>'
            '<div class="c-xp"><span class="lv c-d">Level 2</span><span class="bar" role="img" aria-label="110 of 150 XP">%s</span><span class="n">40 XP to level 3</span></div></section>'
            '<section class="c-card c-red c-tonight"><div class="c-snap" role="button" aria-label="Scan your fridge again">%s<span class="c-h">fridge, 18:20</span></div>%s'
            '<p class="k">Tonight\'s card</p><h2 class="c-d">%s</h2>'
            '<div class="c-chips"><span class="c-chip">chicken thighs</span><span class="c-chip">lemon</span><span class="c-chip">butter</span><span class="c-chip">spinach</span><span class="c-chip">+2</span></div>'
            '<p class="m">Files under <b>Pan sauces</b>. 30 min, +40 XP</p>'
            '<div class="c-row"><div class="c-btn grow" role="button">Start cooking</div><div class="c-btn sec" role="button">%s Scan fridge</div></div></section>'
            '<div class="c-boxh"><h2 class="c-d">The box</h2><span>12 skills, 4 dividers</span></div>'
            '<div class="c-stack">%s</div><div class="c-front"><div class="c-plate"><b class="c-d">Tomi\'s recipes</b><span>7 cards and counting</span></div></div><div class="c-homepad"></div>') % (
                tomi(C, "happy", 78), days, xpbar, fridge_snap(), clip(), LESSON, icon("camera", 20, 2), stack)
    return phone("dir-c-home", "C1", "Home", "full scroll height, the box is the skill map", "c-screen", body, INK)


def illo(food="chicken", w=330, h=188):
    return ('<svg viewBox="0 12 358 204" width="%s" height="%s" preserveAspectRatio="xMidYMid slice" role="img" aria-label="A %s searing in a hot pan over a flame">'
            '<rect x="0" y="0" width="358" height="230" fill="#F7EDD6"/><rect x="0" y="198" width="358" height="32" fill="#E9D9B4"/>%s</svg>') % (
                w, h, "chicken thigh" if food == "chicken" else "slab of tofu", render(sear_shapes(food), C))


def step():
    tabs = '<span class="on">Step 1</span>' + "".join("<span>%s</span>" % n for n in range(2, 7))
    body = ('<div class="c-top"><div class="c-ib" role="button" aria-label="Close lesson">%s</div><div class="mid c-d">Pan sauces</div>'
            '<div class="c-ib on" role="button" aria-label="Read aloud is on">%s</div></div>'
            '<div class="c-tabs" role="img" aria-label="Step 1 of 6">%s</div>'
            '<div class="c-card c-stepcard"><div class="c-illo">%s</div><p class="c-steptext">%s</p>'
            '<div class="c-timer"><span class="t">7:30</span><span class="l">Skin-side down. I\'ll ring when it\'s time to flip.</span><div class="c-btn sm sec" role="button">%s Start timer</div></div></div>'
            '<div class="c-sticky">%s<small>Tomi\'s tip</small><p class="c-h">%s</p></div>'
            '<div class="c-foot"><div class="c-row"><div class="c-btn sm sec grow" role="button" style="justify-content:flex-start">%s Ask Tomi about this step</div>'
            '<div class="c-btn sm sec" role="button" aria-label="Hold to talk" style="width:52px;padding:0">%s</div></div>'
            '<div class="c-row"><div class="c-btn sec" role="button" style="width:92px">Back</div><div class="c-btn grow" role="button">Next card %s</div></div></div>') % (
                icon("close", 24, 2.2), icon("speaker", 22, 2), tabs, illo(), STEP1, icon("timer", 18, 2), tomi(C, "tip", 58), TIP1,
                tomi_face(C, 26), icon("mic", 20, 2), icon("arrow", 20, 2.2))
    return phone("dir-c-step", "C2", "Lesson step", "step 1 of 6, 390 x 844", "c-screen", body, INK, 844)


def onboarding():
    opts = ""
    for k, name, desc in DIETS:
        sel = k == "vegetarian"
        opts += ('<div class="c-card c-ruled c-opt%s" role="radio" aria-checked="%s">%s%s<b class="c-d">%s</b><span class="d">%s</span></div>') % (
            " sel" if sel else "", "true" if sel else "false", food_svg(C, k, 54),
            '<span class="tick">%s</span>' % icon("check", 20, 3) if sel else '<span class="box"></span>', name, desc)
    body = ('<div class="c-ob-top"><div class="c-ob-pips" aria-hidden="true"><i class="on"></i><i></i><i></i><i></i></div><span>Card 1 of 4</span></div>'
            '<div class="c-ob-hero">%s<p class="c-h">Hi, I\'m Tomi! Four quick cards and your box is ready.</p></div>'
            '<div class="c-ob-body"><h1 class="c-d">What do you eat?</h1><p class="sub">Only recipes that fit go in your box. You can change this later in Settings.</p>'
            '<div class="c-opts" role="radiogroup">%s</div></div>'
            '<div class="c-foot"><div class="c-btn" role="button">Continue</div></div>') % (tomi(C, "happy", 104), opts)
    return phone("dir-c-onboarding", "C3", "Onboarding, question 1", "390 x 844", "c-screen", body, INK, 844)


PALETTE = [("#EFE4CF", "Oat", "background"), ("#FFFCF4", "Index card", "cards"), ("#36202F", "Aubergine ink", "text, outlines"),
           ("#5A2748", "Plum", "primary action"), ("#CF3F28", "Tomato", "next up, Tomi"), ("#E9B440", "Mustard", "mastered tab, tape"),
           ("#2E7D7A", "Tin teal", "the box"), ("#DBC59C", "Manila", "dividers")]


def style():
    return {
        "id": "dir-c-style",
        "palette": PALETTE,
        "dark": {"#36202F", "#5A2748", "#CF3F28", "#2E7D7A"},
        "type": ('<div class="c-screen ts"><p class="c-d" style="font-size:32px;line-height:36px;margin:0">Your recipe box</p>'
                 '<p class="tn">Young Serif. Titles, card and tab names.</p>'
                 '<p style="font-size:17px;line-height:23px;margin:10px 0 0;font-weight:500">Sear skin-side down for 7 to 8 minutes.</p>'
                 '<p class="tn">Karla 500 to 700. Steps, labels, buttons.</p>'
                 '<p class="c-h" style="font-size:25px;line-height:26px;margin:8px 0 0">Dry skin browns. Wet skin steams.</p><p class="tn">Caveat 700. Tomi\'s voice only, 19 pt and up.</p></div>'),
        "buttons": '<div class="c-screen ts" style="display:flex;flex-direction:column;gap:10px"><div class="c-btn">Start cooking</div><div class="c-btn sec">Scan fridge</div></div>',
        "card": ('<div class="c-screen ts" style="display:flex;flex-direction:column;gap:14px"><div class="c-card c-ruled" style="padding:10px 14px 14px;--rl:36px"><b class="c-d" style="font-size:18px;font-weight:400">Pan sauces</b>'
                 '<div style="font-size:13.5px;line-height:26px;color:#674F5F;font-weight:500">Deglaze the fond, reduce, mount with butter</div></div>'
                 '<div class="c-chips"><span class="c-chip">chicken thighs</span><span class="c-chip">lemon</span></div>'
                 '<div style="padding-top:26px;height:146px;overflow:hidden;margin-top:-6px">%s%s</div></div>') % (sk_card(0, SK["sear"]), sk_card(1, SK["braise"])),
        "moods": '<div class="c-screen ts moods">%s%s%s</div>' % (
            '<figure>%s<figcaption>Hello</figcaption></figure>' % tomi(C, "happy", 100),
            '<figure>%s<figcaption>Thinking</figcaption></figure>' % tomi(C, "think", 100),
            '<figure>%s<figcaption>Nailed it</figcaption></figure>' % tomi(C, "cheer", 100)),
        "parts": '<div class="c-screen ts parts"><div style="border-radius:4px;overflow:hidden">%s</div><div style="border-radius:4px;overflow:hidden">%s</div></div>' % (illo("chicken", 196, 112), illo("tofu", 196, 112)),
        "tomi_note": "Sticker: inked outline, flat fills, white die-cut edge. He is stuck onto cards and notes, and writes by hand.",
    }
