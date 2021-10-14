--Pathway to Chaos
local s,id=GetID()
function s.initial_effect(c)
	--skill
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop,1)
end
s.listed_names={5405694,54484652}
s.listed_series={0xa4,0xbd}
function s.tgfilter(c)
	return c:IsSetCard(0xa4) and c:IsType(TYPE_MONSTER)
end
function s.filter(c,tp)
	local chk=(not c:IsType(TYPE_EFFECT))
	return c:IsFaceup() and (c:IsOriginalSetCard(0xbd) or c:IsOriginalCodeRule(5405694))
	and (chk or Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_HAND,0,1,nil))
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--twice per duel check
	if Duel.GetFlagEffect(ep,id)>1 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil,tp)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--choose which monster to transform
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.HintSelection(sg)
	local tc=sg:GetFirst()
	--if changing an Effect Monster
	if tc:IsType(TYPE_EFFECT) then
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
			g1:ResetEffect(RESETS_REDIRECT,RESET_EVENT)
			Duel.SendtoGrave(g1,REASON_RULE)
		end
	end
	--transform
	if tc then
		local code=nil
		if tc:IsOriginalSetCard(0xbd) then
			code=5405694
		elseif tc:IsOriginalCodeRule(5405694) then
			code=54484652
		end
		tc:Recreate(code,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true)
	end
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
