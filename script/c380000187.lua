--Dino DNA!
local s,id=GetID()
function s.initial_effect(c)
	--skill
	aux.AddPreDrawSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return Duel.GetCurrentChain()==0
	and Duel.GetTurnPlayer()==tp
	and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--activate
	local lp=Duel.GetLP(tp)+200
	Duel.SetLP(tp, lp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
