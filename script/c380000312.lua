--Number Hunt
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
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_series={0x48}
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		--turn count
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_TURN_END)
		e1:SetCountLimit(1)
		e1:SetCondition(s.checkcon)
		e1:SetOperation(s.checkop)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,5)
		c:SetTurnCounter(0)
		Duel.RegisterEffect(e1,tp)
		--remove number and add it to your extra
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_FREE_CHAIN)
		e2:SetCondition(s.flipcon)
		e2:SetOperation(s.flipop)
		Duel.RegisterEffect(e2,tp)
	end
	e:SetLabel(1)
end
function s.checkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsTurnPlayer(tp)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()+1
	c:SetTurnCounter(ct)
end
function s.filter(c)
	return c:IsSetCard(0x48)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	local c=e:GetHandler()
	return aux.CanActivateSkill(tp)
	and c:GetTurnCounter()==3
	and Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity()
	and Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_EXTRA,1,nil)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--Remove 1 random Number
	local g=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_EXTRA,nil):RandomSelect(tp,1)
	local tc=g:GetFirst()
	if tc then
		local m=tc:GetMetatable(true)
		local no=m.xyz_number
		local code=tc:GetCode()
		local token=Duel.CreateToken(tp,code)
		Duel.SendtoDeck(tc,nil,-2,REASON_RULE)
		Duel.SendtoDeck(token,nil,SEQ_DECKTOP,REASON_RULE)
		Duel.ConfirmCards(1-tp,token)
		if no==0 then return end
		Duel.BreakEffect()
		local lp=Duel.GetLP(tp)-(no*30)
		Duel.SetLP(tp, lp)
	end
end
