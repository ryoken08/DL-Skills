--Determination to Fight
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
s.listed_names={58330108,71525232,73665146,1995985}
s.listed_series={0x51,0xe7,0xe8,0xf5}
function s.exfilter(c)
	return c:IsMonster() and (c:IsSetCard(0x51) or c:IsSetCard(0xe7) or c:IsSetCard(0xe8))
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return Duel.IsExistingMatchingCard(s.exfilter,tp,LOCATION_DECK,0,10,nil)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		--skill
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
function s.thfilter(c)
	return c:IsMonster() and c:IsSetCard(0xf5)
end
function s.tgfilter(c)
	return c:IsMonster() and c:IsSetCard(0x51)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--three times per duel check
	if Duel.GetFlagEffect(ep,id)>2 then return end
	--condition
	local b1=(Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil))
	local b2=(Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1)
	return aux.CanActivateSkill(tp) and (b1 or b2)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--flag register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	local b1=(Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil))
	local b2=(Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_MZONE,0,1,nil))
	local op=aux.SelectEffect(tp,
	{b1,aux.Stringid(id,1)},
	{b2,aux.Stringid(id,2)})
	if op==1 then
		--return 1 card from your hand to your Deck
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
		if #sg>0 then
			Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_RULE)
		end
		--add 1 "Gandora" monster from your Deck to your hand
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.SendtoHand(tc,nil,REASON_RULE)
			Duel.ConfirmCards(1-tp,tc)
		end
		--Extra Normal Summon
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(id,0))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
		e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xf5))
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	else
		--Send 1 "Gadget" monster from your field to the Graveyard
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_GRAVE)
			e1:SetReset(RESET_CHAIN)
			tc:RegisterEffect(e1)
			tc:ResetEffect(RESETS_REDIRECT,RESET_EVENT)
			Duel.SendtoGrave(tc,REASON_RULE)
			if tc:IsLocation(LOCATION_REMOVED) then
				Duel.SendtoGrave(tc,REASON_RULE)
			end
		end
		Duel.BreakEffect()
		--play 1 "Silent Magician LV4" or 1 "Silent Swordsman LV3" from outside of your Deck
		local cards={1995985,73665146}
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,3))
		local code=Duel.SelectCardsFromCodes(tp,1,1,nil,false,table.unpack(cards))
		local token=Duel.CreateToken(tp,code)
		if token then
			local e0=Effect.CreateEffect(e:GetHandler())
			e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e0:SetCode(EVENT_FREE_CHAIN)
			e0:SetOperation(function () Duel.SetChainLimitTillChainEnd(aux.FALSE) end)
			token:RegisterEffect(e0)
			Duel.MoveToField(token,tp,tp,LOCATION_MZONE,POS_FACEUP,true)
			e0:Reset()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
			e1:SetReset(RESET_PHASE+PHASE_END)
			token:RegisterEffect(e1)
		end
	end
	Duel.BreakEffect()
	local cards_gandora={71525232,58330108}
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,3))
	local code=Duel.SelectCardsFromCodes(tp,1,1,nil,false,table.unpack(cards_gandora))
	local token=Duel.CreateToken(tp,code)
	Duel.SendtoGrave(token,REASON_RULE)
	if token:IsLocation(LOCATION_REMOVED) then
		Duel.SendtoGrave(token,REASON_RULE)
	end
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
