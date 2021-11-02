--Clock of Destiny
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
s.listed_names={75041269}
s.listed_series={0xc008,0x3008}
function s.exfilter(c)
	return c:IsMonster() and c:IsSetCard(0xc008)
end
function s.exfilter2(c)
	return c:IsMonster() and not (c:IsSetCard(0xc008) or c:IsSetCard(0x3008))
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return Duel.IsExistingMatchingCard(s.exfilter,tp,LOCATION_DECK,0,8,nil)
	and not Duel.IsExistingMatchingCard(s.exfilter2,tp,LOCATION_DECK,0,1,nil)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetCondition(s.flipcon)
		e1:SetOperation(s.flipop)
		Duel.RegisterEffect(e1,tp)
	end
	e:SetLabel(1)
end
function s.tgfilter(c)
	return c:IsMonster() and c:IsSetCard(0xc008) and c:IsLevelBelow(4)
end
s.filter=aux.FilterFaceupFunction(Card.IsCode,75041269)
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--condition
	local b1=(Duel.GetFlagEffect(ep,id)==0 and Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,75041269))
	local b2=(Duel.GetFlagEffect(ep,id+1)==0 and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_FZONE,0,1,nil))
	return aux.CanActivateSkill(tp) and (b1 or b2)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	local b1=(Duel.GetFlagEffect(ep,id)==0 and Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,75041269))
	local b2=(Duel.GetFlagEffect(ep,id+1)==0 and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_FZONE,0,1,nil))
	local op=aux.SelectEffect(tp,
	{b1,aux.Stringid(id,1)},
	{b2,aux.Stringid(id,2)})
	if op==1 then
		--opd register
		Duel.RegisterFlagEffect(ep,id,0,0,0)
		--Send 1 Level 4 or lower "Destiny HERO" monster in your hand to the Graveyard
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_HAND,0,1,1,nil)
		local tg=g:GetFirst()
		if tg then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
			e1:SetReset(RESET_CHAIN)
			tg:RegisterEffect(e1)
			Duel.SendtoGrave(tg,REASON_RULE)
		end
		--Add 1 "Clock Tower Prison" from your Deck to your hand
		local tc=Duel.GetFirstMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,nil,75041269)
		if tc then
			Duel.BreakEffect()
			Duel.SendtoHand(tc,nil,REASON_RULE)
			Duel.ConfirmCards(1-tp,tc)
		end
	else
		--opd register
		Duel.RegisterFlagEffect(ep,id+1,0,0,0)
		--Select 1 "Clock Tower Prison" in your Field Zone
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
		local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_FZONE,0,1,1,nil)
		Duel.HintSelection(g)
		--Place 3 Clock Counters on it
		local tc=g:GetFirst()
		tc:AddCounter(0x1b,3)
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,Duel.GetTurnCount())
		if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,5318639) and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			--Add "Mystical Space Typhoon" to your hand from your Deck
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_DECK,0,1,1,nil,5318639)
			if #sg>0 then
				Duel.BreakEffect()
				Duel.SendtoHand(sg,nil,REASON_RULE)
				Duel.ConfirmCards(1-tp,sg)
			end
		end
		--Return the "Clock Tower Prison" to your Deck at the end of your next turn
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetLabelObject(tc)
		e1:SetCondition(s.tdcon)
		e1:SetOperation(s.tdop)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		e1:SetCountLimit(1)
		Duel.RegisterEffect(e1,tp)
	end
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return Duel.GetTurnCount()~=e:GetLabel() and Duel.GetTurnPlayer()==tp and tc:GetFlagEffectLabel(id)==e:GetLabel()
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_RULE)
end
