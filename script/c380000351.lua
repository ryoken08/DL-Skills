--Dice Recovery
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop,1)
end
s.roll_dice=true
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	local d=Duel.TossDice(tp,1)
	local ct=d*200
	local lp=Duel.GetLP(tp)+ct
	Duel.SetLP(tp, lp)
	--cannot use this Skill again the rest of the Duel if you get 2, 3, 4, or 5
	if d==1 or d==6 then
		Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
	else
		--opd register
		Duel.RegisterFlagEffect(ep,id,0,0,0)
	end
end
