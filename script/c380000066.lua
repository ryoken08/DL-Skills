--Mind Scan
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
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--mind scan
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetCondition(s.con1)
	e1:SetOperation(s.op1)
	Duel.RegisterEffect(e1,tp)
	--flip back if LP<3000
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetCondition(s.con2)
	e2:SetOperation(s.op2)
	Duel.RegisterEffect(e2,tp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()>=3 and Duel.GetLP(tp)>=3000
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,id)==0 then
		Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
		Duel.RegisterFlagEffect(tp,id,0,0,0)
	end
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)
	if g and #g>0 then
		for tc in aux.Next(g) do
			if tc:GetFlagEffect(id)==0 then
				Duel.ConfirmCards(tp,tc)
				tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
			end
		end
	end
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<3000
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
	Duel.ResetFlagEffect(tp,id)
end
