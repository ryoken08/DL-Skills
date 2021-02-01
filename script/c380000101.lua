--Love is Pain
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
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_DAMAGE)
		e1:SetCondition(s.damcon)
		e1:SetOperation(s.damop)
		Duel.RegisterEffect(e1,tp)
	end
	e:SetLabel(1)
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and tp~=rp and (r&REASON_EFFECT)~=0 and Duel.GetLP(tp)<=2000
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,0,id)
	local lp=Duel.GetLP(1-tp)-ev
	Duel.SetLP(1-tp,lp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
