--Meklord Convert
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	aux.AddSkillProcedure(c,1,false)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetCountLimit(1)
	e1:SetRange(0x5f)
	e1:SetLabel(0)
	e1:SetCondition(s.condition)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_names={63468625}
s.listed_series={0x13}
function s.exfilter(c)
	return c:IsMonster() and not c:IsSetCard(0x13)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return Duel.IsExistingMatchingCard(Card.IsMonster,tp,LOCATION_DECK,0,12,nil)
		and not Duel.IsExistingMatchingCard(s.exfilter,tp,LOCATION_DECK,0,1,nil)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetCountLimit(1)
		e1:SetCondition(s.flipcon)
		e1:SetOperation(s.flipop)
		Duel.RegisterEffect(e1,tp)
	end
	e:SetLabel(1)
end
function s.filter(c)
	return c:IsCode(63468625) and not c:IsPublic()
end
function s.thfilter(c)
	return c:IsMonster() and c:IsSetCard(0x13)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--condition
	local b1=(Duel.GetFlagEffect(ep,id)==0 and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_MZONE,0,2,nil))
	local b2=(Duel.GetFlagEffect(ep,id+1)==0 and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE,0,2,nil) and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,63468625))
	return aux.CanActivateSkill(tp) and (b1 or b2)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	local b1=(Duel.GetFlagEffect(ep,id)==0 and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_MZONE,0,2,nil))
	local b2=(Duel.GetFlagEffect(ep,id+1)==0 and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE,0,2,nil) and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,63468625))
	local op=aux.SelectEffect(tp,
	{b1,aux.Stringid(id,1)},
	{b2,aux.Stringid(id,2)})
	if op==1 then
		--opd register
		Duel.RegisterFlagEffect(ep,id,0,0,0)
		--Reveal 1 "Meklord Astro Mekanikle" in your hand
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND,0,1,1,nil)
		if #g>0 then
			Duel.ConfirmCards(1-tp,g)
		end
		--Return 2 "Meklord" monsters on your field to your hand
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_MZONE,0,2,2,nil)
		if #sg>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
		--Send 1 "Meklord Deflection" to your Graveyard from the outside of your Deck
		local token=Duel.CreateToken(tp,66594927)
		Duel.SendtoGrave(token,REASON_RULE)
		if token:IsLocation(LOCATION_REMOVED) then
			Duel.SendtoGrave(token,REASON_RULE)
		end
	else
		--opd register
		Duel.RegisterFlagEffect(ep,id+1,0,0,0)
		--Return 2 "Meklord" monsters from your Graveyard to your Deck
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_GRAVE,0,2,2,nil)
		if #g>0 then
			Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_RULE)
		end
		local sg=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_DECK,0,nil,63468625)
		if #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			--add 1 "Meklord Astro Mekanikle" to your hand from your Deck
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local tc=sg:Select(tp,1,1,nil)
			if tc then
				Duel.BreakEffect()
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			end
		end
	end
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
