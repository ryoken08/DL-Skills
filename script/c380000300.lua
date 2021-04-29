--Onomatoplay
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop,1)
end
s.listed_series={0x54,0x59,0x82,0x8f}
function s.filter1(c,tp)
	return (c:IsSetCard(0x54) or c:IsSetCard(0x59) or c:IsSetCard(0x82) or c:IsSetCard(0x8f))
	and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function s.filter2(c,code)
	return (c:IsSetCard(0x54) or c:IsSetCard(0x59) or c:IsSetCard(0x82) or c:IsSetCard(0x8f)) and c:IsType(TYPE_MONSTER) and not c:IsCode(code)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--twice per duel check
	if Duel.GetFlagEffect(ep,id)>1 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_HAND,0,1,nil,tp)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--Return 1 Zubaba, Gagaga, Gogogo, or Dododo card to the deck
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_HAND,0,1,1,nil,tp)
	local g1=g:GetFirst()
	if g1 then
		Duel.ConfirmCards(1-tp,g1)
		Duel.SendtoDeck(g1,nil,SEQ_DECKSHUFFLE,REASON_RULE)
	end
	--Add 1 Zubaba, Gagaga, Gogogo or Dododo monster with a different name to hand
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_DECK,0,1,1,nil,g1:GetCode())
	local tc=sg:GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_RULE)
		Duel.ConfirmCards(1-tp,tc)
	end
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
