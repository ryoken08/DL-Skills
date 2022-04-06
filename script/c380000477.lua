--Occult Maniac
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
	e1:SetCondition(s.flipcon)
	e1:SetOperation(s.flipop)
	c:RegisterEffect(e1)
end
function s.filter(c)
	return c:IsRace(RACE_ZOMBIE) or c:IsRace(RACE_FIEND)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK,0,nil):GetClassCount(Card.GetCode)>=5
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
		Duel.Hint(HINT_CARD,tp,id)
		local p=c:GetControler()
		local dr=Duel.GetStartingHand(p)
		local g=Duel.GetDecktopGroup(tp,dr)
		local ct=g:FilterCount(s.filter,nil)
		local num=Duel.GetRandomNumber(1,10)
		if ct==0 and num<10 then
			local g1=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK,0,nil):RandomSelect(tp,1)
			local tc=g1:GetFirst()
			Duel.MoveToDeckTop(tc)
		end
		--cannot use monster effects
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(1,0)
		e1:SetValue(s.aclimit)
		e1:SetReset(RESET_PHASE+PHASE_MAIN1+RESET_SELF_TURN)
		Duel.RegisterEffect(e1,tp)
		--cannot Special Summon
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetReset(RESET_PHASE+PHASE_MAIN1+RESET_SELF_TURN)
		Duel.RegisterEffect(e2,tp)
	end
	e:SetLabel(1)
end
function s.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
