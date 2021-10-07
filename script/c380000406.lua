--Turning Up the Heat
--Effect is not fully implemented
local s,id=GetID()
function s.initial_effect(c)
	--skill
	aux.AddSkillProcedure(c,1,false)
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
s.listed_names={94415058,20409757,16178681}
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
		Duel.Hint(HINT_CARD,tp,id)
		local token=Duel.CreateToken(tp,94415058)
		Duel.SendtoDeck(token,nil,SEQ_DECKSHUFFLE,REASON_RULE)
		local token2=Duel.CreateToken(tp,20409757)
		Duel.SendtoDeck(token2,nil,SEQ_DECKSHUFFLE,REASON_RULE)
		if Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_DECK,0,nil,16178681)<=2 then
			Duel.BreakEffect()
			local token3=Duel.CreateToken(tp,16178681)
			Duel.SendtoDeck(token3,nil,SEQ_DECKTOP,REASON_RULE)
		end
		Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
	end
	e:SetLabel(1)
end
