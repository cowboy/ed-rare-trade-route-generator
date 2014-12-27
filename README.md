# Elite: Dangerous Rare Trade Route Generator

Tested on OS X with ruby 2.0.0p247.

## Usage

```bash
$ time ./generate-routes.rb
Parsing CSV data...done
Update: 26/12/14 - rev 1358
Normalizing system data...done
Removing systems with distant stations / missing routes...done
Grouping nearby systems...done
Calculating routes...
Route #1 (warnings=5, jumps=13, distance=592.33, 26/12/14 - rev 1358)
Route #2 (warnings=5, jumps=13, distance=559.52, 26/12/14 - rev 1358)
Route #3 (warnings=5, jumps=13, distance=586.20, 26/12/14 - rev 1358)
Route #4 (warnings=5, jumps=13, distance=588.46, 26/12/14 - rev 1358)
Route #5 (warnings=5, jumps=13, distance=613.50, 26/12/14 - rev 1358)
...thousands of lines of output...
Route #26998 (warnings=4, jumps=11, distance=599.99, 26/12/14 - rev 1358)
Route #26999 (warnings=4, jumps=12, distance=671.37, 26/12/14 - rev 1358)
Route #27000 (warnings=4, jumps=12, distance=679.71, 26/12/14 - rev 1358)
Route #27001 (warnings=4, jumps=11, distance=627.60, 26/12/14 - rev 1358)
Route #27002 (warnings=4, jumps=13, distance=743.31, 26/12/14 - rev 1358)

Done!

==========================================
     POSSIBLY-INTERESTING STATISTICS
==========================================
Number of loops found..............2983196
Number of routes found...............27002
Number of perfect routes found...........7
Number of imperfect routes found.....26995
Max depth seen..........................10
Max jumps seen..........................14
==========================================

real	348m35.263s
user	346m59.850s
sys	0m21.759s
```

(Yes, it took almost 4 hours to run)

## Sample results

From generated `routes/best-10.txt` file:

```
============[ BEST ROUTE #1 ]=============

Route #4859 (warnings=0, jumps=13, distance=669.32, 26/12/14 - rev 1358) PERFECT

["Leesti", "Diso", "Lave", "Orrere", "Zaonce", "Any Na", "Deuringas", "Neritus", "39 Tauri", "Bast", "Esuseku", "Eranin", "Shinrarta Dezhra"]

Leesti
   BUY Leestian Evil Juice x 14 (George Lucas @ 257.0 Ls)
   BUY Azure Milk x 7 (George Lucas @ 257.0 Ls)
  NEXT Diso (2.57 Ly)
Diso
  SELL Tauri Chimes (39 Tauri @ 160.87 Ly)
   BUY Diso Ma Corn x 15 (Shifnalport @ 284.0 Ls)
  NEXT Lave (3.59 Ly)
Lave
   BUY Lavian Brandy x 7 (Lave Station @ 302.0 Ls)
  NEXT Orrere (9.15 Ly)
Orrere
   BUY Orrerian Vicious Brew x 16 (Sharon Lee Free Market @ 963.0 Ls)
  NEXT Zaonce (14.07 Ly)
Zaonce
  SELL Bast Snake Gin (Bast @ 160.18 Ly)
   BUY Leathery Eggs x 1 (Ridley Scott @ 400.0 Ls)
  NEXT Any Na (87.21 Ly)
Any Na
   BUY Any Na Coffee x 11 (Libby Orbital @ 581.0 Ls)
  NEXT Deuringas (51.64 Ly)
Deuringas
  SELL Eranin Whiskey (Eranin @ 167.1 Ly)
   BUY Deuringas Truffles x 7 (Shukor Hub @ 798.0 Ls)
  NEXT Neritus (62.09 Ly)
Neritus
   BUY Neritus Berries x 13 (Toll Ring @ 524.0 Ls)
  NEXT 39 Tauri (88.17 Ly)
39 Tauri
  SELL Diso Ma Corn (Diso @ 160.87 Ly)
  SELL Lavian Brandy (Lave @ 162.68 Ly)
  SELL Orrerian Vicious Brew (Orrere @ 163.89 Ly)
  SELL Leathery Eggs (Zaonce @ 164.19 Ly)
   BUY Tauri Chimes x 17 (Porta @ 991.0 Ls)
  NEXT Bast (49.32 Ly)
Bast
  SELL Any Na Coffee (Any Na @ 170.32 Ly)
  SELL Deuringas Truffles (Deuringas @ 174.22 Ly)
   BUY Bast Snake Gin x 10 (Hart Station @ 202.0 Ls)
  NEXT Esuseku (73.99 Ly)
Esuseku
  SELL Leestian Evil Juice (Leesti @ 202.36 Ly)
  SELL Azure Milk (Leesti @ 202.36 Ly)
  SELL Neritus Berries (Neritus @ 185.55 Ly)
  SELL Waters of Shintara (Shinrarta Dezhra @ 170.94 Ly)
   BUY Esuseku Caviar x 10 (Savinykh Orbital @ 276.0 Ls)
  NEXT Eranin (87.57 Ly)
Eranin
   BUY Eranin Whiskey x 8 (Azeban City @ 297.0 Ls)
  NEXT Shinrarta Dezhra (85.64 Ly)
Shinrarta Dezhra
  SELL Esuseku Caviar (Esuseku @ 170.94 Ly)
   BUY Waters of Shintara x 5 (Jameson Memorial @ 347.0 Ls)
  NEXT Leesti (54.31 Ly)


============[ BEST ROUTE #2 ]=============

Route #4870 (warnings=0, jumps=13, distance=674.29, 26/12/14 - rev 1358) PERFECT

["Leesti", "Diso", "Lave", "Orrere", "Zaonce", "Any Na", "Deuringas", "Neritus", "39 Tauri", "Hecate", "Esuseku", "Eranin", "Shinrarta Dezhra"]

Leesti
  SELL Live Hecate Sea Worms (Hecate @ 186.27 Ly)
   BUY Leestian Evil Juice x 14 (George Lucas @ 257.0 Ls)
   BUY Azure Milk x 7 (George Lucas @ 257.0 Ls)
  NEXT Diso (2.57 Ly)
Diso
  SELL Tauri Chimes (39 Tauri @ 160.87 Ly)
   BUY Diso Ma Corn x 15 (Shifnalport @ 284.0 Ls)
  NEXT Lave (3.59 Ly)
Lave
   BUY Lavian Brandy x 7 (Lave Station @ 302.0 Ls)
  NEXT Orrere (9.15 Ly)
Orrere
   BUY Orrerian Vicious Brew x 16 (Sharon Lee Free Market @ 963.0 Ls)
  NEXT Zaonce (14.07 Ly)
Zaonce
   BUY Leathery Eggs x 1 (Ridley Scott @ 400.0 Ls)
  NEXT Any Na (87.21 Ly)
Any Na
   BUY Any Na Coffee x 11 (Libby Orbital @ 581.0 Ls)
  NEXT Deuringas (51.64 Ly)
Deuringas
  SELL Eranin Whiskey (Eranin @ 167.1 Ly)
   BUY Deuringas Truffles x 7 (Shukor Hub @ 798.0 Ls)
  NEXT Neritus (62.09 Ly)
Neritus
   BUY Neritus Berries x 13 (Toll Ring @ 524.0 Ls)
  NEXT 39 Tauri (88.17 Ly)
39 Tauri
  SELL Diso Ma Corn (Diso @ 160.87 Ly)
  SELL Lavian Brandy (Lave @ 162.68 Ly)
  SELL Orrerian Vicious Brew (Orrere @ 163.89 Ly)
  SELL Leathery Eggs (Zaonce @ 164.19 Ly)
   BUY Tauri Chimes x 17 (Porta @ 991.0 Ls)
  NEXT Hecate (49.37 Ly)
Hecate
  SELL Leestian Evil Juice (Leesti @ 186.27 Ly)
  SELL Azure Milk (Leesti @ 186.27 Ly)
  SELL Any Na Coffee (Any Na @ 192.24 Ly)
  SELL Deuringas Truffles (Deuringas @ 195.65 Ly)
   BUY Live Hecate Sea Worms x 13 (RJH1972 @ 570.0 Ls)
  NEXT Esuseku (78.91 Ly)
Esuseku
  SELL Neritus Berries (Neritus @ 185.55 Ly)
  SELL Waters of Shintara (Shinrarta Dezhra @ 170.94 Ly)
   BUY Esuseku Caviar x 10 (Savinykh Orbital @ 276.0 Ls)
  NEXT Eranin (87.57 Ly)
Eranin
   BUY Eranin Whiskey x 8 (Azeban City @ 297.0 Ls)
  NEXT Shinrarta Dezhra (85.64 Ly)
Shinrarta Dezhra
  SELL Esuseku Caviar (Esuseku @ 170.94 Ly)
   BUY Waters of Shintara x 5 (Jameson Memorial @ 347.0 Ls)
  NEXT Leesti (54.31 Ly)


============[ BEST ROUTE #3 ]=============

Route #19706 (warnings=0, jumps=13, distance=714.84, 26/12/14 - rev 1358) PERFECT

["Leesti", "Diso", "Lave", "Orrere", "Shinrarta Dezhra", "George Pantazis", "Kappa Fornacis", "Utgaroar", "Yaso Kondi", "Quechua", "Tanmark", "Epsilon Indi", "CD-75 661"]

Leesti
  SELL Utgaroar Millennial Eggs (Utgaroar @ 183.62 Ly)
  SELL Albino Quechua Mammoth Meat (Quechua @ 195.41 Ly)
  SELL Tanmark Tranquil Tea (Tanmark @ 175.37 Ly)
   BUY Leestian Evil Juice x 14 (George Lucas @ 257.0 Ls)
   BUY Azure Milk x 7 (George Lucas @ 257.0 Ls)
  NEXT Diso (2.57 Ly)
Diso
  SELL Onion Head (Kappa Fornacis @ 160.21 Ly)
   BUY Diso Ma Corn x 15 (Shifnalport @ 284.0 Ls)
  NEXT Lave (3.59 Ly)
Lave
   BUY Lavian Brandy x 7 (Lave Station @ 302.0 Ls)
  NEXT Orrere (9.15 Ly)
Orrere
   BUY Orrerian Vicious Brew x 16 (Sharon Lee Free Market @ 963.0 Ls)
  NEXT Shinrarta Dezhra (60.02 Ly)
Shinrarta Dezhra
   BUY Waters of Shintara x 5 (Jameson Memorial @ 347.0 Ls)
  NEXT George Pantazis (86.25 Ly)
George Pantazis
   BUY Pantaa Prayer Sticks x 13 (Zakam Platform @ 45.0 Ls)
  NEXT Kappa Fornacis (57.02 Ly)
Kappa Fornacis
  SELL Diso Ma Corn (Diso @ 160.21 Ly)
  SELL Lavian Brandy (Lave @ 161.58 Ly)
  SELL Orrerian Vicious Brew (Orrere @ 162.61 Ly)
   BUY Onion Head x 17 (Harvestport @ 918.0 Ls)
  NEXT Utgaroar (41.93 Ly)
Utgaroar
  SELL Leestian Evil Juice (Leesti @ 183.62 Ly)
  SELL Azure Milk (Leesti @ 183.62 Ly)
   BUY Utgaroar Millennial Eggs x 15 (Fort Klarix @ 171.0 Ls)
  NEXT Yaso Kondi (73.48 Ly)
Yaso Kondi
  SELL Waters of Shintara (Shinrarta Dezhra @ 202.01 Ly)
  SELL Pantaa Prayer Sticks (George Pantazis @ 161.36 Ly)
  SELL Indi Bourbon (Epsilon Indi @ 167.23 Ly)
  SELL CD-75 Kitten Brand Coffee (CD-75 661 @ 174.68 Ly)
   BUY Yaso Kondi Leaf x 5 (Wheeler Market @ 114.0 Ls)
  NEXT Quechua (88.8 Ly)
Quechua
   BUY Albino Quechua Mammoth Meat x 10 (Crown Ring @ 120.0 Ls)
  NEXT Tanmark (61.85 Ly)
Tanmark
   BUY Tanmark Tranquil Tea x 9 (Cassie-L-Peia @ 414.0 Ls)
  NEXT Epsilon Indi (78.41 Ly)
Epsilon Indi
  SELL Yaso Kondi Leaf (Yaso Kondi @ 167.23 Ly)
   BUY Indi Bourbon x 11 (Mansfield Orbiter @ 143.0 Ls)
  NEXT CD-75 661 (79.31 Ly)
CD-75 661
   BUY CD-75 Kitten Brand Coffee x 12 (Kirk Dock @ 339.0 Ls)
  NEXT Leesti (72.46 Ly)


============[ BEST ROUTE #4 ]=============

Route #10397 (warnings=0, jumps=13, distance=720.91, 26/12/14 - rev 1358) PERFECT

["Leesti", "Diso", "Lave", "Orrere", "Shinrarta Dezhra", "Altair", "Kappa Fornacis", "Utgaroar", "Yaso Kondi", "Quechua", "Tanmark", "Epsilon Indi", "CD-75 661"]

Leesti
  SELL Utgaroar Millennial Eggs (Utgaroar @ 183.62 Ly)
  SELL Albino Quechua Mammoth Meat (Quechua @ 195.41 Ly)
  SELL Tanmark Tranquil Tea (Tanmark @ 175.37 Ly)
   BUY Leestian Evil Juice x 14 (George Lucas @ 257.0 Ls)
   BUY Azure Milk x 7 (George Lucas @ 257.0 Ls)
  NEXT Diso (2.57 Ly)
Diso
  SELL Onion Head (Kappa Fornacis @ 160.21 Ly)
   BUY Diso Ma Corn x 15 (Shifnalport @ 284.0 Ls)
  NEXT Lave (3.59 Ly)
Lave
   BUY Lavian Brandy x 7 (Lave Station @ 302.0 Ls)
  NEXT Orrere (9.15 Ly)
Orrere
   BUY Orrerian Vicious Brew x 16 (Sharon Lee Free Market @ 963.0 Ls)
  NEXT Shinrarta Dezhra (60.02 Ly)
Shinrarta Dezhra
   BUY Waters of Shintara x 5 (Jameson Memorial @ 347.0 Ls)
  NEXT Altair (72.82 Ly)
Altair
   BUY Altairian Skin x 22 (Solo Orbiter @ 661.0 Ls)
  NEXT Kappa Fornacis (76.52 Ly)
Kappa Fornacis
  SELL Diso Ma Corn (Diso @ 160.21 Ly)
  SELL Lavian Brandy (Lave @ 161.58 Ly)
  SELL Orrerian Vicious Brew (Orrere @ 162.61 Ly)
   BUY Onion Head x 17 (Harvestport @ 918.0 Ls)
  NEXT Utgaroar (41.93 Ly)
Utgaroar
  SELL Leestian Evil Juice (Leesti @ 183.62 Ly)
  SELL Azure Milk (Leesti @ 183.62 Ly)
   BUY Utgaroar Millennial Eggs x 15 (Fort Klarix @ 171.0 Ls)
  NEXT Yaso Kondi (73.48 Ly)
Yaso Kondi
  SELL Waters of Shintara (Shinrarta Dezhra @ 202.01 Ly)
  SELL Altairian Skin (Altair @ 174.42 Ly)
  SELL Indi Bourbon (Epsilon Indi @ 167.23 Ly)
  SELL CD-75 Kitten Brand Coffee (CD-75 661 @ 174.68 Ly)
   BUY Yaso Kondi Leaf x 5 (Wheeler Market @ 114.0 Ls)
  NEXT Quechua (88.8 Ly)
Quechua
   BUY Albino Quechua Mammoth Meat x 10 (Crown Ring @ 120.0 Ls)
  NEXT Tanmark (61.85 Ly)
Tanmark
   BUY Tanmark Tranquil Tea x 9 (Cassie-L-Peia @ 414.0 Ls)
  NEXT Epsilon Indi (78.41 Ly)
Epsilon Indi
  SELL Yaso Kondi Leaf (Yaso Kondi @ 167.23 Ly)
   BUY Indi Bourbon x 11 (Mansfield Orbiter @ 143.0 Ls)
  NEXT CD-75 661 (79.31 Ly)
CD-75 661
   BUY CD-75 Kitten Brand Coffee x 12 (Kirk Dock @ 339.0 Ls)
  NEXT Leesti (72.46 Ly)


============[ BEST ROUTE #5 ]=============

Route #22166 (warnings=0, jumps=13, distance=731.94, 26/12/14 - rev 1358) PERFECT

["Leesti", "Diso", "Lave", "Orrere", "Shinrarta Dezhra", "Zeessze", "Kappa Fornacis", "Utgaroar", "Yaso Kondi", "Quechua", "Tanmark", "Epsilon Indi", "CD-75 661"]

Leesti
  SELL Utgaroar Millennial Eggs (Utgaroar @ 183.62 Ly)
  SELL Albino Quechua Mammoth Meat (Quechua @ 195.41 Ly)
  SELL Tanmark Tranquil Tea (Tanmark @ 175.37 Ly)
   BUY Leestian Evil Juice x 14 (George Lucas @ 257.0 Ls)
   BUY Azure Milk x 7 (George Lucas @ 257.0 Ls)
  NEXT Diso (2.57 Ly)
Diso
  SELL Onion Head (Kappa Fornacis @ 160.21 Ly)
   BUY Diso Ma Corn x 15 (Shifnalport @ 284.0 Ls)
  NEXT Lave (3.59 Ly)
Lave
   BUY Lavian Brandy x 7 (Lave Station @ 302.0 Ls)
  NEXT Orrere (9.15 Ly)
Orrere
   BUY Orrerian Vicious Brew x 16 (Sharon Lee Free Market @ 963.0 Ls)
  NEXT Shinrarta Dezhra (60.02 Ly)
Shinrarta Dezhra
   BUY Waters of Shintara x 5 (Jameson Memorial @ 347.0 Ls)
  NEXT Zeessze (88.64 Ly)
Zeessze
   BUY Zeessze Ant Grub Glue x 18 (Nicollier Hanger @ 489.0 Ls)
  NEXT Kappa Fornacis (71.73 Ly)
Kappa Fornacis
  SELL Diso Ma Corn (Diso @ 160.21 Ly)
  SELL Lavian Brandy (Lave @ 161.58 Ly)
  SELL Orrerian Vicious Brew (Orrere @ 162.61 Ly)
   BUY Onion Head x 17 (Harvestport @ 918.0 Ls)
  NEXT Utgaroar (41.93 Ly)
Utgaroar
  SELL Leestian Evil Juice (Leesti @ 183.62 Ly)
  SELL Azure Milk (Leesti @ 183.62 Ly)
   BUY Utgaroar Millennial Eggs x 15 (Fort Klarix @ 171.0 Ls)
  NEXT Yaso Kondi (73.48 Ly)
Yaso Kondi
  SELL Waters of Shintara (Shinrarta Dezhra @ 202.01 Ly)
  SELL Zeessze Ant Grub Glue (Zeessze @ 174.93 Ly)
  SELL Indi Bourbon (Epsilon Indi @ 167.23 Ly)
  SELL CD-75 Kitten Brand Coffee (CD-75 661 @ 174.68 Ly)
   BUY Yaso Kondi Leaf x 5 (Wheeler Market @ 114.0 Ls)
  NEXT Quechua (88.8 Ly)
Quechua
   BUY Albino Quechua Mammoth Meat x 10 (Crown Ring @ 120.0 Ls)
  NEXT Tanmark (61.85 Ly)
Tanmark
   BUY Tanmark Tranquil Tea x 9 (Cassie-L-Peia @ 414.0 Ls)
  NEXT Epsilon Indi (78.41 Ly)
Epsilon Indi
  SELL Yaso Kondi Leaf (Yaso Kondi @ 167.23 Ly)
   BUY Indi Bourbon x 11 (Mansfield Orbiter @ 143.0 Ls)
  NEXT CD-75 661 (79.31 Ly)
CD-75 661
   BUY CD-75 Kitten Brand Coffee x 12 (Kirk Dock @ 339.0 Ls)
  NEXT Leesti (72.46 Ly)


============[ BEST ROUTE #6 ]=============

Route #19905 (warnings=0, jumps=13, distance=761.73, 26/12/14 - rev 1358) PERFECT

["Leesti", "Diso", "Lave", "Orrere", "Shinrarta Dezhra", "George Pantazis", "Kappa Fornacis", "Quechua", "Yaso Kondi", "Utgaroar", "Witchhaul", "Epsilon Indi", "CD-75 661"]

Leesti
  SELL Albino Quechua Mammoth Meat (Quechua @ 195.41 Ly)
  SELL Utgaroar Millennial Eggs (Utgaroar @ 183.62 Ly)
  SELL Witchhaul Kobe Beef (Witchhaul @ 188.54 Ly)
   BUY Leestian Evil Juice x 14 (George Lucas @ 257.0 Ls)
   BUY Azure Milk x 7 (George Lucas @ 257.0 Ls)
  NEXT Diso (2.57 Ly)
Diso
  SELL Onion Head (Kappa Fornacis @ 160.21 Ly)
   BUY Diso Ma Corn x 15 (Shifnalport @ 284.0 Ls)
  NEXT Lave (3.59 Ly)
Lave
   BUY Lavian Brandy x 7 (Lave Station @ 302.0 Ls)
  NEXT Orrere (9.15 Ly)
Orrere
   BUY Orrerian Vicious Brew x 16 (Sharon Lee Free Market @ 963.0 Ls)
  NEXT Shinrarta Dezhra (60.02 Ly)
Shinrarta Dezhra
   BUY Waters of Shintara x 5 (Jameson Memorial @ 347.0 Ls)
  NEXT George Pantazis (86.25 Ly)
George Pantazis
   BUY Pantaa Prayer Sticks x 13 (Zakam Platform @ 45.0 Ls)
  NEXT Kappa Fornacis (57.02 Ly)
Kappa Fornacis
  SELL Diso Ma Corn (Diso @ 160.21 Ly)
  SELL Lavian Brandy (Lave @ 161.58 Ly)
  SELL Orrerian Vicious Brew (Orrere @ 162.61 Ly)
   BUY Onion Head x 17 (Harvestport @ 918.0 Ls)
  NEXT Quechua (62.84 Ly)
Quechua
  SELL Leestian Evil Juice (Leesti @ 195.41 Ly)
  SELL Azure Milk (Leesti @ 195.41 Ly)
   BUY Albino Quechua Mammoth Meat x 10 (Crown Ring @ 120.0 Ls)
  NEXT Yaso Kondi (88.8 Ly)
Yaso Kondi
  SELL Waters of Shintara (Shinrarta Dezhra @ 202.01 Ly)
  SELL Pantaa Prayer Sticks (George Pantazis @ 161.36 Ly)
  SELL Indi Bourbon (Epsilon Indi @ 167.23 Ly)
  SELL CD-75 Kitten Brand Coffee (CD-75 661 @ 174.68 Ly)
   BUY Yaso Kondi Leaf x 5 (Wheeler Market @ 114.0 Ls)
  NEXT Utgaroar (73.48 Ly)
Utgaroar
   BUY Utgaroar Millennial Eggs x 15 (Fort Klarix @ 171.0 Ls)
  NEXT Witchhaul (79.86 Ly)
Witchhaul
   BUY Witchhaul Kobe Beef x 9 (Hornby Terminal @ 219.0 Ls)
  NEXT Epsilon Indi (86.38 Ly)
Epsilon Indi
  SELL Yaso Kondi Leaf (Yaso Kondi @ 167.23 Ly)
   BUY Indi Bourbon x 11 (Mansfield Orbiter @ 143.0 Ls)
  NEXT CD-75 661 (79.31 Ly)
CD-75 661
   BUY CD-75 Kitten Brand Coffee x 12 (Kirk Dock @ 339.0 Ls)
  NEXT Leesti (72.46 Ly)


============[ BEST ROUTE #7 ]=============

Route #10478 (warnings=0, jumps=13, distance=767.80, 26/12/14 - rev 1358) PERFECT

["Leesti", "Diso", "Lave", "Orrere", "Shinrarta Dezhra", "Altair", "Kappa Fornacis", "Quechua", "Yaso Kondi", "Utgaroar", "Witchhaul", "Epsilon Indi", "CD-75 661"]

Leesti
  SELL Albino Quechua Mammoth Meat (Quechua @ 195.41 Ly)
  SELL Utgaroar Millennial Eggs (Utgaroar @ 183.62 Ly)
  SELL Witchhaul Kobe Beef (Witchhaul @ 188.54 Ly)
   BUY Leestian Evil Juice x 14 (George Lucas @ 257.0 Ls)
   BUY Azure Milk x 7 (George Lucas @ 257.0 Ls)
  NEXT Diso (2.57 Ly)
Diso
  SELL Onion Head (Kappa Fornacis @ 160.21 Ly)
   BUY Diso Ma Corn x 15 (Shifnalport @ 284.0 Ls)
  NEXT Lave (3.59 Ly)
Lave
   BUY Lavian Brandy x 7 (Lave Station @ 302.0 Ls)
  NEXT Orrere (9.15 Ly)
Orrere
   BUY Orrerian Vicious Brew x 16 (Sharon Lee Free Market @ 963.0 Ls)
  NEXT Shinrarta Dezhra (60.02 Ly)
Shinrarta Dezhra
   BUY Waters of Shintara x 5 (Jameson Memorial @ 347.0 Ls)
  NEXT Altair (72.82 Ly)
Altair
   BUY Altairian Skin x 22 (Solo Orbiter @ 661.0 Ls)
  NEXT Kappa Fornacis (76.52 Ly)
Kappa Fornacis
  SELL Diso Ma Corn (Diso @ 160.21 Ly)
  SELL Lavian Brandy (Lave @ 161.58 Ly)
  SELL Orrerian Vicious Brew (Orrere @ 162.61 Ly)
   BUY Onion Head x 17 (Harvestport @ 918.0 Ls)
  NEXT Quechua (62.84 Ly)
Quechua
  SELL Leestian Evil Juice (Leesti @ 195.41 Ly)
  SELL Azure Milk (Leesti @ 195.41 Ly)
   BUY Albino Quechua Mammoth Meat x 10 (Crown Ring @ 120.0 Ls)
  NEXT Yaso Kondi (88.8 Ly)
Yaso Kondi
  SELL Waters of Shintara (Shinrarta Dezhra @ 202.01 Ly)
  SELL Altairian Skin (Altair @ 174.42 Ly)
  SELL Indi Bourbon (Epsilon Indi @ 167.23 Ly)
  SELL CD-75 Kitten Brand Coffee (CD-75 661 @ 174.68 Ly)
   BUY Yaso Kondi Leaf x 5 (Wheeler Market @ 114.0 Ls)
  NEXT Utgaroar (73.48 Ly)
Utgaroar
   BUY Utgaroar Millennial Eggs x 15 (Fort Klarix @ 171.0 Ls)
  NEXT Witchhaul (79.86 Ly)
Witchhaul
   BUY Witchhaul Kobe Beef x 9 (Hornby Terminal @ 219.0 Ls)
  NEXT Epsilon Indi (86.38 Ly)
Epsilon Indi
  SELL Yaso Kondi Leaf (Yaso Kondi @ 167.23 Ly)
   BUY Indi Bourbon x 11 (Mansfield Orbiter @ 143.0 Ls)
  NEXT CD-75 661 (79.31 Ly)
CD-75 661
   BUY CD-75 Kitten Brand Coffee x 12 (Kirk Dock @ 339.0 Ls)
  NEXT Leesti (72.46 Ly)


============[ BEST ROUTE #8 ]=============

Route #5757 (warnings=1, jumps=12, distance=623.14, 26/12/14 - rev 1358)

["Leesti", "Diso", "Lave", "Orrere", "Zaonce", "Any Na", "Neritus", "39 Tauri", "Bast", "Esuseku", "Eranin", "Shinrarta Dezhra"]

[Warn] suboptimal sell distance: Eranin -> Any Na (154.11 Ly)

Leesti
   BUY Leestian Evil Juice x 14 (George Lucas @ 257.0 Ls)
   BUY Azure Milk x 7 (George Lucas @ 257.0 Ls)
  NEXT Diso (2.57 Ly)
Diso
  SELL Tauri Chimes (39 Tauri @ 160.87 Ly)
   BUY Diso Ma Corn x 15 (Shifnalport @ 284.0 Ls)
  NEXT Lave (3.59 Ly)
Lave
   BUY Lavian Brandy x 7 (Lave Station @ 302.0 Ls)
  NEXT Orrere (9.15 Ly)
Orrere
   BUY Orrerian Vicious Brew x 16 (Sharon Lee Free Market @ 963.0 Ls)
  NEXT Zaonce (14.07 Ly)
Zaonce
  SELL Bast Snake Gin (Bast @ 160.18 Ly)
   BUY Leathery Eggs x 1 (Ridley Scott @ 400.0 Ls)
  NEXT Any Na (87.21 Ly)
Any Na
  SELL Eranin Whiskey (Eranin @ 154.11 Ly)
   BUY Any Na Coffee x 11 (Libby Orbital @ 581.0 Ls)
  NEXT Neritus (67.55 Ly)
Neritus
   BUY Neritus Berries x 13 (Toll Ring @ 524.0 Ls)
  NEXT 39 Tauri (88.17 Ly)
39 Tauri
  SELL Diso Ma Corn (Diso @ 160.87 Ly)
  SELL Lavian Brandy (Lave @ 162.68 Ly)
  SELL Orrerian Vicious Brew (Orrere @ 163.89 Ly)
  SELL Leathery Eggs (Zaonce @ 164.19 Ly)
   BUY Tauri Chimes x 17 (Porta @ 991.0 Ls)
  NEXT Bast (49.32 Ly)
Bast
  SELL Any Na Coffee (Any Na @ 170.32 Ly)
   BUY Bast Snake Gin x 10 (Hart Station @ 202.0 Ls)
  NEXT Esuseku (73.99 Ly)
Esuseku
  SELL Leestian Evil Juice (Leesti @ 202.36 Ly)
  SELL Azure Milk (Leesti @ 202.36 Ly)
  SELL Neritus Berries (Neritus @ 185.55 Ly)
  SELL Waters of Shintara (Shinrarta Dezhra @ 170.94 Ly)
   BUY Esuseku Caviar x 10 (Savinykh Orbital @ 276.0 Ls)
  NEXT Eranin (87.57 Ly)
Eranin
   BUY Eranin Whiskey x 8 (Azeban City @ 297.0 Ls)
  NEXT Shinrarta Dezhra (85.64 Ly)
Shinrarta Dezhra
  SELL Esuseku Caviar (Esuseku @ 170.94 Ly)
   BUY Waters of Shintara x 5 (Jameson Memorial @ 347.0 Ls)
  NEXT Leesti (54.31 Ly)


============[ BEST ROUTE #9 ]=============

Route #5782 (warnings=1, jumps=12, distance=628.11, 26/12/14 - rev 1358)

["Leesti", "Diso", "Lave", "Orrere", "Zaonce", "Any Na", "Neritus", "39 Tauri", "Hecate", "Esuseku", "Eranin", "Shinrarta Dezhra"]

[Warn] suboptimal sell distance: Eranin -> Any Na (154.11 Ly)

Leesti
  SELL Live Hecate Sea Worms (Hecate @ 186.27 Ly)
   BUY Leestian Evil Juice x 14 (George Lucas @ 257.0 Ls)
   BUY Azure Milk x 7 (George Lucas @ 257.0 Ls)
  NEXT Diso (2.57 Ly)
Diso
  SELL Tauri Chimes (39 Tauri @ 160.87 Ly)
   BUY Diso Ma Corn x 15 (Shifnalport @ 284.0 Ls)
  NEXT Lave (3.59 Ly)
Lave
   BUY Lavian Brandy x 7 (Lave Station @ 302.0 Ls)
  NEXT Orrere (9.15 Ly)
Orrere
   BUY Orrerian Vicious Brew x 16 (Sharon Lee Free Market @ 963.0 Ls)
  NEXT Zaonce (14.07 Ly)
Zaonce
   BUY Leathery Eggs x 1 (Ridley Scott @ 400.0 Ls)
  NEXT Any Na (87.21 Ly)
Any Na
  SELL Eranin Whiskey (Eranin @ 154.11 Ly)
   BUY Any Na Coffee x 11 (Libby Orbital @ 581.0 Ls)
  NEXT Neritus (67.55 Ly)
Neritus
   BUY Neritus Berries x 13 (Toll Ring @ 524.0 Ls)
  NEXT 39 Tauri (88.17 Ly)
39 Tauri
  SELL Diso Ma Corn (Diso @ 160.87 Ly)
  SELL Lavian Brandy (Lave @ 162.68 Ly)
  SELL Orrerian Vicious Brew (Orrere @ 163.89 Ly)
  SELL Leathery Eggs (Zaonce @ 164.19 Ly)
   BUY Tauri Chimes x 17 (Porta @ 991.0 Ls)
  NEXT Hecate (49.37 Ly)
Hecate
  SELL Leestian Evil Juice (Leesti @ 186.27 Ly)
  SELL Azure Milk (Leesti @ 186.27 Ly)
  SELL Any Na Coffee (Any Na @ 192.24 Ly)
   BUY Live Hecate Sea Worms x 13 (RJH1972 @ 570.0 Ls)
  NEXT Esuseku (78.91 Ly)
Esuseku
  SELL Neritus Berries (Neritus @ 185.55 Ly)
  SELL Waters of Shintara (Shinrarta Dezhra @ 170.94 Ly)
   BUY Esuseku Caviar x 10 (Savinykh Orbital @ 276.0 Ls)
  NEXT Eranin (87.57 Ly)
Eranin
   BUY Eranin Whiskey x 8 (Azeban City @ 297.0 Ls)
  NEXT Shinrarta Dezhra (85.64 Ly)
Shinrarta Dezhra
  SELL Esuseku Caviar (Esuseku @ 170.94 Ly)
   BUY Waters of Shintara x 5 (Jameson Memorial @ 347.0 Ls)
  NEXT Leesti (54.31 Ly)


============[ BEST ROUTE #10 ]============

Route #8160 (warnings=1, jumps=12, distance=642.53, 26/12/14 - rev 1358)

["Leesti", "Diso", "Lave", "Orrere", "Shinrarta Dezhra", "Epsilon Indi", "Kappa Fornacis", "Quechua", "Yaso Kondi", "Utgaroar", "Phiagre", "CD-75 661"]

[Warn] suboptimal sell distance: Phiagre -> Lave (136.65 Ly)

Leesti
  SELL Albino Quechua Mammoth Meat (Quechua @ 195.41 Ly)
  SELL Utgaroar Millennial Eggs (Utgaroar @ 183.62 Ly)
   BUY Leestian Evil Juice x 14 (George Lucas @ 257.0 Ls)
   BUY Azure Milk x 7 (George Lucas @ 257.0 Ls)
  NEXT Diso (2.57 Ly)
Diso
  SELL Onion Head (Kappa Fornacis @ 160.21 Ly)
   BUY Diso Ma Corn x 15 (Shifnalport @ 284.0 Ls)
  NEXT Lave (3.59 Ly)
Lave
  SELL Giant Verrix (Phiagre @ 136.65 Ly)
   BUY Lavian Brandy x 7 (Lave Station @ 302.0 Ls)
  NEXT Orrere (9.15 Ly)
Orrere
   BUY Orrerian Vicious Brew x 16 (Sharon Lee Free Market @ 963.0 Ls)
  NEXT Shinrarta Dezhra (60.02 Ly)
Shinrarta Dezhra
   BUY Waters of Shintara x 5 (Jameson Memorial @ 347.0 Ls)
  NEXT Epsilon Indi (62.19 Ly)
Epsilon Indi
   BUY Indi Bourbon x 11 (Mansfield Orbiter @ 143.0 Ls)
  NEXT Kappa Fornacis (65.84 Ly)
Kappa Fornacis
  SELL Diso Ma Corn (Diso @ 160.21 Ly)
  SELL Lavian Brandy (Lave @ 161.58 Ly)
  SELL Orrerian Vicious Brew (Orrere @ 162.61 Ly)
   BUY Onion Head x 17 (Harvestport @ 918.0 Ls)
  NEXT Quechua (62.84 Ly)
Quechua
  SELL Leestian Evil Juice (Leesti @ 195.41 Ly)
  SELL Azure Milk (Leesti @ 195.41 Ly)
   BUY Albino Quechua Mammoth Meat x 10 (Crown Ring @ 120.0 Ls)
  NEXT Yaso Kondi (88.8 Ly)
Yaso Kondi
  SELL Waters of Shintara (Shinrarta Dezhra @ 202.01 Ly)
  SELL Indi Bourbon (Epsilon Indi @ 167.23 Ly)
  SELL CD-75 Kitten Brand Coffee (CD-75 661 @ 174.68 Ly)
   BUY Yaso Kondi Leaf x 5 (Wheeler Market @ 114.0 Ls)
  NEXT Utgaroar (73.48 Ly)
Utgaroar
   BUY Utgaroar Millennial Eggs x 15 (Fort Klarix @ 171.0 Ls)
  NEXT Phiagre (75.74 Ly)
Phiagre
   BUY Giant Verrix x 6 (Greeboski's Outpost @ 8.5 Ls)
  NEXT CD-75 661 (65.85 Ly)
CD-75 661
  SELL Yaso Kondi Leaf (Yaso Kondi @ 174.68 Ly)
   BUY CD-75 Kitten Brand Coffee x 12 (Kirk Dock @ 339.0 Ls)
  NEXT Leesti (72.46 Ly)
```
