--The Embodiment of Despair: Meklord Astro Mekanikle
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
s.listed_names={63468625,39648965,75733063,2137678}
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
		Duel.Hint(HINT_CARD,tp,id)
		--add cards from outside of the deck to the deck
		for i=1,4 do
			local token=Duel.CreateToken(tp,s.listed_names[i])
			Duel.SendtoDeck(token,nil,SEQ_DECKSHUFFLE,REASON_RULE)
		end
		Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
	end
	e:SetLabel(1)
end
function s.filter(c)
	return c:IsCode(63468625) and not c:IsPublic()
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND,0,1,nil)
	and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,39648965)
	and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,75733063)
	and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,2137678)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--Reveal 1 "Meklord Astro Mekanikle" in your hand
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND,0,1,1,nil)
	if #g>0 then
		Duel.ConfirmCards(1-tp,g)
	end
	--Return 1 "Meklord Army of Wisel," 1 "Meklord Army of Skiel," and 1 "Meklord Army of Granel" from your Graveyard to your hand
	local g1=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_GRAVE,0,nil,39648965)
	local g2=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_GRAVE,0,nil,75733063)
	local g3=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_GRAVE,0,nil,2137678)
	if #g1>0 and #g2>0 and #g3>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg2=g2:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg3=g3:Select(tp,1,1,nil)
		sg1:Merge(sg3)
		Duel.SendtoHand(sg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg1)
	end
	--Cannot activate cards or effects
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(1)
	Duel.RegisterEffect(e1,tp)
	-- Remove restrictions when you successfully Special Summon "Meklord Astro Mekanikle"
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetLabelObject(e1)
	e0:SetOperation(s.checkop)
	e0:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e0,tp)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local ef=e:GetLabelObject()
	if ef then
		ef:Reset()
		e:Reset()
	end
end
