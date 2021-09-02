--Family Gift
local s,id=GetID()
function s.initial_effect(c)
	--skill
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
	Duel.AddCustomActivityCounter(94766498,ACTIVITY_CHAIN,s.chainfilter)
end
s.listed_names={94766498}
s.listed_series={0x70}
function s.chainfilter(re,tp,cid)
	return not (re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsSetCard(0x70))
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.GetCustomActivityCount(94766498,tp,ACTIVITY_CHAIN)>0
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--return 1 card from your hand to your Deck
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
	if #g>0 then
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_RULE)
	end
	--add Chronomaly Aztec Mask Golem to your hand from outside of your Deck
	local token=Duel.CreateToken(tp,94766498)
	Duel.SendtoHand(token,nil,REASON_RULE)
end
