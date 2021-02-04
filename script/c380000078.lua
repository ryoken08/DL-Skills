--Three-Star Demotion
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
s.listed_names={25955164,62340868,98434877}
function s.filter(c)
	return c:IsCode(25955164,62340868,98434877)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(Card.IsLevelAbove,tp,LOCATION_HAND,0,1,nil,1)
	and (Duel.GetLP(tp)<=1000 or Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND,0,1,nil))
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	local g=nil
	if Duel.GetLP(tp)>1000 then
		g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_HAND,0,nil)
	else 
		g=Duel.GetFieldGroup(tp,LOCATION_HAND,0):Filter(Card.IsLevelAbove,nil,1)
	end
	if #g==0 then return end
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END)
		e1:SetValue(-3)
		tc:RegisterEffect(e1)
	end
end
