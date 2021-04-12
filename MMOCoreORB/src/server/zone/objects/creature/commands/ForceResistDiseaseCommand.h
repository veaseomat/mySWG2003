/*
				Copyright <SWGEmu>
		See file COPYING for copying conditions.*/

#ifndef FORCERESISTDISEASECOMMAND_H_
#define FORCERESISTDISEASECOMMAND_H_

class ForceResistDiseaseCommand : public JediQueueCommand {
public:

	ForceResistDiseaseCommand(const String& name, ZoneProcessServer* server)
		: JediQueueCommand(name, server) {
//
//		buffCRC = BuffCRC::JEDI_RESIST_DISEASE;
//
//		skillMods.put("resistance_disease", 25);
//		skillMods.put("absorption_disease", 25);

	}

	int doQueueCommand(CreatureObject* creature, const uint64& target, const UnicodeString& arguments) const {
//		return doJediSelfBuffCommand(creature);
		creature->sendSystemMessage("This skill has been removed."); //"You do not have enough Force Power to peform that action.
		return GENERALERROR;
	}

};

#endif //FORCERESISTDISEASECOMMAND_H_
