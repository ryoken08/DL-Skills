--Red-Eyes Fusion
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
s.listed_names={CARD_REDEYES_B_DRAGON,6172122}
s.listed_series={0x3b}
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil)
	and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,6172122)
	and Duel.GetLP(tp)<=2400
end
function s.filter(c)
	if c:IsLocation(LOCATION_GRAVE) then
		return c:IsCode(CARD_REDEYES_B_DRAGON)
	else
		return c:IsSetCard(0x3b)
	end
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--shuffle 1 "red-eyes" card or 1 red-eyes
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	if g:GetFirst():IsLocation(LOCATION_GRAVE) then
		Duel.HintSelection(g)
	else
		Duel.ConfirmCards(1-tp,g)
	end
	local g1=g:GetFirst()
	if g1 then
		Duel.SendtoDeck(g1,nil,SEQ_DECKSHUFFLE,REASON_RULE)
	end
	--add 1 red-eyes fusion
	local tc=Duel.GetFirstMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,nil,6172122)
	if tc then
		Duel.SendtoHand(tc,nil,REASON_RULE)
		Duel.ConfirmCards(1-tp,tc)
	end
end
