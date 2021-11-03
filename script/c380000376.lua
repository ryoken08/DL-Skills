--Malicious HERO
local s,id=GetID()
function s.initial_effect(c)
	--skill
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetCountLimit(1)
	e1:SetRange(0x5f)
	e1:SetLabel(0)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_names={58554959,86676862,94820406,72043279}
s.listed_series={0x6008}
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	for i=1,2 do
		local token=Duel.CreateToken(tp,58554959)
		Duel.SendtoDeck(token,nil,SEQ_DECKSHUFFLE,REASON_RULE)
	end
	local token2=Duel.CreateToken(tp,94820406)
	Duel.SendtoDeck(token2,nil,SEQ_DECKSHUFFLE,REASON_RULE)
	Duel.BreakEffect()
	local token3=Duel.CreateToken(tp,86676862)
	Duel.SendtoDeck(token3,nil,SEQ_DECKTOP,REASON_RULE)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
function s.thfilter(c)
	return c:IsMonster() and c:IsRace(RACE_FIEND) and (c:IsLevel(6) or c:IsSetCard(0x6008))
end
function s.filter(c)
	return c:HasLevel() and c:IsMonster() and c:IsRace(RACE_FIEND)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	local b1=(Duel.GetFlagEffect(ep,id)==0 and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND,0,1,nil,58554959) and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,58554959))
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_HAND,0,nil)
	local b2=(Duel.GetFlagEffect(ep,id+1)==0 and g:CheckWithSumGreater(Card.GetLevel,7,1,99)
		and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,58554959))
	--condition
	return aux.CanActivateSkill(tp) and (b1 or b2)
	and Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsCode,72043279),tp,LOCATION_ONFIELD,0,1,nil)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	local b1=(Duel.GetFlagEffect(ep,id)==0 and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND,0,1,nil,58554959) and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_HAND,0,1,nil,58554959))
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_HAND,0,nil)
	local b2=(Duel.GetFlagEffect(ep,id+1)==0 and g:CheckWithSumGreater(Card.GetLevel,7,1,99)
		and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,58554959))
	local op=aux.SelectEffect(tp,
	{b1,aux.Stringid(id,1)},
	{b2,aux.Stringid(id,2)})
	if op==1 then
		--opd register
		Duel.RegisterFlagEffect(ep,id,0,0,0)
		--Return 1 "Evil HERO Malicious Edge" in your hand to your Deck
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_HAND,0,1,1,nil,58554959)
		local g1=g:GetFirst()
		if g1 then
			Duel.ConfirmCards(1-tp,g1)
			Duel.SendtoDeck(g1,nil,SEQ_DECKSHUFFLE,REASON_RULE)
		end
		--Add 1 Level 6 Fiend-Type monster or "Evil HERO" monster to your hand from your Deck
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		local tc=sg:GetFirst()
		if tc then
			Duel.SendtoHand(tc,nil,REASON_RULE)
			Duel.ConfirmCards(1-tp,tc)
		end
	else
		--opd register
		Duel.RegisterFlagEffect(ep,id+1,0,0,0)
		--Return 1 or more Fiend-Type monster(s) whose total Levels equal 7 or more to your Deck from your hand
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:SelectWithSumGreater(tp,Card.GetLevel,7,1,99)
		if sg and #sg>0 then
			Duel.ConfirmCards(1-tp,sg)
			Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_RULE)
		end
		--Add 1 "Evil HERO Malicious Edge" to your hand from your Deck
		local tc=Duel.GetFirstMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,nil,58554959)
		if tc then
			Duel.SendtoHand(tc,nil,REASON_RULE)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
