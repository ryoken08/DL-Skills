--Gem Dragon Go!
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
	e1:SetCondition(s.flipcon)
	e1:SetOperation(s.flipop)
	c:RegisterEffect(e1)
end
s.listed_names={62397231,17658803,11091375,43096270}
function s.exfilter(c)
	return c:IsCode(62397231,17658803,11091375,43096270)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return Duel.GetMatchingGroup(s.exfilter,tp,LOCATION_DECK,0,nil):GetClassCount(Card.GetCode)>=3
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
		Duel.Hint(HINT_CARD,tp,id)
		local p=c:GetControler()
		local dr=Duel.GetStartingHand(p)
		local g=Duel.GetDecktopGroup(tp,dr)
		local ct=g:FilterCount(Card.IsType,nil,TYPE_NORMAL)
		local num=Duel.GetRandomNumber(1,10)
		if ct==0 and num<10 then
			local g1=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_DECK,0,nil,TYPE_NORMAL):RandomSelect(tp,1)
			local tc=g1:GetFirst()
			Duel.MoveToDeckTop(tc)
		end
	end
	e:SetLabel(1)
end
