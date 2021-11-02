--Reverse of the Underworld and D.D.
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
s.listed_series={0xaf}
s.filter=aux.FilterFaceupFunction(Card.IsSetCard,0xaf)
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_GRAVE,0,nil,0xaf)
	local sg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_REMOVED,0,nil)
	return aux.CanActivateSkill(tp) and #g==#sg and #g>0
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--Banish all "D/D" monsters in your Graveyard
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_GRAVE,0,nil,0xaf)
	if #g>0 then
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_REMOVED)
			e1:SetReset(RESET_CHAIN)
			tc:RegisterEffect(e1)
			tc:ResetEffect(RESETS_REDIRECT,RESET_EVENT)
		end
		Duel.Remove(g,POS_FACEUP,REASON_RULE)
	end
	--Return all your banished "D/D" monsters to the Graveyard
	local sg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_REMOVED,0,g)
	Duel.SendtoGrave(sg,REASON_RULE+REASON_RETURN)
end
