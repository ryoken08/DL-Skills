--Arcana Swap
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	aux.AddPreDrawSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
s.listed_series={0x5}
function s.filter(c)
	return c:IsSetCard(0x5) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return Duel.GetCurrentChain()==0 and Duel.GetTurnCount()==1
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND,0,1,nil)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	--ask if you want to activate the skill or not
	if not Duel.SelectYesNo(tp,aux.Stringid(id,0)) then return end
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--shuffle
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND,0,1,63,nil)
	if #g>0 then
		Duel.ConfirmCards(1-tp,g)
		local ct=Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_RULE)
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,ct,REASON_RULE)
	end
end
