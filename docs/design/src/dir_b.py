# Direction B - Tasting menu. Cobalt ink on paper, red stamp, typeset path.
from common import *

INK = "#172A6E"
ORD = ["First course", "Second course", "Third course", "Fourth course"]

CSS = r"""
/* ============ B: Tasting menu ============ */
.b-screen{--paper:#FBFAF5;--ink:#172A6E;--blue:#1D3690;--red:#C9321C;--yolk:#F1C232;--rule:#C3CAE6;--muted:#46548A;--tint:#EEF0F8;
  background:var(--paper);color:var(--ink);font-family:"Newsreader",Georgia,"Times New Roman",serif;font-size:16px;line-height:1.35}
.b-d{font-family:"Gloock","Newsreader",Georgia,serif;font-weight:400;letter-spacing:0}
.b-u{font-family:"Figtree",system-ui,-apple-system,"Helvetica Neue",Arial,sans-serif}
.b-k{font-family:"Figtree",system-ui,sans-serif;font-size:11px;line-height:14px;font-weight:700;letter-spacing:.14em;text-transform:uppercase;color:var(--muted)}
.b-it{font-style:italic;color:var(--muted)}
.b-mast{padding:64px 20px 0;text-align:center;display:flex;flex-direction:column;align-items:center}
.b-mast h1{font-size:32px;line-height:36px;margin-top:2px}
.b-mast .b-k{margin-top:6px}
.b-house{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));margin:16px 16px 0;border-top:3px double var(--blue)}
.b-house > div{padding:10px 4px 11px;text-align:center;min-width:0}
.b-house > div + div{border-left:1px solid var(--rule)}
.b-house .v{white-space:nowrap}
.b-house .v{display:block;font-size:24px;line-height:28px;margin-top:3px}
.b-house .s{display:block;font-family:"Figtree",sans-serif;font-size:12px;line-height:15px;color:var(--muted);font-weight:500}
.b-xp{grid-column:1/-1;display:block;height:3px;background:var(--rule);position:relative}
.b-xp::after{content:"";position:absolute;left:0;top:0;bottom:0;width:73.3%;background:var(--blue)}
.b-special{position:relative;margin:26px 16px 0;padding:26px 18px 18px;border:1.5px solid var(--blue);border-radius:3px;text-align:center;display:flex;flex-direction:column;gap:10px}
.b-special::before{content:"";position:absolute;inset:4px;border:1px solid var(--rule);border-radius:1px;pointer-events:none}
.b-special .flag{position:absolute;left:50%;top:-10px;transform:translateX(-50%);background:var(--paper);padding:0 10px;color:var(--red);white-space:nowrap;line-height:20px}
.b-special h2{font-size:25px;line-height:30px;text-wrap:balance}
.b-special .from{font-size:15.5px;line-height:21px}
.b-special .meta{font-size:13.5px;line-height:18px;font-weight:500;color:var(--ink)}
.b-special .meta b{font-weight:700}
.b-special .tomi{position:absolute;right:-6px;top:-44px}
.b-btn{position:relative;display:flex;align-items:center;justify-content:center;gap:8px;min-height:52px;padding:0 20px;border-radius:4px;background:var(--blue);color:#fff;font:600 16.5px/1 "Figtree",system-ui,sans-serif;letter-spacing:.01em}
.b-btn.sec{background:transparent;color:var(--blue);box-shadow:inset 0 0 0 1.5px var(--blue)}
.b-btn.sm{min-height:44px;font-size:15px;padding:0 14px}
.b-menu{padding:30px 20px 56px}
.b-menu-h{text-align:center}
.b-menu-h h2{font-size:28px;line-height:32px}
.b-menu-h p{font-size:15.5px;line-height:21px;margin-top:4px}
.b-course{margin-top:28px;padding-bottom:10px;border-bottom:1px solid var(--blue);display:flex;align-items:baseline;gap:10px;flex-wrap:wrap}
.b-course .b-k{flex-basis:100%;display:flex;align-items:center;gap:10px}
.b-course .b-k::after{content:"";flex:1;height:1px;background:var(--rule)}
.b-course h3{font-size:22px;line-height:26px}
.b-course .b-it{font-size:15px;line-height:20px;margin-left:auto}
.b-dish{position:relative;padding:13px 0 12px;border-bottom:1px solid var(--rule);min-height:64px}
.b-dish .row{display:flex;align-items:baseline;gap:8px}
.b-dish .nm{font-size:19px;line-height:24px;position:relative;white-space:nowrap}
.b-dish .ld{flex:1;min-width:16px;border-bottom:2px dotted #8E9BD0;transform:translateY(-4px)}
.b-dish .st{display:inline-flex;align-items:center;gap:6px;font:600 13px/24px "Figtree",sans-serif;white-space:nowrap}
.b-dish .desc{font-size:15px;line-height:20px;margin-top:1px}
.b-dish.locked .nm{color:var(--muted)}
.b-dish.locked .st{color:var(--muted)}
.b-dish.next .st{color:var(--red);font-weight:700}
.b-dish.next .desc{margin-top:6px}
.b-dish .circle{position:absolute;left:-17px;top:-8px;pointer-events:none}
.b-stamp{flex:none;margin:-12px -2px -14px 2px;transform:rotate(-11deg);align-self:center}
.b-fine{text-align:center;font-size:14.5px;line-height:20px;margin-top:22px}
/* step */
.b-top{display:flex;align-items:center;padding:58px 8px 0;gap:4px}
.b-ib{width:44px;height:44px;display:grid;place-items:center;flex:none;color:var(--blue)}
.b-ib.on{position:relative}
.b-ib.on::after{content:"";position:absolute;left:10px;right:10px;bottom:5px;height:2px;background:var(--red)}
.b-top .mid{flex:1;text-align:center;min-width:0}
.b-top .mid .t{display:block;font-size:19px;line-height:23px}
.b-ticks{display:grid;grid-template-columns:repeat(6,1fr);gap:0;margin:10px 16px 0;border-bottom:1px solid var(--rule)}
.b-ticks i{height:3px;margin-bottom:-2px}
.b-ticks i.on{background:var(--blue)}
.b-ticks i + i{border-left:1px solid var(--paper)}
.b-body{padding:14px 16px 0;display:flex;flex-direction:column;gap:16px}
.b-plate{border:1px solid var(--blue);border-radius:3px;padding:3px}
.b-plate .in{border:1px solid var(--rule);height:206px;overflow:hidden}
.b-plate svg{display:block;width:100%;height:100%}
.b-plate figcaption{font-size:14px;line-height:18px;text-align:center;padding:6px 0 4px}
.b-steptext{font-size:22px;line-height:30px;font-weight:500}
.b-steptext b{font-weight:600;font-style:italic}
.b-timer{display:flex;align-items:center;gap:12px;border-top:1px solid var(--blue);border-bottom:1px solid var(--blue);padding:8px 0}
.b-timer .t{font-size:40px;line-height:44px;font-variant-numeric:tabular-nums}
.b-timer .l{flex:1;min-width:0;font:500 12.5px/16px "Figtree",sans-serif;color:var(--muted)}
.b-tip{display:flex;align-items:center;gap:8px}
.b-tip .tx{flex:1;min-width:0}
.b-tip .b-k{color:var(--red)}
.b-tip p{font-size:19px;line-height:25px;color:var(--ink);font-style:italic;margin-top:2px}
.b-foot{position:absolute;left:0;right:0;bottom:0;padding:0 16px 34px;display:flex;gap:10px}
.b-foot .grow{flex:1;white-space:nowrap}
.b-foot .b-btn{padding:0 16px}
.b-btn.sq{width:52px;padding:0;flex:none}
.b-txtbtn{display:flex;align-items:center;gap:4px;min-height:52px;padding:0 10px 0 2px;color:var(--blue);font:600 16px/1 "Figtree",sans-serif}
/* onboarding */
.b-ob-top{padding:66px 20px 0;display:flex;align-items:center;gap:12px}
.b-ob-top .b-ticks{flex:1;margin:0;grid-template-columns:repeat(4,1fr)}
.b-ob-hero{display:flex;align-items:center;gap:10px;padding:26px 20px 0}
.b-ob-hero p{font-size:19px;line-height:25px;color:var(--ink);flex:1;min-width:0}
.b-ob-body{padding:24px 20px 0}
.b-ob-body h1{font-size:38px;line-height:42px}
.b-ob-body .sub{font-size:16px;line-height:22px;margin-top:6px}
.b-opts{margin-top:22px;border-top:1px solid var(--blue)}
.b-opt{display:flex;align-items:baseline;gap:10px;min-height:78px;padding:26px 2px 0;border-bottom:1px solid var(--rule);position:relative}
.b-opt .bx{align-self:flex-start;margin-top:1px;width:26px;height:26px;border:1.5px solid var(--blue);border-radius:2px;flex:none;position:relative}
.b-opt .bx svg{position:absolute;left:1px;top:-9px}
.b-opt .nm{font-size:22px;line-height:28px}
.b-opt .ld{flex:1;min-width:12px;border-bottom:2px dotted #8E9BD0;transform:translateY(-5px)}
.b-opt .d{font-size:15.5px;line-height:28px;white-space:nowrap}
.b-opt.sel{background:var(--tint);margin:0 -20px;padding-left:22px;padding-right:22px}
.b-opt.sel .d{color:var(--ink)}
.b-chip{display:inline-flex;align-items:center;height:30px;padding:0 11px;border:1px solid var(--blue);border-radius:2px;font:600 13.5px/1 "Figtree",sans-serif;color:var(--blue)}
.b-card{border:1.5px solid var(--blue);border-radius:3px;padding:12px 14px;position:relative}
"""


def stamp(size=42):
    return ('<svg class="b-stamp" viewBox="0 0 48 48" width="%s" height="%s" aria-hidden="true"><g fill="none" stroke="#D9402A" opacity=".92">'
            '<circle cx="24" cy="24" r="21.500" stroke-width="2.200"/><circle cx="24" cy="24" r="17.500" stroke-width="1" stroke-dasharray="1.500 2.600"/></g>'
            '<g fill="#D9402A" opacity=".92"><path d="M17.500 26.500c-5.500 -.300 -6 -8.300 -.200 -8.500c1 -6.600 12.400 -6.600 13.400 0c5.800 .200 5.300 8.200 -.200 8.500z"/><rect x="17.500" y="28" width="13" height="4.600" rx="1.200"/>'
            '<path d="M13 37.500h22" stroke="#D9402A" stroke-width="1.400" stroke-linecap="round"/></g></svg>') % (size, size)


def pips(n):
    d = lambda x, on: '<path d="M%s 1l4 4 -4 4 -4 -4z" fill="%s" stroke="#1D3690" stroke-width="1.300" stroke-linejoin="round"/>' % (x, "#1D3690" if on else "none")
    return '<svg viewBox="0 0 22 10" width="22" height="10" aria-hidden="true">%s%s</svg>' % (d(5.5, n > 0), d(16.5, n > 1))


def dish(s):
    sid, name, blurb, unit, state, cooks, needs = s[:7]
    extra = ""
    if state == "mastered":
        st = "Mastered" + stamp()
    elif state == "progress":
        st = "%s of 2 %s" % (cooks, pips(cooks))
    elif state == "ready":
        st = "Ready " + pips(0)
    elif state == "next":
        st = "Next up " + pips(0)
        extra = ('<svg class="circle" viewBox="0 0 150 42" preserveAspectRatio="none" width="%s" height="42" aria-hidden="true"><path d="M21 33C4 29 4 11 30 7C62 2 118 2 136 12C152 21 138 35 104 38C72 41 34 40 14 31C6 27 10 16 24 11" '
                 'fill="none" stroke="#D9402A" stroke-width="2" stroke-linecap="round" vector-effect="non-scaling-stroke"/></svg>') % 138
    else:
        st = icon("lock", 13, 2) + "Locked"
        blurb = "Served after %s." % needs.replace(", ", " and ")
    return ('<div class="b-dish %s" id="b-skill-%s"><div class="row"><span class="nm b-d">%s%s</span><span class="ld"></span><span class="st">%s</span></div>'
            '<p class="desc b-it">%s</p></div>') % (state, sid, extra, name, st, blurb)


def home():
    menu = ""
    for u, (uname, usub) in enumerate(UNITS):
        sk = [s for s in SKILLS if s[3] == u]
        done = len([s for s in sk if s[4] == "mastered"])
        menu += '<div class="b-course"><p class="b-k">%s</p><h3 class="b-d">%s</h3><p class="b-it">%s of %s mastered</p></div>' % (ORD[u], uname, done, len(sk))
        menu += "".join(dish(s) for s in sk)
    body = ('<header class="b-mast">%s<h1 class="b-d">Tonight at Tomi\'s</h1><p class="b-k">Friday 2 October, dinner</p></header>'
            '<div class="b-house" role="group" aria-label="Your progress"><div><span class="b-k">Streak</span><span class="v b-d">3 nights</span><span class="s">cook tonight for 4</span></div>'
            '<div><span class="b-k">Rank</span><span class="v b-d">Commis</span><span class="s">level 2</span></div>'
            '<div><span class="b-k">To level 3</span><span class="v b-d">40 XP</span><span class="s">110 of 150</span></div><span class="b-xp" role="img" aria-label="110 of 150 XP"></span></div>'
            '<section class="b-special"><span class="flag b-k">Tonight\'s special</span><h2 class="b-d">%s</h2>'
            '<p class="from b-it">From your fridge: chicken thighs, lemon, garlic, butter, spinach and white wine.</p>'
            '<p class="meta b-u">Practises <b>Pan sauces</b> &middot; 30 min &middot; +40 XP</p>'
            '<div class="b-btn" role="button">Start cooking</div><div class="b-btn sec" role="button">%s Scan your fridge again</div></section>'
            '<section class="b-menu"><div class="b-menu-h"><h2 class="b-d">The menu</h2><p class="b-it">Twelve techniques in four courses. Cook a dish twice and it earns the chef\'s stamp.</p></div>%s'
            '<p class="b-fine b-it">New dishes are served once the ones before them are mastered.</p></section>') % (
                tomi(B, "happy", 66), LESSON, icon("camera", 20, 1.8), menu)
    return phone("dir-b-home", "B1", "Home", "full scroll height, the menu is the skill map", "b-screen", body, INK)


def illo(food="chicken", w=358, h=206):
    return ('<svg viewBox="0 4 358 210" width="%s" height="%s" preserveAspectRatio="xMidYMid slice" role="img" aria-label="A %s searing in a hot pan over a flame">'
            '<rect x="0" y="0" width="358" height="220" fill="#FBFAF5"/><circle cx="179" cy="118" r="88" fill="#EEF0F8"/><path d="M40 198.500h278" stroke="#1D3690" stroke-width="1.500"/>%s</svg>') % (
                w, h, "chicken thigh" if food == "chicken" else "slab of tofu", render(sear_shapes(food), B))


def step():
    body = ('<div class="b-top"><div class="b-ib" role="button" aria-label="Close lesson">%s</div>'
            '<div class="mid"><span class="b-k">Pan sauces</span><span class="t b-d">Step 1 of 6</span></div>'
            '<div class="b-ib on" role="button" aria-label="Read aloud is on">%s</div></div>'
            '<div class="b-ticks" aria-hidden="true"><i class="on"></i><i></i><i></i><i></i><i></i><i></i></div>'
            '<div class="b-body"><figure class="b-plate"><div class="in">%s</div><figcaption class="b-it">Fig. 1. Skin-side down, then hands off.</figcaption></figure>'
            '<p class="b-steptext">%s</p>'
            '<div class="b-timer"><span class="t b-d">7:30</span><span class="l">minutes, skin-side down. Tomi rings at the flip.</span><div class="b-btn sm sec" role="button">%s Start timer</div></div>'
            '<div class="b-tip">%s<div class="tx"><span class="b-k">Tomi\'s tip</span><p>%s</p></div></div></div>'
            '<div class="b-foot"><div class="b-btn sec sq" role="button" aria-label="Back">%s</div><div class="b-btn sec" role="button">%s Ask Tomi</div><div class="b-btn grow" role="button">Next step %s</div></div>') % (
                icon("close", 24, 1.8), icon("speaker", 23, 1.8), illo(), STEP1, icon("timer", 18, 1.8), tomi(B, "tip", 70), TIP1,
                icon("back", 22, 2), icon("mic", 19, 1.8), icon("arrow", 19, 2))
    return phone("dir-b-step", "B2", "Lesson step", "step 1 of 6, 390 x 844", "b-screen", body, INK, 844)


def onboarding():
    opts = ""
    for k, name, desc in DIETS:
        sel = k == "vegetarian"
        mark = ('<svg viewBox="0 0 34 34" width="34" height="34" aria-hidden="true"><path d="M5 19c3 2.500 5.500 6 7.500 9.500C16 19 22 10 31 3" fill="none" stroke="#D9402A" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/></svg>') if sel else ""
        opts += ('<div class="b-opt%s" role="radio" aria-checked="%s"><span class="bx">%s</span><span class="nm b-d">%s</span><span class="ld"></span><span class="d b-it">%s</span></div>') % (
            " sel" if sel else "", "true" if sel else "false", mark, name, desc.lower())
    body = ('<div class="b-ob-top"><span class="b-k">Question 1 of 4</span><div class="b-ticks" aria-hidden="true"><i class="on"></i><i></i><i></i><i></i></div></div>'
            '<div class="b-ob-hero">%s<p class="b-it">&ldquo;Good evening, I\'m Tomi. Four questions before I write your menu.&rdquo;</p></div>'
            '<div class="b-ob-body"><h1 class="b-d">What do you eat?</h1><p class="sub b-it">Dishes that do not fit never reach your menu. You can change this later in Settings.</p>'
            '<div class="b-opts" role="radiogroup">%s</div></div>'
            '<div class="b-foot"><div class="b-btn grow" role="button">Continue</div></div>') % (tomi(B, "happy", 108), opts)
    return phone("dir-b-onboarding", "B3", "Onboarding, question 1", "390 x 844", "b-screen", body, INK, 844)


PALETTE = [("#FBFAF5", "Paper", "background"), ("#EEF0F8", "Blue wash", "selected, plates"), ("#172A6E", "Ink", "text"),
           ("#1D3690", "Cobalt", "rules, primary action"), ("#C9321C", "Stamp red", "next up, red text"), ("#E4472F", "Print red", "Tomi, stamp fill"),
           ("#F1C232", "Yolk", "third print colour"), ("#46548A", "Faded ink", "secondary text")]


def style():
    return {
        "id": "dir-b-style",
        "palette": PALETTE,
        "dark": {"#172A6E", "#1D3690", "#C9321C", "#E4472F", "#46548A"},
        "type": ('<div class="b-screen ts"><p class="b-d" style="font-size:34px;line-height:38px;margin:0">Deglaze, reduce, mount</p>'
                 '<p class="tn">Gloock. Titles, dish names, timer digits.</p>'
                 '<p style="font-size:18px;line-height:24px;margin:10px 0 0">Sear skin-side down, <i>without moving them.</i></p>'
                 '<p class="tn">Newsreader 400 to 600 and italic. Steps, descriptions.</p>'
                 '<p class="b-k" style="margin:10px 0 0">First course &middot; Start cooking</p><p class="tn">Figtree 500 to 700. Labels, buttons, numbers.</p></div>'),
        "buttons": '<div class="b-screen ts" style="display:flex;flex-direction:column;gap:10px"><div class="b-btn">Start cooking</div><div class="b-btn sec">Scan your fridge</div></div>',
        "card": ('<div class="b-screen ts" style="display:flex;flex-direction:column;gap:10px"><div class="b-card"><span class="b-k" style="color:#C9321C">Tonight\'s special</span>'
                 '<div class="b-d" style="font-size:19px;line-height:24px">Lemon-butter pan sauce</div></div>'
                 '<div style="display:flex;gap:8px;flex-wrap:wrap"><span class="b-chip">Chicken thighs</span><span class="b-chip">Lemon</span></div>'
                 '<div>%s%s</div></div>') % (dish(SK["sear"]), dish(SK["braise"])),
        "moods": '<div class="b-screen ts moods">%s%s%s</div>' % (
            '<figure>%s<figcaption class="b-u">Hello</figcaption></figure>' % tomi(B, "happy", 100),
            '<figure>%s<figcaption class="b-u">Thinking</figcaption></figure>' % tomi(B, "think", 100),
            '<figure>%s<figcaption class="b-u">Nailed it</figcaption></figure>' % tomi(B, "cheer", 100)),
        "parts": '<div class="b-screen ts parts"><div style="border:1px solid #1D3690">%s</div><div style="border:1px solid #1D3690">%s</div></div>' % (illo("chicken", 196, 115), illo("tofu", 196, 115)),
        "tomi_note": "Three-ink print: cobalt line, red and yolk fills set slightly off register. His toque doubles as the mastery stamp.",
    }
