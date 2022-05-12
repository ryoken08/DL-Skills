--Favorite Duel
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
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.counterfilter)
end
s.listed_names={25366484,35809262,45906428,63035430}
s.listed_series={0x3008,0x9,0x1f}
function s.counterfilter(c)
	return not c:IsCode(35809262)
end
function s.filter(c)
	return c:IsMonster() and c:IsType(TYPE_NORMAL) and c:IsSetCard(0x3008)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK,0,nil):GetClassCount(Card.GetCode)>=4
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		--skill
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetCondition(s.flipcon)
		e1:SetOperation(s.flipop)
		Duel.RegisterEffect(e1,tp)
	end
	e:SetLabel(1)
end
function s.tgfilter1(c)
	return c:IsMonster() and (c:IsSetCard(0x3008) or c:IsSetCard(0x1f))
end
function s.tgfilter2(c)
	return c:IsMonster() and ((c:IsSetCard(0x3008) and c:IsType(TYPE_NORMAL)) or c:IsSetCard(0x1f))
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--condition
	local b1=(Duel.GetFlagEffect(ep,id)<3 and Duel.GetFlagEffect(ep,id+1)==0 and Duel.IsExistingMatchingCard(s.tgfilter1,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(s.tgfilter2,tp,LOCATION_DECK,0,1,nil))
	local b2=(Duel.GetFlagEffect(ep,id+2)==0 and Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)>0)
	return aux.CanActivateSkill(tp) and (b1 or b2)
end
function s.tgfilter(c)
	return c:IsMonster() and c:IsSetCard(0x13)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	local b1=(Duel.GetFlagEffect(ep,id)<3 and Duel.GetFlagEffect(ep,id+1)==0 and Duel.IsExistingMatchingCard(s.tgfilter1,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(s.tgfilter2,tp,LOCATION_DECK,0,1,nil))
	local b2=(Duel.GetFlagEffect(ep,id+2)==0 and Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)>0)
	local op=aux.SelectEffect(tp,
	{b1,aux.Stringid(id,1)},
	{b2,aux.Stringid(id,2)})
	if op==1 then
		--flag register
		Duel.RegisterFlagEffect(ep,id,0,0,0)
		--Send 1 "Elemental HERO" monster or 1 "Neo-Spacian" monster from your hand to the Graveyard
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tc=Duel.SelectMatchingCard(tp,s.tgfilter1,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
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
		--Send 1 "Elemental HERO" Normal Monster or 1 "Neo-Spacian" monster from your Deck to the Graveyard
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tc=Duel.SelectMatchingCard(tp,s.tgfilter2,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
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
		--add 1 "Miracle Fusion" to your hand from outside of your Deck
		local token=Duel.CreateToken(tp,45906428)
		Duel.SendtoHand(token,nil,REASON_RULE)
		Duel.ConfirmCards(1-tp,token)
		--opt register
		Duel.RegisterFlagEffect(tp,id+1,RESET_PHASE+PHASE_END,0,1)
	elseif op==2 then
		--opd register
		Duel.RegisterFlagEffect(ep,id+2,0,0,0)
		--Set 1 "Skyscraper" to your field from outside of your Deck
		local token=Duel.CreateToken(tp,63035430)
		Duel.SSet(tp,token)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(id,3))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
function s.splimit(e,c)
	return not (c:IsSetCard(0x9) or c:IsCode(25366484,35809262))
end
