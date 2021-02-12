--Trap Search
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
s.listed_names={CARD_JINZO}
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsOriginalCodeRule,CARD_JINZO),tp,LOCATION_MZONE,0,1,nil)
	and Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_SZONE,nil,TYPE_TRAP)>0
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_TRAP)
	if #g>0 then
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
			e1:SetReset(RESET_CHAIN)
			tc:RegisterEffect(e1)
			tc:ResetEffect(RESETS_REDIRECT,RESET_EVENT)
		end
		Duel.SendtoGrave(g,REASON_DESTROY)
	end
end
