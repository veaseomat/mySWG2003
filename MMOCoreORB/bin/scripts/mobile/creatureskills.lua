--This is the Skill trees for NPC's
--to modify this for hybrids you can create a name for your hybrid tree and insert it at the bottom of the list
--in the Server Administrator NPC Skill section
-- command usage inside npc templates is attacks = merge(skilltreename1,skilltreename2,ect,ect)

--creature level 1 to 10
brawlernovice = { {"intimidationattack",""}, {"posturedownattack",""} }
marksmannovice = { {"creatureareaattack",""} }

--creature level 11 to 15
brawlermid = { {"intimidationattack",""}, {"posturedownattack",""}, {"stunattack",""} }
marksmanmid = { {"creatureareaattack",""} }

--creature level 16 to 20
marksmanmaster = { {"posturedownattack",""}, {"creatureareaattack",""} }
brawlermaster = { {"intimidationattack",""}, {"posturedownattack",""}, {"stunattack",""}, {"blindattack",""}, {"dizzyattack",""} }

--creature level 21 to 25 use base profession master with these depending on weapons in thier weapons groups
bountyhunternovice = { {"intimidationattack",""}, {"posturedownattack",""} }
commandonovice = { {"intimidationattack",""} }
carbineernovice = { {"posturedownattack",""} }
pistoleernovice = { {"posturedownattack",""} }
riflemannovice = { {"posturedownattack",""}, {"stunattack",""}, {"dizzyattack",""}, {"creatureareaattack",""} }
fencernovice = { {"intimidationattack",""}, {"posturedownattack",""} }
swordsmannovice = { {"intimidationattack",""}, {"posturedownattack",""}, {"creatureareaattack",""} }
pikemannovice = { {"intimidationattack",""}, {"posturedownattack",""}, {"stunattack",""}, {"creatureareaattack",""} }
tkanovice = { {"intimidationattack",""}, {"posturedownattack",""}, {"stunattack",""}, {"knockdownattack",""}, {"creatureareaattack",""} }

--creature level 26 to 30 use base profession master with these depending on weapons in their weapons groups
bountyhuntermid = { {"intimidationattack",""}, {"posturedownattack",""}, {"knockdownattack",""} }
commandomid = { }
carbineermid = { {"posturedownattack",""}, {"knockdownattack",""}, {"creatureareaattack",""} }
pistoleermid = { {"posturedownattack",""}, {"creatureareaattack",""} }
riflemanmid = { {"posturedownattack",""}, {"stunattack",""}, {"dizzyattack",""}, {"creatureareaattack",""} }
fencermid = { {"intimidationattack",""}, {"posturedownattack",""}, {"creatureareaattack",""} }
swordsmanmid = { {"intimidationattack",""}, {"posturedownattack",""}, {"creatureareaattack",""} }
pikemanmid = { {"intimidationattack",""}, {"posturedownattack",""}, {"stunattack",""}, {"creatureareaattack",""} }
tkamid = { {"intimidationattack",""}, {"posturedownattack",""}, {"stunattack",""}, {"blindattack",""}, {"knockdownattack",""} }

--creature level 31 and above use combinations of base profesion mastery and these
bountyhuntermaster = { {"intimidationattack",""}, {"posturedownattack",""}, {"knockdownattack",""} }
commandomaster = { }
carbineermaster = { {"posturedownattack",""}, {"knockdownattack",""}, {"creatureareaattack",""} }
pistoleermaster = { {"posturedownattack",""}, {"creatureareaattack",""} }
riflemanmaster = { {"posturedownattack",""}, {"stunattack",""}, {"dizzyattack",""}, {"creatureareaattack",""} }
fencermaster = { {"intimidationattack",""}, {"posturedownattack",""}, {"creatureareaattack",""} }
swordsmanmaster = { {"intimidationattack",""}, {"posturedownattack",""}, {"creatureareaattack",""} }
pikemanmaster = { {"intimidationattack",""}, {"posturedownattack",""}, {"stunattack",""}, {"creatureareaattack",""} }
tkamaster = { {"intimidationattack",""}, {"posturedownattack",""}, {"stunattack",""}, {"dizzyattack",""}, {"blindattack",""}, {"knockdownattack",""} }

--npc jedi skills
lightsabermaster = { {"intimidationattack",""}, {"posturedownattack",""}, {"stunattack",""}, {"dizzyattack",""}, {"blindattack",""}, {"knockdownattack",""} }--{"intimidationattack",""}, {"posturedownattack",""}, {"stunattack",""}, {"blindattack",""}, {"dizzyattack",""} }
forcepowermaster = { {"intimidationattack",""}, {"posturedownattack",""}, {"stunattack",""}, {"dizzyattack",""}, {"blindattack",""}, {"knockdownattack",""} }--{"forcelightningsingle2",""},{"mindblast2",""},{"forceknockdown2",""}, {"forcethrow2",""} }

-- npc force wielders use standard profession mastery with the addition of this command
forcewielder ={ {"intimidationattack",""}, {"posturedownattack",""}, {"stunattack",""}, {"dizzyattack",""}, {"blindattack",""}, {"knockdownattack",""} }--{"forcelightningsingle1",""},{"mindblast1",""},{"forceknockdown1",""},  {"forcethrow1",""} }
--Server Administrator NPC skill trees place below
