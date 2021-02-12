--Duel Fuel
local s,id=GetID()
function s.initial_effect(c)
	--skill
	aux.AddPreDrawSkillProcedure(c,1,false,s.checkcon,s.checkop)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop,1)
end
function s.checkcon(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return Duel.GetCurrentChain()==0 and Duel.GetLP(tp)<Duel.GetLP(1-tp)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(id,RESET_PHASE+PHASE_END,0,2)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--twice per duel check
	if Duel.GetFlagEffect(ep,id)>1 then return end
	--condition
	local c=e:GetHandler()
	return aux.CanActivateSkill(tp)
	and c:GetFlagEffect(id)>0
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	local lp=Duel.GetLP(tp)+1000
	Duel.SetLP(tp, lp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
