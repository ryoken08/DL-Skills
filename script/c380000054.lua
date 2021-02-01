--Destiny Board
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,31829185)
	and Duel.GetLP(tp)<=2000
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	local c=e:GetHandler()
	--activate countdown
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(s.checkcon)
	e1:SetOperation(s.checkop)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,5)
	c:SetTurnCounter(0)
	Duel.RegisterEffect(e1,tp)
	--flip face-down
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetCondition(s.flipcon2)
	e2:SetOperation(s.flip)
	e2:SetLabelObject(e1)
	Duel.RegisterEffect(e2,tp)
end
function s.checkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,31829185) and tp==Duel.GetTurnPlayer()
end
s.message = { 
	CARD_DESTINY_BOARD, 31893528, 67287533, 94772232, 30170981
}
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_DESTINY_BOARD=0x15
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()+1
	c:SetTurnCounter(ct)
	for i=1,ct do
		code=s.message[i]
		Duel.Hint(HINT_CARD,0,code)
	end
	if ct==5 then
		Duel.Win(tp,WIN_REASON_DESTINY_BOARD)
	end
end
function s.flipcon2(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,31829185)
end
function s.flip(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
	local e1=e:GetLabelObject()
	e1:Reset()
	e:Reset()
end
