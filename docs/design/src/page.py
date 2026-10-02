# Review page chrome: header, per-direction layout, style strip, comparison.

PAGE_CSS = r"""
/* Layout: neutral studio page. Header, then three direction sections (two phone columns plus notes, then a style strip), then comparison. */
:root{--pg:#ECEAE5;--pg-ink:#1D1C1A;--pg-muted:#54514B;--pg-card:#F8F7F3;--pg-line:#D3CFC6;--pg-accent:#B5321E;
  --pg-font:"Instrument Sans",system-ui,-apple-system,"Segoe UI","Helvetica Neue",Arial,sans-serif;color-scheme:light}
*{box-sizing:border-box}
html{background:var(--pg)}
body{margin:0;background:var(--pg);color:var(--pg-ink);font-family:var(--pg-font);font-size:16px;line-height:1.5;-webkit-font-smoothing:antialiased}
.wrap{max-width:1248px;margin:0 auto;padding-inline:24px;padding-block:44px 96px}
h1,h2,h3,h4,p,figure{margin:0}
.pg-kick{font-size:13px;font-weight:700;letter-spacing:.08em;text-transform:uppercase;color:var(--pg-muted)}
.pg-h1{font-size:44px;line-height:48px;font-weight:700;letter-spacing:-.02em;margin-top:8px;text-wrap:balance}
.pg-lede{max-width:74ch;margin-top:18px;font-size:17px;line-height:27px}
.pg-lede + .pg-lede{margin-top:12px}
.banned{display:flex;flex-wrap:wrap;gap:8px;margin-top:18px;padding:0;list-style:none}
.banned li{font-size:13.5px;line-height:18px;padding:5px 10px;border:1px solid var(--pg-line);border-radius:6px;color:var(--pg-muted);text-decoration:line-through;text-decoration-color:var(--pg-accent);text-decoration-thickness:1.5px}
.pitches{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:16px;margin-top:32px}
.pitch{min-width:0;background:var(--pg-card);border:1px solid var(--pg-line);border-radius:14px;padding:18px 18px 16px;display:flex;flex-direction:column;gap:10px;color:inherit;text-decoration:none}
.pitch h3{font-size:19px;line-height:24px;display:flex;align-items:center;gap:10px}
.ltr{display:inline-grid;place-items:center;width:28px;height:28px;border-radius:7px;color:#fff;font-size:15px;font-weight:700;flex:none}
.pitch p{font-size:15px;line-height:22px}
.costs{display:grid;grid-template-columns:auto minmax(0,1fr);gap:6px 12px;font-size:14px;line-height:20px;margin:0;padding-top:10px;border-top:1px solid var(--pg-line)}
.costs dt{font-weight:700;white-space:nowrap}
.costs dd{margin:0;color:var(--pg-muted)}
.dir{margin-top:88px;scroll-margin-top:16px}
.dir-head{display:flex;gap:16px;align-items:flex-start;padding-bottom:22px;margin-bottom:28px;border-bottom:1.5px solid var(--pg-ink)}
.dir-head .ltr{width:44px;height:44px;border-radius:10px;font-size:24px}
.dir-head h2{font-size:30px;line-height:34px;letter-spacing:-.015em}
.dir-head p{font-size:16px;line-height:24px;color:var(--pg-muted);max-width:78ch;margin-top:4px}
.dir-grid{display:grid;grid-template-columns:410px 410px minmax(0,1fr);gap:30px;align-items:start}
.col{display:flex;flex-direction:column;gap:30px;min-width:0}
.notes{min-width:0;display:flex;flex-direction:column;gap:18px;font-size:14.5px;line-height:21px}
.notes h4{font-size:12.5px;letter-spacing:.08em;text-transform:uppercase;color:var(--pg-muted);margin-bottom:6px}
.notes ul{margin:0;padding:0;list-style:none;display:flex;flex-direction:column;gap:9px}
.notes li{padding-left:14px;position:relative}
.notes li::before{content:"";position:absolute;left:0;top:9px;width:6px;height:2px;background:var(--pg-ink)}
.notes li b{font-weight:700}
@media (max-width:1150px){.dir-grid{grid-template-columns:410px minmax(0,1fr)}.notes{grid-column:1/-1;display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:24px}}
@media (max-width:900px){.dir-grid{grid-template-columns:minmax(0,1fr)}.pitches{grid-template-columns:minmax(0,1fr)}.notes{display:flex}.pg-h1{font-size:34px;line-height:38px}}
.shot{display:flex;flex-direction:column;gap:10px;width:410px;max-width:100%;scroll-margin-top:16px}
.shot > figcaption{display:flex;align-items:baseline;gap:8px;font-size:14.5px;line-height:20px;flex-wrap:wrap}
.code{font-weight:700;font-size:12px;line-height:18px;padding:1px 7px;border-radius:5px;background:var(--pg-ink);color:#fff}
.cap-note{color:var(--pg-muted)}
.phone{width:410px;max-width:100%;border-radius:58px;background:#131313;padding:10px;box-shadow:0 34px 50px -34px rgba(20,18,14,.55)}
.screen{position:relative;width:390px;max-width:100%;border-radius:48px;overflow:hidden;min-height:844px;text-align:left}
.screen p,.screen h1,.screen h2,.screen h3{margin:0}
.screen svg{flex:none}
.sb{position:absolute;top:0;left:0;right:0;height:54px;display:flex;justify-content:space-between;align-items:center;padding:8px 30px 0 40px;font:600 16px/1 -apple-system,"SF Pro Text","Instrument Sans",system-ui,sans-serif;z-index:5;letter-spacing:0}
.sb-i{position:absolute;left:50%;top:12px;width:122px;height:35px;margin-left:-61px;border-radius:20px;background:#000}
.sb-r{display:flex;gap:6px;align-items:center}
.hb{position:absolute;left:50%;bottom:8px;width:138px;height:5px;margin-left:-69px;border-radius:3px;background:currentColor;opacity:.9;z-index:5}
.ic{display:block;flex:none}
/* style strip */
.style{margin-top:36px;scroll-margin-top:16px}
.style > h3{font-size:12.5px;letter-spacing:.08em;text-transform:uppercase;color:var(--pg-muted);margin-bottom:12px}
.style-grid{display:grid;grid-template-columns:repeat(12,minmax(0,1fr));gap:14px}
.sblock{min-width:0;background:var(--pg-card);border:1px solid var(--pg-line);border-radius:14px;padding:14px;display:flex;flex-direction:column;gap:10px}
.sblock h4{font-size:13px;font-weight:700}
.sblock .cap{font-size:13px;line-height:18px;color:var(--pg-muted)}
.s4{grid-column:span 4}.s3{grid-column:span 3}.s5{grid-column:span 5}.s6{grid-column:span 6}.s8{grid-column:span 8}
@media (max-width:900px){.s4,.s3,.s5,.s6,.s8{grid-column:1/-1}}
.swatches{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:8px}
.sw{min-width:0;border-radius:9px;padding:26px 8px 7px;font-size:11.5px;line-height:14px;border:1px solid rgba(0,0,0,.10);color:#1D1C1A;overflow-wrap:anywhere}
.sw.dk{color:#fff}
.sw b{display:block;font-size:12px}
.sw span{display:block;font-family:ui-monospace,"SF Mono",Menlo,monospace;font-size:11px;opacity:.92}
.ts{padding:16px;border-radius:10px;flex:1;min-width:0}
.ts .tn{font-family:var(--pg-font);font-size:12px;line-height:16px;margin:4px 0 0;opacity:.8;font-style:normal;font-weight:500;letter-spacing:0;text-transform:none}
.moods{display:flex;justify-content:space-around;align-items:flex-end;gap:6px}
.moods figure{display:flex;flex-direction:column;align-items:center;gap:4px;min-width:0}
.moods figcaption{font-size:12.5px;line-height:16px;font-weight:600}
.parts{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:10px;align-items:center}
.parts svg{display:block;width:100%;height:auto}
/* comparison */
.final{margin-top:96px}
.final h2{font-size:30px;line-height:34px;letter-spacing:-.015em}
.tw{overflow-x:auto;margin-top:20px;border:1px solid var(--pg-line);border-radius:14px;background:var(--pg-card)}
table.cmp{border-collapse:collapse;width:100%;min-width:760px;font-size:14.5px;line-height:21px}
.cmp th,.cmp td{text-align:left;vertical-align:top;padding:12px 16px;border-bottom:1px solid var(--pg-line)}
.cmp tr:last-child td,.cmp tr:last-child th{border-bottom:0}
.cmp thead th{font-size:14.5px;border-bottom:1.5px solid var(--pg-ink)}
.cmp tbody th{font-weight:700;width:17%}
.cmp td{width:27.6%}
.cmp .v{display:block;font-weight:700}
.cmp .v i{font-style:normal;display:inline-block;width:46px;height:6px;border-radius:3px;background:var(--pg-line);margin-right:8px;vertical-align:middle;position:relative;overflow:hidden}
.cmp .v i::after{content:"";position:absolute;inset:0;width:var(--w);background:var(--pg-ink)}
.rec{margin-top:28px;display:grid;grid-template-columns:minmax(0,1fr);gap:12px;background:var(--pg-ink);color:#F4F2EC;border-radius:16px;padding:26px 28px}
.rec .pg-kick{color:#BDB8AC}
.rec h3{font-size:24px;line-height:30px;letter-spacing:-.01em}
.rec p{max-width:78ch;font-size:16px;line-height:25px;color:#E7E4DC}
.rec p b{color:#fff}
"""

LTR = {"a": "#1F4F47", "b": "#1D3690", "c": "#5A2748"}

META = {
    "a": {
        "name": "Tomi's kitchen",
        "pitch": "Home is a room. The skills are the things in it, and they light up as you earn them.",
        "lede": "A cut-paper kitchen in enamel colours. The butter-yellow fridge is the scan button, tonight's lesson is a note taped beside it, and every pan, pot and jar is a skill. Unlit objects are locked, the burner that is on is tonight's.",
        "build": "Highest. About 14 code-drawn objects, each lit and unlit, placed by hand with custom hit areas.",
        "scale": "Weak. Skill 13 needs a new object and a spot in the room. Fitting 12 with readable labels already took two walls.",
        "next": "Medium. The lit burner and flag mark it, but that is a scroll away, so the note by the fridge has to say it too.",
        "notes": [
            ("Map", ["<b>Stations, not nodes.</b> Board, top shelf, pot shelf, four burners, two ovens. A skill is the object plus a shelf-edge label.",
                     "<b>State is drawn three ways:</b> full colour or grey silhouette, a label (Mastered, 1 of 2 cooks, Ready, Needs Boil), and pips or a lock.",
                     "<b>Next up</b> is the only burner with a flame and a turned knob."]),
            ("Game layer", ["<b>Streak</b> is a tear-off calendar, <b>XP</b> is a measuring jug filling toward the next level. Two objects with plain text, no pill row.",
                            "<b>Scan</b> is the fridge itself. The whole door is the touch target."]),
            ("Open questions", ["The scene is two walls stacked with a strip of floor between them. It reads as a doll's house, which may or may not be wanted.",
                                "Labels at 13 / 11.5 pt are the smallest text in the three directions."]),
        ],
    },
    "b": {
        "name": "Tasting menu",
        "pitch": "The skill path is a printed menu: four courses, twelve dishes, a chef's stamp when you master one.",
        "lede": "Cobalt ink on white paper with a red rubber stamp, like a bistro carte. The path is typeset, not illustrated. Tonight's lesson is the special, the next skill is circled in pen, and Tomi is drawn as a three-ink print.",
        "build": "Lowest. A list with custom rows. The only drawing is the stamp, the pen circle and the print-style Tomi.",
        "scale": "Best. A new skill is a new line, a new unit is a new course. 40 skills would still read.",
        "next": "High. The special sits at the top and the same dish is circled on the card below.",
        "notes": [
            ("Map", ["<b>Courses, not units.</b> A course heading is small type and a rule, never a coloured banner.",
                     "<b>Dish line:</b> name, dotted leader, state in words. Mastered adds Tomi's stamp, in progress shows two diamonds, locked shows a lock and what it needs.",
                     "<b>Next up</b> is circled by hand in red and tagged as tonight's special."]),
            ("Game layer", ["<b>Streak, rank and XP</b> are three columns of type under the masthead, like the head of a bill. Levels borrow kitchen ranks: level 2 is Commis.",
                            "<b>Scan</b> is the second button on the special. Before the first scan of the evening it becomes the primary one."]),
            ("Open questions", ["It is the least playful of the three. The stamp and the pen marks carry all of the warmth.",
                                "Serif body text is a risk at arm's length from a stove. The step screen sets it at 22 pt to compensate."]),
        ],
    },
    "c": {
        "name": "Recipe box",
        "pitch": "Every lesson you cook becomes a card you keep. Skills are the tabs, and the box fills up.",
        "lede": "Index cards, tab dividers and Tomi's handwriting, in a teal tin. Each skill card lists the dishes you have cooked for it, so progress is a collection you can cook from again. The next skill is the card pulled halfway out.",
        "build": "Medium. An overlapping card stack, one tab shape, a pulled-out state and small rotations. Standard layout, little drawing.",
        "scale": "Good. A skill is one more card behind a divider. Past about 30, dividers need to collapse, and the recipe collection will want search.",
        "next": "High as drawn: the pulled card and tonight's card agree. In a much longer box the pulled card can scroll out of view.",
        "notes": [
            ("Map", ["<b>Cards behind dividers.</b> Dividers are the four units. Tabs stagger left, middle, right like a real card file.",
                     "<b>State:</b> a mastered card lists its two recipes and carries a tick sticker, in progress shows one recipe and one empty slot, locked cards are kraft with a lock and what they need.",
                     "<b>Next up</b> is pulled out of the stack with tonight's recipe pencilled in."]),
            ("Game layer", ["<b>Cook's log</b> card: seven day boxes ticked by hand for the streak, and a pencil line for XP to the next level.",
                            "<b>Scan</b> is the fridge snapshot clipped to tonight's card, plus a labelled button."]),
            ("Open questions", ["The home screen is the longest of the three. A collapsed box (dividers only) may be the right default.",
                                "Handwriting is used for Tomi's voice only and never below 19 pt, but it still needs a legibility check on device."]),
        ],
    },
}


def header():
    cards = ""
    for k in "abc":
        m = META[k]
        cards += ('<a class="pitch" href="#dir-%s" id="pitch-%s"><h3><span class="ltr" style="background:%s">%s</span>%s</h3><p>%s</p>'
                  '<dl class="costs"><dt>Build</dt><dd>%s</dd><dt>Past 12 skills</dt><dd>%s</dd><dt>What is next</dt><dd>%s</dd></dl></a>') % (
                      k, k, LTR[k], k.upper(), m["name"], m["pitch"], m["build"], m["scale"], m["next"])
    return ('<header id="intro"><p class="pg-kick">Tomi for iPhone, design round 1</p>'
            '<h1 class="pg-h1">Three identities that come from the kitchen</h1>'
            '<p class="pg-lede" id="what-changed">The prototype borrowed its look from Duolingo. Every direction below drops the five traits that made it read that way and keeps what is Tomi\'s own: the tomato chef, the warm tone, and the game rules (XP, a nightly streak, two cooks to master a skill, prerequisites, one skill that is next up). '
            'Shapes now come from the kitchen: a room with stations, a printed menu, a box of recipe cards. Buttons are flat and sentence case. Streak, level and XP are shown as kitchen objects or plain type. Tomi is redrawn with arms, a tilted toque, leaves and four moods, in three treatments.</p>'
            '<p class="pg-lede">All three show the same progress and follow the real unlock rules: Knife basics, Eggs 101 and Searing are mastered, Boil &amp; blanch is at 1 of 2 cooks, Pan sauces is next up. Sauté, Roasting and Emulsions are ready because their only prerequisite, Knife basics, is done. Rice, Pasta, Braising and Balancing flavor are locked.</p>'
            '<ul class="banned" aria-label="Removed from the prototype"><li>winding column of ringed nodes and crowns</li><li>coloured Unit N banners</li><li>caps buttons with a hard bottom edge</li><li>flame, gem and crown pill row</li><li>fat rounded display type on flat primaries</li></ul>'
            '<div class="pitches">%s</div></header>') % cards


def swatches(pal, dark):
    out = ""
    for hx, name, use in pal:
        out += '<div class="sw%s" style="background:%s"><b>%s</b><span>%s</span>%s</div>' % (" dk" if hx in dark else "", hx, name, hx, use)
    return '<div class="swatches">%s</div>' % out


def direction(k, mod):
    m = META[k]
    s = mod.style()
    notes = ""
    for title, items in m["notes"]:
        notes += '<div><h4>%s</h4><ul>%s</ul></div>' % (title, "".join("<li>%s</li>" % i for i in items))
    strip = ('<div class="style" id="%s"><h3>Direction %s style sheet (light theme)</h3><div class="style-grid">'
             '<div class="sblock s5" id="dir-%s-palette"><h4>Palette</h4>%s</div>'
             '<div class="sblock s4" id="dir-%s-type"><h4>Type</h4>%s</div>'
             '<div class="sblock s3" id="dir-%s-buttons"><h4>Buttons</h4>%s</div>'
             '<div class="sblock s4" id="dir-%s-components"><h4>Card, chips, skill states</h4>%s</div>'
             '<div class="sblock s4" id="dir-%s-tomi"><h4>Tomi</h4>%s<p class="cap">%s</p></div>'
             '<div class="sblock s4" id="dir-%s-scene"><h4>Step scene parts</h4>%s<p class="cap">Vessel, heat, food and motion are separate parts. Swapping the food part gives the vegetarian sear with no new drawing.</p></div>'
             '</div></div>') % (s["id"], k.upper(), k, swatches(s["palette"], s["dark"]), k, s["type"], k, s["buttons"], k, s["card"], k, s["moods"], s["tomi_note"], k, s["parts"])
    return ('<section class="dir" id="dir-%s"><div class="dir-head"><span class="ltr" style="background:%s">%s</span><div><h2>%s</h2><p>%s</p></div></div>'
            '<div class="dir-grid"><div class="col">%s</div><div class="col">%s%s</div><aside class="notes" id="dir-%s-notes">%s</aside></div>%s</section>') % (
                k, LTR[k], k.upper(), m["name"], m["lede"], mod.home(), mod.step(), mod.onboarding(), k, notes, strip)


def bar(pct):
    return '<i style="--w:%s%%"></i>' % pct


def footer():
    rows = [
        ("Build effort", (30, "High cost", "About 14 drawn objects in two states, hand-placed, custom hit areas, and a scene that must be re-composed for iPad or larger type."),
                         (95, "Low cost", "A list. Stamp, pen circle and one Tomi print style are the only custom drawing."),
                         (65, "Medium cost", "Card stack with offsets, one tab shape, a pull-out animation. Cards reuse one component.")),
        ("Scales past 12 skills", (25, "Weak", "Each new skill needs an object and a place. More walls means more scrolling through scenery."),
                                  (95, "Strong", "A line per skill, a heading per course. Collapsing finished courses is trivial."),
                                  (75, "Good", "A card per skill. Needs collapsible dividers past about 30, and search once recipes pile up.")),
        ("How clear is what's next", (60, "Medium", "Lit burner and flag, but below the fold. Relies on the note by the fridge."),
                                     (90, "High", "The special on top, the same dish circled on the card."),
                                     (85, "High", "Tonight's card on top, the same skill pulled out of the box.")),
        ("Distance from Duolingo", (85, "Far", "A place, not a path. Risk: station labels with pips can drift back toward nodes if simplified."),
                                   (95, "Farthest", "No nodes, no colour coding, no mascot-led chrome."),
                                   (90, "Far", "Collection, not path. Tabs and stickers are stationery, not game UI.")),
        ("Kitchen and fridge in the identity", (95, "Strongest", "The fridge is literally the button."),
                                               (60, "Medium", "Dining room more than kitchen. The fridge is a button label."),
                                               (80, "Strong", "Home cooking's own filing system, with the fridge photo clipped to tonight's card.")),
        ("Reward after cooking", (70, "Good", "An object lights up. Nice the first time, the same the second."),
                                 (55, "Modest", "A stamp lands on the line."),
                                 (95, "Best", "You keep the recipe. The box holds dishes you can cook again, which is the product's promise.")),
    ]
    body = ""
    for i, (label, a, b, c) in enumerate(rows):
        cells = "".join('<td><span class="v">%s%s</span>%s</td>' % (bar(p), v, t) for p, v, t in (a, b, c))
        body += '<tr id="cmp-row-%s"><th scope="row">%s</th>%s</tr>' % (i + 1, label, cells)
    return ('<section class="final" id="comparison"><p class="pg-kick">Side by side</p><h2>The three directions on the same criteria</h2><p class="pg-lede" style="margin-top:8px;font-size:15px;line-height:22px;color:var(--pg-muted)">The bar shows how favourable the direction is on that row. Longer is better.</p>'
            '<div class="tw"><table class="cmp"><thead><tr><th scope="col"></th><th scope="col">A. Tomi\'s kitchen</th><th scope="col">B. Tasting menu</th><th scope="col">C. Recipe box</th></tr></thead><tbody>%s</tbody></table></div>'
            '<div class="rec" id="recommendation"><p class="pg-kick">Recommendation</p><h3>Build C, the recipe box, and borrow the fridge from A.</h3>'
            '<p><b>Why C.</b> It is the only direction where the reward is something real. After each lesson you own a recipe card, and the skill map is simply where those cards live. That matches the promise (learn to cook from what is in your fridge) better than lighting up an object or stamping a line, and it gives people a reason to open the app on nights they are not learning anything new.</p>'
            '<p><b>Why not the others.</b> A is the most charming picture and the most expensive to keep true: every new skill is an illustration and a layout problem, and the map is already two screens of scenery for twelve skills. B is the safest to build and the clearest list, but it moves Tomi out of the kitchen into a dining room and has the thinnest game feel.</p>'
            '<p><b>What to borrow.</b> From A, the fridge as a drawn object for the scan entry point and for the scan flow itself, and the cut-paper kitchen for celebration screens. From B, the discipline of the dish line: name, leader, state in words. Round 2 would take the chosen direction through scan, chips, quiz, celebration and Ask Tomi, in light and dark.</p></div></section>') % body
