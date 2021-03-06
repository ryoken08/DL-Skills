--Prescience
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
	--prescience
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(s.op1)
	Duel.RegisterEffect(e1,tp)
	--flip back if turn <=5
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetCondition(s.con2)
	e2:SetOperation(s.op2)
	e2:SetLabelObject(e1)
	Duel.RegisterEffect(e2,tp)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(e:GetHandler():GetControler(),1)
	local g2=Duel.GetDecktopGroup(1-e:GetHandler():GetControler(),1)
	
	if #g>0 and g:GetFirst():GetFlagEffect(id)==0 then
		Duel.ConfirmCards(e:GetHandler():GetControler(),g)
		g:GetFirst():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
	end
	if #g2>0 and g2:GetFirst():GetFlagEffect(id)==0 then
		Duel.ConfirmCards(e:GetHandler():GetControler(),g2)
		g2:GetFirst():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
	end
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()>5
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
	local e1=e:GetLabelObject()
	e1:Reset()
	e:Reset()
end
