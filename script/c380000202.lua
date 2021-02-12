--Mask Exchange
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop,1)
end
s.listed_names={48948935,22610082}
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--twice per duel check
	if Duel.GetFlagEffect(ep,id)>1 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,48948935)
	and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND,0,1,nil,22610082)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--flag register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	local tc=Duel.GetFirstMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,nil,48948935)
	if tc then
		Duel.SendtoHand(tc,nil,REASON_RULE)
		Duel.ConfirmCards(1-tp,tc)
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_HAND,0,1,1,nil,22610082)
	if #sg>0 then
		Duel.ConfirmCards(1-tp,sg)
		Duel.SendtoDeck(sg,nil,SEQ_DECKBOTTOM,REASON_RULE)
		Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
	end
end
