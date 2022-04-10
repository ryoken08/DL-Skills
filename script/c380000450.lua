--Meklord Astro Genesis
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
	aux.GlobalCheck(s,function()
		s[0]=0
		s[1]=0
		s[2]={}
		s[3]={}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end)
end
s.listed_names={68140974,31930787,4545683,63468625}
s.listed_series={0x13,0x3013}
function s.cfilter(c,tp)
	return c:IsSetCard(0x3013) and c:IsSummonPlayer(tp)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local g1=eg:Filter(s.cfilter,nil,tp)
	local g2=eg:Filter(s.cfilter,nil,1-tp)
	local tc1=g1:GetFirst()
	while tc1 do
		if s[tp]==0 then
			s[2+tp][1]=tc1:GetCode()
			s[tp]=s[tp]+1
		else
			local chk=true
			for i=1,s[tp]+1 do
				if s[2+tp][i]==tc1:GetCode() then
					chk=false
				end
			end
			if chk then
				s[2+tp][s[tp]+1]=tc1:GetCode()
				s[tp]=s[tp]+1
			end
		end
		tc1=g1:GetNext()
	end
	while tc2 do
		if s[1-tp]==0 then
			s[2+1-tp][1]=tc2:GetCode()
			s[1-tp]=s[1-tp]+1
		else
			local chk=true
			for i=1,s[1-tp]+1 do
				if s[2+1-tp][i]==tc2:GetCode() then
					chk=false
				end
			end
			if chk then
				s[2+1-tp][s[1-tp]+1]=tc2:GetCode()
				s[1-tp]=s[1-tp]+1
			end
		end
		tc2=g2:GetNext()
	end
end
function s.exfilter(c)
	return c:IsMonster() and not c:IsSetCard(0x13)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return Duel.IsExistingMatchingCard(Card.IsMonster,tp,LOCATION_DECK,0,1,nil)
		and not Duel.IsExistingMatchingCard(s.exfilter,tp,LOCATION_DECK,0,1,nil)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetCondition(s.flipcon)
		e1:SetOperation(s.flipop)
		Duel.RegisterEffect(e1,tp)
	end
	e:SetLabel(1)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp) and s[tp]>=3
	and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,68140974)
	and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,31930787)
	and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,4545683)
	and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,63468625)
	and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--Banish 1 "Meklord Emperor Wisel," 1 "Meklord Emperor Skiel," and 1 "Meklord Emperor Granel" from your GY
	local g1=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_GRAVE,0,nil,68140974)
	local g2=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_GRAVE,0,nil,31930787)
	local g3=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_GRAVE,0,nil,4545683)
	if #g1>0 and #g2>0 and #g3>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg2=g2:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg3=g3:Select(tp,1,1,nil)
		sg1:Merge(sg3)
		Duel.Remove(sg1,POS_FACEUP,REASON_RULE)
	end
	--play 1 "Meklord Astro Mekanikle" from your Deck or hand in Attack Position
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,63468625)
	if #sg>0 then
		local tc=sg:GetFirst()
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_FREE_CHAIN)
		e0:SetOperation(function () Duel.SetChainLimitTillChainEnd(aux.FALSE) end)
		tc:RegisterEffect(e0)
		Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,POS_FACEUP_ATTACK,true)
		e0:Reset()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e1:SetReset(RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
