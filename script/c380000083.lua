--Monstermorph: De-Evolution
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop,1)
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
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if not s[tp] then s[tp]=Duel.GetLP(tp) end
	if s[tp]>Duel.GetLP(tp) then
		s[2+tp]=s[2+tp]+(s[tp]-Duel.GetLP(tp))
		s[tp]=Duel.GetLP(tp)
	end
	if not s[1-tp] then s[1-tp]=Duel.GetLP(1-tp) end
	if s[1-tp]>Duel.GetLP(1-tp) then
		s[2+(1-tp)]=s[2+(1-tp)]+(s[1-tp]-Duel.GetLP(1-tp))
		s[1-tp]=Duel.GetLP(1-tp)
	end
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--condition
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil,ft,tp)
	and ft>-1
	and s[2+tp]>=1500
end
function s.filter(c,ft,tp)
	local lv=c:GetOriginalLevel()
	local rc=c:GetOriginalRace()
	local att=c:GetOriginalAttribute()
	return lv>0 and not c:IsType(TYPE_TOKEN) and (ft>0 or c:GetSequence()<5)
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,lv-1,rc,att)
end
function s.spfilter(c,lv,rc,att)
	return c:IsLevel(lv) and c:IsRace(rc) and c:IsAttribute(att) and c:IsSummonableCard()
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil,ft,tp)
	local g1=g:GetFirst()
	if g1 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
		e1:SetReset(RESET_CHAIN)
		g1:RegisterEffect(e1)
		g1:ResetEffect(RESETS_REDIRECT,RESET_EVENT)
		Duel.SendtoGrave(g1,REASON_RULE)
		Duel.BreakEffect()
	end
	local sg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK,0,nil,g1:GetLevel()-1,g1:GetRace(),g1:GetAttribute()):RandomSelect(tp,1)
	local tc=sg:GetFirst()
	if tc then
		Duel.MoveToDeckTop(tc)
		tc:ReverseInDeck()
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_FREE_CHAIN)
		e0:SetOperation(function () Duel.SetChainLimitTillChainEnd(aux.FALSE) end)
		tc:RegisterEffect(e0)
		Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,POS_FACEUP,true)
		e0:Reset()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e1:SetReset(RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		s[2+tp]=0
	end
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
