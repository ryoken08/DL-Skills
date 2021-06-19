--One-Card Wonder
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
function s.IsSetCardListed(c,...)
	if not c.listed_series then return false end
	local setcodes={...}
	for _,setcode in ipairs(setcodes) do
		if type(c.listed_series)=='table' then
			for _,v in ipairs(c.listed_series) do
				if v==setcode then return true end
			end
		else
			if c.listed_series==setcode then return true end
		end
	end
	return false
end
function s.exfilter(c)
	return (c:IsType(TYPE_MONSTER) and not c:IsSetCard(0xb)) and not s.IsSetCardListed(c,0xb)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return not Duel.IsExistingMatchingCard(s.exfilter,tp,LOCATION_DECK,0,1,nil)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
		Duel.Hint(HINT_CARD,tp,id)
		Debug.SetPlayerInfo(tp,Duel.GetLP(tp),1,2)
	end
	e:SetLabel(1)
end
