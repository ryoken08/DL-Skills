--Soldier to Lord
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
s.listed_names={39648965,68140974,75733063,31930787,2137678,4545683}
s.listed_series={0x13,0x3013,0x6013}
function s.exfilter(c)
	return c:IsMonster() and not c:IsSetCard(0x13)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return Duel.IsExistingMatchingCard(Card.IsMonster,tp,LOCATION_DECK,0,1,nil)
		and not Duel.IsExistingMatchingCard(s.exfilter,tp,LOCATION_DECK,0,1,nil)
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
s.list={[39648965]=68140974,[75733063]=31930787,[2137678]=4545683}
function s.filter2(c,tcode)
	return c:IsCode(tcode)
end
function s.filter(c,tp)
	local tcode=s.list[c:GetCode()]
	return c:IsFaceup() and c:IsMonster() and c:IsSetCard(0x6013) and tcode and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_HAND,0,1,nil,tcode)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	return aux.CanActivateSkill(tp) and #g==1
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil,tp)
	and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--Send 1 face-up "Meklord Army" monster on your field to your Graveyard
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.HintSelection(g)
	local tc=g:GetFirst()
	if tc then
		local code=tc:GetCode()
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
		--Play 1 "Meklord Emperor" based on the list
		local tcode=s.list[code]
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local sg=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_HAND,0,1,1,nil,tcode)
		if #sg>0 then
			local tc=sg:GetFirst()
			local e0=Effect.CreateEffect(e:GetHandler())
			e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e0:SetCode(EVENT_FREE_CHAIN)
			e0:SetOperation(function () Duel.SetChainLimitTillChainEnd(aux.FALSE) end)
			tc:RegisterEffect(e0)
			Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,POS_FACEUP,true)
			e0:Reset()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
			e1:SetReset(RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
	end
end
