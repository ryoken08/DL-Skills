--Mark of the Dragon - Heart
local s,id=GetID()
function s.initial_effect(c)
	--skill
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetCountLimit(1)
	e1:SetRange(0x5f)
	e1:SetLabel(0)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.counterfilter)
	aux.GlobalCheck(s,function()
		s[0]=false
		s[1]=false
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
		aux.AddValuesReset(function()
			s[0]=false
			s[1]=false
		end)
	end)
end
s.listed_names={76865611,2403771,25165047}
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc:GetSummonType()==SUMMON_TYPE_SYNCHRO and tc:IsCode(2403771) then
		s[tc:GetSummonPlayer()]=true
	end
end
function s.counterfilter(c)
	local mt=c:GetMetatable()
	local ct=0
	if mt.synchro_tuner_required then ct=ct+mt.synchro_tuner_required end
	if mt.synchro_nt_required then ct=ct+mt.synchro_nt_required end
	return (c:IsType(TYPE_SYNCHRO) and ct>0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	for i=1,2 do
		local token=Duel.CreateToken(tp,76865611)
		Duel.SendtoDeck(token,nil,SEQ_DECKSHUFFLE,REASON_RULE)
	end
	Duel.BreakEffect()
	local token2=Duel.CreateToken(tp,2403771)
	Duel.SendtoDeck(token2,nil,SEQ_DECKTOP,REASON_RULE)
	local token3=Duel.CreateToken(tp,25165047)
	Duel.SendtoDeck(token3,nil,SEQ_DECKTOP,REASON_RULE)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp) and s[tp]
	and Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0
	and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND,0,1,nil,76865611)
	and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--play 1 "Morphtronic Lantron" from your hand in Defense Position
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local sg=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_HAND,0,1,1,nil,76865611)
	local tc=sg:GetFirst()
	if tc then
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_FREE_CHAIN)
		e0:SetOperation(function () Duel.SetChainLimitTillChainEnd(aux.FALSE) end)
		tc:RegisterEffect(e0)
		Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,POS_FACEUP_DEFENSE,true)
		e0:Reset()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e1:SetReset(RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
	--Cannot Normal or Special Summon monsters except Synchro Monsters that list a Synchro Monster as material
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH+EFFECT_FLAG_CLIENT_HINT)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetReset(RESET_PHASE+PHASE_END)
	e4:SetTargetRange(1,0)
	e4:SetTarget(s.sumlimit)
	Duel.RegisterEffect(e4,tp)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e5,tp)
end
function s.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	local mt=c:GetMetatable()
	local ct=0
	if mt.synchro_tuner_required then ct=ct+mt.synchro_tuner_required end
	if mt.synchro_nt_required then ct=ct+mt.synchro_nt_required end
	return not (c:IsType(TYPE_SYNCHRO) and ct>0)
end
