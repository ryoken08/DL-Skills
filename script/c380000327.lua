--Final Mission
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
s.listed_names={66436257}
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	local num=5
	if Duel.GetLP(tp)>1000 then
		num=Duel.GetRandomNumber(1,10)
	else
		num=1
	end
	if num<5 then
		local token=Duel.CreateToken(tp,66436257)
		Duel.SendtoGrave(token,REASON_RULE)
	end
end
