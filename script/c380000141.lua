--Mark of the Dragon - Head
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
s.listed_names={63977008,CARD_STARDUST_DRAGON,24696097,50091196}
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	for i=1,2 do
		local token=Duel.CreateToken(tp,63977008)
		Duel.SendtoDeck(token,nil,SEQ_DECKSHUFFLE,REASON_RULE)
	end
	local token2=Duel.CreateToken(tp,CARD_STARDUST_DRAGON)
	Duel.SendtoDeck(token2,nil,SEQ_DECKTOP,REASON_RULE)
	local token3=Duel.CreateToken(tp,24696097)
	Duel.SendtoDeck(token3,nil,SEQ_DECKTOP,REASON_RULE)
	local token4=Duel.CreateToken(tp,50091196)
	Duel.SendtoDeck(token4,nil,SEQ_DECKTOP,REASON_RULE)
end
