--Recycling Reserve
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	local g=Duel.GetMatchingGroup(Card.IsRace,tp,LOCATION_GRAVE,0,nil,RACE_MACHINE)
	local sg=Duel.GetMatchingGroup(aux.NOT(Card.IsRace),tp,LOCATION_GRAVE,0,nil,RACE_MACHINE)
	return aux.CanActivateSkill(tp)
	and (#g-#sg)>=2 and #sg>0
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	local g=Duel.GetMatchingGroup(aux.NOT(Card.IsRace),tp,LOCATION_GRAVE,0,nil,RACE_MACHINE)
	Duel.SendtoDeck(g,nil,-2,REASON_RULE)
end
