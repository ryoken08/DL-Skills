--Malicious HERO
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
s.listed_names={58554959,86676862,94820406}
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	for i=1,2 do
		local token=Duel.CreateToken(tp,58554959)
		Duel.SendtoDeck(token,nil,SEQ_DECKSHUFFLE,REASON_RULE)
	end
	local token2=Duel.CreateToken(tp,94820406)
	Duel.SendtoDeck(token2,nil,SEQ_DECKSHUFFLE,REASON_RULE)
	local token3=Duel.CreateToken(tp,86676862)
	Duel.SendtoDeck(token3,nil,SEQ_DECKTOP,REASON_RULE)
end
