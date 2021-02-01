--Meet My Family!
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
	e1:SetOperation(s.flipop)
	c:RegisterEffect(e1)
end
s.cards = {
	79856792, 7093411, 95600067, 32710364, 21698716, 68215963, 69937550, 32933942
}
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	Duel.DisableShuffleCheck()
	for i=1,8 do
		local token=Duel.CreateToken(tp,s.cards[i])
		Duel.SendtoDeck(token,nil,SEQ_DECKTOP,REASON_RULE)
	end
	Duel.ShuffleDeck(tp)
end
