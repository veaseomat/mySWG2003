/*
				Copyright <SWGEmu>
		See file COPYING for copying conditions.*/

#ifndef FORCERESISTSTATESCOMMAND_H_
#define FORCERESISTSTATESCOMMAND_H_

class ForceResistStatesCommand : public JediQueueCommand {
public:

	ForceResistStatesCommand(const String& name, ZoneProcessServer* server)
		: JediQueueCommand(name, server) {
//
//		buffCRC = BuffCRC::JEDI_RESIST_STATES;
//
//		skillMods.put("resistance_states", 25);

	}

	int doQueueCommand(CreatureObject* creature, const uint64& target, const UnicodeString& arguments) const {
//		return doJediSelfBuffCommand(creature);
		creature->sendSystemMessage("This skill has been removed."); //"You do not have enough Force Power to peform that action.
		return GENERALERROR;
	}

};

#endif //FORCERESISTSTATESCOMMAND_H_
