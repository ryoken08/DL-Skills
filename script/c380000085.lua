--Where the Heroes Dwell
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.GetLP(tp)<=3000
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	local g=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	if g then
		Duel.SendtoHand(g,nil,REASON_RULE)
	end
	local token=Duel.CreateToken(tp,63035430)   
	Duel.MoveToField(token,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
end
