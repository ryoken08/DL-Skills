--Moth to the Flame
local s,id=GetID()
function s.initial_effect(c)
	--skill
	aux.AddPreDrawSkillProcedure(c,1,false,s.flipcon,s.flipop)
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
s.listed_names={58192742,40240595,87756343,14141448,48579379}
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_EQUIP)
		e1:SetTarget(s.equiptarget)
		e1:SetOperation(s.equipop)
		Duel.RegisterEffect(e1,tp)
	end
	e:SetLabel(1)
end
function s.equiptarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	local g=tc:GetEquipTarget()
	if chk==0 then return tc:IsCode(40240595) and g:IsCode(58192742) and g:IsControler(tp) end
end
function s.equipop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local c=e:GetHandler()
	if tc then
		Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
		Duel.Hint(HINT_CARD,tp,id)
		--Add 1 additional turn during each end phase
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetRange(LOCATION_SZONE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCondition(s.checkcon)
		e1:SetOperation(s.checkop)
		e1:SetCountLimit(1)
		tc:RegisterEffect(e1)
		Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
	end
end
function s.checkcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetCardTarget()
	return Duel.GetTurnPlayer()==tp and g and g:IsExists(Card.IsCode,1,nil,58192742)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()+1
	c:SetTurnCounter(ct)
end
function s.filter(c)
	return c:IsCode(58192742) and c:GetEquipGroup():FilterCount(Card.IsCode,nil,40240595)>0
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--three times per duel check
	if Duel.GetFlagEffect(ep,id)>2 then return end
	--condition
	return Duel.GetCurrentChain()==0 and tp==Duel.GetTurnPlayer()
	and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
	and Duel.GetDrawCount(tp)>0
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil)
end
s.cards = {
	87756343, 14141448, 48579379
}
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--flag register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	local token=Duel.CreateToken(tp,s.cards[Duel.GetFlagEffect(ep,id)])
	Duel.DisableShuffleCheck()
	Duel.SendtoHand(token,nil,REASON_RULE)  
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
