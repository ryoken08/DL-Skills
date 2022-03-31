--Cubic Dimension Summon
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop,1)
end
s.listed_series={0xe3}
function s.filter(c,ft,tp)
	local lv=c:GetOriginalLevel()
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xe3) and c:IsFaceup() and lv>0
	and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,nil,lv+1)
end
function s.spfilter(c,lv)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xe3) and c:IsLevel(lv)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--twice per duel check
	if Duel.GetFlagEffect(ep,id)>1 then return end
	--condition
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil,ft,tp)
	and ft>-1
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--flag register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	--send 1 cubic monster
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil,ft,tp)
	local g1=g:GetFirst()
	if g1 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_GRAVE)
		e1:SetReset(RESET_CHAIN)
		g1:RegisterEffect(e1)
		g1:ResetEffect(RESETS_REDIRECT,RESET_EVENT)
		Duel.SendtoGrave(g1,REASON_RULE)
		if g1:IsLocation(LOCATION_REMOVED) then
			Duel.SendtoGrave(g1,REASON_RULE)
		end
	end
	--play 1 cubic monster 1 level higher
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local sg=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,g1:GetLevel()+1)
	local tc=sg:GetFirst()
	local atk=tc:GetOriginalLevel()*500
	if tc then
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
		--atk becomes equal to original level*500
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_ATTACK_FINAL)
		e2:SetValue(atk)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
