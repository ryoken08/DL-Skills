--Fusioning Maestra
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
s.listed_names={62895219,79531196,84988419}
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
		Duel.Hint(HINT_CARD,tp,id)
		local token=Duel.CreateToken(tp,62895219)
		Duel.SendtoDeck(token,nil,SEQ_DECKSHUFFLE,REASON_RULE)
		local token2=Duel.CreateToken(tp,79531196)
		Duel.SendtoDeck(token2,nil,SEQ_DECKSHUFFLE,REASON_RULE)
		Duel.BreakEffect()
		local token3=Duel.CreateToken(tp,84988419)
		Duel.SendtoDeck(token3,nil,SEQ_DECKTOP,REASON_RULE)
		Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
	end
	e:SetLabel(1)
end
s.filter=aux.FilterFaceupFunction(Card.IsType,TYPE_FUSION)
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,79531196)
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_REMOVED,0,1,nil)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--Return all of your banished Fusion Monsters to your Extra Deck
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_REMOVED,0,nil)
	Duel.SendtoDeck(g,nil,0,REASON_RULE)
end
