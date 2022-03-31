--Relinquished Puppet
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
s.listed_names={76543119}
s.listed_series={0x83,0x48}
function s.exfilter(c)
	return c:IsType(TYPE_MONSTER) and not (c:IsSetCard(0x83) or (c:IsAttribute(ATTRIBUTE_DARK) and c:IsSetCard(0x48)))
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return not Duel.IsExistingMatchingCard(s.exfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil)
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
	return c:IsLevel(8) and c:IsSetCard(0x83)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil)
	and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--send 1 Level 8 Gimmick Puppet monster in your hand or Deck to your Graveyard
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_GRAVE)
		e1:SetReset(RESET_CHAIN)
		tc:RegisterEffect(e1)
		Duel.SendtoGrave(g,REASON_RULE)
		if tc:IsLocation(LOCATION_REMOVED) then
			Duel.SendtoGrave(g,REASON_RULE)
		end
	end
	Duel.BreakEffect()
	--play 1 Gimmick Puppet Des Troy from outside of your Deck
	local token=Duel.CreateToken(tp,76543119)
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
