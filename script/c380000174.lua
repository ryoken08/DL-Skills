--Hero Flash!!
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
	e1:SetCondition(s.condition)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_names={74825788,213326,37318031,63703130,191749}
s.listed_series={0x08}
function s.filter(c)
	return c:IsMonster() and c:IsType(TYPE_NORMAL) and c:IsSetCard(0x08)
end
function s.exfilter(c)
	return c:IsMonster() and not c:IsSetCard(0x08)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK,0,nil):GetClassCount(Card.GetCode)>=4
	   and not Duel.IsExistingMatchingCard(s.exfilter,tp,LOCATION_DECK,0,1,nil)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		--turn count
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PREDRAW)
		e1:SetCountLimit(1)
		e1:SetCondition(s.checkcon)
		e1:SetOperation(s.checkop)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,11)
		c:SetTurnCounter(0)
		Duel.RegisterEffect(e1,tp)
		--add to hand
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PREDRAW)
		e2:SetCountLimit(1)
		e2:SetCondition(s.flipcon)
		e2:SetOperation(s.flipop)
		Duel.RegisterEffect(e2,tp)
	end
	e:SetLabel(1)
end
function s.checkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()+1
	c:SetTurnCounter(ct)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--five times per duel check
	if Duel.GetFlagEffect(ep,id)>4 then return end
	--condition
	local c=e:GetHandler()
	local ct=math.floor(c:GetTurnCounter()%2)
	return Duel.GetCurrentChain()==0 and tp==Duel.GetTurnPlayer()
	and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
	and ct~=0
end
s.cards = {
	74825788, 213326, 37318031, 63703130, 191749
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
