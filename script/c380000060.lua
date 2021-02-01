--Fairy's Smile
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
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_DRAW)
	e1:SetCondition(s.condition)
	e1:SetOperation(s.activate)
	Duel.RegisterEffect(e1,tp)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and r==REASON_RULE and eg:IsExists(s.filter,1,nil) and Duel.GetCurrentPhase()==PHASE_DRAW
end
function s.filter(c)
	return c:IsRace(RACE_FAIRY) and not c:IsPublic()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	local g=eg:Filter(s.filter,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	local lp=Duel.GetLP(tp)+1000
	Duel.SetLP(tp,lp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
