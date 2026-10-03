# Builds ../round3.html: direction B completed (lesson player, scene kit, Ask Tomi,
# voice, skill detail, profile, settings, edge states), dark theme, and handoff.
# Run: python3 round3.py   (round1.html and round2.html are not touched)
import os, re, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import common
from common import *
import dir_b
import round2 as r2
from round2 import chip, box, TICK, stamp2, menu, mast, house, HOUSE3, MENU_H, fridge_open
from page import PAGE_CSS
import scenes3
from scenes3 import scene_svg, SCENES

common.ICONS.update({
    "thumbup": '<path d="M7 10.500v9.500H4v-9.500z"/><path d="M7 10.500l4 -7c1.600 0 2.700 1.100 2.700 2.700V10h5.100a2 2 0 0 1 2 2.400l-1.300 6a2 2 0 0 1 -2 1.600H7"/>',
    "thumbdown": '<path d="M7 13.500V4H4v9.500z"/><path d="M7 13.500l4 7c1.600 0 2.700 -1.100 2.700 -2.700V14h5.100a2 2 0 0 0 2 -2.400l-1.300 -6a2 2 0 0 0 -2 -1.600H7"/>',
    "gear": '<circle cx="12" cy="12" r="3.200"/><path d="M12 3v3M12 18v3M3 12h3M18 12h3M5.600 5.600l2.100 2.100M16.300 16.300l2.100 2.100M5.600 18.400l2.100 -2.100M16.300 7.700l2.100 -2.100"/>',
    "chev": '<path d="M9 5l7 7 -7 7"/>',
    "pause": '<path d="M8 5v14M16 5v14"/>',
    "up": '<path d="M12 19V5M6 11l6 -6 6 6"/>',
    "nomic": '<path d="M12 3.500a3 3 0 0 0 -3 3v5a3 3 0 0 0 6 0v-5a3 3 0 0 0 -3 -3z"/><path d="M5.500 11.500a6.500 6.500 0 0 0 13 0M12 18v3M4 4l16 16"/>',
})

INK = "#172A6E"
PAPER_D = "#F2EEE1"

B_DARK = {
    "mode": "print", "paper": "#0E1736", "line": "#F2EEE1", "lw": 2, "off": (2.5, 2),
    "pal": Pal(red="#E4472F", red_d="#E4472F", shade=None, hl=None, green="#6F86DB", white="#F2EEE1", hat_line="#0E1736", hat_shade=None,
               ink="#0E1736", blush=None, eye_hl="#F2EEE1", wood="#F1C232", wood_d="#F1C232", shadow=None),
}
HEXMAP = [("#1D3690", "#A9B8F5"), ("#FBFAF5", "#0E1736"), ("#D9402A", "#FF7A5C"), ("#C9D1EE", "#2B3A72"), ("#EEF0F8", "#1B2752"),
          ("#172A6E", "#F2EEE1"), ("#8E9BD0", "#55649E"), ("rgba(29,54,144,.45)", "rgba(169,184,245,.7)")]


def darkify(html):
    stash = []
    def sub(m):
        size = int(round(float(m.group(1)) * 128 / 136.0))
        stash.append(tomi(B_DARK, m.group(2), size))
        return "@@T%d@@" % (len(stash) - 1)
    html = re.sub(r'<svg class="tomi" viewBox="[^"]*" width="\d+" height="(\d+)" role="img" aria-label="Tomi the tomato chef, (\w+)">.*?</svg>', sub, html, flags=re.S)
    for a, b in HEXMAP:
        html = html.replace(a, b)
    for i, t in enumerate(stash):
        html = html.replace("@@T%d@@" % i, t)
    return html


CSS = r"""
/* ============ Round 3 additions ============ */
.r3-grid{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:46px 28px;align-items:start}
.r3-grid .shot{width:auto;min-width:0}
.r3-grid .phone{zoom:.89}
.r3-grid .shot-note{margin-top:2px;border:0;padding:0;font-size:13.5px;line-height:19px;max-width:365px}
@media (min-width:1340px){.r3-grid .phone{zoom:1}.r3-grid .shot-note{max-width:410px}}
@media (max-width:1150px){.r3-grid{grid-template-columns:repeat(2,minmax(0,1fr))}}
@media (max-width:800px){.r3-grid{grid-template-columns:minmax(0,1fr)}.r3-grid .phone{zoom:1}}
.hb{z-index:9}
.fold{position:absolute;left:0;right:0;top:844px;border-top:1.5px dashed #D9402A;z-index:8;pointer-events:none}
.fold::after{content:"fold, 844 pt";position:absolute;right:10px;top:-19px;font:700 10.5px/16px "Figtree",sans-serif;letter-spacing:.06em;color:#fff;background:#D9402A;padding:0 6px;border-radius:2px}
.decl{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:10px 28px;margin-top:22px;padding:0;list-style:none;font-size:15px;line-height:22px}
.decl li{padding-left:14px;position:relative;min-width:0}
.decl li::before{content:"";position:absolute;left:0;top:10px;width:6px;height:2px;background:var(--pg-ink)}
@media (max-width:900px){.decl{grid-template-columns:minmax(0,1fr)}}
.kit{display:grid;grid-template-columns:repeat(5,minmax(0,1fr));gap:14px}
.kit figure{min-width:0;background:#FBFAF5;border:1px solid var(--pg-line);border-radius:10px;padding:8px 10px 10px;display:flex;flex-direction:column;gap:2px}
.kit svg{display:block;width:100%;height:auto}
.kit b{font-size:14px;line-height:18px}
.kit span{font-size:12.5px;line-height:16px;color:var(--pg-muted)}
.kit .swap{grid-column:span 2;display:grid;grid-template-columns:1fr 1fr;gap:4px 10px}
.kit .swap b,.kit .swap span{grid-column:1 / -1}
@media (max-width:900px){.kit{grid-template-columns:repeat(2,minmax(0,1fr))}}
.tok{overflow-x:auto;border:1px solid var(--pg-line);border-radius:14px;background:var(--pg-card);margin-top:14px}
.tok table{border-collapse:collapse;width:100%;min-width:760px;font-size:14px;line-height:20px}
.tok th,.tok td{text-align:left;padding:8px 14px;border-bottom:1px solid var(--pg-line);vertical-align:middle}
.tok tr:last-child td{border-bottom:0}
.tok thead th{border-bottom:1.5px solid var(--pg-ink);font-size:13px}
.tok code{font-family:ui-monospace,"SF Mono",Menlo,monospace;font-size:12.5px}
.tok .sw{display:inline-block;width:34px;height:22px;border-radius:4px;border:1px solid rgba(0,0,0,.2);vertical-align:middle;margin-right:8px;padding:0}
.hand h3{font-size:19px;line-height:24px;margin-top:34px}
.hand > p{font-size:15px;line-height:22px;color:var(--pg-muted);max-width:80ch;margin-top:4px}
.comp{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:14px;margin-top:14px}
.comp > div{min-width:0;border:1px solid var(--pg-line);border-radius:12px;overflow:hidden;background:var(--pg-card);display:flex;flex-direction:column}
.comp .b-screen{padding:14px 16px;flex:1;display:flex;flex-direction:column;gap:10px;justify-content:center}
.comp h4{font-size:13.5px;line-height:18px;padding:9px 14px 0}
.comp p.cs{font-size:12.5px;line-height:17px;color:var(--pg-muted);padding:2px 14px 10px;margin:0}
@media (max-width:900px){.comp{grid-template-columns:minmax(0,1fr)}}
.moodrow{display:flex;gap:10px;flex-wrap:wrap;margin-top:14px}
.moodrow figure{display:flex;flex-direction:column;align-items:center;gap:4px;padding:10px 14px 8px;border-radius:12px;font-size:12.5px;font-weight:600;min-width:0}
.pal-d{display:grid;grid-template-columns:repeat(8,minmax(0,1fr));gap:8px;margin-top:14px}
@media (max-width:900px){.pal-d{grid-template-columns:repeat(4,minmax(0,1fr))}}

/* dark theme: same roles, night ink ground */
.b-dark{--paper:#0E1736;--ink:#F2EEE1;--blue:#A9B8F5;--red:#FF7A5C;--yolk:#F1C232;--rule:#33427A;--muted:#B9C1E3;--tint:#1B2752}
.b-dark .b-btn{background:#F2EEE1;color:#0E1736}
.b-dark .b-btn.sec{background:transparent;color:var(--blue)}
.b-dark .r-chip.lock,.b-dark .r-field .add,.b-dark .r-two .on{background:var(--blue);color:#0E1736}
.b-dark .r-seg i{color:#7686C4}
.b-dark .r-seg i.on{color:var(--blue)}
.b-dark .r-seg i.on.nv{background:#F2EEE1;color:#0E1736}
.b-dark .r-seg i.on.lv{background:var(--red);color:#0E1736}
.b-dark .r-chip.x{background:transparent}
.b-dark .r-cz.never .nm span{text-decoration-color:#FF7A5C}
.b-dark .b-dish .ld,.b-dark .r-alt .ld,.b-dark .r-sum .ld{border-bottom-color:#55649E}
.b-dark .l-scrim{background:rgba(2,6,22,.6)}
.b-dark .r-voice{background:var(--tint)}
.b-dark .a-q,.b-dark .r-chip.q em,.b-dark .u-yes{color:#0E1736}

/* lesson player */
.b-timer.run{background:var(--tint);margin:0 -16px;padding:8px 16px;position:relative}
.b-timer.run::after{content:"";position:absolute;left:0;bottom:-1px;height:3px;width:31%;background:var(--red)}
.b-timer.done{border-color:var(--red);border-width:2px}
.b-timer.done .t{color:var(--red)}
.b-timer.done .l b{display:block;font:400 19px/23px "Gloock",Georgia,serif;color:var(--ink)}
.l-scrim{position:absolute;inset:0;background:rgba(23,42,110,.38);z-index:6}
.l-sheet{position:absolute;left:0;right:0;bottom:0;z-index:7;background:var(--paper);border-top:3px double var(--blue);border-radius:16px 16px 0 0;padding:16px 20px 36px;display:flex;flex-direction:column;gap:10px}
.l-sheet h2{font-size:26px;line-height:31px}
.l-sheet .tx{font-size:16.500px;line-height:23px;color:var(--ink)}
.l-sheet .hd{display:flex;align-items:flex-end;gap:10px}
.l-intro{padding:10px 20px 0}
.l-intro h1{font-size:30px;line-height:35px;margin-top:6px;text-wrap:balance}
.screen .l-meta{font:500 13.500px/18px "Figtree",sans-serif;margin-top:8px}
.l-meta b{font-weight:700}
.l-box{margin-top:18px;border:1.5px solid var(--blue);border-radius:3px;padding:14px 16px;position:relative}
.l-box::before{content:"";position:absolute;inset:4px;border:1px solid var(--rule);pointer-events:none}
.l-box h2{font-size:24px;line-height:29px;margin-top:2px}
.l-box .tx{font-size:17px;line-height:24px;margin-top:6px;color:var(--ink)}
.l-why{display:flex;align-items:center;gap:10px;margin-top:16px}
.l-why .tx{flex:1;min-width:0}
.l-why p{font-size:17px;line-height:23px;font-style:italic;color:var(--ink);margin-top:2px}
.l-sec{margin-top:18px}
.l-sec .hd{padding-bottom:5px;border-bottom:1px solid var(--blue);display:flex;justify-content:space-between;align-items:baseline}
.l-sec .hd .b-it{font-size:14.500px}
.l-uses{display:flex;flex-wrap:wrap;gap:6px;margin-top:10px}
.q-body{padding:16px 20px 0}
.q-body h1{font-size:30px;line-height:35px;margin-top:6px;text-wrap:balance}
.q-opts{margin-top:18px;border-top:1px solid var(--blue)}
.q-opt{display:grid;grid-template-columns:26px minmax(0,1fr);gap:14px;align-items:start;padding:16px 2px;border-bottom:1px solid var(--rule);font-size:19px;line-height:25px;color:var(--ink)}
.q-opt .bx{margin-top:0}
.bx.xm svg{position:static}
.q-opt.sel{background:var(--tint);margin:0 -20px;padding-left:22px;padding-right:22px}
.q-opt.miss span.t{text-decoration:line-through;text-decoration-color:var(--red);color:var(--muted)}
.q-opt small{display:block;font:700 11px/16px "Figtree",sans-serif;letter-spacing:.14em;text-transform:uppercase;color:var(--red);margin-top:2px}
.q-res{margin-top:16px;padding:12px 14px 13px;background:var(--tint);border-left:3px solid var(--blue)}
.q-res.no{border-left-color:var(--red)}
.q-res b{display:block;font:400 21px/26px "Gloock",Georgia,serif}
.q-res p{font-size:16px;line-height:22px;margin-top:3px;color:var(--ink)}
.b-btn.off{background:transparent;color:var(--muted);box-shadow:inset 0 0 0 1.5px var(--rule)}
.f-rate{display:grid;grid-template-columns:1fr 1fr;gap:10px;margin-top:10px}
.f-rate div{display:flex;flex-direction:column;align-items:center;gap:6px;padding:14px 8px 12px;border:1.5px solid var(--blue);border-radius:4px;font:600 14.500px/18px "Figtree",sans-serif;color:var(--blue)}
.f-rate div.on{background:var(--tint)}
.c-wrap{padding:66px 20px 0;display:flex;flex-direction:column;align-items:center;text-align:center}
.c-wrap h1{font-size:38px;line-height:42px;margin-top:4px}
.c-wrap .sub{font-size:17px;line-height:23px;margin-top:6px}
.c-ink{width:100%;text-align:left;margin-top:20px;border-top:3px double var(--blue);border-bottom:1px solid var(--blue);padding:4px 0 0;position:relative}
.c-ink .b-dish{border-bottom:0}
.c-ink .b-k{display:block;padding-top:8px}
/* plate photo */
.p-photo{width:236px;margin-top:18px;padding:8px 8px 0;border:1.5px solid var(--blue);background:#fff;transform:rotate(-2deg)}
.p-photo svg{display:block;width:100%;height:auto}
.p-photo figcaption{font-size:14.5px;line-height:19px;padding:8px 4px 9px;text-align:center}
.s-line .ph{width:34px;height:34px;flex:none;margin:-6px 0 -6px 3px;border:1.5px solid var(--blue);background:#fff;overflow:hidden}
.s-line .ph svg{display:block;width:100%;height:100%}
.c-press{position:absolute;right:6px;top:10px;transform:rotate(-12deg)}
.c-press .b-stamp{margin:0;transform:none}
.c-new{display:inline-block;font:700 10.500px/16px "Figtree",sans-serif;letter-spacing:.12em;text-transform:uppercase;color:#fff;background:var(--red);padding:0 6px;border-radius:2px;margin-left:8px;vertical-align:3px}
.b-dark .c-new{color:#0E1736}
/* ask tomi */
.a-sheet{position:absolute;left:0;right:0;top:118px;bottom:0;z-index:7;background:var(--paper);border-top:3px double var(--blue);border-radius:16px 16px 0 0;display:flex;flex-direction:column}
.a-head{display:flex;align-items:center;gap:10px;padding:10px 8px 8px 16px;border-bottom:1px solid var(--rule)}
.a-head .tx{flex:1;min-width:0}
.a-head b{display:block;font:400 21px/25px "Gloock",Georgia,serif}
.a-head span{display:block;font:500 13px/17px "Figtree",sans-serif;color:var(--muted)}
.a-log{flex:1;min-height:0;padding:14px 16px 0;display:flex;flex-direction:column;gap:12px;overflow:hidden}
.a-q{align-self:flex-end;max-width:80%;background:var(--blue);color:#fff;border-radius:12px 12px 2px 12px;padding:8px 12px;font:500 15.500px/21px "Figtree",sans-serif}
.a-t{border-left:2px solid var(--red);padding:1px 0 1px 12px;font-size:17px;line-height:23px;color:var(--ink);max-width:94%}
.a-safe{border:1.5px solid var(--blue);border-radius:3px;background:var(--tint);padding:10px 12px 11px;max-width:94%}
.a-safe .b-k{display:flex;align-items:center;gap:6px;color:var(--blue)}
.a-safe b{display:block;font:400 26px/31px "Gloock",Georgia,serif;margin-top:4px}
.a-safe p{font-size:15.500px;line-height:21px;color:var(--ink);margin-top:2px}
.a-sugg{display:flex;flex-direction:column;gap:8px}
.a-sugg div{display:flex;align-items:center;justify-content:space-between;gap:8px;min-height:46px;padding:0 12px 0 14px;border:1.5px solid var(--blue);border-radius:3px;font:600 15.500px/20px "Figtree",sans-serif;color:var(--blue)}
.a-in{padding:10px 16px 34px;display:flex;gap:8px;align-items:center}
.a-in .r-field{flex:1;margin-top:0}
.a-note{font-size:15px;line-height:20px}
.a-fixed{border-top:1px solid var(--blue)}
.a-fixed div{padding:11px 0 10px;border-bottom:1px solid var(--rule)}
.a-fixed b{display:block;font:400 18px/23px "Gloock",Georgia,serif}
.a-fixed span{display:block;font-size:15.500px;line-height:21px;font-style:italic;color:var(--muted)}
/* voice */
.v-bar{position:absolute;left:0;right:0;bottom:0;padding:14px 16px 36px;background:var(--tint);border-top:1.5px solid var(--blue);display:flex;flex-direction:column;gap:8px;z-index:6}
.v-bar .row{display:flex;align-items:center;gap:12px}
.v-bar .tx{flex:1;min-width:0}
.v-bar b{display:block;font:400 21px/25px "Gloock",Georgia,serif}
.v-bar span.s{display:block;font:500 13.500px/18px "Figtree",sans-serif;color:var(--muted)}
.v-heard{font-size:18px;line-height:24px;font-style:italic;color:var(--ink)}
.v-cmds{display:flex;gap:6px;flex-wrap:wrap}
.v-cmds span{display:inline-flex;align-items:center;height:30px;padding:0 10px;border:1px solid var(--blue);border-radius:2px;font:600 13px/1 "Figtree",sans-serif;color:var(--blue);background:var(--paper)}
.v-hold{width:132px;height:132px;border-radius:50%;background:var(--blue);color:#fff;display:grid;place-items:center;box-shadow:0 0 0 10px var(--paper),0 0 0 11.500px var(--blue),0 0 0 22px var(--paper),0 0 0 23px var(--rule);margin:26px auto 22px}
.b-dark .v-hold{color:#0E1736}
.v-say{background:linear-gradient(transparent 58%,rgba(241,194,50,.55) 58%)}
/* skill detail, profile, settings */
.s-top{display:flex;align-items:center;justify-content:space-between;padding:56px 12px 0 6px;min-height:100px}
.s-top .bk{display:flex;align-items:center;gap:2px;font:600 15px/44px "Figtree",sans-serif;color:var(--blue)}
.s-body{padding:6px 20px 0}
.s-body h1{font-size:38px;line-height:42px;margin-top:6px;display:flex;align-items:center;gap:12px}
.s-body .sub{font-size:17px;line-height:23px;margin-top:4px}
.s-body .tx{font-size:17px;line-height:24px;color:var(--ink);margin-top:10px}
.s-line{display:flex;align-items:baseline;gap:8px;padding:11px 0 10px;border-bottom:1px solid var(--rule);min-height:46px}
.s-line .nm{font-size:18px;line-height:23px;min-width:0}
.s-line .ld{flex:1;min-width:12px;border-bottom:2px dotted #8E9BD0;transform:translateY(-4px)}
.s-line .v{font:600 13px/23px "Figtree",sans-serif;white-space:nowrap;display:inline-flex;align-items:center;gap:5px}
.s-line .v.it{font:italic 400 15px/23px "Newsreader",Georgia,serif;color:var(--muted)}
.s-line.blank .nm{font-style:italic;font-family:"Newsreader",Georgia,serif;font-size:15.500px;color:var(--muted)}
.s-line.cur{background:var(--tint);margin:0 -20px;padding-left:20px;padding-right:20px}
.s-line .lv{font:700 11px/23px "Figtree",sans-serif;letter-spacing:.1em;color:var(--muted);width:18px;flex:none}
.s-line.past .nm{color:var(--muted)}
.s-row{display:flex;align-items:baseline;gap:8px;min-height:52px;padding:14px 0 12px;border-bottom:1px solid var(--rule)}
.s-row .nm{font-size:19px;line-height:24px;white-space:nowrap}
.s-row .ld{flex:1;min-width:12px;border-bottom:2px dotted #8E9BD0;transform:translateY(-4px)}
.s-row .v{font:500 14.500px/24px "Figtree",sans-serif;color:var(--muted);text-align:right;display:inline-flex;align-items:center;gap:4px;white-space:nowrap}
.s-row.danger .nm{color:var(--red)}
.sw-t{display:inline-block;width:44px;height:26px;border-radius:13px;border:1.5px solid var(--blue);position:relative;vertical-align:middle;margin-left:6px;flex:none}
.sw-t::after{content:"";position:absolute;top:3px;left:3px;width:17px;height:17px;border-radius:50%;background:var(--blue)}
.sw-t.on{background:var(--blue)}
.sw-t.on::after{left:21px;background:var(--paper)}
/* review, revised */
.u-box{margin-top:18px;border:1.5px dashed var(--red);border-radius:3px;padding:10px 12px 4px}
.u-box .hd{display:flex;justify-content:space-between;align-items:baseline;gap:8px}
.u-box .hd .b-k{color:var(--red)}
.u-box .hd .b-it{font-size:14.500px}
.u-row{display:flex;align-items:center;gap:8px;padding:9px 0;border-top:1px solid var(--rule);margin-top:8px}
.u-row + .u-row{margin-top:0}
.u-row .nm{flex:1;min-width:0;font:600 16px/22px "Figtree",sans-serif;color:var(--ink)}
.u-row .nm small{display:block;font:italic 400 14px/18px "Newsreader",Georgia,serif;color:var(--muted)}
.u-yes,.u-no{display:inline-flex;align-items:center;gap:5px;height:44px;padding:0 12px;border-radius:3px;font:600 14.500px/1 "Figtree",sans-serif;white-space:nowrap}
.u-yes{background:var(--blue);color:#fff}
.u-no{box-shadow:inset 0 0 0 1.5px var(--blue);color:var(--blue)}
.n-box{margin-top:14px;padding:11px 14px 12px;background:var(--tint);font-size:15.500px;line-height:21px;color:var(--ink)}
.n-box .b-k{display:block;margin-bottom:2px}
.e-wrap{padding:8px 20px 0}
.e-wrap h1{font-size:34px;line-height:38px;margin-top:6px;text-wrap:balance}
.e-wrap .sub{font-size:17px;line-height:23px;margin-top:8px}
"""


# ---------------------------------------------------------------- helpers
def shot(id_, code, title, note, body, height=844, cls="b-screen", sb=INK, cap="", dark=False):
    if dark:
        body = darkify(body)
        cls += " b-dark"
        sb = PAPER_D
    style = ' style="height:%spx"' % height if height else ""
    fold = "" if height else '<div class="fold" aria-hidden="true"></div>'
    if not height and not cap:
        cap = "scrolls, full height"
    return ('<figure class="shot" id="' + id_ + '"><figcaption><span class="code">' + code + '</span><b>' + title + '</b><span class="cap-note">' + cap + '</span></figcaption>'
            '<div class="phone"><div class="screen ' + cls + '"' + style + '>' + statusbar(sb) + body + fold +
            '<div class="hb" aria-hidden="true" style="color:' + sb + '"></div></div></div><p class="shot-note">' + note + '</p></figure>')


def inner(fig):
    """Body of a round 2 screen, without its status bar and home bar."""
    m = re.search(r'<div class="screen [^"]*"[^>]*>(.*)<div class="hb"', fig, flags=re.S)
    b = m.group(1)
    return b[b.index("</svg></span></div>") + len("</svg></span></div>"):].replace('<div class="fold" aria-hidden="true"></div>', "")


def plate_fig(svg_inner, caption, label):
    return ('<figure class="b-plate"><div class="in"><svg viewBox="0 4 358 210" width="358" height="206" preserveAspectRatio="xMidYMid slice" role="img" aria-label="' + label + '">'
            '<rect x="0" y="0" width="358" height="220" fill="#FBFAF5"/><circle cx="179" cy="118" r="88" fill="#EEF0F8"/>' + svg_inner +
            '</svg></div><figcaption class="b-it">' + caption + '</figcaption></figure>')


def ltop(mid, ticks=1, voice="Voice on", close="Close lesson"):
    v = ('<div class="r-voice" role="switch" aria-checked="true">' + icon("speaker", 18, 1.8) + " " + voice + "</div>") if voice else "<div></div>"
    t = "".join('<i class="on"></i>' if i < ticks else "<i></i>" for i in range(6))
    return ('<div class="b-top v2"><div class="b-ib" role="button" aria-label="' + close + '">' + icon("close", 24, 1.8) + '</div>'
            '<div class="mid"><span class="b-k">Pan sauces</span><span class="t b-d">' + mid + '</span></div>' + v + '</div>'
            '<div class="b-ticks" aria-hidden="true">' + t + '</div>')


NAV = ('<div class="b-foot"><div class="b-btn sec sq" role="button" aria-label="Back">' + icon("back", 22, 2) + '</div><div class="b-btn sec" role="button">' +
       icon("chat", 19, 1.8) + ' Ask Tomi</div><div class="b-btn grow" role="button">Next step ' + icon("arrow", 19, 2) + '</div></div>')

T_IDLE = ('<div class="b-timer"><span class="t b-d">7:30</span><span class="l">minutes, skin-side down. Tomi rings at the flip.</span><div class="b-btn sm sec" role="button">' + icon("timer", 18, 1.8) + ' Start timer</div></div>')
T_RUN = ('<div class="b-timer run" role="timer"><span class="t b-d">5:12</span><span class="l">left of 7:30. Leave them alone, I will ring.</span><div class="b-btn sm sec" role="button">' + icon("pause", 18, 2) + ' Pause</div></div>')
T_DONE = ('<div class="b-timer done" role="alert"><span class="t b-d">0:00</span><span class="l"><b>Time to flip.</b>Ringing. Golden and it lifts easily?</span><div class="b-btn sm" role="button">Stop</div></div>')
STEP5 = "Take the pan off the heat. <b>Whisk in 2 tbsp cold butter</b> and the juice of half a lemon. Taste, then add salt."
TIP5 = "Off the heat, so the butter emulsifies and does not turn greasy."


def tipblock(text, mood="tip"):
    return '<div class="b-tip">' + tomi(B, mood, 70) + '<div class="tx"><span class="b-k">Tomi\'s tip</span><p>' + text + '</p></div></div>'


def step1(timer, footer=NAV, extra="", voice="Voice on", text=STEP1, tip=True):
    return (ltop("Step 1 of 6", 1, voice) + '<div class="b-body">' + plate_fig(scenes3.scene("sear"), "Fig. 1. Skin-side down, then hands off.", "Chicken searing in a pan") +
            '<p class="b-steptext">' + text + '</p>' + timer + (tipblock(TIP1) if tip else "") + '</div>' + footer + extra)


def whisk_scene():
    return (scenes3.R(scenes3.hob(0)) + scenes3.R(scenes3.pan()) + scenes3.G(232, 6, scenes3.whisk(), 26) +
            scenes3.R([F('rect x="138" y="108" width="26" height="18" rx="3" transform="rotate(-8 151 117)"', "yolk")]) +
            scenes3.R(scenes3.arc("M132 110q46 -24 92 -6", "M216 98l9 6 -8 7")))


# ---------------------------------------------------------------- 1. lesson player
def lp_intro():
    uses = "".join('<span class="r-use">' + u + "</span>" for u in ("chicken thighs", "lemon", "garlic", "butter", "spinach", "white wine")) + \
        "".join('<span class="r-use cup">' + u + "</span>" for u in ("oil", "salt"))
    body = (ltop("Before you start", 0, voice="") + '<div class="l-intro"><p class="b-k" style="color:var(--red)">Tonight\'s special</p>'
            '<h1 class="b-d">' + LESSON + '</h1><p class="l-meta">Practises <b>Pan sauces</b> &middot; 6 steps &middot; 30 min &middot; for 2</p>'
            '<div class="l-box"><span class="b-k">The technique</span><h2 class="b-d">Pan sauces</h2>'
            '<p class="tx">Searing leaves browned bits stuck to the pan. That is the fond. Liquid dissolves it, simmering concentrates it, and cold butter swirled in at the end thickens it into a glossy sauce.</p></div>'
            '<div class="l-why">' + tomi(B, "happy", 74) + '<div class="tx"><span class="b-k">Why tonight</span><p>You have mastered searing, so this is next. It uses the chicken, lemon and wine in your fridge.</p></div></div>'
            '<div class="l-sec"><div class="hd"><span class="b-k">You will use</span><span class="b-it">nothing to buy</span></div><div class="l-uses">' + uses + '</div></div>'
            '<div class="l-sec"><div class="hd"><span class="b-k">Get out</span><span class="b-it">before the heat goes on</span></div><div class="l-uses"><span class="r-use cup">a heavy pan</span><span class="r-use cup">wooden spoon</span><span class="r-use cup">whisk</span><span class="r-use cup">a plate</span></div></div></div>'
            '<div class="r-flow"><div class="b-btn" role="button">Start cooking</div><div class="r-link" role="button">Not tonight</div></div>')
    return shot("lp-intro", "1a", "Lesson intro", "Dish, technique, and why Tomi chose it tonight, in that order. The concept is three sentences and lives in the same double-ruled box as the special. Ingredient chips are solid for the fridge and pale for the cupboard, as on home. Voice is offered from step 1, not here.", body, height=None)


def lp_step_timer():
    return shot("lp-step-timer", "1b", "Step, timer running", "The timer block turns into a wash-coloured band with the time left, a red rule that drains along its bottom edge, and Pause. Nothing else on the screen moves, so the cook can glance and look away.", step1(T_RUN))


def lp_notify():
    sheet = ('<div class="l-scrim"></div><div class="l-sheet" role="dialog" aria-label="Allow notifications"><div class="hd">' + tomi(B, "tip", 72) +
             '<div><span class="b-k">First timer</span><h2 class="b-d">Shall I ring when it is up?</h2></div></div>'
             '<p class="tx">Timers ring when the phone is locked or your hands are full. iOS will ask you to confirm.</p>'
             '<div class="r-opt" role="checkbox" aria-checked="false" style="margin-top:2px">' + box(False) + '<div class="tx">Also nudge me at dinner time<small>once a day at most</small></div><span class="r-time">17:30</span></div>'
             '<div class="b-btn" role="button">' + icon("bell", 20, 1.8) + ' Allow and start the timer</div>'
             '<div class="r-link" role="button">Start it without ringing</div></div>')
    return shot("lp-notify", "1c", "First timer: notification prompt", "<b>Moved out of onboarding.</b> It appears once, the first time Start timer is tapped, when the reason is obvious. Either answer starts the timer, so the cook is never blocked with a hot pan. The dinner reminder is off by default here.", step1(T_IDLE, extra=sheet))


def lp_timer_done():
    foot = ('<div class="b-foot"><div class="b-btn sec sq" role="button" aria-label="Back">' + icon("back", 22, 2) + '</div><div class="b-btn sec" role="button">+1 min</div>'
            '<div class="b-btn grow" role="button">Next: flip ' + icon("arrow", 19, 2) + '</div></div>')
    return shot("lp-timer-done", "1d", "Timer finished", "The block gets a red rule and says what to do, not only that time is up, with a doneness cue. Stop silences it, +1 min is one tap, and the primary button names the next action.", step1(T_DONE, footer=foot))


def lp_step_plain():
    body = (ltop("Step 5 of 6", 5) + '<div class="b-body">' + plate_fig(whisk_scene(), "Fig. 5. Off the heat, cold butter, keep it moving.", "Whisking butter into a pan off the heat") +
            '<p class="b-steptext">' + STEP5 + '</p>' + tipblock(TIP5) +
            '<div class="n-box"><span class="b-k">This is the lesson</span>Mounting with butter is the move you are here to learn. Watch for the sauce turning glossy.</div></div>' + NAV)
    return shot("lp-step-plain", "1e", "Step, no timer", "No timer, so no timer block: the space goes to a short note marking the step that carries tonight's technique. Same frame, type and footer as every other step.", body)


QUIZ_Q = "Why do you add the butter off the heat?"
QUIZ = ["So it melts faster", "So it emulsifies into a glossy sauce and does not separate", "To cool the chicken down"]

def quiz(state):
    opts = ""
    for i, o in enumerate(QUIZ):
        cls, mark, extra = "", box(False), ""
        if state == "right" and i == 1:
            cls, mark = " sel", box(True)
        if state == "wrong":
            if i == 0:
                cls, mark, extra = " miss", '<span class="bx xm" style="display:grid;place-items:center;color:var(--blue)">' + icon("close", 18, 2.4) + "</span>", "<small>Your answer</small>"
            if i == 1:
                cls, mark, extra = " sel", box(True), "<small>The answer</small>"
        opts += '<div class="q-opt' + cls + '" role="radio">' + mark + '<div><span class="t">' + o + "</span>" + extra + "</div></div>"
    res, foot = "", ""
    if state == "ask":
        foot = '<div class="b-foot col"><p class="r-hint b-it">Pick one, then check.</p><div class="b-btn off" role="button" aria-disabled="true">Check</div></div>'
    elif state == "right":
        res = '<div class="q-res" role="status"><b>Correct. 10 XP</b><p>Cold butter whisked into a warm liquid, not a boiling one, forms an emulsion. Too much heat breaks it and leaves the sauce oily.</p></div>'
        foot = '<div class="b-foot col"><div class="b-btn" role="button">Continue</div></div>'
    else:
        res = '<div class="q-res no" role="status"><b>Not quite.</b><p>Cold butter whisked into a warm liquid, not a boiling one, forms an emulsion. Too much heat breaks it. No XP lost, and I will ask again next time.</p></div>'
        foot = '<div class="b-foot col"><div class="b-btn" role="button">Continue</div></div>'
    return (ltop("Quick check", 6, voice="") + '<div class="q-body"><p class="b-k">One question &middot; +10 XP</p><h1 class="b-d">' + QUIZ_Q + '</h1>'
            '<div class="q-opts" role="radiogroup">' + opts + "</div>" + res + "</div>" + foot)


def lp_quiz():
    return shot("lp-quiz", "1f", "Quiz, before answering", "One written question per lesson, set as three tick rows. Check is drawn disabled (outlined, grey) until a row is ticked.", quiz("ask"))


def lp_quiz_right():
    return shot("lp-quiz-right", "1g", "Quiz, correct", "The ticked row washes blue, and the explanation block has a blue rule and the XP in words. No colour flash, no sound cue needed.", quiz("right"))


def lp_quiz_wrong():
    return shot("lp-quiz-wrong", "1h", "Quiz, wrong", "The cook's answer is struck through and labelled, the right one is ticked and labelled, and the same explanation appears with a red rule. Wrong answers cost nothing; the question returns in a later lesson.", quiz("wrong"))


def lp_finish():
    body = (ltop("Service", 6, voice="") + '<div class="q-body">' + plate_fig(scenes3.scene("plate"), "Fig. 7. On the plate.", "The finished dish on a plate").replace('height:206px', '') +
            '<p class="b-k" style="margin-top:16px">Last thing</p><h1 class="b-d">Did you cook it?</h1>'
            '<p class="b-it" style="font-size:16px;line-height:22px;margin-top:6px">Only dishes you really cooked count toward the stamp.</p>'
            '<p class="b-k" style="margin-top:18px">How was the lesson?</p>'
            '<div class="f-rate" role="radiogroup"><div class="on" role="radio" aria-checked="true">' + icon("thumbup", 26, 1.8) + 'Good lesson</div><div role="radio" aria-checked="false">' + icon("thumbdown", 26, 1.8) + 'Needs work</div></div></div>'
            '<div class="b-foot col"><div class="b-btn" role="button">Yes, I cooked it</div><div class="r-link" role="button">I stopped early</div></div>')
    return shot("lp-finish", "1i", "Finish: did you cook it?", "An honest question with two answers; only \"Yes\" counts toward mastery, and stopping early keeps the lesson for another night. The thumbs are optional and labelled in words. Thumbs down opens a one-line \"what went wrong\" field (not drawn).", body)


def celebrate_a():
    line = dir_b.dish(("pansauce", "Pan sauces", "Deglaze the fond, reduce, mount with butter", 2, "progress", 1, "", []))
    body = ('<div class="c-wrap">' + tomi(B, "cheer", 118) + '<p class="b-k" style="margin-top:8px">Friday 2 October</p><h1 class="b-d">Dinner is served.</h1>'
            '<p class="sub b-it">Your first pan sauce. One more and it earns the stamp.</p>'
            '<div class="c-ink"><span class="b-k">Inked onto your menu</span>' + line + '</div></div>' +
            house(("Earned", "50 XP", "40 dish, 10 quiz"), ("Streak", "3 weeks", "2 of 3 this week"), ("New rank", "Cook", "level 3")).replace('class="b-xp"', 'class="b-xp" style="display:none"') +
            '<div class="b-foot col"><div class="b-btn" role="button">Back to the menu</div><div class="b-btn sec" role="button">' + icon("camera", 20, 1.8) + ' Show me the plate</div><div class="r-link" role="button">Save this dish to cook again</div></div>')
    return shot("lp-celebrate", "1j", "Celebration, progress toward the stamp", "<b>The reward is the menu changing.</b> The dish line is written in with its first diamond filled, under a double rule, as if the card had just been reprinted. XP, streak and the new rank use the same three columns as home. In the app the line draws in left to right and the diamond fills last. \"Show me the plate\" is an optional extra: everything on this card is already earned without it.", body)


def celebrate_b():
    line = dir_b.dish(("boil", "Boil & blanch", "Salted water, timing, shocking veg", 0, "mastered", 2, "", [])).replace("Mastered" + stamp2(), "")
    new = dir_b.dish(("rice", "Rice & grains", "Ratios, absorption, resting", 1, "ready", 0, "", [])).replace("Rice &amp; grains", "Rice & grains").replace(
        '<span class="nm b-d">Rice & grains</span>', '<span class="nm b-d">Rice & grains<span class="c-new">New</span></span>')
    body = ('<div class="c-wrap">' + tomi(B, "cheer", 104) + '<p class="b-k" style="margin-top:8px">Second cook</p><h1 class="b-d">Stamped.</h1>'
            '<p class="sub b-it">Boil &amp; blanch is yours. It stays on the menu to cook whenever you like.</p>'
            '<div class="c-ink"><span class="b-k">Mastered</span>' + line + '<div class="c-press">' + stamp2(92) + '</div></div>'
            '<div class="c-ink" style="border-top:1px solid var(--blue);margin-top:14px"><span class="b-k">Now served</span>' + new + '</div></div>' +
            house(("Earned", "50 XP", "40 dish, 10 quiz"), ("Streak", "4 weeks", "goal met"), ("First course", "3 of 3", "all stamped")).replace('class="b-xp"', 'class="b-xp" style="display:none"') +
            '<div class="b-foot col"><div class="b-btn" role="button">Back to the menu</div><div class="b-btn sec" role="button">' + icon("camera", 20, 1.8) + ' Show me the plate</div></div>')
    return shot("lp-celebrate-stamp", "1k", "Celebration, stamp earned", "The second cook presses the stamp, large and off-square, over the dish line; in the app it lands with a short press and a haptic. Below it, anything newly unlocked is added to the menu with a \"New\" tag. Shown for Boil &amp; blanch, because mastering it serves Rice &amp; grains.", body)


def plate_photo(label="Your photo of the finished dish", box="64 64 230 172"):
    return ('<svg viewBox="' + box + '" role="img" aria-label="' + label + '"><rect x="0" y="0" width="358" height="300" fill="#EEF0F8"/>' +
            scenes3.scene("plate") + '</svg>')


def lp_plate():
    body = ('<div class="c-wrap" style="padding-top:62px"><p class="b-k">Friday 2 October</p><h1 class="b-d">That looks like dinner.</h1>'
            '<figure class="p-photo">' + plate_photo() + '<figcaption class="b-it">Seared chicken thighs with lemon-butter pan sauce</figcaption></figure>'
            '<div class="l-why" style="width:100%;text-align:left;margin-top:20px">' + tomi(B, "happy", 74) +
            '<div class="tx"><span class="b-k">Tomi says</span><p>Deep golden skin and a sauce that shines. That gloss is the butter you mounted at the end.</p></div></div></div>'
            '<div class="b-foot col"><p class="r-hint b-it">Kept with Pan sauces. It stays on this phone.</p>'
            '<div class="b-btn" role="button">Back to the menu</div><div class="r-link" role="button">Take it again</div></div>')
    return shot("lp-plate", "1l", "Plate photo, kept", "<b>A keepsake, not a test.</b> Shown after \"Show me the plate\". Tomi makes one warm remark about what the technique should show (colour, gloss) and never gives a score. He never says a dish is cooked through or safe: a photo cannot tell. The photo is kept with the dish on the menu and stays on the phone. Without Apple Intelligence it is kept with no remark.", body)


# ---------------------------------------------------------------- 3. ask tomi
def ask_sheet(log, field="Ask about this step", unavailable=False):
    head = ('<div class="a-head">' + tomi(B, "happy", 46) + '<div class="tx"><b>Ask Tomi</b><span>Step 1, searing the chicken</span></div><span class="r-time" role="timer" aria-label="Timer, 5:12 left">5:12</span><div class="b-ib" role="button" aria-label="Close">' + icon("close", 22, 1.8) + '</div></div>')
    inp = ('<div class="a-in"><div class="r-field"><span class="b-it">' + field + '</span><div class="add" role="button" aria-label="Send">' + icon("up", 20, 2.4) + '</div></div>'
           '<div class="r-sq" role="button" aria-label="Hold to talk" style="width:52px;height:52px">' + icon("mic", 22, 1.8) + '</div></div>')
    if unavailable:
        inp = '<div class="a-in" style="padding-top:0"><div class="b-btn sec grow" role="button" style="flex:1">Back to the step</div></div>'
    return step1(T_RUN, extra='<div class="l-scrim"></div><div class="a-sheet" role="dialog" aria-label="Ask Tomi">' + head + '<div class="a-log">' + log + "</div>" + inp + "</div>")


def ask_open():
    log = ('<p class="a-note b-it">Ask anything about this dish. I know the recipe, the step you are on and what is in your kitchen.</p>'
           '<div class="a-sugg">' + "".join('<div role="button">' + q + icon("chev", 18, 2) + "</div>" for q in ("How do I know it is done?", "What can I use instead of white wine?", "Explain this step more simply", "My pan is smoking. What now?")) + "</div>")
    return shot("ask-open", "3a", "Ask Tomi, opened from a step", "A sheet over the step. The running timer is repeated in the sheet's header, so it is never out of sight. Four suggested questions written for this step do most of the work; the field and hold-to-talk are for everything else.", ask_sheet(log))


def ask_thread():
    log = ('<div class="a-q">How do I know when to flip?</div>'
           '<div class="a-t">When the skin is deep golden and the thigh lifts without sticking. If it clings, give it another minute. It lets go when it is ready.</div>'
           '<div class="a-q">What temperature is chicken safe at?</div>'
           '<div class="a-safe"><span class="b-k">' + icon("check", 14, 3) + 'From the safety table</span><b>74 &deg;C in the thickest part</b>'
           '<p>That is 165 &deg;F. Thighs taste better taken a little higher. No thermometer? Cut in: the juices should run clear.</p></div>'
           '<p class="a-note b-it">Temperatures and allergens are looked up, never guessed.</p>')
    return shot("ask-thread", "3b", "A short exchange, with a safety-table answer", "Questions sit right in cobalt; Tomi's replies are serif with a red rule. A food-safety answer is a different object: a boxed card with a tick, the number in display type and the label \"From the safety table\", so the cook can tell a checked fact from a generated sentence.", ask_sheet(log, "Ask a follow-up"))


def ask_off():
    log = ('<div class="n-box" style="margin-top:0"><span class="b-k">Free questions are off</span>The on-device model is not ready on this iPhone right now. The answers below were written with the recipe, and safety numbers still work.</div>'
           '<p class="b-k" style="margin-top:4px">For this step</p><div class="a-fixed">'
           '<div><b>How do I know when to flip?</b><span>Deep golden skin that lifts without sticking.</span></div>'
           '<div><b>Can I move them around?</b><span>No. Dry skin browns. Moving it steams it.</span></div>'
           '<div><b>What temperature is safe?</b><span>74 &deg;C in the thickest part, from the safety table.</span></div></div>')
    return shot("ask-off", "3c", "Model unavailable", "When Apple's model is downloading or busy, Ask Tomi does not vanish mid-recipe. It says so in one sentence and falls back to the questions written with the lesson, plus the safety table. On an iPhone with no Apple Intelligence at all, the Ask Tomi button is hidden instead (see 7c).", ask_sheet(log, unavailable=True))


# ---------------------------------------------------------------- 4. voice
def wave(n=22, live=True):
    import math
    bars = ""
    for i in range(n):
        h = 6 + (abs(math.sin(i * 1.7)) * 22 if live else 3)
        bars += '<rect x="%s" y="%.1f" width="3" height="%.1f" rx="1.5" fill="#1D3690"/>' % (i * 6, 16 - h / 2, h)
    return '<svg viewBox="0 0 %s 32" width="%s" height="32" aria-hidden="true">%s</svg>' % (n * 6, n * 6, bars)


def voice_listen():
    bar = ('<div class="v-bar" role="status"><div class="row">' + tomi(B, "think", 52) + '<div class="tx"><b>Listening</b><span class="s">Hands-free is on</span></div>' + wave() + '</div>'
           '<p class="v-heard">&ldquo;Tomi, start the tim&hellip;&rdquo;</p>'
           '<div class="v-cmds" aria-label="Things you can say"><span>next</span><span>back</span><span>repeat</span><span>start the timer</span><span>how long left?</span></div></div>')
    return shot("voice-listening", "4a", "Listening", "With hands-free on, the footer becomes a listening bar: a live level meter, the words as they are heard, and the five commands that never need the model. Anything else is passed to Ask Tomi. Tapping the bar turns listening off.", step1(T_IDLE, footer="", extra=bar, voice="Hands-free", tip=False))


def voice_speak():
    text = '<span class="v-say">Pat 4 chicken thighs dry and salt both sides.</span> <b>Sear skin-side down</b> in a hot pan with a little oil for 7 to 8 minutes, <b>without moving them</b>.'
    bar = ('<div class="v-bar" role="status"><div class="row">' + tomi(B, "happy", 52) + '<div class="tx"><b>Reading step 1</b><span class="s">Say &ldquo;stop&rdquo; or tap to interrupt</span></div>'
           '<div class="r-sq" role="button" aria-label="Stop reading" style="width:48px;height:48px;background:var(--paper)">' + icon("pause", 22, 2) + '</div></div></div>')
    return shot("voice-speaking", "4b", "Tomi speaking", "While Tomi reads, the sentence being spoken is underlined in yolk and the bar says what he is doing and how to interrupt. The microphone is paused while he talks, so he does not hear himself.", step1(T_IDLE, footer="", extra=bar, voice="Hands-free", text=text))


def voice_hold():
    bar = ('<div class="v-bar" style="align-items:center;text-align:center;padding-top:18px"><b style="font:400 21px/25px Gloock,Georgia,serif">Go on, I am listening</b>'
           '<p class="v-heard">&ldquo;how long left&rdquo;</p>'
           '<div class="v-hold" role="button" aria-pressed="true" aria-label="Hold to talk">' + icon("mic", 44, 1.6) + '</div>'
           '<span class="s" style="font:500 13.500px/18px Figtree,sans-serif;color:var(--muted)">Release to send. Slide away to cancel.</span></div>')
    return shot("voice-hold", "4c", "Hold to talk", "The backup for noisy kitchens and for people who do not want an open microphone: press and hold the mic (in the footer or in Ask Tomi), speak, release. The control is 132 pt so a knuckle can hit it.", step1(T_RUN, footer="", extra=bar, tip=False))


def voice_primer():
    pts = [("mic", "Say next, back, repeat or start the timer without touching the phone."),
           ("phone", "I listen only during a lesson, on this phone. Nothing is recorded or uploaded."),
           ("nomic", "Rather not? Hold-to-talk and the buttons do everything voice does.")]
    body = (r2.top(None, skip=False) + '<div class="r-body" style="padding-top:0"><div class="r-hero">' + tomi(B, "think", 112) +
            '<div class="r-banner" style="margin-bottom:34px"><span class="b-k"><span>You</span><span>hands full</span></span><b>&ldquo;Tomi, next.&rdquo;</b><span class="t">Step 2 is read aloud.</span></div></div>' +
            r2.head("First use of hands-free", "May I listen while you cook?", "iOS will ask you to confirm on the next screen.") +
            '<div class="r-pts">' + "".join('<div class="r-pt">' + icon(i, 24, 1.8) + "<span>" + t + "</span></div>" for i, t in pts) + '</div></div>' +
            r2.foot("Allow microphone", link="Not now", ic="mic"))
    return shot("voice-primer", "4d", "Microphone primer", "Shown the first time hands-free is switched on, never at launch. Same shape as the camera primer: what it is for, where the audio goes, and the alternative.", body)


# ---------------------------------------------------------------- 5. skill detail
def sline(name, val, cls="", it=False, pre=""):
    return '<div class="s-line ' + cls + '">' + pre + '<span class="nm b-d">' + name + '</span><span class="ld"></span><span class="v' + (" it" if it else "") + '">' + val + "</span></div>"


def stop(back="The menu", right=""):
    return '<div class="s-top"><div class="bk" role="button">' + icon("back", 22, 2) + back + "</div>" + right + "</div>"


def skill_mastered():
    body = (stop() + '<div class="s-body"><p class="b-k">Second course &middot; Heat control</p><h1 class="b-d">Searing' + stamp2(46).replace('class="b-stamp"', 'class="b-stamp" style="margin:0"') + '</h1>'
            '<p class="sub b-it">Dry surface, hot pan, hands off</p>'
            '<p class="tx">Browning is flavour. A dry surface and a properly hot pan build a crust; moving the food too soon tears it off. You learned to wait.</p>'
            '<div class="l-sec"><div class="hd"><span class="b-k">Cooked for it</span><span class="b-it">2 of 2, mastered</span></div>' +
            sline("Seared mushrooms on toast", "1 Oct " + icon("chev", 14, 2.2)) + sline("Crisp-skin chicken thighs", "30 Sep " + '<span class="ph">' + plate_photo("Your photo of this dish", "104 82 150 150") + '</span>') + '</div>'
            '<div class="l-sec"><div class="hd"><span class="b-k">It unlocked</span><span class="b-it">on your menu now</span></div>' +
            sline("Pan sauces", "Next up " + dir_b.pips(0)) + sline("Braising", icon("lock", 13, 2) + " also needs Roasting") + '</div></div>'
            '<div class="b-foot col"><div class="b-btn sec" role="button">Practise it again tonight</div></div>')
    return shot("skill-mastered", "5a", "Skill detail, mastered", "What opens when a dish line is tapped. Title with its stamp, the technique in three sentences, the two dishes cooked for it (each opens the recipe to cook again; a dish with a plate photo shows it in place of the arrow), and what it unlocked. A mastered skill can still be chosen for tonight, as a secondary action.", body)


def skill_ready():
    body = (stop() + '<div class="s-body"><p class="b-k">Second course &middot; Heat control</p><h1 class="b-d">Saut&eacute;</h1>'
            '<p class="sub b-it">Hot pan, small pieces, keep it moving</p>'
            '<p class="tx">The opposite of searing: small pieces, high heat, constant motion, so everything cooks fast and evenly without stewing.</p>'
            '<div class="l-sec"><div class="hd"><span class="b-k">Cooked for it</span><span class="b-it">0 of 2 ' + dir_b.pips(0) + '</span></div>' +
            sline("first cook, to be written", "", "blank") + sline("second cook earns the stamp", "", "blank") + '</div>'
            '<div class="l-sec"><div class="hd"><span class="b-k">Served after</span><span class="b-it">done</span></div>' +
            '<div class="s-line"><span class="nm b-d">Knife basics</span><span class="ld"></span>' + stamp2(34) + '</div></div>'
            '<div class="l-sec"><div class="hd"><span class="b-k">It unlocks</span><span class="b-it">with Boil &amp; blanch</span></div>' + sline("Pasta & starch water", icon("lock", 13, 2) + " Locked") + '</div></div>'
            '<div class="b-foot col"><p class="r-hint b-it">I will pick a saut&eacute; dish from your next scan.</p><div class="b-btn" role="button">Make it tonight\'s focus</div></div>')
    return shot("skill-ready", "5b", "Skill detail, ready", "The same page before any cooking: two blank lines waiting to be written, what it was served after, what it unlocks. The primary button makes it tonight's focus, which changes the circled dish on the menu and what the next scan looks for.", body)


# ---------------------------------------------------------------- 6. profile and settings
LADDER = [(1, "Novice", 0), (2, "Commis", 150), (3, "Cook", 300), (4, "Saucier", 450), (5, "Sous", 600), (6, "Chef", 750), (7, "Patron", 900), (8, "Toque", 1050)]
HISTORY = [("Thu 1 Oct", "Seared mushrooms on toast", "Searing"), ("Wed 30 Sep", "Crisp-skin chicken thighs", "Searing"), ("Tue 29 Sep", "Green beans, lemon butter", "Boil & blanch"),
           ("Sat 26 Sep", "Spinach and parmesan omelette", "Eggs 101"), ("Thu 24 Sep", "Soft scramble on toast", "Eggs 101"), ("Tue 22 Sep", "Garlic and chili greens", "Knife basics"),
           ("Mon 21 Sep", "Chopped Greek salad", "Knife basics")]

def profile():
    lad = ""
    for lv, name, xp in LADDER:
        cls = "cur" if lv == 2 else ("past" if lv < 2 else "")
        val = "260 XP, you are here" if lv == 2 else (icon("check", 14, 2.6) + " " + str(xp) + " XP" if lv < 2 else str(xp) + " XP")
        lad += sline(name, val, cls, pre='<span class="lv">' + str(lv) + "</span>")
    hist = "".join('<div class="r-alt"><div class="row"><span class="nm b-d">' + d + '</span><span class="ld"></span><span class="sk">' + s + '</span></div><p class="b-it">' + w + "</p></div>" for w, d, s in HISTORY)
    body = (stop("Home", '<div class="b-ib" role="button" aria-label="Settings">' + icon("gear", 24, 1.8) + "</div>") +
            '<header class="b-mast" style="padding-top:0">' + tomi(B, "happy", 66) + '<h1 class="b-d">Your record</h1><p class="b-k">Cooking since 21 September</p></header>' +
            house(("Cooked", "7 dishes", "3 stamps"), ("Streak", "3 weeks", "best 3"), ("Rank", "Commis", "level 2")) +
            '<div class="s-body"><div class="l-sec" style="margin-top:22px"><div class="hd"><span class="b-k">The brigade</span><span class="b-it">150 XP a rank</span></div>' + lad + '</div>'
            '<div class="l-sec" style="margin-top:26px"><div class="hd"><span class="b-k">Cooked so far</span><span class="b-it">newest first</span></div>' + hist + '</div></div><div style="height:50px"></div>')
    return shot("profile", "6a", "Profile: rank ladder and history", "<b>The proposed ladder, level 1 upward: Novice, Commis, Cook, Saucier, Sous, Chef, Patron, Toque.</b> Every name is seven letters or fewer so it fits the stats column at 24 pt. 150 XP a rank puts Toque at 1,050 XP, about where all twelve stamps land. History is a dated list of dish lines; each opens its recipe.", body, height=None)


def settings():
    def row(n, v, cls=""):
        return '<div class="s-row ' + cls + '" role="button"><span class="nm b-d">' + n + '</span><span class="ld"></span><span class="v">' + v + "</span></div>"
    ch = icon("chev", 16, 2.2)
    sw = lambda on: '<span class="sw-t' + (" on" if on else "") + '" role="switch" aria-checked="' + ("true" if on else "false") + '"></span>'
    body = (stop("Your record") + '<div class="s-body"><h1 class="b-d" style="margin-top:0">Settings</h1>'
            '<div class="l-sec"><div class="hd"><span class="b-k">Your menu</span><span class="b-it">changes apply from tonight</span></div>' +
            row("Diet", "Everything " + ch) + row("Never serve", "Nuts, shellfish " + ch) + row("Cuisines", "2 loved, 1 never " + ch) + row("Kitchen", "Stovetop, oven, microwave " + ch) +
            row("Table and units", "For 2, metric " + ch) + row("Cupboard", "12 staples " + ch) + '</div>'
            '<div class="l-sec" style="margin-top:24px"><div class="hd"><span class="b-k">Tomi</span><span class="b-it">voice and reminders</span></div>' +
            row("Read steps aloud", "On" + sw(True)) + row("Hands-free listening", "Off" + sw(False)) + row("Dinner reminder", "17:30" + sw(True)) + '</div>'
            '<div class="l-sec" style="margin-top:24px"><div class="hd"><span class="b-k">Progress</span><span class="b-it">cannot be undone</span></div>' +
            row("Reset progress", "asks twice " + ch, "danger") + '</div>'
            '<p class="b-fine b-it" style="margin-top:18px">Everything stays on this phone.</p></div><div style="height:50px"></div>')
    return shot("settings", "6b", "Settings", "Every onboarding answer is one line here, with its current value, and opens the same screen used in onboarding. Voice and the reminder are switches with the state written beside them. Reset is red, last, and confirms twice.", body, height=None)


# ---------------------------------------------------------------- 7. revised review and edge states
def scan_review_first():
    found = ["eggs", "spinach", "parmesan", "lemon", "cherry tomatoes", "cucumber", "butter", "milk", "white wine"]
    urow = lambda n, why: ('<div class="u-row"><div class="nm">' + n + "?<small>" + why + '</small></div><div class="u-yes" role="button">' + icon("check", 16, 2.6) + 'I have it</div><div class="u-no" role="button">' + icon("close", 16, 2.2) + "No</div></div>")
    staples = "".join(chip(n, "lock") for n in ("Oil", "Salt", "Pepper")) + "".join(chip(n, "on" if on else "off") for n, on in r2.STAPLES)
    body = ('<div class="r-top"><div class="b-ib" role="button" aria-label="Back">' + icon("back", 22, 2) + '</div><div style="flex:1"></div></div>'
            '<div class="r-body" style="padding-top:0"><div class="r-revh"><div class="tx"><p class="b-k">Check my list</p><h1 class="b-d">Here is what I found.</h1></div>'
            '<div class="r-mini" role="button"><div>' + fridge_open(52, 66) + '</div>Retake</div></div>'
            '<div class="r-grp"><div class="hd"><span class="b-k">From your fridge</span><span class="b-it">9 counted</span></div><div class="r-chips">' + "".join(chip(n, "x") for n in found) + '</div></div>'
            '<div class="u-box"><div class="hd"><span class="b-k">Not sure, not counted</span><span class="b-it">2 to confirm</span></div>' +
            urow("Feta", "a white block, top shelf") + urow("Spring onions", "something green in the drawer") + '</div>'
            '<div class="r-grp"><div class="hd"><span class="b-k">Your cupboard, first time</span><span class="b-it">I will remember these</span></div>'
            '<p class="r-legend b-it" style="margin-top:8px">Tick what is always there, so you never photograph the salt.</p><div class="r-chips">' + staples + '</div>'
            '<div class="r-field"><span class="b-it">Add another, for example cumin</span><div class="add" role="button" aria-label="Add">' + icon("plus", 20, 2.4) + '</div></div></div>'
            '<div class="r-grp"><div class="hd"><span class="b-k">Add something</span><span class="b-it">anything I missed in the fridge</span></div>'
            '<div class="r-field"><span class="b-it">Type an ingredient</span><div class="add" role="button" aria-label="Add">' + icon("plus", 20, 2.4) + '</div></div></div></div>'
            '<div class="r-flow"><p class="r-hint b-it">9 from the fridge, 10 from the cupboard.</p><div class="b-btn" role="button">Write tonight\'s special</div></div>')
    return shot("scan-review-first", "7a", "First scan review, revised", "<b>Two decisions applied.</b> Unsure items are no longer chips among the others: they sit in their own dashed box, are not counted, and each needs \"I have it\" or \"No\". Tomi says what he saw, so the cook knows what to check. And the cupboard question, moved out of onboarding, is asked here once, in context; on later scans this group is the short \"From your cupboard\" row from round 2.", body, height=None)


def edge_camera():
    body = (r2.top(None, skip=False) + '<div class="e-wrap"><div class="r-hero" style="margin-top:0">' + tomi(B, "think", 112) + r2.fridge_closed() + '</div>'
            '<p class="b-k">Camera is off for Tomi</p><h1 class="b-d">I cannot see the fridge.</h1>'
            '<p class="sub b-it">Camera access was declined. You can switch it on in Settings, pick a photo you already took, or just tell me what you have.</p></div>'
            '<div class="b-foot col"><div class="b-btn" role="button">' + icon("keyboard", 20, 1.8) + ' Type what I have</div>'
            '<div class="b-btn sec" role="button">' + icon("photos", 20, 1.8) + ' Choose a photo</div><div class="r-link" role="button">Open Settings to allow the camera</div></div>')
    return shot("edge-camera-denied", "7b", "Camera permission denied", "Shown instead of the capture screen. Typing is promoted to the primary button because it always works; the photo library does not need camera permission; Settings is a link, since the app cannot ask twice.", body)


def edge_noai():
    body = (mast("happy") + house(*r2.HOUSE0, zero=True) +
            '<section class="b-special"><span class="flag b-k">Tonight\'s special</span><div class="blank"><span class="b-it">to be written</span><i></i></div>'
            '<h2 class="b-d">What have you got tonight?</h2><p class="from b-it">Type a few ingredients and I will write the special from them.</p>'
            '<div class="b-btn" role="button">' + icon("keyboard", 20, 1.8) + ' Type what you have</div><p class="r-cup">Cupboard: oil, salt, pepper and 7 more. <u>Edit</u></p></section>'
            '<div class="n-box" style="margin:18px 16px 0"><span class="b-k">On this iPhone</span>Reading fridge photos and Ask Tomi need Apple Intelligence, which this iPhone does not have. Lessons, timers, voice reading and your menu all work.</div>'
            '<section class="b-menu" style="padding-top:26px">' + MENU_H + menu(r2.zero_skills(), only=(0,)) + '</section>')
    return shot("edge-no-ai", "7c", "No Apple Intelligence", "Home on an older iPhone. The scan button is not shown disabled, it is simply absent: typing is the one way in. A single note explains what is missing and what still works. Inside lessons the Ask Tomi button is hidden and the footer is Back and Next only.", body, height=844, cls="b-screen r-crop", cap="first screenful")


def edge_streak():
    hs = (("Streak", "0 weeks", "was 12, your best"), ("Rank", "Cook", "level 3"), ("To level 4", "134 XP", "366 of 500"))
    body = (mast("think") + house(*hs).replace('class="b-xp"', 'class="b-xp" style="--x:1"') +
            '<div class="n-box" style="margin:18px 16px 0"><span class="b-k" style="color:var(--red)">The stove went cold</span>Last week ended short of your 3 cooking days, so the count starts again. Your stamps, rank and recipes are all still here.</div>'
            '<section class="b-special" style="margin-top:22px"><span class="flag b-k">Tonight\'s special</span><div class="blank"><span class="b-it">to be written</span><i></i></div>'
            '<h2 class="b-d" style="font-size:22px;line-height:27px">Start a new run this week. What have you got?</h2>'
            '<div class="b-btn" role="button">' + icon("camera", 20, 1.8) + ' Scan your fridge</div><div class="r-link" role="button" style="min-height:40px">' + icon("keyboard", 20, 1.8) + ' Type what you have</div></section>'
            '<section class="b-menu">' + MENU_H + '</section>')
    return shot("edge-streak-lost", "7d", "Streak lost", "No guilt and no \"repair\" upsell. The streak column tells the truth (0, and the best run), one note says what was lost and what was not, and the screen moves straight on to tonight. Tomi is thoughtful, not sad.", body, height=844, cls="b-screen r-crop", cap="first screenful")


def edge_all():
    done = [(s[0], s[1], s[2], s[3], "mastered", 2, "", []) for s in SKILLS]
    hs = (("Stamps", "12 of 12", "the whole menu"), ("Rank", "Toque", "level 8"), ("Streak", "31 weeks", "best 31"))
    body = (mast("cheer") + house(*hs).replace('class="b-xp"', 'class="b-xp" style="display:none"') +
            '<section class="b-special"><span class="flag b-k">Chef\'s choice</span><h2 class="b-d">Every dish is stamped.</h2>'
            '<p class="from b-it">Nothing left to unlock, so I will pick whatever suits your fridge and keeps a technique sharp. Guest menus with new cuisines arrive here.</p>'
            '<div class="b-btn" role="button">' + icon("camera", 20, 1.8) + ' Scan your fridge</div><div class="r-link" role="button" style="min-height:40px">' + icon("keyboard", 20, 1.8) + ' Type what you have</div></section>'
            '<section class="b-menu">' + MENU_H + menu(done) + '<p class="b-fine b-it">All twelve, mastered.</p></section>')
    return shot("edge-all-mastered", "7e", "All twelve mastered", "The special becomes \"Chef's choice\": Tomi picks for the fridge and to keep skills in use. The XP rule is gone because there is no next rank. The menu below is the trophy: twelve stamped lines. This is also where guest menus will be announced.", body, height=None)


# ---------------------------------------------------------------- dark screens
def d_home():
    body = (mast("happy") + house(*HOUSE3) +
            '<section class="b-special"><span class="flag b-k">Tonight\'s special</span><h2 class="b-d">' + LESSON + '</h2>'
            '<div class="uses"><span class="r-use">chicken thighs</span><span class="r-use">lemon</span><span class="r-use">spinach</span><span class="r-use">white wine</span><span class="r-use cup">butter</span><span class="r-use cup">garlic</span></div>'
            '<p class="meta b-u">Practises <b>Pan sauces</b> &middot; 30 min &middot; +40 XP</p>'
            '<div class="b-btn" role="button">Start cooking</div><div class="b-btn sec" role="button">' + icon("camera", 20, 1.8) + ' Scan again</div></section>'
            '<section class="r-also"><p class="b-k">Also on tonight</p>'
            '<div class="r-alt"><div class="row"><span class="nm b-d">Lemon and garlic saut&eacute;ed spinach</span><span class="ld"></span><span class="sk">Saut&eacute;</span></div><p class="b-it">Uses spinach, lemon. 10 min</p></div></section>'
            '<section class="b-menu" style="padding-top:26px">' + MENU_H + menu(SKILLS) + '</section>')
    return shot("dark-home", "D1", "Home with a special", "Paper-coloured type on night ink. Rules and outlines become chalk blue, the primary button inverts to paper, and the stamp and pen circle use a lighter red that holds 6.9:1 on the ground. \"Also on tonight\" lists one dish: a second match was Mexican, which this cook set to never, so it is not offered.", body, height=None, dark=True)


def d_review():
    return shot("dark-review", "D4", "Scan review", "The dashed \"not sure\" box keeps its red edge; confirmed chips are outlined, cupboard chips are washed, locked staples are solid chalk blue with dark text.", inner(scan_review_first()), height=None, dark=True)


def d_cuisines():
    fig = r2.ob_cuisines()
    return shot("dark-cuisines", "D5", "Onboarding, cuisines", "Never is solid paper with a dark cross, love is solid red, try is the quiet middle. The struck-through name keeps its red line.", inner(fig), height=None, dark=True)


# ---------------------------------------------------------------- page sections
def kit():
    out = ""
    for name, label, parts in SCENES:
        out += '<figure id="scene-' + name + '">' + scene_svg(name, label=label) + "<b>" + label + "</b><span>" + parts + "</span></figure>"
    out += ('<figure class="swap" id="scene-swap-sear">' + scene_svg("sear", "chicken", label="Sear, chicken") + scene_svg("sear", "tofu", label="Sear, tofu") +
            '<b>Food swap: sear</b><span>Only the main part changes: chicken thigh to tofu.</span></figure>')
    out += ('<figure class="swap" id="scene-swap-plate">' + scene_svg("plate", "chicken", label="Plate, chicken") + scene_svg("plate", "tofu", label="Plate, tofu") +
            '<b>Food swap: plate</b><span>Same plate, greens and sauce. The main is the only new part.</span></figure>')
    return '<div class="kit">' + out + "</div>"


DARK_PAL = [("#0E1736", "Night ink", "ground", True), ("#1B2752", "Night wash", "selected, bands", True), ("#F2EEE1", "Paper", "text, primary button", False),
            ("#A9B8F5", "Chalk blue", "rules, outlines, links", False), ("#FF7A5C", "Stamp red, lit", "stamp, next up, alerts", False), ("#E4472F", "Print red", "Tomi", True),
            ("#F1C232", "Yolk", "third ink", False), ("#B9C1E3", "Faded chalk", "secondary text", False)]


def dark_palette():
    sw = "".join('<div class="sw' + (" dk" if dk else "") + '" style="background:' + hx + '"><b>' + n + "</b><span>" + hx + "</span>" + use + "</div>" for hx, n, use, dk in DARK_PAL)
    return ('<div class="pal-d" id="dark-palette">' + sw + '</div>'
            '<p class="pg-lede" style="font-size:15px;line-height:22px;margin-top:14px" id="dark-contrast">Contrast on Night ink #0E1736: Paper 15.0:1, Faded chalk 9.6:1, Chalk blue 8.9:1, Stamp red lit 6.9:1, Yolk 10.6:1. '
            'On Night wash #1B2752: Paper 12.4:1, Faded chalk 7.9:1. Primary button is Night ink on Paper, 15.0:1. Print red is used only for Tomi\'s body and never for text. '
            'Rule colour #33427A is decorative (1.8:1) and never the only carrier of meaning. Ratios are calculated from the hex values, not measured on a device.</p>')


def tok_table(head, rows):
    return ('<div class="tok"><table><thead><tr>' + "".join("<th scope=\"col\">" + h + "</th>" for h in head) + "</tr></thead><tbody>" +
            "".join("<tr>" + "".join("<td>" + c + "</td>" for c in r) + "</tr>" for r in rows) + "</tbody></table></div>")


def swc(hx):
    return '<span class="sw" style="background:' + hx + '"></span><code>' + hx + "</code>"


def handoff():
    colours = [("paper", "Ground", swc("#FBFAF5"), swc("#0E1736")), ("wash", "Selected rows, bands, plates", swc("#EEF0F8"), swc("#1B2752")),
               ("ink", "Text", swc("#172A6E"), swc("#F2EEE1")), ("cobalt", "Rules, outlines, links, primary fill (light)", swc("#1D3690"), swc("#A9B8F5")),
               ("inkFaded", "Secondary text", swc("#46548A"), swc("#B9C1E3")), ("rule", "Hairlines", swc("#C3CAE6"), swc("#33427A")),
               ("leader", "Dotted leaders, inactive marks", swc("#8E9BD0"), swc("#55649E")), ("stampRed", "Stamp, pen marks, red text, alerts", swc("#C9321C") + " text, " + swc("#D9402A") + " marks", swc("#FF7A5C")),
               ("printRed", "Tomi's body", swc("#E4472F"), swc("#E4472F")), ("yolk", "Third ink, highlights", swc("#F1C232"), swc("#F1C232")),
               ("onPrimary", "Text on the primary button", swc("#FFFFFF"), swc("#0E1736")), ("primaryFill", "Primary button fill", swc("#1D3690"), swc("#F2EEE1"))]
    types = [("displayXL", "Gloock 400", "40 / 44", "Welcome, celebration"), ("displayL", "Gloock 400", "34 / 38", "Question and screen titles"), ("displayM", "Gloock 400", "30 / 35", "Lesson and quiz titles"),
             ("title", "Gloock 400", "25 / 30", "Tonight's special, sheet titles"), ("value", "Gloock 400", "24 / 28", "Stats values, rank names"), ("dish", "Gloock 400", "19 / 24", "Dish lines, tick rows (20 to 22 on onboarding)"),
             ("timer", "Gloock 400, tabular", "40 / 44", "Timer digits"), ("step", "Newsreader 500", "22 / 30", "Step text; key phrase 600 italic"), ("body", "Newsreader 400", "17 / 23", "Explanations, answers"),
             ("description", "Newsreader 400 italic", "15 / 20", "Dish descriptions, hints (16 / 22 under titles)"), ("label", "Figtree 700, +0.14 em, caps", "11 / 14", "Kickers, column heads"),
             ("button", "Figtree 600", "16.5 / 20", "Buttons (15 small)"), ("status", "Figtree 600", "13 / 24", "Dish state, values"), ("chip", "Figtree 600", "15.5 / 20", "Chips (13 on use tags)")]
    spacing = [("space", "4, 8, 12, 16, 20, 24, 32", "Screen side margin is 20 (16 on lesson steps and footers). Rows are 52 to 66 tall."), ("radius", "2 tick box and tags, 3 chips, fields and boxes, 4 buttons, 16 sheets, 50% stamp", "Nothing else is rounded."),
               ("rule", "1 hairline, 1.5 outline, 2 dotted leader, 3 double rule", "Double rule opens a block; a single cobalt rule closes a heading."), ("target", "44 minimum", "Chips are 44 tall, segment cells 44 by 44, buttons 52, small buttons 44.")]
    comp = [
        ("Button", "primary, secondary (outline), small, disabled (grey outline), text link, square icon", '<div class="b-btn">Start cooking</div><div class="b-btn sec">' + icon("camera", 20, 1.8) + ' Scan again</div><div class="b-btn off">Check</div>'),
        ("Tick row", "empty, ticked (red hand tick, wash band), with leader and note", '<div class="b-opts" style="margin:0"><div class="b-opt sel" style="min-height:58px;padding-top:16px;margin:0 -16px;padding-left:18px;padding-right:18px"><span class="bx" style="align-self:flex-start">' + TICK + '</span><span class="nm b-d">Oven</span><span class="ld"></span><span class="d b-it">roasting</span></div><div class="b-opt" style="min-height:58px;padding-top:16px"><span class="bx" style="align-self:flex-start"></span><span class="nm b-d">Blender</span><span class="ld"></span><span class="d b-it">soups</span></div></div>'),
        ("Cuisine control", "never (ink fill, name struck), try (wash, default), love (red fill)", "".join('<div class="r-cz ' + st + '" style="grid-template-columns:1fr 135px"><div class="nm b-d"><span>' + n + '</span></div><div class="r-seg"><i class="nv' + (" on" if st == "never" else "") + '">' + icon("close", 20, 2.4) + '</i><i class="' + ("on" if st == "try" else "") + '">' + icon("dot", 20, 2.2) + '</i><i class="lv' + (" on" if st == "love" else "") + '">' + icon("heart", 20, 2.2) + "</i></div></div>" for n, st in (("Italian", "love"), ("Mexican", "never"), ("Thai", "try")))),
        ("Chip", "locked, on, off, off tonight, removable, use tag (fridge, cupboard), missing", '<div class="r-chips" style="margin:0">' + chip("Salt", "lock") + chip("Rice", "on") + chip("Flour", "off") + chip("Onions", "out") + chip("lemon", "x") + '</div><div class="l-uses" style="margin:0"><span class="r-use">spinach</span><span class="r-use cup">butter</span><span class="r-miss">eggs</span></div>'),
        ("Unsure row", "awaiting an answer; becomes a removable chip on \"I have it\", disappears on \"No\"", '<div class="u-box" style="margin:0"><div class="hd"><span class="b-k">Not sure, not counted</span></div><div class="u-row"><div class="nm">Feta?<small>a white block</small></div><div class="u-yes">' + icon("check", 16, 2.6) + 'I have it</div><div class="u-no">' + icon("close", 16, 2.2) + 'No</div></div></div>'),
        ("Dish line", "mastered (stamp), in progress (diamonds), ready, next up (pen circle), locked", "".join(dir_b.dish(SK[k]) for k in ("sear", "boil", "pansauce", "rice"))),
        ("Stamp", "42 on dish lines, 30 inline, 92 pressed on the celebration", '<div style="display:flex;align-items:center;gap:22px;padding:6px 0">' + stamp2(42).replace('class="b-stamp"', 'class="b-stamp" style="margin:0"') + stamp2(30).replace('class="b-stamp"', 'class="b-stamp" style="margin:0"') + stamp2(92).replace('class="b-stamp"', 'class="b-stamp" style="margin:0"') + "</div>"),
        ("Stats columns", "three cells; the XP rule under them is optional", '<div style="margin:0 -16px">' + house(*HOUSE3) + "</div>"),
        ("Timer block", "idle, running (wash band, red drain rule), finished (red rule, action words)", T_IDLE + T_RUN.replace('class="b-timer run"', 'class="b-timer run" style="margin:0 -16px"') + T_DONE),
        ("Tip", "Tomi, red label, italic line", tipblock(TIP1)),
        ("Progress rule", "segments, one per step or question", '<div class="b-ticks" style="margin:6px 0"><i class="on"></i><i class="on"></i><i></i><i></i><i></i><i></i></div><div class="b-ticks" style="margin:6px 0;grid-template-columns:repeat(6,1fr)"><i class="on"></i><i class="on"></i><i class="on"></i><i class="on"></i><i></i><i></i></div>'),
        ("Sheet and note", "sheet: double rule top, 16 radius, scrim behind. Note: wash box with a label", '<div class="n-box" style="margin:0"><span class="b-k">Please note</span>I cannot read packaging, so please still check the labels.</div>'),
    ]
    comp_html = "".join('<div id="comp-' + n.lower().replace(" ", "-") + '"><h4>' + n + '</h4><p class="cs">' + st + '</p><div class="b-screen">' + ex + "</div></div>" for n, st, ex in comp)
    moods = "".join('<figure style="background:#FBFAF5;color:#172A6E">' + tomi(B, m, 84) + "<figcaption>" + l + "</figcaption></figure>" for m, l in (("happy", "happy: greeting, default"), ("tip", "tip: tips, prompts"), ("think", "think: waiting, unsure"), ("cheer", "cheer: celebration"), ("wow", "wow: reserved, surprise")))
    moods += "".join('<figure style="background:#0E1736;color:#F2EEE1">' + tomi(B_DARK, m, 84) + "<figcaption>" + l + "</figcaption></figure>" for m, l in (("happy", "happy, dark"), ("cheer", "cheer, dark")))
    return ('<section class="r2-sec hand" id="handoff"><div class="dir-head"><span class="ltr" style="background:#1D3690">9</span><div><h2>Handoff for SwiftUI</h2>'
            '<p>Final tokens, components and Tomi\'s moods. Names here match the labels used on the screens above. All values are points.</p></div></div>'
            '<h3 id="tok-colour" style="margin-top:0">Colour</h3>' + tok_table(["Token", "Role", "Light", "Dark"], colours) +
            '<h3 id="tok-type">Type</h3><p>Three families, all SIL Open Font License: Gloock, Newsreader (variable, optical size on), Figtree (variable). Sizes should scale with Dynamic Type from these defaults.</p>' +
            tok_table(["Style", "Font", "Size / line", "Used for"], types) +
            '<h3 id="tok-space">Spacing, radii, rules</h3>' + tok_table(["Token", "Values", "Notes"], spacing) +
            '<h3 id="components">Component inventory</h3><p>Each component with the states that are drawn somewhere in rounds 1 to 3.</p><div class="comp">' + comp_html + '</div>'
            '<h3 id="tomi-moods">Tomi\'s moods</h3><p>Five poses from one set of parts (body, arms, feet, leaves, toque, face). Print style: outline in cobalt (paper in dark), red and yolk fills offset 2.5 by 2 pt, toque left as ground colour in light and filled paper in dark.</p>'
            '<div class="moodrow">' + moods + '</div></section>')


def section(id_, n, title, lede, content, grid=True):
    return ('<section class="r2-sec" id="' + id_ + '"><div class="dir-head"><span class="ltr" style="background:#1D3690">' + n + '</span><div><h2>' + title + '</h2><p>' + lede + '</p></div></div>' +
            ('<div class="r3-grid">' + "".join(content) + "</div>" if grid else content) + "</section>")


def header():
    return ('<header id="intro"><p class="pg-kick">Tomi for iPhone, design round 3</p>'
            '<h1 class="pg-h1">The tasting menu, finished: every screen, dark theme, handoff</h1>'
            '<p class="pg-lede">This round completes direction B. With rounds 1 and 2, every screen of the app now has a mockup: the lesson player from intro to celebration, the scene kit, Ask Tomi, hands-free voice, skill detail, profile, settings and the edge states. '
            'Phones are shown three to a row with notes underneath. A red dashed line marks the fold at 844 pt on any screen that scrolls. Six screens are repeated in the dark theme, and the last section is the token and component handoff for SwiftUI.</p>'
            '<ul class="decl" id="decisions-applied" aria-label="Decisions applied since round 2">'
            '<li><b>Onboarding is nine screens.</b> The notification question now appears at the first timer (1c). The cupboard question now appears in the first scan review (7a).</li>'
            '<li><b>Unsure ingredients are not counted</b> until confirmed. They have their own dashed box with \"I have it\" and \"No\" (7a, D4).</li>'
            '<li><b>A \"never\" cuisine is hidden everywhere,</b> including \"Also on tonight\" (D1 shows one alternative, not two).</li>'
            '<li><b>Rank ladder proposed:</b> Novice, Commis, Cook, Saucier, Sous, Chef, Patron, Toque, at 150 XP a rank (6a).</li></ul></header>')


def closing():
    return ('<section class="final" id="open-questions"><p class="pg-kick">Before building</p><h2>Open questions and recommendations</h2>'
            '<div class="oq"><div id="oq-questions"><h3>Open questions</h3><ul>'
            '<li><b>Rank names.</b> Sous, Patron and Toque are shortened or informal so they fit the column. If the full words matter more (Sous chef, Chef patron), the stats column needs a two-line value.</li>'
            '<li><b>XP numbers.</b> I used 40 XP a dish and 10 for the quiz, and 150 XP a rank. At those rates twelve stamps is about 1,200 XP, just past Toque. The real numbers live in the rules engine.</li>'
            '<li><b>Wrong quiz answers.</b> Drawn as costing nothing and returning later. If a retry on the spot is wanted, the wrong state needs a \"Try again\" button.</li>'
            '<li><b>\"I stopped early\".</b> I assumed it keeps the streak only if a step was reached; that rule is not decided.</li>'
            '<li><b>Thumbs down.</b> The follow-up field is described, not drawn.</li>'
            '<li><b>Hands-free and timers together.</b> The listening bar replaces the footer, so Next and Back are voice or swipe only while it is on. That may be too strict; a slim Next button could stay.</li>'
            '<li><b>Sample cooks differ between rounds.</b> Round 2 followed a vegetarian on day one; this round returns to round 1\'s cook (chicken, level 2). The final build needs one consistent demo account.</li></ul></div>'
            '<div id="oq-not-done"><h3>Not covered, or thin</h3><ul>'
            '<li><b>Motion is described, not shown.</b> The stamp press, the line being inked and the timer rule draining need a prototype in SwiftUI to judge.</li>'
            '<li><b>Dark theme covers six screens.</b> The camera, celebration, profile and settings screens were not drawn in dark; they use the same tokens.</li>'
            '<li><b>Scenes are static.</b> Fifteen are drawn. Slice, mince, peel, grate, measure, pat dry, scramble, fry egg, blanch, fluff, toss pasta and taste are still to draw from the same parts.</li>'
            '<li><b>Dynamic Type and long translations</b> were not tested. Dish lines and the stats column are the tightest places.</li>'
            '<li><b>Reset, the iOS permission dialogs and the keyboard-up states</b> are not drawn.</li></ul></div></div>'
            '<div class="rec" id="recommendation"><p class="pg-kick">Recommendation</p><h3>Build the lesson player first, with the dish line and stamp as its reward.</h3>'
            '<p><b>Why.</b> It is where the cook spends the evening and it uses nearly every component: progress rule, plate, step text, timer block, tip, footer, sheet, tick rows and the stats columns. Once it works, home, skill detail and profile are mostly dish lines and rules.</p>'
            '<p><b>Lock the tokens before any screen.</b> Light and dark share every role, so the palette in section 9 can go in as one asset catalogue. Tomi and the scenes should be code-drawn from the same part list so the print offset and the dark outline are parameters, not second drawings.</p>'
            '<p><b>Prototype three motions early:</b> the stamp press, the dish line writing itself in, and the red timer rule. They carry the reward in a style that has no confetti, and they are the part these stills cannot prove.</p></div></section>')


def build():
    FONTS = ("https://fonts.googleapis.com/css2?family=Instrument+Sans:wght@400..700&family=Gloock"
             "&family=Newsreader:ital,opsz,wght@0,6..72,400..600;1,6..72,400..600&family=Figtree:wght@400..700&display=swap")
    d_step = shot("dark-step", "D2", "Lesson step, timer running", "The timer band is night wash with the same red drain rule. The plate's wash disc and the print offset both survive the inversion.", step1(T_RUN), dark=True)
    d_quiz = shot("dark-quiz", "D3", "Quiz, correct", "The ticked row washes, the tick stays red, the explanation keeps its chalk-blue rule.", quiz("right"), dark=True)
    d_ask = shot("dark-ask", "D6", "Ask Tomi", "Questions are chalk-blue bubbles with dark text; the safety card is a washed box with the number in display type.", ask_sheet(
        '<div class="a-q">What temperature is chicken safe at?</div><div class="a-safe"><span class="b-k">' + icon("check", 14, 3) + 'From the safety table</span><b>74 &deg;C in the thickest part</b>'
        '<p>That is 165 &deg;F. No thermometer? Cut in: the juices should run clear.</p></div><div class="a-q">And how do I know when to flip?</div>'
        '<div class="a-t">When the skin is deep golden and the thigh lifts without sticking.</div>', "Ask a follow-up"), dark=True)
    parts = ['<!doctype html>\n<html lang="en">\n<head>\n<meta charset="utf-8">\n<meta name="viewport" content="width=device-width, initial-scale=1">\n',
             '<title>Tomi design round 3</title>\n',
             '<link rel="preconnect" href="https://fonts.googleapis.com">\n<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>\n',
             '<link rel="stylesheet" href="' + FONTS.replace("&", "&amp;") + '">\n',
             "<style>\n", PAGE_CSS, dir_b.CSS, r2.CSS, CSS, "</style>\n</head>\n<body>\n<div class=\"wrap\">\n",
             header(),
             section("lesson-player", "1", "Lesson player", "From the intro to the celebration, in the order a cook meets them. The sample is round 1's pan sauce lesson.",
                     [lp_intro(), lp_step_timer(), lp_notify(), lp_timer_done(), lp_step_plain(), lp_quiz(), lp_quiz_right(), lp_quiz_wrong(), lp_finish(), celebrate_a(), celebrate_b(), lp_plate()]),
             section("step-scenes", "2", "Step scenes", "Fifteen actions drawn from one kit of parts on a shared stage. Under each: the parts it uses. \"Main\" is the swappable food part.", kit(), grid=False),
             section("ask-tomi", "3", "Ask Tomi", "A sheet over the step. The timer above it keeps running.", [ask_open(), ask_thread(), ask_off()]),
             section("voice", "4", "Hands-free voice", "Listening, speaking, the hold-to-talk fallback, and the primer shown the first time.", [voice_listen(), voice_speak(), voice_hold(), voice_primer()]),
             section("skill-detail", "5", "Skill detail", "What opens when a dish line on the menu is tapped.", [skill_mastered(), skill_ready()]),
             section("profile-settings", "6", "Profile and settings", "The rank ladder, the cooking record, and every onboarding answer as a setting.", [profile(), settings()]),
             section("edge-states", "7", "Revised review and edge states", "The scan review with both decisions applied, then four edges. There is no offline state: everything is local.",
                     [scan_review_first(), edge_camera(), edge_noai(), edge_streak(), edge_all()]),
             section("dark", "8", "Dark theme", "Still ink and paper, inverted: a deep navy ground with paper-coloured type. Every role keeps its name; only the values change.",
                     dark_palette() + '<div class="r3-grid" style="margin-top:30px">' + d_home() + d_step + d_quiz + d_review() + d_cuisines() + d_ask + "</div>", grid=False),
             handoff(), closing(), "</div>\n</body>\n</html>\n"]
    text = "".join(parts)
    assert chr(8212) not in text and chr(8211) not in text, "dash found"
    assert "#ff00ff" not in text, "missing palette key"
    assert "@@T" not in text
    out = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "round3.html")
    open(out, "w", encoding="utf-8").write(text)
    print("wrote", os.path.abspath(out), len(text) // 1024, "KB")
    if os.environ.get("DBG"):
        head_ = "".join(parts[:9]).replace(".r3-grid .phone{zoom:.89}", "") + "</style></head><body>"
        ids = re.findall(r'<figure class="shot" id="([^"]+)"', text)
        figs = []
        for sid in ids:
            a = text.index('<figure class="shot" id="' + sid + '"')
            b = text.index('<p class="shot-note">', a)
            figs.append(text[a:b] + "</figure>")
        for i in range(0, len(figs), 3):
            open(os.path.join(os.path.dirname(out), "_sheet_%02d.html" % (i // 3)), "w", encoding="utf-8").write(
                head_ + '<div style="padding:10px;display:flex;gap:16px;align-items:flex-start">' + "".join(figs[i:i + 3]) + "</div></body></html>")
        print(" ".join(ids))


if __name__ == "__main__":
    build()
