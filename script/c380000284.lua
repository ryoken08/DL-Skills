--Pathway to Chaos
local s,id=GetID()
function s.initial_effect(c)
	--skill
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
s.listed_names={5405694,54484652}
s.listed_series={0xa4,0xbd}
function s.tgfilter(c)
	return c:IsSetCard(0xa4) and c:IsType(TYPE_MONSTER)
end
function s.filter(c)
	return c:IsFaceup() and (c:IsOriginalSetCard(0xbd) or c:IsOriginalCodeRule(5405694))
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_HAND,0,1,nil)
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--send 1 kuriboh to the gy
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_HAND,0,1,1,nil)
	local g1=g:GetFirst()
	if g1 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
		e1:SetReset(RESET_CHAIN)
		g1:RegisterEffect(e1)
		Duel.SendtoGrave(g1,REASON_RULE)
	end
	--choose which monster to transform
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.HintSelection(sg)
	local tc=sg:GetFirst()
	if tc then
		local seq=tc:GetSequence()
		local pos=tc:GetPosition()
		local code=nil
		if tc:IsOriginalSetCard(0xbd) then
			code=5405694
		elseif tc:IsOriginalCodeRule(5405694) then
			code=54484652
		end
		Duel.SendtoDeck(tc,nil,-2,REASON_RULE)
		local token=Duel.CreateToken(tp,code)
		if token then
			--Move to field
			local e0=Effect.CreateEffect(e:GetHandler())
			e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e0:SetCode(EVENT_FREE_CHAIN)
			e0:SetOperation(function () Duel.SetChainLimitTillChainEnd(aux.FALSE) end)
			token:RegisterEffect(e0)
			Duel.MoveToField(token,tp,tp,LOCATION_MZONE,pos,true,(1<<seq))
			e0:Reset()
		end
	end
end
