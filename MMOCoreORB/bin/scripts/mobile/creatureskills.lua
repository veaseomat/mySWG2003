--This is the Skill trees for NPC's
--to modify this for hybrids you can create a name for your hybrid tree and insert it at the bottom of the list
--in the Server Administrator NPC Skill section
-- command usage inside npc templates is attacks = merge(skilltreename1,skilltreename2,ect,ect)

--creature level 1 to 10
brawlernovice = { {"intimidationattack",""}, {"posturedownattack",""} }
marksmannovice = {  }

--creature level 11 to 15
brawlermid = { {"intimidationattack",""}, {"posturedownattack",""}, {"stunattack",""} }
marksmanmid = {  }

--creature level 16 to 20
marksmanmaster = { {"posturedownattack",""} }
brawlermaster = { {"intimidationattack",""}, {"posturedownattack",""}, {"stunattack",""}, {"blindattack",""}, {"dizzyattack",""} }

--creature level 21 to 25 use base profession master with these depending on weapons in thier weapons groups
bountyhunternovice = { {"intimidationattack",""}, {"posturedownattack",""} }
commandonovice = { {"intimidationattack",""} }
carbineernovice = { {"posturedownattack",""} }
pistoleernovice = { {"posturedownattack",""} }
riflemannovice = { {"posturedownattack",""}, {"stunattack",""}, {"dizzyattack",""} }
fencernovice = { {"intimidationattack",""}, {"posturedownattack",""} }
swordsmannovice = { {"intimidationattack",""}, {"posturedownattack",""} }
pikemannovice = { {"intimidationattack",""}, {"posturedownattack",""}, {"stunattack",""} }
tkanovice = { {"intimidationattack",""}, {"posturedownattack",""}, {"stunattack",""}, {"knockdownattack",""} }

--creature level 26 to 30 use base profession master with these depending on weapons in their weapons groups
bountyhuntermid = { {"intimidationattack",""}, {"posturedownattack",""}, {"knockdownattack",""} }
commandomid = { }
carbineermid = { {"posturedownattack",""}, {"knockdownattack",""} }
pistoleermid = { {"posturedownattack",""} }
riflemanmid = { {"posturedownattack",""}, {"stunattack",""}, {"dizzyattack",""} }
fencermid = { {"intimidationattack",""}, {"posturedownattack",""} }
swordsmanmid = { {"intimidationattack",""}, {"posturedownattack",""} }
pikemanmid = { {"intimidationattack",""}, {"posturedownattack",""}, {"stunattack",""} }
tkamid = { {"intimidationattack",""}, {"posturedownattack",""}, {"stunattack",""}, {"blindattack",""}, {"knockdownattack",""} }

--creature level 31 and above use combinations of base profesion mastery and these
bountyhuntermaster = { {"intimidationattack",""}, {"posturedownattack",""}, {"knockdownattack",""} }
commandomaster = { }
carbineermaster = { {"posturedownattack",""}, {"knockdownattack",""} }
pistoleermaster = { {"posturedownattack",""} }
riflemanmaster = { {"posturedownattack",""}, {"stunattack",""}, {"dizzyattack",""} }
fencermaster = { {"intimidationattack",""}, {"posturedownattack",""} }
swordsmanmaster = { {"intimidationattack",""}, {"posturedownattack",""} }
pikemanmaster = { {"intimidationattack",""}, {"posturedownattack",""}, {"stunattack",""} }
tkamaster = { {"intimidationattack",""}, {"posturedownattack",""}, {"stunattack",""}, {"dizzyattack",""}, {"blindattack",""}, {"knockdownattack",""} }

--npc jedi skills
lightsabermaster = { {"intimidationattack",""}, {"posturedownattack",""}, {"stunattack",""}, {"dizzyattack",""}, {"blindattack",""}, {"knockdownattack",""} }--{"intimidationattack",""}, {"posturedownattack",""}, {"stunattack",""}, {"blindattack",""}, {"dizzyattack",""} }
forcepowermaster = { {"intimidationattack",""}, {"posturedownattack",""}, {"stunattack",""}, {"dizzyattack",""}, {"blindattack",""}, {"knockdownattack",""} }--{"forcelightningsingle2",""},{"mindblast2",""},{"forceknockdown2",""}, {"forcethrow2",""} }

-- npc force wielders use standard profession mastery with the addition of this command
forcewielder ={ {"intimidationattack",""}, {"posturedownattack",""}, {"stunattack",""}, {"dizzyattack",""}, {"blindattack",""}, {"knockdownattack",""} }--{"forcelightningsingle1",""},{"mindblast1",""},{"forceknockdown1",""},  {"forcethrow1",""} }
--Server Administrator NPC skill trees place below
