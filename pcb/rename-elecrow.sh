mkdir gerber
mv surfboard-F.Cu.gbr gerber/surfboard.GTL
mv surfboard-B.Cu.gbr gerber/surfboard.GBL
mv surfboard-F.Mask.gbr gerber/surfboard.GTS
mv surfboard-B.Mask.gbr gerber/surfboard.GBS
mv surfboard-F.SilkS.gbr gerber/surfboard.GTO
mv surfboard-B.SilkS.gbr gerber/surfboard.GBO
mv surfboard-PTH.drl gerber/surfboard.TXT
mv surfboard-NPTH.drl gerber/surfboard-NPTH.TXT
mv surfboard-Edge.Cuts.gbr gerber/surfboard.GML
zip -r gerber gerber
