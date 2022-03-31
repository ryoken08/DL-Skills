--Tuning
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
	e1:SetCondition(s.condition)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	aux.GlobalCheck(s,function()
		s[0]=nil
		s[1]=nil
		s[2]=0
		s[3]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end)
end
s.listed_names={9365703}
s.listed_series={0x43,0x1017}
function s.checkop()
	for tp=0,1 do
		if not s[tp] then s[tp]=Duel.GetLP(tp) end
		if s[tp]>Duel.GetLP(tp) then
			s[2+tp]=s[2+tp]+(s[tp]-Duel.GetLP(tp))
			s[tp]=Duel.GetLP(tp)
		end
	end
end
function s.exfilter(c)
	return c:IsSetCard(0x43) and c:IsType(TYPE_EFFECT)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return Duel.IsExistingMatchingCard(s.exfilter,tp,LOCATION_DECK,0,3,nil)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	--flag register
	Duel.RegisterFlagEffect(tp,id+1,0,0,0)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return Duel.GetCurrentChain()==0 and tp==Duel.GetTurnPlayer()
	and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
	and Duel.GetDrawCount(tp)>0
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil)
	and s[2+tp]>=1000
end
function s.filter(c)
	return c:IsSetCard(0x1017) and c:IsType(TYPE_TUNER)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	--ask if you want to activate the skill or not
	if not Duel.SelectYesNo(tp,aux.Stringid(id,0)) then return end
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--choose
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToDeckTop(tc)
		s[2+tp]=0
	end
	--send to gy top of deck
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_DRAW)
	e2:SetCondition(s.tgcon)
	e2:SetOperation(s.tgop)
	e2:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN,1)
	Duel.RegisterEffect(e2,tp)
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and r==REASON_RULE 
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ShuffleDeck(tp)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if tc then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_GRAVE)
		e1:SetReset(RESET_CHAIN)
		tc:RegisterEffect(e1)
		Duel.SendtoGrave(tc,REASON_RULE)
		if tc:IsLocation(LOCATION_REMOVED) then
			Duel.SendtoGrave(g,REASON_RULE)
		end
	end
	if Duel.GetFlagEffect(ep,id+1)==1 then
		local token=Duel.CreateToken(tp,9365703)
		Duel.SendtoGrave(token,REASON_RULE)
		if token:IsLocation(LOCATION_REMOVED) then
			Duel.SendtoGrave(token,REASON_RULE)
		end
	end
end

