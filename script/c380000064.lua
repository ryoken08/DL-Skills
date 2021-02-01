--Shadow Game
local s,id=GetID()
function s.initial_effect(c)
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
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(s.damcon)
	e1:SetOperation(s.damop)
	Duel.RegisterEffect(e1,tp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetTurnPlayer()
	return Duel.GetFieldGroupCount(p,LOCATION_GRAVE,0)~=0 and Duel.GetLP(p)>1000
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetTurnPlayer()
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	local val=Duel.GetFieldGroupCount(p,LOCATION_GRAVE,0)*100
	if val>400 then
		val=400
	end
	local lp=Duel.GetLP(p)-val
	Duel.SetLP(p,lp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
