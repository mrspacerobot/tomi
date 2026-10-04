# Builds ../round2.html: direction B (Tasting menu) taken through onboarding,
# home before a scan, and the scan flow. Run: python3 round2.py
# round1.html is not touched by this script.
import os, re, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import common
from common import *
import dir_b
from page import PAGE_CSS

common.ICONS.update({
    "plus": '<path d="M12 5v14M5 12h14"/>',
    "minus": '<path d="M5 12h14"/>',
    "heart": '<path d="M12 20s-7.500 -4.700 -7.500 -10.200a4.200 4.200 0 0 1 7.500 -2.600a4.200 4.200 0 0 1 7.500 2.600c0 5.500 -7.500 10.200 -7.500 10.200z"/>',
    "keyboard": '<rect x="3" y="6" width="18" height="12" rx="2"/><path d="M7 10h.01M11 10h.01M15 10h.01M8 14h8"/>',
    "photos": '<rect x="4" y="5.500" width="16" height="13.500" rx="2"/><path d="M4 16l4.500 -4.500 4 4 2.500 -2.500 5 5"/><circle cx="15.500" cy="10" r="1.300"/>',
    "bell": '<path d="M6 16.500V11a6 6 0 0 1 12 0v5.500l1.500 2h-15z"/><path d="M10 20.500a2.200 2.200 0 0 0 4 0"/>',
    "pencil": '<path d="M5 19l1 -4L16.500 4.500l3 3L9 18z"/><path d="M14.500 6.500l3 3"/>',
    "dot": '<circle cx="12" cy="12" r="4"/>',
    "phone": '<rect x="7" y="3" width="10" height="18" rx="2.500"/><path d="M11 18h2"/>',
    "eye": '<path d="M2.500 12s3.500 -6 9.500 -6 9.500 6 9.500 6 -3.500 6 -9.500 6 -9.500 -6 -9.500 -6z"/><circle cx="12" cy="12" r="2.600"/>',
})

INK = "#172A6E"
RED = "#D9402A"


# ---------------------------------------------------------------- fixes carried over from round 1
def stamp2(size=42):
    """Chef's stamp, redrawn: one ring, a toque big enough to read at 28 pt."""
    return ('<svg class="b-stamp" viewBox="0 0 48 48" width="%s" height="%s" aria-hidden="true">'
            '<circle cx="24" cy="24" r="21.400" fill="none" stroke="#D9402A" stroke-width="2.600"/>'
            '<path d="M15.800 27.600c-7 -.400 -7.400 -11 -.200 -10.800c1.400 -8.600 15.400 -8.600 16.800 0c7.200 -.200 6.800 10.400 -.200 10.800z" fill="#D9402A"/>'
            '<path d="M20.600 20v5.400M27.400 20v5.400" stroke="#FBFAF5" stroke-width="1.700" stroke-linecap="round"/>'
            '<rect x="15.600" y="29.800" width="16.800" height="6.600" rx="1.600" fill="#D9402A"/></svg>') % (size, size)


OLD_STAMP = dir_b.stamp
dir_b.stamp = stamp2

TICK = ('<svg viewBox="0 0 34 34" width="34" height="34" aria-hidden="true"><path d="M5 19c3 2.500 5.500 6 7.500 9.500C16 19 22 10 31 3" fill="none" stroke="#D9402A" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/></svg>')

CSS = r"""
/* ============ Round 2 additions (direction B) ============ */
.wrap{max-width:1420px}
.r2-sec{margin-top:80px;scroll-margin-top:16px}
.r2-sec > .dir-head{margin-bottom:26px}
.r2-grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:52px 30px;align-items:start}
.r2-grid .shot{width:auto;min-width:0;display:grid;grid-template-columns:410px minmax(0,1fr);column-gap:16px;row-gap:10px;align-items:start}
.r2-grid .shot > figcaption{grid-column:1 / -1}
.shot-note{font-size:13.5px;line-height:19px;color:var(--pg-muted);min-width:0;padding-top:14px;border-top:1.5px solid var(--pg-ink);margin-top:44px}
@media (max-width:1150px){.r2-grid{grid-template-columns:minmax(0,1fr)}.r2-grid .shot{grid-template-columns:minmax(0,410px) minmax(0,1fr)}}
@media (max-width:640px){.r2-grid .shot{grid-template-columns:minmax(0,1fr)}.shot-note{margin-top:0}}
.shot-note b{color:var(--pg-ink)}
.flow{margin-top:26px;border:1px solid var(--pg-line);border-radius:14px;background:var(--pg-card);overflow-x:auto}
.flow table{border-collapse:collapse;width:100%;min-width:720px;font-size:14.5px;line-height:20px}
.flow th,.flow td{text-align:left;padding:9px 14px;border-bottom:1px solid var(--pg-line);vertical-align:top}
.flow tr:last-child td{border-bottom:0;font-weight:700}
.flow thead th{border-bottom:1.5px solid var(--pg-ink);font-size:13.5px}
.flow td.n{font-variant-numeric:tabular-nums;white-space:nowrap}
.oq{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:16px;margin-top:20px}
.oq > div{min-width:0;background:var(--pg-card);border:1px solid var(--pg-line);border-radius:14px;padding:18px 20px}
.oq h3{font-size:17px;line-height:22px;margin-bottom:8px}
.oq ul{margin:0;padding:0;list-style:none;display:flex;flex-direction:column;gap:9px;font-size:15px;line-height:22px}
.oq li{padding-left:14px;position:relative}
.oq li::before{content:"";position:absolute;left:0;top:10px;width:6px;height:2px;background:var(--pg-ink)}
@media (max-width:900px){.oq{grid-template-columns:minmax(0,1fr)}}
.specimen{display:flex;gap:28px;align-items:center;flex-wrap:wrap;background:#FBFAF5;border:1px solid var(--pg-line);border-radius:14px;padding:18px 22px;max-width:410px;font-size:13.5px;color:var(--pg-muted)}
.specimen div{display:flex;flex-direction:column;align-items:center;gap:8px}
.specimen .b-stamp{margin:0}

/* in-phone components */
.b-xp.x0::after{width:0}
.r-top{display:flex;align-items:center;gap:6px;padding:56px 16px 0 6px;min-height:100px}
.r-top .b-ticks{flex:1;margin:0;border-bottom:1px solid var(--rule)}
.r-skip{font:600 13.5px/44px "Figtree",system-ui,sans-serif;color:var(--blue);white-space:nowrap;text-decoration:underline;text-underline-offset:3px;padding-left:8px}
.r-req{font:600 12px/44px "Figtree",system-ui,sans-serif;color:var(--muted);white-space:nowrap;padding-left:8px}
.r-body{padding:12px 20px 0}
.r-body h1{font-size:34px;line-height:38px;margin-top:6px;text-wrap:balance}
.r-body .sub{font-size:16px;line-height:22px;margin-top:6px}
.r-hint{font-size:14.5px;line-height:20px;text-align:center}
.b-foot.col{flex-direction:column;gap:8px}
.r-link{display:flex;align-items:center;justify-content:center;gap:8px;min-height:44px;font:600 15.5px/1 "Figtree",system-ui,sans-serif;color:var(--blue);text-decoration:underline;text-underline-offset:3px}
.bx{display:block;width:26px;height:26px;border:1.5px solid var(--blue);border-radius:2px;flex:none;position:relative;background:var(--paper)}
.bx svg{position:absolute;left:1px;top:-9px}
/* welcome */
.r-wel{padding:118px 24px 0;text-align:center;display:flex;flex-direction:column;align-items:center}
.r-wel .disc{width:232px;height:232px;border-radius:50%;background:var(--tint);display:grid;place-items:center}
.r-wel .b-k{margin-top:26px}
.r-wel h1{font-size:40px;line-height:44px;margin-top:10px;text-wrap:balance}
.r-wel p.b-it{font-size:18px;line-height:25px;margin-top:14px;max-width:310px}
.r-rule{width:100%;border-top:3px double var(--blue);margin-top:26px}
/* avoid */
.r-grid{display:grid;grid-template-columns:1fr 1fr;column-gap:22px;border-top:1px solid var(--blue);margin-top:16px}
.r-cell{display:flex;align-items:center;gap:12px;height:52px;border-bottom:1px solid var(--rule);font-size:20px}
.r-cell.on{background:linear-gradient(var(--tint),var(--tint)) no-repeat;background-size:calc(100% + 0px) 100%}
.r-none{display:flex;align-items:center;gap:12px;height:56px;border-bottom:3px double var(--blue);font-size:20px}
.r-none .b-it{margin-left:auto;font:italic 400 15.5px/20px "Newsreader",Georgia,serif}
.r-nb{margin-top:14px;padding:11px 14px 12px;background:var(--tint);font-size:15.5px;line-height:21px}
.r-nb .b-k{color:var(--red);display:block;margin-bottom:2px}
/* cuisines */
.r-czh{display:grid;grid-template-columns:1fr 44px 44px 44px;align-items:end;margin-top:14px;padding:0 1.5px 6px 0;border-bottom:1px solid var(--blue)}
.r-czh span{text-align:center}
.r-cz{display:grid;grid-template-columns:1fr 135px;align-items:center;min-height:52px;border-bottom:1px solid var(--rule)}
.r-cz .nm{font-size:20px;line-height:24px;display:flex;align-items:baseline;gap:8px;min-width:0}
.r-cz .nm small{font:italic 400 14.5px/20px "Newsreader",Georgia,serif;color:var(--muted);white-space:nowrap}
.r-cz.never .nm span{color:var(--muted);text-decoration:line-through;text-decoration-color:#D9402A;text-decoration-thickness:2px}
.r-cz.love .nm small{color:var(--red)}
.r-seg{display:grid;grid-template-columns:repeat(3,1fr);height:44px;border:1.5px solid var(--blue);border-radius:3px;overflow:hidden}
.r-seg i{display:grid;place-items:center;color:#8E9BD0}
.r-seg i + i{border-left:1px solid var(--rule)}
.r-seg i.on{background:var(--tint);color:var(--blue)}
.r-seg i.on.nv{background:var(--ink);color:#fff}
.r-seg i.on.lv{background:var(--red);color:#fff}
.r-flow{padding:16px 16px 34px;display:flex;flex-direction:column;gap:8px}
/* level */
.r-lv{display:grid;grid-template-columns:26px minmax(0,1fr);gap:2px 14px;padding:18px 2px 17px;border-bottom:1px solid var(--rule)}
.r-lv .bx{grid-row:1 / span 2;margin-top:3px}
.r-lv .nm{font-size:24px;line-height:30px;display:flex;align-items:center;gap:8px}
.r-lv .d{font-size:16px;line-height:22px}
.r-lv.sel{background:var(--tint);margin:0 -20px;padding-left:22px;padding-right:22px}
.r-lv.sel .d{color:var(--ink)}
.r-lv.c{padding:11px 2px 11px}
.r-lv.c:last-child{border-bottom:0}
.r-lv.c .nm{font-size:22px;line-height:28px}
.r-lv.c .d{font-size:15px;line-height:20px}
/* weekly goal */
.r-days{display:grid;grid-template-columns:repeat(7,minmax(0,1fr));border:1.5px solid var(--blue);border-radius:4px;margin-top:10px;overflow:hidden}
.r-days > div{min-height:48px;display:grid;place-items:center;font-size:22px;color:var(--blue)}
.r-days > div + div{border-left:1px solid var(--rule)}
.r-days > .on{background:var(--blue);color:#fff}
.r-days-cap{display:flex;justify-content:space-between;margin-top:6px;font:500 13.5px/18px "Figtree",system-ui,sans-serif;color:var(--muted)}
/* table for */
.r-step{display:flex;align-items:center;justify-content:center;gap:30px;margin-top:20px}
.r-step .n{font-size:92px;line-height:96px;min-width:70px;text-align:center}
.r-sq{width:56px;height:56px;border:1.5px solid var(--blue);border-radius:4px;display:grid;place-items:center;color:var(--blue)}
.r-two{display:grid;grid-template-columns:1fr 1fr;border:1.5px solid var(--blue);border-radius:4px;margin-top:10px;overflow:hidden}
.r-two > div{padding:12px 14px 13px;min-height:64px}
.r-two b{display:flex;align-items:center;gap:8px;font:600 17px/22px "Figtree",system-ui,sans-serif}
.r-two span{display:block;font:500 13.5px/18px "Figtree",system-ui,sans-serif;color:var(--muted)}
.r-two .on{background:var(--blue);color:#fff}
.r-two .on span{color:#DDE2F6}
.r-sep{margin-top:26px;padding-top:16px;border-top:1px solid var(--blue)}
.screen .r-card{margin-top:14px;padding:10px 14px;border:1px solid var(--rule);font-size:16px;line-height:22px;text-align:center}
/* chips */
.r-chips{display:flex;flex-wrap:wrap;gap:8px;margin-top:8px}
.r-chip{display:inline-flex;align-items:center;gap:6px;height:44px;padding:0 13px 0 10px;border:1.5px solid var(--blue);border-radius:3px;font:600 15.5px/1 "Figtree",system-ui,sans-serif;color:var(--ink);background:var(--tint);white-space:nowrap}
.r-chip.off{background:transparent;border-color:#8E9BD0;color:var(--muted)}
.r-chip.lock{background:var(--blue);color:#fff}
.r-chip.out{background:transparent;border-color:#8E9BD0;color:var(--muted);text-decoration:line-through}
.r-chip.x{padding:0 4px 0 13px;background:var(--paper)}
.r-chip.x .ic{color:var(--muted);margin:0 4px}
.r-chip.q{border-style:dashed;border-color:var(--red)}
.r-chip.q em{font-style:normal;display:grid;place-items:center;width:20px;height:20px;border-radius:50%;background:var(--red);color:#fff;font-size:13px;margin-left:-3px}
.r-chip.ghost{border-style:dashed;border-color:#8E9BD0;background:transparent;width:86px}
.r-grp{margin-top:18px}
.r-grp .hd{display:flex;align-items:baseline;justify-content:space-between;gap:8px;padding-bottom:5px;border-bottom:1px solid var(--blue)}
.r-grp .hd .b-it{font-size:14.5px}
.r-field{display:flex;align-items:center;gap:8px;height:52px;margin-top:8px;border:1.5px solid var(--blue);border-radius:3px;padding:0 5px 0 14px;font-size:17px;line-height:22px}
.r-field span{flex:1;min-width:0;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.r-field .add{width:40px;height:40px;border-radius:2px;background:var(--blue);color:#fff;display:grid;place-items:center;flex:none}
.r-field.focus{box-shadow:0 0 0 3px var(--tint);border-width:2px}
.r-field.focus span{font-style:normal;color:var(--ink)}
.r-field .caret{display:inline-block;width:2px;height:22px;background:var(--red);vertical-align:-4px;margin-left:1px}
/* primers */
.r-hero{display:flex;align-items:flex-end;justify-content:center;gap:6px;margin:8px 0 18px;height:176px}
.r-pts{margin-top:18px;border-top:1px solid var(--blue)}
.r-pt{display:grid;grid-template-columns:24px minmax(0,1fr);gap:14px;padding:13px 2px;border-bottom:1px solid var(--rule);font-size:17px;line-height:23px;color:var(--ink)}
.r-pt .ic{color:var(--blue);margin-top:1px}
.r-banner{flex:1;max-width:214px;border:1.5px solid var(--blue);border-radius:4px;padding:10px 12px 11px;margin-bottom:26px;background:var(--paper);box-shadow:4px 4px 0 var(--tint)}
.r-banner .b-k{display:flex;justify-content:space-between}
.r-banner b{display:block;font:400 19px/24px "Gloock",Georgia,serif;margin-top:4px}
.r-banner span.t{display:block;font:500 13.5px/18px "Figtree",sans-serif;color:var(--muted)}
.r-opt{display:flex;align-items:center;gap:12px;margin-top:14px;padding:12px 14px;background:var(--tint)}
.r-opt .tx{flex:1;min-width:0;font-size:17px;line-height:22px}
.r-opt .tx small{display:block;font:italic 400 14.5px/19px "Newsreader",Georgia,serif;color:var(--muted)}
.r-time{font:600 15px/34px "Figtree",sans-serif;padding:0 10px;border:1.5px solid var(--blue);border-radius:3px;background:var(--paper);color:var(--blue)}
/* done */
.r-sum{margin-top:18px;border-top:3px double var(--blue);border-bottom:1px solid var(--blue)}
.r-sum div{display:flex;align-items:baseline;gap:8px;padding:9px 0 8px;border-bottom:1px solid var(--rule)}
.r-sum div:last-child{border-bottom:0}
.r-sum .l{font:700 11px/20px "Figtree",sans-serif;letter-spacing:.14em;text-transform:uppercase;color:var(--muted);white-space:nowrap}
.r-sum .ld{flex:1;min-width:10px;border-bottom:2px dotted #8E9BD0;transform:translateY(-4px)}
.r-sum .v{font-size:16.5px;line-height:21px;text-align:right;max-width:228px}
/* home variants */
.b-special .blank{display:flex;align-items:baseline;gap:8px;margin:2px 6px 0}
.b-special .blank i{flex:1;border-bottom:2px dotted #8E9BD0}
.b-special .blank span{font-size:15px}
.screen .r-cup{font:500 13.5px/18px "Figtree",sans-serif;color:var(--muted);margin-top:2px}
.r-cup u{color:var(--blue);font-weight:600;text-underline-offset:3px}
.b-special .uses{display:flex;flex-wrap:wrap;justify-content:center;gap:6px}
.r-use{display:inline-flex;align-items:center;height:26px;padding:0 9px;border:1px solid var(--blue);border-radius:2px;font:600 13px/1 "Figtree",sans-serif;color:var(--blue);background:var(--paper)}
.r-use.cup{border-color:#8E9BD0;color:var(--muted)}
.r-also{margin:22px 20px 0}
.r-also .b-k{display:flex;align-items:center;gap:10px}
.r-also .b-k::after{content:"";flex:1;height:1px;background:var(--rule)}
.r-alt{padding:11px 0 10px;border-bottom:1px solid var(--rule)}
.r-alt .row{display:flex;align-items:baseline;gap:8px}
.r-alt .nm{font-size:18px;line-height:23px}
.r-alt .ld{flex:1;min-width:12px;border-bottom:2px dotted #8E9BD0;transform:translateY(-4px)}
.r-alt .sk{font:600 13px/23px "Figtree",sans-serif;white-space:nowrap}
.r-alt .b-it{font-size:15px;line-height:20px}
.r-crop{height:844px;overflow:hidden}
.r-crop::after{content:"";position:absolute;left:0;right:0;bottom:0;height:70px;background:linear-gradient(rgba(251,250,245,0),#FBFAF5 70%)}
.r-again{display:flex;align-items:baseline;gap:8px;text-align:left;padding-top:10px;border-top:1px solid var(--rule)}
.r-again .ld{flex:1;border-bottom:2px dotted #8E9BD0;transform:translateY(-4px);min-width:12px}
.r-again .nm{font-size:16.5px;line-height:21px}
.r-again .b-u{font-size:13px;font-weight:600;color:var(--blue);white-space:nowrap}
/* scan */
.r-cam{background:#0C1433;color:#fff;font-family:"Newsreader",Georgia,serif}
.r-cam .r-top{color:#fff}
.r-cam .ttl{flex:1;text-align:center;font:400 19px/44px "Gloock",Georgia,serif;padding-right:44px}
.r-tipcard{display:flex;align-items:center;gap:8px;margin:2px 16px 0;padding:8px 14px 8px 8px;background:#FBFAF5;color:#172A6E;border-radius:4px;font-size:16px;line-height:21px;font-style:italic}
.r-vf{position:relative;margin:14px 16px 0;height:482px;border-radius:6px;overflow:hidden}
.r-vf > svg{display:block;width:100%;height:100%}
.r-vf .c{position:absolute;width:30px;height:30px;border:3px solid #fff}
.r-vf .c.tl{left:12px;top:12px;border-right:0;border-bottom:0}.r-vf .c.tr{right:12px;top:12px;border-left:0;border-bottom:0}
.r-vf .c.bl{left:12px;bottom:12px;border-right:0;border-top:0}.r-vf .c.br{right:12px;bottom:12px;border-left:0;border-top:0}
.r-camfoot{position:absolute;left:0;right:0;bottom:0;padding:0 26px 40px;display:grid;grid-template-columns:1fr auto 1fr;align-items:center}
.r-cbtn{display:flex;flex-direction:column;align-items:center;gap:6px;font:600 13px/16px "Figtree",sans-serif;color:#fff}
.r-cbtn i{width:52px;height:52px;border:1.5px solid rgba(255,255,255,.75);border-radius:4px;display:grid;place-items:center}
.r-shut{width:76px;height:76px;border-radius:50%;border:4px solid #fff;display:grid;place-items:center}
.r-shut i{width:58px;height:58px;border-radius:50%;background:#fff}
.r-read{display:flex;align-items:flex-end;justify-content:center;gap:4px;margin-top:6px}
.r-thumb{position:relative;width:176px;height:222px;border:1px solid var(--blue);padding:3px;flex:none}
.r-thumb svg{display:block;width:100%;height:100%}
.r-thumb::after{content:"";position:absolute;left:-6px;right:-6px;top:58%;height:2px;background:var(--red)}
.r-bar{height:3px;background:var(--rule);margin-top:18px;position:relative}
.r-bar::after{content:"";position:absolute;left:0;top:0;bottom:0;width:62%;background:var(--blue)}
.r-revh{display:flex;gap:12px;align-items:flex-start}
.r-revh .tx{flex:1;min-width:0}
.r-mini{flex:none;width:58px;text-align:center;font:600 12.5px/16px "Figtree",sans-serif;color:var(--blue);margin-top:10px}
.r-mini div{height:72px;border:1px solid var(--blue);padding:2px;margin-bottom:4px}
.r-mini svg{display:block;width:100%;height:100%}
.screen .r-legend{font-size:14.5px;line-height:19px;margin-top:8px}
.r-sugg{display:flex;gap:8px;margin-top:8px;flex-wrap:wrap}
.r-sugg span{display:inline-flex;align-items:center;height:36px;padding:0 12px;border-radius:18px;background:var(--tint);font:600 14.5px/1 "Figtree",sans-serif;color:var(--blue)}
.r-close{margin-top:16px;border:1.5px solid var(--blue);border-radius:3px;padding:14px 16px 12px;position:relative}
.r-close::before{content:"";position:absolute;inset:4px;border:1px solid var(--rule);pointer-events:none}
.r-close h2{font-size:22px;line-height:27px;margin-top:2px}
.r-close .ln{display:flex;gap:8px;align-items:center;flex-wrap:wrap;margin-top:10px;font:600 13px/20px "Figtree",sans-serif;color:var(--muted)}
.r-miss{display:inline-flex;align-items:center;height:30px;padding:0 10px;border:1.5px dashed var(--red);border-radius:2px;font:600 14px/1 "Figtree",sans-serif;color:var(--red)}
.r-voice{display:inline-flex;align-items:center;gap:6px;height:36px;padding:0 10px 0 8px;border:1.5px solid var(--blue);border-radius:3px;font:600 13px/1 "Figtree",sans-serif;color:var(--blue);background:var(--tint);white-space:nowrap;justify-self:end}
.b-top.v2{display:grid;grid-template-columns:104px minmax(0,1fr) 104px;padding:58px 16px 0 8px}
"""


# ---------------------------------------------------------------- helpers
def shot(id_, code, title, note, body, height=844, cls="b-screen", sb=INK, cap=""):
    style = ' style="height:%spx"' % height if height else ""
    return ('<figure class="shot" id="%s"><figcaption><span class="code">%s</span><b>%s</b><span class="cap-note">%s</span></figcaption>'
            '<div class="phone"><div class="screen %s"%s>%s%s<div class="hb" aria-hidden="true" style="color:%s"></div></div></div>'
            '<p class="shot-note">%s</p></figure>') % (id_, code, title, cap, cls, style, statusbar(sb), body, sb, note)


def box(on=False):
    return '<span class="bx">%s</span>' % (TICK if on else "")


def top(step=None, skip=True, back=True, req=""):
    ticks = ""
    if step:
        ticks = '<div class="b-ticks" style="grid-template-columns:repeat(7,1fr)" role="img" aria-label="Question %s of 7">%s</div>' % (
            step, "".join('<i class="on"></i>' if i < step else "<i></i>" for i in range(7)))
    else:
        ticks = '<div style="flex:1"></div>'
    right = '<div class="r-skip" role="button">Skip, ask me later</div>' if skip else ('<div class="r-req">%s</div>' % req if req else "")
    return '<div class="r-top">%s%s%s</div>' % (
        '<div class="b-ib" role="button" aria-label="Back">%s</div>' % icon("back", 22, 2) if back else '<div style="width:10px"></div>', ticks, right)


def foot(primary, link=None, ic=None, hint=None):
    out = '<div class="b-foot col">'
    if hint:
        out += '<p class="r-hint b-it">%s</p>' % hint
    if primary:
        out += '<div class="b-btn" role="button">%s%s</div>' % (icon(ic, 20, 1.8) + " " if ic else "", primary)
    if link:
        out += '<div class="r-link" role="button">%s</div>' % link
    return out + "</div>"


def head(k, h, sub):
    return '<p class="b-k">%s</p><h1 class="b-d">%s</h1><p class="sub b-it">%s</p>' % (k, h, sub)


# ---------------------------------------------------------------- 1. onboarding
def ob_welcome():
    body = ('<div class="r-wel"><div class="disc">%s</div><p class="b-k">Chez Tomi</p>'
            '<h1 class="b-d">Learn to cook, starting from your fridge.</h1>'
            '<p class="b-it">Show me what you have. I write a menu that teaches you one technique at a time.</p></div>%s') % (
                tomi(B, "happy", 164), foot("Write my menu", hint="About a minute. Eleven taps if you are in a hurry."))
    return shot("ob-welcome", "1a", "Welcome", "One promise, one button. No sign-in, no carousel. The hint under the button sets the expectation that this is short.", body)


def ob_diet():
    opts = ""
    for k, name, desc in DIETS:
        sel = k == "vegetarian"
        opts += ('<div class="b-opt%s" role="radio" aria-checked="%s">%s<span class="nm b-d" style="margin-left:2px">%s</span><span class="ld"></span><span class="d b-it">%s</span></div>') % (
            " sel" if sel else "", "true" if sel else "false", '<span class="bx" style="align-self:flex-start">%s</span>' % (TICK if sel else ""), name, desc.lower())
    body = top(1, skip=False, back=True, req="Required") + '<div class="b-ob-hero" style="padding:4px 20px 0">%s<p class="b-it">&ldquo;Good evening. A few questions, then I write your menu.&rdquo;</p></div><div class="r-body">%s<div class="b-opts" role="radiogroup" style="margin-top:18px">%s</div></div>%s' % (tomi(B, "happy", 84),
        head("Question 1 of 7", "What do you eat?", "Dishes that do not fit never reach your menu."), opts,
        foot(None, hint="Tap one and we move on. You can change it later in Settings."))
    return shot("ob-diet", "1b", "What do you eat?", "<b>One tap, no Continue.</b> Single-choice screens advance on tap; Back is top left. Shown just after tapping Vegetarian. Not skippable: it decides which dishes exist.", body)


AVOID = ["Nuts", "Dairy", "Gluten", "Eggs", "Shellfish", "Fish", "Soy", "Sesame", "Pork", "Alcohol"]

def ob_avoid():
    on = {"Nuts", "Shellfish"}
    cells = "".join('<div class="r-cell b-d" role="checkbox" aria-checked="%s">%s%s</div>' % ("true" if a in on else "false", box(a in on), a) for a in AVOID)
    body = top(2, skip=False, req="Required") + ('<div class="r-body">%s<div class="r-grid">%s</div>'
            '<div class="r-none b-d" role="checkbox" aria-checked="false">%sNone of these<span class="b-it">I eat all ten</span></div>'
            '<div class="r-nb"><span class="b-k">Please note</span>I leave these out of every dish and check again after any swap. I cannot read packaging, so please still check the labels.</div></div>%s') % (
                head("Question 2 of 7", "Anything to avoid?", "Allergies and things you never eat. Tick all that apply."), cells, box(False),
                foot("Continue", hint="Avoiding nuts and shellfish."))
    return shot("ob-avoid", "1c", "Anything to avoid?", "<b>Safety screen, so no skip.</b> Continue stays disabled until something is ticked or \"None of these\" is chosen, which makes \"none\" a deliberate answer. \"None of these\" advances in one tap. The note is honest about what Tomi can and cannot check.", body)


CUISINES = [("Italian", "love"), ("Mexican", "never"), ("Indian", "try"), ("Chinese", "try"), ("Japanese", "love"),
            ("Thai", "try"), ("French", "try"), ("Middle Eastern", "try"), ("Mediterranean", "try"), ("Korean", "try")]

def ob_cuisines():
    rows = ""
    for name, st in CUISINES:
        extra = {"love": "<small>more often</small>", "never": "<small>off the menu</small>", "try": ""}[st]
        seg = ('<div class="r-seg" role="radiogroup" aria-label="%s"><i class="nv%s" role="radio" aria-label="Never">%s</i><i class="%s" role="radio" aria-label="Happy to try">%s</i><i class="lv%s" role="radio" aria-label="Love it">%s</i></div>') % (
            name, " on" if st == "never" else "", icon("close", 20, 2.4), "on" if st == "try" else "", icon("dot", 20, 2.2), " on" if st == "love" else "", icon("heart", 20, 2.2))
        rows += '<div class="r-cz %s"><div class="nm b-d"><span>%s</span>%s</div>%s</div>' % (st, name, extra, seg)
    body = top(3) + ('<div class="r-body">%s<div class="r-czh b-k"><span></span><span>Never</span><span>Try</span><span>Love</span></div>%s'
            '<p class="b-it" style="font-size:15px;line-height:20px;margin-top:12px">Cuisines never hold a technique back: searing is searing. More arrive later as guest menus.</p></div>'
            '<div class="r-flow"><p class="r-hint b-it">Loves Italian and Japanese. Mexican is off the menu.</p><div class="b-btn" role="button">Continue</div></div>') % (
                head("Question 3 of 7", "Any cuisines you love, or never want?", "Everything starts at \"try\". Change only what you feel strongly about."), rows)
    return shot("ob-cuisines", "1d", "Cuisines", "<b>Three states, one tap each.</b> Every row starts on the middle mark, so the fastest path is to touch nothing and continue. Never strikes the name out and removes those dishes; Love makes them come up more often. State is shown by position, icon, words and fill, not colour alone. Scrolls: the button is pinned in the app.", body, height=None, cap="scrolls, full height")


KITCHEN = [("Stovetop", "every pan dish", True), ("Oven", "roasting and braising", True), ("Microwave", "quick melts and reheats", True),
           ("Thermometer", "doneness by number", False), ("Blender", "smooth soups and sauces", False), ("Rice cooker", "one less pot to watch", False)]

def ob_kitchen():
    opts = ""
    for name, desc, on in KITCHEN:
        opts += ('<div class="b-opt" role="checkbox" aria-checked="%s" style="min-height:64px;padding-top:19px"><span class="bx" style="align-self:flex-start">%s</span><span class="nm b-d" style="margin-left:2px">%s</span><span class="ld"></span><span class="d b-it">%s</span></div>') % (
            "true" if on else "false", TICK if on else "", name, desc)
    body = top(4) + '<div class="r-body">%s<div class="b-opts" style="margin-top:16px">%s</div></div>%s' % (
        head("Question 4 of 7", "What is in your kitchen?", "I only write dishes you can actually make."), opts,
        foot("Continue", hint="No thermometer? Steps will say what to look for instead."))
    return shot("ob-kitchen", "1e", "Your kitchen", "Stovetop, oven and microwave are ticked by default, so most people just continue. Skipping keeps the defaults. No oven means roasting and braising use stovetop versions or wait.", body)


def ob_level():
    rows = ""
    data = [("Never, really", "Start at the first dish. I explain everything, including how to hold the knife.", False, ""),
            ("The basics", "Start at the first course, with shorter explanations.", True, ""),
            ("Comfortable", "The first course arrives already stamped. You start at Heat control.", False, stamp2(30))]
    for name, desc, sel, extra in data:
        rows += '<div class="r-lv c%s" role="radio" aria-checked="%s">%s<span class="nm b-d">%s%s</span><span class="d b-it">%s</span></div>' % (
            " sel" if sel else "", "true" if sel else "false", box(sel), name, extra, desc)
    days = "".join('<div class="b-d%s" role="radio" aria-checked="%s" aria-label="%s days a week">%s</div>' % (
        " on" if n == 3 else "", "true" if n == 3 else "false", n, n) for n in range(1, 8))
    goal = ('<div class="r-sep" style="margin-top:18px"><p class="b-k">Cooking days a week</p><div class="r-days" role="radiogroup">%s</div>'
            '<div class="r-days-cap"><span>now and then</span><span>every night</span></div></div>') % days
    body = top(5) + '<div class="r-body">%s<div style="margin-top:14px;border-top:1px solid var(--blue)">%s</div>%s</div>%s' % (
        head("Question 5 of 7", "How much do you cook?", "This sets where your menu begins, and your weekly goal."), rows, goal,
        foot("Continue", hint="Your streak counts the weeks you reach it."))
    return shot("ob-level", "1f", "How much do you cook?", "Two decisions with defaults, so Continue is the only tap needed: where the menu begins (\"The basics\") and the weekly goal (3 days). The streak counts weeks with the goal met, so it survives nights off. Two dishes on one night count as one day. \"Comfortable\" shows the stamp so the reward is visible before it is earned.", body)


def ob_table():
    body = top(6) + ('<div class="r-body">%s'
            '<div class="r-step"><div class="r-sq" role="button" aria-label="One fewer">%s</div><div class="n b-d" aria-live="polite">2</div><div class="r-sq" role="button" aria-label="One more">%s</div></div>'
            '<p class="b-it" style="text-align:center;font-size:16px">people at the table, most nights</p>'
            '<div class="r-sep"><p class="b-k">Amounts in</p><div class="r-two" role="radiogroup"><div class="on" role="radio" aria-checked="true"><b>%s Metric</b><span>grams, millilitres, &deg;C</span></div>'
            '<div role="radio" aria-checked="false"><b>Cups</b><span>cups, ounces, &deg;F</span></div></div>'
            '<p class="r-card b-it">On the card: 120 ml white wine, oven at 200 &deg;C</p></div></div>%s') % (
                head("Question 6 of 7", "Table for how many?", "I scale every amount to fit."), icon("minus", 24, 2), icon("plus", 24, 2), icon("check", 18, 2.6),
                foot("Continue"))
    return shot("ob-table", "1g", "Table for how many, and units", "Two small decisions on one screen, both with defaults (2 people, units from the phone's region), so Continue is the only tap needed. The sample line shows what the units choice changes.", body)


STAPLES = [("Rice", True), ("Pasta", True), ("Flour", False), ("Garlic", True), ("Onions", True), ("Soy sauce", False),
           ("Stock", False), ("Tinned tomatoes", True), ("Butter", True), ("Eggs", True)]

def chip(name, kind="on"):
    if kind == "lock":
        return '<span class="r-chip lock">%s%s</span>' % (icon("lock", 15, 2.2), name)
    if kind == "on":
        return '<span class="r-chip" role="checkbox" aria-checked="true">%s%s</span>' % (icon("check", 16, 2.6), name)
    if kind == "off":
        return '<span class="r-chip off" role="checkbox" aria-checked="false">%s%s</span>' % (icon("plus", 16, 2.2), name)
    if kind == "out":
        return '<span class="r-chip out" role="checkbox" aria-checked="false">%s</span>' % name
    if kind == "q":
        return '<span class="r-chip x q"><em>?</em>%s%s</span>' % (name, icon("close", 16, 2.2))
    return '<span class="r-chip x">%s%s</span>' % (name, icon("close", 16, 2.2))


def ob_pantry():
    body = top(7) + ('<div class="r-body">%s'
            '<div class="r-grp"><div class="hd"><span class="b-k">Always there</span><span class="b-it">I assume these</span></div><div class="r-chips">%s</div></div>'
            '<div class="r-grp"><div class="hd"><span class="b-k">Usually there</span><span class="b-it">tap to add or remove</span></div><div class="r-chips">%s</div></div>'
            '<div class="r-grp"><div class="hd"><span class="b-k">Anything else?</span><span class="b-it">spices, sauces, tins</span></div>'
            '<div class="r-chips">%s%s</div><div class="r-field"><span class="b-it">Type one, for example cumin</span><div class="add" role="button" aria-label="Add">%s</div></div></div></div>%s') % (
                head("Question 7 of 7", "What is always in your cupboard?", "So you never have to photograph the salt."),
                "".join(chip(n, "lock") for n in ("Olive oil", "Salt", "Pepper")),
                "".join(chip(n, "on" if on else "off") for n, on in STAPLES),
                chip("Chili flakes", "x"), chip("Sunflower oil", "x"), icon("plus", 20, 2.4),
                '<div class="r-flow"><p class="r-hint b-it">12 staples saved. Edit them any evening.</p><div class="b-btn" role="button">Continue</div></div>')
    return shot("ob-pantry", "1h", "Always in your cupboard", "The saved version of the prototype's pantry text field. Olive oil, salt and pepper are locked on. The oil is named, never left as plain oil, because a cook who avoids nuts, sesame or soy has to know which one a dish means. Seven common staples are pre-ticked so skipping still gives Tomi something to work with. The same list appears on the scan review, where a staple can be switched off for one night.", body, height=None, cap="scrolls a little, full height")


def fridge_closed():
    S = [
        D('ellipse cx="80" cy="166" rx="52" ry="5"', "steel_d"),
        F('rect x="40" y="8" width="80" height="156" rx="10"', "steel_d"),
        L('path d="M40 66h80"', "ink", 2),
        L('path d="M108 26v26M108 80v40"', "ink", 3.4),
        F('rect x="54" y="84" width="22" height="18" rx="2" transform="rotate(-5 65 93)"', "white"),
        D('circle cx="66" cy="84" r="3.600"', "red"),
        F('circle cx="62" cy="126" r="7"', "yolk"),
    ]
    corners = "".join('<path d="%s" fill="none" stroke="#D9402A" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>' % d for d in (
        "M12 22V6h16", "M132 6h16v16", "M148 150v16h-16", "M28 166H12v-16"))
    return '<svg viewBox="0 0 160 176" width="150" height="165" aria-hidden="true">%s%s</svg>' % (render(S, B), corners)


def ob_camera():
    pts = [("eye", "I spot the ingredients and write tonight's special from them."),
           ("phone", "Photos stay on this phone. Nothing is uploaded, nothing is kept after the list is made."),
           ("pencil", "You check and correct my list before anything is cooked.")]
    body = top(None, skip=False) + ('<div class="r-body" style="padding-top:0"><div class="r-hero">%s%s</div>%s'
            '<div class="r-pts">%s</div></div>%s') % (
                tomi(B, "happy", 112), fridge_closed(),
                head("One permission", "May I look in your fridge?", "iOS will ask you to confirm on the next screen."),
                "".join('<div class="r-pt">%s<span>%s</span></div>' % (icon(i, 24, 1.8), t) for i, t in pts),
                foot("Allow camera", link="%s Type it instead" % icon("keyboard", 20, 1.8), ic="camera"))
    return shot("ob-camera", "1i", "Camera primer", "Shown before the system prompt, so the iOS dialog is never a surprise. Three plain reasons, and a real alternative: \"Type it instead\" skips the camera for good and uses the typed review screen.", body)


def ob_notify():
    banner = ('<div class="r-banner"><span class="b-k"><span>Tomi</span><span>now</span></span><b>Time to flip.</b><span class="t">7:30 is up. Step 2 is ready.</span></div>')
    body = top(None, skip=False) + ('<div class="r-body" style="padding-top:0"><div class="r-hero" style="align-items:flex-end;gap:2px">%s%s</div>%s'
            '<div class="r-pts"><div class="r-pt">%s<span>Timers ring when the phone is locked or your hands are covered in flour.</span></div></div>'
            '<div class="r-opt" role="checkbox" aria-checked="true">%s<div class="tx">A nudge at dinner time<small>once a day at most, off whenever you like</small></div><span class="r-time">17:30</span></div></div>%s') % (
                tomi(B, "tip", 104), banner,
                head("One more", "Shall I ring when the timer is up?", "iOS will ask you to confirm on the next screen."),
                icon("bell", 24, 1.8), box(True),
                foot("Allow notifications", link="Not now", ic="bell"))
    return shot("ob-notify", "1j", "Notification primer", "Leads with the useful reason (timers), and keeps the daily reminder as a separate, optional tick with a time the cook controls. \"Not now\" is a full-size target. Microphone is still asked later, the first time hands-free voice is switched on.", body)


def ob_done():
    rows = [("Diet", "Vegetarian"), ("Never", "Nuts, shellfish"), ("Cuisines", "Loves Italian and Japanese. No Mexican."),
            ("Kitchen", "Stovetop, oven, microwave"), ("Starting at", "The first course"), ("Weekly goal", "3 cooking days"), ("Table", "For 2, metric"), ("Cupboard", "12 staples")]
    body = ('<div class="r-wel" style="padding-top:76px"><div style="display:flex;align-items:flex-end;gap:2px">%s%s</div>'
            '<h1 class="b-d" style="margin-top:6px">Your menu is written.</h1>'
            '<p class="b-it" style="max-width:none;margin-top:8px;font-size:17px">Twelve techniques, four courses, all of it yours.</p>'
            '<div class="r-sum" style="width:100%%;text-align:left">%s</div></div>%s') % (
                tomi(B, "cheer", 118), '<div style="transform:rotate(-10deg);margin:0 0 54px -8px">%s</div>' % stamp2(54),
                "".join('<div><span class="l">%s</span><span class="ld"></span><span class="v">%s</span></div>' % r for r in rows),
                foot("Scan my fridge", link="%s Type what I have" % icon("keyboard", 20, 1.8), ic="camera"))
    return shot("ob-done", "1k", "Done", "Reads the answers back as a menu header, so a wrong one is caught now (each line opens its question). The primary button goes straight to the first scan; the typed route is one tap away.", body)


# ---------------------------------------------------------------- 2. home before a scan
NEEDS0 = {"saute": "Knife basics", "sear": "Knife basics", "rice": "Boil & blanch", "roast": "Knife basics", "pansauce": "Searing",
          "emulsion": "Knife basics", "pasta": "Boil & blanch, Sauté", "braise": "Searing, Roasting", "balance": "Pan sauces, Emulsions"}

def zero_skills(next_id=None):
    out = []
    for s in SKILLS:
        sid = s[0]
        st = "locked" if sid in NEEDS0 else ("next" if sid == next_id else "ready")
        out.append((sid, s[1], s[2], s[3], st, 0, NEEDS0.get(sid, ""), []))
    return out


def menu(skills, only=None):
    out = ""
    for u, (uname, usub) in enumerate(UNITS):
        if only is not None and u not in only:
            continue
        sk = [s for s in skills if s[3] == u]
        done = len([s for s in sk if s[4] == "mastered"])
        out += '<div class="b-course"><p class="b-k">%s</p><h3 class="b-d">%s</h3><p class="b-it">%s of %s mastered</p></div>' % (dir_b.ORD[u], uname, done, len(sk))
        out += "".join(dir_b.dish(s) for s in sk)
    return out


def mast(mood="happy"):
    return '<header class="b-mast">%s<h1 class="b-d">Tonight at Tomi\'s</h1><p class="b-k">Friday 2 October, dinner</p></header>' % tomi(B, mood, 66)


def house(a, b, c, zero=False):
    cell = lambda k, v, s: '<div><span class="b-k">%s</span><span class="v b-d">%s</span><span class="s">%s</span></div>' % (k, v, s)
    return '<div class="b-house" role="group" aria-label="Your progress">%s%s%s<span class="b-xp%s"></span></div>' % (cell(*a), cell(*b), cell(*c), " x0" if zero else "")


HOUSE0 = (("Streak", "0 weeks", "0 of 3 this week"), ("Rank", "Novice", "level 1"), ("To level 2", "150 XP", "0 of 150"))
HOUSE3 = (("Streak", "3 weeks", "1 of 3 this week"), ("Rank", "Commis", "level 2"), ("To level 3", "67 XP", "183 of 250"))
MENU_H = '<div class="b-menu-h"><h2 class="b-d">The menu</h2><p class="b-it">Twelve techniques in four courses. Cook a dish twice and it earns the chef\'s stamp.</p></div>'


def home_empty():
    body = (mast("think") + house(*HOUSE0, zero=True) +
            '<section class="b-special"><span class="flag b-k">Tonight\'s special</span>'
            '<div class="blank"><span class="b-it">to be written</span><i></i></div>'
            '<h2 class="b-d">What is in your fridge tonight?</h2>'
            '<p class="from b-it">Show me, and I\'ll write the special from what you have. About ten seconds.</p>'
            '<div class="b-btn" role="button">%s Scan your fridge</div><div class="b-btn sec" role="button">%s Type what you have</div>'
            '<p class="r-cup">Cupboard: olive oil, salt, pepper and 9 more. <u>Edit</u></p></section>'
            '<section class="b-menu">%s%s<p class="b-fine b-it">New dishes are served once the ones before them are mastered.</p></section>') % (
                icon("camera", 20, 1.8), icon("keyboard", 20, 1.8), MENU_H, menu(zero_skills()))
    return shot("home-empty", "2a", "Home, first evening", "<b>The special's box stays, with the dish left blank.</b> The same frame that will hold tonight's dish asks the question instead, so the scan result lands exactly where the cook was looking. Scan is primary, typing is the visible second button, and the saved cupboard is one tap from editing. Zero progress: the first course is ready, everything else says what it is served after.", body, height=None, cap="full scroll height")


def home_returning():
    sk = SKILLS
    body = (mast("happy") + house(*HOUSE3) +
            '<section class="b-special" style="gap:9px;padding-top:22px"><span class="flag b-k">Tonight\'s special</span>'
            '<div class="blank"><span class="b-it">to be written</span><i></i></div>'
            '<h2 class="b-d" style="font-size:22px;line-height:27px">Next on your menu is Pan sauces. What have you got?</h2>'
            '<div class="b-btn" role="button">%s Scan your fridge</div>'
            '<div class="r-link" role="button" style="min-height:40px">%s Type what you have</div>'
            '<div class="r-again"><span class="nm b-d">Seared mushrooms on toast</span><span class="ld"></span><span class="b-u">Cook again</span></div></section>'
            '<section class="b-menu">%s%s</section>') % (icon("camera", 20, 1.8), icon("keyboard", 20, 1.8), MENU_H, menu(sk, only=(0,)))
    return shot("home-returning", "2b", "Home, returning, not scanned today", "The smaller variant. Same blank line, but Tomi already knows the next technique, so the box is shorter: one button, typing as a link, and last night's dish offered again for evenings with no time to scan. The menu follows as in round 1.", body, height=844, cls="b-screen r-crop", cap="first screenful")


# ---------------------------------------------------------------- 3. scan flow
def fridge_open(w=358, h=452):
    S = [
        D('rect x="0" y="0" width="358" height="452"', "iron_l"),
        D('rect x="18" y="14" width="322" height="424" rx="10"', "eye_hl"),
        L('path d="M18 136h322M18 252h322M18 356h322"', "ink", 2.4),
        D('rect x="18" y="138" width="322" height="5"', "bowl"), D('rect x="18" y="254" width="322" height="5"', "bowl"), D('rect x="18" y="358" width="322" height="5"', "bowl"),
        # shelf 1: milk, jar, wine
        F('path d="M52 136V70l14 -16h20l14 16v66z"', "white"), L('path d="M52 70h48M66 54v16"', "ink", 2), D('rect x="60" y="90" width="32" height="20" rx="2"', "bowl"),
        F('rect x="128" y="84" width="46" height="52" rx="7"', "yolk"), F('rect x="131" y="72" width="40" height="13" rx="3"', "red"),
        F('path d="M214 136V84c0 -8 8 -10 8 -22V40h14v22c0 12 8 14 8 22v52z"', "bowl"), D('rect x="218" y="98" width="22" height="22" rx="2"', "eye_hl"),
        F('rect x="270" y="96" width="48" height="40" rx="6"', "white"), L('path d="M270 110h48"', "ink", 2),
        # shelf 2: eggs, cheese, butter
        F('path d="M44 252v-18c0 -6 4 -10 10 -10h84c6 0 10 4 10 10v18z"', "bowl"),
        F('ellipse cx="66" cy="222" rx="10" ry="12.500"', "white"), F('ellipse cx="96" cy="222" rx="10" ry="12.500"', "white"), F('ellipse cx="126" cy="222" rx="10" ry="12.500"', "white"),
        F('path d="M186 252l64 -34v34z"', "yolk"), D('circle cx="232" cy="241" r="3"', "eye_hl"), D('circle cx="218" cy="246" r="2"', "eye_hl"),
        F('rect x="268" y="226" width="56" height="26" rx="4"', "yolk"), F('rect x="268" y="226" width="22" height="26" rx="4"', "white"),
        # shelf 3: tomatoes, cucumber, lemon
        F('path d="M40 322h84q-2 34 -42 34t-42 -34z"', "white"),
        F('circle cx="62" cy="316" r="11"', "red"), F('circle cx="84" cy="310" r="11"', "red"), F('circle cx="104" cy="317" r="11"', "red"),
        F('rect x="150" y="330" width="104" height="24" rx="12"', "green"),
        F('ellipse cx="296" cy="338" rx="24" ry="17"', "yolk"), F('circle cx="321" cy="338" r="3.500"', "yolk"),
        # drawer with spinach
        F('path d="M96 392c-14 -16 -6 -32 8 -34c4 14 6 24 -2 36zM132 390c-8 -20 2 -34 16 -34c2 14 0 26 -10 36zM172 392c-4 -20 8 -32 22 -30c0 14 -6 26 -16 32zM214 392c0 -18 12 -28 26 -24c-2 12 -10 22 -20 26z"', "green"),
        F('rect x="34" y="384" width="290" height="44" rx="6"', "white"), L('path d="M150 402h58"', "ink", 3),
    ]
    return '<svg viewBox="0 0 358 452" width="%s" height="%s" preserveAspectRatio="xMidYMid slice" role="img" aria-label="An open fridge with milk, a jar, wine, eggs, cheese, butter, tomatoes, cucumber, lemon and spinach">%s</svg>' % (w, h, render(S, B))


def scan_capture():
    body = ('<div class="r-top"><div class="b-ib" role="button" aria-label="Close" style="color:#fff">%s</div><div class="ttl">Tonight\'s fridge</div></div>'
            '<div class="r-tipcard">%s<span>Open the door wide and step back. I need to see every shelf.</span></div>'
            '<div class="r-vf">%s<span class="c tl"></span><span class="c tr"></span><span class="c bl"></span><span class="c br"></span></div>'
            '<div class="r-camfoot"><div class="r-cbtn" role="button"><i>%s</i>Photo library</div>'
            '<div class="r-shut" role="button" aria-label="Take photo"><i></i></div>'
            '<div class="r-cbtn" role="button"><i>%s</i>Type instead</div></div>') % (
                icon("close", 24, 2), tomi(B, "happy", 44), fridge_open(), icon("photos", 24, 1.8), icon("keyboard", 24, 1.8))
    return shot("scan-capture", "3a", "Capture", "The only dark screen, because it is a camera. Tomi's framing hint sits above the viewfinder, not over it. Library and \"Type instead\" are labelled, equal-weight exits either side of the shutter. The fridge here is a drawing standing in for the live camera.", body, cls="r-cam", sb="#FFFFFF")


def scan_reading():
    found = "".join('<span class="r-chip x" style="padding-right:13px">%s</span>' % n for n in ("milk", "eggs", "parmesan", "butter"))
    body = ('<div class="r-top"><div class="b-ib" role="button" aria-label="Cancel">%s</div><div style="flex:1"></div></div>'
            '<div class="r-body" style="padding-top:0"><div class="r-read">%s<div class="r-thumb">%s</div></div>'
            '<p class="b-k" style="margin-top:24px">One moment</p><h1 class="b-d">Reading your fridge</h1>'
            '<p class="sub b-it">Usually under ten seconds. It all happens on this phone.</p><div class="r-bar" role="progressbar" aria-label="Reading the photo"></div>'
            '<div class="r-grp"><div class="hd"><span class="b-k">Found so far</span><span class="b-it">4 items</span></div>'
            '<div class="r-chips">%s<span class="r-chip ghost"></span><span class="r-chip ghost" style="width:64px"></span></div></div></div>%s') % (
                icon("close", 24, 1.8), tomi(B, "think", 104), fridge_open(168, 214), found, foot(None, link="Cancel and type it instead"))
    return shot("scan-reading", "3b", "Reading the fridge", "A short wait made visible: the red line moves down the photo and found items appear as chips, so there is something to read from the first second. It states where the work happens. Cancel falls back to typing.", body)


FOUND = [("eggs", ""), ("spinach", ""), ("parmesan", ""), ("lemon", ""), ("cherry tomatoes", ""), ("cucumber", ""), ("butter", ""), ("milk", ""), ("white wine", ""), ("feta", "q"), ("spring onions", "q")]
CUP = [("Olive oil", "lock"), ("Salt", "lock"), ("Pepper", "lock"), ("Rice", "on"), ("Pasta", "on"), ("Garlic", "on"), ("Onions", "out"), ("Tinned tomatoes", "on")]

def cupboard():
    return ('<div class="r-grp"><div class="hd"><span class="b-k">From your cupboard</span><span class="b-it">tap to leave one out tonight</span></div><div class="r-chips">%s</div></div>') % (
        "".join(chip(n, k) for n, k in CUP))


def scan_review():
    body = ('<div class="r-top"><div class="b-ib" role="button" aria-label="Back">%s</div><div style="flex:1"></div></div>'
            '<div class="r-body" style="padding-top:0"><div class="r-revh"><div class="tx"><p class="b-k">Check my list</p><h1 class="b-d">Here is what I found.</h1></div>'
            '<div class="r-mini" role="button"><div>%s</div>Retake</div></div>'
            '<p class="sub b-it">Remove what is wrong, add what I missed.</p>'
            '<div class="r-grp"><div class="hd"><span class="b-k">From your fridge</span><span class="b-it">11 items</span></div><div class="r-chips">%s</div>'
            '<p class="r-legend b-it">Dashed means I am not sure. Tap to confirm, or remove it.</p></div>%s'
            '<div class="r-grp"><div class="hd"><span class="b-k">Add something</span><span class="b-it">anything I missed</span></div>'
            '<div class="r-field"><span class="b-it">Type an ingredient</span><div class="add" role="button" aria-label="Add">%s</div></div></div></div>'
            '<div class="r-flow"><div class="b-btn" role="button">Write tonight\'s special</div></div>') % (
                icon("back", 22, 2), fridge_open(52, 66), "".join(chip(n, k or "x") for n, k in FOUND), cupboard(), icon("plus", 20, 2.4))
    return shot("scan-review", "3c", "Review what Tomi found", "The correction step the plan requires (\"always show editable chips\"). Three groups: what the photo showed (each removable, two marked unsure with a dashed edge and a question mark), the saved cupboard (Onions switched off for tonight, struck through), and a field for anything missed. One primary button.", body, height=None, cap="scrolls, full height")


def scan_typed():
    typed = "".join(chip(n, "x") for n in ("eggs", "spinach", "parmesan", "cherry tomatoes"))
    body = ('<div class="r-top"><div class="b-ib" role="button" aria-label="Back">%s</div><div style="flex:1"></div><div class="r-skip" role="button" style="text-decoration:none;display:flex;align-items:center;gap:6px">%s Use the camera</div></div>'
            '<div class="r-body" style="padding-top:0"><p class="b-k">No photo needed</p><h1 class="b-d">What have you got tonight?</h1>'
            '<p class="sub b-it">The main things will do. A few words each.</p>'
            '<div class="r-field focus"><span>lem<i class="caret"></i></span><div class="add" role="button" aria-label="Add">%s</div></div>'
            '<div class="r-sugg"><span>lemon</span><span>lemongrass</span><span>lemon thyme</span></div>'
            '<div class="r-grp"><div class="hd"><span class="b-k">On tonight\'s list</span><span class="b-it">4 items</span></div><div class="r-chips">%s</div></div>%s</div>'
            '<div class="r-flow"><div class="b-btn" role="button">Write tonight\'s special</div></div>') % (
                icon("back", 22, 2), icon("camera", 18, 1.8), icon("plus", 20, 2.4), typed, cupboard())
    return shot("scan-typed", "3d", "Typed-only path", "The same review screen with the field moved to the top and focused, for people who skip the camera or whose phone has no Apple Intelligence. Suggestions complete a word in one tap. The cupboard does the same work as before, so three or four typed items are enough. The keyboard is not drawn.", body, height=None, cap="keyboard not drawn")


def scan_nothing():
    body = ('<div class="r-top"><div class="b-ib" role="button" aria-label="Back">%s</div><div style="flex:1"></div></div>'
            '<div class="r-body" style="padding-top:0"><div style="display:flex;align-items:flex-end;gap:10px">%s<p class="b-it" style="font-size:18px;line-height:24px;color:var(--ink);padding-bottom:14px">&ldquo;Milk, butter, a lemon and white wine. Even I need a little more than that.&rdquo;</p></div>'
            '<p class="b-k" style="margin-top:14px">Nothing fits yet</p><h1 class="b-d">Not quite a dish.</h1>'
            '<p class="sub b-it">The closest one on your menu is two things short.</p>'
            '<div class="r-close"><span class="b-k">Closest dish</span><h2 class="b-d">Buttery spinach omelette</h2>'
            '<div class="ln">You have %s%s%s</div><div class="ln">Missing %s%s</div></div></div>'
            '<div class="b-foot col"><div class="b-btn" role="button">%s Add what I missed</div>'
            '<div class="b-btn sec" role="button">Cook from the cupboard instead</div>'
            '<p class="r-hint b-it" style="margin-top:2px">Garlic and oil spaghetti needs nothing from the fridge.</p></div>') % (
                icon("back", 22, 2), tomi(B, "think", 100),
                '<span class="r-use">butter</span>', '<span class="r-use cup">salt</span>', '<span class="r-use cup">oil</span>',
                '<span class="r-miss">eggs</span>', '<span class="r-miss">spinach</span>', icon("plus", 20, 2))
    return shot("scan-nothing", "3e", "Nothing fits", "Tomi says so plainly, names the closest dish and exactly what is missing, and offers two ways forward: fix the list (most misses are a bad photo), or cook a cupboard-only dish so the evening and the streak are not lost.", body)


def home_result():
    body = (mast("cheer") + house(*HOUSE0, zero=True) +
            '<section class="b-special"><span class="flag b-k">Tonight\'s special</span><h2 class="b-d">Spinach and parmesan omelette</h2>'
            '<div class="uses" aria-label="Uses"><span class="r-use">eggs</span><span class="r-use">spinach</span><span class="r-use">parmesan</span><span class="r-use">butter</span><span class="r-use cup">salt</span></div>'
            '<p class="from b-it">Uses four things from your fridge. Nothing to buy.</p>'
            '<p class="meta b-u">Practises <b>Eggs 101</b> &middot; 15 min &middot; +40 XP</p>'
            '<div class="b-btn" role="button">Start cooking</div><div class="b-btn sec" role="button">%s Scan again</div></section>'
            '<section class="r-also"><p class="b-k">Also on tonight</p>'
            '<div class="r-alt"><div class="row"><span class="nm b-d">Tomato and cucumber salad</span><span class="ld"></span><span class="sk">Knife basics</span></div><p class="b-it">Uses cherry tomatoes, cucumber, lemon. 10 min</p></div>'
            '<div class="r-alt"><div class="row"><span class="nm b-d">Soft eggs, buttered spinach</span><span class="ld"></span><span class="sk">Boil &amp; blanch</span></div><p class="b-it">Uses eggs, spinach, butter. 12 min</p></div></section>'
            '<section class="b-menu" style="padding-top:26px">%s%s<p class="b-fine b-it">New dishes are served once the ones before them are mastered.</p></section>') % (
                icon("camera", 20, 1.8), MENU_H, menu(zero_skills("eggs")))
    return shot("home-result", "3f", "The result, back on home", "The blank line is filled in. Chips under the title say what it uses: solid for the fridge, pale for the cupboard. Two alternatives sit below as ordinary dish lines, each practising a different technique that is ready. On the menu, Eggs 101 is now circled as tonight's.", body, height=None, cap="full scroll height")


# ---------------------------------------------------------------- fixes
def step_fixed():
    html = dir_b.step()
    html = html.replace('id="dir-b-step"', 'id="fix-step"').replace('<span class="code">B2</span>', '<span class="code">4a</span>')
    html = html.replace('class="b-top"', 'class="b-top v2"')
    html, n = re.subn(r'<div class="b-ib on" role="button" aria-label="Read aloud is on">.*?</svg></div>',
                      lambda m: '<div class="r-voice" role="switch" aria-checked="true">%s Voice on</div>' % icon("speaker", 18, 1.8), html, count=1, flags=re.S)
    assert n == 1
    html = html.replace('</div></div></figure>', '</div></div><p class="shot-note">The voice toggle now says what it is and what state it is in: \"Voice on\" with a filled background, \"Voice off\" outlined. Everything else is unchanged from round 1.</p></figure>')
    return html


def specimen():
    return ('<figure class="shot" id="fix-stamp"><figcaption><span class="code">4b</span><b>Chef\'s stamp</b><span class="cap-note">before and after</span></figcaption>'
            '<div style="display:flex;flex-direction:column;gap:12px;min-width:0"><div class="specimen"><div>%s<span>round 1, 42 pt</span></div><div>%s<span>new, 42 pt</span></div><div>%s<span>new, 28 pt</span></div></div>'
            '<div class="b-screen" style="max-width:410px;padding:4px 20px 0;border:1px solid var(--pg-line);border-radius:14px">%s%s</div></div>'
            '<p class="shot-note">One ring, a larger toque with two pleats and a clear band. The dashed inner ring and underline are gone. It now reads at 28 pt; the experience question uses it at 30 pt.</p></figure>') % (
                OLD_STAMP(42), stamp2(42), stamp2(28), dir_b.dish(SK["knife"]), dir_b.dish(SK["sear"]))


# ---------------------------------------------------------------- page
FLOW = [
    ("1a", "Welcome", "Write my menu", "1", "No"),
    ("1b", "What do you eat?", "Tap an answer, advances", "1", "No, decides which dishes exist"),
    ("1c", "Anything to avoid?", "\"None of these\", advances", "1", "No, safety"),
    ("1d", "Cuisines", "Continue (all on \"try\")", "1", "Yes"),
    ("1e", "Your kitchen", "Continue (defaults ticked)", "1", "Yes"),
    ("1f", "How much have you cooked?", "Tap an answer, advances", "1", "Yes, starts at the first dish"),
    ("1g", "Table and units", "Continue (2, phone's region)", "1", "Yes"),
    ("1h", "Cupboard", "Continue (7 staples ticked)", "1", "Yes"),
    ("1i", "Camera primer", "Allow, or Type it instead", "1 + iOS prompt", "Camera is optional"),
    ("1j", "Notification primer", "Allow, or Not now", "1 + iOS prompt", "Notifications are optional"),
    ("1k", "Done", "Scan my fridge", "1", ""),
    ("", "Whole onboarding", "", "11 taps + 2 iOS prompts", "5 of 7 questions skippable"),
]


def header():
    rows = "".join('<tr><td class="n">%s</td><td>%s</td><td>%s</td><td class="n">%s</td><td>%s</td></tr>' % r for r in FLOW)
    return ('<header id="intro"><p class="pg-kick">Tomi for iPhone, design round 2</p>'
            '<h1 class="pg-h1">The tasting menu, from first launch to tonight\'s special</h1>'
            '<p class="pg-lede" id="flow-note">Direction B, taken through the three things asked for: the whole onboarding, home before a fridge scan, and the scan flow, including the saved cupboard. Same palette, type and print-style Tomi as round 1. '
            'Onboarding is seven questions between a welcome and two permission primers. Every question has a default or advances on a single tap, so the shortest path through is <b>11 taps plus the two iOS permission dialogs</b>, about a minute. '
            'Only the two questions that decide what is safe to serve cannot be skipped. A skipped question keeps its default and can be answered later in Settings.</p>'
            '<div class="flow"><table><thead><tr><th scope="col"></th><th scope="col">Screen</th><th scope="col">Fastest way through</th><th scope="col">Taps</th><th scope="col">Skippable</th></tr></thead><tbody>%s</tbody></table></div></header>') % rows


def section(id_, n, title, lede, shots):
    return ('<section class="r2-sec" id="%s"><div class="dir-head"><span class="ltr" style="background:#1D3690">%s</span><div><h2>%s</h2><p>%s</p></div></div>'
            '<div class="r2-grid">%s</div></section>') % (id_, n, title, lede, "".join(shots))


def closing():
    return ('<section class="final" id="open-questions"><p class="pg-kick">Before building</p><h2>Open questions, and what to cut</h2>'
            '<div class="oq"><div id="oq-questions"><h3>Open questions</h3><ul>'
            '<li><b>Level names.</b> I used Novice for level 1 and Commis for level 2. The full ladder (Chef de partie, Sous chef, and so on) needs deciding, or the rank column goes back to a plain level number.</li>'
            '<li><b>Does \"never\" a cuisine hide alternatives too?</b> I assumed yes: never means never, on the special and on \"also on tonight\".</li>'
            '<li><b>Fish appears twice,</b> as a diet (pescatarian) and as something to avoid. I kept both because one is preference and one is allergy, but a vegan who ticks nothing still needs dairy and eggs excluded by the diet rule, not by this screen.</li>'
            '<li><b>Uncertain ingredients.</b> I show them dashed with a question mark and count them as present unless removed. The safer rule is to leave them out of matching until confirmed. Which one is a product call.</li>'
            '<li><b>Cupboard-only dishes.</b> The \"nothing fits\" screen promises a dish that needs nothing from the fridge. The lesson library has to contain a few for each first-course technique.</li>'
            '<li><b>Reminder time.</b> 17:30 is a guess. It could be asked, or learned from when the first few scans happen.</li>'
            '<li><b>Not designed this round:</b> the keyboard-up state, the iOS permission dialogs themselves, the denied-camera state, Settings, and dark theme.</li></ul></div>'
            '<div id="oq-cuts"><h3>If onboarding feels too long, cut in this order</h3><ul>'
            '<li><b>1. Move the notification primer (1j) to the first timer.</b> The reason is most convincing at the moment a timer is about to start. Saves a screen and an iOS dialog.</li>'
            '<li><b>2. Move the cupboard (1h) to the first scan review.</b> It already appears there. Pre-tick the same staples and let the cook correct them in context.</li>'
            '<li><b>3. Fold table and units (1g) into defaults.</b> Two people and the phone\'s region are right for most. Offer the change on the first recipe card.</li>'
            '<li><b>4. Move cuisines (1d) to after the first cooked lesson.</b> The owner raised this one, so I would keep it until the others are gone, but it is the least needed on day one.</li>'
            '<li><b>Keep to the end:</b> diet, avoid, kitchen, experience, and the camera primer. They change tonight\'s dish or its safety.</li></ul></div></div>'
            '<div class="rec" id="recommendation"><p class="pg-kick">Recommendation</p><h3>Ship cuts 1 and 2 from the start: nine screens, nine taps, one iOS dialog.</h3>'
            '<p><b>Why.</b> The cupboard and the notification request both work better at the moment they matter, and both already have a home there: the scan review shows the cupboard, and the first timer is the honest time to ask to ring. That leaves six questions, each of which changes what is served tonight, plus the welcome, the camera primer and the done screen.</p>'
            '<p><b>Keep the cuisines screen.</b> It answers the owner\'s case directly (Mexican struck off the menu in one tap), costs one tap for people with no strong feelings, and is where the later guest menus get their first mention.</p>'
            '<p><b>Home before a scan.</b> Keep the blank special. It teaches the layout of the home screen before there is anything in it, and makes the scan result feel like an answer.</p></div></section>')


def build():
    FONTS = ("https://fonts.googleapis.com/css2?family=Instrument+Sans:wght@400..700&family=Gloock"
             "&family=Newsreader:ital,opsz,wght@0,6..72,400..600;1,6..72,400..600&family=Figtree:wght@400..700&display=swap")
    ob = [ob_welcome(), ob_diet(), ob_avoid(), ob_cuisines(), ob_kitchen(), ob_level(), ob_table(), ob_pantry(), ob_camera(), ob_notify(), ob_done()]
    parts = ['<!doctype html>\n<html lang="en">\n<head>\n<meta charset="utf-8">\n<meta name="viewport" content="width=device-width, initial-scale=1">\n',
             '<title>Tomi design round 2</title>\n',
             '<link rel="preconnect" href="https://fonts.googleapis.com">\n<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>\n',
             '<link rel="stylesheet" href="%s">\n' % FONTS.replace("&", "&amp;"),
             "<style>\n", PAGE_CSS, dir_b.CSS, CSS, "</style>\n</head>\n<body>\n<div class=\"wrap\">\n",
             header(),
             section("onboarding", "1", "Onboarding", "Eleven screens in order. One decision per screen, progress along the top, and \"Skip, ask me later\" wherever skipping is safe. Tomi is writing your menu, so the questions are set like one.", ob),
             section("home-before-scan", "2", "Home before a scan", "What stands in for tonight's special when there is none yet, on the first evening and for a returning cook.", [home_empty(), home_returning()]),
             section("scan-flow", "3", "Scan flow", "Camera, a short wait, a list to correct, then the special. The typed route and the dead end are designed too.", [scan_capture(), scan_reading(), scan_review(), scan_typed(), scan_nothing(), home_result()]),
             section("fixes", "4", "Fixes from round 1", "The two weaknesses reported in direction B.", [step_fixed(), specimen()]),
             closing(), "</div>\n</body>\n</html>\n"]
    text = "".join(parts)
    assert chr(8212) not in text and chr(8211) not in text, "dash found"
    assert "#ff00ff" not in text, "missing palette key"
    out = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "round2.html")
    open(out, "w", encoding="utf-8").write(text)
    print("wrote", os.path.abspath(out), len(text) // 1024, "KB")
    if os.environ.get("DBG"):
        head_ = "".join(parts[:8]) + "</style></head><body>"
        for m in re.finditer(r'<figure class="shot" id="([^"]+)".*?</figure>', text, flags=re.S):
            open(os.path.join(os.path.dirname(out), "_dbg_%s.html" % m.group(1)), "w", encoding="utf-8").write(head_ + '<div style="padding:10px">%s</div></body></html>' % m.group(0))


if __name__ == "__main__":
    build()
