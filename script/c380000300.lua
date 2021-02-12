--Onomatoplay
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
s.listed_series={0x54,0x59,0x82,0x8f}
function s.filter1(c)
	return (c:IsSetCard(0x54) or c:IsSetCard(0x59) or c:IsSetCard(0x82) or c:IsSetCard(0x8f))
end
function s.filter2(c)
	return (c:IsSetCard(0x54) or c:IsSetCard(0x59) or c:IsSetCard(0x82) or c:IsSetCard(0x8f)) and c:IsType(TYPE_MONSTER)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	local g=Duel.GetMatchingGroup(s.filter1,tp,LOCATION_HAND,0,nil)
	local sg=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_DECK,0,nil)
	return aux.CanActivateSkill(tp)
	and g:GetClassCount(Card.GetCode)>=2
	and sg:GetClassCount(Card.GetCode)>=2
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--Return 2 Zubaba, Gagaga, Gogogo, or Dododo cards with different names to the deck
	local g=Duel.GetMatchingGroup(s.filter1,tp,LOCATION_HAND,0,nil)
	if g:GetClassCount(Card.GetCode)>=2 then
		local g1=aux.SelectUnselectGroup(g,e,tp,2,2,aux.dncheck,1,tp,HINTMSG_TODECK)
		Duel.ConfirmCards(1-tp,g1)
		Duel.SendtoDeck(g1,nil,SEQ_DECKSHUFFLE,REASON_RULE)
	end
	--Add 2 Zubaba, Gagaga, Gogogo or Dododo monsters with different names to hand
	local sg=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_DECK,0,nil)
	if sg:GetClassCount(Card.GetCode)>=2 then
		local sg1=aux.SelectUnselectGroup(sg,e,tp,2,2,aux.dncheck,1,tp,HINTMSG_ATOHAND)
		Duel.SendtoHand(sg1,nil,REASON_RULE)
		Duel.ConfirmCards(1-tp,sg1)
	end
end
