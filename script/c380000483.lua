--Meklord Refinement
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
s.listed_names={2992036}
s.listed_series={0x13}
function s.filter(c)
	return c:IsMonster() and not c:IsSetCard(0x13)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	--condition
	local ct=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_DECK,0,nil,0x13)
	local g=Duel.GetMatchingGroup(aux.NOT(Card.IsType),tp,LOCATION_DECK,0,nil,TYPE_SKILL)
	return (#g-#ct)<=(math.floor(#g/2)) and not Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil)
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
function s.tgfilter(c)
	return c:IsMonster() and c:IsSetCard(0x13)
end
function s.thfilter(c,chck)
	return c:IsSetCard(0x13) and c:IsType(TYPE_SPELL+TYPE_TRAP) and chck<=1
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--twice per duel check
	if Duel.GetFlagEffect(ep,id)>1 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_HAND,0,1,nil)
	and (Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,Duel.GetFlagEffect(ep,id))
	or Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_DECK,0,1,nil,0x13))
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--flag register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--Send 1 "Meklord" monster from your hand to the Graveyard
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	if tc then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_GRAVE)
		e1:SetReset(RESET_CHAIN)
		tc:RegisterEffect(e1)
		Duel.SendtoGrave(tc,REASON_RULE)
		if tc:IsLocation(LOCATION_REMOVED) then
			Duel.SendtoGrave(tc,REASON_RULE)
		end
	end
	if Duel.GetFlagEffect(ep,id)==1 then 
		--add 1 "Meklord" Spell/Trap Card from your Deck to your hand
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,Duel.GetFlagEffect(ep,id))
		local tc=g:GetFirst()
		if tc then
			Duel.BreakEffect()
			Duel.SendtoHand(tc,nil,REASON_RULE)
			Duel.ConfirmCards(1-tp,tc)
		end
	else
		local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_DECK,0,nil,0x13)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			--add 1 "Meklord" card from your Deck to your hand
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_DECK,0,1,1,nil,0x13)
			local tc=sg:GetFirst()
			if tc then
				Duel.BreakEffect()
				Duel.SendtoHand(tc,nil,REASON_RULE)
				Duel.ConfirmCards(1-tp,tc)
			end
		else
			Duel.BreakEffect()
			--add 1 "Meklord Astro the Eradicator" from outside of your Deck to your hand
			local token=Duel.CreateToken(tp,2992036)
			Duel.SendtoHand(token,nil,REASON_RULE)
			Duel.ConfirmCards(1-tp,token)
		end
	end
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end

