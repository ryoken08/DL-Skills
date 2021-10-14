--Fusionmorph: Red-Eyes
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
s.listed_names={CARD_REDEYES_B_DRAGON,11901678,90660762,21140872}
s.filter=aux.FilterFaceupFunction(Card.IsOriginalCodeRule,CARD_REDEYES_B_DRAGON)
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil)
	and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil)
end
function s.cfilter(c)
	return c:IsType(TYPE_NORMAL) and (c:IsLevel(6) and (c:IsRace(RACE_DRAGON) or c:IsRace(RACE_FIEND))) 
		or (c:IsLevel(4) and c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_EARTH))
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--send 1 monster to gy
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,1,1,nil)
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
	--transform 1 red-eyes
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local sg=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.HintSelection(sg)
	local tc=sg:GetFirst()
	if tc then
		local code=nil
		if g1:IsRace(RACE_FIEND) then
			code=11901678
		elseif g1:IsRace(RACE_DRAGON) then
			code=90660762
		elseif g1:IsRace(RACE_WARRIOR) then
			code=21140872
		end
		tc:Recreate(code,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true)
	end
end
