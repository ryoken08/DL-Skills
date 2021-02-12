--My Name is Yubel
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop,1)
end
s.listed_names={78371393,4779091,31764700}
function s.filter(c)
	return c:IsCode(4779091,31764700)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND,0,1,nil)
	and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,78371393)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND,0,1,1,nil)
	if #g>0 then
		Duel.ConfirmCards(1-tp,g)
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_RULE)
		Duel.BreakEffect()
	end
	local tc=Duel.GetFirstMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,nil,78371393)
	if tc then
		Duel.SendtoHand(tc,nil,REASON_RULE)
		Duel.ConfirmCards(1-tp,tc)
		Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
	end
end
