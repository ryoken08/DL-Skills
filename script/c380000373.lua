--Gimmick Puppet - 4 or 8
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop,1)
end
s.listed_series={0x83}
function s.filter(c)
	return c:IsLevel(8) and c:IsSetCard(0x83)
end
function s.mzfilter(c)
	return c:HasLevel() and c:IsFaceup() and c:IsSetCard(0x83) and not c:IsLevel(8)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--twice per duel check
	if Duel.GetFlagEffect(ep,id)>1 then return end
	local b1=Duel.GetMatchingGroupCount(s.filter,tp,LOCATION_HAND,0,nil)>0
	local b2=Duel.GetMatchingGroupCount(s.mzfilter,tp,LOCATION_MZONE,0,nil)>0
	--condition
	return aux.CanActivateSkill(tp) and (b1 or b2)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--flag register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	local b1=Duel.GetMatchingGroupCount(s.filter,tp,LOCATION_HAND,0,nil)>0
	local b2=Duel.GetMatchingGroupCount(s.mzfilter,tp,LOCATION_MZONE,0,nil)>0
	local opt=0
	if b1 and b2 then
		opt=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	elseif b1 then
		opt=Duel.SelectOption(tp,aux.Stringid(id,1))
	elseif b2 then
		opt=Duel.SelectOption(tp,aux.Stringid(id,2))+1
	else return end
	if opt==0 then
		local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_HAND,0,nil)
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(4)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
	else
		local g=Duel.GetMatchingGroup(s.mzfilter,tp,LOCATION_MZONE,0,nil)
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(8)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
	end
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
