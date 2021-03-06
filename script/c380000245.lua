--Cubic Seeds
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
s.listed_names={CARD_VIJAM}
s.listed_series={0xe3}
function s.filter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsSetCard(0xe3)
end
function s.exfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsSetCard(0xe3)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return not Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil)
	   and not Duel.IsExistingMatchingCard(s.exfilter,tp,LOCATION_DECK,0,7,nil)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
		Duel.Hint(HINT_CARD,tp,id)
		for i=1,3 do
			local token=Duel.CreateToken(tp,CARD_VIJAM)
			Duel.SendtoDeck(token,nil,SEQ_DECKSHUFFLE,REASON_RULE)
		end
	end
	e:SetLabel(1)
end
