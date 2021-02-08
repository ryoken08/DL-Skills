--Smile bright!
local s,id=GetID()
function s.initial_effect(c)
	--skill
	aux.AddPreDrawSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return Duel.GetCurrentChain()==0
	and Duel.GetTurnPlayer()==tp
	and Duel.GetLP(1-tp)>1000
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--activate
	local lp=Duel.GetLP(1-tp)-50
	Duel.SetLP(1-tp, lp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
