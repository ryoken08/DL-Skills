--Scorns of Ultimate Defeat
local s,id=GetID()
function s.initial_effect(c)
	--skill
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
s.listed_names={55410871,21082832}
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.GetTurnCount()>=6
end
function s.filter(c)
	return c:IsFaceup() and c:IsDefenseAbove(3500)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	local token=Duel.CreateToken(tp,55410871)
	Duel.SendtoDeck(token,nil,SEQ_DECKTOP,REASON_RULE)
	local g=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_MZONE,nil)
	if #g>0 then
		local token1=Duel.CreateToken(tp,21082832)
		Duel.SendtoHand(token1,nil,REASON_RULE)
	end
end
