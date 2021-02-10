--No Mortal Can Resist
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
s.listed_names={CARD_SKULL_SERVANT}
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and (Duel.GetLP(1-tp)-Duel.GetLP(tp))>=2000
	and Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_GRAVE,1,nil)
end
function s.filter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsOriginalCodeRule(CARD_SKULL_SERVANT)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	local g=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_GRAVE,nil)
	for tc in aux.Next(g) do
		Duel.SendtoDeck(tc,tp,-2,REASON_RULE)
		local token=Duel.CreateToken(1-tp,CARD_SKULL_SERVANT)
		Duel.SendtoGrave(token,REASON_RULE)
	end
end
