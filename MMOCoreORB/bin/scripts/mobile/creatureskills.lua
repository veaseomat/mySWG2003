--This is the Skill trees for NPC's
--to modify this for hybrids you can create a name for your hybrid tree and insert it at the bottom of the list
--in the Server Administrator NPC Skill section
-- command usage inside npc templates is attacks = merge(skilltreename1,skilltreename2,ect,ect)

--creature level 1 to 10
brawlernovice = { {"attack",""}, {"attack",""}, {"intimidationattack",""}, {"posturedownattack",""} }
marksmannovice = {  }

--creature level 11 to 15
brawlermid = { {"attack",""}, {"attack",""}, {"attack",""}, {"intimidationattack",""}, {"posturedownattack",""}, {"stunattack",""} }
marksmanmid = {  }

--creature level 16 to 20
marksmanmaster = { {"attack",""}, {"attack",""}, {"posturedownattack",""} }
brawlermaster = { {"attack",""}, {"attack",""}, {"attack",""}, {"attack",""}, {"intimidationattack",""}, {"posturedownattack",""}, {"stunattack",""}, {"blindattack",""}, {"dizzyattack",""} }

--creature level 21 to 25 use base profession master with these depending on weapons in thier weapons groups
bountyhunternovice = { {"attack",""}, {"attack",""}, {"intimidationattack",""}, {"posturedownattack",""} }
commandonovice = { {"attack",""}, {"attack",""}, {"intimidationattack",""} }
carbineernovice = { {"attack",""}, {"attack",""}, {"posturedownattack",""} }
pistoleernovice = { {"attack",""}, {"attack",""}, {"posturedownattack",""} }
riflemannovice = { {"attack",""}, {"attack",""}, {"posturedownattack",""}, {"stunattack",""}, {"dizzyattack",""} }
fencernovice = { {"attack",""}, {"attack",""}, {"attack",""}, {"intimidationattack",""}, {"posturedownattack",""} }
swordsmannovice = { {"attack",""}, {"attack",""}, {"intimidationattack",""}, {"posturedownattack",""} }
pikemannovice = { {"attack",""}, {"attack",""}, {"attack",""}, {"intimidationattack",""}, {"posturedownattack",""}, {"stunattack",""} }
tkanovice = { {"attack",""}, {"attack",""}, {"attack",""}, {"intimidationattack",""}, {"posturedownattack",""}, {"stunattack",""}, {"knockdownattack",""} }

--creature level 26 to 30 use base profession master with these depending on weapons in their weapons groups
bountyhuntermid = { {"attack",""}, {"intimidationattack",""}, {"posturedownattack",""}, {"knockdownattack",""} }
commandomid = { {"attack",""}, }
carbineermid = { {"attack",""}, {"attack",""}, {"posturedownattack",""}, {"knockdownattack",""} }
pistoleermid = { {"attack",""}, {"attack",""}, {"posturedownattack",""} }
riflemanmid = { {"attack",""}, {"attack",""}, {"posturedownattack",""}, {"stunattack",""}, {"dizzyattack",""} }
fencermid = { {"attack",""}, {"attack",""}, {"intimidationattack",""}, {"posturedownattack",""} }
swordsmanmid = { {"attack",""}, {"attack",""}, {"attack",""}, {"intimidationattack",""}, {"posturedownattack",""} }
pikemanmid = { {"attack",""}, {"attack",""}, {"attack",""}, {"intimidationattack",""}, {"posturedownattack",""}, {"stunattack",""} }
tkamid = { {"attack",""}, {"attack",""}, {"attack",""}, {"attack",""}, {"intimidationattack",""}, {"posturedownattack",""}, {"stunattack",""}, {"blindattack",""}, {"knockdownattack",""} }

--creature level 31 and above use combinations of base profesion mastery and these
bountyhuntermaster = { {"attack",""}, {"intimidationattack",""}, {"posturedownattack",""}, {"knockdownattack",""} }
commandomaster = { }
carbineermaster = { {"attack",""}, {"attack",""}, {"posturedownattack",""}, {"knockdownattack",""} }
pistoleermaster = { {"attack",""}, {"attack",""}, {"posturedownattack",""} }
riflemanmaster = { {"attack",""}, {"attack",""}, {"posturedownattack",""}, {"stunattack",""}, {"dizzyattack",""} }
fencermaster = { {"attack",""}, {"intimidationattack",""}, {"posturedownattack",""} }
swordsmanmaster = { {"attack",""}, {"attack",""}, {"intimidationattack",""}, {"posturedownattack",""} }
pikemanmaster = { {"attack",""}, {"attack",""}, {"intimidationattack",""}, {"posturedownattack",""}, {"stunattack",""} }
tkamaster = { {"attack",""}, {"attack",""}, {"attack",""}, {"intimidationattack",""}, {"posturedownattack",""}, {"stunattack",""}, {"dizzyattack",""}, {"blindattack",""}, {"knockdownattack",""} }

--npc jedi skills
lightsabermaster = { {"attack",""}, {"attack",""}, {"intimidationattack",""}, {"posturedownattack",""}, {"stunattack",""}, {"dizzyattack",""}, {"blindattack",""}, {"knockdownattack",""} }--{"intimidationattack",""}, {"posturedownattack",""}, {"stunattack",""}, {"blindattack",""}, {"dizzyattack",""} }
forcepowermaster = { {"attack",""}, {"attack",""}, {"intimidationattack",""}, {"posturedownattack",""}, {"stunattack",""}, {"dizzyattack",""}, {"blindattack",""}, {"knockdownattack",""} }--{"forcelightningsingle2",""},{"mindblast2",""},{"forceknockdown2",""}, {"forcethrow2",""} }

-- npc force wielders use standard profession mastery with the addition of this command
forcewielder ={ {"attack",""}, {"attack",""}, {"attack",""}, {"attack",""}, {"intimidationattack",""}, {"posturedownattack",""}, {"stunattack",""}, {"dizzyattack",""}, {"blindattack",""}, {"knockdownattack",""} }--{"forcelightningsingle1",""},{"mindblast1",""},{"forceknockdown1",""},  {"forcethrow1",""} }
--Server Administrator NPC skill trees place below
