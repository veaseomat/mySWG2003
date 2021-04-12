/*
				Copyright <SWGEmu>
		See file COPYING for copying conditions.*/

#ifndef FORCEFEEDBACK2COMMAND_H_
#define FORCEFEEDBACK2COMMAND_H_

class ForceFeedback2Command : public JediQueueCommand {
public:

	ForceFeedback2Command(const String& name, ZoneProcessServer* server) : JediQueueCommand(name, server) {
//		buffCRC = BuffCRC::JEDI_FORCE_FEEDBACK_2;
//		overrideableCRCs.add(BuffCRC::JEDI_FORCE_FEEDBACK_1);
//		singleUseEventTypes.add(ObserverEventType::FORCEFEEDBACK);
//		skillMods.put("force_feedback", 95);
	}

	int doQueueCommand(CreatureObject* creature, const uint64& target, const UnicodeString& arguments) const {
//		return doJediSelfBuffCommand(creature);
		creature->sendSystemMessage("This skill has been removed."); //"You do not have enough Force Power to peform that action.
		return GENERALERROR;
	}

};

#endif //FORCEFEEDBACK2COMMAND_H_
